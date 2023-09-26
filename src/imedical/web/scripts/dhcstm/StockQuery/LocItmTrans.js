// /名称: 台帐信息查询（库存查询界面调用）
// /描述: 台帐信息查询（库存查询界面调用）
// /编写者：zhangdongmei
// /编写日期: 2012.08.10

function TransQuery(Incil, StkDate, IncInfo) {

	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo = replaceAll(IncInfo, " ", "　"); //用全角空格代替半角空格，防止label展示的时候自动将半角空格过滤掉

	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '起始日期',
			id: 'StartDate',
			anchor: '90%',
			value: StkDate
		});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
			fieldLabel: '结束日期',
			id: 'EndDate',
			anchor: '90%',
			value: StkDate
		});

	var Inc = new Ext.form.Label({
			text: IncInfo,
			align: 'center',
			cls: 'classDiv1'
		})

		// 检索按钮
		var searchBT = new Ext.Toolbar.Button({
			text: '查询',
			tooltip: '点击查询物资台帐',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				searchData();
			}
		});

	/**
	 * 查询方法
	 */
	function searchData() {
		// 必选条件
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "请在主界面选择某一条记录查看其台帐信息！");
			return;
		}

		var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString(); ;
		var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
		DetailInfoStore.setBaseParam('incil', Incil);
		DetailInfoStore.setBaseParam('startdate', StartDate);
		DetailInfoStore.setBaseParam('enddate', EndDate);
		var size = StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({
			params: {
				start: 0,
				limit: size
			}
		});
	}

	// 访问路径
	var DetailInfoUrl = DictUrl
		 + 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
			url: DetailInfoUrl,
			method: "POST"
		});

	// 指定列参数
	//业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
	//^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
	//^期末金额(进价)^期末金额(售价)^供应商^厂商^操作人
	var fields = ["TrId", "TrDate", "BatExp", "PurUom", "Sp", "Rp", "EndQty", "EndQtyUom",
		"TrQty", "TrQtyUom", "RpAmt", "SpAmt", "TrNo", "TrAdm", "TrMsg",
		"EndRpAmt", "EndSpAmt", "Vendor", "Manf", "OperateUser", "TrPointer"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "TrId",
			fields: fields
		});
	// 数据集
	var DetailInfoStore = new Ext.data.Store({
			proxy: proxy,
			reader: reader
		});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
					header: "TrId",
					dataIndex: 'TrId',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: "业务RowId",
					dataIndex: 'TrPointer',
					hidden: true
				}, {
					header: "日期",
					dataIndex: 'TrDate',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: '批号效期',
					dataIndex: 'BatExp',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: "单位",
					dataIndex: 'PurUom',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: "售价",
					dataIndex: 'Sp',
					width: 100,
					align: 'left',

					sortable: true
				}, {
					header: "进价",
					dataIndex: 'Rp',
					width: 100,

					align: 'left'
				}, {
					header: "结余数量",
					dataIndex: 'EndQtyUom',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "数量",
					dataIndex: 'TrQtyUom',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "进价金额",
					dataIndex: 'RpAmt',
					width: 120,
					align: 'left',

					sortable: true
				}, {
					header: "售价金额",
					dataIndex: 'SpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "处理号",
					dataIndex: 'TrNo',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "处理人",
					dataIndex: 'TrAdm',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "摘要",
					dataIndex: 'TrMsg',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "结余金额(进价)",
					dataIndex: 'EndRpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "结余金额(售价)",
					dataIndex: 'EndSpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "供应商",
					dataIndex: 'Vendor',
					width: 160,
					align: 'right',
					sortable: true
				}, {
					header: "厂商",
					dataIndex: 'Manf',
					width: 160,
					align: 'right',
					sortable: true
				}, {
					header: "操作人",
					dataIndex: 'OperateUser',
					width: 100,
					align: 'right',
					sortable: true
				}
			]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: DetailInfoStore,
			pageSize: PageSize,
			displayInfo: true
		});
	var DetailInfoGrid = new Ext.grid.GridPanel({
			title: '',
			height: 170,
			region: 'center',
			cm: DetailInfoCm,
			sm: new Ext.grid.RowSelectionModel({
				singleSelect: true
			}),
			store: DetailInfoStore,
			trackMouseOver: true,
			stripeRows: true,
			loadMask: true,
			bbar: StatuTabPagingToolbar
		});

	var HisListTab = new Ext.ux.FormPanel({
			tbar: [searchBT],
			items: [{
				xtype:'fieldset',
				title:'查询条件',
				layout : 'column',
				style:'padding:5px 0px 0px 5px',
				defaults:{xtype:'fieldset',columnWidth : .33,border:false},
				items: [{
					items: [StartDate]
				}, {
					items: [EndDate]
				}]
			},{
				style:'padding:0px 0px 0px 30px',
				items: [Inc]
			}]
		});

	var window = new Ext.Window({
			title: '台帐信息',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [HisListTab, DetailInfoGrid]
		});
	window.show();
	searchBT.handler();
}
