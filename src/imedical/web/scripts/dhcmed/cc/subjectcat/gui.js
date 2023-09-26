function InitViewport(){
	var obj = new Object();
	obj.SubjectCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectCatStore = new Ext.data.Store({
		proxy: obj.SubjectCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Title', mapping: 'Title'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.SubjectCatCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SubjectCat = new Ext.grid.GridPanel({
		id : 'SubjectCat'
		,store : obj.SubjectCatStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '名称', width: 150, dataIndex: 'Title', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 200, dataIndex: 'Desc', sortable: true}
			,{header: '是否有效', width: 80, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.SubjectCatStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.CenterFPanel = new Ext.form.FormPanel({
		id : 'CenterFPanel'
		,layout : 'border'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,region : 'center'
		,items:[
			obj.SubjectCat
		]
	});
	obj.LeftInfoPanel = new Ext.Panel({
		id : 'LeftInfoPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.ID = new Ext.form.TextField({
		id : 'ID'
		,hidden : true
});
	obj.Title = new Ext.form.TextField({
		id : 'Title'
		,fieldLabel : '名称'
		,anchor : '95%'
});
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.Desc = new Ext.form.TextField({
		id : 'Desc'
		,fieldLabel : '描述'
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
	obj.CenterInfoPanel = new Ext.Panel({
		id : 'CenterInfoPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ID
			,obj.Title
			,obj.Code
			,obj.Desc
			,obj.IsActive
			,obj.ResumeText
		]
	});
	obj.RightInfoPanel = new Ext.Panel({
		id : 'RightInfoPanel'
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
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.southFPanel = new Ext.form.FormPanel({
		id : 'southFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 220
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftInfoPanel
			,obj.CenterInfoPanel
			,obj.RightInfoPanel
		]
	,	buttons:[
			obj.btnFind
			,obj.btnUpdate
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.CenterFPanel
			,obj.southFPanel
		]
	});
	obj.SubjectCatStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectCatSrv';
			param.QueryName = 'QuerySubjectCatInfo';
			param.Arg1 = obj.Title.getValue();
			param.ArgCnt = 1;
	});
	obj.SubjectCatStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewportEvent(obj);
	//事件处理代码
	obj.SubjectCat.on("rowclick", obj.SubjectCat_rowclick, obj);
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

