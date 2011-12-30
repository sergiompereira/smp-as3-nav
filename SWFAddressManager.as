package com.smp.nav
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.asual.swfaddress.*;
	
	
	public class  SWFAddressManager extends EventDispatcher
	{
		public var baseTitle:String = "";
		
		protected var _model:INavigationModel;
		protected var _init:Boolean = false;

		
		public function SWFAddressManager(){

			
		}
		
		public function Init(model:INavigationModel):void {
			
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onChange);
		
			//first load
			if (SWFAddress.getValue() != "/") {
				//ignored : automaticaly called on onChange...
				//changeContent(SWFAddress.getValue());
			}
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onNavigationChange);
			
		}
		
		protected function onChange(evt:SWFAddressEvent):void 
		{
			//debug:
			//SWFAddress.setTitle("onChange: swfaddress"+ evt.value.substring(1) +" model active:"+ _model.activeLabel);
			
			if (!_init) 
			{
				_init = true;
				
				/*
				 * Avoids calling a _model change on first load if the url is the root
				 * So it is left to the Main class to set the initial model state
				 * If the initial url is not the root, then SwfAddressManager will change the model 
				 * and override any default state previously set elsewhere in the application
				 */
				
				if (SWFAddress.getValue() != "/") {
					changeContent(evt.value);
				}
				
			}
			else if (_model.state.menuId == -1)
			{
				//ignores any idle navigation if an url has been submited on the browser
				changeContent(evt.value);
			}
			else
			{
				//this condition avoids a code loop ...
				if(evt.value.substring(1) != _model.activeLabel) {
					changeContent(evt.value);
				}
			}
		}
		
		protected function changeContent(value:String):void
		{	
			_model.changeContentByLabel(value.substring(1));		
		}

		protected function onNavigationChange(evt:Event):void 
		{			
			
			var address:String = SWFAddress.getValue().substring(1);
			var ls:int = address.lastIndexOf("/");
			address = address.substring(0, ls);
			
			if (_model.state.menuId > -1 && _model.activeLabel != address)
			{
				SWFAddress.setValue(_model.activeLabel);
				
				if(SWFAddress.getValue() != "/"){
					SWFAddress.setTitle(baseTitle+ _model.activeTitle);
				}else{
					SWFAddress.setTitle(baseTitle);
				}
				
				//não é necessário invocar o google analytics. O próprio SWFAddress reconhece se o js existe na página.
				//navigateToURL(new URLRequest("javascript:pageTracker._trackPageview('"+evt+"'); void(0);"), "_self");
			}
		}
	}
	
}