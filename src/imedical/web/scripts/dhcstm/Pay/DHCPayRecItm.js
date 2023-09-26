
// /描述: 付款单制单
// /编写者：gwj
// /编写日期: 2012.09.24

var gPayRowId = "";
var gVendorRowId = "";
var payLocRowId = "";
var payRatio = 1;
var ManuOp = false;
var saveOK = true;

function CreateFromRec(payLocRowId, Fn, payRowId) {
	var URL = "dhcstm.payaction.csp";

	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
			text: '查询',
			tooltip: '点击查询',
			width: 70,
			height: 30,
			iconCls: 'page_find',
			handler: function () {
				Query();
			}
		});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
			text: '清空',
			tooltip: '点击清空',
			width: 70,
			height: 30,
			iconCls: 'page_clearscreen',
			handler: function () {
				clearData();
			}
		});

	// 确定按钮
	var saveBT = new Ext.Toolbar.Button({
			text: '保存付款单',
			tooltip: '点击保存',
			width: 70,
			height: 30,
			iconCls: 'page_save',
			handler: function () {
				Save();
			}
		});

	// 取消按钮
	var CancelBT = new Ext.Toolbar.Button({
			text: '关闭',
			tooltip: '点击关闭本窗口',
			width: 70,
			height: 30,
			iconCls: 'page_close',
			handler: function () {
				payItmWindow.close();
			}
		});

	/**
	 * 保存
	 */
	function Save() {
		saveOK = true;
		var selectedCount = ItmToPayGrid.getSelectionModel().getCount();
		if (selectedCount == 0) {
			saveOK = false;
			return;
		}

		var vendor = gVendorRowId;
		var paymode = Ext.getCmp("PayMode").getValue();
		var payUrl = URL + "?actiontype=UpdPay&loc=" + payLocRowId + "&vendor=" + vendor + "&paymode=" + paymode + "&pay=" + payRowId;
		var payResult = ExecuteDBSynAccess(payUrl);
		var payJsonData = Ext.util.JSON.decode(payResult);
		if (payJsonData.success == 'true') {
			var pay = payJsonData.info;
			if (pay > 0) {
				var rowCnt = 0;
				var handledRowCnt = 0;
				var rowCount = ItmToPayGrid.getStore().getCount();
				var sm = ItmToPayGrid.getSelectionModel();
				for (var i = 0; i < rowCount; i++) {
					if (sm.isSelected(i) == true) {
						var rowData = ItmToPayGrid.store.getAt(i);
						var pointer = rowData.get("ingri");
						var inci = rowData.get("inci");
						var recAmt = rowData.get("rpAmt");
						var payAmt = rowData.get("amt");
						var payi = "";
						var disc = "";
						var type = rowData.get("type");
						type = type == '入库' ? 'G' : (type == '退货' ? 'R' : '');

						var restAmt = rowData.get("restAmt");
						if ((type == 'G') && (payAmt > restAmt)) {
							Msg.info('warning', '页面中第' + (i + 1) + '行入库单付款金额多于待付金额!');
							return;
						}
						if ((type == 'R') && (payAmt < restAmt)) {
							Msg.info('warning', '第' + (i + 1) + '行退货单付款金额多于待付金额!');
							return;
						}
						var detailData = pointer + "^" + inci + "^" + recAmt + "^" + payAmt + "^" + disc + "^" + type;
						//SavePayItm(payi,pay,detailData)  //保存明细
						var payiUrl = URL + '?actiontype=UpdPayItm&payi=' + payi + '&pay=' + pay + '&detailData=' + detailData;
						var payiResult = ExecuteDBSynAccess(payiUrl);
						var payiJsonData = Ext.util.JSON.decode(payiResult);
						if (payiJsonData.success == 'true') {
							var payiItm = payiJsonData.info;
							if (payiItm != "") {
								saveOK = true;
								handledRowCnt++;
								if (handledRowCnt == selectedCount) {
									//若已经处理完则执行刷新
									Msg.info("success", "保存成功!")
									ItmToPayGrid.load();
								}
							} else {
								saveOK = false;
							}
						} else {
							saveOK = false;
						}
					}
				}
			} else {
				saveOK = false;
				Msg.info('error', '主表更新失败!');

			}
		} else {
			var ret = payJsonData.info;
			saveOK = false;
			if (ret == '-1') {
				Msg.info('warning', '要付款明细的供应商和原付款单供应商不同！')
			} else if (ret == '-2') {
				Msg.info('warning', '要付款科室与原付款单的科室不同!')
			} else if (ret == '-3') {
				Msg.info('warning', '付款单已经完成不能再添加付款明细!')
			} else {
				Msg.info('error', '主表更新失败!');
			}
		}

		if (saveOK) {
			payItmWindow.close();
			Fn(pay);
		}
	}

	/**
	 * 查询方法
	 */
	function Query() {
		if (payLocRowId == null || payLocRowId.length <= 0) {
			//Msg.info("warning", "请选择入库科室!");
			return;
		}
		vendorListGrid.load();
	}

	/**
	 * 清空方法
	 */
	function clearData() {
		vendorListGrid.removeAll();
		gVendorRowId = "";
		ItmToPayGrid.removeAll();
		Ext.getCmp('payVendor').setValue('');
		Ext.getCmp('InvNoField').setValue('');
		Ext.getCmp('payNo').setValue('');
		payTotalAmt.setValue('');
		gPayRowId = "";
	}

	// 供应商
	var payVendor = new Ext.ux.VendorComboBox({
			fieldLabel: '供应商',
			id: 'payVendor',
			name: 'payVendor',
			anchor: '90%',
			emptyText: '供应商...',
			valueParams: {
				LocId: payLocRowId
			}
		});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '起始日期',
			id: 'StartDate',
			name: 'StartDate',
			anchor: '90%',

			width: 120,
			value: new Date().add(Date.DAY,  - 30)
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

	var prePay = new Ext.form.TextField({
			fieldLabel: '预付款',
			id: 'prePay',
			name: 'prePay',
			anchor: '90%',
			width: 120,
			emptyText: "输入要付金额或者比例",
			listeners: {
				specialkey: function (textfield, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var preAmt = textfield.getValue();
						var endnum = -1;
						var m = ItmToPayGrid.getSelectionModel();
						var store = ItmToPayGrid.getStore();
						var cnt = store.getTotalCount();
						if (preAmt > 1) { //输入大于1时
							var sumAmt = 0;
							for (var i = 0; i < cnt; i++) {
								var rec = store.getAt(i);
								var amt = rec.get('restAmt');
								sumAmt = accAdd(sumAmt, amt);
								if(preAmt<sumAmt) break;
								endnum = i
							}
							if (endnum >= 0) {
								m.selectRange(0, endnum);
							}
						} else if (0 < preAmt <= 1) { //输入小于1时 按照比例来处理
							payRatio = preAmt;
							m.selectRange(0, cnt);
						}
						payRatio = 1; //恢复默认值
					}
				}
			}
		});

	//本次付款金额
	var payTotalAmt = new Ext.form.TextField({
			id: 'payTotalAmt',
			fieldLabel: '付款总额',
			anchor: '90%',
			disabled: true
		});
	var GetPaymodeStore = new Ext.data.Store({
			url: URL + "?actiontype=GetPayMode",
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results',
				fields: [{
						name: 'RowId',
						mapping: 'rowid'
					}, {
						name: 'Description',
						mapping: 'payDesc'
					}, 'payCode']
			})
		});

	// 入库科室
	var PayMode = new Ext.ux.ComboBox({
			fieldLabel: '支付方式',
			id: 'PayMode',
			name: 'PayMode',
			anchor: '90%',
			store: GetPaymodeStore,
			valueField: 'RowId',
			displayField: 'Description',
			emptyText: '支付方式...'
		});

	var InvNoField = new Ext.form.TextField({
			id: "InvNoField",
			fieldLabel: "发票号",
			allowBlank: true,
			anchor: '90%',
			selectOnFocus: true
		});

	var vendorListColumns = [{
			header: 'RowId',
			dataIndex: 'vendor',
			hidden: true
		}, {
			header: '供应商名称',
			width: 190,
			dataIndex: 'vendorName'
		}
	];

	function vendorRowSelFn(sm, rowIndex, r) {
		gVendorRowId = r.get("vendor");
		ItmToPayGrid.load();
	}

	function vendorParamsFn() {
		var userId = session['LOGON.USERID'];
		var groupId = session['LOGON.GROUPID'];
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if (sd != "") {
			sd = sd.format(ARG_DATEFORMAT);
		}
		if (ed != "") {
			ed = ed.format(ARG_DATEFORMAT);
		}
		var vendor = Ext.getCmp('payVendor').getValue();
		var invNo = Ext.getCmp('InvNoField').getValue();
		var StrParam = sd + "^" + ed + "^" + payLocRowId + "^" + vendor + "^" + groupId + "^" + userId + "^" + invNo;
		return {
			strParam: StrParam
		};
	}

	var vendorListGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'vendorListGrid',
			editable: false,
			contentColumns: vendorListColumns,
			smType: "row",
			smRowSelFn: vendorRowSelFn,
			autoLoadStore: true,
			actionUrl: URL,
			queryAction: "queryVendor",
			idProperty: "vendor",
			paramsFn: vendorParamsFn,
			showTBar: false,
			childGrid: 'ItmToPayGrid',
			isCheck: false
		});

	var ItmToPayColumns = [{
			header: "RowId",
			dataIndex: 'RowId',
			sortable: true,
			hidden: true
		}, {
			header: "单号",
			dataIndex: 'No'
		}, {
			header: '类型',
			dataIndex: 'type',
			width: 50
		}, {
			header: '付款金额',
			align: 'right',
			dataIndex: 'amt',
			editable: true,
			editor: new Ext.form.NumberField({})
		}, {
			header: "日期", //审核日期
			dataIndex: 'gdDate'
		}, {
			header: "时间", //审核时间
			dataIndex: 'gdTime',
			width: 50
		}, {
			header: "审核人",
			dataIndex: 'gdAuditUserName'
		}, {
			header: "明细rowid",
			dataIndex: 'ingri',
			hidden: true
		}, {
			header: "inclb",
			dataIndex: 'inclb',
			hidden: true
		}, {
			header: "inci",
			dataIndex: 'inci',
			hidden: true,
			editable: false
		}, {
			header: "代码",
			dataIndex: 'inciCode'
		}, {
			header: "名称",
			dataIndex: 'inciDesc',
			width: 200
		}, {
			header: '规格',
			dataIndex: 'spec',
			width: 80,
			editable: false
		}, {
			header: '厂商',
			dataIndex: 'manf'
		}, {
			header: '单位',
			dataIndex: 'uomDesc'
		}, {
			header: '数量',
			dataIndex: 'qty',
			align: 'right'
		}, {
			header: '进价',
			dataIndex: 'rp',
			align: 'right'
		}, {
			header: '进价金额',
			dataIndex: 'rpAmt',
			align: 'right'
		}, {
			header: '售价',
			dataIndex: 'sp',
			align: 'right'
		}, {
			header: '售价金额',
			dataIndex: 'spAmt',
			align: 'right'
		}, {
			header: '已付金额',
			align: 'right',
			dataIndex: 'payedAmt',
			xtype: 'numbercolumn'
		}, {
			header: '待付金额',
			align: 'right',
			dataIndex: 'restAmt',
			xtype: 'numbercolumn'
		}, {
			header: '发票号',
			dataIndex: 'invNo'
		}, {
			header: '发票金额',
			dataIndex: 'invAmt',
			align: 'right'
		}, {
			header: '发票日期',
			dataIndex: 'invDate',
			align: 'center'
		}, {
			header: '随行单',
			dataIndex: 'sxNo'
		}, {
			header: '批号',
			dataIndex: 'batNo'
		}, {
			header: '有效期',
			dataIndex: 'expDate'
		},{
			header: '超出账期天数',
			align: 'right',
			dataIndex: 'DifDays'
		}
	];

	function ItmToPayParamsFn() {
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		if (sd != "") {
			sd = sd.format(ARG_DATEFORMAT);
		}
		if (ed != "") {
			ed = ed.format(ARG_DATEFORMAT);
		}
		var userId = session['LOGON.USERID'];
		var groupId = session['LOGON.GROUPID'];
		var strParam = payLocRowId + "^" + gVendorRowId + "^" + sd + "^" + ed + "^" + groupId + "^" + userId;
		return {
			strParam: strParam
		};
	}

	var ItmToPayGrid = new Ext.dhcstm.EditorGridPanel({
			id: 'ItmToPayGrid',
			editable: true,
			contentColumns: ItmToPayColumns,
			smType: "checkbox",
			singleSelect: false,
			smRowSelFn: function () {},
			selectFirst: false,
			autoLoadStore: false,
			actionUrl: URL,
			queryAction: "queryItmToPay",
			idProperty: "ingri",
			checkProperty: "",
			paramsFn: ItmToPayParamsFn,
			remoteSort: false,
			showTBar: false,
			paging: false,
			isCheck: false,
			listeners: {
				'afteredit': function (e) {
					if (e.field == 'amt') {
						ManuOp = true;
						e.record.commit();
						e.grid.getSelectionModel().selectRow(e.row, true);
						TotalAmt();
					}
				}
			},
			viewConfig:{
				getRowClass : function(record,rowIndex,rowParams,store){ 
					var DifDays=record.get("DifDays");
					if(DifDays>0){
						return 'classRed';
					}
				}
			}
		});

	ItmToPayGrid.getSelectionModel().on('rowselect', function (t, ind, rec) {
		var toBePayAmt = rec.get('restAmt');
		rec.set('amt', toBePayAmt * payRatio); //使用<待付款金额>填充
		rec.commit();
		TotalAmt();
	});
	ItmToPayGrid.getSelectionModel().on('rowdeselect', function (t, ind, rec) {
		var toBePayAmt = rec.get('restAmt');
		rec.set('amt', ''); //取消使用<待付款金额>填充
		rec.commit();
		TotalAmt();
	});

	/*计算总金额*/
	function TotalAmt() {
		var store = ItmToPayGrid.getStore();
		var cnt = store.getTotalCount();
		var sumAmt = 0;
		for (var i = 0; i < cnt; i++) {
			var rec = store.getAt(i);
			var amt = rec.get('amt');
			sumAmt = accAdd(sumAmt, amt);
		}
		Ext.getCmp('payTotalAmt').setValue(sumAmt);
	}

	var payHisListTab = new Ext.form.FormPanel({
			labelWidth: 80,
			labelAlign: 'right',
			frame: true,
			bodyStyle: 'padding:5px;',
			tbar: [SearchBT, '-', ClearBT, '-', saveBT, '-', CancelBT],
			layout: 'column',
			items: [{
					xtype: 'fieldset',
					title: '查询条件',
					autoHeight: true,
					columnWidth: 0.7,
					layout: 'column',
					items: [{
							columnWidth: 0.33,
							layout: 'form',
							items: [StartDate, EndDate]
						}, {
							columnWidth: 0.4,
							layout: 'form',
							items: [payVendor, PayMode]
						}, {
							columnWidth: 0.27,
							layout: 'form',
							items: [InvNoField]
						}
					]
				}, {
					columnWidth: 0.01
				}, {
					xtype: 'fieldset',
					title: '付款单信息',
					autoHeight: true,
					columnWidth: 0.29,
					layout: 'form',
					items: [prePay, payTotalAmt]
				}
			]
		});

	var payItmWindow = new Ext.Window({
			title: '应付单据查询',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [{
					region: 'north',
					height: 130,
					layout: 'fit',
					items: payHisListTab
				}, {
					region: 'west',
					title: '应付供应商列表',
					layout: 'fit',
					width: 240,
					split: true,
					collapsible: true,
					items: vendorListGrid
				}, {
					region: 'center',
					title: '应付单据',
					layout: 'fit',
					items: ItmToPayGrid
				}
			]
		});
	payItmWindow.show();
}

///以下是之前用到的方法,将数据保存到临时global,再通过^TMP保存付款单
/*
 * 暂存数据(根据存储号)
 * StoreId - 存储号
 * */
function StoreItmData(StoreId) {
	var RowDataBlock = 50; //行数
	//var StoreId=GetStoreId();
	//alert(StoreId);
	if (StoreId != "") {
		var ListDetail = "";
		var rowCnt = 0;
		var rowCount = ItmToPayGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var sm = ItmToPayGrid.getSelectionModel();
			if (sm.isSelected(i) == true) {
				var rowData = ItmToPayGrid.store.getAt(i);
				var pointer = rowData.get("ingri");
				var inci = rowData.get("inci");
				var recAmt = rowData.get("rpAmt");
				var payAmt = rowData.get("amt");
				//var disc=rowData.get("disc");
				var disc = "";
				var type = rowData.get("type");

				var str = "" + "^" + pointer + "^" + inci + "^" + recAmt + "^" + payAmt + "^" + disc + "^" + type;

				if (ListDetail == "") {
					ListDetail = str;
				} else {
					ListDetail = ListDetail + xRowDelim() + str;
				}

				rowCnt = rowCnt++;
				if (rowCnt == RowDataBlock) {
					SendToStoreData(StoreId, ListDetail);
					//alert(ListDetail);
					rowCnt = 0; //清零
					ListDetail = "";
				}
			}
		}
		//alert(ListDetail);
		if (ListDetail != "") //最后的一批
		{
			SendToStoreData(StoreId, ListDetail);
		}
	}
}

/*发送并保存数据*/
function SendToStoreData(StoreId, detailData) {
	Ext.Ajax.request({
		url: URL + '?actiontype=StorePayItm',
		method: "POST",
		params: {
			storeId: StoreId,
			detailData: detailData
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Execute(StoreId) //执行保存
			}
		}
	});
}

/*执行保存*/
function Execute(StoreId) {
	var VenId = gVendorRowId; //供应商rowid
	var LocId = payLocRowId; //付款科室rowid
	var CreateUser = session['LOGON.USERID'];

	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + "";
	//alert(MainInfo);
	var url = URL + "?actiontype=save&MainInfo=" + MainInfo + "&StoreId=" + StoreId;

	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '更新中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 完成单据
				Msg.info("success", "保存付款单成功!");
				ItmToPayGrid.store.reload();
			} else {
				var ret = jsonData.info;
				if (ret == -99) {
					Msg.info("error", "加锁失败,不能保存!");
				} else if (ret == -4) {
					Msg.info("error", "保存付款单主表信息失败!");
				} else if (ret == -5) {
					Msg.info("error", "保存付款单明细失败!");
				} else {
					Msg.info("error", "部分明细保存不成功：" + ret);
				}
			}
		},
		scope: this
	});
}
