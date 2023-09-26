/**
 * 查询界面
 */
function HVBarcodeQuery(Incil,IncDesc) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
	// 3关闭按钮
	var HVBarCodecloseBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					HVBarcodeWin.close();
				}
			});
	
	// 显示库存项对应的在用高值条码
	function getHVBarcode(Incil) {
		if (Incil == null || Incil=="") {
			return;
		}
		HVBarCodeInfoStore.setBaseParam('incil',Incil);
		var pagingSize=HVBarCodePagingToolbar.pageSize;
		HVBarCodeInfoStore.load({params:{start:0,limit:pagingSize}})
	}

	// 访问路径
	var MasterInfoUrl = DictUrl + "itmtrackaction.csp?actiontype=GetEnableBarcodes";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["dhcit", "HVBarCode", "BatchNo", "ExpDate", "IngrDate",
		"InciCode", "InciDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "dhcit",
				fields : fields
			});
	// 数据集
	var HVBarCodeInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var HVBarCodeInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "条码ID",
				dataIndex : 'dhcit',
				width : 60,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "条码",
				dataIndex : 'HVBarCode',
				width : 220,
				align : 'left',
				sortable : true,
				editable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField())
			}, {
				header : "批号",
				dataIndex : 'BatchNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "效期",
				dataIndex : 'ExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "入库日期",
				dataIndex : 'IngrDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "物资代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "物资名称",
				dataIndex : 'InciDesc',
				width : 80,
				align : 'left',
				sortable : true
			}
		]);
	HVBarCodeInfoCm.defaultSortable = true;
	
	var HVBarCodePagingToolbar = new Ext.PagingToolbar({
					store : HVBarCodeInfoStore,
					pageSize : 20,
					displayInfo : true
				});
	
	var HVBarCodeInfoGrid = new Ext.ux.EditorGridPanel({
				id : 'HVBarCodeInfoGrid',
				title : '',
				cm : HVBarCodeInfoCm,
				sm : new Ext.grid.RowSelectionModel(),
				store : HVBarCodeInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				tbar : ['->',HVBarCodecloseBT],
				bbar : [HVBarCodePagingToolbar]
			});

	var HVBarcodeWin = new Ext.Window({
				title : IncDesc+'高值条码',
				width :600,
				height : 500,
				modal:true,
				layout : 'fit',
				items : [HVBarCodeInfoGrid]
			});
	HVBarcodeWin.show();
	
	//自动显示库存项别名
	getHVBarcode(Incil);
}