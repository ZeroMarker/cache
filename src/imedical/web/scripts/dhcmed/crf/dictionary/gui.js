function InitViewscreen(){
	var obj = new Object();
/*
	obj.DicCode = new Ext.form.TextField({
		id : 'DicCode'
		,fieldLabel : '�ֵ����'
		,anchor : '95%'
});
	obj.DicName = new Ext.form.TextField({
		id : 'DicName'
		,fieldLabel : '�ֵ�����'
		,anchor : '95%'
});

	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,columnWidth :0.3
		,layout : 'form'
		,items:[			
		]
	});

	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,columnWidth :0.4
		,layout : 'form'
		,items:[
			obj.DicCode,
			obj.DicName
		]
	});
		obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,columnWidth :0.3
		,layout : 'form'
		,items:[
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '��ѯ'
});*/
	obj.btnNew = new Ext.Toolbar.Button({  //new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
	//	,anchor : '95%'
		,text : '�½�'
});
	obj.btnEdit = new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		//,anchor : '95%'
		,text : '�༭'
});
/*
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,title : '�ֵ�ά��'
		,layout : 'column'
		,labelWidth : 60
		,frame : true
		,height : 130
		,region : 'north'
		,items:[
			obj.Panel1,
			obj.Panel2,
			obj.Panel3
		]
		,buttons:[
			obj.btnQuery
			,obj.btnNew
			,obj.btnEdit
		]
	});*/
	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[ //ID,DicCode,DicName,ClassName,QueryName,Fields,FormalSpec
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicName', mapping: 'DicName'}
			,{name: 'ClassName', mapping: 'ClassName'}
			,{name: 'QueryName', mapping: 'QueryName'}
			,{name: 'Fields', mapping: 'Fields'}
			,{name: 'FormalSpec', mapping: 'FormalSpec'}			
		])
	});
	obj.gridListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridList = new Ext.grid.GridPanel({
		id : 'gridList'
		,buttonAlign : 'center'
		,store : obj.gridListStore
		,loadMask : true
		,region : 'center'
		,viewConfig: {forceFit: true}
		,columns: [  
			new Ext.grid.RowNumberer()
			,{header: '�ֵ����', width: 100, dataIndex: 'DicCode', sortable: true}
			,{header: '�ֵ�����', width: 250, dataIndex: 'DicName', sortable: true}
			,{header: '������', width: 250, dataIndex: 'ClassName', sortable: true}
			,{header: 'Query����', width: 250, dataIndex: 'QueryName', sortable: true}
			,{header: '�ֶ��б�', width: 100, dataIndex: 'Fields', sortable: true}
			,{header: '����˵��', width: 100, dataIndex: 'FormalSpec', sortable: true}
		]
		,tbar:[obj.btnNew,obj.btnEdit]
});
	obj.Viewscreen = new Ext.Viewport({
		id : 'Viewscreen'
		,layout : 'border'
		,items:[
			//obj.fPanel,
			obj.gridList
		]
	});
	
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.BO.Dictionary';
			param.QueryName = 'QueryAllDic';
			param.Arg1 = '';   //obj.DicCode.getValue();
			param.Arg2 = '';  //obj.DicName.getValue();
			param.ArgCnt = 2;
	});
	obj.gridListStore.load();

	InitViewscreenEvent(obj);
	//�¼��������
	//obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.gridList.on("rowdblclick", obj.gridList_rowdblclick, obj);
	//obj.gridList.on("rowclick", obj.gridList_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}


function InitwinScreen(){
	var obj = new Object();

	obj.txtDicID = new Ext.form.TextField({
		id : 'txtDicID'
		,hidden:true
});
	obj.txtDicCode = new Ext.form.TextField({
		id : 'txtDicCode'
		,fieldLabel : '�ֵ����'
		,anchor : '95%'
});
	obj.txtDicName = new Ext.form.TextField({
		id : 'txtDicName'
		,fieldLabel : '�ֵ�����'
		,anchor : '95%'
});	
	obj.txtClassName = new Ext.form.TextField({
		id : 'txtClassName'
		,fieldLabel : '������'
		,anchor : '95%'
});
/*	obj.txtQueryName = new Ext.form.TextField({
		id : 'txtQueryName'
		,fieldLabel : 'Query����'
		,anchor : '95%'
});*/
	obj.txtQueryNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.txtQueryNameStore = new Ext.data.Store({
		proxy: obj.txtQueryNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Name', mapping: 'Name'}
		])
	});
	obj.txtQueryName = new Ext.form.ComboBox({
		id : 'txtQueryName'
		,store : obj.txtQueryNameStore
		,minChars : 1
		,displayField : 'Name'
		,fieldLabel : 'Query����'
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'ID'
});
	obj.txtFields = new Ext.form.TextField({
		id : 'txtFields'
		,fieldLabel : '�ֶ��б�'
		,anchor : '95%'
});
	obj.txtFormalSpec = new Ext.form.TextField({
		id : 'txtFormalSpec'
		,fieldLabel : '����˵��'
		,anchor : '95%'
});
	obj.winfBtnGet = new Ext.Button({
			id : 'winfBtnGet'
			,iconCls : 'icon-find'
			,text : '��ȡ�ֶμ�����' //Query�ֶμ�����
	});
	obj.winfBtnSave = new Ext.Button({
		id : 'winfBtnSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.winfPBtnCancle = new Ext.Button({
		id : 'winfPBtnCancle'
		,iconCls : 'icon-undo'
		,text : 'ȡ��'
});

	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelWidth : 70
		,region : 'center'
		,layout : 'form'
		,frame : true
		,height : 280
		,items:[
		//	obj.Panel4
			obj.txtDicID
			,obj.txtDicCode
			,obj.txtDicName
			,obj.txtClassName
			,obj.txtQueryName
			,obj.txtFields
			,obj.txtFormalSpec
		]
		,buttons:[
			obj.winfBtnGet,
			obj.winfBtnSave
			,obj.winfPBtnCancle
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 320
		,buttonAlign : 'center'
		,width : 400
		,modal : true
		,title : '�༭'
		,items:[
			obj.winfPanel
		]
	});
	
	obj.txtQueryNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CR.BO.Dictionary';
			param.QueryName = 'GetAllQuerys';
			param.Arg1 = obj.txtClassName.getValue();
			param.ArgCnt = 1;
	});
	obj.txtQueryNameStore.load();
	
	InitwinScreenEvent(obj);
	//�¼��������
	obj.winfBtnSave.on("click", obj.winfBtnSave_click, obj);
	obj.winfPBtnCancle.on("click", obj.winfPBtnCancle_click, obj);
	obj.winfBtnGet.on("click", obj.winfBtnGet_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}