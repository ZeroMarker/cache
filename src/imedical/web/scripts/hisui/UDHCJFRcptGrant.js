/// UDHCJFRcptGrant.js

var m_BuyRowID = "";

$(function () {
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
	
	$HUI.linkbutton('#SelReceiptsNum', {
		onClick: function () {
			selReceiptsNumClick();
		}
	});
	
	$HUI.numberbox('#number', {
		min: 1,
		isKeyupChange: true,
		onChange: function (newValue, oldValue) {
			celendno();
		}
	});
	
	$("#stno").attr("readOnly", true);
	
	$('#grantflag').combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: '', text: '全部', selected: true},
			  {id: '可用', text: '可用'},
			  {id: '已用完', text: '已用完'},
			  {id: '待用', text: '待用'},
			  {id: '转交', text: '转交'}]
	});
	
	//领取人
    $("#lquser").combobox({
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onChange: function(newValue, oldValue) {
			setValueById("lquserid", (newValue || ""));
		}
	});
	
	//类型
    $("#type").combobox({
        panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'I', text: '住院押金', selected: true}],
		onChange: function(newValue, oldValue) {
			var url = $URL + "?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array&type=" + (newValue || "") + "&hospId=" + session['LOGON.HOSPID'];
			$("#lquser").combobox("clear").combobox("reload", url);
			
			StartNo();
		}
    });
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
		setValueById('title', myAry[2]);
		m_BuyRowID = myAry[3];
	});
}

function addClick() {
	var stno = getValueById('stno');
	if (stno == "") {
		$.messager.popover({msg: '开始号码不能为空', type: 'info'});
		return;
	}
	var endno = getValueById('endno');
	if (endno == "") {
		$.messager.popover({msg: '结束号码不能为空', type: 'info'});
		return;
	}
	if (stno.length != endno.length) {
		$.messager.popover({msg: '开始号码和结束号码位数不同', type: 'info'});
		return;
	}
	var kyendno = getValueById('kyendno');
	if (endno > kyendno) {
		$.messager.popover({msg: '发放的结束号码不能大于可用结束号码', type: 'info'});
		return;
	}
	if (parseInt(endno, 10) < parseInt(stno, 10)) {
		$.messager.popover({msg: '结束号码不能小于开始号码', type: 'info'});
		return;
	}
	var lquserid = getValueById('lquserid');
	if (lquserid == "") {
		$.messager.popover({msg: '领取人不能为空', type: 'info'});
		focusById('lquser');
		return;
	}
	var title = getValueById('title');
	var type = getValueById('type');
	if (m_BuyRowID == "") {
		$.messager.popover({msg: '选择发票错误', type: 'info'});
		return;
	}
	var str = stno + '^' + endno + '^' + kyendno + '^' + session['LOGON.USERID'] + '^' + lquserid + '^' + title + '^' + type;
	$.messager.confirm("提示", "确认发放从[<font color='red'>" + title + stno + "</font>]到[<font color='red'>" + title + endno + "</font>]的收据?",function(r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFReceipt",
			MethodName: "InsertGrant",
			str: str,
			buyRowID: m_BuyRowID,
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
* 购入成功后重新获取新的发票号段
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	StartNo();            //购入成功后重新获取新的发票号段
	$('#Find').click();
}

function deleteClick() {
	var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tgrantrowid) {
		$.messager.popover({msg: '请选择要删除的记录', type: 'info'});
        return;
	}
	var grantRowId = row.Tgrantrowid;
	var rtn = $.m({ClassName: "web.UDHCJFReceipt", MetodName: "GetMaxGrantRowId", hospId: session['LOGON.HOSPID']}, false);
	var myAry = rtn.split("^");
	var maxRowId = myAry[0];
	var stNo = myAry[1];
	var curno = myAry[2];
	if (grantRowId != maxRowId) {
		$.messager.popover({msg: '该记录不是最后一条记录，不能删除', type: 'info'});
		return;
	}
	if (stNo != curno) {
		$.messager.popover({msg: '选中记录已经使用，不能删除', type: 'info'});
		return;
	}
	$.messager.confirm("提示", "确认删除？",function(r) {
		if (!r) {
			return;
		}
		$.m({
		    ClassName: "web.UDHCJFReceipt",
	    	MethodName: "DeleteGrant",
	    	grantId: grantRowId,
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

function celendno() {
	var num = getValueById('number');
	var sno = getValueById('stno');
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	if ((num == "") || (parseInt(num, 10) == 0)) {
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
function selReceiptsNumClick() {
	var type = getValueById('type');
	if (type == "") {
		$.messager.popover({msg: '请先选择票据类型', type: 'info'});
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

function init_Layout(){
	DHCWeb_ComponentLayout()
	$('#cstno').parent().parent().css("width", "71px");
}