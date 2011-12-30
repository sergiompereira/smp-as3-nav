package com.smp.nav
{
	
	 
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	 * O _container deve ter frames como os mesmos labels que lhes correpondem no model.
	 * Os MovieClips (dentro do _container, em cada frame label) devem ter como instance name o mesmo do label.
	 * 
	 * Devem ter um stop() no primeiro frame
	 * Este frame deve estar vazio.
	 * Devem ter o segundo frame com o label IN
	 * Dever ter um frame OUT no início da animação de fecho
	 * Devem declarar duas funções start() e close() (por exemplo, associando a classe InternalPage com document class)
	 * A função start() desloca a playhead para o frame IN enquanto a close o faz para o frame OUT
	 * Devem ter no último frame um dispatchEvent(new Event(Event.CLOSE))
	 * Não devem ter stop() no último frame
	 * 
	 * Para os MovieClips que pertencem a subáreas (submenus) deve funcionar de modo idêntico
	 * com os mesmos labels que lhes correpondem no model.
	 * 
	 */

	public class  TimelineManager extends EventDispatcher
	{
				
		private var _model:INavigationModel;
		private var _container:MovieClip;
		private var _init:Boolean = false;
		private var _activeMc:MovieClip;
		
		private var _timer:Timer = new Timer(2000, 1);
		
		
		//browser debugging
		import flash.net.URLRequest;
		import flash.net.navigateToURL;
		
		
		public function TimelineManager() {
			
		}
		
		public function Init(model:INavigationModel, container:MovieClip):void {
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onNavChange);
			_container = container;
			
		}
		
		private function onNavChange(evt:Event):void {
			changeContent();
		}
		
		
		private function changeContent():void {
			
			if (!_init) {
				_init = true;
				gotoContent();
				
			}else {
				
				_activeMc.addEventListener(Event.CLOSE, onContentClosed);
				_activeMc.close();
			}
			
			
		}
		
		private function onContentClosed(evt:Event ):void {
			_activeMc.removeEventListener(Event.CLOSE, onContentClosed);
			gotoContent();
			
		}
		
		private function gotoContent():void 
		{				
			_container.gotoAndStop(_model.activeShortLabel);
			_container.addEventListener(Event.ENTER_FRAME, onNewFrame);

			
		}
		
		private function onNewFrame(evt:Event):void 
		{
			_container.removeEventListener(Event.ENTER_FRAME, onNewFrame);
			
			_activeMc = _container[_model.activeShortLabel]
			_activeMc.start();
			
			dispatchEvent(new Event(Event.COMPLETE));
		
		}
		

	}
	
}