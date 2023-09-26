/** 
 * ģ��:	��Һ���ı�ǩ��ӡ(����)
 * ��д����:2018-02-27
 * ��д��:  yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var NeedUserArr = []; //�Ƿ�¼����ҩ,��ǩ,�˶�������,
var ConfirmMsgInfoArr = [];
var GridCmbBatNo;
var GridCmbPrtWay;
$(function() {
    InitDict();
    InitPivasSettings();
    InitGridWard();
    InitGridAdm();
    InitGridWorkType();
    InitGridOrdExe();
    $("#btnFind").on("click", Query);
    $("#btnFindDetail").on("click", QueryDetail);
    $("#btnPrint").on("click", ConfirmSaveData);
    $('#btnPack').on('click', function() {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function() {
        PackSelectDsp('');
    });
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $("#tabsDetail").tabs({
        onSelect: function(title) {
            if (title.indexOf("ҽ��") >= 0) {
                $("#gridOrdExe").datagrid("clear")
                QueryOrdExe();
            }
        }
    });
});

function InitDict() {
    // ��Һ����
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, {});
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, {});
    // ���
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, {});
    // �÷�
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, {});
    // ����
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    // ��Ա
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser30', Type: 'LocUser' }, {});
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser40', Type: 'LocUser' }, {});
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser50', Type: 'LocUser' }, {});
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridOrdExe",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    });
    GridCmbPrtWay = PIVAS.PrtWayCombo({
        GridId: "gridWorkType",
        Field: "prtWayId"
    });
}

function InitGridWard() {
    var columns = [
        [
            { field: 'wardSelect', checkbox: true },
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '����', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.LabelPrint",
            QueryName: "LabelPrintWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        onClickRow: function(rowIndex, rowData) {},
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridWard").datagrid("uncheckAll");
            $("#gridWorkType").datagrid("uncheckAll");
            $("#gridOrdExe").datagrid("uncheckAll");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

/// ��ʼ������
function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

function InitGridWorkType() {
    var columns = [
        [
            { field: 'workTypeSelect', checkbox: true },
            { field: 'pid', title: '����', width: 100, hidden: true },
            { field: 'workTypeId', title: '������Id', width: 100, hidden: true },
            { field: 'prtWayDesc', title: '��ӡ��������', width: 100, hidden: true },
            { field: 'wtCode', title: '���������', width: 100 },
            { field: 'wtDesc', title: '����������', width: 200 },
            {
                field: 'prtWayId',
                title: '��ӡ����ʽ',
                width: 200,
                editor: GridCmbPrtWay,
                descField: 'prtWayDesc',
                formatter: function(value, row, index) {
                    return row.prtWayDesc
                }
            },
            { field: 'orderCnt', title: '����', width: 50 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.LabelPrint",
            QueryName: "LabelPrintWorkType"
        },
        fitColumns: true,
        columns: columns,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        onClickCell: function(rowIndex, field, value) {
            if ((field == "prtWayId") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'prtWayId'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onLoadSuccess: function() {
            if ($("#gridWorkType").datagrid("getRows") != "") {
                $("#gridWorkType").datagrid("checkAll");
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWorkType", dataGridOption);
}

//��ʼ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'ordExeCheck', checkbox: true },
            { field: 'warnInfo', title: '����', width: 50, hidden: false },
            { field: 'pid', title: 'pid', width: 50, hidden: true },
            { field: 'ordRemark', title: '��ע', width: 75 },
            { field: 'doseDateTime', title: '��ҩ����', width: 95 },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 100 },
            {
                field: 'batNo',
                title: '����',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != "") {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                halign: 'left',
                align: 'center',
                styler: function(value, row, index) {
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // ż���б�ɫ,�����˵ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: 'ҩƷ', width: 250 ,styler: PIVAS.Grid.Styler.IncDesc},
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 75 },
            { field: "passResultDesc", title: '��˽��', width: 85 },
            { field: 'priDesc', title: '���ȼ�', width: 75 },
            { field: "packFlag", title: '���', width: 85, halign: 'left', align: 'center' },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'colColor', title: 'colColor', width: 50 },
            { field: "incDescStyle", title: 'incDescStyle', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        rowStyler: function(index, row) {
            /*
            var colColorArr=(row.TbColColor).split("-");
            var colorStyle="";
            if ((colColorArr[1]%2)==0){	// ������ı���ɫ
            	colorStyle=PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;	
            */
        },
        onClickRow: function(rowIndex, rowData) {

        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if ((field == "batNo") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
        },
        onLoadSuccess: function() {
            $(this).datagrid("scrollTo", 0);
            PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

///���ǼǺŲ�ѯ�����б�
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
    var patLen = PIVAS.PatNoLength();
    var plen = patNo.length;
    if (plen > patLen) {
        $.messager.alert('��ʾ', '����ǼǺŴ���!', 'warning');
        return;
    }
    for (i = 1; i <= patLen - plen; i++) {
        patNo = "0" + patNo;
    }
    $('#txtPatNo').val(patNo);
    var params = patNo;
    $('#gridAdm').datagrid('query', {
        inputParams: params
    });
}

/// ��ѯ����
function Query() {
    ClearDetailGrid();
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params
    });;
}
/// ��ѯ������
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }
    $('#tabsDetail').tabs('select', '������');
    $('#gridWorkType').datagrid('query', {
        inputStr: params
    });
}
/// ��ѯ��������ϸ
function QueryOrdExe() {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('��ʾ', '�������б�������', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('��ʾ', '��ȡ����PID', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    var prtWayStr = "";
    var gridWTChecked = $('#gridWorkType').datagrid('getChecked');
    for (var i = 0; i < gridWTChecked.length; i++) {
        var checkedData = gridWTChecked[i];
        var workTypeId = checkedData.workTypeId;
        var prtWayId = checkedData.prtWayId;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayId : prtWayStr + "!!" + workTypeId + "^" + prtWayId;
    }
    if (prtWayStr == "") {
        $.messager.alert('��ʾ', '��ѡ������', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    $('#gridOrdExe').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetLabelPrintDetail',
        queryParams: {
            params: pid + "|@|" + prtWayStr
        }
    });
}
/// ��ѯ����
function QueryParams(queryType) {
    var startDate = $('#dateStart').datebox('getValue'); // ��ʼ����
    var endDate = $('#dateEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // ������
    var wardIdStr = $("#cmbWard").combobox("getValue") || ''; // ����	
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // ��Һ����
    var workType = $("#cmbWorkType").combobox("getValue") || ''; // ������
    var priority = $("#cmbPriority").combobox("getValue") || ''; // ҽ�����ȼ�
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // ҩƷ
    var packFlag = $("#cmbPack").combobox("getValues") || ''; // �������
    var instrucId = $("#cmbInstruc").combobox("getValue") || ''; // �÷�
    var batNoStr = "";
    var admId = "";
    var wardIdStr = "";
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    if (queryType == "QueryDetail") {
        var tabTitle = $('#tabsTotal').tabs('getSelected').panel('options').title;
        if (tabTitle == "�����б�") {
            var gridWardChecked = $('#gridWard').datagrid('getChecked');
            for (var i = 0; i < gridWardChecked.length; i++) {
                var checkedData = gridWardChecked[i];
                wardIdStr = (wardIdStr == "" ? checkedData.wardId : wardIdStr + "," + checkedData.wardId)
            }
            if (wardIdStr == "") {
                $.messager.alert('��ʾ', '��ѡ����', 'warning');
                return "";
            }
        } else if (tabTitle == "���ǼǺ�") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                $.messager.alert('��ʾ', '��ѡ������¼', 'warning');
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }

    }
    var params = SessionLoc + "^" + wardIdStr + "^" + startDate + "^" + endDate + "^" + locGrpId + "^" +
        pivaCat + "^" + workType + "^" + priority + "^" + incId + "^" + instrucId + "^" +
        packFlag + "^" + batNoStr + "^" + admId;
    return params;
}

/// ��������ǰ����
function ConfirmSaveData() {
    // if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
    //   return;
    //}
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('��ʾ', '�������б�������', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('��ʾ', '��ȡ����PID', 'warning');
        return;
    }
    $.messager.confirm('��ʾ', "��ȷ�ϴ�ӡ��ǩ��?", function(r) {
        if (r) {
            var userNum = NeedUserArr.length;
            if (userNum > 0) {
                // д���ж���
                for (var i = 0; i < userNum; i++) {
                    var needUserCode = NeedUserArr[i];
                    var cmbUserId = "cmb" + needUserCode;
                    $("#needUserWin #" + cmbUserId).closest("tr").css("display", "table")
                }
                $('#needUserWin').window({ height: 90 + (userNum * 45) });
                $('#needUserWin').window({ width: 280 });
                $('#needUserWin').window('open');
            } else {
                SaveData("", "", "");
            }
            
            
        }
    });
}

function NeedUserWinSave() {
    var user30 = "";
    var user40 = "";
    var user50 = "";
    if (NeedUserArr.indexOf("NeedUser30") >= 0) {
        user30 = $("#cmbNeedUser30").combobox("getValue") || "";
        if (user30 == "") {
            $.messager.alert('��ʾ', '��ѡ����ҩ�˶���', 'warning');
            return;
        }
    }
    if (NeedUserArr.indexOf("NeedUser40") >= 0) {
        user40 = $("#cmbNeedUser40").combobox("getValue") || "";
        if (user40 == "") {
            $.messager.alert('��ʾ', '��ѡ����ǩ�˶���', 'warning');
            return;
        }
    }
    if (NeedUserArr.indexOf("NeedUser50") >= 0) {
        user50 = $("#cmbNeedUser50").combobox("getValue") || "";
        if (user50 == "") {
            $.messager.alert('��ʾ', '��ѡ��˶Ժ˶���', 'warning');
            return;
        }
    }
    $('#needUserWin').window('close');
    SaveData(user30, user40, user50);
}
/// ��������
function SaveData(user30, user40, user50) {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('��ʾ', '�������б�������', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('��ʾ', '��ȡ����PID', 'warning');
        return;
    }
    var gridChecked = $("#gridWorkType").datagrid("getChecked");
    var prtWayStr = "";
    var workTypeStr = "";
    for (var i = 0; i < gridChecked.length; i++) {
        var workTypeId = gridChecked[i].workTypeId;
        var prtWayId = gridChecked[i].prtWayId;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayId : prtWayStr + "!!" + workTypeId + "^" + prtWayId;
        workTypeStr = (workTypeStr == "") ? workTypeId : workTypeStr + "^" + workTypeId;
    }
    if (prtWayStr == "") {
        $.messager.alert('��ʾ', '��ȡ������ӡ��ʽ', 'warning');
        return;
    }
    PIVAS.Progress.Show({ type: 'save', interval: 1000 });
    $.m({
        ClassName: "web.DHCSTPIVAS.LabelPrint",
        MethodName: "SaveData",
        pid: pid,
        userId: SessionUser,
        workTypeStr: workTypeStr,
        user30: user30,
        user40: user40,
        user50: user50
    }, function(retData) {
        PIVAS.Progress.Close();
        var retArr = retData.split("^");
        if (retArr[0] == -1) {
            $.messager.alert('��ʾ', retArr[1], 'warning');
            return;
        } else if (retArr[0] < -1) {
            $.messager.alert('��ʾ', retArr[1], 'error');
            return;
        } else {
            PIVASPRINT.CallBack = QueryDetail;
            PIVASPRINT.LabelsJsonByPogsNo({ pogsNo: retArr[0], sortWay: prtWayStr })
        }
    });
}

// �������
function PackSelectDsp(packFlag) {
    $.messager.confirm('��ʾ', "��ȷ��" + ((packFlag == "P") ? "���" : "ȡ�����") + "��?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('��ʾ', '�빴ѡ��Ҫ' + ((packFlag == "P") ? "���" : "ȡ�����") + '�ļ�¼', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.DataHandler", "UpdateOeDspToPackMulti", mDspStr, packFlag)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                $.messager.alert('��ʾ', retArr[1], 'warning');
                return;
            } else if (retArr[0] < -1) {
                $.messager.alert('��ʾ', retArr[1], 'error');
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: ((packFlag == "P") ? "���" : "ȡ�����") + '�ɹ�',
                type: 'success'
            });
            QueryOrdExe();
            //$('#gridOrdExe').datagrid('reload');
        }
    })
}
/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "LabelPrint"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        // �Ƿ�¼����ҩ,��ǩ,�˶�������,Ҳ���⼸��
        if (jsonData.NeedUser30 == "Y") {
            NeedUserArr.push("NeedUser30");
        }
        if (jsonData.NeedUser40 == "Y") {
            NeedUserArr.push("NeedUser40");
        }
        if (jsonData.NeedUser50 == "Y") {
            NeedUserArr.push("NeedUser50");
        }
    });
}

// ��ȡѡ�м�¼��mdspId��
function GetMainDspStr() {
    var mDspArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var mDsp = checkedData.mDsp;
        if (mDspArr.indexOf(mDsp) < 0) {
            mDspArr.push(mDsp);
        }
    }
    return mDspArr.join("^");
}

/// �����ѯ�������ϸ
function ClearDetailGrid() {
    ClearTmpGlobal();
    $("#gridAdm").datagrid("clear");
    $("#gridWorkType").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");

}
// ����������漰��������ʱglobal
function ClearTmpGlobal() {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.LabelPrint", "KillLabelPrint", pid)
}

window.onbeforeunload = function() {
    ClearTmpGlobal();
};