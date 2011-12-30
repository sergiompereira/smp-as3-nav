package com.smp.nav
{

	 
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	import com.smp.data.XMLLoader;
	
	
	public class  MainPage extends MovieClip
	{
		
		protected var _navLoader:LoadXML;
		protected var _navPath:String;
		
		protected var _navTree:XMLList;
		
		protected var _navigationItems:Array;
		protected var _contentHolder:MovieClip;
		
		protected var _externalAssetsBasePath:String;
		protected var _useSwfAddress:Boolean;
		protected var _swfAddressBaseTitle:String;
		
		protected var _model:INavigationModel;
		protected var _navigation:ANavigation;
		protected var _contentManager:*;
		protected var _swfaddress:SWFAddressManager;
		
		protected var contextItemsCollection:Array;
		
		
		/**
		 * Override stageInit to set local specifications when model, navigation and content manager have already been initialized and are ready to use.
		 * Look for other local overridable functions at the end of the class:
		 * preloadHandler and onContentComplete may be used to handle loading and displaying of external swf file.s
		 * 
		 * Override createNavigation to use any other navigation class from this package (instead of the default Navigation)
		 * The same aplies (but not recomended and probabley not needed) for createContentManager and createSwfAddressManager
		 * Override also to extend functionality beyond the super function
		 * 
		 * Look for the specifications in the NavigationModel class for the Array or Xml format to pass here in the init function.
		 * 
		 * SwfManager calls the start function on InternalPage immediately after loading.
		 * If that is not desired, override InternalPage with a subclass and override the start function with an empty one.
		 * 
		 * 
		 */
		
		public function MainPage() {
			
		}
		
		/**
		 * 
		 * @param	navigationItems : example of use -> new Array({menu:menu.menuItem1, submenu:new Array(submenu1.item1,submenu1.item2)}, {menu:menu.menuItem2},  {menu:menu.menuItem3})
		 * @param	navPath : path to the xml file
		 * @param	navData : Array or XMLList (if no navPath provided)
		 * @param	contentHolder : the DisplayObjectContainer where will be placed the swf files or where are already placed the content movieclips
		 * @param	externalAssetsBasePath : the base path to the swf files with same names as the corrisponding labels in the data object. If not provided or empty string, timeline management with content movieclips already placed will be assumed.
		 * @param	useSwfAddress : whether to use SWFAddress object
		 */
		public function init(navigationItems:Array = null, navPath:String = "", navData:* = null, contentHolder:MovieClip = null, externalAssetsBasePath:String = "", useSwfAddress:Boolean = false, swfAddressBaseTitle:String = ""):void {
				
			_navigationItems = navigationItems;
			
			if (!contentHolder) {
				_contentHolder = this;
			}else{
				_contentHolder = contentHolder;
			}
			
			_externalAssetsBasePath = externalAssetsBasePath;
			_useSwfAddress = useSwfAddress;
			_swfAddressBaseTitle = swfAddressBaseTitle;
			
			instantiateComponents();
			
			
			if (navPath != "") 
			{
				_navLoader = new LoadXML(navPath, true, null, false);
				_navLoader.addEventListener(Event.COMPLETE, onDataLoaded, false, 0, true);
			}
			else if (navData)
			{
				createModel(navData);
				navigationInit();
				stageInit();
			}
			else 
			{
				throw new IOError("MainPage: define either navPath or navData");
			}
			
			
		}
		
		protected function createModel(data:*):void
		{
			
			_model = NavigationModel.getInstance();
			_model.setData(data);
			_model.addEventListener(Event.CHANGE, onModelChange);
		}
		
		protected function instantiateComponents():void 
		{
			
			createNavigation();
			createContentManager();
			createSwfAddressManager();
		}
		
		protected function createNavigation():void
		{
			_navigation = new Navigation();
		}
		
		protected function createContentManager():void
		{
			if(_externalAssetsBasePath != ""){
				_contentManager = new SwfManager();
			}else {
				_contentManager = new TimelineManager();
			}
			
			_contentManager.addEventListener(Event.COMPLETE, onContentComplete);

		}
		protected function createSwfAddressManager():void
		{
			if (_useSwfAddress)
			{
				_swfaddress = new SWFAddressManager();
			}
			
		}
		
		protected function onDataLoaded(evt:Event):void 
		{	
			removeEventListener(Event.COMPLETE, onDataLoaded);
			_navTree = setDataFilter(_navLoader.XMLTree);
			
			createModel(_navTree);
			
			navigationInit();
			stageInit();
			
		}
		
		//to be overriden as desired
		protected function setDataFilter(xml:XML):XMLList {
			return xml.elements();
		}
		
		protected function navigationInit():void 
		{
	
			if(_contentManager != null){
				if(_externalAssetsBasePath){
					_contentManager.Init(_model, _contentHolder, _externalAssetsBasePath, transitionIn, transitionOut, preloadHandler);
				}else {
					_contentManager.Init(_model, _contentHolder);
				}
			}
			
			if(_useSwfAddress && _swfaddress != null){
				_swfaddress.Init(_model);
				_swfaddress.baseTitle = _swfAddressBaseTitle;
			}
			
			if(_navigation != null){
				_navigation.init(_model, _navigationItems);
			}
			
			
			var customContextMenu:ContextMenu = new ContextMenu();
			var i:uint;
			var length:Number = _model.getMenuLength();
			var contextMenuItem:ContextMenuItem;
			contextItemsCollection = [];
			for (i = 0; i < length; i++) {
				contextMenuItem = new ContextMenuItem(_model.getTitle(new NavigationState(i, -1)));
				customContextMenu.customItems.push(contextMenuItem);
				
				contextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onContextItemSelect); 
				contextItemsCollection.push([contextMenuItem, i]);
			}
			this.contextMenu = customContextMenu;
			
			
			
				
		}
		
		
		protected function onContextItemSelect(evt:ContextMenuEvent) {
			var j:uint;
			for (j = 0; j < contextItemsCollection.length; j++) {
				if (contextItemsCollection[j][0] == evt.currentTarget) {
					_model.state = new NavigationState(contextItemsCollection[j][1]);
					break;
				}
			}
			
		}
		
		
		/* Functions to be overriden to comply with local specifications */
		
		protected function stageInit():void {
			
		}
		
		protected function transitionIn():void {
			
		}
		
		protected function transitionOut():void {
			
		}
		
		protected function preloadHandler(perc:Number):void {
			
		}
		
		protected function onModelChange(evt:Event):void {
			
		}
		
		protected function onContentComplete(evt:Event):void {
			
		}
	}
}
