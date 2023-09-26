
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.cboRepCat = Common_ComboToDic("cboRepCat","报告分类","NINFReportCateg");
	obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","报告科室","");
	obj.cboRepType = Common_ComboToDic("cboRepType","报告类型","NINFInfReportType");
	obj.txtModuleList = Common_TextField("txtModuleList","模块列表");
	
	obj.gridMapRepMdlStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMapRepMdlStore = new Ext.data.Store({
		proxy: obj.gridMapRepMdlStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
			{name: 'RowID', mapping : 'RowID'}
			,{name: 'RepCatID', mapping : 'RepCatID'}
			,{name: 'RepCatDesc', mapping: 'RepCatDesc'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepTypeID', mapping: 'RepTypeID'}
			,{name: 'RepTypeDesc', mapping: 'RepTypeDesc'}
			,{name: 'ModuleList', mapping: 'ModuleList'}
		])
	});
	obj.gridMapRepMdl = new Ext.grid.EditorGridPanel({
		id : 'gridMapRepMdl'
		,store : obj.gridMapRepMdlStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: 'ID', width: 40, dataIndex: 'RowID', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告分类', width: 150, dataIndex: 'RepCatDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告科室', width: 150, dataIndex: 'RepLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '报告类型', width: 150, dataIndex: 'RepTypeDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '模块列表', width: 300, dataIndex: 'ModuleList', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepCat]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepLoc]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepType]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtModuleList]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridMapRepMdl
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'<b>注:模块列表项目之间以"英文逗号"分割【如未设置,界面以默认设置显示】!</b>','->','…']
			}
		]
	});
	
	obj.gridMapRepMdlStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.MapRepMdl';
		param.QueryName = 'QryMapRepMdl';
		param.ArgCnt = 0;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

