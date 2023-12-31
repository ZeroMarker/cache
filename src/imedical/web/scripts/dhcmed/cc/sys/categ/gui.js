function InitViewport(SubjectID){
	var obj = new Object();
	obj.SubjectID=SubjectID;
	obj.CurrICRowid="";
	obj.vGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.vGridPanelStore = new Ext.data.Store({
		proxy: obj.vGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
             ,{name: 'Dep', mapping : 'Dep'} //Add By LiYang 2011-09-19
             ,{name: 'Ward', mapping: 'Ward'}
             ,{name: 'DepID', mapping : 'DepID'} //Add By LiYang 2011-09-19
             ,{name: 'WardID', mapping: 'WardID'}           
		])
	});
	obj.vGridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.vGridPanel = new Ext.grid.GridPanel({
		id : 'vGridPanel'
		,buttonAlign : 'center'
		,store : obj.vGridPanelStore
		,loadMask : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: 'ID', width: 150, dataIndex: 'Rowid', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'Desc', sortable: true}
             ,{header: '科室', width: 100, dataIndex: 'Dep', sortable: true}
             //,{header: '病房', width: 100, dataIndex: 'Ward', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.vGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.ICCode = new Ext.form.TextField({
		id : 'ICCode'
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	obj.ICDesc = new Ext.form.TextField({
		id : 'ICDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
	});

	//Add By LiYang 2011-09-14 增加科室字段
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboDepStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboDepStore = new Ext.data.Store({
		proxy: obj.cboDepStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboDep = new Ext.form.ComboBox({
		id : 'cboDep'
         ,anchor : '95%'
		,store : obj.cboDepStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '科室'
		,valueField : 'CTLocID'
		,triggerAction : 'all'
	});
	
	obj.leftItemCatPanel = new Ext.Panel({
		id : 'leftItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,height : 1
		,items:[]
	});
	obj.centerItemCatPanel = new Ext.Panel({
		id : 'centerItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .5
		,layout : 'form'
		,items:[
			obj.ICCode
			,obj.ICDesc
			,obj.cboDep //Add By LiYang 2011-09-14
		]
	});
	obj.rightItemCatPanel = new Ext.Panel({
		id : 'rightItemCatPanel'
		,buttonAlign : 'center'
		,columnWidth : .25
		,items:[]
	});
	obj.ItemCatPanel = new Ext.Panel({
		id : 'ItemCatPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.leftItemCatPanel
			,obj.centerItemCatPanel
			,obj.rightItemCatPanel
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	obj.ItemCatFPanel = new Ext.form.FormPanel({
		id : 'ItemCatFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,region : 'south'
		,frame : true
		//,title : '监控项目大类维护'
		,height : 150
		,items:[
			obj.ItemCatPanel
		]
		,buttons:[
			obj.btnSave
			,obj.btnDelete
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.vGridPanel
			,obj.ItemCatFPanel
		]
	});
	obj.vGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.ItemCatSrv';
			param.QueryName = 'QryItemCat';
			param.Arg1 = obj.SubjectID;
			param.ArgCnt = 1;
	});
	//Add By LiYang 2011-09-14
	obj.cboDepStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = obj.cboDep.getRawValue();
			param.Arg2 = "E";
			param.Arg3 = "";
			param.ArgCnt = 3;
	});
	obj.vGridPanelStore.load({params : {start:0,limit:20}});
	
	InitViewportEvent(obj);
	obj.LoadEvent();
	return obj;
}

