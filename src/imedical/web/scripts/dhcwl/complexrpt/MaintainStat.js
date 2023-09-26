(function(){
	Ext.ns("dhcwl.complexrpt");
})();
dhcwl.complexrpt.MaintainStat=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainStat',
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

	dhcwl_complexrpt_maintain=new dhcwl.complexrpt.MaintainStat();
	dhcwl_complexrpt_RptStatItem=new dhcwl.complexrpt.RptStatItem();
	dhcwl_complexrpt_maintain.mainTabs.add(dhcwl_complexrpt_RptStatItem.getStatShowWin());
	dhcwl_complexrpt_maintain.mainTabs.setActiveTab(0);
	
});