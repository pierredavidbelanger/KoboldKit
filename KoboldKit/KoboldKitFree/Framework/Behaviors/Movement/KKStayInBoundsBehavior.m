/*
 * Copyright (c) 2013 Steffen Itterheim.
 * Released under the MIT License:
 * KoboldAid/licenses/KoboldKitFree.License.txt
 */


#import "KKStayInBoundsBehavior.h"

@implementation KKStayInBoundsBehavior

+(id) stayInBounds:(CGRect)bounds
{
	return [[self alloc] initWithBounds:bounds];
}

-(id) initWithBounds:(CGRect)bounds
{
	self = [super init];
	if (self)
	{
		_bounds = bounds;
	}
	return self;
}

-(void) didJoinController
{
	[self.node.kkScene addSceneEventsObserver:self];
	_isSpriteNode = [self.node isKindOfClass:[SKSpriteNode class]];
}

-(void) didLeaveController
{
	[self.node.kkScene removeSceneEventsObserver:self];
}

-(void) setBounds:(CGRect)bounds
{
	_bounds = bounds;
	
	if (CGRectIsEmpty(_bounds) == NO)
	{
		// immediately update with new bounds
		[self didSimulatePhysics];
	}
}

-(void) didSimulatePhysics
{
	SKNode* node = self.node;
	CGPoint nodePos = node.position;
	CGSize nodeSize = node.frame.size;
	CGPoint anchorPoint = CGPointMake(0.5, 0.5);

	if (_isSpriteNode)
	{
		SKSpriteNode* sprite = (SKSpriteNode*)node;
		nodeSize = sprite.size;
		anchorPoint = sprite.anchorPoint;
	}
	
	SKPhysicsBody* body = node.physicsBody;
	CGVector velocity = body.velocity;
	
	// keep node within defined borders
	if (_bounds.origin.x != INFINITY && _bounds.size.width != INFINITY)
	{
		float maxWidth = _bounds.origin.x + _bounds.size.width - 1;
		if ((nodePos.x + nodeSize.width * (1.0 - anchorPoint.x)) > maxWidth)
		{
			nodePos.x = maxWidth - nodeSize.width * (1.0 - anchorPoint.x);
			velocity.dx = 0;
		}
		
		if ((nodePos.x - nodeSize.width * anchorPoint.x) < _bounds.origin.x)
		{
			nodePos.x = _bounds.origin.x + nodeSize.width * anchorPoint.x;
			velocity.dx = 0;
		}
	}
	
	if (_bounds.origin.y != INFINITY && _bounds.size.height != INFINITY)
	{
		float maxHeight = _bounds.origin.y + _bounds.size.height - 1;
		if ((nodePos.y + nodeSize.height * (1.0 - anchorPoint.y)) > maxHeight)
		{
			nodePos.y = maxHeight - nodeSize.height * (1.0 - anchorPoint.y);
			velocity.dy = 0;
		}
		
		if ((nodePos.y - nodeSize.height * anchorPoint.y) < _bounds.origin.y)
		{
			nodePos.y = _bounds.origin.y + nodeSize.height * anchorPoint.y;
			velocity.dy = 0;
		}
	}
	
	/*
	if (CGPointEqualToPoint(nodePos, node.position) == NO)
	{
		NSLog(@"Capped node.position to: %@", NSStringFromCGPoint(nodePos));
	}
	else
	{
		LOG_EXPR(node.position);
	}
	*/
	
	node.position = nodePos;
	body.velocity = velocity;
}

#pragma mark !! Update methods below whenever class layout changes !!
#pragma mark NSCoding

static NSString* const ArchiveKeyForOtherNode = @"otherNode";
static NSString* const ArchiveKeyForPositionOffset = @"positionOffset";
static NSString* const ArchiveKeyForPositionMultiplier = @"positionMultiplier";

-(id) initWithCoder:(NSCoder*)decoder
{
	self = [super init];
	if (self)
	{
		/*
		_target = [decoder decodeObjectForKey:ArchiveKeyForOtherNode];
		_positionOffset = [decoder decodeCGPointForKey:ArchiveKeyForPositionOffset];
		_positionMultiplier = [decoder decodeCGPointForKey:ArchiveKeyForPositionMultiplier];
		 */
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder*)encoder
{
	/*
	[encoder encodeObject:_target forKey:ArchiveKeyForOtherNode];
	[encoder encodeCGPoint:_positionOffset forKey:ArchiveKeyForPositionOffset];
	[encoder encodeCGPoint:_positionMultiplier forKey:ArchiveKeyForPositionMultiplier];
	 */
}

#pragma mark NSCopying

-(id) copyWithZone:(NSZone*)zone
{
	KKStayInBoundsBehavior* copy = [[super copyWithZone:zone] init];
	copy->_bounds = _bounds;
	copy->_isSpriteNode = _isSpriteNode;
	return copy;
}

#pragma mark Equality

-(BOOL) isEqualToBehavior:(KKBehavior*)behavior
{
	if ([self isMemberOfClass:[behavior class]] == NO)
		return NO;
	return NO;
}
@end
