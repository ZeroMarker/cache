/**
 * 名称: 药品信息窗口
 * 
 * 描述: 药品信息 编写者：zhangyong 编写日期: 2011.11.04
 * 
 * @param {}
 *            Input 输入值
 * @param {}
 *            StkGrpCode 类组编码
 * @param {}
 *            StkGrpType 类组
 * @param {}
 *            Locdr 药房
 * @param {}
 *            NotUseFlag 不启用
 * @param {}
 *            QtyFlag 数量
 * @param {}
 *            HospID 院区
 * @param {}
 *            Fn 调用界面方法句柄，用于反射调用界面的方法(传递选中行的数据Record)
 * @param {}
 *            InputDetailGrid,用于控制焦点定位问题
 */
GetPhaOrderWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Fn,InputDetailGrid) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if (InputDetailGrid!=undefined){
		InputDetailGrid.setDisabled(true);
		//InputDetailGrid.focus(false);
		}  //控制连续点击焦点定位不准	
	var flg = false; // 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0, Input.indexOf("*"));
	}
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input=' + encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType=' + StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag + '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0 + '&limit=' + 15; // 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url: PhaOrderUrl,
		method: "POST"
	}); // 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec", "ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp", "bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty", "PhcFormDesc", "GoodName", "GeneName", {name: 'NotUseFlag',type: 'bool'},
	"PuomDr", "PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"]; // 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "InciDr",
		fields: fields
	}); 
	// 数据集
	var PhaOrderStore = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store: PhaOrderStore,
		pageSize: 15,
		displayInfo: true,
		displayMsg: $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
		emptyMsg: "No results to display",
		prevText: $g("上一页"),
		nextText: $g("下一页"),
		refreshText: $g("刷新"),
		lastText: $g("最后页"),
		firstText: $g("第一页"),
		beforePageText: $g("当前页"),
		afterPageText: $g("共{0}页"),
		emptyMsg: $g("没有数据")
	});
	var nm = new Ext.grid.RowNumberer({
		width: 20
	});
	/**var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true
	});**/ 
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
		header: $g('不可用'),
		dataIndex: 'NotUseFlag',
		width: 60,
		renderer: function(v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, {
		header: $g("代码"),
		dataIndex: 'InciCode',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g('名称'),
		dataIndex: 'InciDesc',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header:$g( "规格"),
		dataIndex: 'Spec',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: $g("生产企业"),
		dataIndex: 'ManfName',
		width: 180,
		align: 'left',
		sortable: true
	},
	{
		header: $g('入库单位'),
		dataIndex: 'PuomDesc',
		width: 70,
		align: 'left',
		sortable: true
	},
	{
		header:$g( "售价(入库单位)"),
		dataIndex: 'pSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("数量(入库单位)"),
		dataIndex: 'PuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("基本单位"),
		dataIndex: 'BuomDesc',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("售价(基本单位)"),
		dataIndex: 'bSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("数量(基本单位)"),
		dataIndex: 'BuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("计价单位"),
		dataIndex: 'BillUomDesc',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("售价(计价单位)"),
		dataIndex: 'BillSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("数量(计价单位)"),
		dataIndex: 'BillUomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("剂型"),
		dataIndex: 'PhcFormDesc',
		width: 60,
		align: 'left',
		sortable: true
	},
	{
		header: $g("商品名"),
		dataIndex: 'GoodName',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("处方通用名"),
		dataIndex: 'GeneName',
		width: 160,
		align: 'left',
		sortable: true
	},
	ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true; 
	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
		text:$g( '选取'),
		tooltip: $g('点击选取'),
		iconCls: 'page_goto',
		handler: function() {
			returnData();
		}
	});
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRows = PhaOrderGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", $g("请选择要返回的药品信息！"));
		} else if (selectRows.length > 1) {
			Msg.info("warning", $g("返回只允许选择一条记录！"));
		} else {
			flg = true;
			window.close();
		}
	} 
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text: $g('关闭'),
		tooltip: $g('点击关闭'),
		iconCls: 'page_close',
		handler: function() {
			flg = false;
			window.close();
		}
	});
	var PhaOrderGrid = new Ext.grid.GridPanel({
		cm: PhaOrderCm,
		store: PhaOrderStore,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		//sm: sm,
		//new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		tbar: [returnBT, '-', closeBT],
		bbar: StatuTabPagingToolbar,
		deferRowRender: false
	});
	if (!window) {
		var window = new Ext.Window({
			title:$g( '药品信息'),
			width : document.body.clientWidth*0.6,
			height : document.body.clientHeight*0.75,
			layout: 'fit',
			plain: true,
			modal: true,
			buttonAlign: 'center',
			//autoScroll : true,
			items: PhaOrderGrid,
			listeners: {
				"show": function() {
					LoadPhaOrderStore(); //避免弹出窗体焦点丢失LiangQiang 2013-11-22
				}
			}
		});
	}
	window.show();
	window.on('close',
		function(panel) {
			if (InputDetailGrid!=undefined){InputDetailGrid.setDisabled(false);}  //控制连续点击焦点定位不准	
			var selectRows = PhaOrderGrid.getSelectionModel().getSelections();
			if (selectRows.length == 0) {
				Fn("");
			} else if (selectRows.length > 1) {
				Fn("");
			} else {
				if (flg) {
					Fn(selectRows[0]);
				} else {
					Fn("");
				}
			}
	}); // 双击事件
	PhaOrderGrid.on('rowdblclick',
		function() {
			returnData();
	}); 
	// 回车事件
	PhaOrderGrid.on('keydown',
		function(e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				returnData();
			} 
			//------------ 实现数字键选择行
			if (e.getKey() == 48 || e.getKey() == 96) {
				GetDrugByNum(9)
			}
			if (e.getKey() == 49 || e.getKey() == 97) {
				GetDrugByNum(0)
			}
			if (e.getKey() == 50 || e.getKey() == 98) {
				GetDrugByNum(1)
			}
			if (e.getKey() == 51 || e.getKey() == 99) {
				GetDrugByNum(2)
			}
			if (e.getKey() == 52 || e.getKey() == 100) {
				GetDrugByNum(3)
			}
			if (e.getKey() == 53 || e.getKey() == 101) {
				GetDrugByNum(4)
			}
			if (e.getKey() == 54 || e.getKey() == 102) {
				GetDrugByNum(5)
			}
			if (e.getKey() == 55 || e.getKey() == 103) {
				GetDrugByNum(6)
			}
			if (e.getKey() == 56 || e.getKey() == 104) {
				GetDrugByNum(7)
			}
			if (e.getKey() == 57 || e.getKey() == 105) {
				GetDrugByNum(8)
			}
			if (e.getKey() == 58 || e.getKey() == 106) {
				GetDrugByNum(9)
			} 
			//------------ 实现数字键选择行
	}) 
	function GetDrugByNum(Num) {
		PhaOrderGrid.getSelectionModel().selectRow(Num); //add by myq 选中第 Num+1 行
		PhaOrderGrid.getView().focusRow(Num);
	}
	function LoadPhaOrderStore() {
		PhaOrderStore.load({
			callback: function(r, options, success) {
				if (success == false) {
					Msg.info('warning', $g('没有任何符合的记录！'));
					if (window) {
						window.close();
					}
				} else {
					PhaOrderGrid.getSelectionModel().selectFirstRow(); // 选中第一行并获得焦点
					PhaOrderGrid.getView().focusRow(0); //兼容google,yunhaibao20151126
					row = PhaOrderGrid.getView().getRow(0);
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
					}
					var rownum = PhaOrderGrid.getStore().getCount();
				    if (rownum == 1) {
						returnData();
					}
				}
			}
		});
	}
}
