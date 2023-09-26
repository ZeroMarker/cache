/*
 *ģ��:סԺҩ��
 *��ģ��:ҵ���ѯ-��ҩ��ѯ-��ҩ������ͳ��
 *createdate:2016-12-13
 *creator:dinghongying
 */
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitStatType();
    InitDispDayWorkList();
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    /* �󶨰�ť�¼� end*/
    ;
    $("#dispdayworkdg").closest(".panel-body").height(GridCanUseHeight(1));
})


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
    $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//��ʼ��ͳ�Ʒ�ʽ
function InitStatType() {
    var data = [{
            id: 1,
            text: '����Աͳ��'
        },
        {
            id: 2,
            text: '������ͳ��'
        }
    ];
    var selectoption = {
        data: data,
        width: '8.5em',
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-stattype").dhcphaSelect(selectoption);
    $('#sel-stattype').on('select2:select', function (event) {
        Query();
    })

}
//��ʼ����ҩ�������б�
function InitDispDayWorkList() {
    //����columns
    var columns = [
        [{
                field: "UserCode",
                title: '��ҩ�˹���',
                width: 100,
                sortable: true
            },
            {
                field: 'UserName',
                title: '��ҩ������/����',
                width: 140,
                sortable: true
            },
            {
                field: 'Work',
                title: '��ҩƷ��(��)ͳ��',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'DispAmt',
                title: '��ҩ���ϼ�',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'Quenum',
                title: '��������',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Quefacnum',
                title: '��������',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'FacSum',
                title: '�������',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'FacSum1',
                title: '���崦������',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'Ws',
                title: 'ζ��',
                width: 50,
                align: 'right',
                sortable: true
            },
            {
                field: "RetNum",
                title: '��ҩƷ��(��)ͳ��',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetAmt',
                title: '��ҩ���ϼ�',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetQue',
                title: '��ҩ��������',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetFac',
                title: '��ҩ��������',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutQue',
                title: '��Ժ��ҩ��������',
                width: 120,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutFac',
                title: '��Ժ��ҩ����',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutQueAmt',
                title: '��Ժ��ҩ�������',
                width: 150,
                align: 'right',
                sortable: true
            },
            {
                field: 'AmtTotal',
                title: '�ϼƽ��',
                width: 100,
                align: 'right',
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    }
    //����datagrid	
    $('#dispdayworkdg').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("��ѡ�����!");
        return;
    }
    var statType = $("#sel-stattype").val();
    if (statType == null) {
        statType = "";
    }
    var chkSecUser = "0";
    if ($("#chk-secuser").is(':checked')) {
        chkSecUser = "on";
    }
    if ((chkSecUser == "on") && (statType == 2)) {
        dhcphaMsgBox.alert("������ѡ���޷����ڶ���ҩ��ͳ��,����ȷ�ϲ�ѯ����!");
        return;
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + statType + tmpSplit + chkSecUser;
    $('#dispdayworkdg').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "WorkStat",
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });

}