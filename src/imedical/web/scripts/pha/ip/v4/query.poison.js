/**
 * 名称:	 住院药房 - 管制药品统计
 * 编写人:	 yunhaibao
 * 编写日期: 2021-01-22
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
        title: PHA_COM.IsTabsMenu() !== true ? '管制药品统计' : '',
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
                title: '就诊ID',
                width: 100,
                hidden: true
            },
            {
                field: 'intr',
                title: '台账ID',
                width: 100,
                hidden: true
            },
            {
                field: 'transDate',
                title: '发退日期',
                width: 100
            },

            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 125
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'patSex',
                title: '性别',
                width: 50
            },
            {
                field: 'patAge',
                title: '年龄',
                width: 50
            },
            {
                field: 'idNo',
                title: '患者证件号码',
                width: 170
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 200
            },
            {
                field: 'spec',
                title: '规格',
                width: 100
            },
            {
                field: 'qtyUom',
                title: '数量',
                width: 75
            },
            {
                field: 'docName',
                title: '开单医生',
                width: 75
            },
            {
                field: 'dispUserName',
                title: '发药人',
                width: 75
            },
            {
                field: 'collateUserName',
                title: '复核人',
                width: 75
            },
            {
                field: 'batNo',
                title: '批号',
                width: 100
            },
            {
                field: 'expDate',
                title: '效期',
                width: 100,
                hidden: true
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 100,
                align: 'right',
                hidden: true
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 100
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 100
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 100
            },
            {
                field: 'oeoriRemark',
                title: '医嘱备注',
                width: 100
            },
            {
                field: 'prescNo',
                title: '处方号',
                width: 125
            },
            {
                field: 'medicare',
                title: '病案号',
                width: 100
            },
            {
                field: 'diagDesc',
                title: '诊断',
                width: 200,
                showTip: true
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 100,
                showTip: true
            },
            {
                field: 'agencyName',
                title: '代办人姓名',
                width: 100,
                showTip: true
            },
            {
                field: 'agencyIdNo',
                title: '代办人证件号码',
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
            msg: '请先选择发药科室',
            type: 'alert'
        });
        return;
    }
    if ($('#conPoison').combobox('getValue') === '') {
        PHA.Popover({
            msg: '请先选择管制分类',
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
            msg: '没有数据',
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
        printTitle: printTitle + $g('药品逐日登记表'),
        phaLocDesc: $('#conPhaLoc').combobox('getText'),
        countDate: $('#conStartDate').datebox('getValue') + '至' + $('#conEndDate').datebox('getValue'),
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
        page: { rows: 15, x: 245, y: 2, fontname: '黑体', fontbold: 'true', fontsize: '12', format: '页码：{1}/{2}' }
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
            msg: '没有数据',
            type: 'alert'
        });
        return;
    }
    var printTitle = '';
    var poisonDesc = $('#conPoison').combobox('getText');
    if (poisonDesc !== '') {
        var printTitle = poisonDesc;
    }
    var fileName = printTitle + $g('药品逐日登记表') + new Date().getTime() + '.xlsx';
    PHA_COM.ExportGrid('gridTrans', fileName);
}
