//
//  ViewController.m
//  MapsDrag
//
//  Created by Faraz Haider on 11/14/17.
//  Copyright © 2017 Etisalat. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate,UIGestureRecognizerDelegate>
{
    CLLocationManager *objLocationManager;
    double latitude_UserLocation, longitude_UserLocation;
    BOOL _mapNeedsPadding;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserLocation];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) loadUserLocation
{
    objLocationManager = [[CLLocationManager alloc] init];
    objLocationManager.delegate = self;
    objLocationManager.distanceFilter = kCLDistanceFilterNone;
    objLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([objLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [objLocationManager requestWhenInUseAuthorization];
    }
    [objLocationManager startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    latitude_UserLocation = newLocation.coordinate.latitude;
    longitude_UserLocation = newLocation.coordinate.longitude;
    [objLocationManager stopUpdatingLocation];
    [self loadMapView];
}


- (void) loadMapView
{
    CLLocationCoordinate2D objCoor2D = {.latitude = latitude_UserLocation, .longitude = longitude_UserLocation};
    MKCoordinateSpan objCoorSpan = {.latitudeDelta = 0.2, .longitudeDelta = 0.2};
    MKCoordinateRegion objMapRegion = {objCoor2D, objCoorSpan};
    
     [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
    [self.mapView setRegion:objMapRegion];
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [objLocationManager stopUpdatingLocation];
}


//- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id) annotation {
//    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"myPin"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"myPin"] ;
//        
//    }
//    else {
//        pin.annotation = annotation;
//    }
//    pin.animatesDrop = YES;
//    pin.draggable = YES;
//    pin.canShowCallout = YES;
//    
//    return pin;
//}

//- (void)mapView:(MKMapView *)mapView
// annotationView:(MKAnnotationView *)annotationView
//didChangeDragState:(MKAnnotationViewDragState)newState
//   fromOldState:(MKAnnotationViewDragState)oldState
//{
//    if (newState == MKAnnotationViewDragStateEnding)
//    {
//        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
//        [annotationView.annotation setCoordinate:droppedAt];
//
//        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
//
//    }
//
//}

-(void)getLocation:(CLLocation *)locations withcompletionHandler : (void(^)(NSArray *arr))completionHandler{
    
    
    
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:locations completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,
                                                                   NSError * _Nullable error) {
        // placemark = [placemarks lastObject];
        
        completionHandler(placemarks);
        
    }];
    
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

        NSLog(@"%f %f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    
        CLLocation * location = [[CLLocation alloc]initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        [self getLocation:location withcompletionHandler:^(NSArray *arr) {
        
        // you will get whole array here in `arr`, now you can manipulate it according to requirement
        NSLog(@"your response array : %@",arr);
        
        CLPlacemark *placemark = [arr lastObject];
            _textView.text = placemark.name;
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
