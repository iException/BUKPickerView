//
//  BUKPickerViewDefaultCellTableViewCell.m
//  Pods
//
//  Created by hyice on 15/8/7.
//
//

#import "BUKPickerViewDefaultCell.h"

@implementation BUKPickerViewDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.normalStateBgColor = [UIColor whiteColor];
        self.selectedStateBgColor = [UIColor colorWithRed:0xf8/255.0 green:0xf8/255.0 blue:0xf8/255.0 alpha:1.0];
        self.normalStateTextColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        self.selectedStateTextColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self updateBackgroundColor];
        
        [self initBottomLine];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image) {
        CGFloat xPadding = 9;
        CGFloat yPadding = 6;
        
        CGFloat size = CGRectGetHeight(self.frame) - 2*yPadding;
        self.imageView.frame = CGRectMake(xPadding, yPadding, size, size);
        
        CGFloat labelStartX = 2*xPadding + size;
        self.textLabel.frame = CGRectMake(labelStartX, yPadding, CGRectGetWidth(self.frame) - labelStartX, size);
    }
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
