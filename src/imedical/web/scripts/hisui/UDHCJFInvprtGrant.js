/// UDHCJFInvprtGrant.js

var m_AmtMRowID = "";

$(function() {
	init_Layout();
	
	$HUI.linkbutton('#Add', {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.linkbutton('#Delete', {
		onClick: function () {
			deleteClick();
		}
	});
	
	$HUI.linkbutton('#BtnConfirm', {
		onClick: function () {
			confirmInvprtClick();
		}
	});
	
	$HUI.linkbutton('#PrintInvoice', {
		onClick: function () {
			PrintInvoice();
		}
	});
	
	$HUI.linkbutton('#SelReceiptsNum', {
		onClick: function () {
			selReceiptsNum_Click();
		}
	});

	$HUI.numberbox('#number', {
		min: 1,
		isKeyupChange: true,
		onChange: function (newValue, oldValue) {
			celendno();
		}
	});
	
	$("#startno").attr("readOnly", true);
	
	$('#invprtFlag').combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'All', text: '全部', selected: true},
			  {id: 'Y', text: '可用'},
			  {id: 'N', text: '已用完'},
			  {id: '', text: '待用'},
			  {id: 'Confirm', text:'已核销'}]
	});
	
	//类型
    $("#type").combobox({
        panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			$("#lquser").combobox("clear").combobox("reload");
			getinvgrantmax();
		}
    });
    
    //领取人
	$("#lquser").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.type = getValueById("type");
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("lquserid", (newValue || ""));
		}
	});
});

function getinvgrantmax() {
	var type = getValueById("type");
	if (type == "") {
		return;
	}
	$.m({
		ClassName: "web.UDHCJFInvprt",
		MethodName: "dhcamtmaguse",
		type: type,
		hospId: session['LOGON.HOSPID']
	},function(rtn) {
		var myAry = rtn.split("^");
		if (!myAry[3]) {
			setValueById("maxno", "");
			setValueById("startno", "");
			$.messager.popover({msg: '没有可以发放的发票', type: 'info'});
			return;
		}
		m_AmtMRowID = myAry[3];
		setValueById('startno', myAry[2]);
		setValueById('Title', myAry[4]);
		setValueById("maxno", myAry[1]);
		setValueById("endno", myAry[1]);
		if (myAry[2] == "") {
			focusById('startno');
		} else {
			focusById('number');
		}
	});
}

function addClick() {
	var startno = getValueById("startno");
	var endno = getValueById("endno");
	var buyend = getValueById("maxno");
	var title = getValueById("Title");
	var lquser = getValueById("lquser");
	var lquserid = getValueById("lquserid");
	var type = getValueById("type");
	if (buyend == "") {
		$.messager.popover({msg: '没有可以发放的发票', type: 'info'});
		return;
	}
	if (type == "") {
		$.messager.popover({msg: '发票类型不能为空', type: 'info'});
		focusById('type');
		return;
	}
	if ((startno == "") || (endno == "")) {
		$.messager.popover({msg: '起始号码或结束号码不能为空', type: 'info'});
		focusById('endno');
		return;
	}
	if (!checkno(startno)) {
		$.messager.popover({msg: '起始号码输入有误', type: 'info'});
		focusById('startno');
		return;
	}
	if (!checkno(endno)) {
		$.messager.popover({msg: '结束号码输入有误', type: 'info'});
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		$.messager.popover({msg: '结束号码不能小于开始号码，请重新输入', type: 'info'});
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		$.messager.popover({msg: '结束号码的长度不等于开始号码的长度，请重新输入', type: 'info'});
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) > parseInt(buyend, 10)) {
		$.messager.popover({msg: '此次发放的收据的最大号码是：' + buyend + '，请重新输入', type: 'info'});
		focusById('endno');
		return;
	}
	if (lquserid == "") {
		$.messager.popover({msg: '领取人不能为空', type: 'info'});
		focusById('lquser');
		return;
	}
	if (m_AmtMRowID == "") {
		$.messager.popover({msg: '选择发票错误', type: 'info'});
		return;
	}
	$.messager.confirm("提示", "确认发放从[<font color='red'>" + title + startno + "</font>]到[<font color='red'>" + title + endno + "</font>]的发票？",function(r){
		if (!r) {
			return;
		}
		var str = "^" + startno + "^" + endno + "^" + lquserid + "^" + buyend + "^" + type + "^" + title;
		$.m({
			ClassName: "web.UDHCJFInvprt",
			MethodName: "dhcinvoiceinsert",
			str: str,
			AMRowID: m_AmtMRowID,
			hospId: session['LOGON.HOSPID']
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.alert("提示", "发放成功", "success", function() {
					reloadMenuPanel();
				});
				return;
			}
			$.messager.popover({msg: "发放失败：" + (myAry[1] || rtn), type: "error"});
		});
	});
}

/**
* 删除发放
*/
function deleteClick() {
	var row = $HUI.datagrid("#tUDHCJFInvprtGrant").getSelected();
	if (!row || !row.Trowid) {
		$.messager.popover({msg: '请选择要删除的记录', type: 'info'});
        return;
	}
	var invRowid = row.Trowid;
	var jsonObj = getPersistClsObj("User.DHCINVOICE", invRowid);
	if (jsonObj.INVStartInv != jsonObj.INVLastNum) {
		$.messager.popover({msg: '选中记录已经使用，不能删除', type: 'info'});
		return;
	}
	$.messager.confirm("提示", "确认删除？",function(r) {
		if (!r) {
			return;
		}
		$.m({
		    ClassName: "web.UDHCJFInvprt",
	    	MethodName: "DeleteGrant",
	    	invId: invRowid,
	    	hospId: session['LOGON.HOSPID']
	    }, function(rtn) {
		    if (rtn == 0) {
			    $.messager.alert("提示", "删除成功", "success", function() {
					$("#Find").click();
				});
			    return;
			}
		    $.messager.popover({msg: "删除失败：" + rtn, type: "error"});
		});
	});
}

/**
* 购入成功后重新获取新的发票号段
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	getinvgrantmax();            //购入成功后重新获取新的发票号段
	$('#Find').click();
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function celendno() {
	var num = getValueById('number');
	if (num.indexOf("-") > -1) {
		numobj.value = "";
		return;
	}
	var sno = getValueById('startno');
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	if (num == "" || (parseInt(num, 10) == 0)) {
		return;
	}
	if (checkno(num) && (sno != "") && checkno(sno)) {
		ssno1 = parseInt(sno, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString();
		slen = sno.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = "0" + ssno;
		}
		setValueById('endno', ssno);
	}
}

function confirmInvprtClick() {
	var row = $HUI.datagrid('#tUDHCJFInvprtGrant').getSelected();
	if (!row || !row.Trowid) {
		$.messager.popover({msg: '请选择需要核销的记录', type: 'info'});
		return;
	}
	var invRowid = row.Trowid;
	var invFlag = row.Tflag;
	var userRowid = row.TlquserId;
	if (invFlag != "已用完") {
		$.messager.popover({msg: '票据未用完或已核销，不能核销', type: 'info'});
		return;
	}
	$.m({
	    ClassName: "web.DHCOPConfirmInvoiceManage",
    	MethodName: "ConfirmInsert",
    	invRowid: invRowid,
    	userRowid: session['LOGON.USERID']
    }, function(rtn) {
	    if (rtn == 0) {
			$.messager.alert("提示", "核销成功", "success", function() {
				$("#Find").click();
			});
			return;
		}
		$.messager.popover({msg: '核销失败', type: 'error'});
	});
}

// tangzf 2019-5-15
function PrintInvoice() {
	var invprtFlag = getValueById("invprtFlag");
	var type = getValueById('type');
	var lquserid = getValueById('lquserid');
	var stDate = getValueById("stdate");
	var endDate = getValueById("enddate");
	var hospId = session['LOGON.HOSPID'];
	var fileName = "DHCBILL-InvGrantList.rpx" + "&invprtFlag=" + invprtFlag + "&type=" + type + "&lquserid=" + lquserid;
	fileName += "&stdate=" + stDate + "&enddate=" + endDate + "&hospId=" + hospId;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-09-30
 */
function selReceiptsNum_Click() {
	var type = getValueById('type');
	if (type == "") {
		$.messager.popover({msg: '请先选择票据类型', type: 'info'});
		return;
	}
	var flag = "INV";
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	websys_showModal({
		iconCls: 'icon-w-list',
		title: '购入号段列表',
		height: 370,
		width: 610,
		url: url,
		callbackFunc: function(rtn) {
			var myAry = rtn.split('^');
			m_AmtMRowID =  myAry[0];
			var startNO = myAry[1];
			var endNO = myAry[2];
			var title = myAry[3];
			
			setValueById('startno', startNO);
			setValueById('endno', endNO);
			setValueById('maxno', endNO);
			setValueById('Title', title);
			if (startNO == "") {
				focusById('startno');
			} else {
				setValueById('number', "");
				focusById('number');
			}
		}
	});
}

function init_Layout(){
	$('#cStartno').parent().parent().css("width", "69px");
	DHCWeb_ComponentLayout();
}