// Falanxia Moderatrix.
//
// Copyright (c) 2010 Falanxia (http://falanxia.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

package com.falanxia.moderatrix.widgets {
	import com.falanxia.moderatrix.constants.Align;
	import com.falanxia.moderatrix.constants.MouseStatus;
	import com.falanxia.moderatrix.events.ButtonEvent;
	import com.falanxia.moderatrix.globals.SkinManager;
	import com.falanxia.moderatrix.skin.LabelButtonSkin;
	import com.falanxia.utilitaris.display.MorphSprite;
	import com.falanxia.utilitaris.utils.DisplayUtils;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;

	import flash.display.DisplayObjectContainer;



	/** @todo Comment */
	public class LabelButton extends MorphSprite {


		protected var _skin:LabelButtonSkin;
		protected var _button:ScaleButton;
		protected var _labelOut:Label;
		protected var _labelHover:Label;
		protected var _labelFocus:Label;

		private var _debugLevel:String;



		/** @todo Comment */
		public function LabelButton(skin:LabelButtonSkin, config:Object = null, text:String = "", parent:DisplayObjectContainer = null,
		                            debugLevel:String = null) {
			var c:Object;

			if(config == null) c = new Object();
			c = config;

			var dl:String = (debugLevel == null) ? SkinManager.debugLevel : debugLevel;

			_button = new ScaleButton(skin.buttonSkin, {}, this, dl);
			_labelOut = new Label(skin.labelOutSkin, {mouseEnabled:false, mouseChildren:false}, "", this, dl);
			_labelHover = new Label(skin.labelHoverSkin, {alpha:0, mouseEnabled:false, mouseChildren:false}, "", this, dl);
			_labelFocus = new Label(skin.labelFocusSkin, {alpha:0, mouseEnabled:false, mouseChildren:false}, "", this, dl);
			_button.debugColor = SkinManager.debugColor;
			_labelOut.debugColor = SkinManager.debugColor;
			_labelHover.debugColor = SkinManager.debugColor;
			_labelFocus.debugColor = SkinManager.debugColor;

			this.skin = skin;
			this.text = text;
			this.focusRect = false;

			_button.addEventListener(ButtonEvent.HOVER_IN_TWEEN, onButtonHoverInTween, false, 0, true);
			_button.addEventListener(ButtonEvent.HOVER_OUT_TWEEN, onButtonHoverOutTween, false, 0, true);
			_button.addEventListener(ButtonEvent.FOCUS_IN_TWEEN, onButtonFocusInTween, false, 0, true);
			_button.addEventListener(ButtonEvent.DRAG_CONFIRMED_TWEEN, onButtonDragConfirmedTween, false, 0, true);
			_button.addEventListener(ButtonEvent.RELEASED_INSIDE_TWEEN, onButtonReleasedInsideTween, false, 0, true);
			_button.addEventListener(ButtonEvent.RELEASED_OUTSIDE_TWEEN, onButtonReleasedOutsideTween, false, 0, true);

			if(c.width == undefined) c.width = skin.buttonSkin.assetSize.width;
			if(c.height == undefined) c.height = skin.buttonSkin.assetSize.height;

			//noinspection NegatedIfStatementJS
			if(skin != null) super(c, parent);
			else throw new Error("No skin defined");

			_skin = skin;
		}



		/**
		 * Destroys {@code LabelButton} instance and frees it for GC.
		 */
		override public function destroy():void {
			super.destroy();

			forceRelease();
			removeChildren();

			_button.destroy();
			_labelOut.destroy();
			_labelHover.destroy();
			_labelFocus.destroy();

			_skin = null;
			_button = null;
			_labelOut = null;
			_labelHover = null;
			_labelFocus = null;
			_debugLevel = null;
		}



		/** @todo Comment */
		public function draw():void {
			_button.draw();
			_labelOut.draw();
			_labelHover.draw();
			_labelFocus.draw();
		}



		/** @todo Comment */
		public function forceRelease():void {
			_button.forceRelease();
		}



		/** @todo Comment */
		public static function releaseAll():void {
			ButtonCore.releaseAll();
		}



		/**
		 * Automatically set {@code width} of the button.
		 * @param padding Padding
		 * @param max Maximal width (then text will be split in more lines)
		 */
		public function autoWidth(padding:Number = 0, max:Number = 500):void {
			this.width = 2000;

			var w:Number = label.width + padding;
			if(w > max) w = max;

			this.width = w;
		}



		/* ★ SETTERS & GETTERS ★ */

		/** @todo Comment */
		override public function get tabEnabled():Boolean {
			return _button.tabEnabled;
		}



		/** @todo Comment */
		override public function set tabEnabled(enabled:Boolean):void {
			_button.tabEnabled = enabled;
		}



		/** @todo Comment */
		override public function get tabIndex():int {
			return _button.tabIndex;
		}



		/** @todo Comment */
		override public function set tabIndex(index:int):void {
			_button.tabIndex = index;
		}



		/** @todo Comment */
		public function get skin():LabelButtonSkin {
			return _skin;
		}



		/** @todo Comment */
		public function set skin(skin:LabelButtonSkin):void {
			_skin = skin;

			_skin.labelOutSkin.hAlign = Align.CENTER;
			_skin.labelHoverSkin.hAlign = Align.CENTER;
			_skin.labelFocusSkin.hAlign = Align.CENTER;

			_button.skin = _skin.buttonSkin;
			_labelOut.skin = _skin.labelOutSkin;
			_labelHover.skin = _skin.labelHoverSkin;
			_labelFocus.skin = _skin.labelFocusSkin;

			draw();
		}



		/** @todo Comment */
		override public function get width():Number {
			return _button.width;
		}



		/** @todo Comment */
		override public function set width(value:Number):void {
			_button.width = value;
			_labelOut.width = value;
			_labelHover.width = value;
			_labelFocus.width = value;

			draw();
		}



		/** @todo Comment */
		override public function get height():Number {
			return _button.height;
		}



		/** @todo Comment */
		override public function set height(value:Number):void {
			_button.height = value;
			_labelOut.y = Math.round((value - _labelOut.height) / 2);
			_labelHover.y = Math.round((value - _labelHover.height) / 2);
			_labelFocus.y = Math.round((value - _labelFocus.height) / 2);

			draw();
		}



		/** @todo Comment */
		public function set areEventsEnabled(value:Boolean):void {
			_button.areEventsEnabled = value;
			this.buttonMode = value;
			this.useHandCursor = value;

			draw();
		}



		/** @todo Comment */
		public function get areEventsEnabled():Boolean {
			return _button.areEventsEnabled;
		}



		/** @todo Comment */
		public function get mouseStatus():String {
			return _button.mouseStatus;
		}



		/** @todo Comment */
		public function set mouseStatus(value:String):void {
			_button.mouseStatus = value;
		}



		/** @todo Comment */
		public function get debugLevel():String {
			return _debugLevel;
		}



		/** @todo Comment */
		public function set debugLevel(value:String):void {
			_debugLevel = value;
			_button.debugLevel = value;
			_labelOut.debugLevel = value;
			_labelHover.debugLevel = value;
			_labelFocus.debugLevel = value;
		}



		/** @todo Comment */
		public function get text():String {
			return _labelOut.text;
		}



		/** @todo Comment */
		public function set text(value:String):void {
			_labelOut.text = value;
			_labelHover.text = value;
			_labelFocus.text = value;

			draw();
		}



		/** @todo Comment */
		public function get label():Label {
			var out:Label;

			if(_button.mouseStatus == MouseStatus.OUT) out = _labelOut;
			if(_button.mouseStatus == MouseStatus.HOVER) out = _labelHover;
			if(_button.mouseStatus == MouseStatus.FOCUS) out = _labelFocus;

			return out;
		}



		/** @todo Comment */
		public function get labelOut():Label {
			return _labelOut;
		}



		/** @todo Comment */
		public function get labelHover():Label {
			return _labelHover;
		}



		/** @todo Comment */
		public function get labelFocus():Label {
			return _labelFocus;
		}



		/** @todo Comment */
		public function get button():ScaleButton {
			return _button;
		}



		/* ★ PRIVATE METHODS ★ */


		/**
		 * Remove children.
		 */
		private function removeChildren():void {
			_button.removeEventListener(ButtonEvent.HOVER_IN_TWEEN, onButtonHoverInTween);
			_button.removeEventListener(ButtonEvent.HOVER_OUT_TWEEN, onButtonHoverOutTween);
			_button.removeEventListener(ButtonEvent.FOCUS_IN_TWEEN, onButtonFocusInTween);
			_button.removeEventListener(ButtonEvent.DRAG_CONFIRMED_TWEEN, onButtonDragConfirmedTween);
			_button.removeEventListener(ButtonEvent.RELEASED_INSIDE_TWEEN, onButtonReleasedInsideTween);
			_button.removeEventListener(ButtonEvent.RELEASED_OUTSIDE_TWEEN, onButtonReleasedOutsideTween);

			DisplayUtils.removeChildren(this, _button, _labelOut, _labelHover, _labelFocus);
		}



		/* ★ EVENT LISTENERS ★ */


		/** @todo Comment */
		private function onButtonHoverInTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.hoverInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelHover, _skin.buttonSkin.hoverInDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(_labelFocus, _skin.buttonSkin.hoverInDuration, {alpha:0, ease:Sine.easeIn});
		}



		/** @todo Comment */
		private function onButtonHoverOutTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.hoverOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(_labelHover, _skin.buttonSkin.hoverOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelFocus, _skin.buttonSkin.hoverOutDuration, {alpha:0, ease:Sine.easeIn});
		}



		/** @todo Comment */
		private function onButtonFocusInTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.focusInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelHover, _skin.buttonSkin.focusInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelFocus, _skin.buttonSkin.focusInDuration, {alpha:1, ease:Sine.easeOut});
		}



		/** @todo Comment */
		private function onButtonDragConfirmedTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.hoverInDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelHover, _skin.buttonSkin.hoverInDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(_labelFocus, _skin.buttonSkin.hoverInDuration, {alpha:0, ease:Sine.easeIn});
		}



		/** @todo Comment */
		private function onButtonReleasedInsideTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.focusOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelHover, _skin.buttonSkin.focusOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(_labelFocus, _skin.buttonSkin.focusOutDuration, {alpha:0, ease:Sine.easeIn});
		}



		/** @todo Comment */
		private function onButtonReleasedOutsideTween(event:ButtonEvent):void {
			new TweenLite(_labelOut, _skin.buttonSkin.focusOutDuration, {alpha:1, ease:Sine.easeOut});
			new TweenLite(_labelHover, _skin.buttonSkin.focusOutDuration, {alpha:0, ease:Sine.easeIn});
			new TweenLite(_labelFocus, _skin.buttonSkin.focusOutDuration, {alpha:0, ease:Sine.easeIn});
		}
	}
}
