//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	obj.bpcVSCode = new Ext.form.TextField({
		id : 'bpcVSCode'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.bpcVSDesc = new Ext.form.TextField({
		id : 'bpcVSDesc'
		,fieldLabel : '����'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.bpcVSCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.bpcVSDesc
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 30
		,height : 50
		,columnWidth : .4
		,region : 'north'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Rowid
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'	
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .22
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .22
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .22
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 40
		,region : 'center'
		,layout : 'column'
		,columnWidth : .4
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '����ת��ά��'
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
			idProperty: 'tBPCVSRowId'
		}, 
	    [
			{name: 'tBPCVSDesc', mapping : 'tBPCVSDesc'}
			,{name: 'tBPCVSCode', mapping: 'tBPCVSCode'}
			,{name: 'tBPCVSRowId', mapping: 'tBPCVSRowId'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '����',width: 180,dataIndex: 'tBPCVSCode',sortable: true}
           ,{header: '����', width: 260, dataIndex: 'tBPCVSDesc', sortable: true}
		   ,{header: 'ϵͳ��', width: 100, dataIndex: 'tBPCVSRowId', sortable: true}
		]
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCVisitStatus';
		param.QueryName = 'FindVStatus';
		param.ArgCnt = 0;
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
			obj.functionPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//�¼��������
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}