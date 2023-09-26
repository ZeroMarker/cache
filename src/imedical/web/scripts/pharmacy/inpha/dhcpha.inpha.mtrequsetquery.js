/*
 *ģ��:			�ƶ�ҩ��
 *��ģ��:		�ƶ�ҩ��-���쵥��ѯ
 *createdate:	2018-09-11
 *creator:		hulihua
 */
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //ҩ������
    SetLogPhaLoc(); //��ҩ�����Ҹ�Ĭ��ֵ��
    InitPhaWard(); //����
    SetLogWardLoc(); //����������ֵ��
    InitThisLocInci($("#sel-phaloc").val());
    InitInphReqType(); //��������
    InitInphReqStatue(); //����״̬
    InitThisLocUser(gLocId); //������
    InitBoxStatus(); //������״̬
    InitRequsetList();
    InitRequsetDetailList();
    /* ��Ԫ���¼� start*/
    //���쵥�Żس��¼�
    $('#txt-inphreqno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var inphreqno = $.trim($("#txt-inphreqno").val());
            if (inphreqno != "") {
                Query();
            }
        }
    });
    //��ҩ���Żس��¼�
    $('#txt-inphdrawno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var inphdrawno = $.trim($("#txt-inphdrawno").val());
            if (inphdrawno != "") {
                Query();
            }
        }
    });
    //�̻����Żس��¼�
    $('#txt-connectno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var connectno = $.trim($("#txt-connectno").val());
            if (connectno != "") {
                Query();
            }
        }
    });
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

    //����������
    $('#sel-phaward').on('select2:select', function (event) {
        InitThisLocUser($("#sel-phaward").val());
    })
})

window.onload = function () {
    setTimeout("Query()", 500);
}

//��ʼ��������
function InitThisLocUser(locrowid) {
    var locincioptions = {
        id: "#sel-inphrequser",
        locid: locrowid,
        placeholder: "������...",
        width: '12em'
    }
    InitLocAllUser(locincioptions)
}

//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "270px"
    }
    InitLocInci(locincioptions)
}

//��ʼ��������״̬
function InitBoxStatus() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: 10,
            text: '������ɴ�ӡװ����'
        },
        {
            id: 60,
            text: '�����������'
        },
        {
            id: 70,
            text: '��������'
        }
    ];
    var selectoption = {
        data: data,
        width: '12em',
        allowClear: true,
        placeholder: "������״̬...",
        minimumResultsForSearch: Infinity
    };
    $("#sel-boxstatus").dhcphaSelect(selectoption);
}

//��ʼ����������
function InitInphReqType() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: 1,
            text: '��ҩ'
        },
        {
            id: 2,
            text: 'ȡҩ'
        },
        {
            id: 3,
            text: '����'
        },
        {
            id: 4,
            text: '����'
        },
        {
            id: 5,
            text: '��һ'
        },
        {
            id: 6,
            text: '����'
        }
    ];
    var selectoption = {
        data: data,
        width: '10.7em',
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $("#sel-inphreqtype").dhcphaSelect(selectoption);
}

//��ʼ�����쵥״̬
function InitInphReqStatue() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: '05',
            text: '��������'
        },
        {
            id: '10',
            text: '��������'
        },
        {
            id: '20',
            text: 'ҩ����ҩ��'
        },
        {
            id: '30',
            text: '��ҩ���'
        },
        {
            id: '40',
            text: 'ҩ���˶���'
        },
        {
            id: '50',
            text: '�˶�װ�����'
        },
        {
            id: '60',
            text: '�����������'
        },
        {
            id: '70',
            text: '��������'
        },
        {
            id: '80',
            text: '�����˶�'
        }
    ];
    var selectoption = {
        data: data,
        width: '180px',
        allowClear: true,
        placeholder: "���쵥״̬...",
        minimumResultsForSearch: Infinity
    };
    $("#sel-inphreqstatue").dhcphaSelect(selectoption);
}

//ҩ�����Ҹ�Ĭ��ֵ��
function SetLogPhaLoc() {
    var LogLocid = ""
    if (gHospID == "1") {
        LogLocid = "102"; //��ҽԺԺ��Ĭ��Ϊ����ҩ����
    }
    if ((LogLocid == "") || (LogLocid == gLocId)) {
        return;
    }
    var LogLocArr = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetLocInfoById", LogLocid);
    var LogLocDesc = LogLocArr.split("^")[1];
    var select2option = '<option value=' + "'" + LogLocid + "'" + 'selected>' + LogLocDesc + '</option>'
    $("#sel-phaloc").append(select2option);
}

//������Ĭ��ֵ��
function SetLogWardLoc() {
    if ((gWardID == "") || (gWardID == null)) {
        return;
    }
    var select2option = '<option value=' + "'" + gLocId + "'" + 'selected>' + gLocDesc + '</option>'
    $("#sel-phaward").append(select2option);
}

//��ʼ�����쵥�б�table
function InitRequsetList() {
    var columns = [{
            name: "TInphrNo",
            index: "TInphrNo",
            header: '���쵥����',
            width: 80
        },
        {
            name: "TWardLocDesc",
            index: "TWardLocDesc",
            header: '����',
            width: 160,
            align: 'left'
        },
        {
            name: "TDispLocDesc",
            index: "TDispLocDesc",
            header: '��ҩ����',
            width: 120
        },
        {
            name: "TAlertDarwUserDesc",
            index: "TAlertDarwUserDesc",
            header: '��ʾҩ����ҩ��',
            width: 130
        },
        {
            name: "TAlertDrawDateTime",
            index: "TAlertDrawDateTime",
            header: '��ʾҩ����ҩʱ��',
            width: 140
        },
        {
            name: "TReqUserDesc",
            index: "TReqUserDesc",
            header: '������',
            width: 130
        },
        {
            name: "TReqDateTime",
            index: "TReqDateTime",
            header: '����ʱ��',
            width: 140
        },
        {
            name: "TReqTypeDesc",
            index: "TReqTypeDesc",
            header: '��������',
            width: 70
        },
        {
            name: "TPhrStatusDesc",
            index: "TPhrStatusDesc",
            header: '���쵥״̬',
            width: 100
        },
        {
            name: "TBoxStatus",
            index: "TBoxStatus",
            header: '������״̬',
            width: 100
        },
        {
            name: "TPhDrawNo",
            index: "TPhDrawNo",
            header: '��ҩ����',
            width: 120
        },
        {
            name: "TCancelUserDesc",
            index: "TCancelUserDesc",
            header: '������',
            width: 130
        },
        {
            name: "TCancelDateTime",
            index: "TCancelDateTime",
            header: '����ʱ��',
            width: 140
        },
        {
            name: "TConnectNo",
            index: "TConnectNo",
            header: '�̻�����',
            width: 120,
            align: 'left'
        },
        {
            name: "TPHRRowID",
            index: "TPHRRowID",
            header: '���쵥ID',
            width: 10,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTInPhReq.InPhReqQuery&MethodName=jsQuaryInphreqInfo', //��ѯ��̨	
        height: GridCanUseHeight(2) * 0.5 - 7,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        autoScroll: true,
        datatype: "local",
        pager: "#jqGridPager", //��ҳ�ؼ���id 
        onSelectRow: function (id) {
            QuerySub(id);
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-requsttotal').dhcphaJqGrid(jqOptions);
}

//��ʼ�����쵥��ϸ�б�table
function InitRequsetDetailList() {
    //����columns
    var columns = [{
            header: 'TphmbiId',
            index: 'TphmbiId',
            name: 'TphmbiId',
            width: 5,
            hidden: true
        },
        {
            header: 'ҩƷ����',
            index: 'TInciCode',
            name: 'TInciCode',
            width: 60
        },
        {
            header: 'ҩƷ����',
            index: 'TInciDesc',
            name: 'TInciDesc',
            width: 200,
            align: 'left'
        },
        {
            header: '����',
            index: 'TQty',
            name: 'TQty',
            width: 40
        },
        {
            header: '��λ',
            index: 'TUomDesc',
            name: 'TUomDesc',
            width: 60
        },
        {
            header: '���쵥״̬',
            index: 'TItmstatusDesc',
            name: 'TItmstatusDesc',
            width: 80
        },
        {
            header: '������',
            index: 'TCancelUserDesc',
            name: 'TCancelUserDesc',
            width: 100
        },
        {
            header: '��������',
            index: 'TCancelDateTime',
            name: 'TCancelDateTime',
            width: 130,
            align: 'left'
        },
        {
            header: '����ӱ�ID',
            index: 'TDspBatchId',
            name: 'TDspBatchId',
            width: 80
        },
        {
            header: '�����ӱ�ID',
            index: 'TInphreqSubID',
            name: 'TInphreqSubID',
            width: 80
        }
    ];
    var dataGridOption = {
        colModel: columns, //��
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTInPhReq.InPhReqQuery&MethodName=jsQuaryInphreqItmInfo',
        height: GridCanUseHeight(2) * 0.5 ,
        shrinkToFit: false,
        rownumbers: true,
        autoScroll: true
    }
    //����datagrid	
    $('#grid-requstdetail').dhcphaJqGrid(dataGridOption);
}

///��ѯ
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var inciRowId = $("#sel-locinci").val();
    if (inciRowId == null) {
        inciRowId = ""
    }
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("��ѡ��ҩ������!");
        return;
    }
    var wardLoc = $("#sel-phaward").val();
    if (wardLoc == null) {
        wardLoc = "";
    }
    var inphrequser = $.trim($("#sel-inphrequser").val());
    var inphreqtype = $.trim($("#sel-inphreqtype").val());
    var inphreqstatue = $.trim($("#sel-inphreqstatue").val());
    var boxstatus = $.trim($("#sel-boxstatus").val());
    var inphreqno = $.trim($("#txt-inphreqno").val());
    var drawno = $.trim($("#txt-inphdrawno").val());
    var connectno = $.trim($("#txt-connectno").val());
    var patno = $.trim($("#txt-patno").val());

    var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + wardLoc + tmpSplit + inphreqtype + tmpSplit +
        inphreqstatue + tmpSplit + drawno + tmpSplit + connectno + tmpSplit + inphrequser + tmpSplit + boxstatus + tmpSplit +
        inphreqno + tmpSplit + inciRowId + tmpSplit + patno;
    $("#grid-requsttotal").setGridParam({
        datatype: 'json',
        page: 1,
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-requstdetail").jqGrid("clearGridData");
}

///��ѯ��ϸ
function QuerySub(selectid) {
    var selrowdata = $("#grid-requsttotal").jqGrid('getRowData', selectid);
    var phrid = selrowdata.TPHRRowID;
    if ((phrid == null) || (phrid == "")) {
        return;
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
    var params = phrid;
    $("#grid-requstdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}
//���
function ClearConditions() {
    var today = new Date();
    $("#date-start").data('daterangepicker').setStartDate(today);
    $("#date-start").data('daterangepicker').setEndDate(today);
    $("#date-end").data('daterangepicker').setStartDate(today);
    $("#date-end").data('daterangepicker').setEndDate(today);
    $("#sel-locinci").empty();
    $("#sel-phaward").empty();
    $("#sel-inphrequser").empty();
    $("#sel-inphreqtype").empty();
    InitInphReqType();
    $("#sel-inphreqstatue").empty();
    InitInphReqStatue();
    $("#sel-boxstatus").empty();
    InitBoxStatus();
    $('#txt-inphreqno').val("");
    $('#txt-connectno').val("");
    $('#txt-inphdrawno').val("");
    $('#txt-patno').val("");
    $("#grid-requstdetail").jqGrid("clearGridData");
    $("#grid-requstdetail").jqGrid("clearGridData");
}