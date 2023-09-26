/*
ģ��:		�ƶ�ҩ��
��ģ��:		�ƶ�ҩ��-�������ش����ǩ
Creator:	hulihua
CreateDate:	2017-04-25
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
    //�����ڿؼ�����ʼ��ֵ��
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", gLocId);
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    InitPhaLoc(); //ҩ������
    InitLabelWardList();
    InitLabelInfoList();
    /* ��ʼ����� end*/
})

window.onload = function () {
    Query();
}

//��ʼ����ǩ�����б�
function InitLabelWardList() {
    //����columns
    var columns = [{
            header: 'ProcessID',
            index: 'ProcessID',
            name: 'ProcessID',
            width: 60,
            hidden: true
        },
        {
            header: 'TWardLocId',
            index: 'TWardLocId',
            name: 'TWardLocId',
            width: 200,
            hidden: true
        },
        {
            header: '���Ҳ���',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 250,
            align: 'left'
        }
    ];

    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTInPhCalLabel.CalLabelQuery&MethodName=GetLabelWardList',
        recordtext: "",
        pgtext: "",
        height: GridCanUseHeight(1) - 36,
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QuerySub();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-phboxwardloclist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    //����datagrid	
    $('#grid-phboxwardloclist').dhcphaJqGrid(jqOptions);
}

//��ʼ�������ǩ�б�
function InitLabelInfoList() {
    var columns = [{
            header: 'PID',
            index: 'PID',
            name: 'PID',
            width: 10,
            align: 'left',
            hidden: true
        },
        {
            header: 'TPhbId',
            index: 'TPhbId',
            name: 'TPhbId',
            width: 10,
            align: 'left',
            hidden: true
        },
        {
            header: 'TWardLocId',
            index: 'TWardLocId',
            name: 'TWardLocId',
            width: 10,
            align: 'right',
            hidden: true
        },
        {
            header: 'TDispLoc',
            index: 'TDispLoc',
            name: 'TDispLoc',
            width: 10,
            align: 'right',
            hidden: true
        },
        {
            header: '����',
            index: 'TBoxNo',
            name: 'TBoxNo',
            width: 80
        },
        {
            header: '��������',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 100,
            align: 'left'
        },
        {
            header: 'װ��ʱ��',
            index: 'TCreateDate',
            name: 'TCreateDate',
            width: 100
        },
        {
            header: '����',
            index: 'TPhbNum',
            name: 'TPhbNum',
            width: 50
        },
        {
            header: 'ҩƷƷ����',
            index: 'TInciNum',
            name: 'TInciNum',
            width: 50
        },
        {
            header: '��ע',
            index: 'TReMark',
            name: 'TReMark',
            width: 150,
            align: 'left'
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTInPhCalLabel.CalLabelQuery&MethodName=GetLabelInfoList',
        multiselect: false,
        height: GridCanUseHeight(1) - 36,
        //pager: "#jqGridPager", //��ҳ�ؼ���id  
        shrinkToFit: false,
    }
    //����datagrid	
    $('#grid-phboxdetail').dhcphaJqGrid(jqOptions);
}

///��ѯ
function Query() {
    KillCalLabelTMP();
    $('#grid-phboxwardloclist').jqGrid("clearGridData");
    $('#grid-phboxdetail').jqGrid("clearGridData");
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("��ѡ�����!");
        return;
    }
    var chkcancel = "";
    if ($("#chk-cancel").is(':checked')) {
        chkcancel = "Y";
    }

    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaLoc + "^" + chkcancel;
    $("#grid-phboxwardloclist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

///��ѯ��ϸ
function QuerySub() {
    var selectid = $("#grid-phboxwardloclist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-phboxwardloclist").jqGrid('getRowData', selectid);
    var pid = selrowdata.ProcessID;
    var wardwardloc = selrowdata.TWardLocId;
    var params = pid + "^" + wardwardloc;

    $("#grid-phboxdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-phboxdetail").clearJqGrid();
}

///���Ϸ���ǩ
function CanleLabel() {
    var selectid = $("#grid-phboxdetail").jqGrid('getGridParam', 'selrow');
    if ((selectid == null) || (selectid == "")) {
        dhcphaMsgBox.alert("����ѡ����Ҫ������װ��ǩ��Ϣ��");
        return;
    }
    var selrowdata = $("#grid-phboxdetail").jqGrid('getRowData', selectid);
    var phboxid = selrowdata.TPhbId;
    var disploc = selrowdata.TDispLoc;
    var params = disploc + "#" + phboxid + "#" + gUserID;
    var ret = tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery", "HandleCalPhbox", params);
    if (ret == 0) {
        dhcphaMsgBox.alert("�����ɹ���");
        ClearConditions();
        Query();
        return;
    } else if (ret == -1) {
        dhcphaMsgBox.alert("δѡ������Ҫ���ϵ�װ��ǩ��¼�����ʵ��");
        return;
    } else if (ret == -2) {
        dhcphaMsgBox.alert("��װ��ǩ�Ѿ����������ʵ��");
        return;
    } else if (ret == -3) {
        dhcphaMsgBox.alert("��װ��ǩ�Ѿ����ͻ���ǩ�գ����ʵ��");
        return;
    } else if (ret == -4) {
        dhcphaMsgBox.alert("��װ��ǩû�ж�Ӧ�ı�ҩ��Ϣ����������Ϣ�����ʵ��");
        return;
    } else if (ret == -5) {
        dhcphaMsgBox.alert("�����Ѿ����ջ���������ɣ����ʵ��");
        return;
    } else {
        dhcphaMsgBox.alert("����ʧ�ܣ�����ϵ����ʦ�����");
        return;
    }
}

///��ӡ
function BPrintHandler() {
    var selectid = $("#grid-phboxdetail").jqGrid('getGridParam', 'selrow');
    if ((selectid == null) || (selectid == "")) {
        dhcphaMsgBox.alert("����ѡ����Ҫ�����װ��ǩ��Ϣ��");
        return;
    }
    var selrowdata = $("#grid-phboxdetail").jqGrid('getRowData', selectid);
    var phboxid = selrowdata.TPhbId;
    //var PrintLabelInfo=tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetPrintPhBoxInfo",phboxid);
    if (phboxid == "") {
        dhcphaMsgBox.alert("����Ҫ�����װ��ǩ��Ϣ�������ʵ��");
        return;
    } else {
        //PrintPhBoxLabel(PrintLabelInfo);
        PrintPhBoxLabelC(phboxid)
    }
}

///���
function ClearConditions() {
    //�����ڿؼ�����ʼ��ֵ��
    KillCalLabelTMP();
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", gLocId);
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    $('#grid-phboxwardloclist').clearJqGrid();
    $('#grid-phboxdetail').clearJqGrid();
}

///�����ʱglobal
function KillCalLabelTMP() {
    var Pid = "";
    if ($("#grid-phboxwardloclist").getGridParam('records') > 0) {
        var firstrowdata = $("#grid-phboxwardloclist").jqGrid("getRowData", 1);
        Pid = firstrowdata.ProcessID;
    }
    if (Pid != "") {
        var killret = tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery", "KillTmp", Pid);
    }
}

///�쳣�ر�
window.onbeforeunload = function () {
    KillCalLabelTMP();
}