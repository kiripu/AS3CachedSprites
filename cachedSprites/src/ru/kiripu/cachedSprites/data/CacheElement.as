/**
 * Created by kiripu on 02.02.2016.
 */
package ru.kiripu.cachedSprites.data
{
import flash.utils.Dictionary;

public class CacheElement
{
    public var cachedFrameData:CachedFrameData;
    public var cachedFrameDataVector:Vector.<CachedFrameData>;
    public var cachedAnimationDataDictionary:Dictionary;

    public static function create(
            cachedFrameData:CachedFrameData,
            cachedFrameVector:Vector.<CachedFrameData> = null,
            cachedAnimationData:Dictionary = null):CacheElement
    {
        var cacheElement:CacheElement = new CacheElement();
        cacheElement.cachedFrameData = cachedFrameData;
        cacheElement.cachedFrameDataVector = cachedFrameVector;
        cacheElement.cachedAnimationDataDictionary = cachedAnimationData;
        return cacheElement;
    }
}
}
