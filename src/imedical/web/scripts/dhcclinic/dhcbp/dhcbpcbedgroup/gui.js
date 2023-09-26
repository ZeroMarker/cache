//update by GY 20170307
function InitViewScreen(){
	var obj=new Object();
	obj.BPCBGDesc = new Ext.form.TextField({
		id : 'BPCBGDesc'
		,fieldLabel : '床位组名称'
		,labelSeparator: ''
		,anchor : '95%'

	});

	obj.BPCBGCode = new Ext.form.TextField({
		id : 'BPCBGCode'
		,fieldLabel : '床位组代码'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCBGWordDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextward(v, record) { 
         return record.wardRowid+" || "+record.wardDesc; 
    } 
   	obj.BPCBGWordDrStore = new Ext.data.Store({
      	proxy: obj.BPCBGWordDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'wardRowid'   
      		}, 
      		[	
      			{name: 'wardRowid', mapping: 'wardRowid'}
      			,{ name: 'selecttext', convert: seltextward}
      			//,{name: 'wardDesc', mapping: 'wardDesc'}
    
      		])
      	});		
   obj.BPCBGWordDr =new Ext.form.ComboBox({
      	id : 'obj.BPCBGWordDr'
      	,store : obj.BPCBGWordDrStore
      	,minChars : 0
      	//,displayField : 'wardDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '病区'
      	,valueField : 'wardRowid'
      	,editable : true
      	,triggerAction : 'all'
      	,labelSeparator: ''
      	,anchor : '95%'
              });	
    obj.BPCBGWordDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUBedEquip';
      	param.QueryName = 'Findward';
      	param.Arg1 = obj.BPCBGWordDr.getRawValue();
      	param.ArgCnt = 1;
      	});
      	obj.BPCBGWordDrStore.load();

	obj.ctlocdescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ctlocdescstore = new Ext.data.Store({
		proxy: obj.ctlocdescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
		     {name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
			,{name: 'ctlocCode', mapping: 'ctlocCode'}
		])
	});	
	obj.ctlocdesc = new Ext.form.ComboBox({
		id : 'ctlocdesc'
		,store:obj.ctlocdescstore
		,minChars:1	
		,displayField:'ctlocDesc'	
		,fieldLabel : '科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	
	
	obj.ctlocdescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'FindLocList';
		param.Arg1=obj.ctlocdesc.getValue();
		param.Arg2="";
		param.Arg3="";
		param.ArgCnt = 3;
	});
	obj.ctlocdescstore.load({});
	
	
	
	
	obj.BPCBGRowId = new Ext.form.TextField({
		id : 'BPCBGRowId'
		,hidden : true
	})
	obj.BPCBGIsolatedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextyn(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
   	obj.BPCBGIsolatedStore = new Ext.data.Store({
      	proxy: obj.BPCBGIsolatedStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'Id'   
      		}, 
      		[	
      			{name: 'Id', mapping: 'Id'}
      			,{ name: 'selecttext', convert: seltextyn}
      			//,{name: 'Desc', mapping: 'Desc'}
    
      		])
      	});	
      		
   obj.BPCBGIsolated =new Ext.form.ComboBox({
      	id : 'obj.BPCBGIsolated'
      	,store : obj.BPCBGIsolatedStore
      	,minChars : 0
      	//,displayField : 'Desc'
      	,displayField : 'selecttext'
      	,fieldLabel : '是否隔离'
      	,valueField : 'Id'
      	,editable : false
      	,triggerAction : 'all'
      	,labelSeparator: ''
      	,anchor : '95%'
              });	
    obj.BPCBGIsolatedStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCBedGroup';
      	param.QueryName = 'FindBPCBGIsolated';
      	param.ArgCnt = 0;
      	});
      	obj.BPCBGIsolatedStore.load();
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth : 75
		,layout : 'form'
		,items:[
		obj.BPCBGCode
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth : 75
		,layout : 'form'
		,items:[
		obj.BPCBGDesc
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .01
		,layout : 'form'
		,items:[
		obj.BPCBGRowId
		]
	});
		obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth : 60
		,layout : 'form'
		,items:[
		obj.BPCBGIsolated
		]
	});
	obj.Panel3= new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .29
		,labelWidth : 30
		,layout : 'form'
		,items:[
		obj.ctlocdesc
		//obj.BPCBGWordDr
		]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:60
		,region : 'north'
		,layout : 'column'
		,columnWidth : .7
		,items:[
		  obj.Panel1
	     ,obj.Panel2
	     ,obj.Panel3
	     ,obj.Panel4
	     ,obj.Panel5
		]
	});
		obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查询'
	});
		obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,width:86
		,iconCls : 'icon-add'
		,text : '增加'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,width:86
		,iconCls : 'icon-updateSmall'
		,text : '更新'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	
	obj.schSubChildPl1 = new Ext.Panel({
		id : 'schSubChildPl1'
		,buttonAlign : 'left'
		,columnWidth : .01
		,layout : 'column'
		,items:[
		]
		,buttons:[
			//obj.btnfind
		]
	});	
	obj.schSubChildPl2 = new Ext.Panel({
		id : 'schSubChildPl2'
		,buttonAlign : 'left'
		,columnWidth : .3
		,layout : 'column'
		,items:[
		]
		,items:[
			obj.btnUpd
		]
	});
	obj.schSubChildPl3 = new Ext.Panel({
		id : 'schSubChildPl3'
		,buttonAlign : 'left'
		,columnWidth : .3
		,layout : 'column'
		,items:[
		]
		,items:[
			obj.btnDel
		]
	});
		obj.schSubChildPl4 = new Ext.Panel({
		id : 'schSubChildPl4'
		,buttonAlign : 'left'
		,columnWidth : .3
		,layout : 'column'
		,items:[
		]
		,items:[
			obj.btnAdd
				]
	});
	
	obj.chkFormPanel = new Ext.form.FormPanel({
		id : 'chkFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 50
		,region : 'center'
		,layout : 'column'
		,columnWidth : .3
		,items:[
			obj.schSubChildPl4
			,obj.schSubChildPl2
			,obj.schSubChildPl3
			,obj.schSubChildPl1
			]	
	});
	
    obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '床位组维护'
		,region : 'north'
		,layout : 'column'
		,frame : true
		//,collapsible:true
		,animate:true
		,iconCls : 'icon-manage'
		,items:[
		     obj.fPanel,
		     obj.chkFormPanel
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
			idProperty: 'tRowId'   
		}, 
		[	
			,{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tBPCBGCode', mapping: 'tBPCBGCode'}
			,{name: 'tBPCBGDesc', mapping: 'tBPCBGDesc'}
			,{name: 'tBPCBGWard', mapping: 'tBPCBGWard'}
			,{name: 'tBPCBGWardDr', mapping: 'tBPCBGWardDr'}
			,{name: 'tBPCBGIsolatedDr', mapping: 'tBPCBGIsolatedDr'}
			,{name: 'tBPCBGIsolated', mapping: 'tBPCBGIsolated'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '床位组代码', width: 150, dataIndex: 'tBPCBGCode', sortable: true}
			,{header: '床位组名称', width: 200, dataIndex: 'tBPCBGDesc', sortable: true}
			//,{header: '病区', width: 200, dataIndex: 'tBPCBGWard', sortable: true}
			,{header: '科室', width: 200, dataIndex: 'tBPCBGWard', sortable: true}
			,{header: '是否隔离', width: 100, dataIndex: 'tBPCBGIsolated', sortable: true}
			,{header: '系统号', width: 100, dataIndex: 'tRowId', sortable: true}	
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
			forceFit: false
			//Return CSS class to apply to rows depending upon data values
			
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.retGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,tbar:obj.tb
		,items:[
		obj.retGridPanel
		]
	});
		obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCBPCBedGroup';
		param.QueryName = 'FindBPCBedGroup';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load();
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			 obj.floorPanel
			 ,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnDel.on("click", obj.btnDel_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnUpd.on("click", obj.btnUpd_click, obj);
  	obj.LoadEvent(arguments);
	return obj;
}


