// LIALinkedInApplication.m
//
// Copyright (c) 2013 Ancientprogramming
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "LIALinkedInApplication.h"


@implementation LIALinkedInApplication

- (id)initWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    self = [super init];
    if (self) {
        self.redirectURL = redirectURL;
        self.clientId = clientId;
        self.clientSecret = clientSecret;
        self.state = state;
        self.grantedAccess = grantedAccess;
    }

    return self;
}

+ (id)applicationWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    return [[self alloc] initWithRedirectURL:redirectURL clientId:clientId clientSecret:clientSecret state:state grantedAccess:grantedAccess];
}

- (NSString *)grantedAccessString {
    return [self.grantedAccess componentsJoinedByString: @"%20"];
}

@end