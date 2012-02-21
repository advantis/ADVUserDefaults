//
//  Copyright © 2012 Yuri Kotov
//


#import "EmergencyCardViewController.h"

// Model
#import "UserDefaults.h"

// Controller
#import "EditDetailsViewController.h"

enum
{
    FullNameRow = 0,
    BirthDateRow,
    BloodTypeRow,
    BloodSugarRow,
    NUM_ROWS
};

@implementation EmergencyCardViewController
{
    UserDefaults *_defaults;
    NSDateFormatter *_formatter;
}

#pragma mark - EmergencyCardViewController
- (void) edit
{
    EditDetailsViewController *editor = [EditDetailsViewController new];
    editor.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:editor animated:YES];
}

#pragma mark - UITableViewController
- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        _defaults = [UserDefaults new];

        _formatter = [NSDateFormatter new];
        [_formatter setDateStyle:NSDateFormatterMediumStyle];
        [_formatter setTimeStyle:NSDateFormatterNoStyle];

        self.title = @"Emergency Card";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                               target:self
                                                                                               action:@selector(edit)];
    }
    return self;
}

#pragma mark - UIViewController
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - NSObject
- (id) init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - UITableViewDataSource
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Personal Info";
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUM_ROWS;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    switch (indexPath.row)
    {
        case FullNameRow:
            cell.textLabel.text = @"Full Name";
            cell.detailTextLabel.text = _defaults.fullName;
            break;
        case BirthDateRow:
            cell.textLabel.text = @"Birth Date";
            cell.detailTextLabel.text = [_formatter stringFromDate:_defaults.birthDate];
            break;
        case BloodTypeRow:
            cell.textLabel.text = @"Blood Type";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%c",
                                         BloodTypeName(_defaults.bloodType),
                                         _defaults.positiveRhesusFactor ? '+' : '-'];
            break;
        case BloodSugarRow:
            cell.textLabel.text = @"Blood Sugar";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f mg/dL", _defaults.bloodSugar];
            break;
    }

    return cell;
}

@end
