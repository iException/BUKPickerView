//
//  BUKViewController.m
//  BUKPickerView
//
//  Created by hyice on 06/30/2015.
//  Copyright (c) 2014 hyice. All rights reserved.
//

#import "BUKViewController.h"
#import <BUKPickerView/BUKPickerView.h>
#import <BUKDynamicPopView/BUKDynamicPopView.h>
#import <BUKPickerView/BUKPickerTitleView.h>
#import <BUKPickerView/BUKPickerViewModel.h>


@interface BUKViewController ()

@property (nonatomic, strong) BUKPickerView *pickerView;
@property (nonatomic, strong) BUKPickerViewModel *pickerViewModel;

@end

@implementation BUKViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Custom UI
//    [[BUKPickerTitleView appearance] setBackgroundColor:[UIColor orangeColor]];
//    [[BUKPickerTitleView appearance] setTitleColor:[UIColor redColor]];
//    [[BUKPickerTitleView appearance] setTintColor:[UIColor whiteColor]];
//    [[BUKPickerTitleView appearance] setBottomLineColor:[UIColor blueColor]];
    
    self.title = @"DEMO";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"show" style:UIBarButtonItemStylePlain target:self action:@selector(showPickerView)];
}

- (void)showPickerView
{
    [self.pickerView buk_dynamicShowInView:self.view];
}
//
//#pragma mark - delegate -
//#pragma mark - BUKPickerViewDataSourceAndDelegate

//- (NSInteger)buk_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section depth:(NSInteger)depth
//{
//    return 10;
//}
//
//- (UITableViewCell *)buk_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth
//{
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
//    cell.textLabel.text = @"Just For Test";
//    return cell;
//}
//
//- (void)buk_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth
//{
//    if (depth == 2) {
//        [self.pickerView buk_dynamicHide];
//        self.pickerView = nil;
//    }else {
//        [self.pickerView push];
//    }
//}
//
//- (CGFloat)buk_coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth
//{
//    return 0.7f;
//}

- (BUKPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[BUKPickerView alloc] initWithDelegate:self.pickerViewModel];
        _pickerView.frame = CGRectMake(10, 0, 300, 500);
    }
    return _pickerView;
}

- (BUKPickerViewItem *)oneItem
{
    BUKPickerViewItem *item = [[BUKPickerViewItem alloc] init];
    item.title = @"Just For Test.";
    return item;
}

- (NSArray *)tenItems
{
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< 10; i++) {
        [testArray addObject:[self oneItem]];
    }
    
    return testArray;
}

- (NSArray *)tenItemsWithChildren:(NSArray *)children
{
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< 10; i++) {
        BUKPickerViewItem *item = [self oneItem];
        item.children = children;
        [testArray addObject:item];
    }
    
    return testArray;
}

- (BUKPickerViewModel *)pickerViewModel
{
    if (!_pickerViewModel) {
        NSArray *second = [self tenItemsWithChildren:[self tenItems]];

        _pickerViewModel = [[BUKPickerViewModel alloc] initWithPickerViewItems:[self tenItemsWithChildren:second] complete:^(id result) {
            NSLog(@"result:%@", result);
        }];
        _pickerViewModel.allowMultiSelect = YES;
        _pickerViewModel.coverRates = @[@1.0, @0.8, @0.6, @0.4];
    }
    
    return _pickerViewModel;
}
@end
