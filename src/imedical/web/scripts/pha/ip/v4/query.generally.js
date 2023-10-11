/**
 * ����:	 סԺҩ�� - ��ҩ�ۺϲ�ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2020-03-14
 */
var PHA_IP_QUERY_GENERALLY = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAIP_COM.KillTmpOnUnLoad('PHA.IP.Query.Generally', PHA_IP_QUERY_GENERALLY.Pid);

$(function () {
    var $lyBody = $('#lyBody');
    $('.js-pha-con-toggle .panel-header, .pha-con-more-less').on('click', function (e) {
        $('.pha-con-more-less').toggle();
        $('.pha-con-more-less-link').toggle();
        var tHeight = $('.pha-con-more-less-link').css('display') === 'block' ? 175 : 135;
        $lyBody.layout('panel', 'north').panel('resize', { height: tHeight });
        $lyBody.layout('resize');
    });

    // PHAIP_COM.ToggleMore('moreorless', '.js-pha-moreorless', { width: $('#moreorless').closest('td').next().position().left - 20 });

    PHA_COM.ResizePanel({
        layoutId: 'lyBody',
        region: 'south',
        height: 0.5
    });
    //    PHAIP_COM.PanelCondition({
    //        body: '#lyBody',
    //        panel: '#panelCondition',
    //        field: '.pha-con-more-less',
    //        heightArr: [135, 215]
    //    });
    InitDict();
    InitGridInci();
    InitGridOrder();
    $('#btnFind').on('click', QueryHandler);
    $('#btnPrint').on('click', PrintHandler);
    $('#btnClean').on('click', CleanHandler);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
        }
    });

    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter']
    ]);
    setTimeout(function () {
        PHAIP_COM.ToggleMore('moreorless', '.js-pha-moreorless', { width: $($('.pha-con-table')[1]).outerWidth() });
    }, 500);
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');

    PHA.ComboBox('conPhaLoc', {
        width: combWidth,
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        required: true,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function (data) {
            PHA.ComboBox('conDispCat', {
                width: combWidth,
                url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + data.RowId,
                panelHeight: 'auto'
            });
            PHA.ComboBox('conPhaUser', {
                width: combWidth,
                url: PHA_STORE.SSUser(data.RowId).url
            });
            PHA.ComboBox('conWardLoc', {
                url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + data.RowId,
                width: combWidth
            });
        }
    });
    PHA.ComboBox('conDispWay', {
        data: [
            { RowId: 'WARD', Description: $g('������ҩ') },
            { RowId: 'DOCLOC', Description: $g('ҽ�����ҷ�ҩ') }
        ],
        panelHeight: 'auto',
        width: combWidth,
        onSelect: function () {}
    });
    PHA.ComboBox('conOut', {
        data: [
            { RowId: 'equal', Description: $g('����') },
            { RowId: 'not', Description: $g('����') }
        ],
        width: combWidth,
        panelHeight: 'auto',
        onSelect: function () {}
    });
    PHA.ComboBox('conWardLoc', {
        width: combWidth,
        url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + session['LOGON.CTLOCID']
    });
    PHA.ComboBox('conDocLoc', {
        width: combWidth,
        url: PHA_STORE.DocLoc().url
    });
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_STORE.PHCForm().url
    });
    PHA.ComboBox('conPoison', {
        width: combWidth,
        url: PHA_STORE.PHCPoison().url
    });

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 153
    });
    PHA.LookUp('conInci', opts);

    PHA.TriggerBox('conPhcCat', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('conPhcCat', {}, function (data) {
                $('#conPhcCat').triggerbox('setValue', data.phcCatDesc);
                $('#conPhcCat').triggerbox('setValueId', data.phcCatId);
            });
        }
    });
    PHA.ComboBox('conUomType', {
        width: combWidth,
        data: [
            { RowId: 'bUom', Description: '������λ����' },
            { RowId: 'pUom', Description: '��ⵥλ����' },
            { RowId: 'pbUomDesc', Description: '��������λ' }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
    PHA.ComboBox('conIntrType', {
        width: combWidth,
        data: [
            { RowId: 'P', Description: '��ҩ' },
            { RowId: 'Y', Description: '��ҩ' }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
}
function InitGridInci() {
    var columns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '����',
                width: 100
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                sortable: true
            },
            {
                field: 'spec',
                title: '���',
                width: 100
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 150
            },
            {
                field: 'goodName',
                title: '��Ʒ��',
                width: 100
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 50
            },
            {
                field: 'qty',
                title: '�ϼ�����',
                width: 70,
                align: 'right',
                sortable: true
            },

            {
                field: 'amt',
                title: '�ϼƽ��',
                width: 70,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'dispAmt',
                title: '��ҩ���',
                width: 70,
                align: 'right'
            },
            {
                field: 'retQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'retAmt',
                title: '��ҩ���',
                width: 70,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: '#gridInciBar',
        pageNumber: 1,
        pageSize: 100,
        onSortColumn: function () {
            QueryHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridOrder').datagrid('clear');
        },
        onSelect: function () {
            QueryOrderHandler();
        }
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridOrder() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '��������',
                width: 150
            },
            {
                field: 'locDesc',
                title: '��ҩ����',
                width: 150
            },
            {
                field: 'bedNo',
                title: '����',
                width: 70
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100,
                formatter: function (value, row, index) {
                    return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
                }
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 95,
                align: 'center'
            },
            {
                field: 'dosage',
                title: '����',
                width: 100
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 100
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 100
            },
            {
                field: 'busiType',
                title: '����',
                width: 50,
                styler: function (value, row, index) {
                    if (value === 'P') {
                        //return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'Y') {
                        return { class: 'phaip-grid-cell-ret' };
                    }
                },
                formatter: function (value, row, index) {
                    return value === 'P' ? $g('��ҩ') : $g('��ҩ');
                }
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 75
            },
            {
                field: 'spAmt',
                title: '���',
                align: 'right'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                formatter: function (value, row, index) {
                    return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
                }
            },
            {
                field: 'prescNo',
                title: '������',
                width: 120,
                align: 'center'
            },
            {
                field: 'oeoriDateTime',
                title: '����ʱ��',
                width: 155,
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '��ʿ����ҽ����Ϣ'
            },
            {
                field: 'nurAuditInfo',
                title: '��ҩ�����Ϣ'
            },
            {
                field: 'phaInfo',
                title: '������ҩ��Ϣ'
            },
            {
                field: 'phaNo',
                title: 'ҵ�񵥺�'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        toolbar: [],
        pageNumber: 1,
        pageSize: 100,
        autoSizeColumn: true,
        onSortColumn: function () {
            QueryOrderHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridOrder', dataGridOption);
    PHA.GridEvent('gridOrder', 'click', ['pha-grid-a js-grid-oeore', 'pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    top: null,
                    modalable: true
                },
                { oeore: rowData.oeore }
            );
        }
        if (className === 'pha-grid-a js-grid-patNo') {
            PHA_UX.AdmDetail({}, { AdmId: rowData.adm });
        }
    });
}
function QueryHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = GetParamsJson();
    var ret = $.cm(
        {
            ClassName: 'PHA.IP.Query.Generally',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_GENERALLY.Pid,
            dataType: 'text'
        },
        false
    );

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Generally',
            QueryName: 'TotalInciData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_GENERALLY.Pid,
            rows: 9999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    var footer = $.cm(
        {
            ClassName: 'PHA.IP.Query.Generally',
            MethodName: 'GetFooter',
            pid: PHA_IP_QUERY_GENERALLY.Pid
        },
        false
    );
    rowsData.footer = footer;

    $('#gridInci').datagrid('loadData', rowsData);
}

function QueryOrderHandler() {
    $('#gridOrder').datagrid('loading');
    setTimeout(QueryOrder, 100);
}
function QueryOrder() {
    var pJson = GetParamsJson();
    pJson.inci = $('#gridInci').datagrid('getSelected').inci;

    var sort = $('#gridOrder').datagrid('options').sortName;
    var order = $('#gridOrder').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Generally',
            QueryName: 'TotalOrderData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_GENERALLY.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridOrder').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue') || '',
        wardLoc: $('#conWardLoc').combobox('getValue') || '',
        patNo: $('#conPatNo').val().trim(),
        phaNo: $('#conPhaNo').val() || '',
        phcForm: $('#conForm').combobox('getValue') || '',
        outFlag: $('#conOut').combobox('getValue') || '',
        phcCat: $('#conPhcCat').triggerbox('getValue') || '',
        inci: $('#conInci').lookup('getValue') || '',
        dispCat: $('#conDispCat').combobox('getValue') || '',
        poison: $('#conPoison').combobox('getValue') || '',
        dispWay: $('#conDispWay').combobox('getValue') || '',
        phaUser: $('#conPhaUser').combobox('getValue') || '',
        uomType: $('#conUomType').combobox('getValue') || '',
        intrType: $('#conIntrType').combobox('getValue') || '',
        prescNo: $('#conPrescNo').val() || ''
    };
}

function CleanHandler() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '');
    $('#conEndTime').timespinner('setValue', '');
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conDocLoc').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conPatNo').val(''), $('#conPhaNo').val('');
    $('#conForm').combobox('clear');
    $('#conOut').combobox('clear');
    $('#conPhcCat').triggerbox('setValue', '');
    $('#conInci').lookup('clear');
    $('#conDispCat').combobox('clear');
    $('#conPoison').combobox('clear');
    $('#conDispWay').combobox('clear');
    $('#conPhaUser').combobox('clear');
    $('#conUomType').combobox('clear');
    $('#conIntrType').combobox('clear');
    $('#conPrescNo').val('');
    $('#gridInci').datagrid('clear');
}
function PrintHandler() {
    if ($('#gridInci').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: '���Ȳ�ѯ���ݣ� �ٽ��д�ӡ',
            type: 'alert'
        });
        return;
    }
    //��ȡ��������

    var para = {
        title: session['LOGON.HOSPDESC'] + '��ҩ�ۺϲ�ѯͳ��',
        countDate: $('#conStartDate').datebox('getValue') + '��' + $('#conEndDate').datebox('getValue'),
        printDate: PHA_UTIL.GetTime('', 'Y'),
        phLocDesc: $('#conPhaLoc').combobox('getText'),
        wardDesc: $('#conWardLoc').combobox('getText')
    };

    var list = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').originalRows));
    // ���Ӻϼ�
    var footer = JSON.parse(JSON.stringify($('#gridInci').datagrid('getData').footer[0]));
    footer.inciDesc = '�ϼ�';
    list.push(footer);
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAIPDispQueryGenerally',
        data: {
            Para: para,
            List: list
        },
        preview: false,
        listBorder: { style: 2, startX: 1, endX: 195 },
        page: {
            rows: 30,
            x: 185,
            y: 2,
            fontname: '����',
            fontbold: 'true',
            fontsize: '12',
            format: 'ҳ�룺{1}/{2}'
        }
    });
    if (typeof App_MenuCsp) {
        PHA_LOG.Operate({
            operate: 'P',
            logInput: JSON.stringify(para),
            // logInput: logParams,
            type: 'page',
            pointer: App_MenuCsp,
            origData: '',
            remarks: App_MenuName
        });
    }
}
