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
    
    //购入人
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
    	
	//类型
    $("#type").combobox({
        panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		editable: false,
		data:[{id: 'I', text: '住院押金', selected: true}],
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
    if (!checkno(stno)) {
	    $.messager.popover({msg: '开始号码输入有误', type: 'info'});
        focusById('stno');
        return;
    }
    if (!checkno(endno)) {
	    $.messager.popover({msg: '结束号码输入有误', type: 'info'});
        focusById('endno');
        return;
    }
    if (parseInt(endno, 10) < parseInt(stno, 10)) {
	    $.messager.popover({msg: '结束号码不能小于开始号码', type: 'info'});
        return;
    }
    var gruser = getValueById('gruser');
    if (gruser == "") {
	    $.messager.popover({msg: '购入人不能为空', type: 'info'});
        return;
    }
    
    var title = getValueById('title');
    var type = getValueById('type');
    if (type == "") {
	    $.messager.popover({msg: '请选择类型', type: 'info'});
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
						reloadMenuPanel();
					});
					break;
				case "-505":
					$.messager.popover({msg: '不能重复购入押金收据', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '购入失败：' + rtn, type: 'error'});
				}
			});
		}
	});
}

/**
* 购入成功后重新获取新的发票号段
*/
function reloadMenuPanel() {
	$('#number').numberbox('clear');
	setValueById('endno', '');
	StartNo();            //购入成功后重新获取新的发票号段
	$('#Find').click();
}

function Delete_click() {
    var row = $HUI.datagrid("#tUDHCJFRcptBuy").getSelected();
	if (!row || !row.Tbuyrowid) {
		$.messager.popover({msg: '请选择要删除的记录', type: 'info'});
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
					$.messager.popover({msg: '此号段已使用，不能删除', type: 'info'});
					break;
				default:
					$.messager.popover({msg: '删除失败：' + rtn, type: 'error'});
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
		$.messager.popover({msg: '请先选择一行', type: 'info'});
        return;
	}
	var comment1 = row.Tcomment1;
    if (comment1 == "") {
	    $.messager.popover({msg: '所选的行不是恢复发放的类型', type: 'info'});
        return;
    }
    if (comment1 != "Return") {
	    $.messager.popover({msg: '该收据已经恢复发放过了', type: 'info'});
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
	    $.messager.popover({msg: '恢复发放失败：' + rtn, type: 'error'});
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