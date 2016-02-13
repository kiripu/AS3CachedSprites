/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.utils.Dictionary;

import ru.kiripu.cachedSprites.data.CachedAnimationData;
import ru.kiripu.cachedSprites.data.CachedFrameData;
import ru.kiripu.cachedSprites.error.CachedSpritesError;

public class CachedAnimatedSprite
{
    public var x:Number;
    public var y:Number;

    private var _frames:Vector.<CachedFrameData>;
    private var _animations:Dictionary;

    private var _currFrame:int;
    private var _currTime:Number;
    private var _frameData:CachedFrameData;
    private var _animationData:CachedAnimationData;
    private var _isPlaying:Boolean;
    private var _destPoint:Point;
    private var _animationsNames:Vector.<String>;

    public function CachedAnimatedSprite(frames:Vector.<CachedFrameData>, animations:Dictionary, animationsNames:Vector.<String>)
    {
        _frames = frames;
        _animations = animations;
        _animationsNames = animationsNames;
        _animationData = _animations[_animationsNames[0]];
        _currFrame = 0;
        _currTime = 0;
        _isPlaying = true;
        _destPoint = new Point();
    }

    public function dispose():void
    {
        _frames = null;
        _animations = null;
        _frameData = null;
        _animationData = null;
        _destPoint = null;
    }

    public function update(deltaTime:Number):void
    {
        if (_isPlaying)
        {
            _currTime += deltaTime;
            var newFrame:int = (_currTime * 30) % _animationData.totalFrames + _animationData.startFrame;
            if (_currFrame == newFrame) onFrameChanged();
            _currFrame = newFrame;
            _frameData = _frames[newFrame];
        }
    }

    public function draw(source:BitmapData):void
    {
        if (_isPlaying && _frameData)
        {
            var bitmapData:BitmapData = _frameData.bitmapData;
            var offset:Point = _frameData.offset;
            _destPoint.setTo(x + offset.x, y + offset.y);
            source.copyPixels(bitmapData, bitmapData.rect, _destPoint, null, null, true);
        }
    }

    public function play():void {_isPlaying = true;}

    public function stop():void {_isPlaying = false;}

    public function gotoAndPlay(animationName:String):void
    {
        if (gotoAnimation(animationName)) play();
    }

    public function gotoAndStop(animationName:String):void
    {
        if (gotoAnimation(animationName)) stop();
    }

    private function gotoAnimation(animationName:String):Boolean
    {
        _animationData = _animations[animationName];
        if (_animationData != null) return true;
        else throw new Error(CachedSpritesError.ERROR_NO_ANIMATION_IN_SPRITE);
    }

    private function onFrameChanged():void
    {

    }
}
}
