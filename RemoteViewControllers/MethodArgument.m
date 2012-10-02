//
//  MethodArgument.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "MethodArgument.h"

@implementation MethodArgument {
    NSMutableData *_contents;
}

- (id)initWithArgumentType:(const char *)type
{
    self = [super init];
    if (self) {
        NSAssert(type != NULL, @"type must not be nil");
        _type = type;
    }
    return self;
}

- (size_t)size
{
    if (strcmp(_type, @encode(char)) == 0) {
        return sizeof(char);
    } else if (strcmp(_type, @encode(int)) == 0) {
        return sizeof(int);
    } else if (strcmp(_type, @encode(short)) == 0) {
        return sizeof(short);
    } else if (strcmp(_type, @encode(long)) == 0) {
        return sizeof(long);
    } else if (strcmp(_type, @encode(long long)) == 0) {
        return sizeof(long long);
    } else if (strcmp(_type, @encode(unsigned char)) == 0) {
        return sizeof(unsigned char);
    } else if (strcmp(_type, @encode(unsigned int)) == 0) {
        return sizeof(unsigned int);
    } else if (strcmp(_type, @encode(unsigned short)) == 0) {
        return sizeof(unsigned short);
    } else if (strcmp(_type, @encode(unsigned long)) == 0) {
        return sizeof(unsigned long);
    } else if (strcmp(_type, @encode(unsigned long long)) == 0) {
        return sizeof(unsigned long long);
    } else if (strcmp(_type, @encode(float)) == 0) {
        return sizeof(float);
    } else if (strcmp(_type, @encode(double)) == 0) {
        return sizeof(double);
    } else if (strcmp(_type, @encode(_Bool)) == 0) {
        return sizeof(_Bool);
    } else if (strcmp(_type, @encode(void)) == 0) {
        return sizeof(void);
    } else if (strcmp(_type, @encode(char *)) == 0) {
        return sizeof(char *);
    } else if (strcmp(_type, @encode(id)) == 0 || strcmp(_type, "@?") == 0) { // object or block (@?)
        return sizeof(id);
    } else if (strcmp(_type, @encode(Class)) == 0) {
        return sizeof(Class);
    } else if (strcmp(_type, @encode(SEL)) == 0) {
        return sizeof(SEL);
    } else if (strncmp(_type, "^", 1) == 0) { // pointer to type
        return sizeof(void *);
    }
    [NSException raise:NSInternalInconsistencyException format:@"argument type %s unknown", _type];
    return 0;
}

- (NSMutableData *)bufferForContents
{
    if (_contents == nil) {
        _contents = [[NSMutableData alloc] initWithLength:self.size];
    }
    return _contents;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];
    [description appendFormat:@"%s: ", _type];
    
    if (strcmp(_type, @encode(char)) == 0) {
        [description appendFormat:@"%c == %hhd", (char)[_contents bytes], (char)[_contents bytes]];
    } else if (strcmp(_type, @encode(int)) == 0) {
        [description appendFormat:@"%d", (int)[_contents bytes]];
    } else if (strcmp(_type, @encode(short)) == 0) {
        [description appendFormat:@"%hd", (short)[_contents bytes]];
    } else if (strcmp(_type, @encode(long)) == 0) {
        [description appendFormat:@"%ld", (long)[_contents bytes]];
    } else if (strcmp(_type, @encode(long long)) == 0) {
        [description appendFormat:@"%lld", (long long)[_contents bytes]];
    } else if (strcmp(_type, @encode(unsigned char)) == 0) {
        [description appendFormat:@"%c == %hhu", (unsigned char)[_contents bytes], (unsigned char)[_contents bytes]];
    } else if (strcmp(_type, @encode(unsigned int)) == 0) {
        [description appendFormat:@"%u", (unsigned int)[_contents bytes]];
    } else if (strcmp(_type, @encode(unsigned short)) == 0) {
        [description appendFormat:@"%hu", (unsigned short)[_contents bytes]];
    } else if (strcmp(_type, @encode(unsigned long)) == 0) {
        [description appendFormat:@"%lu", (unsigned long)[_contents bytes]];
    } else if (strcmp(_type, @encode(unsigned long long)) == 0) {
        [description appendFormat:@"%llu", (unsigned long long)[_contents bytes]];
    } else if (strcmp(_type, @encode(float)) == 0 || strcmp(_type, @encode(double)) == 0) {
        [description appendFormat:@"%f", *(double *)[_contents bytes]];
    } else if (strcmp(_type, @encode(_Bool)) == 0) {
        [description appendFormat:@"%hhd", (char)[_contents bytes]];
    } else if (strcmp(_type, @encode(void)) == 0) {
        [description appendString:@"(void)"];
    } else if (strcmp(_type, @encode(char *)) == 0) {
        [description appendFormat:@"%s", (char *)[_contents bytes]];
    } else if (strcmp(_type, @encode(id)) == 0 || strcmp(_type, "@?") == 0 || strcmp(_type, @encode(Class)) == 0) {
        [description appendFormat:@"%@", *(void **)[_contents bytes]];
    } else if (strcmp(_type, @encode(SEL)) == 0) {
        [description appendFormat:@"%@", NSStringFromSelector(*(SEL *)[_contents bytes])];
    } else if (strcmp(_type, @encode(_Bool)) == 0) {
        [description appendFormat:@"%hhd", (char)[_contents bytes]];
    } else if (strncmp(_type, "^", 1) == 0) { // pointer to type
        [description appendFormat:@"%p", *(void **)[_contents bytes]];
    } else {
        [NSException raise:NSInternalInconsistencyException format:@"argument type %s unknown", _type];
    }
    
    return description;
}

@end

/*
 Objective-C type encodings
 
 c A char
 i An int
 s A short
 l A long l is treated as a 32-bit quantity on 64-bit programs.
 q A long long
 C An unsigned char
 I An unsigned int
 S An unsigned short
 L An unsigned long
 Q An unsigned long long
 f A float
 d A double
 B A C++ bool or a C99 _Bool
 v A void
 * A character string (char *)
 @ An object (whether statically typed or typed id)
 # A class object (Class)
 : A method selector (SEL)
 [array type] An array
 {name=type...} A structure
 (name=type...) A union
 bnum A bit field of num bits
 ^type A pointer to type
 ? An unknown type (among other things, this code is used for function pointers)
 */
