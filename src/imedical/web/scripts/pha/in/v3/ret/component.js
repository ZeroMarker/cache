/**
 * 退货 - 组件
 * @creator 云海宝
 */
var RET_COMPONENTS = function () {
    var components = {
        Loc: function (domID, options) {
            options = options || {};
            PHA_UX.ComboBox.Loc(domID, options);
        },
        StkCatGrp: function (domID, options) {
            options = options || {};
            var defOptions = {
                panelHeight: 'auto',
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    LocId: PHA_UX.Get('loc', session['LOGON.CTLOCID']), // 只有走公共插件才这么写有效
                    UserId: session['LOGON.USERID']
                }
            };
            PHA_UX.ComboBox.StkCatGrp(domID, $.extend(defOptions, options));
        },
        StkCat: function (domID, options) {
            options = options || {};
            var defOptions = {
                multiple: true,
                rowStyle: 'checkbox'
            };
            PHA_UX.ComboBox.StkCat(domID, $.extend(defOptions, options));
        },
        Poison: function (domID, options) {
            options = options || {};
            defOptions = {};
            PHA_UX.ComboBox.Poison(domID, $.extend(defOptions, options));
        },
        Date: function (domID) {
            PHA.DateBox(domID, {});
            $('#' + domID).datebox('setValue', 't');
        },
        PurchUser: function (domID, options) {
            options = options || {};
            defOptions = { url: PHA_IN_STORE.LocPurPlanUser().url };
            PHA.ComboBox(domID, $.extend(defOptions, options));
        },
        No: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Inci: function (domID,options) {
            options = options || {};
            var defaultOptions = {
                width:160,
                qParams:{
                    scgId: PHA_UX.Get('stkCatGrp', ''),
                }
            };
            PHA_UX.ComboGrid.INCItm(domID, $.extend(defaultOptions, options));
        },
        Vendor: function (domID, options) {
            options = options || {};
            var def = {
                panelWidth: 'auto',
                panelHeight: $.fn.combobox.defaults.height * 10 + 5
            };
            $.extend(def, options);
            PHA_UX.ComboBox.Vendor(domID, $.extend(def, options));
        },
        OperateType: function (domID, options, callBack) {
            PHA.ComboBox(domID, {
                url: PHA_IN_STORE.OperateType('R').url,
                panelHeight: 'auto',
                editable: false,
                onLoadSuccess: function (rows) {
                    if (callBack) {
                        callBack(rows);
                    }
                }
            });
        },
        Reason: function (domID, options) {
            options = options || {};
            defOptions = { url: PHA_IN_STORE.ReasonForReturn().url };
            PHA.ComboBox(domID, $.extend(defOptions, options));
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                multiple: true,
                rowStyle: 'checkbox',
                editable: false,
                panelHeight: 'auto',
                url: PHA_STORE.BusiProcess('RET', session['LOGON.CTLOCID'], session['LOGON.USERID']).url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        NextStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                url: PHA_STORE.BusiProcess('RET', session['LOGON.CTLOCID'], session['LOGON.USERID']).url,
                loadFilter: function (rows) {
                    return rows.filter(function (ele, index) {
                        if (['SAVE', 'COMP', 'CANCEL', 'COPY'].indexOf(ele.RowId) >= 0) {
                            return false;
                        }
                        return true;
                    });
                }
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        StatusResult: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: false,
                // rowStyle: 'checkbox', //显示成勾选行形式
                url: PHA_IN_STORE.BusiStatusResult().url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, { placeholder: '备注..' });
        },
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        RecRetStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    { RowId: '0', Description: $g('未退货') },
                    { RowId: '0.5', Description: $g('部分退货') },
                    { RowId: '1', Description: $g('已全部退货') }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Banner: function (domID, options) {
            if (typeof options === 'object') {
                var dataArr = [];
                dataArr = [
                    {
                        info: options.no,
                        append: '/'
                    },
                    {
                        prepend: $g('制单')+': ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == $g('保存') ? $g('未完成') : options.statusDesc,
                        labelClass: options.statusDesc == $g('保存') ? 'danger' : 'info'
                    }
                ];
                if ((options.recNo || '') !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: $g('依据入库单')+': ', info: options.recNo });
                }
                $('#' + domID).phabanner('loadData', dataArr);
            } else {
                $('#' + domID).phabanner({
                    title: $g('选择单据后, 显示详细信息')
                });
            }
        },

        ItmGrid: function (domID, opts) {
            var columnsObj = this.ItmGridColmuns(domID);

            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: opts.columns ? opts.columns : columnsObj.columns,
                frozenColumns: opts.frozenColumns ? opts.frozenColumns : columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                pagination: false,
                autoSizeColumn: true,
                editFieldSort: ['inci', 'qty', 'reason', 'rp', 'sp'],
                footerSumFields: ['rpAmt', 'spAmt', 'invAmt'],
                distinctFields: ['recItmID'],
                isAutoShowPanel: false,
                allowEnd: true,
                rownumbers: true,
                checkOnSelect: false,
                selectOnCheck: false,
                showFooter: true,
                showComCol: true,
                loadFilter: function (data) {
                    if (data.success === 0) {
                        PHA.Alert('提示', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('提示', data.rows[0], 'warning');
                            }
                        }
                    }
                    return data;
                },
                onLoadSuccess: function (data) {
                    var gridID = this.id;
                    PHA_GridEditor.End(domID);
                    RET_COM.SumGridFooter(gridID);
                    $(this).datagrid('clearChecked');
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    PHA_UX.DrugDetail({}, { inci: rowData.inci });
                    return;
                }
            });
        },
        ItmGridColmuns: function (gridID) {
            gridID = gridID || 'gridItm';
            function GridOptions() {
                return {
                    gridID: gridID,
                    $grid: $('#' + gridID)
                };
            }
            var frozenColumns = [
                [
                    {
                        field: 'retItmID',
                        title: 'retItmID',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'gCheck',
                        checkbox: true
                    },
                    {
                        field: 'inci',
                        title: 'inci',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },

                    {
                        field: 'inciCode',
                        title: '药品代码',
                        width: 100,
                        sortable: true,
                        formatter: function (value, rowData, index) {
                            if (!value || !rowData.inci) {
                                return value;
                            }
                            return '<a class="pha-grid-a js-grid-inciCode">' + value + '</a>';
                        }
                    },
                    {
                        field: 'inciDesc', // 不需要类似下拉框的descField转换
                        title: '药品名称',
                        descField: 'inciDesc',
                        width: 200,
                        sortable: true,
                        editor: PHA_UX.Grid.INCItmRecWin(
                            {
                                type: 'triggerbox',
                                required: true,
                                onBeforeLoad: function (param, gridRowData) {
                                    param.hospId = session['LOGON.HOSPID'];
                                    param.pJsonStr = JSON.stringify({
                                        stkType: App_StkType,
                                        scgId: $('#stkCatGrp').combobox('getValues').toString() || '',
                                        locId: $('#loc').combobox('getValue') || '',
                                        userId: session['LOGON.USERID'],
                                        notUseFlag: 'N',
                                        qtyFlag: '',
                                        reqLocId: $('#loc').combobox('getValue') || ''
                                    });
                                    GridOptions().$grid.datagrid('options').recBatRowIndexArr = [];
                                },
                                // 窗口关闭后先进了onClickSure, 又进了onBeforeNext, 统一使用onClickSure 符合理解
                                onBeforeNext: function (retData, gridRowData, gridRowIndex) {
                                    // 窗口内记录双击行直接返回此处, 此center为单条
                                    // var newRetData = _.cloneDeep(retData);
                                    // newRetData.center = [newRetData.center];
                                    // console.info("onBeforeNext",newRetData)
                                    // onWinDataReturn(newRetData);
                                },
                                onClickSure: function (retData) {
                                    onWinDataReturn(retData);
                                }
                            },
                            {
                                north: {
                                    loadFilter: function (data) {
                                        data.rows.forEach(function (ele) {
                                            $.extend(ele, {
                                                vendor: $('#vendor').combobox('getValue') || '',
                                                loc: $('#loc').combobox('getValue') || ''
                                            });
                                        });
                                        return data;
                                    }
                                },
                                center: {
                                    loadFilter: function (data) {
                                        // 能直接显示提示, 就不每次慢慢弹, 弹到狗年马月
                                        // 走的method , 没分页, 此处data直接就是 rows了
                                        var retRows = $('#gridItm').datagrid('getRows');
                                        var rows = data;
                                        if (Array.isArray(rows)) {
                                            for (const row of rows) {
                                                var recItmID = row.recItmID;
                                                for (const retRow of retRows) {
                                                    if (retRow.recItmID === recItmID) {
                                                        row.warnInfo = '已存在';
                                                        row.banFlag = true;
                                                    }
                                                    if (retRow.inclbAvaQty == 0) {
                                                        row.warnInfo = '库存为零';
                                                        row.banFlag = true;
                                                    }
                                                }
                                            }
                                        }
                                        return {
                                            total: rows.length,
                                            rows: rows
                                        };
                                    }
                                }
                            }
                        )
                    },
                    {
                        field: 'spec',
                        title: '规格',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'uom',
                        title: '单位',
                        width: 75,
                        sortable: true,
                        descField: 'uomDesc',
                        formatter: function (value, row, index) {
                            return row.uomDesc;
                        },
                        editor: PHA_UX.Grid.INCItmUom({
                            panelHeight: 'auto',
                            loadRemote: true,
                            required: true,
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                // 表格控制, 数据用单独起
                                var calcData = RET_COM.InvokeSyn('CalcData4InputRow', {
                                    value: cmbRowData.RowId,
                                    rowData: gridRowData,
                                    trigger: {
                                        field: 'uom',
                                        type: 'onBeforeNext'
                                    },
                                    appSetting:RET_COM.GetSettings().App
                                });
                                if (RET_COM.ValidateApiReturn(calcData) === true) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: calcData.rowData
                                    });
                                }
                                return true;
                            }
                        })
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'qty',
                        title: '数量',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                minPrecision: '',
                                checkValue: function (val, checkRet) {
                                    var validate = RET_COM.ValidateQty(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    var $grid = GridOptions().$grid;
                                    var qty = val;
                                    $grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: {
                                            rpAmt: _.safecalc('multiply', qty, gridRowData.rp),
                                            spAmt: _.safecalc('multiply', qty, gridRowData.sp)
                                        }
                                    });
                                }
                            })
                        ),
                        styler: function (value, rowData, rowIndex) {
                            if (rowData.infoStock !== '' && rowData.infoStock !== undefined) {
                                return { class: 'pha-datagrid-validate-col' };
                            }
                        }
                    },
                    {
                        field: 'inclbAvaQty',
                        title: '可用库存', // 点击显示全院分布, 以及占用信息?
                        width: 75,
                        sortable: true,
                        align: 'right'
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
                            required: true,
                            loadRemote: false,
                            panelHeight: 'auto',
                            url: PHA_IN_STORE.ReasonForReturn().url
                        })
                    },
                    {
                        field: 'manfDesc',
                        title: '生产企业',
                        width: 150,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row[this.descField];
                        }
                    },
                    {
                        field: 'rp',
                        title: '进价',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                checkValue: function (val, checkRet) {
                                    var validate = RET_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: {
                                            rpAmt: _.safecalc('multiply', val, gridRowData.qty)
                                        }
                                    });
                                }
                            })
                        )
                    },
                    {
                        field: 'sp',
                        title: '售价',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.ValidateBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: false,
                                checkValue: function (val, checkRet) {
                                    var validate = RET_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: {
                                            spAmt: _.safecalc('multiply', val, gridRowData.qty)
                                        }
                                    });
                                }
                            })
                        )
                    },
                    {
                        field: 'rpAmt',
                        title: '进价金额',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'spAmt',
                        title: '售价金额',
                        width: 100,
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
                        title: '退发票金额', // 发票金额
                        width: 100,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: false,
                                checkValue: function (val, checkRet) {
                                    var validate = PLAN_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                }
                            })
                        )
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
                    },

                    {
                        field: 'recItmID',
                        title: '入库记录id', // @todo 超链接可查看入库详细信息
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'insuCode',
                        title: '国家医保编码',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'insuDesc',
                        title: '国家医保名称',
                        sortable: true,
                        width: 150
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
            function onWinDataReturn(retData) {
                var recItmRows = retData.center;
                var gridID = GridOptions().gridID;
                var $_grid = $('#' + gridID);
                var needUpdateRowIndex = '';
                if (PHA_GridEditor.IsGridEditing(gridID)) {
                    needUpdateRowIndex = PHA_GridEditor.CurRowIndex(gridID);
                    // 全局变量, 仅用于弹窗后追加行数据使用
                    PHA_IN_RET_ROWINDEX = needUpdateRowIndex;
                }
                var defaultRow = {};
                for (var i = 0, length = recItmRows.length; i < length; i++) {
                    var ele = recItmRows[i];
                    // 选择的批次不允许选择, 如已经存在于表格或者不可用等, 逻辑待进一步分析
                    if (ele.banFlag === true) {
                        continue;
                    }
                    // 此处多次调用并无大碍, 有空在改成一次性的
                    var msgData = RET_COM.GetFullData4InputRow(ele);

                    var mRowData = msgData.rowData;
                    var mMsgData = msgData.msgData;
                    var mMsgData_rows = mMsgData.rows;
                    if (mMsgData_rows.length > 0) {
                        // 不在此提示先
                        // PHA.Alert('提示', mMsgData_rows.join('</br>'), 'warning');
                        // return;
                    }
                    // 与调整|出库的逻辑一致, 无效则更新, 否则追加
                    if (RET_COM.ValidateApiReturn(mRowData) === true) {
                        if (i === 0) {
                            var recItmID = RET_COM.GetSelectedRow(gridID, 'recItmID');
                            var selRowIndex = RET_COM.GetSelectedRowIndex(gridID);
                            if (recItmID === '') {
                                $_grid.datagrid('updateRow', {
                                    index: selRowIndex,
                                    row: $.extend(mRowData, defaultRow)
                                });
                                GridOptions().$grid.datagrid('options').recBatRowIndexArr.push(selRowIndex);

                                continue;
                            }
                        }
                        PHA_GridEditor.Add({
                            gridID: gridID,
                            field: '',
                            rowData: $.extend(mRowData, defaultRow)
                        });
                        GridOptions()
                            .$grid.datagrid('options')
                            .recBatRowIndexArr.push($_grid.datagrid('getRows').length - 1);
                    }
                }
                setTimeout(function () {
                    if ($('#DrugBatRec_Detail_Win').parent().css('display') === 'none') {
                        // 窗口关闭后, 调用数据验证 onAfterEdit
                        $_grid.datagrid('options').onRecBatWinClose();
                    }
                }, 100);
            }
        },
        MainGrid: function (domID, opts) {
            var columnsObj = this.MainGridColmuns();
            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: columnsObj.columns,
                frozenColumns: columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                isAutoShowPanel: false,
                selectOnCheck: false,
                checkOnSelect: false,
                rownumbers: true,
                loadFilter: function (data) {
                    if (data.success === 0) {
                        PHA.Alert('提示', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('提示', data.rows[0], 'warning');
                            }
                        }
                    }
                    return data;
                },
                onBeforeLoad: function (params) {
                    // 可校验必填数据
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            PHA.GridEvent(domID, 'click', ['pha-grid-a js-grid-retNo'], function (rowIndex, rowData, className) {
                if (className === 'pha-grid-a js-grid-retNo') {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
                            busiCode: 'RET',
                            pointer: rowData.retID
                        }
                    );
                }
            });
        },
        MainGridColmuns: function () {
            var frozenColumns = [
                [
                    {
                        field: 'retID',
                        title: 'retID',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'no',
                        title: '单号',
                        // width: 100,
                        sortable: true,
                        formatter: function (value, rowData, index) {
                            if (!value) {
                                return;
                            }
                            return '<a class="pha-grid-a js-grid-retNo">' + value + '</a>';
                        }
                    },
                    {
                        field: 'locDesc',
                        title: '退货科室',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'vendorDesc',
                        title: '经营企业',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '退货类型',
                        width: 100,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'createDate',
                        title: '制单日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '制单时间',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '制单人',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'finishDate',
                        title: '完成日期',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishTime',
                        title: '完成时间',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishUserName',
                        title: '完成人',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditDate',
                        title: '审核日期',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditTime',
                        title: '审核时间',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditUserName',
                        title: '审核人',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'statusDesc',
                        title: '状态',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusDate',
                        title: '状态操作日期',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusTime',
                        title: '状态操作时间',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusUserName',
                        title: '状态操作人',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'remarks',
                        title: '备注',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'labels',
                        title: '标签',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },

                    {
                        field: 'rpAmt',
                        title: '进价金额',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'spAmt',
                        title: '售价金额',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'diffAmt',
                        title: '差额',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },

                    {
                        field: 'newestStatusInfo',
                        title: '最新流转信息',
                        // width: '150',
                        sortable: true,
                        showTip: true,
                        // formatter:function(val){
                        //     // return '<div style="text-overflow: ellipsis;">'+val+'</div>'

                        // },
                        styler: function (val) {
                            if (val !== undefined) {
                                if (val.indexOf('拒绝') > 0) {
                                    return { class: 'pha-datagrid-status-warn' };
                                }
                            }
                        }
                    },
                    {
                        field: 'retInfo',
                        title: '更多信息',
                        width: 300,
                        sortable: true
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
        },
        QueryWindow: function (domID, options) {
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: '选择退货单',
                width: $('body').width() * 0.85,
                height: $('body').height() * 0.85,
                modal: true,
                closable: true,
                collapsible: false,
                maximizable: false,
                minimizable: false,
                onOpen: function () {
                    $.data($('#' + this.id)[0], 'retData', {});
                }
            };
            $('#' + domID)
                .window($.extend({}, defOptions, options))
                .window('open');
            PHA_COM.ResizePanel({
                layoutId: 'layout-ret-query',
                region: 'north',
                height: 0.5
            });
        },
        Detail: function () {
        },
        Pop: function (msg, type) {
            type = type || 'info';
            PHA.Popover({
                msg: msg,
                type: type
            });
        },
        BanEditFields: function (cols, banEditFields) {
            banEditFields = banEditFields || [];
            if (banEditFields.length > 0) {
                cols.forEach(function (ele) {
                    if (banEditFields.indexOf(ele.field) >= 0) {
                        delete ele.editor;
                    }
                });
            }
        }
    };
    return function (type) {
        var pParams = [].slice.call(arguments, 1, arguments.length);
        // 注意apply 第一个参数this的变化, 此处默认this指window, 因此做改动
        return components[type].apply(components, pParams);
    };
};
