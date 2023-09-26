function InitViewport1(){
	var obj = new Object();
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	} else {
		obj.AdminPower  = AdminPower;
	}
	
	obj.RecRowID = "";
	obj.txtDate = Common_DateFieldToDate("txtDate","<b style='color:red'>*</b>检测日期");
	obj.cboLoc = Common_ComboToLoc("cboLoc","<b style='color:red'>*</b>采样科室");
	obj.cboItem = Common_ComboToDic("cboItem","<b style='color:red'>*</b>检测项目","NINFEnviHyItemCategory");
	obj.txtItemValue = Common_NumberField("txtItemValue","<b style='color:red'>*</b>项目值");
	obj.cboUom = Common_ComboToDic("cboUom","<b style='color:red'>*</b>单位","NINFEnviHyNormUom");
	obj.txtResume = Common_TextField("txtResume","备注");


	obj.gridEnviHyRepAddStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));

	obj.gridEnviHyRepAddStore = new Ext.data.Store({
		proxy: obj.gridEnviHyRepAddStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ForMulaID'
		},
		[  
			{name: 'RepAddID', mapping : 'RepAddID'}
			,{name: 'LocID', mapping : 'LocID'}
			,{name: 'LocDesc', mapping : 'LocDesc'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepItemID', mapping : 'RepItemID'}
			,{name: 'RepItemDesc', mapping : 'RepItemDesc'}
			,{name: 'RepValue', mapping: 'RepValue'}
			,{name: 'RepUomID', mapping: 'RepUomID'}
			,{name: 'RepUomDesc', mapping: 'RepUomDesc'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'aDate', mapping: 'aDate'}
		])
	});

	obj.gridEnviHyRepAdd = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyRepAdd'
		,store : obj.gridEnviHyRepAddStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '采样日期', width: 100, dataIndex: 'aDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '采样科室', width: 150, dataIndex: 'LocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '采样人', width: 80, dataIndex: 'RepUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '检测项目', width: 150, dataIndex: 'RepItemDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '项目值', width: 80, dataIndex: 'RepValue', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 80, dataIndex: 'RepUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 240, dataIndex: 'Resume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridEnviHyRepAddStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	obj.btnQuery = new Ext.Toolbar.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
	});
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,width: 80
		,text : '保存'
	});
	
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
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
						height: 65,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtDate]
									},{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboLoc]
									},{
										width :180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboItem]
									},{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtItemValue]
									},{
										width : 140
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 50
										,items: [obj.cboUom ]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth : 1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.gridEnviHyRepAdd
						]
					}
				],
				bbar : [obj.btnQuery,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridEnviHyRepAddStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINF.Rep.EnviHyReportAdd';
		param.QueryName = 'QryEnviHyRepAdd';
		param.Arg1 =  Common_GetValue('txtDate');
		param.Arg2 =  Common_GetValue('cboLoc');
		param.ArgCnt = 2;

	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

