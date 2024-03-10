//
//  FragmentsIGShare.h
//  Runner
//
//  Created by Mahit Mehta on 3/9/24.
//

#ifndef FragmentsIGShare_h
#define FragmentsIGShare_h

@interface FragmentsIGShare : NSObject 

- (void) shareBackgroundAndStickerImage: (UIImage *) sticker;

- (void) backgroundImage: (NSData *)backgroundImage
            stickerImage: (NSData *)stickerImage
            // backgroundTopColor: (NSString *)backgroundTopColor
            // backgroundBottomColor: (NSString *)backgroundBottomColor
                   appID:(NSString *)appID;

@end

#endif /* FragmentsIGShare_h */
