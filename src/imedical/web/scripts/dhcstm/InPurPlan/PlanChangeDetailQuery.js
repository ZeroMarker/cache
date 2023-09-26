/**
 * 查询采购明细修改界面
 */
function ChangeDetailQuery(InpiId){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 3关闭按钮
	var PlanChangeDetailCloseBT = new Ext.Toolbar.Button({
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
	function GetChange(InpiId) {
		if (InpiId == null || InpiId=="") {
			return;
		}
		PlanChangeDetailStore.setBaseParam('InpiId',InpiId);
		var pagingSize=PlanChangeDetailPagingToolbar.pageSize;
		PlanChangeDetailStore.load({params:{start:0,limit:pagingSize}})
	}

	// 访问路径
	var MasterInfoUrl = DictUrl + "inpurplanaction.csp?actiontype=GetChangeDetail";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["DhcPaiId", "UserName", "ResultQty", "PriorQty", "UomDesc",
		"InciCode", "InciDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "dhcit",
				fields : fields
			});
	// 数据集
	var PlanChangeDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var PlanChangeDetailCm = new Ext.grid.ColumnModel([nm, {
				header : "Id",
				dataIndex : 'DhcPaiId',
				width : 60,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "修改人",
				dataIndex : 'UserName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "改前数量",
				dataIndex : 'PriorQty',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "改后数量",
				dataIndex : 'ResultQty',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'UomDesc',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "物资代码",
				dataIndex : 'InciCode',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "物资名称",
				dataIndex : 'InciDesc',
				width : 90,
				align : 'left',
				sortable : true
			}
		]);
	PlanChangeDetailCm.defaultSortable = true;		
	var PlanChangeDetailPagingToolbar = new Ext.PagingToolbar({
					store : PlanChangeDetailStore,
					pageSize : 20,
					displayInfo : true
				});		
	var PlanChangeDetailGrid = new Ext.ux.EditorGridPanel({
				id : 'PlanChangeDetailGrid',
				title : '',
				cm : PlanChangeDetailCm,
				sm : new Ext.grid.RowSelectionModel(),
				store : PlanChangeDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				tbar : ['->',PlanChangeDetailCloseBT],
				bbar : [PlanChangeDetailPagingToolbar]
			});
     
	var PlanChangeDetailWin = new Ext.Window({
				title : '修改记录',
				width :600,
				height : 500,
				modal:true,
				layout : 'fit',
				items : [PlanChangeDetailGrid]
			});
	PlanChangeDetailWin.show();
	
	//自动显示库存项别名
	GetChange(InpiId)		
	
	}