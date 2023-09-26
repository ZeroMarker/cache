(function(){
	Ext.ns("dhcwl.CDQ");
})();
//////////////////////////////////////////////////////////////////////
///描述: 		指标数据查询框架类
///编写者：		WZ
///编写日期: 		2017-6
//////////////////////////////////////////

dhcwl.CDQ.MaintainCDQ=function(){
	var mySelfRef=this;
	//主菜单
    var ModalMenu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
				id:'menuDataQryCfgObj',
                text: '增加查询窗口',
                handler: onAddModal
            }]				
	})
	
	//tab页
	this.mainTabs=new Ext.TabPanel({
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[],
        deferredRender:true
    });
 
	//主面板，tab页嵌入到主面板中
	this.mainPanel=new Ext.Panel({
        items:[this.mainTabs],
        deferredRender:true,
		tbar: [
			{
				text:'功能模块',
				iconCls: 'bmenu',  
				menu: ModalMenu  
			}
		],
		layout: 'fit'
    });	

	//主视图，充填整个空间
    this.mainWin=new Ext.Viewport({
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
		layout: 'fit',
		items: [this.mainPanel]
    });
    	
	//菜单响应函数
	//点击菜单项增加tab功能页。
	function onAddModal(cmp,event){
		
		/*
		eval(aryTableObj[cmp.id].createTabExc);
		aryTableObj[cmp.id].tabrf=tmpObj;
		mySelfRef.mainTabs.add(tmpObj);

		mySelfRef.mainTabs.setActiveTab(tmpObj);
		*/

		var tmpObj=new dhcwl.CDQ.CommonDataQryCfg();
		var commonPanel=tmpObj.getQryPanel();

		dhcwl_CDQ_maintain.mainTabs.add(commonPanel);
		dhcwl_CDQ_maintain.mainTabs.setActiveTab(commonPanel);			
		
	}
	
	
	
};
//ext入口方法,被自动调用
Ext.onReady(function(){
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}
	
	/*

	aryTableObj=new Array();
	
	aryTableObj["menuDataQryCfgObj"]=new Object();
	aryTableObj["menuDataQryCfgObj"].tabrf=new dhcwl.CDQ.CommonDataQryCfg().getQryPanel();
	aryTableObj["menuDataQryCfgObj"].createTabExc="var tmpObj=dhcwl.CDQ.CommonDataQryCfg().getQryPanel();";

	dhcwl_CDQ_maintain=new dhcwl.CDQ.MaintainCDQ();
	dhcwl_CDQ_maintain.mainTabs.add(aryTableObj["menuDataQryCfgObj"].tabrf);
	dhcwl_CDQ_maintain.mainTabs.setActiveTab(0);
	*/
	
	var tmpObj=new dhcwl.CDQ.CommonDataQryCfg();
	var commonPanel=tmpObj.getQryPanel();

	dhcwl_CDQ_maintain=new dhcwl.CDQ.MaintainCDQ();
	dhcwl_CDQ_maintain.mainTabs.add(commonPanel);
	dhcwl_CDQ_maintain.mainTabs.setActiveTab(0);	
		
});