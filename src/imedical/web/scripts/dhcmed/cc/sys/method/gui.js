function InitViewport(PackageID){
	var obj = new Object();
	obj.winCurrRowid="";
	obj.winPackageID=PackageID;
	obj.MethodInfoListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MethodInfoListStore = new Ext.data.Store({
		proxy: obj.MethodInfoListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Name', mapping: 'Name'}
			,{name: 'ClassMetohd', mapping: 'ClassMetohd'}
			,{name: 'DefaultReturnValue', mapping: 'DefaultReturnValue'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.MethodInfoListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MethodInfoList = new Ext.grid.GridPanel({
		id : 'MethodInfoList'
		,store : obj.MethodInfoListStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '名称', width: 100, dataIndex: 'Name', sortable: true}
			,{header: '类方法', width: 100, dataIndex: 'ClassMetohd', sortable: true}
			,{header: '返回值', width: 100, dataIndex: 'DefaultReturnValue', sortable: true}
			,{header: '是否有效', width: 60, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '说明', width: 300, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MethodInfoListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.MCenterFPanel = new Ext.form.FormPanel({
		id : 'MCenterFPanel'
		,layout : 'border'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,region : 'center'
		,items:[
			obj.MethodInfoList
		]
	});
	obj.winName = new Ext.form.TextField({
		id : 'winName'
		,fieldLabel : '名称'
		,anchor : '95%'
	});
	obj.winDReturnValue = new Ext.form.TextField({
		id : 'winDReturnValue'
		,fieldLabel : '返回值'
		,anchor : '95%'
	});
	obj.winResumeText = new Ext.form.TextField({
		id : 'winResumeText'
		,fieldLabel : '说明'
		,anchor : '95%'
	});
	obj.winClassMethod = new Ext.form.TextField({
		id : 'winClassMethod'
		,fieldLabel : '类方法'
		,anchor : '95%'
	});
	obj.winIsActive = new Ext.form.Checkbox({
		id : 'winIsActive'
		,checked : true
		,fieldLabel : '是否有效'
		,anchor : '95%'
	});
	obj.winLeftPanel = new Ext.Panel({
		id : 'winLeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.winCenterPanel = new Ext.Panel({
		id : 'winCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.winName
			,obj.winClassMethod
			,obj.winDReturnValue
			,obj.winIsActive
			,obj.winResumeText
		]
	});
	obj.winRightPanel = new Ext.Panel({
		id : 'winRightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.winBtnUpdate = new Ext.Button({
		id : 'winBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	obj.MSouthFPanel = new Ext.form.FormPanel({
		id : 'MSouthFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 190
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.winLeftPanel
			,obj.winCenterPanel
			,obj.winRightPanel
		]
		,buttons:[
			obj.winBtnUpdate
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.MCenterFPanel
			,obj.MSouthFPanel
		]
	});
	obj.MethodInfoListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.PackageSrv';
			param.QueryName = 'QueryMethodInfo';
			param.Arg1 = obj.winPackageID;
			param.Arg2 = "";
			param.ArgCnt = 2;
	});
	obj.MethodInfoListStore.load({
		params : {
			start:0
			,limit:20
		}
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

