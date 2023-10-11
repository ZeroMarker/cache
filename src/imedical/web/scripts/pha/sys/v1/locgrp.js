/**
 * 名称:	 药房公共 - 科室组维护
 * 编写人:	 yunhaibao
 * 编写日期: 2020-10-30
 */
$g('关联');
$g('取消关联');
PHA_COM.App.Csp = 'pha.sys.v1.locgrp.csp';
PHA_COM.App.Name = 'SYS.LOCGRP';
PHA_COM.App.Load = '';
$(function () {
    InitDict();
    InitGridLocGrp();
    InitGridLocGrpItm();
    InitGridLoc();
    InitEvents();
});

// 事件
function InitEvents() {
    $('#btnAdd, #btnEdit').on('click', function () {
        ShowDiagLocGrp(this);
    });
    $('#btnFind').on('click', Query);
    $('#btnDel').on('click', Delete);
    $('#conNoGrp').checkbox('options').onCheckChange = QueryLoc;
    PHA.SearchBox('conAlias', {
        width: 210,
        searcher: QueryLoc,
        placeholder: '请输入别名回车查询...'
    });
}

// 字典
function InitDict() {
    // 初始化科室
    PHA.ComboBox('conUserLoc', {
        width: 200,
        url: PHA_STORE.UserLoc().url + '&UserId=' + session['LOGON.USERID'],
        onLoadSuccess: function () {
            if (PHA_COM.App.Load == '') {
                var datas = $('#conUserLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == session['LOGON.CTLOCID']) {
                        $('#conUserLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
            PHA_COM.App.Load = 1;
        },
        onSelect: function () {
            Query();
        }
    });
    PHA.ComboBox('loc', {
        width:207,
        url: PHA_STORE.UserLoc().url + '&UserId=' + session['LOGON.USERID']
    });
    // 初始化类型
    PHA.ComboBox('conAppType', {
        data: [
            {
                RowId: 'PIVASCOMMON',
                Description: $g('配液中心')
            },
            {
                RowId: 'IPCOMMON',
                Description: $g('住院药房')
            }
        ],
        panelHeight: 'auto'
    });
    PHA.ComboBox('appCode', {
        data: [
            {
                RowId: 'PIVASCOMMON',
                Description: $g('配液中心')
            },
            {
                RowId: 'IPCOMMON',
                Description: $g('住院药房')
            }
        ],
        panelHeight: 'auto'
    });
}

// 表格-科室组
function InitGridLocGrp() {
    var columns = [
        [
            {
                field: 'locGrp',
                title: '科室组Id',
                hidden: true,
                width: 100
            },
            {
                field: 'loc',
                title: '科室',
                width: 150,
                hidden: true
            },
            {
                field: 'locDesc',
                title: '科室',
                width: 150
            },
            {
                field: 'appCode',
                title: '类型代码',
                width: 150,
                hidden: true
            },
            {
                field: 'appDesc',
                title: '类型',
                width: 100,
                hidden: true
            },
            {
                field: 'locGrpCode',
                title: '代码',
                width: 150
            },
            {
                field: 'locGrpDesc',
                title: '名称',
                width: 150
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        toolbar: null,
        toolbar: '#gridLocGrpBar',
        enableDnd: false,
        fitColumns: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            QueryItm();
            QueryLoc();
        },
        onDblClickRow: function (rowIndex, rowData) {
            // $('#btnEdit').click();
        },
        onLoadSuccess: function () {
            $('#gridLocGrpItm').datagrid('clear');
            $('#gridLoc').datagrid('clear');
        }
    };

    PHA.Grid('gridLocGrp', dataGridOption);
}

// 表格-科室组明细
function InitGridLocGrpItm() {
    var columns = [
        [
            {
                field: 'locGrpItmID',
                title: 'locGrpItmID',
                hidden: true,
                width: 100
            },
            {
                field: 'operate',
                title: '操作',
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<img class="js-grid-no" title=' + $g('取消关联') + ' src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_no.png" style="border:0px;cursor:pointer">';
                }
            },
            {
                field: 'loc',
                title: '科室',
                hidden: true,
                width: 100
            },
            {
                field: 'locDesc',
                title: '科室',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: [],
        loadMsg: null,
        loadingMessage: null,
        onDblClickRow: function (rowIndex, rowData) {
            SaveLocGrpItm({
                loc: rowData.loc,
                locGrpItmID: rowData.locGrpItmID
            });
        }
    };
    PHA.Grid('gridLocGrpItm', dataGridOption);
    PHA.GridEvent('gridLocGrpItm', 'click', ['js-grid-no'], function (rowIndex, rowData, className) {
        SaveLocGrpItm({
            loc: rowData.loc,
            locGrpItmID: rowData.locGrpItmID
        });
    });
}
function InitGridLoc() {
    var columns = [
        [
            {
                field: 'loc',
                title: '科室Id',
                width: 150,
                hidden: true
            },
            {
                field: 'operate',
                title: '操作',
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<img class="js-grid-yes" title=' + $g('关联') + ' src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">';
                }
            },
            {
                field: 'locDesc',
                title: '科室',
                width: 175
            },
            {
                field: 'locGrpDescStr',
                title: '已属科室组'
                //width: $('#panelLoc').width() - 240
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        toolbar: '#gridLocBar',
        enableDnd: false,
        exportXls: false,
        loadMsg: null,
        loadingMessage: null,
        onDblClickRow: function (rowIndex, rowData) {
            SaveLocGrpItm({
                loc: rowData.loc
            });
        },
        rowStyler: function (index, rowData) {
            if (rowData.locGrpDescStr !== '') {
                return 'font-weight:bold';
            }
        }
    };

    PHA.Grid('gridLoc', dataGridOption);
    PHA.GridEvent('gridLoc', 'click', ['js-grid-yes'], function (rowIndex, rowData) {
        SaveLocGrpItm({
            loc: rowData.loc
        });
    });
}

function ShowDiagLocGrp(btnOpt) {
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var locGrp = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
        if (gridSelect == '') {
            PHA.Popover({
                msg: '请先选中需要修改的科室组',
                type: 'alert'
            });
            return;
        }
        locGrp = gridSelect.locGrp || '';
        if (locGrp == '') {
            PHA.Popover({
                msg: '请先保存正在修改的科室组',
                type: 'alert'
            });
            return;
        }
    }
    $('#diagLocGrp').dialog({
        title: '科室组' + btnOpt.text,
        iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
        modal: true
    });
    $('#diagLocGrp').dialog('open');
    $.data($('#diagLocGrp')[0], 'operateType', ifAdd ? 'add' : 'edit');
    if (ifAdd == false) {
        $('#diagLocGrp_btnAdd').hide();
        // 编辑时,调后台数据加载
        $.cm(
            {
                ClassName: 'PHA.SYS.LocGrp.Query',
                MethodName: 'SelectDHCStkLocGroup',
                locGrp: locGrp
            },
            function (jsonData) {
                PHA.SetVals([jsonData]);
            }
        );
    } else {
        var clearValueArr = ['loc', 'locGrpCode', 'locGrpDesc', 'appCode'];
        PHA.ClearVals(clearValueArr);
        var loc = $('#conUserLoc').combobox('getValue');
        if (loc !== '') {
            $('#loc').combobox('setValue', loc);
        }
    }
}
/**
 * @param {String} type 1(继续新增)
 */
function SaveLocGrp(type) {
    var title = $('#diagLocGrp').panel('options').title;
    var ifAdd = $.data($('#diagLocGrp')[0], 'operateType') === 'add' ? true : false;
    var locGrp = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridLocGrp').datagrid('getSelected');
        locGrp = gridSelect.locGrp || '';
    }

    var loc = $('#loc').combobox('getValue') || '';
    var code = $('#locGrpCode').val().trim();
    var desc = $('#locGrpDesc').val().trim();
    if (loc === '' || code === '' || desc === '') {
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.SYS.LocGrp.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify([
                {
                    locGrp: locGrp,
                    loc: loc,
                    code: code,
                    desc: desc
                }
            ])
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('提示', retJson.message, 'warning');
    } else {
        PHA.Popover({
            msg: '保存成功',
            type: 'success',
            timeout: 500
        });
    }
    if (type == 1) {
        PHA.ClearVals(['locGrpCode', 'locGrpDesc']);
        $('#locGrpCode').focus();
    } else {
        if (retJson.success !== 'N') {
            $('#diagLocGrp').dialog('close');
        }
    }
    $('#gridLocGrp').datagrid('reload');
}

function Query() {
    var loc = $('#conUserLoc').combobox('getValue') || '';
    if (loc === '') {
        PHA.Popover({
            msg: '请选择科室后查询',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        loc: loc,
        appCode: 'DHCSTCOMMON'
    };

    $('#gridLocGrp').datagrid('options').url = $URL;
    $('#gridLocGrp').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'DHCStkLocGroup',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

// 删除科室组
function Delete() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的科室组',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var locGrp = gridSelect.locGrp || '';

    PHA.Confirm('删除提示', '您确认删除吗', function () {
        var retJson = $.cm(
            {
                ClassName: 'PHA.COM.DataApi',
                MethodName: 'HandleInAll',
                pClassName: 'PHA.SYS.LocGrp.Save',
                pMethodName: 'Delete',
                pJsonStr: JSON.stringify([locGrp])
            },
            false
        );
        if (retJson.success === 'N') {
            PHA.Alert('提示', retJson.message, 'warning');
            return;
        } else {
            PHA.Popover({
                msg: '删除成功',
                type: 'success'
            });
            $('#gridLocGrp').datagrid('reload');
        }
    });
}

function SaveLocGrpItm(rowData) {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中科室组记录',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    var locGrpItmID = rowData.locGrpItmID || '';
    var loc = rowData.loc;

    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.SYS.LocGrp.Save',
            pMethodName: 'SaveItmHandler',
            pJsonStr: JSON.stringify([
                {
                    locGrp: locGrp,
                    locGrpItmID: locGrpItmID,
                    loc: loc
                }
            ])
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('提示', retJson.message, 'warning');
    } else {
        PHA.Popover({
            msg: (locGrpItmID !== '' ? '取消' : '') + '关联成功',
            type: 'success',
            timeout: 500
        });
    }
    $('#gridLoc').datagrid('reload');
    $('#gridLocGrpItm').datagrid('reload');
}

function QueryItm() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '请先选择左侧科室组',
            type: 'alert'
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    $('#gridLocGrpItm').datagrid('options').url = $URL;
    $('#gridLocGrpItm').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'DHCStkLocGrpItm',
        pJsonStr: JSON.stringify({ locGrp: locGrp }),
        rows: 9999
    });
}

function QueryLoc() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '请先选择左侧科室组',
            type: 'alert'
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    var alias = $('#conAlias').searchbox('getValue');
    var noGrp = $('#conNoGrp').checkbox('getValue') === true ? 'Y' : '';
    var pJson = {
        locGrp: locGrp,
        alias: alias,
        noGrp: noGrp
    };
    $('#gridLoc').datagrid('options').url = $URL;
    $('#gridLoc').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'LocData',
        pJsonStr: JSON.stringify(pJson),
        rows: 9999
    });
}
