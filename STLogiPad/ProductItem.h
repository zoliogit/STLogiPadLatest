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
@property NSString *StdPackDet;
@property NSString *productcode;
@property NSString *proddescription;
@property NSString *productuom;
@property int quantity;
@property NSString* image;

@end
