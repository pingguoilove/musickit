//  Copyright (c) 2015 Venture Media Labs. All rights reserved.

#import "VMKLayerTestCase.h"
#import "VMKScoreElementImageLayer.h"

#import <mxml/geometry/CodaGeometry.h>
#import <mxml/geometry/SegnoGeometry.h>

@interface VMKImageLayerTests : VMKLayerTestCase

@end

@implementation VMKImageLayerTests

- (void)testCoda {
    mxml::dom::Segno coda;
    mxml::SegnoGeometry geom(coda);
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"coda" geometry:&geom];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

- (void)testSegno {
    mxml::dom::Segno segno;
    mxml::SegnoGeometry geom(segno);
    VMKScoreElementImageLayer* layer = [[VMKScoreElementImageLayer alloc] initWithImageName:@"segno" geometry:&geom];
    
    [self calculateRenderingErrors:layer forSelector:_cmd testBlock:^(VMKRenderingErrors errors) {
        XCTAssertLessThanOrEqual(errors.maximumError, kMaximumError);
    }];
}

@end
