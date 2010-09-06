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

package com.falanxia.moderatrix.skin.meta {
	import com.falanxia.moderatrix.enums.*;
	import com.falanxia.moderatrix.interfaces.*;
	import com.falanxia.moderatrix.skin.*;
	import com.falanxia.utilitaris.utils.*;

	import flash.display.*;
	import flash.geom.*;



	/**
	 * Glyph skin.
	 *
	 * Glyph skin to be used with the Glyph widget.
	 *
	 * @author Vaclav Vancura @ Falanxia a.s. <vaclav@falanxia.com>
	 * @author Falanxia (<a href="http://falanxia.com">falanxia.com</a>, <a href="http://twitter.com/falanxia">@falanxia</a>)
	 * @since 1.0
	 */
	public class GlyphSkin extends Skin implements ISkin {


		protected var _glyphOutSkin:ImageSkin;
		protected var _glyphHoverSkin:ImageSkin;
		protected var _glyphFocusSkin:ImageSkin;



		/**
		 * Constructor.
		 * ID is autogenerated if it's empty
		 * @param config Config Object (optional)
		 * @param id Skin ID (optional)
		 */
		public function GlyphSkin(config:Object, id:String = null) {
			_glyphOutSkin = new ImageSkin(config, id + "#glyphOut");
			_glyphHoverSkin = new ImageSkin(config, id + "#glyphHover");
			_glyphFocusSkin = new ImageSkin(config, id + "#glyphFocus");

			super(SkinType.GLYPHS, config, id);
		}



		/**
		 * Destroys the GlyphSkin instance and frees it for GC.
		 */
		override public function destroy():void {
			super.destroy();

			_glyphOutSkin.destroy();
			_glyphHoverSkin.destroy();
			_glyphFocusSkin.destroy();

			_glyphOutSkin = null;
			_glyphHoverSkin = null;
			_glyphFocusSkin = null;
		}



		/**
		 * Get bitmaps from vector of BitmapData.
		 * @param value Source vector of BitmapData
		 */
		public function getBitmapsFromAtlas(value:Vector.<BitmapData>):void {
			var bitmap:BitmapData = value[0];

			if(bitmap.width % 3 != 0) throw new Error("Width has to be multiple of 3");

			_bitmapSize.width = bitmap.width / 3;
			_bitmapSize.height = bitmap.height;

			_glyphOutSkin.getBitmapsFromAtlas(new <BitmapData>[
				BitmapUtils.crop(bitmap, new Rectangle(0, 0, _bitmapSize.width, _bitmapSize.height))
			]);

			_glyphHoverSkin.getBitmapsFromAtlas(new <BitmapData>[
				BitmapUtils.crop(bitmap, new Rectangle(_bitmapSize.width, 0, _bitmapSize.width, _bitmapSize.height))
			]);

			_glyphFocusSkin.getBitmapsFromAtlas(new <BitmapData>[
				BitmapUtils.crop(bitmap, new Rectangle(_bitmapSize.width << 1, 0, _bitmapSize.width, _bitmapSize.height))
			]);
		}



		/**
		 * Parse config Object.
		 * @param value Config Object
		 */
		override public function parseConfig(value:Object):void {
			super.parseConfig(value);

			_glyphOutSkin.parseConfig(value);
			_glyphHoverSkin.parseConfig(value);
			_glyphFocusSkin.parseConfig(value);
		}



		/**
		 * Revert config to the last known state.
		 */
		override public function revertConfig():void {
			super.revertConfig();

			_glyphOutSkin.revertConfig();
			_glyphHoverSkin.revertConfig();
			_glyphFocusSkin.revertConfig();
		}



		/**
		 * Get out glyph skin.
		 * @return Out glyph skin
		 */
		public function get glyphOutSkin():ImageSkin {
			return _glyphOutSkin;
		}



		/**
		 * Set out glyph skin.
		 * @param source Out glyph skin
		 */
		public function set glyphOutSkin(source:ImageSkin):void {
			_glyphOutSkin = source;
		}



		/**
		 * Get hover glyph skin.
		 * @return Hover glyph skin
		 */
		public function get glyphHoverSkin():ImageSkin {
			return _glyphHoverSkin;
		}



		/**
		 * Set hover glyph skin.
		 * @param source Hover glyph skin
		 */
		public function set glyphHoverSkin(source:ImageSkin):void {
			_glyphHoverSkin = source;
		}



		/**
		 * Get focus glyph skin.
		 * @return Focus glyph skin
		 */
		public function get glyphFocusSkin():ImageSkin {
			return _glyphFocusSkin;
		}



		/**
		 * Set focus glyph skin.
		 * @param source Focus glyph skin
		 */
		public function set glyphFocusSkin(source:ImageSkin):void {
			_glyphFocusSkin = source;
		}
	}
}