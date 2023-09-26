
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
			//,{header: '就诊号', width: 0, dataIndex: 'EpisodeID', sortable: true}
			//,{header: '规则号', width: 0, dataIndex: 'RuleID', sortable: true}
			,{header: '规则名称', width: 250, dataIndex: 'RuleName', sortable: true}
			,{header: '表达式类型', width: 50, dataIndex: 'RuleType', sortable: true}
			//,{header: '项目号', width: 0, dataIndex: 'RuleItem', sortable: true}
			,{header: '项目名称', width: 250, dataIndex: 'ItemName', sortable: true}
			,{header: '基准', width: 100, dataIndex: 'RuleNorm', sortable: true}
			,{header: '时限要求', width: 100, dataIndex: 'RuleTime', sortable: true}
			,{header: '数量要求', width: 100, dataIndex: 'RuleAmount', sortable: true}
			,{header: '结果', width: 100, dataIndex: 'RuleRst', sortable: true}
		]
	});
	obj.btnInputVar = new Ext.Button({
		id : 'btnInputVar'
		,clearCls : 'icon-varrecord'
		,text : '变异记录'
	});
	obj.MTSubWindow = new Ext.Window({
		id : 'MTSubWindow'
		,buttonAlign : 'center'
		,maximized : false
		,title : '监控结果'
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
	//事件处理代码
  obj.LoadEvent(arguments);
  return obj;
}

