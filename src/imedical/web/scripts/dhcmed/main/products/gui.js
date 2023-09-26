function InitViewscreen(){
	var obj = new Object();
	obj.btnNew = new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,id : 'Button2'
		,text : '�½�'
});

	obj.btnEdit = new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,text : '�༭'
});/*
	obj.ViewPanel = new Ext.Panel({
		id : 'ViewPanel'
		,height : 60
		,buttonAlign : 'center'
		,region : 'north'
		,frame : true
		,title : '��Ʒά��'
		,layout : 'column'
		,items:[
		]
	,	buttons:[
			obj.btnNew
			,obj.btnEdit
		]
	});*/
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ProCode', mapping: 'ProCode'}
			,{name: 'ProName', mapping: 'ProName'}
			,{name: 'ProVersion', mapping: 'ProVersion'}
			,{name: 'IconClass', mapping: 'IconClass'}
			,{name: 'ShowIndex', mapping: 'ShowIndex'}
			,{name: 'ProActive', mapping: 'ProActive'}
			,{name: 'ProResume', mapping: 'ProResume'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,buttonAlign : 'center'
		,store : obj.GridPanelStore
		,loadMask : true
		,region : 'center'
		,frame : 'true'
		,viewConfig: {forceFit: true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 180, dataIndex: 'ProCode', sortable: true}
			,{header: '��Ʒ����', width: 300, dataIndex: 'ProName', sortable: true}
			,{header: '�汾��', width: 100, dataIndex: 'ProVersion', sortable: true}
			,{header: 'ͼ��', width: 100, dataIndex: 'IconClass', sortable: true}
			,{header: '��ʾ˳��', width: 100, dataIndex: 'ShowIndex', sortable: true}
			,{header: '�Ƿ���Ч', width: 100, dataIndex: 'ProActive', sortable: true}
			,{header: '����', width: 200, dataIndex: 'ProResume', sortable: true}
		]
		,tbar:[obj.btnNew,obj.btnEdit]
		//Modified By LiYang 2014-07-15 FixBug:1356 ϵͳ����-��Ʒά��-����¼����20��ʱ���޸ļ�¼�󣬽���ֻ��ʾǰ20����¼
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.GridPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})

});
	obj.Viewscreen = new Ext.Viewport({
		id : 'Viewscreen'
		,layout : 'border'
		,items:[
			//obj.ViewPanel,
			obj.GridPanel
		]
	});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'FindProInfo';
			param.ArgCnt = 0;
	});
	obj.GridPanelStore.load({/*
	params : {
		start:0
		,limit:20
	}*/});

	InitViewscreenEvent(obj);
	//�¼��������
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
	obj.GridPanel.on("rowclick", obj.GridPanel_rowclick, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitwinScreen(){
	var obj = new Object();
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .1
		,height :1
		,layout : 'form'
		,items:[
		]
	});
	obj.winfPProCode = new Ext.form.TextField({
		id : 'winfPProCode'
		,allowBlank : false
		,fieldLabel : '��Ʒ����'
		,anchor : '95%'
});
	obj.winfPProName = new Ext.form.TextField({
		id : 'winfPProName'
		,allowBlank : false
		,fieldLabel : '��Ʒ����'
		,anchor : '95%'
});
	obj.winfPProVersion = new Ext.form.TextField({
		id : 'winfPProVersion'
		,fieldLabel : '�汾��'
		,anchor : '95%'
});
	obj.winfPProShowIndex = new Ext.form.TextField({
		id : 'winfPProShowIndex'
		,fieldLabel : '��ʾ˳��'
		,anchor : '95%'
});
	obj.winfPProIconClass = new Ext.form.TextField({
		id : 'winfPProIconClass'
		,fieldLabel : 'ͼ��'
		,anchor : '95%'
});
	obj.winfPProResume = new Ext.form.TextField({
		id : 'winfPProResume'
		,fieldLabel : '����'
		,anchor : '95%'
});
	obj.winfPProActive = new Ext.form.Checkbox({
		id : 'winfPProActive'
		,checked : true
		,fieldLabel : '�Ƿ���Ч'
});
	obj.winfPProID = new Ext.form.TextField({
		id : 'winfPProID'
		,hidden : true
});
	obj.winfBtnSave = new Ext.Button({
		id : 'winfBtnSave'
		,iconCls : 'icon-save'
		,text : '����'
});
	obj.winfPBtnCancle = new Ext.Button({
		id : 'winfPBtnCancle'
		,iconCls : 'icon-undo'
		,text : 'ȡ��'
});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.winfPProCode
			,obj.winfPProName
			,obj.winfPProVersion
			,obj.winfPProShowIndex
			,obj.winfPProIconClass
			,obj.winfPProResume
			,obj.winfPProActive
			,obj.winfPProID
		]
	,	buttons:[
			obj.winfBtnSave
			,obj.winfPBtnCancle
		]
	});
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,height :1
		,items:[
		]
	});
	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelWidth : 70
		,labelAlign : 'right'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 400
		,items:[
			obj.Panel3
			,obj.Panel4
			,obj.Panel5
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 320
		,buttonAlign : 'center'
		,width : 400
		,modal : true
		,title : '��Ʒ�༭'
		,items:[
			obj.winfPanel
		]
	});
	InitwinScreenEvent(obj);
	//�¼��������
	obj.winfBtnSave.on("click", obj.winfBtnSave_click, obj);
	obj.winfPBtnCancle.on("click", obj.winfPBtnCancle_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

