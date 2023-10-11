/*
 *ģ��:סԺҩ��
 *��ģ��:ҵ���ѯ-������ҩ�ض���ѯ
 *createdate:2016-12-15
 *creator:xueshuaiyi
 */
DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
var QUERYPID = "";
$(function () {
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
    /* ��ʼ����� start*/
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitPhaWard(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitDispCat(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPoisonCat();
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitWardQueryList();
    //�ǼǺŻس��¼�
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                Query();
            }
        }
    });
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* �󶨰�ť�¼� end*/
    ;
    $("#wardquerygrid").closest(".panel-body").height(GridCanUseHeight(1));
})


//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "390px"
    }
    InitLocInci(locincioptions)
}
//��ʼ������
function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        width: '15em',
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        $("#sel-locinci").empty();
        InitThisLocInci($(this).val());
        InitDispCat($(this).val());
        $("#sel-phaward").empty();
        InitPhaWard($(this).val());
    });
}
//��ʼ������
function InitPhaWard(locid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+ locid,
        placeholder: "����...",
        width: '15em'
    }
    $("#sel-phaward").dhcphaSelect(selectoption)
}
//��ʼ����ҩ���
function InitDispCat(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" + locrowid,
        placeholder: "��ҩ���...",
        minimumResultsForSearch: Infinity
        //multiple: true	
    }
    $("#sel-dispcat").dhcphaSelect(selectoption)
}
//��ʼ�����Ʒ���
function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPoisonCatDs&style=select2",
        allowClear: true,
        placeholder: "���Ʒ���...",
        minimumResultsForSearch: Infinity
    }
    $("#sel-poison").dhcphaSelect(selectoption)
    $('#sel-poison').on('select2:select', function (event) {
        //alert(event)
    });
}
//��ʼ����ҩ��ѯ�б�
function InitWardQueryList() {
    //����columns
    var columns = [
        [{
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100,
                align: 'left'
            },
            {
                field: 'patName',
                title: '����',
                width: 100,
                align: 'left'
            },
            {
                field: 'incCode',
                title: 'ҩƷ����',
                width: 100,
                align: 'left'
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 250,
                align: 'left'
            },
            {
                field: 'qty',
                title: '����',
                width: 80,
                align: 'right',
                sortable: false
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 50,
                align: 'left'
            },
            {
                field: 'spAmt',
                title: '���',
                width: 70,
                align: 'right'
            },
            {
                field: 'pid',
                title: '���̺�',
                width: 70,
                hidden: true
            }

        ]
    ];

    var dataGridOption = {
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.WardIncStat.Display&MethodName=EuiGetWardPatInc",
        columns: columns,
        fitColumns: true,
        showFooter: true,
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
                QUERYPID = $(this).datagrid("getRows")[0].pid;
                $(this).datagrid("options").queryParams.Pid = QUERYPID;
            }
        }
    }
    //����datagrid	
    $('#wardquerygrid').dhcphaEasyUIGrid(dataGridOption);
}


///��ѯ
function Query() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    var patno = $("#txt-patno").val();
    var patname = $("#txt-name").val();
    var ward = $("#sel-phaward").val();
    if (ward == null) {
        dhcphaMsgBox.alert("��������Ϊ�գ�");
        return;
    }
    var incirowid = $("#sel-locinci").val();
    if (incirowid == null) {
        incirowid = "";
    }
    var dispcat = $("#sel-dispcat").val();
    if (dispcat == null) {
        dispcat = "";
    }
    var poisonrowid = $("#sel-poison").val();
    if (poisonrowid == null) {
        poisonrowid = "";
    }
    KillTmpGloal();
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + incirowid +
        tmpSplit + patno + tmpSplit + ward + tmpSplit + phaloc + tmpSplit + dispcat + tmpSplit + poisonrowid +
        tmpSplit + patname
    $('#wardquerygrid').datagrid({
        queryParams: {
            InputStr: params,
            Pid: ""
        }
    });
}

//���
function ClearConditions() {
    KillTmpGloal();
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    $("#txt-name").val("");
    $("#txt-patno").val("");
    $("#sel-locinci").empty();
    $("#sel-poison").empty();
    $("#sel-phaward").empty();
    $("#sel-dispcat").empty();
    $('#wardquerygrid').clearEasyUIGrid();
}

// �����ʱglobal
function KillTmpGloal() {
    tkMakeServerCall("web.DHCINPHA.WardIncStat.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
    KillTmpGloal();
}