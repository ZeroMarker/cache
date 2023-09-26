(function(){
	Ext.ns("dhcwl.mripdaytask");

})();
dhcwl.mripdaytask.MaintainMripdayTask=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'MaintainMripdayTaskMain',
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

	dhcwl_mripdaytask_maintain=new dhcwl.mripdaytask.MaintainMripdayTask();

	dhcwl_mripdaytask_BaseSetCfg=new dhcwl.mripdaytask.BaseSetCfg();
	
	//加入基本设置页面TAB
	dhcwl_mripdaytask_maintain.mainTabs.add(dhcwl_mripdaytask_BaseSetCfg.getBaseSetCfgPanel());
	//出院情况对应设置TAB
	dhcwl_mripdaytask_maintain.mainTabs.add(new dhcwl.mripdaytask.DisConditionCfg().getDisConditionCfgPanel());
	//dhcwl_mripdaytask_maintain.mainTabs.add(dhcwl_mripdaytask_DisConditionCfg.getDisConditionCfgPanel());
	//医嘱对应设置基本TAB
	dhcwl_mripdaytask_maintain.mainTabs.add(new dhcwl.mripdaytask.OeordInfoCfg().getOeordInfoCfgPanel());
	//dhcwl_mripdaytask_maintain.mainTabs.add(dhcwl_mripdaytask_OeordInfoCfg.getOeordInfoCfgPanel());
	dhcwl_mripdaytask_maintain.mainTabs.setActiveTab(0);

	
});