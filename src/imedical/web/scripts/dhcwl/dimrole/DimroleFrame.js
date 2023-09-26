(function(){
	Ext.ns("dhcwl.dimrole");
})();

dhcwl.dimrole.MaintainDimrole=function(){
	var mySelfRef=this;
    var ModalMenu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
				id:'menuSchema',
                text: 'ç»´åº¦è§’è‰²å±•ç¤º',
                handler: onAddModal
            },{
				id:'menuservAndSet',				
                text: 'ç»´åº¦è§’è‰²ç»´æŠ¤',
				disabled:true,
                handler: onAddModal				
			}]				
	})
	
	this.mainTabs=new Ext.TabPanel({
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[],
        deferredRender:true
    });
 
	this.mainPanel=new Ext.Panel({
        items:[this.mainTabs],
        deferredRender:true,
		tbar: [
			{
				text:'ç»´åº¦è§’è‰²',
				iconCls: 'bmenu',  
				menu: ModalMenu  
			}
		],
		layout: 'fit'
    });	

	
    this.mainWin=new Ext.Viewport({
    	id:'MaintainMeasureMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
		layout: 'fit',
		items: [this.mainPanel]
        //items: [this.mainTabs]
    });
    	
	
	function onAddModal(cmp,event){
		
		if(aryTableObj[cmp.id].tabrf==null)
		{
			eval(aryTableObj[cmp.id].createTabExc);
			aryTableObj[cmp.id].tabrf=tmpObj;
			mySelfRef.mainTabs.add(tmpObj);
		}
		else 
		{
			var aryExistTab=mySelfRef.mainTabs.find("title",cmp.text);
			if(aryExistTab.length==0)
			{
				eval(aryTableObj[cmp.id].createTabExc);
				aryTableObj[cmp.id].tabrf=tmpObj;
				mySelfRef.mainTabs.add(tmpObj);				
			}
		}

		mySelfRef.mainTabs.setActiveTab(aryTableObj[cmp.id].tabrf);			
		
	}
	
	
	
};
Ext.onReady(function(){
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}

	aryTableObj=new Array();

	aryTableObj["menuSchema"]=new Object();
	aryTableObj["menuservAndSet"]=new Object();
	aryTableObj["menuSchedule"]=new Object();

	aryTableObj["menuSchema"].tabrf=new dhcwl.dimrole.dimroleShow().getDimroleShowCfgPanel();
	aryTableObj["menuSchema"].createTabExc="var tmpObj=new dhcwl.dimrole.dimroleShow().getDimroleShowCfgPanel();";
	
	aryTableObj["menuservAndSet"].tabrf=null;
	aryTableObj["menuservAndSet"].createTabExc="var tmpObj=new dhcwl.dimrole.dimrole().getDimroleCfgPanel();";
	
	
	
	//Ä£ÐÍÅäÖÃ
	dhcwl_schema_maintain=new dhcwl.dimrole.MaintainDimrole();
	dhcwl_schema_maintain.mainTabs.add(aryTableObj["menuSchema"].tabrf);
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.normalSch().getCfgPanel());
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.sysmgr().getPanel());


	///////
	//µ÷¶È
	dhcwl_schema_scheduler_creatTaskGroup=null;
	dhcwl_schema_scheduler_TaskGroup=new dhcwl.dimrole.dimrole();
	//dhcwl_schema_scheduler_moduleManager=new dhcwl.schema.scheduler.TaskGroupManager();
	//dhcwl_schema_maintain.mainTabs.add(dhcwl_schema_scheduler_moduleManager.getTaskGroupManagerPanel());


	dhcwl_schema_maintain.mainTabs.setActiveTab(0);
	
});