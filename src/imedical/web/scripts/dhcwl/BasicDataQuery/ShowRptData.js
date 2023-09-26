(function(){
	Ext.ns("dhcwl.BDQ.ShowRptData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.ShowRptData=function(pObj){
	var serviceUrl="dhcwl/basedataquery/qryuserright.csp";
	var outThis=this;
	var paramObj=new Object();
	var inParam;
	
 	var rptCml = new Ext.grid.ColumnModel([
        {header:'ID',id:'rptID',dataIndex:'rptID',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'报表名称',id:'Name',dataIndex:'Name',sortable:true, width: 100, sortable: true,menuDisabled : true},
		{header:'查询对象',id:'BaseObjName',dataIndex:'BaseObjName',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'备注',id:'userName',dataIndex:'userName',sortable:true, width: 150, sortable: true,menuDisabled : true}
    ]);
    var rptStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getRtpNotBelongUserID'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'rptID'},
            	{name: 'Name'},
				{name: 'BaseObjName'},
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
		autoExpandColumn: 'Name',
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [		
					'报表名称:',
					{
						id:'findRptName',
						//width: 100,	
						xtype:'textfield'//,						flex : 1				
					},
					"查询对象:",
					{
						id:'findQryObj',
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
		if(outThis.onSelCallback)
		{		
			var selRec=rptGrid.getSelectionModel().getSelected();
			if(!selRec) {
				Ext.Msg.alert("提示","请选择报表！");
				return;
			}
			var rptName=selRec.get("Name");
			paramObj.rptName=rptName;
			outThis.onSelCallback(paramObj);
			rptDataWin.close();
		}		
	}

	function OnCancel() {
			rptDataWin.close();
	}
 
	
	function OnSearch() {
		var name=Ext.getCmp("findRptName").getValue();
		var qryObj=Ext.getCmp("findQryObj").getValue();
		rptStore.setBaseParam("rptName",name);
		rptStore.setBaseParam("BaseObjName",qryObj);
		rptStore.load({params:{start:0,limit:50}});		
		
	}
	
	function OnResetCond() {
		Ext.getCmp("findRptName").setValue("");
		Ext.getCmp("findQryObj").setValue("");
		rptStore.setBaseParam("rptName","");
		rptStore.setBaseParam("BaseObjName","");
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

