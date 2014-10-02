//
//  NYHDKey.h
//  NybexAuthenticator
//
//  Created by Judson Stephenson on 12/13/13.
//  Copyright (c) 2013 Nybex, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BTCKeychain;

@interface NYHDKey : NSObject

// The Key
@property(nonatomic, strong) BTCKeychain *key;

// init new nodes with keys
+ (instancetype) initWithWalletKey:(NSString *)key;
+ (instancetype) initWithMasterSeed:(NSString*)seed;
+ (instancetype) initWithBTCKeychain:(BTCKeychain*)key;

// search for node
- (instancetype) nodeForPath:(NSString*)path;
- (instancetype) subkeyAtIndex:(NSNumber*)index usingPrivateDerivation:(BOOL)is_private;

// get node properties
- (instancetype) publicCopy;
- (NSString*) privateWalletKey;
- (NSString*) publicWalletKey;
- (NSNumber*) index;

// Set static vars
+ (void) setServiceName:(NSString*)val;

@end
