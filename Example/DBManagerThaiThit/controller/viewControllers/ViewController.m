//
//  ViewController.m
//  Sqlite crud


#import "ViewController.h"
#import "DBWorker.h"
#import <AdSupport/AdSupport.h>

@interface ViewController ()

@property BOOL boolPhone;


@end

@implementation ViewController
@synthesize arrMainData,txtName,txtPhone, tableView,boolPhone;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //Handle Single Tap On View To hide keyboard and show Button Player
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    singleFingerTap.numberOfTapsRequired = 1;
    singleFingerTap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:singleFingerTap];
    [self.txtPhone addTarget:self
                      action:@selector(txtPhoneDidChange:)
            forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

/*Move UIView up when the keyboard appears in iOS
 
 - (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
 }

 - (void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
 }

 #pragma mark - keyboard movements
 - (void)keyboardWillShow:(NSNotification *)notification
 {
     CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

     [UIView animateWithDuration:0.3 animations:^{
         CGRect f = self.view.frame;
         f.origin.y = -keyboardSize.height;
         self.view.frame = f;
     }];
 }

 -(void)keyboardWillHide:(NSNotification *)notification
 {
     [UIView animateWithDuration:0.3 animations:^{
         CGRect f = self.view.frame;
         f.origin.y = 0.0f;
         self.view.frame = f;
     }];
 }
 
 */
#pragma mark - Customize



-(void)txtPhoneDidChange:(UITextField *)textField{
    //Validate input is number
    self.boolPhone = [self validateInputNumber:textField.text limitRange:10];
    
    NSLog(@"Text changed: %@\n", textField.text);
}

-(BOOL)validateInputNumber:(NSString *)str limitRange:(int8_t)range{
    if (str.length > range){
        [self showAlert:@"Limited 10 numbers"];
        return NO;
    }
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [str length]; i++) {
        unichar c = [str characterAtIndex:i];
        NSLog(@"Char: %c\n", c);
        if (![myCharSet characterIsMember:c]){
            [self showAlert:@"Just input numbers"];
            return NO;
        }
    }
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) recognizer{
    [self.view endEditing:YES]; //Hide keyboard
}

- (void)showAlert:(NSString *)message{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithTextField{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textFieldName) {
        textFieldName.placeholder = @"Input new name";
        textFieldName.secureTextEntry = NO;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textFieldPhone) {
        textFieldPhone.placeholder = @"Input new phone number";
        textFieldPhone.secureTextEntry = NO;
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self validateInputNumber:[[alertController textFields][1] text] limitRange:10]){
            if([self trimString:[[alertController textFields][0] text]].length == 0 ||
                [self trimString:[[alertController textFields][1] text]].length == 0){
                 [self showAlert:@"Please fill all fields."];
             }
             else{
                 DBWorker *dw = [[DBWorker alloc]init];
                 if([dw checkExistWithName:[self trimString:[[alertController textFields][0] text]]
                                Phone:[self trimString:[[alertController textFields][1] text]]] > 0){
                     [self showAlert:@"Data exist!"];
                 }
                 else{
                     if([dw updateDataWithNewName:[self trimString:[[alertController textFields][0] text]]
                                         NewPhone:[self trimString:[[alertController textFields][1] text]]
                                           AtName:[self trimString:self.txtName.text]
                                          AtPhone:[self trimString:self.txtPhone.text]]){
                         [self showAlert:@"Data saved !"];
                     }
                     else{
                         [self showAlert:@"Data is not saved !"];
                     }
                     
                 }
            }
            [self showAllDB];
        }
        
    }];
    
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAllDB{
    DBWorker *dw = [[DBWorker alloc]init];
    arrMainData = [dw getAllData];
    [tableView reloadData];
}

-(NSString *)trimString:(NSString *)str{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
#pragma mark - IBAction
- (IBAction)btnSave:(UIButton *)sender {
    
    [self.view endEditing:YES]; //Hide keyboard
    if(self.boolPhone){
        if([self trimString:txtName.text].length == 0 || [self trimString:txtPhone.text].length == 0){
            [self showAlert:@"Please fill all fields."];
        }
        else{
            DBWorker *dw = [[DBWorker alloc]init];
            if([dw checkExistWithName:[self trimString:txtName.text]
                                Phone:[self trimString:txtPhone.text]] > 0){
                [self showAlert:@"Data exist!"];
            }
            else{
                if([dw saveDataWithName:[self trimString:txtName.text]
                                  Phone:[self trimString:txtPhone.text]]){
                    [self showAlert:@"Data saved !"];
                }
                else{
                    [self showAlert:@"Data is not saved !"];
                }
                [self showAllDB];
            }
        }
    }
}

- (IBAction)btnUpdate:(UIButton *)sender {
    [self.view endEditing:YES]; //Hide keyboard
    DBWorker *dw = [[DBWorker alloc]init];
    if(self.boolPhone){
        if([dw checkDataNotEmtry]){
                if([self trimString:txtName.text].length == 0 || [self trimString:txtPhone.text].length == 0){
                    [self showAlert:@"Please fill all fields."];
                }
                else{
                    if([dw checkExistWithName:[self trimString:txtName.text]] > 0 &&
                       [dw checkExistWithPhone:[self trimString:txtPhone.text]] == 0){
                        if([dw updateDataWithName:[self trimString:txtName.text] PhoneUpdateTo:[self trimString:txtPhone.text]]){
                            [self showAlert:@"Data's phone number updated !"];
                        }
                        else{
                            [self showAlert:@"Data not updated !"];
                        }
                    }
                    else if([dw checkExistWithName:[self trimString:txtName.text]] == 0 &&
                             [dw checkExistWithPhone:[self trimString:txtPhone.text]] > 0){
                        if([dw updateDataWithPhone:[self trimString:txtName.text] NameUpdateTo:[self trimString:txtPhone.text]]){
                            [self showAlert:@"Data's name updated !"];
                        }
                        else{
                            [self showAlert:@"Data not updated !"];
                        }
                    }
                    else if([dw checkExistWithName:[self trimString:txtName.text]] > 0 &&
                            [dw checkExistWithPhone:[self trimString:txtPhone.text]] > 0){
                        [self showAlertWithTextField];
                    }
                    else {
                        [self showAlert:@"Data not exist !"];
                    }
                }
            }
            else {
                [self showAlert:@"Please save data first."];
            }
    }
    
}

//- (IBAction)btnSearch:(id)sender {
//    [self.view endEditing:YES]; //Hide keyboard
//    DBWorker *dw = [[DBWorker alloc]init];
//    if([dw checkDataNotEmtry]){
//        if([self trimString:txtName.text].length == 0 && [self trimString:txtPhone.text].length == 0){
//            [self ShowAlert:@"Please fill at least one field."];
//        }
//        else{
//            if ([dw checkExistWithName:[self trimString:txtName.text] Phone:[self trimString:txtPhone.text]]) {
//                arrMainData = [dw getDataWithName:[self trimString:txtName.text] Phone:[self trimString:txtPhone.text]];
//                [tableView reloadData];
//                [self ShowAlert:@"Data found !"];
//            } else {
//                [self showAllDB];
//                [self ShowAlert:@"Data not found !"];
//            }
// //            if([dw checkExistWithName:[self trimString:txtName.text]]){
// //                arrMainData = [dw getDataWithName:[self trimString:txtName.text]];
// //                [tableView reloadData];
// //                [self ShowAlert:@"Data found !"];
// //            }
// //            else{
// //                [self ShowAlert:@"Data not found !"];
// //                [self showAllDB];
// //            }
//        }
//    }
//    else{
//        [self ShowAlert:@"Please save data first."];
//    }
//}

- (IBAction)btnDelete:(UIButton *)sender {
    [self.view endEditing:YES]; //Hide keyboard
    DBWorker *dw = [[DBWorker alloc]init];
    if([dw checkDataNotEmtry]){
        if([self trimString:txtName.text].length == 0 && [self trimString:txtPhone.text].length == 0){
            if([dw deleteAllData]){
                [self showAllDB];
                [self showAlert:@"All data deleted !"];
            }else{
                [self showAllDB];
                [self showAlert:@"All data not deleted !"];
            }
        }
        else{
            if([dw checkExistWithName:[self trimString:txtName.text] Phone:[self trimString:txtPhone.text]] > 0){
                if([dw deleteDataWithName:[self trimString:txtName.text]
                                    Phone:[self trimString:txtPhone.text]]){
                    [self showAllDB];
                    [self showAlert:@"Data deleted !"];
                }else{
                    [self showAllDB];
                    [self showAlert:@"Data not deleted !"];
                }
            }
            else{
                [self showAlert:@"Data not exist !"];
            }
        }
        
    }
    else{
        [self showAlert:@"Please save data first."];
    }
    
}

- (IBAction)btnShow:(UIButton *)sender {
    [self.view endEditing:YES]; //Hide keyboard
    DBWorker *dw = [[DBWorker alloc]init];
    if([dw checkDataNotEmtry]){
        if([self trimString:txtName.text].length == 0 && [self trimString:txtPhone.text].length == 0){
            [self showAllDB];
        }
        else{
            if ([dw checkExistWithName:[self trimString:txtName.text] Phone:[self trimString:txtPhone.text]]) {
                arrMainData = [dw getDataWithName:[self trimString:txtName.text] Phone:[self trimString:txtPhone.text]];
                [tableView reloadData];
                [self showAlert:@"Data found !"];
            } else {
                [self showAllDB];
                [self showAlert:@"Data not found !"];
            }
        }
    
    }
    else{
        [self showAlert:@"Database emtry."];
    }
    
}
#pragma mark - Table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrMainData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@ - %@",
                  [[arrMainData objectAtIndex:indexPath.row]objectForKey:@"name"],
                  [[arrMainData objectAtIndex:indexPath.row]objectForKey:@"phone"]]);
    
    cell.textLabel.text = [[arrMainData objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.detailTextLabel.text = [[arrMainData objectAtIndex:indexPath.row]objectForKey:@"phone"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    txtName.text = [self trimString:[[arrMainData objectAtIndex:indexPath.row]objectForKey:@"name"]];
    txtPhone.text = [self trimString:[[arrMainData objectAtIndex:indexPath.row] objectForKey:@"phone"]];
}




@end
