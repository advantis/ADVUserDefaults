//
//  Copyright © 2012 Yuri Kotov
//

#import "EditDetailsViewController.h"

// Model
#import "UserDefaults.h"

@implementation EditDetailsViewController
{
	UserDefaults *_defaults;

	IBOutlet UITextField *_fullNameField;
	IBOutlet UIDatePicker *_birthDatePicker;
	IBOutlet UISlider *_bloodSugarSlider;
	IBOutlet UILabel *_bloodSugarLabel;
	IBOutlet UISwitch *_rhesusFactorSwitch;
	IBOutlet UISegmentedControl *_bloodTypeSwitch;
}

#pragma mark - EditDetailsViewController
- (void) reloadData
{
	_fullNameField.text = _defaults.fullName;
	_bloodSugarSlider.value = _defaults.bloodSugar;
	_bloodSugarLabel.text = [NSString stringWithFormat:@"%0.2f", _defaults.bloodSugar];
	[_birthDatePicker setDate:_defaults.birthDate animated:NO];
	_rhesusFactorSwitch.on = [_defaults isRhesusFactorPositive];
	_bloodTypeSwitch.selectedSegmentIndex = _defaults.bloodType;
}

- (IBAction) done
{
	UIViewController *parentViewController = [self respondsToSelector:@selector(presentingViewController)]
			? self.presentingViewController
			: self.parentViewController;
	[parentViewController dismissModalViewControllerAnimated:YES];
}

- (IBAction) fullNameChanged:(UITextField *)sender
{
	_defaults.fullName = sender.text;
}

- (IBAction) birthDateChanged:(UIDatePicker *)sender
{
	_defaults.birthDate = sender.date;
}

- (IBAction) bloodTypeChanged:(UISegmentedControl *)sender
{
	_defaults.bloodType = (BloodType) sender.selectedSegmentIndex;
}

- (IBAction) rhesusFactorChanged:(UISwitch *)sender
{
	_defaults.positiveRhesusFactor = sender.on;
}

- (IBAction) bloodSugarChanged:(UISlider *)sender
{
	_defaults.bloodSugar = sender.value;
	_bloodSugarLabel.text = [NSString stringWithFormat:@"%0.2f", sender.value];
}

#pragma mark - UIViewController
- (id) initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName:nibName bundle:nibBundle];
	if (self)
	{
		_defaults = [UserDefaults new];
	}
	return self;
}

- (void) viewDidUnload
{
	_bloodTypeSwitch = nil;
	_rhesusFactorSwitch = nil;
	_bloodSugarLabel = nil;
	_bloodSugarSlider = nil;
	_birthDatePicker = nil;
	_fullNameField = nil;
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	return ![textField endEditing:YES];
}

@end
