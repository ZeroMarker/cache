/**
 * FileName: dhcbill.ipbill.charge.main.js
 * Author: ZhYW
 * Date: 2019-03-04
 * Description: 住院收费
 */

$(function () {
	$(document).keydown(function (e) {
		frameEnterKeyCode(e);
	});
	//初始化查询菜单
	initQueryMenu();

	initCateList();
	initBillList();
	
	initTabs();
	
	getPatInfo();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	//读医保卡
	$HUI.linkbutton("#btn-readInsuCard", {
		onClick: function () {
			readInsuCardClick();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//账单
	$HUI.linkbutton("#btn-bill", {
		onClick: function () {
			billClick();
		}
	});

	//取消结算
	$HUI.linkbutton("#btn-cancelCharge", {
		onClick: function () {
			cancelChargeClick();
		}
	});

	//医保预结算
	$HUI.linkbutton("#btn-insuPreCharge", {
		onClick: function () {
			insuPreDivClick();
		}
	});
	
	//取消医保结算
	$HUI.linkbutton("#btn-insuCancelDivide", {
		onClick: function () {
			insuCancelDivClick();
		}
	});
	
	//押金列表
	$HUI.linkbutton("#btn-depList", {
		onClick: function () {
			depListClick();
		}
	});

	//卡号回车查询事件
	$("#CardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").focus().keydown(function (e) {
		patientNoKeydown(e);
	});

	//病案号回车查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});

	initAdmList();      //就诊列表
	initChgStatus();    //结算状态
}

/**
* 就诊下拉数据表格
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		fitColumns: false,
		editable: false,
		idField: "TAdm",
		textField: "TDept",
		columns: [[{field: 'TAdm', title: 'TAdm', hidden: true}, 
				   {field: 'TAdmDate', title: '入院时间', width: 150,
				    formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TAdmTime;
						}
					}
				   },
				   {field: 'TDept', title: '就诊科室', width: 90},
				   {field: 'TWard', title: '就诊病区', width: 130},
				   {field: 'TDischDate', title: '出院时间', width: 150,
				   	formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TDischTime;
						}
					}
				   }
			]],
		onLoadSuccess:function(data) {
			if (data.total > 0) {
				setValueById("admList", (GV.EpisodeID || data.rows[0].TAdm));
			}
	    },
		onSelect: function (index, row) {
			GV.EpisodeID = row.TAdm;
			loadBillList();
		}
	});
}

/**
* 结算状态下拉框
*/
function initChgStatus() {
	$HUI.combobox("#status", {
		panelHeight: 'auto',
		data: [{id: "", text: $g("全部")},
			   {id: "billed", text: $g("未结算")},
			   {id: "discharge", text: $g("最终结算")},
			   {id: "paid", text: $g("结算历史")},
			   {id: "toBill", text: $g("新入院")}
		],
		editable: false,
		valueField: 'id',
		textField: 'text',
		onSelect: function (rec) {
			loadBillList();
		}
	});
}

/**
* 初始化账单列表
*/
function initBillList() {
	GV.BillList = $HUI.datagrid("#billList", {
		fit: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		pageSize: 99999999,
		toolbar: (CV.ToolMenus.length > 0) ? CV.ToolMenus : null,
		className: "web.DHCIPBillCashier",
		queryName: "SearchBill",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["patientNo", "mrNo", "patName", "dept", "admdate", "dischargedate", "CodingUPDate", "prtdate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["patientid", "pbflag", "prtrowid", "disChgStatusCode"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "ward") {
					cm[i].title = '科室病区';
					cm[i].formatter = function(value, row, index) {
						return row.dept + " " + row.ward;
					}
				}
				if (cm[i].field == "admtime") {
					cm[i].formatter = function (value, row, index) {
						return row.admdate + " " + value;
					}
				}
				if (cm[i].field == "dischargetime") {
					cm[i].formatter = function (value, row, index) {
						return row.dischargedate + " " + value;
					}
				}
				if (cm[i].field == "CodingUPTime") {
					cm[i].formatter = function (value, row, index) {
						return row.CodingUPDate + " " + value;
					}
				}
				if (cm[i].field == "prttime") {
					cm[i].formatter = function (value, row, index) {
						return row.prtdate + " " + value;
					}
				}
				if (cm[i].field == "transLocFlag") {
					cm[i].align = 'center';
					cm[i].formatter = function (value, row, index) {
						return (value == "Y") ? ("<a href='javascript:;' onclick='openCostInquriy(" + JSON.stringify(row) + ")'>" + $g("是") + "</a>") : $g("否");
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "ward") {
						cm[i].width = 180;
					}
					if ($.inArray(cm[i].field, ["admtime", "dischargetime", "CodingUPTime", "prttime"]) != -1) {
						cm[i].width = 160;
						continue;
					}
				}
			}
		},
		rowStyler: function (index, row) {
			if ($.inArray(row.disChgStatusCode, GV.DischgStatAry) != -1) {
				return "color: #FF0000;";
			}
		},
		onLoadSuccess: function (data) {
			GV.EditIndex = undefined;
			$("#btn-insuPreCharge, #btn-disCharge").linkbutton("enable");
			//账单列表无数据时,需清空分类信息Grid、支付方式Grid、押金列表Grid
			if (data.total == 0) {
				delete GV.BillID;
				delete GV.PrtRowID;
				loadGridData();
				return true;
			}
			var selectRowIndex = 0;    //默认第一行
			$.each(data.rows, function (index, row) {
				if (row.pbrowid && (row.pbrowid == GV.BillID)) {
					selectRowIndex = index;
					return false;
				}
			});
			GV.BillList.selectRow(selectRowIndex);
		},
		onSelect: function (index, row) {
			GV.PatientID = row.patientid;
			GV.EpisodeID = row.episodeid;
			GV.BillID = row.pbrowid;
			GV.PrtRowID = row.prtrowid;
			
			loadGridData();
			initPatFeeInfo();
			setPayMPanelTitle();
			setEprMenuForm(row.episodeid, row.patientid);  //头菜单传值			
			
			var isDivided = isInsuDivided();
			$("#btn-insuPreCharge").linkbutton({disabled: isDivided});    //如果已经医保结算或为自费账单，把医保预结算按钮禁用
			
			//2022-09-01 ZhYW 考虑到医保结算和财务结算分角色，故不在此处校验发票
			/*
			if (!checkInv()) {
				$.messager.popover({msg: "您没有可用发票，不能结算，请先领取发票", type: "info"});
				$("#btn-disCharge").linkbutton("disable");
			}
			*/
		},
		onRowContextMenu: function (e, index, row) {
			e.preventDefault();   //阻止浏览器默认的右键菜单弹出
			initRightMenu(e);     //添加右键菜单
			//判断是不是在同一条记录上右击如果是则不刷新支付方式和押金
			if (row.pbrowid != GV.BillID) {
				GV.BillList.selectRow(index);
			}
		}
	});
}

/**
 * 右键菜单
 */
function initRightMenu(e) {
	try {
		if (!CV.RightMenus.length) {
			return;
		}
		var target = "rightyKey";
		var $target = $("#" + target);
		if (!$target.length) {
			$target = $("<div id=\"" + target + "\"></div>").appendTo("body");
			$target.menu();
			$.each(CV.RightMenus, function (index, item) {
				$target.menu("appendItem", item);
			});
		}
		$target.menu("show", {
			left: e.pageX,
			top: e.pageY
		});
	}catch (e) {
		$.messager.popover({msg: "创建右键菜单失败：" + e.message, type: "error"});
	}
}

/**
* 初始化分类信息Grid
*/
function initCateList() {
	GV.CateList = $HUI.datagrid("#cateList", {
		fit: true,
		title: '分类信息',
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		fitColumns: true,
		singleSelect: true,
		rownumbers: true,
		remoteSort: false,
		showFooter: true,
		toolbar: [],
		pageSize: 99999999,
		loadMsg: '',
		className: "web.DHCIPBillCashier",
		queryName: "GetCateList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (cm[i].field == "CateAmt") {
					cm[i].sortable = true;
					cm[i].sorter = function (a, b) {
						return ((Number(a).sub(b) > 0) ? 1 : -1);
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillCashier",
			QueryName: "GetCateList",
			bill: GV.BillID,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			totalFields: "CateAmt",
			totalFooter: "\"CateDesc\":" + "\"" + $g("合计") + "\"",
			rows: 99999999
		},
		onLoadSuccess: function(data) {
			if (data.footer && (data.footer.length > 0)) {
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").css("visibility", "visible");
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").text(data.total + 1);
			}
		}
	});
}

/**
* 加载就诊列表
*/
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "SearchAdm",
		papmi: GV.PatientID,
		sessionStr: getSessionStr()
	}
	loadComboGridStore("admList", queryParams);
}

/**
* 加载账单列表数据
*/
function loadBillList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "SearchBill",
		StDate: "",
		EndDate: "",
		PatientNO: "",
		MedicareNO: "",
		PatientName: "",
		InvoiceNO: "",
		EpisodeID: GV.EpisodeID,
		PayStatus: getValueById("status"),
		SessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("billList", queryParams);
}

/**
* 押金明细窗口
*/
function depListClick() {
    if (!GV.EpisodeID) {
        return;
    }
    $("#depositDlg").show().dialog({
        width: 920,
        height: 450,
        iconCls: 'icon-w-list',
        title: '押金明细',
        draggable: false,
        modal: true
    });
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
		return;
	}
	$("#btn-readCard").linkbutton("toggleAble");
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

/**
 * 读医保卡
 */
function readInsuCardClick() {
	if ($("#btn-readInsuCard").linkbutton("options").disabled) {
		return;
	}
	$("#btn-readInsuCard").linkbutton("toggleAble");
	var rtn = InsuReadCard(0, PUBLIC_CONSTANT.SESSION.USERID, "", "", "00A^^^");
	var myAry = rtn.split("|");
	if (myAry[0] == 0) {
		var insuReadInfo = myAry[1];
		var insuReadAry = insuReadInfo.split("^");
		var insuCardNo = insuReadAry[1];	//医保卡号
		var credNo = insuReadAry[7];	    //身份证号
		$("#CardNo").val(credNo);
		if (credNo != "") {
			DHCACC_GetAccInfo("", credNo, "", "", magCardCallback);
		}
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
			focusById("CardNo");
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
		getPatInfo(patientId);
	}
}

/**
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("medicareNo", "");
		getPatInfo($(e.target).val());
	}
}

/**
* 病案号回车事件
*/
function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("patientNo", "");
		getPatInfo($(e.target).val());
	}
}

function getPatInfo() {
	var patientNo = "";
	var medicareNo = "";
	var episodeId = "";
	if (typeof arguments[0] === "undefined") {
		var frm = dhcsys_getmenuform();
		if (frm) {
			episodeId = frm.EpisodeID.value;
		}
	} else {
		patientNo = getValueById("patientNo");
		medicareNo = getValueById("medicareNo");
	}
	if (patientNo || medicareNo || episodeId) {
		$.m({
			ClassName: "web.DHCIPBillCashier",
			MethodName: "GetAdmInfo",
			PatientNo: patientNo,
			MedicareNo: medicareNo,
			EpisodeID: episodeId,
			SessionStr: getSessionStr()
		}, function (rtn) {
			if (!rtn) {
				$.messager.popover({msg: "患者不存在", type: "info"});
				return;
			}
			setPatInfo(rtn);
		});
	}
}

function setPatInfo(str) {
	try {
		var myAry = str.split("^");
		var patientNo = myAry[0];
		var visitStatus = myAry[8];
		var episodeId = ($.inArray(visitStatus, ["C", "P"]) == -1) ? myAry[2] : "";
		var patientId = myAry[14];
		setValueById("patientNo", myAry[0]);
		setValueById("medicareNo", myAry[6]);
		GV.PatientID = patientId;
		GV.EpisodeID = episodeId;
		setDefTabFromIframe();    //设置默认选中
		refreshBar(patientId, episodeId);
		loadAdmList();
		//+2022-11-28 TianZJ
		$.m({
			ClassName: "web.DHCIPBillCashier",
			MethodName: "IsEpSubType",
			adm: episodeId,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.alert("提示", (myAry[1] || myAry[0]), "info");
			}
		});
	}catch(e) {
		$.messager.popover({msg: "获取患者信息异常:" + e.message, type: "error"});
	}
}

/**
 * 结算
 */
function chargeClick() {
	var _checkAdm = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择账单", type: "info"});
				return reject();
			}
			var isLock = lockAdm(GV.EpisodeID, true);   //2023-02-22 ZhYW 对当前结算就诊解锁
			if (isLock) {
		        return reject();
		    }
			var visitStatus = getPropValById("PA_Adm", GV.EpisodeID, "PAADM_VisitStatus");
			if (visitStatus == "C") {
				$.messager.popover({msg: "患者已退院，不能结算", type: "info"});
				return reject();
			}
			admStatusJson = getAdmStatusJson();
			if (admStatusJson.statusCode == "B") {
				$.messager.popover({msg: ($g("患者正在进行") + admStatusJson.status + "，" + $g("不能结算")), type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	/**
	* 判断是否婴儿结算
	*/
	var _checkBaby = function() {
		return new Promise(function (resolve, reject) {
			var rtnValue = $.m({ClassName: "web.UDHCJFCOMMON", MethodName: "CheckBabyAdmDisCharge", MotherAdm: GV.EpisodeID}, false);
			var myAry = rtnValue.split("^");
			var rtn = myAry[0];
			var babyAdmStatus = myAry[1];
			if (rtn == 0) {
				return resolve();
			}
			if ((rtn == -1) && !CV.BabyUnPayAllowMotherPay) {
				$.messager.popover({msg: "有婴儿未结算，母亲不允许结算", type: "info"});
				return reject();
			}
			var msg = ((rtn == -1) ? "有婴儿未结算" : ("婴儿是" + babyAdmStatus + "状态")) + "，母亲是否确认结算?";
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _checkBill = function() {
		return new Promise(function (resolve, reject) {
			//判断账单状态
			var refundFlag = getBillRefFlag();
			if (refundFlag == "B") {
				$.messager.popover({msg: "该账单已经红冲，不允许结算", type: "info"});
				return reject();
			}
			if (isChgedBill()) {
				$.messager.popover({msg: "该账单已结算", type: "info"});
				return reject();
			}
			if ($.inArray(admStatusJson.statusCode, GV.DischgStatAry) != -1) {
				//最终结算时验证自费患者是否取消医保登记
				var isCancel = checkInsuRegIsCancel();
				if (!isCancel) {
					$.messager.popover({msg: "医保未取消登记，不能结算", type: "info"});
					return reject();
				}
				$.messager.confirm("确认", "是否确认结算？", function (r) {
					return r ? resolve() : reject();
				});
				return;
			}
			
			/*以下为中途结算控制*/
			if (!isAllowedIntPay()) {
				$.messager.popover({msg: "患者未出院，不能结算", type: "info"});
				return reject();
			}
			//判断医保患者是否必须做最终结算
			if (!canIntPayForInsu()) {
				$.messager.popover({msg: "医保患者未出院，不能结算", type: "info"});
				return reject();
			}
			
			$.messager.confirm("确认", ($g("患者是") + admStatusJson.status + $g("状态") + "，" + $g("是否确认中途结算") + "？"), function (r) {
				return r ? resolve() : reject();
			}).children("div.messager-button").children("a:eq(1)").focus();   //取消按钮聚焦
			$(".messager-button>a .l-btn-text").each(function(index, item) {
				$(this).parent().parent().css({width: "90px"});
				if ($.inArray($(this).text(), ["Ok", "确定"]) != -1) {
					$(this).text($g("中途结算"));
					return true;
				}
			});
		});
	};
	
	var _validFee = function() {
		return new Promise(function (resolve, reject) {
			//费用审核
			if (IPBILL_CONF.PARAM.ConfirmPatFee == "Y") {
				if (!isExamPassed()) {
					$.messager.popover({msg: "该患者费用还未审核通过，不允许结算", type: "info"});
					return reject();
				}
			}
			//+2022-11-29 住院结算医保审核控制
			if (!isInsuAudited()) {
				$.messager.popover({msg: "该患者医保审核未通过，不允许结算", type: "info"});
				return reject();
			}
			//费用核查
			//1.患者未做最终结算
			if ($.inArray(admStatusJson.statusCode, GV.DischgStatAry) == -1) {
				//判断收费是否有未记账的医嘱、是否有计费数量与发药数量不一致的药品
				var hasNotBillOrd = getNotBillOrd();
				if (hasNotBillOrd) {
					return reject();
				}
				return resolve();
			}
			//2.患者已办理最终结算
			var isChecked = checkFee();
			if (!isChecked) {
				return reject();
			}
			resolve();
		});
	};
	
	var _linkChg = function() {
		return new Promise(function(resolve, reject) {
			if (!isOpenPayMWin()) {
				return charge().then(function() {
			        resolve();
			    }, function() {
			        reject();
			    });
			}
			//弹出收款界面收款
			return _showPayMWin().then(function() {
		        resolve();
		    }, function() {
		        reject();
		    });
		});
	};
	
	var _showPayMWin = function() {
		return new Promise(function(resolve, reject) {
			var url = CV.PayMURL + "?EpisodeID=" + GV.EpisodeID + "&BillID=" + GV.BillID;
			websys_showModal({
				url: url,
				title: $g('出院结算'),
				iconCls: 'icon-w-paid',
				onClose: function () {
					_closePayMWin();
					return resolve();
				}
			});
		});
	};
	
	var _closePayMWin = function() {
		if (isChgedBill()) {
			//HIS已结算
			if (getValueById("status") != "paid") {
				$("#status").combobox("select", "paid");
				return;
			}
			loadBillList();
			return;
		}
		//HIS未结算
		//配置了HIS未结算关闭界面取消医保结算时需撤销医保
		if (GV.CancelInsuDiv == "Y") {
			insuCancelDivide();
		}
	};
	
	if ($("#btn-disCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-disCharge").linkbutton("disable");
	
	var admStatusJson = {};
	
	var promise = Promise.resolve();
	promise
		.then(_checkAdm)
		.then(_checkBaby)
		.then(_checkBill)
		.then(_validFee)
		.then(_linkChg)
		.then(function() {
			lockAdm(GV.EpisodeID, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-disCharge").linkbutton("enable");
		}, function() {
			lockAdm(GV.EpisodeID, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-disCharge").linkbutton("enable");
		});
}

/**
* 判断收费有未记账的医嘱有计费数量与发药数量不一致的药品如果有则不允许结算
*/
function getNotBillOrd() {
	var rtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetNotBillOrd", GV.EpisodeID, GV.BillID);
	var notBillOrdArr = rtn.split("^");
	var mNotBill = notBillOrdArr[0].split(",");
	var mNotBillNum = mNotBill[0];
	/*
	if (mNotBillNum != 0) {
		$.messager.popover({msg: "该患者有需要计费的医嘱，不能结算", type: "info"});
		return true;
	}
	*/
	var mDisAry = notBillOrdArr[1].split(",");
	var mDisNum = mDisAry[0];
	if (mDisNum != 0) {
		$.messager.popover({msg: "该患者有发药数量与计费数量不一致的医嘱，不能结算", type: "info"});
		return true;
	}
	var notDisp = notBillOrdArr[2].split(",");
	var notDispNum = notDisp[0];
	if (notDispNum != 0) {
		$.messager.popover({msg: "该患者有未发药品，不能结算", type: "info"});
		return true;
	}
	//判断中途结算账单是否有负数账单
	if (notBillOrdArr[3]) {
		var mPBNegativ = notBillOrdArr[3].split(",");
		var mPBNegativNum = mPBNegativ[0];
		if (mPBNegativNum != 0) {
			$.messager.popover({msg: "该患者有负数的医嘱，不能结算", type: "info"});
			return true;
		}
	}
	//判断婴儿的
	var babyRtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetBabyNotBillOrd", GV.EpisodeID, GV.BillID);
	var babyNotBillOrdArr = babyRtn.split("^");
	var babyNotBill = babyNotBillOrdArr[0].split(",");
	var babyNotBillNum = babyNotBill[0];
	/*
	if (babyNotBillNum != 0) {
		$.messager.popover({msg: "该患者的婴儿有需要计费的医嘱，不能结算", type: "info"});
		return true;
	}
	*/
	var babyDis = babyNotBillOrdArr[1].split(",");
	var babyDisNum = babyDis[0];
	if (babyDisNum != 0) {
		$.messager.popover({msg: "该患者的婴儿有发药数量与计费数量不一致的医嘱，不能结算", type: "info"});
		return true;
	}
	var babyNotDisp = babyNotBillOrdArr[2].split(",");
	var babyNotDispNum = babyNotDisp[0];
	if (babyNotDispNum != 0) {
		$.messager.popover({msg: "该患者的婴儿有未发药品，不能结算", type: "info"});
		return true;
	}
	return false;
}

/**
* 清屏
*/
function clearClick() {
	clearGV();
	
	clearEprMenuForms();

	setDefTabFromIframe();
	$(":text:not(.pagination-num)").val("");
	setValueById("status", "");
	$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
	GV.BillList.loadData({total: 0, rows: []});
	
	$(".numberbox-f").numberbox("clear");

	GV.PayMList.getPanel().panel("setTitle", "支付信息");
	
	checkInv();     //设置默认发票号
	
	setValueById("currentInvId", "");
	
	clearBanner();
	
	focusById("patientNo");
}

function clearGV() {
	GV.PatientID = "";
	GV.EpisodeID = "";
	GV.BillID = "";
	GV.PrtRowID = "";
}

function setEprMenuForm(episodeId, patientId) {
	var menuWin = websys_getMenuWin();
	if (menuWin && menuWin.MainClearEpisodeDetails) {
		menuWin.MainClearEpisodeDetails();
	}
	var frm = dhcsys_getmenuform();
	if (frm && (frm.EpisodeID.value != episodeId)) {
		frm.EpisodeID.value = episodeId;
		frm.PatientID.value = patientId;
	}
}

function clearEprMenuForms() {
	var menuWin = websys_getMenuWin();
	if (menuWin && menuWin.MainClearEpisodeDetails) {
		menuWin.MainClearEpisodeDetails();
		return;
	}
	var frm = dhcsys_getmenuform();
	if (frm) {
		if (frm.EpisodeID) {
			frm.EpisodeID.value = "";
		}
		if (frm.PatientID) {
			frm.PatientID.value = "";
		}
	}
}

/**
 * 原号重新打印收据
 */
function rePrintInvClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择账单", type: "info"});
				return reject();
			}
			if (!(GV.PrtRowID > 0)) {
				$.messager.popover({msg: "账单未结算，不能补打发票", type: "info"});
				return reject();
			}
			var jsonObj = getPersistClsObj("User.DHCINVPRTZY", GV.PrtRowID);
			if ($.inArray(jsonObj.PRTFlag, ["N", "I"]) == -1) {
				$.messager.popover({msg: "该发票已退费，不能补打发票", type: "info"});
				return reject();
			}
			if (!jsonObj.PRTinv) {
				$.messager.popover({msg: "发票号为空，不能补打发票", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确定要补打发票？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(function() {
			inpatInvPrint(GV.PrtRowID + "#" + "R");  //R为补打标识
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
 * 打印台账
 */
function printPtLedger() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var params = "&billId=" + GV.BillID;
	var fileName = "DHCBILL-IPBILL-Ledger.rpx" + params;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		e.preventDefault();
		linkBillDetail();
		break;
	case 118: //F7
		e.preventDefault();
		clearClick();
		break;
	case 120: //F9
		e.preventDefault();
		chargeClick();
		break;
	case 121: // F10
		e.preventDefault();
		if ($("#tool-btn-AddDepositTool").length > 0) {
			linkAddDeposit();
		}
		break;
	case 117: //F6  和调试F12冲突
		e.preventDefault();
		if ($("#tool-btn-RefDepositTool").length > 0) {
			linkRefDeposit();
		}
		break;
	default:
	}
}

/**
* 初始化Tab面板事件
*/
function initTabs() {
	$("#chargeTabs").tabs({
		onSelect: function (title, index) {
			var tabPanel = $("#chargeTabs").tabs("getTab", index);
			if (!tabPanel) {
				return;
			}
			var tabId = tabPanel.panel("options").id;
			if (tabId == "billListTab") {
				loadBillList();
				return;
			}
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				$(this).tabs("select", 0);
				return;
			}
			var cardNo = getValueById("CardNo");
			var cardTypeId = getValueById("CardTypeRowId");
			var paramObj = {};
			switch (tabId) {
			case "addDepositTab":
				//交押金
				paramObj = {EpisodeID: GV.EpisodeID, CardNo: cardNo, CardTypeRowId: cardTypeId};
				break;
			case "refDepositTab":
				//退押金
				paramObj = {EpisodeID: GV.EpisodeID, CardNo: cardNo, CardTypeRowId: cardTypeId};
				break;
			case "billDetailTab":
				//患者费用明细
				if (!GV.BillID) {
					$.messager.popover({msg: "请选择账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				paramObj = {EpisodeID: GV.EpisodeID, BillID: GV.BillID};
				break;
			case "halfBillByOrdTab":
				//医嘱拆分账单
				if (!checkCanIntPay()) {
					$(this).tabs("select", 0);
					break;
				}
				paramObj = {BillID: GV.BillID};
				break;
			case "searchDepDet":
				//押金明细查询
				var depTypeId = getIPDepTypeId();
				paramObj = {EpisodeID: GV.EpisodeID, DepositType: depTypeId};
				break;
			case "searchTarFee":
				//收费项目查询
				if (!GV.BillID) {
					$.messager.popover({msg: "请选择账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				paramObj = {BillID: GV.BillID};
				break;
			case "admOrderFee":
				//医嘱费用查询
				paramObj = {EpisodeID: GV.EpisodeID};
				break;
			case "itmFeeDtlsAudit":    //+gongxin
				//收费项目审核
				paramObj = {BillID: GV.BillID, EpisodeID: GV.EpisodeID};
				break;
			case "summaryPrintInv":
				//集中打印发票
				paramObj = {PatientId: GV.PatientID};
				break;
			case "summaryRePrtInv":
				//集中打印发票重打 ShangXuehao
				paramObj = {PatientId: GV.PatientID};
				break;
			case "arrearsBack":
				//欠费补回
				paramObj = {PatientId: GV.PatientID};
				break;
			case "prtInvManage":
				//发票打印管理
				paramObj = {PatientId: GV.PatientID};
				break;
			default:
			}
			
			if (!$.isEmptyObject(paramObj)) {
				initCfgTab(tabId, paramObj);
			}
		}
	});
}

function initCfgTab(tabId, paramObj) {
	var $obj = $("#" + tabId);
	var title = $obj.panel("options").title;
	var params = "";
	$.each(Object.keys(paramObj), function(index, prop) {
		params += ((params == "") ? "" : "&") + prop + "=" + paramObj[prop];
	});
	var url = $obj.attr("data") + params;
	addOneTab("chargeTabs", tabId, title, url);
}

/**
* 添加tab面板
*/
function addOneTab(parentId, tabId, mTitle, mUrl) {
	if ($("#" + parentId).tabs("exists", mTitle)) {
		$("#" + parentId).tabs("select", mTitle);
		refreshTab(tabId, mUrl);
		return;
	}
	$("#" + parentId).tabs("add", {
		id: tabId,
		fit: true,
		title: mTitle,
		closable: false,
		selected: false,
		border: false,
		cache: false
	});
}

/**
* 2023-02-08 ZhYW 增加Token
*/
function refreshTab(tabId, url) {
	var iframeId = "iframe_" + tabId;
	var content = "<iframe id=\"" + iframeId + "\" src=\"" + websys_writeMWToken(url) + "\" width=\"100%\" height=\"100%\" scrolling=\"auto\" frameborder=\"0\"></iframe>";
	$("#" + tabId).css("overflow", "hidden").panel({
		content: content
	}).panel("refresh");
	
	focusById(iframeId);
}

/**
 * 拆分账单
 */
function halfBillClick() {
	if (!checkCanIntPay()) {
		return;
	}
	var url = "dhcbill.ipbill.intpay.csp?BillID=" + GV.BillID;
	websys_showModal({
		url: url,
		title: $(this).text(),
		iconCls: 'icon-w-edit',
		width: 621,
		height: 265,
		callbackFunc: function() {
			GV.BillList.reload();
		}
	});
}

/**
 * 判断能否拆分账单
 */
function checkCanIntPay() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择需要拆分账单的账单", type: "info"});
		return false;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "该账单已封账，不能拆分账单", type: "info"});
		return false;
	}
	if (isChgedBill()) {
		$.messager.popover({msg: "该账单已经结算，不能拆分账单", type: "info"});
		return false;
	}
	//判断医保患者是否能够中途结算
	if (!canIntPayForInsu()) {
		$.messager.popover({msg: "该患者为医保患者，不能拆分账单", type: "info"});
		return false;
	}
	
	var insuUpFlag = getInsuUpFlag();
	if ($.inArray(insuUpFlag, ["1", "2"]) != -1) {
		$.messager.popover({msg: "该账单已医保" + ((insuUpFlag == 1) ? "上传" : "结算") + "，不能拆分账单", type: "info"});
		return false;
	}
	
	return true;
}

/**
 * 合并账单
 */
function delHarfBillClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var notPayedNum = getNotPayedBillNum();
	if (!(notPayedNum > 1)) {
		$.messager.popover({msg: "患者无多个未结算账单，不需合并", type: "info"});
		return;
	}
	var url = "dhcbill.ipbill.mergebill.csp?EpisodeID=" + GV.EpisodeID;
	websys_showModal({
		url: url,
		title: $g('合并账单'),
		iconCls: 'icon-w-edit',
		width: 700,
		height: 400,
		callbackFun: function() {
			loadBillList();
		}
	});
}

/**
 * 封账
 */
function closeAcountClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择需要封账的账单", type: "info"});
				return reject();
			}
			var refundFlag = getBillRefFlag();
			if (refundFlag == "B") {
				$.messager.popover({msg: "该账单已经红冲，不能封账", type: "info"});
				return reject();
			}
			admStatusJson = getAdmStatusJson();
			if (admStatusJson.statusCode == "B") {
				$.messager.popover({msg: ($g("患者正在进行") + admStatusJson.status + "，" + $g("不能封账")), type: "info"});
				return reject();
			}
			if (isChgedBill()) {
				$.messager.popover({msg: "该账单已结算，不能封账", type: "info"});
				return reject();
			}
			if (isClosedBill()) {
				$.messager.popover({msg: "该账单已封账，不能重复封账", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认封账？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _closeAcount = function() {
		return new Promise(function (resolve, reject) {
			$.messager.progress({title: "提示",	msg: "封账中...."});
			$.m({
				ClassName: "web.DHCIPBillPBCloseAcount",
				MethodName: "CloseAcount",
				adm: GV.EpisodeID,
				billno: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				computername: ClientIPAddress
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "封账成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "封账失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 封账成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var admStatusJson = {};
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_closeAcount)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
 * 取消封账
 */
function uncloseAcountClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择需要取消封账的账单", type: "info"});
				return reject();
			}
			var refundFlag = getBillRefFlag();
			if (refundFlag == "B") {
				$.messager.popover({msg: "该账单已经红冲，不能取消封账", type: "info"});
				return reject();
			}
			if (!isClosedBill()) {
				$.messager.popover({msg: "该账单未封账，无需取消", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认取消封账？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _uncloseAcount = function() {
		return new Promise(function (resolve, reject) {
			$.messager.progress({title: "提示",	msg: "取消封账中...."});
			$.m({
				ClassName: "web.DHCIPBillPBCloseAcount",
				MethodName: "UnCloseAcount",
				adm: GV.EpisodeID,
				billno: GV.BillID,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				computername: ClientIPAddress
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "取消封账成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "取消封账失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 取消封账成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_uncloseAcount)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
 * 取消结算
 */
function cancelChargeClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择账单", type: "info"});
				return reject();
			}
			if (!GV.PrtRowID) {
				$.messager.popover({msg: "账单未结算，不能取消结算", type: "info"});
				return reject();
			}
			//判断取消结算是否需要打印负票，如果打印判断是否有可用发票
			if ((IPBILL_CONF.PARAM.StrikeInvRequireInv == "Y") && (!checkInv())) {
				$.messager.popover({msg: "取消结算需打印负票，您没有可用发票，请先领取发票", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "BILL.IP.BL.CancelPay", MethodName: "IsValidCancel", prtRowId: GV.PrtRowID}, false);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.popover({msg: myAry[1], type: "info"});
				return reject();
			}
			//+2023-02-13 ZhYW
			var rtn = $.m({ClassName: "web.DHCIPBillReg", MethodName: "GetInsuUpFlagByAdm", adm: GV.EpisodeID}, false);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.popover({msg: (myAry[1] + "，如需取消结算，请先将其封账或结算"), type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var msg = "是否确认取消？";
			var transDepAmt = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetTransDeposit", Adm: GV.EpisodeID}, false);
			if (transDepAmt > 0) {
				msg = "患者结算时转过押金，取消结算押金会虚增，" + msg;
			}
			$.messager.confirm("确认", $g(msg), function (r) {
				if (!r) {
					return reject();
				}
				if (!(transDepAmt > 0)) {
					return resolve();
				}
				$.messager.alert("提示", "请退掉中途结算转过的押金", "info", function () {
					resolve();
				});
			});
		});
	};
	
	//取消结算原因
	var _getCancelReason = function() {
		return new Promise(function (resolve, reject) {
			var _content = "<div id=\"edit-mod-dlg\">"
							+ "<table class=\"search-table\">"
								+ "<tr>"
									+ "<td class=\"r-label\"><label class=\"clsRequired\">" + $g("取消结算原因") + "</label></td>"
									+ "<td><input id=\"dlg-cancelReason\" class=\"textbox\" style=\"width:220px;\"/></td>"
								+ "</tr>"
							+ "</table>"
						+ "</div>";
			$("body").append(_content);
			var modDlgObj = $HUI.dialog("#edit-mod-dlg", {
                title: '请选择取消结算原因',
                iconCls: 'icon-w-edit',
                closable: false,
                modal: true,
                width: 350,
    			height: 150,
                onClose: function() {
	                $("body").remove("#edit-mod-dlg");
	                modDlgObj.destroy();
	            },
                buttons: [{
                        text: '确定',
                        handler: function () {
                            var bool = true;
                            $("#edit-mod-dlg .validatebox-text").each(function (index, item) {
                                if (!$(this).validatebox("isValid")) {
                                    $.messager.popover({msg: "<font color=\"red\">" + $(this).parents("td").prev().text() + "</font>" + "验证不通过", type: "info"});
                                    bool = false;
                                    return false;
                                }
                            });
                            if (!bool) {
                                return;
                            }
                        	cancelReasonId = getValueById("dlg-cancelReason");
                        	modDlgObj.close();
                         	resolve();
                        }
                    }, {
                        text: '取消',
                        handler: function () {
	                   		modDlgObj.close();
	                   		reject();
                        }
                    }
                ],
                onBeforeOpen: function () {
                    //取消结算原因
					$HUI.combobox("#dlg-cancelReason", {
						panelHeight: 150,
						url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryCancelChgReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
						valueField: 'id',
						textField: 'text',
						defaultFilter: 5,
						required: true,
						blurValidValue: true,
						onLoadSuccess: function(data) {
							if (data.length > 0) {
			                    setValueById("dlg-cancelReason", data[0].id);
			                }
						}
					});
                }
            });
		});
	};
	
	//医保取消结算
	var _cancelInsuDiv = function() {
		return new Promise(function (resolve, reject) {
			var rtn = insuCancelDivide();
			if (rtn < 0) {
				$.messager.popover({msg: "医保取消结算失败", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cancelPay = function () {
		return new Promise(function (resolve, reject) {
			var expStr = cancelReasonId;
			$.messager.progress({title: "提示",	msg: "取消结算中...."});
			$.m({
				ClassName: "BILL.IP.BL.CancelPay",
				MethodName: "DelPay",
				prtRowId: GV.PrtRowID,
				sessionStr: getSessionStr(),
				expStr: expStr
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					strikePrtRowId = myAry[1];
					$.messager.popover({msg: "取消结算成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "取消结算失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		loadBillList();
		if ((IPBILL_CONF.PARAM.StrikeInvRequireInv == "Y") && (strikePrtRowId > 0)) {
			inpatInvPrint(strikePrtRowId + "#" + "");
		}
		//取消结算押金不回冲时，打印充押金单据
		if (CV.DelPayMode == 1) {
			$.m({
				ClassName: "BILL.IP.BL.CancelPay",
				MethodName: "GetTransDepRowIDStr",
				strikePrtRowId: strikePrtRowId
			}, function(rtn) {
				// Date:2023.04.18	wzh		通用配置:住院收费系统-住院收费-押金不回冲是否打印押金单据
				if (typeof(GV.CfgPoint) == "undefined") GV.CfgPoint = {};	// 如果没有配置点的节点，则生成
				if (typeof(GV.CfgPoint.YJBHCSFDYYJDJ) == "undefined"){   //如果没有该配置点则获取，如果有则判断
					//返回值。只有success=1才赋值
					var cfgData = $.cm({ClassName: "BILL.CFG.COM.GeneralCfg", MethodName: "GetResultByRelaCode", RelaCode: "IPCHRG.IPChrg.YJBHCSFDYYJDJ", SourceData: "", TgtData: "", HospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
					if (cfgData.success){
						GV.CfgPoint.YJBHCSFDYYJDJ = +cfgData.value;
					}else{// 默认打印
						GV.CfgPoint.YJBHCSFDYYJDJ = 1;
					}
				}
				if (!GV.CfgPoint.YJBHCSFDYYJDJ) return;
				rtn.split("^").forEach(function(id) {
					if (id > 0) {
						depositPrint(id + "#" + "");
					}
				});
			});
		}
	};
	
	if ($("#btn-cancelCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancelCharge").linkbutton("disable");
	
	var cancelReasonId = "";
	var strikePrtRowId = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_getCancelReason)
		.then(_cancelInsuDiv)
		.then(_cancelPay)
		.then(function() {
			_success();
			$("#btn-cancelCharge").linkbutton("enable");
		}, function() {
			$("#btn-cancelCharge").linkbutton("enable");
		});
}

/**
* 取消医保结算
*/
function insuCancelDivClick() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var admReaAry = getAdmReason();
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "自费患者，不能取消医保结算", type: "info"});
		return;
	}
	if (isChgedBill()) {
		$.messager.popover({msg: "该账单已结算，不能取消医保结算", type: "info"});
		return;
	}
	if (!isInsuDivided()) {
		$.messager.popover({msg: "医保未结算，不能取消医保结算", type: "info"});
		return;
	}
	insuCancelDivide();
}

/**
 * 交押金
 */
function linkAddDeposit() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var paramObj = {EpisodeID: GV.EpisodeID};
	initCfgTab("addDepositTab", paramObj);
}

/**
 * 退押金
 */
function linkRefDeposit() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var paramObj = {EpisodeID: GV.EpisodeID};
	initCfgTab("refDepositTab", paramObj);
}

/**
 * 患者费用明细
 */
function linkBillDetail() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择患者账单", type: "info"});
		return;
	}
	var paramObj = {EpisodeID: GV.EpisodeID, BillID: GV.BillID};
	initCfgTab("billDetailTab", paramObj);
}

/**
 * 医嘱费用查询
 */
function linkAdmOrderFee() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var paramObj = {EpisodeID: GV.EpisodeID};
	initCfgTab("admOrderFee", paramObj);
}

/**
 * 收费项目查询
 */
function linkSearchTarFee() {
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var paramObj = {BillID: GV.BillID};
	initCfgTab("searchTarFee", paramObj);
}

/**
 * 押金明细
 */
function linkSearchDepDet() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var depTypeId = getIPDepTypeId();
	var paramObj = {EpisodeID: GV.EpisodeID, DepositType: depTypeId};
	initCfgTab("searchDepDet", paramObj);
}

/**
 * 跳号
 */
function altVoidInvClick() {
	var insTypeId = getInsTypeId();
	var argumentObj = {
		receiptType: "IP",
		insTypeId: insTypeId
	};
	BILL_INF.showSkipInv(argumentObj).then(checkInv);
}

/**
 * 结算退款
 */
function refundSrvClick() {
	var prtRowId = GV.PrtRowID;
	if (!prtRowId) {
		$.messager.popover({msg: "请先选择结算记录", type: "info"});
		return;
	}
	var notRefAmt = getNotRefundAmt(prtRowId);
	if (notRefAmt == 0) {
		$.messager.popover({msg: "没有待退款的第三方支付", type: "info"});
		return;
	}
	refundSrv(prtRowId);
}

function openCostInquriy(row) {
	var url = "dhcbill.ipbill.patcostinquriy.csp?BillNo=" + row.pbrowid + "&EpisodeID=" + row.episodeid;
	websys_showModal({
		url: url,
		title: $g('患者科室费用查询'),
		iconCls: 'icon-w-find',
		width: '90%',
		height: '85%'
	});
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	refreshBar(patientId, episodeId);
	setEprMenuForm(episodeId, patientId);
	
	getPatInfo();
}

/**
* iframe 调用父窗口方法来跳转到病人列表
*/
function setDefTabFromIframe() {
	$("#chargeTabs").tabs("select", 0);
}

/**
* 锁定/解锁就诊记录
* admStr: 需加锁/解锁的就诊Id
* isLock：true:加锁, false:解锁
* 返回值：true:有锁定adm, false:无锁定adm
*/
function lockAdm(admStr, isLock) {
	if (!admStr) {
		return false;
	}
	if (isLock) {
		//加锁
		var rtn = $.m({ClassName: "web.DHCBillLockAdm", MethodName: "LockAdm", admStr: admStr}, false);
		if (rtn != "") {
			rtn = rtn.replace(/\^/g, "\n");
			$.messager.popover({msg: rtn, type: "info"});
			return true;
		}
		return false;
	}
	//解锁
	$.m({ClassName: "web.DHCBillLockAdm", MethodName: "UnLockAdm", wantreturnval: 0, admStr: admStr}, false);
	return false;
}

/**
* 获取"住院押金"类型RowId
*/
function getIPDepTypeId() {
	return $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
}

/**
* 过号重打
*/
function passNoReprtClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择账单", type: "info"});
				return reject();
			}
			if (!(GV.PrtRowID > 0)) {
				$.messager.popover({msg: "账单未结算，不能过号重打", type: "info"});
				return reject();
			}
			var invJson = getPersistClsObj("User.DHCINVPRTZY", GV.PrtRowID);
			prtInvNo = invJson.PRTinv;
			if (!prtInvNo) {
				$.messager.popover({msg: "发票号为空，不能过号重打", type: "info"});
				return reject();
			}
			if (invJson.PRTUsr != PUBLIC_CONSTANT.SESSION.USERID) {
				$.messager.popover({msg: "非您本人打印的发票，不能过号重打", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("是否确认将发票") + "【<font color=\"red\">" + prtInvNo + "</font>】" + $g("过号重打? ")), function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 过号重打
	*/
	var _reprint = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "BILL.IP.BL.PrtInv",
				MethodName: "PrtSkipNoReprint",
				prtRowId: GV.PrtRowID,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "过号重打成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "过号重打失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 过号重打成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
		checkInv();    //设置新的发票号
		var invPrintFlag = getPropValById("DHC_INVPRTZY", GV.PrtRowID, "PRT_INVPrintFlag");
		if (invPrintFlag == "P") {
			inpatInvPrint(GV.PrtRowID + "#" + "");
		}
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var prtInvNo = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_reprint)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
* wangxinqiang
* 2022-08-17
* 打印票据遗失证明
*/
function loseProveClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	if (!(GV.PrtRowID > 0)) {
		$.messager.popover({msg: "账单未结算，不能打印", type: "info"});
		return;
	}
	var prtInvNo = getPropValById("DHC_INVPRTZY", GV.PrtRowID, "PRT_inv");
	if (!prtInvNo) {
		$.messager.popover({msg: "发票号为空，不能打印", type: "info"});
		return;
	}
	var fileName = "DHCBILL-IPBILL-PJYSZM.rpx" + "&prtRowId="+ GV.PrtRowID;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
 * 外院发票录入
 */
function addInvClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var url = "dhcbill.outpay.ipaddinv.csp?&EpisodeID=" + GV.EpisodeID + "&BillId=" + GV.BillID;
	websys_showModal({
		url: url,
		title: '外院发票录入',
		iconCls: 'icon-w-add',
		width: '98%',
		height: '90%'
	});
}
