//
//  IGShare.m
//  Runner
//
//  Created by Mahit Mehta on 3/9/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FragmentsShare.h"

@implementation FragmentsShare
    // Identify your App ID
    NSString *const appIDString = @"659072192949172";

- (void)shareBackgroundAndStickerImageIG:(UIImage *) sticker
{
  // Call method to share image and sticker
  [self backgroundImageIG:UIImagePNGRepresentation([UIImage imageNamed:@"IGShareBG"])
        stickerImage:UIImagePNGRepresentation(sticker)
        appID:appIDString];
}


// Method to share image and sticker on Instagram
- (void)backgroundImageIG:(NSData *)backgroundImage
        stickerImage:(NSData *)stickerImage
        appID:(NSString *)appID
{
  NSURL *urlScheme = [NSURL URLWithString:[NSString stringWithFormat:@"instagram-stories://share?source_application=%@", appID]];


  if ([[UIApplication sharedApplication] canOpenURL:urlScheme])
  {
    // Attach the pasteboard items
    NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage,
                                   @"com.instagram.sharedSticker.stickerImage" : stickerImage
    }];

    // Set pasteboard options
    NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};

    // This call is iOS 10+, can use 'setItems' depending on what versions you support
    [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];

    [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
  }
  else
  {
      // Handle error cases
  }
}

- (void)shareBackgroundAndStickerImageFB: (UIImage *) sticker {
  [self backgroundImageFB:UIImagePNGRepresentation([UIImage imageNamed:@"IGShareBG"])
           stickerImage:UIImagePNGRepresentation(sticker)
                  appID:appIDString];
}

- (void)backgroundImageFB:(NSData *)backgroundImage
           stickerImage:(NSData *)stickerImage
                  appID:(NSString *)appID {

  // Verify app can open custom URL scheme. If able,
  // assign assets to pasteboard, open scheme.
  NSURL *urlScheme = [NSURL URLWithString:@"facebook-stories://share"];
  if ([[UIApplication sharedApplication] canOpenURL:urlScheme]) {

      // Assign background and sticker image assets to pasteboard
      NSArray *pasteboardItems = @[@{@"com.facebook.sharedSticker.backgroundImage" : backgroundImage,
                                     @"com.facebook.sharedSticker.stickerImage" : stickerImage,
                                     @"com.facebook.sharedSticker.appID" : appID}];
      NSDictionary *pasteboardOptions = @{UIPasteboardOptionExpirationDate : [[NSDate date] dateByAddingTimeInterval:60 * 5]};
      // This call is iOS 10+, can use 'setItems' depending on what versions you support
      [[UIPasteboard generalPasteboard] setItems:pasteboardItems options:pasteboardOptions];

      [[UIApplication sharedApplication] openURL:urlScheme options:@{} completionHandler:nil];
  } else {
      // Handle older app versions or app not installed case
  }
}


@end
