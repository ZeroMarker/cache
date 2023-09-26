function InitPatMessageView(paadm){
	var obj = new Object();
	obj.PatientMessListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PatientMessListStore = new Ext.data.Store({
		proxy: obj.PatientMessListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'CreateUserName', mapping: 'CreateUserName'}
			,{name: 'CreateDate', mapping: 'CreateDate'}
			,{name: 'CreateTime', mapping: 'CreateTime'}
			,{name: 'Message', mapping: 'Message'}
		])
	});
	obj.PatientMessListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PatientMessList = new Ext.grid.GridPanel({
		id : 'PatientMessList'
		,height : 150
		,store : obj.PatientMessListStore
		,width : 570
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '发送人', width: 80, dataIndex: 'CreateUserName', sortable: true}
			,{header: '发送日期', width: 80, dataIndex: 'CreateDate', sortable: true}
			,{header: '发送时间', width: 80, dataIndex: 'CreateTime', sortable: true}
			,{header: '内容', width: 370, dataIndex: 'Message', sortable: true}
		]});
	obj.MessContent = new Ext.form.TextArea({
		id : 'MessContent'
});
	obj.MessageFPanel = new Ext.form.FormPanel({
		id : 'MessageFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 150
		,region : 'south'
		,layout : 'fit'
		,items:[
			obj.MessContent
		]
	});
	obj.PatMessageView = new Ext.Viewport({
		id : 'PatMessageView'
		,layout : 'border'
		,items:[
			obj.PatientMessList
			,obj.MessageFPanel
		]
	});
	obj.PatientMessListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MessageSrv';
			param.QueryName = 'QueryPatMessage';
			param.Arg1 = paadm;
			param.ArgCnt = 1;
	});
	obj.PatientMessListStore.load({});
	InitPatMessageViewEvent(obj);
	//事件处理代码
	obj.PatientMessList.on("rowclick", obj.PatientMessList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}

