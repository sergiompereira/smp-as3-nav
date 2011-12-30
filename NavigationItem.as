package com.smp.nav
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	
	import com.smp.common.utils.Utils
	
	public class  NavigationItem extends MovieClip
	{
		
		protected var _model:INavigationModel;
		protected var _id:uint;
		protected var _parentId:int;
		protected var _title:String;
		protected var _link:String = "";
		protected var _active:Boolean = false;
		
		protected var menu_txt:TextField;
		
		protected var _textformatActive:TextFormat = new TextFormat();
		protected var _textformatOver:TextFormat = new TextFormat();
		protected var _textformatOut:TextFormat = new TextFormat();
		
		
		
		
		
		public function NavigationItem() {
			
			
			
		}
		
		public function init(model:INavigationModel):void {
			
			_model = model;
			
			buttonMode = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			_model.addEventListener(Event.CHANGE, onMenuChange);
			
			
		}
		
		//to be set by the subclass
		protected function set textField(value:TextField):void {
			menu_txt = value;
			menu_txt.autoSize = TextFieldAutoSize.LEFT;
			menu_txt.mouseEnabled = false;
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
			
			if (menu_txt)
			{
				menu_txt.setTextFormat(_textformatOver);
			}
		}
		
		protected function OutFnc():void 
		{
			if (menu_txt)
			{
				menu_txt.setTextFormat(_textformatOut);
			}
		}
		
		protected function UpFnc():void 
		{
			if (menu_txt)
			{
				menu_txt.setTextFormat(_textformatActive);
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
			
			if(menu_txt){
				switch(_active) {
					case true:
						menu_txt.setTextFormat(_textformatActive);
						
						break;
					
					case false:
						menu_txt.setTextFormat(_textformatOut);
					
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
			if (menu_txt){
				menu_txt.text = _title;
			}
		}
		
		public function get title():String {
			return _title;
		}
		
		
		public function setOverFormat(format:TextFormat):void {
			_textformatOver = format;
		}
		
		public function setOutFormat(format:TextFormat):void {
			_textformatOut = format;
		}
		
		public function setActiveFormat(format:TextFormat):void {
			_textformatActive = format;
		}
		
		public function get textWidth():Number {
			if (menu_txt){
				return menu_txt.textWidth;
			}
			return 0;
		}
		
		public function get textHeight():Number {
			if (menu_txt){
				return menu_txt.textHeight;
			}
			return 0;
		}
	}
	
}