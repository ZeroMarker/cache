//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	obj.bpcVSCode = new Ext.form.TextField({
		id : 'bpcVSCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.bpcVSDesc = new Ext.form.TextField({
		id : 'bpcVSDesc'
		,fieldLabel : '描述'
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
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'	
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
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
		,title : '病人转归维护'
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
			{header: '代码',width: 180,dataIndex: 'tBPCVSCode',sortable: true}
           ,{header: '描述', width: 260, dataIndex: 'tBPCVSDesc', sortable: true}
		   ,{header: '系统号', width: 100, dataIndex: 'tBPCVSRowId', sortable: true}
		]
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
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
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
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
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}