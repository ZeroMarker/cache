
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.txtDesc1 = Common_TextField("txtDesc1","别名");
	obj.txtPinyin = Common_TextField("txtPinyin","拼音");
	obj.txtSpec = Common_TextField("txtSpec","规格");
	obj.txtUnit = Common_TextField("txtUnit","单位");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.cboGroup = Common_ComboToDic("cboGroup","分类","NINFHandHyProductGrp");
	
	obj.gridHandHyProductsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridHandHyProductsStore = new Ext.data.Store({
		proxy: obj.gridHandHyProductsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HHPID'
		},
		[
			{name: 'HHPID', mapping : 'HHPID'}
			,{name: 'HHPCode', mapping : 'HHPCode'}
			,{name: 'HHPDesc', mapping: 'HHPDesc'}
			,{name: 'HHPDesc1', mapping: 'HHPDesc1'}
			,{name: 'HHPPinyin', mapping: 'HHPPinyin'}
			,{name: 'HHPSpec', mapping: 'HHPSpec'}
			,{name: 'HHPUnit', mapping: 'HHPUnit'}
			,{name: 'HHPActive', mapping: 'HHPActive'}
			,{name: 'HHPActiveDesc', mapping: 'HHPActiveDesc'}
			,{name: 'HHPResume', mapping: 'HHPResume'}
			,{name: 'HHPGroupID', mapping: 'HHPGroupID'}
			,{name: 'HHPGroupDesc', mapping: 'HHPGroupDesc'}
		])
	});
	obj.gridHandHyProducts = new Ext.grid.EditorGridPanel({
		id : 'gridHandHyProducts'
		,store : obj.gridHandHyProductsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'HHPCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'HHPDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '拼音码', width:100, dataIndex: 'HHPPinyin', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '规格', width:100, dataIndex: 'HHPSpec', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width:100, dataIndex: 'HHPUnit', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '分类', width:100, dataIndex: 'HHPGroupDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 60, dataIndex: 'HHPActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '别名', width: 200, dataIndex: 'HHPDesc1', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '备注', width: 200, dataIndex: 'HHPResume', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridHandHyProductsStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
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
						height: 60,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.40
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtPinyin]
									},{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSpec]
									},{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtUnit]
									},{
										columnWidth:.20
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc1]
									},{
										columnWidth:.20
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboGroup]
									},{
										columnWidth:.45
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
							obj.gridHandHyProducts
						]
					}
				],
				bbar : [obj.btnFind,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridHandHyProductsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.HandHyProducts';
		param.QueryName = 'QryHandHyProducts';
		param.Arg1 = Common_GetValue("txtCode");
		param.Arg2 = Common_GetValue("txtDesc");
		param.ArgCnt = 2;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

