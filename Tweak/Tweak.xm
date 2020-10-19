#import "Headers.h"

%group EasyAirplaneDisabler

//Replace "Open Settings" action with "Turn off Airplane"
%hook SBApplicationLaunchNotifyAirplaneModeAlertItem
-(void)_sendUserToSettings {
//     [self _turnOffAirplaneMode]; //Seems like they made some cleaning in iOS 14, they got rid of this method.
    RadiosPreferences *preferences = [%c(RadiosPreferences) new];
    [preferences setAirplaneMode:NO];
    [preferences synchronize];
}

-(void)didActivate {
    %orig;

    _SBAlertController *sbAlertController = MSHookIvar<_SBAlertController *>(self, "_alertController"); //This iVar is nil until the alert is activated
    UIAlertAction *settingsAction = [sbAlertController.actions firstObject];
    if (settingsAction) {
        //Localized keys are found in SpringBoard.strings files or with frida-trace on this method
        NSString *localizedDisable = [[NSBundle mainBundle] localizedStringForKey:@"TURN_OFF" value:@"Turn off" table:@"SpringBoard"];
        [settingsAction setTitle:localizedDisable];
    }
}
%end //hook SBApplicationLaunchNotifyAirplaneModeAlertItem

%end //group EasyAirplaneDisabler


%ctor {
    %init(EasyAirplaneDisabler);
}