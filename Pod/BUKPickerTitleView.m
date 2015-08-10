//
//  BUKPickerTitleView.m
//  Pods
//
//  Created by hyice on 15/8/6.
//
//

#import "BUKPickerTitleView.h"

@interface BUKPickerTitleView ()

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation BUKPickerTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        if (![[[self class] appearance] backgroundColor]) {
            self.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xf4/255.0 alpha:1.0];
        }
        
        _titleColor = [UIColor blackColor];
        _tintColor = [UIColor colorWithRed:0x6d/255.0 green:0xd0/255.0 blue:0x28/255.0 alpha:1.0];
        _bottomLineColor = [UIColor colorWithRed:0xdc/255.0 green:0xdb/255.0 blue:0xdd/255.0 alpha:1.0];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.bottomLine];
        
        [self layoutViews];
    }
    
    return self;
}

- (void)layoutViews
{
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    
    self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    self.rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    self.bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bottomLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_bottomLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomLine)]];
}

#pragma mark - events -
- (void)leftButtonPressed
{
    if (self.leftButtonAction) {
        self.leftButtonAction(self);
    }
}

- (void)rightButtonPressed
{
    if (self.rightButtonAction) {
        self.rightButtonAction(self);
    }
}

#pragma mark - setters && getters -
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [_leftButton setTitle:@"返回" forState:UIControlStateHighlighted];
        [_leftButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _leftButton.titleEdgeInsets = UIEdgeInsetsMake(5, 15, 0, 0);
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftButton;
}

- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [_rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:self.tintColor forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _rightButton.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 15);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [_rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _rightButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"请选择";
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = self.titleColor;
    }
    
    return _titleLabel;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = self.bottomLineColor;
    }
    
    return _bottomLine;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(titleColor))];
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
    [self didChangeValueForKey:NSStringFromSelector(@selector(titleColor))];
}

- (void)setTintColor:(UIColor *)tintColor
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(tintColor))];
    _tintColor = tintColor;
    [self.leftButton setTitleColor:tintColor forState:UIControlStateNormal];
    [self.rightButton setTitleColor:tintColor forState:UIControlStateNormal];
    [self didChangeValueForKey:NSStringFromSelector(@selector(tintColor))];
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(bottomLineColor))];
    _bottomLineColor = bottomLineColor;
    self.bottomLine.backgroundColor = bottomLineColor;
    [self didChangeValueForKey:NSStringFromSelector(@selector(bottomLineColor))];
}
@end
