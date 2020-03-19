//
//  ProductItem.h
//  STLogiPad
//
//  Created by Sreekumar A N on 10/17/19.
//  Copyright © 2019 Sreekumar A N. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductItem : NSObject
@property NSString *ownercode;
@property NSString *warehousecode;
@property int StdPackDet;
@property NSString *productcode;
@property NSString *proddescription;
@property NSString *productuom;
@property int Totalquantity,par,isSelected;
@property NSString* image;

@end
