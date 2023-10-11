/// UDHCJFInvprtBuy.js

$(function() {
	init_Layout();
	
	$HUI.linkbutton('#add', {
		onClick: function () {
			Add_Click();
		}
	});
	
	$HUI.linkbutton('#delete', {
		onClick: function () {
			delete_Click();
		}
	});
	
	$HUI.linkbutton('#Print', {
		onClick: function () {
			Print_Click();
		}
	});
	
	//恢复发放(目前没有使用)
	$HUI.linkbutton('#BtnRestore', {
		onClick: function () {
			Restore_Click();
		}
	});
	
	$HUI.numberbox('#number', {
		min: 1,
		isKeyupChange: true,
		onChange: function (newValue, oldValue) {
			celendno();
		}
	});
	
	//类型
    $("#type").combobox({
        panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			getinvmax();
		}
    });
    
    //购入人员
    $("#buyer").combobox({
        panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvBuyer&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("userid", (newValue || ""));
		}
    });
    
});

/**
* 获取需要购入的开始号
*/
function getinvmax() {
	var type = getValueById("type");
	if (!type) {
		return;
	}
	$.m({
		ClassName: "web.UDHCJFInvprt",
		MethodName: "invprtgetmax",
		type: type,
		hospId: session['LOGON.HOSPID']
	}, function(startNo) {
		setValueById("Startno", startNo);
		if (!startNo) {
			focusById('Startno');
		} else {
			focusById('endno');
		}
	});
}

function delete_Click() {
	var row = $HUI.datagrid("#tUDHCJFInvprtBuy").getSelected();
	if (!row || !row.TRowid) {
		$.messager.popover({msg: '请选择要删除的记录', type: 'info'});
		return;
	}
	var rowId = row.TRowid;
	$.messager.confirm("提示", "确认删除？",function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFInvprt",
				MethodName: "DeleteBuy",
				rowId: rowId
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "删除成功", "success", function() {
						$("#Find").click();
					});
					break;
				case "-2":
					$.messager.popover({msg: '此号段已使用，不能删除', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '删除失败：' + rtn, type: 'error'});
				}
			});
		}
	});
}

function Add_Click() {
	var startno = getValueById('Startno');
	var endno = getValueById('endno');
	var buyuser = getValueById('userid');
	var title = getValueById('Title');
	var type = getValueById('type');
	var userid = buyuser;
	var useflag = "";
	//add by zhl anh
	if (userid == "") {
		$.messager.popover({msg: '购入人不能为空', type: 'info'});
		focusById('buyer');
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
		focusById('Startno');
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
		$.messager.popover({msg: '结束号码的长度不等于开始号码的长度,请重新输入', type: 'info'});
		focusById('endno');
		return;
	}
	
	$.messager.confirm("确认", "确定购入从[<font color='red'>" + title + startno + "</font>]到[<font color='red'>" + title + endno + "</font>]的发票？", function(r) {
		if (r) {
			var str = "^^" + type + "^" + buyuser + "^^" + startno + "^" + endno + "^^" + session['LOGON.USERID'] + "^^" + useflag + "^" + title;
			$.m({
				ClassName: "web.UDHCJFInvprt",
				MethodName: "dhcamtmaginsert",
				str: str,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "购入成功", "success", function() {
						reloadMenuPanel();
					});
					break;
				case "-505":
					$.messager.popover({msg: '发票已经购入，不能重复购入', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '购入失败：' + rtn, type: 'error'});
				}
			});
		}
	});
}

/**
* 购入成功后重新获取新的发票号段
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	setValueById('endno', '');
	getinvmax();            //购入成功后重新获取新的发票号段
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
	var sno = getValueById('Startno');
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

function Restore_Click() {
	var row = $HUI.datagrid("#tUDHCJFInvprtBuy").getSelected();
	if (!row || !row.TRowid) {
		$.messager.popover({msg: '请选择一条记录', type: 'info'});
		return;
	}
	var returnFlag = rowData.TReturnFlag;
	if (returnFlag == "") {
		$.messager.popover({msg: '此收据不是退回收据或已经退回', type: 'info'});
		return;
	}
	var rowId = row.TRowid;
	var encmeth = getValueById('GetRestore');
	if (cspRunServerMethod(encmeth, rowId) == 0) {
		$.messager.popover({msg: '保存成功', type: 'success'});
	} else {
		$.messager.popover({msg: '保存失败', type: 'error'});
	}
	$("#Find").click();
}

/**
* tangzf 2019-5-15
*/
function Print_Click() {
	var stDate = getValueById('stdate');
	var endDate = getValueById('enddate');
	var type = getValueById('type');
	var buyer = getValueById('buyer');
	var hospId = getValueById('hospId');
	var fileName = "DHCBILL-InvBuyList.rpx" + "&type=" + type+ "&stdate=" + stDate + "&enddate=" + endDate;
	fileName += "&buyer=" + buyer + "&hospId=" + hospId;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

function init_Layout() {
	$('#cStartno').parent().parent().css("width", "71px");
	DHCWeb_ComponentLayout();
}