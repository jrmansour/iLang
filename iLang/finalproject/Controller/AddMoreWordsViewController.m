//
//  AddMoreWordsViewController.m
//  finalproject
//
//  Created by Jahan on 18/01/14.
//  Copyright (c) 2014 Jahangir Rostamzad. All rights reserved.
//

#import "AddMoreWordsViewController.h"

@interface AddMoreWordsViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *daysPicker;

@property (strong, nonatomic) NSArray* pickerValues;

@end

@implementation AddMoreWordsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pickerValues = [NSArray arrayWithObjects: @"1", @"2", @"3", @"4", @"5", @"10",
                         @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", nil];
    [self.daysPicker reloadAllComponents];
    
	// Do any additional setup after loading the view.
    [self.daysPicker selectRow: 5 inComponent: 0 animated: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
    NSUInteger row = [self.daysPicker selectedRowInComponent:0];
    NSString* selItem = [self.pickerValues objectAtIndex: row];
    [self.database addWordsInProgress: [selItem intValue]];
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)cancelPressed:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerValues count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* item = [NSString stringWithFormat:@"%@ words", [self.pickerValues objectAtIndex:row]];
    return item;
}

@end
