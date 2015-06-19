//
//  VKontakteActivity.m
//  VKActivity
//
//  Created by Denivip Group on 28.01.14.
//  Copyright (c) 2014 Denivip Group. All rights reserved.
//

#import "VKontakteActivity.h"

// abandoning
// Instead of this class
// and vk-ios-sdk  https://github.com/denivip/vk-ios-sdk
// using release vk-ios-sdk https://github.com/VKCOM/vk-ios-sdk.git
@interface VKontakteActivity ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation VKontakteActivity

#pragma mark - UIActivity

- (NSString *)activityType
{
    return @"VKActivityTypeVKontakte";
}

- (NSString *)activityTitle
{
    return @"VK";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed: @"vk"];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}
#endif

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    for (UIActivityItemProvider *item in activityItems) {
        if ([item isKindOfClass:[UIImage class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    for (id item in activityItems) {
        if([item isKindOfClass:[UIImage class]]) {
            self.image = item;
        }
    }
}

- (void)performActivity {
    [VKSdk initializeWithDelegate:self andAppId:@"4873922"];
    
    if ([VKSdk wakeUpSession])
    {
        [self postToWall];
    }
    else{
        [VKSdk authorize:@[VK_PER_WALL, VK_PER_PHOTOS]];
    }
}

#pragma mark - Upload

-(void)postToWall
{

    [self uploadPhoto];

}

- (void)uploadPhoto
{
    NSString *userId = [VKSdk getAccessToken].userId;
    
    //предварителная загрузка фото на сервер
    VKRequest *request = [VKApi uploadWallPhotoRequest:self.image parameters:[VKImageParameters jpegImageWithQuality:1.f] userId:[userId integerValue] groupId:0];
    [request executeWithResultBlock: ^(VKResponse *response) {
        VKPhoto *photoInfo = [(VKPhotoArray*)response.parsedModel objectAtIndex:0];
        NSString *photoAttachment = [NSString stringWithFormat:@"photo%@_%@", photoInfo.owner_id, photoInfo.id];
        [self postParameters:@{ VK_API_ATTACHMENTS : photoAttachment,
                            VK_API_FRIENDS_ONLY : @(0),
                            VK_API_OWNER_ID : userId,
                            VK_API_MESSAGE : @""}];
    } errorBlock: ^(NSError *error) {
        NSLog(@"Error: %@", error);
        [self activityDidFinish:NO];
    }];
}

-(void)postParameters:(NSDictionary *)params{
    VKRequest *post = [[VKApi wall] post:params];
    [post executeWithResultBlock: ^(VKResponse *response) {
        NSNumber * postId = response.json[@"post_id"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://vk.com/wall%@_%@", [VKSdk getAccessToken].userId, postId]]];
    } errorBlock: ^(NSError *error) {
        NSLog(@"Error: %@", error);
        [self activityDidFinish:NO];
    }];
}

#pragma mark VKSdkDelegate implementation

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    
}

@end
