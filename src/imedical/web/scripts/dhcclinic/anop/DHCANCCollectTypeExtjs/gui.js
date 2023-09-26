function InitViewScreen()
{ 
	var obj = new Object();
	
	//监护设备主表---------------------------
	//代码
	obj.ANCCTCode = new Ext.form.TextField({
		id : 'ANCCTCode'
		,fieldLabel : '代码'
		,anchor : '95%'
	});	
	
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'right'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ANCCTCode
		]
	});
	
	//名称
	obj.ANCCTDesc = new Ext.form.TextField({
		id : 'ANCCTDesc'
		,fieldLabel : '名称'
		,anchor : '95%'
	});
	
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ANCCTDesc
		]
	});
	
	//Source
	obj.ANCCTSource = new Ext.form.TextField({
		id : 'ANCCTSource'
		,fieldLabel : 'Source'
		,anchor : '95%'
	});
	
	obj.Panel13 = new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ANCCTSource
		]
	});
	
	//激活状态
	obj.ANCCTActiveStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ANCCTActiveStore = new Ext.data.Store({
		proxy: obj.ANCCTActiveStoreProxy,
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
	obj.ANCCTActive = new Ext.form.ComboBox({
		id : 'ANCCTActive'
		,store:obj.ANCCTActiveStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '激活状态'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.ANCCTActiveStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'YesNo';
		param.ArgCnt = 1;
	});
	obj.ANCCTActiveStore.load({});
	
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.ANCCTActive
		]
	});
	
	//监护项目主表Rowid
	obj.ANCCTRowid = new Ext.form.TextField({
		id : 'ANCCTRowid'
		,fieldLabel : 'ItemRowid'
		,anchor : '95%'
	});
	
	obj.Panel15 = new Ext.Panel({
		id : 'Panel15'
		,hidden : true
		,items:[
			obj.ANCCTRowid
		]
	});
	
	obj.Panel1 = new Ext.Panel({
		id:"Panel1"
		,buttonAlign:"center"
		,labelAlign : 'left'
		,labelWidth:30
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
			,obj.Panel15
		]
	});
	
	//增加，更新，删除，查询 按钮
	
	obj.addButton = new Ext.Button({
		id : 'addButton'
		,width:60
		,text : '增加'
	});
	
	obj.updateButton = new Ext.Button({
		id : 'updateButton'
		,width:60
		,text : '更新'
	});
	
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		,width:60
		,text : '删除'
	});
	
	obj.findButton = new Ext.Button({
		id : 'findButton'
		,width:60
		,text : '查询'
	});
	
	obj.addButtonPanel = new Ext.Panel({
		id : 'addButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.addButton
		]
	});
	
	obj.updateButtonPanel = new Ext.Panel({
		id : 'updateButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.updateButton
		]
	});
	
	obj.deleteButtonPanel = new Ext.Panel({
		id : 'deleteButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.deleteButton
		]
	});
	
	obj.findButtonPanel = new Ext.Panel({
		id : 'findButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.findButton
		]
	});
	
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 40
		,layout : 'column'
		,items:[
			obj.addButtonPanel
			,obj.updateButtonPanel
			,obj.findButtonPanel
			,obj.deleteButtonPanel
		]
	});
	
	//医院设备
	obj.hpDevs = new Ext.form.TextField({
		id : 'hpDevs'
		,fieldLabel : '医院设备'
		,anchor : '95%'
	});
	
	obj.Panel21 = new Ext.Panel({
		id : 'Panel21'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.hpDevs
		]
	});
	
	//采集服务IP
	obj.MSrvIP = new Ext.form.TextField({
		id : 'MSrvIP'
		,fieldLabel : '采集服务IP'
		,anchor : '95%'
	});
	
	obj.Panel22 = new Ext.Panel({
		id : 'Panel22'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.MSrvIP
		]
	});
	
	//设置 按钮
	obj.setDevesButton = new Ext.Button({
		id : 'setDevesButton'
		,width:60
		,text : '设置'
	});
	
	obj.setDevesButtonPanel = new Ext.Panel({
		id : 'setDevesButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.setDevesButton
		]
	});
	
	obj.Panel2 = new Ext.Panel({
		id:"Panel2"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:30
		//,height:30
		,layout:"column"
		,items:[
			obj.Panel21
			,obj.Panel22
			,obj.setDevesButtonPanel
		]
	});
	
	
	//Source Device
	obj.srcDevStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.srcDevStore = new Ext.data.Store({
		proxy: obj.srcDevStoreProxy,
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
	
	obj.srcDev = new Ext.form.ComboBox({
		id : 'srcDev'
		,store:obj.srcDevStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : 'Source Device'
		,valueField : 'trowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.srcDevStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.srcDev.getRawValue();
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	obj.srcDevStore.load({});
	
	obj.Panel31 = new Ext.Panel({
		id : 'Panel31'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.srcDev
		]
	});
	
	
	//dest Deivice
	obj.dstDevStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.dstDevStore = new Ext.data.Store({
		proxy: obj.dstDevStoreProxy,
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
	
	obj.dstDev = new Ext.form.ComboBox({
		id : 'dstDev'
		,store:obj.dstDevStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : 'dest Deivice'
		,valueField : 'trowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
	}); 	
	
	obj.dstDevStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.dstDev.getRawValue();
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	
	obj.dstDevStore.load({});
	
	obj.Panel32 = new Ext.Panel({
		id : 'Panel32'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.dstDev
		]
	});
	
	//复制 按钮
	obj.copyButton = new Ext.Button({
		id : 'copyButton'
		,width:60
		,text : '复制'
	});
	
	obj.copyButtonPanel = new Ext.Panel({
		id : 'copyButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.copyButton
		]
	});
	
	obj.Panel3 = new Ext.Panel({
		id:"Panel3"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:30
		,layout:"column"
		,items:[
			obj.Panel31
			,obj.Panel32
			,obj.copyButtonPanel
		]
	});
	
	obj.fPanel = new Ext.Panel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'form'
		,height:150
		,frame : true
		,items:[
			obj.Panel1
			,obj.buttonPanel
			,obj.Panel2
			,obj.Panel3
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
			idProperty: 'trowid'
		}, 
	    [
			{name: 'trowid', mapping : 'trowid'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
			,{name: 'tANCCTActive', mapping: 'tANCCTActive'}
			,{name: 'tSource', mapping: 'tSource'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '代码',width: 250,dataIndex: 'tCode',sortable: true}
			,{header: '名称',width: 250,dataIndex: 'tDesc',sortable: true}
        	,{header: '激活状态',width: 150,dataIndex: 'tANCCTActive',sortable: true}
			,{header: 'rowid',width: 150,dataIndex: 'trowid',sortable: true}
			,{header: 'tSource',width: 150,dataIndex: 'tSource',sortable: true}			
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
			pageSize : 50,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.ANCCTCode.getRawValue();
		param.Arg2 = "";
		param.Arg3 = obj.ANCCTSource.getRawValue();
		param.ArgCnt = 3;
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
		,height:100
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	
	obj.DHCANCCollectType = new Ext.Panel({
		id : 'DHCANCCollectType'
		,buttonAlign : 'center'
		,title : '监护设备主表'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.resultPanel
		]
	});
	
	
	//监护设备子表-------------------------------------------------
	
	//代码
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	
	//激活状态
	obj.ANCCTActiveItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ANCCTActiveItemStore = new Ext.data.Store({
		proxy: obj.ANCCTActiveItemStoreProxy,
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
	obj.ANCCTActiveItem = new Ext.form.ComboBox({
		id : 'ANCCTActiveItem'
		,store:obj.ANCCTActiveItemStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '激活状态'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		
	}); 	
	
	obj.ANCCTActiveItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1= "YesNo";
		param.ArgCnt = 1;
	});
	obj.ANCCTActiveItemStore.load({});
	
	obj.PanelItem21 = new Ext.Panel({
		id : 'PanelItem21'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.Code
			,obj.ANCCTActiveItem
		]
	});
	
	
	//通道号
	obj.ANCCTIChannelNo = new Ext.form.TextField({
		id : 'ANCCTIChannelNo'
		,fieldLabel : '通道号'
		,anchor : '95%'
	});
	
	//监护项目名称
	obj.ANCCTIComOrdStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ANCCTIComOrdStore = new Ext.data.Store({
		proxy: obj.ANCCTIComOrdStoreProxy,
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
	obj.ANCCTIComOrd = new Ext.form.ComboBox({
		id : 'ANCCTIComOrd'
		,store:obj.ANCCTIComOrdStore
		,minChars:1	
		,displayField:'MDIDesc'	
		,fieldLabel : '监护项目名称'
		,valueField : 'MDIRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		
	}); 	
	
	obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'FindMoniDataItem';
		param.Arg1 = obj.ANCCTIComOrd.getRawValue();
		param.ArgCnt = 1;
	});
	obj.ANCCTIComOrdStore.load({});
	
	obj.PanelItem22 = new Ext.Panel({
		id : 'PanelItem22'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.ANCCTIChannelNo
			,obj.ANCCTIComOrd
		]
	});
	
	//监护项目子表Rowid
	obj.ItemRowid = new Ext.form.TextField({
		id : 'ItemRowid'
		,fieldLabel : 'ItemRowid'
		,anchor : '95%'
	});
	
	obj.PanelItem23 = new Ext.Panel({
		id : 'PanelItem23'
		,buttonAlign : 'center'
		,columnWidth : .3
		,hidden : true
		,layout : 'form'
		,items:[
			obj.ItemRowid
		]
	});
	
	obj.fItemPanel = new Ext.Panel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:80
		,region:"center"
		,layout:"column"
		,items:[
			obj.PanelItem21
			,obj.PanelItem22
			,obj.PanelItem23
		]
	});
	
	obj.addButtonItem = new Ext.Button({
		id : 'addButtonItem'
		,width:60
		,text : '增加'
	});
	obj.deleteButtonItem = new Ext.Button({
		id : 'deleteButtonItem'
		,width:60
		,text : '删除'
	});
	obj.updateButtonItem= new Ext.Button({
		id : 'updateButtonItem'
		,width:60
		,text : '更新'
	});
	obj.addButtonItemPanel = new Ext.Panel({
		id : 'addButtonItemPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addButtonItem
		]

	});
	obj.deleteButtonItemPanel = new Ext.Panel({
		id : 'deleteButtonItemPanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.deleteButtonItem
		]

	});
	obj.updateButtonItemPanel = new Ext.Panel({
		id : 'updateButtonItemPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updateButtonItem
		    ]

	});	
	obj.buttonItemPanel = new Ext.Panel({
		id : 'buttonItemPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addButtonItemPanel
			,obj.deleteButtonItemPanel
			,obj.updateButtonItemPanel
		]
	});
	
	obj.floorItemPanel = new Ext.Panel({
		id : 'floorItemPanel'
		,buttonAlign : 'center'
		,height : 100
		,region : 'north'
		,layout : 'border'
		,frame : true
		,items:[
			obj.fItemPanel
			,obj.buttonItemPanel
		]
    });
   
    obj.retGridItemPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridItemPanelStore = new Ext.data.Store({
		proxy: obj.retGridItemPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'trowid'
		}, 
	    [
			{name: 'trowid', mapping : 'trowid'}
			,{name: 'tCode', mapping: 'tCode'}
			,{name: 'tANCCTIComOrdDr', mapping: 'tANCCTIComOrdDr'}
			,{name: 'tANCCTIChannelNo', mapping: 'tANCCTIChannelNo'}
			,{name: 'tANCCTIActive', mapping: 'tANCCTIActive'}
			,{name: 'tANCCTIComOrdDrDesc', mapping: 'tANCCTIComOrdDrDesc'}
			,{name: 'tANCCTIComCode', mapping: 'tANCCTIComCode'}			
		])
	});
	var cmItem = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '代码',width: 120,dataIndex: 'tCode',sortable: true}
			,{header: '激活状态',width: 120,dataIndex: 'tANCCTIActive',sortable: true}
        	,{header: 'rowid',width: 120,dataIndex: 'trowid',sortable: true}
			,{header: '通道号',width: 120,dataIndex: 'tANCCTIChannelNo',sortable: true}
			,{header: '监护项目ID',width: 120,dataIndex: 'tANCCTIComOrdDr',sortable: true}
			,{header: '监护项目名称',width: 120,dataIndex: 'tANCCTIComOrdDrDesc',sortable: true}
			,{header: '常用医嘱Code',width: 120,dataIndex: 'tANCCTIComCode',sortable: true}
		]
	});
	
	 obj.retGridItemPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridItemPanel'
		,store : obj.retGridItemPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cmItem
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridItemPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridItemPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindCollectTypeItem';
		param.Arg1 = obj.ANCCTRowid.getValue();
		param.ArgCnt = 1;
	});
	obj.retGridItemPanelStore.load({});
	
	obj.PanelItem23 = new Ext.Panel({
		id : 'PanelList23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	
	obj.PanelItem25 = new Ext.Panel({
		id : 'PanelList25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	obj.resultItemPanel = new Ext.Panel({
		id : 'resultItemPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.PanelItem23
			,obj.PanelItem25
		    ,obj.retGridItemPanel
		]
	});
	
	obj.DHCANCCollectTypeItem = new Ext.Panel({
		id : 'DHCCollectTypeItem'
		,buttonAlign : 'center'
		,height : 300
		,title : '监护项目子表'
		,region : 'south'
		,layout : 'border'
		,frame : true
		,animate:true
		,items:[
			obj.floorItemPanel
			,obj.resultItemPanel
		]
	});
	
	//----------------------------------
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.DHCANCCollectType
			,obj.DHCANCCollectTypeItem
		]
	}); 
	
	
	/////////////////////////////////////////////
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick",obj.retGridPanel_rowclick, obj);
	obj.addButton.on("click", obj.addButton_click, obj);
	obj.updateButton.on("click", obj.updateButton_click, obj);
	obj.deleteButton.on("click", obj.deleteButton_click, obj);
	obj.findButton.on("click", obj.findButton_click, obj);
	
	obj.setDevesButton.on("click", obj.setDevesButton_click, obj);
	obj.copyButton.on("click", obj.copyButton_click, obj);
	
	obj.retGridItemPanel.on("rowclick",obj.retGridItemPanel_rowclick, obj);
	obj.addButtonItem.on("click", obj.addButtonItem_click, obj);
	obj.deleteButtonItem.on("click", obj.deleteButtonItem_click, obj);
	obj.updateButtonItem.on("click", obj.updateButtonItem_click, obj);
	
	obj.LoadEvent(arguments); 
	
	return obj;
}