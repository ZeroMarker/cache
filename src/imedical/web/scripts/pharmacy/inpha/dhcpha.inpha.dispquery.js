/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺ�ѷ�ҩ��ѯ
 * createdate:2017-02-20
 * creator:dinghongying
 */
$(function () {
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
    var stdatetime = FormatDateT("T") + " " + "00:00:00"
    var eddatetime = FormatDateT("T") + " " + "23:59:59"
    $("#date-start").data('daterangepicker').setStartDate(stdatetime);
    $("#date-start").data('daterangepicker').setEndDate(stdatetime);
    $("#date-end").data('daterangepicker').setStartDate(eddatetime);
    $("#date-end").data('daterangepicker').setEndDate(eddatetime);
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitDocLoc();
    InitDispType();
    InitPhaWard();
    InitFyUser();
    InitDispWardList();
    InitDispMainList();
    InitDispDetailList();
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
    $("#btn-findselect").on("click", QuerySub);
    $("#btn-clear").on("click", ClearConditions);
    $("#a-change").on("click", ChangeDispQuery);
    $("#btn-print").on("click", PrintInDisp);
    /* �󶨰�ť�¼� end*/
    ;
    $("#chk-longord").on("ifClicked", function () {
        if ($(this).is(':checked')) {
            $(this).iCheck('uncheck');
        } else {
            $(this).iCheck('check');
        }
        if ($(this).is(':checked')) {
            $("#chk-shortord").iCheck('uncheck');
        }
    })
    $("#chk-shortord").on("ifClicked", function () {
        if ($(this).is(':checked')) {
            $(this).iCheck('uncheck');
        } else {
            $(this).iCheck('check');
        }
        if ($(this).is(':checked')) {
            $("#chk-longord").iCheck('uncheck');
        }
    })
    ResizeDispQuery()
    $("#div-detail").hide();
})

// ��ʼ��ҩ��
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false,
        placeholder: 'ҩ��...'
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    $('#sel-phaloc').on('select2:select', function (event) {
        InitDispType(event.params.data.id);
		InitPhaWard(event.params.data.id)
    });
    if (DHCPHA_CONSTANT.SESSION.GWARD_ROWID == "") {
    	var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
        $("#sel-phaloc").append(select2option);
    }
}
// ��ʼ��ҽ������
function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&custtype=DocLoc",
        allowClear: true,
        placeholder: 'ҽ������...'
    }
    $("#sel-docloc").dhcphaSelect(selectoption)
    $('#sel-docloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//��ʼ����ҩ���
function InitDispType(recLocId) {
    if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = "";
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" +
            ((recLocId != "") ? recLocId : DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID),
        allowClear: true,
        multiple: false,
        minimumResultsForSearch: Infinity,
        //maximumSelectionLength: 3,  // ����ѡ����Ŀ��
        placeholder: "��ҩ���..."
    }
    $("#sel-disptype").dhcphaSelect(selectoption)
    $('#sel-disptype').on('select2:select', function (event) {
        //alert(event)
    });
}

//��ʼ����ҩ��
function InitFyUser() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetInPhaUser&locId=" +
            DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "&style=select2",
        allowClear: true,
        placeholder: '��ҩ��...'
    }
    $("#sel-fyuser").dhcphaSelect(selectoption)
    $("#sel-fyuser").on('select2:select', function (event) {
        //alert(event)
    });
}
//��Ϊ�����տ�������ȡ���߲���(�������Ժ����ҩ�����)  by zhaoxinlong 2022.04.22
//��ʼ������
function InitPhaWard(recLocId) {
	if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+reclocId,
        placeholder: "����...",
        width: "390px"
    }
    $("#sel-phaward").dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.SESSION.GWARD_ROWID != "") {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.SESSION.GWARD_ROWID + "'" + 'selected>' + DHCPHA_CONSTANT.SESSION.GWARD_DESC + '</option>'
        $("#sel-phaward").append(select2option);
    }
}

//��ʼ����ҩ��ѯ�б�
function InitDispWardList() {
    var columns = [
        [{
                field: "Tcoll",
                title: 'Tcoll',
                width: 40,
                hidden: true
            },
            {
                field: "Tpid",
                title: 'Tpid',
                width: 40,
                hidden: true
            },
            {
                field: "TSelect",
                title: 'TSelect',
                checkbox: true
            },
            {
                field: "TWard",
                title: '����',
                width: 200
            },
            {
                field: "TDispCat",
                title: '����',
                width: 80,
                align: 'center'
            },
            {
                field: "TDateScope",
                title: '���ڷ�Χ',
                width: 100
            },
            {
                field: "TStatus",
                title: '״̬',
                width: 60,
                align: 'center'
            },
            {
                field: "TPrintDate",
                title: '��ӡ����',
                width: 100,
                align: 'center'
            },
            {
                field: "TPrintTime",
                title: '��ӡʱ��',
                width: 100,
                align: 'center'
            },
            {
                field: "TCollectDate",
                title: '��ҩ����',
                width: 100,
                align: 'center'
            },
            {
                field: "TCollectTime",
                title: '��ҩʱ��',
                width: 100,
                align: 'center'
            },
            {
                field: "TOperUser",
                title: '������',
                width: 100,
                align: 'left'
            },
            {
                field: "TCollectUser",
                title: '�ڶ���ҩ��',
                width: 100,
                align: 'left'
            },
            {
                field: "TDispNo",
                title: '��ҩ����',
                width: 240,
                align: 'left'
            },
            {
                field: "TSendAutoFlag",
                title: '��ҩ��',
                width: 100,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollected",
        columns: columns,
        fitColumns: true,
        singleSelect: true,
        checkOnSelect: true,
        selectOnCheck: false,
        onSelect: function (rowIndex, rowData) {
            QuerySub();
        }
    }
    //����datagrid	
    $('#grid-query').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ�����б�
function InitDispMainList() {
    var columns = [
        [{
                field: "Tincicode",
                title: 'ҩƷ����',
                width: 125,
                align: 'left'
            },
            {
                field: "Tincidesc",
                title: 'ҩƷ����',
                width: 300
            },
            {
                field: "Tqty",
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: "Tuom",
                title: '��λ',
                width: 50,
                align: 'center'
            },
            {
                field: "Tprice",
                title: '����',
                width: 70,
                align: 'right'
            },
            {
                field: "Tinciamt",
                title: '��ҩ���',
                width: 75,
                align: 'right'
            },
            {
                field: "Tspec",
                title: '���',
                width: 100
            },
            {
                field: "Tmanf",
                title: '������ҵ',
                width: 250
            },
            {
                field: "Tresqty",
                title: '�������',
                width: 70,
                align: 'right'
            },
            {
                field: "Tresdata",
                title: '�����Ϣ',
                width: 300
            },
            {
                field: "Tgenedesc",
                title: '����ͨ����',
                width: 100,
                align: 'left',
                hidden:true
            },
            {
                field: "Tphcform",
                title: '����',
                width: 60,
                hidden:true
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollTotal",
        columns: columns,
        fitColumns: false
    }
    //����datagrid	
    $('#grid-querytotal').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ��ϸ�б�
function InitDispDetailList() {
    var columns = [
        [{
                field: "TAdmLoc",
                title: '����',
                width: 150
            },
            {
                field: "TBedNo",
                title: '����',
                width: 80
            },
            {
                field: "TPaName",
                title: '����',
                width: 80
            },
            {
                field: "TRegNo",
                title: '�ǼǺ�',
                width: 90
            },
            {
                field: "TOld",
                title: '����',
                width: 70
            },
            {
                field: "TOrdItemDesc",
                title: 'ҩƷ����',
                width: 225
            },
            {
                field: "TQty",
                title: '����',
                width: 70
            },
            {
                field: "TDoseQty",
                title: '����',
                width: 75
            },
            {
                field: "TFreq",
                title: 'Ƶ��',
                width: 75
            },
            {
                field: "TInstruction",
                title: '�÷�',
                width: 80
            },
            {
                field: "TDuration",
                title: '�Ƴ�',
                width: 75
            },
            {
                field: "TDispCat",
                title: '����',
                width: 75
            },
            {
                field: "TPrescno",
                title: '������',
                width: 115,
                align: 'center'
            },
            {
                field: "TJYType",
                title: '��ҩ��ʽ',
                width: 75,
                align: 'center',
				hidden:true
            },
            {
                field: "TStatus",
                title: '״̬',
                width: 75,
                align: 'center',
                hidden: true
            }, //ҽ��״̬,ִ�м�¼״̬���޷���ȷ��ʾ		
            {
                field: "TBatchNo",
                title: '����',
                width: 100
            },
            {
                field: "TDiag",
                title: '���',
                width: 150
            },
            {
                field: "TDoctor",
                title: '����ҽ��',
                width: 80,
                hidden:true
            },
            {
                field: "TOeoriDate",
                title: '��������',
                width: 100
            },
            {
                field: "TDoseDate",
                title: '��ҩ����',
                width: 100,
                align: 'left'
            },
            {
                field: "TDoseTimes",
                title: '��ҩʱ��',
                width: 120,
                align: 'left'
            },
            {
                field: "TEncryptLevel",
                title: '�����ܼ�',
                width: 100,
                align: 'left'
            },
            {
                field: "TPatLevel",
                title: '���˼���',
                width: 100,
                align: 'left'
            },
            {
                field: "TSalePrice",
                title: '�۸�',
                width: 75,
                align: 'right'
            },
            {
                field: "TStotal",
                title: '���',
                width: 75,
                align: 'right'
            },
            {
                field: "TManf",
                title: '������ҵ',
                width: 150,
                align: 'left'
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollDetail",
        columns: columns,
        pagination: false,
        fitColumns: false
    }
    //����datagrid	
    $('#grid-querydetail').dhcphaEasyUIGrid(dataGridOption);
}


///��ѯ
function Query() {
    var inputStr = QueryParams();
    if (inputStr == "") {
        return;
    }
    $('#grid-query').datagrid({
        queryParams: {
            InputStr: inputStr
        }
    });
    $('#grid-querytotal').clearEasyUIGrid();
    $('#grid-querydetail').clearEasyUIGrid();
}
/// ��ѯ��ϸ����
function QuerySub() {
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var selecteddata = $('#grid-query').datagrid('getSelected');
    if (selecteddata == null) {
        //return;	
    }
    var checkedItems = $('#grid-query').datagrid('getChecked');
    if ((checkedItems == null) || (checkedItems == "")) {
        dhcphaMsgBox.alert("�빴ѡ��Ҫͳ�Ƶķ�ҩ��!");
        return;
    }
    var phacIdStr = "";
    $.each(checkedItems, function (index, item) {
        if (phacIdStr == "") {
            phacIdStr = item.Tcoll;
        } else {
            phacIdStr = phacIdStr + "," + item.Tcoll;
        }
    });
    var inputStr = QueryParams();
    params = GetQueryParams("^");
    if ($("#sp-title").text() == "��ҩ��ҩƷ����") {
        $('#grid-querytotal').datagrid({
            queryParams: {
                PhacIdStr: phacIdStr,
                InputStr: inputStr
            }
        });
    } else {
        $('#grid-querydetail').datagrid({
            queryParams: {
                PhacIdStr: phacIdStr,
                InputStr: inputStr
            }
        });
    }
}

// ��ѯ����
function QueryParams() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    if (phaloc == null) {
        dhcphaMsgBox.alert("��ѡ��ҩ��!")
        return "";
    }
    var wardloc = $("#sel-phaward").val();
    if (wardloc == null) {
        wardloc = "";
    }
    var dispuser = $("#sel-fyuser").val();
    if (dispuser == null) {
        dispuser = "";
    }
    var dispcatstr = $("#sel-disptype").val();
    if (dispcatstr == null) {
        dispcatstr = "";
    }
    var docloc = $("#sel-docloc").val();
    if (docloc == null) {
        docloc = "";
    }
    var dispno = $("#txt-dispno").val();
    var regno = $("#txt-patno").val();
    var chklong = "";
    if ($("#chk-longord").is(':checked')) {
        chklong = "Y";
    }
    var chkshort = "";
    if ($("#chk-shortord").is(':checked')) {
        chkshort = "Y";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + wardloc + tmpSplit + dispuser + tmpSplit + dispcatstr + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + docloc + tmpSplit + dispno + tmpSplit + regno + tmpSplit + chklong + tmpSplit + chkshort;;
    return params;
}

// ��ӡ����
function GetQueryParams(splitchar) {
    var checkedItems = $('#grid-query').datagrid('getChecked');
    var paramstr = ""
    var regno = $("#txt-patno").val();
    var chklong = "0";
    if ($("#chk-longord").is(':checked')) {
        chklong = "1";
    }
    var chkshort = "0";
    if ($("#chk-shortord").is(':checked')) {
        chkshort = "1";
    }
    var otherparams = regno + "^" + chklong + "^" + chkshort;
    $.each(checkedItems, function (index, item) {
        if (paramstr == "") {
            paramstr = item.Tcoll + splitchar + otherparams;
        } else {
            paramstr = paramstr + "A" + item.Tcoll + splitchar + otherparams;
        }
    });
    return paramstr;
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "��ҩ��ҩƷ����") {
        $("#sp-title").text("��ҩ����ϸ");
        $("#div-total").hide();
        $("#div-detail").show();
        $('#grid-querydetail').clearEasyUIGrid();
    } else {
        $("#sp-title").text("��ҩ��ҩƷ����")
        $("#div-detail").hide();
        $("#div-total").show(); //ÿ�ε�����ܶ�Ҫ���»���
        $('#grid-querytotal').clearEasyUIGrid();
    }
    QuerySub();
}
//���
function ClearConditions() {
    var stdatetime = FormatDateT("T") + " " + "00:00:00"
    var eddatetime = FormatDateT("T") + " " + "23:59:59"
    $("#date-start").data('daterangepicker').setStartDate(stdatetime);
    $("#date-start").data('daterangepicker').setEndDate(stdatetime);
    $("#date-end").data('daterangepicker').setStartDate(eddatetime);
    $("#date-end").data('daterangepicker').setEndDate(eddatetime);
    $("#txt-patno").val("");
    $("#txt-dispno").val("");
    $("#sel-docloc").empty();
    $("#sel-fyuser").empty();
    $("#sel-disptype").empty();
    $("#sel-phaward").empty();
    $("#chk-shortord").iCheck("uncheck");
    $("#chk-longord").iCheck("uncheck");
    $("#chk-prtdetail").iCheck("uncheck");
    $("#chk-prttotal").iCheck("uncheck");
    $('#grid-query').clearEasyUIGrid();
    $('#grid-querytotal').clearEasyUIGrid();
    $('#grid-querydetail').clearEasyUIGrid();
    $(".datagrid-header-check input").iCheck("uncheck");
}
// ��ӡ
function PrintInDisp() {
    var checkedItems = $('#grid-query').datagrid('getChecked');
    if ((checkedItems == null) || (checkedItems == "")) {
        dhcphaMsgBox.alert("�빴ѡ��Ҫ��ӡ�ķ�ҩ��!");
        return;
    }
    // ��ȡ��ӡ��ʽ: 1-��ϸ,2-����,3-��ϸ+����
    var checkedItems = $('#grid-query').datagrid('getChecked');
    var phacStr = "";
    $.each(checkedItems, function (index, item) {
        if (phacStr == "") {
            phacStr = item.Tcoll;
        } else {
            phacStr = phacStr + "^" + item.Tcoll;
        }
    });
    var otherStr = "";
    var prtdetail = $("#chk-prtdetail").is(':checked') ? 1 : 0;
    var prttotal = $("#chk-prttotal").is(':checked') ? 1 : 0;
    var prttype = "";
    prttype = prtdetail == 1 ? 1 : prttype;
    prttype = prttotal == 1 ? 2 : prttype;
    prttype = (prtdetail == 1) && (prttotal == 1) ? 3 : prttype;
    IPPRINTCOM.Print({
        phacStr: phacStr,
        otherStr: otherStr,
        printType: prttype,
        reprintFlag: 1,
        pid: ''
    });
}
window.onresize = ResizeDispQuery;

function ResizeDispQuery() {
    var gridcanuse = GridCanUseHeight(1) * 0.5;
    $("#grid-query").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-querytotal").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-querydetail").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-query,#grid-querytotal,#grid-querydetail").datagrid('resize')
}