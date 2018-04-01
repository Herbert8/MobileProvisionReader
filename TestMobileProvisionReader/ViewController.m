//
//  ViewController.m
//  TestMobileProvisionReader
//
//  Created by 巴宏斌 on 2017/12/19.
//  Copyright © 2017年 巴宏斌. All rights reserved.
//

#import "ViewController.h"
#import "FDTMobileProvisionReader.h"


@interface ViewController ()

@end

@implementation ViewController { 
    __weak IBOutlet UILabel *lblVal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    FDTMobileProvisionReader *reader = [[FDTMobileProvisionReader alloc] init];

    reader = [[FDTMobileProvisionReader alloc] initWithMobileProvisionAtPath:@"/Volumes/App/tmp/bydate/2017-12-19/MochaMobilePlatformDemoDevProfile.mobileprovision"];

    reader = [[FDTMobileProvisionReader alloc] init];

    if (reader) {

        NSLog(@"rder = %@", reader);

        NSLog(@"===========================================================");

        NSLog(@"AppIDName = %@", reader.AppIDName);
        NSLog(@"CreationDate = %@", reader.CreationDate);
//            NSLog(@"DeveloperCertificates = %@", reader.DeveloperCertificates);
        NSLog(@"ExpirationDate = %@", reader.ExpirationDate);
        NSLog(@"Name = %@", reader.Name);
//            NSLog(@"ProvisionedDevices = %@", reader.ProvisionedDevices);
        NSLog(@"TeamIdentifier = %@", reader.TeamIdentifier);
        NSLog(@"TeamName = %@", reader.TeamName);
        NSLog(@"TimeToLive = %ld", reader.TimeToLive);
        NSLog(@"UUID = %@", reader.UUID);
        NSLog(@"Version = %ld", reader.Version);
        NSLog(@"AppReleaseMode = %ld", reader.applicationReleaseMode);
        lblVal.text = [NSString stringWithFormat:@"AppReleaseMode = %ld", reader.applicationReleaseMode];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
