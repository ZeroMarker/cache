/// UDHCJFInvprtDeliver.js

var judgepass1 = 0;
var judgepass2 = 0;
var passstatus;

$(function() {
	init_Layout();

    passstatus = "1";

    var obj = document.getElementById('deliver');
    if (obj) {
        obj.onclick = deliver_Click;
    }
    var obj = document.getElementById("stdate1");
    obj.onkeydown = getstdate;
    if (obj.value == "") {
        getdate();
    }
    var obj = document.getElementById("enddate1");
    obj.onkeydown = getenddate;
    if (obj.value == "") {
        getdate();
    }
    var numobj = document.getElementById('delivernum');
    if (numobj) {
        numobj.onkeyup = celendno;
    }
    getStartflag();
    $("#Startno").attr("readOnly", true);
    $HUI.checkbox("#Startflag", {
        onCheckChange: function () {
            getStartflag();
        }
    });
});

function StartNo() {
    var beuserid = getValueById('Bezjuserid');
    var type = getValueById('type');
    if (beuserid == "") {
        return;
    }
    $.m({
		ClassName: "web.UDHCJFInvprt",
		MethodName: "Getkydeliver",
		guser: beuserid,
		type: type,
		hospId: session['LOGON.HOSPID']
	},function(rtn) {
		var myAry = rtn.split("^");
	    setValueById('Startno', myAry[0]);
	    setValueById('endno', myAry[1]);
		setValueById('kyendno', myAry[1]);
		setValueById('kyrowid', myAry[2]);
	});
}

function getdate() {
    var encmeth = getValueById('today');
    if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
    var enddate1 = document.getElementById('enddate1');
    var enddate = document.getElementById('enddate');
    var stdate1 = document.getElementById('stdate1');
    var stdate = document.getElementById('stdate');
    today = value;
    curdate = value;
    var curdate1 = value;
    var str = curdate.split("/");

    curdate = str[2] + "-" + str[1] + "-" + str[0];
    if (enddate1.value == "") {
        enddate1.value = curdate;
        enddate.value = curdate1;
    }
    if (stdate1.value == "") {
        stdate1.value = curdate;
        stdate.value = curdate1;
    }
    checkdate();
}

function checkdate() {
    var end1obj = document.getElementById('enddate1');
    var endobj = document.getElementById('enddate');
    var enddate1 = document.getElementById('enddate1').value;
    var stdate1 = document.getElementById('stdate1').value;

    if ((enddate1 != "") & (stdate1 != "")) {
        var date = enddate1.split("-");
        var date1 = stdate1.split("-");
        if (eval(date1[0]) > eval(date[0])) {
            end1obj.value = "";
            end1obj.value = "";
            DHCWeb_HISUIalert(t['07']);
            return;
        }
        if (eval(date1[1]) > eval(date[1])) {
            end1obj.value = "";
            end1obj.value = "";
            DHCWeb_HISUIalert(t['07']);
            return;
        }
        if (eval(date1[2]) > eval(date[2])) {
            end1obj.value = "";
            end1obj.value = "";
            DHCWeb_HISUIalert(t['07']);
            return;
        }
    }
}

function getstdate() {
    var key = websys_getKey(e);
    if (key == 13) {
        var mybirth = getValueById("stdate1");
        if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
            var obj = document.getElementById("stdate1");
            obj.className = 'clsInvalid';
            focusById("stdate1");
            return websys_cancel();
        } else {
            var obj = document.getElementById("stdate1");
            obj.className = 'clsvalid';
        }
        if ((mybirth.length == 8)) {
            var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
            setValueById("stdate1", mybirth);
        }
        var myrtn = DHCWeb_IsDate(mybirth, "-");
        if (!myrtn) {
            var obj = document.getElementById("stdate1");
            obj.className = 'clsInvalid';
            focusById("stdate1");
            return websys_cancel();
        } else {
            var obj = document.getElementById("stdate1");
            obj.className = 'clsvalid';
        }
        checkdate();
        var obj = document.getElementById("stdate1");
        var str1 = obj.value.split("-");
        var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
        var stdateobj = document.getElementById("stdate");
        stdateobj.value = str2;
        focusById('enddate1');
    }
}

function getenddate() {
    var key = websys_getKey(e);
    if (key == 13) {
        var mybirth = getValueById("enddate1");
        if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
            var obj = document.getElementById("enddate1");
            obj.className = 'clsInvalid';
            focusById("enddate1");
            return websys_cancel();
        } else {
            var obj = document.getElementById("enddate1");
            obj.className = 'clsvalid';
        }
        if ((mybirth.length == 8)) {
            var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
            setValueById("enddate1", mybirth);
        }
        var myrtn = DHCWeb_IsDate(mybirth, "-");
        if (!myrtn) {
            var obj = document.getElementById("enddate1");
            obj.className = 'clsInvalid';
            focusById("enddate1");
            return websys_cancel();
        } else {
            var obj = document.getElementById("enddate1");
            obj.className = 'clsvalid';
        }
        checkdate();
        var obj = document.getElementById("enddate1");
       	var str1 = obj.value.split("-");
        var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
        var enddateobj = document.getElementById("enddate");
        enddateobj.value = str2;

        focusById('query');
    }
}

function deliver_Click() {
    var Startflag = getValueById("Startflag");
    var startno = getValueById("Startno");
    var endno = getValueById("endno");
    var type = getValueById("type");
	var kyendno = getValueById("kyendno");
	var kyrowid = getValueById("kyrowid");

    //add by wangjian 2013-03-15
    if (Startflag) {
        var startno1 = getValueById('Startno1');
        if (!checkno(startno1)) {
            DHCWeb_HISUIalert("转交开始号码有误");
            focusById('endno');
            return false;
        }
        if (parseInt(startno1, 10) < parseInt(startno, 10)) {
            DHCWeb_HISUIalert("转交的开始号码不能小于当前开始号码");
            focusById('endno');
            return false;
        }
        if (parseInt(startno1, 10) > parseInt(endno, 10)) {
            DHCWeb_HISUIalert("转交的开始号码不能大于当前结束号码");
            focusById('endno');
            return false;
        }
        if (endno.length != startno1.length) {
            DHCWeb_HISUIalert("转交的开始号码长度不能小于当前结束号码");
            focusById('endno');
            return false;
        }
    }
    //end
    if (type == "") {
        DHCWeb_HISUIalert(t['01']);
        focusById('type');
        return false;
    }
    if ((startno == "") || (endno == "")) {
        DHCWeb_HISUIalert(t['02']);
        focusById('endno');
        return false;
    }
    if (!checkno(startno)) {
        DHCWeb_HISUIalert(t['05']);
        focusById('Startno');
        return false;
    }
    if (!checkno(endno)) {
        DHCWeb_HISUIalert(t['06']);
        focusById('endno');
        return false;
    }
    if (parseInt(kyendno, 10) < parseInt(endno, 10)) {
        DHCWeb_HISUIalert(t['16']);
        focusById('endno');
        return false;
    }
    if (parseInt(endno, 10) < parseInt(startno, 10)) {
        DHCWeb_HISUIalert(t['07']);
        focusById('endno');
        return false;
    }
    if (endno.length != startno.length) {
        DHCWeb_HISUIalert(t['08']);
        focusById('endno');
        return false;
    }
    var userid = getValueById('zjuserid');
    if (userid == "") {
        DHCWeb_HISUIalert(t['09']);
        focusById('deliveruser');
        return;
    }
    var beuserid = getValueById('Bezjuserid');
    if (beuserid == "") {
        DHCWeb_HISUIalert(t['19']);
        focusById('Bedeliveruser');
    }
    if (userid == beuserid) {
        DHCWeb_HISUIalert(t['15']);
        focusById('deliveruser');
        return;
    }
    if (passstatus == "1") {
        judgepass1 = 1;
        judgepass2 = 1;
    }
    if (passstatus == "0") {
        var pass1 = getValueById('passward1');
        var pass2 = getValueById('passward2');
        if (pass1 == "") {
            DHCWeb_HISUIalert(t['03']);
            focusById('passward1');
            return;
        }
        if (pass2 == "") {
            DHCWeb_HISUIalert(t['04']);
            focusById('passward2');
            return;
        }
        var strpwd = beuserid + "^" + pass1;
        var encmeth = getValueById('judgepwd');
        if (cspRunServerMethod(encmeth, 'judgepwd', '', strpwd) == '0') {};
        var strpwd1 = userid + "^" + pass2;
        var encmeth = getValueById('judgepwd1');
        if (cspRunServerMethod(encmeth, 'judgepwd1', '', strpwd1) == '0') {}
    }
    var tStartNo = startno;
    if ((judgepass1 == 1) && (judgepass2 == 1)) {
	    var guser = session['LOGON.USERID'];
        var str = "";
        if (Startflag) {
            tStartNo = startno1;
            str = "^" + startno1 + "^" + endno + "^" + userid + "^" + kyendno + "^" + kyrowid + "^" + type + "^" + beuserid + "^" + guser + "^1" + "^" + startno;
        } else {
            str = "^" + startno + "^" + endno + "^" + userid + "^" + kyendno + "^" + kyrowid + "^" + type + "^" + beuserid + "^" + guser + "^0" + "^" + startno;
        }
        $.messager.confirm("提示", t['10'] + "[ <font style='color:red'>" + tStartNo + "</font> ]" + t['11'] + "[ <font style='color:red'>" + endno + "</font> ]" + t['12'], function (r) {
            if (r) {
	            $.m({
					ClassName: "web.UDHCJFInvprt",
					MethodName: "deliverinv",
					str: str,
					hospId: session['LOGON.HOSPID']
				}, function(rtn) {
					switch(rtn) {
					case "0":
						$.messager.alert("提示", "转交成功", "success", function() {
							$("#query").click();
						});
						break;
					case "-100":
						DHCWeb_HISUIalert("不能重复转交,请刷新界面后重试");
						break;
					default:
						DHCWeb_HISUIalert("转交失败" + rtn);
					}
				});
            }
        });
    }
}

function judgepwd(value) {
    if (value == '100') {
        DHCWeb_HISUIalert(t['13']);
        focusById('passward1');
        judgepass1 = 0;
    } else {
        judgepass1 = 1;
    }
}

function judgepwd1(value) {
    if (value == '100') {
        DHCWeb_HISUIalert(t['14']);
        focusById('passward2');
        judgepass2 = 0;
    } else {
        judgepass2 = 1;
    }
}

function celendno() {
    var num = getValueById('delivernum');
    var sno = getValueById('Startno');

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

function getStartflag() {
    if (getValueById("Startflag")) {
	    $("#Startno1").attr("readOnly", false);
	    $("#delivernum").attr("readOnly", true);
    } else {
	    $("#Startno1").attr("readOnly", true);
	    $("#delivernum").attr("readOnly", false);
    }
	StartNo();
}

function init_Layout() {
    $('#cStartno').parent().parent().css("width", "71px");
    DHCWeb_ComponentLayout();
    
    //类型
    $("#type").combobox({
        panelHeight: 'auto',
		url: $URL + '?ClassName=web.UDHCJFInvprt&QueryName=FindInvType&ResultSetType=array',
		valueField: 'code',
		textField: 'text',
		editable: false,
		onChange: function(newValue, oldValue) {
			$("#Bedeliveruser, #deliveruser").combobox("clear").combobox("reload");
		}
    });
    
    //转交人
	$("#Bedeliveruser").combobox({
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
			setValueById("Bezjuserid", (newValue || ""));
			StartNo();
		}
    });
    
    //接收人
    $("#deliveruser").combobox({
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
			setValueById("zjuserid", (newValue || ""));
		}
    });
}