package com.smp.nav.ui{


	import flash.events.Event;
	
	import com.smp.nav.ANavigation;
	import com.smp.nav.INavigationModel;
	import com.smp.nav.NavigationState;
	import com.smp.nav.ui.NavigationItemInterface;
	
	

	/**
	 * The menu items must be already on the stage. 
	 * They can be any interactive objects, event without any custom class associated with them and even being different library items.
	 * Their labels/titles and states must be drawn on the stage and in the timeline (use OVER, OUT, UP and ACTIVE as frame labels)
	 * Use this class to just passe them in an Array. 
	 * They will be initialized with their ids and the model, and their mouse events will be intercepted.
	 * 
	 */
	
	public class  NavigationStatic extends ANavigation
	{
		
		protected var _interfaceStates:Boolean;
		
		
		public function NavigationStatic(interfaceStates:Boolean = true) {
			_interfaceStates = interfaceStates;
		}
		
		/**
		 * 
		 * @param	model
		 * @param	navigationItems	:	new Array({menu:menu.menuItem1, submenu:new Array(submenu1.item1,submenu1.item2)}, {menu:menu.menuItem2},  {menu:menu.menuItem3})
		 */
		override public function init(model:INavigationModel, navigationItems:Array = null ):void {
			
			_model = model;
			_model.addEventListener(Event.CHANGE, onMenuChange);
			
			
			if (navigationItems) {
				
				initializeNavigationItems(navigationItems);
			}
			
		}
		
		/**
		* Repare-se na independência:
		* - é possível inicializar a navegação sem passar submenus, mesmo que haja subáreas no model
		* - do mesmo modo, é possível existirem subáreas no model sem afectar a navegação 
		* porque o model event change é gerido internamente aos navigationItems
		* 
		* ex. navigationItems -> new Array({menu:menu.menuItem1, submenu:new Array(submenu1.item1,submenu1.item2)}, {menu:menu.menuItem2},  {menu:menu.menuItem3})
		*/
		
		protected function initializeNavigationItems(navigationItems:Array) {
		
			var navigationItem:NavigationItemInterface;
			for (var i:uint = 0; i < navigationItems.length; i++) 
			{
				navigationItem = new NavigationItemInterface();
				navigationItem.init(_model, navigationItems[i].menu, _interfaceStates);
				navigationItem.title = _model.getTitle(new NavigationState(i));
				navigationItem.setId(i);
				
				if (navigationItems[i].submenu != null && typeof(navigationItems[i].submenu) == "Array") {
					
					var navigationSubItem:NavigationItemInterface;
					for (var j:uint = 0; j < navigationItems[i].submenu.length; j++) 
					{
						navigationSubItem = new NavigationItemInterface();
						navigationSubItem.init(_model, navigationItems[i].submenu[j], _interfaceStates);
						navigationSubItem.title = _model.getTitle(new NavigationState(i,j));
						navigationSubItem.setId(j, i);
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