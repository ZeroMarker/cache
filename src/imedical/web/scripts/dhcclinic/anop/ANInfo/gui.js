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
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'AnRowId', width: 50, dataIndex: 'AnRowId', hidden: true}
		,{header: '����', width: 70, dataIndex: 'ANOType', sortable: true}
		,{header: '����', width: 120, dataIndex: 'ANOOEORI', sortable: true}
		,{header: '��ע', width: 180, dataIndex: 'ANONote', sortable: true}
		,{header: '��ʼʱ��', width: 100, dataIndex: 'start', sortable: true}
		,{header: '����ʱ��', width: 100, dataIndex: 'end', sortable: true}
		,{header: '���տ���', width: 50, dataIndex: 'ANORecLoc', sortable: true}
		,{header: '����', width: 50, dataIndex: 'ANOQty', sortable: true}
		,{header: '��ҩ;��', width: 80, dataIndex: 'ANOInstr', sortable: true}
		,{header: 'Ũ��', width: 50, dataIndex: 'ANODensity', sortable: true}
		,{header: '�ٶ�', width: 50, dataIndex: 'ANOSpeed', sortable: true}
		,{header: '��λ', width: 50, dataIndex: 'ANUom', sortable: true}
		,{header: '����', width: 50, dataIndex: 'ANOVolume', sortable: true}
		,{header: '��ҩ��ʽ', width: 80, dataIndex: 'ANODrugMode', sortable: true}
		,{header: '������Դ', width: 80, dataIndex: 'ANOSource', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
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
		,title : '����������Ϣ'
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