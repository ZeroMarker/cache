/**
 * ģ��:סԺҩ��
 * ��ģ��:��ҩͳ��
 * createdate:2016-12-14
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
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    $('#date-start')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-start')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-end')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#date-end')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '23:59:59');
    //�������лس��¼�
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    /*
    $("button[type=submit]").on("keypress",function(e){
    	if(window.event.keyCode == "13"){
    		return false;
    	}
    })
    */
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPhaLoc();
    InitDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitStkGrp(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitSeekType();
    InitDispWardList();
    InitDispStatList();
    /* �󶨰�ť�¼� start*/
    $('#btn-find').on('click', Query);
    $('#btn-findselect').on('click', QuerySub);
    $('#btn-print').on('click', BPrintHandler);
    $('#btn-clear').on('click', ClearConditions);
    /* �󶨰�ť�¼� end*/
    $('#grid-dispstattotal').closest('.panel-body').height(GridCanUseHeight(1));
    $('#grid-dispstatdetail').closest('.panel-body').height(GridCanUseHeight(1));
});

//��ʼ��ҩƷѡ��
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: '#sel-locinci',
        locid: locrowid,
        width: '390px'
    };
    InitLocInci(locincioptions);
}

//��ʼ��ҩ��
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        InitThisLocInci($(this).val());
        InitDispType($(this).val());
        InitStkGrp($(this).val());
    });
}

//��ʼ����ҩ���
function InitDispType(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetLocDispTypeDs&style=select2&locId=' + locrowid,
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $('#sel-disptype').dhcphaSelect(selectoption);
}

//��ʼ������
function InitStkGrp(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetLocStkGrpDs&style=select2&locId=' + locrowid,
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $('#sel-stkgrp').dhcphaSelect(selectoption);
}

//��ʼ����ѯ��ʽ
function InitSeekType() {
    var data = [
        {
            id: 1,
            text: '������'
        },
        {
            id: 0,
            text: '���ٴ�����'
        }
    ];
    var selectoption = {
        data: data,
        width: 150,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $('#sel-seektype').dhcphaSelect(selectoption);
    $('#sel-seektype').on('select2:select', function (event) {
        var seekVal = $('#sel-seektype').val();
        var seekTitle = seekVal == '1' ? '�����б�' : '�ٴ������б�';
        $('#locPanelTitle').text(seekTitle);
        Query();
    });
}

//��ʼ����ҩͳ���б�
function InitDispWardList() {
    //����columns
    var columns = [
        [
            {
                field: 'ProcessID',
                title: 'ProcessID',
                width: 80,
                hidden: true
            },
            {
                field: 'AdmLocRowid',
                title: 'AdmLocRowid',
                width: 80,
                hidden: true
            },
            {
                field: 'TSelect',
                title: '',
                checkbox: true
            },
            {
                field: 'AdmLocDesc',
                title: '����',
                width: 250,
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: true,
        pagination: false,
        singleSelect: true,
        checkOnSelect: true,
        selectOnCheck: false,
        onClickRow: function (rowIndex, rowData) {
            QuerySub();
        }
    };
    //����datagrid
    $('#grid-dispstattotal').dhcphaEasyUIGrid(dataGridOption);
}

//��ʼ����ҩͳ��ҩƷ��Ϣ�б�
function InitDispStatList() {
    var columns = [
        [
            {
                field: 'PID',
                title: 'PID',
                width: 50,
                hidden: true
            },
            {
                field: 'AdmLocID',
                title: 'AdmLocID',
                width: 50,
                hidden: true
            },
            {
                field: 'Tinci',
                title: 'Tinci',
                width: 100,
                hidden: true
            },
            {
                field: 'DispItmCode',
                title: 'ҩƷ����',
                width: 75,
                sortable: true
            },
            {
                field: 'DispItmDesc',
                title: 'ҩƷ����',
                width: 220
            },
            {
                field: 'DispQty',
                title: '��ҩ����',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetQty',
                title: '��ҩ����',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Total',
                title: '�ϼ�����',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Uom',
                title: '��λ',
                width: 60
            },
            {
                field: 'TPhciPrice',
                title: '����',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'Amount',
                title: '���',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'TBarCode',
                title: '���',
                width: 80
            },
            {
                field: 'TManf',
                title: '������ҵ',
                width: 120
            },
            {
                field: 'TPhcfDesc',
                title: '����',
                width: 100
            },
            {
                field: 'Tward',
                title: '����/����',
                width: 150
            },
            {
                field: 'Tgeneric',
                title: 'ͨ����',
                width: 100,
                hidden: true
            },
            {
                field: 'TTotalUom',
                title: '����(��λ)',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    };
    //����datagrid
    $('#grid-dispstatdetail').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var startdate = startdatetime.split(' ')[0];
    var starttime = startdatetime.split(' ')[1];
    var enddate = enddatetime.split(' ')[0];
    var endtime = enddatetime.split(' ')[1];
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert('��ѡ�����!');
        return;
    }
    var inciRowId = $('#sel-locinci').val();
    if (inciRowId == null) {
        inciRowId = '';
    }
    var dispType = $('#sel-disptype').val();
    if (dispType == null) {
        dispType = '';
    }
    var stkGrp = $('#sel-stkgrp').val();
    if (stkGrp == null) {
        stkGrp = '';
    }
    var statFlag = '';
    var seekType = $('#sel-seektype').val();
    if (seekType == '��ѡ��' || seekType == 0) {
        statFlag = '0';
    }
    if (seekType == 1) {
        statFlag = '1';
    }
    var phcCat = '',
        includeDisp = '',
        patNo = '';
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params =
        startdate +
        tmpSplit +
        enddate +
        tmpSplit +
        phaLoc +
        tmpSplit +
        dispType +
        tmpSplit +
        starttime +
        tmpSplit +
        endtime +
        tmpSplit +
        inciRowId +
        tmpSplit +
        statFlag +
        tmpSplit +
        phcCat +
        tmpSplit +
        includeDisp +
        tmpSplit +
        patNo +
        tmpSplit +
        stkGrp;
    KillDispStatTMP();
    $('#grid-dispstattotal').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTPCHCOLLS',
            QueryName: 'DispStat',
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
    $('#grid-dispstatdetail').clearEasyUIGrid();
}

///��ѯ��ϸ
function QuerySub() {
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var selecteddata = $('#grid-dispstattotal').datagrid('getSelected');
    if (selecteddata == null) {
        //return;
    }
    var checkedItems = $('#grid-dispstattotal').datagrid('getChecked');
    if (checkedItems == null || checkedItems == '') {
        dhcphaMsgBox.alert('�빴ѡ��Ҫͳ�ƵĿ���!');
        return;
    }
    var admLocStr = '',
        pid = '';
    $.each(checkedItems, function (index, item) {
        if (admLocStr == '') {
            admLocStr = item.AdmLocRowid;
        } else {
            admLocStr = admLocStr + '^' + item.AdmLocRowid;
        }
        pid = item.ProcessID;
    });
    var params = pid + tmpSplit + admLocStr;
    $('#grid-dispstatdetail').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTPCHCOLLS',
            QueryName: 'DispStatItm',
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
}

///��ӡ
function BPrintHandler() {
    //��ȡ��ǰ������������
    if ($('#grid-dispstattotal').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('ҳ��û������');
        return;
    }
    if ($('#grid-dispstattotal').datagrid('getChecked') == null) {
        dhcphaMsgBox.alert('��ѡ����Ҫ��ӡ�Ŀ���!');
        return;
    }
    if ($('#grid-dispstatdetail').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('ҳ��û������');
        return;
    }
    // �谴�������
    var DispQuerydgOption = $('#grid-dispstatdetail').datagrid('options');
    var DispQuerydgParams = DispQuerydgOption.queryParams.Params;
    var DispQuerydgUrl = DispQuerydgOption.url;
    var DispQuerydgClassName = DispQuerydgOption.queryParams.ClassName;
    var DispQuerydgQueryName = DispQuerydgOption.queryParams.QueryName;
    $.ajax({
        type: 'GET',
        url: DispQuerydgUrl + '?&page=1&rows=9999&ClassName=' + DispQuerydgClassName + '&QueryName=' + DispQuerydgQueryName + '&Params=' + DispQuerydgParams,
        async: false,
        dataType: 'json',
        success: function (dispquerydata) {
            // ���������
            var rows = dispquerydata.rows;
            var rowsLen = rows.length;
            if (rowsLen == 0) {
                return;
            }
            var wardRowsArr = [];
            for (var i = 0; i < rowsLen; i++) {
                var rowData = rows[i];
                var ward = rowData.Tward;
                if (ward == '') {
                    continue;
                }
                if (!wardRowsArr[ward]) {
                    wardRowsArr[ward] = [];
                }
                wardRowsArr[ward].push(rowData);
            }

            var paraData = GetXmlPrintPara();
            for (var wId in wardRowsArr) {
                var listData = wardRowsArr[wId];
                var paraWard = paraData.ward;
                if (paraWard.indexOf('��  ��') >= 0) {
                    paraData.ward = '��  ��:' + listData[0].Tward;
                } else if (paraWard.indexOf('��  ��') >= 0) {
                    paraData.ward = '��  ��:' + listData[0].Tward;
                }
                PRINTCOM.XML({
                    printBy: 'lodop',
                    XMLTemplate: 'PHAIPDispStat',
                    data: {
                        Para: paraData,
                        List: listData
                    },
                    listBorder: { style: 4, startX: 1, endX: 180 },
                    page: { rows: 28, x: 8, y: 8, fontname: '����', fontbold: 'false', fontsize: '12', format: '��{1}ҳ/��{2}ҳ' }
                });
            }
        }
    });
}

/*
 * @creator: Huxt 2019-12-24
 * @desc: ��ȡxml��ӡPara����
 */
function GetXmlPrintPara() {
    var HospitalDesc = tkMakeServerCall('web.DHCSTKUTIL', 'GetHospName', session['LOGON.HOSPID']);
    var phaloc = $('#sel-phaloc').select2('data')[0].text;
    var seektype = $('#sel-seektype').select2('data')[0].text;
    if (seektype.indexOf('����') >= 0) {
        phawardtitle = '��  ��:';
    } else {
        phawardtitle = '��  ��:';
    }
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var daterange = startdatetime + ' �� ' + enddatetime;
    return {
        title: HospitalDesc + '��ҩͳ��',
        phaloc: phaloc,
        ward: phawardtitle,
        daterange: daterange,
        PrintDate: getPrintDateTime(),
        PrintUserName: session['LOGON.USERNAME']
    };
}

//���
function ClearConditions() {
    var today = new Date();
    $('#date-start')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-start')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-end')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#date-end')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#sel-stkgrp').empty();
    $('#sel-locinci').empty();
    $('#sel-disptype').empty();
    KillDispStatTMP();
    $('#grid-dispstatdetail').clearEasyUIGrid();
    $('#grid-dispstattotal').clearEasyUIGrid();
    $('#grid-dispstattotal').datagrid('uncheckAll');
}
//�����ʱglobal
function KillDispStatTMP() {
    var totalrowsdata = $('#grid-dispstattotal').datagrid('getRows');
    var totalrows = totalrowsdata.length;
    if (totalrows > 0) {
        var firstdata = $('#grid-dispstattotal').datagrid('getData').rows[0];
        var killret = tkMakeServerCall('web.DHCSTPCHCOLLS', 'ClearColl', firstdata['ProcessID']);
    }
}
window.onbeforeunload = function () {
    KillDispStatTMP(); //�����쳣�ر��岻��
};
