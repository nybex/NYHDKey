//
//  NYHDKey.m
//  NybexAuthenticator
//
//  Created by Judson Stephenson on 12/13/13.
//  Copyright (c) 2013 Nybex, Inc. All rights reserved.
//

#import "NYHDKey.h"

static NSString *kNYHDKeyServiceName = @"NYHDKeychain";

@implementation NYHDKey

/*
 * Initializers for different kinds of data:
 *   Extended keys, CBHDKeys, and Master seeds.
 */
+ (NYHDKey *) initWithWalletKey: (NSString*)key
{
    // Get a byte array from the string wallet key
    CBByteArray * walletKeyString = CBNewByteArrayFromString((char *)[key UTF8String], true);
    // Get the checksum bytes for this key string
    CBChecksumBytes * walletKeyData = CBNewChecksumBytesFromString(walletKeyString, false);
    CBReleaseObject(walletKeyString);

    // Create the HDKey
    CBHDKey * cbkey = CBNewHDKeyFromData(CBByteArrayGetData(CBGetByteArray(walletKeyData)));

    // Release what we don't need
    CBReleaseObject(walletKeyData);

    return [[self class] initWithCBHDKey: cbkey];
}

+ (NYHDKey *) initWithCBHDKey: (CBHDKey*)key
{
    // Create a new instance
    NYHDKey * instance = [[self class] new];

    // Set the cbhdkey instance
    instance.key = key;

    return instance;
}

+ (NYHDKey *) initWithMasterSeed: (NSString*)seed
{
    // Salt with string according to bip32
    NSString *salt = @"Bitcoin seed";
    // Turn the string into an NSData Object
    NSData *saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    // Turn our seed into an NSData array as well
    NSData *seedData = [seed dataUsingEncoding:NSUTF8StringEncoding];
    // Create a mutable data instance to hold our hmac value
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    // HMAC the salt + seed
    CCHmac(kCCHmacAlgSHA512, saltData.bytes, saltData.length,
           seedData.bytes, seedData.length, hash.mutableBytes);

    // Create an empty HD key
    CBHDKey * HDKey = CBNewHDKey(true);

    // Setup the master key
    HDKey->versionBytes = CB_HD_KEY_VERSION_PROD_PRIVATE;
    HDKey->childID.priv = false;
    HDKey->childID.childNumber = 0;
    HDKey->depth = 0;

    // Zero out the parent fingerprint since this is the master
    memset(HDKey->parentFingerprint, 0, 4);

    // Break the hash into two 32 byte parts, with the first part being the private key
    memcpy(HDKey->keyPair->privkey,
           [[NSData dataWithBytesNoCopy:(char *)[hash bytes] length: 32 freeWhenDone: NO] bytes],
           32);

    // And the second 32 bytes being the chain code
    memcpy(HDKey->chainCode,
           [[NSData dataWithBytesNoCopy:(char *)[hash bytes]+32 length: 32 freeWhenDone: NO] bytes],
           32);

    // Calculate the public key
    CBKeyGetPublicKey(HDKey->keyPair->privkey, HDKey->keyPair->pubkey.key);

    // Create a new instance
    return [[self class] initWithCBHDKey: HDKey];
}

/*
 * Find / Save / Delete key from keychain
 */

- (id) saveToKeychainWithName: (NSString *)name
{
#if __IPHONE_4_0 && TARGET_OS_IPHONE
    // Set the accessibility type we want
    [SSKeychain setAccessibilityType:kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly];
#endif

    SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
    query.service = kNYHDKeyServiceName;
    query.account = name;
    query.password = [self privateWalletKey];

    NSError *error = nil;
    if([query save:&error]){
        return @YES;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

+ (id) keyFromKeychainWithName: (NSString *)name
{
    NSError * error;
    NSString * walletKey = [SSKeychain passwordForService:kNYHDKeyServiceName account:name error: &error];
    if(walletKey == nil){
        NSLog(@"%@", error);
        return nil;
    } else {
        return [NYHDKey initWithWalletKey: walletKey];
    }
}

/*
 * Node finding and derivation functions
 */

- (NYHDKey *) nodeForPath:(NSString *)path
{
    [self _requireKey];

    NYHDKey * currentParent = self;

    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if([pathArray count] > 0){
        for(id str in pathArray){
            currentParent =
            [currentParent subkeyAtIndex: [NSNumber numberWithInteger:
                                    [([str hasSuffix:@"p"] || [str hasSuffix:@"`"]
                                        ? [str substringToIndex:[str length]-1]
                                        : str) integerValue]
                                  ] usingPrivateDerivation:
                                        ([str hasSuffix:@"p"] || [str hasSuffix:@"'"])];

        }
    } else {
        @throw([NSException
                exceptionWithName:@"InvalidPathException"
                reason:@"The path passed to nodeForPath was empty?"
                userInfo:nil]);
    }

    return currentParent;
}

- (NYHDKey *) subkeyAtIndex: (NSNumber *)index usingPrivateDerivation: (BOOL)is_private
{
    [self _requireKey];

    CBHDKey * keyCopy = self.key;
    CBHDKey * childKey = CBNewHDKey(true);

    // Derive the
    CBHDKeyDeriveChild(keyCopy, (CBHDKeyChildID){.priv = (int)is_private, .childNumber = [index intValue]}, childKey);

    return [[self class] initWithCBHDKey:childKey];
}

/*
 * Accessing node properties
 */
- (NSString *) privateWalletKey
{
    [self _requireKey];

    // Require a private copy
    if(CBHDKeyGetType(self.key->versionBytes) != CB_HD_KEY_TYPE_PRIVATE){
        @throw([NSException
                exceptionWithName:@"PrivateKeyException"
                reason:@"Cannot get a private copy from a public key"
                userInfo:nil]);
    }

    // Make a copy of the key
    CBHDKey * keyCopy = [self privateCopy].key;

    uint8_t * keyData = malloc(CB_HD_KEY_STR_SIZE);
    CBHDKeySerialise(keyCopy, keyData);

    CBChecksumBytes * checksumBytes = CBNewChecksumBytesFromBytes(keyData, CB_HD_KEY_STR_SIZE, false);
    CBByteArray * str = CBChecksumBytesGetString(checksumBytes);
    CBReleaseObject(checksumBytes);

    NSString *walletKey = [NSString stringWithUTF8String: (char *)CBByteArrayGetData(str)];

    CBReleaseObject(str);

    return walletKey;
}

- (NSString *) publicWalletKey
{
    [self _requireKey];

    // Make a copy of the key
    CBHDKey * keyCopy = [self publicCopy].key;

    uint8_t * keyData = malloc(CB_HD_KEY_STR_SIZE);
    CBHDKeySerialise(keyCopy, keyData);

    CBChecksumBytes * checksumBytes = CBNewChecksumBytesFromBytes(keyData, CB_HD_KEY_STR_SIZE, false);
    CBByteArray * str = CBChecksumBytesGetString(checksumBytes);
    CBReleaseObject(checksumBytes);

    NSString *walletKey = [NSString stringWithUTF8String: (char *)CBByteArrayGetData(str)];

    CBReleaseObject(str);

    return walletKey;
}

- (NSNumber *) index
{
    [self _requireKey];
    return [NSNumber numberWithInt: self.key->childID.childNumber];
}

- (CBPubKeyInfo) CBPubKey
{
    [self _requireKey];
    return self.key->keyPair->pubkey;
}

- (CBKeyPair *) CBKeypair
{
    [self _requireKey];
    return self.key->keyPair;
}
/*
 * Copies of nodes
 */
- (NYHDKey *) publicCopy;
{
    [self _requireKey];

    // Make a copy of the key
    CBHDKey * keyCopy = self.key;
    keyCopy->versionBytes = CB_HD_KEY_VERSION_PROD_PUBLIC;

    return [NYHDKey initWithCBHDKey:keyCopy];
}

- (NYHDKey *) privateCopy;
{
    [self _requireKey];

    // Make a copy of the key
    CBHDKey * keyCopy = self.key;
    keyCopy->versionBytes = CB_HD_KEY_VERSION_PROD_PRIVATE;
    return [NYHDKey initWithCBHDKey:keyCopy];
}

+ (void)setServiceName: (NSString*)val
{
    kNYHDKeyServiceName = val;
}

/*
 * Private utility functions
 */
- (void) _requireKey
{
    if(self.key == nil){
        @throw([NSException
                exceptionWithName:@"NoKeyException"
                reason:@"Please run -initWithWalletKey or -initWithMasterSeed"
                userInfo:nil]);
    }
}
@end
