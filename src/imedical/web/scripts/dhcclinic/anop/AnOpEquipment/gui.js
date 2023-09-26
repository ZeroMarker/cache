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
			{name: 'OPCountDesc', mapping: 'OPCountDesc'}
			,{name: 'tPreOperNum', mapping: 'tPreOperNum'}
			,{name: 'tAddNum', mapping: 'tAddNum'}
			,{name: 'tUnSewNum', mapping: 'tUnSewNum'}
			,{name: 'tSewedNum', mapping: 'tSewedNum'}
			,{name: 'OPCountId', mapping: 'OPCountId'}
			,{name: 'tANOPCId', mapping: 'tANOPCId'}
			,{name: 'tSelfDefine', mapping: 'tSelfDefine'}
			,{name: 'tScanPackageNo', mapping: 'tScanPackageNo'}
			,{name: 'tScanPackageItemId', mapping: 'tScanPackageItemId'}
			,{name: 'tPackageName', mapping: 'tPackageName'}
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
		,{header: '器械名称', width: 100, dataIndex: 'OPCountDesc', sortable: true}
		,{header: '术前清点数', width: 70, dataIndex: 'tPreOperNum', sortable: true}
		,{header: '术中加点', width: 120, dataIndex: 'tAddNum', sortable: true}
		,{header: '关前清点数', width: 180, dataIndex: 'tUnSewNum', sortable: true}
		,{header: '关后清点数', width: 100, dataIndex: 'tSewedNum', sortable: true}
		,{header: '器械ID', width: 100, dataIndex: 'OPCountId', sortable: true}
		,{header: '清点项子表ID', width: 50, dataIndex: 'tANOPCId', hidden: true}
		,{header: '自定义项目', width: 50, dataIndex: 'tSelfDefine', hidden: true}
		,{header: '符合条件否', width: 80, dataIndex: 'tScanPackageNo', hidden: true}
		,{header: 'tScanPackageItemId', width: 50, dataIndex: 'tScanPackageItemId', hidden: true}
		,{header: '手术包', width: 50, dataIndex: 'tPackageName', hidden: true}
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
		,title : '<span style=\'font-size:14px;\'>术中器械信息</span>'
		,iconCls:'icon-operInfo'
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
		param.ClassName = 'web.DHCANCOPCount';
		param.QueryName = 'FindTypeSel';
		param.Arg1 = "1";
		param.Arg2 = selectObj.get('opaId');
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	obj.retGridPanelStore.load({
	});
    return obj;
}