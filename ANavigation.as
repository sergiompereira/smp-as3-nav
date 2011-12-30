package com.smp.nav
{

	

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.errors.IllegalOperationError;

	import com.smp.common.display.DisplayObjectUtilities;
	

	/**
	 * Use this class to configurate the menu items already instanciated on the stage.
	 * The class MainPage uses this one, however, you can override its createNavigation function to use a subclass
	 * like for instance NavigationBuilder
	 */
	public class  ANavigation
	{
		
		protected var _model:INavigationModel;
		
		/**
		 * Abstract class. Must be extended and all non private methods overriden.
		 */
		public function ANavigation() {
			
		}
		
		//to be overriden as desired
		public function init(model:INavigationModel, navigationItems:Array = null):void {
			
			throw new IllegalOperationError("ANavigation > init: Abstract class. Must be extended and this method overriden.");
			return null;
			
		}
		
		
		//to be overriden as desired
		protected function onMenuChange(evt:Event):void {
			throw new IllegalOperationError("ANavigation > onMenuChange: Abstract class. Must be extended and this method overriden.");
			return null;
		}
		
	}
	
}