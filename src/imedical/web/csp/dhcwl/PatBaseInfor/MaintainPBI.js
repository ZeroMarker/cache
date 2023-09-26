(function(){
	Ext.ns("dhcwl.mkpi");
})();
dhcwl.mkpi.MaintainKpis=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainKpisMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        //width:1000,
        //heitht:800,
        items: [this.mainTabs]
    });
    
};
Ext.onReady(function(){
	//dhcwl_mkpi_previewKpiData=null;
	dhcwl_mkpi_maintain=new dhcwl.mkpi.MaintainKpis();
	dhcwl_mkpi_showKpiWin=new dhcwl.mkpi.ShowKpiWin();
	dhcwl_mkpi_maintain.mainTabs.add(dhcwl_mkpi_showKpiWin.getKpiShowWin());
	dhcwl_mkpi_maintain.mainTabs.setActiveTab(0);
});