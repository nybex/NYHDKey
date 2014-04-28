#define EXP_SHORTHAND
#import "Specta.h"
#import "Expecta.h"
#import "NYHDKey.h"

SpecBegin(NYHDKey)

describe(@"NYHDKey", ^{
    // Test initializing HDKeys from Wallet Keys as well
    // as from master seeds, which are not part of cbitcoin yet
    describe(@"Initialization from seeds and keys", ^{
        it(@"Should init from master seed correctly", ^{
            expect([[NYHDKey initWithMasterSeed: @"SecretPassword"] privateWalletKey]).to.equal(@"xprv9s21ZrQH143K3N5WeKo91Cgrg9TAZc5TydidjnfkaYSSW1jd5fPd5YVzzWLi6zumJa8ohrFoX1uVhct29KjA8TbyJoKpf1jrMY9KDepbukD");
        });

        it(@"Should init with wallet key correctly", ^{
            expect([[NYHDKey initWithWalletKey:@"xprv9s21ZrQH143K3N5WeKo91Cgrg9TAZc5TydidjnfkaYSSW1jd5fPd5YVzzWLi6zumJa8ohrFoX1uVhct29KjA8TbyJoKpf1jrMY9KDepbukD"] privateWalletKey]).to.equal(@"xprv9s21ZrQH143K3N5WeKo91Cgrg9TAZc5TydidjnfkaYSSW1jd5fPd5YVzzWLi6zumJa8ohrFoX1uVhct29KjA8TbyJoKpf1jrMY9KDepbukD");
        });
    });

    // Go through the standard suite of bip32 test vectors
    // This is vector #1
    describe(@"Child Key Derivation Test #1", ^{
        it(@"Derive m/0'", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0'"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7");

            expect([k0p publicWalletKey]).to.equal(@"xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw");
        });

        it(@"Derive m/0'/1", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0'/1"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs");

            expect([k0p publicWalletKey]).to.equal(@"xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ");
        });

        it(@"Derive m/0'/1/2'", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0'/1/2'"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM");

            expect([k0p publicWalletKey]).to.equal(@"xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5");
        });

        it(@"Derive m/0'/1/2'/2", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey]
                             nodeForPath:@"0'/1/2'/2"];

            expect([k0p privateWalletKey]).to.equal(@"xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334");

            expect([k0p publicWalletKey]).to.equal(@"xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV");
        });

        it(@"Derive m/0'/1/2'/2/1000000000", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey]
                             nodeForPath:@"0'/1/2'/2/1000000000"];

            expect([k0p privateWalletKey]).to.equal(@"xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76");

            expect([k0p publicWalletKey]).to.equal(@"xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy");
        });
    });

    // Go through bip32 vector #2
    describe(@"Child Key Derivation Test #2", ^{
        it(@"Derive m/0", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9vHkqa6EV4sPZHYqZznhT2NPtPCjKuDKGY38FBWLvgaDx45zo9WQRUT3dKYnjwih2yJD9mkrocEZXo1ex8G81dwSM1fwqWpWkeS3v86pgKt");

            expect([k0p publicWalletKey]).to.equal(@"xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH");
        });

        it(@"Derive m/0/2147483647'", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0/2147483647'"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9wSp6B7kry3Vj9m1zSnLvN3xH8RdsPP1Mh7fAaR7aRLcQMKTR2vidYEeEg2mUCTAwCd6vnxVrcjfy2kRgVsFawNzmjuHc2YmYRmagcEPdU9");

            expect([k0p publicWalletKey]).to.equal(@"xpub6ASAVgeehLbnwdqV6UKMHVzgqAG8Gr6riv3Fxxpj8ksbH9ebxaEyBLZ85ySDhKiLDBrQSARLq1uNRts8RuJiHjaDMBU4Zn9h8LZNnBC5y4a");
        });

        it(@"Derive m/0/2147483647'/1", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0/2147483647'/1"];

            expect([k0p privateWalletKey]).to.equal(@"xprv9zFnWC6h2cLgpmSA46vutJzBcfJ8yaJGg8cX1e5StJh45BBciYTRXSd25UEPVuesF9yog62tGAQtHjXajPPdbRCHuWS6T8XA2ECKADdw4Ef");

            expect([k0p publicWalletKey]).to.equal(@"xpub6DF8uhdarytz3FWdA8TvFSvvAh8dP3283MY7p2V4SeE2wyWmG5mg5EwVvmdMVCQcoNJxGoWaU9DCWh89LojfZ537wTfunKau47EL2dhHKon");
        });

        it(@"Derive m/0/2147483647'/1/2147483646'", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0/2147483647'/1/2147483646'"];

            expect([k0p privateWalletKey]).to.equal(@"xprvA1RpRA33e1JQ7ifknakTFpgNXPmW2YvmhqLQYMmrj4xJXXWYpDPS3xz7iAxn8L39njGVyuoseXzU6rcxFLJ8HFsTjSyQbLYnMpCqE2VbFWc");

            expect([k0p publicWalletKey]).to.equal(@"xpub6ERApfZwUNrhLCkDtcHTcxd75RbzS1ed54G1LkBUHQVHQKqhMkhgbmJbZRkrgZw4koxb5JaHWkY4ALHY2grBGRjaDMzQLcgJvLJuZZvRcEL");
        });

        it(@"Derive m/0/2147483647'/1/2147483646'/2", ^{
            NSString * masterWalletKey = @"xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U";

            NYHDKey * k0p = [[NYHDKey initWithWalletKey: masterWalletKey] nodeForPath:@"0/2147483647'/1/2147483646'/2"];

            expect([k0p privateWalletKey]).to.equal(@"xprvA2nrNbFZABcdryreWet9Ea4LvTJcGsqrMzxHx98MMrotbir7yrKCEXw7nadnHM8Dq38EGfSh6dqA9QWTyefMLEcBYJUuekgW4BYPJcr9E7j");

            expect([k0p publicWalletKey]).to.equal(@"xpub6FnCn6nSzZAw5Tw7cgR9bi15UV96gLZhjDstkXXxvCLsUXBGXPdSnLFbdpq8p9HmGsApME5hQTZ3emM2rnY5agb9rXpVGyy3bdW6EEgAtqt");
        });
    });

    describe(@"Edge case?", ^{
        it(@"Should correctly parse", ^{
            NSString *k = @"xpub6Crfsj8RS7h8EJinfwhRMLkiNfc9iXnoxtLYAfYD2qD76n8oHrToP4yRjkgPxLrMZgVR96kdbEdFXa4jax9Yf1XfPJNVJEr4xDfDMvCiwJb";
            NYHDKey *k0 = [NYHDKey initWithWalletKey:k];
            expect([[k0 nodeForPath:@"0/0/0"] publicWalletKey]).to.equal(@"xpub6Jeh916xoMV7VTuUy3qHYtLm2sJrG1YUhQ1e2tB2zcAdsxdT1j5VW7snhXTe37F2Vu4jtATPAuTz5kVLzsMV9xvzz1TxbB2dw3VZChTqNdd");
        });
        it(@"Should parse this test case from Mark's phone", ^{
            NYHDKey *k = [NYHDKey initWithWalletKey:@"xpub661MyMwAqRbcEtf92soV58PT1QDLU35UdfDvspfgraAiQTtoDAaUzcdAZC9M6Xv5tfBRZWzz5fN9verK6ykSWK56mHS23xzuDsYRhU3CmUP"];
            [k publicWalletKey];
            expect([[k nodeForPath:@"0/0/0"] publicWalletKey]).to.equal(@"xpub6Bz3KSoSmhzoJrFdZBhXWV3aaE8NTQQf8SVUHkyrdYWpudmrqxkkDKiG8NYXLT3EnPLZfSTne8wwmHvdKpeLsfCf3DnDCVwiXqzawMQezou");
        });
    });

    // If you don't init the HDKey with the correct information beforehand
    // then we wil lthrow an exception that tells you to run an initWith method
    describe(@"Preventing user error", ^{
        it(@"Should raise exception for uninitalized class and private key", ^{
            expect(^{ [[NYHDKey new] privateWalletKey]; }).to.raiseAny();
        });

        it(@"Should raise exception for uninitalized class and public key", ^{
            expect(^{ [[NYHDKey new] publicWalletKey]; }).to.raiseAny();
        });

        it(@"Should raise exception for uninitalized class and public copy", ^{
            expect(^{ [[NYHDKey new] publicCopy]; }).to.raiseAny();
        });
    });

    // Saving the keys to the keychain
    describe(@"Keys & The Keychain", ^{
        it(@"Should save and fetch a key from the keychain", ^{
            NYHDKey * k = [NYHDKey initWithMasterSeed: @"SecretPassword"];
            expect([k saveToKeychainWithName:@"testKey"]).to.equal(@YES);

            NYHDKey * k1 = [NYHDKey keyFromKeychainWithName: @"testKey"];

            expect([k1 privateWalletKey]).to.equal([k privateWalletKey]);
        });
    });
});

SpecEnd