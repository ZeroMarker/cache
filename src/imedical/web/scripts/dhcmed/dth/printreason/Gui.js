
function InitPrintReasonSubWindow(reportId){
	var obj = new Object();
	obj.PrintReasonSubGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PrintReasonSubGridPanelStore = new Ext.data.Store({
		proxy: obj.PrintReasonSubGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReasonDesc'
		}, 
		[
			 {name: 'PrintType', mapping : 'PrintType'}
			,{name: 'PrintDate', mapping : 'PrintDate'}
			,{name: 'PrintTime', mapping : 'PrintTime'}
			,{name: 'PrintUser', mapping: 'PrintUser'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'PrintNum', mapping: 'PrintNum'}
			,{name: 'UserID', mapping: 'UserID'}
		])
	});
	obj.PrintReasonSubGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PrintReasonSubGridPanel = new Ext.grid.GridPanel({
		id : 'PrintReasonSubGridPanel'
		,store : obj.PrintReasonSubGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '��ӡ����', width: 120, dataIndex: 'PrintType', sortable: false}
			,{header: '��ӡ����', width: 120, dataIndex: 'PrintDate', sortable: false}
			,{header: '��ӡʱ��', width: 120, dataIndex: 'PrintTime', sortable: false}
			,{header: '��ӡ��', width: 120, dataIndex: 'PrintUser', sortable: true}
			,{header: '����ԭ��', width: 250, dataIndex: 'ResumeText', sortable: true}
			,{header: '��ӡ����', width: 120, dataIndex: 'PrintNum', sortable: true}
			,{header: '��Ȩ��', width: 120, dataIndex: 'UserID', sortable: true}
		]
	});
	obj.PrintReasonSubWindow = new Ext.Window({
		id : 'PrintReasonSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '����֤�����ӡ��ϸ'
		,layout : 'border'
		,height : 350
		,width : 800
		,modal: true
		,items:[
			obj.PrintReasonSubGridPanel
		]
	});
	obj.PrintReasonSubGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.DTHService.ReportSrv';
			param.QueryName = 'QryPrintReasonByInDate';
			param.Arg1 = reportId;
		    param.ArgCnt = 1;
	});
	InitPrintReasonSubWindowEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

