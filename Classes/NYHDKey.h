//
//  NYHDKey.h
//  NybexAuthenticator
//
//  Created by Judson Stephenson on 12/13/13.
//  Copyright (c) 2013 Nybex, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import "SSKeychain.h"
#import "CBHDKeys.h"
#import "CBAddress.h"

@interface NYHDKey : NSObject

// The
@property(assign) CBHDKey *key;

// init new nodes with keys
+ (NYHDKey *) initWithWalletKey: (NSString *)key;
+ (NYHDKey *) initWithMasterSeed: (NSString*)seed;
+ (NYHDKey *) initWithCBHDKey: (CBHDKey*)key;

// search for node
- (NYHDKey *) nodeForPath: (NSString *)path;
- (NYHDKey *) subkeyAtIndex: (NSNumber *)index usingPrivateDerivation: (BOOL)is_private;

// get node properties
- (NYHDKey *) publicCopy;
- (NSString *) privateWalletKey;
- (NSString *) publicWalletKey;
- (CBPubKeyInfo) CBPubKey;
- (CBKeyPair *) CBKeypair;
- (NSNumber *) index;

// Keychain Methods
- (id) saveToKeychainWithName: (NSString *)name;
+ (id) keyFromKeychainWithName: (NSString *)name;

// Set static vars
+ (void)setServiceName: (NSString*)val;

@end
