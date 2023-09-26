(function(){
	Ext.ns("dhcwl.RptMgmt");
})();

dhcwl.RptMgmt.MaintainRptMgmt=function(){
	var mySelfRef=this;
	

	var showMainPanel=new dhcwl.RptMgmt.ShowMain().getShowMainPanel();
	
	this.mainPanel=new Ext.Panel({
        items:showMainPanel,
        deferredRender:true,
		layout: 'fit'
    });	

	
    this.mainWin=new Ext.Viewport({
    	id:'MaintainMgmtMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
		layout: 'fit',
		items: [this.mainPanel]
    });
    	
};
Ext.onReady(function(){
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}

	dhcwl_RptMgmt_maintain=new dhcwl.RptMgmt.MaintainRptMgmt();	
});