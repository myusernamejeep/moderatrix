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

package com.falanxia.moderatrix.skin {
	import com.falanxia.moderatrix.interfaces.ISkin;
	import com.falanxia.utilitaris.utils.DisplayUtils;
	import com.falanxia.utilitaris.utils.ObjectUtils;
	import com.falanxia.utilitaris.utils.RandomUtils;

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;



	/**
	 * Skin.
	 *
	 * Parent of all widget skins.
	 *
	 * @author Vaclav Vancura @ Falanxia a.s. <vaclav@falanxia.com>
	 * @author Falanxia (<a href="http://falanxia.com">falanxia.com</a>, <a href="http://twitter.com/falanxia">@falanxia</a>)
	 * @since 1.0
	 */
	public class Skin implements ISkin {


		protected var _id:String;
		protected var _type:String;
		protected var _bitmapSize:Rectangle = new Rectangle(0, 0, 0, 0);
		protected var _config:Object = new Object();
		protected var _settings:Dictionary;

		private var prevConfig:Object;
		private var oldSettings:Dictionary;



		/**
		 * Constructor.
		 * ID is autogenerated if it's empty
		 * @param type Skin type
		 * @param config Config Object (optional)
		 * @param id Skin ID (optional)
		 * @see SkinType
		 */
		public function Skin(type:String, config:Object = null, id:String = null):void {
			_type = type;
			_id = _id == null ? type + ":skin:" + RandomUtils.randomString() : id;

			_settings = resetSettings();
			oldSettings = new Dictionary();

			ObjectUtils.assign(oldSettings, _settings);

			if(config != null) parseConfig(config);
		}



		/**
		 * Destroys Skin instance and frees it for GC.
		 */
		public function destroy():void {
			_id = null;
			_type = null;
			_bitmapSize = null;
			_config = null;
			_settings = null;

			prevConfig = null;
			oldSettings = null;
		}



		/**
		 * Parse config Object.
		 * Placeholder to be overridden via child skins.
		 * @param value Config Object
		 */
		public function parseConfig(value:Object):void {
			_config = value;

			prevConfig = _config;

			ObjectUtils.assign(oldSettings, _settings);

			for(var i:String in value) {
				if(i != "filters") {
					_settings[i] = value[i];
				}
			}

			if(value.filters != undefined && value.filters is Array) {
				for each(var f:* in value.filters) {
					if(f is BitmapFilter) {
						// bitmapFilter means we got filter already converted
						_settings.filters.push(f);
					}
					else {
						if(f is Object) {
							// it's an Object, we need to convert it first
							try {
								switch(f.filter) {
									case "DropShadow" :
										var dsDistance:Number = (f.distance == undefined) ? 1 : f.distance;
										var dsAngle:Number = (f.angle == undefined) ? 45 : f.angle;
										var dsColor:Number = (f.color == undefined) ? 0x000000 : f.color;
										var dsAlpha:Number = (f.alpha == undefined) ? 0.5 : f.alpha;
										var dsBlur:Number = (f.blur == undefined) ? 1 : f.blur;
										var dsStrength:Number = (f.strength == undefined) ? 1 : f.strength;
										var dsQuality:Number = (f.quality == undefined) ? 1 : f.quality;
										var dsInner:Boolean = (f.inner == undefined) ? false : f.inner;
										var dsKnockout:Boolean = (f.knockout == undefined) ? false : f.knockout;
										var dsHideObject:Boolean = (f.hideObject == undefined) ? false : f.hideObject;
										var g:DropShadowFilter = new DropShadowFilter(dsDistance, dsAngle, dsColor, dsAlpha, dsBlur, dsBlur, dsStrength, dsQuality, dsInner, dsKnockout, dsHideObject);

										_settings.filters.push(g);

										break;

									default:
								}
							}
							catch(err:Error) {
								throw new Error("Error converting filters Object to native filters (" + err.message + ")");
							}
						}
					}
				}
			}
		}



		/**
		 * Revert config to the last stored state.
		 * Placeholder to be overridden via child skins.
		 */
		public function revertConfig():void {
			_config = prevConfig;
			_settings = new Dictionary();

			ObjectUtils.assign(_settings, oldSettings);

			oldSettings = resetSettings();
		}



		/**
		 * Get skin ID.
		 * @return Skin ID
		 */
		public function get id():String {
			return _id;
		}



		/**
		 * Get skin type.
		 * @return Skin type
		 * @see SkinType
		 */
		public function get type():String {
			return _type;
		}



		/**
		 * Get bitmap size.
		 * @return Bitmap size
		 */
		public function get bitmapSize():Rectangle {
			return _bitmapSize;
		}



		/**
		 * Get config Object.
		 * @return Config Object
		 */
		public function get config():Object {
			return _config;
		}



		/**
		 * Get current settings.
		 * @return Current settings
		 */
		public function get settings():Dictionary {
			return _settings;
		}



		protected function getSkinSize(source:MovieClip, frame:Object):void {
			// it's needed to duplicate this MovieClip as there was some weird bug:
			// when used source.gotoAndStop(frame) on one of next lines,
			// all future getChildByName() on this source failed.
			var duplicate:MovieClip = DisplayUtils.duplicateMovieClip(source);

			duplicate.gotoAndStop(frame);

			_bitmapSize.width = duplicate.width;
			_bitmapSize.height = duplicate.height;
		}



		protected function checkSize(source:BitmapData):void {
			if(_bitmapSize.width == 0 && _bitmapSize.height == 0) {
				// size is not specified, set initial values
				_bitmapSize.width = source.width;
				_bitmapSize.height = source.height;
			}

			else {
				if(source.width != _bitmapSize.width || source.height != _bitmapSize.height) {
					// size mismatch
					throw new Error("Sizes have to match");
				}
			}
		}



		protected function resetSettings():Dictionary {
			return new Dictionary();
		}
	}
}
