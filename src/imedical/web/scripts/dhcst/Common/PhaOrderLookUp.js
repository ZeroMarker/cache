/**
 * 名称: 药品信息下拉列表
 * 
 * 描述: 药品信息 编写者：yunhaibao 编写日期: 2017.11.13
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
 * @param {}
 *            AllCatGrpFlag,用于控制焦点定位问题
 */
GetPhaOrderLookUp = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Fn,InputDetailGrid,AllCatGrpFlag) {
	var flg = false; // 替换特殊字符
	AllCatGrpFlag=AllCatGrpFlag||"";
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0, Input.indexOf("*"));
	}
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input=' + encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType=' + StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag + '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0 + '&limit=' + 15+"&AllCatGrpFlag="+AllCatGrpFlag; // 通过AJAX方式调用后台数据
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
	PhaOrderStore.load({
		callback: function(r, options, success) {
			if (success == false) {
			} else {
				InciDescLookupGrid.getSelectionModel().selectFirstRow(); // 选中第一行并获得焦点
				InciDescLookupGrid.getView().focusRow(0); 				 //兼容google,yunhaibao20151126
				row = InciDescLookupGrid.getView().getRow(0);
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					setTimeout(function(){element.focus();},1000);
				}
			}
		}
	});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true
	}); 
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
		header: $g('不可用'),
		dataIndex: 'NotUseFlag',
		width: 45,
		renderer: function(v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([ {
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
		header: $g("规格"),
		dataIndex: 'Spec',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: $g("厂商"),
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
		header: $g("售价(入库单位)"),
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
		hidden:true
	},
	{
		header: $g("基本单位"),
		dataIndex: 'BuomDesc',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("售价(基本单位)"),
		dataIndex: 'bSp',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("数量(基本单位)"),
		dataIndex: 'BuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("计价单位"),
		dataIndex: 'BillUomDesc',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("售价(计价单位)"),
		dataIndex: 'BillSp',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("数量(计价单位)"),
		dataIndex: 'BillUomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("剂型"),
		dataIndex: 'PhcFormDesc',
		width: 60,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("商品名"),
		dataIndex: 'GoodName',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("通用名"),
		dataIndex: 'GeneName',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	ColumnNotUseFlag]);
	//PhaOrderCm.defaultSortable = true; 
	InciDescLookupGrid = new dhcst.icare.Lookup({
		lookupListComponetId: 1872,
		defaultWidth:1000,
		lookupPage:$g( "药品选择"),
		lookupName: "M_InciDesc",
		listeners: { 'selectRow': Fn },
		pageSize: 30,
		isCombo: true,
		listFields:fields,
		listColumns:PhaOrderCm,
		listUrl:PhaOrderUrl,
		dataSet:PhaOrderStore
	});


}
