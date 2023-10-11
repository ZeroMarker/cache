/**
 * FileName: dhcbill.inv.buyinv.js
 * Author: ZhYW
 * Date: 2022-06-25
 * Description: 发票购入
 */

var buyInv = function (args) {
	args = args || {};
	this.argRcptType = args.RcptType || "";
};

(function () {
	var _argRcptType = "";    //发票类型
	var _invTitle = "";       //发票号前缀
	var _leftNum = 0;         //购入发票号余票数
	
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-find", {
			onClick: function () {
				_loadBuyInvList();
			}
		});
		
		$HUI.linkbutton("#btn-print", {
			onClick: function () {
				_printClick();
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
		$("#number")
	    .numberbox({
			min: 1,
			isKeyupChange: true,
			fix: false,
			onChange: function (newValue, oldValue) {
				_calcEndNo();
			}
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
				_getPendingBuyInv();
			}
	    });
	    
	    //购入人
		$("#buyer").combobox({
			panelHeight: 150,
			url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvBuyer&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
			valueField: 'id',
			textField: 'text',
			defaultFilter: 5,
			selectOnNavigation: false
		});
	};
	
	var _buyInvList = $HUI.datagrid("#buyInvList", {
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
				}],
		className: "web.UDHCJFInvprt",
		queryName: "InvprtBuyList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TBuyDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "TBuyTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TBuyDate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["TStartno", "TEndno", "TCurrentno"]) != -1) {
					cm[i].formatter = function (value, row, index) {
						return (row.TTitle != "") ? (row.TTitle + "[" + value + "]") : value;
					}
				}
				if ($.inArray(cm[i].field, ["TBuyId", "TTitle", "TUseFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TUseFlagDisplay") {
					cm[i].formatter = function (value, row, index) {
						var color = (row.TUseFlag == "N") ? "#f16e57" : "#21ba45";
						return "<font color=\"" + color+ "\">" + value + "</font>";
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TBuyTime") {
						cm[i].width = 150;
					}
				}
			}
		}
	});
	
	/**
	* 加载grid
	*/
	var _loadBuyInvList = function () {
		var queryParams = {
			ClassName: "web.UDHCJFInvprt",
			QueryName: "InvprtBuyList",
			type: getValueById("invType"),
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			buyerId: getValueById("buyer"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		};
		loadDataGridStore("buyInvList", queryParams);
	};
	
	/**
	* 获取待购入号段信息
	*/
	var _getPendingBuyInv = function () {
		var invType = getValueById("invType");
		if (invType == "") {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFInvprt",
			MethodName: "invprtgetmax",
			type: invType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},function(startNo) {
			setValueById("startNo", startNo);
			if (startNo == "") {
				focusById("startNo");
			} else {
				focusById("endNo");
			}
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
	* 购入
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
				resolve();
			});
		};
		
		var _cfr = function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", ($g("确认购入从") + "[<font color='red'>" + title + startNo + "</font>]" + $g("到") + "[<font color='red'>" + title + endNo + "</font>]" + $g("的发票") + "？"), function (r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _buy = function() {
			return new Promise(function (resolve, reject) {
				var invStr = "^^" + invType + "^" + buyerId + "^^" + startNo + "^" + endNo + "^^" + PUBLIC_CONSTANT.SESSION.USERID + "^^" + useFlag + "^" + title;
				$.m({
					ClassName: "web.UDHCJFInvprt",
					MethodName: "dhcamtmaginsert",
					str: invStr,
					hospId: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					var myAry = rtn.split("^");
					if (myAry[0] == 0) {
						$.messager.popover({msg: "购入成功", type: "success"});
						return resolve();
					}
					$.messager.popover({msg: "购入失败：" + (myAry[1] || myAry[0]), type: "error"});
					reject();
				});
			});
		};
		
		var _grantSuccess = function () {
			$("#number").numberbox("clear");
			setValueById("title", "");
			setValueById("endNo", "");
			_getPendingBuyInv();            //购入成功后重新获取新的发票号段
			_loadBuyInvList();
		};

		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var startNo = getValueById("startNo");
		var endNo = getValueById("endNo");
		var buyerId = getValueById("buyer");
		var invType = getValueById("invType");
		var title = $.trim(getValueById("title"));   //发票号前缀
		var useFlag = "";      //可用标识(""为待用)
		
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_buy)
			.then(function () {
				_grantSuccess();
				$this.linkbutton("enable");
			}, function () {
				$this.linkbutton("enable");
			});
	};
		
	/**
	* 打印购入单
	*/
	var _printClick = function () {
		var invType = getValueById("invType");
		var buyerId = getValueById("buyer");
		var stDate = getValueById("stDate");
		var endDate = getValueById("endDate");
		var fileName = "DHCBILL-INV-BuyList.rpx" + "&type=" + invType + "&stDate=" + stDate + "&endDate=" + endDate;
		fileName += "&buyerId=" + buyerId + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		var maxHeight = ($(window).height() || 550) * 0.8;
		var maxWidth = ($(window).width() || 1366) * 0.8;
		DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
	};
	
	/**
	* 删除
	*/
	var _deleteClick = function ($this) {
		var _validate = function() {
			return new Promise(function (resolve, reject) {
				var row = _buyInvList.getSelected();
				if (!row || !row.TBuyId) {
					$.messager.popover({msg: "请选择需要删除的记录", type: "info"});
					return reject();
				}
				buyId = row.TBuyId;
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
					MethodName: "DeleteBuy",
					rowId: buyId
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
			_loadBuyInvList();
		};
		
		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var buyId = "";
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
	* 清屏
	*/
	var _clearClick = function () {
		$(":text:not(.pagination-num,.combo-text)").val("");
		$(".combobox-f").combobox("clear");
		$("#number").numberbox("clear");
		$(".datebox-f").datebox("setValue", CV.DefDate);
		
		_buyInvList.options().pageNumber = 1;   //跳转到第一页
		_buyInvList.loadData({total: 0, rows: []});
	};
	
	buyInv.prototype.init = function () {
		_argRcptType = this.argRcptType;
		$(".datebox-f").datebox("setValue", CV.DefDate);
		
		_initBtnEvents();
		_initTextboxEvents();
	};
})();

$(function () {
    var buyInvObj = new buyInv(CV);
    buyInvObj.init();
});