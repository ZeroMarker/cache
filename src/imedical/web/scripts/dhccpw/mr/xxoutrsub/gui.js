
function InitOutReasonSubWindow(QryType,CPWID,DateFrom,DateTo,LocID,WardID,CPWDesc){
	var obj = new Object();
	obj.OutReasonSubGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.OutReasonSubGridPanelStore = new Ext.data.Store({
		proxy: obj.OutReasonSubGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReasonDesc'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ReasonDesc', mapping: 'ReasonDesc'}
			,{name: 'CategDesc', mapping: 'CategDesc'}
			,{name: 'ItemCount', mapping: 'ItemCount'}
			,{name: 'Ratio', mapping: 'Ratio'}
		])
	});
	obj.OutReasonSubGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.OutReasonSubGridPanel = new Ext.grid.GridPanel({
		id : 'OutReasonSubGridPanel'
		,store : obj.OutReasonSubGridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����ԭ��', width: 150, dataIndex: 'ReasonDesc', sortable: false}
			,{header: '����', width: 50, dataIndex: 'ItemCount', sortable: true}
			,{header: '�ٷֱ�', width: 50, dataIndex: 'Ratio', sortable: true}
			,{header: '����', width: 120, dataIndex: 'CategDesc', sortable: true}
		]
	});
	obj.OutReasonSubWindow = new Ext.Window({
		id : 'OutReasonSubWindow'
		,collapsed : true
		,buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : '�ٴ�·����'+CPWDesc + ' ����ԭ�����'
		,layout : 'border'
		,height : 350
		,width : 600
		,modal: true
		,items:[
			obj.OutReasonSubGridPanel
		]
	});
	obj.OutReasonSubGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.VarianceAnalysis';
			if (QryType==1) {
				param.QueryName = 'QryOutReasonByInDate';
			}else if (QryType==2) {
				param.QueryName = 'QryOutReasonByOutDate';
			}else if (QryType==3) {
				param.QueryName = 'QryOutReasonByAdmDate';
			}else if (QryType==4) {
				param.QueryName = 'QryOutReasonByDischDate';
			}else{
				param.QueryName = 'QryOutReasonByInDate';
			}
			param.Arg1 = CPWID;
			param.Arg2 = DateFrom;
			param.Arg3 = DateTo;
			param.Arg4 = LocID;
			param.Arg5 = WardID;
			param.ArgCnt = 5;
	});
	InitOutReasonSubWindowEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

