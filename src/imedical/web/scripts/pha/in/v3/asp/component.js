/**
 * 调价 - 统一价 - 组件
 * @creator 云海宝
 */
var ASP_COMPONENTS = function () {
    var components = {
        StkCatGrp: function (domID, options) {
            options = options || {};
            var defOptions = {
                simple: false,
                panelHeight: 'auto',
                multiple: true,
                rowStyle: 'checkbox',
                qParams: {
                    LocId: session['LOGON.CTLOCID'],
                    UserId: session['LOGON.USERID']
                }
            };
            PHA_UX.ComboBox.StkCatGrp(domID, $.extend(defOptions, options));
        },
        Date: function (domID) {
            PHA.DateBox(domID, {
                
            });
            $('#' + domID).datebox('setValue', 't');
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
        Reason: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_IN_STORE.ReasonForAdjPrice().url
            });
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                url: PHA_STORE.BusiProcess('ASP', session['LOGON.CTLOCID'], session['LOGON.USERID']).url
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
                url: PHA_STORE.BusiProcess('ASP', session['LOGON.CTLOCID'], session['LOGON.USERID']).url,
                loadFilter: function (rows) {
                    return rows.filter(function (ele, index) {
                        if (['SAVE', 'COMP', 'CANCEL', 'COPY'].indexOf(ele.RowId) >= 0) {
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
                    { RowId: 'UN', Description: '未审核' },
                    { RowId: 'PASS', Description: '已审核' }
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
        AspGrid: function (domID, opts, otherOpts) {
	        otherOpts = otherOpts || {};
            var columnsObj = this.AspGridColmuns(domID, otherOpts);

            var dataGridOption = {
                url: '',
                exportXls: false,
                columns: opts.columns ? opts.columns : columnsObj.columns,
                frozenColumns: opts.frozenColumns ? opts.frozenColumns : columnsObj.frozenColumns,
                toolbar: [],
                pageNumber: 1,
                rownumbers: true,
                allowEnd: true,
                isAutoShowPanel: false,
                selectOnCheck: false,
                checkOnSelect: false,
                editFieldSort: ['inci', 'retUomRp', 'retUomSp', 'reason', 'preExecuteDate', 'remark'], // 一般单位不怎么修改, 因此不做跳转
                distinctFields: ['inci'],
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
                    $(this).datagrid('loaded')
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode', 'pha-grid-a js-grid-aspNo'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    PHA_UX.DrugDetail({}, { inci: rowData.inci });
                    return;
                }
                if (className.indexOf('pha-grid-a js-grid-aspNo') >= 0) {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
	                        No: rowData.no,
                            busiCode: 'ASP',
                            pointer: rowData.aspID
                        }
                    );
                }
            });
        },
        AspGridColmuns: function (gridID, opts) {
            gridID = gridID || 'gridAsp';
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
                        field: 'aspID',
                        title: 'aspID',
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
                            return '<a class="pha-grid-a js-grid-aspNo">' + value + '</a>';
                        }
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
                        field: 'inci',
                        title: '药品名称',
                        width: 200,
                        sortable: true,
                        descField: 'inciDesc',
                        formatter: function (value, rowData, index) {
                            return rowData.inciDesc;
                        },
                        editor: PHA_UX.Grid.INCItm({
                            type: 'lookup',
                            required: true,
                            onBeforeLoad: function (param, gridRowData) {
                                param.hospId = session['LOGON.HOSPID'];
                                param.pJsonStr = JSON.stringify({
                                    stkType: App_StkType,
                                    scgId: $('#stkCatGrp').combobox('getValues').toString(),
                                    locId: session['LOGON.CTLOCID'],
                                    userId: session['LOGON.USERID'],
                                    notUseFlag: 'N',
                                    qtyFlag: '',
                                    notCheckLoc: 'Y'
                                });
                            },
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                // var pos = PHA_UTIL.Array.IsFieldsInArray($('#gridAsp').datagrid('getRows'), { inci: cmbRowData.inci }, gridRowIndex);
                                // if (pos !== '') {
                                //     PHA.Popover({ msg: '正在编辑中的行 与 第' + (pos + 1) + '行药品重复' });
                                //     return false;
                                // }
                                var fullDataObj = ASP_COM.InvokeSyn('GetFullData4InputRow', {
                                    inci: cmbRowData.inci,
                                    hosp: gridRowData.hosp
                                });
                                if (ASP_COM.ValidateApiReturn(fullDataObj) === false) {
                                    return;
                                }
                                var rowData = fullDataObj.rowData;
                                var msgData = fullDataObj.msgData;
                                var msgDataRows = msgData.rows;
                                if (msgData.type === 'terminate') {
                                    PHA.Alert('提示', msgDataRows.join('</br>'), 'wanning');
                                    return;
                                }
                                if (msgDataRows.length > 0) {
                                    // 不能用回调
                                    PHA.Alert('提示', msgDataRows.join('</br>'), 'info');
                                }
                                GridOptions().$grid.datagrid('updateRowData', {
                                    index: gridRowIndex,
                                    row: rowData
                                });
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
                        editor: PHA_UX.Grid.INCItmUom({
                            loadRemote: false,
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                var calcData = ASP_COM.InvokeSyn('CalcData4InputRow', {
                                    value: cmbRowData.RowId,
                                    rowData: gridRowData,
                                    trigger: {
                                        field: 'uom',
                                        type: 'onBeforeNext'
                                    }
                                });
                                GridOptions().$grid.datagrid('updateRowData', {
                                    index: gridRowIndex,
                                    row: calcData
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
                                    var validate = ASP_COM.ValidatePrice(val, 'rp');
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onEnter: function (val, gridRowData, gridRowIndex) {
                                    var calcData = ASP_COM.InvokeSyn('CalcData4InputRow', {
                                        rowData: gridRowData,
                                        value: val,
                                        trigger: {
                                            field: 'retUomRp',
                                            type: 'onEnter'
                                        }
                                    });
                                    /* 计算进价差 */
                                    var diffRp = _.safecalc('add', val, _.safecalc('multiply', -1, gridRowData.priUomRp))
                                    if (diffRp == 0) diffRp = "";
                                    calcData['diffRp'] = diffRp;
                                    var diffPrice = _.safecalc('add', gridRowData.retUomSp, _.safecalc('multiply', -1, val));
                                    calcData['diffPrice'] = diffPrice;
                                    if(gridRowData.retUomSp == '') var marginVal = '';
                                    else var marginVal = (parseFloat(gridRowData.retUomSp) == 0) ? 0 :  _.toFixed(_.safecalc('divide', gridRowData.retUomSp, val), 4);
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
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                maxPrecision: 8,
                                checkValue: function (val, checkRet) {
                                    var validate = ASP_COM.ValidatePrice(val, 'sp');
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
                                    if(gridRowData.retUomRp == '') var marginVal = '';
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
                        sortable: true,
                        hidden: true,
                        align: 'right'/*,
                        formatter: function (value, row, index) {
                            return _.toFixed(_.safecalc('add', row.retUomSp, _.safecalc('multiply', -1, row.retUomRp)), 2);  //改为后台取值，前台取值会影响前台联动事件
                        },
                        styler:function(value, rowData, rowIndex){
                            var rp = rowData.retUomRp;
                            var sp = rowData.retUomSp;
                            if (rp !== '' && !isNaN(rp) && sp !== '' && !isNaN(sp)) {
                                if (rp !== 0) {
                                    if (sp / rp > ASP_COM.GetSettings().App.Warn4PriceRate) {
                                        return { class: 'pha-datagrid-price-warning' };
                                    }
                                }
                                if (rp - sp > 0) {
                                    return { class: 'pha-datagrid-price-warning' };
                                }
                            }
                        }
                        */
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
	                        if (value > ASP_COM.GetSettings().App.Warn4PriceRate) return '<div style="color:red">' + value + '</div>';  
	                        else return value;
                            //return _.toFixed(_.safecalc('divide', row.retUomSp, row.retUomRp), 2); //改为后台取值，前台取值会影响前台联动事件
                        }
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
                        showTip:true,
                        editor: PHA_GridEditor.ValidateBox({})
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
                        field: 'invDate',
                        title: '发票日期',
                        width: 125,
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
                        field: 'maxSp',
                        title: '最高售价',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'hosp',
                        title: '医院',
                        width: 100,
                        sortable: true,
                        hidden: true
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
                        field: 'aspStatus',
                        title: 'aspStatus',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'markType',
                        title: '定价类型',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'markTypeDesc',
                        title: '定价类型',
                        sortable: true,
                        width: 100
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
                columns: columns,
                frozenColumns: frozenColumns
            };
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
                        width: 125,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'grp',
                        title: 'grp',
                        width: 125,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'grpDesc',
                        title: '分组',
                        width: 125,
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
        }
    };
    return function (type) {
        var pParams = [].slice.call(arguments, 1, arguments.length);
        // 注意apply 第一个参数this的变化, 此处默认this指window, 因此做改动
        return components[type].apply(components, pParams);
    };
};
