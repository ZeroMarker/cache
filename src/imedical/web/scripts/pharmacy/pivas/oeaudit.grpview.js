/** 
 * ģ��: 	 �����������
 * ��д����: 2018-02-11
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var ChangeViewNum = 1;
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function() {
        // ���ͨ��
        AuditOk("SHTG");
    });
    $("#btnPackNor").on("click", function() {
        // �������
        AuditOk("ZCDB");
    });
    $('#btnAuditNo').on("click", function() {
        AuditNoShow("SHJJ");
    });
    $("#btnPackUnNor").on("click", function() {
        AuditNoShow("FZCDB");
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //������ҩ
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $("#btnHelp").on({
        "mousemove": function() {
            $('#helpWindowDiv').window('open');
            $('#helpWindowDiv').window('move', {
                left: event.clientX - $("#helpWindowDiv").width(),
                top: event.clientY,
            });
        },
        "mouseleave": function() {
            $('#helpWindowDiv').window('close');
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    $("#btnChangeView").on("click", ChangeView);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
});

function InitDict() {
    // ���״̬
    PIVAS.ComboBox.Init({ Id: 'cmbPassStat', Type: 'PassStat' }, { editable: false, width: 120 });
    $('#cmbPassStat').combobox("setValue", 1);
    // ��˽��
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { editable: false, width: 120 });
    $('#cmbPassResult').combobox("setValue", "");
    // ��ʿ���
    PIVAS.ComboBox.Init({ Id: 'cmbNurAudit', Type: 'NurseResult' }, { editable: false, width: 120 });
    $('#cmbNurAudit').combobox("setValue", 1);
    // ��Һ����
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, { width: 120 });
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: 120 });
    // ��������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: 120 });
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, {
        width: 310
    });
}

//��ʼ�������б�
function InitGridWard() {
    //����columns
    var columns = [
        [
            { field: 'select', checkbox: true },
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '����', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OeAudit",
            QueryName: "OeAuditWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        onClickRow: function(rowIndex, rowData) {
            CurWardID = rowData.wardId;
            CurAdm = "";
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridOrdItem").datagrid("clear");
            $(this).datagrid("uncheckAll");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

//��ʼ����ϸ�б�
function InitGridOrdItem() {
    //����columns
    var columnspat = [
        [
            { field: 'gridOrdItemSelect', checkbox: true },
            {
                field: 'warnFlag',
                title: '״̬',
                width: 70,
                align: 'left',
                styler: function(value, row, index) {
                    // ��עΪ����ͻ��������ɫ,������ʵ��ɫ��֮��ʱ����
                    if (row.priorityDesc == "��ʱҽ��") {
                        return 'background-color:#F9E701;'; //����
                    } else if (row.passResultDesc == "���ͨ��") {
                        return 'background-color:#019BC1;color:white;'; //��ɫ
                    } else if (row.passResultDesc == "��˾ܾ�") {
                        return 'background-color:#C33A30;color:white;'; //��ɫ
                    } else if (row.passResultDesc == "���������") {
                        return 'background-color:#E46022;'; //ǳ��ɫ
                    } else if (row.passResultDesc == "�������") {
                        return 'background-color:#009B6B;'; //ǳ��ɫ
                    }
                },
                formatter: function(value, row, index) {
                    if (value == undefined) {
                        value = "";
                    }
                    if (value.indexOf("����") >= 0) {
                        return PIVAS.Grid.CSS.SurgeryImg;
                    } else {
                        return row.passResultDesc;
                    }
                }
            },
            {
                field: 'analysisResult',
                title: '����',
                width: 45,
                halign: 'left',
                align: 'center',
                hidden: false,
                formatter: function(value, row, index) {
                    if (value == "1") { // ���� #16BBA2
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                    } else if (value == "2") { // ��ʾ #FF6356
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                    } else if (value == "3") { //���� black
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                    }
                    return '';
                }
            },
            { field: 'ordRemark', title: '��ע', width: 75 },
            { field: "patNo", title: '�ǼǺ�', width: 100 },
            { field: "patName", title: '����', width: 75 },
            { field: 'bedNo', title: '����', width: 75 },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                align: 'center',
                halign: 'left',
                styler: function(value, row, index) {
                    // ������formatterִ��
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // ż���б�ɫ,�����˵ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: 'ҩƷ',
                width: 230,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'qty', title: '����', width: 45, align: 'right' },
            { field: 'freqDesc', title: 'Ƶ��', width: 100 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'doctorName', title: 'ҽ��', width: 80 },
            { field: 'wardDesc', title: '����', width: 200 },
            { field: 'priDesc', title: 'ҽ�����ȼ�', width: 100 },
            { field: 'bUomDesc', title: '��λ', width: 75 },
            { field: "passResultDesc", title: '��˽��', width: 85 },
            { field: 'pivaCatDesc', title: '��Һ����', width: 100 }, //,hidden:true
            { field: "patSex", title: '�Ա�', width: 50, hidden: true },
            { field: "patAge", title: '����', width: 75, hidden: true },
            { field: "patWeight", title: '����', width: 50, hidden: true },
            { field: "patHeight", title: '���', width: 50, hidden: true },
            { field: "diag", title: '���', width: 200, hidden: true },
            { field: "mOeori", title: '��ҽ��Id', width: 100, hidden: true },
            { field: "admId", title: '����Id', width: 100, hidden: true },
            { field: "pid", title: 'pid', width: 200, hidden: true },
            { field: 'oeoriDateTime', title: '��ҽ��ʱ��', width: 115 },
            { field: "oeori", title: 'ҽ��ID', width: 150, hidden: false },
            { field: "colColor", title: '��ɫ��ʶ', width: 40, hidden: true },
            { field: "analysisData", title: '�������', width: 200, hidden: true },
            { field: "doseDate", title: '��ҩ����', width: 75, hidden: false },
            { field: "dateMOeori", title: '��ҽ��Id+����', width: 200, hidden: false }
        ]
    ];
    var dataGridOption = {
        url: '',
        fitColumns: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columnspat,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        toolbar: "#gridOrdItemBar",
        onLoadSuccess: function() {
            $(this).datagrid("scrollTo", 0);
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // ��ҳ��������ʱglobal��ȡ
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            GridOrdItemCellTip();
        },
        rowStyler: function(index, row) {
            /*
            var colColorArr=(row.colColor).split("-");
            var colorStyle="";
            if ((colColorArr[1]%2)==0){	// ������ı���ɫ
            	colorStyle=PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;	
            */
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: false,
                Value: rowData.dateMOeori
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if (field == "oeoriSign") {
                var mOeori = $(this).datagrid("getRows")[rowIndex].mOeori;
                PIVASPASSTPN.Init({
                    Params: mOeori + "^" + 5, // 5 Ϊ��Ӧ���ָ���Id,�˴�ĿǰΪд��,��ӦTPN
                    Field: 'oeoriSign',
                    ClickField: field
                });
            } else if (field == "analysisResult") {
                var content = $(this).datagrid("getRows")[rowIndex].analysisData;
                DHCSTPHCMPASS.AnalysisTips({ Content: content })
            }
        },
        onDblClickCell: function(rowIndex, field, value) {
            if (field != "incDesc") {
                return;
            }
            var rowData = $(this).datagrid("getRows")[rowIndex];
            if (PIVAS.VAR.PASS == "DHC") {
                /// ����֪ʶ��˵�����д
                var userInfo = SessionUser + "^" + SessionLoc + "^" + SessionGroup;
                var incDesc = rowData.incDesc;
                DHCSTPHCMPASS.MedicineTips({
                    Oeori: rowData.oeori,
                    UserInfo: userInfo,
                    IncDesc: value
                })
            }
        },
        groupField: 'dateMOeori',
        //view: groupview,
        groupFormatter: function(value, rows) {
            var rowData = rows[0];
            var grpData = rowData.patNo + " " + rowData.bedNo + " " + rowData.patName + " " + rowData.wardDesc
            return grpData;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}

function InitTreeGridReason() {
    var treeColumns = [
        [
            { field: 'reasonId', title: 'reasonId', width: 250, hidden: true },
            { field: 'reasonDesc', title: 'ԭ��', width: 250 },
            { field: '_parentId', title: 'parentId', hidden: true }
        ]
    ];
    $('#treeGridReason').treegrid({
        animate: true,
        border: false,
        fit: true,
        checkbox: true,
        nowrap: true,
        fitColumns: true,
        singleSelect: true,
        idField: 'reasonId',
        treeField: 'reasonDesc',
        pagination: false,
        columns: treeColumns,
        url: PIVAS.URL.COMMON + '?action=JsGetAuditReason',
        queryParams: {
            params: PivasWayCode + "^"
        }
    });
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

///��ѯ
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
    $('#gridWard').datagrid('query', { inputStr: params });
}

///��ѯҽ��
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    $('#gridOrdItem').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetOeAuditDetail',
        pageNumber: 1,
        queryParams: {
            params: params,
            pid: ''
        }
    });
}

/// ��ȡ����
function QueryParams(queryType) {
    var wardIdStr = "";
    var startDate = $('#dateStart').datebox('getValue'); // ��ʼ����
    var endDate = $('#dateEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox("getValue"); // ������
    var pivaCat = $("#cmbPivaCat").combobox("getValue"); // ��Һ����
    var passStat = $("#cmbPassStat").combobox("getValue"); // ���״̬
    var passResult = $("#cmbPassResult").combobox("getValue"); // ��˽��
    var nurAudit = $("#cmbNurAudit").combobox("getValue"); // ��ʿ���
    var priority = $("#cmbPriority").combobox("getValue"); // ҽ�����ȼ�	
    var locGrpId = $('#cmbLocGrp').combobox("getValue"); // ������	
    var admId = "";
    // ���Ϊ��ѯ��ϸ,��wardIdȡѡ���Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (queryType == "QueryDetail") {
        if (tabTitle == "�����б�") {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
                $.messager.alert('��ʾ', '��ѡ����', 'warning');
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
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
    } else {
        wardIdStr = $("#cmbWard").combobox("getValue");
    }
    var incId = $("#cmgIncItm").combobox("getValue");
    var params = startDate + "^" + endDate + "^" + "" + "^" + "" + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId;
    return params;
}

/// �������ͨ��
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        $.messager.alert('��ʾ', '����ѡ���¼!', 'warning');
        return;
    }
    PIVAS.Progress.Show({ type: 'save', interval: 1000 });
    $.m({
        ClassName: "web.DHCSTPIVAS.OeAudit",
        MethodName: "PivasPass",
        dateMOeoriStr: dateMOeoriStr,
        userId: SessionUser,
        passType: passType
    }, function(passRet) {
        PIVAS.Progress.Close();
        var passRetArr = passRet.split("^");
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            //$.messager.alert('��ʾ','���ͨ��!','info');
        } else {
            $.messager.alert('��ʾ', '���ʧ��!', 'error');
        }
        QueryDetail();
    })
}

/// ������˾ܾ�����
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
        $.messager.alert('��ʾ', '����ά���ܾ�ԭ��!', 'warning');
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        $.messager.alert('��ʾ', '����ѡ��δ�������ļ�¼!', 'warning');
        return;
    }
    if (passType == "FZCDB") {
        $('#reasonSelectDiv').window({ 'title': "���������ԭ��ѡ��" });
    } else {
        $('#reasonSelectDiv').window({ 'title': "��˾ܾ�ԭ��ѡ��" });
    }
    $('#reasonSelectDiv').dialog('open');
    $('#treeGridReason').treegrid('clearChecked');
    $('#treeGridReason').treegrid({
        queryParams: {
            params: PivasWayCode + "^1"
        }
    });
}

/// �ܾ�
function AuditNo() {
    var winTitle = $("#reasonSelectDiv").panel('options').title;
    var passType = "SHJJ";
    if (winTitle == "���������") {
        passType = "FZCDB";
    }
    var checkedNodes = $('#treeGridReason').treegrid("getCheckedNodes");
    if (checkedNodes == "") {
        $.messager.alert("��ʾ", "��ѡ��ԭ��", "warning");
        return "";
    }
    var reasonStr = "";
    for (var nI = 0; nI < checkedNodes.length; nI++) {
        var reasonId = checkedNodes[nI].reasonId;
        if (reasonId == 0) {
            continue;
        }
        // ֻ��Ҷ�ӽ��
        if ($('#treeGridReason').treegrid('getChildren', reasonId) == "") {
            reasonStr = reasonStr == "" ? reasonId : reasonStr + "!!" + reasonId
        }
    }
    var reasonNotes = $("#txtReasonNotes").val();
    var reasonData = reasonStr + "|@|" + reasonNotes;
    var dateMOeoriStr = GetDateMainOeoriStr();
    // ͬ��,��������
    var passRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "PivasPass", dateMOeoriStr, SessionUser, passType, reasonData);
    var passRetArr = passRet.split("^");
    var passVal = passRetArr[0];
    var passInfo = passRetArr[1];
    if (passVal == 0) {
        $('#reasonSelectDiv').dialog('close');
    } else {
        $.messager.alert('��ʾ', winTitle + 'ʧ��', 'error');
    }
    QueryDetail();


}

///ȡ���������
function CancelAudit() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ��һ����¼', "warning");
        return;
    }
    /*
    var dateMOeori = gridSelect.dateMOeori;
    var cancelWarnInfo = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "GetCancelWarnInfo", dateMOeori);
    var ConfirmMsgInfoArr = [];
    if (cancelWarnInfo != "") {
        var cancelWarnArr = cancelWarnInfo.split("^");
        for (var cI = 0; cI < cancelWarnArr.length; cI++) {
            var cancelInfo = cancelWarnArr[cI].split(":");
            ConfirmMsgInfoArr.push({ title: cancelInfo[0] + ":", data: cancelInfo[1] });
        }
    } else {
        return;
    }
    var conditionHtml = PIVAS.Html.ConfirmInfo({ Data: ConfirmMsgInfoArr });
    */
    var conditionHtml = "��ȷ��ȡ�����?";
    $.messager.confirm('��ܰ��ʾ', conditionHtml, function(r) {
        if (r) {
            /*����ѡ
            var lastoeori=""
            var dispgridselect=$('#ordtimdg').datagrid("getRows");
            var dispgridrows=dispgridselect.length;
            for(var i=0;i<dispgridrows;i++){
            	var selecteddata=dispgridselect[i];
            	var select=selecteddata["TSelect"]
            	var oeori=selecteddata["Tbtoeori"]
            	var AuditRes=selecteddata["TbAuditRes"];
            	var moeori=selecteddata["TbMOeori"];
             	if(AuditRes==""){continue}
             	if(lastoeori==moeori){continue}
             	var str=UserDr+"^"+moeori
            	if (select=="Y"){			
            		var ret=tkMakeServerCall("web.DHCSTPIVAS.OeAudit","CancelOrdAudit",str)
            		lastoeori=moeori
            	};
            }
            */
            // ������

            var dateMOeori = gridSelect.dateMOeori;
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPass", dateMOeori, SessionUser)
            QueryDetail();
        }
    });
}

/// �������
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ��һ����¼', "warning");
        return;
    }
    var adm = gridSelect.admId;
    var wWidth = document.body.clientWidth * 0.9;
    var wHeight = document.body.clientHeight * 0.9;
    var lnk = "emr.record.browse.csp?EpisodeID=" + adm;
    window.open(lnk, "_blank", "width=" + wWidth + ",height=" + wHeight + ",menubar=no,status=yes,toolbar=no,resizable=yes");
}

/// ��ȡѡ�����ҽ����
function GetDateMainOeoriStr() {
    var dateMOeoriArr = [];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultDesc = checkedData.passResultDesc;
        // ��������ٴ���
        if (passResultDesc != "") {
            continue;
        }
        var dateMOeori = checkedData.dateMOeori;
        if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
            dateMOeoriArr.push(dateMOeori);
        }
    }
    return dateMOeoriArr.join("^");
}

function ClearGrid() {

}

function AuditRecordLog() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ��һ����¼', "warning");
        return;
    }
    var dateMOeori = gridSelect.dateMOeori;
    var winDivId = 'OeAuditWindowDiv';
    var winDiv = '<div id="OeAuditWindowDiv"><div id="gridOeAuditRecord"></div></div>'
    $("body").append(winDiv);
    //������
    var columns = [
        [
            { field: 'passResult', title: '���״̬', width: 100 },
            { field: 'userName', title: '������', width: 100 },
            { field: 'dateTime', title: '����ʱ��', width: 160 },
            { field: 'reasonDesc', title: '����ԭ��', width: 250 },
            { field: 'docAgree', title: 'ҽ������', width: 80 },
            { field: 'docNotes', title: 'ҽ������', width: 80 },
            { field: 'oeoriStat', title: 'ҽ��״̬', width: 80 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            QueryName: 'OeAuditRecord',
            dateMOeori: dateMOeori
        },
        fit: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: true,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init("gridOeAuditRecord", dataGridOption);
    $('#OeAuditWindowDiv').window({
        title: ' ������˼�¼',
        collapsible: false,
        iconCls: "icon-history-rec",
        border: false,
        closed: true,
        modal: true,
        width: 900,
        height: 500,
        onBeforeClose: function() {
            $("#OeAuditWindowDiv").remove()
        }
    });
    $('#OeAuditWindowDiv').window('open');
}

/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "OeAudit"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({ GridId: "gridOrdItem", MOeori: "mOeori", GridType: "EasyUI", Field: "analysisResult", CallBack: GridOrdItemCellTip })
    }
}

/// ��ϸ���celltip
function GridOrdItemCellTip() {
    PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
    PIVAS.Grid.CellTip({
        TipArr: ['patNo'],
        ClassName: 'web.DHCSTPIVAS.Common',
        MethodName: 'PatBasicInfoHtml',
        TdField: 'mOeori'
    });
}
// ����������漰��������ʱglobal
function ClearTmpGlobal() {
    var rowsData = $("#gridOrdItem").datagrid("getRows");
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "KillOeAudit", pid)
}
window.onbeforeunload = function() {
    ClearTmpGlobal();
}

function ChangeView() {
    var hsMethod = "";
    var showView = "";
    if (ChangeViewNum % 2 == 1) {
        hsMethod = "hideColumn";
        showView = groupview;
    } else {
        hsMethod = "showColumn"
        showView = $.fn.datagrid.defaults.view;
    }
    var gridOpts = $("#gridOrdItem").datagrid("options");
    $('#gridOrdItem').datagrid(hsMethod, 'patNo');
    $('#gridOrdItem').datagrid(hsMethod, 'patName');
    $('#gridOrdItem').datagrid(hsMethod, 'bedNo');
    $('#gridOrdItem').datagrid('options').view = showView
    $('#gridOrdItem').datagrid("reload")
    ChangeViewNum++;
}