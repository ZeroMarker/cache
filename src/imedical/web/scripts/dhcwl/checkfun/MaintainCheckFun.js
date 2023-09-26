(function(){
	Ext.ns("dhcwl.checkfun");
	
})();
dhcwl.checkfun.MaintainCheckFun=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        //activeTab: 0,
        defaults:{autoScroll:true},
        items:[],
        deferredRender:true
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainCheckFun',
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
	dhcwl_checkfun_maintain=new dhcwl.checkfun.MaintainCheckFun();
	dhcwl_checkfun_checkfunset=new dhcwl.checkfun.CheckFunSet();
    dhcwl_checkfun_checkfunkpi=new dhcwl.checkfun.CheckFunKpi();
    //dhcwl_checkfun_checkfunvalue=new dhcwl.checkfun.CheckFunValue();
    //dhcwl_checkfun_checkfunrel=new dhcwl.checkfun.CheckFunRel();
	dhcwl_checkfun_maintain.mainTabs.add(dhcwl_checkfun_checkfunset.getCheckFunSetPanel());
	dhcwl_checkfun_maintain.mainTabs.add(dhcwl_checkfun_checkfunkpi.getCheckFunKpiPanel());
	//dhcwl_checkfun_maintain.mainTabs.add(dhcwl_checkfun_checkfunvalue.getCheckFunValuePanel());
	//dhcwl_checkfun_maintain.mainTabs.add(dhcwl_checkfun_checkfunrel.getCheckFunRelPanel());
	dhcwl_checkfun_maintain.mainTabs.setActiveTab(0);
	dhcwl_checkfun_maintain.mainTabs.setActiveTab(1);
	//dhcwl_checkfun_maintain.mainTabs.setActiveTab(2);
	dhcwl_checkfun_maintain.mainTabs.setActiveTab(0);
	
});