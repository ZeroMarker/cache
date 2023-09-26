(function(){
	Ext.ns("dhcwl.complexrpt");
})();
dhcwl.complexrpt.maintainKpiPool=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainRptDef',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [this.mainTabs]
    });
    
};
Ext.onReady(function(){
	dhcwl_complexrpt_maintain=new dhcwl.complexrpt.maintainKpiPool();
	dhcwl_complexrpt_KpiPool=new dhcwl.complexrpt.RptMKpiPool();
	dhcwl_complexrpt_maintain.mainTabs.add(dhcwl_complexrpt_KpiPool.getKpiPoolShowWin());
	dhcwl_complexrpt_maintain.mainTabs.setActiveTab(0);
});