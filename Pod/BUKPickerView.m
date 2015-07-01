//
//  BUKPickerView.m
//  Pods
//
//  Created by hyice on 15/6/30.
//
//

#import "BUKPickerView.h"
#import <BUKDynamicPopView.h>

@interface BUKPickerView () <UITableViewDataSource, UITableViewDelegate, BUKDynamicPopViewDelegate>

@property (nonatomic, strong) NSMutableArray *buk_tableViews;

@property (nonatomic, weak) NSLayoutConstraint *buk_firstTableViewTopConstraint;

@end

@implementation BUKPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buk_addFirstTableView];
    }
    return self;
}

- (void)push
{
    UITableView *pre = [self.buk_tableViews lastObject];
    
    UITableView *next = [self buk_pickerTableView];
    [self.buk_tableViews addObject:next];
    
    CGFloat depth = [self buk_depthForTableView:next];
    
    [self buk_registerCellClassOrNibForTableView:next depth:depth];
    
    CGFloat coverRate = [self buk_coverRateForTableView:next depth:depth];
    
    CGRect frame = pre.bounds;
    frame.size.width *= coverRate;
    next.frame = frame;
    
    next.buk_animationStyle = [self buk_animationStyleWithView:next];
    next.buk_dynamicBackground.backgroundColor = [UIColor clearColor];
    next.buk_dynamicPopViewDelegate = self;
    
    [next buk_dynamicShowInView:pre];
}

- (BOOL)pop
{
    if (self.buk_tableViews.count <= 1) {
        return NO;
    }
    
    UITableView *last = [self.buk_tableViews lastObject];
    [last buk_dynamicHide];
    [self.buk_tableViews removeLastObject];

    return YES;
}

#pragma mark - BUKDynamicPopViewDelegate -
- (void)buk_dynamicPopViewBackgroundTapped:(UIView *)view
{
    NSInteger index = [self.buk_tableViews indexOfObject:view];
    [self.buk_tableViews removeObjectsInRange:NSMakeRange(index, self.buk_tableViews.count - index)];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:depth:)]) {
        return [self.delegate tableView:tableView numberOfRowsInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:depth:)]) {
        return [self.delegate tableView:tableView cellForRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView]];
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"BUKPickerViewDefaultCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:depth:)]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:depth:)]) {
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfSectionsInTableView:depth:)]) {
        return [self.delegate numberOfSectionsInTableView:tableView depth:[self buk_depthForTableView:tableView]];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:depth:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView]];
    }
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:depth:)]) {
        return [self.delegate tableView:tableView heightForHeaderInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:depth:)]) {
        [self.delegate tableView:tableView heightForFooterInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return 0.01f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:depth:)]) {
        return [self.delegate tableView:tableView titleForHeaderInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:titleForFooterInSection:depth:)]) {
        [self.delegate tableView:tableView titleForFooterInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:depth:)]) {
        return [self.delegate tableView:tableView viewForHeaderInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:depth:)]) {
        return [self.delegate tableView:tableView viewForFooterInSection:section depth:[self buk_depthForTableView:tableView]];
    }
    
    return nil;
}

#pragma mark - private methods - 
- (NSInteger)buk_depthForTableView:(UITableView *)tableView
{
    return [self.buk_tableViews indexOfObject:tableView];
}

- (UITableView *)buk_pickerTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    return tableView;
}

- (void)buk_addFirstTableView
{
    UITableView *first = [self buk_pickerTableView];
    [self addSubview:first];
    [self.buk_tableViews addObject:first];
    
    first.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[first]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(first)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:first attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    self.buk_firstTableViewTopConstraint = [NSLayoutConstraint constraintWithItem:first attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleView? :self attribute:self.titleView? NSLayoutAttributeBottom : NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:self.buk_firstTableViewTopConstraint];
}

- (void)buk_registerCellClassOrNibForTableView:(UITableView *)tableView depth:(NSInteger)depth
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BUKPickerViewDefaultCell"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerCellClassOrNibForTableView:depth:)]) {
        [self.delegate registerCellClassOrNibForTableView:tableView depth:depth];
    }
}

- (CGFloat)buk_coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(coverRateForTableView:depth:)]) {
        return [self.delegate coverRateForTableView:tableView depth:depth];
    }
    
    return 1.0f;
}

- (BUKXOrYMoveAnimationStyle *)buk_animationStyleWithView:(UIView *)view
{
    BUKXOrYMoveAnimationStyle *style = [[BUKXOrYMoveAnimationStyle alloc] initWithView:view];
    style.startPosition = BUKRightOuterBorder;
    style.showPosition = BUKRightInnerBorder;
    style.endPosition = BUKRightOuterBorder;
    
    return style;
}

#pragma mark - setter && getter -
- (NSMutableArray *)buk_tableViews
{
    if (!_buk_tableViews) {
        _buk_tableViews = [[NSMutableArray alloc] init];
    }
    return _buk_tableViews;
}
@end
