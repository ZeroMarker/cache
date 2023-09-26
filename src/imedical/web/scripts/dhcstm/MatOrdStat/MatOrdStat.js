// 名称:物质医嘱统计
// 编写日期:2013-5-16
//编写着:徐超
var UserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
var gLocId = session['LOGON.CTLOCID'];
var gIncId = '';
var CURRENT_INGR = '', CURRENT_INIT = ''; //本次补录入库单rowidStr, 出库单rowidStr

var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		name: 'StkGrpType',
		StkType: App_StkTypeCode, //标识类组类型
		LocId: gLocId,
		UserId: UserId,
		anchor: '90%'
	});

var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		anchor: '90%',
		params: {
			ScgId: 'StkGrpType'
		},
		valueParams: {
			LocId: gLocId,
			UserId: UserId
		}
	});

var InciDesc = new Ext.form.TextField({
		fieldLabel: '物资名称',
		id: 'InciDesc',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "", getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gIncId = record.get("InciDr");
	var InciCode = record.get("InciCode");
	var InciDesc = record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);

	findhaveMatord.handler();
}

var PresentFlag = new Ext.form.Checkbox({
		fieldLabel: '捐赠',
		id: 'PresentFlag',
		name: 'PresentFlag',
		anchor: '90%',
		checked: false
	});

// 调价换票标志
var ExchangeFlag = new Ext.form.Checkbox({
		id: 'ExchangeFlag',
		name: 'ExchangeFlag',
		anchor: '90%',
		checked: false,
		fieldLabel: '调价换票'
	});
//资金来源

var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel: '资金来源',
		id: 'SourceOfFund',
		anchor: '90%',
		store: SourceOfFundStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: false
	});
var OperateInType = new Ext.form.ComboBox({
		fieldLabel: '入库类型',
		id: 'OperateInType',
		name: 'OperateInType',
		anchor: '90%',
		store: OperateInTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		allowBlank: true,
		triggerAction: 'all',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		valueNotFoundText: ''
	});
// 默认选中第一行数据
OperateInTypeStore.load({
	callback: function (r, options, success) {
		if (success && r.length > 0) {
			OperateInType.setValue(r[0].get(OperateInType.valueField));
		}
	}
});

// 采购人员
var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel: '采购人员',
		id: 'PurchaseUser',
		store: PurchaseUserStore,
		valueField: 'RowId',
		displayField: 'Description'
	});

var reclocField = new Ext.ux.LocComboBox({
		id: 'reclocField',
		fieldLabel: '入库科室',
		name: 'reclocField',
		groupId: gGroupId,
		anchor: '90%'
	});

var ordlocField = new Ext.ux.LocComboBox({
		id: 'ordlocField',
		fieldLabel: '医嘱接收科室',
		anchor: '90%',
		defaultLoc: {}
	});

var startDateField = new Ext.ux.DateField({
		id: 'startDateField',
		anchor: '90%',
		allowBlank: false,
		fieldLabel: '医嘱开始日期',
		value: new Date()
	});

var endDateField = new Ext.ux.DateField({
		id: 'endDateField',
		anchor: '90%',
		allowBlank: false,
		fieldLabel: '医嘱结束日期',
		value: new Date()
	});

var IngrFlag = new Ext.form.RadioGroup({
		id: 'IngrFlag',
		columns: 3,
		height: 20,
		itemCls: 'x-check-group-alt',
		items: [{
				boxLabel: '全部',
				name: 'IngrFlag',
				id: 'AllFlag',
				inputValue: 0
			}, {
				boxLabel: '未补录',
				name: 'IngrFlag',
				id: 'NoIngrFlag',
				inputValue: 1,
				checked: true
			}, {
				boxLabel: '已补录',
				name: 'IngrFlag',
				id: 'IngredFlag',
				inputValue: 2
			}
		]
	});
var OrdRegno = new Ext.form.TextField({
		fieldLabel: '登记号',
		id: 'OrdRegno',
		anchor: '90%',
		enableKeyEvents: true,
		listeners: {
			keydown: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var OrdRegno = field.getValue();
					Ext.Ajax.request({
						url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
						params: {
							regno: OrdRegno
						},
						success: function (result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								var value = jsonData.info;
								var arr = value.split("^");
								//基础信息
								field.setValue(arr[0]);
								Ext.getCmp('OrdRegnoDetail').setValue(arr.slice(1));
							}
						},
						scope: this
					});
				}
			}
		}
	});
var OrdRegnoDetail = new Ext.form.TextField({
		fieldLabel: '登记号信息',
		id: 'OrdRegnoDetail',
		disabled: true,
		anchor: '90%'
	});
// 金额总合计
var totalrp = new Ext.form.TextField({
		fieldLabel: '金额合计',
		id: 'totalrp',
		name: 'totalrp',
		anchor: '90%',
		readOnly: true
	});
// 金额总合计
var invno = new Ext.form.TextField({
		fieldLabel: '发票号',
		id: 'invno',
		name: 'invno',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					websys_setfocus("invdate")
				}
			}
		}
	});
var invdate = new Ext.ux.DateField({
		fieldLabel: '发票日期',
		id: 'invdate',
		name: 'invdate',
		anchor: '90%'
	});
/*
var regno = new Ext.form.TextField({
fieldLabel : '登记号',
id : 'regno',
name : 'regno',
anchor : '90%',
enableKeyEvents:true,
listeners:{
keydown:function(field,e){
if (e.getKey() == Ext.EventObject.ENTER) {
var regno=field.getValue();
Ext.Ajax.request({
url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo&regno='+regno,
success: function(result, request) {
var jsonData = Ext.util.JSON.decode( result.responseText );
if (jsonData.success=='true') {
var value = jsonData.info;
var arr = value.split("^");
//基础信息
field.setValue(arr[0]);
Ext.getCmp('regnodetail').setValue(arr.slice(1));
}
},
scope: this
});
}
}
}
});
var regnodetail = new Ext.form.TextField({
fieldLabel : '登记号信息',
id : 'regnodetail',
name : 'regnodetail',
disabled:true,
anchor : '90%'
});

var onlydischarged = new Ext.form.Checkbox({
id: 'onlydischarged',
fieldLabel:'仅出院',
anchor:'90%',
allowBlank:true
});
var paied = new Ext.form.Checkbox({
id: 'paied',
fieldLabel:'已结算医嘱',
anchor:'90%',
allowBlank:true
});
var onlyuseradd = new Ext.form.Checkbox({
id: 'onlyuseradd',
fieldLabel:'仅操作人医嘱',
anchor:'90%',
allowBlank:true
});
 */

function findhaveMat() {
	var LocId = Ext.getCmp('reclocField').getValue();
	if (LocId == '') {
		Msg.info('warning', '请选择科室!');
		return false;
	}
	var startDate = Ext.getCmp('startDateField').getValue();
	if ((startDate != "") && (startDate != null)) {
		startDate = startDate.format(ARG_DATEFORMAT);
	} else {
		Msg.info("error", "请选择起始日期!");
		return false;
	}
	var endDate = Ext.getCmp('endDateField').getValue();
	if ((endDate != "") && (endDate != null)) {
		endDate = endDate.format(ARG_DATEFORMAT);
	} else {
		Msg.info("error", "请选择截止日期!");
		return false;
	}
	var Vendor = Ext.getCmp('Vendor').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var InciDesc = Ext.getCmp('InciDesc').getValue();
	if (InciDesc == '') {
		gIncId = '';
	}
	var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
	var ordlocField = Ext.getCmp('ordlocField').getValue();
	var OrdRegno = Ext.getCmp("OrdRegno").getValue();
	var strPar = startDate + "^" + endDate + "^" + Vendor + "^" + StkGrpType + "^" + gIncId
		 + "^" + LocId + "^" + IngrFlag + "^" + ordlocField + "^^^" + OrdRegno + "^" + InciDesc+"^^"+gGroupId+"^"+UserId;
	MatordGridDs.setBaseParam('strPar', strPar);
	MatordGridDs.removeAll();
	MatordGridDs.load({
		params: {
			start: 0,
			limit: 9999
		},
		callback: function (r, options, success) {
			if (success == false) {
				Msg.info("error", "查询有误, 请查看日志!");
			}
		}
	});
}
var findhaveMatord = new Ext.Toolbar.Button({
		text: '查找医嘱信息',
		tooltip: '查找医嘱信息',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			findhaveMat();
		}
	});

function CheckBarCode(Barcode, inci) {
	var url = 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode=' + encodeURIComponent(Barcode);
	var result = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(result);
	if (jsonData.success == 'true') {
		var itmArr = jsonData.info.split("^");
		var type = itmArr[1];
		var barcodeInci = itmArr[5];
		if (barcodeInci != inci) {
			Msg.info("error", "条码" + Barcode + "与物资不相符,请核实!");
			return false;
		}
		if (type != "MP" && type != "MF") {
			//对于第三方his, 在保存高值信息的时候,应记录医嘱信息, 判断是否开医嘱以此为准?
			Msg.info("warning", "条码" + Barcode + "未开医嘱, 不允许办理正式入库!");
			return false;
		} else {
			return true;
		}
	} else {
		Msg.info("error", "条码" + Barcode + "尚未注册!");
		return false;
	}
}

var saveMatord = new Ext.Toolbar.Button({
		text: '保存信息',
		tooltip: '保存信息',
		iconCls: 'page_save',
		width: 70,
		height: 30,
		handler: function () {
			if (MatordGrid.activeEditor != null) {
				MatordGrid.activeEditor.completeEdit();
			}
			var ListDetail = "";
			var rowCount = MatordGrid.getStore().getCount();
			if (rowCount == 0) {
				Msg.info("error", "没有需要保存的高值信息!");
				return;
			}
			for (var i = 0; i < rowCount; i++) {
				if (sm.isSelected(i)) {
					var rowData = MatordGrid.getStore().getAt(i);
					var orirowid = rowData.get("orirowid");
					var barcode = rowData.get("barcode");
					if (barcode == "" || barcode == 0) {
						Msg.info("warning", "第" + (i + 1) + "行物资请填写条码!");
						return;
					}
					var inci = rowData.get("inci")
						if (CheckBarCode(barcode, inci) == false) {
							return;
						}
						var invno = rowData.get("invno");
					var invdate = Ext.util.Format.date(rowData.get("invdate"), ARG_DATEFORMAT);
					var invamt = rowData.get("invamt");
					var vendordr = rowData.get("vendordr");
					var str = orirowid + "^" + invno + "^" + invdate + "^" + invamt + "^" + vendordr;

					if (ListDetail == "") {
						ListDetail = str;
					} else {
						ListDetail = ListDetail + xRowDelim() + str;
					}
				}
			}
			if (ListDetail == "") {
				Msg.info("error", "没有需要保存的信息!");
				return;
			}
			var url = "dhcstm.matordstataction.csp?actiontype=SaveInvInfo";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					ListDetail: ListDetail
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "保存成功!");
						MatordGridDs.reload();
					} else {
						var ret = jsonData.info;
						Msg.info("error", "部分明细保存不成功：" + ret);
					}
				},
				scope: this
			});
		}
	});

var clearMatord = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '清空',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			CURRENT_INGR = '';
			CURRENT_INIT = '';
			GrMasterInfoGrid.getStore().removeAll();
			GrDetailInfoGrid.getStore().removeAll();
			MatordGridDs.removeAll();
			clearPanel(formPanel);
			startDateField.setValue(new Date());
			endDateField.setValue(new Date());
			Ext.getCmp('NoIngrFlag').setValue(true)
		}
	});

var CancelMatord = new Ext.Toolbar.Button({
		text: '撤销补录',
		tooltip: '撤销补录',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var ParamInfo = tkMakeServerCall("web.DHCSTM.HVMatOrdItm", "GetParamProp", gGroupId, gLocId, UserId);
			var paramarr = ParamInfo.split("^");
			var IfCanDoCancelOeRec = paramarr[1];
			if (IfCanDoCancelOeRec != "Y") {
				Msg.info("warning", "您没有权限撤销补录!");
				return;
			}
			CancelMatRec();
		}
	});
function CancelMatRec() {
	var CancelListDetail = "";
	var Cancelsm = MatordGrid.getSelectionModel();
	var Matordstore = MatordGrid.getStore();
	var rowCount = MatordGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		if (Cancelsm.isSelected(i)) {
			var rowData = Matordstore.getAt(i);
			var BarCode = rowData.get("barcode");
			var IngrFlag = rowData.get('IngrFlag');
			if (IngrFlag != "Y") {
				Msg.info("warning", "未生成入库单不可以撤销补录!");
				Cancelsm.deselectRow(i);
				return;
			}
			var hvmatid = rowData.get('orirowid');
			if (CancelListDetail == "") {
				CancelListDetail = hvmatid;
			} else {
				CancelListDetail = CancelListDetail + "^" + hvmatid;
			}
		}
	}
	if (CancelListDetail == "") {
		Msg.info("error", "没有需要撤销补录的信息!");
		return
	};
	var url = "dhcstm.matordstataction.csp?actiontype=CancelMatRecStr";
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			ListDetail: CancelListDetail,
			user: UserId
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				// 刷新界面
				Msg.info("success", "撤销成功!");
				CURRENT_INGR = "";
				CURRENT_INIT = "";
				findhaveMat();
			} else {
				var ret = jsonData.info;
				loadMask.hide();
				if (ret == -5) {
					Msg.info("error", "保存入库单明细失败!");
				} else {
					Msg.info("error", "部分明细保存不成功：" + ret);
				}
			}
		},
		scope: this
	});
}
var createMatord = new Ext.ux.Button({
		text: '生成入库单',
		tooltip: '生成入库单',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			var LocId = Ext.getCmp("reclocField").getValue();
			if (LocId == '') {
				Msg.info('warning', '入库科室不可为空!');
				loadMask.hide();
				return false;
			}
			var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
			var MainInfo = LocId + "^" + SourceOfFund + "^" + gGroupId;

			var ListDetail = "";
			var sm = MatordGrid.getSelectionModel();
			var store = MatordGrid.getStore();
			var rowCount = MatordGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				if (sm.isSelected(i)) {
					var rowData = store.getAt(i);
					var BarCode = rowData.get("barcode");
					var IngrFlag = rowData.get('IngrFlag');
					var canceled = rowData.get("canceled");
					if (IngrFlag == "Y" || canceled == "Y") {
						Msg.info("warning", "已生成入库单或者已是取消状态,不可以再次生成!");
						sm.deselectRow(i);
						loadMask.hide();
						return;
					}
					var Ingri = "" //rowData.get("Ingri");
					var IncId = rowData.get("inci");
					var BatchNo = rowData.get("batno");
					var ExpDate = Ext.util.Format.date(rowData.get("expdate"), ARG_DATEFORMAT);
					//					if(ExpDate==""){
					//						Msg.info("warning","第"+(i+1)+"行有效期不可为空!");
					//						return;
					//					}
					var VendorId = rowData.get("vendordr");
					if (Ext.isEmpty(VendorId)) {
						Msg.info("warning", "第" + (i + 1) + "行供应商不可为空!");
						loadMask.hide();
						return;
					}
					var ManfId = rowData.get("manfdr");
					var IngrUomId = rowData.get("uomdr");
					var RecQty = rowData.get("qty");
					var Rp = rowData.get("rp");
					var NewSp = rowData.get("sp");
					var SxNo = "" //rowData.get("SxNo");
						var InvNo = rowData.get("invno");
					if (InvNo == '') {
						Msg.info('error', BarCode + '没有录入发票号!');
						loadMask.hide();
						return false;
					}
					var InvDate = Ext.util.Format.date(rowData.get("invdate"), ARG_DATEFORMAT);
					var InvAmt = rowData.get("invamt");
					var Remark = "" //rowData.get("Remark");
					var Remarks = "" //rowData.get("Remarks");
					var QualityNo = "" //rowData.get("QualityNo");
					var MtDesc = "" //rowData.get("MtDesc");
					var MtDr = "" //rowData.get("MtDr");

					if (CheckBarCode(BarCode, IncId) == false) {
						loadMask.hide();
						return;
					}
					var VendorRowid = rowData.get("vendorrowid");
					var oeori = rowData.get("oeori");
					var hvmat = rowData.get('orirowid');
					var vendordr = rowData.get('vendordr');
					var str = hvmat + '^' + InvNo + '^' + InvDate + '^' + InvAmt + '^' + vendordr;
					if (ListDetail == "") {
						ListDetail = str;
					} else {
						ListDetail = ListDetail + RowDelim + str;
					}
				}
			}

			if (ListDetail == "") {
				Msg.info("error", "没有需要生成入库单的信息!");
				loadMask.hide();
				return;
			}
			
			var url = "dhcstm.matordstataction.csp?actiontype=Create";
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					MainInfo: MainInfo,
					ListDetail: ListDetail,
					user: UserId
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON
						.decode(result.responseText);
					loadMask.hide();
					if (jsonData.success == 'true') {
						// 刷新界面
						Msg.info("success", "保存成功!");
						findhaveMatord.handler();
						var CurrentInfo = jsonData.info;
						var CurrentInfoArr = CurrentInfo.split(xRowDelim());
						CURRENT_INGR = CurrentInfoArr[0];
						CURRENT_INIT = CurrentInfoArr[1];
						if (CURRENT_INGR != '') {
							tabPanel.activate('CurrentIngrPanel');
						}
					} else {
						var ret = jsonData.info;
						loadMask.hide();
						if (ret == -99) {
							Msg.info("error", "加锁失败,不能保存!");
						} else if (ret == -1) {
							Msg.info("error", "生成入库单号失败,不能保存!");
						} else if (ret == -3) {
							Msg.info("error", "保存入库单失败!");
						} else if (ret == -4) {
							Msg.info("error", "未找到需更新的入库单,不能保存!");
						} else if (ret == -5) {
							Msg.info("error", "保存入库单明细失败!");
						} else {
							Msg.info("error", "部分明细保存不成功：" + ret);
						}
					}
				},
				scope: this
			});
		}
	});

var PrintIngrButton = new Ext.Toolbar.Button({
		text: '打印入库单',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择需要打印的入库单!");
				return;
			}
			var DhcIngr = rowData.get("IngrId");
			PrintRec(DhcIngr);
		}
	});

var PrintInitButton = new Ext.Toolbar.Button({
		text: '打印出库单',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var rowData = InitMasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择需要打印的出库单!");
				return;
			}
			var init = rowData.get("init");
			PrintInIsTrf(init);
		}
	});
var PrintHvMatButton = new Ext.Toolbar.Button({
		text: '导出',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var LocId = Ext.getCmp('reclocField').getValue();
			if (LocId == '') {
				Msg.info('warning', '请选择科室!');
				return false;
			}
			var startDate = Ext.getCmp('startDateField').getValue();
			if ((startDate != "") && (startDate != null)) {
				startDate = startDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDateField').getValue();
			if ((endDate != "") && (endDate != null)) {
				endDate = endDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "请选择截止日期!");
				return false;
			}
			/*
			var Vendor = Ext.getCmp('Vendor').getValue();
			var StkGrpType = Ext.getCmp('StkGrpType').getValue();
			var InciDesc = Ext.getCmp('InciDesc').getValue();
			if (InciDesc == '') {
				gIncId = '';
			}
			var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
			var ordlocField = Ext.getCmp('ordlocField').getValue();
			var OrdRegno = Ext.getCmp("OrdRegno").getValue();
			var strPar = startDate + "^" + endDate + "^" + Vendor + "^" + StkGrpType + "^" + gIncId
				+ "^" + LocId + "^" + IngrFlag + "^" + ordlocField + "^^^" + OrdRegno + "^" + InciDesc;
			*/
			var strPar = MatordGridDs.lastOptions.params['strPar'];
			fileName = "DHCSTM_HVMatItm.raq&&sd=" + startDate + "&ed=" + endDate + "&strParam=" + strPar;
			DHCSTM_DHCCPM_RQPrint(fileName);
		}
	});
///去重复
function filterRepeatStr(str) {
	var ar2 = str.split("^");
	var array = new Array();
	var j = 0
		for (var i = 0; i < ar2.length; i++) {
			if ((array == "" || array.toString().match(new RegExp(ar2[i], "g")) == null) && ar2[i] != "") {
				array[j] = ar2[i];
				array.sort();
				j++;
			}
		}
		return array.toString();
}
var PrintHvMat2Button = new Ext.Toolbar.Button({
		text: '导出(按供应商)',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			var count = MatordGrid.getStore().getCount()
			var vendorstr = ""
			for (i = 0; i < count; i++) {
				var rowData = MatordGrid.getStore().getAt(i);
				var vendor = rowData.get('vendordr');
				if (vendorstr == "") {
					vendorstr = vendor;
				} else {
					vendorstr = vendorstr + "^" + vendor;
				}
			}
			vendorstr = filterRepeatStr(vendorstr);
			var vendorarr = vendorstr.split(",");
			var LocId = Ext.getCmp('reclocField').getValue();
			if (LocId == '') {
				Msg.info('warning', '请选择科室!');
				return false;
			}
			var startDate = Ext.getCmp('startDateField').getValue();
			if ((startDate != "") && (startDate != null)) {
				startDate = startDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "请选择起始日期!");
				return false;
			}
			var endDate = Ext.getCmp('endDateField').getValue();
			if ((endDate != "") && (endDate != null)) {
				endDate = endDate.format(ARG_DATEFORMAT);
			} else {
				Msg.info("error", "请选择截止日期!");
				return false;
			}
			//var Vendor = Ext.getCmp('Vendor').getValue();
			var StkGrpType = Ext.getCmp('StkGrpType').getValue();
			var InciDesc = Ext.getCmp('InciDesc').getValue();
			if (InciDesc == '') {
				gIncId = '';
			}
			var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
			var ordlocField = Ext.getCmp('ordlocField').getValue();
			var OrdRegno = Ext.getCmp("OrdRegno").getValue();
			for (i = 0; i < vendorarr.length; i++) {
				var Vendor = vendorarr[i];
				var strPar = startDate + "^" + endDate + "^" + Vendor + "^" + StkGrpType + "^" + gIncId
					 + "^" + LocId + "^" + IngrFlag + "^" + ordlocField + "^^^" + OrdRegno + "^" + InciDesc;
				fileName = "DHCSTM_HVMatItm.raq&sd=" + startDate + "&ed=" + endDate + "&strParam=" + strPar;
				DHCCPM_RQPrint(fileName);
			}
		}
	});
var SmsButton = new Ext.Toolbar.Button({
		text: '发送短信',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function () {
			Ext.MessageBox.confirm('注意', '确认要发送短信吗?', SendSms);
			/*	var count=MatordGrid.getStore().getCount()
			var vendorstr=""
			for (i=0;i<count;i++){
			var rowData=MatordGrid.getStore().getAt(i);
			var vendor=rowData.get('vendordr');
			if (vendorstr==""){vendorstr=vendor}
			else{vendorstr=vendorstr+"^"+vendor}

			}
			var LocId = Ext.getCmp('reclocField').getValue();
			vendorstr=filterRepeatStr(vendorstr)
			var ret=tkMakeServerCall("web.DHCSTM.HVMatOrdItm","Sms",vendorstr,UserId,LocId);
			Msg.info("success","发送完成!");
			 */
		}
	});

function SendSms(btn) {
	if (btn == "no") {
		return;
	}
	var count = MatordGrid.getStore().getCount()
		var vendorstr = ""
		for (i = 0; i < count; i++) {
			var rowData = MatordGrid.getStore().getAt(i);
			var vendor = rowData.get('vendordr');
			if (vendorstr == "") {
				vendorstr = vendor
			} else {
				vendorstr = vendorstr + "^" + vendor
			}

		}
		var LocId = Ext.getCmp('reclocField').getValue();
	vendorstr = filterRepeatStr(vendorstr)
		var ret = tkMakeServerCall("web.DHCSTM.HVMatOrdItm", "Sms", vendorstr, UserId, LocId);
	Msg.info("success", "发送完成!");

}

var formPanel = new Ext.ux.FormPanel({
		title: '高值材料入库补录',
		//'-', PrintHvMat2Button,'-', SmsButton,
		tbar: [findhaveMatord, '-', saveMatord, '-', createMatord, '-', clearMatord, '-', PrintIngrButton, '-', PrintInitButton, '-', PrintHvMatButton, '-', CancelMatord],
		items: [{
				xtype: 'fieldset',
				title: '条件选项',
				items: [{
						layout: 'column',
						defaults: {
							layout: 'form'
						},
						items: [{
								columnWidth: .3,
								labelWidth: 100,
								items: [reclocField, ordlocField, StkGrpType]
							}, {
								columnWidth: .22,
								labelWidth: 100,
								items: [startDateField, endDateField, InciDesc]
							}, {
								columnWidth: .25,
								labelWidth: 100,
								items: [Vendor, OrdRegno, OrdRegnoDetail]
							}, {
								columnWidth: .23,
								items: [SourceOfFund, IngrFlag]
							}
						]
					}
				]
			}
		]
		/*,{
		xtype : 'fieldset',
		title : '入库单选项',
		hidden : true,		//2015-06-16 隐藏"入库单选项"fieldset部分
		items : [{
		layout : 'column',
		items : [{
		columnWidth : .2,
		layout : 'form',
		items : [OperateInType]
		}, {
		columnWidth : .2,
		layout : 'form',
		items : [PurchaseUser]
		}, {
		columnWidth : .12,
		layout : 'form',
		items : [PresentFlag]
		}, {
		columnWidth : .12,
		layout : 'form',
		items : [ExchangeFlag]
		}]
		}]
		}*/
	});

var sm = new Ext.grid.CheckboxSelectionModel({
		checkOnly: true,
		listeners: {
			beforerowselect: function (sm, rowIndex, keepExisting, record) {
				var IngrFlag = record.data["IngrFlag"];
				var canceled = record.data["canceled"];
				var barcode = record.data["barcode"];
				/*if (IngrFlag=="Y" || canceled=="Y"){
				Msg.info("warning", barcode + "已生成入库单或者已是取消状态!");
				return false;
				}*/
			},
			rowselect: function (sm, rowIndex, record) {
				if (MatordGrid.activeEditor != null) {
					MatordGrid.activeEditor.completeEdit();
				}
				var selarr = this.getSelections();
				var len = selarr.length;
				if (len > 1) {
					var invno = selarr[len - 2].data["invno"];
					var invnodate = selarr[len - 2].data["invdate"];
					record.set("invno", invno);
					record.set("invdate", invnodate);
				}
				getTotalrp();
			},
			rowdeselect: function (sm, rowIndex, record) {
				//record.set("invno","");
				//record.set("invdate","");
				getTotalrp();
			}
		}
	});
var MatordGrid = "";
//配置数据源
var MatordGridUrl = 'dhcstm.matordstataction.csp';
var MatordGridProxy = new Ext.data.HttpProxy({
		url: MatordGridUrl + '?actiontype=query',
		method: 'GET'
	});
var MatordGridDs = new Ext.data.Store({
		proxy: MatordGridProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			id: 'orirowid',
			totalProperty: 'results'
		}, [{
					name: 'oeori'
				}, {
					name: 'orirowid'
				}, {
					name: 'invno'
				}, {
					name: 'invdate',
					type: 'date',
					dateFormat: DateFormat
				}, {
					name: 'invamt'
				}, {
					name: 'code'
				}, {
					name: 'desc'
				}, {
					name: 'doctordr'
				}, {
					name: 'doctor'
				}, {
					name: 'orddate'
				}, {
					name: 'ordtime'
				}, {
					name: 'qty'
				}, {
					name: 'uomdr'
				}, {
					name: 'uomdesc'
				}, {
					name: 'pano'
				}, {
					name: 'paname'
				}, {
					name: 'ward'
				}, {
					name: 'bed'
				}, {
					name: 'prescno'
				}, {
					name: 'oeori'
				}, {
					name: 'vendorrowid'
				}, {
					name: 'manfdr'
				}, {
					name: 'vendor'
				}, {
					name: 'manf'
				}, {
					name: 'rp'
				}, {
					name: 'batno'
				}, {
					name: 'expdate',
					type: 'date',
					dateFormat: DateFormat
				}, {
					name: 'sp'
				}, {
					name: 'ordstatus'
				}, {
					name: 'feestatus'
				}, {
					name: 'feeamt'
				}, {
					name: 'admlocdr'
				}, {
					name: 'admloc'
				}, {
					name: 'date'
				}, {
					name: 'time'
				}, {
					name: 'user'
				}, {
					name: 'ingno'
				}, {
					name: 'dateofmanu'
				}, {
					name: 'canceled'
				}, {
					name: 'usercanceled'
				}, {
					name: 'datecanceled'
				}, {
					name: 'timecanceled'
				}, {
					name: 'ingrtno'
				}, {
					name: 'barcode'
				}, {
					name: 'inci'
				}, {
					name: 'dhcit'
				},
				'IngrFlag', 'vendordr', 'ingri',
				'specdesc', 'IngriModify', 'IngriModifyNo', 'InitRecLoc'
			]),
		remoteSort: false
	});

var IngrVendor = new Ext.ux.VendorComboBox({
		//params : {ScgId : 'StkGrpType'},
		valueParams: {
			LocId: gLocId,
			UserId: UserId
		}
	});

var canceled = new Ext.grid.CheckColumn({
		header: '取消标志',
		dataIndex: 'canceled',
		width: 100,
		sortable: true,
		hidden: true,
		renderer: function (v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + ((v == 'Y') || (v == true) ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});

//模型
var MatordGridCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			sm, {
				header: "oeori",
				dataIndex: 'oeori',
				width: 90,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资代码",
				dataIndex: 'code',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "物资名称",
				dataIndex: 'desc',
				width: 140,
				align: 'left',
				sortable: true
			}, {
				header: "条码id",
				dataIndex: 'dhcit',
				width: 60,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "高值条码",
				dataIndex: 'barcode',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "补录标记",
				dataIndex: 'IngrFlag',
				width: 60,
				xtype: 'checkcolumn',
				isPlugin: false,
				align: 'center',
				sortable: true
			}, {
				header: "补录入库单Dr",
				dataIndex: 'IngriModify',
				width: 80,
				hidden: true
			}, {
				header: "补录入库单",
				dataIndex: 'IngriModifyNo',
				width: 160,
				align: 'left',
				sortable: true
			}, {
				header: "生成日期",
				dataIndex: 'dateofmanu',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "进价",
				dataIndex: 'rp',
				width: 80,
				align: 'right',
				sortable: true,
				editable: false, //2015-06-16 不允许修改进价,批号,效期
				editor: new Ext.form.TextField({
					id: 'rpField',
					allowBlank: false,
					selectOnFocus: true,
					tabIndex: 1
				})
			}, {
				header: "<font color=blue>发票金额</font>",
				dataIndex: 'invamt',
				width: 80,
				align: 'right',
				sortable: true,
				editor: new Ext.form.NumberField({
					allowBlank: false,
					selectOnFocus: true
				})
			}, {
				header: "<font color=blue>发票号</font>",
				dataIndex: 'invno',
				width: 100,
				align: 'left',
				sortable: true,
				editor: new Ext.form.TextField({
					id: 'invnoField',
					allowBlank: false,
					selectOnFocus: true
				})
			}, {
				header: "<font color=blue>发票日期</font>",
				dataIndex: 'invdate',
				width: 80,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editor: new Ext.ux.DateField({
					id: 'invdateField'
				})
			}, {
				header: "批号",
				dataIndex: 'batno',
				width: 80,
				align: 'left',
				sortable: true,
				editable: false, //2015-06-16 不允许修改进价,批号,效期
				editor: new Ext.form.TextField({
					id: 'batnoField',
					allowBlank: false,
					selectOnFocus: true
				})
			}, {
				header: "有效期",
				dataIndex: 'expdate',
				width: 80,
				align: 'left',
				sortable: true,
				renderer: Ext.util.Format.dateRenderer(DateFormat),
				editable: false, //2015-06-16 不允许修改进价,批号,效期
				editor: new Ext.ux.DateField({
					id: 'expdateField'
				})
			}, {
				header: "入库单号",
				dataIndex: 'ingno',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "患者登记号",
				dataIndex: 'pano',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "患者姓名",
				dataIndex: 'paname',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "医生",
				dataIndex: 'doctor',
				width: 60,
				align: 'left',
				sortable: true
			}, {
				header: "医嘱状态",
				dataIndex: 'ordstatus',
				width: 40,
				align: 'center',
				renderer: function (value) {
					var PoStatus = '';
					if (value == 'V') {
						PoStatus = '核实';
					} else if (value == 'U') {
						PoStatus = '作废';
					} else if (value == 'E') {
						PoStatus = '执行';
					} else if (value == 'C') {
						PoStatus = '撤销';
					}
					return PoStatus;
				},
				sortable: true
			}, {
				header: "医嘱日期",
				dataIndex: 'orddate',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "医嘱时间",
				dataIndex: 'ordtime',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "数量",
				dataIndex: 'qty',
				width: 50,
				align: 'right',
				sortable: true
			}, {
				header: "单位",
				dataIndex: 'uomdesc',
				width: 40,
				align: 'left'
			}, {
				header: "补录接收科室",
				dataIndex: 'InitRecLoc',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "患者病区",
				dataIndex: 'admloc',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "床号",
				dataIndex: 'bed',
				width: 40,
				align: 'left',
				sortable: true
			}, {
				header: "处方号",
				dataIndex: 'prescno',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "费用状态",
				dataIndex: 'feestatus',
				width: 40,
				align: 'left',
				sortable: true
			}, {
				header: "费用总额",
				dataIndex: 'feeamt',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "供应商",
				dataIndex: 'vendordr',
				editor: new Ext.grid.GridEditor(IngrVendor),
				renderer: Ext.util.Format.comboRenderer2(IngrVendor, 'vendordr', 'vendor')
			}, {
				header: "厂商",
				dataIndex: 'manf',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "售价",
				dataIndex: 'sp',
				width: 80,
				align: 'right',
				sortable: true
			}, canceled, {
				header: "具体规格",
				dataIndex: 'specdesc',
				width: 80,
				align: 'right',
				sortable: true
			}
		]);
function getTotalrp() {
	var selarr = MatordGrid.getSelectionModel().getSelections();
	var totalrp = 0
		for (var i = 0; i < selarr.length; i++) {
			var rowData = selarr[i];
			var Rp = rowData.get("rp");
			totalrp = accAdd(totalrp, Rp)
		}
		Ext.getCmp("totalrp").setValue(totalrp);
}
var InvNoBT = new Ext.Toolbar.Button({
		text: '填写发票号和发票日期',
		tooltip: '点击填写发票号',
		height: 30,
		width: 70,
		iconCls: 'page_refresh',
		handler: function () {
			InvNoInput();
		}
	});

function InvNoInput() {
	var rs = sm.getSelections();
	var count = rs.length;
	if (count > 0) {
		var invno = Ext.getCmp('invno').getValue();
		var InvDate = Ext.getCmp('invdate').getValue();
		for (var i = 0; i < count; i++) {
			var rowData = rs[i];
			rowData.set('invno', invno);
			rowData.set('invdate', InvDate);
		}
		//saveMatord.handler();
		Msg.info('warning', '发票信息已录入表格,请保存!');
	} else {
		Msg.info('error', '请选择需要录入发票的记录!');
	}
}

//表格
MatordGrid = new Ext.ux.EditorGridPanel({
		id: 'MatordGrid',
		store: MatordGridDs,
		tbar: ['发票号:', '-', invno, '-', '发票日期:', invdate, '-', InvNoBT, '->', '金额合计:', '-', totalrp],
		//title:'明细信息',
		cm: MatordGridCm,
		plugins: canceled,
		trackMouseOver: true,
		stripeRows: true,
		sm: sm,
		loadMask: true,
		clicksToEdit: 1,
		listeners: {
			beforeedit: function (e) {
				var IngrFlag = e.record.get('IngrFlag');
				if (IngrFlag == "Y") {
					return false;
				}
				if (e.field == 'vendordr' && !Ext.isEmpty(e.record.get('ingri'))) {
					e.cancel = true;
					Msg.info('warning', '该条码有入库记录,不允许修改供应商!');
				}
			},
			afteredit: function (e) {
				if (e.field == 'invno') {
					var invnoFlag = InvNoValidator(e.value, "");
					if (!invnoFlag) {
						Msg.info("warning", "发票号'" + e.value + "'已存在于其他入库单中!");
						//e.record.set('invno',e.originalValue);
					}
				}
			}
		}
	});

//>>>>>>>>>>入库单回显部分>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
		url: DictUrl + 'ingdrecaction.csp?actiontype=QueryIngrStr',
		totalProperty: "results",
		root: 'rows',
		fields: ["IngrId", "IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp", "RpAmt", "SpAmt", "AcceptUser", "InvAmt"],
		listeners: {
			load: function (store, records, option) {
				if (records.length > 0) {
					GrMasterInfoGrid.getSelectionModel().selectFirstRow();
					GrMasterInfoGrid.getView().focusRow(0);
				}
			}
		}
	});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'IngrId',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true,
				hideable: false
			}, {
				header: "入库单号",
				dataIndex: 'IngrNo',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: '入库部门',
				dataIndex: 'RecLoc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "供应商",
				dataIndex: 'Vendor',
				width: 200,
				align: 'left',
				sortable: true
			}, {
				dataIndex: "StkGrp",
				hidden: true,
				hideable: false
			}, {
				header: '采购员',
				dataIndex: 'PurchUser',
				width: 70,
				align: 'left',
				sortable: true
			}, {
				header: "完成标志",
				dataIndex: 'Complete',
				width: 70,
				align: 'left',
				sortable: true
			}, {
				header: "发票金额",
				dataIndex: 'InvAmt',
				width: 80,
				xtype: 'numbercolumn',
				align: 'right'
			}, {
				header: "进价金额",
				dataIndex: 'RpAmt',
				width: 80,
				xtype: 'numbercolumn',
				align: 'right'
			}, {
				header: "售价金额",
				dataIndex: 'SpAmt',
				xtype: 'numbercolumn',
				width: 80,
				align: 'right'
			}, {
				header: "备注",
				dataIndex: 'InGrRemarks',
				width: 160,
				align: 'left'
			}
		]);

var GridPagingToolbar = new Ext.PagingToolbar({
		store: GrMasterInfoStore,
		pageSize: PageSize,
		displayInfo: true
	});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
		id: 'GrMasterInfoGrid',
		title: '',
		//autoHeight: true,
		cm: GrMasterInfoCm,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function (sm, rowIndex, r) {
					var InGr = r.get("IngrId");
					GrDetailInfoStore.load({
						params: {
							start: 0,
							limit: 999,
							sort: 'Rowid',
							dir: 'Desc',
							Parref: InGr
						}
					});
				}
			}
		}),
		store: GrMasterInfoStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: [GridPagingToolbar]
	});

var GrDetailInfoStore = new Ext.data.JsonStore({
		url: DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
		totalProperty: "results",
		root: 'rows',
		fields: ["Ingri", "BatchNo", "IngrUom", "ExpDate", "Inclb", "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc", "InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate", "QualityNo", "SxNo", "Remark", "MtDesc", "PubDesc",
			"CheckPort", "CheckRepNo", {
				name: 'CheckRepDate',
				type: 'date',
				dateFormat: DateFormat
			}, "AdmNo", {
				name: 'AdmExpdate',
				type: 'date',
				dateFormat: DateFormat
			}, "CheckPack", "InvMoney"]
	});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
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
				width: 230,
				align: 'left',
				sortable: true
			}, {
				header: "生产厂商",
				dataIndex: 'Manf',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "批号",
				dataIndex: 'BatchNo',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "有效期",
				dataIndex: 'ExpDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "单位",
				dataIndex: 'IngrUom',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "数量",
				dataIndex: 'RecQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "进价",
				dataIndex: 'Rp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "售价",
				dataIndex: 'Sp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "发票号",
				dataIndex: 'InvNo',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "发票日期",
				dataIndex: 'InvDate',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "发票金额",
				dataIndex: 'InvMoney',
				width: 100,
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
			}
		]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
		id: 'GrDetailInfoGrid',
		title: '',
		height: 170,
		cm: GrDetailInfoCm,
		store: GrDetailInfoStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true
	});

var IngrInfoPanel = new Ext.Panel({
		layout: 'border',
		items: [{
				region: 'north',
				layout: 'fit',
				height: 200,
				items: GrMasterInfoGrid
			}, {
				region: 'center',
				layout: 'fit',
				items: GrDetailInfoGrid
			}
		]
	});
//<<<<<<<<<<入库单回显部分<<<<<<<<<<

//>>>>>>>>>>出库单回显部分>>>>>>>>>>
var InitMasterStore = new Ext.data.JsonStore({
		url: DictUrl + 'dhcinistrfaction.csp?actiontype=QueryTrans',
		totalProperty: "results",
		root: 'rows',
		fields: ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd", "tt", "comp", "userName",
			"status", "RpAmt", "SpAmt", "MarginAmt", "Remark", "StatusCode", "confirmFlag"],
		listeners: {
			load: function (store, records, options) {
				if (records.length > 0) {
					InitMasterGrid.getSelectionModel().selectFirstRow();
					InitMasterGrid.getView().focusRow(0);
				}
			}
		}
	});

var InitMasterCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "RowId",
				dataIndex: 'init',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "转移单号",
				dataIndex: 'initNo',
				width: 160,
				align: 'left',
				sortable: true
			}, {
				header: "请求部门",
				dataIndex: 'toLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "供给部门",
				dataIndex: 'frLocDesc',
				width: 120,
				align: 'left',
				sortable: true
			}, {
				header: "转移日期",
				dataIndex: 'dd',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: "制单人",
				dataIndex: 'userName',
				width: 90,
				align: 'left',
				sortable: true
			}, {
				header: "进价金额",
				dataIndex: 'RpAmt',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "售价金额",
				dataIndex: 'SpAmt',
				width: 80,
				align: 'right',
				sortable: true
			}
		]);

var InitMasterPagingToolbar = new Ext.PagingToolbar({
		store: InitMasterStore,
		pageSize: PageSize,
		displayInfo: true
	});
var InitMasterGrid = new Ext.grid.GridPanel({
		title: '',
		height: 170,
		cm: InitMasterCm,
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true,
			listeners: {
				rowselect: function (sm, rowIndex, r) {
					var InIt = r.get("init");
					InitDetailStore.setBaseParam('Parref', InIt);
					InitDetailStore.removeAll();
					InitDetailStore.load({
						params: {
							start: 0,
							limit: InitDetailPagingToolbar.pageSize,
							sort: 'Rowid',
							dir: 'Desc'
						}
					})
				}
			}
		}),
		store: InitMasterStore,
		trackMouseOver: true,
		stripeRows: true,
		loadMask: true,
		bbar: InitMasterPagingToolbar
	});

var InitDetailStore = new Ext.data.JsonStore({
		url: DictUrl + 'dhcinistrfaction.csp?actiontype=QueryDetail',
		totalProperty: "results",
		root: 'rows',
		fields: ["initi", "inrqi", "inci", "inciCode",
			"inciDesc", "inclb", "batexp", "manf", "manfName",
			"qty", "uom", "sp", "status", "remark",
			"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec", "newSp",
			"spAmt", "rp", "rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty", "TrUomDesc"]
	});

var InitDetailCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header: "转移细项RowId",
				dataIndex: 'initi',
				width: 100,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "物资Id",
				dataIndex: 'inci',
				width: 80,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: '物资代码',
				dataIndex: 'inciCode',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: '物资名称',
				dataIndex: 'inciDesc',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "批次Id",
				dataIndex: 'inclb',
				width: 180,
				align: 'left',
				sortable: true,
				hidden: true
			}, {
				header: "批次/效期",
				dataIndex: 'batexp',
				width: 150,
				align: 'left',
				sortable: true
			}, {
				header: "生产厂商",
				dataIndex: 'manfName',
				width: 180,
				align: 'left',
				sortable: true
			}, {
				header: "批次库存",
				dataIndex: 'inclbQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "转移数量",
				dataIndex: 'qty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "转移单位",
				dataIndex: 'TrUomDesc',
				width: 80,
				align: 'left',
				sortable: true
			}, {
				header: "进价",
				dataIndex: 'rp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "售价",
				dataIndex: 'sp',
				width: 60,
				align: 'right',
				sortable: true
			}, {
				header: "请求数量",
				dataIndex: 'reqQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "货位码",
				dataIndex: 'stkbin',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "请求方库存",
				dataIndex: 'reqLocStkQty',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "占用数量",
				dataIndex: 'inclbDirtyQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "可用数量",
				dataIndex: 'inclbAvaQty',
				width: 80,
				align: 'right',
				sortable: true
			}, {
				header: "批次售价",
				dataIndex: 'newSp',
				width: 100,
				align: 'right',
				sortable: true
			}, {
				header: "规格",
				dataIndex: 'spec',
				width: 100,
				align: 'left',
				sortable: true
			}, {
				header: "售价金额",
				dataIndex: 'spAmt',
				width: 100,
				align: 'right',

				sortable: true
			}, {
				header: "进价金额",
				dataIndex: 'rpAmt',
				width: 100,
				align: 'right',
				sortable: true
			}
		]);

var InitDetailPagingToolbar = new Ext.PagingToolbar({
		store: InitDetailStore,
		pageSize: PageSize,
		displayInfo: true
	});

var InitDetailGrid = new Ext.grid.GridPanel({
		title: '',
		height: 200,
		cm: InitDetailCm,
		store: InitDetailStore,
		trackMouseOver: true,
		stripeRows: true,
		bbar: InitDetailPagingToolbar,
		loadMask: true
	});

var InitInfoPanel = new Ext.Panel({
		layout: 'border',
		items: [{
				region: 'north',
				layout: 'fit',
				height: 200,
				items: InitMasterGrid
			}, {
				region: 'center',
				layout: 'fit',
				items: InitDetailGrid
			}
		]
	});
//<<<<<<<<<<出库单回显部分<<<<<<<<<<

var tabPanel = new Ext.TabPanel({
		region: 'center',
		activeTab: 0,
		items: [{
				title: '高值医嘱信息',
				id: 'HVMatPanel',
				layout: 'fit',
				items: MatordGrid
			}, {
				title: '本次补录入库信息',
				id: 'CurrentIngrPanel',
				layout: 'fit',
				items: IngrInfoPanel
			}, {
				title: '本次补录出库信息',
				id: 'CurrentInitPanel',
				layout: 'fit',
				items: InitInfoPanel
			}
		],
		listeners: {
			'tabchange': function (t, p) {
				if (p.getId() == 'CurrentIngrPanel') {
					if (CURRENT_INGR != "") {
						GrMasterInfoGrid.getStore().load({
							params: {
								IngrStr: CURRENT_INGR
							}
						});
					}
				} else if (p.getId() == 'CurrentInitPanel') {
					if (CURRENT_INIT != "") {
						InitMasterGrid.getStore().load({
							params: {
								InitStr: CURRENT_INIT
							}
						});
					}
				}
			}
		}
	});

//===========模块主页面=============================================
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, tabPanel]
		});
});
//===========模块主页面=============================================
