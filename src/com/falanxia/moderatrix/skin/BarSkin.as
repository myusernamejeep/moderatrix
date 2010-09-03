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
	import com.falanxia.emitor.*;
	import com.falanxia.moderatrix.enums.*;
	import com.falanxia.moderatrix.interfaces.*;
	import com.falanxia.utilitaris.utils.*;

	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;



	/**
	 * Bar skin.
	 *
	 * Bar skin to be used with the Bar widget.
	 *
	 * @author Vaclav Vancura @ Falanxia a.s. <vaclav@falanxia.com>
	 * @author Falanxia (<a href="http://falanxia.com">falanxia.com</a>, <a href="http://twitter.com/falanxia">@falanxia</a>)
	 * @since 1.0
	 */
	public class BarSkin extends Skin implements ISkin, IBitmapSkin {


		public static const GUIDE_BITMAP:uint = 0;
		public static const BAR_BITMAP:uint = 1;

		protected var _bitmapSources:Vector.<BitmapData>;



		/**
		 * Constructor.
		 * ID is autogenerated if it's empty
		 * @param config Config Object (optional)
		 x		 * @param id Skin ID (optional)
		 * @param asset Asset (optional)
		 */
		public function BarSkin(config:Object = null, id:String = null, asset:Asset = null) {
			super(SkinType.BAR, config, id);

			_bitmapSources = new Vector.<BitmapData>;

			_bitmapSources[GUIDE_BITMAP] = new BitmapData(1, 1, true, 0x00000000);
			_bitmapSources[BAR_BITMAP] = new BitmapData(1, 1, true, 0x00000000);

			if(asset != null) parseAsset(asset);
		}



		/**
		 * Destroys the BarSkin instance and frees it for GC.
		 */
		override public function destroy():void {
			super.destroy();

			_bitmapSources[GUIDE_BITMAP].dispose();
			_bitmapSources[BAR_BITMAP].dispose();

			_bitmapSources = null;
		}



		/**
		 * Parse asset.
		 * @param value Asset
		 * @see Asset
		 */
		public function parseAsset(value:Asset):void {
			getBitmapsFromAtlas(new <BitmapData>[
				value.getChunkByURL(_config.image).bitmap.bitmapData
			]);
		}



		/**
		 * Get bitmaps from vector of BitmapData.
		 * @param value Source vector of BitmapData
		 */
		public function getBitmapsFromAtlas(value:Vector.<BitmapData>):void {
			var bitmap:BitmapData = value[0];

			if(bitmap.width % 2 != 0) throw new Error("Width has to be multiple of 2");

			_bitmapSize.width = bitmap.width >> 1;
			_bitmapSize.height = bitmap.height;

			_bitmapSources[GUIDE_BITMAP] = BitmapUtils.crop(bitmap, new Rectangle(0, 0, _bitmapSize.width, _bitmapSize.height));
			_bitmapSources[BAR_BITMAP] = BitmapUtils.crop(bitmap, new Rectangle(_bitmapSize.width, 0, _bitmapSize.width, _bitmapSize.height));
		}



		/**
		 * Set bitmap sources BitmapData.
		 * @param value Vector of bitmap sources
		 */
		public function set bitmapSources(value:Vector.<BitmapData>):void {
			checkSize(value[GUIDE_BITMAP]);
			checkSize(value[BAR_BITMAP]);

			_bitmapSources = value;
		}



		/**
		 * Get bitmap sources BitmapData.
		 * @return Vector of bitmap sources
		 */
		public function get bitmapSources():Vector.<BitmapData> {
			return _bitmapSources;
		}



		override protected function resetSettings():Dictionary {
			var set:Dictionary = new Dictionary();

			set["paddingTop"] = 0;
			set["paddingBottom"] = 0;
			set["paddingLeft"] = 0;
			set["paddingRight"] = 0;

			return set;
		}
	}
}
