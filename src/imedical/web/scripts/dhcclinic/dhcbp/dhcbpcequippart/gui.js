//by+2017-03-07
function InitViewScreen(){
	var obj = new Object();
	
	obj.bpcEPCode = new Ext.form.TextField({
		id : 'bpcEPCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
	 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth:45
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEPCode
			,obj.RowId
		]
	});
	
	obj.bpcEPDesc = new Ext.form.TextField({
		id : 'bpcEPDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelAlign : 'right'
		,labelWidth:45
		,layout : 'form'
		,items:[
			obj.bpcEPDesc
		]
	});

	
	obj.bpcEPModelDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
    function seltext(v, record) { 
         return record.tID+" || "+record.tBPCEMDesc; 
    } 
    
	obj.bpcEPModelDrstore = new Ext.data.Store({
		proxy: obj.bpcEPModelDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tID'
		}, 
		[
			{name: 'tID', mapping: 'tID'}
			,{ name: 'selecttext', convert: seltext}
			//,{name: 'tBPCEMDesc', mapping: 'tBPCEMDesc'}
		])
	});
	obj.bpcEPModelDr = new Ext.form.ComboBox({
		id : 'bpcEPModelDr'
		,store:obj.bpcEPModelDrstore
		,minChars:1
		//,displayField:'tBPCEMDesc'
		,displayField:'selecttext'
		,fieldLabel : '设备型号'
		,valueField : 'tID'
		,labelSeparator: ''
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.bpcEPModelDr
		]
	});


	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '添加'
		,iconCls : 'icon-add'
		,style:'margin-left :20px;'
		,width :86
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		,style:'margin-left :20px;'
		,text : '更新'
		,width :86
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
		,width :86
		,iconCls : 'icon-delete'
		,style:'margin-left :20px;'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,iconCls : 'icon-find'
		,style:'margin-left :20px;'
		,width :86
		,text : '查找'
	});
obj.btn1 = new Ext.Panel({
		id : 'btn1'
		,buttonAlign : 'center'
		,labelWidth:60
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.findbutton
		]
	});
	obj.btn2 = new Ext.Panel({
		id : 'btn2'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.addbutton
		]
	});
	obj.btn3 = new Ext.Panel({
		id : 'btn3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.updatebutton
		]
	});
	obj.btn4 = new Ext.Panel({
		id : 'btn4'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.deletebutton
		]
	});
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		//,columnWidth : .72
		,layout : 'column'
        ,items:[
            obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.btn1
			,obj.btn2
            ,obj.btn3
            ,obj.btn4
            
       ]
	});
  
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 65
		,title : '设备配件维护'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		//,collapsible:true
		,animate:true
		,items:[
		    obj.keypanel
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
			idProperty: 'tBPCEPRowId'
		}, 
	    [
			{name: 'tBPCEPRowId', mapping: 'tBPCEPRowId'}
			,{name: 'tBPCEPCode', mapping: 'tBPCEPCode'}
			,{name: 'tBPCEPDesc', mapping: 'tBPCEPDesc'}
			,{name: 'tBPCEPBPCEquipModelDr', mapping: 'tBPCEPBPCEquipModelDr'}
			,{name: 'tBPCEPBPCEquipModel', mapping: 'tBPCEPBPCEquipModel'}
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
		//,{header: 'tID', width: 50, dataIndex: 'tID', sortable: true}
		,{header: '代码', width: 350, dataIndex: 'tBPCEPCode', sortable: true}
		,{header: '描述', width: 350, dataIndex: 'tBPCEPDesc', sortable: true}
		,{header: '设备', width: 350, dataIndex: 'tBPCEPBPCEquipModel', sortable: true}
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
	

	obj.bpcEPModelDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipModel';
		param.QueryName = 'FindEModel';
		param.ArgCnt = 0;
	});
	obj.bpcEPModelDrstore.load({});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCEquipPart';
		param.QueryName = 'FindEPart';
		param.Arg1=obj.bpcEPModelDr.getValue();
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}