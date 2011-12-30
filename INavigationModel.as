package com.smp.nav
{
	import flash.events.IEventDispatcher;
	
	public interface  INavigationModel extends IEventDispatcher
	{
		function setData(navData:Object = null) ;
		function getMenuLength():Number;
		function getSubmenuLength(value:NavigationState):Number;
		function get state():NavigationState ;
		function set state(value:NavigationState):void ;
		function getTitle(state:NavigationState):String  ;
		function getLabel(state:NavigationState):String ; 
		function get activeTitle():String ;
		function get activeLabel():String ;
		function get activeShortLabel():String;
		function getIndexByLabel(label:String):NavigationState ;
		function changeContentByLabel(label:String):void ;
		function set overState(value:NavigationState):void; 
		function get overState():NavigationState;
	}
	
}