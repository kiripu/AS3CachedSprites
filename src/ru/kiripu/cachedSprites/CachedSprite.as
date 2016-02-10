/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites {
import flash.display.BitmapData;
import flash.geom.Point;

import ru.kiripu.cachedSprites.data.CachedFrameData;

public class CachedSprite
{
    public var x:Number;
    public var y:Number;

    private var _cachedFrame:CachedFrameData;
    private var _destPoint:Point;

    public function CachedSprite(cachedFrameData:CachedFrameData)
    {
        _cachedFrame = cachedFrameData;
        _destPoint = new Point();
    }

    public function dispose():void
    {
        _cachedFrame = null;
        _destPoint = null;
    }

    public function draw(source:BitmapData):void
    {
        var bitmapData:BitmapData = _cachedFrame.bitmapData;
        var offset:Point = _cachedFrame.offset;
        _destPoint.setTo(x + offset.x, y + offset.y);
        source.copyPixels(bitmapData, bitmapData.rect, _destPoint);
    }
}
}
