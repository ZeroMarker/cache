
function InitViewport1(){
	var obj = new Object();
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'SDCode', mapping: 'SDCode'}
			,{name: 'SDDesc', mapping: 'SDDesc'}
			,{name: 'SDInPut', mapping: 'SDInPut'}
			,{name: 'SDOutPut', mapping: 'SDOutPut'}
			,{name: 'SDMethodName', mapping: 'SDMethodName'}
			,{name: 'SDResume', mapping: 'SDResume'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,buttonAlign : 'center'
		,store : obj.GridPanelStore
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 150, dataIndex: 'SDCode', sortable: true}
			,{header: '描述', width: 150, dataIndex: 'SDDesc', sortable: true}
			,{header: '入参', width: 150, dataIndex: 'SDInPut', sortable: true}
			,{header: '出参', width: 150, dataIndex: 'SDOutPut', sortable: true}
			,{header: 'Method名称', width: 150, dataIndex: 'SDMethodName', sortable: true}
			,{header: '备注', width: 150, dataIndex: 'SDResume', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 16,
			store : obj.GridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		, tbar: [{
            iconCls: 'icon-new',
            text: '新建',
            handler: function(){
             	obj.btnNew_click(obj);	
            }
        },{
        	iconCls: 'icon-edit',
        	text: '编辑',
        	handler: function(){
             	obj.btnEdit_click(obj);	
            }
        },{
        	iconCls: 'icon-delete',
        	text: '删除',
        	handler: function(){
             	obj.btnDelete_click(obj);	
            }
        }
        ]

});
	obj.btnNew = new Ext.Button({
		id : 'btnNew'
		,text : '新建'
		,iconCls: 'icon-new'
});
	obj.btnEdit = new Ext.Button({
		id : 'btnEdit'
		,text : '编辑'
		,iconCls: 'icon-edit'
});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,text : '删除'
		,iconCls: 'icon-delete'
});
	obj.btnPanel = new Ext.Panel({
		id : 'btnPanel'
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,items:[
		]
	,	buttons:[   
			obj.btnNew
			,obj.btnEdit
			,obj.btnDelete
		]
	});
	
	obj.rowid = new Ext.form.TextField({
		id : 'rowid'
		,hidden : true
});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.GridPanel
			//,obj.btnPanel
			,obj.rowid
		]
	});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectDicSrv';
			param.QueryName = 'QrySubjectDic';
			param.ArgCnt = 0;
	});
	obj.GridPanelStore.load({});
	InitViewport1Event(obj);
	//事件处理代码
	obj.GridPanel.on("rowclick", obj.GridPanel_rowclick, obj);
	obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
    obj.LoadEvent();
  return obj;
}
function InitWinEdit(){
	var obj = new Object();
	obj.hidden1 = new Ext.form.TextField({
		id : 'hidden1'
		,width : 300
		,hidden : true
});
	obj.SDCode = new Ext.form.TextField({
		id : 'SDCode'
		,width : 300
		,fieldLabel : '代码'
		
});
	obj.SDDesc = new Ext.form.TextField({
		id : 'SDDesc'
		,width : 300
		,fieldLabel : '描述'
	
});
	obj.SDInPut = new Ext.form.TextField({
		id : 'SDInPut'
		,width : 300
		,fieldLabel : '入参'
	
});
	obj.SDOutPut = new Ext.form.TextField({
		id : 'SDOutPut'
		,width : 300
		,fieldLabel : '出参'
		
});
	obj.SDMethodName = new Ext.form.TextField({
		id : 'SDMethodName'
		,width : 300
		,fieldLabel : 'Method名称'
		
});
	obj.SDResume = new Ext.form.TextField({
		id : 'SDResume'
		,width : 300
		,fieldLabel : '备注'
		
});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,text: '保存'
		,iconCls: 'icon-save'
	
});
	obj.btnExit = new Ext.Button({
		id : 'btnExit'
		,text: '退出'
		,iconCls: 'icon-exit'
		
});
obj.PanelEdit = new Ext.form.FormPanel({
		id : 'PanelEdit'
		,buttonAlign : 'center'
		,height : 228
		,labelWidth: 80
		,bodyStyle: 'padding:20 20 20 20'
		,layout : 'form'
		,frame : true
		,width : 484
		,items:[
			obj.SDCode
			,obj.SDDesc
			,obj.SDInPut
			,obj.SDOutPut
			,obj.SDMethodName
			,obj.SDResume
		]
	});
	obj.WinEdit = new Ext.Window({
		id : 'WinEdit'
		,height : 300
		,buttonAlign : 'center'
		,modal: true
		,width : 450
		,plain : true
		,title : '主题项'
		,layout : 'form'
		,items:[
			obj.PanelEdit
		]
	,	buttons:[
			obj.btnSave
			,obj.btnExit
		]
	});
	InitWinEditEvent(obj);
	//事件处理代码
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnExit.on("click", obj.btnExit_click, obj);
 
  obj.LoadEvent();
  return obj;
}

