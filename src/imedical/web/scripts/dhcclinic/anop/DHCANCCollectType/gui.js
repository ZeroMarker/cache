//by+2017-03-07
function InitViewScreen()
{ 
	var obj = new Object();
	
	//监护设备主表---------------------------
	//代码
	obj.ANCCTCode = new Ext.form.TextField({
		id : 'ANCCTCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	
	//名称
	obj.ANCCTDesc = new Ext.form.TextField({
		id : 'ANCCTDesc'
		,fieldLabel : '名称'
		,labelSeparator: ''
		,anchor : '95%'
	});
	//Source
	obj.ANCCTSource = new Ext.form.TextField({
		id : 'ANCCTSource'
		,fieldLabel : 'Source'
		,labelSeparator: ''
		,anchor : '95%'
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
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.ANCCTActiveStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'YesNo';
		param.ArgCnt = 1;
	});
	//obj.ANCCTActiveStore.load({});
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
	
	
	
	//增加，更新，删除，查询 按钮
	
	obj.addButton = new Ext.Button({
		id : 'addButton'
		//,width:76
		,text : '增加'
		,style:'margin-top :3px;'
		,iconCls : 'icon-add'
	});
	
	obj.updateButton = new Ext.Button({
		id : 'updateButton'
		//,width:76
		,text : '更新'
		,iconCls : 'icon-updateSmall'
	});
	
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		//,width:76
		,style:'margin-top :3px;'
		,text : '删除'
		,iconCls : 'icon-delete'
	});
	
	obj.findButton = new Ext.Button({
		id : 'findButton'
		//,width:76
		,text : '查询'
		,iconCls : 'icon-find'
	});
	
	
	
	
	//医院设备
	obj.hpDevs = new Ext.form.TextField({
		id : 'hpDevs'
		,fieldLabel : '医院设备'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	
	
	//采集服务IP
	obj.MSrvIP = new Ext.form.TextField({
		id : 'MSrvIP'
		,fieldLabel : '采集服务IP'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	
	//设置 按钮
	obj.setDevesButton = new Ext.Button({
		id : 'setDevesButton'
		//,width:76
		,iconCls:'icon-setting'
		,text : '设置'
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
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.srcDevStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.srcDev.getRawValue();
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	//obj.srcDevStore.load({});
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
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.dstDevStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.dstDev.getRawValue();
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	
	//obj.dstDevStore.load({});
	
	//复制 按钮
	obj.copyButton = new Ext.Button({
		id : 'copyButton'
		//,width:76
		,iconCls:'icon-ordermanage'
		,style:'margin-top :3px;'
		,text : '复制'
	});
		obj.setDevesButtonPanel = new Ext.Panel({
		id : 'setDevesButtonPanel'
		,buttonAlign : 'right'
		,labelAlign : 'right'
		//,labelWidth:45
		//,style:'margin-left :10px;'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.setDevesButton
		    ,obj.copyButton
		]
	});
	
	obj.Panel21 = new Ext.Panel({
		id : 'Panel21'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth:90
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.hpDevs
			,obj.dstDev
		]
	});
	obj.Panel22 = new Ext.Panel({
		id : 'Panel22'
		,buttonAlign : 'center'
		,labelWidth:105
		,columnWidth : .25
		,labelAlign : 'right'
		,layout : 'form'
		,items:[
			obj.MSrvIP
			,obj.srcDev
		]
	});
	
	
		obj.deleteButtonPanel = new Ext.Panel({
		id : 'deleteButtonPanel'
		,buttonAlign : 'right'
		,layout : 'column'
		//,style:'margin-left :10px;'
		,columnWidth : .08
		,items:[
		obj.updateButton
		    ,obj.deleteButton
		]
	});
	obj.findButtonPanel = new Ext.Panel({
		id : 'findButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .08
		,layout : 'form'
		,items:[
		    obj.findButton
		    ,obj.addButton
		]
	});
		obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .13
		,labelWidth : 45
		,layout : 'form'
		,items:[
			obj.ANCCTCode
			,obj.ANCCTDesc
		]
	});
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .12
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.ANCCTSource
			,obj.ANCCTActive
		]
	});
	
	obj.fPanel = new Ext.Panel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,height:90
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.findButtonPanel
			,obj.deleteButtonPanel
			,obj.Panel21
			,obj.Panel22
			,obj.setDevesButtonPanel
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
			,{header: 'Source',width: 150,dataIndex: 'tSource',sortable: true}			
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
		,iconCls : 'icon-manage'
		,items:[
			obj.fPanel
			,obj.resultPanel
		]
	});
	
	
	//监护设备子表-------------------------------------------------
	
	//代码
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '序号'
		,labelSeparator: ''
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
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
		
	}); 	
	
	obj.ANCCTActiveItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1= "YesNo";
		param.ArgCnt = 1;
	});
	//obj.ANCCTActiveItemStore.load({});
	obj.PanelCode = new Ext.Panel({
		id : 'PanelCode'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth:30
		,columnWidth : .20
		,layout : 'form'
		,items:[
			obj.Code
		]
	});
	obj.PanelANCCTActiveItem = new Ext.Panel({
		id : 'PanelANCCTActiveItem'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelAlign : 'right'
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ANCCTActiveItem
		]
	});
	/*
	obj.PanelItem21 = new Ext.Panel({
		id : 'PanelItem21'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'column'
		,items:[
			obj.PanelCode
			,obj.PanelANCCTActiveItem
		]
	});
	*/
	
	
	//通道号
	obj.ANCCTIChannelNo = new Ext.form.TextField({
		id : 'ANCCTIChannelNo'
		,fieldLabel : '通道号'
		,labelSeparator: ''
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
		,labelSeparator: ''
		,editable : true
		,selectOnFocus : true
		
	}); 	
	
	obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindRecordItem';
		param.Arg1 = obj.ANCCTIComOrd.getRawValue();
		param.Arg2 = obj.ANCCTRowid.getRawValue();
		param.ArgCnt = 2;
	});
	//obj.ANCCTIComOrdStore.load({});
	obj.PanelANCCTIChannelNo = new Ext.Panel({
		id : 'PanelANCCTIChannelNo'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelAlign : 'right'
		,labelWidth:45
		,layout : 'form'
		,items:[
			obj.ANCCTIChannelNo
		]
	});
	obj.PanelANCCTIComOrd = new Ext.Panel({
		id : 'PanelANCCTIComOrd'
		,buttonAlign : 'center'
		,columnWidth : .35
		,labelAlign : 'right'
		,labelWidth:90
		,layout : 'form'
		,items:[
			obj.ANCCTIComOrd
		]
	});
	/*
	obj.PanelItem22 = new Ext.Panel({
		id : 'PanelItem22'
		,buttonAlign : 'center'
		,columnWidth : .45
		,labelAlign : 'right'
		,layout : 'column'
		,items:[
			obj.PanelANCCTIChannelNo
			,obj.PanelANCCTIComOrd
		]
	});
	*/
	
	//监护项目子表Rowid
	obj.ItemRowid = new Ext.form.TextField({
		id : 'ItemRowid'
		,fieldLabel : 'ItemRowid'
		,anchor : '95%'
	});
	
	obj.PanelItem23 = new Ext.Panel({
		id : 'PanelItem23'
		,buttonAlign : 'center'
		,columnWidth : .05
		,hidden : true
		,layout : 'form'
		,items:[
			obj.ItemRowid
		]
	});
	//20160902+dyl
	obj.fItemPanel = new Ext.Panel({
		id:"fItemPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		//,labelWidth:60
		,height:30
		,columnWidth : .65
		,region:"center"
		,layout:"column"
		,items:[
			//obj.PanelItem21
			obj.PanelCode
			,obj.PanelANCCTActiveItem
			,obj.PanelANCCTIChannelNo
			,obj.PanelANCCTIComOrd
			,obj.PanelItem23
		]
	});
	
	obj.addButtonItem = new Ext.Button({
		id : 'addButtonItem'
		,width:86
		,text : '增加'
		,iconCls : 'icon-add'
		,style: 'margin-left:10px'
	});
	obj.deleteButtonItem = new Ext.Button({
		id : 'deleteButtonItem'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
		,style: 'margin-left:10px'
	});
	obj.updateButtonItem= new Ext.Button({
		id : 'updateButtonItem'
		,width:86
		,text : '更新'
		,iconCls : 'icon-updateSmall'
		,style: 'margin-left:10px'
	});
	obj.addButtonItemPanel = new Ext.Panel({
		id : 'addButtonItemPanel'
		,buttonAlign : 'right'
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.addButtonItem
		]

	});
	obj.deleteButtonItemPanel = new Ext.Panel({
		id : 'deleteButtonItemPanel'
		,buttonAlign : 'center'	
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.deleteButtonItem
		]

	});
	obj.updateButtonItemPanel = new Ext.Panel({
		id : 'updateButtonItemPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
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
		,height : 40
		,columnWidth : .35
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addButtonItemPanel
			,obj.updateButtonItemPanel
			,obj.deleteButtonItemPanel
		]
	});
	
	obj.floorItemPanel = new Ext.Panel({
		id : 'floorItemPanel'
		,buttonAlign : 'center'
		,height : 40
		,region : 'north'
		,layout : 'column'
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
			{header: '序号',width: 120,dataIndex: 'tCode',sortable: true}
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
	//obj.retGridItemPanelStore.load({});
	
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
		,height : 200
		,title : '监护项目子表'
		,region : 'south'
		,layout : 'border'
		,frame : true
		,animate:true
		,iconCls : 'icon-manage'
		,items:[
			obj.floorItemPanel
			,obj.resultItemPanel
		]
	});
	
	//----------------------------------
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,frame: true
		,items:[
			obj.DHCANCCollectType
			,obj.DHCANCCollectTypeItem
		]
		,defaults: {
            split: true
        }
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