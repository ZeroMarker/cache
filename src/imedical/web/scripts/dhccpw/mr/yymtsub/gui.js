
function InitMTSubWindow(PathWayID,UserID){
	var obj = new Object();
	obj.PathWayID=PathWayID;
	obj.UserID=UserID;
	obj.gpCPWMonistorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gpCPWMonistorStore = new Ext.data.Store({
		proxy: obj.gpCPWMonistorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RuleID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'RuleID', mapping: 'RuleID'}
			,{name: 'RuleName', mapping: 'RuleName'}
			,{name: 'RuleType', mapping: 'RuleType'}
			,{name: 'RuleItem', mapping: 'RuleItem'}
			,{name: 'ItemName', mapping: 'ItemName'}
			,{name: 'RuleNorm', mapping: 'RuleNorm'}
			,{name: 'RuleTime', mapping: 'RuleTime'}
			,{name: 'RuleAmount', mapping: 'RuleAmount'}
			,{name: 'RuleRst', mapping: 'RuleRst'}
		])
	});
	obj.gpCPWMonistorCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gpCPWMonistor = new Ext.grid.GridPanel({
		id : 'gpCPWMonistor'
		,store : obj.gpCPWMonistorStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : true
		,viewConfig : {forceFit:true}
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '�����', width: 0, dataIndex: 'EpisodeID', sortable: true}
			//,{header: '�����', width: 0, dataIndex: 'RuleID', sortable: true}
			,{header: '��������', width: 250, dataIndex: 'RuleName', sortable: true}
			,{header: '���ʽ����', width: 50, dataIndex: 'RuleType', sortable: true}
			//,{header: '��Ŀ��', width: 0, dataIndex: 'RuleItem', sortable: true}
			,{header: '��Ŀ����', width: 250, dataIndex: 'ItemName', sortable: true}
			,{header: '��׼', width: 100, dataIndex: 'RuleNorm', sortable: true}
			,{header: 'ʱ��Ҫ��', width: 100, dataIndex: 'RuleTime', sortable: true}
			,{header: '����Ҫ��', width: 100, dataIndex: 'RuleAmount', sortable: true}
			,{header: '���', width: 100, dataIndex: 'RuleRst', sortable: true}
		]
	});
	obj.btnInputVar = new Ext.Button({
		id : 'btnInputVar'
		,clearCls : 'icon-varrecord'
		,text : '�����¼'
	});
	obj.MTSubWindow = new Ext.Window({
		id : 'MTSubWindow'
		,buttonAlign : 'center'
		,maximized : false
		,title : '��ؽ��'
		,resizable : false
		,layout : 'fit'
		,width : 900
		,height : 500
		,modal: true
		,items:[
			obj.gpCPWMonistor
		]
		,buttons:[
			obj.btnInputVar
		]
	});
	obj.gpCPWMonistorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MR.ClinPathWaysMonitor';
			param.QueryName = 'QryMonitor';
			param.Arg1 = obj.PathWayID;
			param.ArgCnt = 1;
	});
	InitMTSubWindowEvent(obj);
	//�¼��������
  obj.LoadEvent(arguments);
  return obj;
}

