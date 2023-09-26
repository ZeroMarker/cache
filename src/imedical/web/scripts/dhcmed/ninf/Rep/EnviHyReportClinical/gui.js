
function InitViewport1(){
	var obj = new Object();
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	} else {
		obj.AdminPower  = AdminPower;
	}
	
	obj.txtDate = new Ext.form.DateField({
		id : 'txtDate'
		,fieldLabel : '����·�'
		,plugins: 'monthPickerPlugin'
		,editable : false
		,format : 'Y-m'
		,width : 10
		,anchor : '100%'
		,value : new Date().dateFormat('Y-m')
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 70
		,text : '��ѯ'
	});
	obj.btnPBC = new Ext.Button({
		id : 'btnPBC'
		,iconCls : 'icon-export'
		,width: 70
		,text : '��ӡ����'
	});
	obj.btnAdd = new Ext.Toolbar.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,width: 70
		,text : '����'
	});
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 70
		,text : 'ɾ��'
	});
	obj.btnCopy = new Ext.Toolbar.Button({
		id : 'btnCopy'
		,iconCls : 'icon-Edit'
		,width: 70
		,text : '���Ƶ���ǰ��'
	});
	obj.cboLoc = Common_ComboToLoc("cboLoc","�������");
	
	obj.grid_RowEditer_txtItem = Common_ComboToEnviHyItem("grid_RowEditer_txtItem","<b style='color:red'>*</b>�����Ŀ");
	obj.grid_RowEditer_cboNorms = new Ext.form.ComboBox({
		id : 'grid_RowEditer_cboNorms'
		,fieldLabel : "<b style='color:red'>*</b>��ⷶΧ"
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.NINFService.Dic.EnviHyNorms';
						param.QueryName = 'QryEnviHyNormToItem';
						param.Arg1      = Common_GetValue('grid_RowEditer_txtItem')?Common_GetValue('grid_RowEditer_txtItem'):"";
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'ID'
			}, 
			[
				{name: 'ID', mapping: 'ID'}
				,{name: 'EHNRange', mapping: 'EHNRange'}
			])
		})
		,minChars : 0
		,displayField : 'EHNRange'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 10
		,anchor : '100%'
	});
	
	obj.grid_RowEditer_txtItemObj = Common_TextField("grid_RowEditer_txtItemObj","<b style='color:red'>*</b>��Ŀ����");
	obj.grid_RowEditer_txtDate = Common_DateFieldToDate("grid_RowEditer_txtDate","<b style='color:red'>*</b>�������");
	obj.grid_RowEditer_cboSpecimenType = Common_ComboToDic("grid_RowEditer_cboSpecimenType","<b style='color:red'>*</b>�걾����","NINFEnviHySpecimenType");
	obj.grid_RowEditer_txtSpecimenNum = Common_NumberField("grid_RowEditer_txtSpecimenNum","<b style='color:red'>*</b>�걾����"); //Common_TextField
	obj.grid_RowEditer_txtResume = Common_TextArea("grid_RowEditer_txtResume","��ע",50);
	
	obj.gridEnviHyReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEnviHyReportStore = new Ext.data.Store({
		proxy: obj.gridEnviHyReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'},
			{name: 'ItemID', mapping : 'ItemID'},
			{name: 'ItemDesc', mapping : 'ItemDesc'},
			{name: 'EHRBarCode', mapping : 'EHRBarCode'},
			{name: 'NormID', mapping : 'NormID'},
			{name: 'NormRange', mapping : 'NormRange'},
			{name: 'ItemObj', mapping : 'ItemObj'},
			{name: 'EHRDate', mapping : 'EHRDate'},
			{name: 'SpecimenTypeID', mapping : 'SpecimenTypeID'},
			{name: 'SpecimenTypeDesc', mapping : 'SpecimenTypeDesc'},
			{name: 'SpecimenNum', mapping : 'SpecimenNum'},
			{name: 'RepStatusDesc', mapping : 'RepStatusDesc'},
			{name: 'RepResume', mapping : 'RepResume'}
		])
	});
	obj.sm = new Ext.grid.CheckboxSelectionModel({width:25});
	obj.gridEnviHyReport = new Ext.grid.GridPanel({
		id : 'gridEnviHyReport'
		,store : obj.gridEnviHyReportStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,sm :obj.sm
		,columns: [
			obj.sm, 
			new Ext.grid.RowNumberer(),
			{header: '����״̬', width: 150, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '�����Ŀ', width: 300, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '��ⷶΧ', width: 270, dataIndex: 'NormRange', sortable: false, menuDisabled:true, align: 'center'},
			{header: '��Ŀ����', width: 150, dataIndex: 'ItemObj', sortable: false, menuDisabled:true, align: 'center'},
			{header: '�������', width: 150, dataIndex: 'EHRDate', sortable: false, menuDisabled:true, align: 'center'},
			{header: '�걾����', width: 150, dataIndex: 'SpecimenTypeDesc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '�걾����', width: 70, dataIndex: 'SpecimenNum', sortable: false, menuDisabled:true, align: 'center'}
		]
		,tbar : [obj.btnAdd,obj.btnDelete,obj.btnCopy,'->','...']
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridEnviHyReportStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
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
						region: 'north',
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
										,items: [obj.txtDate]
									},{
										width:280
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,boxMinWidth : 200
										,boxMaxWidth : 300
										,items: [obj.cboLoc]
									},{
										width : 10
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnQuery]
									},{
										width : 75
										,layout : 'form'
										,items: [obj.btnPBC]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.gridEnviHyReport
						]
					}
				]
			}
		]
	});
	
	obj.gridEnviHyReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.EnviHyReport';
		param.QueryName = 'QryEnviHyRep';
		param.Arg1 = Common_GetValue('txtDate');
		param.Arg2 = Common_GetValue('cboLoc');
		param.ArgCnt = 2;
	});
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

