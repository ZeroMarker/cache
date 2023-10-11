/**
 * FileName: dhcbill.inv.deliverrcpt.js
 * Author: ZhYW
 * Date: 2022-07-03
 * Description: 预交金收据转交
 */

var deliverRcpt = function () {
};

(function () {
	var _receiptId = "";       //转交票据号段RowId
	var _rcptMinNo = "";       //待转交的号段开始号
	var _rcptMaxNo = "";       //转交票据号段结束号
	var _rcptTitle = "";       //票据号前缀
	var _leftNum = 0;         //购入票据号余票数
	
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-find", {
			onClick: function () {
				_loadDeliverRcptList();
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

		//票据类型
	    $("#rcptType").combobox({
	       panelHeight: 'auto',
			valueField: 'value',
			textField: 'text',
			editable: false,
			data:[{value: 'I', text: $g('住院押金'), selected: true}],
			onChange: function(newValue, oldValue) {
				var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=" + newValue + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
				$("#deliver, #receiver").combobox("clear").combobox("reload", url);
			}
	    });
	    
	    //转交人
		$("#deliver").combobox({
			panelHeight: 150,
			valueField: 'id',
			textField: 'text',
			defaultFilter: 5,
			selectOnNavigation: false,
			onChange: function(newValue, oldValue) {
				_getPendingDeliverRcpt();
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
	
	var _deliverRcptList = $HUI.datagrid("#deliverRcptList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [{
					text: '转交',
					iconCls: 'icon-big-switch',
					handler: function() {
						_deliverClick($(this));
					}
				}],
		className: "web.UDHCJFReceipt",
		queryName: "FindDeliver",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (cm[i].field == "Tdate") {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tdate + " " + value;
					}
				}
				if ($.inArray(cm[i].field, ["Tstartno", "Tendno", "Tcurrentno"]) != -1) {
					cm[i].formatter = function (value, row, index) {
						return (row.Ttitle != "") ? (row.Ttitle + "[" + value + "]") : value;
					}
				}
				if ($.inArray(cm[i].field, ["Trowid", "Ttitle", "TuseFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TuseFlagDisplay") {
					cm[i].formatter = function (value, row, index) {
						var color = (row.TuseFlag == 2) ? "#f16e57" : "#21ba45";
						return "<font color=\"" + color+ "\">" + value + "</font>";
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Ttime") {
						cm[i].width = 150;
					}
				}
			}
		}
	});
	
	/**
	* 加载grid
	*/
	var _loadDeliverRcptList = function () {
		var queryParams = {
			ClassName: "web.UDHCJFReceipt",
			QueryName: "FindDeliver",
			type: getValueById("rcptType"),
			zjuserid: getValueById("receiver"),
			Bezjuserid: getValueById("deliver"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		};
		loadDataGridStore("deliverRcptList", queryParams);
	};
	
	/**
	* 获取待转交号段信息
	*/
	var _getPendingDeliverRcpt = function () {
		var rcptType = getValueById("rcptType");
		if (rcptType == "") {
			return;
		}
		var deliverId = getValueById("deliver");
		if (deliverId == "") {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFReceipt",
			MethodName: "Getkydeliver",
			userId: deliverId,
			type: rcptType,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},function(rtn) {
			var myAry = rtn.split("^");
			var startNo = myAry[0] || "";
			_rcptMinNo = startNo;
			var endNo = myAry[1] || "";
			_rcptMaxNo = endNo;
			_receiptId = myAry[2] || "";
			_rcptTitle = myAry[3] || "";
			_leftNum = +myAry[4] || 0;
			setValueById("startNo", startNo);
			setValueById("endNo", endNo);
			if (!(_receiptId > 0)) {
				focusById("startNo");
				$.messager.popover({msg: "没有可以转交的票据", type: "info"});
				return;
			}
			$.extend($("#number").numberbox("options"), {max: _leftNum});
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
	* 转交
	*/
	var _deliverClick = function ($this) {
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
				if (!(_receiptId > 0)) {
					$.messager.popover({msg: "没有可以转交的票据", type: "info"});
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
				if (parseInt(endNo, 10) > parseInt(_rcptMaxNo, 10)) {
					$.messager.popover({msg: "此次转交的收据的最大号码是：" + _rcptMaxNo + "，请重新输入", type: "info"});
					focusById("endNo");
					return reject();
				}
				if (deliverId == receiverId) {
					$.messager.popover({msg: "转交人和接收人不能相同", type: "info"});
			        focusById("receiver");
			        return reject();
			    }
				resolve();
			});
		};
		
		var _cfr = function() {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", ($g("确认转交从") + "[<font color='red'>" + _rcptTitle + startNo + "</font>]" + $g("到") + "[<font color='red'>" + _rcptTitle + endNo + "</font>]" + $g("的票据") + "？"), function (r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _deliver = function() {
			return new Promise(function (resolve, reject) {
				var deliverStr = startNo + "^" + endNo + "^" + _rcptMinNo + "^" + deliverId + "^" + "" + "^" + receiverId
					+ "^" + _rcptTitle + "^" + _rcptMaxNo + "^" + _receiptId + "^" + rcptType + "^" + PUBLIC_CONSTANT.SESSION.USERID;
				
				$.m({
					ClassName: "web.UDHCJFReceipt",
					MethodName: "deliverrcpt",
					str: deliverStr,
					hospId: PUBLIC_CONSTANT.SESSION.HOSPID
				}, function(rtn) {
					var myAry = rtn.split("^");
					if (myAry[0] == 0) {
						$.messager.popover({msg: "转交成功", type: "success"});
						return resolve();
					}
					$.messager.popover({msg: "转交失败：" + (myAry[1] || myAry[0]), type: "error"});
					reject();
				});
			});
		};
		
		var _deliverSuccess = function () {
			$("#number").numberbox("clear");
			_getPendingDeliverRcpt();            //转交成功后重新获取新的票据号段
			_loadDeliverRcptList();
		};

		if ($this.linkbutton("options").disabled) {
			return;
		}
		$this.linkbutton("disable");
		
		var startNo = getValueById("startNo");
		var endNo = getValueById("endNo");
		var deliverId = getValueById("deliver");
		var receiverId = getValueById("receiver");
		var rcptType = getValueById("rcptType");
		
		var promise = Promise.resolve();
		promise
			.then(_validate)
			.then(_cfr)
			.then(_deliver)
			.then(function () {
				_deliverSuccess();
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
		$("#deliver, #receiver").combobox("clear");
		$("#number").numberbox("clear");
		_getPendingDeliverRcpt();
		
		_deliverInvList.options().pageNumber = 1;   //跳转到第一页
		_deliverInvList.loadData({total: 0, rows: []});
	};
	
	deliverRcpt.prototype.init = function () {
		_initBtnEvents();
		_initTextboxEvents();
	};
})();

$(function () {
    var deliverRcptObj = new deliverRcpt();
    deliverRcptObj.init();
});