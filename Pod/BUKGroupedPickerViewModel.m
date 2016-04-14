//
//  BUKGroupedPickerViewModel.m
//  Pods
//
//  Created by 李翔 on 4/14/16.
//
//

#import "BUKGroupedPickerViewModel.h"
#import "BUKPickerViewModel.h"
#import "BUKPickerTitleView.h"
#import "BUKPickerViewDefaultCell.h"

@interface BUKGroupedPickerViewModel ()

@property (nonatomic, strong) NSMutableArray *buk_sectionsStack;
@property (nonatomic, copy) void (^buk_completeBlock)(id result);
@property (nonatomic, copy) void (^buk_lazyLoadBlock)(BUKFinishLoadPickerViewItemsBlock finishLoad);
@property (nonatomic, strong) BUKPickerTitleView *titleView;
@property (nonatomic, weak) BUKPickerView *buk_pickerView;
@property (nonatomic, strong) NSMutableArray *buk_selectionResult;

@property (nonatomic, assign) BOOL buk_userInteracted;

@end

@implementation BUKGroupedPickerViewModel

- (instancetype)initWithPickerViewSections:(NSArray<BUKPickerViewSection *> *)sections complete:(void (^)(id))complete
{
    self = [super init];
    
    if (self) {
        [self buk_setupDefaultViewStyle];
        
        self.buk_completeBlock = complete;
        [self buk_addRootSections:sections];
    }
    
    return self;
}

- (instancetype)initWithLazyPickerViewSections:(void (^)(BUKFinishLoadPickerViewItemsBlock))lazyLoad complete:(void (^)(id))complete
{
    self = [super init];
    
    if (self) {
        
        [self buk_setupDefaultViewStyle];
        
        self.buk_completeBlock = complete;
        self.buk_lazyLoadBlock = lazyLoad;
    }
    
    return self;
}

- (void)buk_setupDefaultViewStyle
{
    _needTitleView = YES;
    
    _oddLevelCellNormalTextColor = [UIColor colorWithRed:0x66/255.0 green:0x66/255.0 blue:0x66/255.0 alpha:1.0];
    _oddLevelCellNormalBgColor = [UIColor whiteColor];
    _oddLevelCellHighlightTextColor = [UIColor orangeColor];
    _oddLevelCellHighlightBgColor = [UIColor colorWithRed:0xf8/255.0 green:0xf8/255.0 blue:0xf8/255.0 alpha:1.0];
    
    _evenLevelCellNormalTextColor = _oddLevelCellNormalTextColor;
    _evenLevelCellNormalBgColor = _oddLevelCellHighlightBgColor;
    _evenLevelCellHighlightTextColor = _oddLevelCellHighlightTextColor;
    _evenLevelCellHighlightBgColor = _oddLevelCellNormalBgColor;
}

- (void)buk_addRootSections:(NSArray<BUKPickerViewSection *> *)sections
{
    if (!sections || ![sections isKindOfClass:[NSArray class]]) {
        return;
    }
    
    self.buk_sectionsStack = nil;
    [self.buk_sectionsStack addObject:sections];
    
    [self buk_loadDefaultSelectionsFromSections:sections];
    
    _coverRates = [self buk_defaultCoverRateForSections:sections];
}

#pragma mark - BUKPickerViewDataSourceAndDelegate
- (NSInteger)buk_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    self.buk_pickerView = pickerView;
    if (self.needTitleView && pickerView.titleView != self.titleView) {
        pickerView.titleView = self.titleView;
    }
    
    return [self buk_sectionsStackAtDepth:depth].count;
}

- (UITableViewCell *)buk_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    BUKPickerViewDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BUKPickerViewDefaultCell class]) forIndexPath:indexPath];
    
    if (depth % 2 == 0) {
        cell.normalStateTextColor = self.oddLevelCellNormalTextColor;
        cell.normalStateBgColor = self.oddLevelCellNormalBgColor;
        cell.selectedStateTextColor = self.oddLevelCellHighlightTextColor;
        cell.selectedStateBgColor = self.oddLevelCellHighlightBgColor;
    } else {
        cell.normalStateTextColor = self.evenLevelCellNormalTextColor;
        cell.normalStateBgColor = self.evenLevelCellNormalBgColor;
        cell.selectedStateTextColor = self.evenLevelCellHighlightTextColor;
        cell.selectedStateBgColor = self.evenLevelCellHighlightBgColor;
    }
    
    BUKPickerViewItem *item = [self buk_itemAtIndexPath:indexPath depth:depth];
    [self buk_setupCell:cell withPickViewItem:item];
    
    return cell;
}

- (CGFloat)buk_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    if (self.enableMultiLineTitleForCell) {
        BUKPickerViewItem *item = [self buk_itemAtIndexPath:indexPath depth:depth];
        CGFloat coverRate = [self buk_coverRateForTableView:tableView depth:depth pickerView:pickerView];
        CGFloat width = CGRectGetWidth(pickerView.bounds) * coverRate;
        CGFloat height = [BUKPickerViewDefaultCell suitableHeightForCellWithWidth:width
                                                                             text:item.title
                                                                            image:item.image
                                                                    accessoryType:[self buk_accessoryTypeForItem:item]];
        return height;
    }
    
    return 44;
}

- (void)buk_registerCellClassOrNibForTableView:(UITableView *)tableView depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    if (depth % 2 == 0) {
        tableView.backgroundColor = self.oddLevelCellNormalBgColor;
    }else {
        tableView.backgroundColor = self.evenLevelCellNormalBgColor;
    }
    
    [tableView registerClass:[BUKPickerViewDefaultCell class] forCellReuseIdentifier:NSStringFromClass([BUKPickerViewDefaultCell class])];
}

- (CGFloat)buk_coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    if (!self.coverRates || !self.coverRates.count) {
        return 1.0;
    }
    
    NSInteger index = depth;
    if (self.coverRates.count <= index) {
        index = self.coverRates.count - 1;
    }
    
    id value = [self.coverRates objectAtIndex:index];
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    
    return 1.0;
}

- (void)buk_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth pickerView:(BUKPickerView *)pickerView
{
    self.buk_userInteracted = YES;
    
    if ([pickerView popToDepth:depth]) {
        [self.buk_sectionsStack removeObjectsInRange:NSMakeRange(depth + 1, self.buk_sectionsStack.count - depth - 1)];
    }
    
    BUKPickerViewItem *item = [self buk_itemAtIndexPath:indexPath depth:depth];
    
    if (item.children && item.children.count != 0) {
        [self.buk_sectionsStack addObject:item.children];
        [pickerView push];
    } else if (item.lazyChildren && !item.children) {
        [self buk_showLoadingView];
        item.lazyChildren(^(NSArray *children) {
            if (!children || ![children isKindOfClass:[NSArray class]]) {
                return ;
            }
            
            item.children = children;
            
            [self buk_tableView:tableView didSelectRowAtIndexPath:indexPath depth:depth pickerView:pickerView];
            
            [self buk_hideLoadingView];
        });
        
    } else if (self.allowMultiSelect) {
        if (item.isSelected) {
            item.isSelected = NO;
            [self.buk_selectionResult removeObject:item];
        } else if (self.maxSelectionCount > 0 && self.buk_selectionResult.count == self.maxSelectionCount) {
            if (self.overSelectionAction) {
                self.overSelectionAction();
            }
        } else {
            item.isSelected = YES;
            [self.buk_selectionResult addObject:item];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self buk_finishSelectionWithResult:item];
        [pickerView buk_dynamicHide];
    }
}

- (void)buk_pickerView:(BUKPickerView *)pickerView didFinishPopToDepth:(NSInteger)depth
{
    self.buk_userInteracted = YES;
    
    if (!self.needTitleView) {
        return;
    }
    
    self.titleView.leftButton.hidden = depth == 0;
}

- (void)buk_pickerView:(BUKPickerView *)pickerView didFinishPushToDepth:(NSInteger)depth
{
    [self buk_handleDefaultSelectionAtDepth:depth];
    
    if (!self.needTitleView) {
        return;
    }
    
    self.titleView.leftButton.hidden = depth == 0;
}

#pragma mark - private
- (NSArray *)buk_sectionsStackAtDepth:(NSInteger)depth
{
    if (self.buk_lazyLoadBlock) {
        [self buk_asyncLoadLazyLoadSections];
        return nil;
    }
    
    if (self.buk_sectionsStack.count <= depth) {
        return nil;
    }
    
    NSArray *sections = [self.buk_sectionsStack objectAtIndex:depth];
    if (!sections || ![sections isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    return sections;
}

- (void)buk_asyncLoadLazyLoadSections
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BUKFinishLoadPickerViewItemsBlock finishLoad = ^(NSArray *sections) {
            self.buk_lazyLoadBlock = nil;
            [self buk_addRootSections:sections];
            [self.buk_pickerView push];
            [self buk_hideLoadingView];
        };
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self buk_showLoadingView];
            self.buk_lazyLoadBlock(finishLoad);
        });
    });
}

- (BUKPickerViewItem *)buk_itemAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth
{
    NSArray *sections = [self buk_sectionsStackAtDepth:depth];
    
    if (!sections || sections.count <= indexPath.row) {
        return nil;
    }
    
    BUKPickerViewSection *section = [sections objectAtIndex:indexPath.section];
    BUKPickerViewItem *item = [section.items objectAtIndex:indexPath.row];
    
    if (![item isKindOfClass:[BUKPickerViewItem class]]) {
        return nil;
    }
    
    return item;
}

- (NSArray *)buk_defaultCoverRateForSections:(NSArray *)sections
{
    NSInteger levels = 1;
    BUKPickerViewSection *section = sections.lastObject;
    
    if (!section) {
        return @[@1.0];
    }
    
    while (section.items.lastObject.children) {
        levels++;
        section = section.items.lastObject.children.lastObject;
    }
    
    if (section.items.lastObject.lazyChildren) {
        levels++;
    }
    
    NSMutableArray *rates = [[NSMutableArray alloc] initWithCapacity:levels];
    for (int i = 0; i < levels; i++) {
        [rates addObject:@(1-i*1.0/levels)];
    }
    
    return rates;
}

- (void)buk_finishSelectionWithResult:(id)result
{
    if (self.buk_completeBlock) {
        self.buk_completeBlock(result);
    }
}

- (void)buk_loadDefaultSelectionsFromSections:(NSArray<BUKPickerViewSection *> *)sections
{
    if (![sections isKindOfClass:[NSArray class]]) {
        NSAssert(NO, @"BUKPickerViewModel: Not Valid BUKPickerViewItem Children!");
        return;
    }
    
    [sections enumerateObjectsUsingBlock:^(BUKPickerViewSection * _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        [section.items enumerateObjectsUsingBlock:^(BUKPickerViewItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item.isSelected) {
                if (item.children) {
                    if (!self.allowMultiSelect) {
                        [self.buk_sectionsStack addObject:item.children];
                    }
                } else {
                    [self.buk_selectionResult addObject:item];
                }
            }
            
            if (item.children) {
                [self buk_loadDefaultSelectionsFromSections:item.children];
            }
        }];
    }];
}

- (void)buk_showLoadingView
{
    [self.loadingView removeFromSuperview];
    
    [self.buk_pickerView addSubview:self.loadingView];
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.buk_pickerView addConstraints:@[
                                          [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.needTitleView ? self.titleView : self.buk_pickerView attribute:self.needTitleView? NSLayoutAttributeBottom : NSLayoutAttributeTop multiplier:1.0 constant:0],
                                          [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buk_pickerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                          [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.buk_pickerView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                          [NSLayoutConstraint constraintWithItem:self.loadingView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.buk_pickerView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]
                                          ]];
    
    self.loadingView.alpha = 0.0f;
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingView.alpha = 1.0f;
    }];
}

- (void)buk_hideLoadingView
{
    CALayer *layer = [self.loadingView.layer presentationLayer];
    CGFloat alpha = layer.opacity;
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.alpha = alpha;
    [UIView animateWithDuration:0.25f animations:^{
        self.loadingView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}

- (void)buk_handleDefaultSelectionAtDepth:(NSInteger)depth
{
    NSInteger stackCount = self.buk_sectionsStack.count;
    if (stackCount <= 1) {
        return;
    }
    
    if (stackCount <= depth) {
        return;
    }

    BUKPickerViewItem *selectedItem;
    
    if (self.buk_sectionsStack.count > depth + 1) {
        if (self.buk_userInteracted) {
            return;
        }
        
        if (self.allowMultiSelect) {
            return;
        }
        
        NSArray *childrenSections = [self.buk_sectionsStack objectAtIndex:depth+1];
        
        BUKPickerViewSection *childSection = [childrenSections firstObject];
        selectedItem = childSection.parentItem;
    } else {
        selectedItem = [self.buk_selectionResult firstObject];
    }
    
    if (!selectedItem) {
        return;
    }
    
    NSArray *currentSections = [self.buk_sectionsStack objectAtIndex:depth];
    NSIndexPath *indexPath;
    for (int i = 0; i < currentSections.count; i++) {
        BUKPickerViewSection *section = [currentSections objectAtIndex:i];
        for (int j = 0; j < section.items.count; j++) {
            BUKPickerViewItem *item = [section.items objectAtIndex:j];
            if (item == selectedItem) {
                indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    if (indexPath) {
        UITableView *tableView = [self.buk_pickerView tableViewAtDepth:depth];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        if (indexPath.row > 2) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 2 inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
}

- (void)buk_setupCell:(BUKPickerViewDefaultCell *)cell withPickViewItem:(BUKPickerViewItem *)item
{
    if (!item) {
        return;
    }
    
    if (!cell) {
        return;
    }
    
    cell.imageView.image = item.image;
    cell.textLabel.text = item.title;
    cell.accessoryType = [self buk_accessoryTypeForItem:item];
    
    if (self.enableMultiLineTitleForCell) {
        cell.textLabel.numberOfLines = 0;
    } else {
        cell.textLabel.numberOfLines = 1;
    }
}

- (UITableViewCellAccessoryType)buk_accessoryTypeForItem:(BUKPickerViewItem *)item
{
    if (item.isSelected) {
        if (!item.children && !item.lazyChildren) {
            return UITableViewCellAccessoryCheckmark;
        }
    }
    
    if (item.children || item.lazyChildren) {
        return UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return UITableViewCellAccessoryNone;
}

#pragma mark - setter && getter -
- (NSMutableArray *)buk_sectionsStack
{
    if (!_buk_sectionsStack) {
        _buk_sectionsStack = [[NSMutableArray alloc] init];
    }
    return _buk_sectionsStack;
}

- (BUKPickerTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[BUKPickerTitleView alloc] init];
        _titleView.leftButton.hidden = YES;
        _titleView.rightButton.hidden = !self.allowMultiSelect;
        __weak typeof(self) weakSelf = self;
        _titleView.leftButtonAction = ^(BUKPickerTitleView *titleView) {
            [weakSelf.buk_sectionsStack removeLastObject];
            [weakSelf.buk_pickerView pop];
            
            UITableView *tableView = [weakSelf.buk_pickerView tableViewAtDepth:weakSelf.buk_sectionsStack.count - 1];
            if (tableView) {
                [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:NO];
            }
        };
        _titleView.rightButtonAction = ^(BUKPickerTitleView *titleView) {
            [weakSelf buk_finishSelectionWithResult:weakSelf.buk_selectionResult];
            [weakSelf.buk_pickerView buk_dynamicHide];
        };
    }
    
    return _titleView;
}

- (NSMutableArray *)buk_selectionResult
{
    if (!_buk_selectionResult) {
        _buk_selectionResult = [[NSMutableArray alloc] init];
    }
    
    return _buk_selectionResult;
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] init];
        _loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator startAnimating];
        [_loadingView addSubview:indicator];
        
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        [_loadingView addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_loadingView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
                                       [NSLayoutConstraint constraintWithItem:indicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_loadingView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]
                                       ]
         ];
    }
    
    return _loadingView;
}

- (void)setAllowMultiSelect:(BOOL)allowMultiSelect
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(allowMultiSelect))];
    _allowMultiSelect = allowMultiSelect;
    [self didChangeValueForKey:NSStringFromSelector(@selector(allowMultiSelect))];
    
    if (!_titleView) {
        self.titleView.rightButton.hidden = !allowMultiSelect;
    }
}

@end
