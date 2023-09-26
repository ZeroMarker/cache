///20170324+GY
function InitViewScreen(){
	var obj = new Object();
	obj.ctlocDescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ctlocDescstore = new Ext.data.Store({
		proxy: obj.ctlocDescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping : 'ctlocDesc'}
			
		])
	});
	obj.operLoc = new Ext.form.ComboBox({
		id : 'operLoc'
		,store:obj.ctlocDescstore
		,minChars:1
		,displayField:'ctlocDesc'
		,fieldLabel : '手术室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,validateOnBlur:true
		,editable:false
		,labelSeparator: ''
		,anchor : '80%'
	});
	obj.oprCtDefUsestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprCtDefUsestore = new Ext.data.Store({
		proxy: obj.oprCtDefUsestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprLocId'
		}, 
		[
			{name: 'oprLocId', mapping: 'oprLocId'}
			,{name: 'oprCtLoc', mapping : 'oprCtLoc'}
			
		])
	});
	obj.oprCtDefUse = new Ext.form.ComboBox({
		id : 'oprCtDefUse'
		,store:obj.oprCtDefUsestore
		,minChars:1
		,displayField:'oprCtLoc'
		,fieldLabel : '默认外科科室'
		,valueField : 'oprLocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '80%'
	});
	obj.opRoomCode = new Ext.form.TextField({
		id : 'opRoomCode'
		,fieldLabel : '手术间代码'
		,labelSeparator: ''
		,anchor : '85%'
	}); 
	obj.oprAvailablestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprAvailablestore = new Ext.data.Store({
		proxy: obj.oprAvailablestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AvailableCode'
		}, 
		[
			{name: 'AvailableCode', mapping: 'AvailableCode'}
		])
	});
	obj.oprAvailable = new Ext.form.ComboBox({
		id : 'oprAvailable'
		,store:obj.oprAvailablestore
		,minChars:1
		,displayField:'AvailableCode'
		,labelSeparator: ''
		,fieldLabel : '是否可用'
		,valueField : 'AvailableCode'
		,triggerAction : 'all'
		,editable:false
		,anchor : '85%'
	});

	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	obj.oprLocId = new Ext.form.TextField({
		id : 'oprLocId'
		,hidden : true
    });
    obj.opRoomDesc = new Ext.form.TextField({
		id : 'opRoomDesc'
		,fieldLabel : '手术间名称'
		,labelSeparator: ''
		,anchor : '85%'
	}); 	
	obj.oprNotAvailReasonstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprNotAvailReasonstore = new Ext.data.Store({
		proxy: obj.oprNotAvailReasonstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RNAVRowID'
		}, 
		[
			{name: 'RNAVRowID', mapping: 'RNAVRowID'}
			,{name: 'RNAVDesc', mapping : 'RNAVDesc'}
		])
	});
	obj.oprNotAvailReason = new Ext.form.ComboBox({
		id : 'oprNotAvailReason'
		,store:obj.oprNotAvailReasonstore
		,minChars:1
		,displayField:'RNAVDesc'
		,fieldLabel : '不可用原因'
		,labelSeparator: ''
		,editable:false
		,valueField : 'RNAVRowID'
		,triggerAction : 'all'
		,anchor : '85%'
	});
	obj.oprCtFloorstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.oprCtFloorstore = new Ext.data.Store({
		proxy: obj.oprCtFloorstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprCtFloorId'
		}, 
		[
			{name: 'oprCtFloorId', mapping: 'oprCtFloorId'}
			,{name: 'oprCtFloor', mapping : 'oprCtFloor'}
			
		])
	});
	obj.oprCtFloor = new Ext.form.ComboBox({
		id : 'oprCtFloor'
		,store:obj.oprCtFloorstore
		,minChars:1
		,displayField:'oprCtFloor'
		,fieldLabel : '手术楼层'
		,editable:false
		,valueField : 'oprCtFloorId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '80%'
	});	  
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth :90
		,layout : 'form'
		,items:[
			obj.operLoc
			,obj.oprCtDefUse
		]
	});	 
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth :75
		,layout : 'form'
		,items:[
			obj.opRoomCode
			,obj.oprAvailable
		]
	});
			
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth :75
		,layout : 'form'
		,items:[
			obj.opRoomDesc
			,obj.oprNotAvailReason
		]
	});	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:'86'
		,style:'margin-left:5px;'
		,text : '增加'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		,width:'86'
		,style:'margin-Top:3px;margin-left:5px'
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:'86'
		,style:'margin-left:130px'
		,text : '删除'
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .10
		,layout : 'form'
		,items:[
		     obj.addbutton
            ,obj.updatebutton
		]
	});	
	/*
	obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,layout : 'form'
		,items:[
		    obj.deletebutton	
		    			
		]
	});	*/
	 obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .20
		,labelWidth:60
		,layout : 'form'
		,items:[
            obj.oprCtFloor   
		     ,obj.deletebutton	
		]
	});	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
		    //,obj.Panel6
		]
	});

	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 92
		,title : '手术间维护'
		,region : 'north'
		,layout : 'form'
		,iconCls:'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'tOprId'
		}, 
	    [
			{name: 'tOprId', mapping : 'tOprId'}
			,{name: 'tOprCtLocId', mapping : 'tOprCtLocId'}
			,{name: 'tOprCtLoc', mapping : 'tOprCtLoc'}
			,{name: 'tOprCode', mapping : 'tOprCode'}
			,{name: 'tOprDesc', mapping : 'tOprDesc'}
			,{name: 'tOprCtFloorId', mapping: 'tOprCtFloorId'}
			,{name: 'tOprCtTypeId', mapping: 'tOprCtTypeId'}
			,{name: 'tOprCtDefUseId', mapping: 'tOprCtDefUseId'}
			,{name: 'tOprCtFloor', mapping: 'tOprCtFloor'}
			,{name: 'tOprCtType', mapping: 'tOprCtType'}
			,{name: 'tOprCtDefUse', mapping: 'tOprCtDefUse'}
			,{name: 'tOprAvailable', mapping: 'tOprAvailable'}
			,{name: 'tOprNotAvailReason', mapping: 'tOprNotAvailReason'}
			,{name: 'tOprBedType', mapping: 'tOprBedType'}
			,{name: 'tOprNotAvailReasonId', mapping: 'tOprNotAvailReasonId'}
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
		,{header: '系统号', width: 50, dataIndex: 'tOprId', sortable: true}
		,{header: '手术室', width: 150, dataIndex: 'tOprCtLoc', sortable: true}
		,{header: '手术间代码', width: 70, dataIndex: 'tOprCode', sortable: true}
		,{header: '手术间名称', width: 80, dataIndex: 'tOprDesc', sortable: true}
		,{header: '手术室ID', width: 60, dataIndex: 'tOprCtLocId', sortable: true}
		,{header: '手术楼层ID', width: 70, dataIndex: 'tOprCtFloorId', sortable: true}
		,{header: '手术类型ID', width:70, dataIndex: 'tOprCtTypeId', sortable: true}
		,{header: '默认外科科室ID', width: 90, dataIndex: 'tOprCtDefUseId', sortable: true}
		,{header: '手术楼层', width: 60, dataIndex: 'tOprCtFloor', sortable: true}
		,{header: '手术类型', width: 60, dataIndex: 'tOprCtType', sortable: true}
		,{header: '默认外科科室', width: 159, dataIndex: 'tOprCtDefUse', sortable: true}
		,{header: '是否可用', width: 60, dataIndex: 'tOprAvailable', sortable: true}
		,{header: '不可用原因', width: 70, dataIndex: 'tOprNotAvailReason', sortable: true}
		//,{header: '手术间类型', width: 80, dataIndex: 'tOPRBedType', sortable: true}
		,{header: '不可用原因ID', width: 80, dataIndex: 'tOprNotAvailReasonId', sortable: true}
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
		,iconCls:'icon-result'
		,title : '手术间规模查询结果'
		,frame : false
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
	

	obj.ctlocDescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1=obj.operLoc.getRawValue();
		param.Arg2='OP^OUTOP^EMOP';
		param.Arg3='';
		param.ArgCnt = 3;
	});
	obj.ctlocDescstore.load({});
		
	obj.oprCtDefUsestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'ctdefuselookup';
		param.Arg1=obj.oprCtDefUse.getRawValue();
		param.ArgCnt = 1;
	});
	obj.oprCtDefUsestore.load({});
	
	obj.oprAvailablestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'Availablelookup';
		param.ArgCnt = 0;
	});
	obj.oprAvailablestore.load({});
	
	obj.oprNotAvailReasonstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'NotAvailReasonlookup';
		param.ArgCnt = 0;
	});
	obj.oprNotAvailReasonstore.load({});
	
	obj.oprCtFloorstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'ctfloorlookup';
		param.Arg1=obj.oprCtFloor.getRawValue();
		param.ArgCnt = 1;
	});
	obj.oprCtFloorstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCRoom';
		param.QueryName = 'FindexeLoc';
		param.Arg1="T"
		param.ArgCnt = 1;
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