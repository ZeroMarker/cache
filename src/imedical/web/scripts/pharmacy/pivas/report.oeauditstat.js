/** 
 * 模块: 	 配液中心配液医嘱审核统计
 * 编写日期: 2018-04-03
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    PIVAS.Session.More(session['LOGON.CTLOCID'])
    InitDict();
    $('#txtPatNo').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
        }
    });
    $('#btnFind').on("click", Query);
    $("iframe").attr("src", PIVAS.RunQianBG);
	$(".dhcpha-win-mask").remove();
    //InitPivasSettings();
});

function InitDict() {
    var comboWidth = 214
    PIVAS.Date.Init({ Id: 'dateAuditStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateAuditEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    // 配液中心
    PIVAS.ComboBox.Init({ Id: 'cmbPivaLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function(data) {

        },
        width: comboWidth
    });
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, { width: comboWidth });
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { width: comboWidth });
    // 药品
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: comboWidth });
    // 开单科室
    PIVAS.ComboBox.Init({ Id: 'cmbDocLoc', Type: 'DocLoc' }, { width: comboWidth });
    // 审核人
    PIVAS.ComboBox.Init({ Id: 'cmbAuditUser', Type: 'LocUser' }, { width: comboWidth });
}

/// 查询
function Query() {
    var params = GetParams();
    if (params == "") {
        return;
    }
    var tabOptions = $('#tabsOeAuditStat').tabs('getSelected').panel('options');
    var tabTitle = tabOptions.title;
    var tabId = tabOptions.id;
    var raqParams = "";
    var labelName = "";
    if (tabTitle == "不合理医嘱统计") {
        var chkRadioObj = $("input[name='radioSHJJ']:checked");
        labelName = chkRadioObj.attr("label");
        if (labelName == undefined) {
            $.messager.alert("提示", "请先选中需要查询的报表类型", "warning");
            return;
        }
        var subTitle1 = $("#cmbPivaLoc").combobox("getText");
        subTitle1 += "        日期范围:" + $('#dateAuditStart').datebox('getValue') + "至" + $('#dateAuditEnd').datebox('getValue');
        raqParams = {
            inputStr: params,
            mainTitle: PIVAS.Session.HOSPDESC + tabTitle + labelName,
            subTitle1: subTitle1,
            userName: session['LOGON.USERNAME']
        };
    } else if (tabTitle == "干预医嘱统计") {
        var chkRadioObj = $("input[name='radioGYCG']:checked");
        labelName = chkRadioObj.attr("label");
        if (labelName == undefined) {
            $.messager.alert("提示", "请先选中需要查询的报表类型", "warning");
            return;
        }
        var subTitle1 = $("#cmbPivaLoc").combobox("getText");
        subTitle1 += "        日期范围:" + $('#dateAuditStart').datebox('getValue') + "至" + $('#dateAuditEnd').datebox('getValue');
        raqParams = {
            inputStr: params,
            mainTitle: PIVAS.Session.HOSPDESC + tabTitle + labelName,
            subTitle1: subTitle1,
            userName: session['LOGON.USERNAME']
        };
    }
    if (raqParams != "") {
        var raqName = "DHCST_PIVAS_" + tabTitle + (labelName != "" ? "_" + labelName : "") + ".raq";
        var raqObj = {
            raqName: raqName,
            raqParams: raqParams,
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj)
        $("#" + tabId + " iframe").attr("src", raqSrc);
    }
}

// 获取参数
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox("getValue") || ''; // 配液中心		
    var dateAuditStart = $('#dateAuditStart').datebox('getValue'); // 审核开始日期
    var dateAuditEnd = $('#dateAuditEnd').datebox('getValue'); // 审核结束日期
    var timeAuditStart = $('#timeAuditStart').timespinner('getValue'); // 审核开始时间
    var timeAuditEnd = $('#timeAuditEnd').timespinner('getValue'); // 审核结束时间
    var docLocId = $("#cmbDocLoc").combobox("getValue") || ''; // 开单科室
    var wardId = $("#cmbWard").combobox("getValue") || ''; // 病区
    var locGrpId = $("#cmbLocGrp").combobox("getValue") || ''; // 科室组
    var auditUser = $("#cmbAuditUser").combobox("getValue") || ''; // 审核人
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // 药品
    var patNo = $("#txtPatNo").val().trim()
    paramsArr[0] = pivaLocId;
    paramsArr[1] = dateAuditStart;
    paramsArr[2] = dateAuditEnd;
    paramsArr[3] = timeAuditStart;
    paramsArr[4] = timeAuditEnd;
    paramsArr[5] = docLocId;
    paramsArr[6] = wardId;
    paramsArr[7] = locGrpId;
    paramsArr[8] = auditUser;
    paramsArr[9] = incId;
    paramsArr[10] = patNo;
    return paramsArr.join("^");
}

// 初始化默认条件
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "Generally"
    }, function(jsonData) {
        $("#dateAuditStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateAuditEnd").datebox("setValue", jsonData.OrdEdDate);
    });
}