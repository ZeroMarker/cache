/**
 * ģ��:	�ƶ�ҩ��
 * ��ģ��:	�ƶ�ҩ��-��ʿȡҩ��ҩ����
 * Creator:	hulihua
 * CreateDate:	2017-04-06
 */
var takenurseid = ""; //ȡҩ��ʿ����
var collectuserid = ""; //��ҩ�˹���
var phdrrowidstr = ""; //���ѡ��ı�ҩID��
var wardrowidstr = ""; //���ѡ��ı�ҩ������
DhcphaTempBarCode = "";

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
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    InitPhaWard(); //����
    InitThisLocInci(); //ҩƷ
    InitGridDispWardDraw(); //��ʼ����ҩ���б�
    InitDispTotalList(); //��ʼ����ҩ����
    InitDispDetailList(); //��ʼ����ҩ��ϸ

    /* ��Ԫ���¼� start*/
    //���Żس������¼�
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetUserInfo();
        }
    });

    //�������Żس�������ѯ�¼�
    $('#txt-connectno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            QueryInPhDrawDispList();
            $('#txt-connectno').val("");
            DhcphaTempBarCode = "";
        }
    });

    //��ʿ���Żس������¼�
    $('#txt-nurseno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetNurseInfo();
        }
    });

    //�ǼǺŻس��¼�
    $('#txt-regno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-regno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryInDrawDetail();
            }
        }
    });

    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    InitBodyStyle();
    document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
    setTimeout("QueryInPhDrawDispList()", 200);
    DhcphaTempBarCode = "";
}

//ɨ��������빤��֮����֤�Լ�������
function SetUserInfo() {
    var cardno = $.trim($("#txt-cardno").val());
    $('#fyusername').text("");
    if (cardno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", cardno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("���빤���������ʵ!");
            $('#txt-cardno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        collectuserid = ss[0];
        $('#fyusername').text(ss[2]);
        $('#txt-cardno').val("");
        ConfirmDisp();
    }
}

//ɨ�軤ʿ����֮����֤�Լ�������
function SetNurseInfo() {
    var nurseno = $.trim($("#txt-nurseno").val());
    takenurseid = "";
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    if (nurseno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", nurseno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("���빤���������ʵ!");
            $('#txt-nurseno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        takenurseid = ss[0];
        $('#currentnurse').text(ss[2]);
        $('#currentctloc').text(ss[4]);
        $('#txt-nurseno').val("");
    }
}

function DispQuery() {
    var lnk = "dhcpha/dhcpha.inpha.dispquery.csp";
    websys_createWindow(lnk, "�ѷ�ҩ��ѯ", "width=95%,height=90%")
}

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
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    InitTakeDrugUserModal();
    $("#sel-locinci").empty();
}

//��ʼ������ҩ���б�table
function InitGridDispWardDraw() {
    var columns = [{
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
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
            name: "TPhdrID",
            index: "TPhdrID",
            header: 'TPhdrID',
            width: 10,
            hidden: true
        },
        {
            name: "TPhdrNo",
            index: "TPhdrNo",
            header: '��ҩ����',
            width: 120
        },
        {
            name: "TPhdrDateComp",
            index: "TPhdrDateComp",
            header: '�������',
            width: 140
        },
        {
            name: "TPhdrUserComp",
            index: "TPhdrUserComp",
            header: '��ҩ�����',
            width: 120
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetInPhDrawDispList', //��ѯ��̨	
        height: DhcphaJqGridHeight(1, 1) - 35,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            KillDetailTmp();
            $('#usercompname').text("");
            $("#grid-dispdetail").jqGrid("clearGridData");
            if (id == null) {
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
            } else {
                QueryInDispTotal();
            }
        }
    };
    $('#grid-wardinphreqlist').dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ����table
function InitDispTotalList() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 100,
            align: 'left',
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '����״̬',
            width: 80,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: 'ҩƷ����',
            width: 200,
            align: 'left'
        },
        {
            name: "TActDispQty",
            name: "TActDispQty",
            header: 'ʵ������',
            width: 80,
            align: 'right'
        },
        {
            name: "TDspQty",
            name: "TDspQty",
            header: '��������',
            width: 80,
            align: 'right'
        },
        {
            name: "TPhdQty",
            name: "TPhdQty",
            header: '��ҩ����',
            width: 80,
            align: 'right'
        },
        {
            name: "TRefuseQty",
            name: "TRefuseQty",
            header: '�ܾ�����',
            width: 80,
            align: 'right'
        },
        {
            name: "TDspQty",
            name: "TCalDspQty",
            header: '��������',
            width: 80,
            align: 'right'
        },
        {
            name: "TReturnQty",
            name: "TReturnQty",
            header: '��������',
            width: 80,
            align: 'right'
        },
        {
            name: "TUom",
            name: "TUom",
            header: '��λ',
            width: 60
        },
        {
            name: "TDrugForm",
            name: "TDrugForm",
            header: '����',
            width: 100
        },
        {
            name: "TSpec",
            name: "TSpec",
            header: '���',
            width: 100
        },
        {
            name: "TManf",
            name: "TManf",
            header: '����',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TStkBin",
            name: "TStkBin",
            header: '��λ',
            width: 100,
            align: 'left'
        },
        {
            name: "TGeneric",
            name: "TGeneric",
            header: 'ͨ����',
            width: 150,
            align: 'left'
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetQueryDispList&querytype=total',
        height: DhcphaJqGridHeight(2, 1) - 42,
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-disptotal').dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ϸtable
function InitDispDetailList() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 80,
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '����״̬',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '����',
            width: 125,
            formatter: splitFormatter,
            align: 'left'
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '����',
            width: 80
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '����',
            width: 80
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '�ǼǺ�',
            width: 80
        },
        {
            name: "TPatAge",
            index: "TPatAge",
            header: '����',
            width: 60
        },
        {
            name: "TPatSex",
            index: "TPatSex",
            header: '�Ա�',
            width: 60
        },
        {
            name: "TArcimDesc",
            index: "TArcimDesc",
            header: 'ҩƷ����',
            width: 200,
            align: 'left'
        },
        {
            name: "TActDispQty",
            name: "TActDispQty",
            header: 'ʵ������',
            width: 50,
            align: 'right'
        },
        {
            name: "TDspQty",
            index: "TDspQty",
            header: '��������',
            width: 50,
            align: 'right'
        },
        {
            name: "TPhdQty",
            index: "TPhdQty",
            header: '��ҩ����',
            width: 50,
            align: 'right'
        },
        {
            name: "TRefuseQty",
            index: "TRefuseQty",
            header: '�ܾ�����',
            width: 50,
            align: 'right'
        },
        {
            name: "TCancelQty",
            index: "TCancelQty",
            header: '��������',
            width: 50,
            align: 'right'
        },
        {
            name: "TUom",
            index: "TUom",
            header: '��λ',
            width: 50
        },
        {
            name: "TOrdStatus",
            index: "TOrdStatus",
            header: 'ҽ��״̬',
            width: 60
        },
        {
            name: "TDoseQty",
            index: "TDoseQty",
            header: '����',
            width: 60
        },
        {
            name: "TFreq",
            index: "TFreq",
            header: 'Ƶ��',
            width: 60
        },
        {
            name: "TInstruction",
            index: "TInstruction",
            header: '�÷�',
            width: 80
        },
        {
            name: "TDuration",
            index: "TDuration",
            header: '�Ƴ�',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '������',
            width: 90
        },
        {
            name: "TOrdAuditResult",
            index: "TOrdAuditResult",
            header: 'ҽ�����',
            width: 80
        },
        {
            name: "TGeneric",
            index: "TGeneric",
            header: 'ͨ����',
            width: 150
        },
        {
            name: "TForm",
            index: "TForm",
            header: '����',
            width: 100
        },
        {
            name: "TSpec",
            index: "TSpec",
            header: '���',
            width: 80
        },
        {
            name: "TManf",
            index: "TManf",
            header: '����',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TStkBin",
            index: "TStkBin",
            header: '��λ��',
            width: 100
        },
        {
            name: "TUserAdd",
            index: "TUserAdd",
            header: '����ҽ��',
            width: 60
        },
        {
            name: "TDiagnose",
            index: "TDiagnose",
            header: '���',
            width: 300,
            align: 'left'
        },
        {
            name: "TSkinTest",
            index: "Taction",
            header: '��ע',
            width: 80
        },
        {
            name: "TDataDosing",
            index: "TDataDosing",
            header: '�ַ�����',
            width: 80
        },
        {
            name: "TTimeDosing",
            index: "TTimeDosing",
            header: '�ַ�ʱ��',
            width: 120
        },
        {
            name: "TCookType",
            index: "TCookType",
            header: '��ҩ��ʽ',
            width: 80,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetQueryDispList&querytype=detail',
        height: DhcphaJqGridHeight(2, 2) - 58,
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        pager: "#jqGridPager1", //��ҳ�ؼ���id  
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-dispdetail').dhcphaJqGrid(jqOptions);
    $("#refresh_grid-dispdetail").hide(); //�˴�ˢ��������
}

//��ʼ��ҩƷѡ��
function InitThisLocInci() {
    var phaloc = $('#sel-phaloc').val();
    var locincioptions = {
        id: "#sel-locinci",
        locid: phaloc
    }
    InitLocInci(locincioptions)
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "��ҩ����") {
        $("#sp-title").text("��ҩ��ϸ");
        $("#div-total").hide();
        $("#div-detail").show();
        if ($("#grid-dispdetail").getGridParam('records') == 0) {
            if ($("#grid-disptotal").getGridParam('records') > 0) {
                var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
                Pid = firstrowdata.TPID
            }
            QueryInDispTotal(Pid);
        }
    } else {
        $("#sp-title").text("��ҩ����")
        $("#div-detail").hide();
        $("#div-total").show(); //ÿ�ε�����ܶ�Ҫ���»���
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
        QueryInDispTotal(Pid);
    }
}

//��ѯ����ҩ��ҩ��
function QueryInPhDrawDispList() {

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
    var wardloc = $('#sel-phaward').val();
    if (wardloc == null) {
        wardloc = ""
    }
    var phrstatus = "30"; //ҩ����ҩ���
    var phrtypestr = "2"; //2-ȡҩ
    var connectno = $('#txt-connectno').val();
    if (connectno != "") {
        var checkconnectno = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "CheckConnectNo", connectno, phaloc);
        if (checkconnectno == "") {
            dhcphaMsgBox.alert("�ñ�ǩ��δ��ɱ�ҩ�����Ѿ����ϣ����ʵ!");
            return;
        }
    }

    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaloc + "^" + wardloc + "^" + phrstatus + "^" + phrtypestr + "^" + connectno;
    $("#grid-wardinphreqlist").setGridParam({
        datatype: 'json',
        page: 1,
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    ClearConditons();
}

function QueryInDrawDetail() {
    KillDetailTmp();
    QueryInDispTotal("");
    //$("#txt-regno").val("");
}

function QueryInDispTotal(Pid) {
    if (Pid == undefined) {
        Pid = "";
    }
    var params = GetQueryDispParams();
    if (params != "") {
        if ($("#div-detail").is(":hidden") == false) {
            $("#grid-dispdetail").setGridParam({
                datatype: 'json',
                page: 1,
                postData: {
                    params: params,
                    ProcessId: Pid
                }
            }).trigger("reloadGrid");
        } else {
            $("#grid-disptotal").setGridParam({
                datatype: 'json',
                page: 1,
                postData: {
                    params: params,
                    ProcessId: Pid
                }
            }).trigger("reloadGrid");
        }
    }
}

//��ҩ��,��ҩ��ѡ��
function InitTakeDrugUserModal() {
    $("#btn-takenurse-sure").on("click", function () {
        if ((takenurseid == "") || (takenurseid == null)) {
            dhcphaMsgBox.alert("ȡҩ�˲���Ϊ�գ���ɨ��ȡҩ��!");
            return;
        }
        $("#modal-inphaphauser").modal('hide');
        var dispoptions = {
            takenurseid: takenurseid
        }
        ExecuteDisp(dispoptions);
    });
}

//��ҩ
function ConfirmDisp() {
    DhcphaTempBarCode = "";
    var warnflag = "";
    if ($("#sp-title").text() == "��ҩ��ϸ") {
        if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
            return;
        } else {
            var dispgridrows = $("#grid-dispdetail").getGridParam('records');
            if (dispgridrows < 1) {
                dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ�ı�ҩ��!");
                return;
            }
            for (var i = 1; i <= dispgridrows; i++) {
                var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i);
                var tmpcollstat = tmpselecteddata["TCollStat"];
                if (tmpcollstat.indexOf("����") >= 0) {
                    warnflag = "1";
                    break;
                }
            }
        }
    } else if ($("#sp-title").text() == "��ҩ����") {
        if (DhcphaGridIsEmpty("#grid-disptotal") == true) {
            return;
        } else {
            var dispgridrows = $("#grid-disptotal").getGridParam('records');
            if (dispgridrows < 1) {
                dhcphaMsgBox.alert("����ѡ����Ҫ��ҩ�ı�ҩ��!");
                return;
            }
            for (var i = 1; i <= dispgridrows; i++) {
                var tmpselecteddata = $("#grid-disptotal").jqGrid('getRowData', i);
                var tmpcollstat = tmpselecteddata["TCollStat"];
                if (tmpcollstat.indexOf("����") >= 0) {
                    warnflag = "1";
                    break;
                }
            }

        }
    }
    if (collectuserid == "") {
        dhcphaMsgBox.alert("��ҩ�˲���Ϊ�գ���ɨ�跢ҩ��!");
        if (CheckTxtFocus() == true) {
            $("#txt-cardno").focus();
        }
        return;
    }
    if (warnflag == "1") {
        if (confirm("��ѡ��ҩ�����������뱸ҩ�������������ʵ�Ƿ��г��������ܾ���ҩ��ҩƷ") == false) {
            return;
        }
    }
    dhcphaMsgBox.confirm("��ҩ��Ϊ  <b><font color=#CC1B04 size=6 >" + $('#fyusername').text() + "</font></b>���Ƿ�ȷ�Ϸ�ҩ?", DoDisp);
}

function DoDisp(result) {
    if (result == true) {
        $('#modal-inphaphauser').modal('show');
        $('#currentnurse').text("");
        $('#currentctloc').text("");
        takenurseid = "";
        var timeout = setTimeout(function () {
            $(window).focus();
            if (CheckTxtFocus() != true) {
                $("#txt-nurseno").focus();
                return true;
            }
        }, 500);
    }
}

function ExecuteDisp(dispoptions) {
    var pid = "";
    var phacrowidStr = ""
    if ($("#sp-title").text() == "��ҩ��ϸ") {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    } else if ($("#sp-title").text() == "��ҩ����") {
        var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    }
    var phaloc = $("#sel-phaloc").val();
    var takedruguserid = dispoptions.takenurseid;
    var pwardrowidstr = filterRepeatStr(wardrowidstr);
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var enddate = enddatetime.split(" ")[0];
    var phactype = "2"; //1-��ҩ��2-ȡҩ
    var params = phaloc + "^" + collectuserid + "^" + takedruguserid + "^" + startdate + "^" + enddate + "^" + phactype;

    var wardArr = pwardrowidstr.split(",");
    for (var wardi = 0; wardi < wardArr.length; wardi++) {
        var wardid = wardArr[wardi];
        var wardphdrstr = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "GetWardPhdrStr", wardid, phdrrowidstr);
        if (wardphdrstr == "") {
            continue;
        }
        var PhacRowid = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "SaveDispData", pid, wardid, params, wardphdrstr);
        if (PhacRowid > 0) {
            if (phacrowidStr != "") {
                phacrowidStr = phacrowidStr + "A" + PhacRowid;
            } else {
                phacrowidStr = PhacRowid;
            }
        } else if (PhacRowid < 0) {
            alert("��ҩʧ��," + PhacRowid);
        }
    }
    if ((phacrowidStr == "") || (phacrowidStr == 0)) {
        dhcphaMsgBox.alert("δ����ҩƷ!");
        return;
    }
    KillDetailTmp();
    QueryInPhDrawDispList();
    QueryInDispTotal();
}

function ClearConditons() {
    //$('#grid-wardinphreqlist').clearJqGrid(); 
    KillDetailTmp();
    $('#grid-disptotal').clearJqGrid();
    $('#grid-dispdetail').clearJqGrid();
    DhcphaTempBarCode = "";
}

function InitBodyStyle() {
    $('#div-conditions').collapse('show');
    $('#div-conditions').on('hide.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        tmpheight = tmpheight + $("#div-conditions").height();
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $('#div-conditions').on('show.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $("#grid-disptotal").setGridWidth("");
    $("#grid-dispdetail").setGridWidth("");
    $("#div-detail").hide();
    var wardtitleheight = $("#gview_grid-wardinphreqlist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 10;
    $("#grid-wardinphreqlist").setGridHeight(wardheight);
    $("#tab-patno").hide();
}

//������ѡ
function GetQueryDispParams() {
    phdrrowidstr = "";
    wardrowidstr = "";
    if ($("div-wardinphreq-condition").is(":hidden") == false) {
        var selectid = $("#grid-wardinphreqlist").jqGrid('getGridParam', 'selrow');
        if ((selectid == "") || (selectid == null)) {
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }

        var selrowdata = $("#grid-wardinphreqlist").jqGrid('getRowData', selectid);
        var usercomp = selrowdata.TPhdrUserComp;
        $('#usercompname').text(usercomp);
        phdrrowidstr = selrowdata.TPhdrID;
        wardrowidstr = selrowdata.TWardLocId;
    } else {
        dhcphaMsgBox.alert("��ˢ�½��������!");
        return "";
    }
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var phrstatus = "30";
    var patno = $("#txt-regno").val();

    var params = phdrrowidstr + "^" + phrstatus + "^" + incirowid + "^" + phaloc + "^" + patno;
    return params;
}

//������ѡ
function GetQueryDispParamsD() {
    phdrrowidstr = "";
    wardrowidstr = "";
    if ($("div-wardinphreq-condition").is(":hidden") == false) {
        var selectids = $("#grid-wardinphreqlist").jqGrid('getGridParam', 'selarrrow');
        if ((selectids == "") || (selectids == null)) {
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }
        $.each(selectids, function () {
            var selrowdata = $("#grid-wardinphreqlist").jqGrid('getRowData', this);
            var usercomp = selrowdata.TPhdrUserComp;
            $('#usercompname').text(usercomp);
            var phdrrowid = selrowdata.TPhdrID;
            var wardrowid = selrowdata.TWardLocId;
            if (phdrrowidstr == "") {
                phdrrowidstr = phdrrowid;
                wardrowidstr = wardrowid;
            } else {
                phdrrowidstr = phdrrowidstr + "#" + phdrrowid;
                wardrowidstr = wardrowidstr + "," + wardrowid;
            }
        })
    } else {
        dhcphaMsgBox.alert("��ˢ�½��������!");
        return "";
    }
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("ҩ��������Ϊ��!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var phrstatus = "30";
    var patno = $("#txt-regno").val();

    var params = phdrrowidstr + "^" + phrstatus + "^" + incirowid + "^" + phaloc + "^" + patno;
    return params;
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
}

//�ַ���ȥ�أ�
function filterRepeatStr(str) {
    var ar2 = str.split(",");
    var array = new Array();
    var j = 0
    for (var i = 0; i < ar2.length; i++) {
        if ((array == "" || array.toString().match(new RegExp(ar2[i], "g")) == null) && ar2[i] != "") {
            array[j] = ar2[i];
            array.sort();
            j++;
        }
    }
    return array.toString();
}

function addCollStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val.indexOf("����") >= 0) {
        return "class=dhcpha-record-dispense";
    } else if (val.indexOf("�ܳ�����") >= 0) {
        return "class=dhcpha-record-appeal";
    } else if (val.indexOf("���ܾ�") >= 0) {
        return "class=dhcpha-record-refused";
    } else {
        return "";
    }
}

function KillDetailTmp() {
    var Pid = "";
    if ($("#sp-title").text() == "��ҩ����") {
        if ($("#grid-disptotal").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID;
        }
    } else {
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
    }
    if (Pid != "") {
        tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "KillTmp", Pid);
    }
}

function CheckTxtFocus() {
    var txtfocus1 = $("#txt-cardno").is(":focus");
    var txtfocus2 = $("#txt-connectno").is(":focus");
    var txtfocus3 = $("#txt-nurseno").is(":focus");
    if ((txtfocus1 != true) && (txtfocus2 != true) && (txtfocus3 != true)) {
        return false;
    }
    return true;
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            var BarCode = tkMakeServerCall("web.DHCST.Common.JsonObj", "GetData", DhcphaTempBarCode);
            if (BarCode.indexOf("Y") > -1) {
                $("#txt-connectno").val(BarCode);
                QueryInPhDrawDispList();
                $("#txt-connectno").val("");
            } else {
                $("#txt-cardno").val(BarCode);
                SetUserInfo();
            }
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode);
        }
    }
}

window.onbeforeunload = function () {
    KillDetailTmp();
}