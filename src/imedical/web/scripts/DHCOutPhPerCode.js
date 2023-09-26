/// DHCOutPhPerCode
/// 门诊药房人员代码维护

var SelectedRow = 0;

function BodyLoadHandler() {
    var baddobj = document.getElementById("Badd");
    if (baddobj) baddobj.onclick = Badd_click;
    var obj = document.getElementById("Bupdate");
    if (obj) obj.onclick = Bupdate_click;
    var userid = document.getElementById("userid").value;
    var ctloc = document.getElementById("ctloc").value;
    combo_DeptList = dhtmlXComboFromStr("CLocDesc", "");
    combo_DeptList.enableFilteringMode(true);
    var encmeth = DHCC_GetElementData('getloc');
    var DeptStr = cspRunServerMethod(encmeth, userid)
    var Arr = DHCC_StrToArray(DeptStr);
    combo_DeptList.addOption(Arr);
    combo_User = dhtmlXComboFromStr("CUserName", "");
    combo_User.enableFilteringMode(true);
    var encmeth = DHCC_GetElementData('getuser');
    var DeptStr = cspRunServerMethod(encmeth, ctloc)
    var Arr = DHCC_StrToArray(DeptStr);
    combo_User.addOption(Arr);
    var obj = document.getElementById("CheckFlag")
    if (obj) obj.onclick = checkChecked;
    var obj = document.getElementById("CUseFlag")
    if (obj) obj.onclick = checkChecked;
    var obj = document.getElementById("CFyFlag")
    if (obj) obj.onclick = checkChecked;
    var obj = document.getElementById("CPyFlag")
    if (obj) obj.onclick = checkChecked;
}

function deplook(str) {
    var obj = document.getElementById('depid');
    var tem = str.split("^");
    obj.value = tem[1];
}

function SelectRowHandler() {
    var eSrc = window.event.srcElement;
    var objtbl = document.getElementById('tDHCOutPhPerCode');
    var rows = objtbl.rows.length;
    var lastrowindex = rows - 1;
    var rowObj = getRow(eSrc);
    var selectrow = rowObj.rowIndex;
    if (!selectrow) return;
    var obj = document.getElementById('CLocDesc');
    var obj1 = document.getElementById('CUserName');
    var obj2 = document.getElementById('CUserCode');
    var obj3 = document.getElementById('CPyFlag');
    var obj4 = document.getElementById('CFyFlag');
    var obj5 = document.getElementById('CUseFlag');
    var obj6 = document.getElementById('CUserid');
    var obj7 = document.getElementById('CPhpid');
    var obj8 = document.getElementById('CheckFlag');
    var SelRowObj = document.getElementById('TLocDescz' + selectrow);
    var SelRowObj1 = document.getElementById('TUserNamez' + selectrow);
    var SelRowObj2 = document.getElementById('TUserCodez' + selectrow);
    var SelRowObj3 = document.getElementById('TPyFlagz' + selectrow);
    var SelRowObj4 = document.getElementById('TFyFlagz' + selectrow);
    var SelRowObj5 = document.getElementById('TUseFlagz' + selectrow);
    var SelRowObj7 = document.getElementById('TPhpidz' + selectrow);
    var SelRowObj8 = document.getElementById('TCheckFlagz' + selectrow);
    obj.value = SelRowObj.innerText;
    combo_User.setComboText(SelRowObj1.innerText);
    obj2.value = SelRowObj2.innerText;
    document.getElementById('CPhpid').value = SelRowObj7.value;
    if (SelRowObj3.innerText == t['01']) {
        obj3.checked = true;
    } else {
        obj3.checked = false;
    }
    if (SelRowObj4.innerText == t['01']) {
        obj4.checked = true;
    } else {
        obj4.checked = false;
    }
    if (SelRowObj5.innerText == t['01']) {
        obj5.checked = true;
    } else {
        obj5.checked = false;
    }
    if (SelRowObj8.innerText == t['01']) {
        obj8.checked = true;
    } else {
        obj8.checked = false;
    }
    SelectedRow = selectrow;
}

function Bupdate_click() {
    selectrow = SelectedRow;
    var windesc = combo_User.getSelectedText()
    if (windesc == "") {
        alert(t['nouser']);
        return;
    }
    var userid = combo_User.getSelectedValue()
    var py = document.getElementById('CPyFlag').checked;
    var fy = document.getElementById('CFyFlag').checked;
    var ch = document.getElementById('CheckFlag').checked;
    var use = document.getElementById('CUseFlag').checked;
    var rowid = document.getElementById('CPhpid').value;
    py = (py == true) ? 1 : 0;
    fy = (fy == true) ? 1 : 0;
    use = (use == true) ? 1 : 0;
    ch = (ch == true) ? 1 : 0;
    var pid = document.getElementById('up');
    if (pid) { 
    	var encmeth = pid.value 
    } else { 
    	var encmeth = '' 
    };
    p2 = userid
    p3 = py;
    p4 = fy;
    p5 = rowid;
    p6 = use;
    if (cspRunServerMethod(encmeth, p5, p3, p4, p6, userid, ch) != '0') {
        alert(t['05']);
        return;
    }
    window.location.reload();
}

function GUserId(value) {
    var usercode = document.getElementById('CUserCode')
    var userid = document.getElementById('CUserid')
    var vstr = value
    var sstr = vstr.split("^")
    usercode.value = sstr[1]
    userid.value = sstr[2]
}

function Badd_click() {
    selectrow = SelectedRow;
    var loc = combo_DeptList.getSelectedValue();
    if (loc == "") {
        alert(t['03'])
        return;
    }
    var username = combo_User.getSelectedText();
    var userid = combo_User.getSelectedValue();

    if (username == "") {
        alert(t['04']);
        return;
    }
    var py = document.getElementById('CPyFlag').checked;
    var fy = document.getElementById('CFyFlag').checked;
    var use = document.getElementById('CUseFlag').checked;
    var ch = document.getElementById('CheckFlag').checked;
    py = (py == true) ? 1 : 0;
    fy = (fy == true) ? 1 : 0;
    use = (use == true) ? 1 : 0;
    ch = (ch == true) ? 1 : 0;
    var pid = document.getElementById('ins');
    if (pid) { var encmeth = pid.value } else { var encmeth = '' };
    p1 = loc;
    p2 = username
    p3 = userid
    p4 = py;
    p5 = fy;
    p6 = use;
    var retval = cspRunServerMethod(encmeth, p1, p2, p3, p4, p5, p6, ch)
    if (retval == "0") {
        window.location.reload();
    } else if (retval == -1) {
        alert("不能添加重复记录!")
    } else if (retval == -2) {
        alert("请在门诊药房科室科室维护中先维护选择的科室!");
    }

}

function SetPid(value) {
    if (value != "0") {
        alert(t['05']);
        return;
    }
}

function CleartDHCOPAdm() {
    var objtbl = document.getElementById('tDHCOPReturn');
    var rows = objtbl.rows.length;
    var lastrowindex = rows - 1;
    for (var j = 1; j < lastrowindex + 1; j++) {
        objtbl.deleteRow(1);
    }
}

function GetListSelectText(ListName) {
    var Val = "";
    var obj = document.getElementById(ListName);
    if (obj) {
        if (obj.selectedIndex != -1) {
            Val = obj.options[obj.selectedIndex].text
        };
    }
    return Val;
}

function GetListSelectVal(ListName) {
    var Val = "";
    var obj = document.getElementById(ListName);
    if (obj) {
        if (obj.selectedIndex != -1) {
            Val = obj.options[obj.selectedIndex].value
        };
    }
    return Val;
}

function SetComboValue(obj, val) {
    if (obj) {
        var ind = obj.getIndexByValue(val);
        if (ind == -1) {
            obj.setComboText("");
            return;
        }
        obj.selectOption(ind)
    }
}

function checkChecked() {
    var obj1 = document.getElementById("CheckFlag");
    var obj2 = document.getElementById("CUseFlag");
    var obj3 = document.getElementById("CFyFlag");
    var obj4 = document.getElementById("CPyFlag");
    if (obj2.checked) {
        obj3.checked = false;
        obj1.checked = false;
        obj4.checked = false;
    }
}
document.body.onload = BodyLoadHandler;