/**
 * FileName: dhcbill.ipbill.chgedrefdep.js
 * Author: ZhYW
 * Date: 2021-02-03
 * Description: 出院结算第三方退款
 */

$.extend($.fn.validatebox.defaults.rules, {
	validMin: {
		validator: function (value, param) {
			return (value > 0);
		},
		message: '退款金额必须大于0'
	},
	validMax: {                         //验证申请金额不能超过可退金额
		validator: function (value, param) {
			if (!(value > 0)) {
				return true;     //非正数时在reqQty的Keyup事件中处理，这里返回true
			}
			var curRow = $(this).parents(".datagrid-row").attr("datagrid-row-index") || "";
			if (!curRow) {
				return true;
			}
			var row = GV.RefundList.getRows()[curRow];
			//var notRefundAmt = $(".pay .amt:eq(1)").text() || 0;
			var rowPaymId=row.TPaymDR;
			var tmpstr = $.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetPayMRefundInfo", prtRowId: CV.PrtRowId, paymId: rowPaymId}, false);  
	    	var obj = JSON.parse(tmpstr);
			var notRefundAmt = obj.notRefundAmt;
			
			var minAmt = (+row.PayLeftAmt > +notRefundAmt) ? notRefundAmt : row.PayLeftAmt;
			return !(+value > +minAmt);
		},
		message: '退款金额不能大于可退金额'
	}
});

$(function () {
	initQueryMenu();
    initDepList();
});

function initQueryMenu() {
	//退费方式
	$("#refundMode").combobox({
        panelHeight: 150,
        editable: false,
        url: $URL + '?ClassName=BILL.IP.BL.ChgedRefundDep&QueryName=QryRefundMode&ResultSetType=array',
        valueField: 'CTPMRowID',
        textField: 'CTPMDesc',
        onBeforeLoad: function (param) {
            param.prtRowId = CV.PrtRowId;
        },
        onLoadSuccess: function (data) {
            $(this).combobox("select", ((data.length > 0) ? data[0].CTPMRowID : ""));
        },
        onSelect: function (rec) {
	        if(rec.CTPMRowID>0){
		     	//loadPayMMessage(rec.CTPMRowID);
		    }
		    loadPayMMessageAll();
			loadRefundList(rec.CTPMRowID);
		}
    });
    
    //是否包含可退金额为0的押金记录或补款记录
    $("#isAll").checkbox({
		onChecked:function(e,value){
	  		var refundMode = getValueById("refundMode");  
    		loadPayMMessageAll();
			loadRefundList(refundMode);
    	},
    	onUnchecked:function(e,value){
	    	var refundMode = getValueById("refundMode");  
    		loadPayMMessageAll();
			loadRefundList(refundMode);
	    }
    });
}

function initDepList() {
	GV.RefundList = $HUI.datagrid("#refundList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,   //TPaymDR:%String,paymDesc
		pageSize: 20,
		columns:[[{title: '收费员', field: 'UserName', width: 80},
				  {title: '收费时间', field: 'PrtDate', width: 155,
				  	formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.PrtTime;
						}
					}
				  },
				  {title: 'TPaymDR', field: 'TPaymDR', hidden: true},
				  {title: '业务类型', field: 'TType', width: 100,
				  	formatter: function (value, row, index) {
					    return (value == "IP") ? $g("结算补款") : $g("押金");
					}},
				  {title: '支付方式', field: 'TPaymDesc', width: 100},
				  {title: '金额', field: 'PayAmt', align: 'right', width: 100},
				  {title: '可退金额', field: 'PayLeftAmt', align: 'right', width: 100,
				  	styler: function (value, row, index) {
                    	return (row.IsTimeout != 1) ? 'color: #21ba45;font-weight: bold;' : '';
                	}
				  },
				  {title: '退费金额', field: 'RefundAmt', align: 'right', width: 100,
				  	editor: {
					  	type: 'numberbox',
					  	options: {
						  	precision: 2,
						  	validType: ['validMin', 'validMax']
						}
					},
					styler: function (value, row, index) {
                    	return 'color: red;font-weight: bold;';
                	}
				  },
				  {title: '操作', field: 'Operation', align: 'center', width: 70,
				    formatter: function (value, row, index) {
					    return (row.IsTimeout != 1) ? "<a href='javascript:;' class='datagrid-cell-img' title='退款' onclick='refundClick(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>" : "";
					}
				  },
				  {title: 'RCPTRowID', field: 'RCPTRowID', hidden: true},
				  {title: '交易流水号', field: 'ETPRRN', width: 280},
				  {title: '账号/卡号', field: 'ETPPan', width: 180},
				  {title: 'PayETPRowID', field: 'PayETPRowID', hidden: true},
				  {title: 'HIS订单号', field: 'ETPHISTradeNo', width: 180},
				  {title: '第三方订单号', field: 'ETPExtTradeNo', width: 280},
				  {title: 'TradeType', field: 'TradeType', hidden: true}
			]],
			rowStyler: function(index, row) {
				if (row.IsTimeout  == 1) {
					return 'color: #C0C0C0;';
				}
			},
			onLoadSuccess: function (data) {
				$(".datagrid-cell-img").tooltip({position: 'right'});
				//显示不可退费原因
				$.each(data.rows, function (index, row) {
					if (row.IsTimeout == 1) {
						GV.RefundList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "]>td>div:not(.datagrid-cell-rownumber)").mouseover(function() {
							$(this).popover({
								title: '不能退费原因',
								trigger: 'hover',
								content: "已经超过可退时限，不能退费"
							}).popover("show");
						});
					}
				});
			},
			onClickCell: function (index, field, value) {
				var row = GV.RefundList.getRows()[index];
				if (row.IsTimeout == 1) {
					return;
				}
				if (field == "RefundAmt") {
					onClickCellHandler(index, field, value);
				}
			},
			onEndEdit: function(index, row, changes) {
				onEndEditHandler(index, row);
			}
	});
}

function onClickCellHandler(index, field, value) {
	if (!endEditing()) {
		return;
	}
	GV.EditRowIndex = index;
	GV.RefundList.editCell({index: index, field: field});
	var ed = GV.RefundList.getEditor({index: index, field: field});
	if (ed) {
		$(ed.target).focus();
	}
}

function onEndEditHandler(index, row) {
	var ed = GV.RefundList.getEditor({index: index, field: "RefundAmt"});
	if (ed) {
		row.RefundAmt = $(ed.target).numberbox("getValue");
	}
}

function endEditing() {
	if (GV.EditRowIndex === undefined) {
		return true;
	}
	if (GV.RefundList.validateRow(GV.EditRowIndex)) {
		GV.RefundList.endEdit(GV.EditRowIndex);
		GV.EditRowIndex = undefined;
		return true;
	}
	return false;
}

function loadRefundList(paymId) {
	/*
	var queryParams = {
    	ClassName: "BILL.IP.BL.ChgedRefundDep",
     	QueryName: "QryPendingRefundList",
    	prtRowId: CV.PrtRowId,
    	paymId: paymId
	}
	loadDataGridStore("refundList", queryParams);
	*/
	var queryParams = {
        ClassName: "BILL.IP.BL.ChgedRefundDep",
        QueryName: "QryPendingRefundListNew",
        prtRowId: CV.PrtRowId,
        paymId: paymId,
        isAll: getValueById("isAll") ? 1 : 0
    }
    loadDataGridStore("refundList", queryParams);
}

//imed9.0
function refundClick(index) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!endEditing()) {
				return reject();
			}
			var row = GV.RefundList.getRows()[index];
			if (!row) {
				return reject();
			}
			if (!(row.RefundAmt > 0)) {
				$.messager.popover({msg: "请输入退费金额", type: "info"});
				return reject();
			}
			rcptRowId = row.RCPTRowID;
			refundAmt = row.RefundAmt;
			origBizType = row.TradeType;
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("确认退款") + "<font color=\"red\">" + refundAmt + "</font>" + $g("元") + "？"), function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _refundSrv = function() {
		return new Promise(function (resolve, reject) {
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = RefundPayService("IP", rcptRowId, CV.PrtRowId,"", refundAmt, origBizType, expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.alert("提示", ("退款失败：" + rtnValue.ResultMsg + "，错误代码：" + rtnValue.ResultCode), "error");
				return reject();
			}
			$.messager.alert("提示", rtnValue.ResultMsg, "success", function() {
				return resolve();
			});
		});
	};
	
	var _success = function() {
		reloadQueryMenu();
		var refundMode = getValueById("refundMode");  
		loadRefundList(refundMode);
		loadPayMMessageAll();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var rcptRowId = "";          //原业务ID
	var refundAmt = "";          //退款金额
	var origBizType = "";        //原业务类型
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_refundSrv)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}


function reloadQueryMenu() {
	$("#refundMode").combobox("reload");
	var refundInfo = getPrtRefundInfo();
	var myAry = refundInfo.split("^");
	var refundSum = myAry[0];      //退费总额
	var notRefundSum = myAry[1];   //未退总额
	$(".pay .sum:eq(0)").text(Math.abs(refundSum));
	//$(".pay .amt:eq(1)").text(notRefundSum);
	$(".pay .sum:eq(1)").text(notRefundSum);
	if (notRefundSum == 0) {
		$.messager.alert("提示", "退费完成", "success", function() {
		    websys_showModal("close");
		});
	}
}

/**
* 获取结算后第三方支付需退费信息
*/
function getPrtRefundInfo() {
	return $.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetPrtRefundInfo", prtRowId: CV.PrtRowId}, false);
}

function loadPayMMessage(paymId) {
	$.cm({
		ClassName: "BILL.IP.BL.ChgedRefundDep",
		MethodName: "GetPayMRefundInfo",
		prtRowId: CV.PrtRowId,
		paymId: paymId
	}, function(jsonObj) {
		if(paymId > 0){
			var mode = $("#refundMode").combobox("getText");
			$(".pay .mode:eq(0)").html("<font color='red'>" + mode + "</font>" + $(".pay .mode:eq(0)").text());
			$(".pay .mode:eq(1)").html("<font color='red'>" + mode + "</font>" + $(".pay .mode:eq(1)").text());
			$(".pay .amt:eq(0)").text(jsonObj.refundedAmt);
			$(".pay .amt:eq(1)").text(jsonObj.notRefundAmt);	
		}
	});
}

function loadPayMMessageAll() {
	var allMsg = "";
	$("#refundMode").combobox("getData").map(function (row) {
        var paymId = row.CTPMRowID;
        var paymDesc = row.CTPMDesc;
        if (paymId > 0) {
	    	var tmpstr = $.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetPayMRefundInfo", prtRowId: CV.PrtRowId, paymId: paymId}, false);  
	    	var obj = JSON.parse(tmpstr);
	    	var msg = "<font color='red'>" + paymDesc + "</font>" + "已退：" + obj.refundedAmt + " ，未退：" + obj.notRefundAmt;
	    	if(allMsg == ""){
		    	allMsg = msg;
		    }else {
			    allMsg = allMsg + "<span class='sline'> / </span>" + msg;
			}
	    }
    });
    $(".pay .mode:eq(0)").html(allMsg);
}