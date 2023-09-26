function InitViewScreen()
{
    var obj = new Object();
	obj.TWardDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.TWardDescStore = new Ext.data.Store({
		proxy: obj.TWardDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'wardRowid'
		}, 
		[
		     {name: 'wardRowid', mapping: 'wardRowid'}
			,{name: 'wardDesc', mapping: 'wardDesc'}
		])
	});	
	obj.TWardDesc = new Ext.form.ComboBox({
		id : 'TWardDesc'
		,store:obj.TWardDescStore
		,minChars:1	
		,displayField:'wardDesc'	
		,fieldLabel : '病区'
		,valueField : 'wardRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.TWardDescStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'Findward';
		param.Arg1 = obj.TWardDesc.getRawValue();
		param.ArgCnt = 1;
	});
	//obj.TWardDescStore.load({});
	
	obj.TBedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.TBedStore = new Ext.data.Store({
		proxy: obj.TBedStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RoomRowid1'
		}, 
		[
		     {name: 'RoomRowid1', mapping: 'RoomRowid1'}
			,{name: 'RoomDesc', mapping: 'RoomDesc'}
		])
	});	
	obj.TBed = new Ext.form.ComboBox({
		id : 'TBed'
		,store:obj.TBedStore
		,minChars:1	
		,displayField:'RoomDesc'	
		,fieldLabel : '床位'
		,valueField : 'RoomRowid1'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.TBedStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'FindBed';
		param.Arg1 = obj.TWardDesc.getValue();
		param.ArgCnt = 1;
	});
	//obj.TBedStore.load({});
	
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
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.TInterfaceProgramStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.TInterfaceProgram.getRawValue();
		param.Arg2 = obj.TBed.getValue();
		param.Arg3 = "I";
		param.ArgCnt = 3;
	});
	//obj.TInterfaceProgramStore.load({});
	
	obj.TTcpipAddress = new Ext.form.TextField({
	    id : 'TTcpipAddress'
		,fieldLabel : '设备IP'
		,anchor : '95%'
	});
	
	
	obj.Panel11= new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.TWardDesc
			,obj.TInterfaceProgram
            ,obj.TTcpipAddress			
		]
	});
	
	
	
	obj.TDefaultInterval = new Ext.form.TextField({
	    id : 'TDefaultInterval'
		,fieldLabel : '缺省采样间隔'
		,anchor : '95%'
	});
	
	obj.TEditTcpipAddress = new Ext.form.TextField({
	    id : 'TEditTcpipAddress'
		,fieldLabel : '编辑电脑IP'
		,anchor : '95%'
	});
	
	obj.Panel12= new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.TBed
			,obj.TDefaultInterval
            ,obj.TEditTcpipAddress			
		]
	});
	
	obj.confirmedTime = new Ext.form.TextField({
	    id : 'confirmedTime'
		,fieldLabel : 'ICU取数间隔（分）'
		,anchor : '95%'
	});
	
	obj.TPortStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
	    url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.TPortStore = new Ext.data.Store({
		proxy: obj.TPortStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tPort'
		}, 
		[
		     {name: 'tPort', mapping: 'tPort'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});	
	obj.TPort = new Ext.form.ComboBox({
		id : 'TPort'
		,store:obj.TPortStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '设备端口'
		,valueField : 'tPort'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.TPortStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDevPort';
		param.Arg1 = "";
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	//obj.TPortStore.load({});
	
	obj.TEquipRowid = new Ext.form.TextField({
	    id : 'TEquipRowid'
		,hidden: true
	});
	
	obj.TRowid = new Ext.form.TextField({
	    id : 'TRowid'
		,hidden: true
	});
	
	obj.Panel13= new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.confirmedTime
			,obj.TPort
            ,obj.TEquipRowid
            ,obj.TRowid			
		]
	});
	
	obj.fPanel1 = new Ext.form.FormPanel({
		id:"fPanel1"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:100
		,height:30
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
		]
	});
	
	obj.addbutton1 = new Ext.Button({
		id : 'addbutton1'
		,width:60
		,text : '增加'
	});
	obj.updatebutton1 = new Ext.Button({
		id : 'updatebutton1'
		,width:60
		,text : '修改'
	});
	obj.deletebutton1 = new Ext.Button({
		id : 'deletebutton1'
		,width:60
		,text : '删除'
	});
	
	obj.setbutton = new Ext.Button({
		id : 'setbutton'
		,width:60
		,text : '设置'
	});
	
	obj.defaultsetbutton = new Ext.Button({
		id : 'defaultsetbutton'
		,width:60
		,text : '设为默认'
	});
	
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,width:60
		,text : '查找'
	});
	
	obj.switchbutton = new Ext.Button({
		id : 'switchbutton'
		,width:60
		,text : ''
	});
	
	
	obj.addpanel1 = new Ext.Panel({
		id : 'addpanel1'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.addbutton1
		]

	});
	obj.updatepanel1 = new Ext.Panel({
		id : 'updatepanel1'
		,buttonAlign : 'center'	
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.updatebutton1
		]

	});
	obj.deletepanel1 = new Ext.Panel({
		id : 'deletepanel1'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.deletebutton1
		    ]

	});	
	obj.findpanel = new Ext.Panel({
		id : 'findpanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.findbutton
		    ]

	});	
	
	obj.set = new Ext.Panel({
		id : 'set'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.setbutton
		    ]

	});	
	
	obj.defaultset = new Ext.Panel({
		id : 'defaultset'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.defaultsetbutton
		    ]

	});	
	
	
	
	obj.switchpanel = new Ext.Panel({
		id : 'switchpanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'column'
		,items:[
		    obj.switchbutton
		    ]

	});	
	
	obj.buttonPanel1 = new Ext.form.FormPanel({
		id : 'buttonPanel1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 30
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addpanel1
			,obj.updatepanel1
			,obj.deletepanel1
			,obj.findpanel
			,obj.set
			,obj.defaultset
			,obj.switchpanel
		]
	});
	
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 130
		,region : 'north'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.fPanel1
			,obj.buttonPanel1
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
			,{name: 'TBedRowid', mapping: 'TBedRowid'}
			,{name: 'TBed', mapping: 'TBed'}
			,{name: 'TEquipRowid', mapping: 'TEquipRowid'}
			,{name: 'TEquip', mapping: 'TEquip'}
			,{name: 'TDefaultInterval', mapping: 'TDefaultInterval'}
			,{name: 'TInterfaceProgram', mapping: 'TInterfaceProgram'}
			,{name: 'TPort', mapping: 'TPort'}
			,{name: 'TTcpipAddress', mapping: 'TTcpipAddress'}
			,{name: 'TEditTcpipAddress', mapping: 'TEditTcpipAddress'}
			,{name: 'TWardDesc', mapping: 'TWardDesc'}
			,{name: 'TWardId', mapping: 'TWardId'}
			,{name: 'TInterfaceProgramID', mapping: 'TInterfaceProgramID'}
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
			{header: 'TRowid',width: 60,dataIndex: 'TRowid',sortable: true}
			,{header: '床位',width: 60,dataIndex: 'TBed',sortable: true}
			,{header: '设备',width: 80,dataIndex: 'TEquip',sortable: true}
			,{header: '缺省采样间隔',width: 80,dataIndex: 'TDefaultInterval',sortable: true}
			,{header: '采集代码',width: 100,dataIndex: 'TInterfaceProgram',sortable:true}
			,{header: '设备端口',width: 60,dataIndex: 'TPort',sortable:true}
			,{header: '设备IP',width: 120,dataIndex: 'TTcpipAddress',sortable: true}
			,{header: 'TBedRowid',width: 80,dataIndex: 'TBedRowid',sortable: true}
			,{header: 'TEquipRowid',width: 80,dataIndex: 'TEquipRowid',sortable: true}
			,{header: '设备使用地址',width: 80,dataIndex: 'TEditTcpipAddress',sortable: true}
			,{header: '病区',width: 100,dataIndex: 'TWardDesc',sortable:true}
			//,{header: 'TEquipCode',width: 100,dataIndex: 'TEquipCode',sortable:true}
			,{header: 'TInterfaceProgramID',width: 100,dataIndex: 'TInterfaceProgramID',sortable:true}
			,{header: 'TStat',width: 60,dataIndex: 'TStat',sortable:true}
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
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'FindexeBed';
		param.Arg1 = "";
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
	
	
	obj.DHCICUBedEquip = new Ext.Panel({
		id : 'DHCANCCollectType'
		,buttonAlign : 'center'
		,height : 380
		,title : '监护项目表'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	
	
///////////////监护项目子表-------------------------------
	obj.tCode = new Ext.form.TextField({
		id : 'tCode'
		,fieldLabel : '代码'
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
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.tANCCTActiveStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = "YesNo";
		param.ArgCnt = 1;
	});
	//obj.tANCCTActiveStore.load({});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.tCode
			,obj.tANCCTActive	
		]
	});
	
	obj.tANCCTIChannelNo = new Ext.form.TextField({
		id : 'tANCCTIChannelNo'
		,fieldLabel : '通道号'
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
		,fieldLabel : '监护项目名称'
		,valueField : 'MDIRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		//,mode:'local'
	}); 	
	
	obj.tANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindRecordItem';
		param.Arg1 = obj.tANCCTIComOrd.getRawValue();
		param.Arg2 = obj.TInterfaceProgram.getValue();
		param.ArgCnt = 2;
	});
	//obj.tANCCTIComOrdStore.load({});
	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden:true
	});	
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.tANCCTIChannelNo
			,obj.tANCCTIComOrd
			,obj.RowId
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:80
		,height:70
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel1
			,obj.Panel2
		]
	});
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:60
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '修改'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addbutton
		]

	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]

	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
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
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	
	obj.functionItem = new Ext.Panel({
		id : 'functionItem'
		,buttonAlign : 'center'
		,height : 100
		,region : 'north'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
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
	//obj.retGridPanelItemStore.load({});
	
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
		,region : 'center'
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
		,layout : 'border'
		,defaults: {
            split: true
        ,collapsible: true
		}
		,items:[
			obj.DHCICUBedEquip
			,obj.DHCANCCollectTypeItem
		]		
	});
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton1.on("click", obj.addbutton1_click, obj);
    obj.updatebutton1.on("click", obj.updatebutton1_click, obj);
    obj.deletebutton1.on("click", obj.deletebutton1_click, obj);
	obj.findbutton.on("click", obj.findbutton_click, obj);
	obj.setbutton.on("click", obj.setbutton_click, obj);
	obj.defaultsetbutton.on("click", obj.defaultsetbutton_click, obj);
	obj.switchbutton.on("click", obj.switchbutton_click, obj);
	
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.retGridPanelItem.on("rowclick", obj.retGridPanelItem_rowclick, obj);
	obj.LoadEvent(arguments);
	
    return obj;	
}                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       