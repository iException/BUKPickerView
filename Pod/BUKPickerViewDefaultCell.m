//
//  BUKPickerViewDefaultCellTableViewCell.m
//  Pods
//
//  Created by hyice on 15/8/7.
//
//

#import "BUKPickerViewDefaultCell.h"

static CGFloat const kBUKPickerViewDefaultCellContentHorizontalPadding = 9;
static CGFloat const kBUKPickerViewDefaultCellContentVerticalPadding = 6;
static CGFloat const kBUKPickerViewDefaultCellContentImageMaxSize = 32;
static CGFloat const kBUKPickerViewDefaultCellContentAccessoryWidth = 20;

@implementation BUKPickerViewDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.clipsToBounds = YES;
        
        self.normalStateBgColor = [UIColor whiteColor];
        self.selectedStateBgColor = [UIColor colorWithRed:0xf8/255.0 green:0xf8/255.0 blue:0xf8/255.0 alpha:1.0];
        self.normalStateTextColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        self.selectedStateTextColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        
        self.textLabel.font = [[self class] defaultFontSize];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self updateBackgroundColor];
        
        [self initBottomLine];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat xPadding = kBUKPickerViewDefaultCellContentHorizontalPadding;
    CGFloat yPadding = kBUKPickerViewDefaultCellContentVerticalPadding;

    if (self.imageView.image) {
        self.imageView.frame = [[self class] imageRectWithHeightLimit:CGRectGetHeight(self.contentView.bounds)];
    }

    CGFloat labelMaxX = CGRectGetWidth(self.bounds) - xPadding;
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        labelMaxX -= kBUKPickerViewDefaultCellContentAccessoryWidth;
    }

    CGFloat labelStartX = CGRectGetMaxX(self.imageView.frame) + xPadding;
    CGFloat labelWidth = labelMaxX - labelStartX;
    CGFloat labelHeight = CGRectGetHeight(self.contentView.bounds) - 2*yPadding;
    self.textLabel.frame = CGRectMake(labelStartX, yPadding, labelWidth, labelHeight);
}

#pragma mark - calculate size
+ (CGFloat)suitableHeightForCellWithWidth:(CGFloat)width text:(NSString *)text image:(UIImage *)image accessoryType:(UITableViewCellAccessoryType)accessoryType
{
    CGFloat labelMaxX = width - kBUKPickerViewDefaultCellContentHorizontalPadding;
    if (accessoryType != UITableViewCellAccessoryNone) {
        labelMaxX -= kBUKPickerViewDefaultCellContentAccessoryWidth;
    }

    CGFloat labelStartX = kBUKPickerViewDefaultCellContentHorizontalPadding;
    if (image) {
        labelStartX = kBUKPickerViewDefaultCellContentHorizontalPadding * 2 + kBUKPickerViewDefaultCellContentImageMaxSize;
    }
    CGFloat labelWidth = floor(labelMaxX - labelStartX);
    CGFloat labelHeight = [text boundingRectWithSize:CGSizeMake(labelWidth, NSIntegerMax)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [self defaultFontSize]}
                                             context:nil].size.height;

    CGFloat suitableHeight = MAX(labelHeight, kBUKPickerViewDefaultCellContentImageMaxSize);
    return ceil(suitableHeight + 2 * kBUKPickerViewDefaultCellContentVerticalPadding);
}

+ (CGRect)imageRectWithHeightLimit:(CGFloat)heightLimit
{
    CGFloat size = heightLimit - 2*kBUKPickerViewDefaultCellContentVerticalPadding;
    if (size > kBUKPickerViewDefaultCellContentImageMaxSize) {
        size = kBUKPickerViewDefaultCellContentImageMaxSize;
    }
    return CGRectMake(kBUKPickerViewDefaultCellContentHorizontalPadding,
                      kBUKPickerViewDefaultCellContentVerticalPadding,
                      size,
                      size);
}

+ (UIFont *)defaultFontSize
{
    return [UIFont systemFontOfSize:15];
}

#pragma mark - bottom line
- (void)initBottomLine
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1.0];
    [self addSubview:line];
    
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[line]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[line(0.5)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(line)]];
}

#pragma mark - colors
- (void)setNormalStateBgColor:(UIColor *)normalStateBgColor
{
    _normalStateBgColor = normalStateBgColor;
    [self updateBackgroundColor];
}

- (void)setSelectedStateBgColor:(UIColor *)selectedStateBgColor
{
    _selectedStateBgColor = selectedStateBgColor;
    [self updateBackgroundColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self updateBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self updateBackgroundColor];
}

- (void)updateBackgroundColor
{
    if (self.isSelected || self.isHighlighted) {
        self.backgroundColor = self.selectedStateBgColor;
        self.textLabel.textColor = self.selectedStateTextColor;
    }else {
        self.backgroundColor = self.normalStateBgColor;
        self.textLabel.textColor = self.normalStateTextColor;
    }
}

@end
