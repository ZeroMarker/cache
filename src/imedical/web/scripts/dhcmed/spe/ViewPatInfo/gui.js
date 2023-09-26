function InitViewPatInfo(paadm) {
	var obj = new Object();
	obj.paadm = paadm;
	
	obj.txtRegNo = new Ext.form.TextField({fieldLabel:'���￨��',readOnly:true,width:250});
	obj.txtMrNo = new Ext.form.TextField({fieldLabel:'סԺ��',readOnly:true,width:250});
	obj.txtName = new Ext.form.TextField({fieldLabel:'��������',readOnly:true,width:250});
	obj.txtSex = new Ext.form.TextField({fieldLabel:'�Ա�',readOnly:true,width:250});
	obj.txtAge = new Ext.form.TextField({fieldLabel:'����',readOnly:true,width:250});
	obj.txtAdmitDate = new Ext.form.TextField({fieldLabel:'סԺ����',readOnly:true,width:250});
	obj.txtWard = new Ext.form.TextField({fieldLabel:'����',readOnly:true,width:250});
	
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
			,{header: '��������', width: 250, dataIndex: 'DiseaseName', sortable: true}
			,{header: '�������', width: 120, dataIndex: 'Type', sortable: true}
		]	});
	obj.gridAdmitDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.BaseInfoQry';
			param.QueryName = 'GetMRICDByAdm';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});
	obj.gridAdmitDiagnoseStore.load({});
	obj.objBasePane =({
		title:'������Ϣ',
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
			,{header: '��������', width: 250, dataIndex: 'OperationName', sortable: true}
			,{header: 'ҽ������', width: 120, dataIndex: 'StartDate', sortable: true}
			,{header: 'ҽ��ʱ��', width: 120, dataIndex: 'StartTime', sortable: true}
			,{header: '״̬', width: 80, dataIndex: 'Status', sortable: true}
		]	});
	obj.gridOperationStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.BaseInfoQry';
			param.QueryName = 'QryOperByAdm';
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
			,{header: '�����������', width: 250, dataIndex: 'OrderName', sortable: true}
			,{header: 'ҽ������', width: 120, dataIndex: 'StartDate', sortable: true}
			,{header: '״̬', width: 80, dataIndex: 'OrderStatus', sortable: true}
		]	});
		
		obj.gridLabStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.BaseInfoQry';
			param.QueryName = 'QryLabByAdm';
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
			,{name: 'days', type:'int',mapping: 'days'}
		])
	});
	obj.gridDrugCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridDrug = new Ext.grid.GridPanel({
		store : obj.gridDrugStore
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'arcim', width: 0, dataIndex: 'arcim', sortable: true}
			,{header: '����', width: 250, dataIndex: 'arcimDesc', sortable: true}
			,{header: '��ʼ��ҩ����', width: 120, dataIndex: 'startDate', sortable: true}
			,{header: '������ҩ����', width: 120, dataIndex: 'endDate', sortable: true}
			,{header: '��ҩ����', width: 100, dataIndex: 'days', sortable: true}
		]	});
		
	obj.gridDrugStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SPEService.BaseInfoQry';
			param.QueryName = 'QryOrderByAdm';
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
	obj.tblBaseInfo.setTitle("������Ϣ");
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.operationPanel));
	obj.tblBaseInfo.setTitle("������Ϣ");
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.LabPanel));
	obj.tblBaseInfo.setTitle("���������Ϣ");
	obj.tblBaseInfo = obj.tabFrm.add(new Ext.FormPanel(obj.DrugPanel));
	obj.tblBaseInfo.setTitle("����ҩ����Ϣ");
	
	obj.WinPatInfo = new Ext.Window({
		title:'���߻�����Ϣ',
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
				text:'�ر�',
				handler: function(){
					obj.WinPatInfo.close();
				}
			}
		]
	});
	
	InitViewPatInfoEvent(obj);
	obj.LoadEvent();
	return obj;
}