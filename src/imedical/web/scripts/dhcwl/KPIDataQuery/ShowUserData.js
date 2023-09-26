(function(){
	Ext.ns("dhcwl.KDQ.ShowUserData");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.ShowUserData=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/userrightmap.csp";
	var outThis=this;
	var paramObj=new Object();
	var inParamObj;
	
	var userCml = new Ext.grid.ColumnModel([
        {header:'ID',id:'ID',dataIndex:'ID',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'姓名',id:'name',dataIndex:'name',sortable:true, width: 100, sortable: true,menuDisabled : true},
		{header:'安全组',id:'ssGrp',dataIndex:'ssGrp',sortable:true, width: 150, sortable: true,menuDisabled : true}
    ]);
    var userStore = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'ID'},
            	{name: 'name'},
				{name: 'ssGrp'}
			]
    	})
    });

    var userGrid = new Ext.grid.GridPanel({
        height:480,
		title:'用户',
		//layout:'fit',
        store: userStore,
        cm: userCml,
		autoExpandColumn: 'name',
		
		tbar:new Ext.Toolbar({
					layout: 'hbox',
					items : [		
					'姓名:',
					{
						id:'findName',
						//width: 100,	
						xtype:'textfield'//,						flex : 1				
					},
					"安全组:",
					{
						id:'findGroup',
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
			store:userStore,
			displayInfo:true,
			displayMsg:'{0}~{1}条,共 {2} 条',
			emptyMsg:'sorry,data not found!'
		})
    });
	
	var userDataWin = new Ext.Window({
        width:700,
		height:500,
		resizable:false,
		closable : false,
		title:'选择用户',
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
			items:userGrid
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
		var selRec=userGrid.getSelectionModel().getSelected();		
		if (!selRec) {
			Ext.Msg.alert("提示","请选择用户！");
			return;
		}else{		
			if(outThis.onSelCallback)
			{		

				var userID=selRec.get("ID");
				paramObj.userID=userID;
				outThis.onSelCallback(paramObj);
				userDataWin.close();
			}
		}			
	}

	function OnCancel() {
			userDataWin.close();
	}
 
	function OnSearch() {
		var name=Ext.getCmp("findName").getValue();
		var grp=Ext.getCmp("findGroup").getValue();
		userStore.setBaseParam("userName",name);
		userStore.setBaseParam("userGrp",grp);
		userStore.load({params:{start:0,limit:50}});		
		
	}
	
	function OnResetCond() {
		Ext.getCmp("findName").setValue("");
		Ext.getCmp("findGroup").setValue("");
		userStore.setBaseParam("userName","");
		userStore.setBaseParam("userGrp","");
		userStore.load({params:{start:0,limit:50}});

		
	}

	
	this.init=function(inP) {
		inParamObj=inP;
		if (inParamObj.masterGrid=="rptGrid") {
			userStore.setBaseParam("rptCode",inParamObj.rptCode);
			userStore.setBaseParam("action","getUserNotBelongRpt");
		}else if (inParamObj.masterGrid=="userGrid") {
			userStore.setBaseParam("action","getUserNotBelongMap");
		}
	}
	
	this.getUserDataWin=function() {
		return userDataWin;
	}
	
	
	this.show=function() {
		OnResetCond();
		userDataWin.show();
	}


}

