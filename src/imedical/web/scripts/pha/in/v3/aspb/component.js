/**
 * 调价 - 批次价 - 组件
 * @creator     云海宝
 */
var ASPB_COMPONENTS = function () {
    var components = {
        StkCatGrp: function (domID, options) {
            options = options || {};
            var defOptions = {
                simple: true,
                panelHeight: 'auto',
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    LocId: PHA_UX.Get('loc', session['LOGON.CTLOCID']),
                    UserId: session['LOGON.USERID']
                }
            };
            PHA_UX.ComboBox.StkCatGrp(domID, $.extend(defOptions, options));
        },
        Date: function (domID) {
            PHA.DateBox(domID, {});
            $('#' + domID).datebox('setValue', 't');
        },
        No: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Inci: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                width: 160,
                qParams: {
                    scgId: PHA_UX.Get('stkCatGrp', '')
                }
            };
            PHA_UX.ComboGrid.INCItm(domID, $.extend(defaultOptions, options));
        },

        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                url: PHA_STORE.BusiProcess('ASPB', session['LOGON.CTLOCID'], session['LOGON.USERID']).url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        /**
         * 仅用于审核界面
         */
        NextStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                url: PHA_STORE.BusiProcess('ASPB', session['LOGON.CTLOCID'], session['LOGON.USERID']).url,
                loadFilter: function (rows) {
                    return rows.filter(function (ele, index) {
                        if (ele.RowId === 'SAVE') {
                            return false;
                        }

                        return true;
                    });
                },
                onLoadSuccess: function (data) {
                    if (data.length > 0) {
                        $(this).combobox('setValue', data[0].RowId);
                    }
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
                data: [
                    { RowId: 'UN', Description: '未处理' },
                    { RowId: 'PASS', Description: '已处理' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Reason: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_IN_STORE.ReasonForAdjPrice().url
            });
        },
        GroupWay: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                data: [
                    {
                        RowId: 'INASP_Date|createDate',
                        Description: '制单日期'
                    },
                    {
                        RowId: 'INASP_REASON_DR|reasonDesc',
                        Description: '调价原因'
                    },
                    {
                        RowId: 'INASP_SSUSR_DR|createUserName',
                        Description: '制单人'
                    },
                    {
                        RowId: 'INASP_ExecuteDate|executeDate',
                        Description: '生效日期'
                    },
                    {
                        RowId: 'INASP_PreExeDate|preExecuteDate',
                        Description: '计划生效日期'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
            $('#' + domID).combobox('setValues', ['INASP_Date']);
        },
        /**
         * 全局模糊检索
         */
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        AspbGrid: function (domID, opts, otherOpts) {
	        otherOpts = otherOpts || {};
            var columnsObj = this.AspbGridColmuns(domID, otherOpts);
            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: opts.columns ? opts.columns : columnsObj.columns,
                frozenColumns: opts.frozenColumns ? opts.frozenColumns : columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                rownumbers: true,
                isAutoShowPanel: false,
                allowEnd: true,
                selectOnCheck: false,
                checkOnSelectL: false,
                editFieldSort: ['inci', 'retUomRp', 'retUomSp', 'reason', 'preExecuteDate', 'remark'],
                distinctFields: ['incib'],
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
                    $(this).datagrid('clearChecked');
                    PHA_GridEditor.End(domID);
                    $(this).datagrid('loaded');
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode','pha-grid-a js-grid-aspbNo'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    PHA_UX.DrugDetail({}, { inci: rowData.incib.split('||')[0] });
                    return;
                }
                if (className.indexOf('pha-grid-a js-grid-aspbNo') >= 0) {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
	                        No: rowData.no,
                            busiCode: 'ASPB',
                            pointer: rowData.aspbID
                        }
                    );
                }
            });
        },
        AspbGridColmuns: function (gridID, opts) {
            gridID = gridID || 'gridAspb';
            opts = opts || {};
            var deleteField = opts.deleteField || [];
            function GridOptions() {
                return {
                    gridID: gridID,
                    $grid: $('#' + gridID)
                };
            }
            var frozenColumns = [
                [
                    {
                        field: 'gCheck',
                        checkbox: true
                    },
                    {
                        field: 'aspbID',
                        title: 'aspbID',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'no',
                        title: '单号',
                        width: 100,
                        sortable: true,
                        hidden: true,
                        formatter: function (value, rowData, index) {
                            if (!value) {
                                return;
                            }
                            return '<a class="pha-grid-a js-grid-aspbNo">' + value + '</a>';
                        }
                    },
                    {
                        field: 'inci',
                        title: 'inci',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'incib',
                        title: 'incib',
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
                            if (!value || !rowData.incib) {
                                return value;
                            }
                            return '<a class="pha-grid-a js-grid-inciCode">' + value + '</a>';
                        }
                    },
                    {
                        field: 'inciDesc',
                        title: '药品名称',
                        width: 200,
                        sortable: true,
                        editor: components.INCItmBatWin({
                            type: 'triggerbox',
                            required: true,
                            onBeforeLoad: function (param, gridRowData) {
                                param.hospId = session['LOGON.HOSPID'];
                                param.pJsonStr = JSON.stringify({
                                    stkType: App_StkType,
                                    scgId: $('#stkCatGrp').combobox('getValues').toString() || '',
                                    locId: '',
                                    userId: session['LOGON.USERID'],
                                    notUseFlag: 'N',
                                    qtyFlag: ''
                                });
                                GridOptions().$grid.datagrid('options').winSelecedIndexArr = [];
                            },
                            onBeforeNext: function (retData, gridRowData, gridRowIndex) {
                                // 只是用onClickSure
                                // var newRetData = _.cloneDeep(retData);
                                // newRetData.center = [newRetData.center];
                                // onWinDataReturn(newRetData);
                            },
                            onClickSure: function (retData) {
                                onWinDataReturn(retData);
                            }
                        })
                    },
                    {
                        field: 'uom',
                        title: '单位',
                        width: 75,
                        sortable: true,
                        descField: 'uomDesc',
                        formatter: function (value, row, index) {
                            return row[this.descField];
                        },
                        editor: PHA_GridEditor.ComboBox({
                            required: true,
                            tipPosition: 'top',
                            loadRemote: false,
                            panelHeight: 'auto',
                            url: PHA_STORE.CTUOMWithInci().url,
                            onBeforeLoad: function (param) {
                                var curRowData = PHA_GridEditor.CurRowData('gridAspb');
                                param.InciDr = curRowData.inci || '';
                            },
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                var calcData = ASPB_COM.InvokeSyn('CalcData4InputRow', {
                                    value: cmbRowData.RowId,
                                    rowData: gridRowData,
                                    trigger: {
                                        field: 'uom',
                                        type: 'onBeforeNext'
                                    }
                                });
                                GridOptions().$grid.datagrid('updateRowData', {
                                    index: gridRowIndex,
                                    row: $.extend(gridRowData, calcData)
                                });
                                return true;
                            }
                        })
                    },
                    {
                        field: 'priUomRp',
                        title: '调前进价',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'priUomSp',
                        title: '调前售价',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'retUomRp',
                        title: '<b>' + $g('调后进价') + '</b>',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                maxPrecision: 8,
                                checkValue: function (val, checkRet) {
                                    var validate = ASPB_COM.ValidatePrice(val, 'rp');
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onEnter: function (val, gridRowData, gridRowIndex) {
                                    var calcData = ASPB_COM.InvokeSyn('CalcData4InputRow', {
                                        rowData: gridRowData,
                                        value: val,
                                        trigger: {
                                            field: 'retUomRp',
                                            type: 'onEnter'
                                        }
                                    });
                                    if (ASPB_COM.ValidateApiReturn(calcData) === false) {
                                        return;
                                    }
                                    /* 计算进价差 */
                                    var diffRp = _.safecalc('add', val, _.safecalc('multiply', -1, gridRowData.priUomRp))
                                    if (diffRp == 0) diffRp = "";
                                    calcData['diffRp'] = diffRp
                                    var diffPrice = _.safecalc('add', gridRowData.retUomSp, _.safecalc('multiply', -1, val));
                                    calcData['diffPrice'] = diffPrice;
                                    var marginVal = (parseFloat(gridRowData.retUomSp) == 0) ? 0 :  _.toFixed(_.safecalc('divide', gridRowData.retUomSp, val), 4);
                                    calcData['marginVal'] = marginVal;
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: calcData
                                    });
                                }
                            })
                        )
                    },

                    {
                        field: 'retUomSp',
                        title: '<b>' + $g('调后售价') + '</b>',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        styler: function () {
                            return 'font-weight:bold;';
                        },
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                maxPrecision: 8,
                                checkValue: function (val, checkRet) {
                                    var validate = ASPB_COM.ValidatePrice(val, 'sp');
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onEnter: function (val, gridRowData, gridRowIndex) {
                                    var diffSp = _.safecalc('add', val, _.safecalc('multiply', -1, gridRowData.priUomSp))
                                    if (diffSp == 0) diffSp = "";
                                    var diffPrice = _.safecalc('add', val, _.safecalc('multiply', -1, gridRowData.retUomRp));
                                    var marginVal = (parseFloat(val) == 0) ? 0 : _.toFixed(_.safecalc('divide', val, gridRowData.retUomRp), 4);
                                    var rowData ={
	                                    diffSp : diffSp,
	                                    diffPrice : diffPrice,
	                                    marginVal : marginVal
                                    }
                                    
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: rowData
                                    });
                                }
                            })
                        )
                    },
                    {
                        field: 'diffRp',
                        title: '进价差',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'diffSp',
                        title: '售价差',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'diffPrice',
                        title: '差价',
                        width: 75,
                        hidden: true,
                        sortable: true,
                        align: 'right'/*,
                        formatter: function (value, row, index) {
                            return _.toFixed(_.safecalc('add', row.retUomSp, _.safecalc('multiply', -1, row.retUomRp)), 2);
                        },
                        styler: function (value, rowData, rowIndex) {
                            var rp = rowData.retUomRp;
                            var sp = rowData.retUomSp;
                            if (rp !== '' && !isNaN(rp) && sp !== '' && !isNaN(sp)) {
                                if (rp !== 0) {
                                    if (sp / rp > ASPB_COM.GetSettings().App.Warn4PriceRate) {
                                        return { class: 'pha-datagrid-price-warning' };
                                    }
                                }
                                if (rp - sp > 0) {
                                    return { class: 'pha-datagrid-price-warning' };
                                }
                            }
                        }*/
                    },
                    {
                        field: 'marginVal',
                        title: '加成率',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        formatter: function (value, row, index) {
	                        if(row.zeroMarginFlag && (value != '') && (parseFloat(value) != 1)){
		                        PHA.Msg('info', row.inciDesc + '为零加成药品,进售价不符');
	                        }
	                        if (value > ASPB_COM.GetSettings().App.Warn4PriceRate) return '<div style="color:red">' + value + '</div>';  
	                        else return value;
                            //return _.toFixed(_.safecalc('divide', row.retUomSp, row.retUomRp), 2); //改为后台取值，前台取值会影响前台联动事件
                        }
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
                        field: 'reason',
                        title: '调价原因',
                        width: 150,
                        sortable: true,
                        descField: 'reasonDesc',
                        formatter: function (value, row, index) {
                            return row.reasonDesc;
                        },
                        editor: PHA_GridEditor.ComboBox({
                            required: true,
                            loadRemote: false,
                            panelHeight: 'auto',
                            url: PHA_IN_STORE.ReasonForAdjPrice().url
                        })
                    },

                    {
                        field: 'preExecuteDate',
                        title: '计划生效日期',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({
                            required: true,
                            checkValue: function (value, checkRet) {
                                if (value === '') {
                                    checkRet.msg = '计划生效日期: 必填且日期应在今天之后';
                                    return false;
                                }
                                if (value !== '') {
                                    if (!PHA_UTIL.CompareDate(value, '>', PHA_UTIL.GetDate('t'))) {
                                        checkRet.msg = '计划生效日期: 应在今天之后';
                                        return false;
                                    }
                                }
                                return true;
                            }
                        })
                    },

                    {
                        field: 'remark',
                        title: '备注',
                        width: 125,
                        sortable: true,
                        showTip: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'markType',
                        title: '定价类型',
                        width: 100,
                        sortable: true,
                        formatter: function (value, row, index) {
                            return row.markTypeDesc;
                        }
                    },
                    {
                        field: 'maxSp',
                        title: '最高售价',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'hosp',
                        title: '医院',
                        width: 100,
                        sortable: true,
                        hidden: true,
                        formatter: function (value, row, index) {
                            return row.hospDesc;
                        }
                    },
                    {
                        field: 'warrentNo',
                        title: '物价文件号',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'warrentNoDate',
                        title: '物价文件号日期',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'invNo',
                        title: '发票号',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
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
                        field: 'auditDate',
                        title: '审核日期',
                        width: 100,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditDate') >= 0)
                    },
                    {
                        field: 'auditTime',
                        title: '审核时间',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditTime') >= 0)
                    },
                    {
                        field: 'auditUserName',
                        title: '审核人',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditUserName') >= 0)
                    },
                    {
                        field: 'executeDate',
                        title: '生效日期',
                        width: 100,
                        sortable: true,
                        hidden : (deleteField.indexOf('executeDate') >= 0)
                    },
                    {
                        field: 'executeTime',
                        title: '生效时间',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('executeTime') >= 0)
                    },
                    {
                        field: 'executeUserName',
                        title: '生效人',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('executeUserName') >= 0)
                    },
                    {
                        field: 'timeLine',
                        title: '数据时间轴',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'aspbStatus',
                        title: 'aspbStatus',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'zeroMarginFlag',
                        title: '零加成标志',
                        sortable: true,
                        width: 100,
                        hidden: true,
				        align: 'center'
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
                // 窗口内确认返回此处
                var inciRow = retData.north;
                var incibRows = retData.center;
                if(!incibRows.length) return;
                var gridID = 'gridAspb';
                var $_grid = $('#' + gridID);
                var needUpdateRowIndex = '';
                if (PHA_GridEditor.IsGridEditing(gridID)) {
                    needUpdateRowIndex = PHA_GridEditor.CurRowIndex(gridID);
                    // 全局变量, 仅用于弹窗后追加行数据使用
                    PHA_IN_ASPB_ROWINDEX = needUpdateRowIndex;
                }
                let defaultRow = {
                    hosp: session['LOGON.HOSPID']
                };

                for (var i = 0, length = incibRows.length; i < length; i++) {
                    var ele = incibRows[i];
                    if (ele.banFlag === true) {
                        continue;
                    }
                    var mRowData = {
                        inciCode: inciRow.inciCode,
                        inciDesc: inciRow.inciDesc,
                        inci: inciRow.inci,
                        retUomRp: ele.aspRetRp || '',
                        retUomSp: ele.aspRetSp || '',
                        reason: ele.aspReason || '',
                        reasonDesc: ele.aspReasonDesc || '',
                        uom: inciRow.pUomId || '',
                        uomDesc: inciRow.pUomDesc || '',
                        batNo: ele.batNo || '',
                        expDate: ele.expDate || '',
                        priUomRp: ele.pRp || '',
                        priUomSp: ele.pSp || '',
                        incib: ele.incib,
                        zeroMarginFlag: ele.zeroMarginFlag || '',
                        markType: inciRow.markType,
                        markTypeDesc: inciRow.markTypeDesc,
                        maxSp : ele.maxSp || '',
                    };
                    /* 价格差 */
                    var diffRp = _.safecalc('add', mRowData.retUomRp, _.safecalc('multiply', -1, mRowData.priUomRp))
                    if (diffRp == 0) diffSp = "";
                    var diffSp = _.safecalc('add', mRowData.retUomSp, _.safecalc('multiply', -1, mRowData.priUomSp))
                    if (diffSp == 0) diffSp = "";
                    mRowData['diffRp'] = diffRp;
                    mRowData['diffSp'] = diffSp;
                    
                    if (i === 0) {
                        var incib = ASPB_COM.GetSelectedRow(gridID, 'incib');
                        var selRowIndex = ASPB_COM.GetSelectedRowIndex(gridID);
                        if (incib === '') {
                            var incib = ASPB_COM.GetSelectedRow(gridID, 'incib');
                            $_grid.datagrid('updateRow', {
                                index: selRowIndex,
                                row: $.extend(mRowData, defaultRow)
                            });
                            $_grid.datagrid('options').winSelecedIndexArr.push(selRowIndex);

                            continue;
                        }
                    }
                    PHA_GridEditor.Add({
                        gridID: gridID,
                        field: '',
                        rowData: $.extend(mRowData, defaultRow)
                    });
                    $_grid.datagrid('options').winSelecedIndexArr.push($_grid.datagrid('getRows').length - 1);
                }
                setTimeout(function () {
                    if ($('#DrugBatRec_Detail_Win').parent().css('display') === 'none') {
                        // 窗口关闭后, 调用数据验证 onAfterEdit
                        $_grid.datagrid('options').onBatWinClose();
                    }
                }, 100);
            }
        },
        GrpGrid: function (domID, opts) {
            var columns = this.GrpGridColmuns();
            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: columns,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                isAutoShowPanel: true,
                fitColumns: true,
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
                onLoadSuccess: function (data) {
                    $(this).datagrid('clearChecked');
                    PHA_GridEditor.End(domID);
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
        },
        GrpGridColmuns: function () {
            var cols = [
                [
                    {
                        field: 'grpField',
                        title: 'grpField',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'grp',
                        title: 'grp',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'grpDesc',
                        title: '分组',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'inciCnt',
                        title: '品种数',
                        width: 50,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'dataCnt',
                        title: '记录数',
                        width: 50,
                        sortable: true,
                        align: 'right'
                    }
                ]
            ];
            return cols;
        },
        Pop: function (msg, type) {
            type = type || 'info';
            PHA.Popover({
                msg: msg,
                type: type
            });
        },
        // 批次调价窗口
        INCItmBatWin: function (iOpts, appendFunc) {
            iOpts = iOpts || {};
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'DrugBatRec_Detail_Win',
                        title: '药品批次信息',
                        width: $('body').width() * 0.85,
                        height: $('body').height() * 0.85
                    },
                    grid: {
                        north: {
                            title: '药品信息',
                            height: $('body').height() * 0.85 * 0.4,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'DrugDetail'
                            },
                            columns: [
                                [
                                    {
                                        title: 'inci',
                                        field: 'inci',
                                        width: 100,
                                        hidden: true
                                    },
                                    {
                                        title: '药品代码',
                                        field: 'inciCode',
                                        width: 100
                                    },
                                    {
                                        title: '药品名称',
                                        field: 'inciDesc',
                                        width: 200
                                    },

                                    {
                                        title: '规格',
                                        field: 'inciSpec',
                                        width: 160
                                    },
                                    {
                                        title: '入库单位',
                                        field: 'pUomDesc',
                                        width: 80,
                                        align: 'center'
                                    },
                                    {
                                        title: '贵重药',
                                        field: 'highValueFlag',
                                        width: 70,
                                        align: 'center',
                                        formatter: function (value, rowData, index) {
                                            if (value == 'Y') {
                                                return PHA_COM.Fmt.Grid.Yes.Chinese;
                                            } else {
                                                return PHA_COM.Fmt.Grid.No.Chinese;
                                            }
                                        }
                                    },
                                    {
                                        title: '处方通用名',
                                        field: 'geneName',
                                        width: 130
                                    },
                                    {
                                        title: '生产企业',
                                        field: 'manfName',
                                        width: 160
                                    },
                                    {
                                        title: '商品名',
                                        field: 'goodName',
                                        width: 130
                                    }
                                ]
                            ],
                            editFieldSort: ['aspRetRp', 'aspRetSp', 'aspReason'],
                            onCheck: function () {
                                $('#DrugBatRec_Detail_Win_center').datagrid('clearChecked');
                            }
                        },
                        center: {
                            title: '药品批次信息 - 双击行或按回车键返回 - 有效批次都放第一页',
                            pagination: false,
                            rownumbers: true,
                            url: PHA.$URL,
                            queryParams: {
                                pClassName: 'PHA.IN.ASPB.Api',
                                pMethodName: 'GetIncibDataRows',
                                pPlug: 'datagrid',
                                sort: 'ib',
                                order: 'desc'
                            },
                            onBeforeLoad: function (params) {
                                $(this).datagrid('options').url = 'websys.Broker.cls?ClassName=PHA.COM.Broker&MethodName=Invoke';
                                // console.log(typeof params.pJsonStr);
                                if (typeof params.pJsonStr !== 'undefined') {
                                    var pJson = JSON.parse(params.pJsonStr);
                                    pJson.hosp = session['LOGON.HOSPID'];
                                    params.pJsonStr = JSON.stringify(pJson);
                                }
                            },
                            toolbar: '#gridAspbBar4Win',
                            getDataWay: 'getChecked',
                            frozenColumns: [
                                [
                                    {
                                        title: '调价原因',
                                        field: 'aspReason',
                                        width: 150,
                                        descField: 'aspReasonDesc',
                                        formatter: function (value, row, index) {
                                            return row.aspReasonDesc;
                                        },
                                        editor: PHA_GridEditor.ComboBox({
                                            required: false,
                                            loadRemote: false,
                                            panelHeight: 'auto',
                                            url: PHA_IN_STORE.ReasonForAdjPrice().url
                                        })
                                    },
                                    {
                                        title: '调后进价',
                                        field: 'aspRetRp',
                                        width: 75,
                                        editor: PHA_GridEditor.NumberBox({
                                            required: false,
                                            checkValue: function (val, checkRet) {
                                                var validate = ASPB_COM.ValidatePrice(val, 'rp');
                                                if (validate !== true) {
                                                    checkRet.msg = validate;
                                                    return false;
                                                }
                                                return true;
                                            },
                                            onBeforeNext: function (val, gridRowData, gridRowIndex) {}
                                        })
                                    },
                                    {
                                        title: '调后售价',
                                        field: 'aspRetSp',
                                        width: 75,
                                        editor: PHA_GridEditor.NumberBox({
                                            required: false,
                                            checkValue: function (val, checkRet) {
                                                var validate = ASPB_COM.ValidatePrice(val, 'sp');
                                                if (validate !== true) {
                                                    checkRet.msg = validate;
                                                    return false;
                                                }
                                                return true;
                                            },
                                            onBeforeNext: function (val, gridRowData, gridRowIndex) {}
                                        })
                                    }
                                ]
                            ],
                            columns: [
                                [
                                    {
                                        field: 'gCheck',
                                        checkbox: true,
                                        hidden: false
                                    },
                                    {
                                        title: 'incib',
                                        field: 'incib',
                                        width: 100,
                                        hidden: true
                                    },
                                    {
                                        field: 'warnInfo',
                                        title: '提醒',
                                        width: 100,
                                        styler: function (value) {
                                            value = value || '';
                                            if (value !== '') {
                                                return 'background:red;color:#fff;';
                                            }
                                        }
                                    },
                                    {
                                        title: '批号',
                                        field: 'batNo',
                                        width: 110
                                    },
                                    {
                                        title: '效期',
                                        field: 'expDate',
                                        width: 100
                                    },
                                    {
                                        title: '生产企业',
                                        field: 'manfDesc',
                                        width: 100
                                    },
                                    {
                                        title: '经营企业',
                                        field: 'vendorDesc',
                                        width: 100
                                    },
                                    {
                                        title: '进价',
                                        field: 'pRp',
                                        width: 100,
                                        align: 'right'
                                    },
                                    {
                                        title: '售价',
                                        field: 'pSp',
                                        width: 100,
                                        align: 'right'
                                    },
				                    {
				                        field: 'zeroMarginFlag',
				                        title: '零加成标志',
				                        sortable: true,
				                        width: 100,
				                        hidden: true,
				                        align: 'center'
				                    },
                                    {
                                        field: 'maxSp',
                                        title: '最高售价',
                                        width: 75,
                                        sortable: true,
                                        align: 'right'
                                    }
                                ]
                            ],
                            onClickCell: function (index, field, value) {
                                var gOpts = $(this).datagrid('options');
                                var rowData = $(this).datagrid('getRows')[index];
                                if (rowData.banFlag === true) {
                                    return;
                                }
                                PHA_GridEditor.Edit({
                                    gridID: gOpts.id,
                                    index: index,
                                    field: field
                                });
                            },
                            loadFilter: function (data) {
                                var retRows = $('#gridAspb').datagrid('getRows');
                                var rows = data;
                                if (Array.isArray(rows)) {
                                    for (const row of rows) {
                                        var incib = row.incib;
                                        for (const retRow of retRows) {
                                            if (retRow.incib === incib) {
                                                row.warnInfo = '已存在';
                                                row.banFlag = true;
                                            }
                                        }
                                    }
                                }
                                return {
                                    total: rows.length,
                                    rows: rows
                                };
                            },

                            singleSelect: false,
                            editFieldSort: ['aspReason', 'aspRetRp', 'aspRetSp']
                        }
                    }
                }
            };
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-w-other');
        }
    };
    return function (type) {
        var pParams = [].slice.call(arguments, 1, arguments.length);
        // 注意apply 第一个参数this的变化, 此处默认this指window, 因此做改动
        return components[type].apply(components, pParams);
    };
};