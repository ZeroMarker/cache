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
		,iconCls : 'icon-edit'
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
			idProperty: 'Id'
		},[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Keys', mapping: 'Keys'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Value', mapping: 'Value'}
			,{name: 'ValueDesc', mapping: 'ValueDesc'}
			,{name: 'HospId', mapping: 'HospId'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
		,sortInfo:{field: 'Keys', direction: "ASC"}
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
			,{header: '值(Values)', width: 120, dataIndex: 'Value', sortable: true
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
			,{header: '医院', width: 100, dataIndex: 'HospDesc', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'Resume', sortable: true}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true
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
			param.ClassName = 'DHCWMR.SSService.ConfigSrv';
			param.QueryName = 'QryItemList';
			param.Arg1 = "";
			param.ArgCnt = 1;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}
function InitWinEdit(objConfig){
	var obj = new Object();
	obj.objConfig = objConfig
	
	obj.Keys = new Ext.form.TextField({
		id : 'Keys'
		,width : 340
		,allowBlank : false
		,fieldLabel : '键(Keys)'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.Description = new Ext.form.TextField({
		id : 'Description'
		,width : 340
		,allowBlank : false
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.Value = new Ext.form.TextField({
		id : 'Value'
		,width : 340
		,allowBlank : false
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
		,editable : false
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
	obj.Id = new Ext.form.TextField({
		id : 'Id'
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
			,obj.Value
			,obj.ValueDesc
			,obj.HispsDescs
			,obj.Resume
			,obj.Id
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
	
	obj.HispsDescsStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.ConfigSrv';
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

