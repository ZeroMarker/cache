/**
 * ģ��:סԺҩ��
 * ��ģ��:ҵ���ѯ-��ҩ����
 * createdate:2016-12-09
 * creator:dinghongying
 */
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPhaLoc();
    InitWardList();
    InitReturnTotalList();
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* �󶨰�ť�¼� end*/
    ;
    $("#returntotaldg").closest(".panel-body").height(GridCanUseHeight(1));
})


//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid
    }
    InitLocInci(locincioptions)
}
//��ʼ��ҩ��
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option);
    $('#sel-phaloc').on('select2:select', function (event) {
        InitThisLocInci($(this).val());
    });
}
//��ʼ������
function InitWardList() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDs&style=select2",
        allowClear: true,
        width: '15em',
        placeholder: "����..."
    }
    $("#sel-wardloc").dhcphaSelect(selectoption);
}
//��ʼ����ҩ�����б�
function InitReturnTotalList() {
    //����columns
    var columns = [
        [{
                field: "Inci",
                title: 'Inci',
                hidden: true
            },
            {
                field: 'inciCode',
                title: 'ҩƷ����',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 250,
                sortable: true
            },
            {
                field: 'retQty',
                title: '��ҩ����',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'retUomDesc',
                title: '��λ',
                width: 80,
                sortable: true
            },
            {
                field: 'sp',
                title: '�ۼ�',
                width: 200,
                hidden: true,
                sortable: true
            },
            {
                field: 'spAmt',
                title: '�ۼ۽��',
                width: 150,
                align: 'right',
                sortable: true
            },
            {
                field: 'rp',
                title: '����',
                width: 200,
                hidden: true,
                sortable: true
            },
            {
                field: 'rpAmt',
                title: '���۽��',
                width: 150,
                align: 'right',
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: true
    }
    //����datagrid	
    $('#returntotaldg').dhcphaEasyUIGrid(dataGridOption);
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
        dhcphaMsgBox.alert("��ѡ��ҩ��!");
        return;
    }
    var wardLoc = $("#sel-wardloc").val();
    if (wardLoc == null) {
        wardLoc = "";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + wardLoc + tmpSplit + inciRowId;
    $('#returntotaldg').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "QueryPhaReturnTotal",
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });

}

function ClearConditions() {
    $("#sel-wardloc").empty();
    $("#sel-locinci").empty();
    $('#returntotaldg').clearEasyUIGrid();
    var tDate=new Date();
    $("#date-start").data('daterangepicker').setStartDate(tDate);
    $("#date-start").data('daterangepicker').setEndDate(tDate);
    $("#date-end").data('daterangepicker').setStartDate(tDate);
    $("#date-end").data('daterangepicker').setEndDate(tDate);
}