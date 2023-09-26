function InitViewport1(){
	var obj = new Object();
	
	obj.btnNew = new Ext.Toolbar.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,text : '�½�'
		,width : '80'
	});
	obj.btnEdit = new Ext.Toolbar.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,text : '�༭'
		,width : '80'
	});
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
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
			,{header: '��(Keys)', width: 100, dataIndex: 'Keys', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '����', width: 150, dataIndex: 'Description', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: 'ֵ(Values)', width: 120, dataIndex: 'Val', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: 'ֵ˵��', width: 150, dataIndex: 'ValueDesc', sortable: true
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��Ʒ', width: 0, dataIndex: 'ProName', align: 'left', hidden:true, menuDisabled:true}
			,{header: 'ҽԺ', width: 100, dataIndex: 'HispsDescs', sortable: true}
			,{header: '��ע', width: 100, dataIndex: 'Resume', sortable: true}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '����Ʒ���� : {[values.rs[0].get("ProName")]}(��{[values.rs.length]}����¼)',
			groupByText:'�����з���'
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
		,fieldLabel : '��(Keys)'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.Description = new Ext.form.TextField({
		id : 'Description'
		,width : 340
		//,allowBlank : false
		,fieldLabel : '����'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.Val = new Ext.form.TextField({
		id : 'Val'
		,width : 340
		//,allowBlank : false
		,fieldLabel : 'ֵ(Values)'
		,labelSeparator :''
		,anchor : '95%'
});
	obj.ValueDesc = new Ext.form.TextField({
		id : 'ValueDesc'
		,width : 340
		,fieldLabel : 'ֵ˵��'
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
		,fieldLabel : 'ʹ�ò�Ʒ'
		,labelSeparator :''
		//,editable : false  //ע�� by yhb ҽѧ����֤������-��������-������Ŀ-����/�༭-�޷�ɾ��ѡ���ʹ�ò�Ʒ��ҽԺ
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
		,fieldLabel : 'ҽԺ'
		,labelSeparator :''
		//,editable : false //ע�� by yhb ҽѧ����֤������-��������-������Ŀ-����/�༭-�޷�ɾ��ѡ���ʹ�ò�Ʒ��ҽԺ
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.Resume = new Ext.form.TextField({
		id : 'Resume'
		,width : 340
		,fieldLabel : '��ע'
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
		,text : '����'
});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,text : 'ȡ��'
});
	obj.WinEdit = new Ext.Window({
		id : 'WinEdit'
		,width : 500
		,plain : true
		,buttonAlign : 'center'
		,height : 300
		,title : '�������ñ༭'
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
	//�¼��������
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

