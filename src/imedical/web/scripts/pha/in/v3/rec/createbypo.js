/**
 * 入库 - 制单 - 依据订单
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID'],
                    poRecStatus: ['0']
                }
            ]
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

    components('Loc', 'loc');
    components('Loc', 'reqLoc', { onLoadSuccess: function () {} });
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Vendor', 'vendor');
    components('PORecStatus', 'poRecStatus');
    InitGridMain();
    InitGridItm();

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        if (qJson === undefined) {
            return;
        }
        com.LoadData('gridMain', {
            pJson: JSON.stringify(qJson),
            pMethodName: 'GetPOMainDataRows'
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        $('#gridItm').datagrid('clear');
        SetDefaults();
    });

    PHA_EVENT.Bind('#btnCopyGo', 'click', function () {
        CopyGo();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        Save();
    });
    function Save() {
        if (!PHA_GridEditor.End('gridItm')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        com.Invoke(com.Fmt2ApiMethod('Save4PO'), data4save, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.Top.Set('recID', retData.data);
                // window.location.href = 'pha.in.v3.plan.create.csp';
                PHA_COM.GotoMenu({
                    title: '入库制单',
                    url: 'pha.in.v3.rec.create.csp'
                });
            }
        });
    }
    function CopyGo() {
        if (!PHA_GridEditor.End('gridItm')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        PHA.Confirm('提示', '您确认复制勾选记录至制单界面吗？</br>您可以在制单界面继续修改</br>请注意及时保存', function () {
            com.Invoke(com.Fmt2ApiMethod('GenerateCreateData'), data4save, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    PHA_COM.TOP.Set('pha.in.v3.rec.create.csp_copy', retData);
                    if (top.$('#pha_in_v3_rec_createbypo_win').html()) {
                        top.$('#pha_in_v3_rec_createbypo_win').window('close');
                    } else {
                        PHA_COM.GotoMenu({
                            title: '入库制单',
                            url: 'pha.in.v3.rec.create.csp'
                        });
                    }
                }
            });
        });
    }
    function ValidateNumber(num, type) {
        if (num === '') {
            return '数字为空';
        }
        if (isNaN(num)) {
            return '不为数字';
        }

        return true;
    }
    function GetSaveData() {
        var rows = [];
        for (const it of $('#gridItm').datagrid('getChecked')) {
            var rowData = $.extend({}, it);
            var inputQty = rowData.inputQty || '';
            if (ValidateNumber(inputQty) !== true) {
                continue;
            }
            rows.push({
                recID: '',
                recItmID: '',
                inci: rowData.inci,
                batNo: rowData.batNo,
                expDate: rowData.expDate,
                manf: rowData.manf,
                uom: rowData.uom,
                uomDesc: rowData.uomDesc,
                qty: rowData.inputQty,
                rp: rowData.rp,
                sxNo: rowData.sxNo,
                invNo: rowData.invNo,
                invDate: rowData.invDate,
                invAmt: rowData.invAmt,
                poItmID: rowData.poItmID,
                invCode: rowData.invCode
            });
        }
        if (rows.length === 0) {
            components('Pop', '没有可保存的数据, 请核实是否正确输入数量等信息');
            return false;
        }
        var mainSel = com.GetSelectedRow('#gridMain');
        var data4save = {
            main: {
                recID: '',
                loc: mainSel.loc,
                createUser: session['LOGON.CTLOCID'],
                stkCatGrp: mainSel.stkCatGrp,
                poID: mainSel.poID,
                vendor: mainSel.vendor
            },
            rows: rows
        };
        return data4save;
    }

    function InitGridMain() {
        var columns = [
            [
                {
                    field: 'poID',
                    title: 'poID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'recStateDesc',
                    title: '入库情况',
                    width: 100,
                    sortable: true,
                    styler: function (value, rowData, rowIndex) {
                        if (rowData.recState === 'AllIn') {
                            return { class: 'pha-datagrid-td-trans-all' };
                        }
                        if (rowData.recState === 'PartIn') {
                            return { class: 'pha-datagrid-td-trans-part' };
                        }
                    }
                },
                {
                    field: 'no',
                    title: '订单单号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'locDesc',
                    title: '订单科室',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'vendorDesc',
                    title: '经营企业',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: '制单日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '制单时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createUserName',
                    title: '制单人',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'needDate',
                    title: '要求到货日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'statusDesc',
                    title: '状态',
                    width: 100,
                    sortable: true
                },

                {
                    field: 'remarks',
                    title: '备注',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'labels',
                    title: '标签',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishDate',
                    title: '完成日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishTime',
                    title: '完成时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishUserName',
                    title: '完成人',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: '#gridMainBar',
            pageNumber: 1,
            pageSize: 100,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            loadFilter: PHA.LocalFilter,
            // loadFilter: function (data) {
            //     if (data.success === 0) {
            //         PHA.Alert('调用失败', data.msg, 'error');
            //     }
            //     return data;
            // },
            onSelect: function (rowIndex, rowData) {
                com.LoadData('gridItm', {
                    pJson: JSON.stringify({ poID: rowData.poID }),
                    pMethodName: 'GetPOItmDataRows'
                });
            },
            onLoadSuccess: function () {
                $('#gridItm').datagrid('clear');
            }
        };
        PHA.Grid('gridMain', dataGridOption);
    }
    function InitGridItm() {
        var frozenColumns = [
            [
                {
                    field: 'poItmID',
                    title: 'poItmID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'gCheck',
                    checkbox: true
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
                    width: 200,
                    sortable: true
                },

                {
                    field: 'inputQty',
                    title: '预入库数量',
                    width: 100,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            return true;
                        },
                        onBlur: function (val, gridRowData, gridRowIndex) {
                            $('#gridItm').datagrid('updateRowData', {
                                index: gridRowIndex,
                                row: {
                                    rpAmt: _.safecalc('multiply', val, gridRowData.rp)
                                }
                            });
                        }
                    })
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'uom',
                    title: '单位',
                    width: 75,
                    sortable: true,
                    descField: 'uomDesc',
                    formatter: function (value, row, index) {
                        return row.uomDesc;
                    }
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
                    field: 'rp',
                    title: '进价',
                    width: 75,
                    sortable: true,
                    align: 'right'
                    // ,
                    // editor: PHA_GridEditor.NumberBox({
                    //     required: false,
                    //     checkValue: function (val, checkRet) {
                    //         return true;
                    //     },
                    //     onBeforeNext: function (val, gridRowData, gridRowIndex) {
                    //         var rp = val * 1;
                    //         var qty = gridRowData.qty * 1;
                    //         gridRowData.rpAmt = _.multiply(qty, rp);
                    //     }
                    // })
                },
                {
                    field: 'batNo',
                    title: '批号',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({})
                },
                {
                    field: 'expDate',
                    title: '效期',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.DateBox({})
                },
                {
                    field: 'invNo',
                    title: '发票号',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({})
                },
                {
                    field: 'invDate',
                    title: '发票日期',
                    width: 125,
                    sortable: true,
                    editor: PHA_GridEditor.DateBox({})
                },
                {
                    field: 'invCode',
                    title: '发票代码',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({})
                },
                {
                    field: 'invAmt',
                    title: '发票金额',
                    width: 100,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({})
                },
                {
                    field: 'rpAmt',
                    title: '进价金额',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'qty',
                    title: '订单数量',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'recedQty',
                    title: '已入库数量',
                    width: 100,
                    sortable: true
                }
            ]
        ];

        var dataGridOption = {
            url: '',
            exportXls: false,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: '#gridItmBar',
            pageNumber: 1,
            pageSize: 10000,
            pagination: false,
            autoSizeColumn: true,
            editFieldSort: ['inputQty', 'rp', 'batNo', 'expDate'],
            showFooter: true,
            isAutoShowPanel: false, //
            allowEnd: true,
            singleSelect: false,
            onLoadSuccess: function (data) {
                PHA_GridEditor.End(this.id);
                $(this).datagrid('clearChecked');
                com.SumGridFooter(this.id, ['rpAmt', 'spAmt', 'invAmt']);
            },
            onClickCell: function (index, field, value) {
                PHA_GridEditor.Edit({
                    gridID: 'gridItm',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            }
        };
        PHA.Grid('gridItm', dataGridOption);
    }

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
	    $.extend(biz.getData('defaultData')[0], settings.DefaultData || {});
        SetDefaults();
        com.SetPage('pha.in.v3.rec.createbypo.csp');
        $('#btnFind').trigger('click-i');
    }, 0);
});

