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
    $.messager.confirm("确认", "确认购入从[<font color='red'>" + title + stno + "</font>]到[<font color='red'>" + title + endno + "</font>]的收据?", function(r) {
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
					$.messager.alert("提示", "购入成功", "success", function() {
						$("#Find").click();
					});
					break;
				case "-505":
					DHCWeb_HISUIalert("不能重复购入押金收据");
					break;
				default:
					DHCWeb_HISUIalert("购入失败：" + rtn);
				}
			});
		}
	});
}

function Delete_click() {
    var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		DHCWeb_HISUIalert("请选择要删除的记录");
        return;
	}
    var rowId = row.Tbuyrowid;
    $.messager.confirm("提示", "确认删除？",function(r) {
	    if (r) {
		 	$.m({
			    ClassName: "web.UDHCJFReceipt",
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

//恢复发放
function resumeGrant_click() {
	var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		DHCWeb_HISUIalert("请先选择一行");
        return;
	}
	var comment1 = row.Tcomment1;
    if (comment1 == "") {
        DHCWeb_HISUIalert("所选的行不是恢复发放的类型");
        return;
    }
    if (comment1 != "Return") {
        DHCWeb_HISUIalert("该收据已经恢复发放过了");
        return;
    }
	var rowId = row.Tbuyrowid;
    var encmeth = getValueById('grantTo');
    var rtn = cspRunServerMethod(encmeth, rowId);
    if (rtn == 0) {
        $.messager.alert("提示", "恢复发放成功", "success", function() {
			$("#Find").click();
		});
    } else {
	    $.messager.alert("提示", "恢复发放失败：" + rtn, "error");
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
	
	//类型
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
    
    //购入人
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
