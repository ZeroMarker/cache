// 名称:入库单、退货单发票号输入前组合
// 编写日期:2014-09-09

//保存参数值的object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

//=========================定义全局变量=================================
function CreateFromRec(LocRowId, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var UserId = session['LOGON.USERID'];
	var GroupId = session['LOGON.GROUPID'];
	var ParamStr = "";

	//供应商
	var VendorInv = new Ext.ux.VendorComboBox({
			id: 'VendorInv',
			name: 'VendorInv',
			valueParams: {
				LocId: LocRowId
			}
		});

	var startDateField = new Ext.ux.DateField({
			id: 'startDateField',
			width: 150,
			listWidth: 150,
			allowBlank: true,
			fieldLabel: '起始日期',
			anchor: '90%',
			value: new Date().add(Date.DAY,  - 30)
		});

	var endDateField = new Ext.ux.DateField({
			id: 'endDateField',
			width: 150,
			listWidth: 150,
			allowBlank: true,
			fieldLabel: '截止日期',
			anchor: '90%',
			value: new Date()
		});

	var INVAssemNo = new Ext.form.TextField({
			fieldLabel: '发票组合单号',
			id: 'INVAssemNo',
			name: 'INVAssemNo',
			anchor: '90%',
			disabled: true,
			width: 120
		});

	var INVRpAmt = new Ext.form.TextField({
			id: 'INVRpAmt',
			fieldLabel: '组合进价总额',
			anchor: '90%',
			disabled: true
		});

	var INVSpAmt = new Ext.form.TextField({
			id: 'INVSpAmt',
			fieldLabel: '组合售价总额',
			anchor: '90%',
			disabled: true
		});

	// 类组
	var StkGrpTypeInv = new Ext.ux.StkGrpComboBox({
			id: 'StkGrpTypeInv',
			name: 'StkGrpTypeInv',
			anchor: '90%',
			StkType: App_StkTypeCode,
			LocId: LocRowId,
			UserId: UserId
		});

	var CancelBT = new Ext.Toolbar.Button({
			text: '关闭',
			tooltip: '点击退出本窗口',
			width: 70,
			height: 30,
			iconCls: 'page_close',
			handler: function () {
				invLockWindow.close();
			}
		});

	var find = new Ext.Toolbar.Button({
			text: '查询',
			tooltip: '查询',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				Query();
			}
		});

	function Query() {
		Ext.getCmp('INVRpAmt').setValue("");
		var VendorInv = Ext.getCmp("VendorInv").getValue();
		var StkGrpTypeInv = Ext.getCmp("StkGrpTypeInv").getValue();
		var PhaLoc = LocRowId;
		var startDate = Ext.getCmp('startDateField').getValue();
		if ((startDate != "") && (startDate != null)) {
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if ((endDate != "") && (endDate != null)) {
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		if (VendorInv == "") {
			Msg.info("warning", "请选择供应商!");
			return;
		}
		if (StkGrpTypeInv == "") {
			//Msg.info("warning", "请选择类组!");
			//return;
			Msg.info('warning','未选择类组，请谨慎核实数据!');
		}
		if (startDate == "" || endDate == "") {
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		//ParamStr:起始日期^截止日期^入库单、退货单号^供应商^入库科室
		ParamStr = startDate + '^' + endDate + '^' + VendorInv + '^' + PhaLoc + '^' + StkGrpTypeInv;
		IngdGridDs.setBaseParam('ParamStr', ParamStr);
		IngdDetailGridDs.removeAll();
		IngdGridDs.removeAll();
		IngdGridDs.load({
			params: {
				start: 0,
				limit: IngdPagingToolbar.pageSize
			}
		});
	}

	var clear = new Ext.Toolbar.Button({
			text: '清空',
			tooltip: '清空',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				Ext.getCmp('VendorInv').setValue("");
				Ext.getCmp('StkGrpTypeInv').setValue("");
				Ext.getCmp('INVAssemNo').setValue("");
				Ext.getCmp('INVRpAmt').setValue("");
				Ext.getCmp('startDateField').setValue(new Date().add(Date.DAY,  - 30));
				Ext.getCmp('endDateField').setValue(new Date());
				IngdGridDs.removeAll();
				IngdGrid.getView().refresh();
				IngdDetailGridDs.removeAll();
				IngdDetailGrid.getView().refresh();
				IngdPagingToolbar.getComponent(4).setValue(1); //设置当前页码
				IngdPagingToolbar.getComponent(5).setText("页,共 1 页"); //设置共几页
				IngdPagingToolbar.getComponent(12).setText("没有记录"); //设置记录条数
			}
		});

	var edit = new Ext.Toolbar.Button({
			text: '组合',
			tooltip: '组合',
			iconCls: 'page_edit',
			width: 70,
			height: 30,
			handler: function () {
				var Vendor = Ext.getCmp('VendorInv').getValue();
				var stkGrpId = Ext.getCmp('StkGrpTypeInv').getValue();
				var RpTotalAmt = Ext.getCmp('INVRpAmt').getValue();
				if (RpTotalAmt == 0) {
					Msg.info("warning", "组合的入库单、退货单明细进价总额为零!");
					return;
				}
				var SpTotalAmt = 0;
				var count = IngdDetailGridDs.getCount();
				if (count == 0) {
					Msg.info("warning", "请选择需要组合的入库单、退货单!");
					return;
				}
				var detailData = "";
				var handledRowCnt = 0;
				var rowCount = IngdDetailGridDs.getCount();
				var sm = IngdDetailGrid.getSelectionModel();
				for (var i = 0; i < rowCount; i++) {
					if (sm.isSelected(i) == true) {
						var rowData = IngdDetailGridDs.getAt(i);
						var Ingri = rowData.get("Ingri");
						var RpAmt = rowData.get("RpAmt");
						var SpAmt = rowData.get("SpAmt");
						var type = rowData.get("type");
						type = type == '入库' ? 'G' : (type == '退货' ? 'R' : '');
						SpTotalAmt = accAdd(SpTotalAmt, SpAmt); //售价合计
						var tmp = Ingri + "^" + RpAmt + "^" + SpAmt + "^" + type;
						if (detailData == "") {
							detailData = tmp;
						} else {
							detailData = detailData + xRowDelim() + tmp;
						}
					}
				}
				if (detailData == "") {
					Msg.info("warning", "请选择需要组合的入库单、退货单明细!");
					return;
				}
				var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
				Ext.Ajax.request({
					url: 'dhcstm.vendorinvaction.csp?actiontype=Save',
					params: {
						userId: UserId,
						vendor: Vendor,
						stkGrpId: stkGrpId,
						LocRowId: LocRowId,
						RpAmt: RpTotalAmt,
						SpAmt: SpTotalAmt,
						detailData: detailData
					},
					method: 'POST',
					waitMsg: '组合中...',
					success: function (result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "保存成功!");
							var inv = jsonData.info;
							invLockWindow.close();
							Fn(inv);
						} else {
							if (jsonData.info == -1) {
								Msg.info("error", "信息不全,保存失败!");
							} else if (jsonData.info == -2) {
								Msg.info("error", "明细保存失败!");
							} else {
								Msg.info("error", "保存失败!");
							}
						}
					},
					scope: this
				});
				loadMask.hide();
			}
		});

	var sm = new Ext.grid.CheckboxSelectionModel({
			checkOnly: true,
			listeners: {
				rowselect: function (sm, rowIndex, record) {
					var InGr = IngdGridDs.getAt(rowIndex).get("IngrId");
					var Type = IngdGridDs.getAt(rowIndex).get("Type");
					IngdDetailGridDs.load({
						params: {
							start: 0,
							limit: 999,
							sort: 'Rowid',
							dir: 'Desc',
							Parref: InGr,
							Type: Type
						},
						add: true
					});
				},
				rowdeselect: function (sm, rowIndex, record) {
					var InGr = IngdGridDs.getAt(rowIndex).get("IngrId");
					var rowCount = IngdDetailGridDs.getCount();
					var IngrArr = [];
					for (var i = 0; i < rowCount; i++) {
						var rowData = IngdDetailGridDs.getAt(i);
						var ingr = rowData.get("Ingri").split("||")[0];
						if (ingr == InGr) {
							IngrArr.push(rowData);
						}
					}
					IngdDetailGridDs.remove(IngrArr);
					IngdDetailGrid.getView().refresh();
					IngdDetailTotalAmt();
				}
			}
		});
	
	var IngdGridProxy = new Ext.data.HttpProxy({
			url: 'dhcstm.vendorinvaction.csp?actiontype=QueryIngd',
			method: 'GET'
		});
	var fields = ["IngrId", "IngrNo", "Vendor", "RpAmt", "SpAmt", "Type"];
	var IngdGridDs = new Ext.data.Store({
			proxy: IngdGridProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows',
				id: "IngrId",
				fields: fields
			})
		});

	var IngdGridCm = new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(), sm, {
					header: "RowId",
					dataIndex: 'IngrId',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true,
					hideable: false
				}, {
					header: "单号",
					dataIndex: 'IngrNo',
					width: 120,
					align: 'left',
					sortable: true
				}, {
					header: "类型",
					dataIndex: 'Type',
					width: 70,
					align: 'left',
					sortable: true
				}, {
					header: "进价金额",
					dataIndex: 'RpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "售价金额",
					dataIndex: 'SpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "供应商",
					dataIndex: 'Vendor',
					width: 160,
					align: 'left',
					sortable: true
				}
			]);

	IngdGridCm.defaultSortable = true;

	var IngdPagingToolbar = new Ext.PagingToolbar({
			store: IngdGridDs,
			pageSize: PageSize,
			displayInfo: true,
			displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg: "没有记录"
		});

	var IngdGrid = new Ext.grid.EditorGridPanel({
			region: 'west',
			title: '入库单、退货单信息',
			width: 400,
			split: true,
			collapsible: true,
			layout: 'fit',
			store: IngdGridDs,
			cm: IngdGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			bbar: [IngdPagingToolbar]
		});

	var sm1 = new Ext.grid.CheckboxSelectionModel({
			listeners: {
				rowselect: function (sm1, rowIndex, record) {
					IngdDetailTotalAmt();
				},
				rowdeselect: function (sm1, rowIndex, record) {
					var RpAmt = record.get('RpAmt');
					var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
					var TotalAmt = accSub(TotalAmt, RpAmt);
					Ext.getCmp('INVRpAmt').setValue(TotalAmt);
				}
			}
		});

	var IngdDetailGridProxy = new Ext.data.HttpProxy({
			url: 'dhcstm.vendorinvaction.csp?actiontype=QueryIngdDetail',
			method: 'GET'
		});
	var fields = ["Ingri", "IngrUom", "Inclb", "RecQty", "IncCode", "IncDesc", "Rp", "RpAmt",
		"Sp", "SpAmt", "Spec", "type"];
	var IngdDetailGridDs = new Ext.data.Store({
			proxy: IngdDetailGridProxy,
			reader: new Ext.data.JsonReader({
				totalProperty: "results",
				root: 'rows',
				id: "Ingri",
				fields: fields
			})
		});
	
	IngdDetailGridDs.addListener("load",function(){
		var rowCount = IngdDetailGridDs.getCount();
		var IngriArr = [];
		for (var i = 0; i < rowCount; i++) {
			var rowData = IngdDetailGridDs.getAt(i);
			IngriArr.push(rowData);
		}
		sm1.selectRecords(IngriArr, true);
	});

	var IngdDetailGridCm = new Ext.grid.ColumnModel([
				new Ext.grid.RowNumberer(), sm1, {
					header: "Ingri",
					dataIndex: 'Ingri',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true,
					hideable: false
				}, {
					header: '物资代码',
					dataIndex: 'IncCode',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: '物资名称',
					dataIndex: 'IncDesc',
					width: 160,
					align: 'left',
					sortable: true
				}, {
					header: '规格',
					dataIndex: 'Spec',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "单位",
					dataIndex: 'IngrUom',
					width: 50,
					align: 'left',
					sortable: true
				}, {
					header: "数量",
					dataIndex: 'RecQty',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "进价",
					dataIndex: 'Rp',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "售价",
					dataIndex: 'Sp',
					width: 50,
					align: 'right',
					sortable: true
				}, {
					header: "进价金额",
					dataIndex: 'RpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "售价金额",
					dataIndex: 'SpAmt',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "类型",
					dataIndex: 'type',
					width: 70,
					align: 'left',
					sortable: true,
					hidden: true
				}
			]);

	IngdDetailGridCm.defaultSortable = true;

	var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
			store: IngdDetailGridDs,
			pageSize: 20,
			displayInfo: true,
			displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg: "没有记录"
		});

	var IngdDetailGrid = new Ext.grid.EditorGridPanel({
			region: 'center',
			title: '入库单、退货单明细信息',
			layout: 'fit',
			store: IngdDetailGridDs,
			cm: IngdDetailGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm1,
			loadMask: true,
			clicksToEdit: 1,
			deferRowRender: false
		});
	
	function IngdDetailTotalAmt() {
		Ext.getCmp('INVRpAmt').setValue("");
		var rowCount = IngdDetailGridDs.getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = IngdDetailGridDs.getAt(i);
			if (sm1.isSelected(i) == true) {
				var RpAmt = rowData.get('RpAmt');
				var TotalAmt = Ext.getCmp("INVRpAmt").getValue();
				var TotalAmt = accAdd(TotalAmt, RpAmt);
				Ext.getCmp('INVRpAmt').setValue(TotalAmt);
			}
		}
	}

	var formPanel = new Ext.ux.FormPanel({
			tbar: [find, '-', clear, '-', edit, '-', CancelBT],
			layout: 'column',
			items: [{
					xtype: 'fieldset',
					title: '查询条件',
					columnWidth: 0.65,
					layout: 'column',
					style: 'padding:5px 0px 0px 5px;',
					items: [{
							columnWidth: 0.45,
							layout: 'form',
							items: [startDateField, endDateField]
						}, {
							columnWidth: 0.55,
							layout: 'form',
							items: [VendorInv, StkGrpTypeInv]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '发票组合信息',
					columnWidth: 0.3,
					labelWidth: 90,
					style: 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
					items: [INVRpAmt]
				}
			]
		});

	var invLockWindow = new Ext.Window({
			title: '入库单、退货单组合',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [formPanel, IngdGrid, IngdDetailGrid]
		});
	invLockWindow.show();
}
