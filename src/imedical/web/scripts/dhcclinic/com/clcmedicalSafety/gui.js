//update by GY 20170324
 function InitViewScreen(){
	var obj = new Object();
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '����'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
		,labelSeparator: ''
	});	
	obj.Desc = new Ext.form.TextField({
		id : 'Desc'
		,fieldLabel : '����'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
		,labelSeparator: ''
	});
	obj.ctlocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ctlocStore = new Ext.data.Store({
		proxy: obj.ctlocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});
	obj.ctloc = new Ext.form.ComboBox({
		id : 'ctloc'
		,store : obj.ctlocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '����'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.ctlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCMedicalSafety';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.ctloc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;
	});
	obj.ctlocStore.load({});
	obj.type = new Ext.form.TextField({
		id : 'type'
		,fieldLabel : '����'
		,anchor : '95%'
		,enableKeyEvents:true
		,vtype:'lengthRange'
		,lengthRange:{min:0,max:10}
		,labelSeparator: ''
	});
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Code
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Desc 
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ctloc
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.type
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 30
		,height : 50
		,region : 'north'
		,layout : 'column'
		,columnWidth : .6
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls : 'icon-find'
		,width:'86'
		,style:'margin-left:5px;'
		,text : '��ѯ'
	});
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,width:'86'
		,style:'margin-left:10px;'
		,text : '����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width:'86'
		,style:'margin-left:10px;'
		,text : 'ɾ��'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-updateSmall'
		,width:'86'
		,style:'margin-left:10px;'
		,text : '����'
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,columnWidth : .4
		,items:[
		    obj.btnSch
			,obj.btnAdd 
			,obj.btnUpdate
			,obj.btnDelete
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 60
		,title : '�����¼�ά��'
		,region : 'north'
		,layout : 'column'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
		]
    });
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'tCode', mapping: 'Code'}
			,{name: 'tDesc', mapping: 'Desc'}
			,{name: 'tctlocId', mapping: 'ctlocId'}
			,{name: 'tctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ttype', mapping: 'type'}
			,{name: 'trowId', mapping: 'rowId'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
            new Ext.grid.RowNumberer()
			,{header: '����', width: 100, dataIndex: 'tCode', sortable: true}
			,{header: '����', width: 200, dataIndex: 'tDesc', sortable: true}
			,{header: '����ID', width: 100, dataIndex: 'tctlocId', sortable: true,hidden : true}
			,{header: '����', width: 250, dataIndex: 'tctlocDesc', sortable: true}
			,{header: '����', width: 100, dataIndex: 'ttype', sortable: true}
			,{header: 'rowId', width: 300, dataIndex: 'trowId', sortable: true,hidden : true}
			]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
	});

	obj.retGridPanelStore.load({});
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,title : '�����¼���ѯ���'
		,iconCls:'icon-result'
		,frame : true
		,tbar:obj.tb
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	obj.rowId = new Ext.form.TextField({
		id : 'rowId'
	});
	obj.hiddenPanel = new Ext.Panel({
		id : 'hiddenPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,hidden : true
		,items:[
			obj.rowId
		]
	});
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
			,obj.hiddenPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}