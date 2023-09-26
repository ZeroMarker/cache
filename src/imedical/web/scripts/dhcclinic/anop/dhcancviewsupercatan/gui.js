//20170307+GY
function InitViewScreen(){
	var obj = new Object();
	obj.viewsupname = new Ext.form.TextField({
		id : 'viewsupname'
		,fieldLabel : '名称'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.viewsupcode = new Ext.form.TextField({
		id : 'viewsupcode'
		,fieldLabel : '代码'
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
		,labelAlign : 'right'
		,labelWidth : 40
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.viewsupcode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.viewsupname
		]
	});
	/*
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
	});*/
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,style:'margin-left:15px;'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,style:'margin-left:15px;'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,style:'margin-left:15px;'
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		//,height : 80
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
//		,buttons:[
//			obj.addbutton
//		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,height : 65		
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
//		,buttons:[
//			obj.updatebutton
//		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,height : 65
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
//		,buttons:[
//			obj.deletebutton
//		]
	});	
	/*
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
	});*/
	obj.viewsupPanel = new Ext.Panel({
		id : 'viewsupPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '显示大类维护'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
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
			idProperty: 'RowId'
		}, 
	    [
			{name: 'TANCVSCCode', mapping : 'TANCVSCCode'}
			,{name: 'TANCVSCDesc', mapping: 'TANCVSCDesc'}
			,{name: 'RowId', mapping: 'RowId'}

		])
	});
    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '系统号', width: 100, dataIndex: 'RowId', sortable: true}
		,{header: '代码', width: 150, dataIndex: 'TANCVSCCode', sortable: true}
		,{header: '名称', width: 200, dataIndex: 'TANCVSCDesc', sortable: true}
		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCViewSuperCat';
		param.QueryName = 'FindexeSuperCat';
		//param.Arg1 = obj.viewsupname.getRawValue();
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
		,title : '显示大类查询结果'
		,iconCls:'icon-result'
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
			obj.viewsupPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}