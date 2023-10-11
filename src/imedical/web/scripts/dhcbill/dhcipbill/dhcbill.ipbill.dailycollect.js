/**
 * FileName: dhcbill.ipbill.dailycollect.js
 * Author: ZhYW
 * Date: 2018-03-12
 * Description: 住院收费日结汇总
 */

var GV = {};

$(function () {
	initQueryMenu();
});

function initQueryMenu() {
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadSelDetails();
		}
	});
	$HUI.linkbutton("#btnReceive", {
		onClick: function () {
			receiveClick();
		}
	});
	
	$HUI.checkbox("#checkReceive", {
		onCheckChange: function (e, value) {
			receCheckChange(value);
		}
	});
	
	$HUI.combobox("#userCombo", {
		panelHeight: 180,
		rowStyle: 'checkbox',
		multiple: true,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	$HUI.linkbutton("#btnReset", {
		onClick: function () {
			resetClick();
		}
	});
	
	getStDate();
	
	// 核销改造 XiaoShuai 2022-07-05
	$HUI.linkbutton("#btnVerify", {
		onClick: function () {
			btnVerifyClick(1);
		}
	});
	
	//取消核销
	$HUI.linkbutton("#btnCancelVerify", {
		onClick: function () {
			btnVerifyClick(-1);
		}
	});
	
	$HUI.combobox("#verifyCombo", {
		valueField: 'value',
		textField: 'text',
		data:[
			{value: 3, text: $g('全部'), selected: true},
			{value: 1, text: $g('已核销')},
			{value: '', text: $g('未核销')},
			{value: -1, text: $g('取消核销')}
		] 
	});
	if (!isNeedPreReceive()){
		$("#btnVerify").hide();
		$("#btnCancelVerify").hide();
		$("#verifyCombo+.combo").hide();
		$("#verifyCombolab").hide();
	}
}

function receCheckChange(checked) {
	if (checked) {
		disableById("btnReceive");
		$(".layout:first").layout("add", {
			region: 'east',
			width: 340,
			title: '接收记录',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			collapsible: false
		}).layout("panel", "east").append("<ul id='rece-tree'></ul>");
		initReceTree();
	}else {
		enableById("btnReceive");
		$(".layout:first").layout("remove", "east");
		setValueById("receId", "");    //取消勾选时，将结账Id赋空
		getStDate();
	}
}

/**
* 取开始日期
*/
function getStDate() {
	var defDate = getDefStDate(-1);
	$(".datebox-f").datebox("setValue", defDate);
}

/**
* 接收记录树
*/
function initReceTree() {
	GV.ReceTree = $HUI.tree("#rece-tree", {
		fit: true,
		url: $URL + '?ClassName=web.DHCIPBillDailyCollect&MethodName=BuildReceiveTree&ResultSetType=array',
		animate: true,
		autoNodeHeight: true,
		onBeforeLoad: function(node, param) {
			param.guser = PUBLIC_CONSTANT.SESSION.USERID;
		},
		formatter: function(node) {
			if (node.children) {
				return node.text;
			}
			return "<div>"
					+ "<span data-id='" + node.id + "' class='icon icon-cancel' style='display:block;width:16px;height:16px;position:absolute;right:10px;top:5px;'></span>"
					+ "<div style='height:20px;line-height:20px;color:#666666'>" + node.attributes.stDate + "—" + node.attributes.endDate + "</div>"
					+ "<div style='height:20px;line-height:20px;'>" + node.text + "</div>"
					+ "</div>";
		},
		onClick: function (node) {
			$(this).tree("toggle", node.target);
		},
		onSelect: function (node) {
			if ($(this).tree("isLeaf", node.target)) {
				scanReceList(node);
			}
		},
		onLoadSuccess: function (node, data) {
			$(".tree-title span[data-id]").popover({
				content: $g('取消接收'),
				trigger: 'hover'
			});
		}
	});
	
	$("#rece-tree").on("click", ".tree-title span[data-id]", function(){
		var id = $(this).data("id");
		cancelReceive(id);
	});
}

function scanReceList(node) {
	setValueById("receId", node.id);
	$("#stDate").datebox("setValue", node.attributes.stDate);
	$("#endDate").datebox("setValue", node.attributes.endDate);
	loadSelDetails();
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-14
 * Description: 组长接收
 */
function receiveClick() {
	var _valid = function () {
		return new Promise(function (resolve, reject) {
			var iframe = $("#tabMain")[0].contentWindow.$("#iframe_ipbillCollectList")[0].contentWindow;
			if (!iframe) {
				return reject();
			}
			footIdStr = iframe.getCheckedFootIdStr();
			if (!footIdStr) {
				$.messager.popover({msg: "请选择需要接收的日结记录", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认接收？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _receive = function () {
		return new Promise(function (resolve, reject) {
			$.cm({
				ClassName: "web.DHCIPBillDailyCollect",
				MethodName: "Receive",
				footIdStr: footIdStr,
				sessionStr: getSessionStr()
			}, function (json) {
				$.messager.popover({msg: json.msg, type: "info"});
				if (json.success == 0) {
					receId = json.rowId;
					return resolve();
				}
				return reject();
			});
		});
	};
	
	var _prereceive = function(){
		
		return new Promise(function (resolve, reject) {
			if(!isNeedPreReceive()){
				return resolve();
			}
			$.cm({
				ClassName: "web.DHCIPBillDailyCollect",
				MethodName: "CheckPreRec",
				guser: PUBLIC_CONSTANT.SESSION.USERID,
				footIdStr: footIdStr
			}, function(rtn){
				if (rtn != "0"){
					$.messager.alert('提示',"请先进行核销数据",'error');
					return reject();
				}else{
					return resolve();
				}
			});
		})
	}
	/**
	* 成功后页面处理
	*/
	var _success = function () {
		setValueById("receId", receId);
		loadSelDetails();
	};
	
	if ($("#btnReceive").linkbutton("options").disabled) {
		return;
	}
	$("#btnReceive").linkbutton("disable");
	
	var footIdStr = "";
	var receId = "";   //接收Id
	
	var promise = Promise.resolve();
	promise
		.then(_valid)
		.then(_prereceive)
		.then(_cfr)
		.then(_receive)
		.then(function() {
			_success();
		}, function () {
			$("#btnReceive").linkbutton("enable");
		});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-14
 * Description: 取消接收
 */
function cancelReceive(receId) {
	var _valid = function () {
		return new Promise(function (resolve, reject) {
			if (!receId) {
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认取消？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function () {
		return new Promise(function (resolve, reject) {
			$.cm({
				ClassName: "web.DHCIPBillDailyCollect",
				MethodName: "CancelReceive",
				receId: receId,
				sessionStr: getSessionStr()
			}, function (json) {
				$.messager.popover({msg: json.msg, type: "info"});
				if (json.success == 0) {
					return resolve();
				}
				return reject();
			});
		});
	};
	
	var _success = function () {
		setValueById("receId", "");
		if ($("#rece-tree").length > 0) {
			$("#rece-tree").tree("reload");
		}
		loadSelDetails();
	};
	
	var $selector = $("span.icon-cancel[data-id=" + receId + "]");
	if ($selector.prop("disabled")) {
		return;
	}
	$selector.prop("disabled", true);
	
	var promise = Promise.resolve();
	promise
		.then(_valid)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$selector.prop("disabled", false);
		}, function () {
			$selector.prop("disabled", false);
		});
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-03-15
 * Description: 加载iframe页签明细内容
 */
function loadSelDetails() {
	var iframe = $("#tabMain")[0].contentWindow;
	if (iframe) {
		iframe.loadSelTabsContent();
	}
}

/**
 * 重置
 */
function resetClick() {
	setValueById("checkReceive", false);
	receCheckChange(false);
	loadSelDetails();
}

/**
 * Creator: XiaoShuai
 * CreatDate: 2022-07-05
 * Description: 日结记录核销
 */
function btnVerifyClick(Status) {
	var iframe = $("#tabMain")[0].contentWindow.$("#iframe_ipbillCollectList")[0].contentWindow;
	if (!iframe) {
		return;
	}
	var footIdStr = iframe.getCheckedFootIdStr();
	if (footIdStr == "") {
		$.messager.popover({msg:"请选择需要核销/取消核销的记录",type: "info"});
		return;
	}
	var message = "";
	if(Status == 1) {
		var message = "核销";
	}else if(Status == -1) {
		var message = "取消核销";
	}else {
		return;
	}
	var verifyStatusStr = iframe.getCheckedverifyStatus();//获取选中数据的核销状态
	var footIdArr = footIdStr.split("^");
	var verifyStatusArr = verifyStatusStr.split("^");
	var newFootIdStr = "";
	for(var i = 0; i < footIdArr.length; i++){	//过滤选中的不需要操作的数据
		if(Status == 1){						//核销
			if(verifyStatusArr[i] != Status){
				if(newFootIdStr == ""){
					var newFootIdStr = footIdArr[i];
				}else{
					var newFootIdStr = newFootIdStr+"^"+footIdArr[i];
				}
			}
		}else {								//取消核销
			if ((verifyStatusArr[i] != Status) && (verifyStatusArr[i] != 2)){
				if(newFootIdStr == ""){
					var newFootIdStr = footIdArr[i];
				}else{
					var newFootIdStr = newFootIdStr + "^" + footIdArr[i];
				}
			}
		}
	}
	if ((newFootIdStr == "") && (Status == 1)) {
		$.messager.popover({msg:"所选数据已是核销状态",type: "info"});
		return;
	}
	if ((newFootIdStr == "") && (Status == -1)) {
		$.messager.popover({msg:"所选数据已是取消核销/未核销状态",type: "info"});
		return;
	}
	$.messager.confirm("确认", ("是否" + message + "？"), function (r) {
		if (!r) {
			return;
		}
		$.cm({
			ClassName: "web.DHCIPBillDailyCollect",
			MethodName: "Verify",
			guser: PUBLIC_CONSTANT.SESSION.USERID,
			footIdStr: newFootIdStr,
			Status: Status							// 核销状态(1:核销 -1:取消核销)
		}, function (jsonData) {
			$.messager.popover({msg: (message+jsonData.msg), type: "info"});
			if (jsonData.success == 0) {
				loadSelDetails();
			}
		});
	});
}

/**
* tangzf 2022-10-27
* 通用配置--是否需要预接收   通用配置-住院收费系统-住院日报汇总->是否预接收日报
*/
function isNeedPreReceive() {
	var bool = false;
	var data = $.cm({
		ClassName: "BILL.CFG.COM.GeneralCfg",
		MethodName: "GetResultByRelaCode",
		RelaCode: "IPCHRG.CshrDRptSum.SFHXRB",
		SourceData: "",
		TgtData: "",
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		Date: ""
	}, false);
	if(data.data.split("^")[1] == "Yes"){
		bool = true;
	}
	return bool;
}
