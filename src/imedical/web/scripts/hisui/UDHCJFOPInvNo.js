/// UDHCJFOPInvNo.js

var guser, username;
var SelectRowId = "";
var RowId;
var flag;
var Tuserid = "";

$.extend($.fn.validatebox.defaults.rules, {
	integer: {    //校验非负整数
	    validator: function(value) {
		    var reg = /^\d+$/;
		    return reg.test(value);
		},
		message: $g("请输入数字")
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
		data: [{value: 'Y', text: $g('可用'), selected: true},
       	 		{value: 'N', text: $g('已用完')},
        		{value: '', text: $g('待用')}
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
        if (flag == $g("可用")) {
            flag = "Y";
        } else if (flag == $g("待用")) {
            flag = "";
        } else if (flag == $g("已用完")) {
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
	    $.messager.popover({msg: "操作员不正确不能更新", type: "info"});
        return;
    }
    var curno = getValueById('CurNo');
    var endno = getValueById('EndNo');
    if (curno == "") {
	    $.messager.popover({msg: "当前发票号不能为空", type: "info"});
        return;
    }
    if (endno == "") {
	    $.messager.popover({msg: "结束发票号不能为空", type: "info"});
        return;
    }
    if (parseInt(curno, 10) > parseInt(endno, 10)) {
	    $.messager.popover({msg: "当前发票号不能大于结束发票号", type: "info"});
        return;
    }
 	var flag = getValueById('UserFlagS');
    if (parseInt(curno, 10) == parseInt(endno, 10)) {
        flag = "N";
    }
	$.messager.confirm("确认", "是否确认修改?", function (r) {
		if (!r) {
			return;
		}
		var encmeth = getValueById('UpdateInvNo');
	    var rtn = cspRunServerMethod(encmeth, userid, RowId, curno, endno, flag);
	    if (rtn == 0) {
		    $.messager.popover({msg: "修改成功", type: "success"});
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
	    $.messager.popover({msg: "修改失败：" + rtn, type: "info"});
	});
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    $('#cCurNo').parent().parent().css("width", "85px");
}