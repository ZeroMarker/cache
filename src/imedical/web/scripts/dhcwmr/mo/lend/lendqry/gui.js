function InitViewport()
{
	var obj = new Object();
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType 	= Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","查询日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	obj.cboLendLoc 	= Common_ComboToLendLoc("cboLendLoc","借阅科室","E","","cboHospital");
	obj.cboLendDoc 	= Common_ComboToLendUser("cboLendDoc","借阅医生","cboLendLoc");
	
	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,labelSeparator :''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 150
	});
	
	obj.cboQryType = new Ext.form.ComboBox({
		id : 'cboQryType'
		,name :'cboQryType'
		,fieldLabel : ''
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'LL'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:['svalue','stext'],
			data:[["LL","出库"],["LB","入库"]]
		})
	});
	
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
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'PapmiNo', mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'HospDesc', mapping : 'HospDesc'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			,{name: 'LendDate', mapping : 'LendDate'}
			,{name: 'LendLoc', mapping : 'LendLoc'}
			,{name: 'LendUser', mapping : 'LendUser'}
			,{name: 'BackDate', mapping : 'BackDate'}
			,{name: 'BackUser', mapping : 'BackUser'}
		])
	});

	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : ['->',{text:'病案号：',style:'font-weight:bold;font-size:17px;',xtype:'label'},obj.txtMrNo,'-',obj.btnQry,'-',obj.btnExport,'-',obj.btnPrint]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 70, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '归属院区', width: 80, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 80, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅日期', width: 80, dataIndex: 'LendDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅科室', width: 90, dataIndex: 'LendLoc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '操作员', width: 70, dataIndex: 'LendUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '归还日期', width: 80, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '归还人', width: 100, dataIndex: 'BackUser', sortable: false, menuDisabled:true, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridResultStore,
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
						columnWidth:.18
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						columnWidth:.14
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboMrType]
					},{
						columnWidth:.06
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 1
						,items:[obj.cboQryType]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.dfDateFrom]
					},{
						columnWidth:.12
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 20
						,items:[obj.dfDateTo]
					},{
						columnWidth:.16
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboLendLoc]
					},{
						columnWidth:.18
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items:[obj.cboLendDoc]
					}
					
				]
			},obj.gridResult
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.LendQry';
		param.QueryName = 'QryLend';
		param.Arg1 = obj.GetQueryInput();
		param.ArgCnt = 1;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}