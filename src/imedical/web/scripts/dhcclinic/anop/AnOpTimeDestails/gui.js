function InitViewScreen(){
	var obj = new Object();
	
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
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.dateFrm
			,obj.dateTo
		]
	});	
    obj.opaStartTime =new Ext.form.TimeField({
	    id : 'opaStartTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '手术开始'
		,anchor : '95%'
	});
	obj.opaEndTime =new Ext.form.TimeField({
	    id : 'opaEndTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '手术结束'
		,anchor : '95%'
	});
	obj.opaId = new Ext.form.TextField({
		id : 'opaId'
		,hidden:true
		,anchor : '95%'
	}); 
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.opaStartTime
			,obj.opaEndTime
			,obj.opaId
		]
	});
	
	obj.anaStartTime =new Ext.form.TimeField({
	    id : 'anaStartTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '麻醉开始'
		,anchor : '95%'
	});
	obj.anaEndTime =new Ext.form.TimeField({
	    id : 'anaEndTime'
		,format : 'H:i:s'
		,increment : 1
		,fieldLabel : '麻醉结束'
		,anchor : '95%'
	});	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,items:[
			obj.anaStartTime
			,obj.anaEndTime
		]
	});
	
	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
		]
	});

	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '查找'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
	});
	
	obj.keypanel = new Ext.Panel({
		id : 'keypanel'
		,buttonAlign : 'center'
		,layout : 'column'
        ,buttons:[
            obj.findbutton
            ,obj.updatebutton
       ]
	});
	
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.keypanel
		]
	});
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 160
		,title : '手术相关时间查询'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
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
			idProperty: 'opaId'
		}, 
	    [
			{name: 'opaId', mapping : 'opaId'}
			,{name: 'patLocDesc', mapping : 'patLocDesc'}
			,{name: 'bedNo', mapping : 'bedNo'}
			,{name: 'patName', mapping : 'patName'}
			,{name: 'roomDesc', mapping : 'roomDesc'}
			,{name: 'ordno', mapping: 'ordno'}
			,{name: 'opdes', mapping: 'opdes'}
			,{name: 'inAreaTime', mapping: 'inAreaTime'}
			,{name: 'inRoomTime', mapping: 'inRoomTime'}
			,{name: 'anaStartTime', mapping: 'anaStartTime'}
			,{name: 'opaStartTime', mapping: 'opaStartTime'}
			,{name: 'opaEndTime', mapping: 'opaEndTime'}
			,{name: 'anaEndTime', mapping: 'anaEndTime'}
			,{name: 'leaveRoomTime', mapping: 'leaveRoomTime'}
			,{name: 'roomId', mapping: 'roomId'}
			,{name: 'patLocId', mapping: 'patLocId'}
			,{name: 'opdate', mapping: 'opdate'}
			,{name: 'anmethoddesc', mapping: 'anmethoddesc'}
			,{name: 'anDoc', mapping: 'anDoc'}
			,{name: 'PACUInDateTime', mapping: 'PACUInDateTime'}
			,{name: 'opTime', mapping: 'opTime'}
			,{name: 'anTime', mapping: 'anTime'}
			,{name: 'proAnTime', mapping: 'proAnTime'}
			,{name: 'leaveTime', mapping: 'leaveTime'}
			,{name: 'toICUTime', mapping: 'toICUTime'}
			,{name: 'toWarTime', mapping: 'toWarTime'}
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
		,{header: 'opaId', width: 30, dataIndex: 'opaId', sortable: true}
		,{header: '科室', width: 80, dataIndex: 'patLocDesc', sortable: true}
		,{header: '床位', width: 70, dataIndex: 'bedNo', sortable: true}
		,{header: '姓名', width: 80, dataIndex: 'patName', sortable: true}
		,{header: '手术间', width: 60, dataIndex: 'roomDesc', sortable: true}
		,{header: '台次', width: 40, dataIndex: 'ordno', sortable: true}
		,{header: '手术名称', width:170, dataIndex: 'opdes', sortable: true}
		,{header: '预计麻醉时间', width:70, dataIndex: 'proAnTime', sortable: true}
		,{header: '入等候区', width: 90, dataIndex: 'inAreaTime', sortable: true}
		,{header: '返回病区时间', width: 90, dataIndex: 'toWarTime', sortable: true}
		,{header: '入室', width: 80, dataIndex: 'inRoomTime', sortable: true}
		,{header: '麻醉开始', width: 80, dataIndex: 'anaStartTime', sortable: true}
		,{header: '手术开始', width: 80, dataIndex: 'opaStartTime', sortable: true}
		,{header: '手术结束', width: 80, dataIndex: 'opaEndTime', sortable: true}
		,{header: '麻醉结束', width: 80, dataIndex: 'anaEndTime', sortable: true}
		,{header: '离室', width: 80, dataIndex: 'leaveRoomTime', sortable: true}
		,{header: '离病区时间', width: 80, dataIndex: 'leaveTime', sortable: true}
		,{header: '入ICU时间', width: 80, dataIndex: 'toICUTime', sortable: true}
		,{header: 'roomid', width: 80, dataIndex: 'roomId', hidden: true}
		,{header: 'patLocId', width: 80, dataIndex: 'patLocId', hidden: true}
		,{header: '手术日期', width: 80, dataIndex: 'opdate', sortable: true}
		,{header: '麻醉方法', width: 80, dataIndex: 'anmethoddesc', sortable: true}
		,{header: '麻醉医生', width: 80, dataIndex: 'anDoc', sortable: true}
		,{header: '入恢复室', width: 80, dataIndex: 'PACUInDateTime', sortable: true}
		,{header: '手术用时', width: 80, dataIndex: 'opTime', sortable: true}
		,{header: '麻醉用时', width: 80, dataIndex: 'anTime', sortable: true}
		]
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
	
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.findbutton.on("click", obj.findbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}