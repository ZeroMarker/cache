function InitViewScreen(){
	var obj = new Object();
	obj.icuCVSCCode = new Ext.form.TextField({
		id : 'icuCVSCCode'
		,fieldLabel : '����'
		,anchor : '60%'
	});	
	
	obj.icuCVSCDesc = new Ext.form.TextField({
		id : 'icuCVSCDesc'
		,fieldLabel : '����'
		,anchor : '60%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.icuCVSCCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.icuCVSCDesc
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
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
		,width:60
		,text : '����'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : 'ɾ��'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .2
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
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 110
		,title : '��֢��ʾ����ά��'
		,region : 'north'
		,layout : 'border'
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
			idProperty: 'tICUCVSCRowId'
		}, 
	    [
			{name: 'tICUCVSCCode', mapping:'tICUCVSCCode'}
			,{name: 'tICUCVSCDesc', mapping :'tICUCVSCDesc'}
			,{name: 'tICUCVSCRowId', mapping:'tICUCVSCRowId'}

		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: 'ϵͳ��', width: 100, dataIndex: 'tICUCVSCRowId', sortable: true}
		    ,{header: '����', width: 200, dataIndex: 'tICUCVSCCode', sortable: true}
		    ,{header: '����',width: 200,dataIndex: 'tICUCVSCDesc',sortable: true}
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
		param.ClassName = 'web.DHCICUCViewSuperCat';
		param.QueryName = 'FindexeSuperCat';
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