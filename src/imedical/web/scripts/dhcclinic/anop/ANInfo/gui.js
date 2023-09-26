function InitViewScreen(){
var obj = new Object();
var selectObj=window.dialogArguments;
obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AnRowId'
		}, 
	    [
			{name: 'AnRowId', mapping: 'AnRowId'}
			,{name: 'ANOType', mapping: 'ANOType'}
			,{name: 'ANOOEORI', mapping: 'ANOOEORI'}
			,{name: 'start', mapping: 'start'}
			,{name: 'end', mapping: 'end'}
			,{name: 'ANORecLoc', mapping: 'ANORecLoc'}
			,{name: 'ANOQty', mapping: 'ANOQty'}
			,{name: 'ANOInstr', mapping: 'ANOInstr'}
			,{name: 'ANUom', mapping: 'ANUom'}
			,{name: 'ANODensity', mapping: 'ANODensity'}
			,{name: 'ANOSpeed', mapping: 'ANOSpeed'}
			,{name: 'ANOVolume', mapping: 'ANOVolume'}
			,{name: 'ANODrugMode', mapping: 'ANODrugMode'}
			,{name: 'ANOSource', mapping: 'ANOSource'}
			,{name: 'ANONote', mapping: 'ANONote'}
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
		,{header: 'AnRowId', width: 50, dataIndex: 'AnRowId', hidden: true}
		,{header: '类型', width: 70, dataIndex: 'ANOType', sortable: true}
		,{header: '名称', width: 120, dataIndex: 'ANOOEORI', sortable: true}
		,{header: '备注', width: 180, dataIndex: 'ANONote', sortable: true}
		,{header: '开始时间', width: 100, dataIndex: 'start', sortable: true}
		,{header: '结束时间', width: 100, dataIndex: 'end', sortable: true}
		,{header: '接收科室', width: 50, dataIndex: 'ANORecLoc', sortable: true}
		,{header: '数量', width: 50, dataIndex: 'ANOQty', sortable: true}
		,{header: '用药途径', width: 80, dataIndex: 'ANOInstr', sortable: true}
		,{header: '浓度', width: 50, dataIndex: 'ANODensity', sortable: true}
		,{header: '速度', width: 50, dataIndex: 'ANOSpeed', sortable: true}
		,{header: '单位', width: 50, dataIndex: 'ANUom', sortable: true}
		,{header: '容量', width: 50, dataIndex: 'ANOVolume', sortable: true}
		,{header: '给药方式', width: 80, dataIndex: 'ANODrugMode', sortable: true}
		,{header: '数据来源', width: 80, dataIndex: 'ANOSource', sortable: true}
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
		,title : '术中麻醉信息'
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
			obj.resultPanel
		]
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRecord';
		param.QueryName = 'FindAnInfo';
		param.Arg1 = selectObj.get('opaId');
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({
	});
    return obj;
}