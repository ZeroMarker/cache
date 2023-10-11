/// UDHCJFOPInvNo.js

var guser, username;
var SelectRowId = "";
var RowId;
var flag;
var Tuserid = "";

$.extend($.fn.validatebox.defaults.rules, {
	integer: {    //У��Ǹ�����
	    validator: function(value) {
		    var reg = /^\d+$/;
		    return reg.test(value);
		},
		message: $g("����������")
	}
});

$(function () {
    init_Layout();
    flag = getValueById("flag");
    guser = session['LOGON.USERID'];
    username = $.m({ClassName: "User.SSUser", MethodName: "GetTranByDesc", Prop: "SSUSRName", Desc: session['LOGON.USERNAME'], LangId: session['LOGON.LANGID']}, false);
	setValueById("username", username);
	setValueById("userid", guser);

    $HUI.linkbutton('#Update', {
		onClick: function () {
			Update_click();
		}
	});
	
    $HUI.validatebox('#CurNo', {
	    validType: 'integer'
	});
	
	$HUI.combobox('#UserFlagS', {
		data: [{value: 'Y', text: $g('����'), selected: true},
       	 		{value: 'N', text: $g('������')},
        		{value: '', text: $g('����')}
        	  ],
        valueField: 'value',
        textField: 'text',
        editable: false
    });
});

function SelectRowHandler(index, rowData) {
    var selectrow = index + 1;
    if (!selectrow) {
        return;
    }
    if (SelectRowId != selectrow) {
        RowId = rowData.TRowId;
        var CurNo = rowData.TCurNo;
        var EndNo = rowData.TEndNo;
        var flag = rowData.TFlag;
        if (flag == $g("����")) {
            flag = "Y";
        } else if (flag == $g("����")) {
            flag = "";
        } else if (flag == $g("������")) {
            flag = "N";
        }
     	setValueById('UserFlagS', flag);
        setValueById('CurNo', CurNo);
        setValueById('EndNo', EndNo);
        SelectRowId = selectrow;
        Tuserid = rowData.Tuserid;
    } else {
	    RowId = "";
        setValueById('CurNo', '');
        setValueById('EndNo', '');
        //setValueById('UseFlag', '');
        SelectRowId = "";
        setValueById("username", username);
        setValueById("userid", guser);
    }
}

function Update_click() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return false;
	}
    var userid = getValueById('userid');
    if ((userid != Tuserid) && (Tuserid != "")) {
	    $.messager.popover({msg: "����Ա����ȷ���ܸ���", type: "info"});
        return;
    }
    var curno = getValueById('CurNo');
    var endno = getValueById('EndNo');
    if (curno == "") {
	    $.messager.popover({msg: "��ǰ��Ʊ�Ų���Ϊ��", type: "info"});
        return;
    }
    if (endno == "") {
	    $.messager.popover({msg: "������Ʊ�Ų���Ϊ��", type: "info"});
        return;
    }
    if (parseInt(curno, 10) > parseInt(endno, 10)) {
	    $.messager.popover({msg: "��ǰ��Ʊ�Ų��ܴ��ڽ�����Ʊ��", type: "info"});
        return;
    }
 	var flag = getValueById('UserFlagS');
    if (parseInt(curno, 10) == parseInt(endno, 10)) {
        flag = "N";
    }
	$.messager.confirm("ȷ��", "�Ƿ�ȷ���޸�?", function (r) {
		if (!r) {
			return;
		}
		var encmeth = getValueById('UpdateInvNo');
	    var rtn = cspRunServerMethod(encmeth, userid, RowId, curno, endno, flag);
	    if (rtn == 0) {
		    $.messager.popover({msg: "�޸ĳɹ�", type: "success"});
	        $("#Find").click();
	        return;
		}
		if (rtn == "GuserNull") {
		    $.messager.popover({msg: t['GuserNull'], type: "info"});
	        return;
	    }
	    if (rtn == "RowIdNull") {
		    $.messager.popover({msg: t['RowIdNull'], type: "info"});
	        return;
	    }
	    if (rtn == "CurNoNull") {
		    $.messager.popover({msg: t['CurNoNull'], type: "info"});
	        return;
	    }
	    if (rtn == "AlreadyUseUp") {
		    $.messager.popover({msg: t['AlreadyUseUp'], type: "info"});
	        return;
	    }
	    if (rtn == "StarLess") {
		    $.messager.popover({msg: t['StarLess'], type: "info"});
	        return;
	    }
	    if (rtn == "EndLess") {
		  	$.messager.popover({msg: t['EndLess'], type: "info"});
	        return;
	    }
	    if (rtn == "CurLess") {
		    $.messager.popover({msg: t['CurLess'], type: "info"});
	        return;
	    }
	    $.messager.popover({msg: "�޸�ʧ�ܣ�" + rtn, type: "info"});
	});
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    $('#cCurNo').parent().parent().css("width", "85px");
}