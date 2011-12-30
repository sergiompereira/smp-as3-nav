package com.smp.nav.ui
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.smp.nav.INavigationModel;
	import com.smp.nav.NavigationState;

	import com.smp.common.utils.Utils;
	
	
	public class  NavigationItemInterface extends EventDispatcher
	{
		
		protected var _model:INavigationModel;
		protected var _interface:InteractiveObject;
		protected var _interfaceStates:Boolean;
		protected var _id:uint;
		protected var _parentId:int;
		protected var _title:String;
		protected var _link:String = "";
		protected var _active:Boolean = false;
		
		
		public function NavigationItemInterface() {
			
			
			
		}
		
		
		/**
		 * 
		 * @param	model
		 * @param	interfaceobj
		 * @param	interfaceStates	: if set to true, frame labels OVER, OUT, UP and ACTIVE will be used to change interface visual state.
		 */
		public function init(model:INavigationModel, interfaceobj:InteractiveObject, interfaceStates:Boolean = true):void {
			
			_model = model;
			_interface = interfaceobj;
			_interfaceStates = interfaceStates;
			
			/*if(_interface as MovieClip){
				(_interface as MovieClip).buttonMode = true;
			}*/
			
			_interface.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			_interface.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			_interface.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			_model.addEventListener(Event.CHANGE, onMenuChange);
			
			
		}

		
		private function onOver(evt:MouseEvent):void {
	
			if(_parentId == -1){
				_model.overState = new NavigationState(_id);
			}else {
				_model.overState = new NavigationState(_parentId, _id);
			}
				
			if (this.active == false) 
			{	
				OverFnc();
			}		
			
		}
		
		private function onOut(evt:MouseEvent):void {
			
			//_model.overState = new NavigationState();
			
			if (this.active == false) 
			{
				
				OutFnc();
			}
		}
		
		private function onUp(evt:MouseEvent):void {
			
			if (this.active == false || _model.state.submenuId > -1)
			{
				if(_parentId == -1){
					_model.state = new NavigationState(_id);
				}else {
					_model.state = new NavigationState(_parentId, _id);
				}
				UpFnc();
			}
			
			if (_link != "")
			{
				Utils.goUrl(_link, "_self");
			}
			
		}
		
		protected function OverFnc():void 
		{
			
			if (_interfaceStates)
			{
				(_interface as MovieClip).gotoAndPlay("OVER");
			}
		}
		
		protected function OutFnc():void 
		{
			if (_interfaceStates)
			{
				(_interface as MovieClip).gotoAndPlay("OUT");
			}
		}
		
		protected function UpFnc():void 
		{
			if (_interfaceStates)
			{
				(_interface as MovieClip).gotoAndPlay("UP");
			}
		}
		
		
		protected function onMenuChange(evt:Event):void {
			//if this is a menu item
			if(_parentId == -1){
				if (_model.state.menuId != _id && this.active == true) {
					this.active = false;
					this.OutFnc();
					
				}else if (_model.state.menuId == this.id) {
					this.active = true;
					this.UpFnc();
				}
			}else {
				//if this is a submenu item
				if ((_model.state.menuId != _parentId || _model.state.submenuId != _id) && this.active == true) {
					this.active = false;
					this.OutFnc();
					
				}else if (_model.state.menuId == _parentId && _model.state.submenuId == _id) {
					this.active = true;
					this.UpFnc();
				}
			}
		}
		
		public function set active(value:Boolean):void {
			_active = value;
			
			if(_interfaceStates){
				switch(_active) {
					case true:
						(_interface as MovieClip).gotoAndPlay("ACTIVE");
						
						break;
					
					case false:
						(_interface as MovieClip).gotoAndPlay("OUT");
					
						break;
				}
			}
		
		}
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set link(sLink:String):void {
			_link = sLink;
		}
		
		public function setId(value:uint, parentValue:int = -1):void {
			_id = value;
			_parentId = parentValue;
			
		}
		
		public function get id():uint {
			return _id ;
		}
		
		public function get parentId():int {
			return _parentId ;
		}
		
		public function set title(value:String):void {
			_title = value;
		}
		
		public function get title():String {
			return _title;
		}
		
		
	}
	
}