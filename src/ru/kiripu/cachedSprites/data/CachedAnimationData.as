/**
 * Created by kiripu on 24.01.2016.
 */
package ru.kiripu.cachedSprites.data
{
public class CachedAnimationData
{
    public var name:String;
    public var startFrame:int;
    public var totalFrames:int;

    public static function create(name:String, startFrame:int, totalFrames:int):CachedAnimationData
    {
        var cachedAnimationData:CachedAnimationData = new CachedAnimationData();
        cachedAnimationData.name = name;
        cachedAnimationData.startFrame = startFrame;
        cachedAnimationData.totalFrames = totalFrames;
        return cachedAnimationData;
    }
}
}
