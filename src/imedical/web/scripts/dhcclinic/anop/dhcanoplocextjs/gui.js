//20170302+dyl
function InitViewScreen()
{
	var obj = new Object();
	
	//////////////////所有科室
	obj.CTLocListViewStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.CTLocListViewStore = new Ext.data.Store({
		proxy: obj.CTLocListViewStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocid'
		}, 
		[
		     {name: 'ctlocid', mapping: 'ctlocid'}
			,{name: 'ctloc', mapping: 'ctloc'}
		])
	});	
	
	obj.CTLocListViewStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'ctloclookup';
		param.Arg1="";
		param.ArgCnt = 1;
	});
	obj.CTLocListViewStore.load({});
	
	obj.CTLocGrid = new Ext.grid.GridPanel({
		id : 'CTLocGrid'
 		,store: obj.CTLocListViewStore
    	,height:380
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: '科室ID',
        	dataIndex: 'ctlocid',
        	width:40
    	},{
        	header: '科室',
        	dataIndex: 'ctloc',width:160
    	}])
	}); 	
	
	obj.CTLocGridPanel = new Ext.Panel({
		id : 'CTLocGridPanel'
		,title : '科室'
		,iconCls : 'icon-normalinfo'
		,frame : true
		,animate:true
		,width:250
		,layout : 'form'
		,items:[
			obj.CTLocGrid
		]
	});
	///-------------------科室和麻醉科室之间的按钮
	obj.addAnlocButton = new Ext.Button({
		id : 'addAnlocButton'
		,iconCls : 'icon-insert'
		,text : '添加>>'
	});
	
	obj.addAnlocPanel = new Ext.Panel({
		id : 'addAnlocPanel'
		,buttonAlign : 'center'
		,height:200
		,width:80
		,layout: {type: 'vbox',pack: 'end',align: 'bottom'}
		,items:[
		    obj.addAnlocButton
		]

	});
	
	obj.delAnlocButton = new Ext.Button({
		id : 'delAnlocButton'
		,iconCls : 'icon-delete'
		,text : '删除<<'
	});
	
	obj.delAnlocPanel = new Ext.Panel({
		id : 'delAnlocPanel'
		,buttonAlign : 'center'
		,height:200
		,width:90
		,layout: {type: 'vbox',pack: 'start',align: 'top'}
		,items:[
		    obj.delAnlocButton
		]
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,height:20
		,layout : 'form'
		,items:[
		]
	});
	
	obj.AnLocButtonPanel = new Ext.Panel({
		id : 'AnLocButtonPanel'
		,buttonAlign : 'center'
		,width:100
		,layout : 'form'
		,frame : true
		,items:[
		    obj.addAnlocPanel
		    ,obj.Panel1
		    ,obj.delAnlocPanel
		]
	});
	
	/////////////////////////////麻醉科室
	obj.AnLocListViewStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.AnLocListViewStore = new Ext.data.Store({
		proxy: obj.AnLocListViewStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rw'
		}, 
		[
		     {name: 'rw', mapping: 'rw'}
			,{name: 'desc', mapping: 'desc'}
		])
	});	
	
	obj.AnLocListViewStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'GetAnLoc';
		param.ArgCnt = 0;
	});
	obj.AnLocListViewStore.load({});
	//2101509
	obj.AnLocGrid = new Ext.grid.GridPanel({
		id : 'AnLocListGrid'
 		,store: obj.AnLocListViewStore
    	,multiSelect: true
    	,height:380
    	//,viewConfig:{forceFit:true}
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'rw',
        	dataIndex: 'rw',
        	width:40
    	},{
        	header: 'desc',
        	dataIndex: 'desc',width:160
    	}])
	}); 	
	
	
	
	obj.AnLocGridPanel = new Ext.Panel({
		id : 'AnLocPanel'
		,title : '麻醉科室'
		,iconCls : 'icon-normalinfo'
		,frame : true
		,animate:true
    	,width:250
		,items:[
			obj.AnLocGrid
		]
	});
	
	///-------------麻醉科室和手术科室之间的按钮
	obj.addOplocButton = new Ext.Button({
		id : 'addOplocButton'
		,iconCls : 'icon-insert'
		,text : '添加>>'
	});
	
	obj.addOplocPanel = new Ext.Panel({
		id : 'addOplocPanel'
		,buttonAlign : 'center'
		,height:200
		,width:80
		,layout: {type: 'vbox',pack: 'end',align: 'bottom'}
		,items:[
		    obj.addOplocButton
		]

	});
	
	obj.delOplocButton = new Ext.Button({
		id : 'delOplocButton'
		,iconCls : 'icon-delete'
		,text : '删除<<'
	});
	
	obj.delOplocPanel = new Ext.Panel({
		id : 'delOplocPanel'
		,buttonAlign : 'center'
		,height:200
		,width:80
		,layout: {type: 'vbox',pack: 'start',align: 'top'}
		,items:[
		    obj.delOplocButton
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,height:20
		,layout : 'form'
		,items:[
		]
	});
	
	obj.OpLocButtonPanel = new Ext.Panel({
		id : 'OpLocButtonPanel'
		,buttonAlign : 'center'
		,width:100
		//,height:300
		,frame : true
		,layout : 'form'
		,items:[
		    obj.addOplocPanel
		    ,obj.Panel2
		    ,obj.delOplocPanel
		]
	});
	
	
	//////////////////手术科室
	obj.OpLocListViewStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.OpLocListViewStore = new Ext.data.Store({
		proxy: obj.OpLocListViewStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rw'
		}, 
		[
		     {name: 'rw', mapping: 'rw'}
			,{name: 'desc', mapping: 'desc'}
		])
	});	
	
	obj.OpLocListViewStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
		param.QueryName = 'GetOpLoc';
		param.ArgCnt = 0;
	});
	obj.OpLocListViewStore.load({});
	
	obj.OpLocGrid = new Ext.grid.GridPanel({
		id : 'OpLocListGrid'
 		,store: obj.OpLocListViewStore
    	,multiSelect: true
    	,height:380
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
    	,cm:new Ext.grid.ColumnModel([{
        	header: 'rw',
        	dataIndex: 'rw',width:40
    	},{
        	header: 'desc',
        	dataIndex: 'desc',width:160
    	}])
	}); 	
	
	
	
	obj.OpLocGridPanel = new Ext.Panel({
		id : 'OpLocPanel'
		,title : '手术科室'
		,iconCls : 'icon-normalinfo'
		,frame : true
		,animate:true
		,width:250
		,items:[
			obj.OpLocGrid
		]
	});
	
	
	
	////////////////////////科室预约设置
	obj.AnOpLocSetPanel = new Ext.Panel({
		id : 'AnOpLocSetPanel'
		,buttonAlign : 'center'
		,title : '科室预约设置'
		,iconCls : 'icon-manage'
		,region : 'center'
		,layout : 'column'
		,frame : true
		//,height:600
		//,collapsible:true
		,animate:true
		,items:[
			obj.CTLocGridPanel
			,obj.AnLocButtonPanel
			,obj.AnLocGridPanel
			,obj.OpLocButtonPanel
			,obj.OpLocGridPanel
		]
	});
	
	/////保存按钮
	obj.SaveSetButton = new Ext.Button({
		id : 'SaveSetButton'
		,width:86
		,style:'margin-left:430px;margin-top:10px;'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.SaveSetButtonPanel = new Ext.Panel({
		id : 'SaveSetButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,height:100
		,frame : true
		,layout : 'column'
		,region : 'south'
		,items:[
		    obj.SaveSetButton
		]

	});
	
	
	
	////ViewScreen
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpLocSetPanel 
			,obj.SaveSetButtonPanel
		]
	}); 
	
	InitViewScreenEvent(obj);
	
	obj.addAnlocButton.on("click", obj.addAnlocButton_click, obj);
	obj.delAnlocButton.on("click", obj.delAnlocButton_click, obj);
	obj.addOplocButton.on("click", obj.addOplocButton_click, obj);
	obj.delOplocButton.on("click", obj.delOplocButton_click, obj);
	obj.SaveSetButton.on("click", obj.SaveSetButton_click, obj);
	
	//obj.CTLocGrid.on("keydown", obj.CTLocGrid_keydown, obj);
	
	//obj.LoadEvent(arguments);    
   // return obj;
    
}