function InitViewport(SubCatID){
	
	var obj = new Object();
	obj.CategID=CategID;
	obj.CurrISCRowid="";
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
			,{name: 'KeywordID', mapping: 'KeywordID'}
			,{name: 'KeywordDesc', mapping: 'KeywordDesc'}
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
			,{header: '关键字', width: 100, dataIndex: 'KeywordDesc', sortable: true}
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
	obj.ISCCode = new Ext.form.TextField({
		id : 'ISCCode'
		,fieldLabel : '代码'
		,anchor : '98%'
	});
	obj.ISCDesc = new Ext.form.TextField({
		id : 'ISCDesc'
		,fieldLabel : '描述'
		,anchor : '98%'
	});
	obj.cboISCKeyWordStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboISCKeyWordStore = new Ext.data.Store({
		proxy : obj.cboISCKeyWordStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'rowid'
		}, [{
			name : 'checked',
			mapping : 'checked'
		}, {
			name : 'rowid',
			mapping : 'rowid'
		}, {
			name : 'Description',
			mapping : 'Description'
		}])
	});
	obj.cboISCKeyWordStore.on("load", 
		function(objStore)
		{
			var objRec = new Ext.data.Record(
				{
					checked : false,
					rowid : "",
					Description : "无"
				}
			);
			obj.cboISCKeyWordStore.insert(0, [objRec]);
			obj.cboISCKeyWord.setValue("");
		}
	, obj);

	obj.cboISCKeyWord = new Ext.form.ComboBox({
		id : 'cboISCKeyWord',
		fieldLabel : '关键字',
		width : 50,
		anchor : '98%',
		store : obj.cboISCKeyWordStore,
		mode : 'local',
		selectOnFocus : true,
		forceSelection : true,
		typeAhead : true,
		triggerAction : 'all',
		valueField : 'rowid',
		displayField : 'Description'
	});
			
	obj.cboISCKeyWordStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.CCService.Sys.KeywordSrv';
		param.QueryName = 'QryAll';
		param.ArgCnt = 0;
	});
	obj.cboISCKeyWordStore.load({});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
	});
	obj.ItemSubCatFPanel = new Ext.form.FormPanel({
		id : 'ItemSubCatFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height: 80
		,region : 'south'
		,layout : 'fit'
		,frame : true
		//,title : '监控项目子类维护'
		,items:[
			{
				layout : 'column',
				items : [
					{
						columnWidth:.30
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.ISCCode]
					},{
						columnWidth:.40
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.ISCDesc]
					},{
						columnWidth:.30
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 50
						,items: [obj.cboISCKeyWord]
					}
				]
			}
		]
		,buttons : [
			obj.btnSave
			,obj.btnDelete
		]
	});
	
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.vGridPanel
			,obj.ItemSubCatFPanel
		]
	});
	obj.vGridPanelStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'DHCMed.CCService.Sys.ItemCatSrv';
				param.QueryName = 'QryItemSubCat';
				param.Arg1 = obj.CategID;
				param.ArgCnt = 1;
	});
	obj.vGridPanelStore.load({});
	InitViewportEvent(obj);
	obj.LoadEvent();
	return obj;
}

