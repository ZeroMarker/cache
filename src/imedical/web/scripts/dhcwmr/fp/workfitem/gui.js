function InitViewport1()
{
	var obj = new Object();
	obj.CurrFPItemID = '';
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 100
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 100
		,text : '删除'
	});	
	
	obj.cboWorkFlowStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWorkFlowStore = new Ext.data.Store({
		proxy: obj.cboWorkFlowStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'WFlowID'
		}, 
		[
			{name: 'WFlowID', mapping: 'ID'}
			,{name: 'WFlowDesc', mapping: 'Desc'}
		])
	});
	obj.cboWorkFlow = new Ext.form.ComboBox({
		id : 'cboWorkFlow'
		,width : 340
		,store : obj.cboWorkFlowStore
		,minChars : 1
		,valueField : 'WFlowID'
		,displayField : 'WFlowDesc'
		,fieldLabel : "<font color='red'>*</font>工作流"
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	//操作项目
	obj.cboWFItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWFItemStore = new Ext.data.Store({
		proxy: obj.cboWFItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'WFItemID'
		}, 
		[
			{name: 'WFItemID', mapping : 'WFItemID'}
			,{name: 'WFItemDesc', mapping: 'WFItemDesc'}
		])
	});
	obj.cboWFItem = new Ext.form.ComboBox({
		id : 'cboWFItem'
		,width : 340
		,store : obj.cboWFItemStore
		,minChars : 1
		,valueField : 'WFItemID'
		,displayField : 'WFItemDesc'
		,fieldLabel : "<font color='red'>*</font>操作项目"
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	//诊断库
	obj.cboICDVersionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboICDVersionStore = new Ext.data.Store({
		proxy: obj.cboICDVersionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'VerID'
		}, 
		[
			{name: 'VerID', mapping : 'Id'}
			,{name: 'VerCode', mapping : 'Code'}
			,{name: 'VerDesc', mapping: 'Desc'}
		])
	});
	obj.cboICDVersion = new Ext.form.ComboBox({
		id : 'cboICDVersion'
		,width : 340
		,store : obj.cboICDVersionStore
		,minChars : 1
		,valueField : 'VerID'
		,displayField : 'VerDesc'
		,fieldLabel : "<font color='red'>*</font>诊断库"
		,labelSeparator :''
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	//中医诊断库
	obj.cboICDVer2StoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboICDVer2Store = new Ext.data.Store({
		proxy: obj.cboICDVer2StoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'VerID'
		}, 
		[
			{name: 'VerID', mapping : 'Id'}
			,{name: 'VerCode', mapping : 'Code'}
			,{name: 'VerDesc', mapping: 'Desc'}
		])
	});
	obj.cboICDVer2 = new Ext.form.ComboBox({
		id : 'cboICDVer2'
		,width : 340
		,store : obj.cboICDVer2Store
		,minChars : 1
		,valueField : 'VerID'
		,displayField : 'VerDesc'
		,fieldLabel : '中医诊断库'
		,labelSeparator :''
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	//手术库编码
	obj.cboOprVersionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboOprVersionStore = new Ext.data.Store({
		proxy: obj.cboOprVersionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'VerID'
		}, 
		[
			{name: 'VerID', mapping : 'Id'}
			,{name: 'VerCode', mapping : 'Code'}
			,{name: 'VerDesc', mapping: 'Desc'}
		])
	});
	obj.cboOprVersion = new Ext.form.ComboBox({
		id : 'cboOprVersion'
		,width : 340
		,store : obj.cboOprVersionStore
		,minChars : 1
		,valueField : 'VerID'
		,displayField : 'VerDesc'
		,fieldLabel : "<font color='red'>*</font>手术库"
		,labelSeparator :''
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.cbgFPType = Common_RadioGroupToDC("cbgFPType","<font color='red'>*</font>类型","FPStepType",2);
	
	obj.GridFPItemListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridFPItemListStore = new Ext.data.Store({
		proxy: obj.GridFPItemListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'FPItemID'
		}, 
		[
			{name: 'FPItemID', mapping: 'FPItemID'}
			,{name: 'WFlowID', mapping: 'WFlowID'}
			,{name: 'WFlowDesc', mapping: 'WFlowDesc'}
			,{name: 'WFItemID', mapping: 'WFItemID'}
			,{name: 'WFItemDesc', mapping: 'WFItemDesc'}
			,{name: 'TypeCode', mapping: 'TypeCode'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'ICDVerID', mapping: 'ICDVerID'}
			,{name: 'ICDVerCode', mapping: 'ICDVerCode'}
			,{name: 'ICDVerDesc', mapping: 'ICDVerDesc'}
			,{name: 'OPRVerID', mapping: 'OPRVerID'}
			,{name: 'OPRVerCode', mapping: 'OPRVerCode'}
			,{name: 'OPRVerDesc', mapping: 'OPRVerDesc'}
			,{name: 'ICDVer2ID', mapping: 'ICDVer2ID'}
			,{name: 'ICDVer2Code', mapping: 'ICDVer2Code'}
			,{name: 'ICDVer2Desc', mapping: 'ICDVer2Desc'}
		])
	});
	
	obj.GridFPItemList = new Ext.grid.EditorGridPanel({
		id : 'GridFPItemList'
		,store : obj.GridFPItemListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines:true
		,loadMask : true
		,region : 'center'
		//,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '工作流', width: 100, dataIndex: 'WFlowDesc', align: 'center'}
			,{header: '项目名称', width: 80, dataIndex: 'WFItemDesc', align: 'center'}
			,{header: '类型', width: 50, dataIndex: 'TypeDesc', align: 'center'}
			,{header: '诊断库', width: 80, dataIndex: 'ICDVerDesc', align: 'center'}
			,{header: '手术库', width: 80, dataIndex: 'OPRVerDesc', align: 'center'}
			,{header: '中医诊断库', width: 80, dataIndex: 'ICDVer2Desc', align: 'center'}
			,{header: '关联项', width: 50 , dataIndex: 'FPItemID' , align : 'center' ,
				renderer : function(v, m, rd, r, c, s){
					var FPItemID = rd.get("FPItemID");
					return " <a href='#' onclick='DisplayFPItemExtraWin(\"" + FPItemID + "\");'>编辑</a>";
				}
			}
			,{header: '备注', width: 150, dataIndex: 'Resume', align: 'center'}
			
		],viewConfig : {
			forceFit : true
		}
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 70,
						layout : 'form',   //fix IE11 页面下方选择条件未显示
						frame : true,
						items : [
						{
								layout : 'column',
								items : [
									{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboWorkFlow]
									},{
										width:170
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboWFItem]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.cbgFPType]
									}
								]
						},{
								layout : 'column',
								items : [
									{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboICDVersion]
									},{
										width:170
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboOprVersion]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.cboICDVer2]
									},{
										width:170
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtResume]
									}
								]
						 }	
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.GridFPItemList
						]
					}
				],
				bbar : [obj.btnSave,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.GridFPItemListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FP.WorkFItem';
		param.QueryName = 'QryWorkFItem';
		param.ArgCnt = 0;
	});
	
	//工作流列表
	obj.cboWorkFlowStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.WorkFlow';
		param.QueryName = 'QryWorkFlow';
		param.ArgCnt = 0;
	});
	
	//工作流项目
	obj.cboWFItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.WorkFItemSrv';
		param.QueryName = 'QryWItemToCbo';
		param.Arg1 = Common_GetValue('cboWorkFlow');
		param.ArgCnt = 1;
	});
	
	//诊断库
	obj.cboICDVersionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ICDVersion"
		param.QueryName = "QryICDVersion"
		param.ArgCnt = 0
	});
	
	//中医诊断库
	obj.cboICDVer2StoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ICDVersion"
		param.QueryName = "QryICDVersion"
		param.ArgCnt = 0
	});
	
	//手术库编码
	obj.cboOprVersionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ICDVersion"
		param.QueryName = "QryICDVersion"
		param.ArgCnt = 0
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}