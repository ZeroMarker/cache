/**
 * 住院药房 - 退药单查询
 * @author yunhaibao
 * @since 2020-11-12
 */
var PHA_IP_QUERY_RETURN = {
    WardFlag: session['LOGON.WARDID'] || '' !== '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};

$(function () {
    var settings = PHA.CM(
        {
            pClassName: 'PHA.IP.Return.Api',
            pMethodName: 'GetSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                macAddr: PHAIP_COM.GetMac()
            })
        },
        false
    );
    PHA_IP_QUERY_RETURN.config = settings.config;

    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            $('#btnFind').click();
            $(this).focus().select();
        }
    });
    $('#conRetNo,#conReqNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#btnFind').click();
            $(this).focus().select();
        }
    });
    InitDict();
    InitGridRet();
    InitGridInci();
    InitGridDetail();
    InitSelectPrintWay();
    $('#btnClean').on('click', CleanHandler);
    $('#btnPrint').on('click', PrintHandler);
    $('#btnFind').on('click', QueryHandler);

    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter']
    ]);

    setTimeout(function () {
        PHAIP_COM.ToggleMore('moreorless', '.js-pha-moreorless', { width: $($('.js-pha-moreorless .pha-con-table')[0]).outerWidth() });
        PHA_COM.ResizePanel({
            layoutId: 'lyBody',
            region: 'north',
            height: 0.5
        });
    }, 0);
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', PHA_UTIL.GetDate('t'));
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
                multiple: false
            });
            PHA.ComboBox('conWardLoc', {
                url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + data.RowId,
                width: combWidth
            });
        }
    });
    PHA.ComboBox('conDispCat', {
        url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + '',
        panelHeight: 'auto',
        width: combWidth,
        multiple: false
    });
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'REQ', Description: $g('申请退药') },
            { RowId: 'RET', Description: $g('直接退药') },
            { RowId: 'RES', Description: $g('冲减退药') }
        ],
        panelHeight: 'auto',
        width: combWidth,
        onSelect: function () {
            // QueryHandler();
        }
    });

    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + session['LOGON.CTLOCID'], //修改为按接收科室取病区 By zhaoxinlong 2022.04.24
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
        width: 160
    });
    PHA.LookUp('conInci', opts);

    PHA.ComboBox('conIntrType', {
        data: [
            { RowId: 'P', Description: $g('住院发药') },
            { RowId: 'Y', Description: $g('住院退药') },
            { RowId: 'F', Description: $g('门诊发药') },
            { RowId: 'H', Description: $g('门诊退药') }
        ],
        panelHeight: 'auto',
        multiple: true,
        width: 220,
        editable: false,
        onSelect: function () {}
    });
}
function InitSelectPrintWay() {
    $('#kwPrintWay').keywords({
        singleSelect: true,
        items: [
            { text: $g('默认打印'), id: 'default', selected: true },
            { text: $g('打印药品汇总'), id: 'total' },
            { text: $g('打印患者药品汇总'), id: 'detail' }
        ],
        onSelect: function (rowData) {
            if (rowData.id === 'default') {
                PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['total', 'detail']);
            } else {
                PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['default']);
            }
        }
    });
    $('#winSelectPrintWay').dialog({
        title: '打印方式',
        collapsible: false,
        iconCls: 'icon-w-list',
        maximizable: false,
        minimizable: false,
        border: false,
        closable: false,
        closed: true,
        modal: true,
        onOpen: function () {
            $('#winSelectPrintWay')
                .window('resize', {
                    width: $('#winSelectPrintWay .pha-con-table').width() + 10,
                    height: 'auto'
                })
                .window('center');
        },
        buttons: [
            {
                text: '确定',
                handler: function () {
                    $('#winSelectPrintWay').dialog('close');
                    var retID = $('#gridRet').datagrid('getSelected').rowID;
                    PrintReturnCom(retID, '补', $('#kwPrintWay').keywords('getSelected')[0].id);
                }
            },
            {
                text: '取消',
                handler: function () {
                    $('#winSelectPrintWay').dialog('close');
                }
            }
        ]
    });
}
function InitGridRet() {
    var columns = [
        [
            {
                field: 'rowID',
                title: '退药单ID',
                width: 100,
                hidden: true
            },
            //            {
            //                field: 'itmChk',
            //                checkbox: true
            //            },
            {
                field: 'no',
                title: '单号',
                width: 250,

                sortable: true
            },

            {
                field: 'locDesc',
                title: '药房',
                width: 150,
                hidden: PHA_IP_QUERY_RETURN.WardFlag === 'Y' ? false : true,
                sortable: true
            },
            {
                field: 'deptDesc',
                title: '科室 / 病区',
                width: 200,
                sortable: true
            },

            {
                field: 'date',
                title: '日期',
                width: 95,
                align: 'center',
                sortable: true
            },
            {
                field: 'time',
                title: '时间',
                width: 95,
                align: 'center',
                sortable: true
            },
            {
                field: 'userName',
                title: '退药人',
                width: 100,

                sortable: true
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'wayDesc',
                title: '退药方式',
                sortable: true,
                styler: function (value, row, index) {
                    if (value == 'RES') {
                        return { class: 'phaip-grid-cell-res' };
                    } else if (value == 'REQ') {
                        return { class: 'phaip-grid-cell-req' };
                    } else if (value == 'RET') {
                        //return 'background-color:#e2ffde;color:#fff;';
                    }
                    return '';
                },
                formatter: function (value, row, index) {
                    if (value == 'RES') {
                        return $g('冲减退药');
                    } else if (value == 'REQ') {
                        return $g('申请退药');
                    } else if (value == 'RET') {
                        return $g('直接退药');
                    }
                }
            },
            {
                field: 'reqInfo',
                title: '申请单信息',
                // width: 90,

                sortable: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        columns: columns,
        fitColumns: true,
        // showFooter: true,
        toolbar: '#panelCondition',
        pageNumber: 1,
        pageSize: 100,
        autoSizeColumn: true,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        queryOnSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridDetail').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridRet', dataGridOption);

    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect === false) {
            $(this).datagrid('options').queryOnSelect = true;
            $(this).datagrid('unselectAll');
            $(this).datagrid('selectRow', rowIndex);

            QueryDetailHandler(rowData.rowID);
            QueryInciHandler(rowData.rowID);

            $(this).datagrid('options').queryOnSelect = false;
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
                width: 100
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
                width: 200
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 100
            },
            {
                field: 'retQty',
                title: '退药数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 100,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        onSortColumn: function () {
            QueryInciHandler();
        },
        loadFilter: PHAIP_COM.LoadFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        },
        onSelect: function () {}
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridDetail() {
    var columns = [
        [
            {
                field: 'pharil',
                title: '退药孙表ID',
                width: 100,
                hidden: true
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 150
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 70
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100,
                formatter: function (value, row, index) {
                    return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
                }
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 95
            },
            {
                field: 'inciCode',
                title: '代码',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: '名称',
                width: 300,
                sortable: true
            },
            {
                field: 'spec',
                title: '规格',
                width: 100,
                hidden: true
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 150
            },

            {
                field: 'uomDesc',
                title: '单位',
                width: 75
            },

            {
                field: 'retQty',
                title: '退药数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '申请数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '发药数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'sp',
                title: '售价',
                width: 100,
                align: 'right'
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 100,
                align: 'right'
            },
            {
                field: 'phacil',
                title: '发药孙表ID'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
                formatter: function (value, row, index) {
                    var qOpts = "{oeore:'" + row.oeore + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.TimeLine({},' + qOpts + ')">' + value + '</a>';
                }
            },
            {
                field: 'resInfo',
                title: '冲减信息',
                formatter: function (value, row, index) {
                    var arr = JSON.parse(row.resArr);
                    if (arr.length === 0) {
                        return '';
                    }
                    var cntTag = '<div class="pha-tag pha-tag-success tag-cnt">' + arr.length + '</div>';
                    return FormatResHtml([arr[0]], cntTag);
                }
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        columns: columns,
        fitColumns: false,
        autoSizeColumn: true,
        pageNumber: 1,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        loadFilter: PHAIP_COM.LocalFilter,
        onSortColumn: function () {
            QueryDetailHandler();
        },

        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('.pha-res-body .pha-tag').hover(
                function (e) {
                    var rowIndex = $(e.target).closest('tr').attr('datagrid-row-index') * 1;
                    var rowData = $('#gridDetail').datagrid('getRows')[rowIndex];
                    var resData = JSON.parse(rowData.resArr);
                    var info = FormatResHtml(resData, '');
                    WebuiPopovers.show($(event.target), { title: '冲减信息', content: info, animated: 'pop', closeable: true });
                    //                $('#winResInfo').html(info);
                    //                $('#winRes')
                    //                    .window({
                    //                        width: $(e.target).closest('td').width()
                    //                    })
                    //                    .window('open');
                },
                function () {
                    WebuiPopovers.hideAll();
                }
            );
        }
    };
    PHA.Grid('gridDetail', dataGridOption);
    PHA.GridEvent('gridDetail', 'click', ['pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        PHA_UX.AdmDetail({ top: 10 }, { AdmId: rowData.adm });
    });
}

function FormatResHtml(rowsData, cntTag) {
    var htmlArr = [];
    for (var i = 0; i < rowsData.length; i++) {
        var rowData = rowsData[i];
        var rowHtmlArr = [];
        rowHtmlArr.push('<div style="min-width:50px">' + rowData.patName + '</div>');
        rowHtmlArr.push('<div class="split"> | </div>');
        rowHtmlArr.push('<div style="">' + rowData.patNo + '</div>');
        rowHtmlArr.push('<div class="split"> | </div>');
        rowHtmlArr.push('<div style="">' + rowData.doseDateTime + '</div>');
        rowHtmlArr.push('<div class="split">  </div>');
        rowHtmlArr.push('<div style="min-width:20px">' + rowData.qtyUom + '</div>');
        rowHtmlArr.push('<div class="split"> | </div>');
        rowHtmlArr.push('<div style="">' + rowData.phacDateTime + '</div>');
        rowHtmlArr.push('<div class="split"> | </div>');
        rowHtmlArr.push('<div style="">' + rowData.phacNo + '</div>');
        var paddstyle = '';
        if (cntTag === '') {
            // paddstyle += 'padding-bottom:5px;';
        }
        if (i > 0) {
            paddstyle += 'padding-top:5px;border-top:1px solid #ccc;';
        }
        htmlArr.push('<div></div><div class="pha-res-body" style="' + paddstyle + '">' + cntTag + rowHtmlArr.join('') + '</div>');
    }
    return htmlArr.join('');
}
function QueryHandler() {
    if ($('#conPhaLoc').combobox('getValue') === '') {
        PHA.Popover({
            msg: '请先选择退药药房',
            type: 'alert'
        });
        return;
    }

    $('#gridRet').datagrid('clearChecked');
    $('#gridRet').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    $('#gridRet').datagrid('clear');
    var pJson = GetParamsJson();
    var sort = $('#gridRet').datagrid('options').sortName;
    var order = $('#gridRet').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Return',
            QueryName: 'PhaReturn',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $('#gridRet').datagrid('loadData', rowsData);
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridInci').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phar = gridSel.rowID;

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Return',
            QueryName: 'PhaReturnInci',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
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
        dispCat: $('#conDispCat').combobox('getValue'),
        way: $('#conWay').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue'),
        wardLoc: $('#conWardLoc').combobox('getValue'),
        retNo: $('#conRetNo').val() || '',
        reqNo: $('#conReqNo').val() || '',
        patNo: $('#conPatNo').val() || ''
    };
}

function QueryDetailHandler() {
    $('#gridDetail').datagrid('loading');
    setTimeout(QueryDetail, 100);
}

function QueryDetail() {
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridDetail').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phar = gridSel.rowID;
    var sort = $('#gridRet').datagrid('options').sortName;
    var order = $('#gridRet').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Return',
            QueryName: 'PhaReturnDetail',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $('#gridDetail').datagrid('loadData', rowsData);
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
    $('#conWay').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conRetNo').val('');
    $('#conReqNo').val('');
    $('#conPatNo').val('');
    $('#gridRet').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridDetail').datagrid('clear');
    $('#PHA_UX_AdmDetail, #PHA_UX_TimeLine, #winRes').window('close');
}

function PrintHandler() {
    var gridSel = $('#gridRet').datagrid('getSelected') || '';
    if (gridSel === '') {
        PHA.Popover({
            msg: '请先选中需要打印的退药单',
            type: 'alert'
        });
        return;
    }
    $('#winSelectPrintWay').window('open');
    return;
    var currTab = $('#retTab').tabs('getSelected');
    var tabTitle = currTab.panel('options').title;
    var prnType = '';
    if (tabTitle == $g('退药明细')) prnType = 'detail';
    else if (tabTitle == $g('药品汇总')) prnType = 'total';
    PrintReturnCom(gridSel.rowID, '补', prnType);
}
