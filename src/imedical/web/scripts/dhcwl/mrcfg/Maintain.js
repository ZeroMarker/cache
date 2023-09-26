(function(){
	Ext.ns("DHCMRTJ");
})();
DHCMRTJ.Maintain=function(){
	this.mainTabs=new Ext.TabPanel({
        region: 'center',
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[]
    });
   
    this.mainWin=new Ext.Viewport({
    	id:'mainWin',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
        layout: 'fit',
        items: [this.mainTabs]
    });
    
};
Ext.onReady(function(){
	DHCMRTJ_Maintain=new DHCMRTJ.Maintain();
	DHCMRTJ_Bed_ShowWin=new DHCMRTJ.Bed.ShowWin();
	DHCMRTJ_ICD_ShowWin=new DHCMRTJ.ICD.ShowWin();
	DHCMRTJ_Maintain.mainTabs.add(DHCMRTJ_Bed_ShowWin.getMRBedWin());
	DHCMRTJ_Maintain.mainTabs.add(DHCMRTJ_ICD_ShowWin.getMRICDPanel());
	DHCMRTJ_Maintain.mainTabs.setActiveTab(0);
});