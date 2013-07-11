//
//  main.m
//  CAMetadata
//
//  Created by David Aurelio on 10.07.13.
//  Copyright (c) 2013 David Aurelio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>
#import <libgen.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (argc != 2) {
        printf("Usage: %s path/to/audio/file", basename(argv[0]));
        return -1;
    }
    
    NSString* audioPath = [[NSString stringWithUTF8String:argv[1]]
                                stringByExpandingTildeInPath];
    NSURL* audioUrl = [NSURL fileURLWithPath:audioPath];
    AudioFileID audioFile;
    OSStatus err = noErr;
    
    err = AudioFileOpenURL((CFURLRef) audioUrl, kAudioFileReadPermission,
                           0, &audioFile);
    assert(err == noErr);
    
    UInt32 dictionarySize = 0;
    err = AudioFileGetPropertyInfo(audioFile, kAudioFilePropertyInfoDictionary,
                                   &dictionarySize, 0);
    assert(err == noErr);
    
    CFDictionaryRef dictionary;
    err = AudioFileGetProperty(audioFile, kAudioFilePropertyInfoDictionary,
                               &dictionarySize, &dictionary);
    assert(err == noErr);
    
    NSLog(@"dictionary: %@", dictionary);
    CFRelease(dictionary);
    
    err = AudioFileClose(audioFile);
    assert(err == noErr);

    [pool drain];
    return 0;
}

