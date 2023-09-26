/** 
 * ģ��: 	 �����������
 * ��д����: 2019-07-24
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var FormulaId = "";
var NeedScroll = "1";
$(function () {
    $(".newScroll").mCustomScrollbar({
        theme: "inset-2-dark",
        scrollInertia: 100,
        mouseWheel: {
            scrollAmount: 100 // ������
        }
    });
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitGridOrderDrugs();
    InitTreeGridReason();
    InitTPN();
    InitMedHistory();
    InitMedInfo();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function () {
        // ���ͨ��
        AuditOk("SHTG");
    });
    $('#btnAuditNo').on("click", function () {
        AuditNoShow("SHJJ");
    });
    $("#btnPhaRemark").on("click", function () {
	    // ҩʦ��ע
        AuditRemark();
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //������ҩ-Ԥ��
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    //$("#btnRemark").on("click", SaveRemark);
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $("#kwMore").keywords({
        singleSelect: true,
        onClick: function (v) {
            var panelHeight = 600;
            $("#divTPN").hide();
            $("#divMedHistory").hide();
            $("#divMedInfo").hide();
            var title = v.text;
            if (title == "TPNָ��") {
                $("#divTPN").show();
                $("#divTPNGrid").height(panelHeight);
                $("#gridTPN").datagrid("resize");
                LoadTPN();
            } else if (title == "���λ�����ҩ") {
                $("#divMedHistory").show();
                $("#divMedHistoryGrid").height(panelHeight);
                $("#gridMedHistory").datagrid("resize");
                LoadMedHistory();
            } else if (title == "��˸���") {
                $("#divMedInfo").show();
                $("#divMedInfoGrid").height(panelHeight);
                $("#gridMedInfo").datagrid("resize");
                LoadMedInfo();
            }
        },
        items: [{
            text: "��˸���"
        }, {
            text: "TPNָ��"
        }, {
            text: "���λ�����ҩ"
        }]
    });
   	$("#kwMore").keywords("select", "��˸���");
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
                width: 250
            },
            {
                field: 'needCnt',
                title: 'δ��',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        fitColumns: false,
        fit: true,
        //rownumbers: false,
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
    var columns = [
        [{
                field: 'passResult',
                title: '������˽��',
                width: 50,
                align: 'left',
                hidden: true
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
                field: 'warnFlag',
                title: '״̬',
                width: 75,
                align: "center",
                styler: function (value, row, index) {
                    // ��עΪ����ͻ��������ɫ,������ʵ��ɫ��֮��ʱ����
                    if (row.priorityDesc == "��ʱҽ��") {
                        return 'background-color:#F9E701;'; //����
                    }
					var passResult=row.passResult;
                    if (passResult== "Y") {
                        return 'background-color:#019BC1;color:white;'; //��ɫ
                    } else if ((passResult== "N")||(passResult== "NY")) {
                        return 'background-color:#C33A30;color:white;'; //��ɫ
                    } else if (passResult== "NA") {
                        return 'background-color:#FFB63D;color:white;'; //ǳ��ɫ
                    }
                },
            },
            {
                field: 'pivaCatDesc',
                title: '����',
                width: 45,
                styler: function (value, row, index) {
                    return "font-weight:bold;font-size:16px;"
                }
            },

            {
                field: 'drugs',
                title: 'ҽ��',
                width: 1500
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 150,
                hidden: true
            },
            {
                field: 'bedNo',
                title: '����',
                width: 50,
                hidden: true
            },
            {
                field: "patName",
                title: '����',
                width: 75,
                hidden: true
            },
            {
                field: "patSex",
                title: '�Ա�',
                width: 45,
                align: 'center',
                hidden: true
            },
            {
                field: "patAge",
                title: '����',
                width: 45,
                hidden: true
            },
            {
                field: 'surfaceArea',
                title: '������',
                width: 75,
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
                field: "analysisData",
                title: '�������',
                width: 200,
                hidden: true
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
        url:"",
        fitColumns: false,
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        toolbar: "#gridOrdItemBar",
        onLoadSuccess: function () {
            ClearOrderDetail();
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // ��ҳ��������ʱglobal��ȡ
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            if (NeedScroll == 1) {
                $(this).datagrid("scrollTo", 0);
            }
            NeedScroll = 1;
        },
        onClickRow: function (rowIndex, rowData) {
            ShowOrderDetail(rowData.mOeori)
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "analysisResult") {
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
        view: groupview,
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // ���˻�����Ϣ / ҽ����Ϣ / 
            var viewDiv = "";
            var patDiv = "";
            var ordDiv = "";
            var wardDiv = "";
            patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
            // patDiv += '<div >' + rowData.patNo + '</div>';
            // patDiv += '<div>/</div>';
            patDiv += '<div style="width:80px">' + rowData.patName + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patSex + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patAge + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div style="width:40px">' + rowData.bedNo + '</div>';
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
    $('#gridAdm').datagrid('query', {
        inputParams: patNo + '^' + session['LOGON.HOSPID']
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
        inputStr: params
    });
}

///��ѯҽ��
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    $('#gridOrdItem').datagrid({
	    url:$URL + "?ClassName=web.DHCSTPIVAS.OeAudit&MethodName=JsGetOeAuditDetailOne",
        pageNumber: 1,
        queryParams: {
            inputStr: params,
            pid: ''
        }
    });
}

/// ��ȡ����
function QueryParams(queryType) {
    var wardIdStr = "";
    var startDate = $('#dateStart').datebox('getValue'); // ��ʼ����
    var endDate = $('#dateEnd').datebox('getValue'); // ��ֹ����
    var startTime = ""; // $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var endTime = ""; // $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��

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
                $("#gridOrdItem").datagrid("clear");
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
            }
            /*
            var wardSelect = $('#gridWard').datagrid('getSelected');
            if (wardSelect == null) {
	            $.messager.popover({msg:"��ѡ����",type:'alert'});
                return "";
            }
            wardIdStr = wardSelect.wardId;*/
            //admId = admSelected.admId;
        } else if (tabTitle == "���ǼǺ�") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                $.messager.popover({
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
    var SkinFlag = $('#chkSkinFlag').checkbox('getValue');
    if (SkinFlag == false) {
        var SkinFlag = 0;
    } else {
        var SkinFlag = 1;
    }
    var NoFeeAuditFlag = $('#chkNoFeeAuditFlag').checkbox('getValue');
    if (NoFeeAuditFlag == false) {
        var NoFeeAuditFlag = 0;
    } else {
        var NoFeeAuditFlag = 1;
    }
    var params = startDate + "^" + endDate + "^" + startTime + "^" + endTime + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId + "^" + SkinFlag + "^" + NoFeeAuditFlag;
    return params;
}

/// �������ͨ��
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ���¼",
            type: 'alert'
        });
        return;
    } else {
	    var gridSel=$('#gridOrdItem').datagrid('getSelected');
        var passResult = gridSel.passResult;
        if (passResult=="N"){
		    DHCPHA_HUI_COM.Msg.popover({
		        msg: "��ѡ��ļ�¼Ϊ�ܾ�״̬",
		        type: 'alert'
		    });
		    return;
	    }else if (passResult=="NY"){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "��ѡ��ļ�¼Ϊ�ܾ�״̬,��ҽ���ѽ���",
		        type: 'alert'
		    });
		    return;
		}else if (passResult=="Y"){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "��ѡ��ļ�¼�Ѿ�Ϊͨ��״̬",
		        type: 'alert'
		    });
		    return;
		}
		if ((gridSel.warnFlag).indexOf("��ʿ�ܾ�")>=0){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "��ѡ��ļ�¼�Ѿ���ʿ�ܾ�",
		        type: 'alert'
		    });
		    return;
		}
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
        NeedScroll = "";
		// ��reload,����ֱ��updateRow,��������޸İ�
        $("#gridOrdItem").datagrid("reload")
    })
}

/// ������˾ܾ�����
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
	    DHCPHA_HUI_COM.Msg.popover({
	        msg: "����ά���������ԭ��",
            type: 'alert'	    
	    });
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    var warnMsg="";
    if (dateMOeoriStr == "") {
	    warnMsg="��ѡ���¼";
    } else {
	    var gridSel=$('#gridOrdItem').datagrid('getSelected');
        var passResult = gridSel.passResult;
        if (passResult=="N"){
	        warnMsg="��ѡ��ļ�¼Ϊ�ܾ�״̬";
	    }else if (passResult=="NY"){
		    warnMsg="��ѡ��ļ�¼Ϊ�ܾ�״̬,��ҽ���ѽ���";
		}else if (passResult=="Y"){
			warnMsg="��ѡ��ļ�¼�Ѿ�Ϊͨ��״̬";
		}
		if (warnMsg==""){
			if ((gridSel.warnFlag).indexOf("��ʿ�ܾ�")>=0){
				warnMsg="��ѡ��ļ�¼�Ѿ���ʿ�ܾ�";
			}
			if ((gridSel.warnFlag).indexOf("��ʿδ����")>=0){
				warnMsg="��ѡ��ļ�¼��ʿδ����ҽ��";
			}
		}
    }
	if (warnMsg!=""){
		DHCPHA_HUI_COM.Msg.popover({
	        msg: warnMsg,
	        type: 'alert'
	    });
	    return;
	}
    $('#reasonSelectDiv').window({
        'title': "��˾ܾ�ԭ��ѡ��"
    });
    $('#reasonSelectDiv').dialog('open');
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
    $('#txtReasonNotes').val("");
    if (passVal == 0) {
        $('#reasonSelectDiv').dialog('close');
    } else {
        $.messager.alert('��ʾ', passInfo, 'warning');
        return;
    }
    NeedScroll = "";
    $("#gridOrdItem").datagrid("reload")
}

///ȡ���������
function CancelAudit() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "��ѡ���¼",
            type: 'alert'
        });
        return;
    }

    var conditionHtml = "��ȷ��ȡ�����?";
    $.messager.confirm('��ܰ��ʾ', conditionHtml, function (r) {
        if (r) {
            var dateMOeori = gridSelect.dateMOeori;
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPass", dateMOeori, SessionUser)
            var cancelRetArr = cancelRet.split("^");
            var cancelVal = cancelRetArr[0] || "";
            if (cancelVal == "-1") {
                $.messager.alert('��ʾ', cancelRetArr[1], "warning");
                return;
            }
            NeedScroll = "";
            $("#gridOrdItem").datagrid("reload");
        }
    });
}

/// �������
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "��ѡ���¼",
            type: 'alert'
        });
        return;
    }
    var adm = gridSelect.admId;
    PIVAS.ViewEMRWindow({}, adm);
}

/// ��ȡѡ�����ҽ����
function GetDateMainOeoriStr() {
    var gridSel = $('#gridOrdItem').datagrid('getSelected') || "";
    if (gridSel == "") {
        return "";
    }
    return gridSel.dateMOeori;
}


function AuditRecordLog() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "��ѡ���¼",
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
        FormulaId = tkMakeServerCall("web.DHCSTPIVAS.Common", "GetDIIIdByDesc", FormulaDesc)

    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "gridOrdItem",
            MOeori: "mOeori",
            GridType: "EasyUI",
            Field: "analysisResult",
            CallBack: function () {}
        })
    }else if (PIVAS.VAR.PASS=="DT"){
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


// ����������漰��������ʱglobal
function ClearTmpGlobal() {
    var rowsData = $("#gridOrdItem").datagrid("getRows") || "";
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "KillOeAudit", pid)
}
window.onbeforeunload = function () {
    ClearTmpGlobal();
}

// ��ʾ�Ҳ���ϸ
function ShowOrderDetail(mOeori) {
    $("#lyOrdDetail [id^='oe']").html("");
    var retData = $.cm({
        ClassName: "web.DHCSTPIVAS.OrderInfo",
        MethodName: "GetOrderJson",
        MOeori: mOeori
    }, false)
    var orderObj = retData.order;
    $("#lyOrdDetail [id^='oe']").each(function () {
        if (this.id == "oePIVASRemark") {
            $(this).val(orderObj[this.id] || "");
        } else {
            $(this).html(orderObj[this.id] || "");
        }
    });

    $('#gridOrderDrugs').datagrid('loadData', retData.drugs);
    $("#oeDiag").tooltip({
        content: $("#oeDiag").text(),
        position: 'left',
        showDelay: 500
    });
    // ����Ĭ�Ϲؼ���
    var kwWord = "" //orderObj.kwWord||"";
    if (kwWord != "") {
        $("#kwMore").keywords("select", kwWord);
    } else {
        var curKW = $("#kwMore").keywords("getSelected");
        if (curKW[0]) {
            var title = curKW[0].text;
            $("#kwMore").keywords("select", title);
        }
    }
}

function ClearOrderDetail() {

    $("#lyOrdDetail [id^='oe']").text("");
    $("#lyOrdDetail [id^='oe']").val("");
    $('#gridOrderDrugs').datagrid('clear');
    $("#gridMedHistory").datagrid("clear");
    $("#gridTPN").datagrid("clear");
    $("#gridMedInfo").datagrid("clear");
}

function InitGridOrderDrugs() {
    //����columns
    var columns = [
        [{
                field: "oeoriName",
                title: 'ҩƷ����',
                width: 250,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'spec',
                title: '���',
                width: 80
            },
            {
                field: 'dosage',
                title: '����',
                width: 75
            },
            {
                field: 'arcim',
                title: 'ҽ����ID',
                width: 75,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        pagination: false,
        fit: true,
        rownumbers: true,
        columns: columns,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function (data) {
            var rows = data.rows;
            if (rows) {
                if (rows.length > 0) {
                    //	$(this).datagrid("selectRow",0);
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrderDrugs", dataGridOption);
}

function InitTPN() {
    $("#divTPNGrid").height($("#divMoreCenter").height());
	$("#divTPNGrid").width($("#divMedInfoGrid").width());
    var dataGridOption = {
        url: "",
        border: true,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [{
                    field: 'ingIndItmDesc',
                    title: 'ָ��',
                    width: 100,
                    align: 'left',
                    halign: 'center',
                },
                {
                    field: 'ingIndItmValue',
                    title: 'ֵ',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'ingIndItmRange',
                    title: '��Χ(~)',
                    width: 75,
                    align: 'left',
                    formatter: function (value, row, index) {
                        return (row.ingIndItmMin || "") + "~" + (row.ingIndItmMax || "");
                    }
                }, {
                    field: 'ingIndItmOk',
                    title: '����',
                    width: 75,
                    hidden: true
                }
            ]
        ],
        rowStyler: function (index, row) {
            var isOk = row.ingIndItmOk;
            if (isOk == "1") {
                return {
                    class: "grid-form-high"
                }
            } else if (isOk == "-1") {
                return {
                    class: "grid-form-low"
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridTPN", dataGridOption);
}


function InitMedHistory() {
	$("#divMedHistoryGrid").width($("#divMedInfoGrid").width());
    var columns = [
        [{
                field: 'doseDate',
                title: '����',
                width: 100
            },
            {
                field: 'oeoriInfo',
                title: 'ҽ��',
                width: 333
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init("gridMedHistory", dataGridOption);

}

function LoadMedHistory() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        $.messager.popover({
            msg: "��ѡ���¼",
            type: 'alert'
        });
        $("#gridMedHistory").datagrid("clear");
        return;
    }
    $('#gridMedHistory').datagrid("options").url=$URL;
    $('#gridMedHistory').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'MedHistory',
        InputStr: gridSelect.admId + "^" + "Chemotherapeutic",
    });
}

function LoadTPN() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        $.messager.popover({
            msg: "��ѡ���¼",
            type: 'alert'
        });
        $("#gridTPN").datagrid("clear");
        return;
    }
    $('#gridTPN').datagrid("options").url=$URL;
    $('#gridTPN').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.Formula',
        QueryName: 'OeoriIngrIndItm',
        inputStr: gridSelect.mOeori + "^" + FormulaId
    });
}


function LoadMedInfo() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        //$.messager.popover({msg:"��ѡ���¼",type:'alert'});
        $("#gridMedInfo").datagrid("clear");
        return;
    }
    $('#gridMedInfo').datagrid("options").url=$URL;
    $('#gridMedInfo').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'OrderMedInfo',
        MOeori: gridSelect.mOeori,
        LocId: session['LOGON.CTLOCID']
    });
}

function InitMedInfo() {
    var columns = [
        [{
                field: 'arcimDesc',
                title: 'ҽ������',
                width: 100,
                hidden: true
            },
            {
                field: 'drugInfo',
                title: '������Ϣ',
                width: 430
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        fitColumns: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false,
        groupField: 'arcimDesc',
        view: groupview,
        groupFormatter: function (value, rows) {
            // var sameCnt=rows[0].sameCnt;
            // if (sameCnt>1){
            // }
            return value;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridMedInfo", dataGridOption);
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
			        	newWarnFlag="��ע";
			        }else{
				        if (oldWarnFlag.indexOf("��ע")<0){
				    		newWarnFlag=oldWarnFlag+"</br>��ע";
				        }
				    }
				    if (rText==""){
					    newWarnFlag=newWarnFlag.replace(/<\/br>��ע/g,"");
						newWarnFlag=newWarnFlag.replace(/��ע/g,"");
					}
			        $('#gridOrdItem').datagrid('updateRow',{
				    	index:rowIndex,
				    	row:{
					    	warnFlag:newWarnFlag
					    }
				    });
				    $("#oePhaRemark").text(rText);
		        } else {
		            $.messager.alert('��ʾ', passInfo, 'warning');
		        }
		    })
		}	
	});
}
