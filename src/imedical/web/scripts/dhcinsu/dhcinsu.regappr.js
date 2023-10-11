///FileName: dhcinsu.regappr.js
///Anchor: 靳帅1010
///Creator: 2023-01-03
///Description: 医保住院审批
//入口函数
var GV = {
    UPDATEDATAID: '',
    HospDr: session['LOGON.HOSPID'],
    USERID: session['LOGON.USERID'],
    ADMDR: "",                         //病人就诊ID
    Flag: "",                          //申请状态
    Loc: "",                           //科室
    Ward: "",                          //护理单元
    ApprId: "",                        //审批前费别
    DiseApprComBox: ""
}
$(function () {

    //1 初始化界面
    SetPageLayout();
    //2 初始化元素事件   
    SetElementEvent();

});
// 初始化界面
function SetPageLayout() {
    //初始化下拉列表
    InitApprCombobox();
    //初始化datagrid
    InitApprdg();
}
// 初始化元素事件   
function SetElementEvent() {
    InsuDateDefault('SDate', -1);                            //设置默认日期
    InsuDateDefault('EDate');
    $("#RegNo").keydown(function (e) {                       //登记号回车查询事件
        PatientNo_onKeydown(e);
    });
    $("#IPRecordNo").keydown(function (e) {                  //住院号回车查询事件
        MedicareNo_onkeydown(e);
    });
    $("#AdmNo").keydown(function (e) {                  //卡号回车查询事件
        AdmNo_onkeydown(e);
    });
    $("#BtnSearch").click(RegApprQuery);                     // 查询                     
    $("#BtnPass").click(BtnPass);                            // 医保通过
    $("#BtnInsuWait").click(BtnInsuWait);                    // 置状态为待审批事件
    $("#BtnRefuse").click(BtnRefuse);                        // 医保拒绝
    $("#BtnClean").click(BtnClean);                          // 清屏
    $("#BtnInsuAdd").click(BtnInsuAdd);                      // 医保新增并通过
    $("#BtnUpPicture").click(BtnUpPicture);                  // 上传资料
}
//初始化下拉列表
function InitApprCombobox() {
    //初始化就诊
    InitAdmLst();
    var Options = {
        editable: 'Y',
        hospDr: GV.HospDr,
        defaultFlag: 'N'
    }
    var defaultOptions = {
        editable: 'Y',
        hospDr: GV.HospDr,
        defaultFlag: 'Y'
    }
    INSULoadDicData("AppType", 'app_type00A', defaultOptions);                //加载字典：申请类型
    INSULoadDicData("MedType", 'med_type00A', defaultOptions);                //加载字典：医疗类别
    INSULoadDicData("MatnType", 'matn_type00A', Options);                     //加载字典：生育类别
    INSULoadDicData("BirCtrlType", 'birctrl_type00A', Options);               //加载字典：计划生育手术类别
    //INSULoadDicData("DiseApprType", 'dise_appr_type00A', Options);            
    INSULoadDicData("ApprStats", 'appr_stas00A', Options);                    //加载字典：审批状态选项
    initDiseApprType();                                                       //加载字典：病种审批选项
    initChkedReaId();
    initApprReaId();
    $("#AppType").combobox({
        onSelect: function (record) {
            SetComBoxUnEdit(record.cCode);                                   //选中申请类型后非必要信息不可编辑                    
        }
    });
}
//初始化病种审批选项
function initDiseApprType() {

    GV.DiseApprComBox = $HUI.combobox("#DiseApprType", {
        url: $URL,
        valueField: 'cCode',
        textField: 'cDesc',
        rowStyle: 'checkbox', //显示成勾选行形式
        panelHeight: 'auto',
        editable: false,
        multiple: true,
        onBeforeLoad: function (param) {
            param.ClassName = 'web.INSUDicDataCom';
            param.QueryName = 'QueryDic1';
            param.Type = 'dise_appr_type00A';
            param.HospDr = GV.HospDr;
            param.ResultSetType = 'array';
            return true;
        },
        onSelect: function (rec) {
            //当选择病种审批理由有其他时。设置备注必填
            if (rec.cCode == "7") {
                $('#MemoText').attr("class", "clsRequired");
            }
        },
        onUnselect: function (rec) {
            //当选择病种审批理由取消其他时。设置备注非必填
            if (rec.cCode == "7") {
                $('#MemoText').attr("class", "");
            }
        },
        onAllSelectClick: function (e) {
            //当全选时。设置备注必填
            if ($(this).combobox("getValues") != "") {
                $('#MemoText').attr("class", "clsRequired");
            }
            else {
                $('#MemoText').attr("class", "");
            }
        }
    });

}
//初始化费别
function initChkedReaId() {
    $HUI.combobox("#ChkedReaId", {
        method: 'GET',
        url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpAdmReason&ResultSetType=array',
        valueField: 'id',
        textField: 'text',
        blurValidValue: true,
        defaultFilter: 5,
        onBeforeLoad: function (param) {
            param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
            param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
        },
        onSelect: function (rec) {

        }
    });
}
//初始化审批后费别
function initApprReaId() {
    $HUI.combobox("#ApprReaId", {
        method: 'GET',
        url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpAdmReason&ResultSetType=array',
        valueField: 'id',
        textField: 'text',
        blurValidValue: true,
        defaultFilter: 5,
        onBeforeLoad: function (param) {
            param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
            param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
        },
        onSelect: function (rec) {

        }
    });
}
//初始化审批记录datagrid
function InitApprdg() {
    $('#Apprdg').datagrid({
        fit: true,
        iconCls: 'icon-save',
        rownumbers: true,
        border: false,
        toolbar: tToolBar,
        singleSelect: true,
        fitColumns: false,
        pagination: true,
        autoRowHeight: false,
        pageSize: 20,
        columns: [[
            { field: 'RegID', title: 'Rowid', width: 60, hidden: true },
            { field: 'ADMDR', title: 'ADMDR', width: 60, hidden: true },
            { field: 'Regno', title: 'Regno', width: 60, hidden: true },
            {
                field: 'VisitStatus', title: '在院状态', width: 80, styler: function (val, index, rowData) {
                    switch (val) {
                        case "出院":
                            return "background-color:red";
                            break;
                    }
                }
            },     //upt 20230407 JinS1010
            { field: 'ApprStas', title: '审批结果', width: 80 },
            { field: 'IPRegNo', title: '住院号', width: 60 },
            { field: 'AppType', title: '申请类型', width: 80 },
            { field: 'AppTypeCode', title: '申请类型代码', width: 60, hidden: true },
            { field: 'AppNo', title: '申请流水号', width: 60, hidden: true },
            { field: 'IfReg', title: '已登记', width: 60 },
            { field: 'IfAcct', title: '已结算', width: 60 },
            { field: 'Name', title: '姓名', width: 60 },
            { field: 'Sex', title: '性别', width: 60 },
            { field: 'Age', title: '年龄', width: 60 },
            { field: 'LocDr', title: '住院科室', width: 100 },
            { field: 'Ward', title: '住院护理单元', width: 140 },
            { field: 'ApprReaId', title: '费别', width: 140 },
            { field: 'ApprReaIdCode', title: '费别代码', width: 65, hidden: true },
            { field: 'ChkedReaId', title: '修改后费别', width: 140 },
            { field: 'ChkedReaIdCode', title: '修改后费别代码', width: 90, hidden: true },
            { field: 'AppMemo', title: '申请备注', width: 160 },
            { field: 'Memo', title: '审批备注', width: 160 },
            { field: 'MedType', title: '医疗类别', width: 80 },
            { field: 'MedTypeCode', title: '医疗类别代码', width: 80, hidden: true },
            { field: 'MatnType', title: '生育类别', width: 80 },
            { field: 'MatnTypeCode', title: '生育类别代码', width: 80, hidden: true },
            { field: 'BirCtrlType', title: '计划生育手术类别', width: 160 },
            { field: 'BirCtrlTypeCode', title: '计划生育手术类别代码', width: 160, hidden: true },
            { field: 'AppyReasondesc', title: '病种审批理由', width: 160 },
            { field: 'AppyReasonCode', title: '病种审批选项代码', width: 160, hidden: true },
            {
                field: 'IllHistory', title: '病例查看', width: 80,
                formatter: function (value, row, index) {
                    var htmlStr = "<a title='点击查看' style='text-decoration: underline;color:#0000CC'>" + "查看病历" + "&nbsp;&gt;&gt;" + "</a>";
                    return htmlStr;
                }
            },
            {
                field: 'UpFile', title: '上传文件查看', width: 150,
                formatter: function (value, row, index) {
                    var htmlStr = "<a title='点击查看' style='text-decoration: underline;color:#0000CC'>" + "查看资料" + "&nbsp;&gt;&gt;" + "</a>";
                    return htmlStr;
                }
            },
            { field: 'FileSize', title: '文件大小', width: 80, hidden: true },
            { field: 'FileExtType', title: '数据格式', width: 100, hidden: true },
            { field: 'UpdateUser', title: '上传人', width: 100, hidden: true },
            { field: 'UpdateDate', title: '上传日期', width: 135, hidden: true },
            { field: 'FileWebPath', title: '文件路径', width: 400, hidden: true },
            { field: 'ID', title: 'ID', width: 80, hidden: true },
            { field: 'ApprStasCode', title: '审批结果代码', width: 80, hidden: true },
            { field: 'Apprer', title: '审批人', width: 60 },
            { field: 'ApprDate', title: '审批时间', width: 160 },
            { field: 'ApprRole', title: '申请角色', width: 60, hidden: true },
            { field: 'ApprerId', title: '审批人Id', width: 60, hidden: true },
            { field: 'Appyer', title: '申请人', width: 80 },
            { field: 'AppyDate', title: '申请时间', width: 160 },
            { field: 'AppyerId', title: '申请人Id', width: 80, hidden: true }
        ]],
        onClickCell: function (rowIndex, field, value) {
            if (field == "UpFile") {
                ViewPic(rowIndex);
            }
            if (field == "IllHistory") {
                ViewCases(rowIndex)
            }
        },
        onSelect: function (rowIndex, rowData) {
            onSelectInfo();
            QryAdmLst();
        },
    });
}

//病种,生育对应下拉列表不可编辑函数
function SetComBoxUnEdit(apptype) {
    //当入参为1时为病种审批。 生育审批相关下拉列表不可编辑
    if (apptype == "1") {
        disableById("MatnType");
        disableById("BirCtrlType");
        enableById("DiseApprType");
        GV.DiseApprComBox.setValues("")
        setValueById("MatnType", "");
        setValueById("BirCtrlType", "");
        $('#DiseApprTypeText').attr("class", "clsRequired");
        $('#BirCtrlTypeText').attr("class", "");
        $('#MatnTypeText').attr("class", "");
        return;
    }
    //当入参为2时为生育审批。 病种审批相关下拉列表不可编辑
    if (apptype == "2") {
        enableById("BirCtrlType");
        enableById("MatnType");
        disableById("DiseApprType");
        setValueById("DiseApprType", "");
        $('#MemoText').attr("class", "");
        $('#BirCtrlTypeText').attr("class", "clsRequired");
        $('#MatnTypeText').attr("class", "clsRequired");
        $('#DiseApprTypeText').attr("class", "");
        $('#Memo').css("width", "942px");
        return;
    }
    else {
        enableById("BirCtrlType");
        enableById("MatnType");
        enableById("DiseApprType");
        GV.DiseApprComBox.setValues("");
        setValueById("MatnType", "");
        setValueById("BirCtrlType", "");
        $('#BirCtrlTypeText').attr("class", "clsRequired");
        $('#MatnTypeText').attr("class", "clsRequired");
        $('#DiseApprTypeText').attr("class", "clsRequired");
        $('#Memo').css("width", "950px");
    }
}
//查询医保住院审批
function RegApprQuery() {

    var QueryParam = {
        ClassName: "web.DHCINSURegAppr",
        QueryName: 'GetRegApprInfo',
        RegNo: getValueById("RegNo"),
        IPRecordNo: getValueById("IPRecordNo"),
        SDate: getValueById("SDate"),
        EDate: getValueById("EDate"),
        AdmDr: GV.ADMDR,
        ApprStats: getValueById("ApprStats"),
        Hosptal: GV.HospDr
    }
    loadDataGridStore('Apprdg', QueryParam);
}
//初始化就诊记录函数
function InitAdmLst() {
    $('#AdmList').combogrid({
        panelWidth: 780,
        method: 'GET',
        idField: 'AdmDr',
        textField: 'AdmNo',
        columns: [[
            { field: 'AdmDr', title: 'AdmDr', width: 60 },
            { field: 'AdmNo', title: '就诊号', width: 120 },
            { field: 'DepDesc', title: '就诊科室', width: 160 },
            { field: 'AdmDate', title: '就诊日期', width: 100 },
            { field: 'AdmTime', title: '就诊时间', width: 100 },
            { field: 'VisitStatus', title: '就诊状态', width: 120 },
            { field: 'AdmReasonDesc', title: '就诊费别', width: 120 },
        ]],
        onClickRow: function (rowIndex, rowData) {
            var AdmLstVal = rowData.AdmNo + "-" + rowData.DepDesc + "-" + rowData.AdmDate + " " + rowData.AdmTime + "-" + rowData.VisitStatus + "-" + rowData.AdmReasonDesc
            $('#AdmList').combogrid("setValue", AdmLstVal);
            GV.ADMDR = rowData.AdmDr;
            RegApprQuery();                              //选中就诊记录，查询当前就诊的审批记录
        },
        onLoadSuccess: function (data) {
            if (data.total < 0) {
                return;
            }
            if (data.total == 0) {
                $.messager.alert("提示", "没有查询到病人就诊记录,请先确认患者是否护士分床!", 'info');
                return;
            }
            else {
                var indexed = -1
                var Flag = 0
                for (var i in data.rows) {
                    if (data.rows.hasOwnProperty(i)) {
                        if (GV.ADMDR == data.rows[i].AdmDr) {
                            indexed = i;
                            Flag = 1;
                            break;
                        }
                        if ((data.rows[i].VisitStatus == "在院") && (GV.ADMDR == "")) {
                            indexed = i;
                            Flag = 1;
                            break;
                        }
                    }
                    indexed = 0;
                }
                if (indexed >= 0) {
                    var rowData = data.rows[indexed]
                    $('#AdmList').combogrid("setValue", rowData.AdmNo + "-" + rowData.DepDesc + "-" + rowData.AdmDate + " " + rowData.AdmTime + "-" + rowData.VisitStatus + "-" + rowData.AdmReasonDesc)
                    GV.ADMDR = rowData.AdmDr;
                    loc = rowData.DepDesc;
                    setValueById('ApprReaId', rowData.AdmReasonDesc);
                    disableById("ApprReaId");
                }
            }
        }
    });
}
//加载就诊记录
function QryAdmLst() {
    var tURL = $URL + "?ClassName=" + 'web.DHCINSUIPReg' + "&MethodName=" + "GetPaAdmListByPatNoIPReg" + "&PapmiNo=" + getValueById('RegNo') + "&itmjs=" + "HUIToJson" + "&itmjsex=" + "" + "&HospDr=" + GV.HospDr
    $('#AdmList').combogrid({ url: tURL });
}
///获取病人基本信息函数
function GetPatInfo() {
    var tmpPapmiNo = $('#RegNo').val();
    if (tmpPapmiNo == "") {
        $.messager.alert("提示", "登记号不能为空!", 'info');
        return;
    }
    var PapmiNoLength = 10 - tmpPapmiNo.length;     //登记号补零   	
    for (var i = 0; i < PapmiNoLength; i++) {
        tmpPapmiNo = "0" + tmpPapmiNo;
    }
    PapmiNo = tmpPapmiNo;
    setValueById('RegNo', PapmiNo);              //登记号补全后回写

    //判断登记号是否存在有效卡,如果无有效卡则给出提示
    var CardNoStr = $.cm({
        ClassName: "web.DHCOPAdmReg",
        MethodName: "GetCardNoByPatientNo",
        dataType: "text",
        PatientNo: PapmiNo,
        HospId: GV.HospDr
    }, false);
    var CardNo = CardNoStr.split("^")[0];
    if (CardNo == "") {
        var PatientID = CardNoStr.split("^")[3];
        if (PatientID == "") {
            $.messager.alert("提示", PatientNo + " 该登记号无对应患者!", "info", function () {
                setValueById('RegNo', "");
            })
            return;
        }
    }
    var rtn = "";
    rtn = tkMakeServerCall("web.DHCINSUIPReg", "GetPatInfoByPatNo", "", "", PapmiNo, GV.HospDr);
    if (typeof rtn != "string") {
        return;
    }
    if (rtn.split("!")[0] != "1") {
        setTimeout(function () { $.messager.alert('提示', '取基本信息失败,请输入正确的登记号!', 'error') }, 200);
        return;
    }
    else {
        aData = rtn.split("^");
        QryAdmLst();
        setValueById('IPRecordNo', aData[14]);       //住院号
        setValueById('AdmNo', CardNo);
    }
}
//登记号回车函数
function PatientNo_onKeydown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        GetPatInfo();
        setTimeout(function () { RegApprQuery(); }, 200);
        SetComBoxUnEdit("1");                        //默认病种审批的相关下拉列表
    }
}
//住院号回车函数	
function MedicareNo_onkeydown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        var PatNo = ""
        PatNo = tkMakeServerCall("web.DHCINSUIPReg", "GetPatNoByMrNo", getValueById('IPRecordNo'), "I", GV.HospDr);
        if (PatNo != "") {
            setValueById('RegNo', PatNo);
            GetPatInfo();
            setTimeout(function () { RegApprQuery(); }, 200);
        }
    }
}

//卡号回车函数	 upt 2023/2/21 JinS1010 
function AdmNo_onkeydown(e) {
    var key = websys_getKey(e);
    if (key == 13) {
        var AdmNo = getValueById("AdmNo")
        if (AdmNo == "") return false;
        var myrtn = DHCACC_GetAccInfo("", AdmNo, "", "", "CardNoKeyDownCallBack");
        return false;
    }
}
function CardNoKeyDownCallBack(myrtn) {
    var myary = myrtn.split("^");
    var rtn = myary[0];
    switch (rtn) {
        case "-201": //卡有效有帐户
            var AdmNo = myary[1];
            setValueById('AdmNo', AdmNo);
            setValueById('RegNo', myary[5]);
            GetPatInfo();
            setTimeout(function () { RegApprQuery(); }, 200);
            break;
        case "-200": //卡无效

            $.messager.alert("温馨提示", "-200卡无效!", 'info');
            BtnClean();
            break;
        case "0": //卡有效无帐户
            var AdmNo = myary[1];
            setValueById('AdmNo', AdmNo);
            setValueById('RegNo', myary[5]);
            GetPatInfo();
            setTimeout(function () { RegApprQuery(); }, 200);
            break;
        default:
    }
}


//审批通过
function BtnPass() {
    var InsertStr = "";
    var AppType = "";
    var ApprReaId = "";
    var selected = $('#Apprdg').datagrid('getSelected');
    var DiseApprTypeStr = GV.DiseApprComBox.getValues().toString();
    //当没有选中或者选中的是非提交状态，进行提示
    if (!selected || selected.ApprStasCode == "1") {
        $.messager.alert("温馨提示", "未选中一条记录或选择的记录已经审批通过!", 'info');
        return;
    }

    //获取病人信息来进行判断是否进行医保登记 2023/03/15 upt JinS1010	
    var rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", selected.ADMDR);
    rtn = rtn.split("^");
    //提示：获取病人信息失败 
    if (rtn[0] < 0) {
        $.messager.alert("温馨提示", "人员信息为空！", 'info');
        return;
    }
    var IsReg = rtn[1]
    //当医保登记后，不能进行审批通过。进行弹窗提示 2023/03/15 upt JinS1010
    if (IsReg == "是") {
        $.messager.alert("温馨提示", "该人员已经进行医保登记，不能审批通过！", 'info');
        return;
    }

    var AppyDate = selected.AppyDate.split(" ");
    if (getValueById("MedType") == "") {
        $.messager.alert("温馨提示", "医疗类别不能为空!", 'info');
        return;
    }
    //病种提示，当申请类型为病种审批时
    if (selected.AppTypeCode == "1") {
        if (getValueById("DiseApprType") == "") {
            $.messager.alert("温馨提示", "病种审批选项不能为空!", 'info');
            return;
        }
        //当病种审批选项选择"其他"时，备注不能为空
        if (DiseApprTypeStr.indexOf("7") != -1 && getValueById("Memo") == "") {

            $.messager.alert("温馨提示", "当病种审批选项有其他时，备注不能为空!", 'info');
            return;
        }
    }
    //生育提示，当申请类型为生育审批时
    if (selected.AppTypeCode == "2") {
        if (getValueById("MatnType") == "") {
            $.messager.alert("温馨提示", "生育类别不能为空!", 'info');
            return;
        }
        if (getValueById("BirCtrlType") == "") {
            $.messager.alert("温馨提示", "计划生育手术类别不能为空!", 'info');
            return;
        }
    }
    InsertStr = "^" + selected.ADMDR + "^" + selected.Regno + "^" + selected.IPRegNo + "^" + selected.AppTypeCode + "^" + selected.AppNo + "^" +
        selected.LocDr + "^" + selected.Ward + "^" + selected.ApprReaIdCode + "^" + getValueById("ChkedReaId") + "^" + getValueById("MedType") + "^"
        + getValueById("MatnType") + "^" + getValueById("BirCtrlType") + "^" + DiseApprTypeStr + "^" + getValueById("Memo") + "^" +
        "2" + "^" + "1" + "^" + "" + "^" + "" + "^" + GV.USERID + "^" + AppyDate[0] + "^" + AppyDate[1] + "^" + selected.AppyerId + "^" + GV.HospDr
    //调用审批通过后台函数
    $m({                                                                                //调用审批通过后台函数
        ClassName: "web.DHCINSURegAppr",
        MethodName: "Update",
        InString: InsertStr
    }, function (txtData) {
        if (txtData > 0) {
            $.messager.popover({
                msg: '审批成功',
                type: 'success'
            });
            RegApprQuery();
        }
        else {
            $.messager.popover({
                msg: '审批失败',
                type: 'error'
            });
        }
    });
}
//审批拒绝
function BtnRefuse() {
    var InsertStr = "";
    var AppType = "";
    var ApprReaId = "";
    var selected = $('#Apprdg').datagrid('getSelected');
    var DiseApprTypeStr = GV.DiseApprComBox.getValues().toString();
    //当没有选中一条记录，进行提示
    if (!selected || selected.ApprStasCode == "2") {
        $.messager.alert("温馨提示", "请选择一条提交状态或申请通过记录!", 'info');
        return;
    }
    //获取病人信息来进行判断是否进行医保登记 2023/02/11 upt JinS1010	
    var rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", selected.ADMDR);
    rtn = rtn.split("^");
    //提示：获取病人信息失败 
    if (rtn[0] < 0) {
        $.messager.alert("温馨提示", "人员信息为空！", 'info');
        return;
    }
    var IsReg = rtn[1]      //是否医保登记
    //当医保登记后，不能进行审批拒绝。进行弹窗提示 2023/02/11 upt JinS1010
    if (IsReg == "是") {
        $.messager.alert("温馨提示", "该人员已经进行医保登记，不能审批拒绝！", 'info');
        return;
    }

    var AppyDate = selected.AppyDate.split(" ")
    InsertStr = "^" + selected.ADMDR + "^" + selected.Regno + "^" + selected.IPRegNo + "^" + selected.AppTypeCode + "^" + selected.AppNo + "^" +
        selected.LocDr + "^" + selected.Ward + "^" + selected.ApprReaIdCode + "^" + selected.ApprReaIdCode + "^" + getValueById("MedType") + "^"
        + getValueById("MatnType") + "^" + getValueById("BirCtrlType") + "^" + DiseApprTypeStr + "^" + getValueById("Memo") + "^" +
        "2" + "^" + "2" + "^" + "" + "^" + "" + "^" + GV.USERID + "^" + AppyDate[0] + "^" + AppyDate[1] + "^" + selected.AppyerId + "^" + GV.HospDr
    //调用审批拒绝后台函数
    $m({
        ClassName: "web.DHCINSURegAppr",
        MethodName: "Update",
        InString: InsertStr
    }, function (txtData) {
        if (txtData > 0) {
            $.messager.popover({
                msg: '审批拒绝成功',
                type: 'success'
            });
            RegApprQuery();
        }
        else {
            $.messager.popover({
                msg: '审批拒绝失败',
                type: 'error'
            });
        }
    });
}
//医保申请通过
function BtnInsuAdd() {
    var selected = $('#Apprdg').datagrid('getSelected');
    var AdmDr = ""
    if (GV.ADMDR == "" && !selected) {
        $.messager.alert("提示", "请选择一条需要新增的记录，或填写就诊信息！", 'info')
        return;
    }
    var DiseApprTypeStr = GV.DiseApprComBox.getValues().toString();
    /*
    if(GV.ADMDR!=""){
        AdmDr=GV.ADMDR;
        }
    else{
        AdmDr=selected.ADMDR ;
        }
        
   rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", AdmDr);          //获取病人信息
   rtn = rtn.split("^");
//提示：获取病人信息失败 
if (rtn[0] < 0) {
    $.messager.alert("温馨提示", "人员信息为空，不能申请!", 'info');
    return;
}
GV.ApprId = rtn[12];                                                        //审批前
var ApprStas = rtn[10]
//当审批结果为提交状态或审批通过时，不能申请
if (ApprStas == "0" || ApprStas == "1") {
    $.messager.alert("温馨提示", "当前存在提交状态或者审批通过记录,不能新增审批通过!", 'info');
    return;
}
var IsReg = rtn[1]      
//当医保登记后，不能进行审批通过。进行弹窗提示 2023/03/15 upt JinS1010
if (IsReg == "是") {
    $.messager.alert("温馨提示", "该人员已经进行医保登记，不能新增审批通过！", 'info');
    return;
}	  
var url = "dhcinsu.regappradd.csp?&AdmDr="+AdmDr+"&ApprId="+ GV.ApprId	
websys_showModal({
    url: url,
    title: "医保住院新增审批通过",
    iconCls: "icon-w-add",	
    width: "800",
    height: "320",		
    onClose: function () {
    	
    }
});
	
  */
    var InsertStr = ""
    rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", GV.ADMDR);          //获取病人信息

    rtn = rtn.split("^");
    //提示：获取病人信息失败 
    if (rtn[0] < 0) {
        $.messager.alert("温馨提示", "人员信息为空，不能申请!", 'info');
        return;
    }
    GV.Ward = rtn[9];
    GV.Loc = rtn[7];
    GV.ApprId = rtn[12];                                                        //审批前
    var ApprStas = rtn[10]
    //当审批结果为提交状态或审批通过时，不能申请
    if (ApprStas == "0" || ApprStas == "1") {
        $.messager.alert("温馨提示", "当前存在提交状态或者审批通过记录,不能申请!", 'info');
        return;
    }
    if (getValueById("AppType") == "") {
        $.messager.alert("温馨提示", "申请类型不能为空!", 'info');
        return;
    }
    if (getValueById("MedType") == "") {
        $.messager.alert("温馨提示", "医疗类别不能为空!", 'info');
        return;
    }
    //当申请类型为病种审批时，进行必填提示
    if (getValueById("AppType") == "1") {
        if (getValueById("DiseApprType") == "") {
            $.messager.alert("温馨提示", "病种审批选项不能为空!", 'info');
            return;
        }
        //当病种审批选项选择"其他"时，备注不能为空
        if (DiseApprTypeStr.indexOf("7") != -1 && getValueById("Memo") == "") {

            $.messager.alert("温馨提示", "当病种审批选项有其他时，备注不能为空!", 'info');
            return;
        }
    }
    //当申请类型为生育审批时，进行必填提示
    if (getValueById("AppType") == "2") {
        if (getValueById("MatnType") == "") {
            $.messager.alert("温馨提示", "生育类别不能为空!", 'info');
            return;
        }
        if (getValueById("BirCtrlType") == "") {
            $.messager.alert("温馨提示", "计划生育手术类别不能为空!", 'info');
            return;
        }
    }

    InsertStr = "^" + GV.ADMDR + "^" + getValueById("RegNo") + "^" + getValueById("IPRecordNo") + "^" + getValueById("AppType") + "^" + "" + "^" +
        GV.Loc + "^" + GV.Ward + "^" + GV.ApprId + "^" + getValueById("ChkedReaId") + "^" + getValueById("MedType") + "^"
        + getValueById("MatnType") + "^" + getValueById("BirCtrlType") + "^" + DiseApprTypeStr + "^" + getValueById("Memo") + "^" +
        "2" + "^" + "1" + "^" + "" + "^" + "" + "^" + GV.USERID + "^" + "" + "^" + "" + "^" + "" + "^" + GV.HospDr
    //调用审批通过后台函数
    $m({
        ClassName: "web.DHCINSURegAppr",
        MethodName: "Update",
        InString: InsertStr
    }, function (txtData) {
        if (txtData > 0) {
            $.messager.popover({
                msg: '新增审批成功',
                type: 'success'
            });
            RegApprQuery();
        }
        else {
            $.messager.popover({
                msg: '新增审批失败',
                type: 'error'
            });
        }
    });

}
//upt 20230406 JinS1010  置状态为待审批状态。等待医保办审批回复
function BtnInsuWait() {
    var InsertStr = "";
    var AppType = "";
    var ApprReaId = "";
    var selected = $('#Apprdg').datagrid('getSelected');
    var DiseApprTypeStr = GV.DiseApprComBox.getValues().toString();
    //当没有选中或者选中的是非提交状态，进行提示
    if (!selected || selected.ApprStasCode != "0") {
        $.messager.alert("温馨提示", "请选择一条提交状态记录!", 'info');
        return;
    }

    //获取病人信息来进行判断是否进行医保登记 2023/03/15 upt JinS1010	
    var rtn = tkMakeServerCall("web.DHCINSURegAppr", "GetPatientInfo", selected.ADMDR);
    rtn = rtn.split("^");
    //提示：获取病人信息失败 
    if (rtn[0] < 0) {
        $.messager.alert("温馨提示", "人员信息为空！", 'info');
        return;
    }
    var IsReg = rtn[1]
    //当医保登记后，不能进行审批通过。进行弹窗提示 2023/03/15 upt JinS1010
    if (IsReg == "是") {
        $.messager.alert("温馨提示", "该人员已经进行医保登记，不能审批通过！", 'info');
        return;
    }

    var AppyDate = selected.AppyDate.split(" ");
    if (getValueById("MedType") == "") {
        $.messager.alert("温馨提示", "医疗类别不能为空!", 'info');
        return;
    }
    //病种提示，当申请类型为病种审批时
    if (selected.AppTypeCode == "1") {
        if (getValueById("DiseApprType") == "") {
            $.messager.alert("温馨提示", "病种审批选项不能为空!", 'info');
            return;
        }
        //当病种审批选项选择"其他"时，备注不能为空
        if (DiseApprTypeStr.indexOf("7") != -1 && getValueById("Memo") == "") {

            $.messager.alert("温馨提示", "当病种审批选项有其他时，备注不能为空!", 'info');
            return;
        }
    }
    //生育提示，当申请类型为生育审批时
    if (selected.AppTypeCode == "2") {
        if (getValueById("MatnType") == "") {
            $.messager.alert("温馨提示", "生育类别不能为空!", 'info');
            return;
        }
        if (getValueById("BirCtrlType") == "") {
            $.messager.alert("温馨提示", "计划生育手术类别不能为空!", 'info');
            return;
        }
    }
    InsertStr = "^" + selected.ADMDR + "^" + selected.Regno + "^" + selected.IPRegNo + "^" + selected.AppTypeCode + "^" + selected.AppNo + "^" +
        selected.LocDr + "^" + selected.Ward + "^" + selected.ApprReaIdCode + "^" + getValueById("ChkedReaId") + "^" + getValueById("MedType") + "^"
        + getValueById("MatnType") + "^" + getValueById("BirCtrlType") + "^" + DiseApprTypeStr + "^" + getValueById("Memo") + "^" +
        "2" + "^" + "3" + "^" + "" + "^" + "" + "^" + GV.USERID + "^" + AppyDate[0] + "^" + AppyDate[1] + "^" + selected.AppyerId + "^" + GV.HospDr
    //调用审批通过后台函数
    $m({                                                                                //调用审批通过后台函数
        ClassName: "web.DHCINSURegAppr",
        MethodName: "Update",
        InString: InsertStr
    }, function (txtData) {
        if (txtData > 0) {
            $.messager.popover({
                msg: '待审批成功',
                type: 'success'
            });
            RegApprQuery();
        }
        else {
            $.messager.popover({
                msg: '待审批失败',
                type: 'error'
            });
        }
    });
}
//加载选中信息
function onSelectInfo() {
    var selected = $('#Apprdg').datagrid('getSelected');
    var AppyReasonCodeArr = selected.AppyReasonCode.split(",");
    setValueById("RegNo", selected.Regno);                            //登记号
    setValueById("IPRecordNo", selected.IPRegNo);                     //住院号
    setValueById("AppType", selected.AppTypeCode);                    //申请类型
    setValueById("MedType", selected.MedTypeCode);                    //医疗类别
    setValueById("MatnType", selected.MatnTypeCode);                  //生育类别 
    setValueById("ApprReaId", selected.ApprReaIdCode);                //费别
    setValueById("ChkedReaId", selected.ChkedReaIdCode);              //审批后费别
    setValueById("BirCtrlType", selected.BirCtrlTypeCode);            //计划生育手术类别
    //setValueById("DiseApprType", selected.AppyReasonCode);    
    //当选择记录的审批角色为医保办时把备注信息加载过来     
    if (selected.ApprRoleCode == "2") {
        setValueById("Memo", selected.Memo);                         //备注

    }
    SetComBoxUnEdit(selected.AppTypeCode);                            //选中记录病种或生育类型，另一类型对应的下拉列表不可编辑
    //当病种审批不等于空的时候，去除"点"用
    if (AppyReasonCodeArr != "") {
        GV.DiseApprComBox.setValues(AppyReasonCodeArr);             //病种审批选项
    }
    else {
        GV.DiseApprComBox.setValues("");                             //病种审批选项
    }

    QryAdmLst();
}
//清屏
function BtnClean() {
    setValueById("RegNo", "");
    setValueById("IPRecordNo", "");
    setValueById("AdmNo", "");
    setValueById("AppType", "1");
    setValueById("AdmList", "");
    setValueById("ApprReaId", "");
    setValueById("ChkedReaId", "");
    setValueById("MatnType", "");
    setValueById("MedType", "21");
    setValueById("BirCtrlType", "");
    GV.DiseApprComBox.setValues("");
    setValueById("Memo", "");
    setValueById("ApprStats", "");
    InsuDateDefault('SDate', -1);
    InsuDateDefault('EDate');
    enableById("BirCtrlType");
    enableById("MatnType");
    enableById("DiseApprType");
    $('#Apprdg').datagrid('loadData', []);
    $('#AdmList').combogrid({ url: "" });
    GV.ADMDR = "";
}
//上传材料
function BtnUpPicture() {
    var selected = $('#Apprdg').datagrid('getSelected');
    //当没选择记录或者选中的不是审批通过时提醒
    if (!selected || selected.ApprStasCode != "1") {
        $.messager.alert("温馨提示", "请选择一条审批通过记录!", 'info');
        return;
    }
    var RefuseType = selected.AppTypeCode;                  // 上传文件类型  0生育  1病种 2 其他
    var RefuseDr = selected.RegID;                          // 所属数据Dr  登记审批表id
    var OpenMode = "0";			                            // 打开模式 0 可以上传  1 仅查看
    var FileMaxSize = "";			                        //文件最大大小          单位M (默认为2)
    var FileExtStrs = "";			                        //文件格式后缀字符串  "txt,png,jpg,..."(默认为图片)
    var ProoFileMaxNum = "";		                        //最大保存文件个数    (默认为5)
    OpenUploadFileWindow(RefuseType, RefuseDr, OpenMode, FileMaxSize, FileExtStrs, ProoFileMaxNum);   //文件上传窗口打开	   
}
//查看资料
function ViewPic(rowIndex) {
    var rows = $("#Apprdg").datagrid('getRows');
    var row = rows[rowIndex]                                  //获得当前行
    //当没选择记录或者选中的不是审批通过时提醒
    if (!row || row.ApprStasCode != "1") {
        $.messager.alert("温馨提示", "请选择一条审批通过记录!", 'info');
        return;
    }
    var RefuseType = row.AppTypeCode;                         // 上传文件类型  0生育  1病种 2 其他
    var RefuseDr = row.RegID;                                 // 所属数据Dr  登记审批表id
    var OpenMode = "1";			                              // 打开模式 0 可以上传  1 仅查看
    var FileMaxSize = "";			                          //文件最大大小          单位M (默认为2)
    var FileExtStrs = "";			                          //文件格式后缀字符串  "txt,png,jpg,..."(默认为图片)
    var ProoFileMaxNum = "";		                          //最大保存文件个数    (默认为5)
    OpenUploadFileWindow(RefuseType, RefuseDr, OpenMode, FileMaxSize, FileExtStrs, ProoFileMaxNum);   //文件上传窗口打开		
}
//病历查看事件
function ViewCases(rowIndex) {
    var rows = $("#Apprdg").datagrid('getRows');
    var row = rows[rowIndex]                                  //获得当前行 
    //当没选择记录或者选中的不是审批通过时提醒
    if (!row) {
        $.messager.alert("温馨提示", "请选择一条记录!", 'info');
        return;
    }
    var url = "websys.csp?a=a&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N&LayoutType=2&TMENU=50753&TPAGID=18454199&ChartBookID=70&SwitchSysPat=N&PatientID=" + "" + "&EpisodeID=" + row.ADMDR + "&mradm=&WardID="
    websys_showModal({
        url: url,
        title: "病例浏览",
        top: "105px",
        left: "148px",
        minimizable: true,
        maximizable: true,
        iconCls: "icon-w-edit",
        onClose: function () {
        }
    });
}
