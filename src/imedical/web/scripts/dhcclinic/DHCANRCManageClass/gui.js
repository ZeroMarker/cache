function InitViewScreen()
{
    var obj = new Object();
	
	obj.Code= new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Code
		]
	});
	
	obj.Desc= new Ext.form.TextField({
		id : 'Desc'
		,fieldLabel : '描述'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Desc
		]
	});
	
	obj.CtlocDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CtlocDrStore = new Ext.data.Store({
		proxy: obj.CtlocDrStoreProxy,
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
	obj.CtlocDr=new Ext.form.ComboBox({
		id : 'CtlocDr'
		,store : obj.CtlocDrStore
		,minChars : 1
		,displayField : 'ctloc'
		,fieldLabel : '申请科室'
		,valueField : 'ctlocid'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.CtlocDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.UDHCANOPSET';
			param.QueryName = 'ctloclookup';
			param.Arg1 = obj.CtlocDr.getRawValue();
			param.ArgCnt = 1;
	});	
	obj.CtlocDrStore.load({});	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		    obj.CtlocDr
		]
	});
	
	obj.AuditCarPrvTpStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    obj.AuditCarPrvTpStore=new Ext.data.Store({
		proxy:obj.AuditCarPrvTpStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTCPTRowId'
		}, 
		[
			{name: 'CTCPTRowId', mapping: 'CTCPTRowId'},
			{name: 'CTCPTDesc', mapping: 'CTCPTDesc'}
		])
	});
	obj.AuditCarPrvTp=new Ext.form.MultiSelect({
		id:'cmbAnrcmc',
	    fieldLabel:'审核人员',
		valueField:'CTCPTRowId',
	    displayField:'CTCPTDesc',
	    store:obj.AuditCarPrvTpStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,		
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200 //下拉框的最大高度
	});

	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .35
		,layout : 'form'
		,items:[
		    obj.AuditCarPrvTp
		]
	});	
	
	
	
	
	obj.RowId=new Ext.form.TextField({
		id : 'RowId'
		,hidden:true
	});
	obj.formPanel = new Ext.form.FormPanel({
		id : 'formPanel'
		,height:50
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
		,lableWidth:30
		,layout:'column'
		,buttons:[
	        //obj.selectPanel,
		    obj.updatePanel,
		    obj.addPanel,
		    obj.deletePanel
		
		]});
	obj.ParentPanel=new Ext.Panel({
		id:'ParentPanel'
		,height:150
		,title:'风险管理级别维护'
		,region:'north'
		,layout:'border'
		,frame : true
		,collapsible:true //折叠选项框
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
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CtlocDr', mapping: 'CtlocDr'}
			,{name: 'Ctloc', mapping: 'Ctloc'}
			,{name: 'AuditCarPrvTpDescStr', mapping: 'AuditCarPrvTpDescStr'}
			,{name: 'AuditCarPrvTpDrStr', mapping: 'AuditCarPrvTpDrStr'}
						
			
		])
		});
		
	obj.storeProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCManageClass';
		param.QueryName = 'FindANRCManageClass';
		param.ArgCnt = 0;
	});
	
	obj.store.load({});
	obj.AuditCarPrvTpStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPAppSet';
		param.QueryName = 'FindCarPrvTp';
		param.ArgCnt=0;
	});
	obj.AuditCarPrvTpStore.load({});
	
	
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
		   	header:'代码'
		   	,width:100
		   	,dataIndex:'Code'
		   	,sortable:true
		   	}
	   	,{
		   	header:'描述'
		   	,width:100
		   	,dataIndex:'Desc'
		   	,sortable:true
		   	}
	   	,{
		   	header:'CtlocDr'
		   	,width:100
		   	,dataIndex:'CtlocDr'
		   	,sortable:true
		   	}
		,{
		   	header:'指向科室'
		   	,width:250
		   	,dataIndex:'Ctloc'
		   	,sortable:true
		   	}
	   	,{
		   	header:'审核人员'
		   	,width:300
		   	,dataIndex:'AuditCarPrvTpDescStr'
		   	,sortable:true
		   	}
		,{
		   	header:'AuditCarPrvTpDrStr'
		   	,width:150
		   	,dataIndex:'AuditCarPrvTpDrStr'
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
		,title:'风险管理级别查询结果'
		,region:'center'
		,layout:'border'
		,frame : true
		,items:[
		    obj.retGridPanel
		]
		});
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,layout:'border'
		,items:[
		    obj.ParentPanel
		    ,obj.ResultPanel
		]});
	
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
	
}