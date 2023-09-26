
function InitwinViewport(){
	var obj = new Object();
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,width : 200
		,fieldLabel : '开始日期'
});
	obj.qryPanelSub1 = new Ext.Panel({
		id : 'qryPanelSub1'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.dtFromDate
		]
	});
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		,width : 200
		,fieldLabel : '结束日期'
});
	obj.qryPanelSub2 = new Ext.Panel({
		id : 'qryPanelSub2'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.dtToDate
		]
	});
	obj.qryPanel = new Ext.Panel({
		id : 'qryPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.qryPanelSub1
			,obj.qryPanelSub2
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 50
		,text : '查询'
});
	obj.qryFormPanel = new Ext.form.FormPanel({
		id : 'qryFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,height : 100
		,region : 'north'
		,title : '查询条件'
		,frame : true
		,items:[
			obj.qryPanel
		]
	,	buttons:[
			obj.btnQuery
		]
	});
	obj.rstGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.rstGridPanelStore = new Ext.data.Store({
		proxy: obj.rstGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
		])
	});
	obj.rstGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.rstGridPanel = new Ext.grid.GridPanel({
		id : 'rstGridPanel'
		,store : obj.rstGridPanelStore
		,region : 'center'
		,frame : true
		,title : '查询结果'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
		]
});
	obj.winViewport = new Ext.Viewport({
		id : 'winViewport'
		,region : 'sourth'
		,layout : 'border'
		,items:[
			obj.qryFormPanel
			,obj.rstGridPanel
		]
	});
	obj.rstGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = '';
			param.QueryName = '';
			param.ArgCnt = 0;
	});
	InitwinViewportEvent(obj);
	//事件处理代码
	obj.InitArgument();
	obj.btnQuery.on("click", obj.btnQuery_click, obj);
  	obj.LoadEvent(arguments);
  	return obj;
}

