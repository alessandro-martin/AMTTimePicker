#import "AMTTimePicker.h"

static NSInteger		const numberOfComponentsInPickerView = 3;
static NSUInteger	const defaultMaxNumberOfDays = 45;
static NSUInteger	const maxNumberOfHours = 23;
static NSUInteger	const maxNumberOfMinutes = 59;

@interface AMTTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, readwrite) NSUInteger maxNumberOfDays;

@end

@implementation AMTTimePicker
@synthesize delegate;

- (void)awakeFromNib {	
	[self setUpWithMaxDays:defaultMaxNumberOfDays];
}

- (void) setUpWithMaxDays:(NSUInteger)days {
	self.maxNumberOfDays = days;
	[self selectRow:1 inComponent:0 animated:YES];
	[self selectRow:1 inComponent:1 animated:YES];
	[self selectRow:1 inComponent:2 animated:YES];
	super.delegate = self;
	super.dataSource = self;
}

- (instancetype)initWithMaxDays:(NSUInteger)days {
	if (self = [super init]) {
		[self setUpWithMaxDays:(days > 0) ? days : defaultMaxNumberOfDays];
	}
	
	return self;
}

- (instancetype)init {
	if (self = [super init]) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	return self;
}

#pragma mark - Data

- (NSArray *)pickerData {
	if (!_pickerData) {
		NSMutableArray *temp = [NSMutableArray array];
		for (int i = 0; i < numberOfComponentsInPickerView; i++) {
			NSMutableArray *componentData = [NSMutableArray array];
			[temp addObject:componentData];
			NSUInteger size = 0;
			NSString *componentTitle;
			switch (i) {
				case 0:
					size = self.maxNumberOfDays;
					componentTitle = @"Days";
					break;
				case 1:
					size = maxNumberOfHours;
					componentTitle = @"Hours";
					break;
				case 2:
					size = maxNumberOfMinutes;
					componentTitle = @"Minutes";
					break;
				default:
					break;
			}
			[componentData addObject:componentTitle];
			for (int j = 0; j <= size; j++) {
				[componentData addObject:@(j)];
			}
		}
		_pickerData = temp;
	}
	
	return _pickerData;
}

- (double) timeIntervalFromPicker {
	int days		= [[self pickerView:self
						titleForRow:[self selectedRowInComponent:0]
					   forComponent:0] intValue];
	int hours	= [[self pickerView:self
					    titleForRow:[self selectedRowInComponent:1]
					   forComponent:1] intValue];
	int minutes = [[self pickerView:self
						titleForRow:[self selectedRowInComponent:2]
					   forComponent:2] intValue];
	int timeInSeconds = (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60);
	
	return timeInSeconds;
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView {
	return numberOfComponentsInPickerView;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
	return ((NSArray *)self.pickerData[component]).count;
}

#pragma mark - UIPickerViewDelegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component{
	return [NSString stringWithFormat:@"%@", self.pickerData[component][row]];
}

- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
	if (row == 0) {
		[self selectRow:1
			inComponent:component
			   animated:YES];
	} else {
		[self.delegate amtTimePicker:self
					   didSelectTime:[self timeIntervalFromPicker]];
	}
}

@end
