package com.smp.nav
{
 
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
		
	import com.smp.common.display.loaders.DisplayObjectLoader;
	import com.smp.common.display.DisplayObjectUtilities;
	
	
	
	/**
	 * Os swf devem ter o mesmo nome do respectivo label, sejam menus ou submenus (ver NavigationModel)
	 * 
	 * Os swf devem ter um stop() no primeiro frame
	 * Este frame deve estar vazio.
	 * Devem ter o segundo frame com o label IN
	 * Dever ter um frame OUT no início da animação de fecho
	 * Devem declarar duas funções start() e close() (por exemplo, associando a classe InternalPage com document class)
	 * A função start() desloca a playhead para o frame IN enquanto a close o faz para o frame OUT
	 * Devem ter um dispatchEvent(new Event(Event.CLOSE)) no último frame
	 * Não devem ter stop() no último frame
	 * 
	 * 
	 */
	
	public class  SwfManager extends EventDispatcher
	{
				
		protected var _model:INavigationModel;
		protected var _container:MovieClip;
		
		protected var _swfBasePath:String;
		protected var _transitionInFnc:Function;
		protected var _transitionOutFnc:Function;
		protected var _preloadFnc:Function;
				
		protected var _swfCollection:Array = new Array();
		protected var _swf:DisplayObjectLoader;
		protected var _activeSwfIndex:String;
		
		
		public function SwfManager() {
			
		}
		
		public function Init(model:INavigationModel, container:MovieClip, swfBasePath:String = "", transitionInFnc:Function = null, transitionOutFnc:Function = null, preloadFnc:Function = null):void {
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onNavChange);
			_container = container;
			
			_swfBasePath = swfBasePath;
			_transitionInFnc = transitionInFnc;
			_transitionOutFnc = transitionOutFnc;
			_preloadFnc = preloadFnc;
		}
		
		public function get activeSwf():MovieClip 
		{
			if(_swf.content != null){
				return _swf.content;
			}
			return null;
		}

		
		protected function onNavChange(evt:Event):void 
		{
			
			if(_model.state.menuId > -1){
				unloadContent();
			}else if (_model.state.menuId == -1) {
				handleRemove();
			}
		}
		
		
		protected function unloadContent():void {

			if (_swfCollection.length == 0 || !_swf)
			{	
				loadContent(_swfBasePath+"/"+_model.activeShortLabel+".swf");
			}else {
				handleClose();
			}
			
			
		}
		
		protected function handleClose():Boolean {
			try{
				(_swf.content as MovieClip).addEventListener(Event.CLOSE, onSwfChange);
				(_swf.content as MovieClip).close();
				return true;
			}catch (err:Error) {
				//ignore
				return false;
			}
			
			return false;
		}
		
		protected function onSwfChange(evt:Event ):void 
		{
			(_swf.content as MovieClip).removeEventListener(Event.CLOSE, onSwfChange);
			_container.removeChild(_swf);
			_swf = null;
			dispatchEvent(new Event(Event.CHANGE));
			loadContent(_swfBasePath+"/"+_model.activeShortLabel+".swf");
		}
		
		
		protected function handleRemove():Boolean {
			try{
				(_swf.content as MovieClip).addEventListener(Event.CLOSE, onSwfRemove);
				(_swf.content as MovieClip).close();
				return true;
			}catch (err:Error) {
				//ignore
				return false;
			}
			return false;
		}
		
		protected function onSwfRemove(evt:Event):void 
		{
			
			(_swf.content as MovieClip).removeEventListener(Event.CLOSE, onSwfRemove);
			_container.removeChild(_swf);
			_swf = null;
			dispatchEvent(new Event(Event.UNLOAD));
		}
		
		protected function loadContent(content:String):void {
			
			if(_transitionInFnc != null){
				_transitionInFnc();
			}
			
			var loaded:Boolean = false;
			_activeSwfIndex = _model.state.menuId.toString() + _model.state.submenuId.toString();
			
			for (var k:uint = 0; k < _swfCollection.length; k++) {
				if(_swfCollection[k][1] == _activeSwfIndex){
					_swf = _swfCollection[k][0];
					if(_transitionOutFnc != null){
						_transitionOutFnc();
					}
					(_swf.content as MovieClip).start();
					
					dispatchEvent(new Event(Event.COMPLETE));
					
					loaded = true;
					break;
				}
			}
			
			if (loaded == false) {
				var loader:DisplayObjectLoader = new DisplayObjectLoader("", true);
				loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_swfCollection.push(new Array(loader, _activeSwfIndex));
				(_swfCollection[_swfCollection.length - 1][0] as DisplayObjectLoader).load(content);
				(_swfCollection[_swfCollection.length - 1][0] as DisplayObjectLoader).addEventListener(Event.COMPLETE, onContentReady);
				_swf = (_swfCollection[_swfCollection.length - 1][0] as DisplayObjectLoader);
			}
			
			_container.addChild(_swf);
			
			//debug
			trace(content + " // " +  _activeSwfIndex);
		
		}
		
		protected function onProgress(evt:ProgressEvent):void 
		{
			var perc = (evt.currentTarget as DisplayObjectLoader).loadedPercent;
			if(_preloadFnc != null){
				_preloadFnc(perc);
			}
			if (perc == 100) {
				//
			}
		
		}
		
		protected function onContentReady(evt:Event):void 
		{
			if(_transitionOutFnc != null){
					_transitionOutFnc();
				}
				
				(_swf.content as MovieClip).start();
				
				dispatchEvent(new Event(Event.COMPLETE));
		}
	
	}
	
}