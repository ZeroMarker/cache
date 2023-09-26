/// UDHCJFOPInvNo.js

var guser, username;
var SelectRowId = "";
var RowId;
var flag;
var Tuserid;

$.extend($.fn.validatebox.defaults.rules, {
	integer: {    //校验非负整数
	    validator: function(value) {
		    var reg = /^\d+$/;
		    return reg.test(value);
		},
		message: "请输入数字"
	}
});

$(function () {
    init_Layout();
    flag = getValueById('flag');
    guser = session['LOGON.USERID'];
    username = session['LOGON.USERNAME'];
    
    $HUI.linkbutton('#Update', {
		onClick: function () {
			Update_click();
		}
	});
	
    usernameobj = document.getElementById("username");
    Tuserid = "";
    SelectRowId = "";
    if (usernameobj.value == "") {
        usernameobj.value = username;
        setValueById("userid", guser);
    }

    $HUI.validatebox('#CurNo', {
	    validType: 'integer'
	});
	
	$HUI.combobox('#UserFlagS', {
		data: [{id: 'Y', text: '可用', selected: true},
       	 		{id: 'N', text: '已用完'},
        		{id: '', text: '待用'}],
        valueField: 'id',
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
        if (flag == "可用") {
            flag = "Y";
        } else if (flag == "待用") {
            flag = "";
        } else if (flag == "已用完") {
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
        usernameobj.value = username;
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
        DHCWeb_HISUIalert(t['08']);
        return;
    }
    var curno = getValueById('CurNo');
    var endno = getValueById('EndNo');
    var flag = getValueById('UserFlagS');
    if (curno == "") {
        DHCWeb_HISUIalert(t['02']);
        return;
    }
    if (endno == "") {
        DHCWeb_HISUIalert(t['03']);
        return;
    }
    if (parseInt(curno, 10) > parseInt(endno, 10)) {
        DHCWeb_HISUIalert(t['04']);
        return;
    }
    /*
    if (eval(curno) > eval(endno)) {
    	DHCWeb_HISUIalert(t['04']);
    	return;
    }
	*/
    if (parseInt(curno, 10) == parseInt(endno, 10)) {
        flag = "N";
    }

    var encmeth = getValueById('UpdateInvNo');
    var retval = cspRunServerMethod(encmeth, userid, RowId, curno, endno, flag);
    if (retval == "GuserNull") {
        DHCWeb_HISUIalert(t['GuserNull']);
        return;
    } else if (retval == "RowIdNull") {
        DHCWeb_HISUIalert(t['RowIdNull']);
        return;
    } else if (retval == "CurNoNull") {
        DHCWeb_HISUIalert(t['CurNoNull']);
        return;
    } else if (retval == "AlreadyUseUp") {
        DHCWeb_HISUIalert(t['AlreadyUseUp']);
        return;
    } else if (retval == "StarLess") {
        DHCWeb_HISUIalert(t['StarLess']);
        return;
    } else if (retval == "EndLess") {
        DHCWeb_HISUIalert(t['EndLess']);
        return;
    } else if (retval == "CurLess") {
        DHCWeb_HISUIalert(t['CurLess']);
        return;
    } else if (retval != 0) {
        DHCWeb_HISUIalert(t['UpdateErr'])
        return;
    } else {
        DHCWeb_HISUIalert(t['UpdateSucc']);
        $("#Find").click();
    }
}

function init_Layout() {
    DHCWeb_ComponentLayout();
    $('#cCurNo').parent().parent().css("width", "85px");
}
