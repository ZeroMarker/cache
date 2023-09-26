/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��ҩ��ҩ����
Creator:	���fӨ
CreateDate:	2017-07-05
*/
var NowTAB = "#div-presc-condition"; // ��¼��ǰtab
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 20 * 1000;

$(function () {
    InitPhaConfig();
    /* ��ʼ����� start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc();
    InitPhaWard();
    InitGridPrescList();
    InitGridAdm();
    InitGridAdmPrescList();
    InitTrialDispTab();
    $("#monitor-condition").children().not("#div-presc-condition").hide();

    /* ��Ԫ���¼� start*/
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryInPhDispList();
            }
        }
    });

    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    //�������а�ť�¼�
    $("button").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* ��Ԫ���¼� end*/

    $("#chk-refresh").on("ifChanged", function () {
        if ($(this).is(':checked') == true) {
            DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryInPhDispList();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
        } else {
            clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
        }
    })
    InitRefuseReasonModal();
    InitBodyStyle();
})

window.onload = function () {
    setTimeout("QueryInPhDispList()", 500);
}

//���뵥��ҩ
function ReqReturn() {
    var lnk = "dhcpha/dhcpha.inpha.returnbyreq.csp";
    websys_createWindow(lnk, "���뵥��ҩ", "width=95%,height=90%")
}

//ֱ����ҩ
function DirectReturn() {
    var lnk = "dhcpha/dhcpha.inpha.return.csp";
    websys_createWindow(lnk, "ֱ����ҩ", "width=95%,height=90%")
}

//�ѷ�������ѯ
function AuditParyQuery() {
    var lnk = "dhcpha/dhcpha.inpha.hmprescdispquery.csp";
    websys_createWindow(lnk, "_target", "width=95%,height=90%")
}

//�����ܾ�
function CancelRefuse() {
    var lnk = "dhcpha/dhcpha.inpha.hmprescrefusequery.csp";
    websys_createWindow(lnk, "_target", "width=95%,height=90%");
}

//��ʼ��ҩ������
function InitPhaConfig() {
    $.ajax({
        type: 'POST', //�ύ��ʽ post ����get  
        url: LINK_CSP + "?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId=" + gLocId,
        data: "",
        success: function (value) {
            if (value != "") {
                SetPhaLocConfig(value)
            }
        },
        error: function () {
            alert("��ȡסԺҩ����������ʧ��!");
        }
    });
}
//����ҩ������
function SetPhaLocConfig(configstr) {
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    var starttime = configarr[4];
    var endtime = configarr[5];
    if (starttime == "") {
        starttime = "00:00:00";
    }
    if (endtime == "") {
        endtime = "23:59:59";
    }
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' ' + starttime);
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' ' + starttime);
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' ' + endtime);
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' ' + endtime);
    
    $("#sel-locinci").empty();
    if (configarr[32] != "Y") {
        $("#btn-pass").attr({
            "disabled": "disabled"
        });
        $("#btn-refuse").attr({
            "disabled": "disabled"
        });
    }
}

//��ʼ�������б�table
function InitGridPrescList() {
    var columns = [{
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '�Ƿ�Ӽ�',
            width: 70
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 140,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 90
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 120
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '�󷽽��',
            width: 62
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '��������',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '�ύ��ʿ',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '�ύʱ��',
            width: 140
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispPrescList', //��ѯ��̨	
        pager: "#jqGridPager", //��ҳ�ؼ���id
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-presclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-presclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        color: '#EE7600',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-presclist').dhcphaJqGrid(jqOptions);
}

//��ʼ���˾���table
function InitGridAdm() {
    var columns = [{
            name: "TAdm",
            index: "TAdm",
            header: 'TAdm',
            width: 10,
            hidden: true
        },
        {
            name: "TCurrWard",
            index: "TCurrWard",
            header: '����',
            width: 100,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 80
        },
        {
            name: "TCurrentBed",
            index: "TCurrentBed",
            header: '����',
            width: 60
        },
        {
            name: "TDoctor",
            index: "TDoctor",
            header: 'ҽ��',
            width: 60
        },
        {
            name: "TAdmDate",
            index: "TAdmDate",
            header: '��������',
            width: 80
        },
        {
            name: "TAdmTime",
            index: "TAdmTime",
            header: '����ʱ��',
            width: 80
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '�������',
            width: 80,
            align: 'left',
            formatter: splitFormatter
        }
    ];

    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //��ѯ��̨
        height: DhcphaJqGridHeight(2, 3) * 0.35,
        multiselect: false,
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                var adm = selrowdata.TAdm;
                $("#grid-admpresclist").jqGrid("clearGridData");
                var params = GetMainCodParams();
                params = params + "^^" + adm;
                $("#grid-admpresclist").setGridParam({
                    datatype: 'json',
                    page: 1,
                    postData: {
                        'params': params
                    }
                }).trigger("reloadGrid");
            }
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-admpresclist").jqGrid("clearGridData");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-admlist').dhcphaJqGrid(jqOptions);
}

//��ʼ�����˾��ﴦ���б�table
function InitGridAdmPrescList() {
    var columns = [{
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '�Ƿ�Ӽ�',
            width: 70
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '����',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 80
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 120
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '�󷽽��',
            width: 62
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '��������',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '����',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '�ύ��ʿ',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '�ύʱ��',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispPrescList', //��ѯ��̨	
        height: DhcphaJqGridHeight(2, 3) * 0.55,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        pager: "#jqGridPager1",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-admpresclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-admpresclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#EE7600',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons() {
    $('#grid-presclist').clearJqGrid();
}

function InitBodyStyle() {

    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 48;
    var prescheight = DhcphaJqGridHeight(1, 0) - 15;
    $("#grid-presclist").setGridHeight(wardheight);
    $("#ifrm-presc").height(prescheight);
}

function InitTrialDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        $("#ifrm-presc").empty();
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        NowTAB = tmpTabId;
        QueryInPhDispList();
    })
}

function QueryInPhDispList() {
    var params = GetMainCodParams();
    if (NowTAB == "#div-presc-condition") {
        var wardloc = $('#sel-phaward').val();
        if (wardloc == null) {
            wardloc = ""
        };
        var Input = params + "^" + wardloc + "^";
        var WardStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetDispWardStr", Input);
        params = params + "^" + WardStr + "^";
        $("#grid-presclist").setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                'params': params
            }
        }).trigger("reloadGrid");
    } else {
        var patno = $("#txt-patno").val();
        if (patno == "") {
            var selectid = $("#grid-admlist").jqGrid('getGridParam', 'selrow');
            var selrowdata = $("#grid-admlist").jqGrid('getRowData', selectid);
            patno = selrowdata.TPatNo;
        }
        $("#grid-admlist").setGridParam({
            page: 1,
            datatype: 'json',
            postData: {
                'params': patno,
                'logonLocId': DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID
            }
        }).trigger("reloadGrid");
    }
    $("#txt-patno").val("");
    return true;
}

//��ѯ��ҩ��ϸ
function QueryGridDispSub() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    var prescform = selrowdata.TPrescForm;
    QueryPrescDetail(prescno);
}

function QueryPrescDetail(prescno) {
    $("#ifrm-presc").empty();
    var htmlstr = GetPrescHtml(prescno);
    $("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml(prescno) {
    var cyflag = "Y";
    var phartype = "DHCINPHA";
    var paramsstr = phartype + "^" + prescno + "^" + cyflag;
    $("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}

//��ȡ��ѯ����
function GetMainCodParams() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return;
    }
    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaloc;
    return params;
}

//ȫ����ť
function AllConfirmDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("���������б�û������!");
        return;
    }
    dhcphaMsgBox.confirm("ȷ��ȫ����?ϵͳ��ȫ�����Ų�ѯ�������д���!", ConfirmDispAll);
}

//ȷ��ȫ��
function ConfirmDispAll(result) {
    if (result == true) {
        if (NowTAB == "#div-presc-condition") {
            var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        } else {
            var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        }
        var prescridrows = prescrowdata.length;
        for (var rowi = 1; rowi <= prescridrows; rowi++) {
            ExecuteDisp(rowi);
        }
        QueryInPhDispList();
    }
}

//��ҩ��ť
function ConfirmDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("�󷽷�ҩ�б�������!");
        return;
    }
    ExecuteDisp(selectid);

    QueryInPhDispList();
}

//ִ�з�ҩ
function ExecuteDisp(selectid) {
    if (NowTAB == "#div-presc-condition") {
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    if ((selectid == null) || (prescno == "") || (prescno == null)) {
        dhcphaMsgBox.alert("��ѡ�񴦷��ٷ�ҩ!");
        return;
    }
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        phaLoc = ""
    }
    if (phaLoc == "") {
        dhcphaMsgBox.alert('������ʾ', "ҩ��������Ϊ��!");
        return;
    }

    var urgentFlag = "N"
    if ($("#chk-urgent").is(':checked')) {
        urgentFlag = "Y";
    }

    var params = prescno + "^" + phaLoc + "^" + gUserID + "^" + urgentFlag;
    var retStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp", "SaveData", params);
    var PhacRowid = retStr.split("^")[0];
    var retMessage = retStr.split("^")[1];
    if (PhacRowid > 0) {
        PrintInphaCom(prescno, PhacRowid)
        SendOrderToMachine(PhacRowid);
        $("#ifrm-presc").empty(); //��ʼ������Ԥ��	 
    } else {
        dhcphaMsgBox.alert("��ҩʧ��,ʧ��ԭ��:" + retMessage);
    }
    return;
}

function InitRefuseReasonModal() {
    $('#modal-inpharefusedispreason').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetRefuseDispReason&style=select2",
            minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-refusedispreason").dhcphaSelect(option);
        $("#sel-refusedispreason").empty();
    })
    $("#btn-refusereason-sure").on("click", function () {
        var refusereason = $("#sel-refusedispreason").val();
        if ((refusereason == "") || (refusereason == null)) {
            dhcphaMsgBox.alert("��ѡ��ܾ�ԭ��!");
            return;
        }
        $("#modal-inpharefusedispreason").modal('hide');
        ExecuteRefuse(refusereason);
    });
}

//�ܾ���ҩ��ťִ�з���
function RefuseDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("�󷽷�ҩ�б������ݣ��޷��ܾ���ҩ!");
        return;
    }

    var prescno = selrowdata.TPrescNo;
    if ((selectid == null) || (prescno == "")) {
        dhcphaMsgBox.alert("��ѡ�񴦷����پܾ���ҩ!");
        return;
    }
    $('#modal-inpharefusedispreason').modal('show');
}

function ExecuteRefuse(resondr) {
    if ((resondr == "") || (resondr == null)) {
        return;
    }
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    var ret = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp", "RefusetDrug", prescno, gUserID, resondr);
    if (ret == 0) {
        QueryInPhDispList();
        $("#ifrm-presc").empty(); //��ʼ������Ԥ��
    } else {
        dhcphaMsgBox.alert('������ʾ', "�ܾ���ҩʧ��,�������:" + ret);
        return;
    }
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};


//���͵���ҩ��
function SendOrderToMachine(pharowid) {
    var SendFlag = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetSendMachineFlag", gLocId);
    if (SendFlag == "Y") {
        var sendret = tkMakeServerCall("web.DHCSTInterfacePH", "SendOrderToMechine", pharowid);
        if (sendret != "0") {
            var retString = sendret.split("^")[1];
            dhcphaMsgBox.alert("����������������ʧ��,�������:" + retString, "error");
            return;
        }
    }
}