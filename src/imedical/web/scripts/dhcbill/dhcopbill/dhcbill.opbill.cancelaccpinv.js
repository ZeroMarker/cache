/**
 * FileName: dhcbill.opbill.cancelaccpinv.js
 * Author: ZhYW
 * Date: 2022-05-14
 * Description: 门诊撤销集中打印发票
 */
 
var accPInv = function () {
};

(function () {
	var _patientId = "";
	var _accPayInvId = "";
	var _insuDivId = "";
	var _insTypeId = "";
	var _admSource = "";
		
	/**
     * 初始化按钮事件
     */
	var _initBtnEvents = function () {
		$HUI.linkbutton("#btn-cancel", {
			disabled: true,
			onClick: function () {
				_cancelClick();
			}
		});
		
		$HUI.linkbutton("#btn-clear", {
			onClick: function () {
				_clearClick();
			}
		});
		
		$("#receiptNo").focus().keydown(function (e) {
			_receiptNoKeydown(e);
		});
	};
	
	/**
     * 初始化文本框事件
     */
	var _initPayMList = function() {
		$HUI.combobox("#paymode", {
			panelHeight: 150,
			url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array",
			valueField: 'id',
			textField: 'text',
			defaultFilter: 5
		});
	};
	
	/**
     * 初始化支付datagrid
     */
	var _initPrtInvList = function () {
		$HUI.datagrid("#prtInvList", {
			fit: true,
			title: '支付列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			singleSelect: true,
			pagination: true,
			rownumbers: true,
			pageSize: 20,
			toolbar: [],
			className: "web.udhcOPRefund",
			queryName: "QryPrtInvListByAccPInv",
			onColumnsLoad: function(cm) {
				for (var i = (cm.length - 1); i >= 0; i--) {
					if ($.inArray(cm[i].field, ["TPrtDate"]) != -1) {
						cm.splice(i, 1);
						continue;
					}
					if (cm[i].field == "TPrtTime") {
						cm[i].formatter = function(value, row, index) {
					   		return row.TPrtDate + " " + value;
						}
					}
					if (!cm[i].width) {
						cm[i].width = 120;
					}
				}
			},
			onLoadSuccess: function(data) {
				if (data.total == 0) {
					disableById("btn-cancel");
				}
			}
		});
	};
	
	var _receiptNoKeydown = function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			var receiptNo = $(e.target).val();
			$.m({
				ClassName: "web.UDHCAccPayINVEdit",
				MethodName: "ReadAccPayINVByNo",
				INVNo: receiptNo,
				UserDR: PUBLIC_CONSTANT.SESSION.USERID,
				HospId: PUBLIC_CONSTANT.SESSION.HOSPID
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] != 0) {
					disableById("btn-cancel");
					$.messager.popover({msg: "发票号不存在或非集中打印发票", type: "info"});
					$(e.target).focus();
					return;
				}
				_wrtRefundMain(rtn);
			});
		}
	};
	
	var _wrtRefundMain = function (accPInvInfo) {
		var myAry = accPInvInfo.split("^");
		setValueById("receiptNo", myAry[1]);
		setValueById("invAmt", myAry[5]);
		setValueById("accountNo", myAry[7]);
		setValueById("paymode", myAry[11]);
		setValueById("insuPayAmt", myAry[12]);
		setValueById("accountStatus", myAry[13]);
		setValueById("selfPayAmt", myAry[16]);
		setValueById("insuDivId", myAry[17]);
		
		_patientId = myAry[18];
		_accPayInvId = myAry[14];
		_insuDivId = myAry[17];
		_insTypeId = myAry[19];
		_admSource = myAry[20];
		
		disableById("btn-cancel");
		if (myAry[15] != "N") {
			$.messager.popover({msg: $g("此发票已经被") + ((myAry[15] == "A") ? $g("作废") : $g("红冲")), type: 'info'});
			return;
		}
		if (myAry[10] == "F") {
			$.messager.popover({msg: "账户已经结算，请激活账户后再办理退费", type: "info"});
			return;
		}
		if ($.inArray(myAry[6], ["S", "P"]) == -1) {
			$.messager.popover({msg: "请先做退费审核或到药房退药", type: "info"});
			return;
		}
		enableById("btn-cancel");
		
		refreshBar(_patientId, "");
		
		_loadPrtInvList();
	};
	
	/**
	* 加载支付datagrid
	*/
	var _loadPrtInvList = function () {
		var queryParams = {
			ClassName: "web.udhcOPRefund",
			QueryName: "QryPrtInvListByAccPInv",
			APIRowID: _accPayInvId,
			LangId: PUBLIC_CONSTANT.SESSION.LANGID
		};
		loadDataGridStore("prtInvList", queryParams);
	};
	
	/**
	* 撤销
	*/
	var _cancelClick = function () {
		var _cfr = function () {
			return new Promise(function (resolve, reject) {
				$.messager.confirm("确认", "是否确认撤销？", function(r) {
					return r ? resolve() : reject();
				});
			});
		};
		
		var _validate = function() {
			return new Promise(function (resolve, reject) {
				if (!(_insuDivId > 0)) {
					return resolve();
				}
				var insuPayAmt = getValueById("insuPayAmt");
				$.messager.alert("提示", $g("请注意收取") + "：<font color=\"red\">" + insuPayAmt + "</font> " + $g("元"), "info", function() {
					return resolve();
				});
				return;
			});
		};
		
		/**
		* 医保退费
		*/
		var _insuPark = function() {
			return new Promise(function (resolve, reject) {
				if (!(_insuDivId > 0)) {
					return resolve();
				}
				if (CV.AccPINVYBConFlag == 0) {
					$.messager.popover({msg: "退此发票需要连接医保", type: "info"});
					return reject();
				}
				var myYBHand = 0;
				var expStr = "^^^^";
				var CPPFlag = "N";
				var rtn = InsuOPDivideStrike(myYBHand, PUBLIC_CONSTANT.SESSION.USERID, _insuDivId, _admSource, _insTypeId, expStr, CPPFlag);
				if (rtn != 0) {
					$.messager.popover({msg: "医保退费失败：" + rtn, type: "error"});
					return reject();
				}
				return resolve();
			});
		};
		
		/**
		* 撤销
		*/
		var _cancel = function() {
			$.m({
				ClassName: "web.udhcOPRefEditIF",
				MethodName: "WriteOffAPI",
				AccPInvId: _accPayInvId,
				UserId: PUBLIC_CONSTANT.SESSION.USERID
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "撤销成功", type: "success"});
					return;
				}
				$.messager.popover({msg: "撤销失败：" + (myAry[1] || myAry[0]), type: "error"});
			});
		};
		
		if ($("#btn-cancel").linkbutton("options").disabled) {
			return;
		}
		$("#btn-cancel").linkbutton("disable");
		
		var promise = Promise.resolve();
		promise
			.then(_cfr)
			.then(_validate)
			.then(_insuPark)
			.then(_cancel, function () {
				$("#btn-cancel").linkbutton("enable");
			});
	};
	
	/**
	* 清屏
	*/
	var _clearClick = function() {
		clearBanner();
		$(":text:not(.pagination-num)").val("");
		$(".combobox-f").combobox("clear");
		$(".numbobox-f").combobox("clear");
		$(".datagrid-f").datagrid("options").pageNumber = 1;   //跳转到第一页
		$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
		showBannerTip();
		focusById("receiptNo");
	};
	
	accPInv.prototype.init = function () {
		showBannerTip();
		_initBtnEvents();
		_initPayMList();
		_initPrtInvList();
	};
})();

$(function () {
    var accPInvObj = new accPInv();
    accPInvObj.init();
});