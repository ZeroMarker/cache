function InitPatientDtl(aEpisodeID, aSubjectCode){
	var obj = new Object();
	obj.EpisodeID = aEpisodeID;
	obj.SubjectCode = aSubjectCode;
	
	obj.PaadmSrv = ExtTool.StaticServerObject("DHCMed.Base.PatientAdm");
	obj.PaadmObj = obj.PaadmSrv.GetObjById(obj.EpisodeID);
	obj.PatientID = obj.PaadmObj.PatientID;
	obj.AdmitDate = obj.PaadmObj.AdmitDate;
	
	//���ָ���б� obj.pnCtlRst
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete', function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.pnCtlRstStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.pnCtlRstStore = new Ext.data.GroupingStore({
		proxy: obj.pnCtlRstStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ResultID'
		}, [
			{name: 'ResultID', mapping : 'ResultID'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemGroup', mapping: 'ItemGroup'}
			,{name: 'ItemCatID', mapping: 'ItemCatID'}
			,{name: 'ItemCatDesc', mapping: 'ItemCatDesc'}
			,{name: 'Summary', mapping: 'Summary'}
			,{name: 'ActDate', mapping: 'ActDate'}
			,{name: 'ActTime', mapping: 'ActTime'}
			,{name: 'ActUser', mapping: 'ActUser'}
			,{name: 'OccurDate', mapping: 'OccurDate'}
			,{name: 'OccurTime', mapping: 'OccurTime'}
			,{name: 'ObjEndDate', mapping: 'ObjEndDate'}
			,{name: 'ObjEndTime', mapping: 'ObjEndTime'}
			,{name: 'DataValue', mapping: 'DataValue'}
			,{name: 'ObjectID', mapping: 'ObjectID'}
		])
		,sortInfo:{field: 'ResultID', direction: "ASC"}
		,groupField:'ItemCatDesc'
	});
	obj.pnCtlRst = new Ext.grid.GridPanel({
		id : 'pnCtlRst'
		,title : '��Ⱦ���ָ��'
		,store : obj.pnCtlRstStore
		,buttonAlign : 'center'
		,columnLines : true
		,loadMask : true
		,tbar : {
			items :[
				{text : '��¼����',xtype :'label'},
				{
					id : 'dtCtlRstFromDate',
					fieldLabel : '��ʼ����',
					format : 'Y-m-d',
					value : new Date()-1,
					xtype : 'datefield'
				},
				{text : '��',xtype :'label'},
				{
					id : 'dtCtlRstToDate',
					fieldLabel : '��������',
					format : 'Y-m-d',
					value : new Date(),
					xtype : 'datefield'
				},{
					id : 'btnCtlRstQuery',
					text : '��ѯ',
					icon  : '../scripts/dhcmed/img/find.gif',
					xtype : 'button' ,
					handler: function(){
						var objStore = obj.pnCtlRstStore;
						objStore.removeAll();
						objStore.load({});
					}
				}
			]
		}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header : '��Ŀ', width : 120, dataIndex : 'ItemDesc', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����', width : 60, dataIndex : 'ItemGroup', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��Ŀ����', width : 80, dataIndex : 'ItemCatDesc', sortable: true, menuDisabled:true, hidden:true, align:'center' }
			,{header : 'ժҪ', width: 150, dataIndex: 'Summary', sortable: false, menuDisabled:true, align: 'center'}
			,{header : '�������', width : 70, dataIndex : 'ActDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '���ʱ��', width : 60, dataIndex : 'ActTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����Ա', width : 60, dataIndex : 'ActUser', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��������', width : 70, dataIndex : 'OccurDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����ʱ��', width : 60, dataIndex : 'OccurTime', sortable: false, menuDisabled:true, align:'center' }
			,{header : '��������', width : 70, dataIndex : 'ObjEndDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '����ʱ��', width : 60, dataIndex : 'ObjEndTime', sortable: false, menuDisabled:true, align:'center' }
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '{[values.rs[0].get("ItemCatDesc")]}��{[values.rs.length]}����¼'
			,groupByText:'�����з���'
		})
	});
	obj.pnCtlRstStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.CtlResultSrv';
		param.QueryName = 'QryCtlResultDtl';
		param.Arg1 = obj.EpisodeID;
		param.Arg2 = obj.SubjectCode;
		param.Arg3 = Ext.getCmp("dtCtlRstFromDate").getRawValue();
		param.Arg4 = Ext.getCmp("dtCtlRstToDate").getRawValue();
		param.ArgCnt = 4;
	});
	
	//������Ϣ-����б�
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
		function(conn, response, Options){
		if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
			ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
		}
	);
	obj.gridDiagnoseStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridDiagnoseStore = new Ext.data.Store({
		proxy: obj.gridDiagnoseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ARowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ARowID', mapping: 'ARowID'}
			,{name: 'AMRADMRowId', mapping: 'AMRADMRowId'}
			,{name: 'ADiaSubID', mapping: 'ADiaSubID'}
			,{name: 'ADiagnosTypeID', mapping: 'ADiagnosTypeID'}
			,{name: 'ADiagnosType', mapping: 'ADiagnosType'}
			,{name: 'AICDID', mapping: 'AICDID'}
			,{name: 'AICDCode', mapping: 'AICDCode'}
			,{name: 'ADiagnosName', mapping: 'ADiagnosName'}
			,{name: 'ADemo', mapping: 'ADemo'}
			,{name: 'AEvaluation', mapping: 'AEvaluation'}
			,{name: 'AEvaluationDesc', mapping: 'AEvaluationDesc'}
			,{name: 'AEffects', mapping: 'AEffects'}
			,{name: 'AEffectsDesc', mapping: 'AEffectsDesc'}
			,{name: 'ALevel', mapping: 'ALevel'}
			,{name: 'ASquence', mapping: 'ASquence'}
			,{name: 'AUserName', mapping: 'AUserName'}
			,{name: 'ADateTime', mapping: 'ADateTime'}
		])
	});
	obj.gridDiagnose = new Ext.grid.GridPanel({
		id : 'gridDiagnose'
		,store : obj.gridDiagnoseStore
		,buttonAlign : 'center'
		,title : '�����Ϣ'
		,region : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}
		,viewConfig : {forceFit : true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '�������', width: 100, dataIndex: 'ADiagnosType', sortable: true}
			,{header: 'ICD', width: 100, dataIndex: 'AICDCode', sortable: true}
			,{header: '�������', width: 200, dataIndex: 'ADiagnosName', sortable: true}
			,{header: '״̬', width: 100, dataIndex: 'AEvaluationDesc', sortable: true}
			,{header: 'ICDת��', width: 100, dataIndex: 'AEffectsDesc', sortable: true}
			,{header: '����', width: 100, dataIndex: 'ALevel', sortable: true}
			,{header: '˳��', width: 100, dataIndex: 'ASquence', sortable: true}
			,{header: 'ҽʦ', width: 100, dataIndex: 'AUserName', sortable: true}
			,{header: '���ʱ��', width: 100, dataIndex: 'ADateTime', sortable: true}
		]
	});
	obj.gridDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.CCService.Feedback.EpisodeService';
		param.QueryName = 'GetMRDiagnosList';
		param.Arg1 = obj.EpisodeID;
		param.ArgCnt = 1;
	});
	//������Ϣ-������Ϣ
	var EpisodePanel = new ExtTool.EpisodePanel({EpisodeId:obj.EpisodeID});
	EpisodePanel.setTitle("������Ϣ");
	obj.EpisodePanel = new Ext.Panel({
		id : 'EpisodePanel'
		,title : '������Ϣ'
		,region:'north'
		,layout : 'fit'
		,height:160
		,items:[
			EpisodePanel
		]
	});
	//������Ϣ
	obj.pnBaseInfo = new Ext.Panel({
		title : '������Ϣ'
		,layout : 'border'
		,items:[
			obj.EpisodePanel
			,obj.gridDiagnose
		]
	});
	
	obj.pnLab = new Ext.Panel({
		title : '���鱨��',
		html : '<iframe id="ifLab" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnTimeLine = new Ext.Panel({
		id : 'pnTimeLine'
		,buttonAlign : 'center'
		,title : '��Ⱦ������ͼ'
		,html : '<iframe id="ifTimeLine" height="100%" width="100%" src="#" />' 
	});
	
	obj.ViewObservation = new Ext.Panel({
		id : 'ViewObservation'
		,buttonAlign : 'center'
		,title : '��������'
		,html : '<iframe id="ifViewObservation" height="100%" width="100%" src="#" />' 
	});
	
	obj.pnEpr = new Ext.Panel({
		title : '�������',
		html : '<iframe id="ifEpr" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnOrder = new Ext.Panel({
		title : 'ҽ����',
		html : '<iframe id="ifOrder" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnRis= new Ext.Panel({
		title : '��鱨��',
		html : '<iframe id="ifRis" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnClose = new Ext.Panel({
		title : '�ر�'
	});
	
	obj.TabPanelList = new Ext.TabPanel({
		id : 'TabPanelList'
		,frame : true
		,activeTab : 0
		,items:[
			obj.pnTimeLine
			,obj.pnCtlRst
			,obj.pnEpr
			,obj.pnOrder
			,obj.pnLab
			,obj.pnRis
			,obj.ViewObservation
			,obj.pnBaseInfo
			,obj.pnClose
		]
	});
	
	obj.WinPatientDtl = new Ext.Window({
		id : 'WinPatientDtl'
		,width : 800
		,height : 600
		,layout : 'fit'
		,closable : false
		,modal : true
		,maximized : true
		,title : '���Ʋ���-ժҪ��Ϣ'
		,items:[
			obj.TabPanelList
		]
	});
	
	InitPatientDtlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

