/** 
 * ģ��: 	 �����������
 * ��д����: 2018-02-11
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var FormulaId = "";
var ChangeViewNum = 1;
$(function () {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function () {
        // ���ͨ��
        AuditOk("SHTG");
    });
    $('#btnAuditNo').on("click", function () {
	    // ��˾ܾ�
        AuditNoShow("SHJJ");
    });
    $("#btnPhaRemark").on("click", function () {
	    // ҩʦ��ע
        AuditRemark();
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //������ҩ
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    $("#btnChangeView").on("click", ChangeView);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    // ���״̬
    PIVAS.ComboBox.Init({
        Id: 'cmbPassStat',
        Type: 'PassStat'
    }, {
        editable: false
    });
    $('#cmbPassStat').combobox("setValue", 1);
    // ��˽��
    PIVAS.ComboBox.Init({
        Id: 'cmbPassResult',
        Type: 'PassResult'
    }, {
        editable: false
    });
    $('#cmbPassResult').combobox("setValue", "");
    // ��ʿ���
    PIVAS.ComboBox.Init({
        Id: 'cmbNurAudit',
        Type: 'NurseResult'
    }, {
        editable: false
    });
    $('#cmbNurAudit').combobox("setValue", 1);
    // ��Һ����
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaCat',
        Type: 'PivaCat'
    }, {});
    // ������
    PIVAS.ComboBox.Init({
        Id: 'cmbLocGrp',
        Type: 'LocGrp'
    }, {});
    // ����
    PIVAS.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {});
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({
        Id: 'cmbPriority',
        Type: 'Priority'
    }, {
        width: 150
    });
    // ��������
    PIVAS.ComboBox.Init({
        Id: 'cmbWorkType',
        Type: 'PIVAWorkType'
    }, {});
    // ҩƷ
    PIVAS.ComboGrid.Init({
        Id: 'cmgIncItm',
        Type: 'IncItm'
    }, {
        width: 310
    });
}

//��ʼ�������б�
function InitGridWard() {
    //����columns
    var columns = [
        [{
                field: 'select',
                checkbox: true
            },
            {
                field: "wardId",
                title: 'wardId',
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url:"",
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        queryOnSelect: false,
        onClickRow: function (rowIndex, rowData) {
            CurWardID = rowData.wardId;
            CurAdm = "";
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {
            $("#gridOrdItem").datagrid("clear");
            $(this).datagrid("uncheckAll");
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "wardDesc") {
                $(this).datagrid("options").queryOnSelect = true;
            }
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function (rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({
        Id: 'gridAdm'
    }, options);
}

//��ʼ����ϸ�б�
function InitGridOrdItem() {
    //����columns
    var columnspat = [
        [{
                field: 'gridOrdItemSelect',
                checkbox: true
            },
            {
                field: 'warnFlag',
                title: '״̬',
                width: 70,
                align: 'left',
                styler: function (value, row, index) {
                    // ��עΪ����ͻ��������ɫ,������ʵ��ɫ��֮��ʱ����
                    if (row.priorityDesc == "��ʱҽ��") {
                        return 'background-color:#F9E701;'; //����
                    }

                    if (value.indexOf("���ͨ��") >= 0) {
                        return 'background-color:#019BC1;color:white;'; //��ɫ
                    } else if (value.indexOf("��˾ܾ�") >= 0) {
                        return 'background-color:#C33A30;color:white;'; //��ɫ
                    } else if (value.indexOf("ҽ������") >= 0) {
                        return 'background-color:#FFB63D;color:white;'; //ǳ��ɫ
                    }
                },
                formatter: function (value, row, index) {
                    if (value == undefined) {
                        value = "";
                    }
                    if (value.indexOf("����") >= 0) {
                        return PIVAS.Grid.CSS.SurgeryImg;
                    }
                    return value;
                }
            },
            {
                field: 'analysisResult',
                title: '����',
                width: 45,
                halign: 'left',
                align: 'center',
                hidden: false,
                formatter: function (value, row, index) {
                    if ((value == "1")||(value == "0")) { // ���� #16BBA2
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                    } else if (value == "2") { // ��ʾ #FF6356
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                    } else if (value == "3") { //���� black
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                    }
                    return '';
                }
            },
            {
                field: 'ordRemark',
                title: '��ע',
                width: 75
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 125
            },
            {
                field: 'bedNo',
                title: '����',
                width: 75
            },
            {
                field: "patNo",
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: "patName",
                title: '����',
                width: 75
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                align: 'center',
                halign: 'left',
                /*
                styler: function(value, row, index) {
                    // ������formatterִ��
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // ż���б�ɫ,�����˵ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },*/
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: 'ҩƷ',
                width: 230,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'incSpec',
                title: '���',
                width: 100
            },
            {
                field: 'dosage',
                title: '����',
                width: 75
            },
            {
                field: 'qty',
                title: '����',
                width: 45,
                align: 'right'
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 100
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 80
            },
            {
                field: 'doctorName',
                title: 'ҽ��',
                width: 80
            },
            {
                field: 'priDesc',
                title: 'ҽ�����ȼ�',
                width: 100
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 75
            },
            {
                field: "passResult",
                title: '��˽��',
                width: 85,
                hidden:true
            },
            {
                field: "passResultStat",
                title: '���״̬',
                width: 85,
                hidden:true
            },
            {
                field: 'pivaCatDesc',
                title: '����',
                width: 50
            }, //,hidden:true
            {
                field: "patSex",
                title: '�Ա�',
                width: 50,
                hidden: true
            },
            {
                field: "patAge",
                title: '����',
                width: 75,
                hidden: true
            },
            {
                field: "patWeight",
                title: '����',
                width: 50,
                hidden: true
            },
            {
                field: "patHeight",
                title: '���',
                width: 50,
                hidden: true
            },
            {
                field: "diag",
                title: '���',
                width: 200,
                hidden: true
            },
            {
                field: "mOeori",
                title: '��ҽ��Id',
                width: 100,
                hidden: true
            },
            {
                field: "admId",
                title: '����Id',
                width: 100,
                hidden: true
            },
            {
                field: "pid",
                title: 'pid',
                width: 200,
                hidden: true
            },
            {
                field: 'oeoriDateTime',
                title: '��ҽ��ʱ��',
                width: 115
            },
            {
                field: "oeori",
                title: 'ҽ��ID',
                width: 150,
                hidden: false
            },
            {
                field: "colColor",
                title: '��ɫ��ʶ',
                width: 40,
                hidden: true
            },
            {
                field: "analysisData",
                title: '�������',
                width: 200,
                hidden: true
            },
            {
                field: "doseDate",
                title: '��ҩ����',
                width: 75,
                hidden: false
            },
            {
                field: "dateMOeori",
                title: '��ҽ��Id+����',
                width: 200,
                hidden: true
            },
            {
                field: "wardPat",
                title: '�������߷���',
                width: 200,
                hidden: true
            }
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
        onLoadSuccess: function () {
            $(this).datagrid("options").checking = "";
            $(this).datagrid("uncheckAll");
            $(this).datagrid("scrollTo", 0);
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // ��ҳ��������ʱglobal��ȡ
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            GridOrdItemCellTip();
        },
        rowStyler: function (index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, "patNo");
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori,
                Type: 'Select'
            });
            $(this).datagrid("options").checking = "";

        },
        onUnselect: function (rowIndex, rowData) {
			PIVAS.Grid.ClearSelections(this.id)
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori
            });
            $(this).datagrid("options").checking = "";
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: false,
                Value: rowData.dateMOeori
            });
            $(this).datagrid("options").checking = "";
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "oeoriSign") {
                if (FormulaId != "") {
                    var mOeori = $(this).datagrid("getRows")[rowIndex].mOeori;
                    PIVASPASSTPN.Init({
                        Params: mOeori + "^" + FormulaId,
                        Field: 'oeoriSign',
                        ClickField: field
                    });
                } else {
                    $.messager.alert('��ʾ', '��ȡ�������ָ�깫ʽ</br>�������ָ�깫ʽ�鿴�Ƿ�ά����ʽ</br>���ڲ������ò鿴�Ƿ�ά����Ҫʹ�õ�ָ�깫ʽ', 'warning');
                }
            } else if (field == "analysisResult") {
                var content = $(this).datagrid("getRows")[rowIndex].analysisData;
                DHCSTPHCMPASS.AnalysisTips({
                    Content: content
                })
            }
        },
        onDblClickCell: function (rowIndex, field, value) {
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
                    IncDesc: incDesc
                })
            }
        },
        groupField: 'wardPat',
        //view: groupview,
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // ���˻�����Ϣ / ҽ����Ϣ / 
            var viewDiv = "";
            var patDiv = "";
            var ordDiv = "";
            var wardDiv = "";
            patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
            patDiv += '<div >' + rowData.patNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.bedNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patName + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patSex + '</div>';
            if (rowData.patAge != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patAge + '</div>';
            }
            if (rowData.patWeight != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patWeight + '</div>';
            }
            if (rowData.patHeight != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patHeight + '</div>';
            }
            patDiv += '</div>';
            wardDiv += '<div id="grpViewWard" class="grpViewWard">';
            wardDiv += '<div>' + rowData.wardDesc + '</div>';
            wardDiv += '</div>';
            viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
            return viewDiv;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}

function InitTreeGridReason() {
    var treeColumns = [
        [{
                field: 'reasonId',
                title: 'reasonId',
                width: 250,
                hidden: true
            },
            {
                field: 'reasonDesc',
                title: 'ԭ��',
                width: 250
            },
            {
                field: '_parentId',
                title: 'parentId',
                hidden: true
            }
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
            params: PivasWayCode + "^",
			hosp:session['LOGON.HOSPID']
        }
    });
}

///���ǼǺŲ�ѯ�����б�
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
	patNo=PIVAS.FmtPatNo(patNo);
    $('#txtPatNo').val(patNo);
    var params = patNo + '^' + session['LOGON.HOSPID'];
    $('#gridAdm').datagrid('query', {
        inputParams: params,
        rows: 9999
    });
}

///��ѯ
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
	$('#gridWard').datagrid("options").url=$URL;
    $('#gridWard').datagrid('query', {
        ClassName: "web.DHCSTPIVAS.OeAudit",
        QueryName: "OeAuditWard",
        inputStr: params,
        rows: 9999
    });
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
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // ������
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // ��Һ����
    var passStat = $("#cmbPassStat").combobox("getValue") || ''; // ���״̬
    var passResult = $("#cmbPassResult").combobox("getValue") || ''; // ��˽��
    var nurAudit = $("#cmbNurAudit").combobox("getValue") || ''; // ��ʿ���
    var priority = $("#cmbPriority").combobox("getValue") || ''; // ҽ�����ȼ�	
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // ������	
    var admId = "";
    // ���Ϊ��ѯ��ϸ,��wardIdȡѡ���Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (queryType == "QueryDetail") {
        if (tabTitle == "�����б�") {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
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
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "��ѡ������¼",
                    type: 'alert'
                });
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }
    } else {
        wardIdStr = $("#cmbWard").combobox("getValue") || '';
    }
    var incId = $("#cmgIncItm").combobox("getValue") || '';
    var params = startDate + "^" + endDate + "^" + "" + "^" + "" + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId;
    return params;
}

/// �������ͨ��
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DetailAlert("SHTG");
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m({
        ClassName: "web.DHCSTPIVAS.OeAudit",
        MethodName: "PivasPass",
        dateMOeoriStr: dateMOeoriStr,
        userId: SessionUser,
        passType: passType
    }, function (passRet) {
        PIVAS.Progress.Close();
        var passRetArr = passRet.split("^");
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            //$.messager.alert('��ʾ','���ͨ��!','info');
        } else {
            $.messager.alert('��ʾ', passInfo, 'warning');
            return;
        }
        QueryDetail();
    })
}

/// ������˾ܾ�����
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
        $.messager.alert('��ʾ', '����ά���������ԭ��', 'warning');
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DetailAlert("SHJJ");
        return;
    }
    $('#reasonSelectDiv').window({
        'title': "��˾ܾ�ԭ��ѡ��"
    }).dialog('open');
    $('#treeGridReason').treegrid('clearChecked');
    $('#treeGridReason').treegrid({
        queryParams: {
            params: PivasWayCode + "^1",
			hosp:session['LOGON.HOSPID']
        }
    });
}

/// �ܾ�
function AuditNo() {
    var winTitle = $("#reasonSelectDiv").panel('options').title;
    var passType = "SHJJ";
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
    $('#txtReasonNotes').val("");

}

///ȡ���������
function CancelAudit() {
    var gridOrdItemChecked = $('#gridOrdItem').datagrid("getChecked") || "";
    if (gridOrdItemChecked == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "�빴ѡ��Ҫȡ����˵ļ�¼",
            type: 'alert'
        });
        return;
    }
    var dateMOeoriArr = [];
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        if (passResultStat == "") {
            continue;
        }
        var dateMOeori = checkedData.dateMOeori;
        if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
            dateMOeoriArr.push(dateMOeori);
        }
    }
    var dateMOeoriStr = dateMOeoriArr.join("^");
    if(dateMOeoriStr==""){
	    DHCPHA_HUI_COM.Msg.popover({
            msg: "û����Ҫȡ����˵ļ�¼",
            type: 'alert'
        });	
        return;
    }
    var conditionHtml = "��ȷ��ȡ�����?";
    $.messager.confirm('��ܰ��ʾ', conditionHtml, function (r) {
        if (r) {
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPassMulti", dateMOeoriStr, SessionUser)
            var cancelRetArr = cancelRet.toString().split("^");
            var cancelVal = cancelRetArr[0] || "";
            if (cancelVal == "-1") {
                $.messager.alert('��ʾ', cancelRetArr[1], "warning");
            }
            QueryDetail();
        }
    });
}

/// �������
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
		DHCPHA_HUI_COM.Msg.popover({
	        msg: "����ѡ�м�¼",
	        type: 'alert'
	    });
        return;
    }
    var adm = gridSelect.admId;
    PIVAS.ViewEMRWindow({}, adm);
}

/// ��ȡѡ�����ҽ����
function GetDateMainOeoriStr() {
    var dateMOeoriArr = [];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        // ��������ٴ���
        
        if (passResultStat!= "") {
            continue;
        }
        var warnFlag=checkedData.warnFlag;
        if (warnFlag.indexOf("��ʿ�ܾ�")>=0){
	    	continue;
	    }
        if (warnFlag.indexOf("��ʿδ����")>=0){
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
		DHCPHA_HUI_COM.Msg.popover({
	        msg: "����ѡ�м�¼",
	        type: 'alert'
	    });
        return;
    }
    var dateMOeori = gridSelect.dateMOeori;
    PIVAS.AuditRecordWindow({
        dateMOeori: dateMOeori
    });
}

/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "OeAudit"
    }, function (jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
        var FormulaDesc = jsonData.Formula;
        FormulaId = tkMakeServerCall("web.DHCSTPIVAS.Common", "GetDIIIdByDesc", FormulaDesc);
        if (jsonData.GroupView == "Y") {
            ChangeView();
        }
    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "gridOrdItem",
            MOeori: "dateMOeori",
            GridType: "EasyUI",
            Field: "analysisResult",
            CallBack: GridOrdItemCellTip
        })
    } else if (PIVAS.VAR.PASS=="DT"){
		DHCPHA_HUI_COM.Msg.popover({
            msg: "��ͨ�ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�",
            type: 'alert'
        });	
        return;
		StartDaTongDll(); 
		DaTongPrescAnalyse();  
	}else if (PIVAS.VAR.PASS=="MK"){
		DHCPHA_HUI_COM.Msg.popover({
            msg: "�����ӿ�δ����,����ϵ��ز�Ʒ����Խӿ�",
            type: 'alert'
        });	
        return;
		MKPrescAnalyse(); 
	}else{
		DHCPHA_HUI_COM.Msg.popover({
            msg: "�޴����ͺ�����ҩ�ӿ�,����ҩƷϵͳ����->��������->��Һ����->������ҩ����",
            type: 'alert'
        });	
        return;
	}

}

/// ��ϸ���celltip
function GridOrdItemCellTip() {
    PIVAS.Grid.CellTip({
        TipArr: ['ordRemark']
    });
    PIVAS.Grid.CellTip({
        TipArr: ['patNo'],
        ClassName: 'web.DHCSTPIVAS.Common',
        MethodName: 'PatBasicInfoHtml',
        TdField: 'mOeori'
    });
    PIVAS.Grid.CellTip({
        TipArr: ['warnFlag'],
        ClassName: 'web.DHCSTPIVAS.OeAudit',
        MethodName: 'WarnFlagInfoHtml',
        TdField: 'dateMOeori'
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
window.onbeforeunload = function () {
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
    $('#gridOrdItem').datagrid(hsMethod, 'wardDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'priDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'instrucDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'freqDesc');
    $('#gridOrdItem').datagrid('options').view = showView
    $('#gridOrdItem').datagrid("reload")
    ChangeViewNum++;
}

/// ��ϸ��ʾ,��Ӧͨ��\�ܾ�,��δ��ѡʱ����
function DetailAlert(auditType) {
    var dateMOeoriArr = [];
    var shtgArr = [];
    var shjjArr = [];
    var hsjjArr=[];
    var hswclArr=[];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        var passResult= checkedData.passResult;
        var dateMOeori = checkedData.dateMOeori;
        var warnFlag=checkedData.warnFlag;
        // ��������ٴ���
        if (passResultStat == "") {
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        } else if (passResult=="Y") {
            if (shtgArr.indexOf(dateMOeori) < 0) {
                shtgArr.push(dateMOeori);
            }
        } else if ((passResult=="N")||(passResult=="NY")) {
            if (shjjArr.indexOf(dateMOeori) < 0) {
                shjjArr.push(dateMOeori);
            }
        } 
        if (warnFlag.indexOf("��ʿ�ܾ�")>=0){
	       if (hsjjArr.indexOf(dateMOeori) < 0) {
               hsjjArr.push(dateMOeori);
           }	
	    }
        if (warnFlag.indexOf("��ʿδ����")>=0){
	       if (hswclArr.indexOf(dateMOeori) < 0) {
               hswclArr.push(dateMOeori);
           }	
	    }
    }
    var msgInfo = "����ѡ���¼"
    if (auditType == "SHTG") {
        if (shjjArr.length > 0) {
            msgInfo = "����ȡ�����";
        } else if (shtgArr.length > 0) {
            msgInfo = "��ѡ��ļ�¼�����ͨ��";
        }
    } else if (auditType == "SHJJ") {
        if (shtgArr.length > 0) {
            msgInfo = "����ȡ�����";
        } else if (shjjArr.length > 0) {
            msgInfo = "��ѡ��ļ�¼����˾ܾ�";
        }
    }
	if (hsjjArr.length>0){
    	msgInfo = "��ѡ��ļ�¼�ѻ�ʿ�ܾ�";
	}
	if (hswclArr.length>0){
    	msgInfo = "��ѡ��ļ�¼��ʿ��δ����ҽ��";
	}
	DHCPHA_HUI_COM.Msg.popover({
        msg: msgInfo,
        type: 'alert'
    });
}
/// ��ע������,��ѡ����,�����ڹ�ѡ�����б�עĳһ��ҽ��
function AuditRemark(){
	var gridSelect = $('#gridOrdItem').datagrid('getSelected');
	if (gridSelect==null){
	    DHCPHA_HUI_COM.Msg.popover({
	        msg: "��ѡ����Ҫ��ע�ļ�¼",
	        type: 'alert'
	    });
	    return;
	}
	
	var rowIndex=$('#gridOrdItem').datagrid("getRows").indexOf(gridSelect);
	var dateMOeori=gridSelect.dateMOeori;
	$.messager.prompt("��ʾ", "�������ע����", function (rText) {
		if (rText!=undefined){
			$.cm({
		        ClassName: "web.DHCSTPIVAS.OeAudit",
		        MethodName: "PivasRemark",
		        dateMOeoriStr: dateMOeori,
		        userId: SessionUser,
		        phaRemark: rText,
		        dataType:"text"
		    }, function (passRet) {
		        var passRetArr = passRet.split("^");
		        var passVal = passRetArr[0];
		        var passInfo = passRetArr[1];
		        if (passVal == 0) {
				    DHCPHA_HUI_COM.Msg.popover({
				        msg: "��ע�ɹ�",
				        type: 'success'
				    });
		            var oldWarnFlag=gridSelect.warnFlag;
		            var newWarnFlag=oldWarnFlag;
		            if (oldWarnFlag==""){
			        	newWarnFlag="ҩʦ��ע";
			        }else{
				        if (oldWarnFlag.indexOf("ҩʦ��ע")<0){
				    		newWarnFlag=oldWarnFlag+"</br>ҩʦ��ע";
				        }
				    }
				    if (rText==""){
					    newWarnFlag=newWarnFlag.replace(/<\/br>ҩʦ��ע/g,"");
						newWarnFlag=newWarnFlag.replace(/ҩʦ��ע/g,"");
					}
			        $('#gridOrdItem').datagrid('updateRow',{
				    	index:rowIndex,
				    	row:{
					    	warnFlag:newWarnFlag
					    }
				    });
				    GridOrdItemCellTip();
		        } else {
		            $.messager.alert('��ʾ', passInfo, 'warning');
		        }
		    })
		}	
	});
}