/**
 * Created by kiripu on 02.02.2016.
 */
package ru.kiripu.cachedSprites.data
{
import flash.display.DisplayObject;

public class QueueElement
{
    public var object:DisplayObject;
    public var name:String;
    public var animationName:String;

    public static function create(object:DisplayObject, name:String, animationName:String = null):QueueElement
    {
        var queueElement:QueueElement = new QueueElement();
        queueElement.object = object;
        queueElement.name = name;
        queueElement.animationName = animationName;
        return queueElement;
    }
}
}
