/// UDHCJFInvprtGrant.js

var m_AmtMRowID = "";

$(function() {
	init_Layout();
	var obj = document.getElementById('Add');
	if (obj) {
		obj.onclick = Add_Click;
	}
	var obj = document.getElementById('BtnReturn');
	if (obj) {
		obj.onclick = Return_Click;
	}
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	var obj = document.getElementById("startno");
	if (obj) {
		obj.readOnly = true;
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
	
	$('#invprtFlag').combobox({
		valueField: 'id',
		textField: 'text',
		data:[{id: 'All', text: '全部', selected: true},
			  {id: 'Y', text: '可用'},
			  {id: 'N', text: '已用完'},
			  {id: '', text: '待用'},
			  {id: 'Confirm', text:'已核销'}]
	});
	
	var obj = document.getElementById("BtnConfirm");
	if (obj) {
		obj.onclick = confirmInvprt_Click;
	}
	var obj = websys_$("PrintInvoice");
	if (obj) {
		obj.onclick = PrintInvoice;
	}
	var obj = websys_$("SelReceiptsNum");
	if (obj) {
		obj.onclick = selReceiptsNum_Click;
	}
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
			DHCWeb_HISUIalert(t['01']);
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
			DHCWeb_HISUIalert(t['07']);
			return;
		}
		if (eval(date1[1]) > eval(date[1])) {
			end1obj.value = "";
			end1obj.value = "";
			DHCWeb_HISUIalert(t['07']);
			return;
		}
		if (eval(date1[2]) > eval(date[2])) {
			end1obj.value = "";
			end1obj.value = "";
			DHCWeb_HISUIalert(t['07']);
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
	var startno = getValueById("startno");
	var endno = getValueById("endno");
	var buyend = getValueById("maxno");
	var title = getValueById("Title");
	var lquser = getValueById("lquser");
	var lquserid = getValueById("lquserid");
	var type = getValueById("type");
	if (buyend == "") {
		DHCWeb_HISUIalert(t['01']);
		return;
	}
	if (type == "") {
		DHCWeb_HISUIalert(t['03']);
		focusById('type');
		return;
	}
	if ((startno == "") || (endno == "")) {
		DHCWeb_HISUIalert(t['04']);
		focusById('endno');
		return;
	}
	if (!checkno(startno)) {
		DHCWeb_HISUIalert(t['05']);
		focusById('startno');
		return;
	}
	if (!checkno(endno)) {
		DHCWeb_HISUIalert(t['06']);
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		DHCWeb_HISUIalert(t['07']);
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		DHCWeb_HISUIalert(t['08']);
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) > parseInt(buyend, 10)) {
		DHCWeb_HISUIalert(t['09'] + buyend + t['10']);
		focusById('endno');
		return;
	}
	if (lquserid == "") {
		DHCWeb_HISUIalert(t['11']);
		focusById('lquser');
		return;
	}
	if (m_AmtMRowID == "") {
		DHCWeb_HISUIalert("选择发票错误");
		return;
	}
	$.messager.confirm("提示", "确认发放从[<font color='red'>" + title + startno + "</font>]到[<font color='red'>" + title + endno + "</font>]的发票？",function(r){
		if (r) {
			var str = "^" + startno + "^" + endno + "^" + lquserid + "^" + buyend + "^" + type + "^" + title;
			$.m({
				ClassName: "web.UDHCJFInvprt",
				MethodName: "dhcinvoiceinsert",
				str: str,
				AMRowID: m_AmtMRowID,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "发放成功", "success", function() {
						$("#Find").click();
					});
					break;
				case "-506":
					DHCWeb_HISUIalert("发放号段不存在,请刷新后重发");
					break;
				default:
					DHCWeb_HISUIalert("发放失败：" + rtn);
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

function confirmInvprt_Click() {
	var row = $HUI.datagrid('#tUDHCJFInvprtGrant').getSelected();
	if (!row || !row.Trowid) {
		DHCWeb_HISUIalert("请选择一条记录");
		return;
	}
	var invRowid = row.Trowid;
	var invFlag = row.Tflag;
	var userRowid = row.TlquserId;
	if (invFlag == "已用完") {
		var encmeth = getValueById('BtnConfirmEncrypt');
		var returnCode = cspRunServerMethod(encmeth, invRowid, session['LOGON.USERID']);
		if (returnCode == 0) {
			$.messager.alert("提示", "核销成功", "success", function() {
				$("#Find").click();
			});
		} else {
			DHCWeb_HISUIalert("核销失败");
		}
	} else {
		DHCWeb_HISUIalert("票据未用完或已核销,不能核销!");
		return;
	}
}

// tangzf 2019-5-15
function PrintInvoice() {
	var invprtFlag = getValueById("invprtFlag");
	var type = getValueById('type');
	var lquserid = getValueById('lquserid');
	var stDate = getValueById("stdate");
	var endDate = getValueById("enddate");
	var hospId = getValueById("hospId");
	var fileName = "DHCBILL-InvGrantList.rpx" + "&invprtFlag=" + invprtFlag + "&type=" + type + "&lquserid=" + lquserid;
	fileName += "&stdate=" + stDate + "&enddate=" + endDate + "&hospId=" + hospId;
	DHCCPM_RQPrint(fileName, 1200, 750);
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-09-30
 */
function selReceiptsNum_Click() {
	var type = getValueById('type');
	if (type == "") {
		DHCWeb_HISUIalert('请先选择票据类型');
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
	$('#cStartno').parent().parent().css("width","69px");
	DHCWeb_ComponentLayout();
	
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
}