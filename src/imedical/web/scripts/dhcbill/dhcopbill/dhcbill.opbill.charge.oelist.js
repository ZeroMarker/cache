/**
 * FileName: dhcbill.opbill.charge.oelist.js
 * Anchor: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

function initOEListPanel() {
	initOEListMenu();
	initOrdItmList();
}

function initOEListMenu() {
	//新增
	$HUI.linkbutton("#btn-add", {
		onClick: function () {
			addClick();
		}
	});
	
	//删除
	$HUI.linkbutton("#btn-delete", {
		onClick: function () {
			deleteClick();
		}
	});
	
	//保存
	$HUI.linkbutton("#btn-save", {
		onClick: function () {
			saveClick();
		}
	});
	
	initAdmDoc();
}

function initOrdItmList() {
	var loadSuccess = false;
	var prescClsObj = {};
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		striped: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		checkOnSelect: false,   //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: false,
		rownumbers: false,
		pageSize: 999999999,
		toolbar: '#ordlist-tb',
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: 'TGroup', field: 'TGroup', hidden: true},
				   {title: '医嘱', field: 'OPOrdItemDesc', width: 180,
				   	editor: {
						type: 'combogrid',
						options: {
							panelWidth: 530,
							fitColumns: true,
							method: 'GET',
							pagination: true,
							idField: 'ARCIMastRowID',
							textField: 'ARCIMastDesc',
							mode: 'remote',
							data: [],
							delay: 500,
							enterNullValueClear: false,
							selectOnNavigation: false,
							columns: [[{field: 'ARCIMastDesc', title: '医嘱名称', width: 180},
									   {field: 'ARCIMastRowID', title: 'ARCIMastRowID', hidden: true},
								   	   {field: 'ARCSubCat', title: '子类', width: 80},
								   	   {field: 'subcatordtype', title: 'subcatordtype', hidden: true},
									   {field: 'phuomdesc', title: '单位', width: 80},
									   {field: 'ItemPrice', title: '价格', width: 120, align: 'right'},
									   {field: 'phFreqCode', title: 'phFreqCode', hidden: true},
									   {field: 'ARCType', title: 'ARCType', hidden: true}
							]],
							onBeforeLoad: function (param) {
								$(this).datagrid("options").url = null;   //加这句是因为删除内容时会再发起一次请求
								var adm = getValueById("episodeId");
								if (adm && param.q && ($.trim(param.q).length > 1)) {
									$(this).datagrid("options").url = $URL;
									param.ClassName = "web.DHCOPItemMast";
									param.QueryName = "ARCIMastList";
									param.ARCCATCode = "";
									param.ItemMCode = param.q;
									param.UGroupRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
									param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
									param.adm = adm;
								}
							},
							onSelect: function(index, row) {
								onSelectArcimHandler(row);
							}
						}
					}
				   },
				   {title: '单位', field: 'OPOrdUnit', width: 80},
				   {title: '单价', field: 'OPOrdPrice', width: 100, align: 'right', editor: 'text'},
				   {title: '数量', field: 'OPOrdQty', width: 80,
				   	 editor: {
					   	 type: 'numberbox',
					   	 options: {
						 	min: 1,
						 	isKeyupChange: true,
						 	onChange: function(newValue, oldValue) {
							 	var row = GV.OEItmList.getRows()[GV.EditRowIndex];
							 	if (row) {
								 	row.OPOrdQty = newValue;
								}
							}
						 }
					 }
				   },
				   {title: '金额', field: 'OPOrdBillSum', width: 120, align: 'right'},
				   {title: '接收科室', field: 'OPOrdItemRecLoc', width: 150,
				   	editor: {
					   	type: 'combobox',
					   	options: {
						   	panelHeight: 'auto',
							valueField: 'RecLocRID',
							textField: 'RecLocDesc',
							method: 'GET',
							editable: false,
							onLoadSuccess: function(data) {
								var defRecLocRID = "";
								$.each(data, function (index, item) {
									if (item.DefRecFlag == "Y") {
										defRecLocRID = item.RecLocRID;
										return false;
									}
								});
								$(this).combobox("select", defRecLocRID);
							},
							onChange: function(newValue, oldValue) {
								var row = GV.OEItmList.getRows()[GV.EditRowIndex];
								if (row) {
									row.OPOrdItemRecLocRID = newValue || "";
								}
							}
						}
					}
				   },
				   {title: 'TOrdSubCat', field: 'TOrdSubCat', hidden: true},
				   {title: 'PrescriptionNo', field: 'PrescriptionNo', hidden: true},
				   {title: 'OrdRowId', field: 'OrdRowId', hidden: true},
				   {title: 'OPOrdItemRecLocRID', field: 'OPOrdItemRecLocRID', hidden: true},
				   {title: 'OPOrdDiscPrice', field: 'OPOrdDiscPrice', hidden: true},
				   {title: 'OPOrdInsPrice', field: 'OPOrdInsPrice', hidden: true},
				   {title: 'OPOrdPatPrice', field: 'OPOrdPatPrice', hidden: true}, 
				   {title: 'OPOrdType', field: 'OPOrdType', hidden: true},
				   {title: 'OPOrdInsRowId', field: 'OPOrdInsRowId', hidden: true},
				   {title: 'OPOrdInsType', field: 'OPOrdInsType', hidden: true},
				   {title: 'OPOrdBillFlag', field: 'OPOrdBillFlag', hidden: true},
				   {title: 'OPOrdItemRowID', field: 'OPOrdItemRowID', hidden: true},
				   {title: 'LimitItmFlag', field: 'LimitItmFlag', hidden: true},
				   {title: 'OEORIDR', field: 'OEORIDR', hidden: true},
				   {title: '处方金额', field: 'OPOrdPrescSum', width: 120, align: 'right'},
				   {title: '检验容器', field: 'OPLabPlacerCode', width: 100,
				   	styler: function(value, row, index) {
					   	return labPlacerStyle(value);
					}
				   },
				   {title: 'OEOrdDoctorDR', field: 'OEOrdDoctorDR', hidden: true},
				   {title: '处方/标本号', field: 'LabEpisodeNo', width: 120},
				   {title: '组符号', field: 'GrpOEFlag', width: 60,
				   	styler: function(value, row, index) {
					   	return 'color: red;';
					}
				   },
				   {title: 'TPreOeoriPrescno', field: 'TPreOeoriPrescno', hidden: true},
				   {title: 'ArcimInsu', field: 'ArcimInsu', hidden: true},
				   {title: 'OPOrdBBExtCode', field: 'OPOrdBBExtCode', hidden: true},
				   {title: 'DiscAmt', field: 'DiscAmt', hidden: true},
				   {title: 'PayorAmt', field: 'PayorAmt', hidden: true},
				   {title: 'BillSubType', field: 'BillSubType', hidden: true},
				   {title: 'InsuDicCode', field: 'InsuDicCode', hidden: true},
				   {title: '病种', field: 'InsuDicDesc', width: 160},
			]],
		onLoadSuccess: function (data) {
			$("#actualMoney, #change").numberbox("clear");    //清空实付，找零
			$(this).datagrid("clearChecked");
			GV.EditRowIndex = undefined;
			loadSuccess = false;
			prescClsObj = {};
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (!row.OrdRowId) {
					return true;
				}
				if (+row.OPOrdBillFlag == 1) {
					GV.OEItmList.checkRow(index);
				}else {
					GV.OEItmList.uncheckRow(index);
				}
				if (row.LimitItmFlag == "Y") {
					hasDisabledRow = true;
				}
				$("#ordItmList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = (row.LimitItmFlag == "Y");
			});
			//有disabled行时,表头也disabled
			$("#ordItmList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
			loadSuccess = true;
			calcAdm();
		},
		rowStyler: function(index, row) {
			if (row.PrescriptionNo) {
				if (!prescClsObj[row.PrescriptionNo]) {
					var modeNum = ((Object.keys(prescClsObj).length + 1) % GV.PrescClsCount) || GV.PrescClsCount;
					prescClsObj[row.PrescriptionNo] = "OPOELPrescNo" + modeNum;
				}
				return {class: prescClsObj[row.PrescriptionNo]};
			}
		},
		onCheck: function (rowIndex, rowData) {
			spliceUnBillOrder(rowData.OrdRowId);
			if (!loadSuccess) {
				return;
			}
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			prescLink(rowIndex, rowData);     //处方勾选同步
			regFeeLink(rowIndex, rowData);    //挂号医嘱勾选同步
			calcAdm();
		},
		onUncheck: function (rowIndex, rowData) {
			pushUnBillOrder(rowData.OrdRowId);
			if (!loadSuccess) {
				return;
			}
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			prescLink(rowIndex, rowData);    //处方取消勾选同步
			regFeeLink(rowIndex, rowData);   //挂号医嘱取消勾选同步			
			calcAdm();
		},
		onCheckAll: function (rows) {
			if (!loadSuccess) {
				return;
			}
			$.each(rows, function (index, row) {
				if (!row.OrdRowId) {
					return true;
				}
				if (row.LimitItmFlag == "Y") {
					GV.OEItmList.uncheckRow(index);
					return true;
				}
				spliceUnBillOrder(row.OrdRowId);
			});
			calcAdm();
		},
		onUncheckAll: function (rows) {
			if (!loadSuccess) {
				return;
			}
			$.each(rows, function (index, row) {
				if (!row.OrdRowId) {
					return true;
				}
				pushUnBillOrder(row.OrdRowId);
			});
			calcAdm();
		},
		onBeginEdit: function(index, row) {
			onBeginEditHandler(index, row);
    	},
		onDblClickRow: function(index, row) {
			onDblClickRowHandler(index, row);
		},
		onEndEdit: function(index, row, changes) {
			onEndEditHandler(index, row);
		}
	});
	GV.OEItmList.loadData({"rows": [], "total": 0});
}

function prescLink(rowIndex, rowData) {
	if (!rowData.TPreOeoriPrescno) {
		return;
	}
	var checked = GV.OEItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "]").hasClass("datagrid-row-checked");
	$.each(GV.OEItmList.getRows(), function (index, row) {
		if ((rowIndex == index) || (rowData.TPreOeoriPrescno != row.TPreOeoriPrescno)) {
			return true;
		}
		_linkItm(checked, index);
	});
}

function regFeeLink(rowIndex, rowData) {
	if (!rowData.BillSubType) {
		return;
	}
	var checked = GV.OEItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "]").hasClass("datagrid-row-checked");
	$.each(GV.OEItmList.getRows(), function (index, row) {
		if ((rowIndex == index) || (rowData.BillSubType != row.BillSubType)) {
			return true;
		}
		_linkItm(checked, index);
	});
}

function _linkItm(checked, index) {
	if (GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled) {
		return;
	}
	GV.SelOrdRowIdx = index;
	if (checked) {
		GV.OEItmList.checkRow(index);
	}else {
		GV.OEItmList.uncheckRow(index);
	}
	delete GV.SelOrdRowIdx;
}

/**
* 就诊医生
*/
function initAdmDoc() {
	$HUI.combobox("#admDoc", {
		panelHeight: 150,
		method: 'GET',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$("#admDoc").combobox("options").url = $URL;
				param.ClassName = "web.DHCOPCashier";
				param.QueryName = "FindCTCareProv";
				param.ResultSetType = "array";
				param.desc = param.q;
			}
		}
	});
}

function labPlacerStyle(value) {
	var bgColor = "";
   	var color = "#000000";
   	switch (value) {
	case "A":
		bgColor = "#8D007C";
		break;
	case "C":
		bgColor = "#7F7F7F";
		break;
	case "R":
		bgColor = "#FF0000";
		break;
	case "P":
		bgColor = "#FF00FB";
		break;
	case "Y":
		bgColor = "#FFFF26";
		break;
	case "G":
		bgColor = "#008123";
		break;
	case "H":
		bgColor = "#000000";
		color = "#FFFFFF";
		break;
	case "B":
		bgColor = "#0005FF";
		break;
	case "W":
		bgColor = "#FFFFFF";
		break;
	case "O":
		bgColor = "#8E0000";
		break;
	default:
	}
	return 'background-color:' + bgColor + ';color:' + color;
}

function loadOrdItmList(adm) {
	if (!adm) {
		return;
	}
	var curInsType = getSelectedInsType();
	if (!curInsType) {
		return;
	}
	var unBillStr = getUnBillOrderStr();
	
	var queryParams = {
		ClassName: "web.DHCOPAdmFind",
		QueryName: "GetADMOrder",
		PAADMRowid: adm,
		AdmInsType: curInsType,
		unBillStr: unBillStr,
		gLoc: PUBLIC_CONSTANT.SESSION.GROUPID,
		UloadDR: PUBLIC_CONSTANT.SESSION.CTLOCID,
		rows: 99999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

function saveOrdToServer() {
	var adm = getValueById("episodeId");
	if (!adm) {
		return true;
	}
	var docUserId = getValueById("admDoc");
	if (!docUserId) {
		return true;
	}
	try {
		var saveFlag = false;
		var ordItmStrAry = [];
		var ordRowIndexAry = [];
		var myStr = "";
		$.each(GV.OEItmList.getRows(), function (index, row) {
			if (!row.OPOrdItemRowID) {
				return true;
			}
			if (!row.OrdRowId) {
				saveFlag = true;
				var isHerb = $.m({ClassName: "web.DHCOPCashier", MethodName: "IsHerb", Arcim: row.OPOrdItemRowID, HospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
				var multNum = (isHerb == "1") ? (getValueById("multNum") || 1) : 1;
				
				myStr = row.OPOrdItemRowID + "^";
				myStr += (row.OPOrdQty * multNum) + "^";
				myStr += row.OPOrdItemRecLocRID + "^";
				myStr += row.OPOrdPrice + "^";
				myStr += row.OPOrdUnit + "^";
				myStr += row.OPOrdInsRowId + "^";
				ordItmStrAry.push(myStr);
				ordRowIndexAry.push(index);
			}
		});
		if (ordItmStrAry.length > 0) {
			var ordItmStr = ordItmStrAry.join(PUBLIC_CONSTANT.SEPARATOR.CH1);
			var rtn = $.m({
				ClassName: "web.DHCOPCashier",
				MethodName: "CashierInsertOrdItem",
				Adm: adm,
				OrdItemStr: ordItmStr,
				User: PUBLIC_CONSTANT.SESSION.USERID,
				Loc: PUBLIC_CONSTANT.SESSION.CTLOCID,
				DocUserId: docUserId
			}, false);
			//医生站接口返回0或100说明保存医嘱失败
			if ((rtn != "0") && (rtn != "100")) {
				var myAry = rtn.split("^");
				var tmpAry = [];
				var rowIndex;
				var row = {};
				$.each(myAry, function (index, item) {
					if (!item) {
						return true;
					}
					tmpAry = item.split("*");
					rowIndex = ordRowIndexAry[index];
					if (!rowIndex) {
						return true;
					}
					row = GV.OEItmList.getRows()[rowIndex];
					if (row) {
						row.OrdRowId = tmpAry[1];
					}
				});
			}else {
				throw getErrObj("Run Error at Cache Err: " + rtn);
			}
		}
		if (saveFlag) {
			$.m({
				ClassName: "web.DHCOPCashier",
				MethodName: "CreatePrescNo",
				Adm: adm,
				UserID: PUBLIC_CONSTANT.SESSION.USERID,
				LocID: PUBLIC_CONSTANT.SESSION.CTLOCID
			}, function(rtn) {
				if (rtn != "0") {
					throw getErrObj("Run Error at Cache: General PresNo");
				}
			});
		}
	}catch(e){
		$.messager.popover({msg: e.message, type: "error"});
		return false;
	}
	return true;
}

function  getErrObj(msg) {
	var err = new Error(msg);
	return err;
}

/**
* 判断医嘱是否已保存
*/
function checkSaveOrder() {
	var saveFlag = true;
	try {
		$.each(GV.OEItmList.getRows(), function (index, row) {
			if (!row.OrdRowId) {
				saveFlag = false;
				return false;
			}
		});
	} catch (e) {
		$.messager.popover({msg: e.message, type: "error"});
		return false;
	}
	return saveFlag;
}

function calcAdm() {
	var totalAmt = 0;
	var discAmt = 0;
	var payorAmt = 0;
	var patPayAmt = 0;
	$.each(GV.OEItmList.getChecked(), function (index, row) {
		totalAmt = numCompute(totalAmt, numCompute(row.OPOrdQty, row.OPOrdPrice, "*"), "+");
		discAmt = numCompute(discAmt, row.DiscAmt, "+");
		payorAmt = numCompute(payorAmt, row.PayorAmt, "+");
		patPayAmt = numCompute(patPayAmt, row.OPOrdBillSum, "+");
	});
	setValueById("curDeptShare", patPayAmt);
	setValueById("curDeptRoundShare", getRoundAmt(patPayAmt));

	var selAdmListRow = GV.AdmList.getSelected();
	if (selAdmListRow) {
		var rowIndex = GV.AdmList.getRowIndex(selAdmListRow);
		GV.AdmList.updateRow({
			index: rowIndex,
			row: {
				admTotalSum: totalAmt.toString(),
				admDiscSum: discAmt.toString(),
				admPayOrSum: payorAmt.toString(),
				admPatSum: patPayAmt.toString(),
			}
		});
	}
	var totalSum = 0;
	var discSum = 0;
	var payorSum = 0;
	var patShareSum = 0;
	$.each(GV.AdmList.getRows(), function (index, row) {
		totalSum = numCompute(totalSum, row.admTotalSum, "+");
		discSum = numCompute(discSum, row.admDiscSum, "+");
		payorSum = numCompute(payorSum, row.admPayOrSum, "+");
		patShareSum = numCompute(patShareSum, row.admPatSum, "+");
	});
	setValueById("patShareSum", patShareSum);
	setValueById("patRoundSum", getRoundAmt(patShareSum));
}

function getRoundAmt(amt) {
	var expStr = getValueById("paymode");
	return $.m({ClassName: "web.DHCBillConsIF", MethodName: "OPCRound", MSum: amt, HospId: PUBLIC_CONSTANT.SESSION.HOSPID, ExpStr: expStr}, false);
}

function pushUnBillOrder(oeitm) {
	if (!oeitm) {
		return;
	}
	var adm = getValueById("episodeId");
	if (adm) {
		var index = GV.UnBillOrdObj[adm.toString()].indexOf(oeitm);
		if (index == -1) {
			GV.UnBillOrdObj[adm.toString()].push(oeitm);
		}
	}
	return;
}

function spliceUnBillOrder(oeitm) {
	if (!oeitm) {
		return;
	}
	var adm = getValueById("episodeId");
	if (adm) {
		var index = GV.UnBillOrdObj[adm.toString()].indexOf(oeitm);
		if (index != -1) {
			GV.UnBillOrdObj[adm.toString()].splice(index, 1);
		}
	}
	return;
}

function getUnBillOrderStr() {
	var unBillOrderStr = "";
	var myStr = "";
	$.each(GV.UnBillOrdObj, function(key, val) {
		splitter = PUBLIC_CONSTANT.SEPARATOR.CH2 + key + PUBLIC_CONSTANT.SEPARATOR.CH2;
		myStr = splitter + "^" + val.join("^") + "^" + splitter;
		if (!unBillOrderStr) {
			unBillOrderStr = myStr;
		}else {
			unBillOrderStr += myStr;
		}
	});
	return unBillOrderStr;
}

function addClick() {
	var adm = getValueById("episodeId");
	if (!adm) {
		return;
	}
	appendEditRow();
}

function deleteClick() {
	var row = GV.OEItmList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请单击行选中需要删除的医嘱", type: "info"});
		return;
	}
	var rowIndex = GV.OEItmList.getRowIndex(row);
	$.messager.confirm("确认", "是否确认删除医嘱?", function (r) {
		if (r) {
			var ordItmId = row.OrdRowId;
			var oldUserId = $.m({ClassName: "web.DHCOPItemMast", MethodName: "GetOrdUser", OrdItem: ordItmId, NewUserRowId: PUBLIC_CONSTANT.SESSION.USERID}, false);
			if (oldUserId != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "不是本人开的医嘱不允许删除", type: "info"});
				return;
			}
			var stopOrdInfo = PUBLIC_CONSTANT.SESSION.USERID + "^";
			var rtn = stopOrdItem(ordItmId, stopOrdInfo);
			if (rtn) {
				GV.EditRowIndex = undefined;
				$.messager.popover({msg: "删除成功", type: "success"});
				GV.OEItmList.uncheckRow(rowIndex);
				GV.OEItmList.deleteRow(rowIndex);
			}
		}
	});
}

/**
* 停医嘱
*/
function stopOrdItem(ordItmId, stopOrdInfo) {
	try {
		if (!ordItmId) {
			return true;
		}else {
			var encmeth = getValueById("OPOrdStopItemEncrypt");
			var rtn = cspRunServerMethod(encmeth, ordItmId, stopOrdInfo);
			if (rtn != 0) {
				throw getErrObj("停医嘱失败：" + rtn + "，入参串：" + ordItmId + "~" + stopOrdInfo);
			}
		}
	}catch(e) {
		$.messager.popover({msg: e.message, type: "error"});
		return false;
	}
	return true;
}

function saveClick() {
	var adm = getValueById("episodeId");
	if (!adm) {
		return;
	}
	var docUserId = getValueById("admDoc");
	if (!docUserId) {
		return;
	}
	if (checkSaveOrder()) {
		$.messager.popover({msg: "没有需要保存的医嘱", type: "info"});
		return;
	}
	if (!endEditing()) {
		return;
	}
	var rtn = saveOrdToServer();
	if (rtn) {
		$.messager.popover({msg: "保存成功", type: "success"});
		loadOrdItmList(adm);
	}
}

function onSelectArcimHandler(row) {
	if (!row) {
		return;
	}
	switch(row.ARCType) {
	case "ARCIM":
		setOrdItem(row);
		break;
	case "ARCOS":
		var itemDesc = "";
		var ordRowIdString = "";
		arcositemListOpen(row.ARCIMastRowID, itemDesc, "YES", "", ordRowIdString);
		break;
	default:
	}
}

function setOrdItem(row) {
	var editRow = GV.OEItmList.getRows()[GV.EditRowIndex];
	if (!editRow) {
		return;
	}
	editRow.OPOrdItemRowID = row.ARCIMastRowID;
	editRow.OPOrdType = row.subcatordtype;
	
	var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdQty"});
	var ordQty = (ed ? $(ed.target).val() : 1) || 1;
	setGridCellValue(GV.EditRowIndex, "OPOrdQty", ordQty);
	editRow.OPOrdQty = ordQty;
	
	setGridCellValue(GV.EditRowIndex, "OPOrdUnit", row.phuomdesc);
	editRow.OPOrdUnit = row.phuomdesc;
	
	setGridCellValue(GV.EditRowIndex, "OPOrdPrice", row.ItemPrice);
	editRow.OPOrdPrice = row.ItemPrice;
	
	getOEOtherInfo(editRow);

	var adm = getValueById("episodeId");
	var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdItemRecLoc"});
	if (ed) {
		var url = $URL + "?ClassName=web.DHCOPItemMast&QueryName=AIMRecLoc&ResultSetType=array&PAADMRowID=" + adm + "&ARCIMRID=" + row.ARCIMastRowID + "&LocRowID=" + PUBLIC_CONSTANT.SESSION.CTLOCID;
		ed.target.combobox("reload", url);
	}

	if (editRow.OPOrdType == "P") {
		setTimeout(function() {
			var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdPrice"});
			if (ed) {
				$(ed.target).focus().select();
			}
		}, 100);
	}else {
		var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdPrice"});
		if (ed) {
			$(ed.target).prop("disabled", true);
		}
		setTimeout(function() {
			var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdQty"});
			if (ed) {
				$(ed.target).focus().select();
			}
		}, 100);
	}
}

function setGridCellValue(rowIndex, fieldName, value) {
	var ed = GV.OEItmList.getEditor({index: rowIndex, field: fieldName});
	if (ed) {
		var obj = GV.OEItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] input");
		if (obj) {
			$(obj).val(value);
		}
	}else {
		var obj = GV.OEItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "] td[field=" + fieldName + "] div");
		if (obj) {
			$(obj).text(value);
		}
	}
}

function getOEOtherInfo(row) {
	var adm = getValueById("episodeId");
	var myOEPrice = (row.OPOrdType == "P") ? row.OPOrdPrice : "";
	var encmeth = getValueById("OPOEInfoEncrypt");
	if (encmeth) {
		cspRunServerMethod(encmeth, "wrtOEOtherInfo", adm, row.OPOrdItemRowID, "", row.OPOrdInsRowId, row.OPOrdType, myOEPrice, "ARCIM", PUBLIC_CONSTANT.SESSION.HOSPID);
	}
}

function wrtOEOtherInfo(str) {
	var row = GV.OEItmList.getRows()[GV.EditRowIndex];
	if (!row) {
		return;
	}
	var myAry = str.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	setGridCellValue(GV.EditRowIndex, "OPOrdDiscPrice", myAry[1]);
	row.OPOrdDiscPrice = myAry[1];
	
	setGridCellValue(GV.EditRowIndex, "OPOrdInsPrice", myAry[2]);
	row.OPOrdInsPrice = myAry[2];
	
	setGridCellValue(GV.EditRowIndex, "OPOrdPatPrice", myAry[3]);
	row.OPOrdPatPrice = myAry[3];
	
	var ordBillSum = calcNew(row.OPOrdPrice, row.OPOrdDiscPrice, row.OPOrdInsPrice, row.OPOrdQty);
	setGridCellValue(GV.EditRowIndex, "OPOrdBillSum", ordBillSum);
	row.OPOrdBillSum = ordBillSum;
}

function calcNew(a, b, c, num) {
	if (a && b && c && num) {
		var mynuma1 = parseFloat(a);
		if (isNaN(mynuma1)) {
			var mynuma1 = 0;
		}
		var mynumb1 = parseFloat(b);
		if (isNaN(mynumb1)) {
			var mynumb1 = 0;
		}
		var mynumc1 = parseFloat(c);
		if (isNaN(mynumc1)) {
			var mynumc1 = 0;
		}
		var mynum2 = parseFloat(num);
		if (isNaN(mynum2)) {
			mynum2 = 0;
		}
		var a1 = mynuma1 * mynum2 + 0.0000001;
		var b1 = mynumb1 * mynum2 + 0.0000001;
		var c1 = mynumc1 * mynum2 + 0.0000001;
		a1 = a1.toFixed(2);
		b1 = b1.toFixed(2);
		c1 = c1.toFixed(2);
		var aa1 = a1 - b1;
		aa1 = aa1.toFixed(2);
		var myres = aa1 - c1;
		return myres.toFixed(2);
	}
}

function onDblClickRowHandler(index, row) {
	var ordItmId = row.OrdRowId;
	if (ordItmId) {
		$.messager.popover({msg: "已开医嘱不能修改", type: "info"});
		return;
	}
	if (GV.EditRowIndex != index) {
		if (endEditing()) {
			beginEditing(index);
			GV.EditRowIndex = index;
		} else {
			GV.OEItmList.selectRow(GV.EditRowIndex);
		}
	}
}

function onBeginEditHandler(index, row) {
	var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdPrice"});
	if (ed) {
		$(ed.target).keyup(function(e) {
		  	ordPriceKeyup(e);
		});
	}
	var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdQty"});
	if (ed) {
		$(ed.target).keydown(function(e) {
		  	ordQtyKeydown(e);
		});
	}
	var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdItemDesc"});
	if (ed) {
		$(ed.target).next("span").find("input").focus();
	}
}

function onEndEditHandler(index, row) {
	var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdItemDesc"});
	if (ed) {
		row.OPOrdItemDesc = $(ed.target).combogrid("getText");
	}
	var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdItemRecLoc"});
	if (ed) {
		row.OPOrdItemRecLoc = $(ed.target).combobox("getText");
	}
	if (!row.OPOrdItemRowID) {
		return;
	}
	if (!row.OPOrdQty || !row.OPOrdItemRecLocRID) {
		return;
	}
	GV.OEItmList.checkRow(index);
}

function beginEditing(index) {
	GV.OEItmList.selectRow(index);
	GV.OEItmList.beginEdit(index);
	
	var row = GV.OEItmList.getRows()[index];
	if (row && (row.OPOrdType != "P")) {
		var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdPrice"});
		if (ed) {
			$(ed.target).prop("disabled", true);
		}
	};
}

function endEditing() {
	if (GV.EditRowIndex == undefined) {
		return true;
	}
	if (validateRow(GV.EditRowIndex)) {
		GV.OEItmList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function validateRow(index) {
	var row = GV.OEItmList.getRows()[index];
	if (!row) {
		return false;
	}
	if (!row.OPOrdItemRowID) {
		return true;
	}
	if (!row.OPOrdQty || !row.OPOrdItemRecLocRID) {
		return false;
	}
	return checkAddData(row);
}

function checkAddData(row) {
	var maxQty = checkARCIMMaxQty(row.OPOrdItemRowID, row.OPOrdQty);
	if (maxQty != "0") {
		$.messager.popover({msg: row.OPOrdItemDesc + "超过最大数量：" + maxQty, type: "info"});
		return false;
	}
	var rtn = checkStock(row.OPOrdItemRowID, row.OPOrdQty, row.OPOrdItemRecLocRID);
	if (rtn) {
		$.messager.popover({msg: row.OPOrdItemDesc + "库存不足", type: "info"});
		return false;
	}
	return true;
}

function ordPriceKeyup(e) {
	var row = GV.OEItmList.getRows()[GV.EditRowIndex];
	if (!row) {
		return;
	}
	if (!$(e.target).is(":focus")) {
		return;
	}
	clearNoNum(e.target);
	row.OPOrdPrice = $(e.target).val();
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			$(e.target).focus();
			return;
		}
		var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdQty"});
		if (ed) {
			$(ed.target).focus().select();
		}
	}else {
		getOEOtherInfo(row);
	}
}

function clearNoNum(obj) {
	//先把非数字的都替换掉，除了数字和
	$(obj).val($(obj).val().replace(/[^\d.]/g, ""));
	//必须保证第一个为数字而不是.
	$(obj).val($(obj).val().replace(/^\./g, ""));
	//保证只有出现一个.而没有多个.
	$(obj).val($(obj).val().replace(/\.{2,}/g, "."));
	//保证.只出现一次，而不能出现两次以上
	$(obj).val($(obj).val().replace(".", "$#$").replace(/\./g,"").replace("$#$", "."));
}

function ordQtyKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			$(e.target).focus();
			return;
		}
		var row = GV.OEItmList.getRows()[GV.EditRowIndex];
		if (!row) {
			return;
		}
		row.OPOrdQty = $(e.target).val();
		getOEOtherInfo(row);
		appendEditRow();
	}
}

function appendEditRow() {
	var row = {};
	var val = "";
	$.each(GV.OEItmList.getColumnFields(), function (index, item) {
		val = "";
		if (item == "OPOrdInsRowId") {
			val = getSelectedInsType();
		}
		if (item == "OPOrdBillFlag") {
			val = "1";
		}
		row[item] = val;
	});
	if (endEditing()) {
		GV.OEItmList.appendRow(row);
		GV.EditRowIndex = GV.OEItmList.getRows().length - 1;
		beginEditing(GV.EditRowIndex);
	}
}

/**
* 判断库存
*/
function checkStock(arcim, packQty, recLoc) {
	var encmeth = getValueById("OPOrdCheckStockEncrypt");
	try {
		var rtn = cspRunServerMethod(encmeth, arcim, packQty, recLoc);
		if (+rtn <= 0) {
			return true;
		} else {
			return false;
		}
	} catch (e) {
		$.messager.popover({msg: e.message, type: "error"});
		return false;
	}
}

function checkARCIMMaxQty(arcimId, qty) {
	var rtn = "0";
	var encmeth = getValueById("GetARCIMMaxQty");
	var maxQty = cspRunServerMethod(encmeth, arcimId);
	if (parseFloat(maxQty) > 0) {
		if (parseFloat(qty) > parseFloat(maxQty)) {
			rtn = maxQty;
		}
	}
	return rtn;
}

function arcositemListOpen(itemId, itemDesc, del, itemText, ordRowIdString) {
	if (!ordRowIdString) {
		ordRowIdString = "";
	}
	var adm = getValueById("episodeId");
	var insTypeId = getSelectedInsType();
	var url = "dhcbill.opbill.arcositemlist.csp?&OrderSetId=" + itemId + "&HiddenDelete=" + del + "&ARCIMDesc=" + itemDesc + "&PatientID=" + getValueById("papmi") + "&EpisodeID=" + adm + "&OSOrderRowIDs=" + escape(ordRowIdString) + "&InsTypeID=" + insTypeId;
	websys_showModal({
		url: url,
		title: '医嘱套录入',
		iconCls: 'icon-w-list',
		width: 780,
		height: 450,
		originWindow: window
	});
}

function addCopyItemToList(arcosItmRow) {
	if (!arcosItmRow) {
		return;
	}
	if (!endEditing()) {
		return;
	}
	var row = {};
	var val = "";
	$.each(GV.OEItmList.getColumnFields(), function (index, item) {
		val = "";
		if (item == "OPOrdBillFlag") {
			val = "1";
		}
		row[item] = arcosItmRow[item] || val;
	});
	if (!checkAddData(row)) {
		return;
	}
	GV.OEItmList.appendRow(row);
	var index = GV.OEItmList.getRows().length - 1;
	GV.OEItmList.checkRow(index);
	GV.OEItmList.scrollTo(index);
}