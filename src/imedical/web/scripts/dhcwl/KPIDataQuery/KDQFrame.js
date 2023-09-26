(function(){
	Ext.ns("dhcwl.KDQ");
})();
//////////////////////////////////////////////////////////////////////
///描述: 		指标数据查询框架类
///编写者：		WZ
///编写日期: 		2017-6
//////////////////////////////////////////

dhcwl.KDQ.MaintainKDQ=function(){
	var mySelfRef=this;
	//主菜单
    var ModalMenu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
				id:'menuBusinessCfgObj',
                text: '业务类型配置',
				hidden :true,
                handler: onAddModal
            },{
				id:'menuRptCfg',				
                text: '配置报表',
                handler: onAddModal
			},{
				id:'menuShowKDQData',				
                text: '显示统计数据',
                handler: onAddModal
			},{
				id:'menuUserRightMap',				
                text: '配置用户权限',
				hidden :true,
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
			,'->',
			'当前用户：',
			{
				id:'curuserID',
				xtype: 'displayfield',
                value: 'xxx'
            }
		],
		layout: 'fit'
    });	

	//主视图，充填整个空间
    this.mainWin=new Ext.Viewport({
    	id:'MaintainScheamMain',
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
		
		if(aryTableObj[cmp.id].tabrf==null)
		{
			eval(aryTableObj[cmp.id].createTabExc);
			aryTableObj[cmp.id].tabrf=tmpObj;
			mySelfRef.mainTabs.add(tmpObj);
		}
		else 
		{
			var aryExistTab=mySelfRef.mainTabs.find("title",cmp.text);
			if(aryExistTab.length==0)
			{
				eval(aryTableObj[cmp.id].createTabExc);
				aryTableObj[cmp.id].tabrf=tmpObj;
				mySelfRef.mainTabs.add(tmpObj);				
			}
		}

		mySelfRef.mainTabs.setActiveTab(aryTableObj[cmp.id].tabrf);			
		
	}
	
	
	
};
//ext入口方法,被自动调用
Ext.onReady(function(){
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}

	aryTableObj=new Array();

	aryTableObj["menuBusinessCfgObj"]=new Object();
	aryTableObj["menuRptCfg"]=new Object();
	aryTableObj["menuShowKDQData"]=new Object();
	aryTableObj["menuUserRightMap"]=new Object();


	aryTableObj["menuBusinessCfgObj"].tabrf=null;
	aryTableObj["menuBusinessCfgObj"].createTabExc="var tmpObj=new dhcwl.KDQ.BusinessTypeDataCfg().getBTPanel();";

	aryTableObj["menuRptCfg"].tabrf=new dhcwl.KDQ.DataQryCfg().getRptCfgPanel();;
	aryTableObj["menuRptCfg"].createTabExc="var tmpObj=new dhcwl.KDQ.DataQryCfg().getRptCfgPanel();";	

	aryTableObj["menuShowKDQData"].tabrf=new dhcwl.KDQ.ShowStatData().getShowStatPanel();
	aryTableObj["menuShowKDQData"].createTabExc="var tmpObj=new dhcwl.KDQ.ShowStatData().getShowStatPanel();";
	

	aryTableObj["menuUserRightMap"].tabrf=null;
	aryTableObj["menuUserRightMap"].createTabExc="var tmpObj=new dhcwl.KDQ.UserRightMap().getUserRightMapPanel();";	


	dhcwl_KDQ_maintain=new dhcwl.KDQ.MaintainKDQ();
	dhcwl_KDQ_maintain.mainTabs.add(aryTableObj["menuRptCfg"].tabrf);
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.normalSch().getCfgPanel());
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.sysmgr().getPanel());

	

	dhcwl_KDQ_maintain.mainTabs.setActiveTab(0);
	
	
	
	dhcwl.mkpi.Util.ajaxExc("dhcwl/kpidataquery/frame.csp",
	{
		action:"getCurUser"
	},function(jsonData){
		if(jsonData.success==true && jsonData.tip=="ok"){
			Ext.getCmp("curuserID").setValue(jsonData.userName);
			
			if (jsonData.statGrp=="1") {
				Ext.getCmp("menuBusinessCfgObj").show();
				Ext.getCmp("menuUserRightMap").show();
			}
			
		}
	},this);

		
});