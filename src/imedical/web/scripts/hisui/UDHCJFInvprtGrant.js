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
		data:[{id: 'All', text: 'ȫ��', selected: true},
			  {id: 'Y', text: '����'},
			  {id: 'N', text: '������'},
			  {id: '', text: '����'},
			  {id: 'Confirm', text:'�Ѻ���'}]
	});
	
	//����
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
    
    //��ȡ��
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
			$.messager.popover({msg: 'û�п��Է��ŵķ�Ʊ', type: 'info'});
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
		$.messager.popover({msg: 'û�п��Է��ŵķ�Ʊ', type: 'info'});
		return;
	}
	if (type == "") {
		$.messager.popover({msg: '��Ʊ���Ͳ���Ϊ��', type: 'info'});
		focusById('type');
		return;
	}
	if ((startno == "") || (endno == "")) {
		$.messager.popover({msg: '��ʼ�����������벻��Ϊ��', type: 'info'});
		focusById('endno');
		return;
	}
	if (!checkno(startno)) {
		$.messager.popover({msg: '��ʼ������������', type: 'info'});
		focusById('startno');
		return;
	}
	if (!checkno(endno)) {
		$.messager.popover({msg: '����������������', type: 'info'});
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		$.messager.popover({msg: '�������벻��С�ڿ�ʼ���룬����������', type: 'info'});
		focusById('endno');
		return;
	}
	if (endno.length != startno.length) {
		$.messager.popover({msg: '��������ĳ��Ȳ����ڿ�ʼ����ĳ��ȣ�����������', type: 'info'});
		focusById('endno');
		return;
	}
	if (parseInt(endno, 10) > parseInt(buyend, 10)) {
		$.messager.popover({msg: '�˴η��ŵ��վݵ��������ǣ�' + buyend + '������������', type: 'info'});
		focusById('endno');
		return;
	}
	if (lquserid == "") {
		$.messager.popover({msg: '��ȡ�˲���Ϊ��', type: 'info'});
		focusById('lquser');
		return;
	}
	if (m_AmtMRowID == "") {
		$.messager.popover({msg: 'ѡ��Ʊ����', type: 'info'});
		return;
	}
	$.messager.confirm("��ʾ", "ȷ�Ϸ��Ŵ�[<font color='red'>" + title + startno + "</font>]��[<font color='red'>" + title + endno + "</font>]�ķ�Ʊ��",function(r){
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
* ɾ������
*/
function deleteClick() {
	var row = $HUI.datagrid("#tUDHCJFInvprtGrant").getSelected();
	if (!row || !row.Trowid) {
		$.messager.popover({msg: '��ѡ��Ҫɾ���ļ�¼', type: 'info'});
        return;
	}
	var invRowid = row.Trowid;
	var jsonObj = getPersistClsObj("User.DHCINVOICE", invRowid);
	if (jsonObj.INVStartInv != jsonObj.INVLastNum) {
		$.messager.popover({msg: 'ѡ�м�¼�Ѿ�ʹ�ã�����ɾ��', type: 'info'});
		return;
	}
	$.messager.confirm("��ʾ", "ȷ��ɾ����",function(r) {
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
			    $.messager.alert("��ʾ", "ɾ���ɹ�", "success", function() {
					$("#Find").click();
				});
			    return;
			}
		    $.messager.popover({msg: "ɾ��ʧ�ܣ�" + rtn, type: "error"});
		});
	});
}

/**
* ����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	getinvgrantmax();            //����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
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
		$.messager.popover({msg: '��ѡ����Ҫ�����ļ�¼', type: 'info'});
		return;
	}
	var invRowid = row.Trowid;
	var invFlag = row.Tflag;
	var userRowid = row.TlquserId;
	if (invFlag != "������") {
		$.messager.popover({msg: 'Ʊ��δ������Ѻ��������ܺ���', type: 'info'});
		return;
	}
	$.m({
	    ClassName: "web.DHCOPConfirmInvoiceManage",
    	MethodName: "ConfirmInsert",
    	invRowid: invRowid,
    	userRowid: session['LOGON.USERID']
    }, function(rtn) {
	    if (rtn == 0) {
			$.messager.alert("��ʾ", "�����ɹ�", "success", function() {
				$("#Find").click();
			});
			return;
		}
		$.messager.popover({msg: '����ʧ��', type: 'error'});
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
		$.messager.popover({msg: '����ѡ��Ʊ������', type: 'info'});
		return;
	}
	var flag = "INV";
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	websys_showModal({
		iconCls: 'icon-w-list',
		title: '����Ŷ��б�',
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