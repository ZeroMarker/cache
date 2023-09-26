//by+2017-03-02
function InitViewScreen()
{
    var obj = new Object();
	
	obj.TRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.TRoomStore = new Ext.data.Store({
		proxy: obj.TRoomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RoomRowid'
		}, 
		[
		     {name: 'RoomRowid', mapping: 'RoomRowid'}
			,{name: 'RoomDesc', mapping: 'RoomDesc'}
		])
	});	
	obj.TRoom = new Ext.form.ComboBox({
		id : 'TRoom'
		,store:obj.TRoomStore
		,minChars:1	
		,displayField:'RoomDesc'	
		,fieldLabel : '房间'
		,editable:false
		,valueField : 'RoomRowid'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	}); 	
	
	obj.TRoomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRoomEquip';
		param.QueryName = 'exeRoom';
		param.ArgCnt = 0;
	});
	obj.TRoomStore.load({});
	
	obj.TPort = new Ext.form.TextField({
	    id : 'TPort'
		,fieldLabel : '设备端口'
		,anchor : '95%'
		,labelSeparator: ''
	});
	
	obj.Panel11= new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.TRoom
			,obj.TPort	
		]
	})
	
	obj.TTcpipAddress = new Ext.form.TextField({
	    id : 'TTcpipAddress'
		,fieldLabel : '设备IP'
		,anchor : '95%'
		,labelSeparator: ''
	});
	
	obj.TInterfaceProgramStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.TInterfaceProgramStore = new Ext.data.Store({
		proxy: obj.TInterfaceProgramStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'trowid'
		}, 
		[
		     {name: 'trowid', mapping: 'trowid'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
			,{name: 'tANCCTActive', mapping: 'tANCCTActive'}
			,{name: 'tSource', mapping: 'tSource'}
		])
	});	
	obj.TInterfaceProgram = new Ext.form.ComboBox({
		id : 'TInterfaceProgram'
		,store:obj.TInterfaceProgramStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '采集代码'
		,valueField : 'trowid'
		,labelSeparator: ''
		,editable:false
		,triggerAction : 'all'
		,anchor : '95%'
	}); 	
	
	obj.TInterfaceProgramStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.TInterfaceProgram.getRawValue();
		param.Arg2 = "";
		param.Arg3 = "A";
		param.ArgCnt = 3;
	});
	obj.TInterfaceProgramStore.load({});
	
	
	obj.Panel12= new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.TTcpipAddress
			,obj.TInterfaceProgram		
		]
	});
	
	obj.TUserIPAddress = new Ext.form.TextField({
	    id : 'TUserIPAddress'
	    ,labelSeparator: ''
		,fieldLabel : '用户IP'
		,anchor : '95%'
	});
	
	obj.TDefaultInterval = new Ext.form.TextField({
	    id : 'TDefaultInterval'
		,fieldLabel : '缺省采样间隔'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.TRowid = new Ext.form.TextField({
	    id : 'TRowid'
		,hidden: true
	});
	
	obj.TEquipRowid = new Ext.form.TextField({
	    id : 'TEquipRowid'
		,hidden: true
	});
	
	obj.Panel13= new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.TUserIPAddress
			,obj.TDefaultInterval
            ,obj.TRowid
            ,obj.TEquipRowid		
		]
	});
		obj.addbutton1 = new Ext.Button({
		id : 'addbutton1'
		,width:86
		,text : '增加'
		,iconCls : 'icon-add'
	});
	obj.updatebutton1 = new Ext.Button({
		id : 'updatebutton1'
		,width:86
		,text : '修改'
		,iconCls : 'icon-updateSmall'
		,style:'margin-top:3px;'
	});
	obj.deletebutton1 = new Ext.Button({
		id : 'deletebutton1'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
	});
	
	
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,width:86
		,iconCls : 'icon-find'
		,text : '查找'
		,style:'margin-top:3px;'
	});
	
	
	obj.addpanel1 = new Ext.Panel({
		id : 'addpanel1'
		,buttonAlign : 'center'
		,layout : 'form'
		,style:'margin-left:20px;'
		,columnWidth : .15
		,items:[
		    obj.addbutton1
		    ,obj.updatebutton1
		]

	});
	
	obj.deletepanel1 = new Ext.Panel({
		id : 'deletepanel1'
		,buttonAlign : 'center'
		,layout : 'form'
		,style:'margin-left:15px;'
		,columnWidth : .15
		,items:[
		    obj.deletebutton1
		    ,obj.findbutton
		    ]

	});	

	obj.fPanel1 = new Ext.form.FormPanel({
		id:"fPanel1"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:100
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.addpanel1
			,obj.deletepanel1
		]
	});
	
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 70
		,region : 'north'
		,layout : 'column'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.fPanel1
			
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
			{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TRoom', mapping: 'TRoom'}
			,{name: 'TEquip', mapping: 'TEquip'}
			,{name: 'TDefaultInterval', mapping: 'TDefaultInterval'}
			,{name: 'TInterfaceProgram', mapping: 'TInterfaceProgram'}
			,{name: 'TTcpipAddress', mapping: 'TTcpipAddress'}
			,{name: 'TPort', mapping: 'TPort'}
			,{name: 'TRoomRowid', mapping: 'TRoomRowid'}
			,{name: 'TEquipRowid', mapping: 'TEquipRowid'}
			,{name: 'TUserIPAddress', mapping: 'TUserIPAddress'}
			,{name: 'TInterfaceProgramRowid', mapping: 'TInterfaceProgramRowid'}
			,{name: 'TStat', mapping: 'TStat'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '行号',width: 60,dataIndex: 'TRowid',sortable: true}
			,{header: '房间',width: 60,dataIndex: 'TRoom',sortable: true}
			,{header: '设备',width: 80,dataIndex: 'TEquip',sortable: true}
			,{header: '采样间隔',width: 80,dataIndex: 'TDefaultInterval',sortable: true}
			,{header: '采集代码',width: 120,dataIndex: 'TInterfaceProgram',sortable:true}
			,{header: '设备端口',width: 60,dataIndex: 'TPort',sortable:true}
			,{header: '设备IP',width: 140,dataIndex: 'TTcpipAddress',sortable: true}
			,{header: '用户IP',width: 180,dataIndex: 'TUserIPAddress',sortable: true}
			,{header: 'TRoomRowid',width: 60,dataIndex: 'TRoomRowid',sortable: true}
			,{header: 'TEquipRowid',width: 60,dataIndex: 'TEquipRowid',sortable: true}
			,{header: 'TInterfaceProgramRowid',width:60,dataIndex: 'TInterfaceProgramRowid',sortable:true}
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar: new Ext.PagingToolbar({
			pageSize : 150,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRoomEquip';
		param.QueryName = 'FindexeRoom';
		param.Arg1 = obj.TRoom.getValue();
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
		obj.retGridPanel
		]
	});
	
	obj.DHCANRoomEquip = new Ext.Panel({
		id : 'DHCANRoomEquip'
		,buttonAlign : 'center'
		,height : 380
		,title : '手术间监护设备维护'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	
/////////////////监护项目子表---------------------------------
	obj.tCode = new Ext.form.TextField({
		id : 'tCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.tANCCTActiveStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.tANCCTActiveStore = new Ext.data.Store({
		proxy: obj.tANCCTActiveStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
		     {name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});	
	obj.tANCCTActive = new Ext.form.ComboBox({
		id : 'tANCCTActive'
		,store:obj.tANCCTActiveStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '激活状态'
		,labelSeparator: ''
		,editable:false
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	}); 	
	
	obj.tANCCTActiveStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = "YesNo";
		param.ArgCnt = 1;
	});
	obj.tANCCTActiveStore.load({});
	
	obj.tANCCTIChannelNo = new Ext.form.TextField({
		id : 'tANCCTIChannelNo'
		,fieldLabel : '通道号'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.tANCCTIComOrdStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.tANCCTIComOrdStore = new Ext.data.Store({
		proxy: obj.tANCCTIComOrdStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MDIRowid'
		}, 
		[
		     {name: 'MDIRowid', mapping: 'MDIRowid'}
			,{name: 'MDIDesc', mapping: 'MDIDesc'}
		])
	});	
	obj.tANCCTIComOrd = new Ext.form.ComboBox({
		id : 'tANCCTIComOrd'
		,store:obj.tANCCTIComOrdStore
		,minChars:1	
		,displayField:'MDIDesc'	
		,fieldLabel : '监护项目'
		,labelSeparator: ''
		,valueField : 'MDIRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	obj.tANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindRecordItem';
		param.Arg1 = obj.tANCCTIComOrd.getRawValue();
		param.Arg2 = obj.TInterfaceProgram.getValue();
		param.ArgCnt = 2;
	});
	obj.tANCCTIComOrdStore.load({});
	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden:true
	});	
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:76
		,text : '增加'
		,iconCls : 'icon-add'
		
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:76
		,text : '修改'
		
		,iconCls : 'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:76
		,text : '删除'
		,iconCls : 'icon-delete'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,style:'margin-left:10px;'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.addbutton
		]

	});
obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'form'
		,style:'margin-left:10px;'
		,items:[
		    obj.updatebutton
		]

	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'right'
		,style:'margin-left:10px;'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.deletebutton
		]

	});

	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelWidth : 30
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.tCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.tANCCTActive
		]
	});
	obj.Panel3= new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 45
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.tANCCTIChannelNo
		]
	});
	obj.Panel4= new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth : 70
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.tANCCTIComOrd
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height : 30
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
			,obj.RowId
		]
	});
	
	
	obj.functionItem = new Ext.Panel({
		id : 'functionItem'
		,buttonAlign : 'center'
		,height : 40
		,region : 'north'
		,layout : 'form'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.fPanel
			//,obj.buttonPanel
		]
    });
	
	obj.retGridPanelItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelItemStore = new Ext.data.Store({
		proxy: obj.retGridPanelItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
	    [
			{name: 'tCode', mapping : 'tCode'}
			,{name: 'tANCCTIActive', mapping: 'tANCCTIActive'}
			,{name: 'trowid', mapping: 'trowid'}
			,{name: 'tANCCTIChannelNo', mapping: 'tANCCTIChannelNo'}
			,{name: 'tANCCTIComOrdDr', mapping: 'tANCCTIComOrdDr'}
			,{name: 'tANCCTIComOrdDrDesc', mapping: 'tANCCTIComOrdDrDesc'}
			,{name: 'tANCCTIComCode', mapping: 'tANCCTIComCode'}
		])
	});

    obj.retGridPanelItem = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelItem'
		,store : obj.retGridPanelItemStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		//,autoHeight:true
		,height : 80
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 120, dataIndex: 'tCode', sortable: true}
			,{header: '激活状态', width: 120, dataIndex: 'tANCCTIActive', sortable: true}
			,{header: 'rowid', width: 120, dataIndex: 'trowid', sortable: true}
			,{header: '通道号', width: 120, dataIndex: 'tANCCTIChannelNo', sortable: true}
			,{header: '监护项目ID', width: 150, dataIndex: 'tANCCTIComOrdDr', sortable: true}
			,{header: '监护项目名称', width: 150, dataIndex: 'tANCCTIComOrdDrDesc', sortable: true}
			,{header: '常用医嘱Code', width: 150, dataIndex: 'tANCCTIComCode', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelListStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
		});
	obj.retGridPanelItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindCollectTypeItem';
		param.Arg1 = obj.TInterfaceProgram.getValue();
		param.ArgCnt = 1;
	});	
	obj.retGridPanelItemStore.load({});
	
	obj.PanelItem23 = new Ext.Panel({
		id : 'PanelItem23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.PanelItem25 = new Ext.Panel({
		id : 'PanelItem25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	
	obj.resultItem = new Ext.Panel({
		id : 'resultItem'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.PanelItem23
			,obj.PanelItem25
		    ,obj.retGridPanelItem
			
		]
	});
	
	obj.DHCANCCollectTypeItem = new Ext.Panel({
		id : 'DHCANCCollectTypeItem'
		,buttonAlign : 'center'
		,height : 400
		,title : '监护项目子表'
		,iconCls : 'icon-manage'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.functionItem
			,obj.resultItem
		]
	});
	
	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'form'
		,items:[
			obj.DHCANRoomEquip
			,obj.DHCANCCollectTypeItem
		]
	});
	InitViewScreenEvent(obj);
	
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton1.on("click", obj.addbutton1_click, obj);
    obj.updatebutton1.on("click", obj.updatebutton1_click, obj);
    obj.deletebutton1.on("click", obj.deletebutton1_click, obj);
	obj.findbutton.on("click", obj.findbutton_click, obj);
	
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.retGridPanelItem.on("rowclick", obj.retGridPanelItem_rowclick, obj);
	obj.LoadEvent(arguments);
	
	return obj;
}

