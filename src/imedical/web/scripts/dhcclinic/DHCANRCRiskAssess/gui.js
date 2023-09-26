function InitViewScreen()
{

var obj = new Object();


    obj.OperDiffcultyStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.OperDiffcultyStore=new Ext.data.Store({
		proxy:obj.OperDiffcultyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'operCategId'
		}, 
		[
			{name: 'operCategId', mapping: 'operCategId'},
			{name: 'operCategLDesc', mapping: 'operCategLDesc'}
		])
	});	



obj.OperDiffculty = new Ext.form.ComboBox({
		id : 'OperDiffculty'
		,store : obj.OperDiffcultyStore
		,minChars : 1
		,displayField : 'operCategLDesc'
		,fieldLabel : '手术难度分类'
		,valueField : 'operCategId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.OperDiffculty
		]
	});
	
	
	
	
    obj.ASAStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ASAStore=new Ext.data.Store({
		proxy:obj.ASAStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'ASAId', mapping: 'Id'},
			{name: 'ASADesc', mapping: 'Description'}
		])
	});	

	
	
obj.ASA = new Ext.form.ComboBox({
		id : 'ASA'
		,store : obj.ASAStore
		,minChars : 1
		,displayField : 'ASADesc'
		,fieldLabel : 'ASA分级'
		,valueField : 'ASAId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ASA
		]
	});
	
	
	
	
	obj.AnrcrcStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.AnrcrcStore=new Ext.data.Store({
		proxy:obj.AnrcrcStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrcrcId'
		}, 
		[
			{name: 'anrcrcId', mapping: 'anrcrcId'},
			{name: 'RiskClassDesc', mapping: 'tDesc'}
		])
	});	

	obj.Anrcrc = new Ext.form.ComboBox({
		id : 'Anrcrc'
		,store : obj.AnrcrcStore
		,minChars : 1
		,displayField : 'RiskClassDesc'
		,fieldLabel : '手术风险级别'
		,valueField : 'anrcrcId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Anrcrc
		]
	});
	obj.CtlocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CtlocStore = new Ext.data.Store({
		proxy: obj.CtlocStoreProxy,
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
	obj.Ctloc = new Ext.form.ComboBox({
		id : 'Ctloc'
		,store : obj.CtlocStore
		,minChars : 1
		,displayField : 'ctloc'
		,fieldLabel : '科室'
		,valueField : 'ctlocid'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.CtlocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
			param.QueryName = 'ctloclookup';
			param.Arg1 = obj.Ctloc.getRawValue();
			param.ArgCnt = 1;
	});	
	obj.CtlocStore.load({});	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Ctloc
		]
	});
	obj.RowId=new Ext.form.TextField({
		id : 'RowId'
		,hidden:true
	});
obj.formPanel = new Ext.form.FormPanel({
		id : 'formPanel'
		,height:80
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,layout : 'column'
		,frame:true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.RowId
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:60
		,text : '添加'
	});
	obj.addPanel = new Ext.Panel({
		id : 'addPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.addbutton
		]
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '修改'
	});
	obj.updatePanel = new Ext.Panel({
		id : 'updatePanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.updatebutton
		]
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : '删除'
	});
	obj.deletePanel = new Ext.Panel({
		id : 'deletePanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.deletebutton
		]
	});
obj.buttonPanel=new Ext.form.FormPanel({
		id:'buttonPanel'
		,buttonAlign:'center'
		,region:'center'
		,lableWidth:80
		,layout:'column'
		,buttons:[
	        //obj.selectPanel,
			obj.addPanel,
		    obj.updatePanel,
		    obj.deletePanel
		
		]});

obj.ParentPanel=new Ext.Panel({
		id:'ParentPanel'
		,height:180
		,title:'风险分级维护'
		,region:'north'
		,layout:'border'
		,frame : true
		//,collapsible:true //折叠选项框
		,animate:true
		,items:[
		    obj.formPanel
		    ,obj.buttonPanel
		]
		});

		
	obj.storeProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
   	obj.store=new Ext.data.Store({
	   	proxy: obj.storeProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
	    [
			{name: 'RowId', mapping : 'RowId'}
			,{name: 'OperDiffculty', mapping: 'OperDiffculty'}
			,{name: 'OperDiffcultyDr', mapping: 'OperDiffcultyDr'}
			,{name: 'ASA', mapping: 'ASA'}
			,{name: 'ASADr', mapping: 'ASADr'}
			,{name: 'Anrcrc', mapping: 'Anrcrc'}
			,{name: 'AnrcrcDr', mapping: 'AnrcrcDr'}
			,{name: 'Ctloc', mapping: 'Ctloc'}
			,{name: 'CtlocDr', mapping: 'CtlocDr'}
			
			
		])
		});
		
	obj.storeProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCRiskAssess';
		param.QueryName = 'FindANRCRiskAssess';
		param.ArgCnt = 0;
	});
	obj.store.load({});
	var cm=new Ext.grid.ColumnModel({
	   	defaultSortable:true
	   	,columns:[
	   	new Ext.grid.RowNumberer()
	   	,{
		   	header:'RowID'
		   	,width:100
		   	,dataIndex:'RowId'
		   	,sortable:true
		   	}
	   	,{
		   	header:'手术难度分类'
		   	,width:120
		   	,dataIndex:'OperDiffculty'
		   	,sortable:true
		   	}
		,{
		   	header:'手术难度分类Dr'
		   	,width:120
		   	,dataIndex:'OperDiffcultyDr'
		   	,sortable:true
		   	}
	   	,{
		   	header:'ASA分级'
		   	,width:120
		   	,dataIndex:'ASA'
		   	,sortable:true
		   	}
		,{
		   	header:'ASA分级Dr'
		   	,width:120
		   	,dataIndex:'ASADr'
		   	,sortable:true
		   	}
	   	,{
		   	header:'手术风险级别'
		   	,width:120
		   	,dataIndex:'Anrcrc'
		   	,sortable:true
		   	}
		,{
		   	header:'手术风险级别Dr'
		   	,width:120
		   	,dataIndex:'AnrcrcDr'
		   	,sortable:true
		   	}
		,{
		   	header:'科室'
		   	,width:150
		   	,dataIndex:'Ctloc'
		   	,sortable:true
		   	}
		,{
		   	header:'科室Dr'
		   	,width:120
		   	,dataIndex:'CtlocDr'
		   	,sortable:true
		   	}		
		]
		   	});				
obj.retGridPanel=new Ext.grid.GridPanel({
		id:'retGridPanel'
		,store:obj.store
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar:new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.store,
		    displayMsg: '显示记录： {0} - {1} 共有{2}条记录',
			displayInfo: true,
		    emptyMsg: '没有记录'
			})
		});
obj.ResultPanel=new Ext.Panel({
		id:'ResultPanel'
		,buttonAlign : 'center'
		,title:'风险分级查询结果'
		,region:'center'
		,layout:'border'
		,frame : true
		,items:[
		    obj.retGridPanel
		]
		});


	obj.ASAStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCRiskAssess';
		param.QueryName = 'FindASAClass';
		param.ArgCnt=0;
	});
	obj.ASAStore.load({});  

	obj.AnrcrcStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCRiskCLass';
		param.QueryName = 'FindRiskClass';
		param.Arg1=''; //obj.Anrcrc.getRawValue();
		param.Arg2='';
		param.Arg3='';
		param.ArgCnt=3;	});
	obj.AnrcrcStore.load({});
	
	
	obj.OperDiffcultyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOrc';
		param.QueryName = 'FindORCOperationCategory';
		param.ArgCnt=0;
	});
	obj.OperDiffcultyStore.load({});
	
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,layout:'border'
		,items:[
		    obj.ParentPanel
		    ,obj.ResultPanel
		]});

	InitViewScreenEvent(obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);	
	obj.LoadEvent(arguments);
	return obj;
		
}