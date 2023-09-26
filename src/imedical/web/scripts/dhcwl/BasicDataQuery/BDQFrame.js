(function(){
	Ext.ns("dhcwl.BDQ");
})();

dhcwl.BDQ.MaintainBDQ=function(){
	var mySelfRef=this;
    var ModalMenu = new Ext.menu.Menu({
        id: 'mainMenu',
        items: [
            {
				id:'menuQueryObj',
                text: '定义查询对象',
				hidden :true,
                handler: onAddModal
            },{
				id:'menuQryobjPro',				
                text: '维护对象属性',
				hidden :true,
                handler: onAddModal				
			},{
				id:'menuQueryShowCfg',				
                text: '配置查询条件',
                handler: onAddModal
			},{
				id:'menuShowBDQData',				
                text: '展示查询数据',
                handler: onAddModal
			},{
				id:'menuUserRightMap',				
                text: '配置用户权限',
				hidden :true,
                handler: onAddModal
			}]				
	})
	
	this.mainTabs=new Ext.TabPanel({
        activeTab: 0,
        defaults:{autoScroll:true},
        items:[],
        deferredRender:true
    });
 
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

	
    this.mainWin=new Ext.Viewport({
    	id:'MaintainScheamMain',
        renderTo:Ext.getBody(),
        autoShow:true,
        expandOnShow:true,
        resizable:true,
		layout: 'fit',
		items: [this.mainPanel]
        //items: [this.mainTabs]
    });
    	
	
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
Ext.onReady(function(){
	if (window.navigator.appName=='Microsoft Internet Explorer') {
		document.onkeypress=null;
	}

	aryTableObj=new Array();

	aryTableObj["menuQueryObj"]=new Object();
	aryTableObj["menuQryobjPro"]=new Object();
	aryTableObj["menuQueryShowCfg"]=new Object();
	aryTableObj["menuShowBDQData"]=new Object();
	aryTableObj["menuUserRightMap"]=new Object();

	//aryTableObj["menuQueryObj"].tabrf=new dhcwl.BDQ.QueryObj().getBDQPanel();
	aryTableObj["menuQueryObj"].tabrf=null;
	aryTableObj["menuQueryObj"].createTabExc="var tmpObj=new dhcwl.BDQ.QueryObj().getBDQPanel();";

	aryTableObj["menuQryobjPro"].tabrf=null;
	aryTableObj["menuQryobjPro"].createTabExc="var tmpObj=new dhcwl.BDQ.QryobjPro().getProPanel();";	

	aryTableObj["menuQueryShowCfg"].tabrf=new dhcwl.BDQ.QryViewCfgFrame().getQryViewCfgPanel();
	aryTableObj["menuQueryShowCfg"].createTabExc="var tmpObj=new dhcwl.BDQ.QryViewCfgFrame().getQryViewCfgPanel();";
	
	aryTableObj["menuShowBDQData"].tabrf=null;
	aryTableObj["menuShowBDQData"].createTabExc="var tmpObj=new dhcwl.BDQ.ShowBDQData().getShowDBQPanel();";	
	
	aryTableObj["menuUserRightMap"].tabrf=null;
	aryTableObj["menuUserRightMap"].createTabExc="var tmpObj=new dhcwl.BDQ.UserRightMap().getUserRightMapPanel();";	
	
	///////////////
	//模型配置
	dhcwl_BDQ_maintain=new dhcwl.BDQ.MaintainBDQ();
	//dhcwl_BDQ_maintain.mainTabs.add(aryTableObj["menuQueryObj"].tabrf);
	dhcwl_BDQ_maintain.mainTabs.add(aryTableObj["menuQueryShowCfg"].tabrf);
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.normalSch().getCfgPanel());
	//dhcwl_schema_maintain.mainTabs.add(new dhcwl.schema.sysmgr().getPanel());

	

	dhcwl_BDQ_maintain.mainTabs.setActiveTab(0);
	
	
	
	dhcwl.mkpi.Util.ajaxExc("dhcwl/basedataquery/dataqrycfg.csp",
	{
		action:"getCurUser"
	},function(jsonData){
		if(jsonData.success==true && jsonData.tip=="ok"){
			Ext.getCmp("curuserID").setValue(jsonData.userName);
			
			//if (jsonData.grpID=="1") {
			if (jsonData.statGrp=="1") {
				Ext.getCmp("menuQueryObj").show();
				Ext.getCmp("menuQryobjPro").show();
				Ext.getCmp("menuUserRightMap").show();
			}
		}
	},this);

		
});