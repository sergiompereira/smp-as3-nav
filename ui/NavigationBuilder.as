package com.smp.nav.ui
{

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.smp.nav.ANavigation;
	import com.smp.nav.INavigationModel;
	import com.smp.nav.NavigationModel;
	import com.smp.nav.NavigationItem;
	import com.smp.nav.NavigationState;
	import com.smp.common.display.DisplayObjectUtilities;
	
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;



	//browser debugging
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	
	public class  NavigationBuilder extends ANavigation
	{
				
		public static const TYPE_ENCAPSULATED_HORIZONTAL_HORIZONTAL:uint = 0;
		public static const MENUTYPE_ENCAPSULATED_HORIZONTAL_VERTICAL:uint = 1;
		public static const MENUTYPE_ENCAPSULATED_VERTICAL_HORIZONTAL:uint = 2;
		public static const MENUTYPE_ENCAPSULATED_VERTICAL_VERTICAL:uint = 3;
		public static const MENUTYPE_CUSTOM_HORIZONTAL_HORIZONTAL:uint = 4;
		public static const MENUTYPE_CUSTOM_HORIZONTAL_VERTICAL:uint = 5;
		public static const MENUTYPE_CUSTOM_VERTICAL_HORIZONTAL:uint = 6;
		public static const MENUTYPE_CUSTOM_VERTICAL_VERTICAL:uint = 7;
		
		protected var _menuLength:uint = 0;
	
		protected var _container:DisplayObjectContainer = null;
		protected var _menu:DisplayObjectContainer;
		protected var _submenu:DisplayObjectContainer;
		protected var _submenuListCollection:Array = new Array();
		protected var _tween:GTween;
		
		protected var _menuType:uint = 0;
		protected var _menuPositionProperty:String;
		protected var _menuSizeProperty:String;
		protected var _submenuPositionProperty:String;
		protected var _submenuSizeProperty:String;
		
		protected var _menux:Number = 0;
		protected var _menuy:Number = 0;
		protected var _submenux:Number = 0;
		protected var _submenuy:Number = 0;
		protected var _menuItemDistance:Number = 0;
		protected var _submenuItemDistance:Number = 0;
		protected var _hitArea:Array = new Array(0,0,0,0);

		protected var _openSubmenuId:int = -1;
		protected var _showSubmenuOnOver:Boolean = true;
		protected var _over:Boolean = false;
		
		protected var _transitionTime:Number = 0.3;
		
		/**
		 * @exception : To implement vertical type. Sugestion: use advanced property, ex: menu[positionCoord]
		 */
		public function NavigationBuilder() 
		{	
			_tween = new GTween(_submenu);
		}
		
		/**
		 * 
		 * @param	container
		 * @param	menuType: look for public constants. 
		 * 				ENCAPSULATED means visual hierarchy between the submenu and its parent menu item. 
		 * 				CUSTOM allows for custom positioning of both menu and submenu sprites.
		 * 				In this last case, submenux and submenuy params are absolute position. Otherwise, they are relative to the parent menu item.
		 * @param	menux
		 * @param	menuy
		 * @param	submenux
		 * @param	submenuy
		 * @param	menuItemDistance
		 * @param	submenuItemDistance
		 * @param	hitArea: array with four corners of an active ractangle. While mouse is within this area, the submenu will be kept open.
		 * @param	menuLength: override model menu length
		 */
		public function config(container:DisplayObjectContainer, menuType:uint = 0, menux:Number = 0, menuy:Number = 0, submenux:Number = 0, submenuy:Number = 0, menuItemDistance:Number = 0, submenuItemDistance:Number = 0, hitArea:Array = null, menuLength:uint = 0, showSubmenuOnOver:Boolean = true ):void 
		{
			_container = container;
			_menuType = menuType;
			_menux = menux;
			_menuy = menuy;
			_submenux = submenux;
			_submenuy = submenuy;
			_menuItemDistance = menuItemDistance;
			_submenuItemDistance = submenuItemDistance;
			_showSubmenuOnOver = showSubmenuOnOver;
			
			switch(_menuType) {
				case 0:
					_menuPositionProperty = "x";
					_menuSizeProperty = "textWidth";
					_submenuPositionProperty = "x";
					_submenuSizeProperty = "textWidth";
					break;
				case 1:
					_menuPositionProperty = "x";
					_menuSizeProperty = "textWidth";
					_submenuPositionProperty = "y";
					_submenuSizeProperty = "textHeight";
					break;
				case 2:
					_menuPositionProperty = "y";
					_menuSizeProperty = "textHeight";
					_submenuPositionProperty = "x";
					_submenuSizeProperty = "textWidth";
					break;
				case 3:
					_menuPositionProperty = "y";
					_menuSizeProperty = "textHeight";
					_submenuPositionProperty = "y";
					_submenuSizeProperty = "textHeight";
					break;
				case 4:
					_menuPositionProperty = "x";
					_menuSizeProperty = "textWidth";
					_submenuPositionProperty = "x";
					_submenuSizeProperty = "textWidth";
					break;
				case 5:
					_menuPositionProperty = "x";
					_menuSizeProperty = "textWidth";
					_submenuPositionProperty = "y";
					_submenuSizeProperty = "textHeight";
					break;
				case 6:
					_menuPositionProperty = "y";
					_menuSizeProperty = "textHeight";
					_submenuPositionProperty = "x";
					_submenuSizeProperty = "textWidth";
					break;
				case 7:
					_menuPositionProperty = "y";
					_menuSizeProperty = "textHeight";
					_submenuPositionProperty = "y";
					_submenuSizeProperty = "textHeight";
					break;
				default:
					_menuPositionProperty = "x";
					_menuSizeProperty = "textWidth";
					_submenuPositionProperty = "x";
					_submenuSizeProperty = "textWidth";
					break;
			}
			
			if(hitArea != null){
				_hitArea = hitArea;
			}	
			
			_menuLength = menuLength;
			
			handleConfig();
		}
		
		/**
		 * Override for specific set and reset of the main display objects
		 */
		protected function handleConfig():void 
		{
			if (_menu == null) {
				createMenu();
				createSubmenu();
			}
			
			_menu.x = _menux;
			_menu.y = _menuy;
			_submenu.y = _submenuy;
			_submenu.x = _submenux;
			
			_container.addChild(_menu);
			_container.addChild(_submenu);
			
		}
		
		/**
		 * Override to use specific container classes
		 */
		protected function createMenu():void 
		{
			_menu = new Sprite();	
		}
		
		/**
		 * Override to use specific container classes
		 */
		protected function createSubmenu():void 
		{
			_submenu = new Sprite();
		}
		
		/**
		 * 
		 * @param	model
		 * @param	navigationItems : defined by super. 
		 */
		override public function init(model:INavigationModel, navigationItems:Array = null):void 
		{	
			if (_container == null) {
				throw new Error("NavigationBuilder > init : Use config function first.")
			}
			
			_model = model;
			if(_menuLength == 0){
				_menuLength = _model.getMenuLength();
			}
			
			var timer = new Timer(200);
			timer.addEventListener(TimerEvent.TIMER, onOutNav, false, 0, true);
			timer.start();
			
			start();
			
			_model.addEventListener(Event.CHANGE, onMenuChange);
			if(_showSubmenuOnOver){
				_model.addEventListener(NavigationModel.MOUSE_OVER, onItemOver);
			}
						
		}
		
		/* CREATION PROCUDURES */
		
		protected function start():void 
		{
			buildMenu();
			buildSubmenus();
		}
		
		
		
		protected function buildMenu():void 
		{
			_menu.alpha = 0;
			
			for (var i:int = 0; i < _menuLength; i++) {
				_menu.addChild(createItem(i, -1, _menu, _menuItemDistance, "menu"));
			}
			
			_menu.alpha = 1;
		}
		
		protected function buildSubmenus():void 
		{	
			for (var i:uint = 0; i < _menuLength; i++) 
			{
				_submenuListCollection.push(buildSubmenu(_model.getSubmenuLength(new NavigationState(i)), i));
			}
		}
		
		protected function buildSubmenu(dataLength:Number, parentid:int):DisplayObjectContainer 
		{		
			var submenuList:Sprite = new Sprite();
			if (dataLength > 0) {
				for (var i:int = 0; i < dataLength; i++) {
					submenuList.addChild(createItem(i, parentid, submenuList, _submenuItemDistance, "submenu"));
				}
			}
			return submenuList;
	
		}
		
		/**
		 * Override to manage local specifications
		 * @param	id
		 * @param	parentid
		 * @param	contentor
		 * @param	itemDistance
		 */
		protected function createItem(id:int, parentid:int, contentor:DisplayObjectContainer, itemDistance:Number, itemType:String):NavigationItem
		{
		
				var item:NavigationItem;
				
				if (parentid < 0) {
					item = instanciateMenuItem();
				}else {
					item = instanciateSubmenuItem();
				}
				
				(item as NavigationItem).init(_model);
				item.name = "item" + id;
				setItemTitle(id, item, parentid);
								
				if (parentid < 0) {
					(item as NavigationItem).setId(id);
				}else {
					(item as NavigationItem).setId(id, parentid);
		
				}
						
				setItemPosition(id, item, contentor, itemDistance, itemType);
				
				return item;
				
		}
		
		/**
		 * Override to set local NavigationItem extensions
		 * @return
		 */
		protected function instanciateMenuItem():NavigationItem {
			return new NavigationItem();
		}
		
		/**
		 * Override to set local NavigationItem extensions
		 * @return
		 */
		protected function instanciateSubmenuItem():NavigationItem {
			return new NavigationItem();
		}
		
		/**
		 * Override to manage local specifications
		 * @param	id
		 * @param	item
		 * @param	parentid
		 */
		protected function setItemTitle(id:int, item:NavigationItem, parentid:int):void {
			if (parentid < 0) 
			{
				item.title = _model.getTitle(new NavigationState(id));
			}else {
				
				item.title = _model.getTitle(new NavigationState(parentid, id));	
			}
		}
		
		/**
		 * Override to manage local specifications
		 * @param	id
		 * @param	item
		 * @param	contentor
		 * @param	itemDistance
		 */
		protected function setItemPosition(id:int, item:NavigationItem, contentor:DisplayObjectContainer, itemDistance:Number, itemType:String):void 
		{
			var positionProperty:String;
			switch(itemType) {
				case "menu":
					if(id>0){
						item[_menuPositionProperty] = NavigationItem(contentor.getChildByName("item" + (id - 1)))[_menuPositionProperty] + Math.round(NavigationItem(contentor.getChildByName("item" + (id - 1)))[_menuSizeProperty]) + itemDistance;
					}else {
						item[_menuPositionProperty] = 0;
					}
					break;
				default:
					if(id>0){
						item[_submenuPositionProperty] = NavigationItem(contentor.getChildByName("item" + (id - 1)))[_submenuPositionProperty] + Math.round(NavigationItem(contentor.getChildByName("item" + (id - 1)))[_submenuSizeProperty]) + itemDistance;
					}else {
						item[_submenuPositionProperty] = 0;
					}
					break;
			}
			
			
			
		}
		
		
		/* \\END CREATION PROCUDURES */
		
		
		
	
		/* INTERACTION EVENTS PROCUDURES */
		
		/**
		 * Handles mouse over items (dispatched from model)
		 * @param	evt
		 */
		protected function onItemOver(evt:Event):void {
			if (_model.overState.menuId != _openSubmenuId && _model.overState.menuId < _menuLength)
			{		
				_openSubmenuId = _model.overState.menuId;
				hideSubmenu();
				_tween.addEventListener(Event.COMPLETE, onSubmenuOverChange);
			}
		}
		
		
		/**
		 * Handles mouse out items
		 * @param	evt
		 */
		protected function onOutNav(evt:TimerEvent):void {

			
			if (_container.mouseX < _hitArea[3] || _container.mouseX > _hitArea[1] || _container.mouseY < _hitArea[0] || _container.mouseY > _hitArea[2]) {
				if(_over){
					_over = false;
					_model.overState = new NavigationState();
					if(_openSubmenuId != _model.state.menuId || _openSubmenuId == -1){
						hideSubmenu();
						_tween.addEventListener(Event.COMPLETE, onSubmenuOutChange);
					}
				}
			}else {
				_over = true;
			}
			
				
		}	
		
		/**
		 * Handles model changes
		 * @param	evt
		 */
		override protected function onMenuChange(evt:Event):void 
		{
			if (_model.state.menuId < _menuLength) 
			{
				if ((_model.state.submenuId == -1 && _model.state.menuId != _model.overState.menuId) || _model.state.menuId != _openSubmenuId || _model.state.menuId == -1){
					
					hideSubmenu();
					_tween.addEventListener(Event.COMPLETE, onSubmenuActiveChange);
				}
			}else {
				hideSubmenu();
				_tween.addEventListener(Event.COMPLETE, function(){});
				_openSubmenuId = -1;
			}
		}
		
		/* \\END INTERACTION PROCUDURES */
		
		
		
		/* ANIMATION PROCUDURES */
		
		protected function onSubmenuOverChange(evt:Event):void 
		{
			_tween.removeEventListener(Event.COMPLETE, onSubmenuOverChange);
			DisplayObjectUtilities.removeAllChildren(_submenu);
			handlesOverSubmenu();
		}
		
		protected function handlesOverSubmenu():void 
		{
			if (_model.overState.menuId > -1)
			{
				_submenu.addChild(_submenuListCollection[_model.overState.menuId ]);
				
				var dataLength:Number = _model.getSubmenuLength(_model.overState);
				if (dataLength > 0) 
				{
					_openSubmenuId = _model.overState.menuId;
					setSubmenuPosition(getParentMenu(_model.overState.menuId));
					showSubmenu();
					
				}else {
					_openSubmenuId = -1;
				}
			}else {
				handlesActiveSubmenu()
			}
		}

		protected function onSubmenuOutChange(evt:Event):void
		{
			_tween.removeEventListener(Event.COMPLETE, onSubmenuOutChange);
			DisplayObjectUtilities.removeAllChildren(_submenu);
			handlesActiveSubmenu();
		}
		
		/**
		 * Generic function to set default submenu (on mouse out, or on model change)
		 */
		protected function handlesActiveSubmenu():void 
		{	
			if (_model.state.menuId > -1 && _model.state.menuId < _menuLength) 
			{	
				_submenu.addChild(_submenuListCollection[_model.state.menuId]);
				
				var activeDataLength:Number = _model.getSubmenuLength(_model.state);
				if (activeDataLength > 0) 
				{
					_openSubmenuId = _model.state.menuId;
					setSubmenuPosition(getParentMenu(_model.state.menuId));
					showSubmenu();
				}
			}else {
				_openSubmenuId = -1;
			}
		}
		
		protected function onSubmenuActiveChange(evt:Event):void 
		{
			_tween.removeEventListener(Event.COMPLETE, onSubmenuActiveChange);
			DisplayObjectUtilities.removeAllChildren(_submenu);
			handlesActiveSubmenu();
		}
		
		/**
		 * 
		 * @param	id
		 * @return
		 */
		protected function getParentMenu(id:int):NavigationItem {
			return NavigationItem( _menu.getChildByName("item" + id));
		}
		
		/**
		 * Override to manage local specifications
		 * @param	parentMenuItem
		 */
		protected function setSubmenuPosition(parentMenuItem:NavigationItem):void {
			if(_menuType < 4){
				_submenu.x = parentMenuItem.x + _menux + _submenux;
				_submenu.y = parentMenuItem.y + _menuy + _submenuy;
			}
		}
		
		protected function hideSubmenu():void 
		{
			submenuTransitionOut();
		}
		
		protected function showSubmenu():void 
		{
			submenuTransitionIn();
		}
		
		protected function submenuTransitionIn():void 
		{	
			//_tween.setTween(_submenu, "alpha", TweenSafe.REG_EASEOUT, _submenu.alpha, 1, _transitionTime, true, true);
			_tweener.setValue("alpha", 1);
			_tweener.duration = _transitionTime;
			_tweener.ease = Sine.easeOut;
		}
		
		protected function submenuTransitionOut():void 
		{	
			//_tween.setTween(_submenu, "alpha", TweenSafe.REG_EASEOUT, _submenu.alpha, 0, _transitionTime, true, true);
			_tweener.setValue("alpha", 0);
			_tweener.duration = _transitionTime;
			_tweener.ease = Sine.easeOut;
		}
		
	}
	
}