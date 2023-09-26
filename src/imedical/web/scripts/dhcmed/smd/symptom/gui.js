
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.cboMsCate = Common_ComboToDic("cboMsCate","症状归类","SMDSymptom");
	obj.IsActive  = Common_Checkbox("IsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.gridMentalSymStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMentalSymStore = new Ext.data.Store({
		proxy: obj.gridMentalSymStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		},
		[
			{name: 'RowID', mapping : 'RowID'}
			,{name: 'Code', mapping : 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'CateID', mapping: 'CateID'}
			,{name: 'CateDesc', mapping: 'CateDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridMentalSym = new Ext.grid.EditorGridPanel({
		id : 'gridMentalSym'
		,store : obj.gridMentalSymStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 80, dataIndex: 'Code', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 150, dataIndex: 'Desc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '症状分类', width:150, dataIndex: 'CateDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width:150, dataIndex: 'IsActive', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		},bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridMentalSymStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
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
						height: 40,
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
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth:.2
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboMsCate]
									},{
										columnWidth:.1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.IsActive]
									},{
										columnWidth:.35
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
							obj.gridMentalSym
						]
					}
				],
				bbar : [obj.btnQuery,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridMentalSymStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SMD.Symptom';
		param.QueryName = 'QryMentalSym';
		param.Arg1	 = obj.txtCode.getValue();
		param.Arg2	 = obj.txtDesc.getValue();
		param.Arg3	 = obj.cboMsCate.getValue();
		param.ArgCnt = 3;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

