/**
 * ����:	 סԺҩ�� - ����ҩƷͳ��
 * ��д��:	 yunhaibao
 * ��д����: 2021-01-22
 */
var PHA_IP_QUERY_POISON = {
    WardFlag: session['LOGON.WARDID'] || '' != '' ? 'Y' : 'N',
    DefaultData: [
        {
            conStartDate: 't',
            conEndDate: 't',
            conPhaLoc: session['LOGON.CTLOCID']
        }
    ]
};
$(function () {
    $('.js-con-panel').panel({
        title: PHA_COM.IsTabsMenu() !== true ? '����ҩƷͳ��' : '',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-paper-drug',
        fit: true,
        bodyCls: 'panel-body-gray'
    });
    InitDict();
    InitGridTrans();
    PHA.SetVals(PHA_IP_QUERY_POISON.DefaultData);
    $('#btnClean').on('click', CleanHandler);
    $('#btnPrint').on('click', PrintHandler);
    $('#btnFind').on('click', QueryHandler);
    $('#btnExport').on('click', ExportHandler);
});
function InitDict() {
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.UserLoc().url + '&UserId=' + session['LOGON.USERID'],
        panelHeight: '250',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function (data) {}
    });
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url
    });
    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        panelHeight: 'auto'
    });
}

function InitGridTrans() {
    var columns = [
        [
            {
                field: 'adm',
                title: '����ID',
                width: 100,
                hidden: true
            },
            {
                field: 'intr',
                title: '̨��ID',
                width: 100,
                hidden: true
            },
            {
                field: 'transDate',
                title: '��������',
                width: 100
            },

            {
                field: 'docLocDesc',
                title: '��������',
                width: 125
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'patSex',
                title: '�Ա�',
                width: 50
            },
            {
                field: 'patAge',
                title: '����',
                width: 50
            },
            {
                field: 'idNo',
                title: '����֤������',
                width: 170
            },
            {
                field: 'inciDesc',
                title: 'ҩƷ����',
                width: 200
            },
            {
                field: 'spec',
                title: '���',
                width: 100
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 75
            },
            {
                field: 'docName',
                title: '����ҽ��',
                width: 75
            },
            {
                field: 'dispUserName',
                title: '��ҩ��',
                width: 75
            },
            {
                field: 'collateUserName',
                title: '������',
                width: 75
            },
            {
                field: 'batNo',
                title: '����',
                width: 100
            },
            {
                field: 'expDate',
                title: 'Ч��',
                width: 100,
                hidden: true
            },
            {
                field: 'spAmt',
                title: '���',
                width: 100,
                align: 'right',
                hidden: true
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 100
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 100
            },
            {
                field: 'dosage',
                title: '����',
                width: 100
            },
            {
                field: 'oeoriRemark',
                title: 'ҽ����ע',
                width: 100
            },
            {
                field: 'prescNo',
                title: '������',
                width: 125
            },
            {
                field: 'medicare',
                title: '������',
                width: 100
            },
            {
                field: 'diagDesc',
                title: '���',
                width: 200,
                showTip: true
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 100,
                showTip: true
            },
            {
                field: 'agencyName',
                title: '����������',
                width: 100,
                showTip: true
            },
            {
                field: 'agencyIdNo',
                title: '������֤������',
                width: 170,
                showTip: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        toolbar: '#gridTransBar',
        pageSize: 100,
        pageNumber: 1,
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };

    PHA.Grid('gridTrans', dataGridOption);
}

function QueryHandler() {
    if ($('#conPhaLoc').combobox('getValue') === '') {
        PHA.Popover({
            msg: '����ѡ��ҩ����',
            type: 'alert'
        });
        return;
    }
    if ($('#conPoison').combobox('getValue') === '') {
        PHA.Popover({
            msg: '����ѡ����Ʒ���',
            type: 'alert'
        });
        return;
    }
    $('#gridTrans').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue'),
        poison: $('#conPoison').combobox('getValue')
    };

    var $grid = $('#gridTrans');
    var sort = $grid.datagrid('options').sortName;
    var order = $grid.datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Poison',
            QueryName: 'TotalTransData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $grid.datagrid('loadData', rowsData);
}
function CleanHandler() {
    PHA.DomData('.js-con-data', {
        doType: 'clear'
    });
    $('#gridTrans').datagrid('clear');
    PHA.SetVals(PHA_IP_QUERY_POISON.DefaultData);
}
function PrintHandler() {
    if ($('#gridTrans').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: 'û������',
            type: 'alert'
        });
        return;
    }
    var printTitle = '';
    var poisonDesc = $('#conPoison').combobox('getText');
    if (poisonDesc !== '') {
        var printTitle = poisonDesc;
    }
    var para = {
        printTitle: printTitle + $g('ҩƷ���յǼǱ�'),
        phaLocDesc: $('#conPhaLoc').combobox('getText'),
        countDate: $('#conStartDate').datebox('getValue') + '��' + $('#conEndDate').datebox('getValue'),
        printUserName: session['LOGON.USERNAME']
    };

    var list = $('#gridTrans').datagrid('getData').originalRows;

    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAIPControlDrug',
        data: {
            Para: para,
            List: list
        },
        preview: false,
        listBorder: { style: 4, startX: 1, endX: 275 },
        page: { rows: 15, x: 245, y: 2, fontname: '����', fontbold: 'true', fontsize: '12', format: 'ҳ�룺{1}/{2}' }
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

function ExportHandler() {
    if ($('#gridTrans').datagrid('getData').rows.length === 0) {
        PHA.Popover({
            msg: 'û������',
            type: 'alert'
        });
        return;
    }
    var printTitle = '';
    var poisonDesc = $('#conPoison').combobox('getText');
    if (poisonDesc !== '') {
        var printTitle = poisonDesc;
    }
    var fileName = printTitle + $g('ҩƷ���յǼǱ�') + new Date().getTime() + '.xlsx';
    PHA_COM.ExportGrid('gridTrans', fileName);
}
