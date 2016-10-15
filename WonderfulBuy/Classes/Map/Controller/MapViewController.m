//
//  MapViewController.m
//  WonderfulBuy
//
//  Created by Weiwei Jiang on 15/3/28.
//  Copyright (c) 2015年 Weiwei Jiang. All rights reserved.
//

#import "MapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "Business.h"
#import "Deal.h"
#import "DealAnnotation.h"
#import "MJExtension.h"
#import "MetaTool.h"
#import "ProductCategory.h"
#import "HomeTopItem.h"
#import "CategoryViewController.h"
#import "MTConst.h"

@interface MapViewController () <MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLGeocoder *coder;
@property (nonatomic, copy) NSString *city;
/** item */
@property (nonatomic, weak) UIBarButtonItem *categoryItem;
/** popover */
@property (nonatomic, strong) UIPopoverController *categoryPopover;
@property (nonatomic, copy) NSString *selectedCategoryName;
@property (nonatomic, strong) DPRequest *lastRequest;
@end

@implementation MapViewController

- (CLGeocoder *)coder
{
    if (!_coder) {
        self.coder = [[CLGeocoder alloc] init];
    }
    return _coder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    
    self.title = @"地图";
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    HomeTopItem *categoryTopItem = [HomeTopItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryTopItem];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backItem, categoryItem];
    
    
    [MTNotificationCenter addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangeNotification object:nil];
}

- (void)categoryClick
{
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[CategoryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)categoryDidChange:(NSNotification *)notification
{
    // close popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // get the category of product
    ProductCategory *category = notification.userInfo[MTSelectCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectSubcategoryName];
    // if no subcategory
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {
        self.selectedCategoryName = category.name;
    } else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    
    // remove all the annotations
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // resend to server
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
    // update top words
    HomeTopItem *topItem = (HomeTopItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubtitle:subcategoryName];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [MTNotificationCenter removeObserver:self];
}

#pragma mark - MKMapViewDelegate
/**
 *  called once update location
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // map shows where the user is
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    // longtitude to city : decoding
    // city to longtitude : encoding
    [self.coder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks.count == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length - 1];
        
        // first time to send request
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil) return;
    
    // send request to server
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"city"] = self.city;
    
    // category
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    
    // latitude and longitude
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(DealAnnotation *)annotation
{
    // returning nil means to be handled by system.
    if (![annotation isKindOfClass:[DealAnnotation class]]) return nil;
    
    // create MKAnnotationView
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    
    // set model
    annoView.annotation = annotation;
    
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}

#pragma mark - Request Delegate
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    
    NSLog(@"Request failed - %@", error);
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    
    NSArray *deals = [Deal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (Deal *deal in deals) {
        
        ProductCategory *category = [MetaTool categoryWithDeal:deal];
        
        for (Business *business in deal.businesses) {
            DealAnnotation *anno = [[DealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            
            [self.mapView addAnnotation:anno];
        }
    }
}
@end
