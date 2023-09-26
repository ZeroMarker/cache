(function(){
	Ext.ns("dhcwl.codecfg");
	
})();
dhcwl.codecfg.MaintainCodeCfg=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        //margins:'3 3 3 0', 
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'maintainCodeCfgMain',
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
	//dhcwl_codecfg_codecfgSubGroupItem=null;
	dhcwl_codecfg_maintain=new dhcwl.codecfg.MaintainCodeCfg();
	//dhcwl_codecfg_codecfgtype=new dhcwl.codecfg.CodeCfgType();
	//dhcwl_codecfg_codecfggroup=new dhcwl.codecfg.CodeCfgGroup();
	dhcwl.codecfg.codedfginterface=new dhcwl.codecfg.CodeCfgInterface();
	dhcwl.codecfg.codedfgcontrast=new dhcwl.codecfg.CodeCfgContrast();
	//dhcwl_codecfg_codecfgSubGroupItem=new dhcwl.codecfg.CodeCfgSubGroupItem();
	//dhcwl_codecfg_maintain.mainTabs.add(dhcwl_codecfg_codecfgtype.getcodecfgtypePanel());
	//dhcwl_codecfg_maintain.mainTabs.add(dhcwl_codecfg_codecfggroup.getcodecfggroupPanel());
	dhcwl_codecfg_maintain.mainTabs.add(dhcwl.codecfg.codedfginterface.getcodecfginterfacePanel());
	dhcwl_codecfg_maintain.mainTabs.add(dhcwl.codecfg.codedfgcontrast.getcodecfgcontrastPanel());
	


	dhcwl_codecfg_maintain.mainTabs.setActiveTab(0);
	dhcwl_codecfg_maintain.mainTabs.setActiveTab(1);
	dhcwl_codecfg_maintain.mainTabs.setActiveTab(2);
	dhcwl_codecfg_maintain.mainTabs.setActiveTab(0);
	
});