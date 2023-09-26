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
		,fieldLabel : '�ʾ�'
		,valueField : 'ID'
		,triggerAction : 'all'
});
	obj.EAgeMin = new Ext.form.TextField({
		id : 'EAgeMin'
		,fieldLabel : '��������'
});
	obj.EExpression = new Ext.form.TextField({
		id : 'EExpression'
		,fieldLabel : '���ʽ'
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
		,store : [['F',"����"],['E',"���ʽ"]]
		,width : 123
		,fieldLabel : '���ʽ����'
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
		,store : [['N',"����"],['F',"��"],['M',"Ů"]]
		,width : 123
		,fieldLabel : '�Ա�'
		,triggerAction : 'all'
});
	obj.EAgeMax = new Ext.form.TextField({
		id : 'EAgeMax'
		,fieldLabel : '��������'
});
	obj.EParameters = new Ext.form.TextField({
		id : 'EParameters'
		,fieldLabel : '����'
});
	obj.EUnit = new Ext.form.TextField({
		id : 'EUnit'
		,fieldLabel : '��λ'
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
		,fieldLabel : '��ע'
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
		,text :  '����'
});
	obj.btCancel = new Ext.Button({
		id : 'btCancel'
		,iconCls : 'icon-refresh'
		,text : '  ���'
});
	obj.btFind = new Ext.Button({
		id : 'btFind'
		,iconCls : 'icon-find'
		,text : '����'
});
	obj.btDelete = new Ext.Button({
		id : 'btDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
});
	obj.FormPanel3 = new Ext.form.FormPanel({
		id : 'FormPanel3'
		,buttonAlign : 'center'
		,width : 620
		,labelWidth : 80
		,title : '��ʾ����ά��'
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
			,{header: '�ʾ�', width: 100, dataIndex: 'ECQuestionnaireDR', sortable: true}
			,{header: '�Ա�', width: 100, dataIndex: 'ESex', sortable: true}
			,{header: '��������', width: 50, dataIndex: 'EAgeMin', sortable: true}
			,{header: '��������', width: 50, dataIndex: 'EAgeMax', sortable: true}
			,{header: '���ʽ����', width: 100, dataIndex: 'EExpressionType', sortable: true}
			,{header: '���ʽ', width: 100, dataIndex: 'EExpression', sortable: true}
			,{header: '����', width: 100, dataIndex: 'EParameters', sortable: true}
			,{header: '��λ', width: 100, dataIndex: 'EUnit', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'ERemark', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ItemListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
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
	//�¼��������
	obj.btSave.on("click", obj.btSave_click, obj);
	obj.btCancel.on("click", obj.btCancel_click, obj);
	obj.btFind.on("click", obj.btFind_click, obj);
	obj.btDelete.on("click", obj.btDelete_click, obj);
	obj.ItemList.on("rowclick", obj.ItemList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}

