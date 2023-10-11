/**
 * FileName: dhcbill.opbill.charge.oelist.js
 * Author: ZhYW
 * Date: 2019-06-03
 * Description: 门诊收费
 */

$(function () {
	initOEListMenu();
	initOrdItmList();
});

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
	
	//就诊医生
	$HUI.combobox("#admDoc", {
		panelHeight: 150,
		method: 'GET',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		delay: 300,
		blurValidValue: true,
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			if ($.trim(param.q).length > 1) {
				$("#admDoc").combobox("options").url = $URL;
				param.ClassName = "web.DHCOPCashier";
				param.QueryName = "FindCTCareProv";
				param.ResultSetType = "array";
				param.desc = param.q;
				param.sessionStr = getSessionStr()
			}
		}
	});
}

function initOrdItmList() {
	var loadSuccess = false;
	var prescClsObj = {};
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		border: false,
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		rownumbers: true,
		pageSize: 999999999,
		sortName: 'InsuDicDesc',   //按病种排序
		toolbar: '#ordlist-tb',
		view: detailview,
		detailFormatter: function(rowIndex, rowData) {
			return "<div style=\"padding:2px;\"><table class=\"ddv\"></table></div>"
		},
		onExpandRow: function(rowIndex, rowData) {
			var $ddv = GV.OEItmList.getRowDetail(rowIndex).find("table.ddv");
			$ddv.datagrid({
				width: 610,
				height: 'auto',
				bodyCls: 'panel-body-gray',
				singleSelect: true,
				loadMsg: '',
				rownumbers: true,
				pageList: [3, 5],
				pageSize: 3,
				pagination: true,
				columns: [[{title: 'tarId', field: 'tarItmId', hidden: true},
						   {title: '收费项', field: 'tarItmDesc', width: 180},
						   {title: '单位', field: 'uomDesc', width: 80},
						   {title: 'price', field: 'price', hidden: true},
						   {title: 'discPrice', field: 'discPrice', hidden: true},
						   {title: 'payorPrice', field: 'payorPrice', hidden: true},
						   {title: '单价', field: 'patPrice', width: 100, align: 'right'},
						   {title: '数量', field: 'qty', width: 80},
						   {title: '总金额', field: 'totalAmt', hidden: true},
						   {title: '折扣金额', field: 'discAmt', hidden: true},
						   {title: '记账金额', field: 'payorAmt', hidden: true},
						   {title: '金额', field: 'patAmt', width: 120, align: 'right'}
				]],
				url: $URL,
				queryParams: {
					ClassName: "web.DHCOPCashier",
					QueryName: "QryOrdTarItmList",
					oeitm: rowData.OrdRowId,
					insTypeId: getSelectedInsType(),
					sessionStr: getSessionStr()
				},
				onLoadSuccess: function(data) {
					setTimeout(function() {
						GV.OEItmList.fixDetailRowHeight(rowIndex);    //用来固定当详细内容加载时的行高度
					}, 0);
				}
			});
			GV.OEItmList.fixDetailRowHeight(rowIndex);    //用来固定当详细内容加载时的行高度
		},
		columns: [[{field: 'ck', checkbox: true},
				   {title: 'TGroup', field: 'TGroup', hidden: true},
				   {title: '医嘱', field: 'OPOrdItemDesc', width: 180,
				    formatter: function (value, row, index) {
						if (row.UnBillReason) {
							return "<a onmouseover='showUnBillReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
						}
						return value;
					},
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
							url: $URL + '?ClassName=web.DHCOPItemMast&QueryName=ARCIMastList',
							delay: 500,
							lazy: true,
							enterNullValueClear: false,
							selectOnNavigation: false,
							columns: [[{field: 'ARCIMastDesc', title: '医嘱名称', width: 180},
									   {field: 'ARCIMastRowID', title: 'ARCIMastRowID', hidden: true},
								   	   {field: 'ARCSubCat', title: '子类', width: 80},
								   	   {field: 'SubCatOrderType', title: 'SubCatOrderType', hidden: true},
								   	   {field: 'UOMID', title: 'UOMID', hidden: true},
									   {field: 'UOMDesc', title: '单位', width: 80},
									   {field: 'ItemPrice', title: '价格', width: 120, align: 'right'},
									   {field: 'ARCType', title: 'ARCType', hidden: true}
							]],
							onBeforeLoad: function (param) {
								var adm = getValueById("episodeId");
								if (!adm) {
									return false;
								}
								param.ItemMCode = param.q;
								param.ARCCATCode = "";
								param.EpisodeID = adm;
								param.SessionStr = getSessionStr();
							},
							onSelect: function(index, row) {
								onSelectArcimHandler(row);
							}
						}
					}
				   },
				   {title: '单位', field: 'OPOrdUnit', width: 80},
				   {title: '单价', field: 'OPOrdPrice', width: 100, align: 'right', editor: 'text'},
				   {title: '数量', field: 'OPOrdQty', width: 80, editor: 'text'},
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
				   {title: 'OEORIDR', field: 'OEORIDR',hidden: true},
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
				   {title: '病种', field: 'InsuDicDesc', width: 160, sortable: true},
				   {title: '是否重收', field: 'IsReChged', width: 80,
				    formatter: function (value, row, index) {
						return (value == 1) ? ('<font color="#21ba45">' + $g('是') + '</font>') : ('<font color="#f16e57">' + $g('否') + '</font>');
					}
				   },
				   {title: 'OPOrdUOMID', field: 'OPOrdUOMID', hidden: true}
			]],
		onLoadSuccess: function (data) {
			GV.EditRowIndex = undefined;
			loadSuccess = false;
			prescClsObj = {};
			$(this).datagrid("clearChecked");
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (!row.OrdRowId) {
					return true;
				}
				if (row.OPOrdBillFlag == 1) {
					GV.OEItmList.checkRow(index);
				}else {
					GV.OEItmList.uncheckRow(index);
				}
				if (row.LimitItmFlag == "Y") {
					hasDisabledRow = true;
				}
				GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = (row.LimitItmFlag == "Y");
			});
			//有disabled行时,表头也disabled
			GV.OEItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
			loadSuccess = true;
			calcAdm();
		},
		rowStyler: function(index, row) {
			if (row.PrescriptionNo) {
				if (!prescClsObj[row.PrescriptionNo]) {
					var modeNum = ((Object.keys(prescClsObj).length + 1) % CV.PrescClsCount) || CV.PrescClsCount;
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
			ctrlOrdLink(rowIndex, rowData);
			calcAdm();
			reloadCateList();
		},
		onUncheck: function (rowIndex, rowData) {
			pushUnBillOrder(rowData.OrdRowId);
			if (!loadSuccess) {
				return;
			}
			if (GV.SelOrdRowIdx !== undefined) {
				return;
			}
			ctrlOrdLink(rowIndex, rowData);
			calcAdm();
			reloadCateList();
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
			reloadCateList();
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
			reloadCateList();
		},
		onBeginEdit: function(rowIndex, rowData) {
			onBeginEditHandler(rowIndex, rowData);
    	},
		onDblClickRow: function(rowIndex, rowData) {
			onDblClickRowHandler(rowIndex, rowData);
		},
		onEndEdit: function(rowIndex, rowData, changes) {
			onEndEditHandler(rowIndex, rowData);
		}
	});
	
	GV.OEItmList.loadData({rows: [], total: 0});
}

/**
* 控制医嘱同步勾选
*/
function ctrlOrdLink(rowIndex, rowData) {
	prescLink(rowIndex, rowData);     //处方勾选同步
	groupLink(rowIndex, rowData);     //成组医嘱勾选同步
	regFeeLink(rowIndex, rowData);    //挂号医嘱勾选同步
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
		linkItm(checked, index);
	});
}

function groupLink(rowIndex, rowData) {
	if (!rowData.OEORIDR) {
		return;
	}
	if (!CV.IsTgtChrgGroupOrd) {
		//成组医嘱是否一起收费
		return;
	}
	var checked = GV.OEItmList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + rowIndex + "]").hasClass("datagrid-row-checked");
	$.each(GV.OEItmList.getRows(), function (index, row) {
		if ((rowIndex == index) || (rowData.OEORIDR != row.OEORIDR)) {
			return true;
		}
		linkItm(checked, index);
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
		linkItm(checked, index);
	});
}

function linkItm(checked, index) {
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

/**
* 显示不能收费原因
*/
function showUnBillReason(that, row) {
	$(that).popover({
		title: "<font color=\"#FF0000\">" + row.OPOrdItemDesc + "</font>" + "不能收费原因",
		trigger: 'hover',
		content: row.UnBillReason
	}).popover("show");
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
		AdmStr: adm,
		InsTypeId: curInsType,
		UnBillStr: unBillStr,
		SessionStr: getSessionStr(),
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
				var multNum = (isHerb == 1) ? (getValueById("multNum") || 1) : 1;
				
				myStr = row.OPOrdItemRowID + "^";
				myStr += (row.OPOrdQty * multNum) + "^";
				myStr += row.OPOrdItemRecLocRID + "^";
				myStr += row.OPOrdPrice + "^";
				myStr += row.OPOrdUOMID + "^";
				myStr += row.OPOrdInsRowId + "^";
				ordItmStrAry.push(myStr);
				ordRowIndexAry.push(index);
			}
		});
		if (ordItmStrAry.length > 0) {
			var ordItmStr = ordItmStrAry.join(PUBLIC_CONSTANT.SEPARATOR.CH1);
			var rtn = $.m({ClassName: "web.DHCOPCashierIF", MethodName: "CashierInsertOrdItem", Adm: adm, OrdItemStr: ordItmStr, User: PUBLIC_CONSTANT.SESSION.USERID, Loc: PUBLIC_CONSTANT.SESSION.CTLOCID, DocUserId: docUserId}, false);
			//医生站接口返回0或100说明保存医嘱失败
			if (["0", "100"].indexOf(rtn) == -1) {
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
			$.m({ClassName: "web.DHCOPCashierIF", MethodName: "CreatePrescNo", wantreturnval: 0, Adm: adm, UserId: PUBLIC_CONSTANT.SESSION.USERID}, false);
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
	return !(GV.OEItmList.getRows().some(function (row) {
		return !row.OrdRowId;
	}));
}

function calcAdm() {
	var totalAmt = 0;
	var discAmt = 0;
	var payorAmt = 0;
	var patPayAmt = 0;
	$.each(GV.OEItmList.getChecked(), function (index, row) {
		totalAmt = Number(totalAmt).add(Number(row.OPOrdQty).mul(row.OPOrdPrice)).toFixed(2);
		discAmt = Number(discAmt).add(row.DiscAmt).toFixed(2);
		payorAmt = Number(payorAmt).add(row.PayorAmt).toFixed(2);
		patPayAmt = Number(patPayAmt).add(row.OPOrdBillSum).toFixed(2);
	});
	setValueById("curDeptShare", patPayAmt);

	var selAdmListRow = GV.AdmList.getSelected();
	if (selAdmListRow) {
		var rowIndex = GV.AdmList.getRowIndex(selAdmListRow);
		if (rowIndex >= 0) {
			GV.AdmList.updateRow({
				index: rowIndex,
				row: {
					admTotalSum: Number(totalAmt).toFixed(2),
					admDiscSum: Number(discAmt).toFixed(2),
					admPayOrSum: Number(payorAmt).toFixed(2),
					admPatSum: Number(patPayAmt).toFixed(2)
				}
			});
		}
	}
	
	var totalSum = 0;
	var discSum = 0;
	var payorSum = 0;
	var patShareSum = 0;
	$.each(GV.AdmList.getRows(), function (index, row) {
		totalSum = Number(totalSum).add(row.admTotalSum).toFixed(2);
		discSum = Number(discSum).add(row.admDiscSum).toFixed(2);
		payorSum = Number(payorSum).add(row.admPayOrSum).toFixed(2);
		patShareSum = Number(patShareSum).add(row.admPatSum).toFixed(2);
	});
	setValueById("patShareSum", patShareSum);
}

function pushUnBillOrder(oeitm) {
	if (!oeitm) {
		return;
	}
	var adm = getValueById("episodeId");
	if (adm) {
		var index = GV.UnBillOrdObj[adm].indexOf(oeitm);
		if (index == -1) {
			GV.UnBillOrdObj[adm].push(oeitm);
		}
	}
}

function spliceUnBillOrder(oeitm) {
	if (!oeitm) {
		return;
	}
	var adm = getValueById("episodeId");
	if (adm) {
		var index = GV.UnBillOrdObj[adm].indexOf(oeitm);
		if (index != -1) {
			GV.UnBillOrdObj[adm].splice(index, 1);
		}
	}
}

function getUnBillOrderStr() {
	var unBillOrderStr = "";
	var splitter = "";
	var myStr = "";
	$.each(GV.UnBillOrdObj, function(key, val) {
		if (val.length == 0) {
			return true;
		}
		splitter = PUBLIC_CONSTANT.SEPARATOR.CH2 + key + PUBLIC_CONSTANT.SEPARATOR.CH2;
		myStr = splitter + "^" + val.join("^") + "^" + splitter;
		unBillOrderStr += myStr;
	});
	return unBillOrderStr;
}

function addClick() {
	var adm = getValueById("episodeId");
	if (!adm) {
		return;
	}
	if (GV.EditRowIndex !== undefined) {
		var row = GV.OEItmList.getRows()[GV.EditRowIndex];
		if (!row || !row.OPOrdItemRowID) {
			focusOrdItem(GV.EditRowIndex);
			return;
		}
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
		if (!r) {
			return;
		}
		var ordItmId = row.OrdRowId;
		var oldUserId = $.m({ClassName: "web.DHCOPItemMast", MethodName: "GetOrdUser", OrdItem: ordItmId, NewUserRowId: PUBLIC_CONSTANT.SESSION.USERID}, false);
		if (oldUserId != PUBLIC_CONSTANT.SESSION.USERID) {
			$.messager.popover({msg: "非本人开的医嘱不允许删除", type: "info"});
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
	});
}

/**
* 停医嘱
*/
function stopOrdItem(ordItmId, stopOrdInfo) {
	try {
		if (!ordItmId) {
			return true;
		}
		var encmeth = getValueById("OPOrdStopItemEncrypt");
		var rtn = cspRunServerMethod(encmeth, ordItmId, stopOrdInfo);
		if (rtn != 0) {
			throw getErrObj("停医嘱失败：" + rtn + "，入参串：" + ordItmId + "~" + stopOrdInfo);
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
		loadCateList(adm);
	}
}

function onSelectArcimHandler(row) {
	if (!row) {
		return;
	}
	var tableName = "";
	switch(row.ARCType) {
	case "ARCIM":
		tableName = "User.ARCItmMast";
		setOrdItem(row);
		break;
	case "ARCOS":
		tableName = "User.ARCOrdSets";
		arcositemListOpen(row);
		break;
	default:
	}
	
	//记录基础代码数据使用次数
	if (tableName) {
		BILL_INF.saveCTUseCount(tableName, row.ARCIMastRowID);     //dhcbill.interface.js
	}
}

function setOrdItem(row) {
	var editRow = GV.OEItmList.getRows()[GV.EditRowIndex];
	if (!editRow) {
		return;
	}
	editRow.OPOrdItemRowID = row.ARCIMastRowID;
	editRow.OPOrdType = row.SubCatOrderType;
	
	var ordQty = 1;
	setGridCellValue(GV.EditRowIndex, "OPOrdQty", ordQty);
	editRow.OPOrdQty = ordQty;
	
	setGridCellValue(GV.EditRowIndex, "OPOrdUnit", row.UOMDesc);
	editRow.OPOrdUnit = row.UOMDesc;
	editRow.OPOrdUOMID = row.UOMID;
	
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
		//自定义价格医嘱
		setTimeout(function() {
			var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdPrice"});
			if (ed) {
				$(ed.target).prop("disabled", false).focus().select();
			}
		}, 100);
		return;
	}
	
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
	
	var ordBillSum = Number(row.OPOrdPrice).mul(row.OPOrdQty).sub(Number(row.OPOrdDiscPrice).mul(row.OPOrdQty)).sub(Number(row.OPOrdInsPrice).mul(row.OPOrdQty)).toFixed(2);  //总金额-折扣金额-记账金额
	setGridCellValue(GV.EditRowIndex, "OPOrdBillSum", ordBillSum);
	row.OPOrdBillSum = ordBillSum;
}

function onDblClickRowHandler(index, row) {
	var ordItmId = row.OrdRowId;
	if (ordItmId) {
		$.messager.popover({msg: "已开医嘱不能修改", type: "info"});
		return;
	}
	if (GV.EditRowIndex == index) {
		return;
	}
	if (endEditing()) {
		beginEditing(index);
		GV.EditRowIndex = index;
		return;
	}
	GV.OEItmList.selectRow(GV.EditRowIndex);
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
		$(ed.target)
		.keyup(function(e) {
		  	ordQtyKeyup(e);
		})
		.keydown(function(e) {
		  	ordQtyKeydown(e);
		});
	}
	focusOrdItem(index);   //光标定位到医嘱combogrid编辑器
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
	if (GV.EditRowIndex === undefined) {
		return true;
	}
	if (validateRow(GV.EditRowIndex)) {
		GV.OEItmList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
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
	var arcimDesc = row.OPOrdItemDesc;
	if (!arcimDesc && (GV.EditRowIndex !== undefined)) {
		var ed = GV.OEItmList.getEditor({index: GV.EditRowIndex, field: "OPOrdItemDesc"});
		if (ed) {
			arcimDesc = $(ed.target).combogrid("getText");
		}
	}
	var maxQty = checkARCIMMaxQty(row.OPOrdItemRowID, row.OPOrdQty);
	if (maxQty != 0) {
		$.messager.popover({msg: arcimDesc + "超过最大数量：" + maxQty, type: "info"});
		return false;
	}
	var rtn = checkStock(row.OPOrdItemRowID, row.OPOrdQty, row.OPOrdItemRecLocRID);
	if (rtn) {
		$.messager.popover({msg: arcimDesc + "库存不足", type: "info"});
		return false;
	}
	var rtn = isAllowedDecimalQty(row.OPOrdItemRowID);
	if (!rtn && !(/^[1-9]\d*$/).exec(row.OPOrdQty)) {
		$.messager.popover({msg: arcimDesc + "只能录入正整数", type: "info"});
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
	fixDecimal(e.target);
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

function fixInteger(obj) {
	//把非数字的都替换掉
	$(obj).val($(obj).val().replace(/[^\d]/g, ""));
	//必须保证第一个非0
	$(obj).val($(obj).val().replace(/^0/g, ""));
}

function fixDecimal(obj) {
	//先把非数字的都替换掉，除了数字和.
	$(obj).val($(obj).val().replace(/[^\d.]/g, ""));
	//必须保证第一个为数字而不是.
	$(obj).val($(obj).val().replace(/^\./g, ""));
	//保证只有出现一个.而没有多个.
	$(obj).val($(obj).val().replace(/\.{2,}/g, "."));
	//保证.只出现一次，而不能出现两次以上
	$(obj).val($(obj).val().replace(".", "$#$").replace(/\./g,"").replace("$#$", "."));
}

function ordQtyKeyup(e) {
	var row = GV.OEItmList.getRows()[GV.EditRowIndex];
	if (!row || !row.OPOrdItemRowID) {
		return;
	}
	if (isAllowedDecimalQty(row.OPOrdItemRowID)) {
		fixDecimal(e.target);
	}else {
		fixInteger(e.target);
	}
	row.OPOrdQty = $(e.target).val();
}

function ordQtyKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			$(e.target).focus();
			return;
		}
		var row = GV.OEItmList.getRows()[GV.EditRowIndex];
		if (!row || !row.OPOrdItemRowID) {
			focusOrdItem(GV.EditRowIndex);
			return;
		}
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
* 光标定位到医嘱combogrid编辑器
*/
function focusOrdItem(index) {
	if ((index | 0) === index) {   //判断是否是整数
		var ed = GV.OEItmList.getEditor({index: index, field: "OPOrdItemDesc"});
		if (ed) {
			$(ed.target).next("span").find("input").focus();
		}
	}
}

/**
* 判断库存
*/
function checkStock(arcim, packQty, recLoc) {
	var expStr = getValueById("episodeId") + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	var encmeth = getValueById("OPOrdCheckStockEncrypt");
	return (cspRunServerMethod(encmeth, arcim, packQty, recLoc, expStr) <= 0);
}

function checkARCIMMaxQty(arcimId, qty) {
	var encmeth = getValueById("GetARCIMMaxQty");
	var maxQty = cspRunServerMethod(encmeth, arcimId);
	return (((+maxQty > 0) && (+qty > +maxQty)) ? maxQty : 0);
}

/**
* 医嘱数量是否可以录入小数
*/
function isAllowedDecimalQty(arcim) {
	return ($.m({ClassName: "web.DHCOPCashier", MethodName: "IsAllowedDecimalQty", arcim: arcim, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

function arcositemListOpen(row) {
	var itemId = row.ARCIMastRowID;
	var adm = getValueById("episodeId");
	var insTypeId = getSelectedInsType();
	var url = "dhcbill.opbill.arcositemlist.csp?&OrderSetId=" + itemId + "&HiddenDelete=" + "YES";
	url += "&PatientID=" + getValueById("patientId") + "&EpisodeID=" + adm + "&InsTypeID=" + insTypeId;
	websys_showModal({
		url: url,
		title: '医嘱套录入',
		iconCls: 'icon-w-list',
		width: 780,
		height: 450,
		callbackFuns: [addCopyItemToList, appendEditRow]
	});
}

function addCopyItemToList(arcosItmRow) {
	if (!arcosItmRow) {
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

/**
* 2022-10-19
* ZhYW
* 根据所选病种勾选医嘱
*/
function checkOrdByChronicCode(chronicCode) {
	$.each(GV.OEItmList.getRows(), function(index, row) {
		if (GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] div.datagrid-cell-check>input:checkbox").prop("disabled")) {
			return true;
		}
		if (row.InsuDicCode == chronicCode) {
			GV.OEItmList.checkRow(index);
			return true;
		}
		GV.OEItmList.uncheckRow(index);
	});
}