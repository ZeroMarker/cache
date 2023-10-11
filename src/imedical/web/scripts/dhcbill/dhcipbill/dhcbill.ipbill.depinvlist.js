/**
 * FileName: dhcbill.ipbill.depinvlist.js
 * Author: ZhYW
 * Date: 2019-11-28
 * Description: 押金发票明细查询
 */

$(function () {
	initQueryMenu();
	initDepInvList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadDepInvList();
		}
	});
	
	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//病案号查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});
	
	//收据号查询事件
	$("#receiptNo").keydown(function (e) {
		receiptNoKeydown(e);
	});
	
	//操作员
	$HUI.combobox("#guser", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=I&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	//票据状态
	$HUI.combobox("#rcptStatus", {
		panelHeight: 'auto',
		data: [{value: 'N', text: $g('正常')},
			   {value: 'I', text: $g('中途结算')},
			   {value: 'A', text: $g('作废')},
			   {value: 'BS', text: $g('已冲红')},
			   {value: 'S', text: $g('冲红')}
		],
		valueField: 'value',
		textField: 'text',
		defaultFilter: 5
	});
	
	//票据类型
	$HUI.combobox("#rcptType", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: $g('押金收据'), selected: true},
		       {value: 'N', text: $g('住院发票')},
		       {value: 'A', text: $g('集中打印')}
		],
		required: true,
		editable: false,
		valueField: 'value',
		textField: 'text',
		onChange: function (newValue, oldValue) {
			$("#depositType").combobox("clear");
			if (newValue == "Y") {
				enableById("depositType");
			}else {
				disableById("depositType");
			}
		}
	});
	
	//患者类型
	$HUI.combobox("#patType", {
		panelHeight: 'auto',
		data: [{value: 'Y', text: $g('医保患者')},
		       {value: 'N', text: $g('非医保患者')}
		],
		valueField: 'value',
		textField: 'text',
		onChange: function(newValue, oldValue) {
			$("#admReason").combobox("clear").combobox("reload");
		}
	});
	
	//费别
	$HUI.combobox("#admReason", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillInvDetailSearch&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.insuFlag = getValueById("patType");
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onLoadSuccess: function(data) {
			$(this).combobox("clear");
		}
	});
	
	
	//住院状态
	$HUI.combobox("#patStatus", {//+upd by gongxin 20230424 增加在院状态查询
		panelHeight: 'auto',
		data: [{value: 'C', text: $g('退院')},
			   {value: 'A', text: $g('在院')},
			   {value: 'D', text: $g('出院')},
			   {value: 'P', text: $g('预约')},
		],
		valueField: 'value',
		textField: 'text',
		defaultFilter: 5
	});//+upd by gongxin 20230424 增加在院状态查询
}

function initDepInvList() {
	GV.DepInvList = $HUI.datagrid("#depInvList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCIPBillInvDetailSearch",
		queryName: "FindInvDetail",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
				
				/* +upd by gongxin 20230505 后台取在院状态，多院区翻译 
				if (cm[i].field == "patStatus") {//+upd by gongxin 20230424 增加在院状态查询
					cm[i].formatter = function(value, row, index) {
					   	if (value) {
							return (value == 'C')?('退院'):(value == 'A')?('在院'):(value == 'D')?('出院'):('预约');  // 显示患者在院状态
						}
					};
				}//+upd by gongxin 20230424 增加在院状态查询*/
			}
		}
	});
}

function loadDepInvList() {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID + "!" + PUBLIC_CONSTANT.SESSION.LANGID;
	var queryParams = {
		ClassName: "web.DHCIPBillInvDetailSearch",
		QueryName: "FindInvDetail",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		guser: getValueById("guser") || "",
		rcptStatus: getValueById("rcptStatus") || "",
		rcptType: getValueById("rcptType") || "",
		PayMode: getValueById("paymode") || "",
		InvNo: getValueById("receiptNo"),
		medicareNo: getValueById("medicareNo"),
		PatType: getValueById("patType") || "",
		AdmReason: getValueById("admReason") || "",
		depositType: getValueById("depositType") || "",
		expStr: expStr,
		PatStatus:getValueById("patStatus") || "", //+upd by gongxin 20230424 增加在院状态查询
	};
	loadDataGridStore("depInvList", queryParams);
}

/**
* 病案号回车查询
*/
function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadDepInvList();
	}
}

/**
* 收据号回车查询
*/
function receiptNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		loadDepInvList();
	}
}

/**
* 清屏
*/
function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$(".combobox-f:not(#rcptType)").combobox("clear");
	setValueById("rcptType", "Y");
	$(".datebox-f").datebox("setValue", CV.DefDate);

	GV.DepInvList.options().pageNumber = 1;   //跳转到第一页
	GV.DepInvList.loadData({total: 0, rows: []});
}

/**
* 导出
*/
function exportClick() {
	var expStr = PUBLIC_CONSTANT.SESSION.HOSPID + "!" + PUBLIC_CONSTANT.SESSION.LANGID;
	
	var fileName = "DHCBILL-IPBILL-YJJFPMX.rpx" + "&stDate=" + getValueById("stDate") + "&endDate=" + getValueById("endDate");
	fileName += "&guser=" + (getValueById("guser") || "") + "&rcptStatus=" + (getValueById("rcptStatus") || "") + "&rcptType=" + (getValueById("rcptType") || "");
	fileName += "&PayMode=" + (getValueById("paymode") || "") + "&InvNo=" + getValueById("receiptNo") + "&medicareNo=" + getValueById("medicareNo");
	fileName += "&PatType=" + (getValueById("patType") || "") + "&AdmReason=" + (getValueById("admReason") || "") + "&depositType=" + (getValueById("depositType") || "");
	fileName += "&expStr=" + expStr;
	
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}