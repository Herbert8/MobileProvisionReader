//
//  FDTMobileProvisionReader.h
//  TestMobileProvisionReader
//
//  Created by 巴宏斌 on 2017/12/19.
//  Copyright © 2017年 巴宏斌. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UIApplicationReleaseMode) {
    UIApplicationReleaseUnknown,
    UIApplicationReleaseSim,
    UIApplicationReleaseDev,
    UIApplicationReleaseAdHoc,
    UIApplicationReleaseAppStore,
    UIApplicationReleaseEnterprise
};


@interface FDTMobileProvisionReader : NSObject

@property (readonly) NSString *AppIDName;

@property (readonly) NSDate *CreationDate;

@property (readonly) NSArray *DeveloperCertificates;

@property (readonly) NSDate *ExpirationDate;

@property (readonly) NSString *Name;

@property (readonly) NSArray *ProvisionedDevices;

@property (readonly) NSArray *TeamIdentifier;

@property (readonly) NSString *TeamName;

@property (readonly) NSInteger TimeToLive;

@property (readonly) NSString *UUID;

@property (readonly) NSInteger Version;

@property (readonly) NSDictionary *mobileProvisionInformation;

@property (readonly) UIApplicationReleaseMode applicationReleaseMode;

- (instancetype)initWithMobileProvisionAtPath:(NSString *)path;

@end
