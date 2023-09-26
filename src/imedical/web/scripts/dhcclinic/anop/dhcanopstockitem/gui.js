//by+2017-03-02
function InitViewScreen(){
	var obj = new Object();	
	obj.comAppLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comAppLocStore = new Ext.data.Store({
		proxy: obj.comAppLocStoreProxy,
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
	obj.comAppLoc = new Ext.form.ComboBox({
		id : 'comAppLoc'
		,store : obj.comAppLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp'+'�������'
		,valueField : 'ctlocId'
		,labelWidth :100
		,labelSeparator: ''
		,triggerAction : 'all'
		,anchor : '95%'
	});


	// �Ĳ���Ϣ
	obj.comStockItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comStockItemStore = new Ext.data.Store({
	    proxy : obj.comStockItemStoreProxy
		,reader : new Ext.data.JsonReader({
		     root : 'record'
			,totalProperty : 'total'
			,idProperty : 'rowId'
		},
		[
		    {name:'Code',mapping:'Code'}
			,{name:'rowId',mapping:'rowId'}
			,{name:'itDesc',mapping:'itDesc'}
		])
	
	});
	obj.comStockItem = new Ext.form.ComboBox({
	    id : 'comStockItem'
		,store : obj.comStockItemStore
		,minChars : 1
		,displayField : 'itDesc'
		,fieldLabel : '&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp'+'���Ĳ�'
		,labelSeparator: ''
		,valueField : 'rowId'
		,triggerAction : 'all'
		,anchor : '98%'
	});
	obj.comStockItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPStock';
		param.QueryName = 'FindINCItem';
		param.Arg1 = obj.comStockItem.getRawValue();
		param.ArgCnt = 1;
	});

	obj.txtStockDesc = new Ext.form.TextField({
		id : 'txtStockDesc'
		,fieldLabel : '�Զ���Ĳ�����'
		,labelSeparator: ''
		,anchor : '95%'
	});	
    //obj.comStockItemStore.load({})
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.comAppLoc
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.comStockItem
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,style:'margin-left :50px;'
		,items:[
			obj.txtStockDesc
		]
	});
    
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-save'
		,style:'margin-left :15px;'
		,width:86
		,text : '����'
	});
	obj.seachButton = new Ext.Button({
		id : 'seachButton'
		,iconCls : 'icon-find'
		,width:86
		,style:'margin-left :15px;'
		,text : '��ѯ'
		,tooltip:'<span style=\'color:red;font-size:15px;\'>ֻ��ͨ�����ҽ��в�ѯ��</span>'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,text : 'ɾ��'
		,style:'margin-left :15px;'
		,iconCls : 'icon-delete'
		,tooltip:'<span style=\'color:red;\'>����ʹ�á�ɾ����������</span>'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'center'
		//,height : 80
		,columnWidth : .3
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .3
		,layout : 'column'
		,items:[
		    obj.seachButton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .3
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'left'
		,labelWidth :60
		,region : 'center'
		,columnWidth : .3
		,layout : 'column'
		,items:[
			obj.updatepanel
			,obj.addpanel
			,obj.deletepanel
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'left'
		,labelWidth : 100
		,height : 30
		,columnWidth : .7
		,region : 'west'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Rowid
		]
	});
	obj.clcslinkPanel = new Ext.Panel({
		id : 'clcslinkPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '������������Ĳ�ά��'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
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
			idProperty: 'count'
		}, 
	    [
			{name: 'LocId', mapping : 'LocId'}
			,{name: 'locDesc', mapping : 'locDesc'}
			,{name: 'incitrRowId', mapping : 'incitrRowId'}
			,{name: 'ancCode', mapping : 'ancCode'}
			,{name: 'ancDesc', mapping : 'ancDesc'}
			,{name: 'itDesc', mapping : 'itDesc'}
			,{name: 'count', mapping : 'count'}
			
		])
	});
    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '�������ID', width: 80, dataIndex: 'LocId', sortable: true,tooltip:'���һ��ѡ�У��ٴ�ѡ��󣬷�ѡ��״̬'}
		,{header: '��������', width: 250, dataIndex: 'locDesc', sortable: true}
		,{header: '�Զ���Ĳ�����', width: 350, dataIndex: 'ancDesc', sortable: true}
		,{header: '���Ĳ�����', width: 350, dataIndex: 'itDesc', sortable: true}
		,{header: '�ĲĴ���', width: 100, dataIndex: 'ancCode', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPStock';
		param.QueryName = 'FindANCStock';
		param.Arg1 = obj.comAppLoc.getValue();
		param.Arg2 = obj.comStockItem.getRawValue();
		param.ArgCnt = 2;
	});
	obj.retGridPanelStore.load({});
		
	obj.comAppLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1 = obj.comAppLoc.getRawValue();
		param.Arg2 = 'INOPDEPT^OUTOPDEPT^EMOPDEPT';
		param.ArgCnt = 2;		
	});	
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
		,title : '��ѯ���'
		,region : 'center'
		,layout : 'border'
		,iconCls:'icon-result'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});

    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.clcslinkPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.seachButton.on("click", obj.seachButton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);


	obj.comAppLoc.on("select", obj.comAppLoc_select, obj);
	obj.comAppLoc.on("keyup", obj.comAppLoc_keyup, obj);
	
	
	obj.comStockItem.on("select", obj.comStockItem_select, obj);
	obj.comStockItem.on("keyup", obj.comStockItem_keyup, obj);

	obj.LoadEvent(arguments);
	return obj;
}