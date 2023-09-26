/// UDHCJFRcptDeliver.js

var judgepass1 = 0;
var judgepass2 = 0;

$(function() {
	init_Layout();
	
	var obj = document.getElementById('add');
	if (obj) {
		obj.onclick = add_Click;
	}

	var numobj = document.getElementById('delivernum');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	$("#Startno").attr("readOnly", true);
});

function StartNo() {
	var beuserid = getValueById('Bezjuserid');
	var type = getValueById('type');
	if (beuserid == "") {
		return;
	}
	$.m({
		ClassName: "web.UDHCJFReceipt",
		MethodName: "Getkydeliver",
		guser: beuserid,
		type: type,
		hospId: session['LOGON.HOSPID']
	},function(rtn) {
		var myAry = rtn.split("^");
	    setValueById('Startno', myAry[0]);
	    setValueById('endno', myAry[1]);
		setValueById('kyendno', myAry[1]);
		setValueById('kyrowid', myAry[2]);
	});
}

function add_Click() {
	judgepass1 = 0;
	judgepass2 = 0;
	
	var startno = getValueById('Startno');
	var endno = getValueById('endno');
	
	var oldEndNo = getValueById('kyendno');
	if (+oldEndNo < +endno) {
		DHCWeb_HISUIalert(t["EndNoMaxErr"]);
		focusById('endno');
		return;
	}
	
	var pass1 = getValueById('passward1');
	var pass2 = getValueById('passward2');
	var kyendno = getValueById('kyendno');
	var kyrowid = getValueById('kyrowid');
	var type = getValueById('type');
	if ((startno == "") || (endno == "")) {
		DHCWeb_HISUIalert(t['01']);
		focusById('endno');
		return;
	}
	
	/*
	if (pass1 == "") {
		DHCWeb_HISUIalert(t['02']);
		focusById('passward1');
		return;
	}
	if (pass2 == "") {
		DHCWeb_HISUIalert(t['03']);
		focusById('passward2');
		return;
	}
	*/
	 
	if (!checkno(startno)) {
		DHCWeb_HISUIalert(t['04']);
		focusById('Startno');
		return;
	}
	if (!checkno(endno)) {
		DHCWeb_HISUIalert(t['05']);
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		DHCWeb_HISUIalert(t['06']);
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		DHCWeb_HISUIalert(t['07']);
		focusById('endno');
		return;
	}
	
	var userid = getValueById('zjuserid');
	if (userid == "") {
		DHCWeb_HISUIalert(t['08']);
		focusById('deliveruser');
		return;
	}
	var beuserid = getValueById('Bezjuserid');
	if (beuserid == "") {
		DHCWeb_HISUIalert(t['19']);
		focusById('Bedeliveruser');
		return;
	}
	if (beuserid == userid) {
		DHCWeb_HISUIalert("转交人不能与接收人相同,请重新选择接收人");
		return;
	}
	var msg = t['11'] + "[ <font style='color:red'>" + startno + "</font> ]" + t['12'] + "[ <font style='color:red'>" + endno + "</font> ]" + t['13'];
	$.messager.confirm("提示", msg, function(r) {
		if (r) {
			var str = startno + "^" + endno + "^" + startno + "^" + beuserid + "^" + "" + "^" + userid + "^^" + kyendno + "^" + kyrowid + "^" + type + "^" + session['LOGON.USERID'];
			$.m({
				ClassName: "web.UDHCJFReceipt",
				MethodName: "deliverrcpt",
				str: str,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "转交成功", "success", function() {
						$("#find").click();
					});
					break;
				case "-100":
					DHCWeb_HISUIalert("不能重复转交，请刷新界面后重试");
					break;
				default:
					DHCWeb_HISUIalert("转交失败：" + rtn);
				}
			});
	    }
	});
}

function judgepwd(value) {
	if (value == '100') {
		DHCWeb_HISUIalert(t['09']);
		focusById('passward1');
		judgepass1 = 0;
	} else {
		judgepass1 = 1;
	}
}

function judgepwd1(value) {
	if (value == '100') {
		DHCWeb_HISUIalert(t['10']);
		focusById('passward2');
		judgepass2 = 0;
	} else {
		judgepass2 = 1;
	}
}

function celendno() {
	var num = getValueById('delivernum');
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

function init_Layout() {
	$('#cStartno').parent().parent().css("width","71px");
	DHCWeb_ComponentLayout();
	
	$("#type").combobox({
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindRcptType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			$("#Bedeliveruser, #deliveruser").combobox("clear").combobox("reload");
		}
	});

	//转交人
	$("#Bedeliveruser").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.type = getValueById("type");
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("Bezjuserid", (newValue || ""));
			StartNo();
		}
	});
	
	//接收人
	$("#deliveruser").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.type = getValueById("type");
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("zjuserid", (newValue || ""));
		}
	});
}