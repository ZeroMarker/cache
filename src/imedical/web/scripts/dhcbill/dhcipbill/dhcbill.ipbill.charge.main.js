/**
 * FileName: dhcbill.ipbill.charge.main.js
 * Anchor: ZhYW
 * Date: 2019-03-04
 * Description: 住院收费
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
		frameEnterKeyCode(e);
	});
	//初始化查询菜单
	initQueryMenu();

	//初始化Grid
	initCateList();
	initDepositList();
	initBillList();
	initPayMList();
	
	initTabs();
	checkInv();   //设置默认发票号
	
	loadGridData();
	
	getPatInfo();

	focusById("patientNo");
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
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

	//结算
	$HUI.linkbutton("#btn-disCharge", {
		onClick: function () {
			disChargeClick();
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
			insuPreDivideClick();
		}
	});
	
	//取消医保结算
	$HUI.linkbutton("#btn-insuCancelDivide", {
		onClick: function () {
			insuCancelDivideClick();
		}
	});
	
	//押金列表
	$HUI.linkbutton("#btn-depList", {
		onClick: function () {
			depListClick();
		}
	});

	//卡号回车查询事件
	$("#cardNo").keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//病案号回车查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});

	//实付回车
	$("#patPaidAmt").keydown(function (e) {
		patPaidAmtKeydown(e);
	});

	initAdmList();      //就诊列表
	initChargeStatus(); //结算状态
	initCardType();     //卡类型
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
		textField: "TAdmDept",
		columns: [[{field: 'TAdm', title: 'TAdm', hidden: true}, 
				   {field: 'TAdmDate',	title: '就诊时间', width: 150,
				    formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TAdmTime;
						}
					}
				   },
				   {field: 'TAdmDept', title: '就诊科室', width: 90},
				   {field: 'TAdmWard', title: '就诊病区', width: 130},
				   {field: 'TDisDate', title: '出院时间', width: 150,
				   	formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TDisTime;
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
			setGlobalValue("EpisodeID", row.TAdm);
			loadBillList();
		},
		onChange: function(newValue, oldValue) {
			//上一个就诊记录释放锁
			if (oldValue) {
				var admAry = [oldValue];
				lockAdm(admAry, false);
			}		
		}
	});
}

/**
* 结算状态下拉框
*/
function initChargeStatus() {
	$HUI.combobox("#status", {
		panelHeight: "auto",
		data: [{value: "", text: "全部"},
			   {value: "billed", text: "未结算"},
			   {value: "discharge",	text: "最终结算"},
			   {value: "paid", text: "结算历史"},
			   {value: "toBill", text: "新入院"}
		],
		editable: false,
		valueField: "value",
		textField: "text",
		onSelect: function (record) {
			loadBillList();
		}
	});
}

/**
* 初始化卡类型
*/
function initCardType() {
	$HUI.combobox("#cardType", {
		panelHeight: "auto",
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		editable: false,
		valueField: "value",
		textField: "caption",
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split("^");
		var readCardMode = cardTypeAry[16];
		if (readCardMode == "Handle") {
			disableById("btn-readCard");
			$("#cardNo").attr("readOnly", false);
		} else {
			enableById("btn-readCard");
			setValueById("cardNo", "");
			$("#cardNo").attr("readOnly", true);
		}
	} catch (e) {
	}
}

/**
* 初始化账单列表
*/
function initBillList() {
	GV.BillList = $HUI.datagrid("#tBillList", {
		fit: true,
		striped: true,
		bodyCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		pageSize: 99999999,
		columns: [[{title: '就诊日期', field: 'admdate', width: 90},
				   {title: '就诊时间', field: 'admtime', width: 80},
				   {title: '费别', field: 'instypedesc', width: 80},
				   {title: '科室病区', field: 'locward', width: 180},
				   {title: '床号', field: 'beddesc', width: 60},
				   {title: '押金', field: 'deposit', align: 'right',width: 80},
				   {title: '总金额', field: 'totalamount', align: 'right', width: 80},
				   {title: '自付金额', field: 'patientshare', align: 'right', width: 80},
				   {title: '医保报销', field: 'ybfee', align: 'right', hidden: true},
				   {title: '折扣金额', field: 'discountamount', align: 'right', width: 80},
				   {title: '记账金额', field: 'payorshare', align: 'right', width: 80},
				   {title: '住院状态', field: 'dischargestatus', width: 80},
				   {title: '账单状态', field: 'paidflag', width: 80},
				   {title: '出院日期', field: 'dischargedate', width: 80},
				   {title: '出院时间', field: 'dischargetime', width: 80},
				   {title: '入院办理人', field: 'admuser', width: 80},
				   {title: '住院天数', field: 'zydays', width: 80},
				   {title: '出院办理人', field: 'disuser', width: 80},
				   {title: '护士出院办理人', field: 'disdocname', width: 110},
				   {title: '审核状态', field: 'CodingFlag', width: 80},
				   {title: '审核日期', field: 'CodingUPDate', width: 80},
				   {title: '审核时间', field: 'CodingUPTime', width: 80},
				   {title: '审核人', field: 'CodingUPUserDr', width: 80},
				   {title: '审核原因', field: 'CodingReason', width: 80},
				   {title: '发票号', field: 'invno', width: 80},
				   {title: '财务结算日期', field: 'prtdate', width: 120},
				   {title: '财务结算时间', field: 'prttime', width: 120},
				   {title: '就诊状态', field: 'visitstatus', hidden: true},
				   {title: '账单ID', field: 'pbrowid', width: 80},
				   {title: 'ARRCPID', field: 'arrcprowid', hidden: true},
				   {title: '账单状态', field: 'pbflag', hidden: true},
				   {title: '费别ID', field: 'instypedr', hidden: true},
				   {title: 'patientid', field: 'patientid', hidden: true},
				   {title: '发票ID', field: 'prtrowid', hidden: true},
				   {title: '发票状态', field: 'prtflag', width: 80},
				   {title: '就诊号', field: 'episodeid', width: 70},
				   {title: '是否转科', field: 'translocFlag', align: 'center', width: 80,
					formatter: function (value, row, index) {
						if (value == "Y") {
							return "<a href='javascript:;' onclick=\"openCostInquriy('" + row.pbrowid + "', '" + row.episodeid + "')\">是</a>";
						} else {
							return "否";
						}
					}
				}
			]],
		rowStyler: function (index, row) {
			if ((row.dischargestatus == "最终结算") || (row.dischargestatus == "护士办理出院") || (row.dischargestatus == "结束费用调整")) {
				return "color: #FF0000;";
			}
		},
		onLoadSuccess: function (data) {
			GV.depositArray = [];      //清空押金数组
			GV.EditIndex = undefined;
			enableById("btn-insuPreCharge");
			enableById("btn-disCharge");
			//账单列表无数据时,需清空分类信息Grid、支付方式Grid、押金列表Grid
			if (data.total == 0) {
				delete GV.BillID;
				delete GV.PrtRowID;
				delete GV.ARRCPRowID;
				loadGridData();
			}else {
				var selectRowIndex = 0;    //默认第一行
				$.each(data.rows, function (index, row) {
					if (row.pbrowid && (row.pbrowid == getGlobalValue("BillID"))) {
						selectRowIndex = index;
						return false;
					}
				});
				GV.BillList.selectRow(selectRowIndex);
			}
		},
		onSelect: function (index, row) {
			GV.depositArray = []; //清空押金数组
			setGlobalValue("PatientID", row.patientid);
			setGlobalValue("EpisodeID", row.episodeid);
			setGlobalValue("BillID", row.pbrowid);
			setGlobalValue("ARRCPRowID", row.arrcprowid);
			setGlobalValue("PrtRowID", row.prtrowid);
			loadGridData();
			initPatFeeInfo();
			setPayMPanelTitle();
			setEprMenuForm(row.episodeid, row.patientid);  //头菜单传值
			if (!getGlobalValue("BillID")) {
				return false;
			}
			var admAry = [row.episodeid];
			var lockRtn = lockAdm(admAry, true);
			if (lockRtn) {
				return false;  //选择的Adm已经被锁定
			}
			//如果已经医保结算，把医保预结算按钮变灰
			var insuChargeFlag = checkInsuCharge();
			if (!insuChargeFlag) {
				disableById("btn-insuPreCharge");
			} else {
				enableById("btn-insuPreCharge");
			}
			//判断是否有发票
			var requiredInv = isReaRequiredInv();
			var hasInv = checkInv();
			if (requiredInv && !hasInv) {
				$.messager.popover({msg: "您没有可用发票，不能结算，请先领取发票", type: "info"});
			}
		},
		onRowContextMenu: function (e, index, row) {
			e.preventDefault();
			//添加右键菜单
			initRightMenu(e);
			//判断是不是在同一条记录上右击如果是则不刷新支付方式和押金
			if (row.pbrowid != getGlobalValue("BillID")) {
				GV.BillList.selectRow(index);
			}
		}
	});
	//初始化工具按钮菜单
	initToolMenu();
}

/**
 * 工具菜单
 */
function initToolMenu() {
	var menuBtnArr = getAuthMenu("IPBILLTool");
	if (menuBtnArr.length > 0) {
		try {
			$('#tBillList').datagrid({
				toolbar: menuBtnArr
			});
		} catch (e) {
			$.messager.popover({msg: "创建工具菜单失败：" + e.message, type: "error"});
		}
	}
}

/**
 * 右键菜单
 */
function initRightMenu(e) {
	var menuBtnArr = getAuthMenu("IPBILLRighty");
	if (menuBtnArr.length > 0) {
		try {
			createGridRightyKey(e, "rightyKey", menuBtnArr);
		} catch (e) {
			$.messager.popover({msg: "创建右键菜单失败：" + e.message, type: "error"});
		}
	}
}

/**
* 获取授权菜单JSON
*/
function getAuthMenu(menuPar) {
	return $.cm({
		ClassName: "web.UDHCJFBILLMENU",
		MethodName: "GetSubListToJson",
		ResultSetType: "array",
		code: menuPar,
		groupId: PUBLIC_CONSTANT.SESSION.GROUPID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
}

/**
 * 创建右键菜单
 */
function createGridRightyKey(e, target, menuBtnArr) {
	//没有授权菜单 不创建
	if (menuBtnArr.length == 0) {
		return;
	}
	var $target = $('#' + target);
	if (!$target.length) {
		$target = $('<div id=\"' + target + '\"></div>').appendTo('body');
		$target.menu();
		$.each(menuBtnArr, function (index, item) {
			$target.menu("appendItem", {
				id: item.id,
				text: item.text,
				iconCls: item.iconCls,
				onclick: eval("(" + item.handler + ")")
			});
		});
	}
	$target.menu('show', {
		left: e.pageX,
		top: e.pageY
	});
}

/**
* 初始化分类信息Grid
*/
function initCateList() {
	$HUI.datagrid("#tCateList", {
		fit: true,
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
		columns: [[{title: '分类', field: 'TarDesc1', width: 70},
				   {title: '金额',field: 'TarAmt1', align: 'right', width: 70, sortable: true,
					sorter: function (a, b) {
					   	return ((numCompute(a, b, "-") > 0) ? 1 : -1);
					}
				   }
			]],
		onLoadSuccess: function(data) {
			if (data.footer && (data.footer.length > 0)) {
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").css("visibility","visible");
				$("#panelCate [class='datagrid-ftable'] [class='datagrid-cell-rownumber']").text(data.total + 1);
			}
		}
	});
}

/**
* 初始化押金Grid
*/
function initDepositList() {
	GV.DepositList = $HUI.datagrid("#tDepositList", {
		fit: true,
		bodyCls: 'panel-body-gray',
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		autoRowHeight: false,
		rownumbers: true,
		pageSize: 99999999,
		loadMsg: '',
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '金额', field: 'TDepAmt', align: 'right', width: 80},
				   {title: '押金单号', field: 'TDepNO', width: 100},
				   {title: '支付方式', field: 'TDepPayM', width: 100,
			   		formatter: function (value, row, index) {
						if (row.TBillFlag == "0") {
							return value + " ( <span style='color:#ff0000'>未到账</span> )";
						}else {
							return value;
						}
					}
				   },
				   {title: '交款日期', field: 'TDepPrtDate', width: 90},
				   {title: '收费员', field: 'TUser', width: 80},
				   {title: '状态', field: 'TPrtStatus', width: 60},
				   {title: '支票到账标识', field: 'TBillFlag', hidden: true},
				   {title: 'TPayMRowid', field: 'TPayMRowid', hidden: true},
				   {title: 'TRcptRowid', field: 'TRcptRowid', hidden: true},
				   {title: 'TBankBackFlag', field: 'TBankBackFlag',hidden: true},
				   {title: 'TRefundNo', field: 'TRefundNo', hidden: true},
				   {title: 'TPrtStatusFlag', field: 'TPrtStatusFlag',hidden: true},
				   {title: 'PAPMIRowID', field: 'patientid',hidden: true},
				   {title: 'TARRCPTDR', field: 'TARRCPTDR', hidden: true}
			]],
		onLoadSuccess: function (data) {
			onLoadSuccessDepList(data);
		},
		onCheckAll: function (rows) {
			onCheckAllDepList(rows);
		},
		onUncheckAll: function (rows) {
			onUncheckAllDepList();
		},
		onCheck: function (index, row) {
			onCheckDepList(index, row);
		},
		onUncheck: function (index, row) {
			onUncheckDepList(index, row);
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
		papmi: getGlobalValue("PatientID"),
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
		EpisodeID: getGlobalValue("EpisodeID"),
		PayStatus: getValueById("status"),
		SessionStr: getSessionStr(),
		rows: 99999999
	}
	loadDataGridStore("tBillList", queryParams);
}

/**
* 加载分类信息列表数据
*/
function loadCateList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "GetLedger",
		bill: getGlobalValue("BillID"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		totalFields: "TarAmt1",
		totalFooter: '"TarDesc1":"合计"',
		rows: 99999999
	}
	loadDataGridStore("tCateList", queryParams);
}

/**
* 加载界面Grid数据
*/
function loadGridData() {
	loadCateList();
	loadPayMList();
	loadDepositList();
}

/**
* 押金明细窗口
*/
function depListClick() {
	if (!getGlobalValue("EpisodeID")) {
		return;
	}
	$("#depositDlg").show();
	$("#depositDlg").dialog({
		width: 600,
		height: 450,
		iconCls: 'icon-w-list',
		title: '押金明细',
		draggable: false,
		modal: true,
		onClose: function () {
			setDepositArray();
		}
	});
}

/**
* 登记号回车事件
*/
function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("medicareNo", "");
		getPatInfo(e);
	}
}

/**
* 病案号回车事件
*/
function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("patientNo", "");
		getPatInfo(e);
	}
}

function getPatInfo() {
	var patientNo = "";
	var medicareNo = "";
	var episodeId = "";
	if ((typeof arguments[0] === "object") && (arguments[0].target)) {
		patientNo = getValueById("patientNo");
		medicareNo = getValueById("medicareNo");
	} else {
		var frm = dhcsys_getmenuform();
		if (frm) {
			episodeId = frm.EpisodeID.value;
		}
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
			if (rtn) {
				setPatInfo(rtn);
			}else {
				$.messager.popover({msg: "患者不存在", type: "info"});
			}
		});
	}
}

function setPatInfo(str) {
	try {
		var myAry = str.split("^");
		var myPatNo = myAry[0];
		var myPatName = myAry[1];
		var myMedicareNo = myAry[6];
		var myVisitStatus = myAry[8];
		var myAdmId = ("CP".indexOf(myVisitStatus) == -1) ? myAry[2] : "";
		var myPapmiId = myAry[14];
		setValueById("patientNo", myPatNo);
		setValueById("medicareNo", myMedicareNo);
		setGlobalValue("PatientID", myPapmiId);
		setGlobalValue("EpisodeID", myAdmId);
		$("#chargeTabs").tabs("select", 0);   //设置默认选中
		refreshBar(myPapmiId, myAdmId);
		loadAdmList();
	}catch(e) {
		$.messager.popover({msg: "获取患者信息异常:" + e.message, type: "error"});
	}
}

/**
 * 结算
 */
function disChargeClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	
	//判断是否需要发票
	var requiredInv = isReaRequiredInv();
	var hasInv = checkInv();
	if (requiredInv && !hasInv) {
		$.messager.popover({msg: "您没有可用发票，请先领取发票", type: "info"});
		return;
	}
	
	//判断当前票号和界面是否一致
	var sameFlag = checkInvSame();
	if (!sameFlag) {
		$.messager.popover({msg: "发票号和后台查询不一致，请刷新界面后再试", type: "info"});
		return;
	}

	//判断是否婴儿结算
	var rtnStr = tkMakeServerCall("web.UDHCJFCOMMON", "CheckBabyAdmDisCharge", getGlobalValue("EpisodeID"));
	var rtn = rtnStr.split("^")[0];
	var admStatus = rtnStr.split("^")[1];
	if (+rtn != 0) {
		var msg = ((+rtn == -1) ? "有婴儿未结算" : ("婴儿是" + admStatus + "状态")) + "，母亲是否确认结算?";
		$.messager.confirm("确认", msg, function (r) {
			if (r) {
				_linkPay();
			}
		});
	}else {
		_linkPay();
	}
	
	function _linkPay() {
		//判断账单状态
		var billInfo = getBillBaseInfo();
		if (!billInfo) {
			$.messager.popover({msg: "获取账单信息失败", type: "info"});
			return;
		}
		var billAry = billInfo.split("^");
		var refundFlag = billAry[16];        //红冲标志
		var billNationalCode = billAry[21];  //账单费别NationalCode
		var payedFlag = billAry[15];         //计费状态
		if (refundFlag == "B") {
			$.messager.popover({msg: "该账单已经红冲，不允许结算", type: "info"});
			return;
		}
		if (payedFlag == "P") {
			var msg = "该账单已结算";
			if (isClosedBill()) {
				msg = "该账单已封账，不允许结算"; 
			}
			$.messager.popover({msg: msg, type: "info"});
			return;
		}
		var admReasonAry = getAdmReason();
		var admReaId = admReasonAry[0];
		var admReaNationalCode = admReasonAry[1];
		//判断就诊状态
		var admStatus = getAdmStatus();
		if (admStatus == "退院") {
			$.messager.popover({msg: "该患者已退院，不能结算", type: "info"});
			return;
		}
		
		var admStatAry = ["护士办理出院", "结束费用调整", "最终结算"];
		if ($.inArray(admStatus, admStatAry) == -1) {
			var billNum = getBillNum();
			if (+billNum > 1) {
				$.messager.confirm("确认", "患者要做中途结算，是否确认结算？", function (r) {
					if (r) {
						_linkCharge();
					}
				});
			} else {
				//判断医保患者是否必须做最终结算
				if ((+admReaNationalCode > 0) && (IPBILL_CONF.PARAM.InsuIntPay != "Y")) {
					$.messager.popover({msg: "医保患者是" + admStatus + "状态，不能结算", type: "info"});
					return;
				} else if (admStatus == "费用调整") {
					$.messager.popover({msg: "患者正在进行费用调整，不能结算", type: "info"});
					return;
				} else {
					$.messager.confirm("确认", "患者是" + admStatus + "状态，是否确认结算？", function (r) {
						if (r) {
							_linkCharge();
						}
					});
				}
			}
		} else {
			//最终结算时验证自费患者是否取消医保登记
			var cancelFlag = checkInsuRegIsCancel();
			if (!cancelFlag) {
				$.messager.popover({msg: "医保未取消登记，不能结算", type: "info"});
				return;
			}else {
				$.messager.confirm("确认", "是否确认结算？", function (r) {
					if (r) {
						_linkCharge();
					}
				});
			}
		}
		
		function _linkCharge() {
			if ($.inArray(admStatus, admStatAry) == -1) {
				//判断收费是否有未记账的医嘱、是否有计费数量与发药数量不一致的药品
				var hasNotBillOrd = getNotBillOrd();
				if (hasNotBillOrd) {
					return;
				}
			} else {
				//费用核查
				var checkFeeFlag = checkFee();
				if (!checkFeeFlag) {
					return;
				}
			}
			//判断账单数量，判断是否账单
			var billNum = getBillNum();
			if (+billNum == 1) {
				var hasClickBill = checkBillClick();
				if (!hasClickBill) {
					$.messager.popover({msg: "请先做账单", type: "info"});
					return;
				}
			}
			//费用审核
			if (IPBILL_CONF.PARAM.ConfirmPatFee == "Y") {
				var rtn = $.m({ClassName: "web.UDHCJFBillDetailOrder", MethodName: "GetCodingFlag", Adm: getGlobalValue("EpisodeID"), BillNo: getGlobalValue("BillID")}, false);
				if (rtn != "Y") {
					$.messager.popover({msg: "该患者费用还未审核通过，不允许结算", type: "info"});
					return;
				}
			}
			if (isOpenPayMWin()) {
				var url = "dhcbill.ipbill.charge.paym.csp?&EpisodeID=" + getGlobalValue("EpisodeID") + "&BillID=" + getGlobalValue("BillID");
				websys_showModal({
					url: url,
					title: "出院结算",
					iconCls: "icon-w-paid",
					onClose: function () {
						//判断账单状态
						var billInfo = getBillBaseInfo();
						if (!billInfo) {
							$.messager.popover({msg: "获取账单信息失败", type: "info"});
							return;
						}
						var billAry = billInfo.split("^");
						var payedFlag = billAry[15];         //计费状态
						if (payedFlag == "P") {
							if (getValueById("status") != "paid") {
								$("#status").combobox("select", "paid");
							} else {
								loadBillList();
							}
						}else {
							//配置了HIS未结算关闭界面取消医保结算时需撤销医保
							if (getGlobalValue("CancelInsuDiv") == "Y") {
								insuCancelDivide();
							}
						}
					}
				});
			}else {
				charge();
			}
		}
	}
}

/**
* 判断收费有未记账的医嘱有计费数量与发药数量不一致的药品如果有则不允许结算
*/
function getNotBillOrd() {
	var rtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetNotBillOrd", getGlobalValue("EpisodeID"), getGlobalValue("BillID"));
	var notBillOrdArr = rtn.split("^");
	var mNotBill = notBillOrdArr[0].split(",");
	var mNotBillNum = mNotBill[0];
	var mNotBillInfo = mNotBill[1];
	/*
	if (mNotBillNum != 0) {
		$.messager.popover({msg: "该患者有需要计费的医嘱，不能结算", type: "info"});
		return true;
	}
	*/
	var mDis = notBillOrdArr[1].split(",");
	var mDisNum = mDis[0];
	var mDisInfo = mDis[1];
	if (mDisNum != 0) {
		$.messager.popover({msg: "该患者有发药数量与计费数量不一致的医嘱，不能结算", type: "info"});
		return true;
	}
	var notDisp = notBillOrdArr[2].split(",");
	var notDispNum = notDisp[0];
	var notDispInfo = notDisp[1];
	if (notDispNum != 0) {
		$.messager.popover({msg: "该患者有未发药品，不能结算", type: "info"});
		return true;
	}
	//判断中途结算帐单是否有负数帐单
	var mPBNegativ = notBillOrdArr[3].split(",");
	var mPBNegativNum = mPBNegativ[0];
	var mPBNegativInfo = mPBNegativ[1];
	if (+mPBNegativNum != 0) {
		$.messager.popover({msg: "该患者有负数的医嘱，不能结算", type: "info"});
		return true;
	}
	//判断婴儿的
	var babyRtn = tkMakeServerCall("web.DHCIPBillPayControl", "GetBabyNotBillOrd", getGlobalValue("EpisodeID"), getGlobalValue("BillID"));
	var babyNotBillOrdArr = babyRtn.split("^");
	var babyNotBill = babyNotBillOrdArr[0].split(",");
	var babyNotBillNum = babyNotBill[0];
	var babyNotBillInfo = babyNotBill[1];
	/*
	if (babyNotBillNum != 0) {
		$.messager.popover({msg: "该患者的婴儿有需要计费的医嘱，不能结算", type: "info"});
		return true;
	}
	*/
	var babyDis = babyNotBillOrdArr[1].split(",");
	var babyDisNum = babyDis[0];
	var babyDisInfo = babyDis[1];
	if (babyDisNum != 0) {
		$.messager.popover({msg: "该患者的婴儿有发药数量与计费数量不一致的医嘱，不能结算", type: "info"});
		return true;
	}
	var babyNotDisp = babyNotBillOrdArr[2].split(",");
	var babyNotDispNum = babyNotDisp[0];
	var babyNotDispInfo = babyNotDisp[1];
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
	if (GV.EpisodeID) {
		var admAry = [GV.EpisodeID];
		lockAdm(admAry, false);    //就诊解锁
	}

	clearGV();
	clearTopForms();

	setDefTabFromIframe();
	$(":text:not(.pagination-num)").val("");
	$("#cardType").combobox("reload");
	setValueById("status", "");
	$("#admList").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
	GV.BillList.loadData({total: 0, rows: []});
	
	$(".numberbox-f").numberbox("clear");

	GV.PayMList.getPanel().panel("setTitle", "支付信息");
	
	checkInv();     //设置默认发票号
		
	setValueById("currentInvId", "");
	
	$(".PatInfoItem").html("");
	
	focusById("patientNo");
}

function clearGV() {
	GV.PatientID = "";
	GV.EpisodeID = "";
	GV.BillID = "";
	GV.PrtRowID = "";
	GV.BalanceAmt = "";
	GV.ClickBill = "";
	GV.depositArray = [];
}

function clearTopForms() {
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
* 卡号回车事件
*/
function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById("cardNo");
			if (!cardNo) {
				return;
			}
			var cardType = getValueById("cardType");
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split("^");
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, "", "PatInfo");
			var myAry = myRtn.toString().split("^");
			var rtn = myAry[0];
			switch (rtn) {
			case "0":
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatInfo(e);
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("cardNo");
					});
				}, 300);
				break;
			case '-201':
				setValueById("cardNo", myAry[1]);
				setValueById("patientNo", myAry[5]);
				getPatInfo(e);
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById("cardType");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatInfo(event);
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("btn-readCard");
			});
			break;
		case "-201":
			setValueById("cardNo", myAry[1]);
			setValueById("patientNo", myAry[5]);
			getPatInfo(event);
			break;
		default:
		}
	} catch (e) {
	}
}

/**
 * 原号重新打印收据
 */
function rePrintInvClick() {
	var row = GV.BillList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择需要重打的记录", type: "info"});
		return;
	}
	var invNo = row.invno;
	if (!invNo) {
		$.messager.popover({msg: "发票号为空，不能重打", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", invNo, PUBLIC_CONSTANT.SESSION.USERID);
	var prtInvFlag = rtn.split("^")[0];
	var prtInvRowId = rtn.split("^")[1];
	var prtInsDR = rtn.split("^")[2];
	if (prtInvFlag != "1") {
		$.messager.popover({msg: "该发票已作废，不能重打", type: "info"});
		return;
	} else {
		$.messager.confirm("确认", "确定要重打发票?", function (r) {
			if (r) {
				inpatInvPrint(prtInvRowId + "#" + "R");  //R为补打标志
			}
		});
	}
}

/**
 * 打印台账
 */
function printPtLedger() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var params = "&billId=" + getGlobalValue("BillID");
	var fileName = "DHCBILL-IPBILL-Ledger.rpx" + params;
	DHCCPM_RQPrint(fileName, 900, 600);
}

/**
* 判断医保患者是否能够中途结算
* 根据UDHCJFIPInsu.js
*/
function canHarfBillForInsu() {
	var insuArr = [];
	insuArr.push("本地医保");
	//取就诊费别
	var rtn = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "getInsTypeInfo", EpisodeID: "", BillNo: getGlobalValue("BillID")}, false);
	var nationalCode = "";
	var admReasonDesc = "";
	if (rtn != "") {
		var myAry = rtn.split("^");
		nationalCode = myAry[5];
		admReasonDesc = myAry[2];
	}
	if ($.inArray(admReasonDesc, insuArr) != -1) {
		return false;
	}
	if ((IPBILL_CONF.PARAM.InsuIntPay != "Y") && (+nationalCode > 0)) {
		return false;
	}
	return true;
}

/**
 * 快捷键
 */
function frameEnterKeyCode(e) {
	var key = websys_getKey(e);
	switch (key) {
	case 115: //F4
		linkBillDetail();
		break;
	case 118: //F7
		clearClick();
		break;
	case 119: //F8
		//findClick();
		break;
	case 120: //F9
		disChargeClick();
		break;
	case 121: // F10
		if ($('#tool-btn-AddDepositTool').is(':visible')) {
			linkAddDeposit();
		}
		break;
	case 117: //F6  和调试F12冲突
		if ($('#tool-btn-RefDepositTool').is(':visible')) {
			linkRefDeposit();
		}
		break;
	case 112: //F1
		setColumnVal();
		break;
	}
}


/**
* 初始化Tab面板事件
*/
function initTabs() {
	$("#chargeTabs").tabs({
		onSelect: function (title, index) {
			var tabPanel = $("#chargeTabs").tabs("getTab", index);
			var billId = getGlobalValue("BillID");
			var episodeId = getGlobalValue("EpisodeID");
			var panelID = "";
			if (tabPanel) {
				var opts = tabPanel.panel("options");
				panelID = opts.id;
			}
			switch (panelID) {
			case "billListTab":
				loadBillList();
				break;
			case "addDepositTab":
				if (episodeId == "") {
					$.messager.popover({msg: "请选择患者", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initAddDepositTab();
				break;
			case "refDepositTab":
				if (episodeId == "") {
					$.messager.popover({msg: "请选择患者", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initRefDepositTab();
				break;
			case "billDetailTab":
				if (billId == "") {
					$.messager.popover({msg: "请选择账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initBillDetailTab();
				break;
			case "halfBillByOrdTab":
				if (billId == "") {
					$.messager.popover({
						msg: "请选择账单",
						type: "info"
					});
					$(this).tabs("select", 0);
					break;
				}
				var billInfo = getBillBaseInfo();
				if (!billInfo) {
					$.messager.popover({msg: "获取账单信息失败", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				var payedFlag = billInfo.split("^")[15];
				if (payedFlag == "P") {
					$.messager.popover({msg: "该账单已经结算，不能拆分账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				//判断医保病人是否能够中途结算
				var canHarfForInsu = canHarfBillForInsu();
				if (!canHarfForInsu) {
					$.messager.popover({msg: "该患者为医保患者，不能拆分账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				var num = getBillNum();
				switch (num) {
				case "0":
					$.messager.popover({msg: "该患者没有未结账单，不能拆分账单", type: "info"});
					break;
				case "1":
					billClick();
					initHalfBillByOrdTab();
					break;
				default:
					$.messager.popover({msg: "该患者有多个未结账单，不能拆分账单", type: "info"});
					$(this).tabs("select", 0);
				}
				break;
			case "searchDepDet":
				if (episodeId == "") {
					$.messager.popover({msg: "请选择患者", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initDepDetailTab();
				break;
			case "searchTarFee":
				if (episodeId == "") {
					$.messager.popover({msg: "请选择账单", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initTarFeeTab();
				break;
			case "admOrderFee":
				if (episodeId == "") {
					$.messager.popover({msg: "请选择患者", type: "info"});
					$(this).tabs("select", 0);
					break;
				}
				initAdmOrderFeeTab();
				break;
			default:
			}
		}
	});
}

/**
* 交押金
*/
function initAddDepositTab() {
	var url = "dhcbill.ipbill.deposit.pay.if.csp?EpisodeID=" + getGlobalValue("EpisodeID");
	addOneTab("chargeTabs", "addDepositTab", "交押金", url);
}

/**
* 退押金
*/
function initRefDepositTab() {
	var url = "dhcbill.ipbill.deposit.refund.if.csp?EpisodeID=" + getGlobalValue("EpisodeID");
	addOneTab("chargeTabs", "refDepositTab", "退押金", url);
}

/**
* 患者费用明细
*/
function initBillDetailTab() {
	var url = "dhcbill.ipbill.billdtl.csp?EpisodeID=" + getGlobalValue("EpisodeID") + "&BillRowId=" + getGlobalValue("BillID");
	addOneTab("chargeTabs", "billDetailTab", "患者费用明细", url);
}

/**
* 医嘱拆分账单
*/
function initHalfBillByOrdTab() {
	var url = "dhcbill.ipbill.intpay.itm.csp?BillID=" + getGlobalValue("BillID");
	addOneTab("chargeTabs", "halfBillByOrdTab", "医嘱拆分账单", url);
}

/**
* 押金明细查询
*/
function initDepDetailTab() {
	var depositTypeId = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetIPDepositTypeId"}, false);
	var url = "dhcbill.ipbill.depositlist.csp?EpisodeID=" + getGlobalValue("EpisodeID") + "&DepositType=" + depositTypeId;
	addOneTab("chargeTabs", "searchDepDet", "押金明细查询", url);
}

/**
* 收费项目查询
*/
function initTarFeeTab() {
	var url = "dhcbill.itemlist.csp?BillNo=" + getGlobalValue("BillID");
	addOneTab("chargeTabs", "searchTarFee", "收费项目查询", url);
}

/**
* 医嘱费用查询
*/
function initAdmOrderFeeTab() {
	var url = "dhcbill.ipbill.patordfee.csp?EpisodeID=" + getGlobalValue("EpisodeID");
	addOneTab("chargeTabs", "admOrderFee", "医嘱费用查询", url);
}

/**
* 添加tab面板
*/
function addOneTab(parentId, tabId, mTitle, mUrl) {
	if ($("#" + parentId).tabs("exists", mTitle)) {
		$("#" + parentId).tabs("select", mTitle);
		refreshTab(tabId, mUrl);
	} else {
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
}

function refreshTab(tabId, url) {
	var iframeId = "iframe_" + tabId;
	var content = '<iframe id="' + iframeId + '" src="' + url + '" width="100%" height="100%" scrolling="auto" frameborder="0"></iframe>';
	$("#" + tabId).css("overflow", "hidden").panel({
		content: content
	}).panel('refresh');
	
	focusById(iframeId);
}

/**
 * 中途结算
 */
function halfBillClick() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择需要中途结算的账单", type: "info"});
		return;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "该账单已封账，不能中途结算", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var payedFlag = billInfo.split("^")[15];
	if (payedFlag == "P") {
		$.messager.popover({msg: "该账单已经结算，不能中途结算", type: "info"});
		return;
	}
	//判断医保患者是否能够中途结算
	var canHarfForInsu = canHarfBillForInsu();
	if (!canHarfForInsu) {
		$.messager.popover({msg: "该患者为医保患者，不能中途结算", type: "info"});
		return;
	}
	var insuUpFlag = getInsuUpFlag();
	switch (insuUpFlag) {
	case "1":
		$.messager.popover({msg: "该账单已医保上传，不能中途结算", type: "info"});
		break;
	case "2":
		$.messager.popover({msg: "该账单已医保结算，不能中途结算", type: "info"});
		break;
	default:
		var num = getBillNum();
		switch (num) {
		case "0":
			$.messager.popover({msg: "该患者没有未结账单，不能中途结算", type: "info"});
			break;
		case "1":
			var url = "dhcbill.ipbill.intpay.csp?BillID=" + getGlobalValue("BillID");
			websys_showModal({
				width: 720,
				height: 335,
				iconCls: 'icon-int-bill',
				title: '中途结算',
				url: url,
				callbackFunc: function() {
					$("#tBillList").datagrid("reload");
				}
			});
			break;
		default:
			$.messager.popover({msg: "该患者有多个未结账单，不能中途结算", type: "info"});
		}
	}
}

/**
 * 取消中途结算
 */
function delHarfBillClick() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择需要取消中途结算的账单", type: "info"});
		return;
	}
	$.messager.confirm("提示", "是否确认取消中途结算?", function (r) {
		if (r) {
			var insuUpFlag = getInsuUpFlag();
			switch (insuUpFlag) {
			case "1":
				$.messager.popover({msg: "该账单已医保上传，不能取消中途结算", type: "info"});
				break;
			case "2":
				$.messager.popover({msg: "该账单已医保结算，不能取消中途结算", type: "info"});
				break;
			default:
				$.m({
					ClassName: "web.UDHCJFIntBill",
					MethodName: "DINBILL",
					BILL: getGlobalValue("BillID"), 
					USER: PUBLIC_CONSTANT.SESSION.USERID
				}, function(rtn) {
					switch (rtn) {
					case "0":
						$.messager.popover({msg: "取消中途结算成功", type: "success"});
						loadBillList();
						break;
					case "-1":
						$.messager.popover({msg: "原账单已结算或已封账，不能取消中途结算", type: "info"});
						break;
					case "-2":
						$.messager.popover({msg: "请选择拆分账单进行取消中途结算", type: "info"});
						break;
					default:
						$.messager.popover({msg: "取消中途结算失败：" + rtn, type: "error"});
					}
				});
			}
		}
	});
}

/**
 * 封帐
 */
function closeAcountClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择需要封账的账单", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var billAry = billInfo.split("^");
	var payedFlag = billAry[15];
	var refundFlag = billAry[16];
	if (refundFlag == "B") {
		$.messager.popover({msg: "该账单已经红冲，不能封账", type: "info"});
		return;
	}
	var admStatus = getAdmStatus();
	if (admStatus == "费用调整") {
		$.messager.popover({msg: "患者正在进行费用调整，不能封账", type: "info"});
		return;
	}
	var num = getBillNum();
	if (+num == 1) {
		var hasClickBill = checkBillClick();
		if (!hasClickBill) {
			$.messager.popover({msg: "请先做账单", type: "info"});
			return;
		}
	}
	$.m({
		ClassName: "web.DHCIPBillPBCloseAcount",
		MethodName: "PaidPatientbill",
		adm: getGlobalValue("EpisodeID"),
		billno: getGlobalValue("BillID"),
		user: PUBLIC_CONSTANT.SESSION.USERID,
		computername: ClientIPAddress
	}, function(rtn) {
		switch (rtn) {
		case "0":
			$.messager.popover({msg: "封账成功", type: "success"});
			loadBillList();
			break;
		case "-101":
			$.messager.popover({msg: "该账单已封账，不能再次封账", type: "info"});
			break;
		case "-102":
			$.messager.popover({msg: "该账单已结算，不能封账", type: "info"});
			break;
		case "-103":
			$.messager.popover({msg: "该就诊是预住院就诊，不能封账", type: "info"});
			break;
		default:
			$.messager.popover({msg: "封账失败：" + rtn, type: "error"});
		}
	});
}

/**
 * 取消封帐
 */
function uncloseAcountClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择需要取消封账的账单", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var billAry = billInfo.split("^");
	var payedFlag = billAry[15];
	var refundFlag = billAry[16];
	if (refundFlag == "B") {
		$.messager.popover({msg: "该账单已经红冲，不能取消封帐", type: "info"});
		return;
	}
	$.m({
		ClassName: "web.DHCIPBillPBCloseAcount",
		MethodName: "UnCloseAcount",
		Adm: getGlobalValue("EpisodeID"),
		BillNo: getGlobalValue("BillID"),
		Guser: PUBLIC_CONSTANT.SESSION.USERID,
		computername: ClientIPAddress
	}, function(rtn) {
		switch (rtn) {
		case "0":
			$.messager.popover({msg: "取消封帐成功", type: "success"});
			loadBillList();
			break;
		case "AdmNull":
			$.messager.popover({msg: "请选择需取消封账的账单", type: "info"});
			break;
		case "ErrNull":
			$.messager.popover({msg: "该账单未封账，不需取消封帐", type: "info"});
			break;
		case "AlreadyPRT":
			$.messager.popover({msg: "该账单已经结算，不能取消封帐", type: "info"});
			break;
		case "CofimOK":
			$.messager.popover({msg: "已经审核，不能取消封帐", type: "info"});
			break;
		default:
			$.messager.popover({msg: "取消封帐失败：" + rtn, type: "error"});
		}
	});
}

/**
 * 取消结算
 */
function cancelChargeClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	
	//判断取消结算是否需要打印负票，如果打印判断是否有可用发票
	if (IPBILL_CONF.PARAM.StrikeInvRequireInv == "Y") {
		var requiredInv = isReaRequiredInv();
		var hasInv = checkInv();
		if (requiredInv && !hasInv) {
			$.messager.popover({msg: "取消结算需打印负票，您没有可用发票，请先领取发票", type: "info"});
			return;
		}
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "此账单已封帐，不能取消结算", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var payedFlag = billInfo.split("^")[15];
	if (payedFlag == "B") {
		$.messager.popover({msg: "账单没有结算，不能取消结算", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.UDHCJFPBCANCELIP", MethodName: "GetBillPayFlag", bill: getGlobalValue("BillID")}, false);
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		$.messager.popover({msg: myAry[1], type: "info"});
		return;
	}
	var msg = "是否确认取消？";
	var transDepAmt = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetTransDeposit", Adm: getGlobalValue("EpisodeID")}, false);
	if (+transDepAmt > 0) {
		msg = "患者结算时转过押金，取消结算押金会虚增，" + msg;
	}
	$.messager.confirm("确认", msg, function (r) {
		if (r) {
			if (+transDepAmt > 0) {
				$.messager.alert("提示", "请退掉中途结算转过的押金", "info", function () {
					_cancelPay();
				});
			}else {
				_cancelPay();
			}
		}
	});
	
	function _cancelPay() {
		//医保取消结算
		var rtn = insuCancelDivide();
		if (+rtn < 0) {
			$.messager.popover({msg: "医保取消结算失败", type: "info"});
			return;
		}
		$.m({
			ClassName: "web.UDHCJFPBCANCELIP",
			MethodName: "DelPay",
			Adm: getGlobalValue("EpisodeID"),
			BillNo: getGlobalValue("BillID"),
			User: PUBLIC_CONSTANT.SESSION.USERID,
			InvFlag: IPBILL_CONF.PARAM.StrikeInvRequireInv,
			SessionStr: getSessionStr()
		}, function(rtn) {
			var myAry = rtn.split("^");
			var errCode = myAry[0];
			var strikeBill = myAry[1];
			var newBill = myAry[2];
			var newPrtRowId = myAry[3];
			switch (errCode) {
			case "0":
				$.messager.popover({msg: "取消结算成功", type: "success"});
				loadBillList();
				if (newPrtRowId != "") {
					//更新发票号
					checkInv();
					if (IPBILL_CONF.PARAM.StrikeInvRequireInv == "Y") {
						inpatInvPrint(newPrtRowId + "#" + "");
					}
				}
				
				//获取取消结算模式配置
				var rtn = $.m({ClassName: "web.UDHCJFPBCANCELIP", MethodName: "GetDelPayMode", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
				if (rtn == "1") {
					$.m({
						ClassName: "web.UDHCJFPBCANCELIP",
						MethodName: "GetTransDepRowIDStr",
						bill: strikeBill
					}, function (rtn) {
						$.each(rtn.split("^"), function(index, item) {
							if (+item > 0) {
								depositPrint(item + "#" + "");
							}
						});
					});
				}
				break;
			case "-4":
				$.messager.popover({msg: "押金回冲时，当前押金收据号已经被使用", type: "info"});
				break;
			case "101":
				$.messager.popover({msg: "没有可用的发票，请先领取", type: "info"});
				break;
			case "102":
				$.messager.popover({msg: "可用押金票据不足，请先领取", type: "info"});
				break;
			case "103":
				$.messager.popover({msg: "该账单已被取消结算，不能再次取消", type: "info"});
				break;
			case "104":
				$.messager.popover({msg: "欠费/结存结算已全部补回/退回，但没有对应的补回/退回信息，请核查", type: "info"});
				break;
			case "Abort":
				$.messager.popover({msg: "该患者的发票已经作废，不能取消结算", type: "info"});
				break;
			case "QF":
				$.messager.popover({msg: "欠费患者，不能取消结算", type: "info"});
				break;
			case "CloseAcountErr":
				$.messager.popover({msg: "该账单已封帐，不能取消结算", type: "info"});
				break;
			default:
				$.messager.popover({msg: "取消结算失败：" + errCode, type: "error"});
			}
		});		
	}
}

/**
* 取消医保结算
*/
function insuCancelDivideClick() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var payedFlag = tkMakeServerCall("web.UDHCJFBaseCommon", "GetBillPaidFlag", getGlobalValue("BillID"));
	if (payedFlag == "N") {
		$.messager.popover({msg: "账单未结算或已经打印发票，不能取消医保结算", type: "info"});
		return;
	}
	var admReaAry = getAdmReason();
	var admReaId = admReaAry[0];
	var admReaNationalCode = admReaAry[1];
	if (+admReaNationalCode > 0) {
		if (!checkInsuCharge()) {
			insuCancelDivide();
		}else {
			$.messager.popover({msg: "医保未结算，不能取消医保结算", type: "info"});
		}
	}else {
		$.messager.popover({msg: "自费患者，不能取消医保结算", type: "info"});
	}
}

/**
 * 交押金
 */
function linkAddDeposit() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	initAddDepositTab();
}

/**
 * 退押金
 */
function linkRefDeposit() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	initRefDepositTab();
}

/**
 * 患者费用明细
 */
function linkBillDetail() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择患者账单", type: "info"});
		return;
	}
	initBillDetailTab();
}

/**
 * 医嘱费用查询
 */
function linkAdmOrderFee() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	initAdmOrderFeeTab();
}

/**
 * 收费项目查询
 */
function linkSearchTarFee() {
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	initTarFeeTab();
}

/**
 * 押金明细
 */
function linkSearchDepDet() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	initDepDetailTab();
}

/**
 * 跳号
 */
function altVoidInvClick() {
	var admReaAry = getAdmReason();
	var insType = admReaAry[0];
	var receiptType = "IP";
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&CurrentInsType=" + insType + "&receiptType=" + receiptType;
	websys_showModal({
		width: 520,
		height: 227,
		iconCls: 'icon-skip-no',
		title: '住院发票跳号',
		url: url,
		onClose: function() {
			checkInv();
		}
	});
}

function openCostInquriy(billID, episodeID) {
	var url = "dhcipbillpatcostinquriy.csp?BillNo=" + billID + "&EpisodeID=" + episodeID;
	websys_showModal({
		url: url,
		title: '患者科室费用查询',
		iconCls: 'icon-w-find',
		width: '90%',
		height: '85%'
	});
}

/**
 * 患者列表中选择患者切换
 */
function switchPatient(patientId, episodeId) {
	$("#InpatListDiv").data("AutoOpen", 0);
	refreshBar(patientId, episodeId);
	setEprMenuForm(episodeId, patientId);
	
	getPatInfo();
}

function setEprMenuForm(adm, papmi) {
	var frm = dhcsys_getmenuform();
	if ((frm) && (frm.EpisodeID.value != adm)) {
		frm.EpisodeID.value = adm;
		frm.PatientID.value = papmi;
	}
}

/**
* iframe 调用父窗口方法来跳转到病人列表
*/
function setDefTabFromIframe() {
	$("#chargeTabs").tabs("select", 0);
}

/**
* 锁定/解锁就诊记录
* admAry:就诊记录数组
* isLock：true:加锁, false:解锁
* 返回值：true:有锁定adm, false:无锁定adm
*/
function lockAdm(admAry, isLock) {
	var admAry = unique(admAry);
	var admStr = admAry.join("^");
	var lockType = "User.OEOrder";
	if (isLock) {
		var rtn = $.m({ClassName: "web.DHCBillLockAdm", MethodName: "LockAdm", admStr: admStr, lockType: lockType}, false);
		if (rtn != "") {
			rtn = rtn.replace(/\^/g, "\n");
			$.messager.popover({msg: rtn, type: "info"});
			disableById("btn-insuPreCharge");
			disableById("btn-disCharge");
			return true;
		}
	} else {
		$.m({ClassName: "web.DHCBillLockAdm", MethodName: "UnLockAdm", admStr: admStr, lockType: lockType}, false);
	}
	
	return false;
}