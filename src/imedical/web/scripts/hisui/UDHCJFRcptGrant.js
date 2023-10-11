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
		data:[{id: '', text: 'ȫ��', selected: true},
			  {id: '����', text: '����'},
			  {id: '������', text: '������'},
			  {id: '����', text: '����'},
			  {id: 'ת��', text: 'ת��'}]
	});
	
	//��ȡ��
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
	
	//����
    $("#type").combobox({
        panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'I', text: 'סԺѺ��', selected: true}],
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
		$.messager.popover({msg: '��ʼ���벻��Ϊ��', type: 'info'});
		return;
	}
	var endno = getValueById('endno');
	if (endno == "") {
		$.messager.popover({msg: '�������벻��Ϊ��', type: 'info'});
		return;
	}
	if (stno.length != endno.length) {
		$.messager.popover({msg: '��ʼ����ͽ�������λ����ͬ', type: 'info'});
		return;
	}
	var kyendno = getValueById('kyendno');
	if (endno > kyendno) {
		$.messager.popover({msg: '���ŵĽ������벻�ܴ��ڿ��ý�������', type: 'info'});
		return;
	}
	if (parseInt(endno, 10) < parseInt(stno, 10)) {
		$.messager.popover({msg: '�������벻��С�ڿ�ʼ����', type: 'info'});
		return;
	}
	var lquserid = getValueById('lquserid');
	if (lquserid == "") {
		$.messager.popover({msg: '��ȡ�˲���Ϊ��', type: 'info'});
		focusById('lquser');
		return;
	}
	var title = getValueById('title');
	var type = getValueById('type');
	if (m_BuyRowID == "") {
		$.messager.popover({msg: 'ѡ��Ʊ����', type: 'info'});
		return;
	}
	var str = stno + '^' + endno + '^' + kyendno + '^' + session['LOGON.USERID'] + '^' + lquserid + '^' + title + '^' + type;
	$.messager.confirm("��ʾ", "ȷ�Ϸ��Ŵ�[<font color='red'>" + title + stno + "</font>]��[<font color='red'>" + title + endno + "</font>]���վ�?",function(r) {
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
				$.messager.alert("��ʾ", "���ųɹ�", "success", function() {
					reloadMenuPanel();
				});
				return;
			}
			$.messager.popover({msg: "����ʧ�ܣ�" + (myAry[1] || rtn), type: "error"});
		});
	});
}

/**
* ����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	StartNo();            //����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
	$('#Find').click();
}

function deleteClick() {
	var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tgrantrowid) {
		$.messager.popover({msg: '��ѡ��Ҫɾ���ļ�¼', type: 'info'});
        return;
	}
	var grantRowId = row.Tgrantrowid;
	var rtn = $.m({ClassName: "web.UDHCJFReceipt", MetodName: "GetMaxGrantRowId", hospId: session['LOGON.HOSPID']}, false);
	var myAry = rtn.split("^");
	var maxRowId = myAry[0];
	var stNo = myAry[1];
	var curno = myAry[2];
	if (grantRowId != maxRowId) {
		$.messager.popover({msg: '�ü�¼�������һ����¼������ɾ��', type: 'info'});
		return;
	}
	if (stNo != curno) {
		$.messager.popover({msg: 'ѡ�м�¼�Ѿ�ʹ�ã�����ɾ��', type: 'info'});
		return;
	}
	$.messager.confirm("��ʾ", "ȷ��ɾ����",function(r) {
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
			    $.messager.alert("��ʾ", "ɾ���ɹ�", "success", function() {
					$("#Find").click();
				});
			    return;
			}
		    $.messager.popover({msg: "ɾ��ʧ�ܣ�" + rtn, type: "error"});
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
		$.messager.popover({msg: '����ѡ��Ʊ������', type: 'info'});
		return;
	}
	var flag = "RCPT";
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	websys_showModal({
			iconCls: 'icon-w-list',
			title: '����Ŷ��б�',	
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