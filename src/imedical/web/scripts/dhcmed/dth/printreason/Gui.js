
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
			,{header: '打印类型', width: 120, dataIndex: 'PrintType', sortable: false}
			,{header: '打印日期', width: 120, dataIndex: 'PrintDate', sortable: false}
			,{header: '打印时间', width: 120, dataIndex: 'PrintTime', sortable: false}
			,{header: '打印人', width: 120, dataIndex: 'PrintUser', sortable: true}
			,{header: '补打原因', width: 250, dataIndex: 'ResumeText', sortable: true}
			,{header: '打印次数', width: 120, dataIndex: 'PrintNum', sortable: true}
			,{header: '授权人', width: 120, dataIndex: 'UserID', sortable: true}
		]
	});
	obj.PrintReasonSubWindow = new Ext.Window({
		id : 'PrintReasonSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '死亡证明书打印明细'
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
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

