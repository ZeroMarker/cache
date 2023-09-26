//by+2017-03-06
function InitViewScreen(){
	var obj = new Object();
	
	obj.linkclcsstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.linkclcsstore = new Ext.data.Store({
		proxy: obj.linkclcsstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
		[
			{name: 'TRowid', mapping: 'TRowid'}
			,{name: 'TCLCSCode', mapping: 'TCLCSCode'}
			,{name: 'TCLCSDesc', mapping: 'TCLCSDesc'}
			,{name: 'TCLCSType', mapping: 'TCLCSType'}
			,{name: 'TCLCSFactor', mapping: 'TCLCSFactor'}
			,{name: 'TCLCSBaseValue', mapping: 'TCLCSBaseValue'}
			,{name: 'TCLCSIsMainScore', mapping: 'TCLCSIsMainScore'}
			,{name: 'TCLCSCanEdit', mapping: 'TCLCSCanEdit'}
			,{name: 'TCLCSUomdr', mapping: 'TCLCSUomdr'}
			,{name: 'TCLCSComOrdDr', mapping: 'TCLCSComOrdDr'}
			,{name: 'TCLCSComOrd', mapping: 'TCLCSComOrd'}
		])
	});
	
	
	obj.linkclcs = new Ext.form.ComboBox({
		id : 'linkclcs'
		,store:obj.linkclcsstore
		,minChars:1
		,displayField:'TCLCSDesc'
		,fieldLabel : '关联评分'
		,labelSeparator: ''
		,valueField : 'TRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});	
	
	obj.mainclcsstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.mainclcsstore = new Ext.data.Store({
		proxy: obj.mainclcsstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
		[
			{name: 'TRowid', mapping: 'TRowid'}
			,{name: 'TCLCSCode', mapping: 'TCLCSCode'}
			,{name: 'TCLCSDesc', mapping: 'TCLCSDesc'}
			,{name: 'TCLCSType', mapping: 'TCLCSType'}
			,{name: 'TCLCSFactor', mapping: 'TCLCSFactor'}
			,{name: 'TCLCSBaseValue', mapping: 'TCLCSBaseValue'}
			,{name: 'TCLCSIsMainScore', mapping: 'TCLCSIsMainScore'}
			,{name: 'TCLCSCanEdit', mapping: 'TCLCSCanEdit'}
			,{name: 'TCLCSUomdr', mapping: 'TCLCSUomdr'}
			,{name: 'TCLCSComOrdDr', mapping: 'TCLCSComOrdDr'}
			,{name: 'TCLCSComOrd', mapping: 'TCLCSComOrd'}
		])
	});
	
	
	obj.mainclcs = new Ext.form.ComboBox({
		id : 'mainclcs'
		,store:obj.mainclcsstore
		,minChars:1
		,displayField:'TCLCSDesc'
		,fieldLabel : '主评分'
		,labelSeparator: ''
		,valueField : 'TRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});	
	
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
	  	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.mainclcs
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.linkclcs
		]
	});
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,text : '增加'
		,iconCls : 'icon-add'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,text : '更新'
		,iconCls : 'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
		
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,style:'margin-left :10px;'
		,columnWidth : .12
		,layout : 'form'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		//,style:'margin-left :10px;'		
		,columnWidth : .12
		,layout : 'form'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		//,style:'margin-left :10px;'
		,columnWidth : .12
		,layout : 'form'
		,items:[
		    obj.deletebutton
		    ]
	});	
	

    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		//,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
			,obj.Rowid
		]
	});
	obj.clcslinkPanel = new Ext.Panel({
		id : 'clcslinkPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '评分关联项维护'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
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
			idProperty: 'TRowid'
		}, 
	    [
			{name: 'TCLCSLMainCLCSDr', mapping : 'TCLCSLMainCLCSDr'}
			,{name: 'TCLCSLMainCLCS', mapping : 'TCLCSLMainCLCS'}
			,{name: 'TCLCSLLinkCLCSDr', mapping: 'TCLCSLLinkCLCSDr'}
			,{name: 'TCLCSLLinkCLCS', mapping: 'TCLCSLLinkCLCS'}
			,{name: 'TRowid', mapping: 'TRowid'}

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
		,{header: '主评分', width: 250, dataIndex: 'TCLCSLMainCLCS', sortable: true}
		,{header: '主评分指向', width: 250, dataIndex: 'TCLCSLMainCLCSDr', sortable: true}
		,{header: '关联评分', width: 250, dataIndex: 'TCLCSLLinkCLCS', sortable: true}
		,{header: '关联评分指向', width: 250, dataIndex: 'TCLCSLLinkCLCSDr', sortable: true}
		,{header: 'ID号', width: 120, dataIndex: 'TRowid', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	
	obj.linkclcsstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindCLCScore';
		param.ArgCnt = 0;
	});	
	obj.linkclcsstore.load({});	
	
	obj.mainclcsstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindCLCScore';
		param.ArgCnt = 0;
	});	
	obj.mainclcsstore.load({});	
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindClCSLink';
		param.Arg1 = obj.mainclcs.getRawValue();
		param.ArgCnt = 1;
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
			obj.clcslinkPanel
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