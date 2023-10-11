/*
 *ģ��:סԺҩ��
 *��ģ��:ҵ���ѯ-��ҩ����ѯ
 *createdate:2016-12-12
 *creator:dinghongying
 */
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-end").dhcphaDateRange(daterangeoptions);
    $("#date-start").dhcphaDateRange(daterangeoptions);
    //�������лس��¼�
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitRetType();
    InitWardList();
    InitReturnList();
    InitReturnDetailList();
    /* �󶨰�ť�¼� start*/
    $("#btn-find").on("click", Query);
    $("#btn-print").on('click', BtnPrintHandler);
    $("#btn-clear").on("click", ClearConditions);
    /* �󶨰�ť�¼� end*/
    /*ҩ������������¼�,��ҩ���仯ʱ,��ʼ��ҩƷ���� add by qhj*/
    $("#sel-phaloc").on('change', function () {
        var phaloc = $("#sel-phaloc").val();
        InitThisLocInci(phaloc);
    });
    ResizePhaReturnQuery()
})
//��ʼ��ҩƷѡ��
function InitThisLocInci(phaloc) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: phaloc,
       	width: '13em'
    }
    InitLocInci(locincioptions)
}
//��ʼ��ҩ��
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false,
        placeholder: "ҩ������..."
    }
    $("#sel-phaloc").dhcphaSelect(selectoption);
	$('#sel-phaloc').on('select2:select', function (event) {
		InitPhaWard(event.params.data.id)
    });
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == "D") {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
        $("#sel-phaloc").append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
        $('#sel-phaloc').on('select2:select', function (event) {
            InitThisLocInci($(this).val());
        });
    }
}
//��Ϊ�����տ�������ȡ���߲���(�������Ժ����ҩ�����)  by zhaoxinlong 2022.04.22
//��ʼ������
function InitWardList() {
	if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+reclocId,
        allowClear: true,
        width: '13em',
        placeholder: "����..."
    }
    $("#sel-wardloc").dhcphaSelect(selectoption);

    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == "W") {
        var SessionWard = session['LOGON.WARDID'] || "";
        if (SessionWard != "") {
            var select2option = '<option value=' + "'" + SessionWard + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
            $("#sel-wardloc").append(select2option);
        }
    }
}

function InitRetType() {
    var data = [{
            id: "",
            text: ''
        },{
            id: 1,
            text: 'ֱ����ҩ'
        }, {
            id: 2,
            text: '���뵥��ҩ'
        },{
            id: 3,
            text: '�����ҩ'
        }
    ];
    var selectoption = {
        data: data,
        width: 125,
        allowClear: true,
        minimumResultsForSearch: Infinity,
        placeholder:"��ҩ����"
    };
    $("#sel-rettype").dhcphaSelect(selectoption);

}
//��ʼ����ҩ���б�
function InitReturnList() {
    //����columns
    var columns = [
        [   {
                field: 'tRetWay',
                title: '��ҩ��ʽ',
                width: 80
            },{
                field: "tPhaRetNo",
                title: '��ҩ����',
                width: 250
            },
            {
                field: 'tWard',
                title: '����',
                width: 200
            },
            {
                field: 'tAdmLoc',
                title: '�������',
                width: 80,
                hidden: true
            },
            {
                field: 'tReturnOper',
                title: '��ҩ��',
                width: 90
            },
            {
                field: 'tReturnDate',
                title: '��ҩ����',
                width: 90
            },
            {
                field: 'tReturnTime',
                title: '��ҩʱ��',
                width: 70
            },
            {
                field: 'tReqNo',
                title: '���뵥��',
                width: 250
            },
            {
                field: 'trquser',
                title: '������',
                width: 90
            },
            {
                field: 'tReqDate',
                title: '��������',
                width: 90
            },
            {
                field: 'tReqTime',
                title: '����ʱ��',
                width: 70
            },
            {
                field: 'tAckUser',
                title: '�����',
                width: 90
            },
            {
                field: 'tAckDate',
                title: '�������',
                width: 90
            },
            {
                field: 'tAckTime',
                title: '���ʱ��',
                width: 70
            },            {
                field: 'tPhaRet',
                title: 'ID',
                width: 70,
				hidden:true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        onSelect: function (rowIndex, rowData) {
            QuerySub();
        },
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
            }
        }
    }
    //����datagrid	
    $('#grid-returntotal').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩ����ϸ��Ϣ�б�
function InitReturnDetailList() {
    //����columns
    var columns = [
        [{
                field: "tPhaRetNo",
                title: '��ҩ����',
                width: 100,
                hidden: true
            },
            {
                field: 'tRegNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'tName',
                title: '����',
                width: 90
            },
            {
                field: 'tWard',
                title: '����',
                width: 150
            },
            {
                field: 'tBedNo',
                title: '����',
                width: 75
            },
            {
                field: 'tAdmLoc',
                title: '�������',
                width: 150
            },
            {
                field: 'tDoctor',
                title: 'ҽ��',
                width: 70
            },
            {
                field: 'tPrescNo',
                title: '������',
                width: 110
            },
            {
                field: 'tDesc',
                title: '����',
                width: 200
            },
            {
                field: "tUom",
                title: '��λ',
                width: 60
            },
            {
                field: 'tReturnPrice',
                title: '��ҩ�۸�',
                width: 75,
                align: 'right'
            },
            {
                field: 'tReturnQty',
                title: '��ҩ����',
                width: 75,
                align: 'right'
            },
            {
                field: 'tReturnAmt',
                title: '��ҩ���',
                width: 75,
                align: 'right'
            },
            {
                field: 'tDispQty',
                title: 'ԭ��ҩ����',
                width: 90,
                align: 'right'
            },
            {
                field: 'tRetReqQty',
                title: '������ҩ����',
                width: 90,
                align: 'right'
            },
            {
                field: 'tReturnDate',
                title: '��ҩ����',
                width: 100
            },
            {
                field: 'tReturnTime',
                title: '��ҩʱ��',
                width: 100
            },
            {
                field: 'tReturnOper',
                title: '��ҩ��',
                width: 80
            },
            {
                field: 'TGeneric',
                title: '����ͨ����',
                width: 150
            },
            {
                field: 'TBarcode',
                title: '���',
                width: 70
            },
            {
                field: 'TForm',
                title: '����',
                width: 100
            },
            {
                field: 'TManf',
                title: '������ҵ',
                width: 120
            },
            {
                field: 'TResPatName',
                title: '���������',
                width: 80
            },
            {
                field: 'TResPatNo',
                title: '������ǼǺ�',
                width: 90
            },
            {
                field: 'TResBedNo',
                title: '���������',
                width: 80
            },
            {
                field: 'TResPatQty',
                title: '���������',
                width: 80
            },
            {
                field: 'TEncryptLevel',
                title: '�����ܼ�',
                width: 100,
                hidden:true
            },
            {
                field: 'TPatLevel',
                title: '���˼���',
                width: 100,
                hidden:true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    }
    //����datagrid	
    $('#grid-returndetail').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var selInci=$("#sel-locinci").select2('data');
    var inciRowId=selInci!=""?selInci[0].id:"";
    var selPhaLoc=$("#sel-phaloc").select2('data');
    var phaLoc=selPhaLoc!=""?selPhaLoc[0].id:"";
    if (phaLoc==""){
	    dhcphaMsgBox.alert("��ѡ��ҩ��!");
        return;
	}
	var selWardLoc=$("#sel-wardloc").select2('data');
    var wardLoc=selWardLoc!=""?selWardLoc[0].id:"";
    var selRetType=$("#sel-rettype").select2('data');
    var rettype=selRetType!=""?selRetType[0].id:"";
    var incstkcatrowid = "";
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + inciRowId + tmpSplit + incstkcatrowid + tmpSplit + wardLoc+tmpSplit+rettype;
    $('#grid-returntotal').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "PhaRet",
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
    $('#grid-returndetail').clearEasyUIGrid();

}

///��ѯ��ϸ
function QuerySub() {
    var selecteddata = $('#grid-returntotal').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var inciRowId = $("#sel-locinci").val();
    if (inciRowId == null) {
        inciRowId = "";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var pharetno = selecteddata["tPhaRetNo"];
	var pharet = selecteddata["tPhaRet"];
    var params = pharetno + tmpSplit + inciRowId + tmpSplit + pharet;
    $('#grid-returndetail').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "RetItm",
            Params: params
        }
    });
}

function BtnPrintHandler() {
    if ($('#grid-returntotal').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert("ҳ��û������");
        return;
    }
    if ($('#grid-returntotal').datagrid('getSelected') == null) {
        dhcphaMsgBox.alert("��ѡ����Ҫ��ӡ������!");
        return;
    }
    var selecteddata = $('#grid-returntotal').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var pharet = selecteddata["tPhaRet"];
    PrintReturnCom(pharet, "��");
}
//���
function ClearConditions() {
    var today = new Date();
    $("#date-start").data('daterangepicker').setStartDate(today);
    $("#date-start").data('daterangepicker').setEndDate(today);
    $("#date-end").data('daterangepicker').setStartDate(today);
    $("#date-end").data('daterangepicker').setEndDate(today);
    $("#sel-locinci").empty();
    $("#sel-wardloc").empty();
    $("#sel-rettype").val("").trigger('change');
    $('#grid-returntotal').clearEasyUIGrid();
    $('#grid-returndetail').clearEasyUIGrid();
}
window.onresize = ResizePhaReturnQuery;

function ResizePhaReturnQuery() {
    $("#grid-returntotal").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#grid-returndetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 12);
    $("#grid-returntotal,#grid-returndetail").datagrid('resize')
}
