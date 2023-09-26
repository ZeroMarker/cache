function InitViewport(){
	var obj = new Object();
	obj.OperCatCode = new Ext.form.TextField({
		id : 'OperCatCode'
		,fieldLabel : '�������'
		,anchor : '95%'
	});	
	obj.OperCat = new Ext.form.TextField({
		id : 'OperCat'
		,fieldLabel : '��������'
		,anchor : '95%'
	});	
	
	// �������*
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
		,fieldLabel : '�������'
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
	
	//����ϵͳ����(ϵͳ�������Ϸ���,ʹ�õ���ͬһ�����ݱ�,��Ϸ����Ҳ��������ϵͳ�����,�����¼�����չ�����������)
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
		,fieldLabel : 'ϵͳ����'
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
	 //��������
	var data=[
			['O','��������'],
			['P','��Ϸ���']
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
		,fieldLabel : '��������'
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
		,text : '��ѯ'
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-edit'
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,itemCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.FormPanel = new Ext.form.FormPanel({
		id : 'FormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,title : '��������ϵ��ӷ���ά��'
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
			,{header: '����ID', width: 150, dataIndex: 'rowId', sortable: true}
			,{header: '�������', width: 200, dataIndex: 'Code', sortable: true}
			,{header: '��������', width: 210, dataIndex: 'Desc', sortable: true}
			,{header: 'ϵͳ����', width: 200, dataIndex: 'sysCatDesc', sortable: true}
			,{header: '�������', width: 210, dataIndex: 'catTypeDesc', sortable: true}
			,{header: 'ʹ�ÿ���Id', width: 200, dataIndex: 'LocId', sortable: true}
			,{header: 'ʹ�ÿ���', width: 210, dataIndex: 'LocDesc', sortable: true}
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
	//�¼��������
	obj.LoadEvent(arguments);
	obj.GridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	return obj;
}


