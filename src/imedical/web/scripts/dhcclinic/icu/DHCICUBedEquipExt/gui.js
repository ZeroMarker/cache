//update by GY 20170307
function InitViewScreen()
{ 
	//20160809
	var obj = new Object();
	//监护设备-------------------------------------------------------
	//病区
	obj.wardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.wardStore = new Ext.data.Store({
		proxy: obj.wardStoreProxy,
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
	obj.ward = new Ext.form.ComboBox({
		id : 'ward'
		,store:obj.wardStore
		,minChars:1	
		,displayField:'wardDesc'	
		,fieldLabel : '病区'
		,valueField : 'wardRowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.wardStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'Findward';
		param.Arg1 = obj.ward.getRawValue();
		param.ArgCnt = 1;
	});
	obj.wardStore.load({});
	
	//床位
	obj.BedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.BedStore = new Ext.data.Store({
		proxy: obj.BedStoreProxy,
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
	obj.Bed = new Ext.form.ComboBox({
		id : 'Bed'
		,store:obj.BedStore
		,minChars:1	
		,displayField:'RoomDesc'	
		,fieldLabel : '床位'
		,valueField : 'RoomRowid1'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.BedStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'FindBed';
		param.Arg1 = obj.ward.getValue();
		param.ArgCnt = 1;
	});
	obj.BedStore.load({});
	
	
	//采集代码
	obj.InterfaceProgramStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.InterfaceProgramStore = new Ext.data.Store({
		proxy: obj.InterfaceProgramStoreProxy,
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
	obj.InterfaceProgram = new Ext.form.ComboBox({
		id : 'InterfaceProgram'
		,store:obj.InterfaceProgramStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '采集代码'
		,valueField : 'trowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
	}); 	
	
	obj.InterfaceProgramStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDHCANCCollectType';
		param.Arg1 = obj.InterfaceProgram.getRawValue();
		param.Arg2 = '';
		param.Arg3 = 'I'
		param.ArgCnt = 3;
	});
	obj.InterfaceProgramStore.load({});
	
	//设备IP
	obj.TcpipAddress = new Ext.form.TextField({
		id : 'TcpipAddress'
		,fieldLabel : '设备IP'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	//20160809
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,labelAlign:'right'
		,columnWidth : .25
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.ward
			,obj.InterfaceProgram
			,obj.TcpipAddress	
		]
	});
	
	//缺省采样间隔
	obj.DefaultInterval = new Ext.form.TextField({
		id : 'DefaultInterval'
		,fieldLabel : '缺省采样间隔'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	
	//编辑电脑IP
	obj.EditTcpipAddress = new Ext.form.TextField({
		id : 'EditTcpipAddress'
		,fieldLabel : '编辑电脑IP'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelAlign:'right'
		,labelWidth : 90
		,layout : 'form'
		,items:[
			obj.Bed
			,obj.DefaultInterval
			,obj.EditTcpipAddress	
		]
	});
	
	
	//ICU取数间隔(分)
	obj.confirmedTime = new Ext.form.TextField({
		id : 'confirmedTime'
		,fieldLabel : 'ICU取数间隔(分)'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//设备端口
	obj.PortStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.PortStore = new Ext.data.Store({
		proxy: obj.PortStoreProxy,
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
	obj.Port = new Ext.form.ComboBox({
		id : 'Port'
		,store:obj.PortStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '设备端口'
		,valueField : 'tPort'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
		
	}); 	
	
	obj.PortStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindDevPort';
		param.Arg1 = obj.Port.getRawValue();
		param.Arg2 = obj.Bed.getValue();
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	obj.PortStore.load({});
	
	
	obj.labelNote=new Ext.form.Label(
	{
		id:'labelNote'
		,text:'如按床位查找需先选择病区'
		,style:'color:red;font-size:14'
		,width:200
		,height:20
	})	
	obj.Panel13 = new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelAlign:'right'
		,layout : 'form'
		,labelWidth : 105
		,items:[
			obj.confirmedTime
			,obj.Port
			,obj.labelNote
		]
	});
	
	//设置按钮
	obj.setButton = new Ext.Button({
		id : 'setButton'
		,width:86
		,iconCls : 'icon-setting'
		,text : '设置'
	});
	
	
	//设为默认按钮
	obj.setDefaultButton = new Ext.Button({
		id : 'setDefaultButton'
		,width:86
		,iconCls : 'icon-ordermanage'
		,text : '设为默认'
	});
	
	//空白Panel
	obj.blankPanel = new Ext.Panel({
		id : 'blankPanel'
		,height:5
		,layout : 'form'
		,items:[
			
		]
	});
	
	
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.setButton
			,obj.blankPanel
			,obj.setDefaultButton
		]
	});
		
	//设备ID
	obj.EquipRowid = new Ext.form.TextField({
		id : 'EquipRowid'
		//,fieldLabel : '设备ID'
		//,hidden:true
	});
	
	//Rowid
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		//,fieldLabel : 'Rowid'
		//,hidden:true
	});
	
	//隐藏Panel
	obj.Panel15 = new Ext.Panel({
		id : 'Panel15'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,hidden:true
		,items:[
			obj.EquipRowid
			,obj.Rowid
		]
	});
	
	obj.addButton = new Ext.Button({
		id : 'addButton'
		,width:86
		,text : '增加'
		,iconCls : 'icon-add'
	});
	
	obj.startOrStopButton = new Ext.Button({
		id : 'startOrStopButton'
		,width:86
		,text : ''
		//,cls : 'lightblue'
	});
	
	obj.updateButton = new Ext.Button({
		id : 'updateButton'
		,width:86
		,text : '更新'
		,iconCls : 'icon-updateSmall'
		,style: 'margin-Top:5px'
	});
	
	
	obj.findButton = new Ext.Button({
		id : 'findButton'
		,width:86
		,text : '查询'
		,iconCls : 'icon-find'
	});
	
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
		,style: 'margin-Top:5px'
	});
	
	obj.ButtonPanel1 = new Ext.Panel({
		id : 'ButtonPanel1'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		    obj.addButton
		    ,obj.updateButton
		]
	});
	
	obj.ButtonPanel2 = new Ext.Panel({
		id : 'ButtonPanel2'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		   obj.findButton 
		   ,obj.deleteButton
		]
	});
	obj.fPanel = new Ext.Panel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,height:80
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
			,obj.Panel15
			,obj.ButtonPanel1
			,obj.ButtonPanel2
		]
	});	
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 80
		,region : 'north'
		,layout : 'border'
		,frame : true
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
			,{header: '缺省采样间隔',width: 100,dataIndex: 'TDefaultInterval',sortable: true}
			,{header: '采集代码',width: 120,dataIndex: 'TInterfaceProgram',sortable: true}
			,{header: '设备端口',width: 80,dataIndex: 'TPort',sortable: true}
			,{header: '设备IP',width: 120,dataIndex: 'TTcpipAddress',sortable: true}
			,{header: 'TBedRowid',width: 80,dataIndex: 'TBedRowid',sortable: true}
			,{header: 'TEquipRowid',width: 80,dataIndex: 'TEquipRowid',sortable: true}
			,{header: '设备使用地址',width: 250,dataIndex: 'TEditTcpipAddress',sortable: true}
			,{header: '病区',width: 250,dataIndex: 'TWardDesc',sortable: true}
			//,{header: 'TEquipCode',width: 120,dataIndex: 'tstatCode',sortable: true}
			,{header: 'TInterfaceProgramID',width: 120,dataIndex: 'TInterfaceProgramID',sortable: true}
			,{header: 'TStat',width: 60,dataIndex: 'TStat',sortable: true}
			
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
		param.ClassName = 'web.DHCICUBedEquip';
		param.QueryName = 'FindexeBed';
		param.Arg1 = obj.Bed.getValue();
		param.Arg2 = obj.InterfaceProgram.getValue();
		param.ArgCnt = 2;
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
		,title : '监护设备查询结果'
		,iconCls : 'icon-result'
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	
	obj.BedEquip = new Ext.Panel({
		id : 'BedEquip'
		,buttonAlign : 'center'
		,height : 200
		,width:500
		,title : '监护设备'
		,region : 'center'
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
	
	//监护项目子表----------------------
	
	//代码
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '序号'
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
		param.Arg1= "YesNo";
		param.ArgCnt = 1;
	});
	obj.ANCCTActiveStore.load({});
	obj.PanelCode = new Ext.Panel({
		id : 'PanelCode'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelAlign:'right'
		,labelWidth : 30
		,layout : 'form'
		,items:[
			obj.Code
		]
	});
	obj.PanelANCCTActive = new Ext.Panel({
		id : 'PanelANCCTActive'
		,columnWidth : .25
		,labelAlign:'right'
		,layout : 'form'
		,labelWidth : 60
		,items:[
			obj.ANCCTActive
		]
	});
	
	
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
		,editable : false
		,selectOnFocus : true
		
	}); 	
	
	obj.ANCCTIComOrdStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCollectType';
		param.QueryName = 'FindRecordItem';
		param.Arg1 = obj.ANCCTIComOrd.getRawValue();
		param.Arg2 = obj.InterfaceProgram.getValue();
		param.ArgCnt = 2;
	});
	obj.ANCCTIComOrdStore.load({});
	obj.PanelANCCTIChannelNo = new Ext.Panel({
		id : 'PanelANCCTIChannelNo'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelAlign:'right'
		,layout : 'form'
		,labelWidth : 45
		,items:[
			obj.ANCCTIChannelNo
		]
	});
	obj.PanelANCCTIComOrd = new Ext.Panel({
		id : 'PanelANCCTIComOrd'
		,buttonAlign : 'center'
		,columnWidth : .34
		,layout : 'form'
		,labelAlign:'right'
		,labelWidth : 90
		,items:[
			obj.ANCCTIComOrd
		]
	});
	
	
	//监护项目子表Rowid
	obj.ItemRowid = new Ext.form.TextField({
		id : 'ItemRowid'
		,fieldLabel : 'ItemRowid'
		,anchor : '95%'
	});
	
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,buttonAlign : 'center'
		,columnWidth : .01
		,hidden : true
		,layout : 'form'
		,items:[
			obj.ItemRowid
		]
	});
	
	obj.fItemPanel = new Ext.Panel({
		id:"fItemPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		//,labelWidth:40
		,height:30
		,region:"center"
		,layout:"column"
		,columnWidth : .6
		,items:[
			obj.PanelCode
			,obj.PanelANCCTActive
			,obj.PanelANCCTIChannelNo
			,obj.PanelANCCTIComOrd
			,obj.Panel23
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
		,columnWidth : .3
		,layout : 'column'
		,items:[
		    obj.addButtonItem
		]

	});
	obj.deleteButtonItemPanel = new Ext.Panel({
		id : 'deleteButtonItemPanel'
		,buttonAlign : 'center'	
		,columnWidth : .3
		,layout : 'column'
		,items:[
		    obj.deleteButtonItem
		]

	});
	obj.updateButtonItemPanel = new Ext.Panel({
		id : 'updateButtonItemPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
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
		,region : 'center'
		,layout : 'column'
		,columnWidth : .4
		,items:[
			obj.addButtonItemPanel
			,obj.updateButtonItemPanel
			,obj.deleteButtonItemPanel
		]
	});
	
	obj.floorItemPanel = new Ext.Panel({
		id : 'floorItemPanel'
		,buttonAlign : 'center'
		,height : 35
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
			{header: '代码',width: 100,dataIndex: 'tCode',sortable: true}
			,{header: '激活状态',width: 100,dataIndex: 'tANCCTIActive',sortable: true}
        	,{header: 'rowid',width: 100,dataIndex: 'trowid',sortable: true}
			,{header: '通道号',width: 100,dataIndex: 'tANCCTIChannelNo',sortable: true}
			,{header: '监护项目ID',width: 100,dataIndex: 'tANCCTIComOrdDr',sortable: true}
			,{header: '监护项目名称',width: 100,dataIndex: 'tANCCTIComOrdDrDesc',sortable: true}
			,{header: '常用医嘱Code',width: 100,dataIndex: 'tANCCTIComCode',sortable: true}
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
		param.Arg1 = obj.InterfaceProgram.getValue();
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
		,title : '监护项目查询结果'
		,iconCls : 'icon-result'
		,items:[
		    obj.PanelItem23
			,obj.PanelItem25
		    ,obj.retGridItemPanel
		]
	});
	
	obj.CollectTypeItem = new Ext.Panel({
		id : 'CollectTypeItem'
		,buttonAlign : 'center'
		,height : 260
		,title : '监护项目子表'
		,region : 'south'
		,layout : 'border'
		,iconCls : 'icon-manage'
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
			obj.BedEquip
			,obj.CollectTypeItem
		]
	}); 
	//obj.BedStore.load({});
	/////////////////////////////////
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick",obj.retGridPanel_rowclick, obj);
	obj.addButton.on("click", obj.addButton_click, obj);
	obj.startOrStopButton.on("click", obj.startOrStopButton_click, obj);
	obj.updateButton.on("click", obj.updateButton_click, obj);
	obj.findButton.on("click", obj.findButton_click, obj);
	obj.deleteButton.on("click", obj.deleteButton_click, obj);
	obj.ward.on('select',obj.ward_select,obj);
	obj.setButton.on("click", obj.setButton_click, obj);
	obj.setDefaultButton.on("click", obj.setDefaultButton_click, obj);
	
	obj.retGridItemPanel.on("rowclick",obj.retGridItemPanel_rowclick, obj);
	obj.addButtonItem.on("click", obj.addButtonItem_click, obj);
	obj.deleteButtonItem.on("click", obj.deleteButtonItem_click, obj);
	obj.updateButtonItem.on("click", obj.updateButtonItem_click, obj);
	
	obj.LoadEvent(arguments); 
	
	return obj;
}