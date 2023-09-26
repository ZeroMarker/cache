/// UDHCJFInvprtBuy.js

$(function() {
	init_Layout();
	var obj = document.getElementById('add');
	if (obj) {
		obj.onclick = Add_Click;
	}
	var obj = document.getElementById('BtnRestore');
	if (obj) {
		obj.onclick = Restore_Click;
	}
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	var obj = document.getElementById("stdate1");
	if (obj) {
		obj.onkeydown = getstdate;
		if (obj.value == "") {
			getdate();
		}
	}
	var obj = document.getElementById("enddate1");
	if (obj) {
		obj.onkeydown = getenddate;
		if (obj.value == "") {
			getdate();
		}
	}
	
	var obj = document.getElementById("delete");
	if (obj) {
		obj.onclick = delete_Click;
	}
	var printobj = document.getElementById("Print");
	if (printobj) {
		printobj.onclick = Print_Click;
	}
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

function getdate() {
	var encmeth = getValueById('today');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	var enddate1 = document.getElementById('enddate1');
	var enddate = document.getElementById('enddate');
	var stdate1 = document.getElementById('stdate1');
	var stdate = document.getElementById('stdate');
	today = value;
	curdate = value;
	var curdate1 = value;
	var str = curdate.split("/");
	curdate = str[2] + "-" + str[1] + "-" + str[0];
	if (enddate1.value == "") {
		enddate1.value = curdate;
		enddate.value = curdate1;
	}
	if (stdate1.value == "") {
		stdate1.value = curdate;
		stdate.value = curdate1;
	}
	checkdate();
}

function checkdate() {
	var end1obj = document.getElementById('enddate1');
	var endobj = document.getElementById('enddate');
	var enddate1 = document.getElementById('enddate1').value;
	var stdate1 = document.getElementById('stdate1').value;
	if ((enddate1 != "") & (stdate1 != "")) {
		var date = enddate1.split("-");
		var date1 = stdate1.split("-");
		if (eval(date1[0]) > eval(date[0])) {
			end1obj.value = "";
			end1obj.value = "";
			DHCWeb_HISUIalert(t['17']);
			return;
		}
		if (eval(date1[1]) > eval(date[1])) {
			end1obj.value = "";
			end1obj.value = "";
			DHCWeb_HISUIalert(t['17']);
			return;
		}
		if (eval(date1[2]) > eval(date[2])) {
			end1obj.value = "";
			end1obj.value = "";
			DHCWeb_HISUIalert(t['17']);
			return;
		}
	}
}

function getstdate() {
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = getValueById("stdate1");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsInvalid';
			focusById("stdate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			setValueById("stdate1", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsInvalid';
			focusById("stdate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsvalid';
		}
		checkdate();
		var obj = document.getElementById("stdate1");
		var str1 = obj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		var stdateobj = document.getElementById("stdate");
		stdateobj.value = str2;
		focusById('enddate1');
	}
}

function delete_Click() {
	var row = $HUI.datagrid("#tUDHCJFInvprtBuy").getSelected();
	if (!row || !row.TRowid) {
		DHCWeb_HISUIalert('请选择要删除的记录');
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
					$.messager.alert("提示", "此号段已使用，不能删除", "info");
					break;
				default:
					$.messager.alert("提示", "删除失败：" + rtn, "error");
				}
			});
		}
	});
}

function getenddate() {
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = getValueById("enddate1");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsInvalid';
			focusById("enddate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			setValueById("enddate1", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsInvalid';
			focusById("enddate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsvalid';
		}
		checkdate();
		var obj = document.getElementById("enddate1");
		var str1 = obj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		var enddateobj = document.getElementById("enddate");
		enddateobj.value = str2;
		focusById('Find');
	}
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
		DHCWeb_HISUIalert(t['14']);
		focusById('buyer');
		return;
	}
	if (type == "") {
		DHCWeb_HISUIalert(t['13']);
		focusById('type');
		return;
	}
	if (startno == "" || endno == "") {
		DHCWeb_HISUIalert(t['01']);
		focusById('endno');
		return;
	}
	if (!checkno(startno)) {
		DHCWeb_HISUIalert(t['02']);
		focusById('Startno');
		return;
	}
	if (!checkno(endno)) {
		DHCWeb_HISUIalert(t['03']);
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		DHCWeb_HISUIalert(t['04']);
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		DHCWeb_HISUIalert(t['05']);
		focusById('endno');
		return;
	}
	/*
	var encmeth = getValueById('getbuynote');
	var buynum = cspRunServerMethod(encmeth, '', '', startno, endno,type);
	if (eval(buynum) > 0) {
		DHCWeb_HISUIalert(t['09']);
		return;
	}
	*/
	var userid = getValueById("user");
	$.messager.confirm("确认", "确定购入从[<font color='red'>" + title + startno + "</font>]到[<font color='red'>" + title + endno + "</font>]的发票？", function(r) {
		if (r) {
			var str = "^^" + type + "^" + buyuser + "^^" + startno + "^" + endno + "^^" + userid + "^^" + useflag + "^" + title;
			$.m({
				ClassName: "web.UDHCJFInvprt",
				MethodName: "dhcamtmaginsert",
				str: str,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "购入成功", "success", function() {
						$("#Find").click();
					});
					break;
				case "-505":
					DHCWeb_HISUIalert(t['09']);
					break;
				default:
					DHCWeb_HISUIalert("购入失败：" + rtn);
				}
			});
		}
	});
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
		DHCWeb_HISUIalert('请先选择一行');
		return;
	}
	var returnFlag = rowData.TReturnFlag;
	if (returnFlag == "") {
		DHCWeb_HISUIalert(t['18']);
		return;
	}
	var rowId = row.TRowid;
	var encmeth = getValueById('GetRestore');
	if (cspRunServerMethod(encmeth, rowId) == 0) {
		DHCWeb_HISUIalert(t['19']);
	} else {
		DHCWeb_HISUIalert(t['20']);
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
	var fileName = "DHCBILL-InvBuyList.rpx" + "&type=" + type+ "&stdate=" + stDate + "&enddate=" + endDate + "&buyer=" + buyer;
	fileName += "&hospId=" + hospId;
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function init_Layout() {
	$('#cStartno').parent().parent().css("width","71px");
	DHCWeb_ComponentLayout();
	
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
}