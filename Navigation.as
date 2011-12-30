package com.smp.nav
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	

	/**
	 * The menu items must be already on the stage. 
	 * They should subclass NavigationItem, even when two local classes are used to handle menu and submenu differences.
	 * Use this class to just configure the menu items, passing them in an Array. 
	 * They will be initialized with their names, ids and the model.
	 * 
	 * The class MainPage uses this Navigation class.
	 * However, you can override its createNavigation function to use a subclass or any other Navigation class from this package.
	 * 
	 */
	
	public class  Navigation extends ANavigation
	{
		
		public function Navigation() {
			
		}
		
		
		override public function init(model:INavigationModel, navigationItems:Array = null):void {
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onMenuChange);
			
			if (navigationItems) {
				initializeNavigationItems(navigationItems);
			}
			
		}
		
		/*
		* Repare-se na independência:
		* - é possível inicializar a navegação sem passar submenus, mesmo que haja subáreas no model
		* - do mesmo modo, é possível existirem subáreas no model sem afectar a navegação 
		* porque o model event change é gerido internamente aos navigationItems
		* 
		* ex. navigationItems -> new Array({menu:menu.menuItem1, submenu:new Array(submenu1.item1,submenu1.item2)}, {menu:menu.menuItem2},  {menu:menu.menuItem3})
		*/
		
		protected function initializeNavigationItems(navigationItems:Array) {
		
			var navigationItem:NavigationItem;
			for (var i:uint = 0; i < navigationItems.length; i++) 
			{
				navigationItem = navigationItems[i].menu;
				navigationItem.init(_model);
				navigationItem.title = _model.getTitle(new NavigationState(i));
				navigationItem.setId(i);
				
				if (navigationItems[i].submenu != null && typeof(navigationItems[i].submenu) == "Array") {
					for (var j:uint = 0; j < navigationItems[i].submenu.length; j++) 
					{
						(navigationItems[i].submenu[j] as NavigationItem).init(_model);
						(navigationItems[i].submenu[j] as NavigationItem).title = _model.getTitle(new NavigationState(i,j));
						(navigationItems[i].submenu[j] as NavigationItem).setId(j, i);
					}
				}
			}
	
		}
		
		//to be overriden as desired
		override protected function onMenuChange(evt:Event):void {
			//ignore...
		}
		
	}
	
}