//  Copyright (c) 2014 Venture Media Labs. All rights reserved.

#import "VMKImage.h"
#import "VMKGeometry.h"

#if TARGET_OS_IPHONE

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    block(context);

    VMKImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return result;
}

#else

CG_EXTERN VMKImage* VMKRenderImage(CGSize size, void (^block)(CGContextRef))   {
    size = VMKRoundSize(size);
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    CGSize scaledSize = CGSizeMake(size.width * scale, size.height * scale);
    VMKImage* result = [[NSImage alloc] initWithSize:size];

    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes:NULL
                             pixelsWide:scaledSize.width
                             pixelsHigh:scaledSize.height
                             bitsPerSample:8
                             samplesPerPixel:4
                             hasAlpha:YES
                             isPlanar:NO
                             colorSpaceName:NSCalibratedRGBColorSpace
                             bytesPerRow:0
                             bitsPerPixel:0];
    [result addRepresentation:rep];

    [result lockFocus];

    CGContextRef ctx = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
    block(ctx);

    [result unlockFocus];
    
    return result;
}

@implementation NSImage (VMKExtension)

- (NSImageRep*)beestRepresentationForScreenScale {
    CGFloat scale = [NSScreen mainScreen].backingScaleFactor;
    CGSize smallestSize = [self smallestSize];
    CGSize targetSize = CGSizeMake(smallestSize.width * scale, smallestSize.height);
    CGFloat closestWidth = smallestSize.width;
    NSImageRep* closestRep;
    for (NSImageRep* rep in self.representations) {
        if (abs(rep.pixelsWide - targetSize.width) < abs(rep.pixelsWide - closestWidth)) {
            closestWidth = rep.pixelsWide;
            closestRep = rep;
        }
    }
    return closestRep;
}

- (CGSize)smallestSize {
    CGSize size = CGSizeMake(HUGE_VALF, HUGE_VALF);
    for (NSImageRep* rep in self.representations) {
        if (rep.size.width < size.width)
            size = rep.size;
    }
    return size;
}

@end

#endif