var CHR_1=String.fromCharCode(1);
function InitBranchMonitorViewport(){
	var obj = new Object();
	obj.SubPanel1Label = new Ext.form.Label({
		id : 'SubPanel1Label'
		,autoHeight : true
		,region : 'center'
		,text : '��֧���ٴ�·��ͳ��'
	});
	obj.ConditionSubPanel1 = new Ext.form.FormPanel({
		id : 'ConditionSubPanel1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 25
		,layout : 'border'
		,frame : true
		,items:[
			obj.SubPanel1Label
		]
	});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,fieldLabel : '��Ժ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	obj.nulla = new Ext.Panel({
		id : 'nulla'
		,width : 150
		,anchor : '50%'
	});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,width : 150
		,fieldLabel : '��'
		,altFormats : 'Y-m-d|d/m/Y'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,anchor : '99%'
		,value : new Date()
	});
	obj.nullb = new Ext.Panel({
		id : 'nullb'
		,width : 150
		,anchor : '50%'
	});
	
	
	

	//*****************************���� ��֧���ٴ�·��
	obj.OffShootStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OffShootStore = new Ext.data.Store({
		proxy: obj.OffShootStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CPWRowId'
		}, 
		[
			{name: 'CPWRowId', mapping: 'Rowid'}
			,{name: 'CPWCode', mapping: 'Code'}
			,{name: 'CPWDesc', mapping: 'Desc'}
			,{name: 'CPWOffShoot', mapping: 'CPWOffShoot'}
		])
	});
	obj.cboOffShoot = new Ext.form.ComboBox({
		id : 'cboOffShoot'
		,width : 80
		,store : obj.OffShootStore
		,displayField : 'CPWDesc'
		,fieldLabel : '·��'
		,editable : false
		,mode: 'local'
		,forceSelection : true
		,selectOnFocus : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CPWRowId'
	});
	obj.OffShootStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'GetPathWays';
			param.Arg1 = '';
			param.ArgCnt = 0;
	});
	obj.OffShootStore.load({});
	
	
	obj.cboStatTitleProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboStatTitleStore = new Ext.data.Store({
		proxy: obj.cboStatTitleProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Title', mapping: 'Title'}
		])
	});
	
	obj.cboStatTitle = new Ext.form.ComboBox({
		id : 'cboStatTitle'
		,width : 120
		,store : obj.cboStatTitleStore
		,displayField : 'Title'
		,editable : false
		,mode: 'local'
		,forceSelection : true
		,selectOnFocus : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'Rowid'
	});
	
	obj.cboStatTitleProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'QueryOffShootStatTitle';
			param.ArgCnt = 0;
	});
	obj.cboStatTitleStore.load({});
	
	
	//****end***
	
	obj.ConditionSubPanel2Child1 = new Ext.Panel({
		id : 'ConditionSubPanel2Child1'
		,buttonAlign : 'center'
		,columnWidth : .20
		//--,height : 115
		,layout : 'form'
		,labelWidth: 60
		,title:'����'
		,labelAlign : 'center'
		,items:[
			obj.DateFrom
			//,obj.nulla
			,obj.DateTo
			//,obj.nullb
			,obj.cboOffShoot
			//,obj.cboStatTitle
		]
	});


	//***************************��ʾ���в�������
	obj.StepStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.StepStore = new Ext.data.Store({
		proxy: obj.StepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BD_RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicCode', mapping: 'BD_Code'}
			,{name: 'StepDesc', mapping: 'BD_Desc'}
		])
	});
	obj.StepGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 20 });
	obj.StepGrid = new Ext.grid.GridPanel({
		id : 'StepGrid'
		,store : obj.StepStore
		,columnWidth : .20
		,height : 120
		,autoScroll :true
		,title : '��������'
		,hideHeaders : true
		,columns: [
			obj.StepGridCheckCol
			,{header: '��������', width: 150, dataIndex: 'StepDesc'}
		]
		,plugins: obj.StepGridCheckCol
	});
	obj.StepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'QryDicBySubCatDesc';
			param.Arg1 = 'STEPTYPE';
			param.Arg2 = 'Y';
			param.ArgCnt = 2;
	});
	obj.StepStore.load({});
	
	//*****************************��ʾ �ϲ�֢
	obj.SyndromeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SyndromeStore = new Ext.data.Store({
		proxy: obj.SyndromeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'Rowid', mapping : 'Rowid'}	
			,{name: 'CPWDCode', mapping: 'Code'}
			,{name: 'CPWDDesc', mapping: 'Desc'}
		])
	});
	obj.SyndromeGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 20 });
	obj.SyndromeGrid = new Ext.grid.GridPanel({
		id : 'SyndromeGrid'
		,store : obj.SyndromeStore
		,columnWidth : .20
		,height : 120
		,title : '�ϲ�֢'
		,hideHeaders : true
		,autoScroll :true
		,columns: [
			obj.SyndromeGridCheckCol
			,{header: '�ϲ�֢',width: 168, dataIndex: 'CPWDDesc'}
		]
		,plugins: obj.SyndromeGridCheckCol
	});
	obj.SyndromeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'GetSyndrome';
			param.Arg1 = '';
			param.ArgCnt = 0;
	});
	obj.SyndromeStore.load({});
	//******************************* ��Panel ���Ч��
	obj.nullc = new Ext.Panel({
		id : 'nullc'
		,columnWidth : .005
	});
	obj.nulld = new Ext.Panel({
		id : 'nulld'
		,columnWidth : .005
	});
	//****************************** �ƶ���ť
	
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,width : 50
		,anchor : '95%'
		,text : '>>'
	});
	obj.ConditionSubPanel2Child4 = new Ext.Panel({
		id : 'ConditionSubPanel2Child4'
		,buttonAlign : 'center'
		,columnWidth : .06
		//--,height : 70
		,layout : 'form'
		,buttons :[
			obj.btnAdd
		]
	});
	//******************************** �ȶԿ�
	
	obj.Panel51aLabela = new Ext.form.Label({
		id : 'Panel51aLabela'
		,autoHeight : true
		,columnWidth : .95
		,text : '�Ա��б�'
	});
	obj.Panel51aLabelb = new Ext.form.Label({
		id : 'Panel51aLabelb'
		,autoHeight : true
		,columnWidth : .05
	});
	obj.Panel51a = new Ext.Panel({
		id : 'Panel51a'
		,layout : 'column'
		,columnWidth : .4
		,height : 15
		,items : [
			obj.Panel51aLabelb
			,obj.Panel51aLabela
		]
	});
	
	//*****************************��ʾ ��֧��ͳ������
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text : '����'
	});
	obj.btnClear = new Ext.Button({
		id : 'btnClear'
		,text : '���'
	});
	
	
	obj.OffShootStatTitleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OffShootStatTitleStore = new Ext.data.Store({
		proxy: obj.OffShootStatTitleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'Index', mapping : 'Index'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'Key', mapping: 'Key'}
			,{name: 'checked', mapping: 'checked'}
		])
	});
	obj.OffShootStatTitleGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 20 });
	obj.OffShootStatTitleGrid = new Ext.grid.GridPanel({
		id : 'OffShootStatTitleGrid'
		,store : obj.OffShootStatTitleStore
		,columnWidth : .33
		//--,height : 105
		,height : 120
		//,title : 'ͳ������'
		,hideHeaders : true
		,autoScroll :true
		,columns: [
			obj.OffShootStatTitleGridCheckCol
			,{header: '����',width: 300, dataIndex: 'ItemDesc'}
		]
		,plugins: obj.OffShootStatTitleGridCheckCol
		,tbar:['ͳ������',obj.cboStatTitle,'-',obj.btnSave,obj.btnClear]
	});
	obj.OffShootStatTitleStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'QueryItemsByTitle';
			//param.Arg1 = '';
			param.ArgCnt = 1;
	});
	


	obj.btnAnalysis = new Ext.Button({
		id : 'btnAnalysis'
		,anchor : '95%'
		,text : 'ͳ��'
		,disabled : false
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,anchor : '95%'
		,text : '����'
	});
	/*
	obj.ConditionSubPanel2 = new Ext.Panel({
		id : 'ConditionSubPanel2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		//,height : 165
		,layout : 'column'
		,frame : true
		,items:[
			obj.ConditionSubPanel2Child1
			,obj.StepGrid
			//,obj.nullc
			,obj.SyndromeGrid
			,obj.ConditionSubPanel2Child4
			//,obj.nulld
			,obj.OffShootStatTitleGrid //ConditionSubPanel2Child5
		]
		,buttons:[
			obj.btnAnalysis
			,obj.btnExport
		]
	});*/
	
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 185
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,frame : true 
		,items:[
			//obj.ConditionSubPanel1
			//obj.ConditionSubPanel2
			obj.ConditionSubPanel2Child1
			,obj.StepGrid
			//,obj.nullc
			,obj.SyndromeGrid
			,obj.ConditionSubPanel2Child4
			//,obj.nulld
			,obj.OffShootStatTitleGrid //ConditionSubPanel2Child5
		],buttons:[
			obj.btnAnalysis
			,obj.btnExport
		]
	});
	
	//***********************************************************GRID 
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL,
			timeout:180000      //Add By Niucaicai 2011-08-10  ���س�ʱ����3����
		}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocDesc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CPWDesc', mapping: 'CPWDesc'}
			,{name: 'CPWDischNum', mapping: 'CPWDischNum'}
			,{name: 'InCPWNum', mapping: 'InCPWNum'}
			,{name: 'CloseCPWNum', mapping: 'CloseCPWNum'}
			,{name: 'OutCPWNum', mapping: 'OutCPWNum'}
			,{name: 'InDays', mapping: 'InDays'}
			,{name: 'OutDays', mapping: 'OutDays'}
			,{name: 'CloseDays', mapping: 'CloseDays'}
			,{name: 'InRatio', mapping: 'InRatio'}
			,{name: 'OutRatio', mapping: 'OutRatio'}
			,{name: 'InCost', mapping: 'InCost'}
			,{name: 'CloseRatio', mapping: 'CloseRatio'}
			,{name: 'CloseCost', mapping: 'CloseCost'}
			,{name: 'InDrugRatio', mapping: 'InDrugRatio'}
			,{name: 'VarianceCount', mapping: 'VarianceCount'}
			,{name: 'VarianceRatio', mapping: 'VarianceRatio'}
			,{name: 'repid', mapping: 'repid'}
			,{name: 'index', mapping: 'index'}
		])
	});
	obj.expander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.Template(
            '<p></p><br>'
        )
    });
	//obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 20 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.GridPanelStore
		,region : 'center'
		,frame : true
		,loadMask : true
		,buttonAlign : 'center'
		,columns: [
			//obj.expander,
			{header: '����·��', width: 200, dataIndex: 'CPWDesc', sortable: false}
			,{header: '�뾶����', width: 60, dataIndex: 'InCPWNum', sortable: false}
			,{header: '��������', width: 60, dataIndex: 'OutCPWNum', sortable: false}
			,{header: '�������', width: 60, dataIndex: 'CloseCPWNum', sortable: false}
			,{header: '��������', width: 60, dataIndex: 'VarianceCount', sortable: false}
			,{header: '������', width: 60, dataIndex: 'OutRatio', sortable: false}
			,{header: '�����', width: 60, dataIndex: 'CloseRatio', sortable: false}
			,{header: '������', width: 60, dataIndex: 'VarianceRatio', sortable: false}
			,{header: 'ƽ��סԺ��', width: 60, dataIndex: 'InDays', sortable: false}
			,{header: '�ξ�����', width: 60, dataIndex: 'CloseCost', sortable: false}
			,{header: 'ҩ�ѱ�', width: 60, dataIndex: 'InDrugRatio', sortable: false}
			//,{header: 'repid', width: 0, dataIndex: 'repid', sortable: false}
			//,{header: 'index', width: 0, dataIndex: 'index', sortable: false}
		]/*
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.GridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})*/
		,viewConfig: {
            forceFit:true
        }
		//,plugins: obj.expander
		,iconCls: 'icon-grid'
		,listeners : {
      		'rowdblclick': function(){
						var rc = obj.GridPanel.getSelectionModel().getSelected();
						var repid=rc.get("repid");
						var index=rc.get("index");
						var title=rc.get("CPWDesc");
      			rowDblClick(event,repid,index,title);
      		}
      	}
	});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'QryCPWDischStat';
			param.Arg1 = obj.DateFrom.getRawValue();
			param.Arg2 = obj.DateTo.getRawValue();
			//param.Arg3 = obj.cboOffShoot.getValue();
			param.ArgCnt = 3;
	});
	obj.ListPanel = new Ext.Panel({
		id : 'ListPanel'
		,region : 'center'
		,layout : 'border'
		,items :[
			obj.GridPanel	
		]
	});
	function rowDblClick(evt,repid,index,title)
	{
		var objWin = new Object();

		objWin.PaGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));

		objWin.PaGridPanelStore = new Ext.data.Store({
		proxy: objWin.PaGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'AdmitTime', mapping: 'AdmitTime'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'DisTime', mapping: 'DisTime'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmDoc', mapping: 'AdmDoc'}
			,{name: 'AdmDays', mapping: 'AdmDays'}
			,{name: 'CountCost', mapping: 'CountCost'}
			,{name: 'VarReason', mapping: 'VarReason'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'DrugRatio', mapping: 'DrugRatio'}
			,{name: 'OutReasonDesc', mapping: 'OutReasonDesc'}
		])
		});
		//obj.PaGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
		objWin.PaGridPanel = new Ext.grid.GridPanel({
			id : 'PaGridPanel'
			,loadMask : true
			,store : objWin.PaGridPanelStore
			,region : 'center'
			//,frame : true
			,buttonAlign : 'center'
			,columns: [
				//new Ext.grid.RowNumberer()
				{header: '�ǼǺ�', width: 70, dataIndex: 'PapmiNo', sortable: true}
				,{header: '����', width: 60, dataIndex: 'PatName', sortable: true}
				,{header: '�Ա�', width: 40, dataIndex: 'Sex', sortable: true}
				,{header: '����', width: 40, dataIndex: 'Age', sortable: true}
				,{header: '����', width: 120, dataIndex: 'AdmLoc', sortable: true}
				,{header: 'ҽ��', width: 60, dataIndex: 'AdmDoc', sortable: true}
				,{header: '״̬', width: 60, dataIndex: 'StatusDesc', sortable: true}
				,{header: '��Ժ����', width: 80, dataIndex: 'AdmitDate', sortable: true}
				,{header: '��Ժʱ��', width: 60, dataIndex: 'AdmitTime', sortable: true}
				,{header: '��Ժ����', width: 80, dataIndex: 'DisDate', sortable: true}
				,{header: '��Ժʱ��', width: 60, dataIndex: 'DisTime', sortable: true}
				,{header: 'סԺ����', width: 60, dataIndex: 'AdmDays', sortable: true}
				,{header: 'ʵ�ʷ���', width: 60, dataIndex: 'CountCost', sortable: true}
				,{header: 'ҩ�ѱ�', width: 60, dataIndex: 'DrugRatio', sortable: true}
				,{header: '����ԭ��', width: 150, dataIndex: 'VarReason', sortable: false}
				,{header: '����ԭ��', width: 150, dataIndex: 'OutReasonDesc', sortable: false}
			]
		});
		objWin.PaGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.BranchAnalysis';
			param.QueryName = 'QryDetails';
			param.Arg1 = repid;
			param.Arg2 = index;
			param.ArgCnt = 2;
		});

		PaWindow = new Ext.Window({
			id : 'PaWindow',
			width : (screen.width-280), //870,
			height : 300,
			x : 20,
			y : evt.clientY+10,
			resizable : false,
			closable : true,
			autoScroll:true,
			animCollapse : true,
			//html:template,
			renderTo : document.body,
			layout : 'border',
			modal : true,
			title : title,
			items : [
				objWin.PaGridPanel
			]
		});

		PaWindow.show();
		objWin.PaGridPanelStore.load({});
	}
	//**********************************************************************************************GRID
	

	obj.BranchMonitorViewport = new Ext.Viewport({
		id : 'BranchMonitorViewport'
		,region : document.body
		,layout : 'border'
		,items:[
			obj.ConditionPanel
			,obj.ListPanel
		]
	});
	InitBranchMonitorViewportEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}