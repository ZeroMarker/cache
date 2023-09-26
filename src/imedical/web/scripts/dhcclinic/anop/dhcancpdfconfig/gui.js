function InitViewScreen()
{ 
	var obj = new Object();
	obj.FTPSrvIP = new Ext.form.TextField({
		id : 'FTPSrvIP'
		,fieldLabel : '服务器IP'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.FTPSrvPortNo = new Ext.form.TextField({
		id : 'FTPSrvPortNo'
		,fieldLabel : '端口号'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.FTPSrvIP
			,obj.FTPSrvPortNo
		]
	});
	obj.FTPSrvUserName = new Ext.form.TextField({
		id : 'FTPSrvUserName'
		,fieldLabel : '用户名'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.FTPSrvUserCode = new Ext.form.TextField({
		id : 'FTPSrvUserCode'
		,fieldLabel : '密码'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.FTPSrvUserName
			,obj.FTPSrvUserCode
		]
	});
	var data=[
		['I','DHCICU']
	]
	obj.FTPFolderNameStoreProxy=data;
	obj.FTPFolderNameStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.FTPFolderName = new Ext.form.ComboBox({
		id : 'FTPFolderName'
		,minChars : 1
		,fieldLabel : '文件夹名'
		,labelSeparator: ''
		,triggerAction : 'all'
		,store : obj.FTPFolderNameStore
		,displayField : 'desc'
		,valueField : 'code'
		,editable:false
		,anchor : '95%'
	});
	obj.FTPRowId = new Ext.form.TextField({
		id : 'FTPRowId'
		,fieldLabel : ''
		,labelSeparator: ''
		,hidden : true
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,columnWidth : .2
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.FTPFolderName
			,obj.FTPRowId
		]
	});
	obj.SaveButton = new Ext.Button({
		id : 'SaveButton'
		,width:86
		,text : '保存'
		,iconCls : 'icon-save'
	});
	obj.SaveButtonPanel = new Ext.Panel({
		id : 'SaveButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		    obj.SaveButton
		]
	});
	obj.DeleteButton = new Ext.Button({
		id : 'DeleteButton'
		,width:86
		,text : '删除'
		,iconCls : 'icon-delete'
	});
	obj.DeleteButtonPanel = new Ext.Panel({
		id : 'DeleteButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .25
		,layout : 'form'
		,items:[
		    obj.DeleteButton
		]
	});
	obj.fPanel = new Ext.Panel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,region : 'north'
		,layout : 'column'
		,iconCls:'icon-result'
		,title : 'FTP服务器配置'
		,height:90
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.SaveButtonPanel
			,obj.DeleteButtonPanel
		]
	});
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
	    [
			{name: 'Id', mapping : 'Id'}
			,{name: 'FTPSrvIP', mapping : 'FTPSrvIP'}
			,{name: 'FTPSrvPortNo', mapping : 'FTPSrvPortNo'}
			,{name: 'FTPSrvUserName', mapping : 'FTPSrvUserName'}
			,{name: 'FTPSrvUserCode', mapping : 'FTPSrvUserCode'}
			,{name: 'FTPFolderName', mapping: 'FTPFolderName'}
			,{name: 'FTPType', mapping: 'FTPType'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,clicksToEdit:1
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '系统号', width: 50, dataIndex: 'Id', sortable: true}
		,{header: '服务器IP', width: 200, dataIndex: 'FTPSrvIP', sortable: true}
		,{header: '端口号', width: 100, dataIndex: 'FTPSrvPortNo', sortable: true}
		,{header: '用户名', width: 100, dataIndex: 'FTPSrvUserName', sortable: true}
		,{header: '密码', width: 100, dataIndex: 'FTPSrvUserCode', sortable: true}
		,{header: '文件夹名', width: 100, dataIndex: 'FTPFolderName', sortable: true}
		,{header: '文件类型', width:100, dataIndex: 'FTPType', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : false
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,frame: true
		,items:[
			obj.fPanel
			,obj.resultPanel
		]
	});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCPDFConfig';
		param.QueryName = 'FindPDFConfig';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.SaveButton.on("click", obj.SaveButton_click, obj);
	obj.DeleteButton.on("click", obj.DeleteButton_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}