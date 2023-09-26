function InitViewport1(){
	var obj = new Object();
	
	obj.btnNew = new Ext.Toolbar.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,text : '新建'
		,width : '80'
	});
	obj.btnEdit = new Ext.Toolbar.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,text : '编辑'
		,width : '80'
	});
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
		,width : '80'
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.GroupingStore({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		},[
			{name: 'myid', mapping: 'myid'}
			,{name: 'Keys', mapping: 'Keys'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Val', mapping: 'Val'}
			,{name: 'ValueDesc', mapping: 'ValueDesc'}
			,{name: 'ProName', mapping: 'ProName'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'Resume', mapping: 'Resume'}
		])
		,sortInfo:{field: 'Keys', direction: "ASC"}
		,groupField:'ProName'
	});
	
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,header : true
		,buttonAlign : 'center'
		,store : obj.GridPanelStore
		,columnLines:true
		,loadMask : true
		,region : 'center'
		,frame : true
		,bbar:[obj.btnNew,obj.btnEdit,'->',obj.btnDelete]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '键(Keys)', width: 100, dataIndex: 'Keys', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '描述', width: 150, dataIndex: 'Description', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '值(Values)', width: 120, dataIndex: 'Val', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '值说明', width: 150, dataIndex: 'ValueDesc', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '产品', width: 0, dataIndex: 'ProName', align: 'left', hidden:true, menuDisabled:true}
			,{header: '医院', width: 100, dataIndex: 'HispsDescs', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'Resume', sortable: true}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '按产品归类 : {[values.rs[0].get("ProName")]}(共{[values.rs.length]}条记录)',
			groupByText:'依本列分组'
		})
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.GridPanel
		]
	});
	
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ConfigSrv';
			param.QueryName = 'QryConfig';
			param.Arg1 = ProductCode;
			param.ArgCnt = 1;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}
function InitWinEdit(){
	var obj = new Object();
	obj.Keys = new Ext.form.TextField({
		id : 'Keys'
		,width : 340
		//,allowBlank : false
		,fieldLabel : '键(Keys)'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.Description = new Ext.form.TextField({
		id : 'Description'
		,width : 340
		//,allowBlank : false
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.Val = new Ext.form.TextField({
		id : 'Val'
		,width : 340
		//,allowBlank : false
		,fieldLabel : '值(Values)'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.ValueDesc = new Ext.form.TextField({
		id : 'ValueDesc'
		,width : 340
		,fieldLabel : '值说明'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.ProNameStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ProNameStore = new Ext.data.Store({
		proxy: obj.ProNameStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.ProName = new Ext.form.ComboBox({
		id : 'ProName'
		,width : 340
		,store : obj.ProNameStore
		,displayField : 'ProName'
		,fieldLabel : '使用产品'
		,labelSeparator :''
		//,editable : false  //注释 by yhb 医学死亡证明管理-基础配置-配置项目-新增/编辑-无法删除选择的使用产品和医院
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.HispsDescsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.HispsDescsStore = new Ext.data.Store({
		proxy: obj.HispsDescsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'hosName', mapping: 'hosName'}
		])
	});
	obj.HispsDescs = new Ext.form.ComboBox({
		id : 'HispsDescs'
		,width : 340
		,store : obj.HispsDescsStore
		,displayField : 'hosName'
		,fieldLabel : '医院'
		,labelSeparator :''
		//,editable : false //注释 by yhb 医学死亡证明管理-基础配置-配置项目-新增/编辑-无法删除选择的使用产品和医院
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.Resume = new Ext.form.TextField({
		id : 'Resume'
		,width : 340
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.myid = new Ext.form.TextField({
		id : 'myid'
		,hidden : true
});
	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 400
		,region : 'center'
		,renderTo : document.body
		,layout : 'form'
		,frame : true
		,items:[
			obj.Keys
			,obj.Description
			,obj.Val
			,obj.ValueDesc
			,obj.ProName
			,obj.HispsDescs
			,obj.Resume
			,obj.myid
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,text : '取消'
});
	obj.WinEdit = new Ext.Window({
		id : 'WinEdit'
		,width : 500
		,plain : true
		,buttonAlign : 'center'
		,height : 300
		,title : '基础配置编辑'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.winfPanel
		]
	,	buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	obj.ProNameStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ConfigSrv';
			param.QueryName = 'QueryProInfo';
			param.ArgCnt = 0;
	});
	obj.ProNameStore.load({});
	obj.HispsDescsStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ConfigSrv';
			param.QueryName = 'QueryHosInfo';
			param.ArgCnt = 0;
	});
	obj.HispsDescsStore.load({});
	InitWinEditEvent(obj);
	//事件处理代码
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

