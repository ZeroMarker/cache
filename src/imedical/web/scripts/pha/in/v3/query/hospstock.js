/**
 * 名称:   全院库存查询
 * 编写人:  pushuangcai
 * 编写日期: 2022-03-07
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v3.query.hospstock.csp';
PHA_COM.App.Name = $g('全院库存查询');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
    hospId: session['LOGON.HOSPID'],
    groupId: session['LOGON.GROUPID'],
    userId: session['LOGON.USERID'],
    locId: session['LOGON.CTLOCID']
};
var ParamProp = PHA_COM.ParamProp(PHA_COM.App.AppName);

$(function () {
    InitComponent(); // 页面组件
    QUE_FORM.InitComponents(); // 公共组件 component.js
    InitEvents();

    InitGridIncItmLoc();
    InitGridIncItm();
    InitGridIncib();
    InitDefVal();
    PHA_COM.SetPanel('#tabMain', $g('全院库存查询'));

    InitInclbWin(); // 初始化弹窗 InclbWindow.js
    AddMoreConditon();
});

function Query() {
    var formData = QUE_FORM.GetFormData();
    if (formData === null) {
        return;
    }
    formData.hosp = PHA_COM.VAR.hospId;
    var btKwArr = $('#btFilterKw').keywords('getSelected');
    for (var i = 0; i < btKwArr.length; i++) {
        formData[btKwArr[i].id] = true;
    }

    var $selTabs = $('#mainTabs').tabs('getSelected');
    var selIndex = $('#mainTabs').tabs('getTabIndex', $selTabs);
    if (selIndex === 0) {
        $('#gridIncItmLoc').datagrid('options').url = PHA.$URL;
        $('#gridIncItmLoc').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    } else if (selIndex === 1) {
        $('#gridIncItm').datagrid('options').url = PHA.$URL;
        $('#gridIncItm').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    } else if (selIndex === 2) {
        $('#gridIncib').datagrid('options').url = PHA.$URL;
        $('#gridIncib').datagrid('query', {
            pJsonStr: JSON.stringify(formData)
        });
    }
}

/**
 * 清屏
 */
function Clear() {
    QUE_FORM.ClearFormData();
    $('#gridIncItmLoc').datagrid('clear');
    $('#gridIncItm').datagrid('clear');
    $('#gridIncib').datagrid('clear');
    $('#gridIncLocBat').datagrid('clear');
    InitDefVal();
}

/**
 * 绑定按钮事件
 */
function InitEvents() {
    PHA_EVENT.Bind('#btnFind', 'click', Query);
    PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

/**
 * 初始化界面组件
 */
function InitComponent() {
    $('#btFilterKw').keywords({
        onClick: function (v) {
            Query();
        },
        singleSelect: false,
        items: [{ text: '过滤无库存批次', id: 'NotEmptyFlag', selected: true }]
    });
}

function InitDefVal() {
    $('#date').datebox('setValue', PHA_UTIL.SysDate('t'));
    PHA.SetComboVal('scg', '');
}

/**
 * 科室库存项表格，点击库存列弹出科室库存批次窗口，按批次汇总
 */
function InitGridIncItmLoc() {
    var frozenColumns = [
        [
            {
                field: 'inciCode',
                title: '药品代码',
                width: 100,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 200,
                hidden: true
            },
            {
                field: 'spec',
                title: '规格',
                width: 100,
                hidden: true
            },
            {
                field: 'locID',
                title: '科室id',
                width: 100,
                hidden: true
            },
            {
                field: 'locDesc',
                title: '科室',
                width: 200,
                hidden: false,
                align: 'center'
            }
        ]
    ];

    var columns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'incil',
                title: 'incil',
                width: 100,
                hidden: true
            },
            {
                field: 'qtyWithUom',
                title: '库存',
                width: 150,
                hidden: true,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'pQty',
                title: '库存(入库)',
                width: 120,
                hidden: false,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'pUomDesc',
                title: '入库单位',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '库存(基本)',
                width: 120,
                hidden: false,
                align: 'right',
                formatter: gridIncItmLocQtyFormatter
            },
            {
                field: 'bUomDesc',
                title: '基本单位',
                width: 80,
                hidden: false
            },
            {
                field: 'avaQtyWithUom',
                title: '可用库存',
                width: 150,
                hidden: false,
                align: 'right'
            },
            {
                title: '进价(入库)',
                field: 'TPRp',
                width: 90,
                align: 'right'
            },
            {
                title: '售价(入库)',
                field: 'TPSp',
                width: 90,
                align: 'right'
            },
            {
                title: '进价(基本)',
                field: 'TBRp',
                width: 90,
                align: 'right'
            },
            {
                title: '售价(基本)',
                field: 'TBSp',
                width: 90,
                align: 'right'
            },
            {
                title: '进价金额',
                field: 'TRpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '售价金额',
                field: 'TSpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '货位',
                field: 'stkBin',
                width: 100
            },
            {
                title: '不可用',
                field: 'notUseFlag',
                width: 70,
                align: 'center',
                formatter: QUE_COM.Grid.Formatter.YesOrNo()
            },
            {
                title: '国家医保编码',
                field: 'insuCode',
                width: 100
            },
            {
                title: '国家医保名称',
                field: 'insuName',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'LocItmStkAll'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        frozenColumns: frozenColumns,
        showFooter: true,
        pagination: true,
        singleSelect: true,
        pageList: [10, 30, 50, 100],
        pageSize: 10,
        groupField: 'inci',
        view: groupview,
        groupFormatter: function (value, rows) {
            return (
                '' +
                rows[0].inciDesc +
                '</b>' +
                '<font style="font-weight:100;">&ensp; | &ensp;' +
                $g('代码') +
                '：' +
                rows[0].inciCode +
                '&ensp;|&ensp;' +
                $g('规格') +
                '：' +
                rows[0].inciSpec +
                '&ensp;|&ensp;' +
                $g('处方通用名') +
                '：' +
                rows[0].geneName +
                '&ensp;|&ensp;' +
                $g('剂型') +
                '：' +
                rows[0].phcFormDesc +
                '</font>'
            );
        }
    };
    PHA.Grid('gridIncItmLoc', dataGridOption);
    QUE_COM.ComGridEvent('gridIncItmLoc');
}

/**
 * 库存项表格，按库存项汇总全院库存
 */
function InitGridIncItm() {
    var frozenColumns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '药品代码',
                width: 100,
                hidden: false,
                formatter: QUE_COM.Grid.Formatter.InciCode()
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 300,
                hidden: false
            },
            {
                field: 'inciSpec',
                title: '规格',
                width: 100,
                hidden: false
            }
        ]
    ];
    var columns = [
        [
            {
                field: 'hospStkUom',
                title: '库存',
                width: 150,
                hidden: true,
                align: 'right'
            },
            {
                field: 'pQty',
                title: '库存(入库)',
                width: 100,
                hidden: false,
                align: 'right'
            },
            {
                field: 'pUomDesc',
                title: '入库单位',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '库存(基本)',
                width: 100,
                hidden: false,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '基本单位',
                width: 80,
                hidden: false
            },
            {
                field: 'geneName',
                title: '处方通用名',
                width: 150,
                hidden: false
            },
            {
                field: 'insuCode',
                title: '医保代码',
                width: 100,
                hidden: false
            },
            {
                field: 'insuName',
                title: '医保名称',
                width: 100,
                hidden: false
            },
            {
                field: 'phcFormDesc',
                title: '剂型',
                width: 80,
                hidden: false
            },
            {
                field: 'manfName',
                title: '生产企业(最近一次)',
                width: 300,
                hidden: false
            },
            {
                field: 'vendor',
                title: '经营企业(最近一次)',
                width: 300,
                hidden: false
            }
        ]
    ];
    var dataGridOption = {
        url: '', //$URL,
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'IncItmStk'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: true,
        fixRowNumber: true,
        frozenColumns: frozenColumns,
        columns: columns,
        showFooter: false,
        pagination: true,
        singleSelect: true
    };
    PHA.Grid('gridIncItm', dataGridOption);
    QUE_COM.ComGridEvent('gridIncItm');
}

/**
 * 批次表格，点击库存列弹出科室库存批次窗口，按科室汇总
 */
function InitGridIncib() {
    var frozenColumns = [
        [
            {
                field: 'inci',
                title: 'inci',
                width: 100,
                hidden: true
            },
            {
                field: 'incib',
                title: 'incib',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '药品代码',
                width: 100,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 200,
                hidden: true
            },
            {
                field: 'spec',
                title: '规格',
                width: 100,
                hidden: true
            },
            {
                field: 'batNo',
                title: '批号',
                align: 'center',
                width: 150
            }
        ]
    ];
    var columns = [
        [
            {
                field: 'expDate',
                title: '效期',
                align: 'center',
                width: 100,
                styler: QUE_COM.Grid.Styler.ExpDate,
                formatter: QUE_COM.Grid.Formatter.ExpDate()
            },
            {
                field: 'qtyWithUom',
                title: '库存',
                width: 150,
                hidden: true,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'pQty',
                title: '库存(入库单位)',
                width: 100,
                hidden: false,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'pUomDesc',
                title: '入库单位',
                width: 80,
                hidden: false
            },
            {
                field: 'bQty',
                title: '库存(基本单位)',
                width: 100,
                hidden: false,
                align: 'right',
                formatter: gridIncibQtyFormatter
            },
            {
                field: 'bUomDesc',
                title: '基本单位',
                width: 80,
                hidden: false
            },
            {
                field: 'geneName',
                title: '处方通用名',
                width: 150,
                hidden: true
            },
            {
                field: 'insuCode',
                title: '医保代码',
                width: 100,
                hidden: true
            },
            {
                field: 'insuName',
                title: '医保名称',
                width: 100,
                hidden: true
            },
            {
                field: 'phcFormDesc',
                title: '剂型',
                width: 80,
                hidden: true
            },
            {
                field: 'TBRp',
                title: '进价(基本)',
                align: 'right',
                width: 100
            },
            {
                field: 'TBSp',
                title: '售价(基本)',
                align: 'right',
                width: 100
            },
            {
                field: 'TPRp',
                title: '进价(入库)',
                align: 'right',
                width: 100
            },
            {
                field: 'TPSp',
                title: '售价(入库)',
                align: 'right',
                width: 100
            },
            {
                title: '进价金额',
                field: 'TRpAmt',
                width: 150,
                align: 'right'
            },
            {
                title: '售价金额',
                field: 'TSpAmt',
                width: 150,
                align: 'right'
            },
            {
                field: 'manfName',
                title: '生产企业',
                width: 220,
                hidden: false
            },
            {
                field: 'vendor',
                title: '经营企业',
                width: 220,
                hidden: false
            }
        ]
    ];
    var dataGridOption = {
        url: '', //$URL,
        queryParams: {
            pClassName: 'PHA.IN.Query.Api',
            pMethodName: 'IncItmBatStk'
        },
        iconCls: 'icon-paper',
        headerCls: 'panel-header-gray',
        bodyCls: 'panel-body-gray',
        exportXls: false,
        fitColumns: false,
        border: false,
        rownumbers: false,
        fixRowNumber: true,
        showFooter: true,
        columns: columns,
        frozenColumns: frozenColumns,
        pagination: true,
        singleSelect: true,
        pageList: [10, 30, 50, 100],
        pageSize: 10,
        groupField: 'inci',
        view: groupview,
        groupFormatter: function (value, rows) {
            return (
                '' +
                rows[0].inciDesc +
                '</b>' +
                '<font style="font-weight:100;">&ensp; | &ensp;' +
                $g('代码') +
                '：' +
                rows[0].inciCode +
                '&ensp;|&ensp;' +
                $g('规格') +
                '：' +
                rows[0].inciSpec +
                '&ensp;|&ensp;' +
                $g('处方通用名') +
                '：' +
                rows[0].geneName +
                '&ensp;|&ensp;' +
                $g('剂型') +
                '：' +
                rows[0].phcFormDesc +
                '</font>'
            );
        }
    };
    PHA.Grid('gridIncib', dataGridOption);
    QUE_COM.ComGridEvent('gridIncib');
}

/**
 * 格式化全院药品批次库存库存数量列
 */
function gridIncibQtyFormatter(value, rowData, rowIndex) {
    if (typeof value === 'undefined' || value === '') {
        return '';
    }
    if ((value === 0)||(!rowData.incib)) {
        return value;
    }
    var retValue = '<a title="' + $g('点击查看科室批次') + '" onclick="GetLcbtDetail(\'gridIncib\')"';
    retValue += 'class="pha-grid-a js-grid-pQty">' + value + '</a>';
    return retValue;
}

/**
 * 格式化全院科室库存库存数量列
 */
function gridIncItmLocQtyFormatter(value, rowData, rowIndex) {
    if (typeof value === 'undefined' || value === '') {
        return '';
    }
    if ((value === 0)||(!rowData.incil)) {
        return value;
    }

    var retValue = '<a title="' + $g('点击查看科室批次') + '" onclick="GetLcbtDetail(\'gridIncItmLoc\')"';
    retValue += 'class="pha-grid-a js-grid-pQty">' + value + '</a>';
    return retValue;
}

/**
 * 列点击事件（因为分组之后PHA.GridEvent不可用）。
 */
function GetLcbtDetail(gridId) {
    var $target = $(event.target);
    var className = $target.attr('class');
    if (className === 'pha-grid-a js-grid-pQty') {
        var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
        if (rowIndex) {
            var rowData = $('#' + gridId).datagrid('getRows')[rowIndex];
            if (gridId === 'gridIncib') {
                var wOpts = {
                    title: rowData.inciDesc + '【' + rowData.batNo + '】',
                    incib: rowData.incib,
                    queryBy: 'Bat'
                };
            } else {
                var wOpts = {
                    title: rowData.inciDesc + '【' + rowData.locDesc + '】',
                    incil: rowData.incil,
                    queryBy: 'Loc'
                };
            }
            OpenInclbWindow(wOpts);
        }
    }
}

function AddMoreConditon() {
    var $tr = $('#hospstock-morecon table tbody');
    $('#con-form-toggle tbody').append($tr.html());
    $tr.remove();
    PHA.ComboBox('mainLoc', {
        placeholder: '科室...',
        url: PHA_STORE.CTLoc().url,
        onHidePanel: function () {
            $('#subLoc').combobox('reload');
        }
    });
    PHA.ComboBox('subLoc', {
        placeholder: '子科室...',
        multiple: true,
        rowStyle: 'checkbox',
        mode: 'remote',
        hoverShow: true,
        url: PHA_STORE.BaseDrugLoc().url,
        onBeforeLoad: function (param) {
            try {
                param.QText = param.q;
                param.MainLocID = $('#mainLoc').combobox('getValue');
            } catch (e) {}
        }
    });
    $('#onlySubLocFlag').checkbox({
        label: '仅查询子科室'
    });
    //PHA.CheckBox('onlySubLocFlag',{})
}
