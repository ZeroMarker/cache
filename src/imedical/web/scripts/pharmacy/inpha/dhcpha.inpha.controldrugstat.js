/**
 * ģ��:סԺҩ��
 * ��ģ��:��˵�-����ҩƷͳ��
 * createdate:2016-12-15
 * creator:dinghongying
 */
$(function () {
    /* ��ʼ����� start*/
    var daterangeoptions = {
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    //�������лس��¼�
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    InitPhaLoc();
    InitLoc();
    InitStkCat();
    InitPoisonCat();
    InitControlDrugList();
    /* �󶨰�ť�¼� start*/
    $('#btn-find').on('click', Query);
    $('#btn-print').on('click', BPrintHandler);
    $('#btn-clear').on('click', ClearConditions);
    /* �󶨰�ť�¼� end*/ $('#grid-controldrug').closest('.panel-body').height(GridCanUseHeight(1));
});

//��ʼ����ҩ����
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option); //��Ĭ��ֵ,û�뵽�ð취,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//��ʼ���������
function InitLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetCtLocDs&style=select2&custtype=DocLoc',
        allowClear: true,
        width: 150
    };
    $('#sel-admloc').dhcphaSelect(selectoption);
    $('#sel-admloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//��ʼ��������
function InitStkCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetStkCatDs&style=select2',
        allowClear: true,
        width: 270
    };
    $('#sel-stk').dhcphaSelect(selectoption);
}

//��ʼ�����Ʒ���
function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetPoisonCatDs&style=select2',
        allowClear: true,
        width: 150,
        minimumResultsForSearch: Infinity
    };
    $('#sel-poison').dhcphaSelect(selectoption);
}

//��ʼ������ҩƷͳ���б�
function InitControlDrugList() {
    //����columns
    var columns = [
        [
            { field: 'TDate', title: '����', width: 100, align: 'center' },
            { field: 'TPrescNo', title: '������', width: 120, align: 'center' },
            { field: 'TRegNo', title: '�ǼǺ�', width: 100, align: 'center' },
            { field: 'TPaName', title: '��������', width: 100 },
            { field: 'TSex', title: '�Ա�', width: 80, align: 'center' },
            { field: 'TAge', title: '����', width: 80 },
            { field: 'TIDNO', title: '���ߣ������ˣ�֤������', width: 120 },
            { field: 'TPRNO', title: '������', width: 100 },
            { field: 'TDiagNose', title: '���', width: 200 },
            { field: 'TDrugDesc', title: 'ҩƷ����', width: 120 },
            { field: 'TQty', title: '����', width: 80, align: 'right' },
            { field: 'TDoctor', title: 'ҽ��', width: 80 },
            { field: 'TDispUser', title: '��ҩ��', width: 80 },
            { field: 'TAuditor', title: '������', width: 80 },
            { field: 'TDrugBatchNo', title: 'ҩƷ����', width: 120 },
            { field: 'TAdmLoc', title: '�Ʊ�', width: 80 },
            { field: 'TAmt', title: '���', width: 80, align: 'right' },
            { field: 'TFreq', title: 'Ƶ��', width: 80 },
            { field: 'TDoseQty', title: '����', width: 80 },
            { field: 'TRem', title: '��ע', width: 80 },
            { field: 'TInstruction', title: '�÷�', width: 80 },
            { field: 'Tuom', title: '��λ', width: 80, hidden: true },
            { field: 'TBarCode', title: '���', width: 80 },
            { field: 'Tpid', title: 'Tpid', width: 10, hidden: true }
        ]
    ];

    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false
    };
    //����datagrid
    $('#grid-controldrug').dhcphaEasyUIGrid(dataGridOption);
}

///��ѯ
function Query() {
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert('��ѡ�����!');
        return;
    }
    var locId = $('#sel-admloc').val();
    if (locId == null) {
        locId = '';
    }
    var stkCatId = $('#sel-stk').val();
    if (stkCatId == null) {
        stkCatId = '';
    }
    var poisonCatId = $('#sel-poison').val();
    if (poisonCatId == null) {
        dhcphaMsgBox.alert('���Ʒ���Ϊ��ѡ�');
        return;
    }
    var chkdocloc = '';
    if ($('#chk-docloc').is(':checked')) {
        chkdocloc = 'on';
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = phaLoc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + stkCatId + tmpSplit + poisonCatId + tmpSplit + chkdocloc + tmpSplit + locId;

    $('#grid-controldrug').datagrid('options').url = DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL;
    $('#grid-controldrug').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTDISPSTATDM',
            QueryName: 'DispStatDM',
            Params: params //�˴�params�����ָ�,���Ӳ�ָ����Լ�˳��ͬ��Ӧquery
        }
    });
}

///��ӡ
function BPrintHandler() {
    //��ȡ��ǰ������������
    if ($('#grid-controldrug').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('ҳ��û������');
        return;
    }
    //��ȡ��������
    var seleclocdata = $('#sel-phaloc').select2('data')[0];
    var phLocDesc = seleclocdata.text;
    var daterange = $('#date-start').val().split(' ')[0] + ' �� ' + $('#date-end').val().split(' ')[0];
    var Para = {
        phLocDesc: phLocDesc,
        CountDate: daterange,
        PrintUserName: DHCPHA_CONSTANT.SESSION.GUSER_NAME
    };
    //��ӡ���� Huxt 2019-12-25
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAIPControlDrug',
        data: {
            Para: Para,
            Grid: { type: 'easyui', grid: 'grid-controldrug' }
        },
        preview: false,
        listBorder: { style: 4, startX: 1, endX: 275 },
        page: { rows: 15, x: 245, y: 2, fontname: '����', fontbold: 'true', fontsize: '12', format: 'ҳ�룺{1}/{2}' }
    });
}

//���
function ClearConditions() {
    var today = new Date();
    $('#date-start').data('daterangepicker').setStartDate(new Date());
    $('#date-end').data('daterangepicker').setEndDate(new Date());
    $('#sel-admloc').empty();
    $('#sel-stk').empty();
    $('#sel-poison').empty();
    $('#chk-docloc').iCheck('uncheck');
    $('#grid-controldrug').clearEasyUIGrid();
}
