function InitViewport(){
	var obj = new Object();
	obj.OperCatCode = new Ext.form.TextField({
		id : 'OperCatCode'
		,fieldLabel : '分类代码'
		,anchor : '95%'
	});	
	obj.OperCat = new Ext.form.TextField({
		id : 'OperCat'
		,fieldLabel : '分类名称'
		,anchor : '95%'
	});	
	
	// 申请科室*
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
	    proxy : obj.comAppLocStoreProxy
		,reader : new Ext.data.JsonReader({
		     root : 'record'
			,totalProperty : 'total'
			,idProperty : 'ctlocId'
		},
		[
		    {name:'ctlocDesc',mapping:'ctlocDesc'}
			,{name:'ctlocId',mapping:'ctlocId'}
		])
	
	});
	obj.comAppLoc = new Ext.form.ComboBox({
	    id : 'comAppLoc'
		,store : obj.comAppLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '申请科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 ='INOPDEPT^OUTOPDEPT^EMOPDEPT'
		param.Arg3 =""
		param.ArgCnt = 3;
	});
	
	//手术系统分类(系统分类和诊断分类,使用的是同一张数据表,诊断分类表也就是整个系统分类表,再往下继续扩展是手术分类表)
	obj.comDiagnosisCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comDiagnosisCatStore = new Ext.data.Store({
		proxy: obj.comDiagnosisCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowId'
		}, 
		[
			,{name: 'DiagCatDes', mapping: 'DiagCatDes'}
			,{name: 'rowId', mapping: 'rowId'}
		])
	});
	obj.comDiagnosisCat = new Ext.form.ComboBox({
		id : 'comDiagnosisCat'
		,minChars : 1
		,fieldLabel : '系统分类'
		,triggerAction : 'all'
		,store : obj.comDiagnosisCatStore
		,displayField : 'DiagCatDes'
		,anchor : '95%'
		,valueField : 'rowId'
	});
	obj.comDiagnosisCatStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCANCDiagCat';
		    param.QueryName = 'LookUpDiagCat';
		    //param.Arg1 =obj.comDiagnosisCat.getRawValue();   //obj.comOpPreDiagnosis.getRawValue()         //;
	    	param.ArgCnt = 0;
	 });
	 //手术类型
	var data=[
			['O','手术分类'],
			['P','诊断分类']
		]
	obj.opTypeStoreProxy=data;
	obj.opTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});

	obj.opType = new Ext.form.ComboBox({
		id : 'opType'
		,valueField : 'code'
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '分类类型'
		,store : obj.opTypeStore
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,height : 120
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.OperCatCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,height : 120
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.comDiagnosisCat
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,height : 100
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.OperCat
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.comAppLoc
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.opType
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查询'
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-edit'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,itemCls : 'icon-delete'
		,text : '删除'
	});
	obj.FormPanel = new Ext.form.FormPanel({
		id : 'FormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '手术与诊断的子分类维护'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 100
		,items:[
			
			obj.Panel1
			,obj.Panel3
			,obj.Panel2
			,obj.Panel5
			,obj.Panel4
		]
		,buttons:[
			obj.btnSch
			,obj.btnSave
			//,obj.btnEdit
			,obj.btnDelete
		]
	});
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowId'
		}, 
		[
			{name: 'rowId', mapping: 'rowId'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'LocId', mapping: 'LocId'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'sysCatId', mapping: 'sysCatId'}
			,{name: 'sysCatDesc', mapping: 'sysCatDesc'}
			,{name: 'catTypeCode', mapping: 'catTypeCode'}
			,{name: 'catTypeDesc', mapping: 'catTypeDesc'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '分类ID', width: 150, dataIndex: 'rowId', sortable: true}
			,{header: '分类代码', width: 200, dataIndex: 'Code', sortable: true}
			,{header: '分类名称', width: 210, dataIndex: 'Desc', sortable: true}
			,{header: '系统分类', width: 200, dataIndex: 'sysCatDesc', sortable: true}
			,{header: '分类类别', width: 210, dataIndex: 'catTypeDesc', sortable: true}
			,{header: '使用科室Id', width: 200, dataIndex: 'LocId', sortable: true}
			,{header: '使用科室', width: 210, dataIndex: 'LocDesc', sortable: true}
		]});
		
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOperationCat';
		param.QueryName = 'LookUpOperationCat';
		param.Arg1=obj.OperCatCode.getValue();
		param.Arg2=obj.OperCat.getValue();
		param.Arg3=obj.comAppLoc.getValue();
		param.Arg4=obj.comDiagnosisCat.getValue();
		param.Arg5=obj.opType.getValue();
		param.ArgCnt =5;
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.FormPanel
			,obj.GridPanel
		]
	});

	obj.GridPanelStore.load({});
	InitViewportEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	obj.GridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	return obj;
}


