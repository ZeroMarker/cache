
function InitInfRepInfoSubWindow(EpisodeID,RepTypeID){
	var obj = new Object();
	obj.InfRepInfoSubGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.InfRepInfoSubGridPanelStore = new Ext.data.Store({
		proxy: obj.InfRepInfoSubGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		}, 
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'TransID', mapping: 'TransID'}
			,{name: 'ReportTypeID', mapping: 'ReportTypeID'}
			,{name: 'ReportTypeDesc', mapping: 'ReportTypeDesc'}
			,{name: 'ReportLocID', mapping: 'ReportLocID'}
			,{name: 'ReportLocDesc', mapping: 'ReportLocDesc'}
			,{name: 'ReportUserID', mapping: 'ReportUserID'}
			,{name: 'ReportUserDesc', mapping: 'ReportUserDesc'}
			,{name: 'ReportDate', mapping: 'ReportDate'}
			,{name: 'ReportTime', mapping: 'ReportTime'}
			,{name: 'ReportStatusID', mapping: 'ReportStatusID'}
			,{name: 'ReportStatusDesc', mapping: 'ReportStatusDesc'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'AdmLoc', mapping: 'AdmLoc'}
			,{name: 'AdmWard', mapping: 'AdmWard'}
			,{name: 'AdmBed', mapping: 'AdmBed'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatMrNo', mapping: 'PatMrNo'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'InfPos', mapping: 'InfPos'}
			,{name: 'InfDiag', mapping: 'InfDiag'}
			,{name: 'Specimen', mapping: 'Specimen'}
			,{name: 'TestResults', mapping: 'TestResults'}
			,{name: 'EveRepID', mapping: 'EveRepID'}
			,{name: 'IsHaveHisRep', mapping: 'IsHaveHisRep'}
		])
	});
	obj.InfRepInfoSubGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.InfRepInfoSubGridPanel = new Ext.grid.GridPanel({
		id : 'InfRepInfoSubGridPanel'
		,store : obj.InfRepInfoSubGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header : '����<br>״̬', width : 50, dataIndex : 'ReportStatusDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '�������', width : 100, dataIndex : 'ReportLocDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '������', width : 60, dataIndex : 'ReportUserDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��������', width : 80, dataIndex : 'ReportDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����ʱ��', width : 60, dataIndex : 'ReportTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ��λ', width : 60, dataIndex : 'InfPos', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ���', width : 60, dataIndex : 'InfDiag', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����걾', width : 60, dataIndex : 'Specimen', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ⱦ<br>��ԭ��', width : 60, dataIndex : 'TestResults', sortable: false, menuDisabled:true, align:'center' }
		]
	});
	obj.InfRepInfoSubWindow = new Ext.Window({
		id : 'InfRepInfoSubWindow'
		,plain : true
		,maxinizable : true
		,maximized : true
		,collapsed : true
		,resizable : false
		,title : '��Ⱦ�����б�'
		,layout : 'fit'
		,height : 350
		,width : 800
		,modal: true
		,items:[
			obj.InfRepInfoSubGridPanel
		]
	});
	obj.InfRepInfoSubGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Rep.InfReport';
			param.QueryName = 'QryReportByAdm';
			param.Arg1 = EpisodeID;
			param.Arg2 = RepTypeID;
			param.ArgCnt = 2;
	});
	InitInfRepInfoSubWindowEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

