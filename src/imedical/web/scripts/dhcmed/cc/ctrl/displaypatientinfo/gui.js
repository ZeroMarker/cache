function DisplayPatientWin(paadm) {
	var obj = new Object();
	obj.paadm = paadm;
	obj.txtRegNo = new Ext.form.TextField({fieldLabel:'就诊卡号',readOnly:true,width:250});
	obj.txtMrNo = new Ext.form.TextField({fieldLabel:'住院号',readOnly:true,width:250});
	obj.txtName = new Ext.form.TextField({fieldLabel:'患者姓名',readOnly:true,width:250});
	obj.txtSex = new Ext.form.TextField({fieldLabel:'性别',readOnly:true,width:250});
	obj.txtAge = new Ext.form.TextField({fieldLabel:'年龄',readOnly:true,width:250});
	obj.txtAdmitDate = new Ext.form.TextField({fieldLabel:'住院日期',readOnly:true,width:250});
	obj.txtWard = new Ext.form.TextField({fieldLabel:'病房',readOnly:true,width:250});


	obj.gridAdmitDiagnoseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridAdmitDiagnoseStore = new Ext.data.Store({
		proxy: obj.gridAdmitDiagnoseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ICD'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ICD', mapping: 'ICD'}
			,{name: 'DiseaseName', mapping: 'DiseaseName'}
			,{name: 'Type', mapping: 'Type'}
		])
	});
	obj.gridAdmitDiagnoseCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridAdmitDiagnose = new Ext.grid.GridPanel({
		height:200
		,store : obj.gridAdmitDiagnoseStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ICD', width: 100, dataIndex: 'ICD', sortable: true}
			,{header: '疾病名称', width: 250, dataIndex: 'DiseaseName', sortable: true}
			,{header: '诊断类型', width: 120, dataIndex: 'Type', sortable: true}
		]	});
	obj.gridAdmitDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.IMPService.PatBaseInfoQry';
			param.QueryName = 'GetMrDiagnose';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});
	obj.gridAdmitDiagnoseStore.load({});
	obj.objBasePane =({
		title:'基本信息',
		xtype:'fieldset',
		frame:true,
		//autoHeight:true,
		width:780,
		//defaults: {width: 800},
		//defaultType: 'textfield',
		layout:"form",
		//renderTo:"BasePanel",
		items:[
			//update by zf 2008-08-20
			
			{
				layout:'column',
				items:[
					{
						columnWidth:.5,
						layout: 'form',
						items:[obj.txtRegNo,obj.txtName,obj.txtAge,obj.txtWard]
					},
					{
						columnWidth:.5,
						layout: 'form',
						items:[obj.txtMrNo,obj.txtSex,obj.txtAdmitDate]
					}
				]
			}
			,obj.gridAdmitDiagnose
		]
   	});



	obj.gridOperationStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridOperationStore = new Ext.data.Store({
		proxy: obj.gridOperationStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrderID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderID', mapping: 'OrderID'}
			,{name: 'OperationName', mapping: 'OperationName'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'Status', mapping: 'Status'}
		])
	});
	obj.gridOperationCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridOperation = new Ext.grid.GridPanel({
		store : obj.gridOperationStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'OrderID', width: 0, dataIndex: 'OrderID', sortable: true}
			,{header: '手术名称', width: 250, dataIndex: 'OperationName', sortable: true}
			,{header: '医嘱日期', width: 120, dataIndex: 'StartDate', sortable: true}
			,{header: '医嘱时间', width: 120, dataIndex: 'StartTime', sortable: true}
			,{header: '状态', width: 80, dataIndex: 'Status', sortable: true}
		]	});
	obj.gridOperationStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.IMPService.PatBaseInfoQry';
			param.QueryName = 'QueryOperation';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});
	obj.gridOperationStore.load({});
	
obj.operationPanel = new Ext.Panel({
		layout:"fit",
		items:[obj.gridOperation]
	
	}); 






	obj.gridLabStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridLabStore = new Ext.data.Store({
		proxy: obj.gridLabStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrderID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrderID', mapping: 'OrderID'}
			,{name: 'OrderName', mapping: 'OrderName'}
			,{name: 'StartDate', mapping: 'StartDate'}
			,{name: 'OrderStatus', mapping: 'OrderStatus'}
			,{name: 'LabTestNo', mapping: 'LabTestNo'}
		])
	});
	obj.gridLabCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridLab = new Ext.grid.GridPanel({
		store : obj.gridLabStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'OrderID', width: 0, dataIndex: 'OrderID', sortable: true}
			,{header: '辅助检查名称', width: 250, dataIndex: 'OrderName', sortable: true}
			,{header: '医嘱日期', width: 120, dataIndex: 'StartDate', sortable: true}
			,{header: '状态', width: 80, dataIndex: 'OrderStatus', sortable: true}
		]	});
		
		obj.gridLabStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.IMPService.PatBaseInfoQry';
			param.QueryName = 'QueryLab';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});	
	obj.gridLabStore.load({});	
		
		
obj.LabPanel = new Ext.Panel({
		layout:"fit",
		items:[obj.gridLab]
	
	}); 	    


	obj.gridDrugStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridDrugStore = new Ext.data.Store({
		proxy: obj.gridDrugStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'arcim'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'arcim', mapping: 'arcim'}
			,{name: 'arcimDesc', mapping: 'arcimDesc'}
			,{name: 'startDate', mapping: 'startDate'}
			,{name: 'endDate', mapping: 'endDate'}
			,{name: 'days', mapping: 'days'}
		])
	});
	obj.gridDrugCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridDrug = new Ext.grid.GridPanel({
		store : obj.gridDrugStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'arcim', width: 0, dataIndex: 'arcim', sortable: true}
			,{header: '名称', width: 250, dataIndex: 'arcimDesc', sortable: true}
			,{header: '开始用药日期', width: 120, dataIndex: 'startDate', sortable: true}
			,{header: '状态', width: 120, dataIndex: 'endDate', sortable: true}
			,{header: '用药天数', width: 100, dataIndex: 'days', sortable: true}
		]	});
		
	obj.gridDrugStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.IMPService.PatBaseInfoQry';
			param.QueryName = 'QueryOrder';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});	
	obj.gridDrugStore.load({});
		
		
obj.DrugPanel = new Ext.Panel({
		layout:"fit",
		items:[	obj.gridDrug]
	
	}); 


	obj.tabFrm = new Ext.TabPanel({
		//width:800,
		//height:300,
		//autoHeight:true,
		activeTab: 0,
		frame:true
	});
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.objBasePane));
	obj.tblBaseInfo.setTitle("基本信息");
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.operationPanel));
	obj.tblBaseInfo.setTitle("手术信息");	
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.LabPanel));
	obj.tblBaseInfo.setTitle("辅助检查信息");	
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.DrugPanel));
	obj.tblBaseInfo.setTitle("抗菌药物信息");	
	

obj.objDisplayWin = new Ext.Window({
		title:'患者基本信息',
		layout:'fit',
		bodyStyle:'padding:5px;',
		maximizable:false,
		//closable:false,
		//collapsible:true,
		shadow:true,
		modal:true,
		width:820,
		height:400,
		closeAction:'hide',
		plain: true,
		//autoHeight: true,
		//renderTo:"MainPanel",
		//modal:true,
		items:[obj.tabFrm],
		buttons:[
	   {
	   	text:'关闭',
	   	handler: function()
	   	{
	   		obj.objDisplayWin.close();
	   	}
	   }
	  ]
	});
	        		
	        		
	InitEventDisplayPatient(obj);
	
	
	obj.gridLab.on("rowdblclick", obj.gridLab_rowdblclick, obj);
	
	
	
	obj.LoadEvent();
	return obj;
}