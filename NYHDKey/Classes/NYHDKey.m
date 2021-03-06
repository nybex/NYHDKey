//
//  NYHDKey.m
//  NybexAuthenticator
//
//  Created by Judson Stephenson on 12/13/13.
//  Copyright (c) 2013 Nybex, Inc. All rights reserved.
//

#import <CoreBitcoin/BTCKeychain.h>
#import <CoreBitcoin/BTCKey.h>

#import "NYHDKey.h"

@implementation NYHDKey

/*
 * Initializers for different kinds of data:
 *   Extended keys, BTCKeychains, and Master seeds.
 */
+ (NYHDKey *) initWithWalletKey:(NSString*)key
{
    return [[self class] initWithBTCKeychain: [[BTCKeychain alloc] initWithExtendedKey:key]];
}

+ (NYHDKey *) initWithMasterSeed:(NSString*)seed
{
    // Create a new instance
    return [[self class] initWithBTCKeychain: [[BTCKeychain alloc] initWithSeed:
                                                                    [seed dataUsingEncoding:NSUTF8StringEncoding]]];
}

+ (NYHDKey *) initWithBTCKeychain:(BTCKeychain*)key
{
    // Create a new instance
    NYHDKey * instance = [[self class] new];

    // Set the BTCKeychain instance
    instance.key = key;

    return instance;
}

/*
 * Node finding and derivation functions
 */

- (NYHDKey*)nodeForPath:(NSString *)path
{
    [self _requireKey];

    NYHDKey * currentParent = self;

    NSArray *pathArray = [path componentsSeparatedByString:@"/"];
    if([pathArray count] > 0){
        for(id str in pathArray){
            currentParent =
            [currentParent subkeyAtIndex: [NSNumber numberWithInteger:
                                    [([str hasSuffix:@"p"] || [str hasSuffix:@"'"]
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

- (NYHDKey*)subkeyAtIndex:(NSNumber *)index usingHardenedDerivation:(BOOL)is_hardened
{
    return [self subkeyAtIndex:index usingPrivateDerivation:is_hardened];
}

- (NYHDKey*)subkeyAtIndex:(NSNumber *)index usingPrivateDerivation:(BOOL)is_private
{
    [self _requireKey];
    return [[self class] initWithBTCKeychain:[self.key derivedKeychainAtIndex:index.unsignedIntValue
                                                                     hardened:is_private]];
}

/*
 * Accessing node properties
 */
- (NSString *) privateWalletKey
{
    [self _requireKey];

    return [self.key isPrivate] ? self.key.extendedPrivateKey : nil;
}

- (NSString *) publicWalletKey
{
    [self _requireKey];

    return self.key.extendedPublicKey;
}

- (NSNumber *) index
{
    [self _requireKey];
    return [NSNumber numberWithInt: self.key.index];
}

/*
 * Copies of nodes
 */
- (NYHDKey *) publicCopy;
{
    [self _requireKey];
    return [NYHDKey initWithBTCKeychain:self.key.publicKeychain];
}

/*
 * Signatures
 */
- (NSData*) signMessage:(NSString*)message {
    return [self.key.key signatureForMessage:message];
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
