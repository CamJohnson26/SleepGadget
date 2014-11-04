//
//  AnalyzeViewController.m
//  SleepTracker
//
//  Created by Cameron Johnson on 5/16/11.
//  Copyright 2011 Ouachita Baptist University. All rights reserved.
//

#import "AnalyzeViewController.h"

#define CALC_AVERAGE_1 @"amount"
#define CALC_AVERAGE_2 @"bedtime"
#define CALC_AVERAGE_3 @"wakeuptime"
#define CALC_CONSISTENCY_1 @"amount"
#define CALC_CONSISTENCY_2 @"bedtime"
#define CALC_CONSISTENCY_3 @"wakeuptime"
#define CALC_LIMIT_1 @"mostsleep"
#define CALC_LIMIT_2 @"leastsleep"
#define CALC_LIMIT_3 @"latestbedtime"
#define CALC_LIMIT_4 @"ealiestbedtime"
#define CALC_LIMIT_5 @"latestwakeup"
#define CALC_LIMIT_6 @"earliestwakeup"

@implementation AnalyzeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [dataToAnalyze release];
    [filledData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

# pragma mark - Do Calculations

// Sleep Debt
-(Time *)calculateSleepDebt {
    
    // Blank out return value
    [returnTimeVal setHour:0];
    [returnTimeVal setMinute:0];
    
    // Adjust for the range
    int iStart = [dataToAnalyze count] - analyzeRange - 1;
    
    // Add together all the sleep they've had within the range, then calculate what they should get and subtract it
    float runningTotal = 0;
    for (int i = iStart; i < [dataToAnalyze count]; i++) {
        runningTotal += [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue] -
        [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
    }
    float recommendedTotal = ((targetSleep.minute / 60) + targetSleep.hour) * analyzeRange;
    float debt = recommendedTotal - runningTotal;
    [returnTimeVal setHour:(int)debt];
    [returnTimeVal setMinute:(debt - (int)debt) * 60];
    return returnTimeVal;
}

// Returns a grade based on how much sleep they've gotten. 90% = A 80% = B ...
-(char)calculateGrade {
    
    char returnChar = 'A';
    
    // Figure out they're average sleep
    Time *averageSleep = [self calculateAverage:CALC_AVERAGE_1];
    
    // Determine the percentage
    float averageSleepDec = ((float)[averageSleep minute] / 60) + [averageSleep hour];
    float targetSleepDec = ((float)[targetSleep minute] / 60) + [targetSleep hour];
    float gradePercentage = (averageSleepDec / targetSleepDec) * 100;
    
    // Determine the grade
    if (gradePercentage >= 90) {
        returnChar = 'A';
    } else if (gradePercentage >= 80) {
        returnChar = 'B';
    } else if (gradePercentage >= 70) {
        returnChar = 'C';
    } else if (gradePercentage >= 60) {
        returnChar = 'D';
    } else {
        returnChar = 'F';
    }
    
    return returnChar;
}

// Sleep Average
-(Time *)calculateAverage:(NSString *)selection {
    
    // Blank out the return value incase something sneaks through our ifs
    [returnTimeVal setHour:0];
    [returnTimeVal setMinute:0];
    
    // Adjust for the range
    int iStart = [dataToAnalyze count] - analyzeRange - 1;
    
    if (selection == CALC_AVERAGE_1) {
        float runningTotal = 0;
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            runningTotal += [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue] -
                            [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
        }
        float averageTime = runningTotal / analyzeRange;
        [returnTimeVal setHour:(int)averageTime];
        [returnTimeVal setMinute:(averageTime - (int)averageTime) * 60];
    } else if (selection == CALC_AVERAGE_2) {
        float runningTotal = 0;
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            runningTotal += [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
        }
        float averageTime = runningTotal / analyzeRange;
        [returnTimeVal setHour:(int)averageTime];
        [returnTimeVal setMinute:(averageTime - (int)averageTime) * 60];
    } else if (selection == CALC_AVERAGE_3) {
        float runningTotal = 0;
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            runningTotal += [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue];
        }
        float averageTime = runningTotal / analyzeRange;
        [returnTimeVal setHour:(int)averageTime];
        [returnTimeVal setMinute:(averageTime - (int)averageTime) * 60];
    }
    
    return returnTimeVal;
}

// Sleep Consistency
-(Time *)calculateConistency:(NSString *)selection {
    
    // First, we need to determine the standard deviation. We calculate this by taking the sleep times, subtracting from the average, and squaring the result averaging these, and taking the square root. Then we invade Russia. During winter.
    
    [returnTimeVal setHour:0];
    [returnTimeVal setMinute:0];
    
    if (selection == CALC_CONSISTENCY_1) {
        // Adjust for the range
        int iStart = [dataToAnalyze count] - analyzeRange - 1;
        Time *sleepTimeAverage = [self calculateAverage:CALC_AVERAGE_1];
        float sleepAverage = ((float)[sleepTimeAverage minute] / 60) + [sleepTimeAverage hour];
        float runningTotal = 0;
    
        // Do the calculations on each value
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            float iSleepTime = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue] -
                            [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
            runningTotal += pow((iSleepTime - sleepAverage), 2.0);
        }
    
        float standardDeviation = sqrt((runningTotal / sleepAverage));
        [returnTimeVal setHour:(int)standardDeviation];
        [returnTimeVal setMinute:(standardDeviation - (int)standardDeviation) * 60];
    } else if (selection == CALC_CONSISTENCY_2) {
        // Adjust for the range
        int iStart = [dataToAnalyze count] - analyzeRange - 1;
        Time *sleepTimeAverage = [self calculateAverage:CALC_AVERAGE_2];
        float sleepAverage = ((float)[sleepTimeAverage minute] / 60) + [sleepTimeAverage hour];
        float runningTotal = 0;
        
        // Do the calculations on each value
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            float iSleepTime = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
            runningTotal += pow((iSleepTime - sleepAverage), 2.0);
        }
        
        float standardDeviation = sqrt((runningTotal / sleepAverage));
        [returnTimeVal setHour:(int)standardDeviation];
        [returnTimeVal setMinute:(standardDeviation - (int)standardDeviation) * 60];
    } else if (selection == CALC_CONSISTENCY_3) {
        // Adjust for the range
        int iStart = [dataToAnalyze count] - analyzeRange - 1;
        Time *sleepTimeAverage = [self calculateAverage:CALC_AVERAGE_3];
        float sleepAverage = ((float)[sleepTimeAverage minute] / 60) + [sleepTimeAverage hour];
        float runningTotal = 0;
        
        // Do the calculations on each value
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            float iSleepTime = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue];
            runningTotal += pow((iSleepTime - sleepAverage), 2.0);
        }
        
        float standardDeviation = sqrt((runningTotal / sleepAverage));
        [returnTimeVal setHour:(int)standardDeviation];
        [returnTimeVal setMinute:(standardDeviation - (int)standardDeviation) * 60];
    }
    
    return returnTimeVal;
}

// Sleep Limits
-(Time *)calculateLimit:(NSString *)selection {
    
    // Blank out the return value incase something sneaks through our ifs
    [returnTimeVal setHour:0];
    [returnTimeVal setMinute:0];
    
    // Adjust for the range
    int iStart = [dataToAnalyze count] - analyzeRange - 1;
    
    if (selection == CALC_LIMIT_1) {
        
        // Find the night they got the most sleep
        int answer = iStart;
        double length = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"EndDate"] floatValue] - [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"StartTime"] floatValue];
        for (int i = iStart; i > [dataToAnalyze count]; i++) {
            double tempLength = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue] - [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
            if (tempLength < length) {
                length = tempLength;
                answer = i;
            }
        }
        [returnTimeVal setHour:(int)length];
        [returnTimeVal setMinute:(length - (int)length) * 60];
    } else if (selection == CALC_LIMIT_2) {
        
        // Find the night they got the least sleep
        int answer = iStart;
        double length = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"EndDate"] floatValue] - [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"StartTime"] floatValue];
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            double tempLength = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] floatValue] - [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] floatValue];
            if (tempLength < length) {
                length = tempLength;
                answer = i;
            }
        }
        [returnTimeVal setHour:(int)length];
        [returnTimeVal setMinute:(length - (int)length) * 60];
        
    } else if (selection == CALC_LIMIT_3) {
        
        // Find the night they went to bed latest
        double latestNight = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"StartTime"] doubleValue];
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            double tempNight = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] doubleValue];
            // Issues here since early morning is later than 11 or 12
            if (tempNight > latestNight) {
                latestNight = tempNight;
            }
        }
        [returnTimeVal setHour:(int)latestNight];
        [returnTimeVal setMinute:(latestNight - (int)latestNight) * 60];

    } else if (selection == CALC_LIMIT_4) {
        
        // Find the night they went to bed earliest
        double latestNight = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"StartTime"] doubleValue];
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            double tempNight = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"StartTime"] doubleValue];
            // Issues here since early morning is later than 11 or 12
            if (tempNight < latestNight) {
                latestNight = tempNight;
            }
        }
        [returnTimeVal setHour:(int)latestNight];
        [returnTimeVal setMinute:(latestNight - (int)latestNight) * 60];
    } else if (selection == CALC_LIMIT_5) {
        
        // Find the night they woke up latest
        double latestWake = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"EndDate"] doubleValue];
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            double tempWake = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] doubleValue];
            // Issues here since early morning is later than 11 or 12
            if (tempWake > latestWake) {
                latestWake = tempWake;
            }
        }
        [returnTimeVal setHour:(int)latestWake];
        [returnTimeVal setMinute:(latestWake - (int)latestWake) * 60];
    } else if (selection == CALC_LIMIT_6) {
        
        // Find the night they woke up earliest
        double latestWake = [[[dataToAnalyze objectAtIndex:iStart] objectForKey:@"EndDate"] doubleValue];
        for (int i = iStart; i < [dataToAnalyze count]; i++) {
            double tempWake = [[[dataToAnalyze objectAtIndex:i] objectForKey:@"EndDate"] doubleValue];
            // Issues here since early morning is later than 11 or 12
            if (tempWake < latestWake) {
                latestWake = tempWake;
            }
        }
        [returnTimeVal setHour:(int)latestWake];
        [returnTimeVal setMinute:(latestWake - (int)latestWake) * 60];
    }
    
    return returnTimeVal;
}

-(NSString *)returnAnalyzedLabel:(NSIndexPath *)index {
    NSString *returnValue = @"";
    if ([index section] == 0) {
        switch ([index row]) {
            case 0:
                returnValue = [[self calculateSleepDebt] createString];
                break;
            case 1:
                returnValue = [NSString stringWithFormat:@"%c",[self calculateGrade]];
                break;
            default:
                break;
        }
    } else if ([index section] == 1) {
        switch ([index row]) {
            case 0:
                returnValue = [[self calculateAverage:CALC_AVERAGE_1] createString];
                break;
            case 1:
                returnValue = [[self calculateAverage:CALC_AVERAGE_2] createString];
                break;
            case 2:
                returnValue = [[self calculateAverage:CALC_AVERAGE_3] createString];
                break;
            default:
                break;
        }
    } else if ([index section] == 2) {
        switch ([index row]) {
            case 0:
                returnValue = [[self calculateConistency:CALC_CONSISTENCY_1] createString];
                break;
            case 1:
                returnValue = [[self calculateConistency:CALC_CONSISTENCY_2] createString];
                break;
            case 2:
                returnValue = [[self calculateConistency:CALC_CONSISTENCY_3] createString];
                break;
            default:
                break;
        }
    } else if ([index section] == 3) {
        switch ([index row]) {
            case 0:
                returnValue = [[self calculateLimit:CALC_LIMIT_1] createString];
                break;
            case 1:
                returnValue = [[self calculateLimit:CALC_LIMIT_2] createString];
                break;
            case 2:
                returnValue = [[self calculateLimit:CALC_LIMIT_3] createString];
                break;
            case 3:
                returnValue = [[self calculateLimit:CALC_LIMIT_4] createString];
                break;
            case 4:
                returnValue = [[self calculateLimit:CALC_LIMIT_5] createString];
                break;
            case 5:
                returnValue = [[self calculateLimit:CALC_LIMIT_6] createString];
                break;
            default:
                break;
        }
    }
    return returnValue;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set up the individual rows of the table view
    NSArray *data1 = [NSArray arrayWithObjects:@"Results", @"Sleep Debt",@"Grade", nil];
    NSArray *data2 = [NSArray arrayWithObjects:@"Averages", @"Sleep Amount",@"Bedtime", @"Wake Up Time", nil];
    NSArray *data3 = [NSArray arrayWithObjects:@"Consistency", @"Sleep Amount",@"Bedtime", @"Wake Up Time", nil];
    NSArray *data4 = [NSArray arrayWithObjects:@"Limits", @"Most Sleep",@"Least Sleep",@"Latest Bedtime",@"Earliest Bedtime",@"Latest Wake Up",@"Earliest Wake Up", nil];
    filledData = [[NSMutableArray alloc] initWithObjects:data1,data2,data3,data4, nil];
    
    // Allocate a graph so that we have something to analyze
    returnTimeVal = [[Time alloc] init];
    
    // Set up the goal
    targetSleep = [[Time alloc] init];
    [targetSleep setHour:8];
    [targetSleep setMinute:0];
    analyzeRange = 7;
}

-(void)viewWillAppear:(BOOL)animated {
    
    // Update the data
    Graph *tempGraph = [[Graph alloc] init];
    dataToAnalyze = [[NSArray alloc] initWithArray:[tempGraph returnAllHours]];
    [tempGraph release];
    [dataTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [filledData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[filledData objectAtIndex:section] count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[filledData objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row] + 1];
    cell.detailTextLabel.text = [self returnAnalyzedLabel:indexPath];
    return cell;
}

// Setup the tableview section headers
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // This should be the first element in the section of the array
    return [[filledData objectAtIndex:section] objectAtIndex:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
