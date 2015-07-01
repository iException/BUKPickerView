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

@interface BUKViewController () <BUKPickerViewDataSourceAndDelegate>

@property (nonatomic, strong) BUKPickerView *pickerView;

@end

@implementation BUKViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pickerView buk_dynamicShowInView:self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section depth:(NSInteger)depth
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth
{
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test" forIndexPath:indexPath];
    cell.textLabel.text = @"科技大厦";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath depth:(NSInteger)depth
{
    [self.pickerView push];
}

- (CGFloat)coverRateForTableView:(UITableView *)tableView depth:(NSInteger)depth
{
    return 1.0f;
}

- (BUKPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[BUKPickerView alloc] initWithFrame:CGRectMake(10, 0, 300, 500)];
        _pickerView.delegate = self;
    }
    return _pickerView;
}
@end
