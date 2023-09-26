function InitViewport1(){
	var obj = new Object();
	obj.ECQuestionnaireDRStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ECQuestionnaireDRStore = new Ext.data.Store({
		proxy: obj.ECQuestionnaireDRStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'QActive', mapping: 'QActive'}
			,{name: 'QCode', mapping: 'QCode'}
			,{name: 'QDesc', mapping: 'QDesc'}
			,{name: 'QRemark', mapping: 'QRemark'}
			,{name: 'QType', mapping: 'QType'}
		])
	});
	obj.ECQuestionnaireDR = new Ext.form.ComboBox({
		id : 'ECQuestionnaireDR'
		,width : 123
		,store : obj.ECQuestionnaireDRStore
		,minChars : 1
		,displayField : 'QDesc'
		,fieldLabel : '问卷'
		,valueField : 'ID'
		,triggerAction : 'all'
});
	obj.EAgeMin = new Ext.form.TextField({
		id : 'EAgeMin'
		,fieldLabel : '年龄下限'
});
	obj.EExpression = new Ext.form.TextField({
		id : 'EExpression'
		,fieldLabel : '表达式'
});
	obj.EExpressionTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.EExpressionTypeStore = new Ext.data.Store({
		proxy: obj.EExpressionTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: ''
		}, 
		[
			{name: 'checked', mapping : 'checked'}
		])
	});
	obj.EExpressionType = new Ext.form.ComboBox({
		id : 'EExpressionType'
		,minChars : 1
		,store : [['F',"函数"],['E',"表达式"]]
		,width : 123
		,fieldLabel : '表达式类型'
		,triggerAction : 'all'
});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ECQuestionnaireDR
			,obj.EAgeMin
			,obj.EExpression
			,obj.EExpressionType
		]
	});
	obj.ESex = new Ext.form.ComboBox({
		id : 'ESex'
		,minChars : 1
		,store : [['N',"不限"],['F',"男"],['M',"女"]]
		,width : 123
		,fieldLabel : '性别'
		,triggerAction : 'all'
});
	obj.EAgeMax = new Ext.form.TextField({
		id : 'EAgeMax'
		,fieldLabel : '年龄上限'
});
	obj.EParameters = new Ext.form.TextField({
		id : 'EParameters'
		,fieldLabel : '参数'
});
	obj.EUnit = new Ext.form.TextField({
		id : 'EUnit'
		,fieldLabel : '单位'
});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ESex
			,obj.EAgeMax
			,obj.EParameters
			,obj.EUnit
		]
	});
	obj.Panel800 = new Ext.Panel({
		id : 'Panel800'
		,buttonAlign : 'center'
		,width : 600
		,region : 'column'
		,columnWidth : .5
		,frame : true
		,layout : 'column'
		,items:[
			obj.Panel7
			,obj.Panel8
		]
	});
	obj.ERemark = new Ext.form.TextArea({
		id : 'ERemark'
		,width : 415
		,fieldLabel : '备注'
});
	obj.Panel9 = new Ext.Panel({
		id : 'Panel9'
		,buttonAlign : 'center'
		,width : 600
		,frame : true
		,layout : 'form'
		,items:[
			obj.ERemark
		]
	});
	obj.btSave = new Ext.Button({
		id : 'btSave'
		,iconCls : 'icon-add'
		,text :  '保存'
});
	obj.btCancel = new Ext.Button({
		id : 'btCancel'
		,iconCls : 'icon-refresh'
		,text : '  清空'
});
	obj.btFind = new Ext.Button({
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '查找'
});
	obj.btDelete = new Ext.Button({
		id : 'btDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
});
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,buttonAlign : 'center'
		,width : 620
		,labelWidth : 80
		,title : '提示条件维护'
		,labelAlign : 'right'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Panel800
			,obj.Panel9
		]
	,	buttons:[
			obj.btSave
			,obj.btCancel
			,obj.btFind
			,obj.btDelete
		]
	});
	obj.ItemListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItemListStore = new Ext.data.Store({
		proxy: obj.ItemListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'ECQuestionnaireDR', mapping: 'ECQuestionnaireDR'}
			,{name: 'ESex', mapping: 'ESex'}
			,{name: 'EAgeMin', mapping: 'EAgeMin'}
			,{name: 'EAgeMax', mapping: 'EAgeMax'}
			,{name: 'EExpressionType', mapping: 'EExpressionType'}
			,{name: 'EExpression', mapping: 'EExpression'}
			,{name: 'EParameters', mapping: 'EParameters'}
			,{name: 'EUnit', mapping: 'EUnit'}
			,{name: 'ERemark', mapping: 'ERemark'}
		])
	});
	obj.ItemListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ItemList = new Ext.grid.GridPanel({
		id : 'ItemList'
		,height : 290
		,store : obj.ItemListStore
		,region : 'center'
		,columnWidth : .9
		,buttonAlign : 'center'
		,columns: [
			obj.ItemListCheckCol
			,{header: 'ID', width: 50, dataIndex: 'ID', sortable: true}
			,{header: '问卷', width: 100, dataIndex: 'ECQuestionnaireDR', sortable: true}
			,{header: '性别', width: 100, dataIndex: 'ESex', sortable: true}
			,{header: '年龄下限', width: 50, dataIndex: 'EAgeMin', sortable: true}
			,{header: '年龄上限', width: 50, dataIndex: 'EAgeMax', sortable: true}
			,{header: '表达式类型', width: 100, dataIndex: 'EExpressionType', sortable: true}
			,{header: '表达式', width: 100, dataIndex: 'EExpression', sortable: true}
			,{header: '参数', width: 100, dataIndex: 'EParameters', sortable: true}
			,{header: '单位', width: 100, dataIndex: 'EUnit', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'ERemark', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ItemListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})


		,plugins : obj.ItemListCheckCol});
	obj.Panel19 = new Ext.Panel({
		id : 'Panel19'
		,height : 300
		,buttonAlign : 'center'
		,width : 620
		,frame : true
		,items:[
			obj.ItemList
		]
	});
	obj.Panel180 = new Ext.Panel({
		id : 'Panel180'
		,buttonAlign : 'center'
		,region : 'center'
		,items:[
			obj.FormPanel3
			,obj.Panel19
		]
	});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.Panel180
		]
	});
	obj.ECQuestionnaireDRStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCQuestionnaire';
			param.ArgCnt = 0;
	});
	obj.EExpressionTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = '';
			param.ArgCnt = 0;
	});
	obj.ItemListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCHM.BaseDataSet';
			param.QueryName = 'GetCExpression';
			param.ArgCnt = 0;
	});
	obj.ItemListStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewport1Event(obj);
	//事件处理代码
	obj.btSave.on("click", obj.btSave_click, obj);
	obj.btCancel.on("click", obj.btCancel_click, obj);
	obj.btFind.on("click", obj.btFind_click, obj);
	obj.btDelete.on("click", obj.btDelete_click, obj);
	obj.ItemList.on("rowclick", obj.ItemList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}

