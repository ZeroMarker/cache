(function(){
	Ext.ns("dhcwl.KDQ.ShowRptData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11

dhcwl.KDQ.ShowRptData=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/userrightmap.csp";
	var outThis=this;
	var paramObj=new Object();
	var inParam;
	
 	var rptCml = new Ext.grid.ColumnModel([
		{header:'报表编码',dataIndex:'rptCode',width: 100},
		{header:'报表描述',id:'descript',dataIndex:'descript',width: 150},
		{header:'作者',dataIndex:'userName', width: 150}
    ]);
    var rptStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getRtpNotBelongUserID'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
            	{name: 'rptCode'},
				{name: 'descript'},
				{name: 'userName'}
			]
    	})
    });

    var rptGrid = new Ext.grid.GridPanel({
        height:480,
		title:'报表配置',
		//layout:'fit',
        store: rptStore,
        cm: rptCml,
		autoExpandColumn: 'descript',
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [		
					'报表编码:',
					{
						id:'findRptCode',
						//width: 100,	
						xtype:'textfield'//,						flex : 1				
					},
					"报表描述:",
					{
						id:'findDescript',
						//width: 100,	
						xtype:'textfield'//,						flex : 1
					},"-",{
						id:'searchBtn',
						iconCls: 'iconSearch',
						text:"搜索",	
						xtype:'button',
						handler:OnSearch
					},	
					"-",
					{
						id:'resetBtn',
						iconCls:'iconReset',
						text:"重置",
						xtype:'button',
						handler:OnResetCond				
		}]}),
		bbar: new Ext.PagingToolbar({
			pageSize:50,
			store:rptStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})		
		
    });
	
	var rptDataWin = new Ext.Window({
        width:700,
		height:500,
		resizable:false,
		closable : false,
		title:'选择报表',
		modal:true,
		//items:[saveAsForm,rptGrid],
		
		layout: {
			type:'vbox',
			padding:'0',
			align:'stretch'
		},
		items: [
		{
			//title:'选择统计项',
			flex:2,
			layout:'fit',
			items:rptGrid
		}],		
		buttons: [
		{
			text:"确定",	
			id:'btnConfirm',
			handler:OnConfirm			
		},{
			text: '取消',
			handler: OnCancel
		}]
	});	
	
	function OnConfirm() {
		var selRec=rptGrid.getSelectionModel().getSelected();
		if (!selRec) {
			Ext.Msg.alert("提示","请选择报表！");
			return;
		}else{
			if(outThis.onSelCallback)
			{		

				var rptCode=selRec.get("rptCode");
				paramObj.rptCode=rptCode;
				outThis.onSelCallback(paramObj);
				rptDataWin.close();
			}
		}		
	}

	function OnCancel() {
			rptDataWin.close();
	}
 
	
	function OnSearch() {
		var code=Ext.getCmp("findRptCode").getValue();
		var descript=Ext.getCmp("findDescript").getValue();
		rptStore.setBaseParam("rptCode",code);
		rptStore.setBaseParam("descript",descript);
		rptStore.load({params:{start:0,limit:50}});		
		
	}
	
	function OnResetCond() {
		Ext.getCmp("findRptCode").setValue("");
		Ext.getCmp("findDescript").setValue("");
		rptStore.setBaseParam("rptCode","");
		rptStore.setBaseParam("descript","");
		//rptStore.setBaseParam("usedFor","exec");
		rptStore.load({params:{start:0,limit:50}});
	}
	
	this.init=function(param) {
		inParam=param;
		rptStore.setBaseParam("userID",param.curUserID);
		//rptStore.load({params:{start:0,limit:50}});		
	}
	
	this.getRptDataWin=function() {
		return rptDataWin;
	}
	
	
	this.show=function() {
		OnResetCond();
		rptDataWin.show();
	}


}

