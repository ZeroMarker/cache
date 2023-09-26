function InitMonitorViewport(){
 var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 100
		,fieldLabel : '��������'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.pConditionChild1 = new Ext.Panel({
		id : 'pConditionChild1'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateFrom
		]
	});
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '��'
		,altFormats : 'Y-m-d|d/m/Y'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,anchor : '99%'
		,value : new Date()
	});
	obj.pConditionChild2 = new Ext.Panel({
		id : 'pConditionChild2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.dfDateTo
		]
	});	
	//�����б�
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
});
	obj.pConditionChild3 = new Ext.Panel({
		id : 'pConditionChild3'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.cboLoc
		]
	});
	//·���б�
	obj.cboPathWayDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboPathWayDicStore = new Ext.data.Store({
		proxy: obj.cboPathWayDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'CurrVersion', mapping: 'CurrVersion'}
		])
	});
	obj.cboPathWayDic = new Ext.form.ComboBox({
		id : 'cboPathWayDic'
		,minChars : 1
		,store : obj.cboPathWayDicStore
		,valueField : 'ID'
		,fieldLabel : '��������'
		,displayField : 'Desc'
		,triggerAction : 'all'
		,width : 100
		,anchor : '99%'
	});	
	obj.pConditionChild4 = new Ext.Panel({
		id : 'pConditionChild4'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,items:[
		obj.cboPathWayDic
		]
	});	
 obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
});
	obj.ConditionSubPanel = new Ext.form.FormPanel({
		id : 'ConditionSubPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'column'
		,frame : true
		,region : 'center'
		,items:[
			obj.pConditionChild1
			,obj.pConditionChild2
			,obj.pConditionChild3
			,obj.pConditionChild4
			,obj.btnQuery
			]
	});  
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 50
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'border'   //fix IE11 ҳ���Ϸ���ѯ����δ��ʾ
		,frame:'true'
		,items:[
		obj.ConditionSubPanel
		]
	});
	obj.ResultGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ResultGridPanelStore = new Ext.data.Store({
		proxy: obj.ResultGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Paadm'
		}, 
		[
			 {name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmRoomBed', mapping: 'AdmRoomBed'}		
			,{name: 'DiagnoseDesc', mapping: 'DiagnoseDesc'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'NotInCPWReason', mapping: 'NotInCPWReason'}
			,{name: 'NotInCPWResume', mapping: 'NotInCPWResume'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		,viewConfig : {forceFit:true}
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�����', width: 70, dataIndex: 'Paadm', sortable: false, align: 'center',hidden : true}
			,{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: false, align: 'center'}
			,{header: '��������', width: 70, dataIndex: 'PatName', sortable: false, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'Age', sortable: false, align: 'center'}
			,{header: '�Ա�', width: 70, dataIndex: 'Sex', sortable: false, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'AdmLoc', sortable: false, align: 'center'}
			,{header: '����', width: 70, dataIndex: 'AdmWard', sortable: false, align: 'center'}
			,{header: '��λ', width: 70, dataIndex: 'AdmRoomBed', sortable: false, align: 'center'}	
			,{header: '���������', width: 70, dataIndex: 'DiagnoseDesc', sortable: false, align: 'center'}
			,{header: '�ʺ�·������', width: 70, dataIndex: 'CPWDesc', sortable: false, align: 'center'}
			,{header: '��Ժҽ��', width: 70, dataIndex: 'AdmDoc', sortable: false, align: 'center'}
			,{header: 'δ�뾶ԭ��', width: 70, dataIndex: 'NotInCPWReason', sortable: false, align: 'center'}
			,{header: 'δ�뾶��ע', width: 70, dataIndex: 'NotInCPWResume', sortable: false, align: 'center'}
		]
	});
	obj.MonitorViewport = new Ext.Viewport({
		id : 'MonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ResultGridPanel
		]
	});	
	obj.ResultGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.CheckNoInPath';
			param.QueryName = 'QueryNIPath';
			param.Arg1 = obj.dfDateFrom.getRawValue();
			param.Arg2 = obj.dfDateTo.getRawValue();
			param.Arg3= obj.cboLoc.getValue();
			param.Arg4= obj.cboPathWayDic.getValue();
			param.ArgCnt = 4;
	});	
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.SysBaseSrv';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboLocStore.load();
	obj.cboPathWayDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysDicSrv';
			param.QueryName = 'QryClinPathWayDic';
			param.Arg1 = 'N';
			param.Arg2 = 'Y';
			param.Arg3 = obj.cboPathWayDic.getRawValue();
			param.ArgCnt = 3;      //add by wuqk 2011-11-19 ������Ч·�������˲���֢
	});
	obj.cboPathWayDicStore.load();
	InitMonitorViewportEvent(obj);
	//�¼��������
	obj.btnQuery.on("click", obj.btnQuery_click, obj);	
	obj.LoadEvent(arguments);
	return obj;	
}