﻿/**
 * FileName: dhcbill.inv.grantinv.js
 * Author: ZhYW
 * Date: 2022-06-24
 * Description: 发票发放
 */

var grantInv = function (args) {
	args = args || {};
	this.argRcptType = args.RcptType || "";
};

(function () {
	var _argRcptType = "";    //发票类型
	var _invBuyID = "";       //购入发票号段RowId
	var _invMaxNo = "";       //购入发票号段结束号
	var _invTitle = "";       //发票号前缀
	var _leftNum = 0;         //购入发票号余票数
	
	$.extend($.fn.numberbox.defaults.rules, {
        max: {
            validator: function(value) {
                return value <= _leftNum;
            },
            message: $g("输入的值必须小于或等于余票数")
        }
    });
    
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-find", {
			onClick: function () {
				_loadGrantInvList();
			}
		});
		
		$HUI.linkbutton("#btn-print", {
			onClick: function () {
				_printClick();
			}
		});
		
		$HUI.linkbutton("#btn-select", {
			onClick: function () {
				_selectClick();
			}
		});
		
		$HUI.linkbutton("#btn-clear", {
			onClick: function () {
				_clearClick();
			}
		});
	};
	
	/**
     * 初始化文本框事件
     */
	var _initTextboxEvents = function() {
		$("#number").numberbox({
			min: 1,
			validType: ['max'],
			isKeyupChange: true,
			fix: false,
			onChange: function (newValue, oldValue) {
				_calcEndNo();
			}
		});
		
		//发票状态
		$("#invStatus").combobox({
			panelHeight: 'auto',
			valueField: 'value',
			textField: 'text',
			editable: false,
			data: [{value: 'All', text: $g('全部'), selected: true},
				   {value: 'Y', text: $g('可用')},
				   {value: 'N', text: $g('已用完')},
				   {value: '', text: $g('待用')},
				   {value: 'Confirm', text: $g('已核销')}]
		});
		
		//发票类型
	    $("#invType").combobox({
	        panelHeight: 'auto',
			url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvType&ResultSetType=array',
			valueField: 'code',
			textField: 'text',
			editable: false,
			loadFilter: function(data) {
				if ($.inArray(_argRcptType, ["R", "I"]) != -1) {
					return data.filter(function(item) {
						return item.code == _argRcptType;
					});
				}
				if (_argRcptType == "O") {
					return data.filter(function(item) {
						return item.code != "I";
					});
				}
				return data;
			},
			onChange: function(newValue, oldValue) {
				var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=" + newValue + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
				$("#receiver").combobox("clear").combobox("reload", url);
				_getPendingGrantInv();
			}
	    });
	    
	    //领取人
		$("#receiver").combobox({
			panelHeight: 150,
			valueField: 'id',
			textField: 'text',
			defaultFilter: 5,
			selectOnNavigation: false
		});
	};
	
	var _grantInvList = $HUI.datagrid("#grantInvList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [{
					text: '新增',
					iconCls: 'icon-add',
					handler: function() {
						_addClick($(this));
					}
				}, {
					text: '删除',
					iconCls: 'icon-cancel',
					handler: function() {
						_deleteClick($(this));
					}
				}, {
					text: '核销',
					iconCls: 'icon-stamp',
					handler: function() {
						_confirmClick($(this));
					}
				}],
		className: "web.UDHCJFInvprt",
		queryName: "InvprtGrantList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tdate", "TConfirmInvDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tdate + " " + value;
					}
				}
				if (cm[i].field == "TConfirmInvTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TConfirmInvDate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["Tstartno", "Tendno", "Tcurrentno"]) != -1) {
					cm[i].formatter = function (value, row, index) {
						return (row.Ttitle != "") ? (row.Ttitle + "[" + value + "]") : value;
					}
				}
				if ($.inArray(cm[i].field, ["TgrantId", "Ttitle", "Tflag", "Tbtype", "TlquserId"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TflagDisplay") {
					cm[i].formatter = function (value, row, index) {
						var color = (row.Tflag == "N") ? "#f16e57" : "#21ba45";
						return "<font color=\"" + color+ "\">" + value + "</font>";
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["Ttime", "TConfirmInvTime"]) != -1) {
						cm[i].width = 150;
					}
				}
			}
		}
	});
	
	/**
	* 加载grid
	*/
	var _loadGrantInvList = function () {
		var queryParams = {
			ClassName: "web.UDHCJFInvprt",
			QueryName: "InvprtGrantList",
			invprtFlag: getValueById("invStatus"),
			type: getValueById("invType"),
			lquserid: getValueById("receiver"),
			stdate: getValueById("stDate"),
			enddate: getValueById("endDate"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		};
		loadDataGridStore("grantInvList", queryParams);
	};
	
	/**
	* 获取待发放号段信息
	*/
	var _getPendingGrantInv = function () {
		var invType = getValueById("invType");
		if (invType == "") {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFInvprt",
			MethodName: "dhcamtmaguse",
			type: invType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},function(rtn) {
			var myAry = rtn.split("^");
			var endNo = myAry[1] || "";
			_invMaxNo = endNo;
			var startNo = myAry[2] || "";
			_invBuyID = myAry[3] || "";
			_invTitle = myAry[4] || "";
			_leftNum = +myAry[5] || 0;
			setValueById("startNo", startNo);
			setValueById("endNo", endNo);
			if (!(_invBuyID > 0)) {
				focusById("startNo");
				$.messager.popover({msg: "没有可以发放的发票", type: "info"});
				return;
			}
			$.extend($("#number").numberbox("options"), {max: _leftNum});
			$("#number").numberbox("clear").focus();
		});
	};
	
	/**
	* 验证是否全是数字
	*/
	var _isNumber = function (no) {
		var patt = /^[\d]+$/;
		return patt.test(no);
	};
	
	/**
	* 根据输入的数量计算结束号
	*/
	var _calcEndNo = function () {
		var num = getValueById("number");
		if (!(num > 0)) {
			setValueById("endNo", "");
			return;
		}
		var startNo = getValueById("startNo");
		if (!_isNumber(startNo)) {    //验证是否全是数字
			return;
		}
		var endNo = String(Number(startNo).add(num) - 1);
		if (endNo.length < startNo.length) {
			endNo = formatString(endNo, startNo.length, "0");
		}
		setValueById("endNo", endNo);
	}
	
	/**
	* 发放
	*/
	var _addClick = function ($this) {
		var _validate = function() {
			return new Promise(function (resolve, reject) {
				var bool = true;
				$(".validatebox-text").each(function() {
					if (!$(this).validatebox("isValid")) {
						$.messager.popover({msg: ("<font color='red'>" + $(this).parent().prev().text() + "</font>" + $g("验证不通过")), type: "info"});
						bool = false;
						return false;
					}
				});
				if (!bool) {
					return reject();
				}
				$.each($(document).find("label[class='clsRequired']"), function (index, item) {
					var id = $(this).parent().next().find("input")[0].id;
					var val = getValueById(id);
					if (val == "") {
						$.messager.popover({msg: ($g("请选择") + "<font color='red'>" + $(this).text() + "</font>"), type: "info"});
						focusById(id);
						bool = false;
						return false;
					}
				});
				if (!bool) {
					return reject();
				}
				if (!(_invBuyID > 0)) {
					$.messager.popover({msg: "没有可以发放的发票", type: "info"});
					return reject();
				}
				if (startNo == "") {
					$.messager.popover({msg: "开始号码不能为空", type: "info"});
					focusById("startNo");
					return reject();
				}
				if (endNo == "") {
					$.messager.popover({msg: "结束号码不能为空", type: "info"});
					focusById("endNo");
					return reject();
				}
				if (!_isNumber(startNo)) {
					$.messager.popover({msg: "开始号码输入有误", type: "info"});
					focusById("startNo");
					return reject();
				}
				if (!_isNumber(endNo)) {
					$.messager.popover({msg: "结束号码输入有误", type: "info"});
					focusById("endNo");
					return reject();
				}
				if (parseInt(endNo, 10) < parseInt(startNo, 10)) {
					$.messager.popover({msg: "结束号码不能小于开始号码，请重新输入", type: "info"});
					focusById("endNo");
					return reject();
				}
				if (endNo.length != startNo.length) {
					$.messager.popover({msg: "结束号码的长度不等于开始号码的长度，请重新输入", type: "info"});
					focusById("endNo");
					return reject();
				}
				if (parseInt(endNo, 10) > parseInt(_invMaxNo, 10)) {
					$.messager.popover({msg: "此次发放的收据的最大号码是：" + _invMaxNo + "，请重新输入", type: "info"});
					focusById("endNo");
					return reject();
				}
				resolve();
			});
		};
		
		var _cfr = function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", ($g("确认发放从") + "[<font color='red'>" + _invTitle + startNo + "</font>]" + $g("到") + "[<font color='red'>" + _invTitle + endNo + "</font>]" + $g("的发票") + "？"), function (r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _grant = function() {
			return new Promise(function (resolve, reject) {
				var invStr = "^" + startNo + "^" + endNo + "^" + receiverId + "^" + _invMaxNo + "^" + invType + "^" + _invTitle;
				$.m({
					ClassName: "web.UDHCJFInvprt",
					MethodName: "dhcinvoiceinsert",
					str: invStr,
					AMRowID: _invBuyID,
					hospId: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					var myAry = rtn.split("^");
					if (myAry[0] == 0) {
						$.messager.popover({msg: "发放成功", type: "success"});
						return resolve();
					}
					$.messager.popover({msg: "发放失败：" + (myAry[1] || myAry[0]), type: "error"});
					reject();
				});
			});
		};
		
		var _grantSuccess = function () {
			$("#number").numberbox("clear");
			_getPendingGrantInv();            //发放成功后重新获取新的发票号段
			_loadGrantInvList();
		};

		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var startNo = getValueById("startNo");
		var endNo = getValueById("endNo");
		var receiverId = getValueById("receiver");
		var invType = getValueById("invType");
		
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_grant)
			.then(function () {
				_grantSuccess();
				$this.linkbutton("enable");
			}, function () {
				$this.linkbutton("enable");
			});
	};
		
	/**
	* 打印发放单
	*/
	var _printClick = function () {
		var invStatus = getValueById("invStatus");
		var invType = getValueById("invType");
		var receiverId = getValueById("receiver");
		var stDate = getValueById("stDate");
		var endDate = getValueById("endDate");
		var fileName = "DHCBILL-INV-GrantList.rpx" + "&invprtFlag=" + invStatus + "&type=" + invType + "&lquserid=" + receiverId;
		fileName += "&stdate=" + stDate + "&enddate=" + endDate + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		var maxHeight = ($(window).height() || 550) * 0.8;
		var maxWidth = ($(window).width() || 1366) * 0.8;
		DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
	};
	
	/**
	* 核销
	*/
	var _confirmClick = function ($this) {
		var _validate = function() {
			return new Promise(function (resolve, reject) {
				var row = _grantInvList.getSelected();
				if (!row || !row.TgrantId) {
					$.messager.popover({msg: "请选择需要核销的记录", type: "info"});
					return reject();
				}
				if (row.Tflag != "N") {
					$.messager.popover({msg: "发票未用完，不能核销", type: "info"});
					return reject();
				}
				if (row.TConfirmInvRowId > 0) {
					$.messager.popover({msg: "发票已核销，不能重复核销", type: "info"});
					return reject();
				}
				grantId = row.TgrantId;
				resolve();
			});
		};
		
		var _cfr = function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", "确认核销？", function (r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _confirm = function() {
			return new Promise(function (resolve, reject) {
				$.m({
				    ClassName: "web.DHCOPConfirmInvoiceManage",
			    	MethodName: "ConfirmInsert",
			    	invRowid: grantId,
			    	userRowid: PUBLIC_CONSTANT.SESSION.USERID
			    }, function(rtn) {
				    if (rtn == 0) {
					    $.messager.popover({msg: "核销成功", type: "success"});
						return resolve();
					}
					$.messager.popover({msg: "核销失败：" + rtn, type: "error"});
					reject();
				});
			});
		};
		
		var _confirmSuccess = function () {
			_loadGrantInvList();
		};
		
		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var grantId = "";
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_confirm)
			.then(function () {
				_confirmSuccess();
				$this.linkbutton("enable");
			}, function () {
				$this.linkbutton("enable");
			});
	};
	
	/**
	* 删除
	*/
	var _deleteClick = function ($this) {
		var _validate = function() {
			return new Promise(function (resolve, reject) {
				var row = _grantInvList.getSelected();
				if (!row || !row.TgrantId) {
					$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
					return reject();
				}
				grantId = row.TgrantId;
				resolve();
			});
		};
		
		var _cfr = function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", "确认删除？", function (r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _delete = function() {
			return new Promise(function (resolve, reject) {
				$.m({
					ClassName: "web.UDHCJFInvprt",
					MethodName: "DeleteGrant",
					grantId: grantId,
					hospId: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					var myAry = rtn.split("^");
					if (myAry[0] == 0) {
						$.messager.popover({msg: "删除成功", type: "success"});
						return resolve();
					}
					$.messager.popover({msg: "删除失败：" + (myAry[1] || myAry[0]), type: "error"});
					reject();
				});
			});
		};
		
		var _deleteSuccess = function () {
			_getPendingGrantInv();
			_loadGrantInvList();
		};
		
		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var grantId = "";
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_delete)
			.then(function () {
				_deleteSuccess();
				$this.linkbutton("enable");
			}, function () {
				$this.linkbutton("enable");
			});
	};
	
	/**
	* 选择号段
	*/
	var _selectClick = function () {
		var invType = getValueById("invType");
		if (invType == "") {
			$.messager.popover({msg: "请先选择发票类型", type: "info"});
			return;
		}
		var flag = "INV";
		var url = "dhcbill.inv.selectbuyinv.csp?flag=" + flag + "&type=" + invType;
		websys_showModal({
			iconCls: 'icon-w-list',
			title: '购入号段列表',
			height: 400,
			width: 760,
			url: url,
			callbackFunc: function(rtn) {
				var myAry = rtn.split("^");
				_invBuyID = myAry[0];
				var startNo = myAry[1];
				var endNo = myAry[2];
				_invMaxNo = endNo;
				_invTitle = myAry[3];
				_leftNum = +myAry[4];
				setValueById("startNo", startNo);
				setValueById("endNo", endNo);
				if (!(_invBuyID > 0)) {
					focusById("startNo");
					return;
				}
				$.extend($("#number").numberbox("options"), {max: _leftNum});
				$("#number").validatebox("validate");
				$("#number").numberbox("clear").focus();
			}
		});
	};
	
	/**
	* 清屏
	*/
	var _clearClick = function () {
		$(":text:not(.pagination-num,.combo-text)").val("");
		$("#invType").combobox("setValue", "");
		$("#invStatus").combobox("setValue", "All");
		$("#number").numberbox("clear").numberbox("validate");
		$(".datebox-f").datebox("setValue", CV.DefDate);
		
		_grantInvList.options().pageNumber = 1;   //跳转到第一页
		_grantInvList.loadData({total: 0, rows: []});
	};
	
	grantInv.prototype.init = function () {
		_argRcptType = this.argRcptType;
		$(".datebox-f").datebox("setValue", CV.DefDate);
		
		_initBtnEvents();
		_initTextboxEvents();
	};
})();

$(function () {
    var grantInvObj = new grantInv(CV);
    grantInvObj.init();
});