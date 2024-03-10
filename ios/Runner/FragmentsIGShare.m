//
//  IGShare.m
//  Runner
//
//  Created by Mahit Mehta on 3/9/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FragmentsIGShare.h"

@implementation FragmentsIGShare

- (void)shareBackgroundAndStickerImage:(UIImage *) sticker
{
  // Identify your App ID
  NSString *const appIDString = @"659072192949172";

  // Call method to share image and sticker
  [self backgroundImage:UIImagePNGRepresentation([UIImage imageNamed:@"IGShareBG"])
        stickerImage:UIImagePNGRepresentation(sticker)
        // backgroundTopColor: @"#9D6DF4"
        // backgroundBottomColor: @"#EDBE21"
        appID:appIDString];
}


// Method to share image and sticker
- (void)backgroundImage:(NSData *)backgroundImage
        stickerImage:(NSData *)stickerImage
        // backgroundTopColor: (NSString *)backgroundTopColor
        // backgroundBottomColor: (NSString *) backgroundBottomColor
        appID:(NSString *)appID
{
  NSURL *urlScheme = [NSURL URLWithString:[NSString stringWithFormat:@"instagram-stories://share?source_application=%@", appID]];


  if ([[UIApplication sharedApplication] canOpenURL:urlScheme])
  {
    // Attach the pasteboard items
    NSArray *pasteboardItems = @[@{@"com.instagram.sharedSticker.backgroundImage" : backgroundImage,
                                   @"com.instagram.sharedSticker.stickerImage" : stickerImage,
                                   //@"com.instagram.sharedSticker.backgroundTopColor": backgroundTopColor,
                                   //@"com.instagram.sharedSticker.backgroundBottomColor": backgroundBottomColor
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

@end
