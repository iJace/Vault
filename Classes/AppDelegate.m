/* 
 * AppDelegate.m
 * Vault
 *
 * Created by Jace Allison on December 21, 2011
 * Last modified on May 5, 2011 by Jace Allison
 *
 * Copyright © 2011-2012 Veeva Systems. All rights reserved.
 *
 * FILE DESCRIPTION
 * 
 * The functions in this file are called when the user interacts
 * with the application.  The only functions used are:
 *  
 *  - applicationDidFinishLaunchingWithOptions
 *  - applicationWillEnterForeground
 */

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

/* 
 * Sets up JSON mappings to native object classes and prepares the application to send
 * and recieve requests from Veeva Vaults' servers. This function is called when the application is
 * launched from a not already running state.
 *
 * PARAMETERS
 *
 *  lanchOptions        Options for launch (Usually set by the OS itself)
 *
 * RETURN VALUE(S)
 *
 *  YES                 Application launched successfully
 */

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    NSURL *baseUrl = [NSURL URLWithString:BASE_URL];
    
    /* Set up a general object manager for Vault and make it shraed */
    RKObjectManager *genManager = [RKObjectManager objectManagerWithBaseURL:baseUrl];
    [RKObjectManager setSharedManager:genManager]; 
    
    /* Map the response status for determining if a session is still valid */
    RKObjectMapping *sessionTestMapping = [RKObjectMapping mappingForClass:[SessionTest class]];
    [sessionTestMapping mapAttributes:@"responseStatus", nil];
    [[RKObjectManager sharedManager].mappingProvider setObjectMapping:sessionTestMapping 
                                               forResourcePathPattern:@"/metadata/objects"];
    
    /* Map the document attributes for requests retrieving document information */
    RKObjectMapping *documentMapping = [RKObjectMapping mappingForClass:[Document class]];
    [documentMapping mapKeyPath:@"id" toAttribute:@"documentId"];
    [documentMapping mapKeyPath:@"type__v" toAttribute:@"type"];
    [documentMapping mapKeyPath:@"name__v" toAttribute:@"name"];
    [documentMapping mapKeyPath:@"format__v" toAttribute:@"format"];
    [documentMapping mapKeyPath:@"version_modified_date__v" toAttribute:@"dateLastModified"];
    [documentMapping mapKeyPath:@"title__v" toAttribute:@"title"];
    [documentMapping mapKeyPath:@"document_number__v" toAttribute:@"docNumber"];
    [documentMapping mapKeyPath:@"size__v" toAttribute:@"size"];
    [documentMapping mapKeyPath:@"major_version_number__v" toAttribute:@"majorVNum"];
    [documentMapping mapKeyPath:@"minor_version_number__v" toAttribute:@"minorVNum"];
    [documentMapping mapKeyPath:@"lifecycle__v" toAttribute:@"lifecycle"];
    [documentMapping mapKeyPath:@"status__v" toAttribute:@"status"];
    [documentMapping mapKeyPath:@"version_created_by__v" toAttribute:@"owner"];
    [documentMapping mapKeyPath:@"last_modified_by__v" toAttribute:@"lastModifier"];
    
    /* Map the user attributes for requests retreiving user information */
    RKObjectMapping *docUserMapping = [RKObjectMapping mappingForClass:[DocumentUser class]];
    [docUserMapping mapKeyPath:@"user_first_name__v" toAttribute:@"firstName"];
    [docUserMapping mapKeyPath:@"user_last_name__v" toAttribute:@"lastName"];
    
    /* Determine where the text in the JSON should be parsed to retrieve correct information */
    [[RKObjectManager sharedManager].mappingProvider setMapping:docUserMapping forKeyPath:@"users.user"];
    
    /* Determine where the text in the JSON should be parsed to retrieve correct information */
    [[RKObjectManager sharedManager].mappingProvider setMapping:documentMapping forKeyPath:@"documents.document"];
    
    /* Set the mapping attributes to obtain relevent information from Vault */
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[VaultUser class]];
    userMapping.setNilForMissingRelationships = YES;
    [userMapping mapAttributes:@"sessionid", @"responseStatus", nil];
    
    /* Set the parser for the application to work with type text/html */
    [[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    
    return YES;
}

/*
 * Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary 
 * interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins 
 * the transition to the background state.  Use this method to pause ongoing tasks, disable timers, and throttle
 * down OpenGL ES frame rates. Games should use this method to pause the game.
 */

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

/*
 * Use this method to release shared resources, save user data, invalidate timers, and store enough application state
 * information to restore your application to its current state in case it is terminated later. 
 * If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 */

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
   
}

/*
 * Called as part of the transition from the background to the inactive state; here you can undo many of the changes
 * made on entering the background.
 */

- (void)applicationWillEnterForeground:(UIApplication *)application 
{

}

 /*
  * Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
  * previously in the background, optionally refresh the user interface. The task this function performs is to load the 
  * login view when the application is used for the very first time.
  *
  * PARAMETERS
  *
  * application             The application currently running
  */

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    NSString *session = [VaultUser loadSession];    /* Load last session, if it exists */
    
    
    if (session == nil) {                           /* No session exists */
        
        /* Instantiate Storyboard and view controllers to present modal transition for login */
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *loginScreen = [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginScreen.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        /* Present next run loop. Prevents "unbalanced VC display" warnings. Displays modal view */
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.window.rootViewController presentModalViewController:loginScreen animated:YES];
        });
    }
} 

/*
 * Called when the application is about to terminate.  Save data if appropriate.
 * See also applicationDidEnterBackground:.
 */

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
