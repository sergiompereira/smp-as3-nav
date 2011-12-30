package com.smp.nav
{
	 
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import com.smp.common.utils.Utils;
	

	
	public class  UrlLinkManager extends EventDispatcher
	{
				
		private var _model:INavigationModel;				
		
		//browser debugging
		import flash.net.URLRequest;
		import flash.net.navigateToURL;
		
		
		public function UrlLinkManager() {
			
		}
		
		public function Init(model:INavigationModel):void {
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onNavChange);
			
		}
		
		private function onNavChange(evt:Event):void {
			changeContent();
		}
		
		
		private function changeContent():void {			
			gotoContent();
		}
		
		
		private function gotoContent():void 
		{				
			Utils.goUrl(_model.activeShortLabel + ".html", "_self");

		}
		

	}
	
}