/// UDHCJFRcptDeliver.js

var judgepass1 = 0;
var judgepass2 = 0;

$(function() {
	init_Layout();
	
	$HUI.linkbutton('#add', {
		onClick: function () {
			addClick();
		}
	});
	
	$HUI.numberbox('#delivernum', {
		min: 1,
		isKeyupChange: true,
		onChange: function (newValue, oldValue) {
			celendno();
		}
	});

	$("#Startno").attr("readOnly", true);
	
	//转交人
	$("#Bedeliveruser").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
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
		defaultFilter: 5,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.type = getValueById("type");
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("zjuserid", (newValue || ""));
		}
	});
	
	$("#type").combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'I', text: '住院押金', selected: true}],
		onChange: function(newValue, oldValue) {
			$("#Bedeliveruser, #deliveruser").combobox("clear").combobox("reload");
		}
	});
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

function addClick() {
	judgepass1 = 0;
	judgepass2 = 0;
	
	var startno = getValueById('Startno');
	var endno = getValueById('endno');
	
	var oldEndNo = getValueById('kyendno');
	if (+oldEndNo < +endno) {
		$.messager.popover({msg: t["EndNoMaxErr"], type: 'info'});
		focusById('endno');
		return;
	}
	
	var pass1 = getValueById('passward1');
	var pass2 = getValueById('passward2');
	var kyendno = getValueById('kyendno');
	var kyrowid = getValueById('kyrowid');
	var type = getValueById('type');
	if ((startno == "") || (endno == "")) {
		$.messager.popover({msg: t['01'], type: 'info'});
		focusById('endno');
		return;
	}
	
	/*
	if (pass1 == "") {
		$.messager.popover({msg: t['02'], type: 'info'});
		focusById('passward1');
		return;
	}
	if (pass2 == "") {
		$.messager.popover({msg: t['03'], type: 'info'});
		focusById('passward2');
		return;
	}
	*/
	 
	if (!checkno(startno)) {
		$.messager.popover({msg: t['04'], type: 'info'});
		focusById('Startno');
		return;
	}
	if (!checkno(endno)) {
		$.messager.popover({msg: t['05'], type: 'info'});
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		$.messager.popover({msg: t['06'], type: 'info'});
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		$.messager.popover({msg: t['07'], type: 'info'});
		focusById('endno');
		return;
	}
	
	var userid = getValueById('zjuserid');
	if (userid == "") {
		$.messager.popover({msg: t['08'], type: 'info'});
		focusById('deliveruser');
		return;
	}
	var beuserid = getValueById('Bezjuserid');
	if (beuserid == "") {
		$.messager.popover({msg: t['19'], type: 'info'});
		focusById('Bedeliveruser');
		return;
	}
	if (beuserid == userid) {
		$.messager.popover({msg: '转交人不能与接收人相同，请重新选择接收人', type: 'info'});
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
					$.messager.popover({msg: "不能重复转交，请刷新界面后重试", type: 'error'});
					break;
				default:
					$.messager.popover({msg: "转交失败：" + rtn, type: 'error'});
				}
			});
	    }
	});
}

function judgepwd(value) {
	if (value == '100') {
		$.messager.popover({msg: t['09'], type: 'info'});
		focusById('passward1');
		judgepass1 = 0;
	} else {
		judgepass1 = 1;
	}
}

function judgepwd1(value) {
	if (value == '100') {
		$.messager.popover({msg: t['10'], type: 'info'});
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
}