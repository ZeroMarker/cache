function InitviewScreen(){
	var obj = new Object();
	
	obj.RecRowID = '';
	obj.TypeCode =  '';
	obj.GroupCode = "";
	
	obj.cboCategoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCategoryStore = new Ext.data.Store({
		proxy: obj.cboCategoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicRowID', mapping: 'DicRowID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicType', mapping: 'DicType'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.cboCategory = new Ext.form.ComboBox({
		id : 'cboCategory'
		,store : obj.cboCategoryStore
		,minChars : 1
		,displayField : 'DicDesc'
		,fieldLabel : '请选择对照类别'
		,labelSeparator :''
		,valueField : 'DicCode'
		,editable : false
		,width : 200
		,triggerAction : 'all'
	});
	
	obj.txtSrcObjID = Common_TextField("txtSrcObjID","源值");
	obj.txtSrcObjDesc = Common_TextField("txtSrcObjDesc","描述");
	obj.txtTargetID = Common_TextField("txtTargetID","目标值");
	obj.txtTargetDesc = Common_TextField("txtTargetDesc","描述");
	obj.txtResume = Common_TextField("txtResume","说明");
	
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 80
		,text : '删除'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '更新'
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'SrcType', mapping: 'SrcType'}
			,{name: 'SrcValID', mapping: 'SrcValID'}
			,{name: 'SrcValDesc', mapping: 'SrcValDesc'}
			,{name: 'Target', mapping: 'Target'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,columnLines : true
		,region : 'center'
		,tbar : new Ext.Toolbar({
			items: [
				new Ext.form.Label({text : '请选择对照类别'}),
				obj.cboCategory
			]
		})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '源值', width: 100, dataIndex: 'SrcValID', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '源值描述', width: 150, dataIndex: 'SrcValDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '目标值', width: 100, dataIndex: 'Target', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '目标值描述', width: 150, dataIndex: 'TargetDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '说明', width: 200, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridResultStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcObjID]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcObjDesc]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtTargetID]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtTargetDesc]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
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
							obj.gridResult
						]
					}
				],
				bbar : [obj.btnFind,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.DicMapping';
		param.QueryName = 'QryByTypeCodeNew';
		
		param.Arg1 = obj.cboCategory.getValue();
		param.Arg2 = obj.txtSrcObjID.getValue();   //Common_GetValue("txtSrcObjID");
		param.Arg3 = obj.txtSrcObjDesc.getValue();   //Common_GetValue("txtSrcObjDesc");
		param.Arg4 = obj.txtTargetID.getValue();   //Common_GetValue("txtTargetID");
		param.Arg5 = obj.txtTargetDesc.getValue();

		param.ArgCnt = 5;
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.DictionarySrv';
		param.QueryName = 'QryDicByType';
		param.Arg1 = 'DicMappingType';
		param.Arg2 = ""
		param.Arg3 = ""
		
		param.ArgCnt = 3;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

