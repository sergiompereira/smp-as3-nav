package com.smp.nav  {
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Singleton Class. Use getInstance instead of constructor
	 * 
	 * navData may be of type XMLList or Array. 
	 * In this last case, use an Array of objects, 
	 * where their properties would be the same as in the XMLList childnodes
	 * 
	 * Note: if a menu item has no contents (click through to the first submenu)
	 * define the optional <content> as "false"
	 * 
	 * * XMLList format:
	 * <root>
	 * 	<menu>
	 * 		<title>Prémios
	 * 		<label>premios
	 * 		<content>true
	 * 		<submenu>
	 * 			<title>Primeiros prémios
	 * 			<label>primeirospremios
	 * 		
	 * 		<submenu>
	 * 			...
	 * 
	 * * Array format:
	 * new Array(
	 * 			{label:"premios", title:"Prémios", content:"true", submenu:new Array(
	 * 					{label:"primeirospremios", title:"Primeiros prémios"},
	 * 					{label:"segundospremios", title:"Segundos prémios"}
	 * 				) 
	 * 			}, 
				{label:"participar", title:"Participar" }, 
				{label:"regulamento", title:"Regulamento" },
	 */
	
	 
	 /**
	  * Singleton...
	  */
	public class NavigationModel extends EventDispatcher implements INavigationModel
	{
		public static const MOUSE_OVER:String = "MOUSE_OVER";
		
		protected var _navData:*;	
		protected var _dataFormat:String;
		protected var _navigationState:NavigationState = new NavigationState();
		protected var _overState:NavigationState = new NavigationState();
		
		private static var _instance:NavigationModel;
		
		public function NavigationModel(inst:PrivateClass) {
			
		}
		
		public static function getInstance():NavigationModel {
			if (NavigationModel._instance == null) {
				NavigationModel._instance = new NavigationModel(new PrivateClass());
			}
			return NavigationModel._instance;
		}
		
		public function setData(navData:Object = null) 
		{	
			if (typeof(navData) == "object")
			{
				_navData = navData;
				_dataFormat = "Array";
			}
			else if (typeof(navData) == "xml") 
			{
				_navData = navData;
				_dataFormat = "Xml";
			}else {
				throw new Error("NavigationModel > constructor: Data object is of wrong type. Use Array or XMLList. Also, check whether Xml is properly formated");
			}
		}
	
		
		public function getMenuLength():Number
		{
			if (_dataFormat == "Array") {
				return _navData.length;
			}else if (_dataFormat == "Xml") {
				return _navData.length();
			}
			
			return 0;
		}
		
		public function getSubmenuLength(state:NavigationState):Number
		{
			if(_navData[state.menuId].submenu != null){
				if(_dataFormat == "Array"){
					return _navData[state.menuId].submenu.length;
				}else if (_dataFormat == "Xml") {
					return _navData[state.menuId].submenu.length();
				}
			}	
			
			return 0;
		}
		
		/**
		 * Returns a new NavigationState instance, so the getter is not used to change state
		 * e.g. model.state.menuId = 1 doesn't change the inner state.
		 * In model.state.menuId, state is invoked as a getter.
		 */
		public function get state():NavigationState {
		
			return new NavigationState(_navigationState.menuId, _navigationState.submenuId);
		}
		
		public function set state(value:NavigationState):void {

			if (value.menuId != _navigationState.menuId || value.submenuId != _navigationState.submenuId)
			{ 
				if (_navData[value.menuId].content != null) {
					if (value.menuId > -1 && value.submenuId == -1 && _navData[value.menuId].content == "false") {
						value.submenuId = 0;
					}
				}

				_navigationState = value;
				
				if (value.menuId == -1) {
					_overState = new NavigationState();
				}
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		public function getTitle(state:NavigationState):String 
		{		
			if (state.submenuId == -1) {
				return _navData[state.menuId].title;
			}else {
				return _navData[state.menuId].submenu[state.submenuId].title;
			}
			
			return "";
		}
		
		public function getLabel(state:NavigationState):String 
		{		
			if(state.submenuId == -1){
				return _navData[state.menuId].label;
			}else {
				return _navData[state.menuId].label+"/"+_navData[state.menuId].submenu[state.submenuId].label;
			}
			
			return "";
		}
		
		public function get activeTitle():String 
		{						
			if (_navigationState.menuId > -1) 
			{		
				if(_navigationState.submenuId == -1){
					return _navData[_navigationState.menuId].title;
				}else {
					return _navData[_navigationState.menuId].submenu[_navigationState.submenuId].title;
				}
			}else {
				handleInactiveState();
			}
			
			return "";
		}
		
		public function get activeLabel():String
		{
			if (_navigationState.menuId > -1)
			{		
				if(_navigationState.submenuId == -1){
					return _navData[_navigationState.menuId].label;
				}else {
					return _navData[_navigationState.menuId].label+"/"+_navData[_navigationState.menuId].submenu[_navigationState.submenuId].label;
				}
			}else {
				handleInactiveState();
			}
			
			return "";
		}
		
		public function get activeShortLabel():String 
		{
			if (_navigationState.menuId > -1)
			{
				if(_navigationState.submenuId == -1){
					return _navData[_navigationState.menuId].label;
				}else {
					return _navData[_navigationState.menuId].submenu[_navigationState.submenuId].label;
				}
			}else {
				handleInactiveState();
			}
			
			return "";
		}
		
		public function getIndexByLabel(label:String):NavigationState {
						
			var menuLength:Number;
			var submenuLength:Number;
			var navState:NavigationState = new NavigationState();
			
			var labels:Array = label.split("/");
			
			if(_dataFormat == "Array"){
				menuLength = _navData.length;
			}else if (_dataFormat == "Xml") {
				menuLength = _navData.length();
			}
					
					
				
			for (var i:int = 0; i < menuLength; i++) 
			{
				if (_navData[i].label == labels[0]) 
				{
					navState.menuId = i;
					
					if (labels.length > 1) 
					{
						if(_dataFormat == "Array"){
							submenuLength = _navData[i].submenu.length;
						}else if (_dataFormat == "Xml") {
							submenuLength = _navData[i].submenu.length();
						}
						
						for (var j:int = 0; j < submenuLength; j++) 
						{
							if (_navData[i].submenu[j].label == labels[1]) 
							{
								navState.submenuId = j;
								break;
							}
							
						}
					}
					
					break;
				}
			}
			
			return navState;
			
		}
		
		public function changeContentByLabel(label:String):void {
			
			var navState:NavigationState = getIndexByLabel(label);
			
			if (navState.menuId > -1) {
				this.state = navState;
			}else {
				//default
				this.state = new NavigationState(0);
			}
			
		}
		
		public function set overState(value:NavigationState):void {
			_overState = value;
			if(_overState.menuId > -1){
				dispatchEvent(new Event(NavigationModel.MOUSE_OVER));
			}
		}
		
		public function get overState():NavigationState {
			return _overState;
		}
		
		private function handleInactiveState():void {
			throw new IOError("NavigationModel : State is set to none. Navigation should be inactive.");
		}
	}
	
	
}

class PrivateClass {
	public function PrivateClass() {
		//
	}
}
