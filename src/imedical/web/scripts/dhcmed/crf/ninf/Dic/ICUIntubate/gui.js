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
		,fieldLabel : '��ѡ��ҽ�����'
		,valueField : 'Code'
		,editable : false
		,width : 300
		,triggerAction : 'all'
	});
	
	obj.txtObjectID = Common_TextField("txtObjectID","��Ŀ");
	obj.txtObjectDesc = Common_TextField("txtObjectDesc","����");
	obj.txtTarget01 = Common_TextField("txtTarget01","ֵ1");
	obj.txtTarget02 = Common_TextField("txtTarget02","ֵ2");
	obj.txtResume = Common_TextField("txtResume","˵��");
	
	obj.txtArcimAlias = Common_TextField("txtArcimAlias","ҽ������");
	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width : 80
		,text : '����'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width : 80
		,text : 'ɾ��'
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '����'
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
			,{header: '��Ŀ', width: 50, dataIndex: 'ObjectID', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '����', width: 150, dataIndex: 'ObjectDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: 'ֵ1', width: 100, dataIndex: 'Target01', sortable: true, menuDisabled:true, align: 'left'}
			,{header: 'ֵ2', width: 100, dataIndex: 'Target02', sortable: true, menuDisabled:true, align: 'left'}
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
			,{header: 'ҽ������', width: 200, dataIndex: 'ArcimDesc', sortable: true}
			,{header: 'ҽ������', width: 80, dataIndex: 'ARCItemCat', sortable: true}
			,{header: 'ҽ������', width: 60, dataIndex: 'ARCOrderType', sortable: true}
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
				bbar : [obj.btnUpdate,obj.btnDelete,'->','��']
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
				bbar : ['��ʾ����ͨ��ƴ����ͷ���ؼ��ʼ���','->','��']
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

