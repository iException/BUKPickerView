//
//  BUKPickerViewDefaultCellTableViewCell.h
//  Pods
//
//  Created by hyice on 15/8/7.
//
//

#import <UIKit/UIKit.h>

@interface BUKPickerViewDefaultCell : UITableViewCell

@property (strong, nonatomic) UIColor *normalStateBgColor;
@property (strong, nonatomic) UIColor *normalStateTextColor;
@property (strong, nonatomic) UIColor *selectedStateBgColor;
@property (strong, nonatomic) UIColor *selectedStateTextColor;

+ (CGFloat)suitableHeightForCellWithWidth:(CGFloat)width
                                     text:(NSString *)text
                                    image:(UIImage *)image
                            accessoryType:(UITableViewCellAccessoryType)accessoryType;

@end
