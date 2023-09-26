function InitMonitorViewport(){
 var obj = new Object();
	obj.dfDateFrom = new Ext.form.DateField({
		id : 'dfDateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '��ʼ����'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		,value : new Date()
	});
	
	obj.dfDateTo = new Ext.form.DateField({
		id : 'dfDateTo'
		,width : 100
		,fieldLabel : '��������'
		,altFormats : 'Y-m-d|d/m/Y'
		,format : 'Y-m-d'
		,anchor : '99%'
		,value : new Date()
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
	//�������б�
	obj.cboOrdStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboOrdStore = new Ext.data.Store({
		proxy: obj.cboOrdStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OrdRowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OrdRowID', mapping: 'OrdRowID'}
			,{name: 'OrdCode', mapping: 'OrdCode'}
			,{name: 'OrdDesc', mapping: 'OrdDesc'}
		])
	});	
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '��ҽ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'CTLocID'
	});
	
	obj.cboOrd = new Ext.form.ComboBox({
		id : 'cboOrd'
		,width : 100
		,store : obj.cboOrdStore
		,minChars : 1
		,displayField : 'OrdDesc'
		,fieldLabel : '������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'OrdRowID'
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
		,width : 80
	});
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '����'
		,width : 80
	});
	
	obj.ConditionPanel = new Ext.Panel({
		id : 'ConditionPanel'
		,height : 35
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,frame:'true'
		,items:[
			{
				layout : 'column',
				items : [
					{
						width:160,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [obj.dfDateFrom]
					},{
						width:160,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [obj.dfDateTo]
					},{
						columnWidth:.40,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 70,
						items : [obj.cboLoc]
					},{
						columnWidth:.60,
						layout : 'form',
						labelAlign : 'right',
						labelWidth : 60,
						items : [obj.cboOrd]
					}
					,{
						width:80,
						layout : 'form',
						items : [obj.btnQuery]
					},{
						width:80,
						layout : 'form',
						items : [obj.btnExport]
					}
				]
			}
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
			idProperty: 'RowID'
		}, 
		[    //OrdLoc,Doctor,PatName,PatSex,PatAge,AdmLoc,CurrWard,CurrBedCode,OrdName,PHCCateg,PHCSubCat,SttDate,SttTime,PHCFreqDesc2,PHCInstrucDesc1,OrdDoseQty,UOMDesc
			 {name: 'RowID', mapping: 'RowID'}
			,{name: 'OrdLoc', mapping: 'OrdLoc'}
			,{name: 'Doctor', mapping: 'Doctor'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'CurrWard', mapping: 'CurrWard'}
			,{name: 'CurrBedCode', mapping: 'CurrBedCode'}
			,{name: 'OrdName', mapping: 'OrdName'}
			,{name: 'OrdType', mapping: 'OrdType'}
			,{name: 'PHCCateg', mapping: 'PHCCateg'}
			,{name: 'PHCSubCat', mapping: 'PHCSubCat'}
			,{name: 'SttDate', mapping: 'SttDate'}
			,{name: 'SttTime', mapping: 'SttTime'}
			,{name: 'PHCFreqDesc2', mapping: 'PHCFreqDesc2'}
			,{name: 'PHCInstrucDesc1', mapping: 'PHCInstrucDesc1'}
			,{name: 'OrdDoseQty', mapping: 'OrdDoseQty'}
			,{name: 'UOMDesc', mapping: 'UOMDesc'}
			,{name: 'PAPMIMedicare', mapping: 'PAPMIMedicare'}
			,{name: 'SttDateTime', mapping: 'SttDateTime'}
			,{name: 'EndDateTime', mapping: 'EndDateTime'}
		])
	});
	obj.ResultGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ResultGridPanel = new Ext.grid.GridPanel({
		id : 'ResultGridPanel'
		,loadMask : true
		,store : obj.ResultGridPanelStore
		,region : 'center'
		,frame : true
		//,viewConfig : {forceFit:true}
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��ҽ������', width: 120, dataIndex: 'OrdLoc', sortable: false, align: 'center'}
			,{header: '��ҽ��<br>ҽ��', width: 60, dataIndex: 'Doctor', sortable: false, align: 'center'}
			,{header: '��������', width: 60, dataIndex: 'PatName', sortable: false, align: 'center'}
			,{header: '������', width: 60, dataIndex: 'PAPMIMedicare', sortable: false, align: 'center'}
			,{header: '����<br>�Ա�', width: 50, dataIndex: 'PatSex', sortable: false, align: 'center'}
			,{header: '����<br>����', width: 50, dataIndex: 'PatAge', sortable: false, align: 'center'}
			,{header: '�������', width: 120, dataIndex: 'AdmLoc', sortable: false, align: 'center'}
			,{header: '���ﲡ��', width: 120, dataIndex: 'CurrWard', sortable: false, align: 'center'}
			,{header: '��λ��', width: 50, dataIndex: 'CurrBedCode', sortable: false, align: 'center'}
			,{header: 'ҽ������', width: 250, dataIndex: 'OrdName', sortable: false, align: 'left'}
			,{header: 'ҽ������', width: 80, dataIndex: 'OrdType', sortable: false, align: 'center'}
			,{header: 'ҩѧ����', width: 80, dataIndex: 'PHCCateg', sortable: false, align: 'center'}
			,{header: 'ҩѧ����', width: 80, dataIndex: 'PHCSubCat', sortable: false, align: 'center'}
			,{header: 'ҽ����ʼ<br>����ʱ��', width: 100, dataIndex: 'SttDateTime', sortable: false, align: 'center'}
			,{header: 'ҽ��ֹͣ<br>����ʱ��', width: 100, dataIndex: 'EndDateTime', sortable: false, align: 'center'}
			,{header: 'Ƶ��', width: 100, dataIndex: 'PHCFreqDesc2', sortable: false, align: 'center'}
			,{header: '�÷�', width: 100, dataIndex: 'PHCInstrucDesc1', sortable: false, align: 'center'}
			,{header: '����', width: 80, dataIndex: 'OrdDoseQty', sortable: false, align: 'center'}
			,{header: '����<br>��λ', width: 80, dataIndex: 'UOMDesc', sortable: false, align: 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : obj.ResultGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
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
			param.ClassName = 'DHCMed.NINFService.Srv.OEOrdItemAnti';
			param.QueryName = 'QryAntiByDateLoc';
			param.Arg1= obj.dfDateFrom.getValue();
			param.Arg2= obj.dfDateTo.getValue();
			param.Arg3= obj.cboLoc.getValue();
			param.Arg4= obj.cboOrd.getValue();
			param.ArgCnt = 4;
	});	
	obj.ResultGridPanelStore.load({
		params : {
			start: 0
			,limit: 1000
		}
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboLocStore.load();
	obj.cboOrdStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Srv.OEOrdItemAnti';
			param.QueryName = 'QryArcimByAnti';
			param.Arg1 = obj.cboOrd.getRawValue();
			param.ArgCnt = 1;
	});
	obj.cboOrdStore.load();
	//�¼��������
	InitMonitorViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;	
}