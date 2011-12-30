package com.smp.nav
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.text.TextField;
	
	
	/*
	 * Os swf/MovieClips devem ter um stop() no primeiro frame
	 * Este frame deve estar vazio.
	 * Devem ter o segundo frame com o label IN
	 * Dever ter um frame OUT no início da animação de fecho
	 * A função start() desloca a playhead para o frame IN enquanto a close o faz para o frame OUT
	 * Devem ter um dispatchEvent(new Event(Event.CLOSE)) no último frame (timeline)
	 * Não devem ter stop() no último frame
	 * 
	 */
	
	public class  InternalPage extends MovieClip
	{
		
		protected var _model:INavigationModel;
		
		public function InternalPage() {
			
		}
		
		public function init(model:INavigationModel):void {
			_model = model;
		}
		
		
		public function start():void {
			gotoAndPlay("IN");
		}
		
		public function close():void {
			gotoAndPlay("OUT");
		}
	}
	
}