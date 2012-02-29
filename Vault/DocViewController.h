//
//  DocViewController.h
//  Vault
//
//  Created by Jace Allison on 2/28/12.
//  Copyright (c) 2012 Issaquah High School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Document.h"
#import "Constants.h"

@interface DocViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *pdfView;
@property (nonatomic, retain) IBOutlet UIToolbar *doneToolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIView *invisibleView;

+ (void) setFileNameToView:(NSString *)filePath;
- (IBAction)finishViewing:(id)sender;

@end