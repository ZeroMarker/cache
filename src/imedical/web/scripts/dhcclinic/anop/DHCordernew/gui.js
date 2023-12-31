function InitViewScreen()
{
	var obj = new Object();
	
	
	//-----------手术报表设置------------
	obj.code = new Ext.form.TextField({
		id : 'code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});	
	
	obj.name = new Ext.form.TextField({
		id : 'name'
		,fieldLabel : '名称'
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
			obj.code
			,obj.name	
		]
	});
	
		obj.orderTypeID = new Ext.form.TextField({
		id : 'orderTypeID'
		//,fieldLabel : '统计类型ID'
		,hidden:true
		,anchor : '95%'
	});	
	
	/*obj.statCode = new Ext.form.TextField({
		id : 'statCode'
		//,fieldLabel : '统计类型ID'
		,hidden:true
		,anchor : '95%'
	});	*/
	
	obj.orderTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.orderTypeStore = new Ext.data.Store({
		proxy: obj.orderTypeStoreProxy,
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
	obj.orderType = new Ext.form.ComboBox({
		id : 'orderType'
		,store:obj.orderTypeStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '统计类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.orderTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'LookUpStatistic';
		//param.Arg1='SchType';
		//param.Arg1=obj.orderType.getValue();
		param.ArgCnt = 0;
	});
	obj.orderTypeStore.load({});
	
	var data=[
              ['A','申请'],
              ['D','拒绝'],
              ['R','安排'],
              ['F','完成']
             ]
    obj.operstatStoreProxy=data;
    obj.operstatStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		 {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.operstat = new Ext.form.ComboBox({
		id : 'operstat'
		,minChars : 1
		,fieldLabel : '手术状态'
		,triggerAction : 'all'
		,store : obj.operstatStore
		,displayField : 'desc'
		,anchor : '95%'
		,valueField : 'code'
    });

    obj.Panel2 = new Ext.Panel({
		id : 'Paneltemp2'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[	
			obj.orderType
			,obj.operstat
			,obj.orderTypeID 
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:80
		,region:"north"
		,layout:"column"
		,items:[
			obj.Panel1
			,obj.Panel2
		]
	});
	
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:60
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '修改'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : '删除'
	});
	obj.addpanel = new Ext.Panel({
		id : 'addpanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addbutton
		]

	});
	obj.updatepanel = new Ext.Panel({
		id : 'updatepanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updatebutton
		]

	});
	obj.deletepanel = new Ext.Panel({
		id : 'deletepanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.deletebutton
		    ]

	});	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addpanel
			,obj.updatepanel
			,obj.deletepanel
		]
	});
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 200
		,region : 'north'
		,layout : 'form'
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
			idProperty: 'code'
		}, 
	    [
			{name: 'tcode', mapping : 'code'}
			,{name: 'tname', mapping: 'name'}
			,{name: 'toperstat', mapping: 'operstat'}
			,{name: 'torderType', mapping: 'statisticstat'}
			,{name: 'torderTypeID', mapping: 'ststatCode'}
			,{name: 'tstatCode', mapping: 'statCode'}

		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '代码',width: 120,dataIndex: 'tcode',sortable: true}
			,{header: '名称',width: 120,dataIndex: 'tname',sortable: true}
        	,{header: '手术状态',width: 120,dataIndex: 'toperstat',sortable: true}
			,{header: '统计类型',width: 120,dataIndex: 'torderType',sortable: true}
			,{header: '统计类型ID',width: 120,dataIndex: 'torderTypeID',sortable: true}
			,{header: '手术状态ID',width: 120,dataIndex: 'tstatCode',sortable: true}
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
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'FindQueryType';
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
	obj.AnOpReport = new Ext.Panel({
		id : 'AnOpReport'
		,buttonAlign : 'center'
		,height : 200
		,width:400
		,title : '手术报表设置'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	});
	//--------------------
   
   
    //----------------------
    obj.seqno = new Ext.form.TextField({
		id : 'seqno'
		,fieldLabel : '序号'
		,anchor : '80%'
	});
	
	obj.checkTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.checkTypeStore = new Ext.data.Store({
		proxy: obj.checkTypeStoreProxy,
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
	obj.checkType = new Ext.form.ComboBox({
		id : 'checkType'
		,store:obj.checkTypeStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '查询类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '80%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.checkTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'LookUpComCode';
		param.Arg1='SchType';
		param.ArgCnt = 1;
	});
	obj.checkTypeStore.load({});
	
	obj.returnTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.returnTypeStore = new Ext.data.Store({
		proxy: obj.returnTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
		     {name: 'rDesc', mapping: 'tDesc'}
			,{name: 'rCode', mapping: 'tCode'}
		])
	});	
	obj.returnType = new Ext.form.ComboBox({
		id : 'returnType'
		,store:obj.returnTypeStore
		,minChars:1	
		,displayField:'rDesc'	
		,fieldLabel : '返回类型'
		,valueField : 'rCode'
		,triggerAction : 'all'
		,anchor : '80%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.returnTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'LookUpComCode';
		//param.Arg1=obj.returnType.getValue();
		param.Arg1='ReturnType'
		param.ArgCnt = 1;
	});
	obj.returnTypeStore.load({});
	
	 obj.PanelList2 = new Ext.Panel({
		id : 'PanelList2'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
			obj.checkType
			,obj.returnType	
		]
	});
	
	obj.columnLinkStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.columnLinkStore = new Ext.data.Store({
		proxy: obj.columnLinkStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
		     {name: 'tDesc', mapping: 'varStr'}
			,{name: 'tID', mapping: 'varAlp'}
		])
	});	
	obj.columnLink = new Ext.form.ComboBox({
		id : 'columnLink'
		,store:obj.columnLinkStore
		,minChars:1	
		,displayField:'tDesc'	
		,fieldLabel : '列关联'
		,valueField : 'tID'
		,triggerAction : 'all'
		,anchor : '80%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.columnLinkStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'LookUpReport';
		param.Arg1=obj.columnLink.getValue();
		param.ArgCnt = 1;
	});
	obj.columnLinkStore.load({});	
		
	
    obj.PanelList1 = new Ext.Panel({
		id : 'PanelList1'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
			obj.seqno
			,obj.columnLink	
		]
	});
	
	obj.columnName = new Ext.form.TextField({
		id : 'columnName'
		,fieldLabel : '列名'
		,anchor : '80%'
	});
	
    
   /* obj.rw = new Ext.form.TextField({
		id : 'rw'
		,hidden : true
    });	*/
    
    
    
    obj.PanelList3 = new Ext.Panel({
		id : 'PanelList3'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
			obj.columnName
			//,obj.rw	
		]
	});
    
    
	
	obj.fPanelList = new Ext.form.FormPanel({
		id:"fPanelList"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:80
		,region:"north"
		,layout:"column"
		,items:[
			obj.PanelList1
			,obj.PanelList2
			,obj.PanelList3
		]
	});
	
	
	obj.addbuttonList = new Ext.Button({
		id : 'addbuttonList'
		,width:60
		,text : '增加'
	});
	obj.updatebuttonList = new Ext.Button({
		id : 'updatebuttonList'
		,width:60
		,text : '更新'
	});
	obj.deletebuttonList = new Ext.Button({
		id : 'deletebuttonList'
		,width:60
		,text : '删除'
	});
	obj.addpanelList = new Ext.Panel({
		id : 'addpanelList'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.addbuttonList
		]

	});
	obj.updatepanelList = new Ext.Panel({
		id : 'updatepanelList'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.updatebuttonList
		]

	});
	obj.deletepanelList = new Ext.Panel({
		id : 'deletepanelList'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'column'
		,items:[
		    obj.deletebuttonList
		    ]

	});	
	obj.buttonPanelList = new Ext.form.FormPanel({
		id : 'buttonPanelList'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addpanelList
			,obj.updatepanelList
			,obj.deletepanelList
		]
	});
	obj.floorPanelList = new Ext.Panel({
		id : 'floorPanelList'
		,buttonAlign : 'center'
		,height : 200
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanelList
			,obj.buttonPanelList
		]
    });
    
    obj.retGridPanelListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelListStore = new Ext.data.Store({
		proxy: obj.retGridPanelListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'seqno'
		}, 
	    [
			{name: 'tseqno', mapping : 'seqno'}
			,{name: 'tname', mapping: 'name'}
			,{name: 'tColLink', mapping: 'ColLink'}
			,{name: 'tColLinkID', mapping: 'ColLinkID'}
			,{name: 'tschtypeId', mapping: 'schtypeId'}
			,{name: 'treturntypeId', mapping: 'returntypeId'}
			,{name: 'tschtype', mapping: 'schtype'}
			,{name: 'treturntype', mapping: 'returntype'}
			//,{name: 'trw', mapping: 'rw'}
			
		])
	});
	var cmList = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '序号',width: 100,dataIndex: 'tseqno',sortable: true}
			,{header: '列名',width: 100,dataIndex: 'tname',sortable: true}
        	,{header: '列关联',width: 100,dataIndex: 'tColLink',sortable: true}
			,{header: '列关联ID',width: 100,dataIndex: 'tColLinkID',sortable: true}
			,{header: '查询类型ID',width: 100,dataIndex: 'tschtypeId',sortable: true}
			,{header: '返回类型ID',width: 100,dataIndex: 'treturntypeId',sortable: true}
			,{header: '查询类型',width: 100,dataIndex: 'tschtype',sortable: true}
			,{header: '返回类型',width: 100,dataIndex: 'treturntype',sortable: true}
			//,{header: 'rw',width: 100,dataIndex: 'trw',sortable: true}
		]
	});
	
	 obj.retGridPanelList = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelList'
		,store : obj.retGridPanelListStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cmList
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelListStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});
	obj.retGridPanelListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPReport';
		param.QueryName = 'FinTypeSetPrint';
		//param.Arg1 = obj.retGridPanel.getValue()
		//obj.retGridPanel
		param.Arg1 = obj.code.getValue();
		//param.Arg2 = obj.orderType.getValue();orderTypeID
		param.Arg2 = obj.orderTypeID.getValue();
		param.ArgCnt = 2;	
	});
	obj.retGridPanelListStore.load({});
	
	obj.PanelList23 = new Ext.Panel({
		id : 'PanelList23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	
	obj.PanelList25 = new Ext.Panel({
		id : 'PanelList25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	obj.resultPanelList = new Ext.Panel({
		id : 'resultPanelList'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.PanelList23
			,obj.PanelList25
		    ,obj.retGridPanelList
		]
	});
    
    obj.AnOpReportList = new Ext.Panel({
		id : 'AnOpReportList'
		,buttonAlign : 'center'
		,height : 200
		,width:650
		,region : 'east'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.floorPanelList
			,obj.resultPanelList
		]
	});

    //------------------------------------
    
   	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpReport
			,obj.AnOpReportList
		]
	}); 
	
	/////////////////////////////////
	InitViewScreenEvent(obj);
	
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
    
    
    obj.retGridPanelList.on("rowclick", obj.retGridPanelList_rowclick, obj);
    obj.addbuttonList.on("click", obj.addbuttonList_click, obj);
    obj.updatebuttonList.on("click", obj.updatebuttonList_click, obj);
    obj.deletebuttonList.on("click", obj.deletebuttonList_click, obj);
    
     
    obj.LoadEvent(arguments);    
    return obj;	
   
}