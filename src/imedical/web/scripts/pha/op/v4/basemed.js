/**
 * 基数药维护
 * scripts/pha/op/v4/basemed.js
 * 2021-11-19 Huxt 修改
 */
var GridCmbInci = '';
var GridCmbInst = '';
var GridCmbDocLoc = '';
var GridCmbUseLoc = '';
var GridCmbExeLoc = '';
var PHA_OP_BASEMED = {
    Config: {}
};
$(function () {
    var settings = PHA.CM(
        {
            pClassName: 'PHA.OP.CfBase.Query',
            pMethodName: 'GetSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                logonHosp: session['LOGON.HOSPID']
            })
        },
        false
    );
    PHA_OP_BASEMED.Config = settings;
    InitHosp();
    InitDict();
    InitGridDict();
    InitEvent();
    InitBaseMedGrid();
    HelpInfo();
});
function InitDict() {
    PHA.ComboBox('conBaseType', {
        required: false,
        panelHeight: 'auto',
        multiple: true,
        rowStyle: 'checkbox',
        editable: false,
        data: [
            {
                RowId: 'O',
                Description: $g('门诊')
            },
            {
                RowId: 'I',
                Description: $g('住院')
            }
        ]
    });
    $('#conBaseType').combobox('setValues', ['O', 'I']);
    PHA.ComboBox('conMakeOrderBase', {
        required: false,
        panelHeight: 'auto',
        multiple: true,
        rowStyle: 'checkbox',
        editable: false,
        data: [
            {
                RowId: 'Y',
                Description: $g('是')
            },
            {
                RowId: 'N',
                Description: $g('否')
            }
        ]
    });
    $('#conMakeOrderBase').combobox('setValues', ['Y', 'N']);
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 272
    });
    PHA.LookUp('conInci', opts);
    // 开单科室
    PHA.ComboBox('conDocLoc', {
        tipPosition: 'top',
        url: PHAOP_STORE.CTLOC().url,
        defaultFilter: 5,
        mode: 'remote'
    });
    // 取药科室(原使用科室)
    PHA.ComboBox('conUseLoc', {
        tipPosition: 'top',
        url: PHAOP_STORE.CTLOC().url,
        defaultFilter: 5,
        mode: 'remote'
    });
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridBaseMed', idField: 'baseMedRowId', sqlTableName: 'DHC_PHBaseMedicine' });
}
function InitGridDict() {
    // 类型
    GridCmdType = PHA.EditGrid.ComboBox({
        required: true,
        width: 150,
        panelHeight: 'auto',
        data: [
            {
                RowId: 'O',
                Description: $g('门诊')
            },
            {
                RowId: 'I',
                Description: $g('住院')
            }
        ]
    });
    // 医嘱项
    var options = {
        panelWidth: '500',
        required: true,
        onSelect: function (index, rowData) {
            var gridSelect = $('#gridBaseMed').datagrid('getSelected');
            gridSelect.arcItmRowId = rowData.arcItmRowId;
        },
        onBeforeLoad: function (param) {
            if (param.q == undefined) {
                param.q = $('#gridBaseMed').datagrid('getSelected').arcItmDesc;
            }
            param.QText = param.q;
            param.HospId = PHA_COM.Session.HOSPID;
        }
    };
    options = $.extend({}, PHAOP_STORE.ArcItm(), options);
    GridCmbArc = PHA.EditGrid.ComboGrid(options);

    // 用法
    GridCmbInst = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
        width: 150,
        url: PHAOP_STORE.Instruction().url,
        defaultFilter: 5,
        mode: 'remote',
        onSelect: function (index, rowData) {
            var editIndex = $('#gridBaseMed').datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var instId = $(this).combobox('getValue'); //当前combobox的值
            if (instId == '' || instId == null) {
                return;
            }
            var gridSelect = $('#gridBaseMed').datagrid('getSelected');
            gridSelect.instRowId = instId;
        },
        onBeforeLoad: function (param) {
            if (param.q == undefined) {
                param.q = $('#gridBaseMed').datagrid('getSelected').instDesc;
            }
            param.QText = param.q;
            param.HospId = PHA_COM.Session.HOSPID;
        }
    });

    // 开单科室
    GridCmbDocLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHAOP_STORE.CTLOC().url,
        defaultFilter: 5,
        mode: 'remote',
        onSelect: function (index, rowData) {
            var editIndex = $('#gridBaseMed').datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var docLocRowId = $(this).combobox('getValue'); //当前combobox的值
            if (docLocRowId == '' || docLocRowId == null) {
                return;
            }
            var gridSelect = $('#gridBaseMed').datagrid('getSelected');
            gridSelect.docLocRowId = docLocRowId;
        },
        onBeforeLoad: function (param) {
            if (param.q == undefined) {
                param.q = $('#gridBaseMed').datagrid('getSelected').docLocDesc;
            }
            param.QText = param.q;
            param.HospId = PHA_COM.Session.HOSPID;
        }
    });
    // 取药科室(原使用科室)
    GridCmbUseLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHAOP_STORE.CTLOC().url,
        defaultFilter: 5,
        mode: 'remote',
        onSelect: function (index, rowData) {
            var editIndex = $('#gridBaseMed').datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var useLocRowId = $(this).combobox('getValue'); //当前combobox的值
            if (useLocRowId == '' || useLocRowId == null) {
                return;
            }
            var gridSelect = $('#gridBaseMed').datagrid('getSelected');
            gridSelect.useLocRowId = useLocRowId;
        },
        onBeforeLoad: function (param) {
            if (param.q == undefined) {
                param.q = $('#gridBaseMed').datagrid('getSelected').useLocDesc;
            }
            param.QText = param.q;
            param.HospId = PHA_COM.Session.HOSPID;
        }
    });
    // 使用科室/执行科室
    GridCmbExeLoc = PHA.EditGrid.ComboBox({
        required: false,
        tipPosition: 'top',
        url: PHAOP_STORE.CTLOC().url,
        defaultFilter: 5,
        mode: 'remote',
        onSelect: function (index, rowData) {
            var editIndex = $('#gridBaseMed').datagrid('options').editIndex;
            if (editIndex == undefined) {
                return;
            }
            var exeLocRowId = $(this).combobox('getValue'); //当前combobox的值
            if (exeLocRowId == '' || exeLocRowId == null) {
                return;
            }
            var gridSelect = $('#gridBaseMed').datagrid('getSelected');
            gridSelect.exeLocRowId = exeLocRowId;
        },
        onBeforeLoad: function (param) {
            if (param.q == undefined) {
                param.q = $('#gridBaseMed').datagrid('getSelected').exeLocDesc;
            }
            param.QText = param.q;
            param.HospId = PHA_COM.Session.HOSPID;
        }
    });
}

function InitEvent() {
    //基数药维护
    $('#btnFind').on('click', Query);
    $('#btnAdd').on('click', function () {
        $('#gridBaseMed').datagrid('addNewRow', {
            editField: 'baseMedType',
            defaultRow: {
                makeOrderBaseFlag: PHA_OP_BASEMED.Config.baseMedManagementMode === '1' ? 'N' : 'Y'
            }
        });
    });
    $('#btnSave').on('click', SaveBaseMed);
    $('#btnDelete').on('click', DelBaseMed);
    $('#btnClear').on('click', ClearConditions);
}

function InitBaseMedGrid() {
    var columns = [
        [
            {
                field: 'baseMedRowId',
                title: '门诊药房id',
                hidden: true,
                width: 100
            },
            {
                field: 'baseMedType',
                title: '类型',
                descField: 'baseMedTypeDesc',
                width: 80,
                sortable: true,
                editor: GridCmdType,
                formatter: function (value, row, index) {
                    return row.baseMedTypeDesc;
                }
            },
            {
                field: 'baseMedTypeDesc',
                title: '类型',
                width: 150,
                hidden: true
            },
            {
                field: 'arcItmDesc',
                title: '药品名称',
                descField: 'arcItmDesc',
                width: 250,
                editor: GridCmbArc,
                sortable: true,
                formatter: function (value, row, index) {
                    return row.arcItmDesc;
                }
            },
            {
                field: 'arcItmRowId',
                title: '药品名称',
                hidden: true,
                width: 250
            },
            {
                field: 'instDesc',
                title: '用法',
                descField: 'instDesc',
                width: 150,
                editor: GridCmbInst,
                formatter: function (value, row, index) {
                    return row.instDesc;
                }
            },
            {
                field: 'instRowId',
                title: '用法描述id',
                hidden: true,
                width: 150
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                descField: 'docLocDesc',
                width: 200,
                sortable: true,
                editor: GridCmbDocLoc,
                formatter: function (value, row, index) {
                    return row.docLocDesc;
                }
            },
            {
                field: 'docLocRowId',
                title: '开单科室id',
                hidden: true,
                width: 200
            },
            {
                field: 'useLocDesc',
                title: '取药科室',
                descField: 'useLocDesc',
                width: 200,
                editor: GridCmbUseLoc,
                formatter: function (value, row, index) {
                    return row.useLocDesc;
                }
            },
            {
                field: 'useLocRowId',
                title: '取药科室Id',
                hidden: true,
                width: 200
            },
            {
                field: 'makeOrderBaseFlag',
                title: '开单置基数药标识',
                align: 'center',
                formatter: function (value, row, index) {
                    if (value === 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                },
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N',
                        disabled: PHA_OP_BASEMED.Config.baseMedManagementMode == 1 ? false : true
                    }
                }
            },
            {
                field: 'exeLocDesc',
                title: '使用科室',
                descField: 'exeLocDesc',
                width: 200,
                editor: GridCmbExeLoc,
                formatter: function (value, row, index) {
                    return row.exeLocDesc;
                }
            },
            {
                field: 'exeLocRowId',
                title: '使用科室Id',
                hidden: true,
                width: 200
            },
            {
                field: 'remarks',
                title: '备注',
                width: 200,
                editor: {
                    type: 'validatebox'
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.OP.CfBase.Query',
            QueryName: 'QueryLocBaseMed',
            pJsonStr: JSON.stringify({
                hospId: PHA_COM.Session.HOSPID
            }),
            rows: 999
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridBaseMedGridBar',
        enableDnd: false,
        fitColumns: false,
        rownumbers: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'arcItmDesc'
                });
            }
        },
        onLoadSuccess: function (data) {}
    };
    PHA.Grid('gridBaseMed', dataGridOption);
}
function InitHosp() {
    var hospComp = GenHospComp('DHC_PHBaseMedicine', '', {
        width: 280
    });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        Query();
        InitDict();
        $('#conInci').lookup('clear');
    };
}
function Query() {
    var pJson = {};
    pJson.hospId = PHA_COM.Session.HOSPID;
    pJson.baseMedType = $('#conBaseType').combobox('getValues').join(',');
    pJson.DocLocId = $('#conDocLoc').combobox('getValue');
    pJson.UseLocId = $('#conUseLoc').combobox('getValue');
    pJson.InciDr = $('#conInci').lookup('getValue') || '';
    pJson.makeOrderBase = $('#conMakeOrderBase').combobox('getValues').join(',');

    $('#gridBaseMed').datagrid('query', {
        pJsonStr: JSON.stringify(pJson)
    });
}
function SaveBaseMed() {
    var $grid = $('#gridBaseMed');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var dataArr = [];
    var gridChanges = $grid.datagrid('getChanges', 'updated');
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var docLocRowId = rowData.docLocRowId || '';
        var useLocRowId = rowData.useLocRowId || '';
        if (docLocRowId == '' || useLocRowId == '') {
            continue;
        }
        var instRowId = rowData.instRowId || '';
        var instDesc = rowData.instDesc || '';
        if (instDesc == '') {
            instRowId = '';
        }
        var exeLocRowId = rowData.exeLocRowId || '';

        var iJson = {
            baseMedRowId: rowData.baseMedRowId || '',
            baseMedType: rowData.baseMedType || '',
            arcItmRowId: rowData.arcItmRowId || '',
            instRowId: instRowId,
            docLocRowId: docLocRowId,
            useLocRowId: useLocRowId,
            remarks: rowData.remarks || '',
            exeLocRowId: exeLocRowId,
            makeOrderBaseFlag: rowData.makeOrderBaseFlag
        };
        dataArr.push(iJson);
    }
    var gridChanges = $grid.datagrid('getChanges', 'inserted');
    var gridChangeLen = gridChanges.length;
    for (var i = 0; i < gridChangeLen; i++) {
        var rowData = gridChanges[i];
        var docLocRowId = rowData.docLocRowId || '';
        var useLocRowId = rowData.useLocRowId || '';
        if (docLocRowId == '' || useLocRowId == '') {
            continue;
        }
        var instRowId = rowData.instRowId || '';
        var instDesc = rowData.instDesc || '';
        if (instDesc == '') {
            instRowId = '';
        }
        var exeLocRowId = rowData.exeLocRowId || '';

        var iJson = {
            baseMedRowId: rowData.baseMedRowId || '',
            baseMedType: rowData.baseMedType || '',
            arcItmRowId: rowData.arcItmRowId || '',
            instRowId: instRowId,
            docLocRowId: docLocRowId,
            useLocRowId: useLocRowId,
            remarks: rowData.remarks || '',
            exeLocRowId: exeLocRowId,
            makeOrderBaseFlag: rowData.makeOrderBaseFlag
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.OP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.OP.CfBase.OperTab',
            pMethodName: 'SaveBaseMed',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );

    if (retJson.success === 'N') {
        msg = PHAOP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
    }
    $grid.datagrid('reload');
}
function DelBaseMed() {
    var gridSelect = $('#gridBaseMed').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    PHAOP_COM._Confirm('', $g('您确定删除当前的基数药记录吗') + '<br/>' + $g('点击[确定]将继续删除，点击[取消]将放弃删除操作。'), function (r) {
        if (r == true) {
            var baseMedRowId = gridSelect.baseMedRowId || '';
            if (baseMedRowId !== '') {
                var arcItmDesc = gridSelect.arcItmDesc || '';
                var dataArr = [];
                var iJson = {
                    baseMedRowId: baseMedRowId,
                    arcItmDesc: arcItmDesc
                };
                dataArr.push(iJson);
                var retJson = $.cm(
                    {
                        ClassName: 'PHA.OP.Data.Api',
                        MethodName: 'HandleInOne',
                        pClassName: 'PHA.OP.CfBase.OperTab',
                        pMethodName: 'DelPhBaseMed',
                        pJsonStr: JSON.stringify(dataArr)
                    },
                    false
                );
                if (retJson.success === 'N') {
                    msg = PHAOP_COM.DataApi.Msg(retJson);
                    PHA.Alert('提示', msg, 'warning');
                    return;
                }
            }
            PHA.Popover({
                msg: '删除成功',
                type: 'success'
            });
            var rowIndex = $('#gridBaseMed').datagrid('getRowIndex', gridSelect);
            $('#gridBaseMed').datagrid('deleteRow', rowIndex);
        }
    });
}

function HelpInfo() {
    $('#btnHelp').popover({
        title: '基数药维护解释',
        trigger: 'hover',
        padding: '10px',
        width: 650,
        content:
            '<div>' +
            $g('基数药：药品在取药科室，发药在药房；取药科室定期补货。') +
            '<br>' +
            '<p class="pha-row">&emsp;&emsp;&emsp;&emsp;' +
            $g('需满足已维护条件才可以，类型、药品、开单科室、取药科室必填') +
            '</p >' +
            '<div class="pha-row pha-line" ><a style="color:red">' +
            $g('名词解释') +
            '：</a></div>' +
            '&emsp;&emsp;' +
            $g('类型：住院--开单科室开立的药品在执行医嘱(医技)界面可以被取药科室查看并执行') +
            '<br>' +
            '<p class="pha-row">&emsp;&emsp;' +
            $g('类型：门诊--下医嘱时开单科室在记录中存在则视为基数药，药房发药时向对应取药科室补货') +
            '</p >' +
            '</div>'
    });
}

function ClearConditions() {
    $('#conBaseType').combobox('setValue', '');
    $('#conDocLoc').combobox('setValue', '');
    $('#conUseLoc').combobox('setValue', '');
    $('#conInci').lookup('clear');
    InitHosp();
    PHA_COM.Session.HOSPID = session['LOGON.HOSPID'];
    InitDict();
    Query();
}
