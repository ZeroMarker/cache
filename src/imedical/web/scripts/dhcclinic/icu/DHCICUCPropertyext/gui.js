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
	
	obj.viewsupvalue = new Ext.form.TextField({
		id : 'viewsupvalue'
		,fieldLabel : '默认值'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	obj.tICUCPRowID = new Ext.form.TextField({
		id : 'tICUCPRowID'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth : 30
		,layout : 'form'
		,items:[
			obj.viewsupcode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth : 35
		,layout : 'form'
		,items:[
			obj.viewsupname
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth : 50
		,layout : 'form'
		,items:[
			obj.viewsupvalue
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,style: 'margin-left:10px'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,style: 'margin-left:10px'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,style: 'margin-left:10px'
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
		,region : 'center'
		,layout : 'column'
		,columnWidth : .4
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});*/
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'column'
		,columnWidth : .6
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
			,obj.tICUCPRowID
		]
	});
	obj.viewsupPanel = new Ext.Panel({
		id : 'viewsupPanel'
		,buttonAlign : 'center'
		,height : 60
		,title : '<span style=\'font-size:14px;\'>数据集维护</span>'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			//,obj.buttonPanel
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
			idProperty: 'tICUCPRowID'
		}, 
	    [
			{name: 'tICUCPCode', mapping : 'tICUCPCode'}
			,{name: 'tICUCPDesc', mapping: 'tICUCPDesc'}
			,{name: 'tICUCPRowID', mapping: 'tICUCPRowID'}
			,{name: 'tICUCPDefaultValue', mapping: 'tICUCPDefaultValue'}

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
		,{header: 'Rowid', width: 100, dataIndex: 'tICUCPRowID', sortable: true}
		,{header: '代码', width: 200, dataIndex: 'tICUCPCode', sortable: true}
		,{header: '名称', width: 200, dataIndex: 'tICUCPDesc', sortable: true}
		,{header: '默认值', width: 100, dataIndex: 'tICUCPDefaultValue', sortable: true}
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
		param.ClassName = 'web.DHCICUCProperty';
		param.QueryName = 'FindICUCProperty';
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
		,title : '<span style=\'font-size:14px;\'>显示数据集结果</span>'
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