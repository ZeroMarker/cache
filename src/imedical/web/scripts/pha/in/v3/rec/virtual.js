/**
 * 入库 - 虚拟入库
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            handleStatus: '',
            defaultData: [{}]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = REC_COMPONENTS();
    var com = REC_COM;
    var settings = com.GetSettings();
    PHA_UX.ComboGrid.INCItm('inci', {
        width: 300,
        onHidePanel: function () {
            $('#btnFindInclb').trigger('click-i');
        }
    });

    components('Loc', 'loc', {
        onChange: function () {
            $('#gridInclb, #gridVirtual').datagrid('clearChecked').datagrid('clear');
        }
    });
    components('Vendor', 'vendor', {
        width: 300
    });

    InitGridInclb();
    InitGridVirtual();

    PHA_EVENT.Bind('#btnFindInclb', 'click', function () {
        var inci = $('#inci').combogrid('getValue');
        var loc = $('#loc').combobox('getValue');
        var inclbArr = [];
        for (const it of $('#gridVirtual').datagrid('getRows')) {
            inclbArr.push(it.inclb);
        }
        com.LoadData('gridInclb', {
            pJson: JSON.stringify({ inci: inci, loc: loc, inclbStr: inclbArr.join(',') }),
            pMethodName: 'GetInclbRows4Virtual'
        });
    });
    PHA_EVENT.Bind('#btnAdd', 'click', function () {
        var $gridInclb = $('#gridInclb');
        var checkedRows = $gridInclb.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '请先勾选需要加入的记录');
            return;
        }
        for (const checkedRow of checkedRows) {
            $('#gridVirtual').datagrid('appendRow', checkedRow);
        }

        var rows = $gridInclb.datagrid('getRows');
        for (const chkit of checkedRows) {
            var rowIndex = rows.indexOf(chkit);
            $gridInclb.datagrid('deleteRow', rowIndex);
        }
        components('Pop', '加入成功');
        $('#btnFindInclb').trigger('click-i');
    });
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        var $grid = $('#gridVirtual');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '请先勾选需要删除的记录');
            return;
        }
        var rows = $grid.datagrid('getRows');
        for (const chkit of checkedRows) {
            var rowIndex = rows.indexOf(chkit);
            $grid.datagrid('deleteRow', rowIndex);
        }
        components('Pop', '删除成功');
        $('#btnFindInclb').trigger('click-i');
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        PHA_GridEditor.End('gridVirtual');

        var vendor = $('#vendor').combobox('getValue');
        if (vendor === '') {
            components('Pop', '请先选择经营企业');
            return;
        }
        var rows = [];
        for (const it of $('#gridVirtual').datagrid('getRows')) {
            var rowData = $.extend({}, it);
            var inputQty = rowData.inputQty || '';
            if (ValidateNumber(inputQty) !== true) {
                continue;
            }
            rows.push({
                recItmID: '',
                inci: rowData.inci,
                inclb: rowData.inclb,
                batNo: rowData.batNo,
                expDate: rowData.expDate,
                manf: rowData.manf,
                uom: rowData.uom,
                qty: rowData.inputQty,
                rp: rowData.rp,
                sp: rowData.sp
            });
        }
        if (rows.length === 0) {
            components('Pop', '没有可保存的数据, 请核实是否正确输入数量等信息');
            return;
        }

        var data4save = {
            main: {
                recID: '',
                loc: $('#loc').combobox('getValue'),
                createUser: session['LOGON.CTLOCID'],
                stkCatGrp: '',
                vendor: vendor
            },
            rows: rows
        };
        com.Invoke(com.Fmt2ApiMethod('Save4Virtual'), data4save, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '保存成功');
                var forRows = $.extend([],$('#gridVirtual').datagrid('getRows'));
                // var checkedRows = $('#gridVirtual').datagrid('getChecked');
                var origRows = $.extend([],$('#gridVirtual').datagrid('getRows'));
                // 倒序删其实就没问题了
                for (const itorig of forRows) {
                    if (ValidateNumber(itorig.inputQty || '') === true) {
                        const rowIndex = origRows.indexOf(itorig);
                        $('#gridVirtual').datagrid('deleteRow', rowIndex);
                        origRows.splice(rowIndex,1)
                    }
                }
            }
        });
    });
    function ValidateNumber(num, type) {
        if (num === '') {
            return '数字为空';
        }
        if (isNaN(num)) {
            return '不为数字';
        }

        return true;
    }

    function GetColumns() {
        var columns = [
            [
                { field: 'gCheck', checkbox: true },
                {
                    field: 'inclb',
                    title: 'inclb',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 300,
                    sortable: true
                },
                {
                    field: 'inputQty',
                    title: '入库数量',
                    width: 100,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            return true;
                        }
                    })
                },

                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'batNo',
                    title: '批号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'expDate',
                    title: '效期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'rp',
                    title: '进价',
                    width: 75,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            return true;
                        },
                        onBeforeNext: function (val, gridRowData, gridRowIndex) {
                            var rp = val * 1;
                            var qty = gridRowData.qty * 1;
                            gridRowData.rpAmt = _.multiply(qty, rp);
                        }
                    })
                },
                {
                    field: 'sp',
                    title: '售价',
                    width: 75,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            return true;
                        }
                    })
                },
                {
                    field: 'manf',
                    title: '生产企业',
                    width: 150,
                    sortable: true,
                    descField: 'manfDesc',
                    formatter: function (value, row, index) {
                        return row.manfDesc;
                    },
                    editor: PHA_GridEditor.ComboBox({
                        required: false,
                        tipPosition: 'top',
                        panelWidth: 'auto',
                        loadRemote: true,
                        url: PHA_STORE.PHManufacturer().url,
                        onBeforeLoad: function (param) {},
                        onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {}
                    })
                },
                {
                    field: 'qty',
                    title: '库存',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'loc',
                    title: 'loc',
                    width: 100,
                    sortable: true,
                    hidden:true
                }
            ]
        ];
        return columns;
    }
    function GetCommonGridOptions(target, options) {
        var dataGridOption = {
            url: '',
            exportXls: false,
            pagination: false,
            columns: GetColumns(),
            toolbar: '#gridInclbBar',
            singleSelect: false,
            rownumber: true,
            pageNumber: 1,
            pageSize: 10000,
            pagination: false,
            onLoadSuccess: function () {
                $(this).datagrid('clearChecked');
                PHA_GridEditor.End($(this)[0].id);
            },
            onClickCell: function (index, field, value) {
                PHA_GridEditor.Edit({
                    gridID: $(this)[0].id,
                    index: index,
                    field: field,
                    forceEnd: true
                });
            }
        };
        return dataGridOption;
    }
    function InitGridInclb() {
        var comOptions = GetCommonGridOptions();
        comOptions.toolbar = '#gridInclbBar';
        PHA.Grid('gridInclb', comOptions);
    }

    function InitGridVirtual() {
        var comOptions = GetCommonGridOptions();
        comOptions.toolbar = '#gridVirtualBar';
        PHA.Grid('gridVirtual', comOptions);
    }

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        SetDefaults();
        PHA_EVENT.Key([
            ['btnFindInclb', 'alt+f'],
            ['btnFindInclb', 'ctrl+enter']
        ]);
        PHA_COM.ResizePanel({
            layoutId: 'layout-rec-virtual',
            region: 'north',
            height: 0.5
        });
    }, 0);
});
