/// UDHCACParaSet.js

$(function () {
    init_Layout();
    if (!window.opener) {
        $("#Exit").linkbutton('disable');
    }
    LoadData();
    $HUI.linkbutton("#SaveButton", {
        onClick: function () {
            Save_Click();
        }
    });
});

function LoadData() {
    var encmeth = getValueById("ReadParaEncrypt");
    if (encmeth != "") {
        var rtnvalue = cspRunServerMethod(encmeth);
        ///CreatePWD_"^"_UsePWD_"^"_CardNoEffect_"^"_AccLeftPrint_"^"_
        ///PWDCount_"^"_EffectPaper_"^"_EffectBill_"^"_SQueryPWD
        var myary = rtnvalue.split("^");
        setCheckBoxDefaultVal("CreatePWD", parseInt(myary[0]));
        setCheckBoxDefaultVal("UsePWD", parseInt(myary[1]));
        setCheckBoxDefaultVal("CardNoEffect", parseInt(myary[2]));
        setCheckBoxDefaultVal("AccLeftPrint", parseInt(myary[3]));
        setValueById("PWDCount", parseInt(myary[4]));
        setCheckBoxDefaultVal("EffectPaper", parseInt(myary[5]));
        setCheckBoxDefaultVal("EffectBill", parseInt(myary[6]));
        setCheckBoxDefaultVal("SQueryPWD", parseInt(myary[7]));

        setValueById("SDateDiff", parseInt(myary[8]));
        setValueById("PWDDateDiff", parseInt(myary[9]));
        setCheckBoxDefaultVal("CardReqSuspend", parseInt(myary[10]));
        setCheckBoxDefaultVal("PWDEditReq", parseInt(myary[11]));
        setCheckBoxDefaultVal("PDAutoNo", parseInt(myary[12]));
        setCheckBoxDefaultVal("AccReCard", parseInt(myary[13]));
        setValueById("DepPrice", parseFloat(myary[14]));
    }
}

function Save_Click() {
    var mystr = BuildStr();
    var encmeth = getValueById("SaveParaEncrypt");
    if (encmeth != "") {
        var rtnValue = cspRunServerMethod(encmeth, mystr);
        if (rtnValue == 0) {
            $.messager.alert("提示", "保存成功！", "info");
        }
    }
}

function BuildStr() {
    var myary = new Array();
    myary[0] = getCheckBoxVal("CreatePWD");
    myary[1] = getCheckBoxVal("UsePWD");
    myary[2] = getCheckBoxVal("CardNoEffect");
    myary[3] = getCheckBoxVal("AccLeftPrint");
    myary[4] = getValueById("PWDCount");
    myary[5] = getCheckBoxVal("EffectPaper");
    myary[6] = getCheckBoxVal("EffectBill");
    myary[7] = getCheckBoxVal("SQueryPWD");
    myary[8] = getValueById("SDateDiff");
    myary[9] = getValueById("PWDDateDiff");
    myary[10] = getCheckBoxVal("CardReqSuspend");
    myary[11] = getCheckBoxVal("PWDEditReq");
    myary[12] = getCheckBoxVal("PDAutoNo");
    myary[13] = getCheckBoxVal("AccReCard");
    for (var i = 0; i < myary.length; i++) {
        if ((myary[i] == true) && (i != 4)) {
            myary[i] = 1;
        } else if ((myary[i] == false) && (i != 4) && (i != 8) && (i != 9)) {
            myary[i] = 0;
        }
    }
    myary[14] = getValueById("DepPrice");
    var myInfo = myary.join("!");
    return myInfo;
}

function init_Layout() {
    $('#PageContent').parent().css("padding", "0px"); // 贴边放
    $('#cPWDDateDiff').css("padding-right", "6px"); // 贴边放
    $('#cPWDCount').css("padding-right", "6px"); // 贴边放
    $('#cDepPrice').css("padding-right", "6px"); // 贴边放
    $('#cSDateDiff').css("padding-right", "6px"); // 贴边放
    $('.maincontent').parent().parent().parent().css({'margin-top':'40px', 'margin-left': '40px'});
    $('.maincontent>table').css("border-spacing", "0px 8px"); //行距
}

function setCheckBoxDefaultVal(id, val) {
    if (val == "1") {
        setValueById(id, true);
    } else {
        setValueById(id, false);
    }
}

function getCheckBoxVal(id) {
    if (getValueById(id)) {
        return 1;
    } else {
        return 0;
    }

}
