/**
 * 名称:	 住院药房 - 发药统计
 * 编写人:	 yunhaibao
 * 编写日期: 2020-11-12
 */
 var PHA_IP_QUERY_STAT = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAIP_COM.KillTmpOnUnLoad('PHA.IP.Query.Stat', PHA_IP_QUERY_STAT.Pid);
$(function () {
    InitDict();
    InitGridGrp();
    InitGridInci();
    InitGridOrder();
    $('#btnClean').on('click', CleanHandler);
    $('#btnFind').on('click', QueryHandler);
    $('#btnFindInci').on('click', QueryInciHandler);

    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter'],
        ['btnFindInci', 'alt+s']
    ]);
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');

    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function (data) {
            PHA.ComboBox('conDispCat', {
                url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + data.RowId,
                panelHeight: 'auto',
                width: combWidth,
                multiple: true
            });
            PHA.ComboBox('conWardLoc', {
                url: PHA_STORE.WardLocByRecLoc().url+'&RecLocId='+ data.RowId,
                width: combWidth,
            });
        }
    });
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'WARD', Description: $g('病区汇总') },
            { RowId: 'DOCLOC', Description: $g('科室汇总') },
            { RowId: 'STKCAT', Description: $g('库存分类') },
            { RowId: 'ARCCAT', Description: $g('医嘱子类') },
            { RowId: 'POISON', Description: $g('管制分类') },
            { RowId: 'PHCFORM', Description: $g('剂型') },
            { RowId: 'DISPCAT', Description: $g('发药类别') },
            { RowId: 'PRIORITY', Description: $g('医嘱优先级') }
        ],
        panelHeight: 'auto',
        editable: false,
        width: combWidth,
        onSelect: function () {
            QueryHandler();
        }
    });
    $('#conWay').combobox('setValue', 'WARD');

    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLocByRecLoc().url+'&RecLocId='+session['LOGON.CTLOCID'],
        width: combWidth
    });
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });

    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        width: combWidth,
        multiple: true
    });

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 220
    });
    PHA.LookUp('conInci', opts);

    PHA.ComboBox('conIntrType', {
        data: [
            { RowId: 'P', Description: $g('住院发药') },
            { RowId: 'Y', Description: $g('住院退药') },
            { RowId: 'F', Description: $g('门诊发药') },
            { RowId: 'H', Description: $g('门诊退药') },
            { RowId: 'HC', Description: $g('门诊撤消退药') }
        ],
        panelHeight: 'auto',
        multiple: true,
        width: 220,
        editable: false,
        onSelect: function () {}
    });
}
function InitGridGrp() {
    var columns = [
        [
            {
                field: 'grpID',
                title: 'grpID',
                width: 100,
                hidden: true
            },
            {
                field: 'itmChk',
                checkbox: true
            },
            {
                field: 'grpDesc',
                title: '名称',
                width: 165,
                sortable: true
            },

            {
                field: 'dispAmt',
                title: '发药金额',
                // width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '退药金额',
                // width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '合计金额',
                //width: 90,
                align: 'right',
                sortable: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        autoSizeColumn: true,
        toolbar: '#gridGrpBar',
        pageNumber: 1,
        pagination: false,
        singleSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        queryOnSelect: false,
        loadFilter: PHA.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridOrder').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'itmChk') {
                $(this).datagrid('options').queryOnSelect = true;
            }
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridGrp', dataGridOption);

    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect == true) {
            $(this).datagrid('options').queryOnSelect = false;
            QueryInciHandler();
        }
    }
}
function InitGridInci() {
    var columns = [
        [
            {
                field: 'inci',
                title: '库存项ID',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '代码',
                width: 100,
                formatter: function (value, row, index) {
                    var inci = row.inci || '';
                    if (inci === '') {
                        return value;
                    }
                    return '<a class="pha-grid-a" onclick="QueryOrderHandler(' + inci + ')">' + value + '</a>';
                }
            },
            {
                field: 'inciDesc',
                title: '名称',
                width: 300,
                sortable: true
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 150
            },
            {
                field: 'uomDesc',
                title: '单位'
                //width: 50
            },
            {
                field: 'dispQty',
                title: '发药数量',
                //width: 70,
                align: 'right'
            },
            {
                field: 'retQty',
                title: '退药数量',
                //width: 70,
                align: 'right'
            },
            {
                field: 'qty',
                title: '合计数量',
                //width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'sp',
                title: '售价',
                // width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '合计金额',
                // width: 70,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        autoSizeColumn: true,
        onSortColumn: function () {
            QueryInciHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            // $('#gridOrder').datagrid('clear');
        },
        onSelect: function () {
            // QueryOrderHandler();
        }
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridOrder() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '开单科室'
            },
            {
                field: 'locDesc',
                title: '领药科室'
            },
            {
                field: 'bedNo',
                title: '床号'
            },
            {
                field: 'patNo',
                title: '登记号'
//                ,
//                formatter: function (value, row, index) {
//                    return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
//                }
            },
            {
                field: 'patName',
                title: '姓名'
            },
            {
                field: 'dosage',
                title: '剂量'
            },
            {
                field: 'freqDesc',
                title: '频次'
            },
            {
                field: 'instrucDesc',
                title: '用法'
            },
            {
                field: 'busiType',
                title: '类型',
                width: 50,
                styler: function (value, row, index) {
                    if (value === 'P' || value === 'F' || value === 'HC') {
                        //return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'Y' || value === 'H') {
                        return { class: 'phaip-grid-cell-ret' };
                    } else if (value === 'HC') {
                        return { class: 'phaip-grid-cell-ret' };
                    }
                },
                formatter: function (value, row, index) {
	                if (value === 'HC') return $g("撤消退药")
                    return value === 'P' || value === 'F' ? $g('发药') : $g('退药');
                }
            },
            {
                field: 'qtyUom',
                title: '数量'
            },
            {
                field: 'spAmt',
                title: '金额',
                align: 'right'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
                formatter: function (value, row, index) {
                    var busiType = row.busiType;
                    if (busiType === 'P' || busiType === 'Y') {
                        return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'prescNo',
                title: '处方号',
                align: 'center'
            },
            {
                field: 'oeoriDateTime',
                title: '开单时间',
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '护士处理医嘱信息',
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '领药审核信息'
            },
            {
                field: 'phaInfo',
                title: '发、退药信息'
            },
            {
                field: 'phaNo',
                title: '业务单号'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        pageNumber: 1,
        border: true,
        toolbar: null,
        pageSize: 100,
        pageNumber: 1,
        bodyCls: 'panel-body-gray',
        loadFilter: PHAIP_COM.LocalFilter,
        onSortColumn: function () {
            QueryOrderHandler();
        },

        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridOrder', dataGridOption);
    PHA.GridEvent('gridOrder', 'click', ['pha-grid-a js-grid-oeore', 'pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        var winOpts = $('#winOrder').window('options');
        var winTop = winOpts.top;
        var winWidth = winOpts.width;
        var winLeft = winOpts.left;
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { oeore: rowData.oeore }
            );
        }
//        if (className === 'pha-grid-a js-grid-patNo') {
//            PHA_UX.AdmDetail(
//                {
//                    top: winTop + $('body').height() / 2 - 50 + 10,
//                    height: 420,
//                    width: $('body').width() * 0.6
//                },
//                { AdmId: rowData.adm }
//            );
//        }
    });
}
function QueryHandler() {
    $('#gridGrp').datagrid('clearChecked');
    $('#gridGrp').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = GetParamsJson();

    var ret = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            dataType: 'text'
        },
        false
    );

    var sort = $('#gridGrp').datagrid('options').sortName;
    var order = $('#gridGrp').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalGrpData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    var footer = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_IP_QUERY_STAT.Pid,
            type: 'TotalGrpData'
        },
        false
    );
    rowsData.footer = footer;

    $('#gridGrp').datagrid('loadData', rowsData);
    $('#gridGrp').datagrid('getData').originalRows = rowsData.rows;
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var pJson = GetParamsJson();
    var grpIDArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpIDArr.push(chkRows[i].grpID);
    }
    pJson.grpID = grpIDArr.join(',');

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalInciData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    var footer = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_IP_QUERY_STAT.Pid,
            type: 'TotalInciData'
        },
        false
    );
    rowsData.footer = footer;
    $('#gridInci').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        inci: $('#conInci').lookup('getValue') || '',
        dispCat: $('#conDispCat').combobox('getValues').join(','),
        poison: $('#conPoison').combobox('getValues').join(','),
        way: $('#conWay').combobox('getValue') || '',
        // uomType: $('#conUomType').combobox('getValue') || '',
        intrType: $('#conIntrType').combobox('getValues').join(','),
        wardLoc: $('#conWardLoc').combobox('getValue'),
        docLoc: $('#conDocLoc').combobox('getValue')
    };
}
function QueryOrderHandler(inci) {
    var pJson = GetParamsJson();
    var grpIDArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpIDArr.push(chkRows[i].grpID);
    }
    pJson.grpID = grpIDArr.join(',');
    pJson.inci = inci;
    var sort = $('#gridOrder').datagrid('options').sortName;
    var order = $('#gridOrder').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalOrderData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $('#gridOrder').datagrid('loadData', rowsData);

    $('#winOrder')
        .window({
            width: $('body').width()*0.8,
            height: $('body').height() * 0.8,
            //top: 20,
            //left: 20,
            closed: true,
            iconCls: 'icon-w-clock',
            resizable: true,
            modal:function(){
	         	try {
					return $('#winOrder').window('options').modal;
				}catch(e){
					return true
				}
	        }(),
            isTopZindex: true,
            maximizable: false,
            minimizable: false,
            collapsible: false
        })
        .window('open');
     $('#winOrder').window('setModalable');
}

function CleanHandler() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '');
    $('#conEndTime').timespinner('setValue', '');
    $('#conPhaLoc').combobox('clear');
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conInci').lookup('clear');
    $('#conDispCat').combobox('clear');
    $('#conPoison').combobox('clear');
    $('#conWay').combobox('setValue', 'WARD');
    // uomType: $('#conUomType').combobox('getValue') || '',
    $('#conIntrType').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#gridGrp').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridOrder').datagrid('clear');
}
