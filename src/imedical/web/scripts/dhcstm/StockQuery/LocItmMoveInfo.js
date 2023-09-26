// /名称:库存动销查询
// /描述: 库存动销查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.16
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam = '';
	var gGroupId = session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel: '科室',
			id: 'PhaLoc',
			name: 'PhaLoc',
			anchor: '90%',
			groupId: gGroupId,
			stkGrpId: 'StkGrpType'
		});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '开始日期',
			id: 'StartDate',
			name: 'StartDate',
			anchor: '90%',

			width: 120,
			value: new Date().add(Date.DAY,  - 30)
		});
	var StartTime = new Ext.form.TextField({
			fieldLabel: '开始时间',
			id: 'StartTime',
			name: 'StartTime',
			anchor: '90%',
			regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText: '时间格式错误，正确格式hh:mm:ss',
			width: 120
		});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
			fieldLabel: '截止日期',
			id: 'EndDate',
			name: 'EndDate',
			anchor: '90%',

			width: 120,
			value: new Date()
		});
	var EndTime = new Ext.form.TextField({
			fieldLabel: '截止时间',
			id: 'EndTime',
			name: 'EndTime',
			anchor: '90%',
			regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText: '时间格式错误，正确格式hh:mm:ss',
			width: 120
		});
	var StkGrpType = new Ext.ux.StkGrpComboBox({
			id: 'StkGrpType',
			name: 'StkGrpType',
			StkType: App_StkTypeCode, //标识类组类型
			anchor: '90%',
			UserId: gUserId,
			LocId: gLocId,
			childCombo: 'DHCStkCatGroup'
		});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel: '库存分类',
			id: 'DHCStkCatGroup',
			name: 'DHCStkCatGroup',
			anchor: '90%',
			width: 140,
			store: StkCatStore,
			valueField: 'RowId',
			displayField: 'Description',
			params: {
				StkGrpId: 'StkGrpType'
			}
		});
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
			text: '查询',
			tooltip: '点击查询',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				ShowReport();
			}
		});

	/**
	 * 查询方法
	 */
	function searchData() {
		// 必选条件
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "科室不能为空！");
			Ext.getCmp("PhaLoc").focus();
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "请选择开始日期!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "请选择截止日期!");
			return;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		endDate = endDate.format(ARG_DATEFORMAT);
		var startTime = Ext.getCmp("StartTime").getRawValue();
		var endTime = Ext.getCmp("EndTime").getRawValue();
		var stkGrpId = Ext.getCmp("StkGrpType").getValue();
		var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();

		gStrParam = phaLoc + "^" + startDate + "^" + startTime + "^" + endDate + "^" + endTime
			 + "^" + stkGrpId + "^" + stkCatId;

		StockQtyStore.setBaseParam("Params", gStrParam);
		StockQtyStore.removeAll();
		var pageSize = StatuTabPagingToolbar.pageSize;
		StockQtyStore.load({
			params: {
				start: 0,
				limit: pageSize
			}
		});

	}

	// 清空按钮
	var RefreshBT = new Ext.Toolbar.Button({
			text: '清空',
			tooltip: '点击清空',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				clearData();
			}
		});

	/**
	 * 清空方法
	 */
	function clearData() {
		gStrParam = '';
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,  - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StartTime").setValue('');
		Ext.getCmp("EndTime").setValue('');
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("DHCStkCatGroup").setValue('');

		StockQtyGrid.store.removeAll();
		StockQtyGrid.getView().refresh();
	}

	var PrintBT = new Ext.Toolbar.Button({
			text: '打印',
			tooltip: '点击打印库存数据',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function () {
				PrintStockData();
			}
		});

	function PrintStockData() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "科室不能为空！");
			Ext.getCmp("PhaLoc").focus();
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "请选择开始日期!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "请选择截止日期!");
			return;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		endDate = endDate.format(ARG_DATEFORMAT);
		var startTime = Ext.getCmp("StartTime").getRawValue();
		var endTime = Ext.getCmp("EndTime").getRawValue();
		var stkGrpId = Ext.getCmp("StkGrpType").getValue();
		var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
		var ParamStr = "phaLoc="+phaLoc+";startDate="+startDate+";startTime="+startTime+
			";endDate="+endDate+";endTime="+endTime+";stkGrpId="+stkGrpId+";stkCatId="+stkCatId;
		if (ParamStr == '') {
			return;
		}
		var RaqName = 'DHCSTM_LocItmMoveInfo_Common.raq';
		var FileName = '{' + RaqName + '(' + ParamStr + ')}';
		var transfileName = TranslateRQStr(FileName);
		DHCSTM_DHCCPM_RQPrint(transfileName);
	}

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel();
	var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header: "incil",
					dataIndex: 'incil',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: '物资代码',
					dataIndex: 'code',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "物资名称",
					dataIndex: 'desc',
					width: 200,
					align: 'left',
					sortable: true
				}, {
					header: "规格",
					dataIndex: 'spec',
					width: 90,
					align: 'left',
					sortable: true
				}, {
					header: "单位",
					dataIndex: 'pUomDesc',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "库存量",
					dataIndex: 'currStkQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "出数量",
					dataIndex: 'OutQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "入数量",
					dataIndex: 'InQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "出金额",
					dataIndex: 'sumOutAmt',
					width: 60,
					align: 'right',

					sortable: true
				}, {
					header: "出进价金额",
					dataIndex: 'sumOutRpAmt',
					width: 60,
					align: 'right',

					sortable: true
				}, {
					header: "入金额",
					dataIndex: 'sumInAmt',
					width: 100,
					align: 'right',

					sortable: true
				}, {
					header: "入进价金额",
					dataIndex: 'sumInRpAmt',
					width: 100,
					align: 'right',

					sortable: true
				}, {
					header: "厂商",
					dataIndex: 'manf',
					width: 150,
					align: 'left',
					sortable: true
				}, {
					header: "货位",
					dataIndex: 'sbDesc',
					width: 150,
					align: 'left',
					sortable: true
				}
			]);
	StockQtyCm.defaultSortable = true;

	// 访问路径
	var DspPhaUrl = DictUrl
		 + 'locitmstkaction.csp?actiontype=jsLocItmMoveInfo&start=&limit=';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
			url: DspPhaUrl,
			method: "POST"
		});
	// 指定列参数
	var fields = ["incil", "code", "desc", "spec", "manf", "OutQty", "pUomDesc", "sumOutAmt", "sumOutRpAmt",
		"InQty", "sumInAmt", "sumInRpAmt", "sbDesc", "currStkQty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "incil",
			fields: fields
		});
	// 数据集
	var StockQtyStore = new Ext.data.Store({
			proxy: proxy,
			reader: reader
		});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: StockQtyStore,
			pageSize: PageSize,
			displayInfo: true,
			displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
			emptyMsg: "No results to display",
			prevText: "上一页",
			nextText: "下一页",
			refreshText: "刷新",
			lastText: "最后页",
			firstText: "第一页",
			beforePageText: "当前页",
			afterPageText: "共{0}页",
			emptyMsg: "没有数据"
		});

	var StockQtyGrid = new Ext.ux.GridPanel({
			id: 'StockQtyGrid',
			title: '明细',
			layout: 'fit',
			region: 'center',
			cm: StockQtyCm,
			store: StockQtyStore,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			bbar: StatuTabPagingToolbar
		});

	var HisListTab = new Ext.ux.FormPanel({
			title: "库存动销查询",
			tbar: [SearchBT, '-', RefreshBT, '-', PrintBT],
			items: [{
					xtype: 'fieldset',
					title: '查询条件',
					layout: 'column',
					style: 'padding:5px 0px 0px 5px',
					defaults: {
						border: false,
						columnWidth: 0.33,
						xtype: 'fieldset'
					},
					items: [{
							items: [PhaLoc, StkGrpType, DHCStkCatGroup]
						}, {
							items: [StartDate, StartTime]
						}, {
							items: [EndDate, EndTime]
						}
					]
				}
			]

		});
	//Tabs定义
	var QueryTabPanel = new Ext.TabPanel({
			region: 'center',
			id: 'QueryTabPanel',
			margins: '3 3 3 0',
			activeTab: 0,
			items: [{
					title: '动销明细',
					id: 'StockQtyItmPanel',
					layout:"fit",
					items:StockQtyGrid
				}, {
					title: '动销汇总',
					id: 'LocItmMoveStatPanel',
					layout:"fit",
					html: '<iframe id="LocItmMoveStat" width=100% height=100% src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" ></iframe>'
				}
			],
			listeners:{
					tabchange:function(tabpanel,panel){
						var p_URL="";
						var panl = Ext.getCmp("QueryTabPanel").getActiveTab();
						var iframe = panl.el.dom.getElementsByTagName("iframe")[0];
						var tabId = QueryTabPanel.getActiveTab().id;
						// 必选条件
						var phaLoc = Ext.getCmp("PhaLoc").getValue();
						if (phaLoc == null || phaLoc.length <= 0) {
							Msg.info("warning", "科室不能为空！");
							Ext.getCmp("PhaLoc").focus();
							return;
						}
						var startDate = Ext.getCmp("StartDate").getValue();
						var endDate = Ext.getCmp("EndDate").getValue();
						if (startDate == undefined || startDate.length <= 0) {
							Msg.info("warning", "请选择开始日期!");
							return;
						}
						if (endDate == undefined || endDate.length <= 0) {
							Msg.info("warning", "请选择截止日期!");
							return;
						}
						startDate = startDate.format(ARG_DATEFORMAT);
						endDate = endDate.format(ARG_DATEFORMAT);
						var startTime = Ext.getCmp("StartTime").getRawValue();
						var endTime = Ext.getCmp("EndTime").getRawValue();
						var stkGrpId = Ext.getCmp("StkGrpType").getValue();
						var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();

						var HospDesc=App_LogonHospDesc;
						if (panel.id=="StockQtyItmPanel"){
								searchData();
						}else if (panel.id=="LocItmMoveStatPanel"){
							    p_URL =PmRunQianUrl+"?reportName=DHCSTM_LocItmMoveInfo_Stat.raq&phaLoc="+phaLoc+";HospDesc="+HospDesc
							    +";startDate="+startDate+";startTime="+startTime+";endDate="+endDate+";endTime="+endTime+";stkGrpId="+stkGrpId
							    +";stkCatId="+stkCatId;
							    var ReportFrame=document.getElementById("LocItmMoveStat");
								ReportFrame.src=p_URL;
						}
					}
			}
		});
	/**
	  *查询
	  */
	function ShowReport()
	{
		QueryTabPanel.fireEvent('tabchange',QueryTabPanel,QueryTabPanel.getActiveTab());
	}
	// 5.2.页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [HisListTab, QueryTabPanel],
			renderTo: 'mainPanel'
		});

})
