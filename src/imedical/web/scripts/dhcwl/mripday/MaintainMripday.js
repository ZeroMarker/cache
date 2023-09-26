(function(){
	Ext.ns("dhcwl.mripday");

})();
dhcwl.mripday.MaintainMripday=function(){
	this.mainTabs=new Ext.TabPanel({
        //region: 'center',
        //margins:'3 3 3 0', 
		//layout:'fit',
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[],
		deferredRender:true
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'MaintainMripdayMain',
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
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}
	dhcwl_mripday_maintain=new dhcwl.mripday.MaintainMripday();

	dhcwl_mripday_mripdayRptCfg=new dhcwl.mripday.MripdayRptCfg();
	
	//加入报表配置TAB
	dhcwl_mripday_maintain.mainTabs.add(dhcwl_mripday_mripdayRptCfg.getRptCfgPanel());
	//加入统计项配置TAB
	dhcwl_mripday_maintain.mainTabs.add(new dhcwl.mripday.MripdayItemCfg().getItemCfgPanel());	
	//加入报表配置TAB
	dhcwl_mripday_maintain.mainTabs.add(new dhcwl.mripday.MripdayDetailItemCfg().getDetailItemPanel());	
	//激活报表配置TAB
	dhcwl_mripday_maintain.mainTabs.setActiveTab(0);

	
});