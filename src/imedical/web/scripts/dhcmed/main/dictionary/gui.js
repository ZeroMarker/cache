function InitviewMain(){
	var obj = new Object();
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-new'
		,text : '�½�'
	});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-edit'
		,text : '�༭'
	});
	obj.btnDicItems = new Ext.Button({
		id : 'btnDicItems'
		,iconCls : 'icon-menudic'
		,text : '�ֵ���'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,height : 60
		,buttonAlign : 'center'
		,region : 'north'
		,frame : true
		,title : '�ֵ����'
		,layout : 'column'
		,items:[]
		,buttons:[
			obj.btnAdd
			,obj.btnEdit
			,obj.btnDicItems
		]
	});
	
	obj.objDicTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter: 'Arg1',
		dataUrl: "./dhcmed.tree.csp",
		clearOnLoad : true,
		baseParams: {
			ClassName: 'DHCMed.SSService.DictionarySrv',
			QueryName: 'QryDictionaryTree',
			ArgCnt: 1
		}
	});
	
	obj.objDicMenu = new  Ext.menu.Menu({
		items : [
			{
				id : 'mnuNewDic',
				text : '�½��ֵ����'
			},{
				id : 'mnuNewDicItem',
				text : '�½��ֵ���Ŀ'	
				
			},{
				id : 'mnuModifyDic',
				text : '�޸��ֵ����'
			}
		]
	});
	
	obj.objDicTreeRootNode = new Ext.tree.AsyncTreeNode({
		leaf: false
		,text: "root-" + ProductCode
		,id: "root-" + ProductCode
		,draggable: false
	});
	
	obj.objDicTree = new Ext.tree.TreePanel({
		region:'west',
		useArrows: true,
		autoScroll: true,
		animate: true,
		enableDD: true,
		containerScroll: true,
		border: false,
		rootVisible: false,
		width : 200,
		//height : 250,
		title: "�ֵ���",
		loader: obj.objDicTreeLoader,
		contextMenu : obj.objDicMenu,
		//collapsible : true,
		//height : 200, //Modify By LiYang 2011-03-23 �̶��汾���߶�  //Modified By LiYang 2011-05-21  ��ʼ���޶��߶�
		root: obj.objDicTreeRootNode	
	});
	obj.objDicTreeRootNode.expand();


	
	
	obj.gridItemsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridItemsStore = new Ext.data.Store({
		proxy: obj.gridItemsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.gridItemsCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridItems = new Ext.grid.GridPanel({
		id : 'gridItems'
		,store : obj.gridItemsStore
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: '����', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 200, dataIndex: 'Description', sortable: true}
			,{header: '��Ч', width: 100, dataIndex: 'Active', sortable: true}
			,{header: 'ҽԺ', width: 200, dataIndex: 'HispsDescs', sortable: true}
			//,{header: '��ʼ����', width: 100, dataIndex: 'DateFrom', sortable: true}
			//,{header: '��ֹ����', width: 100, dataIndex: 'DateTo', sortable: true}
		]});
	
	
		obj.viewMain = new Ext.Viewport({
		id : 'viewMain'
		,layout : 'border'
		,items:[
			//obj.Panel1
			obj.objDicTree
			,obj.gridItems
		]
	});
	InitviewMainEvent(obj);
	//�¼��������
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	//obj.btnDicItems.on("click", obj.btnDicItems_click, obj);
	obj.objDicTree.on("click", obj.objDicTreeClick, obj);
	//obj.objDicTree.on("dblclick", obj.objDicItems_dblclick, obj);
	obj.objDicTree.on("contextmenu", obj.objDicTree_contextmenu, obj);
	Ext.getCmp("mnuNewDicItem").on("click", obj.mnuNewDicItem_click, obj);
	Ext.getCmp("mnuNewDic").on("click", obj.mnuNewDic_click, obj);
	Ext.getCmp("mnuModifyDic").on("click", obj.mnuModifyDic_click, obj);
	
	obj.gridItems.on("rowdblclick", obj.gridItems_rowdblclick, obj);
	
  
  obj.LoadEvent(arguments);
  return obj;
}
function InitwinItems(){
	var obj = new Object();
	obj.gridItemsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridItemsStore = new Ext.data.Store({
		proxy: obj.gridItemsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.gridItemsCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridItems = new Ext.grid.GridPanel({
		id : 'gridItems'
		,store : obj.gridItemsStore
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: '����', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 200, dataIndex: 'Description', sortable: true}
			,{header: '��Ч', width: 100, dataIndex: 'Active', sortable: true}
			,{header: 'ҽԺ', width: 200, dataIndex: 'HispsDescs', sortable: true}
			//,{header: '��ʼ����', width: 100, dataIndex: 'DateFrom', sortable: true}
			//,{header: '��ֹ����', width: 100, dataIndex: 'DateTo', sortable: true}
		]});
	obj.panelEdit = new Ext.Panel({
		id : 'panelEdit'
		,buttonAlign : 'center'
		,width : 600
		,height : 240
		,title : '�༭'
		,region : 'south'
		,frame : true
		,items:[
		]
	});
	obj.winItems = new Ext.Window({
		id : 'winItems'
		,buttonAlign : 'center'
		,width : 600
		,height : 540
		,title : '�ֵ���Ŀ'
		,layout : 'border'
		,modal : true
		,items:[
			obj.gridItems
			,obj.panelEdit
		]
	});
	obj.gridItemsStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	InitwinItemsEvent(obj);
	//�¼��������
	obj.gridItems.on("rowclick", obj.gridItems_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitwinEdit(){
	var obj = new Object();
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,width : 300
		,allowBlank : false
		,fieldLabel : '����'
});
	obj.Description = new Ext.form.TextField({
		id : 'Description'
		,width : 300
		,allowBlank : false
		,fieldLabel : '����'
});
	obj.HispsDescsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.HispsDescsStore = new Ext.data.Store({
		proxy: obj.HispsDescsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'hosName', mapping: 'hosName'}
		])
	});
	obj.HispsDescs = new Ext.form.ComboBox({
		id : 'HispsDescs'
		,width : 300
		,store : obj.HispsDescsStore
		,minChars : 1
		,displayField : 'hosName'
		,fieldLabel : 'ҽԺ'
		,editable : 'false'
		,triggerAction : 'all'
		,valueField : 'rowid'
});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,format : 'Y-m-d'
		,width : 300
		,fieldLabel : '��ʼ����'
		,editable:false
});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,format : 'Y-m-d'
		,width : 300
		,fieldLabel : '��������'
		,editable:false
});
	obj.Active = new Ext.form.Checkbox({
		id : 'Active'
		,fieldLabel : '�Ƿ���Ч'
});
	obj.txtType = new Ext.form.TextField({
		id : 'txtType'
		,hidden : true
});
	obj.txtRowid = new Ext.form.TextField({
		id : 'txtRowid'
		,hidden : true
});
	obj.cboProductStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboProductStore = new Ext.data.Store({
		proxy: obj.cboProductStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ProCode', mapping: 'ProCode'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.cboProduct = new Ext.form.ComboBox({
		id : 'cboProduct'
		,width : 300
		,store : obj.cboProductStore
		,minChars : 1
		,displayField : 'ProName'
		,fieldLabel : '������Ʒ'
		,editable : 'false'
		,triggerAction : 'all'
		,valueField : 'ProCode'
});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,text : 'ȡ��'
});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 180
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Code
			,obj.Description
			,obj.HispsDescs
			,obj.cboProduct
			//,obj.DateFrom
			//,obj.DateTo
			,obj.Active
			,obj.txtType
			,obj.txtRowid
		]
	,	buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	obj.winEdit = new Ext.Window({
		id : 'winEdit'
		,buttonAlign : 'center'
		,width : 500
		,height : 300
		,title : '�༭'
		,layout : 'fit'
		,modal : true
		,renderTo : document.body
		,items:[
			obj.fPanel
		]
	});
	obj.HispsDescsStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Hospital';
			param.QueryName = 'QueryHosInfo';
			param.ArgCnt = 0;
	});
	obj.cboProductStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'FindProInfo';
			param.ArgCnt = 0;
	});	
	
	
	obj.HispsDescsStore.load({});
	InitwinEditEvent(obj);
	//�¼��������
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

