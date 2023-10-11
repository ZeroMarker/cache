/**
 * 退货 - 制单 - 依据入库 / 按目的而分
 * @creator 云海宝
 */

$(function () {
    if(self.frameElement.parentElement.id == "pha_in_v3_ret_createbyrec_win"){
        $("#mainDiv-rec").css('background-color', 'white');
    }
    var biz = {
        data: {
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID'],
                    recRetStatus: ['0']
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
    var components = RET_COMPONENTS();
    var com = RET_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Vendor', 'vendor');
    components('No', 'no');
    InitGridMain();
    InitGridItm();
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        com.LoadData('gridMain', {
            pJson: JSON.stringify(com.Condition('#qCondition', 'get')),
            pMethodName: 'GetRecMainDataRows'
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnCopyGo', 'click', function () {
        CopyGo();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        Save();
    });
    function Save() {
        if (!PHA_GridEditor.End('gridPlan')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        com.Invoke(com.Fmt2ApiMethod('Save4Rec'), data4save, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.Top.Set('retID', retData.data);
                PHA_COM.GotoMenu({
                    title: '退货制单',
                    url: 'pha.in.v3.ret.create.csp'
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
                    PHA_COM.TOP.Set('pha.in.v3.ret.create.csp_copy', retData);
                    if (top.$('#pha_in_v3_ret_createbyrec_win').html()) {
                        top.$('#pha_in_v3_ret_createbyrec_win').window('close');
                    } else {
                        PHA_COM.GotoMenu({
                            title: '退货制单',
                            url: 'pha.in.v3.ret.create.csp'
                        });
                    }
                }
            });
        });
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
                retID: '',
                retItmID: '',
                recItmID: rowData.recItmID,
                inci: rowData.inci,
                batNo: rowData.batNo,
                expDate: rowData.expDate,
                manf: rowData.manf,
                uom: rowData.uom,
                qty: rowData.inputQty,
                rp: rowData.rp,
                sp: rowData.sp,
                sxNo: rowData.sxNo,
                invNo: rowData.invNo,
                invAmt: rowData.invAmt,
                invDate: rowData.invDate,
                invCode: rowData.invCode,
                reason: rowData.reason,
                reasonDesc: rowData.reasonDesc
            });
        }
        if (rows.length === 0) {
            components('Pop', '没有可保存的数据, 请核实是否正确输入数量等信息');
            return false;
        }

        var mainSel = com.GetSelectedRow('#gridMain');
        var data4save = {
            main: {
                retID: '',
                loc: mainSel.loc,
                createUser: session['LOGON.CTLOCID'],
                stkCatGrp: mainSel.stkCatGrp,
                vendor: mainSel.vendor,
                remarks: '依据入库单' + mainSel.no
            },
            rows: rows
        };
        return data4save;
    }
    function InitGridMain() {
        var columns = [
            [
                {
                    field: 'recID',
                    title: 'recID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'no',
                    title: '单号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'locDesc',
                    title: '入库科室',
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
                    field: 'auditDate',
                    title: '审核日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditTime',
                    title: '审核时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditUserName',
                    title: '审核人',
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
            onSelect: function (rowIndex, rowData) {
                com.LoadData('gridItm', {
                    pJson: JSON.stringify({ recID: rowData.recID }),
                    pMethodName: 'GetRecItmDataRows'
                });
            },
            onLoadSuccess: function () {
                $('#gridItm').datagrid('clear');
            }
        };
        PHA.Grid('gridMain', dataGridOption);
    }
    // 以录入数量的行作为有效保存行
    function InitGridItm() {
        var frozenColumns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'recItmID',
                    title: 'recItmID',
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
                    descField: 'inciDesc',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'inputQty',
                    title: '预退货数量',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            if (_.isLikeNumber(val) === false) {
                                checkRet.msg = '数量: 请输入数字';
                                return false;
                            }
                            return true;
                        },
                        onBlur: function (val, gridRowData, gridRowIndex) {
                            $('#gridItm').datagrid('updateRowData', {
                                index: gridRowIndex,
                                row: {
                                    rpAmt: _.safecalc('multiply', val, gridRowData.rp),
                                    spAmt: _.safecalc('multiply', val, gridRowData.sp)
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
                    field: 'reason',
                    title: '退货原因',
                    width: 150,
                    sortable: true,
                    descField: 'reasonDesc',
                    formatter: function (value, row, index) {
                        return row[this.descField];
                    },
                    editor: PHA_GridEditor.ComboBox({
                        required: false,
                        loadRemote: true,
                        panelHeight: 'auto',
                        url: PHA_IN_STORE.ReasonForReturn().url
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
                    }
                },
                {
                    field: 'rp',
                    title: '进价',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'rpAmt',
                    title: '进价金额',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'sp',
                    title: '售价',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'spAmt',
                    title: '售价金额',
                    width: 75,
                    sortable: true,
                    align: 'right'
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
                    width: 75,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({})
                },
                {
                    field: 'sxNo',
                    title: '随行单号',
                    width: 100,
                    sortable: false,
                    editor: PHA_GridEditor.ValidateBox({})
                },
                {
                    field: 'origin',
                    title: '产地',
                    width: 100,
                    sortable: true,
                    descField: 'originDesc',
                    formatter: function (value, row, index) {
                        return row[this.descField];
                    }
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
            // editFieldSort: ['inci', 'qty', 'uom', 'rp'],
            showFooter: true,
            isAutoShowPanel: false,
            allowEnd: true,
            singleSelect: false,
            onLoadSuccess: function (data) {
                PHA_GridEditor.End('gridItm');
                $('#gridItm').datagrid('clearChecked');
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
        $.extend(biz.getData('defaultData')[0], settings.DefaultData ||{});
        SetDefaults();
        com.SetPage('pha.in.v3.ret.createbyrec.csp')
    }, 0);
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
