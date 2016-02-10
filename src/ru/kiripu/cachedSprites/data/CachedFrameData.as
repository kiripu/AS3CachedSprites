/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites.data
{
import flash.display.BitmapData;
import flash.geom.Point;

public class CachedFrameData
{
    public var bitmapData:BitmapData;
    public var offset:Point;
    public var label:String;

    public static function create(bitmapData:BitmapData, offsetX:Number = 0, offsetY:Number = 0, label:String = ""):CachedFrameData
    {
        var cacheFrame:CachedFrameData = new CachedFrameData();
        cacheFrame.bitmapData = bitmapData;
        cacheFrame.offset = new Point(offsetX, offsetY);
        cacheFrame.label = label;
        return cacheFrame;
    }
}
}
