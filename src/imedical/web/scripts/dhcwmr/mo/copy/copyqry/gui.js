function InitViewport()
{
	var obj = new Object();
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","查询日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	
	obj.btnQry = new Ext.Button({
		id : 'btnQry'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 60
		,anchor : '100%'
		,text : '导出'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 60
		,anchor : '100%'
		,text : '打印'
	});
	
	obj.gridCopyDeailStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCopyDeailStore = new Ext.data.Store({
		proxy: obj.gridCopyDeailStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ind'
		},[
			{name: 'ind', mapping : 'ind'}
			,{name: 'ID', mapping : 'ID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'HospDesc', mapping : 'HospDesc'}
			,{name: 'RegDate', mapping : 'RegDate'}
			,{name: 'PaperNumber', mapping : 'PaperNumber'}
			,{name: 'Money', mapping : 'Money'}
			,{name: 'CreateUser', mapping : 'CreateUser'}
		])
	});

	obj.gridCopyDeail = new Ext.grid.GridPanel({
		id : 'gridCopyDeail'
		,store : obj.gridCopyDeailStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : ['->','-',obj.btnQry,'-',obj.btnExport,'-',obj.btnPrint]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '归属院区', width: 70, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '复印日期', width: 70, dataIndex: 'RegDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '复印张数', width: 70, dataIndex: 'PaperNumber', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '金额', width: 70, dataIndex: 'Money', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作员', width: 70, dataIndex: 'CreateUser', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridCopyDeailStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
    });
    
    obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			{
				region:'north'
				,layout:'column'
				,height: 40
				,frame: true
				,items:[
					{
						columnWidth:.2
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						columnWidth:.15
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboMrType]
					},{
						columnWidth:.17
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.dfDateFrom]
					},{
						columnWidth:.13
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items:[obj.dfDateTo]
					}
				]
			},obj.gridCopyDeail
		]
	});
	
	obj.gridCopyDeailStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.CopyQry';
		param.QueryName = 'QryCopyDeail';
		param.Arg1 = Common_GetValue("cboHospital")
		param.Arg2 = Common_GetValue("cboMrType")
		param.Arg3 = Common_GetValue("dfDateFrom")
		param.Arg4 = Common_GetValue("dfDateTo")
		param.ArgCnt = 4;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}