/// UDHCJFRcptBuy.js

var SelectedRow = 0;

$(function () {
    init_Layout();

    var obj = document.getElementById("Add");
    if (obj) {
        obj.onclick = Add_click;
    }

    var obj = document.getElementById("Delete");
    if (obj) {
        obj.onclick = Delete_click;
    }

    var resumeGrantobj = document.getElementById("resumeGrant");
    resumeGrantobj.onclick = resumeGrant_click;
    var numobj = document.getElementById('number');
    if (numobj) {
        numobj.onkeyup = celendno;
    }
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
        DHCWeb_HISUIalert(t['01']);
        return;
    }
    var endno = getValueById('endno');
    if (endno == "") {
        DHCWeb_HISUIalert(t['02']);
        return;
    }
    if (stno.length != endno.length) {
        DHCWeb_HISUIalert(t['03'])
        return;
    }
    if (!checkno(stno)) {
        DHCWeb_HISUIalert(t['16']);
        focusById('stno');
        return;
    }
    if (!checkno(endno)) {
        DHCWeb_HISUIalert(t['17']);
        focusById('endno');
        return;
    }
    if (parseInt(endno, 10) < parseInt(stno, 10)) {
        DHCWeb_HISUIalert(t['10']);
        return;
    }
    var gruser = getValueById('gruser');
    if (gruser == "") {
        DHCWeb_HISUIalert(t['04']);
        return;
    }
    /*
    var encmeth = getValueById('getbuynote');
    var buynum = cspRunServerMethod(encmeth, '', '', stno, endno);
    if (eval(buynum) > 0) {
	    DHCWeb_HISUIalert(t['14']);
	    return;
    }
	*/
    var title = getValueById('title');
    var type = getValueById('type');
    if (type == "") {
        DHCWeb_HISUIalert(t['15']);
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
						$("#Find").click();
					});
					break;
				case "-505":
					DHCWeb_HISUIalert("�����ظ�����Ѻ���վ�");
					break;
				default:
					DHCWeb_HISUIalert("����ʧ�ܣ�" + rtn);
				}
			});
		}
	});
}

function Delete_click() {
    var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		DHCWeb_HISUIalert("��ѡ��Ҫɾ���ļ�¼");
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
					$.messager.alert("��ʾ", "�˺Ŷ���ʹ�ã�����ɾ��", "info");
					break;
				default:
					$.messager.alert("��ʾ", "ɾ��ʧ�ܣ�" + rtn, "error");
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
		DHCWeb_HISUIalert("����ѡ��һ��");
        return;
	}
	var comment1 = row.Tcomment1;
    if (comment1 == "") {
        DHCWeb_HISUIalert("��ѡ���в��ǻָ����ŵ�����");
        return;
    }
    if (comment1 != "Return") {
        DHCWeb_HISUIalert("���վ��Ѿ��ָ����Ź���");
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
	    $.messager.alert("��ʾ", "�ָ�����ʧ�ܣ�" + rtn, "error");
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
	
	//����
    $("#type").combobox({
        panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindRcptType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			StartNo();
		}
    });
    
    //������
    $("#gruser").combobox({
        panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindRcptBuyer&ResultSetType=array',
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
