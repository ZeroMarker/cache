function InitViewport(){
	var obj = new Object();
	//诊断
	obj.comDiagnosisStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.comDiagnosisStore=new Ext.data.Store({
		proxy: obj.comDiagnosisStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid0'
		}, 
		[
			{name: 'rowid0', mapping: 'rowid0'}
			,{name: 'DiagDes', mapping: 'DiagDes'}
			
		])
	});
	obj.comDiagnosis = new Ext.form.ComboBox({
		id : 'comDiagnosis'
		,store:obj.comDiagnosisStore
		,minChars:1
		//,displayField:'tBPCEMDesc'
		,displayField:'DiagDes'
		,fieldLabel : '诊断'
		,valueField : 'rowid0'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	//alert(obj.comDiagnosis.getRawValue())
	obj.comDiagnosisStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCCLCDiagCat';
		    param.QueryName = 'LookUpMrcDiagnosis';
		    param.Arg1 =obj.comDiagnosis.getRawValue();   //obj.comOpPreDiagnosis.getRawValue()         //;
	    	param.ArgCnt = 1;
	 });
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,height : 120
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.comDiagnosis
		]
	});
	
	//诊断分类
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
		,fieldLabel : '诊断分类'
		,triggerAction : 'all'
		,store : obj.comDiagnosisCatStore
		,displayField : 'DiagCatDes'
		,anchor : '95%'
		,valueField : 'rowId'
	});
	obj.comDiagnosisCatStoreProxy.on('beforeload', function(objProxy, param){
		    param.ClassName = 'web.DHCCLCDiagCat';
		    param.QueryName = 'LookUpDiagCat';
		    //param.Arg1 =obj.comDiagnosisCat.getRawValue();   //obj.comOpPreDiagnosis.getRawValue()         //;
	    	param.ArgCnt = 0;
	 });
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,height : 100
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.comDiagnosisCat
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
		,title : '诊断分类关联关系'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 100
		,items:[
			obj.Panel2
			,obj.Panel1
		]
		,buttons:[
			obj.btnSch
			,obj.btnSave
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
			,{name: 'Diagnosis', mapping: 'Diagnosis'}
			,{name: 'DiagCatDes', mapping: 'DiagCatDes'}
			,{name: 'DiagId', mapping: 'DiagId'}
			,{name: 'DiagCatId', mapping: 'DiagCatId'}
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
			,{header: '诊断分类', width: 180, dataIndex: 'DiagCatDes', sortable: true}
			,{header: '诊断名称', width: 210, dataIndex: 'Diagnosis', sortable: true}
			,{header: '诊断ID', width: 150, dataIndex: 'DiagId', sortable: true}
			,{header: '诊断分类ID', width: 150, dataIndex: 'DiagCatId', sortable: true}
			,{header: '关联ID', width: 150, dataIndex: 'rowId', sortable: true}
		]});
		
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCDiagCat';
		param.QueryName = 'LookUpDiagCatLink';
		param.Arg1=obj.comDiagnosisCat.getValue();
		//param.Arg2=obj.DiagnosisCat.getValue();
		param.ArgCnt =1;
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
	InitViewScreenEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	obj.GridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	return obj;
}


