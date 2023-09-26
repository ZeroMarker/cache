/// UDHCJFRcptGrant.js

var m_BuyRowID = "";

$(function () {
	init_Layout();
	
	$('#grantflag').combobox({
		valueField: 'id',
		textField: 'text',
		data:[{id: '', text: '全部', selected: true},
			  {id: t['13'], text: t['13']},
			  {id: t['14'], text: t['14']},
			  {id: t['15'], text: t['15']},
			  {id: t['16'], text: t['16']}]
	});
	var obj = document.getElementById("Add");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("Delete");
	if (obj) {
		obj.onclick = Delete_click;
	}
	$("#stno").attr("readOnly", true);
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	var obj = websys_$("SelReceiptsNum");
	if (obj) {
		obj.onclick = selReceiptsNum_Click;
	}
});

function StartNo() {
	var type = getValueById("type");
	if (type == "") {
		return;
	}
	$.m({
		ClassName: "web.UDHCJFReceipt",
		MethodName: "GetGrantStNo",
		type: type,
		hospId: session['LOGON.HOSPID']
	},function(rtn) {
		var myAry = rtn.split("^");
		setValueById('stno', myAry[0]);
		setValueById('endno', myAry[1]);
		setValueById('kyendno', myAry[1]);
		m_BuyRowID = myAry[3];
	});
}

function Add_click() {
	var stno = getValueById('stno');
	if (stno == "") {
		DHCWeb_HISUIalert(t['01'])
		return;
	}
	var endno = getValueById('endno');
	if (endno == "") {
		DHCWeb_HISUIalert(t['02']);
		return;
	}
	if (stno.length != endno.length) {
		DHCWeb_HISUIalert(t['03']);
		return;
	}
	var kyendno = getValueById('kyendno');
	if (endno > kyendno) {
		DHCWeb_HISUIalert(t['04']);
		return;
	}
	if (parseInt(endno, 10) < parseInt(stno, 10)) {
		DHCWeb_HISUIalert(t['11']);
		return;
	}
	var lquserid = getValueById('lquserid');
	if (lquserid == "") {
		DHCWeb_HISUIalert(t['05']);
		return;
	}
	var title = getValueById('title');
	var type = getValueById('type');
	if (m_BuyRowID == "") {
		DHCWeb_HISUIalert("选择发票错误");
		return;
	}
	var str = stno + '^' + endno + '^' + kyendno + '^' + session['LOGON.USERID'] + '^' + lquserid + '^' + title + '^' + type;
	$.messager.confirm("提示", "确认发放从[<font color='red'>" + title + stno + "</font>]到[<font color='red'>" + title + endno + "</font>]的收据?",function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFReceipt",
				MethodName: "InsertGrant",
				str: str,
				buyRowID: m_BuyRowID,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("提示", "发放成功", "success", function() {
						$("#Find").click();
					});
					break;
				case "-507":
					DHCWeb_HISUIalert("开始号码错误");
					break;
				case "-508":
					DHCWeb_HISUIalert("结束号码错误");
					break;
				default:
					DHCWeb_HISUIalert("发放失败：" + rtn);
				}
			});
		}
	});
}

function Delete_click() {
	var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tgrantrowid) {
		DHCWeb_HISUIalert(t['06']);
        return;
	}
	var grantRowId = row.Tgrantrowid;
	var rtn = $.m({ClassName: "web.UDHCJFReceipt", MetodName: "GetMaxGrantRowId"}, false);
	var myAry = rtn.split("^");
	var maxRowId = myAry[0];
	var stNo = myAry[1];
	var curno = myAry[2];
	if (grantRowId != maxRowId) {
		DHCWeb_HISUIalert(t['07']);
		return;
	}
	if ((grantRowId = maxRowId) && (stno != curno)) {
		DHCWeb_HISUIalert(t['08']);
		return;
	}
	$.messager.confirm("提示", "确认删除？",function(r) {
		if (r) {
			$.m({
			    ClassName: "web.UDHCJFReceipt",
		    	MethodName: "DeleteGrant",
		    	grantId: grantRowId
		    }, function(rtn) {
			    switch(rtn) {
				case "0":
					$.messager.alert("提示", "删除成功", "success", function() {
						$("#Find").click();
					});
					break;
				default:
					$.messager.alert("提示", "删除失败：" + rtn, "error");
				}
			});
		}
	});
}

function celendno() {
	var num = getValueById('number');
	var sno = getValueById('stno');
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
			ssno = "0" + ssno
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
	var flag = "RCPT";
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	websys_showModal({
			iconCls: 'icon-w-list',
			title: '购入号段列表',	
			height: 370,
			width: 610,		
			url: url,
			callbackFunc: function(rtn) {
				var myAry = rtn.split('^');
				m_BuyRowID =  myAry[0];
				var startNO = myAry[1];
				var endNO = myAry[2];
				var title = myAry[3];
				setValueById('stno', startNO);
				setValueById('endno', endNO);
				setValueById('kyendno', endNO);
				setValueById('title', title);
				if (startNO == '') {
					focusById('stno');
				} else {
					setValueById('number', "");
					focusById('number');
				}
			}
	});
}

function Find_click() {
	var type=getValueById("type");
	var tmpFlag=getValueById("grantflag");
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCJFRcptGrant&grantflag=" + tmpFlag+"&type="+type;
	window.location.href = lnk;
}

function init_Layout(){
	DHCWeb_ComponentLayout()
	$('#cstno').parent().parent().css("width", "71px");
	
	//类型
    $("#type").combobox({
        panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindRcptType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			$("#lquser").combobox("clear").combobox("reload");
			StartNo();
		}
    });
    
    //领取人
    $("#lquser").combobox({
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
			setValueById("lquserid", (newValue || ""));
		}
	});
}