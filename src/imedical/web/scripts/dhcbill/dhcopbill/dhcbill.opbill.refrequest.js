/**
 * FileName: dhcbill.opbill.refrequest.js
 * Author: ZhYW
 * Date: 2018-10-10
 * Description: 门诊退费申请
 */

$.extend($.fn.validatebox.defaults.rules, {
	validMaxQty: {                         //验证申请数量不能超过可退数量
		validator: function (value, param) {
			if (!(value > 0)) {
				return true;     //非正数时在reqQty的Keyup事件中处理，这里返回true
			}
			var index = $(this).parents(".datagrid-row").attr("datagrid-row-index") || "";
			if (!index) {
				return true;
			}
			var row = GV.OEItmList.getRows()[index];
			var canRetQty = row.canRetQty;
			var bool = !(+value > +canRetQty);
			setOrdItmRowChecked(index, bool);
			ctrlOrdItm(index, row);
			calcRefAmt();
			return bool;
		},
		message: $g("申请数量不能大于可退数量")
	}
});

$(function () {
	initQueryMenu();
	initInvList();
	initOrdItmList();
});

function initQueryMenu() {
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//发票回车查询事件
	$("#invNo").keydown(function (e) {
		invNoKeydown(e);
	});

	$HUI.linkbutton("#btn-request", {
		onClick: function () {
			requestClick();
		}
	});

	$HUI.linkbutton("#btn-cancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});

	var $tb = $("#more-container");
	if (HISUIStyleCode == "lite") {
		$(".arrows-b-text").css("color", "#339EFF");
		$tb.find(".spread-b-down").removeClass("spread-b-down").addClass("spread-l-down");
	};
	$tb.click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "l" : "b";
		if (t.find(".arrows-b-text").text() == $g("更多")) {
			t.find(".arrows-b-text").text($g("收起"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-tr").slideDown("normal", setHeight(40));
		} else {
			t.find(".arrows-b-text").text($g("更多"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-tr").slideUp("fast", setHeight(-40));
		}
	});
	
	//退费原因
	$HUI.combobox("#refReason", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryRefReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		editable: false,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		onLoadSuccess: function(data) {
			if (data.length > 0) {
				setValueById("refReason", data[0].id);
			}
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			$("#CardNo").focus();
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	if (patientId != "") {
		loadInvList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CheckIsStayInv",
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == "Y") {
				$.messager.alert("提示", "该发票为急诊留观发票，若需退费请停止医嘱", "info");
				return;
			}
			loadInvList();
		});
	}
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout:eq(1)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-tr").show();
	} else {
		$("tr.display-more-tr").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

function initInvList() {
	GV.InvList = $HUI.datagrid("#invList", {
		fit: true,
		border: false,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillRefundRequest",
		queryName: "FindInvInfo",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TINVRowid", "TabFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(this).datagrid("clearChecked");
		},
		onCheck: function (rowIndex, row) {
			initReqPanel();
		},
		onUncheck: function (rowIndex, row) {
			initReqPanel();
		},
		onCheckAll: function (rows) {
			initReqPanel();
		},
		onUncheckAll: function (rows) {
			initReqPanel();
		}
	});
	
	//头菜单有值时，根据患者登记号查询
	var frm = dhcsys_getmenuform();
	if (frm && frm.PatientID.value) {
		var patientNo = getPropValById("PA_PatMas", frm.PatientID.value, "PAPMI_No");
		loadInvList();
	}
}

function loadInvList() {
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindInvInfo",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		ReceiptNO: getValueById("invNo"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		ChargeUser: getValueById("userName"),
		SessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

function initOrdItmList() {
	GV.OEItmList = $HUI.datagrid("#ordItmList", {
		fit: true,
		title: '医嘱明细',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pageSize: 999999999,
		toolbar: [],
		frozenColumns: [[{field: 'ck', checkbox: true},
		           		 {title: '医嘱', field: 'arcimDesc', width: 180,
			           	  	formatter: function (value, row, index) {
								if (!row.reqRowId && row.cantRetReasonStr) {
									return "<a onmouseover='showCantRefReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
								}
								if (row.reqRowId && row.cantDelReasonStr) {
									return "<a onmouseover='showCantDelReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
								}
								return value;
						  	}
		           		 }
			]],
		columns: [[{title: '申请部位', field: 'repPartTar', width: 80, align: 'center',
					formatter: function (value, row, index) {
						if ((row.isAppRep != 'Y') || row.reqRowId) {
							return;
						}
						if (row.select == 1) {
							return "<a href='javascript:;' class='editCls' onclick=\"openPartWinOnClick(\'" + index + "\')\">部位</a>";
						}
					}
				   },
				   {title: '金额', field: 'billAmt', align: 'right', width: 60},
				   {title: '数量/单位', field: 'billQty', width: 85,
					formatter: function (value, row, index) {
						return value + '/' + row.packUom;
					}
				   },
				   {title: 'packQty', field: 'packQty', hidden: true},
				   {title: '可退数量', field: 'canRetQty', width: 80},
				   {title: '申请数量', field: 'reqQty', width: 80,
					editor: {
						type: 'validatebox',
						options: {
							validType: ['validMaxQty']
						}
					}
				   },
				   {title: '已申请数量', field: 'alreadyReqQty', width: 95},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '开单科室', field: 'ordDept', width: 120},
				   {title: '接收科室', field: 'recDept', width: 120},
				   {title: '执行情况', field: 'execInfo', width: 160},
				   {title: '申请人', field: 'reqUserName', width: 80},
				   {title: '申请时间', field: 'reqDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + ' ' + row.reqTime;
					}
				   },
				   {title: '医嘱ID', field: 'oeori', width: 80},
				   {title: 'select', field: 'select', hidden: true},
				   {title: 'isExecute', field: 'isExecute', hidden: true},
				   {title: 'price', field: 'price', hidden: true},
				   {title: 'confac', field: 'confac', hidden: true},
				   {title: 'prtId', field: 'prtId', hidden: true},
				   {title: 'pboId', field: 'pboId', hidden: true},
				   {title: 'dspbId', field: 'dspbId', hidden: true},
				   {title: 'phdicId', field: 'phdicId', hidden: true},
				   {title: 'arcim', field: 'arcim', hidden: true},
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: 'isEdit', field: 'isEdit', hidden: true},
				   {title: 'isAppRep', field: 'isAppRep', hidden: true},
				   {title: 'isCNMedItem', field: 'isCNMedItem', hidden: true},
				   {title: 'isOweDrug', field: 'isOweDrug', hidden: true},
				   {title: 'reqRowId', field: 'reqRowId', hidden: true}
			]],
		rowStyler: function (index, row) {
			if (row.reqRowId) {
				return "background-color: #FFEFD5;";
			}
		},
		onLoadSuccess: function (data) {
			$(".editCls").linkbutton({text: $g("部位")});
			$(this).datagrid("clearChecked");
			GV.EditIndex = undefined;
			var hasDisabledRow = false;
			var CNMedPrescObj = {};
			var CNMedMark = "CNMEDPRESC";
			$.each(data.rows, function (index, row) {
				if (row.select != 1) {
					hasDisabledRow = true;
					GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
				}
				//控制草药一条医嘱disable时，整个处方医嘱都disable，后台循环输出麻烦，先在前台控制
				if (row.isCNMedItem == 1) {
					if (!CNMedPrescObj[row.prescNo]) {
						CNMedPrescObj[row.prescNo] = index;
					}else {
						CNMedPrescObj[row.prescNo] = CNMedPrescObj[row.prescNo] + "^" + index;
					}
					if (row.select != 1) {
						CNMedPrescObj[row.prescNo + CNMedMark] = true;   //草药处方能否退费申请?
					}
				}
			});
			
			//控制草药处方disable
			$.each(Object.keys(CNMedPrescObj), function(index, prop) {
				if (prop.endsWith(CNMedMark)) {
					return true;
				}
				if (!CNMedPrescObj[prop + CNMedMark]) {
					return true;
				}
				var myAry = String(CNMedPrescObj[prop]).split("^");
				$.each(myAry, function (idx, rowIdx) {
					GV.OEItmList.setFieldValue({index: rowIdx, field: "select", value: 0});
					GV.OEItmList.getPanel().find(".datagrid-row[datagrid-row-index=" + rowIdx + "] input:checkbox")[0].disabled = true;
				});
			});

			//有disabled行时,表头也disabled
			GV.OEItmList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onClickRow: function (index, row) {
			if ((GV.EditIndex != index) && (canEdit(row))) {
				if (endEditing()) {
					$(this).datagrid("selectRow", index).datagrid("beginEdit", index);
					GV.EditIndex = index;
					reqQtyFocus(index);
				} else {
					$(this).datagrid("selectRow", GV.EditIndex);
				}
			}
		},
		onCheck: function (index, row) {
			setRowsAry(row, true);
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			if (canEdit(row)) {
				reqQtyFocus(index);
				GV.OEItmList.setFieldValue({index: index, field: "reqQty", value: row.canRetQty});
			}
			if (!canCheck(row)) {
				$(this).datagrid("uncheckRow", index);
			} else {
				ctrlOrdItm(index, row);
				calcRefAmt();
			}
		},
		onUncheck: function (index, row) {
			setRowsAry(row, false);
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			if (!canCheck(row)) {
				return;
			}
			if (canEdit(row)) {
				GV.OEItmList.setFieldValue({index: index, field: "reqQty", value: ""});
			}
			ctrlOrdItm(index, row);
			calcRefAmt();
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if (!canCheck(row)) {
					GV.OEItmList.uncheckRow(index);
				}
				if (canEdit(row)) {
					GV.OEItmList.setFieldValue({index: index, field: "reqQty", value: row.canRetQty});
				}
			});
			GV.RowsAry = GV.OEItmList.getChecked();
			calcRefAmt();
		},
		onUncheckAll: function (rows) {
			GV.RowsAry = [];
			$.each(rows, function (index, row) {
				if (canEdit(row)) {
					GV.OEItmList.setFieldValue({index: index, field: "reqQty", value: ""});
				}
			});
			calcRefAmt();
		},
		onBeginEdit: function(index, row) {
			onBeginEditHandler(index, row);
    	}
	});
}

function onBeginEditHandler(index, row) {
	var ed = GV.OEItmList.getEditor({index: index, field: "reqQty"});
	if (ed) {
		$(ed.target).keyup(function(e) {
			var $obj = e.target;
			fixDecimal(e.target);   //1.先保证是数字(包括整数、小数)
			if (($($obj).val().length > 1) && (/^\d*$/.exec($($obj).val()))) {   //2.输入整数时，保证第一位不能是0
				return fixInteger($obj);
			}
			if (/^\d*$/.exec(+row.packQty)) {   //3.开医嘱时的数量为整数时，申请数量只能为整数
				return fixInteger($obj);
			}
		});
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

function endEditing() {
	if (GV.EditIndex === undefined) {
		return true;
	}
	if (GV.OEItmList.validateRow(GV.EditIndex)) {
		GV.OEItmList.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	}
	return false;
}

/**
 * 判断行能否被勾选
 */
function canCheck(row) {
	if (row.select != 1) {
		return false;
	}
	if (row.reqRowId) {   //已申请时可以勾选
		return true;
	}
	if ((row.isAppRep == "Y") && !row.refRepPart) {
		return false;   //多部位检查申请单退费部位RowId串为空时不能被勾选
	}
	return true;
}

/**
 * 判断行能否被编辑
 */
function canEdit(row) {
	if (row.select != 1) {
		return false;
	}
	if (row.reqRowId) {   //已申请时不能编辑
		return false;
	}
	return (row.isEdit == 1);
}

/**
 * 申请退费数量编辑框获取焦点
 */
function reqQtyFocus(index) {
	var ed = GV.OEItmList.getEditor({index: index, field: "reqQty"});
	if (ed) {
		$(ed.target).focus().select().bind("keyup", function (e) {
			var key = websys_getKey(e);
			if (key == 8) {
				if (!$(ed.target).val()) {
					GV.OEItmList.uncheckRow(index);
				}
			}
		});
	}
}

/**
 * 计算退费金额
 */
function calcRefAmt() {
	var refSum = GV.AlreadyReqSum;
	$.each(GV.RowsAry, function (idx, row) {
		var index = GV.OEItmList.getRowIndex(row);
		var ed = GV.OEItmList.getEditor({index: index, field: "reqQty"});
		var reqQty = ed ? $(ed.target).val() : row.reqQty;
		reqQty = reqQty * row.confac;
		var reqAmt = (row.isAppRep == "Y") ? (row.repPartAmt || 0) : round(Number(reqQty).mul(row.price));
		refSum = Number(refSum).add(+reqAmt);
	});
	refSum = parseFloat(refSum).toFixed(2);
	setValueById("refAmt", refSum);
}

function initReqPanel() {
	getAlreadyReqAmt();
	loadOrdItmList();
}

function loadOrdItmList() {
	var invStr = getCheckedInvStr();
	var queryParams = {
		ClassName: "web.DHCOPBillRefundRequest",
		QueryName: "FindOrdItm",
		invStr: invStr,
		sessionStr: getSessionStr(),
		rows: 9999999
	}
	loadDataGridStore("ordItmList", queryParams);
}

/**
* 新版检查申请单获取部位
*/
function openPartWinOnClick(index) {
	var row = GV.OEItmList.getRows()[index];
	var oeori = row.oeori;
	var pboRowId = row.pboId;
	var oldRefRepPart = row.refRepPart || "";   //已经勾选的部位
	var url = "dhcapp.repparttarwin.csp?oeori=" + oeori + "&refRepPart=" + oldRefRepPart;
	websys_showModal({
		url: url,
		title: '部位列表',
		width: 640,
		height: 400,
		callBackFunc: function(rtnValue) {
			var arReqItmIdStr = rtnValue.split("!!").map(function (item) {
			        return item.split("^")[0];
			    }).join("!!");
			row.refRepPart = arReqItmIdStr;    //多部位检查申请单退费部位RowId串
			
			setOrdItmRowChecked(index, (arReqItmIdStr != ""));

			//计算按部位退费金额
			$.m({
				ClassName: "web.DHCOPBillRefund",
				MethodName: "GetRepPartRefAmt",
				oeitm: oeori,
				pbo: pboRowId,
				arReqItmIdStr: arReqItmIdStr
			}, function (repPartAmt) {
				GV.OEItmList.setFieldValue({index: index, field: "repPartAmt", value: repPartAmt});
				calcRefAmt();
			});
		}
	});
}

/**
 * 申请
 */
function requestClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!endEditing()) {
				return reject();
			}
			GV.EditIndex = undefined;
			GV.OEItmList.acceptChanges();
			if (GV.RowsAry.length == 0) {
				$.messager.popover({msg: "请勾选需退费的未申请医嘱", type: "info"});
				return reject();
			}
			if (!refReason) {
				$.messager.popover({msg: "请选择退费原因", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认申请退费? ", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _getReqInfo = function() {
		return new Promise(function (resolve, reject) {
			var reqDrugAry = [];
			var reqOtherAry = [];
			$.each(GV.RowsAry, function (index, row) {
				var prtId = row.prtId;
				var pboId = row.pboId;
				var oeori = row.oeori;
				var reqQty = Number(row.reqQty).mul(row.confac);  //转换为基本单位数量
				var price = row.price;
				var refSum = (row.isAppRep == "Y") ? (refSum = row.repPartAmt || 0) : round(Number(reqQty).mul(price));
				var dspbId = row.dspbId;
				var isOweDrug = row.isOweDrug;
				var phdicId = row.phdicId;
				var isExecute = row.isExecute;
				var refRepPart = row.refRepPart || "";
				var ordCateType = row.ordCateType;
				var reqStr = prtId + "^" + pboId + "^" + oeori + "^" + reqQty + "^" + refSum;
				if (ordCateType == "R") {
					reqStr += "^" + dspbId + "^" + isOweDrug + "^" + phdicId + "^" + isExecute;
					reqDrugAry.push(reqStr);
				} else {
					reqStr += "^" + "" + "^" + refRepPart;
					reqOtherAry.push(reqStr);
				}
			});
			reqDrugStr = reqDrugAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			reqOtherStr = reqOtherAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
			resolve();
		});
	};
	
	var _request = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCOPBillRefundRequest",
				MethodName: "RefundRequest",
				ReqDrugInfo: reqDrugStr,
				ReqNonDrugInfo: reqOtherStr,
				ReqReason: refReason,
				SessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: myAry[1], type: "success"});
					return resolve();
				}
				$.messager.popover({msg: myAry[1], type: "info"});
				reject();
			});
		});
	};
	
	var _success = function() {
		GV.OEItmList.reload();
		getAlreadyReqAmt();
	};
	
	if ($("#btn-request").linkbutton("options").disabled) {
		return;
	}
	$("#btn-request").linkbutton("disable");
	
	var refReason = getValueById("refReason");
	var reqDrugStr = "";
	var reqOtherStr = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_getReqInfo)
		.then(_request)
		.then(function() {
			_success();
			$("#btn-request").linkbutton("enable");
		}, function() {
			$("#btn-request").linkbutton("enable");
		});
}

/**
 * 撤销申请
 */
function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var reqIdAry = getCheckedReqStr();
			if (reqIdAry.length == 0) {
				$.messager.popover({msg: "请选择需要撤销的已申请记录", type: "info"});
				return reject();
			}
			reqIdStr = reqIdAry.join("^");
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销申请? ", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCOPBillRefundRequest",
				MethodName: "CancelRequest",
				CancelReqInfo: reqIdStr,
				SessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: myAry[1], type: "success"});					
					return resolve();
				}
				$.messager.popover({msg: myAry[1], type: "info"});
				reject();
			});
		});
	};
	
	var _success = function() {
		GV.OEItmList.reload();
		getAlreadyReqAmt();
	};
	
	if ($("#btn-cancel").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancel").linkbutton("disable");
	
	var reqIdStr = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$("#btn-cancel").linkbutton("enable");
		}, function() {
			$("#btn-cancel").linkbutton("enable");
		});
}

/**
 * 模拟##class(web.UDHCJFBILL).round()方法四舍五入
 */
function round(num) {
	return ((num > 0) && (num < 0.01)) ? 0.01 : parseFloat(num).toFixed(2);
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	return GV.InvList.getChecked().map(function(row) {
		return row.TINVRowid + ":" + row.TabFlag;
	}).join("^");
}

/**
 * 取勾选中的已申请的申请id串
 */
function getCheckedReqStr() {
    return GV.OEItmList.getChecked().filter(function (row) {
        return (row.reqRowId != "");
    }).map(function(row) {
	    return row.reqRowId;
	});
}

/**
* 取已申请退费金额
*/
function getAlreadyReqAmt() {
	var invStr = getCheckedInvStr();
	$.m({
		ClassName: "web.DHCOPBillRefundRequest",
		MethodName: "GetAlreadyReqAmt",
		invStr: invStr
	}, function (refSum) {
		GV.AlreadyReqSum = refSum;
		setValueById("refAmt", refSum);
	});
}

/**
 * 控制医嘱退费
 */
function ctrlOrdItm(index, row) {
	var oeori = row.oeori;
	var ordCateType = row.ordCateType;
	var prescNo = row.prescNo;
	var phdicId = row.phdicId;
	var isCNMedItem = row.isCNMedItem;    //草药标识(0:不是; 1:是)
	var isOweDrug = row.isOweDrug;        //欠药标识(0:欠药; 1:非欠药)
	
	var checked = getOrdItmRowChecked(index);
	
	//控制药品退费
	if (ordCateType == "R") {
		//1.控制草药按处方退费
		if (isCNMedItem == 1) {
			$.each(GV.OEItmList.getRows(), function (idx, r) {
				if (index == idx) {
					return true;
				}
				if (prescNo != r.prescNo) {
					return true;
				}
				setOrdItmRowChecked(idx, checked);
			});
			return;
		}
		
		//2.控制欠药医嘱按处方退费
		if (isOweDrug == 0) {
			$.each(GV.OEItmList.getRows(), function (idx, r) {
				if (isOweDrug != r.isOweDrug) {
					return true;
				}
				if (index == idx) {
					return true;
				}
				if (prescNo != r.prescNo) {
					return true;
				}
				setOrdItmRowChecked(idx, checked);
			});
			return;
		}
		
		//3.控制静脉配液医嘱
		if (checked) {
			$.each(GV.OEItmList.getRows(), function (idx, r) {
				if (r.phdicId) {
					return true;
				}
				if (index == idx) {
					return true;
				}
				if (oeori != r.oeori) {
					return true;
				}
				setOrdItmRowChecked(idx, checked);
			});
			return;
		}
		
		if (!phdicId) {
			//未发药记录取消勾选时，所有记录都不勾选
			$.each(GV.OEItmList.getRows(), function (idx, r) {
				if (index == idx) {
					return true;
				}
				if (oeori != r.oeori) {
					return true;
				}
				setOrdItmRowChecked(idx, checked);
			});
			return;
		}
		
		//已发药的取消勾选时，判断是否还有其他勾选中的发药记录，如无，则取消勾选所有未发记录
		var disp = 0;
		$.each(GV.OEItmList.getRows(), function (idx, r) {
			if (!r.phdicId) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			if (getOrdItmRowChecked(idx)) {
				disp = 1;
				return false;
			}
		});
		if (disp == 1) {
			return;    //有其他勾选中的发药记录时，退出
		}
		$.each(GV.OEItmList.getRows(), function (idx, r) {
			if (r.phdicId) {
				return true;
			}
			if (index == idx) {
				return true;
			}
			if (oeori != r.oeori) {
				return true;
			}
			setOrdItmRowChecked(idx, checked);
		});
	}
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return GV.OEItmList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(index).is(":checked");
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelRowIndex = index;
	if (checked) {
		GV.OEItmList.checkRow(index);
	}else {
		GV.OEItmList.uncheckRow(index);
	}
	GV.SelRowIndex = undefined;
}

function setRowsAry(row, checked) {
	if (row.reqRowId) {
		return;     //已申请记录退出
	}
	if (checked) {
		if ($.inArray(row, GV.RowsAry) == -1) {
			GV.RowsAry.push(row);
		}
		return;
	}
	if ($.inArray(row, GV.RowsAry) != -1) {
		GV.RowsAry.splice($.inArray(row, GV.RowsAry), 1);
	}
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#refReason").combobox("reload");
	$("#stDate, #endDate").datebox("setValue", CV.DefDate);
	GV.InvList.options().pageNumber = 1;   //跳转到第一页
	GV.InvList.loadData({total: 0, rows: []});
	GV.OEItmList.loadData({total: 0, rows: []});
}

/**
 * 打印退费单
 */
function printClick() {
	var reqInvAry = getReqInvStr();
	if (reqInvAry.length == 0) {
		$.messager.popover({msg: "请先做退费申请", type: "info"});
		return;
	}
	refReqListPrint(reqInvAry);
}

/**
* 获取已申请的发票
*/
function getReqInvStr() {
    var invStr = getCheckedInvStr();
	var myAry = [];
    return invStr.split("^").filter(function (itm) {
	  	myAry = itm.split(":");
        return invIsApplied(myAry[0], myAry[1]);
    });
}

/**
* 判断发票是否已做退费申请
*/
function invIsApplied(prtRowId, invType) {
	return $.m({ClassName: "web.DHCOPBillRefundRequest", MethodName: "CheckInvIsReqById", prtRowId: prtRowId, invType: invType}, false) == 1;
}

/**
* 泡芙提示不可申请退费原因
*/
function showCantRefReason(that, row) {
	var content = "<ul class='tip-class'>";
	$.each(row.cantRetReasonStr.split("^"), function(index, item) {
		content += "<li>" + (index + 1) + "、"+ item + "</li>";
	});
	content += "</ul>";
	$(that).popover({
		title: '<font color="#FF0000">' + row.arcimDesc + '</font>' + $g('不可申请退费原因'),
		trigger: 'hover',
		content: content
	}).popover("show");
}

/**
* 泡芙提示不可撤销原因
*/
function showCantDelReason(that, row) {
	var content = "<ul class='tip-class'>";
	$.each(row.cantDelReasonStr.split("^"), function(index, item) {
		content += "<li>" + (index + 1) + "、"+ item + "</li>";
	});
	content += "</ul>";
	$(that).popover({
		title: '<font color="#FF0000">' + row.arcimDesc + '</font>' + $g('不可撤销原因'),
		trigger: 'hover',
		content: content
	}).popover("show");
}