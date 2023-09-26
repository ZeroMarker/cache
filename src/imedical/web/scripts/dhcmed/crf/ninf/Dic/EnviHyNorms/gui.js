
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.ItemID = ItemID;  //检测项目
	
	obj.cboCateg = Common_ComboToDic("cboCateg","<b style='color:red'>*</b>环境类别","NINFEnviHyNormCategory");
	obj.txtRange = Common_TextField("txtRange","<b style='color:red'>*</b>检测范围");
	obj.txtNorm = Common_TextField("txtNorm","<b style='color:red'>*</b>检测标准");
	obj.txtNormMax = Common_NumberField("txtNormMax","<b style='color:red'>*</b>中心值");
	obj.txtNormMin = Common_NumberField("txtNormMin","<b style='color:red'>*</b>周边值");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.cboSpecimenType = Common_ComboToDic("cboSpecimenType","<b style='color:red'>*</b>标本类型","NINFEnviHySpecimenType");
	obj.txtSpecimenNum = Common_NumberField("txtSpecimenNum","<b style='color:red'>*</b>标本数量");
	obj.txtCenterNum = Common_NumberField("txtCenterNum","<b style='color:red'>*</b>中心个数");
	obj.txtSurroundNum = Common_NumberField("txtSurroundNum","<b style='color:red'>*</b>周边个数");
	obj.txtItemObj = Common_TextField("txtItemObj","<b style='color:red'>*</b>项目对象");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.gridEnviHyNormsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEnviHyNormsStore = new Ext.data.Store({
		proxy: obj.gridEnviHyNormsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[ 
			{name: 'ID', mapping : 'ID'}
			,{name: 'EHNCategID', mapping : 'EHNCategID'}
			,{name: 'EHNCategDesc', mapping : 'EHNCategDesc'}
			,{name: 'EHNRange', mapping: 'EHNRange'}
			,{name: 'EHNNorm', mapping: 'EHNNorm'}
			,{name: 'EHNNormMax', mapping: 'EHNNormMax'}
			,{name: 'EHNNormMin', mapping: 'EHNNormMin'}
			,{name: 'EHNIsActive', mapping: 'EHNIsActive'}
			,{name: 'EHNIsActiveDesc', mapping: 'EHNIsActiveDesc'}
			,{name: 'EHNResume', mapping: 'EHNResume'}
			,{name: 'SpecimenTypeID', mapping: 'SpecimenTypeID'}
			,{name: 'SpecimenTypeDesc', mapping: 'SpecimenTypeDesc'}
			,{name: 'SpecimenNum', mapping: 'SpecimenNum'}
			,{name: 'CenterNum', mapping: 'CenterNum'}
			,{name: 'SurroundNum', mapping: 'SurroundNum'}
			,{name: 'ItemObj', mapping: 'ItemObj'}
		])
	});
	obj.gridEnviHyNorms = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyNorms'
		,store : obj.gridEnviHyNormsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '环境类别', width: 10, dataIndex: 'EHNCategDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '检测范围', width: 30, dataIndex: 'EHNRange', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '检测标准', width: 20, dataIndex: 'EHNNorm', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '中心值', width: 10, dataIndex: 'EHNNormMax', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '周边值', width: 10, dataIndex: 'EHNNormMin', sortable: false, menuDisabled:true, align: 'center'}			
			,{header: '标本类型', width: 10, dataIndex: 'SpecimenTypeDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '标本数量', width: 10, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '中心个数', width: 10, dataIndex: 'CenterNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '周边个数', width: 10, dataIndex: 'SurroundNum', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '项目对象', width: 20, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 10, dataIndex: 'EHNIsActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 20, dataIndex: 'EHNResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,width: 80
		,text : '保存'
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
						height: 65,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboCateg]
									},{
										columnWidth:.48
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtRange]
									},{
										columnWidth:.48
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtNorm]
									},{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.cboSpecimenType]
									},{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtItemObj]
									},{
										width : 100
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
										width : 110
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtNormMax]
									},{
										width : 100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtNormMin]
									},{
										width : 110
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtSpecimenNum]
									},{
										width : 110
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtCenterNum]
									},{
										width : 110
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtSurroundNum]
									},{
										columnWidth:.95
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
						items : [
							obj.gridEnviHyNorms
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridEnviHyNormsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.EnviHyNorms';
		param.QueryName = 'QryEnviHyNorms';
		param.Arg1 = obj.ItemID;
		param.ArgCnt = 1;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

