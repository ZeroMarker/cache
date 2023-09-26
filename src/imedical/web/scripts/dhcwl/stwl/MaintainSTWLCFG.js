(function(){
	Ext.ns("dhcwl.stwl");
	
})();
dhcwl.stwl.MaintainCFG=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintaincfgMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [this.mainTabs]
    });
    
};
Ext.onReady(function(){
	dhcwl_stwl_maintain=new dhcwl.stwl.MaintainCFG();
	dhcwl_stwl_statcfg=new dhcwl.stwl.statcfg();

	dhcwl_stwl_maintain.mainTabs.add(dhcwl_stwl_statcfg.getSTWLStatPanel());


	dhcwl_stwl_maintain.mainTabs.setActiveTab(0);
	
});