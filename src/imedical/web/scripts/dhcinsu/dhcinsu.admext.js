/**
* FillName: dhcinsu.admext.js
* Description: 异地改造
* Creator JinShuai1010
* Date: 2022-12-13
*/
// 定义常量  
var GV = {
    HospDr: session['LOGON.HOSPID'],  //院区ID
    USERID: session['LOGON.USERID'],  //操作员ID
    GROUPID: session['LOGON.GROUPID'], //安全组id
    OpterId: '',
    OpterDate: '',
    OpterTime: '',
    AdmDr: '',
    ExtID: '',
    Rq: INSUGetRequest()
}
//入口函数
$(function () {
    //1加载界面下拉列表
    InitCombobox();
    //2加载病人信息
    InitPatInfo();
    //3加载事件
    InitEvent();
});
//加载界面下拉列表
function InitCombobox() {
	var Options = {
        editable: 'Y',
        hospDr: GV.HospDr,
        defaultFlag: 'Y',
        DicOPIPFlag: "",
    }
    disableById("OpterID");
    disableById("Opter");
    disableById("OpterDate");
    disableById("OpterTime");
    GV.AdmDr = GV.Rq["AdmDr"];
    disableById("OpterID");
    INSULoadDicData("mdtrtgrptype",'mdtrt_grp_type00A',Options)                //就诊人群类型
    INSULoadDicData("trumflag", 'trum_flag00A', Options)                       //外伤标志
    INSULoadDicData("relttpflag",'rel_ttp_flag00A',Options)                    //涉及第三方标志
    INSULoadDicData("ipttype", 'ipt_type00A', Options)                         //住院类型
    INSULoadDicData("otperreflflag", 'otp_er_refl_flag00A',Options)            //门诊急诊转诊标志
    INSULoadDicData("erflag",'er_flag00A', Options)                            //急诊标志
    INSULoadDicData("neediptflag", 'need_ipt_flag00A',Options)                 //门诊转住院标志
    SetComboboxVisable("mdtrtgrptype","control_admext_display00A","mdtrt_grp_type00A")
    SetComboboxVisable("trumflag","control_admext_display00A","trum_flag00A")
    SetComboboxVisable("relttpflag","control_admext_display00A","rel_ttp_flag00A")
    SetComboboxVisable("ipttype","control_admext_display00A","ipt_type00A")
    SetComboboxVisable("otperreflflag","control_admext_display00A","otp_er_refl_flag00A")
    SetComboboxVisable("erflag","control_admext_display00A","er_flag00A")
    SetComboboxVisable("neediptflag","control_admext_display00A","need_ipt_flag00A")
}
//根据字典配置,设置元素是否显示
function SetComboboxVisable(objectId, Type,Code) {
        var PatType = tkMakeServerCall("web.DHCINSUAdmExtCtl", "GetTypeByAdmDr", GV.AdmDr);
        //获取control_admext_display00A医保字典中该元素的DicOPIPFlag
        var rtn = $cm({
        ClassName: "web.INSUDicDataCom",
        QueryName: "QueryDic",
        Type: Type,
        Code: Code,
        HospDr: GV.HospDr,
        ResultSetType: "array"
      }, false);
    //如果病人类型和医保字典中的配置不一样则对应元素不显示，  当医保字典的DicOPIPFlag为空，默认门诊住院都显示
    if(rtn[0].DicOPIPFlag!=""&&PatType!=rtn[0].DicOPIPFlag){
	    var objectIdTr = $("#" + objectId).parent().parent();
        objectIdTr.attr('style','display:none');
	    }
}
//加载病人信息
function InitPatInfo() {
    var MatnInfo = tkMakeServerCall("web.DHCINSUAdmExtCtl", "GetInfoByAdmDr", GV.AdmDr);
    if (MatnInfo == "^^^^^^^^^^^") {
        GV.AdmDr = GV.AdmDr
    } else {
        var MatnArr = MatnInfo.split("^");
        //alert(MatnInfo)
        setValueById('mdtrtgrptype', MatnArr[2]);
        setValueById('trumflag', MatnArr[5]);
        setValueById('relttpflag', MatnArr[6]);
        setValueById('ipttype', MatnArr[4]);
        setValueById('otperreflflag', MatnArr[3]);
        setValueById('OpterID', MatnArr[7]);
        var OPter = tkMakeServerCall("web.DHCINSUAdmExtCtl", "GetMessByOpterId", MatnArr[7]);
        setValueById('Opter', OPter);
        setValueById('OpterDate', MatnArr[8]);
        setValueById('OpterTime', MatnArr[9]);
        setValueById('erflag', MatnArr[10]);
        setValueById('neediptflag', MatnArr[11]);
        disableById("OpterID");
        disableById("Opter");
        disableById("OpterDate");
        disableById("OpterTime");
        GV.ExtID = MatnArr[0];
        GV.AdmDr = MatnArr[1]
    }
}
//初始化事件
function InitEvent() {
    $("#btnU").click(function () {
        Save()
        InitPatInfo()
    });
    $("#btnC").click(function () {
        websys_showModal('close');
    });
}
//保存信息
function Save() {
    var Instr = "";
    Instr = GV.ExtID + "^" + GV.AdmDr;
    var mdtrtgrptype = getValueById('mdtrtgrptype');
    var trumflag = getValueById('trumflag');
    var relttpflag = getValueById('relttpflag');
    var ipttype = getValueById('ipttype');
    var otperreflflag = getValueById('otperreflflag');
    Instr = Instr + "^" + mdtrtgrptype + "^" + otperreflflag + "^" + ipttype + "^" + trumflag + "^" + relttpflag;
    var today = new Date();
    var NowDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
    var NowTime = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
    var OpterID = GV.USERID
    Instr = Instr + "^" + OpterID + "^" + NowDate + "^" + NowTime
    var erflag = getValueById('erflag');
    var neediptflag = getValueById('neediptflag');
    Instr = Instr + "^" + erflag + "^" + neediptflag
    //alert(Instr)
    var rtn = tkMakeServerCall("web.DHCINSUAdmExtCtl", "Save", Instr, GV.USERID);
    if (rtn > 0) {
        $.messager.alert('提示', '保存成功');
    } else {
        $.messager.alert("提示", "保存失败!rtn=" + rtn, 'error');
    }
}

