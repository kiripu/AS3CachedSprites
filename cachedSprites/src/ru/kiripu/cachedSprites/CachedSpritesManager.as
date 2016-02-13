/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites {

import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

import ru.kiripu.cachedSprites.data.CacheElement;
import ru.kiripu.cachedSprites.data.CachedAnimationData;
import ru.kiripu.cachedSprites.data.CachedFrameData;
import ru.kiripu.cachedSprites.data.QueueElement;

public class CachedSpritesManager
{
    private var _cachedData:Dictionary;
    private var _queue:Array;
    private var _matrix:Matrix;
    private var _framerate:int;

    public function CachedSpritesManager(framerate:int = 30)
    {
        _queue = [];
        _cachedData = new Dictionary();
        _framerate = framerate;
    }

    public function enqueue(object:DisplayObject, name:String, animationName:String = null):void
    {
        if (object is MovieClip) (object as MovieClip).gotoAndStop(1);
        _queue.push(QueueElement.create(object, name, animationName));
    }

    public function load(onComplete:Function):void
    {
        _matrix = new Matrix();
        var queueElement:QueueElement;
        var queueLength:int = _queue.length;
        var cachedObject:DisplayObject;
        for (var i:int = 0; i < queueLength; i++)
        {
            queueElement = _queue.shift();
            cachedObject = queueElement.object;
            switch (getQualifiedSuperclassName(cachedObject))
            {
                case getQualifiedClassName(Sprite):
                    cacheSprite(queueElement.object as Sprite, queueElement.name);
                    break;
                case getQualifiedClassName(MovieClip):
                    if ((cachedObject as MovieClip).totalFrames > 1)
                        cacheAnimation(queueElement.object as MovieClip, queueElement.name, queueElement.animationName);
                    else cacheSprite(queueElement.object as Sprite, queueElement.name);
                    break;
            }
        }
        onComplete();
    }

    public function getSprite(name:String):CachedSprite
    {
        var data:CacheElement = _cachedData[name];
        if (data && data.cachedFrameData) return new CachedSprite(data.cachedFrameData);
        else return null;
    }

    public function getAnimatedSprite(name:String):CachedAnimatedSprite
    {
        var data:CacheElement = _cachedData[name];
        if (data && data.cachedFrameData == null)
            return new CachedAnimatedSprite(
                    data.cachedFrameDataVector,
                    data.cachedAnimationDataDictionary,
                    data.cachedAnimationsNames,
                    _framerate);
        else return null;
    }

    private function cacheSprite(sprite:Sprite, name:String):void
    {
        var rect:Rectangle;
        var bd:BitmapData;

        rect = sprite.getBounds(sprite);
        bd = new BitmapData(Math.max(1, rect.width), Math.max(1, rect.height), true, 0x00000000);
        _matrix.identity();
        _matrix.translate(-rect.x, -rect.y);
        _matrix.scale(sprite.scaleX, sprite.scaleY);
        bd.draw(sprite, _matrix);
        var cacheFrameData:CachedFrameData = CachedFrameData.create(bd, rect.x * sprite.scaleX, rect.y * sprite.scaleY);
        _cachedData[name] = CacheElement.create(cacheFrameData);
    }

    private function cacheAnimation(movieClip:MovieClip, name:String, animationName:String):void
    {
        var rect:Rectangle;
        var bd:BitmapData;
        var cachedFrames:Vector.<CachedFrameData>;
        var cachedAnimations:Dictionary;
        var cachedAnimationsNames:Vector.<String>;
        var cacheElement:CacheElement = _cachedData[name];
        if (cacheElement == null)
        {
            cachedFrames = new <CachedFrameData>[];
            cachedAnimations = new Dictionary();
            cachedAnimationsNames = new <String>[];
            cacheElement = _cachedData[name] = CacheElement.create(null, cachedFrames, cachedAnimations, cachedAnimationsNames);
        }
        cachedFrames = cacheElement.cachedFrameDataVector;
        cachedAnimations = cacheElement.cachedAnimationDataDictionary;
        cachedAnimationsNames = cacheElement.cachedAnimationsNames;

        if (cachedAnimations[animationName] != null) throw new Error("Animation exist");
        else
        {
            var totalFrames:int = movieClip.totalFrames;
            cachedAnimations[animationName] = CachedAnimationData.create(animationName, cachedFrames.length, totalFrames);
            cachedAnimationsNames.push(animationName);

            for (var i:int = 0; i < totalFrames; i++)
            {
                movieClip.gotoAndStop(i);
                rect = movieClip.getBounds(movieClip);
                bd = new BitmapData(Math.max(1, rect.width), Math.max(1, rect.height), true, 0x00000000);
                _matrix.identity();
                _matrix.translate(-rect.x, -rect.y);
                _matrix.scale(movieClip.scaleX, movieClip.scaleY);
                bd.draw(movieClip, _matrix);
                var cacheFrameData:CachedFrameData = CachedFrameData.create(bd, rect.x * movieClip.scaleX, rect.y * movieClip.scaleY);
                cachedFrames.push(cacheFrameData);
            }
        }
    }
}
}
