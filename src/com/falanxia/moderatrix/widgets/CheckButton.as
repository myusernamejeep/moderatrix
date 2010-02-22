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
	import com.falanxia.moderatrix.events.ButtonEvent;
	import com.falanxia.moderatrix.globals.SkinManager;
	import com.falanxia.moderatrix.interfaces.IWidget;
	import com.falanxia.moderatrix.skin.CheckButtonSkin;
	import com.falanxia.utilitaris.display.MorphSprite;
	import com.falanxia.utilitaris.utils.DisplayUtils;

	import flash.display.DisplayObjectContainer;



	/** @todo Comment */
	public class CheckButton extends MorphSprite implements IWidget {


		protected var _skin:CheckButtonSkin;
		protected var _buttonOff:StaticButton;
		protected var _buttonOn:StaticButton;

		private var _debugLevel:String;
		private var _isChecked:Boolean;



		/** @todo Comment */
		public function CheckButton(skin:CheckButtonSkin, config:Object = null, parent:DisplayObjectContainer = null,
		                            debugLevel:String = null) {
			var c:Object;

			if(config == null) c = new Object();
			else c = config;

			var dl:String = (debugLevel == null) ? SkinManager.debugLevel : debugLevel;

			_buttonOff = new StaticButton(skin.buttonOffSkin, {}, this, dl);
			_buttonOn = new StaticButton(skin.buttonOnSkin, {visible:false}, this, dl);

			_buttonOff.debugColor = SkinManager.debugColor;
			_buttonOn.debugColor = SkinManager.debugColor;

			this.buttonMode = true;
			this.useHandCursor = true;
			this.focusRect = false;
			this.isMorphHeightEnabled = false;
			this.isMorphWidthEnabled = false;

			_buttonOff.addEventListener(ButtonEvent.RELEASE_INSIDE, onToggle, false, 0, true);
			_buttonOn.addEventListener(ButtonEvent.RELEASE_INSIDE, onToggle, false, 0, true);

			if(c.width == undefined) c.width = skin.buttonOffSkin.assetSize.width;
			if(c.height == undefined) c.height = skin.buttonOffSkin.assetSize.height;

			//noinspection NegatedIfStatementJS
			if(skin != null) super(c, parent);
			else throw new Error("No skin defined");

			_skin = skin;
		}



		/** @todo Comment */
		public function destroy():void {
			_buttonOff.removeEventListener(ButtonEvent.RELEASE_INSIDE, onToggle);

			DisplayUtils.removeChildren(this, _buttonOff, _buttonOn);

			_buttonOff.destroy();
			_buttonOn.destroy();
		}



		/** @todo Comment */
		public function draw():void {
			_buttonOff.draw();
			_buttonOn.draw();

			_buttonOff.visible = !_isChecked;
			_buttonOn.visible = _isChecked;
		}



		/** @todo Comment */
		public function forceRelease():void {
			_buttonOff.forceRelease();
			_buttonOn.forceRelease();
		}



		/** @todo Comment */
		public static function releaseAll():void {
			ButtonCore.releaseAll();
		}



		/* ★ SETTERS & GETTERS ★ */


		/** @todo Comment */
		override public function get tabEnabled():Boolean {
			return button.tabEnabled;
		}



		/** @todo Comment */
		override public function set tabEnabled(enabled:Boolean):void {
			button.tabEnabled = enabled;
		}



		/** @todo Comment */
		override public function get tabIndex():int {
			return button.tabIndex;
		}



		/** @todo Comment */
		override public function set tabIndex(index:int):void {
			button.tabIndex = index;
		}



		/** @todo Comment */
		override public function get width():Number {
			return _buttonOff.width;
		}



		/** @todo Comment */
		override public function set width(value:Number):void {
		}



		/** @todo Comment */
		override public function get height():Number {
			return _buttonOff.height;
		}



		/** @todo Comment */
		override public function set height(value:Number):void {
		}



		/** @todo Comment */
		public function set areEventsEnabled(value:Boolean):void {
			_buttonOff.areEventsEnabled = value;
			_buttonOn.areEventsEnabled = value;

			this.buttonMode = value;
			this.useHandCursor = value;

			draw();
		}



		/** @todo Comment */
		public function get areEventsEnabled():Boolean {
			return _buttonOff.areEventsEnabled;
		}



		/** @todo Comment */
		public function get mouseStatus():String {
			return button.mouseStatus;
		}



		/** @todo Comment */
		public function set mouseStatus(value:String):void {
			button.mouseStatus = value;
		}



		/** @todo Comment */
		public function get debugLevel():String {
			return _debugLevel;
		}



		/** @todo Comment */
		public function set debugLevel(value:String):void {
			_debugLevel = value;

			_buttonOff.debugLevel = value;
			_buttonOn.debugLevel = value;
		}



		/** @todo Comment */
		public function get isChecked():Boolean {
			return _isChecked;
		}



		/** @todo Comment */
		public function set isChecked(value:Boolean):void {
			_isChecked = value;
			draw();
		}



		/** @todo Comment */
		public function get skin():CheckButtonSkin {
			return _skin;
		}



		/** @todo Comment */
		public function set skin(skin:CheckButtonSkin):void {
			_skin = skin;

			_buttonOff.skin = skin.buttonOffSkin;
			_buttonOn.skin = skin.buttonOnSkin;

			draw();
		}



		/** @todo Comment */
		public function get button():StaticButton {
			return (_isChecked) ? _buttonOn : _buttonOff;
		}



		/** @todo Comment */
		public function get buttonOff():StaticButton {
			return _buttonOff;
		}



		/** @todo Comment */
		public function get buttonOn():StaticButton {
			return _buttonOn;
		}



		/* ★ EVENT LISTENERS ★ */


		/** @todo Comment */
		private function onToggle(event:ButtonEvent):void {
			isChecked = !isChecked;
		}
	}
}