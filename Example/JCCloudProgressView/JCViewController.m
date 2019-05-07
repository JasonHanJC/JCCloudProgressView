//
//  JCViewController.m
//  JCCloudProgressView
//
//  Created by JasonHan1990 on 05/07/2019.
//  Copyright (c) 2019 JasonHan1990. All rights reserved.
//

#import "JCViewController.h"
#import "JCCloudProgressView.h"

@interface JCViewController ()

@property (weak, nonatomic) IBOutlet JCCloudProgressView *cloudProgressView;
@property (weak, nonatomic) IBOutlet UISwitch *animationSwitch;

@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)progressSegmentValueChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.cloudProgressView updateProgress:0.0 animated:self.animationSwitch.on];
            break;
        case 1:
            [self.cloudProgressView updateProgress:0.2 animated:self.animationSwitch.on];
            break;
        case 2:
            [self.cloudProgressView updateProgress:0.4 animated:self.animationSwitch.on];
            break;
        case 3:
            [self.cloudProgressView updateProgress:0.6 animated:self.animationSwitch.on];
            break;
        case 4:
            [self.cloudProgressView updateProgress:0.8 animated:self.animationSwitch.on];
            break;
        case 5:
            [self.cloudProgressView updateProgress:1.0 animated:self.animationSwitch.on];
            break;
        default:
            break;
    }
}

- (IBAction)useRedAndBlue:(id)sender {
    self.cloudProgressView.colorA = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    self.cloudProgressView.colorB = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
}

- (IBAction)useOrangeAndGreen:(id)sender {
    self.cloudProgressView.colorA = [UIColor colorWithRed:1 green:0.58 blue:0 alpha:0.5];
    self.cloudProgressView.colorB = [UIColor colorWithRed:0 green:0.98 blue:0 alpha:0.5];
}


- (IBAction)changeCloudColor:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            self.cloudProgressView.cloudColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
            break;
        case 2:
            self.cloudProgressView.cloudColor = [UIColor colorWithRed:1 green:251.f/255.f blue:0 alpha:1];
            break;
        case 3:
            self.cloudProgressView.cloudColor = [UIColor colorWithRed:57.f/255.f green:202.f/255.f blue:154.f/255.f alpha:1];
            break;
        default:
            break;
    }
}

@end
