@interface SBApplicationLaunchNotifyAirplaneModeAlertItem : NSObject
-(void)_turnOffAirplaneMode;
@end

@interface _SBAlertController : UIAlertController
@property (nonatomic,retain) NSArray * actions;
@end

@interface UIAlertAction (Private)
-(void)setTitle:(NSString *)arg1 ;
@end