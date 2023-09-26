function InitviewScreen(){
	var obj = new Object();
	
	obj.RecRowID = '';
	
	obj.cboCategoryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCategoryStore = new Ext.data.Store({
		proxy: obj.cboCategoryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.cboCategory = new Ext.form.ComboBox({
		id : 'cboCategory'
		,store : obj.cboCategoryStore
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '请选择医嘱类别'
		,valueField : 'Code'
		,editable : false
		,width : 300
		,triggerAction : 'all'
	});
	
	obj.txtObjectID = Common_TextField("txtObjectID","项目");
	obj.txtObjectDesc = Common_TextField("txtObjectDesc","名称");
	obj.txtTarget01 = Common_TextField("txtTarget01","值1");
	obj.txtTarget02 = Common_TextField("txtTarget02","值2");
	obj.txtResume = Common_TextField("txtResume","说明");
	
	obj.txtArcimAlias = Common_TextField("txtArcimAlias","医嘱别名");
	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width : 80
		,text : '查找'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 80
		,text : '删除'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '更新'
	});
	
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Category', mapping: 'Category'}
			,{name: 'ObjectID', mapping: 'ObjectID'}
			,{name: 'ObjectDesc', mapping: 'ObjectDesc'}
			,{name: 'Target01', mapping: 'Target01'}
			,{name: 'Target02', mapping: 'Target02'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
	});
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,columnLines : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '项目', width: 50, dataIndex: 'ObjectID', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '名称', width: 150, dataIndex: 'ObjectDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '值1', width: 100, dataIndex: 'Target01', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '值2', width: 100, dataIndex: 'Target02', sortable: true, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.gridArcimListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridArcimListStore = new Ext.data.Store({
		proxy: obj.gridArcimListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimID'
		}, 
		[
			{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'ArcimCode', mapping: 'ArcimCode'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'ARCItemCat', mapping: 'ARCItemCat'}
			,{name: 'ARCOrderType', mapping: 'ARCOrderType'}
			,{name: 'ARCOrderCat', mapping: 'ARCOrderCat'}
		])
	});
	obj.gridArcimList = new Ext.grid.GridPanel({
		id : 'gridArcimList'
		,region : 'center'
		,store : obj.gridArcimListStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '医嘱名称', width: 200, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '医嘱子类', width: 80, dataIndex: 'ARCItemCat', sortable: true}
			,{header: '医嘱类型', width: 60, dataIndex: 'ARCOrderType', sortable: true}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				layout : 'form',
				labelAlign : 'right',
				labelWidth : 120,
				height : 40,
				frame : true,
				items : [
					obj.cboCategory
				]
			},{
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
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtObjectID]
									},{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtObjectDesc]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtTarget01]
									},{
										columnWidth:.50
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtTarget02]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridResult
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			},{
				region: 'east',
				layout : 'border',
				width : 400,
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
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtArcimAlias]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridArcimList
						]
					}
				],
				bbar : ['提示：可通过拼音字头、关键词检索','->','…']
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINF.Dic.ICUIntubate';
		param.QueryName = 'QryICUIntuByCate';
		param.Arg1 = obj.cboCategory.getValue();
		param.Arg2 = obj.txtObjectID.getValue();
		param.Arg3 = obj.txtObjectDesc.getValue();
		param.ArgCnt = 3;
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QrySSDictionary';
		param.Arg1 = 'NINFDicICUIntubate';
		param.ArgCnt = 1;
	});
	obj.gridArcimListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
			param.QueryName = 'QryArcimByAlias';
			param.Arg1 = obj.txtArcimAlias.getValue();
			param.Arg2 = "";
			param.ArgCnt = 2;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

