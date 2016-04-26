//
//  BUKPickerView.m
//  Pods
//
//  Created by hyice on 15/6/30.
//
//

#import "BUKPickerView.h"

@interface BUKPickerViewTableViewHolder : UIView

@property (nonatomic, strong) UITableView *buk_tableView;

- (void)showLeftLineWithColor:(UIColor *)lineColor;

@end

@implementation BUKPickerViewTableViewHolder {
    UIView *_leftLine;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self addSubview:self.buk_tableView];

        self.buk_tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_buk_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buk_tableView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_buk_tableView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_buk_tableView)]];
    }

    return self;
}

- (UITableView *)buk_tableView
{
    if (!_buk_tableView) {
        _buk_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _buk_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return _buk_tableView;
}

- (void)showLeftLineWithColor:(UIColor *)lineColor
{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        [self addSubview:_leftLine];

        _leftLine.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_leftLine(0.5)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftLine)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_leftLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_leftLine)]];
    }

    _leftLine.backgroundColor = lineColor;
}
@end




@interface BUKPickerView () <UITableViewDataSource, UITableViewDelegate, BUKDynamicPopViewDelegate>

@property (nonatomic, strong) NSMutableArray *buk_tableViewHolders;

@property (nonatomic, weak) NSLayoutConstraint *buk_firstTableViewTopConstraint;

@property (nonatomic, weak) id<BUKPickerViewDataSourceAndDelegate> buk_delegate;

@property (nonatomic, assign) BOOL needUpdateSubviewsHeight;
@property (nonatomic, assign) BOOL needUpdateSubviewsWidth;

@end

@implementation BUKPickerView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BUKPickerViewDataSourceAndDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserverForBounds];

        self.buk_delegate = delegate;
        self.backgroundColor = [UIColor whiteColor];

        while ([self push]) {
            [self push];
        }
    }

    return self;
}

- (void)dealloc
{
    [self removeObserverForBounds];
}

#pragma mark - public -
- (BOOL)push
{
    BUKPickerViewTableViewHolder *nextHolder = [self buk_pickerTableViewHolder];

    CGFloat depth = self.buk_tableViewHolders.count;

    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:numberOfRowsInSection:depth:pickerView:)]) {
        NSInteger count = [self.buk_delegate buk_tableView:nextHolder.buk_tableView numberOfRowsInSection:0 depth:depth pickerView:self];
        if (count == 0) {
            return NO;
        }
    }

    [self.buk_tableViewHolders addObject:nextHolder];

    [self buk_registerCellClassOrNibForTableView:nextHolder.buk_tableView depth:depth];

    if (depth == 0) {
        [self buk_addFirstTableViewHolder:nextHolder];
    } else {
        [self buk_addOtherTableViewHolder:nextHolder depth:depth];
    }

    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_pickerView:didFinishPushToDepth:)]) {
        [self.buk_delegate buk_pickerView:self didFinishPushToDepth:depth];
    }

    return YES;
}

- (BOOL)pop
{
    if (self.buk_tableViewHolders.count <= 1) {
        return NO;
    }

    BUKPickerViewTableViewHolder *lastHolder = [self.buk_tableViewHolders lastObject];
    [lastHolder buk_dynamicHide];
    [self.buk_tableViewHolders removeLastObject];

    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_pickerView:didFinishPopToDepth:)]) {
        [self.buk_delegate buk_pickerView:self didFinishPopToDepth:self.buk_tableViewHolders.count - 1];
    }

    return YES;
}

- (BOOL)popToDepth:(NSInteger)depth
{
    NSInteger currentDepth = self.buk_tableViewHolders.count - 1;

    if (currentDepth <= depth) {
        return NO;
    }

    BUKPickerViewTableViewHolder *holder = [self.buk_tableViewHolders objectAtIndex:depth + 1];
    [holder buk_dynamicHide];
    [self.buk_tableViewHolders removeObjectsInRange:NSMakeRange(depth + 1, currentDepth - depth)];

    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_pickerView:didFinishPopToDepth:)]) {
        [self.buk_delegate buk_pickerView:self didFinishPopToDepth:depth];
    }

    return YES;
}

- (UITableView *)tableViewAtDepth:(NSInteger)depth
{
    if (depth >= self.buk_tableViewHolders.count) {
        return nil;
    }

    BUKPickerViewTableViewHolder *holder = [self.buk_tableViewHolders objectAtIndex:depth];

    if (!holder || ![holder isKindOfClass:[BUKPickerViewTableViewHolder class]]) {
        return nil;
    }

    return holder.buk_tableView;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:numberOfRowsInSection:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView numberOfRowsInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:cellForRowAtIndexPath:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView cellForRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return [tableView dequeueReusableCellWithIdentifier:@"BUKPickerViewDefaultCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:didSelectRowAtIndexPath:depth:pickerView:)]) {
        [self.buk_delegate buk_tableView:tableView didSelectRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView] pickerView:self];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:didDeselectRowAtIndexPath:depth:pickerView:)]) {
        [self.buk_delegate buk_tableView:tableView didDeselectRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView] pickerView:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_numberOfSectionsInTableView:depth:pickerView:)]) {
        return [self.buk_delegate buk_numberOfSectionsInTableView:tableView depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:heightForRowAtIndexPath:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView heightForRowAtIndexPath:indexPath depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:heightForHeaderInSection:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView heightForHeaderInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:heightForFooterInSection:depth:pickerView:)]) {
        [self.buk_delegate buk_tableView:tableView heightForFooterInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return 0.01f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:titleForHeaderInSection:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView titleForHeaderInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:titleForFooterInSection:depth:pickerView:)]) {
        [self.buk_delegate buk_tableView:tableView titleForFooterInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:viewForHeaderInSection:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView viewForHeaderInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_tableView:viewForFooterInSection:depth:pickerView:)]) {
        return [self.buk_delegate buk_tableView:tableView viewForFooterInSection:section depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_sectionIndexTitlesForTableView:depth:pickerView:)]) {
        return [self.buk_delegate buk_sectionIndexTitlesForTableView:tableView depth:[self buk_depthForTableView:tableView] pickerView:self];
    }

    return nil;
}

#pragma mark - BUKDynamicPopViewDelegate
- (void)buk_dynamicPopViewWillShow:(UIView *)view
{
    self.needUpdateSubviewsWidth = NO;
    self.needUpdateSubviewsHeight = NO;
}

- (void)buk_dynamicPopViewDidShow:(UIView *)view
{
    if (self.needUpdateSubviewsHeight || self.needUpdateSubviewsWidth) {

        [self.buk_tableViewHolders enumerateObjectsUsingBlock:^(BUKPickerViewTableViewHolder *  _Nonnull holder, NSUInteger idx, BOOL * _Nonnull stop) {

            CGRect frame = holder.frame;
            if (self.needUpdateSubviewsHeight) {
                frame.size.height = self.bounds.size.height;
            } else if (self.needUpdateSubviewsWidth) {
                frame.size.width = self.bounds.size.width;
            }
            holder.frame = frame;
        }];

        self.needUpdateSubviewsWidth = NO;
        self.needUpdateSubviewsHeight = NO;
    }
}

#pragma mark - kvo bounds -
- (void)addObserverForBounds
{
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(bounds)) options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverForBounds
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(bounds))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"] && object == self) {
        CGRect newRect = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
        CGRect oldRect = [[change objectForKey:NSKeyValueChangeOldKey] CGRectValue];
        if (newRect.size.height == oldRect.size.height) {
            return;
        }

        [self.buk_tableViewHolders enumerateObjectsUsingBlock:^(BUKPickerViewTableViewHolder *  _Nonnull holder, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = holder.frame;
            if (frame.size.height == oldRect.size.height) {
                frame.size.height = newRect.size.height;
                self.needUpdateSubviewsHeight = YES;
            } else if (frame.size.width == oldRect.size.width) {
                frame.size.width = newRect.size.width;
                self.needUpdateSubviewsWidth = YES;
            }

            if (!holder.buk_popViewIsAnimating) {
                holder.frame = frame;
            }
        }];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private methods -
- (NSInteger)buk_depthForTableViewHolder:(BUKPickerViewTableViewHolder *)tableViewHolder
{
    return [self.buk_tableViewHolders indexOfObject:tableViewHolder];
}

- (NSInteger)buk_depthForTableView:(UITableView *)tableView
{
    __block NSInteger depth = NSNotFound;
    [self.buk_tableViewHolders enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BUKPickerViewTableViewHolder *holder, NSUInteger idx, BOOL *stop) {
        if (holder.buk_tableView == tableView) {
            depth = idx;
            *stop = YES;
        }
    }];

    return depth;
}

- (BUKPickerViewTableViewHolder *)buk_pickerTableViewHolder
{
    BUKPickerViewTableViewHolder *holder = [[BUKPickerViewTableViewHolder alloc] init];
    holder.buk_tableView.dataSource = self;
    holder.buk_tableView.delegate = self;

    return holder;
}

- (void)buk_addFirstTableViewHolder:(BUKPickerViewTableViewHolder *)first
{
    first.frame = self.bounds;
    [self addSubview:first];

    first.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[first]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(first)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:first attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    [self buk_updateFirstTableViewTopConstraint];
}

- (void)buk_addOtherTableViewHolder:(BUKPickerViewTableViewHolder *)nextHolder depth:(NSInteger)depth
{
    BUKPickerViewTableViewHolder *preHolder = [self.buk_tableViewHolders objectAtIndex:depth - 1];
    BUKPickerViewTableViewHolder *firstHolder = [self.buk_tableViewHolders firstObject];

    CGFloat coverRate = [self buk_coverRateForTableView:nextHolder.buk_tableView depth:depth];

    if (coverRate < 1.0) {
        [nextHolder showLeftLineWithColor:[UIColor colorWithRed:0xde/255.0 green:0xde/255.0 blue:0xde/255.0 alpha:1.0]];
    }

    CGRect frame = firstHolder.bounds;
    frame.size.width *= coverRate;
    nextHolder.frame = frame;

    nextHolder.buk_animationStyle = [self buk_animationStyleWithView:nextHolder];
    nextHolder.buk_dynamicBackground.hidden = YES;
    nextHolder.buk_dynamicPopViewDelegate = self;

    [nextHolder buk_dynamicShowInView:preHolder];
}

- (void)buk_registerCellClassOrNibForTableView:(UITableView *)tableView depth:(NSInteger)depth
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BUKPickerViewDefaultCell"];

    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_registerCellClassOrNibForTableView:depth:pickerView:)]) {
        [self.buk_delegate buk_registerCellClassOrNibForTableView:tableView depth:depth pickerView:self];
    }
}

- (CGFloat)buk_coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth
{
    if (self.buk_delegate && [self.buk_delegate respondsToSelector:@selector(buk_coverRateForTableView:depth:pickerView:)]) {
        return [self.buk_delegate buk_coverRateForTableView:tableView depth:depth pickerView:self];
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

- (void)buk_updateFirstTableViewTopConstraint
{
    if (self.buk_firstTableViewTopConstraint) {
        [self removeConstraint:self.buk_firstTableViewTopConstraint];
    }

    BUKPickerViewTableViewHolder *firstHolder = [self.buk_tableViewHolders firstObject];

    if (!firstHolder) {
        return;
    }

    self.buk_firstTableViewTopConstraint = [NSLayoutConstraint constraintWithItem:firstHolder
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.titleView? :self
                                                                        attribute:self.titleView? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:0];
    [self addConstraint:self.buk_firstTableViewTopConstraint];

}

#pragma mark - setter && getter -
- (NSMutableArray *)buk_tableViewHolders
{
    if (!_buk_tableViewHolders) {
        _buk_tableViewHolders = [[NSMutableArray alloc] init];
    }
    return _buk_tableViewHolders;
}

- (void)setTitleView:(UIView *)titleView
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(titleView))];
    [_titleView removeFromSuperview];
    _titleView = titleView;
    [self addSubview:_titleView];
    [self didChangeValueForKey:NSStringFromSelector(@selector(titleView))];

    if (_titleView) {
        CGFloat height = CGRectGetHeight(_titleView.frame);
        if (height <= 0) {
            height = 44.0;
        }
        _titleView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_titleView(height)]" options:0 metrics:@{@"height":@(height)} views:NSDictionaryOfVariableBindings(_titleView)]];
    }
    [self buk_updateFirstTableViewTopConstraint];
    
}
@end
