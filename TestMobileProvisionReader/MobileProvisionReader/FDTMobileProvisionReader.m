//
//  FDTMobileProvisionReader.m
//  TestMobileProvisionReader
//
//  Created by 巴宏斌 on 2017/12/19.
//  Copyright © 2017年 巴宏斌. All rights reserved.
//

#import "FDTMobileProvisionReader.h"

@implementation FDTMobileProvisionReader {
    NSString *extractedMobileProvisionStr;
    NSDictionary *extractedMobileProvisionDict;
}

/** embedded.mobileprovision plist format:

 AppIDName, // string — TextDetective
 ApplicationIdentifierPrefix[],  // [ string - 66PK3K3KEV ]
 CreationData, // date — 2013-01-17T14:18:05Z
 DeveloperCertificates[], // [ data ]
 Entitlements {
 application-identifier // string - 66PK3K3KEV.com.blindsight.textdetective
 get-task-allow // true or false
 keychain-access-groups[] // [ string - 66PK3K3KEV.* ]
 },
 ExpirationDate, // date — 2014-01-17T14:18:05Z
 Name, // string — Barrierefreikommunizieren (name assigned to the provisioning profile used)
 ProvisionedDevices[], // [ string.... ]
 TeamIdentifier[], // [string — HHBT96X2EX ]
 TeamName, // string — The Blindsight Corporation
 TimeToLive, // integer - 365
 UUID, // string — 79F37E8E-CC8D-4819-8C13-A678479211CE
 Version, // integer — 1
 ProvisionsAllDevices // true or false  ***NB: not sure if this is where this is

 */

- (instancetype)initWithMobileProvisionAtPath:(NSString *)path {
    if (self = [super init]) {

        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if ([fileMgr fileExistsAtPath:path]) {
            NSData *allMobileProvisionData = [NSData dataWithContentsOfFile:path];
            NSData *extractedMobileProvisionData = [self extractDataFromMobileProvisionData:allMobileProvisionData];

            extractedMobileProvisionStr = [[NSString alloc] initWithData:extractedMobileProvisionData
                                                                encoding:NSUTF8StringEncoding];

            NSError *err = nil;
            extractedMobileProvisionDict = [NSPropertyListSerialization propertyListWithData:extractedMobileProvisionData
                                                                            options:NSPropertyListImmutable
                                                                             format:nil
                                                                              error:&err];
            if (err) {
                extractedMobileProvisionDict = nil;
                self = nil;
            }

        } else {
            self = nil;
        }
    }
    return self;
}

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"embedded"
                                                     ofType:@"mobileprovision"];
    if (self = [self initWithMobileProvisionAtPath:path]) {
        //
    }
    return self;
}

- (NSData *)extractDataFromMobileProvisionData:(NSData *)mobileProvisionData {
    NSString *sStart = @"<?xml";
    NSString *sEnd = @"</plist>";

    NSData *startData = [sStart dataUsingEncoding:NSUTF8StringEncoding];
    NSData *endData = [sEnd dataUsingEncoding:NSUTF8StringEncoding];


    NSRange startRange = [mobileProvisionData rangeOfData:startData
                                                  options:0
                                                    range:(NSRange){0, mobileProvisionData.length}];
    NSRange endRange = [mobileProvisionData rangeOfData:endData
                                                options:0
                                                  range:(NSRange){0, mobileProvisionData.length}];

    NSRange dataRange;
    dataRange.location = startRange.location;
    dataRange.length = endRange.location + endRange.length - startRange.location;

    NSData *retData = [mobileProvisionData subdataWithRange:dataRange];
    return retData;
}


- (NSDate *)dateFromUTCDateString:(NSString *)UTCDateStr {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";

    return [fmt dateFromString:UTCDateStr];
}


- (NSString *)AppIDName {
    return extractedMobileProvisionDict[@"AppIDName"];
}

- (NSDate *)CreationDate {
    return extractedMobileProvisionDict[@"CreationDate"];
}

- (NSArray *)DeveloperCertificates {
    return extractedMobileProvisionDict[@"DeveloperCertificates"];
}

- (NSDate *)ExpirationDate {
    return extractedMobileProvisionDict[@"ExpirationDate"];
}

- (NSString *)Name {
    return extractedMobileProvisionDict[@"Name"];
}

- (NSArray *)ProvisionedDevices {
    return extractedMobileProvisionDict[@"ProvisionedDevices"];
}

- (NSArray *)TeamIdentifier {
    return extractedMobileProvisionDict[@"TeamIdentifier"];
}

- (NSString *)TeamName {
    return extractedMobileProvisionDict[@"TeamName"];
}

- (NSInteger)TimeToLive {
    NSNumber *number = extractedMobileProvisionDict[@"TimeToLive"];
    return number.integerValue;
}

- (NSString *)UUID {
    return extractedMobileProvisionDict[@"UUID"];
}

- (NSInteger)Version {
    NSNumber *number = extractedMobileProvisionDict[@"Version"];
    return number.integerValue;
}

- (UIApplicationReleaseMode)applicationReleaseMode {

    UIApplicationReleaseMode retAppReleaseMode = UIApplicationReleaseUnknown;

    if (!extractedMobileProvisionDict) {
        // failure to read other than it simply not existing
        retAppReleaseMode = UIApplicationReleaseUnknown;
    } else if (!extractedMobileProvisionDict.count) {
#if TARGET_IPHONE_SIMULATOR
        retAppReleaseMode = UIApplicationReleaseSim;
#else
        retAppReleaseMode = UIApplicationReleaseAppStore;
#endif
    } else if ([extractedMobileProvisionDict[@"ProvisionsAllDevices"] boolValue]) {
        // enterprise distribution contains ProvisionsAllDevices - true
        retAppReleaseMode = UIApplicationReleaseEnterprise;
    } else if (self.ProvisionedDevices.count > 0) {
        // development contains UDIDs and get-task-allow is true
        // ad hoc contains UDIDs and get-task-allow is false
        NSDictionary *entitlements = extractedMobileProvisionDict[@"Entitlements"];
        if ([entitlements[@"get-task-allow"] boolValue]) {
            retAppReleaseMode = UIApplicationReleaseDev;
        } else {
            retAppReleaseMode = UIApplicationReleaseAdHoc;
        }
    } else {
        // app store contains no UDIDs (if the file exists at all?)
        retAppReleaseMode = UIApplicationReleaseAppStore;
    }
    return retAppReleaseMode;
}


- (NSString *)description {
    return extractedMobileProvisionStr;
}

- (NSDictionary *)mobileProvisionInformation {
    return [extractedMobileProvisionDict copy];
}

@end
