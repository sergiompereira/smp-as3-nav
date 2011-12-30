package com.smp.nav
{
	
	
	public class  NavigationState
	{
		public var menuId:int;
		public var submenuId:int;
		
		public function NavigationState(menuId:int = -1, submenuId:int = -1)
		{
			this.menuId = menuId;
			this.submenuId = submenuId;
		}
		
	}
	
}