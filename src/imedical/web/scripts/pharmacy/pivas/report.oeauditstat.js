/** 
 * ģ��: 	 ��Һ������Һҽ�����ͳ��
 * ��д����: 2018-04-03
 * ��д��:   yunhaibao
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
    // ��Һ����
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
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, { width: comboWidth });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { width: comboWidth });
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: comboWidth });
    // ��������
    PIVAS.ComboBox.Init({ Id: 'cmbDocLoc', Type: 'DocLoc' }, { width: comboWidth });
    // �����
    PIVAS.ComboBox.Init({ Id: 'cmbAuditUser', Type: 'LocUser' }, { width: comboWidth });
}

/// ��ѯ
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
    if (tabTitle == "������ҽ��ͳ��") {
        var chkRadioObj = $("input[name='radioSHJJ']:checked");
        labelName = chkRadioObj.attr("label");
        if (labelName == undefined) {
            $.messager.alert("��ʾ", "����ѡ����Ҫ��ѯ�ı�������", "warning");
            return;
        }
        var subTitle1 = $("#cmbPivaLoc").combobox("getText");
        subTitle1 += "        ���ڷ�Χ:" + $('#dateAuditStart').datebox('getValue') + "��" + $('#dateAuditEnd').datebox('getValue');
        raqParams = {
            inputStr: params,
            mainTitle: PIVAS.Session.HOSPDESC + tabTitle + labelName,
            subTitle1: subTitle1,
            userName: session['LOGON.USERNAME']
        };
    } else if (tabTitle == "��Ԥҽ��ͳ��") {
        var chkRadioObj = $("input[name='radioGYCG']:checked");
        labelName = chkRadioObj.attr("label");
        if (labelName == undefined) {
            $.messager.alert("��ʾ", "����ѡ����Ҫ��ѯ�ı�������", "warning");
            return;
        }
        var subTitle1 = $("#cmbPivaLoc").combobox("getText");
        subTitle1 += "        ���ڷ�Χ:" + $('#dateAuditStart').datebox('getValue') + "��" + $('#dateAuditEnd').datebox('getValue');
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

// ��ȡ����
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox("getValue") || ''; // ��Һ����		
    var dateAuditStart = $('#dateAuditStart').datebox('getValue'); // ��˿�ʼ����
    var dateAuditEnd = $('#dateAuditEnd').datebox('getValue'); // ��˽�������
    var timeAuditStart = $('#timeAuditStart').timespinner('getValue'); // ��˿�ʼʱ��
    var timeAuditEnd = $('#timeAuditEnd').timespinner('getValue'); // ��˽���ʱ��
    var docLocId = $("#cmbDocLoc").combobox("getValue") || ''; // ��������
    var wardId = $("#cmbWard").combobox("getValue") || ''; // ����
    var locGrpId = $("#cmbLocGrp").combobox("getValue") || ''; // ������
    var auditUser = $("#cmbAuditUser").combobox("getValue") || ''; // �����
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // ҩƷ
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

// ��ʼ��Ĭ������
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