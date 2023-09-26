function InitViewScreen()
{
	var obj = new Object();
	
	
	//-----------手术麻醉打印单据设置------------
	obj.code = new Ext.form.TextField({
		id : 'code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});	
	
	
	var data=[
              ['ByASA','按分级'],
              ['ByLoc','按科室'],
              ['ByPat','按病人']
              ]
    obj.statTypeStoreProxy=data;
	obj.statTypeStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
			{name: 'code'}
		   ,{name: 'desc'}
		])
	});
	obj.statType = new Ext.form.ComboBox({
		id : 'statType'
		,minChars : 1
		,fieldLabel : '统计类型'
		,triggerAction : 'all'
		,store : obj.statTypeStore
		,displayField : 'desc'
		,anchor : '95%'
		,valueField : 'code'
    });
	
	obj.statTypeID = new Ext.form.TextField({
		id : 'statTypeID'
		,fieldLabel : '统计类型ID'
		,anchor : '95%'
		//,hidden:true
	});	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
			obj.code
			,obj.statType
			,obj.statTypeID	
		]
	});
	
	obj.name = new Ext.form.TextField({
		id : 'name'
		,fieldLabel : '名称'
		,anchor : '95%'
	});
	
	var data=[
              ['A','申请'],
              ['D','拒绝'],
              ['R','安排'],
              ['F','完成']
             ]
    obj.operStatStoreProxy=data;
	obj.operStatStore = new Ext.data.Store({
	proxy: new Ext.data.MemoryProxy(data),
	reader: new Ext.data.ArrayReader({
		}, 
		[
		 {name: 'code'}
		 ,{name: 'desc'}
		])
	});
	obj.operStat = new Ext.form.ComboBox({
		id : 'operStat'
		,minChars : 1
		,fieldLabel : '手术状态'
		,triggerAction : 'all'
		,store : obj.operStatStore
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
			obj.name
			,obj.operStat
		]
	});
	
	obj.fPanel = new Ext.form.FormPanel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:100
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
		,text : '更新'
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
		,height : 180
		,region : 'north'
		,layout : 'form'
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
			idProperty: 'code'
		}, 
	    [
			{name: 'tcode', mapping : 'code'}
			,{name: 'tname', mapping: 'name'}
			,{name: 'toperStat', mapping: 'operstat'}
			,{name: 'toperStatID', mapping: 'operStatID'}
			,{name: 'tstatType', mapping: 'statisticstat'}
			,{name: 'tstatTypeID', mapping: 'ststatCode'}

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
			,{header: '手术状态',width: 120,dataIndex: 'toperStat',sortable: true}
			,{header: '手术状态ID',width: 120,dataIndex: 'toperStatID',sortable: true}
			,{header: '统计类型',width: 120,dataIndex: 'tstatType',sortable: true}
			,{header: '统计类型ID',width: 120,dataIndex: 'tstatTypeID',sortable: true}
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
	obj.AnOpSetPrint = new Ext.Panel({
		id : 'AnOpSetPrint'
		,buttonAlign : 'center'
		,height : 200
		,width:500
		,title : '工作量统计'
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
   
   
    //-----------手术麻醉打印单列表-----------
	
	obj.dateFrm = new Ext.form.DateField({
		id : 'dateFrm'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '开始日期'
		,anchor : '95%'
	});
	obj.dateTo = new Ext.form.DateField({
		id : 'dateTo'
		,value : new Date()
		,format : 'j/n/Y'
		,fieldLabel : '结束日期'
		,anchor : '95%'
	});	
	
    obj.PanelList1 = new Ext.Panel({
		id : 'PanelList1'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
		    obj.dateFrm
		]
	});	
    
    obj.PanelList2 = new Ext.Panel({
		id : 'PanelList2'
		,buttonAlign : 'center'
		,columnWidth : .40
		,layout : 'form'
		,items:[
		    obj.dateTo	
		]
	});
	
	obj.schbuttonList = new Ext.Button({
		id : 'schbuttonList'
		,width:60
		,text : '查询'
	});
    
	obj.fPanelList = new Ext.form.FormPanel({
		id:"fPanelList"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:100
		,region:"north"
		,layout:"column"
		,items:[
			obj.PanelList1
			,obj.PanelList2
		]
		,buttons:[
			obj.schbuttonList
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
	         {name: 'AnDoc', mapping: 'AnDoc'}
			,{name: 'ASAI', mapping: 'ASAI'}
			,{name: 'ASAII', mapping: 'ASAII'}
			,{name: 'ASAIII', mapping: 'ASAIII'}
			,{name: 'ASAIV', mapping: 'ASAIV'}
			,{name: 'ASAV', mapping: 'ASAV'}
			,{name: 'ASAVI', mapping: 'ASAVI'}
			
		])
	});
	var cmList = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '麻醉医生',width: 100,dataIndex: 'AnDoc',sortable: true}
			,{header: 'ASA等级I',width: 100,dataIndex: 'ASAI',sortable: true}
        	,{header: 'ASA等级II',width: 100,dataIndex: 'ASAII',sortable: true}
			,{header: 'ASA等级III',width: 100,dataIndex: 'ASAIII',sortable: true}
			,{header: 'ASA等级IV',width: 100,dataIndex: 'ASAIV',sortable: true}
			,{header: 'ASA等级V',width: 100,dataIndex: 'ASAV',sortable: true}
			,{header: 'ASA等级VI',width: 100,dataIndex: 'ASAVI',sortable: true}
			
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
		param.QueryName = 'GetWRPAnOpInfoTest';
		
		param.Arg1 = obj.dateFrm.getValue();
		param.Arg2 = obj.dateTo.getValue();
		param.Arg3 ="";
		param.ArgCnt = 3;
	});

	obj.retGridPanelListStore.load({});
	
	
	
	obj.resultPanelList = new Ext.Panel({
		id : 'resultPanelList'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[ 
		   obj.retGridPanelList
		]
	});
    
    obj.AnOpSetPrintList = new Ext.Panel({
		id : 'AnOpSetPrintList'
		,buttonAlign : 'center'
		,height : 200
		,width:600
		,title : '麻醉医生工作量统计'
		,region : 'east'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanelList
			,obj.resultPanelList
		]
	});

    //------------------------------------
    
   	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.AnOpSetPrint
			,obj.AnOpSetPrintList
		]
	}); 
	/////////////////////////////////
	InitViewScreenEvent(obj);
	

	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addbutton.on("click", obj.addbutton_click, obj);
    obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.deletebutton.on("click", obj.deletebutton_click, obj);
    
    
    obj.retGridPanelList.on("rowclick", obj.retGridPanelList_rowclick, obj);
    obj.schbuttonList.on("click", obj.schbuttonList_click, obj);

     
    obj.LoadEvent(arguments);    
    return obj;	
   
}