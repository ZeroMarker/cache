function InitViewport(){
	var obj = new Object();
	obj.CurrRowid="";
	obj.MethodPackageStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MethodPackageStore = new Ext.data.Store({
		proxy: obj.MethodPackageStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Name', mapping: 'Name'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.MethodPackageCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MethodPackage = new Ext.grid.GridPanel({
		id : 'MethodPackage'
		,store : obj.MethodPackageStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '名称', width: 100, dataIndex: 'Name', sortable: true}
			,{header: '是否有效', width: 60, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '说明', width: 300, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MethodPackageStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.centerFPanel = new Ext.form.FormPanel({
		id : 'centerFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'border'
		,items:[
			obj.MethodPackage
		]
	});
	
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	obj.Name = new Ext.form.TextField({
		id : 'Name'
		,fieldLabel : '名称'
		,anchor : '95%'
	});
	obj.IsActive = new Ext.form.Checkbox({
		id : 'IsActive'
		,checked : true
		,fieldLabel : '是否有效'
		,anchor : '95%'
	});
	obj.ResumeText = new Ext.form.TextField({
		id : 'ResumeText'
		,fieldLabel : '说明'
		,anchor : '95%'
	});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,columnWidth : .2
		,items:[
		]
	});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items:[
			obj.Code
			,obj.Name
			,obj.IsActive
			,obj.ResumeText
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,columnWidth : .2
		,items:[
		]
	});
	obj.butUpdate = new Ext.Button({
		id : 'butUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	obj.southFPanel = new Ext.form.FormPanel({
		id : 'southFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 160
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
		,buttons:[
			obj.butUpdate
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.centerFPanel
			,obj.southFPanel
		]
	});
	obj.MethodPackageStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.PackageSrv';
			param.QueryName = 'QryPackage';
			param.Arg1 = "";
			param.ArgCnt = 1;
	});
	obj.MethodPackageStore.load({
		params : {
			start:0
			,limit:20
		}
	});

	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}