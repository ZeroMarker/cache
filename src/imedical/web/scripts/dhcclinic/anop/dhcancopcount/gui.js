//20170324+GY
function InitViewScreen(){
	var obj = new Object();	
	obj.ancOPCCode = new Ext.form.TextField({
		id : 'ancOPCCode'
		,fieldLabel : '清点项目代码'
		,anchor : '95%'
		,labelSeparator: ''
	});	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	obj.ancOPCDesc = new Ext.form.TextField({
		id : 'ancOPCDesc'
		,fieldLabel : '清点项目名称'
		,anchor : '95%'
		,labelSeparator: ''
	}); 
	obj.ancOPCModelDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));	
    function seltext(v,record) { 
         return record.TypeId+" || "+record.TypeDesc; 
    }    
	obj.ancOPCModelDrstore=new Ext.data.Store({
		proxy: obj.ancOPCModelDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TypeId'
		}, 
		[
			{name: 'TypeId', mapping: 'TypeId'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{ name: 'selecttext', convert:seltext}
			
		])
	});
	obj.ancOPCModelDr = new Ext.form.ComboBox({
		id : 'ancOPCModelDr'
		,store:obj.ancOPCModelDrstore
		,minChars:1
		,displayField:'selecttext'
		,fieldLabel : '清点类型'
		,valueField : 'TypeId'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,columnWidth : .30
		,layout : 'form'
		,labelWidth : 90
		,items:[
			obj.ancOPCCode
			,obj.RowId
		]
	});	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,columnWidth : .40
		,layout : 'form'
		,labelWidth : 90
		,items:[
			obj.ancOPCDesc
		]
	});	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,columnWidth : .30
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.ancOPCModelDr
		]
	});

	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,columnWidth : .5
		,items:[
		     obj.Panel1
		     ,obj.Panel2 
		     //,obj.Panel3
			
		]
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,iconCls : 'icon-find'
		,width:80
		,text : '查询'
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:80
		,style:'margin-left:5px;'
		,text : '增加'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		,width:80
		,style:'margin-left:5px;'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:80
		,style:'margin-left:5px;'
		,text : '删除'
	});

	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'column'
		,columnWidth : .32
		,items:[
		   obj.findbutton
		   ,obj.addbutton
		   ,obj.updatebutton
		   ,obj.deletebutton
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,height : 60
		,title : '手术器材敷料清点项目'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tOPCountId'
		}, 
	    [
			{name: 'tOPCountId', mapping: 'tOPCountId'}
			,{name: 'OPCountCode', mapping: 'OPCountCode'}
			,{name: 'OPCountDesc', mapping: 'OPCountDesc'}
			,{name: 'tOPCountTypeId', mapping: 'tOPCountTypeId'}
			,{name: 'tOPCountType', mapping: 'tOPCountType'}
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
		//,{header: 'tID', width: 50, dataIndex: 'tID', sortable: true}
		,{header: '清点项代码', width: 200, dataIndex: 'OPCountCode', sortable: true}
		,{header: '清点项目描述', width: 260, dataIndex: 'OPCountDesc', sortable: true}
		,{header: '清点类型', width: 200, dataIndex: 'tOPCountType', sortable: true,hidden:true}
		,{header: '清点项ID', width: 0, dataIndex: 'tOPCountId', sortable: true,hidden:true}
		,{header: '清点类型ID', width: 0, dataIndex: 'tOPCountTypeId', sortable: true,hidden:true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
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
		,region : 'center'
		,layout : 'border'
		,iconCls:'icon-result'
		,title : '手术清点项查询结果'
		,frame : true
		,items:[
		    obj.Panel23
		    ,obj.retGridPanel
		    ,obj.Panel25
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
	

	obj.ancOPCModelDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'FindOPCountType';
		param.Arg1=obj.ancOPCModelDr.getValue();
		param.ArgCnt = 1;
		
	});
	obj.ancOPCModelDrstore.load({});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'FindOPCount';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}