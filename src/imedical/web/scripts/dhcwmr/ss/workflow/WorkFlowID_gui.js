function InitWorkDetailEdit()
{
	var obj = new Object();
	var source = arguments[0];
	obj.WorkFlowId = source.get('ID');	

	obj.ExistWorkItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.ExistWorkItemGridStore = new Ext.data.Store({
		proxy: obj.ExistWorkItemGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemIndex', mapping: 'ItemIndex'}	
		])
	});

	obj.ExistWorkItemGrid = new Ext.grid.GridPanel({
		id : 'ExistWorkItemGrid'
		,store : obj.ExistWorkItemGridStore
		,columnLines:true
		,loadMask : true
		,region : 'west'
		,width : 110
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,columns: [
			{header: '操作项目', width: 100, dataIndex: 'ItemDesc', align: 'center'}
		]
	});


	obj.WorkDetailGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.WorkDetailGridStore = new Ext.data.Store({
		proxy: obj.WorkDetailGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'DicCode', mapping: 'DicCode'},
			,{name: 'Resume', mapping: 'Resume'}	
		])
	});

	obj.WorkDetailGrid = new Ext.grid.GridPanel({
		id : 'WorkDetailGrid'
		,store : obj.WorkDetailGridStore
		,columnLines:true
		,loadMask : true
		,region : 'west'
		,width : 160
		,frame : true
		,viewConfig: {forceFit: true}
		,columns: [
			{header: '附加项', width: 160, dataIndex: 'Desc', align: 'center'}
		]
	});
	//附加项操作项目添加移除
	obj.Label1 = new Ext.form.Label({
		id : 'Label1'
		,height : 120
		,width : 50
	});
	obj.BtnRight = new Ext.Button({
		id : 'BtnRight'
		,height : 30
		,anchor : '95%'
		,iconCls : 'icon-add'
		,text : '添加'
	});
	obj.Label2 = new Ext.form.Label({
		id : 'Label2'
		,height : 20
		,width : 50
	});
	obj.BtnLeft = new Ext.Button({
		id : 'BtnLeft'
		,height : 30
		,anchor : '95%'
		,iconCls : 'icon-delete'
		,text : '移除'
	});

	obj.Label3 = new Ext.form.Label({
		id : 'Label3'
		,height : 20
		,width : 50
	});
	obj.BtnUp = new Ext.Button({
		id : 'BtnUp'
		,height : 30
		,anchor : '95%'
		,iconCls : 'icon-moveup'
		,text : '上移'
	});

	obj.Label4 = new Ext.form.Label({
		id : 'Label4'
		,height : 20
		,width : 50
	});
	obj.BtnDown = new Ext.Button({
		id : 'BtnDown'
		,height : 30
		,anchor : '95%'
		,iconCls : 'icon-movedown'
		,text : '下移'
	});
	obj.WFIDControlPanel = new Ext.Panel({
		id : 'WFIDControlPanel'
		,width : 50
		,layout: 'form'
		,labelWidth: 40
		,region : 'center'
		,frame  : true
		,items:[obj.Label1,obj.BtnRight,obj.Label2,obj.BtnLeft,obj.Label3,obj.BtnUp,obj.Label4,obj.BtnDown]
	});
	//已配置的附加项目列表
	obj.ExistWorkFIDetailGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.ExistWorkFIDetailGridStore = new Ext.data.Store({
		proxy: obj.ExistWorkFIDetailGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'DtlID', mapping: 'DtlID'}
			,{name: 'DtlDesc', mapping: 'DtlDesc'}
			,{name: 'DtlIndex', mapping: 'DtlIndex'}
			,{name: 'IsNeed', mapping: 'IsNeed'}
			,{name: 'InitVal', mapping: 'InitVal'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});

	obj.ExistWorkFIDetailGrid = new Ext.grid.GridPanel({
		id : 'ExistWorkFIDetailGrid'
		,store : obj.ExistWorkFIDetailGridStore
		,columnLines:true
		//,loadMask : true
		,width: 450
		,region : 'east'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,columns: [
			{header: '序号', width: 40, dataIndex: 'DtlIndex', align: 'center'}
			,{header: '附加项', width: 100, dataIndex: 'DtlDesc', align: 'center'}
			,{header: '是否必填', width: 80, dataIndex: 'IsNeed', align: 'center'}
			,{header: '初始值', width: 60, dataIndex: 'InitVal', align: 'center'}
			,{header: '是否有效', width: 100, dataIndex: 'IsActive', align: 'center'}
			,{header: '备注', width: 120, dataIndex: 'Resume', align: 'center'}
		]
	});
	
	obj.WorkFIDetailCenterPanel = new Ext.Panel({
		id :'WorkFIDetailCenterPanel'
		,layout : 'border'
		,region: 'center'
		,items: [obj.WorkDetailGrid,obj.WFIDControlPanel,obj.ExistWorkFIDetailGrid]
	});

	obj.WFDIsNeed = new Ext.form.Checkbox({
		id : 'WFDIsNeed'
		,fieldLabel : '是否必填'
		,labelSeparator :''
		,anchor : '99%'
		,checked : false
	});
 	obj.IsNeedPanel = new Ext.Panel({
		id:'IsNeedPanel'
		,layout:'form'
		,region:'center'
		,columnWidth: .2
		,labelWidth: 70
		,labelAlign : 'right'
		,items:[obj.WFDIsNeed]
	});	
	obj.WFDIsActive = new Ext.form.Checkbox({
		id : 'WFDIsActive'
		,fieldLabel : '是否有效'
		,labelSeparator :''
		,anchor : '99%'
		,checked : false
	});
	obj.IsActivePanel = new Ext.Panel({
		id:'IsActivePanel'
		,layout:'form'
		,region:'center'
		,columnWidth: .2
		,labelWidth: 70
		,labelAlign : 'right'
		,items:[obj.WFDIsActive]
	});	
	obj.WFDInitVal = new Ext.form.TextField({
		id : 'WFDInitVal'
		,fieldLabel : '初始值'
		,labelSeparator :''
		,width : 120
		,anchor : '99%'
	});
	obj.InitValPanel = new Ext.Panel({
		id:'InitValPanel'
		,layout:'form'
		,region:'center'
		,columnWidth: .25
		,labelWidth: 70
		,labelAlign : 'right'
		,items:[obj.WFDInitVal]
	});	
	obj.WFDResume = new Ext.form.TextField({
		id : 'WFDResume'
		,fieldLabel : '备注'
		,labelSeparator :''
		,width : 120
		,anchor : '99%'
	});
	obj.WFDRowid = new Ext.form.TextField({
		id : 'WFDRowid'
		,hidden: true
	});
	obj.ResumePanel = new Ext.Panel({
		id:'ResumePanel'
		,layout:'form'
		,region:'center'
		,columnWidth: .25
		,labelWidth: 70
		,labelAlign : 'right'
		,items:[obj.WFDResume,obj.WFDRowid]
	});	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.DetailSouthPanelSub1 = new Ext.Panel({
		id:'DetailSouthPanelSub1'
		,layout:'column'
		,region:'center'
		,items:[obj.IsNeedPanel,obj.IsActivePanel,obj.InitValPanel,obj.ResumePanel]
	});
	obj.WorkFIDetailSouthPanel = new Ext.Panel({
		id :'WorkFIDetailPanel'
		,layout : 'form'
		,region: 'south'
		,height : 80
		,labelWidth: 55
		,labelAlign : 'right'
		,frame : true
		,items:[obj.DetailSouthPanelSub1]
		,buttonAlign : 'center'
		,buttons : [obj.btnSave]
	});
	obj.WorkFIDetailPanel = new Ext.Panel({
		id :'WorkFIDetailPanel'
		,layout : 'border'
		,region: 'center'
		,width :500
		,items:[obj.WorkFIDetailCenterPanel,obj.WorkFIDetailSouthPanel]
	});
	obj.WorkDetailEditWin = new Ext.Window({
		id : 'WorkDetailEditWin'
		,width : 800
		,plain : true
		,buttonAlign : 'center'
		,height : 520
		,title : '附加信息'
		,layout : 'border'
		,frame  : true
		,bodyBorder : 'padding:0 0 0 0'
		,modal : true
		,resizable:false
		,items:[
			obj.ExistWorkItemGrid
			,obj.WorkFIDetailPanel
		]
	});
	
	obj.ExistWorkItemGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.WorkFItem';
		param.QueryName = 'QryWFItemList';
		param.Arg1 = obj.WorkFlowId;
		param.ArgCnt = 1;
	});	
	obj.ExistWorkItemGridStore.load({});

	obj.WorkDetailGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.WorkDetail';
		param.QueryName = 'QueryWorkDetail';
		param.ArgCnt = 0;
	});	

	obj.ExistWorkFIDetailGridStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.WorkFDetail';
		param.QueryName = 'QryWFDetailList';
		var aWFItemID=""
		var objRec = Ext.getCmp("ExistWorkItemGrid").getSelectionModel().getSelected();
		if (objRec)
		{
			aWFItemID = objRec.get("ID");
		}
		param.Arg1 = aWFItemID;
		param.ArgCnt = 1;
	});	
	
	InitWorkDetailEditEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}