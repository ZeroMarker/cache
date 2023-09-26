//20170307+dyl
function InitViewScreen(){
	var obj = new Object();
	
	obj.bpcEMCode = new Ext.form.TextField({
		id : 'bpcEMCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.bpcEMAgent = new Ext.form.TextField({
		id : 'bpcEMAgent'
		,fieldLabel : '代理'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEMCode
			,obj.bpcEMAgent
			,obj.RowId
		]
	});
	
	obj.bpcEMDesc = new Ext.form.TextField({
		id : 'bpcEMDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 

	obj.bpcEMTypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function seltexttype(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
    
	obj.bpcEMTypestore = new Ext.data.Store({
		proxy: obj.bpcEMTypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
		     {name: 'Id', mapping: 'Id'}
			//,{name: 'Desc', mapping: 'Desc'}
			,{ name: 'selecttext', convert:seltexttype }
		])
	});	
	obj.bpcEMType = new Ext.form.ComboBox({
		id : 'bpcEMType'
		,store:obj.bpcEMTypestore
		,minChars:1	
		//,displayField:'Desc'	
		,displayField:'selecttext'
		,fieldLabel : '类型'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEMDesc
			,obj.bpcEMType
		]
	});
	
	obj.bpcEMAbbreviation = new Ext.form.TextField({
		id : 'bpcEMAbbreviation'
		,fieldLabel : '缩写'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.bpcEMNote = new Ext.form.TextField({
		id : 'bpcEMNote'
		,fieldLabel : '备注'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEMAbbreviation
			,obj.bpcEMNote
		]
	});

	obj.manufactNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.manufactNameStore = new Ext.data.Store({
		proxy: obj.manufactNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'BPCMDesc', mapping: 'BPCMDesc'}
		])
	});	
	obj.bpcEMManufacturer = new Ext.form.ComboBox({
		id : 'bpcEMManufacturer'
		,minChars : 1
		,fieldLabel : '厂家名称'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.manufactNameStore
		,displayField : 'BPCMDesc'
		,valueField : 'tRowId'
		,anchor : '95%'
	});	
	obj.manufactNameStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCManufacturer';
		param.QueryName = 'FindEManufacturer';
		param.Arg1 = "";
		param.ArgCnt = 1;
	});
	obj.manufactNameStore.load({});
	
	
	obj.bpcEMCanFilterstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextyn(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
	obj.bpcEMCanFilterstore = new Ext.data.Store({
		proxy: obj.bpcEMCanFilterstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			//,{name: 'Desc', mapping: 'Desc'}
			,{ name: 'selecttext', convert:seltextyn }
		])
	});
	obj.bpcEMCanFilter = new Ext.form.ComboBox({
		id : 'bpcEMCanFilter'
		,store:obj.bpcEMCanFilterstore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttext'
		,fieldLabel : '是否过滤'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEMManufacturer
			,obj.bpcEMCanFilter
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls:'icon-add'
		,style:'margin-left:20px'
		,width:86
		,text : '添加'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls:'icon-edit'
		,style:'margin-top:3px;margin-left:20px'
		,width:86
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls:'icon-delete'
		,text : '删除'
	});
obj.buttonpanel = new Ext.Panel({
		id : 'buttonpanel'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		obj.addbutton
		,obj.updatebutton
		]
		,buttons:[
		
		]
	});
	obj.buttonpanel2 = new Ext.Panel({
		id : 'buttonpanel2'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		obj.deletebutton
		]
		,buttons:[
		
		]
	});
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.buttonpanel
			,obj.buttonpanel2
		]
	});

	
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 90
		,title : '净化设备型号维护'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		//,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tID'
		}, 
	    [
			{name: 'tID', mapping: 'tID'}
			,{name: 'tBPCEMCode', mapping: 'tBPCEMCode'}
			,{name: 'tBPCEMDesc', mapping: 'tBPCEMDesc'}
			,{name: 'tBPCEMAbbreviation', mapping: 'tBPCEMAbbreviation'}
			,{name: 'tBPCEMManufacturerDr', mapping: 'tBPCEMManufacturerDr'}
			,{name: 'tBPCEMManufacturerDesc', mapping: 'tBPCEMManufacturerDesc'}
			,{name: 'tBPCEMAgent', mapping: 'tBPCEMAgent'}
			,{name: 'tBPCEMType', mapping: 'tBPCEMType'}
			,{name: 'tBPCEMTypeD', mapping: 'tBPCEMTypeD'}
			,{name: 'tBPCEMNote', mapping: 'tBPCEMNote'}
			,{name: 'tBPCEMCanFilterB', mapping: 'tBPCEMCanFilterB'}
			,{name: 'tBPCEMCanFilter', mapping: 'tBPCEMCanFilter'}
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
		,{header: '代码', width: 140, dataIndex: 'tBPCEMCode', sortable: true}
		,{header: '描述', width: 140, dataIndex: 'tBPCEMDesc', sortable: true}
		,{header: '缩写', width: 140, dataIndex: 'tBPCEMAbbreviation', sortable: true}
		,{header: '生产厂家', width: 140, dataIndex: 'tBPCEMManufacturerDesc', sortable: true}
		,{header: '代理', width: 140, dataIndex: 'tBPCEMAgent', sortable: true}
		,{header: '类型', width: 140, dataIndex: 'tBPCEMTypeD', sortable: true}
		,{header: '备注', width: 140, dataIndex: 'tBPCEMNote', sortable: true}
		,{header: '是否过滤', width: 100, dataIndex: 'tBPCEMCanFilter', sortable: true}
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
	

	obj.bpcEMTypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEMType';
		param.ArgCnt = 0;
	});
	obj.bpcEMTypestore.load({});
	
	obj.bpcEMCanFilterstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPBedEquip';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.bpcEMCanFilterstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEModel';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
//    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}