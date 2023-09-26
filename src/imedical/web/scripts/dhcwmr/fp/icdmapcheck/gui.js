function InitViewPort()
{
	var obj = new Object();
	obj.cboMark = new Ext.form.ComboBox({
		id : 'cboMark'
		,name :'cboMark'
		,fieldLabel : '编码类型'
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'D'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:['svalue','stext'],
			data:[["D","诊断"],["O","手术"]]
		})
	});
	obj.dfDateFrom = Common_DateFieldToDate("dfDateFrom","对照日期");
	obj.dfDateTo = Common_DateFieldToDate("dfDateTo","至");
	obj.txtBuildUser = Common_TextField("txtBuildUser","对照人员");
	obj.txtAlias = Common_TextField("txtAlias","关键字");
	obj.txtMRICD10 = Common_TextField("txtMRICD10","临床编码");
	obj.txtMRICDDesc = Common_TextField("txtMRICDDesc","临床名称");
	obj.txtFPICD10 = Common_TextField("txtFPICD10","对照编码");
	obj.txtFPICDDesc = Common_TextField("txtFPICDDesc","对照名称");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");

	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,anchor : '100%'
		,text : '查询'
	});

	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,width : 70
		,anchor : '100%'
		,text : '审核'
	});

	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 70
		,anchor : '100%'
		,text : '删除'
	});

	obj.gridMappingStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMappingStore = new Ext.data.Store({
		proxy: obj.gridMappingStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'FPType', mapping : 'FPType'}
			,{name: 'Mark', mapping : 'Mark'}
			,{name: 'MarkDesc', mapping : 'MarkDesc'}
			,{name: 'MRICD10', mapping : 'MRICD10'}
			,{name: 'MRICDDesc', mapping : 'MRICDDesc'}
			,{name: 'FPICD10', mapping : 'FPICD10'}
			,{name: 'FPICDDesc', mapping : 'FPICDDesc'}
			,{name: 'BuildDate', mapping : 'BuildDate'}
			,{name: 'BuildTime', mapping : 'BuildTime'}
			,{name: 'BuildUser', mapping : 'BuildUser'}
			,{name: 'CheckDate', mapping : 'CheckDate'}
			,{name: 'CheckTime', mapping : 'CheckTime'}
			,{name: 'CheckUser', mapping : 'CheckUser'}
			,{name: 'IsActive', mapping : 'IsActive'}
			,{name: 'Resume', mapping : 'Resume'}
		])
	});
	obj.gridMapping = new Ext.grid.GridPanel({
		id : 'gridMapping'
		,store : obj.gridMappingStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '诊断/手术', width: 70, dataIndex: 'MarkDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '临床编码', width: 70, dataIndex: 'MRICD10', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '临床名称', width: 120, dataIndex: 'MRICDDesc', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '对照编码', width: 70, dataIndex: 'FPICD10', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '对照名称', width: 120, dataIndex: 'FPICDDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '对照日期', width: 70, dataIndex: 'BuildDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '对照人员', width: 70, dataIndex: 'BuildUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核日期', width: 70, dataIndex: 'CheckDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核时间', width: 70, dataIndex: 'CheckTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '审核人员', width: 70, dataIndex: 'CheckUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 55, dataIndex: 'IsActive', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '备注', width: 80, dataIndex: 'Resume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });

	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 40,
				layout : 'column',
				frame : true,
				buttonAlign : 'center',
				items : [
					{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.cboMark]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.dfDateFrom]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.dfDateTo]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtBuildUser]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtAlias]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.chkIsActive]
					},{
						columnWidth:.02
					},{
						width:70
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.btnQuery]
					}
				]
			},{
				region:'south',
				height:80,
				layout : 'column',
				frame : true,
				buttonAlign : 'center',
				items:[
					{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtMRICD10]
					},{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtMRICDDesc]
					},{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtFPICD10]
					},{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtFPICDDesc]
					},{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.txtResume]
					}
				]
				,buttons:[obj.btnSave,obj.btnDelete]
			}
			,obj.gridMapping
		]
	});

	obj.gridMappingStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.FPMappingSrv';
		param.QueryName = 'QueryMapping';
		param.Arg1 = Common_GetValue("cboMark");
		param.Arg2 = Common_GetValue("dfDateFrom");
		param.Arg3 = Common_GetValue("dfDateTo");
		param.Arg4 = Common_GetValue("txtBuildUser");
		param.Arg5 = Common_GetValue("txtAlias");
		param.Arg6 = Common_GetValue("chkIsActive")?1:0;

		param.ArgCnt =6;
	});

	InitViewPortEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}