function InitViewport(){
	var obj = new Object();
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
			,{header: '名称', width: 200, dataIndex: 'Name', sortable: true}
			,{header: '是否有效', width: 100, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MethodPackageStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

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
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.rowid = new Ext.form.TextField({
		id : 'rowid'
		,hidden : true
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
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.rowid
			,obj.Code
			,obj.Name
			,obj.IsActive
			,obj.ResumeText
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.butUpdate = new Ext.Button({
		id : 'butUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.btnInfo = new Ext.Button({
		id : 'btnInfo'
		,iconCls : 'icon-add'
		,anchor : '95%'
		,text : '暴露函数'
});
	obj.southFPanel = new Ext.form.FormPanel({
		id : 'southFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 200
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	,	buttons:[
			obj.btnFind
			,obj.butUpdate
			,obj.btnInfo
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
			param.ClassName = 'DHCMed.CCService.MethodPackageSrv';
			param.QueryName = 'QueryMethodPackageInfo';
			param.Arg1 = obj.Name.getValue();
			param.ArgCnt = 1;
	});
	obj.MethodPackageStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewportEvent(obj);
	//事件处理代码
	obj.MethodPackage.on("rowclick", obj.MethodPackage_rowclick, obj);
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.butUpdate.on("click", obj.butUpdate_click, obj);
	obj.btnInfo.on("click", obj.btnInfo_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitMethodInfo(){
	var obj = new Object();
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
			,{header: '书写格式', width: 100, dataIndex: 'ClassMetohd', sortable: true}
			,{header: '返回值', width: 100, dataIndex: 'DefaultReturnValue', sortable: true}
			,{header: '是否有效', width: 80, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.MethodInfoListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

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
	obj.winLeftPanel = new Ext.Panel({
		id : 'winLeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
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
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.winPackageID = new Ext.form.TextField({
		id : 'winPackageID'
		,hidden : true
		,anchor : '95%'
});
	obj.winLeftCenterPanel = new Ext.Panel({
		id : 'winLeftCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winName
			,obj.winDReturnValue
			,obj.winResumeText
			,obj.winPackageID
		]
	});
	obj.winClassMethod = new Ext.form.TextField({
		id : 'winClassMethod'
		,fieldLabel : '书写格式'
		,anchor : '95%'
});
	obj.winIsActive = new Ext.form.Checkbox({
		id : 'winIsActive'
		,checked : true
		,fieldLabel : '是否有效'
		,anchor : '95%'
});
	obj.winID = new Ext.form.TextField({
		id : 'winID'
		,hidden : true
		,anchor : '95%'
});
	obj.winRightCenterPanel = new Ext.Panel({
		id : 'winRightCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winClassMethod
			,obj.winIsActive
			,obj.winID
		]
	});
	obj.winRightPanel = new Ext.Panel({
		id : 'winRightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.winBtnFind = new Ext.Button({
		id : 'winBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.winBtnUpdate = new Ext.Button({
		id : 'winBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.winBtnExit = new Ext.Button({
		id : 'winBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.MSouthFPanel = new Ext.form.FormPanel({
		id : 'MSouthFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 140
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.winLeftPanel
			,obj.winLeftCenterPanel
			,obj.winRightCenterPanel
			,obj.winRightPanel
		]
	,	buttons:[
			obj.winBtnFind
			,obj.winBtnUpdate
			,obj.winBtnExit
		]
	});
	obj.MethodInfo = new Ext.Window({
		id : 'MethodInfo'
		,height : 400
		,buttonAlign : 'center'
		,width : 600
		,closable : false
		,title : '暴露函数维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.MCenterFPanel
			,obj.MSouthFPanel
		]
	});
	obj.MethodInfoListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.MethodPackageSrv';
			param.QueryName = 'QueryMethodInfo';
			param.Arg1 = obj.winPackageID.getValue();
			param.Arg2 = obj.winName.getValue();
			param.ArgCnt = 2;
	});
	obj.MethodInfoListStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitMethodInfoEvent(obj);
	//事件处理代码
	obj.MethodInfoList.on("rowclick", obj.MethodInfoList_rowclick, obj);
	obj.winBtnFind.on("click", obj.winBtnFind_click, obj);
	obj.winBtnUpdate.on("click", obj.winBtnUpdate_click, obj);
	obj.winBtnExit.on("click", obj.winBtnExit_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

