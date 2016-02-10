package {

import data.TestAnimation;
import data.TestSprite;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import ru.kiripu.cachedSprites.CachedAnimatedSprite;

import ru.kiripu.cachedSprites.CachedSprite;

import ru.kiripu.cachedSprites.CachedSpritesManager;

public class Main extends Sprite {
    private var _cachedSpritesManager:CachedSpritesManager;
    private var canvasBitmap:Bitmap;
    private var canvasBD:BitmapData;
    private var cachedSprite:CachedSprite;
    private var cachedAnimation:CachedAnimatedSprite;


    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);

        var sprite:MovieClip = new TestSprite();
        sprite.x = 100;
        sprite.y = 100;
        addChild(sprite);

        canvasBD = new BitmapData(500, 500, true, 0);
        canvasBitmap = new Bitmap(canvasBD);
        addChild(canvasBitmap);


        _cachedSpritesManager = new CachedSpritesManager();
        _cachedSpritesManager.enqueue(new TestSprite(), "test");
        _cachedSpritesManager.enqueue(new TestAnimation(), "test1", "idle");
        _cachedSpritesManager.load(onLoaded);
    }

    private function onLoaded():void
    {
        cachedSprite = _cachedSpritesManager.getSprite("test");
        cachedSprite.x = 200;
        cachedSprite.y = 100;

        cachedAnimation = _cachedSpritesManager.getAnimatedSprite("test1");
        cachedAnimation.x = 300;
        cachedAnimation.y = 200;

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(event:Event):void
    {
        cachedAnimation.update(0.033);

        canvasBD.unlock();
        canvasBD.fillRect(canvasBD.rect, 0);
        cachedSprite.draw(canvasBD);
        cachedAnimation.draw(canvasBD);
        canvasBD.lock();
    }
}
}
