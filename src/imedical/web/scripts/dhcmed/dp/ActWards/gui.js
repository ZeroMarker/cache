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
		,fieldLabel : '请选择常用短语类别'
		,valueField : 'Code'
		,editable : false
		,width : 200
		,triggerAction : 'all'
	});
	
	obj.txtWord = Common_TextField("txtWord","常用短语");
	obj.cbgActType = Common_RadioGroupToDic("cbgActType","属性","DPDicWordProperty",2);
	obj.txtText1 = Common_TextField("txtText1","值1");
	obj.txtText2 = Common_TextField("txtText2","值2");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","说明");
	
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
	obj.gridResultStore = new Ext.data.GroupingStore({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Category', mapping: 'Category'}
			,{name: 'CategoryDesc', mapping: 'CategoryDesc'}
			,{name: 'Words', mapping: 'Words'}
			,{name: 'ActType', mapping: 'ActType'}
			,{name: 'ActTypeDesc', mapping: 'ActTypeDesc'}
			,{name: 'Text1', mapping: 'Text1'}
			,{name: 'Text2', mapping: 'Text2'}
			,{name: 'Text3', mapping: 'Text3'}
			,{name: 'Text4', mapping: 'Text4'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
		])
		,sortInfo:{field: 'ID', direction: "ASC"}
		,groupField:'ActTypeDesc'
	});
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,columnLines : true
		,loadMask : true
		,buttonAlign : 'center'
		,columnLines : true
		,region : 'center'
		,tbar : new Ext.Toolbar({
			items: [
				new Ext.form.Label({text : '请选择常用短语类别'}),
				obj.cboCategory
			]
		})
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '常用短语', width: 200, dataIndex: 'Words', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '属性', width: 150, dataIndex: 'ActTypeDesc', sortable: true, menuDisabled:true, hidden:true, align: 'center'}
			,{header: '值1', width: 200, dataIndex: 'Text1', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '值2', width: 200, dataIndex: 'Text2', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IsActiveDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 300, dataIndex: 'ResumeText', sortable: true, menuDisabled:true, align: 'left'}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '按属性归类 : {[values.rs[0].get("ActTypeDesc")]}',
			groupByText:'依本列分组'
		})
	});
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
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
										width:240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtWord]
									},{
										width:160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cbgActType]
									},{
										columnWidth : .20
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtText1]
									},{
										columnWidth : .20
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtText2]
									},{
										width:100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									},{
										columnWidth : .60
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
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
			}
		]
	});
	
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.DPService.Base.ActWards';
		param.QueryName = 'QryActWards';
		param.Arg1 = obj.cboCategory.getValue();
		param.Arg2 = '';
		param.ArgCnt = 2;
	});
	obj.cboCategoryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QrySSDictionary';
		param.Arg1 = 'DPDicWordCategory';
		param.ArgCnt = 1;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

