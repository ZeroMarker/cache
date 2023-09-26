//20170307+dyl
function InitViewScreen(){
	var obj = new Object();
	obj.bpcAMCode = new Ext.form.TextField({
		id : 'bpcAMCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '90%'
	});  

	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelWidth : 35
		,columnWidth : .13
		,layout : 'form'
		,items:[
			obj.bpcAMCode
			,obj.Rowid
		]
	});
	obj.bpcAMDesc = new Ext.form.TextField({
		id : 'bpcAMDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '90%'
	}); 
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,labelWidth : 35
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
			obj.bpcAMDesc
		]
	});

	//---------------------是否选择药品
	var data=[
		['Y','是'],
		['N','否']
	]
	obj.IfSelectDrugStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.IfSelectDrugStore = new Ext.data.Store({
		proxy: obj.IfSelectDrugStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.IfSelectDrugStore.load({});
	obj.IfSelectDrug = new Ext.form.ComboBox({
		id : 'IfSelectDrug'
		,minChars : 1
		,fieldLabel : '是否选择药品'
		,labelSeparator: ''
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.IfSelectDrugStore
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .13
		,labelWidth : 85
		,layout : 'form'
		,items:[
			obj.IfSelectDrug
		]
	});	
	//---------------------是否使用
	var data=[
		['Y','是'],
		['N','否']
	]
	obj.ActiveStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.ActiveStore = new Ext.data.Store({
		proxy: obj.ActiveStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.ActiveStore.load({});
	obj.Active = new Ext.form.ComboBox({
		id : 'Active'
		,minChars : 1
		,fieldLabel : '是否使用'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.ActiveStore
		,labelSeparator: ''
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
 
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .12
		,layout : 'form'
		,items:[
			obj.Active
		]
	});
	//---------------------血透、腹透
	var data=[
		['H','血透'],
		['P','腹透']
	]
	obj.SubTypeStoreProxy = new Ext.data.MemoryProxy(data),
	
	obj.SubTypeStore = new Ext.data.Store({
		proxy: obj.SubTypeStoreProxy,
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.SubTypeStore.load({});
	obj.SubType = new Ext.form.ComboBox({
		id : 'SubType'
		,minChars : 1
		,fieldLabel : '所属应用'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.SubTypeStore
		,labelSeparator: ''
		,displayField : 'desc'
		,valueField : 'code'
		,anchor :'90%'
	});
 
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,labelWidth : 60
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.SubType
		]
	});	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-Insert'
		,width:70
		,style:'margin-left:10px'
		,text : '添加'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,style:'margin-left:10px'
		,width:70
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,style:'margin-left:10px'
		,iconCls : 'icon-edit'
		,width:70
		,text : '更新'
	});
	
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.addbutton
       ]
	});
obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.updatebutton
       ]
	});
	obj.keypanel3 = new Ext.Panel({
		id : 'keypanel3'
		,buttonAlign : 'center'
		,columnWidth:.1
		,layout : 'form'
        ,items:[
            obj.deletebutton
       ]
	});

	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,labelWidth : 30
		,height:65
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
			,obj.keypanel
			,obj.keypanel2
			,obj.keypanel3
		]
	});

	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 70
		,title : '抗凝码表维护'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tBPCAMRowId'
		}, 
	    [
			,{name: 'tBPCAMRowId', mapping : 'tBPCAMRowId'}
			,{name: 'tBPCAMCode', mapping: 'tBPCAMCode'}
			,{name: 'tBPCAMDesc', mapping: 'tBPCAMDesc'}
			,{name: 'ifSelectDrug', mapping: 'ifSelectDrug'}
			,{name: 'ifSelectDrugDesc', mapping: 'ifSelectDrugDesc'}
			,{name: 'ifActive', mapping: 'ifActive'}
			,{name: 'ifActiveDesc', mapping: 'ifActiveDesc'}
			,{name: 'tBPCAMSubType', mapping: 'tBPCAMSubType'}
			,{name: 'tBPCAMSubTypeDesc', mapping: 'tBPCAMSubTypeDesc'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '系统号', width: 100, dataIndex: 'tBPCAMRowId', sortable: true}
		,{header: '代码', width: 100, dataIndex: 'tBPCAMCode', sortable: true}
		,{header: '描述', width: 300, dataIndex: 'tBPCAMDesc', sortable: true}
		,{header: '是否选择药品', width: 100, dataIndex: 'ifSelectDrugDesc', sortable: true}
		,{header: '是否使用', width: 100, dataIndex: 'ifActiveDesc', sortable: true}
		,{header: '所属应用', width: 100, dataIndex: 'tBPCAMSubTypeDesc', sortable: true}
		]
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

		
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCAnticoagulantMode';
		param.QueryName = 'FindAntMode';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}