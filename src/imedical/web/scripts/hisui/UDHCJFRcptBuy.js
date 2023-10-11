/// UDHCJFRcptBuy.js

$(function () {
    init_Layout();

	$HUI.linkbutton('#Add', {
		onClick: function () {
			Add_click();
		}
	});
	
	$HUI.linkbutton('#Delete', {
		onClick: function () {
			Delete_click();
		}
	});
	
	$HUI.linkbutton('#resumeGrant', {
		onClick: function () {
			resumeGrant_click();
		}
	});
	
	$HUI.numberbox('#number', {
		min: 1,
		isKeyupChange: true,
		onChange: function (newValue, oldValue) {
			celendno();
		}
	});
    
    //������
    $("#gruser").combobox({
        panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindRcptBuyer&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		selectOnNavigation: false,
		onBeforeLoad: function (param) {
			param.hospId = session['LOGON.HOSPID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("userid", (newValue || ""));
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
			StartNo();
		}
    });
});

function StartNo() {
    var type = getValueById('type');
    if (!type) {
		return;
	}
    $.m({
		ClassName: "web.UDHCJFReceipt",
		MethodName: "GetStNo",
		type: type,
		hospId: session['LOGON.HOSPID']
	}, function(startNo) {
		setValueById("stno", startNo);
		if (!startNo) {
			focusById('stno');
		} else {
			focusById('endno');
		}
	});
}

function Add_click() {
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
    if (!checkno(stno)) {
	    $.messager.popover({msg: '��ʼ������������', type: 'info'});
        focusById('stno');
        return;
    }
    if (!checkno(endno)) {
	    $.messager.popover({msg: '����������������', type: 'info'});
        focusById('endno');
        return;
    }
    if (parseInt(endno, 10) < parseInt(stno, 10)) {
	    $.messager.popover({msg: '�������벻��С�ڿ�ʼ����', type: 'info'});
        return;
    }
    var gruser = getValueById('gruser');
    if (gruser == "") {
	    $.messager.popover({msg: '�����˲���Ϊ��', type: 'info'});
        return;
    }
    
    var title = getValueById('title');
    var type = getValueById('type');
    if (type == "") {
	    $.messager.popover({msg: '��ѡ������', type: 'info'});
        return;
    }
    $.messager.confirm("ȷ��", "ȷ�Ϲ����[<font color='red'>" + title + stno + "</font>]��[<font color='red'>" + title + endno + "</font>]���վ�?", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFReceipt",
				MethodName: "InsertBuy",
				stno: stno,
				endno: endno,
				userId: getValueById('userid'),
				title: title,
				type: type,
				hospId: session['LOGON.HOSPID']
			}, function(rtn) {
				switch(rtn) {
				case "0":
					$.messager.alert("��ʾ", "����ɹ�", "success", function() {
						reloadMenuPanel();
					});
					break;
				case "-505":
					$.messager.popover({msg: '�����ظ�����Ѻ���վ�', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '����ʧ�ܣ�' + rtn, type: 'error'});
				}
			});
		}
	});
}

/**
* ����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	setValueById('endno', '');
	StartNo();            //����ɹ������»�ȡ�µķ�Ʊ�Ŷ�
	$('#Find').click();
}

function Delete_click() {
    var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		$.messager.popover({msg: '��ѡ��Ҫɾ���ļ�¼', type: 'info'});
        return;
	}
    var rowId = row.Tbuyrowid;
    $.messager.confirm("��ʾ", "ȷ��ɾ����",function(r) {
	    if (r) {
		 	$.m({
			    ClassName: "web.UDHCJFReceipt",
		    	MethodName: "DeleteBuy",
		    	rowId: rowId
		    }, function(rtn) {
			    switch(rtn) {
				case "0":
					$.messager.alert("��ʾ", "ɾ���ɹ�", "success", function() {
						$("#Find").click();
					});
					break;
				case "-2":
					$.messager.popover({msg: '�˺Ŷ���ʹ�ã�����ɾ��', type: 'info'});
					break;
				default:
					$.messager.popover({msg: 'ɾ��ʧ�ܣ�' + rtn, type: 'error'});
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

//�ָ�����
function resumeGrant_click() {
	var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		$.messager.popover({msg: '����ѡ��һ��', type: 'info'});
        return;
	}
	var comment1 = row.Tcomment1;
    if (comment1 == "") {
	    $.messager.popover({msg: '��ѡ���в��ǻָ����ŵ�����', type: 'info'});
        return;
    }
    if (comment1 != "Return") {
	    $.messager.popover({msg: '���վ��Ѿ��ָ����Ź���', type: 'info'});
        return;
    }
	var rowId = row.Tbuyrowid;
    var encmeth = getValueById('grantTo');
    var rtn = cspRunServerMethod(encmeth, rowId);
    if (rtn == 0) {
        $.messager.alert("��ʾ", "�ָ����ųɹ�", "success", function() {
			$("#Find").click();
		});
    } else {
	    $.messager.popover({msg: '�ָ�����ʧ�ܣ�' + rtn, type: 'error'});
    }
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
            ssno = "0" + ssno;
        }
        setValueById('endno', ssno);
    }
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    $('#cstno').parent().parent().css("width", "71px");
}