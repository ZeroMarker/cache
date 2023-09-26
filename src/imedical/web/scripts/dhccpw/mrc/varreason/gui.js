
function InitWinVarReason(){
	var obj = new Object();
	
	obj.txtVRCode = new Ext.form.TextField({
		id : 'txtVRCode'
		,width : 150
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	obj.txtVRDesc = new Ext.form.TextField({
		id : 'txtVRDesc'
		,width : 150
		,fieldLabel : '描述'
		,anchor : '95%'
	});
	obj.cboVarCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboVarCategStore = new Ext.data.Store({
		proxy: obj.cboVarCategStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboVarCateg = new Ext.form.ComboBox({
		id : 'cboVarCateg'
		,width : 150
		,store : obj.cboVarCategStore
		,displayField : 'Desc'
		,fieldLabel : '变异类型'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
	});
	obj.dtVRDateFrom = new Ext.form.DateField({
		id : 'dtVRDateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,fieldLabel : '开始日期'
		,anchor : '95%'
		,altFormats : 'Y-m-d|d/m/Y'
	});
	obj.dtVRDateTo = new Ext.form.DateField({
		id : 'dtVRDateTo'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,fieldLabel : '结束日期'
		,anchor : '95%'
		,altFormats : 'Y-m-d|d/m/Y'
	});

	obj.cboVarReasonTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboVarReasonTypeStore = new Ext.data.Store({
		proxy: obj.cboVarReasonTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicCode'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
		])
	});
	obj.cboVarReasonType = new Ext.form.ComboBox({
		id : 'cboVarReasonType'
		,width : 150
		,store : obj.cboVarReasonTypeStore
		,displayField : 'DicDesc'
		,fieldLabel : '类型'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
	});
	obj.chkIsActive = new Ext.form.Checkbox({
		id : 'chkIsActive'
		,boxLabel : '是否有效'
	});
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.chkIsActive
		]
	});
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.txtVRCode
			,obj.txtVRDesc
			,obj.cboVarCateg
		]
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.dtVRDateFrom
			,obj.dtVRDateTo
			,obj.cboVarReasonType
		]
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.MainPanel = new Ext.form.FormPanel({
		id : 'MainPanel'
		,height:140
		,buttonAlign : 'center'
		,layout : 'column'
		,labelAlign : 'right'
		,frame:true
		,region : 'south'
		,labelWidth : 60
		,items:[
			//obj.SubPanel1
			obj.SubPanel2
			,obj.SubPanel3
			,obj.SubPanel1
		],	
		buttons:[
			obj.btnUpdate
			,obj.btnDelete
		]
	
	});
	obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'VRCode', mapping: 'VRCode'}
			,{name: 'VRDesc', mapping: 'VRDesc'}
			,{name: 'VRVarCategDesc', mapping: 'VRVarCategDesc'}
			,{name: 'VRDateFrom', mapping: 'VRDateFrom'}
			,{name: 'VRDateTo', mapping: 'VRDateTo'}
			,{name: 'VRVarCategDR', mapping: 'VRVarCategDR'}
			,{name: 'VRType', mapping: 'VRType'}
			,{name: 'VRTypeDesc', mapping: 'VRTypeDesc'}
			,{name: 'VRActive', mapping: 'VRActive'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: 'ID', width: 50, dataIndex: 'ID', sortable: true}
			,{header: '代码', width: 60, dataIndex: 'VRCode', sortable: true}
			,{header: '描述', width: 200, dataIndex: 'VRDesc', sortable: true}
			,{header: '变异类型', width: 150, dataIndex: 'VRVarCategDesc', sortable: true}
			,{header: '开始日期', width: 80, dataIndex: 'VRDateFrom', sortable: true}
			,{header: '结束日期', width: 80, dataIndex: 'VRDateTo', sortable: true}
			,{header: '类别', width: 100, dataIndex: 'VRTypeDesc', sortable: true}
			,{header: '是否有效', width: 100, dataIndex: 'VRActive', sortable: true}
		]
		,stripeRows : true
                ,autoExpandColumn : 'VRDesc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MainGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	
	obj.WinVarReason = new Ext.Viewport({
		id : 'WinVarReason'
		,height : 520
		,buttonAlign : 'center'
		,width : 800
		,title : '变异原因维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MainPanel
			,obj.MainGridPanel
		]
		
	});
	
	obj.cboVarCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceCategory';
			param.QueryName = 'QryVarCateg';
			param.Arg1 = "";
			param.ArgCnt = 1;
	});
	obj.cboVarCategStore.load({});
	
	obj.cboVarReasonTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseConfig';
			param.QueryName = 'QryBaseDic';
			param.Arg1 = "VarReasonType";
			param.ArgCnt = 1;
	});
	obj.cboVarReasonTypeStore.load({});
	
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.VarianceReason';
			param.QueryName = 'QueryAll';
			param.ArgCnt = 0;
	});
	obj.MainGridPanelStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitWinVarReasonEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

