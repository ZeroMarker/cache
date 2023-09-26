/*
 *ģ��:			��ҩ��
 *��ģ��:		��ҩ��-��ҩ��ʿ�˶�
 *createdate:	2017-07-07
 *creator:		dinghongying
 */
DhcphaTempBarCode = "";
$(function () {
    /* ��ʼ����� start*/
    /*
    $("#date-daterange").dhcphaDateRange();
    var tmpstartdate = FormatDateT("t-2")
    $("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
    */
    
    var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-2") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime

    InitGirdPreList();
    InitGirdPreOrderList();

    /* ��Ԫ���¼� start*/
    //���ʧȥ���㴥���¼�
    $('#txt-phboxno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            QueryGridMedBroth();
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
    });

    SetDefaultCode();

    $("#chk-patadm").on("ifChanged", function () {
        QueryGridMedBroth();
    })

    document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
    setTimeout("QueryGridMedBroth()", 500);
}

//��ʾ������Ĭ��ֵ
function SetDefaultCode() {
    $('#currentnurse').text(gUserName);
    var LogLocStrInfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetLocInfoById", gLocId);
    var LogLocArr = LogLocStrInfo.split("^")
    $('#currentctloc').text(LogLocArr[1]);
}

//��ʼ����ҩ���б�table
function InitGirdPreList() {
    var columns = [{
            header: 'TPapmi',
            index: 'TPapmi',
            name: 'TPapmi',
            width: 30,
            hidden: true
        },
        {
            header: '����',
            index: 'TBed',
            name: 'TBed',
            width: 60
        },
        {
            header: '����',
            index: 'TPatName',
            name: 'TPatName',
            width: 100
        },
        {
            header: 'סԺ��',
            index: 'TPatCardNo',
            name: 'TPatCardNo',
            width: 100
        },
        {
            header: '�ǼǺ�',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=PHA.MS.NurChk.Query&MethodName=GetBrothPatList',
        height: OutFYCanUseHeight() - 10,
        recordtext: "",
        pgtext: "",
        shrinkToFit: false,
        rownumbers: true, //�Ƿ���ʾ�к�
        onSelectRow: function (id, status) {
            QueryGridPatBroth();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-patlist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    $("#grid-patlist").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ���б�table
function InitGirdPreOrderList() {
    var columns = [{
            header: 'TPhmbi',
            index: 'TPhmbi',
            name: 'TPhmbi',
            width: 10,
            hidden: true
        },
        {
            header: '����',
            index: 'TBedNo',
            name: 'TBedNo',
            width: 60
        },
        {
            header: '����',
            index: 'TPatName',
            name: 'TPatName',
            width: 80
        },
        {
            header: '�ǼǺ�',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 120
        },
        {
            header: 'סԺ��',
            index: 'TPameNo',
            name: 'TPameNo',
            width: 60
        },
        {
            header: '������',
            index: 'TPrescNo',
            name: 'TPrescNo',
            width: 120
        },
        {
            header: '��ҩʱ��',
            index: 'TActUncovMedDate',
            name: 'TActUncovMedDate',
            width: 140
        },
        {
            header: '����',
            index: 'TActUncovMedPocNum',
            name: 'TActUncovMedPocNum',
            width: 50,
            align: 'right'
        },
        {
            header: '������',
            index: 'TNurseCheckUser',
            name: 'TNurseCheckUser',
            width: 80
        },
        {
            header: '���ղ���',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 120
        },
        {
            header: '����ʱ��',
            index: 'TNurseCheckDate',
            name: 'TNurseCheckDate',
            width: 140
        },
        {
            header: '��ע',
            index: 'TRemark',
            name: 'TRemark',
            width: 160
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=PHA.MS.NurChk.Query&MethodName=GetPatBrothPreList',
        height: OutFYCanUseHeight() - 40,
        multiselect: true,
        pager: "#jqGridPager1",
        rownumbers: true, //�Ƿ���ʾ�к�
        shrinkToFit: false,
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-prescbrothdetail").clearJqGrid();
            }
        }

    };
    $("#grid-prescbrothdetail").dhcphaJqGrid(jqOptions);
}

//��ѯ�����������
function QueryGridMedBroth() {
    if ($("#chk-patadm").is(':checked')) {
        QueryGridPre();
    } else {
        QueryGridPatBroth();
    }
}

//��ѯ��ҩ���б�
function QueryGridPre() {
    $("#grid-patlist").jqGrid("clearGridData");
    $("#grid-prescbrothdetail").jqGrid("clearGridData");
    var currentnurse = $.trim($("#currentnurse").text());
    var currentctloc = $.trim($("#currentctloc").text());
    if (currentnurse == null || currentnurse == "" || currentctloc == null || currentctloc == "") {
        dhcphaMsgBox.alert("����ˢ��ҩ�˵Ŀ��������빤��!");
        return;
    }
    /*
    var daterange = $("#date-daterange").val();
    daterange = FormatDateRangePicker(daterange);
    var stdate = daterange.split(" - ")[0];
    var enddate = daterange.split(" - ")[1];
    */
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var phboxno = $('#txt-phboxno').val();
    var params = startdate + "^" + enddate + "^" + gLocId + "^" + chkauit + "^" + phboxno;
    $("#grid-patlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

function QueryGridPatBroth() {
    if ($("#chk-patadm").is(':checked')) {
        var selectid = $("#grid-patlist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-patlist").jqGrid('getRowData', selectid);
        papmi = selrowdata.TPapmi;
    } else {
        $("#grid-patlist").jqGrid("clearGridData");
        papmi = "";
    }
    /*
    var daterange = $("#date-daterange").val();
    daterange = FormatDateRangePicker(daterange);
    var stdate = daterange.split(" - ")[0];
    var enddate = daterange.split(" - ")[1];
    */
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var phboxno = $('#txt-phboxno').val();
    var params = startdate + "^" + enddate + "^" + papmi + "^" + gLocId + "^" + chkauit + "^" + phboxno;

    $("#grid-prescbrothdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

function MedBroAuitPass() {
    var selectids = $("#grid-prescbrothdetail").jqGrid('getGridParam', 'selarrrow');
    if (selectids == "") {
        dhcphaMsgBox.alert("����ѡ����Ҫ��˵ļ�¼");
        return;
    }
    var chkedFlag = "";
    var PhmbiStr = "";
    $.each(selectids, function () {
        var rowdata = $('#grid-prescbrothdetail').jqGrid('getRowData', this);
        var Phmbi = rowdata.TPhmbi;
        var chkNurse = rowdata.TNurseCheckUser;
        if (rowdata.TNurseCheckUser != "") {
            chkedFlag = "Y";
        }
        if (PhmbiStr == "") {
            PhmbiStr = Phmbi;
        } else {
            PhmbiStr = PhmbiStr + "^" + Phmbi;
        }
    })
    if (chkedFlag == "Y") {
        dhcphaMsgBox.alert("�Ѻ˶ԣ������ٴβ���!");
        return;
    }
    var currentnurse = $.trim($("#currentnurse").text());
    var params = PhmbiStr + "&&" + currentnurse;
    var ret = tkMakeServerCall("web.DHCINPHA.HMNurseCheck.NurseCheckQuery", "SavaBrothNurseCheck", params);
    if (ret != 0) {
        if (ret == -1) {
            dhcphaMsgBox.alert("��ҩ��ϢΪ�գ����ʵ!");
            return;
        } else if (ret == -2) {
            dhcphaMsgBox.alert("�˶���Ϊ�գ����ʵ!");
            return;
        } else {
            dhcphaMsgBox.alert("�˶�����" + ret);
            return;
        }
    } else {
        dhcphaMsgBox.alert("�˶Գɹ���");
        QueryGridMedBroth();
    }

}

//���
function ClearConditions() {
    SetDefaultCode();
    $("#grid-patlist").clearJqGrid();
    $("#grid-prescbrothdetail").clearJqGrid();
    $("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-2"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-2"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
    $("#txt-phboxno").val("");
    $("#chk-audit").iCheck("uncheck");
    $("#chk-patadm").iCheck("uncheck");
    return;
}

//��ҳ��table���ø߶�
function OutFYCanUseHeight() {
    var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
    var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
    var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
    var height5 = parseFloat($("[class='panel-heading']").height());
    var tableheight = $(window).height() - height1 * 2 - 2 * height3 - 2 * height4 - 2 * height5;
    return tableheight;
}

function CheckTxtFocus() {
    var txtfocus = $("#txt-phboxno").is(":focus");
    if (txtfocus != true) {
        return false;
    }
    return true;
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            $("#txt-phboxno").val(DhcphaTempBarCode);
            QueryGridMedBroth();
            $("#txt-phboxno").val("");
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode)
        }
    }
    if (event.keyCode == 113) {
        PhacAuitPass();
    }
}