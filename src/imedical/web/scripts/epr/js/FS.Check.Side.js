//创建tabpanel
    function createTabPanel(id)
    {
	   var tab = new Ext.TabPanel
	   ({   
           id : id,
           activeTab:0,
           border: false,
           activeTab: 0,
           height : 650,
           autoScroll: false,
           autoDestroy: false,
           listeners: {
		   		'beforeremove': function(tabs,tab) {
	    			var id = tab.id;
	    			var menuID = 'menu_' + id.substring(id.length - 1);
        			//Ext.getCmp(menuID).setChecked(false);
					tabs.hideTabStripItem(tab.id);
					tab.hide();
					return;
				}
			} 
    });     
 	return tab;
	} 
    
    //创建panel
    function createPortal(id, title, html)
    {
		var panel = Ext.getCmp(id);
		if(!panel)
		{
			panel = new Ext.Panel({
				id: id,
				title : title,
				html : html,
				width : '100%',
				height: '100%',
				autoScroll: false
			});
		}
		return panel;
    }
