/*
 *	This file is part of the TVShows 2 ("Phoenix") source code.
 *	http://github.com/mattprice/TVShows/
 *
 *	TVShows is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with TVShows. If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "TSRegexFun.h"
#import "RegexKitLite.h"


@implementation TSRegexFun

+ (NSArray *) parseSeasonAndEpisode:(NSString *)title
{
	// Set up our regex strings.
	NSArray *matchedRegex, *returnThis = [NSArray array];
	NSArray *parseTypes = [NSArray arrayWithObjects:@"S([0-9]+)(?:[[:space:]]*)E([0-9]+)",  // S01E01
													@"([0-9]+)(?:[[:space:]]*x[[:space:]]*)([0-9]+)", // 01x01
													@"([0-9]{4})(?:[[:space:]]|[.])([0-9]{2})(?:[[:space:]]|[.])([0-9]{2})", // YYYY MM DD
													@"([0-9]{2})(?:[[:space:]]|[.])([0-9]{2})(?:[[:space:]]|[.])([0-9]{4})",nil]; // MM DD YYYY
	
	// Run through each of the regex strings we've listed above.
	for (NSString *regex in parseTypes) {
		matchedRegex = [title arrayOfCaptureComponentsMatchedByRegex:regex];
	
		// If there's a match then return it, otherwise do nothing.
		if([matchedRegex count] != 0) {
			returnThis = [matchedRegex objectAtIndex:0];
		}
	}

	// If at least one of the strings matched, return it.
	if (returnThis) {
		return returnThis;
	} else {
		// No strings matched? Return nothing.
		return nil;
	}
}

+ (NSString *) removeLeadingZero:(NSString *)string
{
	return [string stringByReplacingOccurrencesOfRegex:@"^ *0+" withString:@""];
}

+ (BOOL) isEpisodeHD:(NSString *)title
{
	return [title isMatchedByRegex:@"(720|1080|HR|x264|mkv)"];
}

+ (NSString *) parseTitleFromString:(NSString *)title withIdentifier:(NSArray* )identifier withType:(NSString *)type
{
	// This is a temporary method until theTVDB support is added
	NSString *showTitle = [title stringByReplacingOccurrencesOfRegex:@"showRSS: feed for " withString:@""];
	
	if (type == @"episode") {
		
		// TVShow is in a Season x Episode format
		return [NSString stringWithFormat:@"%@ — %@x%@",showTitle,[self removeLeadingZero:[identifier objectAtIndex:1]],[self removeLeadingZero:[identifier objectAtIndex:2]]];				
		
	} else if (type == @"date") {
		
		if ([[identifier objectAtIndex:1] length] == 4) {
			
			// TVShows is in a YYYY MM DD format
			return [NSString stringWithFormat:@"%@ — %@-%@-%@",showTitle,
					[self removeLeadingZero:[identifier objectAtIndex:2]],
					[self removeLeadingZero:[identifier objectAtIndex:3]],
					[self removeLeadingZero:[identifier objectAtIndex:1]]];				
		} else {
			
			// TVShow is in a MM DD YYYY format
			return [NSString stringWithFormat:@"%@ — %@-%@-%@",showTitle,
					[self removeLeadingZero:[identifier objectAtIndex:1]],
					[self removeLeadingZero:[identifier objectAtIndex:2]],
					[self removeLeadingZero:[identifier objectAtIndex:3]]];	
		}
	} else {
		return nil;
	}

}

+ (NSString *) replaceHTMLEntitiesInString:(NSString *)string
{
	return [string stringByReplacingOccurrencesOfRegex:@"&quot;" withString:@"\""];
}

@end
