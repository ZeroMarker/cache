function InitViewport(){
	var obj = new Object();
	obj.SubjectStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectStore = new Ext.data.Store({
		proxy: obj.SubjectStoreProxy,
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
			,{name: 'Categroy', mapping: 'Categroy'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.SubjectCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.Subject = new Ext.grid.GridPanel({
		id : 'Subject'
		,store : obj.SubjectStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 150, dataIndex: 'rowid', sortable: true}
			,{header: '名称', width: 150, dataIndex: 'Title', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 200, dataIndex: 'Desc', sortable: true}
			,{header: '是否有效', width: 80, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '主题类别', width: 150, dataIndex: 'Categroy', sortable: true}
			,{header: '表达式', width: 200, dataIndex: 'Expression', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'ResumeText', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.SubjectStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.CenterFPanel = new Ext.form.FormPanel({
		id : 'CenterFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'border'
		,items:[
			obj.Subject
		]
	});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,items:[
		]
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
	obj.ResumeText = new Ext.form.TextField({
		id : 'ResumeText'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.LeftCenterPanel = new Ext.Panel({
		id : 'LeftCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.Title
			,obj.Code
			,obj.Desc
			,obj.ResumeText
		]
	});
	obj.IsActive = new Ext.form.Checkbox({
		id : 'IsActive'
		,checked : true
		,fieldLabel : '是否有效'
		,anchor : '95%'
});
	obj.Categroy = new Ext.form.TextField({
		id : 'Categroy'
		,fieldLabel : '主题类别'
		,anchor : '95%'
});
	obj.Expression = new Ext.form.TextField({
		id : 'Expression'
		,fieldLabel : '表达式'
		,anchor : '95%'
});
	obj.rowid = new Ext.form.TextField({
		id : 'rowid'
		,hidden : true
		,anchor : '95%'
});
	obj.RightCenterPanel = new Ext.Panel({
		id : 'RightCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.IsActive
			,obj.Categroy
			,obj.Expression
			,obj.rowid
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
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
	obj.btnItem = new Ext.Button({
		id : 'btnItem'
		,iconCls : 'icon-add'
		,anchor : '95%'
		,text : '监控项目'
});
	obj.btnConfig = new Ext.Button({
		id : 'btnConfig'
		,iconCls : 'icon-add'
		,anchor : '95%'
		,text : '初始化配置'
});
	obj.btnColor = new Ext.Button({
		id : 'btnColor'
		,iconCls : 'icon-add'
		,anchor : '95%'
		,text : '主题颜色'
});
	obj.southFPanel = new Ext.form.FormPanel({
		id : 'southFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 180
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.LeftCenterPanel
			,obj.RightCenterPanel
			,obj.RightPanel
		]
	,	buttons:[
			obj.btnFind
			,obj.btnUpdate
			,obj.btnItem
			,obj.btnConfig
			,obj.btnColor
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
	obj.SubjectStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QuerySubjectInfo';
			param.Arg1 = obj.Title.getValue();
			param.ArgCnt = 1;
	});
	obj.SubjectStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitViewportEvent(obj);
	//事件处理代码
	obj.Subject.on("rowclick", obj.Subject_rowclick, obj);
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.btnUpdate.on("click", obj.btnUpdate_click, obj);
	obj.btnConfig.on("click", obj.btnConfig_click, obj);
	obj.btnItem.on("click", obj.btnItem_click, obj);
	obj.btnColor.on("click", obj.btnColor_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitSubjectItm(){
	Ext.QuickTips.init();
	var obj = new Object();
	obj.SubjectItmListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectItmListStore = new Ext.data.Store({
		proxy: obj.SubjectItmListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'ItemDic', mapping: 'ItemDic'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'MultiTimes', mapping: 'MultiTimes'}
			,{name: 'MultiTimesDesc', mapping: 'MultiTimesDesc'}
		])
	});
	obj.SubjectItmListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SubjectItmList = new Ext.grid.GridPanel({
		id : 'SubjectItmList'
		,store : obj.SubjectItmListStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 60, dataIndex: 'Code', sortable: true}
			,{header: '项目字典', width: 120, dataIndex: 'IDDesc', sortable: true}
			,{header: '分数', width: 40, dataIndex: 'Score', sortable: true}
			,{header: '有效', width: 80, dataIndex: 'IsActiveDesc', sortable: true}
			,{header: '重复计分', width: 80, dataIndex: 'MultiTimesDesc', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'ResumeText', sortable: true}
		]});
	obj.CenterItmFPanel = new Ext.form.FormPanel({
		id : 'CenterItmFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'border'
		,items:[
			obj.SubjectItmList
		]
	});
	obj.LeftItmPanel = new Ext.Panel({
		id : 'LeftItmPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.ItmCode = new Ext.form.TextField({
		id : 'ItmCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.ItmScore = new Ext.form.TextField({
		id : 'ItmScore'
		,fieldLabel : '分数'
		,anchor : '95%'
});
	obj.ItmResumeText = new Ext.form.TextField({
		id : 'ItmResumeText'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.SubjectItmID = new Ext.form.TextField({
		id : 'SubjectItmID'
		,hidden : true
		,anchor : '95%'
});
	obj.LeftCenterItmPanel = new Ext.Panel({
		id : 'LeftCenterItmPanel'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.ItmCode
			,obj.ItmScore
			,obj.ItmResumeText
			,obj.SubjectItmID
		]
	});
	obj.ItemDic = new Ext.form.TextField({
		id : 'ItemDic'
		,fieldLabel : '字典项'
		,anchor : '95%'
		,disabled : true
});
	obj.ItmIsActive = new Ext.form.Checkbox({
		id : 'ItmIsActive'
		,checked : true
		,fieldLabel : '是否有效'
		,anchor : '95%'
});
obj.MultiTimes = new Ext.form.Checkbox({
		id : 'MultiTimes'
		,checked : false
		,fieldLabel : '重复计分'
		,anchor : '95%'
});
	obj.ItmRowid = new Ext.form.TextField({
		id : 'ItmRowid'
		,hidden : true
		,anchor : '95%'
});
	obj.ItemDicID = new Ext.form.TextField({
		id : 'ItemDicID'
		,hidden : true
		,anchor : '95%'
});
	obj.RightCenterItmPanel = new Ext.Panel({
		id : 'RightCenterItmPanel'
		,buttonAlign : 'center'
		,columnWidth : .45
		,layout : 'form'
		,items:[
			obj.ItemDic
			,obj.ItmIsActive
			,obj.MultiTimes
			,obj.ItmRowid
			,obj.ItemDicID
		]
	});
	obj.RightItmPanel = new Ext.Panel({
		id : 'RightItmPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.ItmBtnFind = new Ext.Button({
		id : 'ItmBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.ItmBtnUpdate = new Ext.Button({
		id : 'ItmBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.ItmBtnExit = new Ext.Button({
		id : 'ItmBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.SouthItmFPanel = new Ext.FormPanel({
		id : 'SouthItmFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 150
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftItmPanel
			,obj.LeftCenterItmPanel
			,obj.RightCenterItmPanel
			,obj.RightItmPanel
		]
	,	buttons:[
			obj.ItmBtnFind
			,obj.ItmBtnUpdate
			,obj.ItmBtnExit
		]
	});
	obj.CenterInsertPanel = new Ext.Panel({
		id : 'CenterInsertPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'border'
		,items:[
				obj.CenterItmFPanel
				,obj.SouthItmFPanel
		]
	});
	obj.LeftInsItmPanel = new Ext.Panel({
		id : 'LeftInsItmPanel'
    		,columnWidth : .5
    		,height : 442
    		,split:true
    		//,collapsible:true   //自动收缩按钮 
    		,border:true
    		//,width:300
			,layout:"accordion"
    		//extraCls:"roomtypegridbbar",
				//iconCls:'icon-feed', 
     		//添加动画效果
    		,layoutConfig: {animate: true}
		,items:[
		]
	});
	obj.treePMsTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter : 'Arg1',
			dataUrl : "dhcmed.cc.loaditemcat.csp",
			baseParams : {
				subjectID:"0"
			}			
		});
	obj.treePMs = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,title:'监控项目'
		,region : 'center'
		,width:300
		,height : 468
		,rootVisible:false
		,autoScroll:true
		,loader : null //obj.treePMsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});

	obj.SubjectItmCatListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectItmCatListStore = new Ext.data.Store({
		proxy: obj.SubjectItmCatListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'Range', mapping: 'Range'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.SubjectItmCatListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SubjectItmCatList = new Ext.grid.GridPanel({
		id : 'SubjectItmCatList'
		,store : obj.SubjectItmCatListStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			{header: '描述', width: 100, dataIndex: 'Desc', sortable: true}
			,{header: '表达式', width: 140, dataIndex: 'Expression', sortable: true}
		]});
	obj.RightInsItmPanel = new Ext.Panel({
		id : 'RightInsItmPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,title : '项目字典'
		,layout : 'border'
		,height : 500
		,items:[
				obj.SubjectItmCatList
		]
	});
	obj.RightInsertPanel = new Ext.Panel({
		id : 'RightInsertPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'east'
		,collapsible : true
		,collapsed : true
		,labelAlign : 'right'
		,layout : 'column'
		,width : 400
		,items:[
			obj.LeftInsItmPanel
			,obj.RightInsItmPanel
		]
	});
	obj.TreePanel = new Ext.Panel({
		id : 'TreePanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'west'
		,labelAlign : 'right'
		,layout : 'column'
		,width : 200
		,items:[
		obj.treePMs
		]
	});
 
	obj.SubjectItm = new Ext.Window({
		id : 'SubjectItm'
		,layout : 'border'
		,height : 500
		,buttonAlign : 'center'
		,width : 800
		,modal : true
		,title : '监控项目'
		,closable : true
		,items:[
			obj.CenterInsertPanel
			,obj.TreePanel
		]
	});
	obj.SubjectItmListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QuerySubjectItmInfo';
			param.Arg1 = obj.SubjectItmID.getValue();
			param.ArgCnt = 1;
	});
	obj.SubjectItmCatListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QueryItemDicInfo';
			param.Arg1 = obj.NodeID;
			param.ArgCnt = 1;
	});
	obj.SubjectItmListStore.load({});
	InitSubjectItmEvent(obj);
	//事件处理代码
	obj.SubjectItmList.on("rowclick", obj.SubjectItmList_rowclick, obj);
	obj.ItmBtnFind.on("click", obj.ItmBtnFind_click, obj);
	obj.ItmBtnUpdate.on("click", obj.ItmBtnUpdate_click, obj);
	obj.ItmBtnExit.on("click", obj.ItmBtnExit_click, obj);
	obj.SubjectItmCatList.on("rowclick",obj.SubjectItmCatList_rowclick,obj);
	obj.treePMs.on("click", obj.treePMs_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitSubjectVMStartConfig(){
	var obj = new Object();
	obj.SubjectVMSConfigStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.SubjectVMSConfigStore = new Ext.data.Store({
		proxy: obj.SubjectVMSConfigStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'StartIndex', mapping: 'StartIndex'}
			,{name: 'Expression', mapping: 'Expression'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'RunType', mapping: 'RunType'}
			,{name: 'VarName', mapping: 'VarName'}
		])
	});
	obj.SubjectVMSConfigCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.SubjectVMSConfig = new Ext.grid.GridPanel({
		id : 'SubjectVMSConfig'
		,store : obj.SubjectVMSConfigStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'Desc', sortable: true}
			,{header: '加载顺序', width: 80, dataIndex: 'StartIndex', sortable: true}
			,{header: '表达式', width: 150, dataIndex: 'Expression', sortable: true}
			,{header: '运行类型', width: 80, dataIndex: 'RunType', sortable: true}
			,{header: 'VM变量名', width: 150, dataIndex: 'VarName', sortable: true}
			,{header: '备注', width: 150, dataIndex: 'ResumeText', sortable: true}
			,{header: '是否有效', width: 80, dataIndex: 'IsActiveDesc', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.SubjectVMSConfigStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.ConCenterFPanel = new Ext.form.FormPanel({
		id : 'ConCenterFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,layout : 'border'
		,anchor : '95%'
		,region : 'center'
		,items:[
			obj.SubjectVMSConfig
		]
	});
	obj.ConLeftPanel = new Ext.Panel({
		id : 'ConLeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.ConCode = new Ext.form.TextField({
		id : 'ConCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.ConDesc = new Ext.form.TextField({
		id : 'ConDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});
	obj.ConStartIndex = new Ext.form.NumberField({
		id : 'ConStartIndex'
		,fieldLabel : '加载顺序'
		,anchor : '95%'
});
	obj.ConIsActive = new Ext.form.Checkbox({
		id : 'ConIsActive'
		,fieldLabel : '是否有效'
		,anchor : '95%'
		,checked : true
});
	obj.ConSubID = new Ext.form.TextField({
		id : 'ConSubID'
		,hidden : true
		,anchor : '95%'
});
	obj.ConLeftCenterPanel = new Ext.Panel({
		id : 'ConLeftCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ConCode
			,obj.ConDesc
			,obj.ConStartIndex
			,obj.ConIsActive
			,obj.ConSubID
		]
	});
	obj.ConExpression = new Ext.form.TextField({
		id : 'ConExpression'
		,fieldLabel : '表达式'
		,anchor : '95%'
});
	obj.ConRunTypeStore = new Ext.data.SimpleStore({
		fields : ['ConRunTypeDesc','ConRunTypeCode'],
		data : 
		[['S','S'],['L','L']]
	});
	obj.ConRunType = new Ext.form.ComboBox({
		id : 'ConRunType'
		,store : obj.ConRunTypeStore
		,displayField : 'ConRunTypeDesc'
		,fieldLabel : '运行类型'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'ConRunTypeCode'
		,mode: 'local'
});
	obj.ConVarName = new Ext.form.TextField({
		id : 'ConVarName'
		,fieldLabel : 'VM变量名'
		,anchor : '95%'
});
	obj.ConResumeText = new Ext.form.TextField({
		id : 'ConResumeText'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.ConID = new Ext.form.TextField({
		id : 'ConID'
		,hidden : true
		,anchor : '95%'
});
	obj.ConRightCenterPanel = new Ext.Panel({
		id : 'ConRightCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.ConExpression
			,obj.ConRunType
			,obj.ConVarName
			,obj.ConResumeText
			,obj.ConID
		]
	});
	obj.ConRightPanel = new Ext.Panel({
		id : 'ConRightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.ConBtnFind = new Ext.Button({
		id : 'ConBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.ConBtnUpdate = new Ext.Button({
		id : 'ConBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.ConBtnExit = new Ext.Button({
		id : 'ConBtnExit'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
});
	obj.ConSouthFPanel = new Ext.form.FormPanel({
		id : 'ConSouthFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 170
		,region : 'south'
		,layout : 'column'
		,frame : true
		,items:[
			obj.ConLeftPanel
			,obj.ConLeftCenterPanel
			,obj.ConRightCenterPanel
			,obj.ConRightPanel
		]
	,	buttons:[
			obj.ConBtnFind
			,obj.ConBtnUpdate
			,obj.ConBtnExit
		]
	});
	obj.SubjectVMStartConfig = new Ext.Window({
		id : 'SubjectVMStartConfig'
		,height : 500
		,buttonAlign : 'center'
		,width : 700
		,closable : false
		,title : '初始化配置'
		,modal : true
		,layout : 'border'
		,items:[
			obj.ConCenterFPanel
			,obj.ConSouthFPanel
		]
	});
	obj.SubjectVMSConfigStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QuerySubjectVMSConfig';
			param.Arg1 = obj.ConSubID.getValue();
			param.ArgCnt = 1;
	});
	obj.SubjectVMSConfigStore.load({
	params : {
		start:0
		,limit:20
	}});

	InitSubjectVMStartConfigEvent(obj);
	//事件处理代码
	obj.SubjectVMSConfig.on("rowclick", obj.SubjectVMSConfig_rowclick, obj);
	obj.ConBtnFind.on("click", obj.ConBtnFind_click, obj);
	obj.ConBtnUpdate.on("click", obj.ConBtnUpdate_click, obj);
	obj.ConBtnExit.on("click", obj.ConBtnExit_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}
function InitColor(){
	var obj = new Object();
	obj.ColorListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ColorListStore = new Ext.data.Store({
		proxy: obj.ColorListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'SubjectDr', mapping: 'SubjectDr'}
			,{name: 'Score', mapping: 'Score'}
			,{name: 'ColorRGB', mapping: 'ColorRGB'}
		])
	});
	obj.ColorListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ColorList = new Ext.grid.GridPanel({
		id : 'ColorList'
		,store : obj.ColorListStore
		,buttonAlign : 'center'
		,width : 177
		,height : 368
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '分数', width: 50, dataIndex: 'Score', sortable: true}
			,{header: '颜色', width: 100, dataIndex: 'ColorRGB', sortable: true}
		]});
	obj.LeftPanel = new Ext.Panel({
		id : 'cLeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.Score = new Ext.form.NumberField({
		id : 'Score'
		,fieldLabel : '分数'
		,anchor : '95%'
});
	obj.txtVCColour = new Ext.form.TextField({
		id : 'txtVCColour'
		,fieldLabel : '颜色'
		,value : '███  测试颜色'
		,readOnly : true
		,width : 190
	});
	obj.ColorID = new Ext.form.TextField({
		id : 'ColorID'
		,anchor : '95%'
		,hidden : true
	});
	obj.ColorPicker = new Ext.ColorPalette({
			id : 'ColorPicker'
			,fieldLabel : '调色板'
			,width : 500
	});
	obj.ColorPicker.colors =  
			   ["000000","000033","000066","000099","0000CC","0000FF","330000","330033","330066","330099","3300CC",
				"3300FF","660000","660033","660066","660099","6600CC","6600FF","990000","990033","990066","990099",
				"9900CC","9900FF","CC0000","CC0033","CC0066","CC0099","CC00CC","CC00FF","FF0000","FF0033","FF0066",
				"FF0099","FF00CC","FF00FF","003300","003333","003366","003399","0033CC","0033FF","333300","333333",
				"333366","333399","3333CC","3333FF","663300","663333","663366","663399","6633CC","6633FF","993300",
				"993333"];
	obj.cboColor = new Ext.form.ComboBox({
	    triggerAction: 'all',
	    mode: 'local',
	    listWidth : 120,
	    width : 18,
	    editable : false,
	    store: new Ext.data.ArrayStore({
	        id: 0,
	        fields: [
	            'myId',
	            'displayText'
	        ],
	        data: [['#000000', '000000'], ['#000033', '000033'],['#000066', '000066']
	              ,['#000099', '000099'], ['#0000CC', '0000CC'],['#0000FF', '0000FF']
	              ,['#330000', '330000'], ['#330033', '330033'],['#330066', '330066']
	              ,['#330099', '330099'], ['#3300CC', '3300CC'],['#3300FF', '3300FF']
	              ,['#660000', '660000'], ['#660033', '660033'],['#660066', '660066']
	              ,['#CC0099', 'CC0099'], ['#CC00CC', 'CC00CC'],['#CC00FF', 'CC00FF']
	              ,['#FF0000', 'FF0000'], ['#FF0033', 'FF0033'],['#FF0066', 'FF0066']
	        ]
	    }),
	    valueField: 'myId',
	    displayField: 'displayText',
	    hideParent:true
	});

        obj.cboMarkColorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboMarkColorStore = new Ext.data.Store({
		proxy: obj.cboMarkColorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ColorNumber'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ColorNumber', mapping: 'ColorNumber'}
			,{name: 'ColorName', mapping: 'ColorName'}
		])
	});
	obj.cboMarkColor = new Ext.form.ComboBox({
		id : 'cboMarkColor'
		,width : 18
		,store : obj.cboMarkColorStore
		,minChars : 1
		,displayField : 'ColorName'
		,valueField : 'ColorNumber'
		,editable : false
		,triggerAction : 'all'
		,hideParent : true
		,listWidth : 120
});
obj.cboMarkColorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.IMP.ColorTable';
			param.QueryName = 'QueryColor';
			param.ArgCnt = 0;
	});
	obj.cboMarkColorStore.load({});
	obj.SubjectID = new Ext.form.TextField({
		id : 'SubjectID'
		,anchor : '95%'
		,hidden : true
});
        obj.Panel15 = new Ext.Panel({
		id : 'Panel15'
		,buttonAlign : 'center'
		,columnWidth : 0.9
		,layout : 'form'
		,items:[
			obj.txtVCColour
		]
	});
	obj.Panel16 = new Ext.Panel({
		id : 'Panel16'
		,buttonAlign : 'center'
		,columnWidth : 0.1
		,items:[
			obj.cboMarkColor
		]
	});
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.Panel15
			,obj.Panel16
		]
	});
	obj.CenterPanel = new Ext.Panel({
		id : 'cLeftCenPanel'
		,buttonAlign : 'center'
		,columnWidth : .8
		,labelWidth : 80
		,layout : 'form'
		,items:[
			obj.Score
			,obj.Panel14
			,obj.SubjectID
			,obj.ColorID
			//,obj.ColorPicker
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'cRightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.cBtnUpdate = new Ext.Button({
		id : 'cBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.cBtnDelete = new Ext.Button({
		id : 'cBtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.ColorPanel = new Ext.form.FormPanel({
		id : 'ColorPanel'
		,width : '400'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'east'
		,layout : 'column'
		,frame : true
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	,	buttons:[
			obj.cBtnUpdate
			,obj.cBtnDelete
		]
	});
	obj.Color = new Ext.Window({
		id : 'Color'
		,height : 400
		,buttonAlign : 'center'
		,width : 591
		,title : '监控主题颜色维护'
		,layout : 'border'
		,modal : true
		,items:[
			obj.ColorList
			,obj.ColorPanel
		]
	});
	obj.ColorListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.SubjectSrv';
			param.QueryName = 'QrySubColorByID';
			param.Arg1 = obj.SubjectID.getValue();
			param.ArgCnt = 1;
	});
	obj.ColorListStore.load({});
	InitColorEvent(obj);
	//事件处理代码
	obj.cBtnUpdate.on("click", obj.cBtnUpdate_click, obj);
	obj.cBtnDelete.on("click", obj.cBtnDelete_click, obj);
	obj.cboMarkColor.on("beforeselect", obj.cboMarkColor_beforeselect, obj);
	obj.ColorList.on("rowclick",obj.ColorList_rowclick,obj);
  obj.LoadEvent(arguments);
  return obj;
}


