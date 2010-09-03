/*
 * Falanxia Moderatrix.
 *
 * Copyright (c) 2010 Falanxia (http://falanxia.com)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.falanxia.moderatrix.widgets {
	import com.falanxia.moderatrix.globals.*;
	import com.falanxia.moderatrix.interfaces.*;
	import com.falanxia.moderatrix.skin.*;
	import com.falanxia.utilitaris.display.*;
	import com.falanxia.utilitaris.utils.*;
	import com.greensock.*;
	import com.greensock.easing.*;

	import flash.display.*;
	import flash.geom.*;



	public class ScaleButton extends ButtonCore implements IWidget {


		private var outSBS:ScaleBitmapSprite;
		private var hoverSBS:ScaleBitmapSprite;
		private var focusSBS:ScaleBitmapSprite;



		public function ScaleButton(skin:ButtonSkin, config:Object = null, parent:DisplayObjectContainer = null, debugLevel:String = null) {
			var c:Object;

			if(config == null) {
				c = new Object();
			}
			else {
				c = config;
			}

			super(skin, c, parent, (debugLevel == null) ? SkinManager.defaultDebugLevel : debugLevel);

			// TODO: Maybe needed in other classes
			if(config.width != undefined) this.width = config.width;
			if(config.height != undefined) this.height = config.height;
		}



		/**
		 * Destroys ScaleButton instance and frees it for GC.
		 */
		override public function destroy():void {
			super.destroy();

			forceRelease();

			// removeChildren();
			// was removed due to multiple item removal
			// TODO: Test if it's needed

			outSBS.destroy();
			hoverSBS.destroy();
			focusSBS.destroy();

			outSBS = null;
			hoverSBS = null;
			focusSBS = null;
		}



		override public function draw():void {
			if(_size != null) {
				super.draw();

				if(_size.width != 0) {
					outSBS.width = _size.width;
					hoverSBS.width = _size.width;
					focusSBS.width = _size.width;
				}
				if(_size.height != 0) {
					outSBS.height = _size.height;
					hoverSBS.height = _size.height;
					focusSBS.height = _size.height;
				}

				activeSpr.size = size;
			}
		}



		override public function set skin(skin:ButtonSkin):void {
			super.skin = skin;

			var rect:Rectangle = _skin.assetSources[ButtonSkin.GUIDE_ASSET].getColorBoundsRect(0x00FF0000, 0x00000000, false);

			// TODO: Outer rect

			outSBS.setData(_skin.assetSources[ButtonSkin.OUT_ASSET], rect);
			hoverSBS.setData(_skin.assetSources[ButtonSkin.HOVER_ASSET], rect);
			focusSBS.setData(_skin.assetSources[ButtonSkin.FOCUS_ASSET], rect);

			invalidate();
		}



		override protected function init():void {
			super.init();

			isMorphWidthEnabled = true;
			isMorphHeightEnabled = true;
			isChangeWidthEnabled = true;
			isChangeHeightEnabled = true;
		}



		override protected function addChildren():void {
			super.addChildren();

			outSBS = new ScaleBitmapSprite();
			hoverSBS = new ScaleBitmapSprite();
			focusSBS = new ScaleBitmapSprite();

			hoverSBS.alpha = 0;
			focusSBS.alpha = 0;

			outSBS.mouseEnabled = false;
			hoverSBS.mouseEnabled = false;
			focusSBS.mouseEnabled = false;

			DisplayUtils.addChildren(contentSpr, outSBS, hoverSBS, focusSBS);
		}



		/**
		 * Remove children.
		 */
		override protected function removeChildren():void {
			super.removeChildren();

			DisplayUtils.removeChildren(contentSpr, outSBS, hoverSBS, focusSBS);
		}



		override protected function hoverInTween():void {
			var hoverInDuration:Number = _skin.settings["hoverInDuration"];

			new TweenLite(outSBS, hoverInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(hoverSBS, hoverInDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(focusSBS, hoverInDuration, {alpha:0, ease:Sine.easeIn});

			super.hoverInTween();
		}



		override protected function hoverOutTween():void {
			var hoverOutDuration:Number = _skin.settings["hoverOutDuration"];

			new TweenLite(outSBS, hoverOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(hoverSBS, hoverOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(focusSBS, hoverOutDuration, {alpha:0, ease:Sine.easeIn});

			super.hoverOutTween();
		}



		override protected function focusInTween():void {
			var focusInDuration:Number = _skin.settings["focusInDuration"];

			new TweenLite(outSBS, focusInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(hoverSBS, focusInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(focusSBS, focusInDuration, {alpha:1, ease:Sine.easeOut});

			super.focusInTween();
		}



		override protected function dragConfirmedTween():void {
			var hoverInDuration:Number = _skin.settings["hoverInDuration"];

			new TweenLite(outSBS, hoverInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(hoverSBS, hoverInDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(focusSBS, hoverInDuration, {alpha:0, ease:Sine.easeIn});

			super.dragConfirmedTween();
		}



		override protected function releasedInsideTween():void {
			var focusOutDuration:Number = _skin.settings["focusOutDuration"];

			new TweenLite(outSBS, focusOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(hoverSBS, focusOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(focusSBS, focusOutDuration, {alpha:0, ease:Sine.easeIn});

			super.releasedInsideTween();
		}



		override protected function releasedOutsideTween():void {
			var focusOutDuration:Number = _skin.settings["focusOutDuration"];

			new TweenLite(outSBS, focusOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(hoverSBS, focusOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(focusSBS, focusOutDuration, {alpha:0, ease:Sine.easeIn});

			super.releasedOutsideTween();
		}
	}
}
