/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.utils.Dictionary;

import ru.kiripu.cachedSprites.data.CachedAnimationData;
import ru.kiripu.cachedSprites.data.CachedFrameData;

public class CachedAnimatedSprite
{
    public var x:Number;
    public var y:Number;

    private var _frames:Vector.<CachedFrameData>;
    private var _animations:Dictionary;

    private var _timeToFps:Number;
    private var _currFrame:Number;
    private var _frameData:CachedFrameData;
    private var _animationData:CachedAnimationData;
    private var _isPlaying:Boolean;
    private var _destPoint:Point;

    public function CachedAnimatedSprite(frames:Vector.<CachedFrameData>, animations:Dictionary, fps:Number = 60)
    {
        _timeToFps = 1 / fps;
        _frames = frames;
        _animations = animations;
        _animationData = _animations["idle"];
        _currFrame = 0;
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
            _currFrame = (_currFrame + deltaTime * 30) % _animationData.totalFrames + _animationData.startFrame;
            _frameData = _frames[int(_currFrame)];
	        trace(_currFrame);
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
}
}
