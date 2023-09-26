//by+2017-03-03
function InitViewScreen()
{
    var obj = new Object();
	
	//------------手术器材敷料清点维护-------------
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '清点类型代码'
		,labelSeparator: ''
		,width: 200
		,anchor : '100%'
	});	
	obj.Desc = new Ext.form.TextField({
		id : 'Desc'
		,fieldLabel : '清点类型名称'
		,labelSeparator: ''
		,anchor : '100%'
	});
	obj.TypeId = new Ext.form.TextField({
		id : 'TypeId'
		,height:1
		,hidden : true
	});
	obj.Panel = new Ext.Panel({
		id : 'Panel'
		,buttonAlign : 'center'
		//,columnWidth : .30
		,layout : 'form'
		,items:[
			obj.Code
			,obj.Desc
			,obj.TypeId
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:100
		,width: 330
		,height:10
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel
		]
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,text : '增加'
		,iconCls : 'icon-add'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,text : '修改'
		,iconCls : 'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,style:'margin-left:9px;'
		,layout : 'form'
		,items:[
		    obj.addbutton
		]

	});
	
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'	
		,layout : 'form'
		,style:'margin-left:15px;'
		,items:[
		    obj.updatebutton
		]

	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,layout : 'form'
		,style:'margin-left:15px;'
		,items:[
		    obj.deletebutton
		    ]
	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 100
		,region : 'north'
		,layout : 'border'
		,frame : true
		//,collapsible:true
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
			idProperty: 'TypeId'
		}, 
	    [
			{name: 'TypeCode', mapping : 'TypeCode'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'TypeId', mapping: 'TypeId'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '类型代码',width: 80,dataIndex: 'TypeCode',sortable: true}
			,{header: '类型名称',width: 80,dataIndex: 'TypeDesc',sortable: true}
			,{header: '类型ID',width: 80,dataIndex: 'TypeId',sortable: true}
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
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'FindOPCountType';
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
		//,region : 'center'
		,height: 368
		,width: 330
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	obj.DHCANCOPCountType = new Ext.Panel({
	    id : 'DHCANCOPCountType'
		,buttonAlign : 'center'
		,layout :'form'
		,title : '手术器材敷料清点维护'
		,iconCls : 'icon-manage'
		,labelSeparator: ''
		//,region : 'center'
		,width:330
		,frame : true
		,animate : true
		,collapasible : true
		,items : [
		    obj.functionPanel
			,obj.resultPanel
		]
	});
	//---------------------中间----------
	obj.allTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.allTypeStore = new Ext.data.Store({
		proxy: obj.allTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCOPC_RowId'
		}, 
		[
		    {name: 'ANCOPC_RowId', mapping: 'ANCOPC_RowId'},
			{name: 'ANCOPC_Desc', mapping: 'ANCOPC_Desc'}
		])
	});	
	
	obj.allTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'GetCountItem';
		param.Arg1="";
		param.ArgCnt = 1;
	});
	obj.allTypeStore.load({});
	
	obj.allTypeGrid = new Ext.grid.GridPanel({
	    id : 'allTypeGrid'
		,store: obj.allTypeStore
		,height:370
    	,viewConfig:{forceFit:true}
    	,stripeRows:true
		,cm:new Ext.grid.ColumnModel([
		{
        	header: '器材ID',
        	dataIndex: 'ANCOPC_RowId',
        	width:20,
			hidden: true
    	},
		{
        	header: '器材名称',
        	dataIndex: 'ANCOPC_Desc'
    	}])
	}); 	
	obj.allTypePanel = new Ext.Panel({
	    id : 'allTypePanel'
		,title : '全部清点项目'
		,iconCls : 'icon-normalinfo'
		,labelSeparator: ''
		,columnWidth : .3
		,animate:true
		,height:410
    	,width:110
		,layout: 'column'
		,items:[
		    obj.allTypeGrid
		]
	});
	
	obj.addTypeButton = new Ext.Button({
		id : 'addTypeButton'
		,width:86
		,text : '添加>>'
		,iconCls : 'icon-add'
	});
	obj.delTypeButton = new Ext.Button({
		id : 'delTypeButton'
		,width:86
		,text : '删除<<'
		,iconCls : 'icon-delete'
	});	
	obj.nothingPanel = new Ext.Panel({
		id : 'nothingPanel'
		,height:50
		,layout : 'column'
		,items:[
		]
	});
	obj.nothingPanelup = new Ext.Panel({
		id : 'nothingPanelup'
		,height:150
		,layout : 'column'
		,items:[
		]
	});
	obj.nothingPaneldown = new Ext.Panel({
		id : 'nothingPaneldown'
		,height:130
		,layout : 'column'
		,items:[
		]
	});
	obj.upPanel2 = new Ext.Panel({
	    id : 'upPanel2'
		//,buttonAlign : 'center'
		,columnWidth : .22
		,width:80
		,frame : true
		,height:820
		,layout : 'form'
		,items:[
		    obj.nothingPanelup
		    ,obj.addTypeButton
		    ,obj.nothingPanel
		    ,obj.delTypeButton
		    ,obj.nothingPaneldown
		]
	});
	//alert(52);
	obj.selectTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.selectTypeStore = new Ext.data.Store({
		proxy: obj.selectTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DefItemCode'
		}, 
		[
		     {name: 'DefItemCode', mapping: 'DefItemCode'},
			 {name: 'DefItemDesc', mapping: 'DefItemDesc'}
		])
	});	
	//alert(53);
	obj.selectTypeGrid = new Ext.grid.GridPanel({
		id : 'selectTypeGrid'
 		,store: obj.selectTypeStore
    	,multiSelect: true
    	,height:381
    	,viewConfig:{forceFit:true}
    	,cm:new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
        	header: 'Code',
        	dataIndex: 'DefItemCode',
			hidden : true
    	},
		{
        	header: 'Desc',
        	dataIndex: 'DefItemDesc',width:100
    	}])
	}); 
	
	obj.selectTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPCount';
		//param.QueryName = 'FindTypeSelDefVal';
		param.QueryName = 'FindTypeSelect';
		param.Arg1 = obj.TypeId.getValue();
		param.ArgCnt = 1;
	});
	obj.selectTypeStore.load({});
	obj.selectTypePanel = new Ext.Panel({
	    id : 'selectTypePanel'
		,title : '所选清点项'
		,layout : 'column'
		,iconCls : 'icon-normalinfo'
		,columnWidth : .25
		//,frame : true
		,animate:true
    	,width:100
		,items:[
			obj.selectTypeGrid
		]
	});
	
	obj.upButton = new Ext.Button({id : 'upButton',width:86,text : '上',iconCls : 'icon-up'});
	obj.downButton = new Ext.Button({id : 'downButton',width:86,text : '下',iconCls : 'icon-down'});
	obj.nopanel1 = new Ext.Panel({id : 'nopanel1',height:150,layout : 'column',items:[]});
	obj.nopanel2= new Ext.Panel({id : 'nopanel2',height:130,layout : 'column',items:[]});
	obj.nothingPanel1 = new Ext.Panel({id : 'nothingPanel1',height:50,layout : 'form',items:[]});
	
	obj.upPanel4 = new Ext.Panel({
	    id : 'upPanel4'
		,buttonAlign : 'center'
		,columnWidth : .22
		,width:100
		,height:820
		,frame : true
		,layout : 'form'
		,items:[
			obj.nopanel1
		    ,obj.upButton
		    ,obj.nothingPanel1
		    ,obj.downButton
		    ,obj.nopanel2
		]
	});
	obj.upPanel = new Ext.Panel({
		id : 'upPanel'
		,buttonAlign : 'center'
		//,region : 'center'
		,layout : 'column'
		,frame : true
		,height:430
		,collapsible:true
		,animate:true
		,items:[
			obj.allTypePanel
			,obj.upPanel2
			,obj.selectTypePanel
			,obj.upPanel4
		]
	});
	
	obj.SaveButton = new Ext.Button({
		id : 'SaveButton'
		,width:86
		,text : '保存'
		,style:'margin-left:200px;'
		,iconCls : 'icon-save'
	});
	
	obj.downPanel = new Ext.Panel({
		id : 'downPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,height:36
		,style:'margin-top:3px;'
		,frame : true
		,layout : 'column'
		//,region : 'south'
		,items:[
		    obj.SaveButton
		]

	});
	
	obj.DHCANCOPCountTypeDetail = new Ext.Panel({
	    id : 'DHCANCOPCountTypeDetail'
		,buttonAlign : 'center'
		,layout : 'form'
		,title : '清点项目选择'
		,iconCls : 'icon-normalinfo'
		,region : 'center'
		,width : 500
		,frame : true
		,animate : true
		,collapasible : true
		,items : [
		    obj.upPanel
			,obj.downPanel
		]
	});
	//-------------------设置清点器材默认值---------
	
	obj.dataretGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.dataretGridPanelStore = new Ext.data.Store({
		proxy: obj.dataretGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SeqNo'
		}, 
	    [
			{name: 'SeqNo', mapping : 'SeqNo'}
			,{name: 'OPCountDesc', mapping: 'OPCountDesc'}
			,{name: 'PreOperNum', mapping: 'OriginalNum'}
			,{name: 'OPCountId', mapping: 'OPCountId'}
		])
	});
	var datacm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '顺序号',width: 50,dataIndex: 'SeqNo',sortable: true}
			,{header: '器材名称',width: 120,dataIndex: 'OPCountDesc',sortable: true}
			,{
				header: '术前清点数'
				,width: 80
				,dataIndex: 'PreOperNum'
				,sortable: true
				,editor:new Ext.form.NumberField({    
                   maxValue:10000,    
                   minValue:0   
				})
			}
			,{header: 'OPCountId',width: 20,dataIndex: 'OPCountId',sortable: true,hidden:true}
		]
	});
	
	 obj.dataretGridPanel = new Ext.grid.EditorGridPanel({
		id : 'dataretGridPanel'
		,store : obj.dataretGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,width : 200
		,height:550
		,region : 'center'
		,buttonAlign : 'center'
		,cm:datacm
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.dataretGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.dataretGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'FindTypeSelDefVal';
		param.Arg1=obj.TypeId.getValue();
		param.ArgCnt = 1;
	});
	obj.dataretGridPanelStore.load({});
	
	obj.DHCANCOPCountTypeDefault = new Ext.Panel({
	    id : 'DHCANCOPCountTypeDefault'
		//,buttonAlign : 'center'
		,layout :'border'
		//,region : 'center'
		,title : '设置清点器材默认值'
		,width:310
		,iconCls : 'icon-normalinfo'
		,height: 542
		,frame : true
		,animate : true
		,collapasible : true
		,items : [
		    obj.dataretGridPanel
		]
	});
	
	obj.ViewScreen = new Ext.Viewport({
	    id : 'ViewScreen'
		,layout : 'column'
		//,bodyStyle : 'overflow-x:scroll; overflow-y:scroll'
		,items : [
		    obj.DHCANCOPCountType
			,obj.DHCANCOPCountTypeDetail
			,obj.DHCANCOPCountTypeDefault 
			//,obj.dataretGridPanel
		]
	});
	
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	
	obj.addTypeButton.on("click", obj.addTypeButton_click, obj);
	obj.delTypeButton.on("click", obj.delTypeButton_click, obj);
	obj.upButton.on("click", obj.upButton_click, obj);
	obj.downButton.on("click", obj.downButton_click, obj);
	obj.SaveButton.on("click", obj.SaveButton_click, obj);
	
	obj.dataretGridPanel.on("keydown", obj.dataretGridPanel_keydown, obj);
	obj.dataretGridPanel.on("beforeedit",obj.dataretGridPanel_beforeedit,obj);
	obj.dataretGridPanel.on("validateedit",obj.dataretGridPanel_validateedit,obj);
	obj.dataretGridPanel.on("afteredit",obj.dataretGridPanel_afteredit,obj);
	
	obj.dataretGridPanel.on("rowclick", obj.dataretGridPanel_rowclick, obj);
	
	obj.LoadEvent(arguments);
	return obj;
}