@interface SBApplicationLaunchNotifyAirplaneModeAlertItem : NSObject
-(void)_turnOffAirplaneMode;
@end

%group EasyAirplaneDisabler

//Replace "Open Settings" action with "Turn off Airplane"
%hook SBApplicationLaunchNotifyAirplaneModeAlertItem
-(void)_sendUserToSettings {
    [self _turnOffAirplaneMode];
}
%end

//Replace "Settings" action title with localized "Turn off" button
%hook UIAlertAction
+(id)actionWithTitle:(NSString*)title style:(long long)arg2 handler:(/*^block*/id)arg3 {
    //Localized keys are found in SpringBoard.strings files or with frida-trace on this method
    NSString *localizedAirplaneSettings = [[NSBundle mainBundle] localizedStringForKey:@"AIRPLANE_DATA_SETTINGS" value:@"Settings" table:@"SpringBoard"];
    if ([title isEqualToString:localizedAirplaneSettings]) {
        NSString *localizedDisable = [[NSBundle mainBundle] localizedStringForKey:@"TURN_OFF" value:@"Turn off" table:@"SpringBoard"];
        title = localizedDisable;
    }

    return %orig;
}
%end

%end //group EasyAirplaneDisabler


%ctor {
    if (![NSProcessInfo processInfo]) return;
    NSString *processName = [NSProcessInfo processInfo].processName;
    BOOL isSpringboard = [@"SpringBoard" isEqualToString:processName];

    if (isSpringboard) {
        %init(EasyAirplaneDisabler);
    }
}