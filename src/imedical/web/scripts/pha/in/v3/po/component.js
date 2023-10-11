/**
 * 采购订单通用组件
 * @creator     云海宝
 */
var PO_COMPONENTS = function () {
    var components = {
        Loc: function (domID, options) {
            options = options || {};
            options.blurValidValue = true;
            // options.enterNullValueClear=true;
            PHA_UX.ComboBox.Loc(domID, options);
        },
        StkCatGrp: function (domID, options) {
            options = options || {};
            var defOptions = {
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
        StkCat: function (domID, options) {
            options = options || {};
            var defOptions = {
                multiple: true,
                rowStyle: 'checkbox'
            };
            PHA_UX.ComboBox.StkCat(domID, $.extend(defOptions, options));
        },
        Poison: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.PHCPoison().url
            });
        },
        Date: function (domID) {
            PHA.DateBox(domID, {});
            $('#' + domID).datebox('setValue', 't');
        },
        User: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.SSUser().url
            });
        },
        No: function (domID) {
            PHA.ValidateBox(domID, {});
            $('#' + domID).attr('data-pha', ['class: "hisui-validatebox"', 'clear: true', 'query: true'].join(','));
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
            var nOptions = $.extend({ panelWidth: 'auto' }, options);
            PHA_UX.ComboBox.Vendor(domID, nOptions);
        },
        OperateType: function (domID) {
            PHA.ComboBox(domID, {
                url: PHA_STORE.APCVendor().url
            });
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                url: PHA_IN_STORE.BusiProcess('PO', 'ALL').url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        StatusText: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, { placeholder: '备注..' });
        },
        /**
         * 仅用于审核界面
         * @param {*} domID
         * @param {*} options
         */
        NextStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                url: PHA_IN_STORE.BusiProcess('PO', 'AUDIT').url,
                loadFilter: function (rows) {
                    return rows.filter(function (ele, index) {
                        console.log(ele.RowId);
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
        /* 入库状态 */
        PORecStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
	            width: 155,
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    { RowId: '0', Description: '未入库' },
                    { RowId: '0.5', Description: '部分入库' },
                    { RowId: '1', Description: '已全部入库' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        
        
        /**
         * 全局模糊检索
         */
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
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
                        prepend: '制单: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == '保存' ? '未完成' : options.statusDesc,
                        labelClass: options.statusDesc == '保存' ? 'danger' : 'info'
                    }
                ];

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
                pagination: false,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                shiftCheck: true,
                singleSelect: true,
                checkOnSelect: false, // 互不干扰, 应保持输入与勾选分开, 但是勾选还需要能分出信息
                selectOnCheck: false,
                editFieldSort: ['inci', 'qty', 'rp'],
                distinctFields: ['inci', 'rp'],
                footerSumFields: ['rpAmt'],
                isAutoShowPanel: false,
                allowEnd: true,
                showFooter: true,
                rownumbers: true,
                showComCol: true,
                data: {
                    rows: [],
                    footer: [],
                    total: 0
                },
                onLoadSuccess: function (data) {
                    var gridID = this.id;
                    PHA_GridEditor.End(gridID);
                    PO_COM.SumGridFooter('#' + gridID);
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
                        descField: 'inciDesc',
                        width: 200,
                        sortable: true,
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
                                    locId: $('#loc').combobox('getValue'),
                                    userId: session['LOGON.USERID'],
                                    notUseFlag: 'N',
                                    qtyFlag: '',
                                    reqLocId: '',
                                    notCheckLoc: 'Y'
                                });
                            },
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                // var pos = PHA_UTIL.Array.IsFieldsInArray($('#gridItm').datagrid('getRows'), { inci: cmbRowData.inci }, gridRowIndex);
                                // if (pos !== '') {
                                //     PHA.Popover({ msg: '正在编辑中的行 与 第' + (pos + 1) + '行药品重复' });
                                //     return false;
                                // }
                                var fullDataObj = PO_COM.InvokeSyn('GetFullData4InputRow', {
                                    inci: cmbRowData.inci,
                                    loc: $('#loc').combobox('getValue')
                                });
                                if (PO_COM.ValidateApiReturn(fullDataObj) === false) {
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
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'spec',
                        title: '规格',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'qty',
                        title: '数量',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.NumberBox({
                            required: true,
                            checkValue: function (val, checkRet) {
                                var validate = PO_COM.ValidateQty(val);
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
                                        rpAmt: _.safecalc('multiply', val, gridRowData.rp)
                                    }
                                });
                            }
                        })
                    },

                    {
                        field: 'uom',
                        title: '单位',
                        width: 100,
                        sortable: true,
                        descField: 'uomDesc',
                        formatter: function (value, row, index) {
                            return row.uomDesc;
                        },
                        editor: PHA_UX.Grid.INCItmUom({
                            required: true,
                            loadRemote: false,
                            blurValidValue: true,
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                var calcData = PO_COM.InvokeSyn('CalcData4InputRow', {
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
                            }
                        })
                    },
                    {
                        field: 'manf',
                        title: '生产企业',
                        width: 200,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row.manfDesc;
                        }
                        // ,
                        // editor: PHA_GridEditor.ComboBox({
                        //     required: false,
                        //     tipPosition: 'top',
                        //     panelWidth: 200,
                        //     loadRemote: false,
                        //     url: PHA_STORE.PHManufacturer().url
                        // })
                    },
                    {
                        field: 'rp',
                        title: '进价',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox($.extend({}, $.fn.numberbox.defaults.phaOptions, {
                            required: (PLAN_COM.GetSettings().App.RpNotNull == 'Y') ? true : false, // 取配采购计划置值，可以不必填
                            checkValue: function (val, checkRet) {
                                var validate = PO_COM.ValidatePrice(val);
                                if (validate !== true) {
                                    checkRet.msg = validate;
                                    return false;
                                }
                                return true;
                            }/*,
                            onBlur: function (val, gridRowData, gridRowIndex) {
                                GridOptions().$grid.datagrid('updateRowData', {
                                    index: gridRowIndex,
                                    row: {
                                        rpAmt: _.safecalc('multiply', val, gridRowData.qty)
                                    }
                                });
                            }*/
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
                        field: 'recedQty',
                        title: '已入库数量',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'insuCode',
                        title: '国家医保编码',
                        sortable: true,
                        width: 150 //,
                        // showTip:true
                    },
                    {
                        field: 'insuDesc',
                        title: '国家医保名称',
                        sortable: true,
                        width: 150 //,
                        // showTip:true
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
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
                isAutoShowPanel: true,
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
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            PHA.GridEvent(domID, 'click', ['pha-grid-a js-grid-poNo'], function (rowIndex, rowData, className) {
                if (className === 'pha-grid-a js-grid-poNo') {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
                            busiCode: 'PO',
                            pointer: rowData.poID
                        }
                    );
                }
            });
        },
        MainGridColmuns: function () {
            var frozenColumns = [
                [
                    {
                        field: 'poID',
                        title: 'poID',
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
                            return '<a class="pha-grid-a js-grid-poNo">' + value + '</a>';
                        }
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
                        width: 200,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'createDate',
                        title: '制单日期',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '制单时间',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '制单人',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '状态代码',
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
                        field: 'needDate',
                        title: '要求到货日期',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'reqLocDesc',
                        title: '申购科室',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'recState',
                        title: '入库情况',
                        width: 100,
                        sortable: true,
                        formatter: function (value, rowData) {
                            return rowData.recStateDesc;
                        }
                    },
                    {
                        field: 'remarks',
                        title: '备注',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'newestStatusInfo',
                        title: '最新流转信息',
                        // width: '150',
                        sortable: true,
                        styler: function (val) {
                            if (val.indexOf('拒绝') > 0) {
                                return { class: 'pha-datagrid-status-warn' };
                            }
                        }
                    }
                ]
            ];
            return {
                frozenColumns: frozenColumns,
                columns: columns
            };
        },
        QueryWindow: function (domID, options) {
            options = options || {};
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: '选择采购订单',
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
                layoutId: 'layout-po-query',
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
        }
    };
    return function (type) {
        var pParams = [].slice.call(arguments, 1, arguments.length);
        // 注意apply 第一个参数this的变化, 此处默认this指window, 因此做改动
        return components[type].apply(components, pParams);
    };
};