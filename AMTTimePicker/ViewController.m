#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet AMTTimePicker *timePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}
- (IBAction)setTimePickerInterval:(id)sender {
	[self.timePicker setTimeInterval:1251000]; // Magic number, sorry! 14d 11h 30m
}

- (void) amtTimePicker:(__unused AMTTimePicker *)picker
		 didSelectTime:(NSTimeInterval)timeInterval{
	self.timeLabel.text = [NSString stringWithFormat:@"Time Interval: %.0f seconds", timeInterval];
}
@end
