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
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '��е����', width: 100, dataIndex: 'OPCountDesc', sortable: true}
		,{header: '��ǰ�����', width: 70, dataIndex: 'tPreOperNum', sortable: true}
		,{header: '���мӵ�', width: 120, dataIndex: 'tAddNum', sortable: true}
		,{header: '��ǰ�����', width: 180, dataIndex: 'tUnSewNum', sortable: true}
		,{header: '�غ������', width: 100, dataIndex: 'tSewedNum', sortable: true}
		,{header: '��еID', width: 100, dataIndex: 'OPCountId', sortable: true}
		,{header: '������ӱ�ID', width: 50, dataIndex: 'tANOPCId', hidden: true}
		,{header: '�Զ�����Ŀ', width: 50, dataIndex: 'tSelfDefine', hidden: true}
		,{header: '����������', width: 80, dataIndex: 'tScanPackageNo', hidden: true}
		,{header: 'tScanPackageItemId', width: 50, dataIndex: 'tScanPackageItemId', hidden: true}
		,{header: '������', width: 50, dataIndex: 'tPackageName', hidden: true}
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
		,title : '<span style=\'font-size:14px;\'>������е��Ϣ</span>'
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