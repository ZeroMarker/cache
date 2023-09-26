/**
 * ģ��:סԺҩ��
 * ��ģ��:סԺҩ��ҩ��-��ҩ�ۺϲ�ѯ-��������ҩͳ��
 * createdate:2016-12-09
 * creator:xueshuaiyi
 */
var QUERYPID = "";
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
    InitPhaLoc();
    InitGridDispRetMain();
    InitGridDispRetDetail();
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* �󶨰�ť�¼� end*/
    ;
    $("#grid-dispretmain").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#grid-dispretdetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//��ʼ������
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//��ʼ����ҩ���б�
function InitGridDispRetMain() {
    //����columns
    var columns = [
        [{
                field: 'Ward',
                title: '����',
                width: 150,
                align: 'left',
                sortable: true
            },
            {
                field: 'PhaDispAmt',
                title: '��ҩ���',
                width: 120,
                align: 'right',
                sortable: true
            },
            {
                field: 'PhaRetAmt',
                title: '��ҩ���',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'PhaDispSum',
                title: '�ϼƽ��',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'ProcessID',
                title: 'ProcessID',
                width: 80,
                align: 'right',
                sortable: true,
                hidden: true
            },
            {
                field: 'WardRowid',
                title: 'WardRowid',
                width: 80,
                align: 'right',
                sortable: true,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispRetStat.Display&MethodName=EuiGetWardStat",
        columns: columns,
        fitColumns: true,
        showFooter: true,
        onSelect: function (rowIndex, rowData) {
            QueryDetail();
        },
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
                QUERYPID = $(this).datagrid("getRows")[0].ProcessID;
                $(this).datagrid("options").queryParams.Pid = QUERYPID;
            } else {
                $('#grid-dispretdetail').clearEasyUIGrid();
            }
        }
    }
    //����datagrid	
    $('#grid-dispretmain').dhcphaEasyUIGrid(dataGridOption);

}

//��ʼ����ҩ����ϸ�б�
function InitGridDispRetDetail() {
    //����columns
    var columns = [
        [{
                field: 'RetDate',
                title: '����',
                width: 100,
                align: 'center'
            },
            {
                field: 'RetTime',
                title: 'ʱ��',
                width: 100,
                align: 'center'
            },
            {
                field: 'Code',
                title: '����',
                width: 120,
                align: 'left'
            },
            {
                field: 'Desc',
                title: '����',
                width: 300,
                align: 'left'
            },
            {
                field: 'IssueType',
                title: '����',
                width: 75,
                align: 'center',
                styler: function (value, row, index) {
                    if (value.indexOf("��") >= 0) {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value.indexOf("��") >= 0) {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                }
            },
            {
                field: 'RetQty',
                title: '����',
                width: 100,
                align: 'right'
            },
            {
                field: 'Uom',
                title: '��λ',
                width: 75,
                align: 'left'
            },
            {
                field: 'RetAmt',
                title: '���',
                width: 100,
                align: 'right'
            },
            {
                field: 'IntrNo',
                title: 'ҵ�񵥺�',
                width: 250,
                align: 'left'
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispRetStat.Display&MethodName=EuiGetWardDetail",
        columns: columns,
        fitColumns: false
    }
    //����datagrid
    $('#grid-dispretdetail').dhcphaEasyUIGrid(dataGridOption);

}
//��ѯ��ϸ
function QueryDetail() {
    var selectdata = $("#grid-dispretmain").datagrid("getSelected")
    if (selectdata == null) {
        dhcphaMsgBox.alert("ѡ�������쳣!");
        return;
    }
    var wardrowid = selectdata["WardRowid"]
    var processid = selectdata["ProcessID"]
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = processid + tmpSplit + wardrowid
    $('#grid-dispretdetail').datagrid({
        queryParams: {
            Pid: processid,
            WardLocId: wardrowid
        }
    });
}
///��������ҩ���ܲ�ѯ
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').select2("data")[0];
    var phaloc = $('#sel-phaloc').select2("data")[0].id;
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc;
    KillTmpGloal();
    $('#grid-dispretmain').datagrid({
        queryParams: {
            InputStr: params,
            Pid: ""
        }
    });

}

//���
function ClearConditions() {
    var tDate = new Date();
    $("#date-start").data('daterangepicker').setStartDate(tDate);
    $("#date-start").data('daterangepicker').setEndDate(tDate);
    $("#date-end").data('daterangepicker').setStartDate(tDate);
    $("#date-end").data('daterangepicker').setEndDate(tDate);
    KillTmpGloal();
    $('#grid-dispretmain').clearEasyUIGrid();
    $('#grid-dispretdetail').clearEasyUIGrid();
}

// �����ʱglobal
function KillTmpGloal() {
    tkMakeServerCall("web.DHCINPHA.DispRetStat.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
    KillTmpGloal();
}