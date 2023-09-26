function VoucherStatusQuery(smRowid) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	

	var DetailInfoStore = new Ext.data.JsonStore({
    	autoDestroy: true,
    	url: DictUrl+'stkmonaction.csp?actiontype=VoucherStatusDetail&start=0&limit=20',
    	root: 'rows',
    	idProperty: 'VCHRowId',
    	fields: ['VCHRowId','VCHVoucherType', 'VCHDate', 'VCHTime', 'VCHSSUSRDR','VCHStatus','VCHRdemark']
    });

	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "VCHRowId",
				dataIndex : 'VCHRowId',
				width : 90,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "状态",
				dataIndex : 'VCHStatus',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "操作人",
				dataIndex : 'VCHSSUSRDR',
				width : 90,
				align : 'left',
				sortable : true
			},  {
				header : '日期',
				dataIndex : 'VCHDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "时间",
				dataIndex : 'VCHTime',
				width : 90,
				align : 'left',
				sortable : true
			},{
				header : "类型",
				dataIndex : 'VCHVoucherType',
				width : 90,
				align : 'left',
				sortable : true
			},  {
				header : "备注",
				dataIndex : 'VCHRdemark',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	DetailInfoCm.defaultSortable = true;
	var DetailInfoGrid = new Ext.ux.GridPanel({
				id:'DetailInfoGrid',
				title : '',
				cm : DetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : DetailInfoStore
			});
	
	var window = new Ext.Window({
				title : '凭证记录',
				width : 600,
				height : 400,
				layout:'fit',
				items : [DetailInfoGrid]
			});
	DetailInfoStore.load({params:{smRowid:smRowid}});
	window.show();
	
}