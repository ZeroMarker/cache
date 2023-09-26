//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	obj.BPCBPMCode = new Ext.form.TextField({
		id : 'BPCBPMCode'
		,fieldLabel : '透析方式'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.BPCBPMDesc = new Ext.form.TextField({
		id : 'BPCBPMDesc'
		,fieldLabel : '透析方式描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	var data=[
		['Y','是'],
		['N','否']
	]
	obj.BPCBPMIsSpecialStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.BPCBPMIsSpecialStore = new Ext.data.Store({
		proxy: obj.BPCBPMIsSpecialStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.BPCBPMIsSpecialStore.load({});
	obj.BPCBPMIsSpecial = new Ext.form.ComboBox({
		id : 'BPCBPMIsSpecial'
		,minChars : 1
		,fieldLabel : '是否特殊'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.BPCBPMIsSpecialStore
		,displayField : 'desc'
		,valueField : 'code'
		,labelSeparator: ''
		,anchor :'95%'
	});
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });
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
	 	
   	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCBPMCode
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .35
		,labelWidth : 90
		,layout : 'form'
		,items:[
			obj.BPCBPMDesc
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCBPMIsSpecial
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.ctlocdesc
		]
	});
    obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'north'
		,layout : 'column'
		,columnWidth : .70
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Rowid
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,style:'margin-left:15px'
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.addbutton
		]
	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'
		,style:'margin-left:15px'		
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]
	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,style:'margin-left:15px'
		,columnWidth : .25
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,columnWidth : .30
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '血液净化模式'
		,region : 'north'
		,layout : 'column'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
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
			idProperty: 'tBPCBPMRowId'
		}, 
	    [
			{name: 'tBPCBPMDesc', mapping : 'tBPCBPMDesc'}
			,{name: 'tBPCBPMCode', mapping: 'tBPCBPMCode'}
			,{name: 'tBPCBPMIsSpecial', mapping: 'tBPCBPMIsSpecial'}
			,{name: 'tBPCBPMIsSpecialDesc', mapping: 'tBPCBPMIsSpecialDesc'}
			,{name: 'tBPCBPMRowId', mapping: 'tBPCBPMRowId'}
			,{name: 'tBPCBPMDeptDr', mapping: 'tBPCBPMDeptDr'}
			,{name: 'tBPCBPMDept', mapping: 'tBPCBPMDept'}


		])
	});
    var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '透析方式',width: 200,dataIndex: 'tBPCBPMCode',sortable: true}
           ,{header: '透析方式描述', width: 280, dataIndex: 'tBPCBPMDesc', sortable: true}
		   ,{header: '是否特殊', width: 100, dataIndex: 'tBPCBPMIsSpecialDesc', sortable: true}
		   ,{header: '系统号', width: 100, dataIndex: 'tBPCBPMRowId', sortable: true}
		   ,{header: '科室', width: 100, dataIndex: 'tBPCBPMDept', sortable: true}
		]
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
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

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCBloodPurificationMode';
		param.QueryName = 'FindDHCBPCBPMode';
		param.ArgCnt = 0;
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

    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
		]
	});
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}