//20170307+dyl
function InitViewScreen(){
	var obj = new Object();
	
	obj.bpbeBedDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextbed(v, record) { 
         return record.tRowId+" || "+record.tBPCBDesc; 
    } 
	obj.bpbeBedDrstore = new Ext.data.Store({
		proxy: obj.bpbeBedDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
		     {name: 'tRowId', mapping: 'tRowId'}
			,{ name: 'selecttext', convert:seltextbed }
			//,{name: 'tBPCBDesc', mapping: 'tBPCBDesc'}
		])
	});	
	obj.bpbeBedDr = new Ext.form.ComboBox({
		id : 'bpbeBedDr'
		,store:obj.bpbeBedDrstore
		,minChars:1	
		//,displayField:'tBPCBDesc'	
		,displayField:'selecttext'	
		,fieldLabel : '床位'
		,labelSeparator: ''
		,valueField : 'tRowId'
		,triggerAction : 'all'
		,anchor : '85%'
		,editable : true
		,mode: 'local'
	}); 		
	
	obj.bpbeCollectTypeDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextco(v, record) { 
         return record.trowid+" || "+record.tDesc; 
    } 
	obj.bpbeCollectTypeDrstore = new Ext.data.Store({
		proxy: obj.bpbeCollectTypeDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'trowid'
		}, 
		[
		     {name: 'trowid', mapping: 'trowid'}
			,{ name: 'selecttext', convert:seltextco }
			//,{name: 'tDesc', mapping: 'tDesc'}
		])
	});	
	obj.bpbeCollectTypeDr = new Ext.form.ComboBox({
		id : 'bpbeCollectTypeDr'
		,store:obj.bpbeCollectTypeDrstore
		,minChars:1	
		//,displayField:'tDesc'	
		,displayField:'selecttext'	
		,fieldLabel : '采集代码'
		,labelSeparator: ''
		,valueField : 'trowid'
		,triggerAction : 'all'
		,anchor : '85%'
		,editable : true
		,mode: 'local'
	}); 
	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.bpbeBedDr
			,obj.bpbeCollectTypeDr
			,obj.RowId
		]
	});

	obj.bpbeBPCEquipDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextequip(v, record) { 
         return record.tBPCERowId+" || "+record.tBPCEDesc; 
    } 
	obj.bpbeBPCEquipDrstore = new Ext.data.Store({
		proxy: obj.bpbeBPCEquipDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tBPCERowId'
		}, 
		[
		     {name: 'tBPCERowId', mapping: 'tBPCERowId'}
			,{ name: 'selecttext', convert:seltextequip }
			//,{name: 'tBPCEDesc', mapping: 'tBPCEDesc'}
		])
	});	
	obj.bpbeBPCEquipDr = new Ext.form.ComboBox({
		id : 'bpbeBPCEquipDr'
		,store:obj.bpbeBPCEquipDrstore
		,minChars:1	
		//,displayField:'tBPCEDesc'	
		,displayField:'selecttext'	
		,fieldLabel : '设备'
		,labelSeparator: ''
		,valueField : 'tBPCERowId'
		,triggerAction : 'all'
		,anchor : '85%'
		,editable : true
		,mode: 'local'
	}); 	

	obj.bpbeDefaultInterval = new Ext.form.TextField({
		id : 'bpbeDefaultInterval'
		,fieldLabel : '缺省采样间隔'
		,labelSeparator: ''
		,anchor : '85%'
	});  
		
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth:100
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.bpbeBPCEquipDr
			,obj.bpbeDefaultInterval
		]
	});
	
	obj.bpbeTcpipAddress = new Ext.form.TextField({
		id : 'bpbeTcpipAddress'
		,fieldLabel : '设备IP'
		,labelSeparator: ''
		,anchor : '85%'
	}); 
	obj.bpbeEditTcpipAddress = new Ext.form.TextField({
		id : 'bpbeEditTcpipAddress'
		,fieldLabel : '编辑电脑IP'
		,labelSeparator: ''
		,anchor : '85%'
	}); 
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.bpbeTcpipAddress
			,obj.bpbeEditTcpipAddress
		]
	});

	obj.bpbePort = new Ext.form.TextField({
		id : 'bpbePort'
		,fieldLabel : '设备端口'
		,labelSeparator: ''
		,anchor : '85%'
	});
	
	obj.bpbeIfConnectedstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextyn(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
	obj.bpbeIfConnectedstore = new Ext.data.Store({
		proxy: obj.bpbeIfConnectedstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{ name: 'selecttext', convert:seltextyn }
			//,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.bpbeIfConnected = new Ext.form.ComboBox({
		id : 'bpbeIfConnected'
		,store:obj.bpbeIfConnectedstore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttext'
		,fieldLabel : '是否连接'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '85%'
	});

	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.bpbePort
			,obj.bpbeIfConnected
		]
	});
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-insert'
		,width:86
		,style:'margin-left:20px'
		,text : '添加'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,style:'margin-top:3px;margin-left:20px'
		,iconCls : 'icon-edit'
		,width:86
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,style:'margin-left:20px'
		,iconCls : 'icon-delete'
		,text : '删除'
	});

	obj.buttonpanel = new Ext.Panel({
		id : 'buttonpanel'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
        ,items:[
            obj.addbutton
            ,obj.updatebutton
            ,obj.deletebutton
       ]
	});
	obj.buttonpanel2 = new Ext.Panel({
		id : 'buttonpanel2'
		,buttonAlign : 'center'
		,columnWidth : .15
		,layout : 'form'
        ,items:[
            obj.deletebutton
       ]
	});
/*
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		//,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			//obj.keypanel
		]
	});
	*/
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		//,region : 'center'
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
		,title : '净化监护设备维护'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tBPBERowId'
		}, 
	    [
			{name: 'tBPBERowId', mapping: 'tBPBERowId'}
			,{name: 'tBPBEBedDr', mapping: 'tBPBEBedDr'}
			,{name: 'tBPBEBed', mapping: 'tBPBEBed'}
			,{name: 'tBPBEBPCEquipDr', mapping: 'tBPBEBPCEquipDr'}
			,{name: 'tBPBEBPCEquip', mapping: 'tBPBEBPCEquip'}
			,{name: 'tBPBETcpipAddress', mapping: 'tBPBETcpipAddress'}
			,{name: 'tBPBEPort', mapping: 'tBPBEPort'}
			,{name: 'tBPBECollectTypeDr', mapping: 'tBPBECollectTypeDr'}
			,{name: 'tBPBECollectType', mapping: 'tBPBECollectType'}
			,{name: 'tBPBEDefaultInterval', mapping: 'tBPBEDefaultInterval'}
			,{name: 'tBPBEEditTcpipAddress', mapping: 'tBPBEEditTcpipAddress'}
			,{name: 'tBPBEIfConnectedB', mapping: 'tBPBEIfConnectedB'}
			,{name: 'tBPBEIfConnected', mapping: 'tBPBEIfConnected'}
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
		,{header: '床位', width: 140, dataIndex: 'tBPBEBed', sortable: true}
		,{header: '设备', width: 240, dataIndex: 'tBPBEBPCEquip', sortable: true}
		,{header: '设备IP', width: 140, dataIndex: 'tBPBETcpipAddress', sortable: true}
		,{header: '设备端口', width: 140, dataIndex: 'tBPBEPort', sortable: true}
		,{header: '采集代码', width: 140, dataIndex: 'tBPBECollectType', sortable: true}
		,{header: '缺省采样间隔', width: 140, dataIndex: 'tBPBEDefaultInterval', sortable: true}
		,{header: '编辑电脑IP', width: 140, dataIndex: 'tBPBEEditTcpipAddress', sortable: true}
		,{header: '是否连接', width: 140, dataIndex: 'tBPBEIfConnected', sortable: true}
		,{header: 'tID', width: 50, dataIndex: 'tBPBERowId', sortable: true}
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
	

	obj.bpbeBedDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCBed';
		param.QueryName = 'FindBPCBed';
		param.ArgCnt = 0;
	});
	obj.bpbeBedDrstore.load({});
	
	obj.bpbeCollectTypeDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1="";
		param.Arg2="";
		param.Arg3="B";
		param.ArgCnt = 3;
	});
	obj.bpbeCollectTypeDrstore.load({});

	obj.bpbeBPCEquipDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquip';
		param.QueryName = 'FindEquip';
		param.Arg1="";
		param.Arg2="";
		param.Arg3="";
		param.Arg4="";
		param.Arg5="";
		param.ArgCnt = 5;
	});
	obj.bpbeBPCEquipDrstore.load({});
	
	obj.bpbeIfConnectedstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPBedEquip';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.bpbeIfConnectedstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPBedEquip';
		param.QueryName = 'FindBedEquip';
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