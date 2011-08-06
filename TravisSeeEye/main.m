//
//  main.m
//  TravisSeeEye
//
//  Created by Peter Schroeder on 06.08.11.
//  Copyright 2011 tolingo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
