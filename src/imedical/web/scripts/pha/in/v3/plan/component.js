/**
 * 采购计划通用组件
 * @creator 云海宝
 */
var PLAN_COMPONENTS = function () {
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
        },
        PlanNo: function (domID) {
            return this.No(domID);
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
        Vendor: function (domID, options) {
            options = options || {};
            var nOptions = $.extend({ panelWidth: 'auto' }, options);
            PHA_UX.ComboBox.Vendor(domID, nOptions);
        },
        OperateType: function (domID, options, callBack) {
            PHA.ComboBox(domID, {
                url: PHA_IN_STORE.OperateType('P').url,
                panelHeight: 'auto',
                editable: false,
                onLoadSuccess: function (rows) {
                    if (callBack) {
                        callBack(rows);
                    }
                }
            });
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                url: PHA_IN_STORE.BusiProcess('PLAN', 'ALL').url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
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
                url: PHA_IN_STORE.BusiProcess('PLAN', 'AUDIT').url,
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
        /* 订单状态 */
        PoStatus : function(domId, des){
			PHA.ComboBox(domId, {
		        width: 155,
		        panelHeight: 'auto',
		        data: [
	                { RowId: '', 		Description: '全部' },
	                { RowId: 'ONLY', 	Description: '生成' },
	                { RowId: 'NOT', 	Description: '未生成' },
	            ]
		    });
		},
        
        Remarks: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        RoundPercent: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        LimitRange: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox', //显示成勾选行形式
                data: [
                    { RowId: 'HospConsume', Description: '根据全院消耗' },
                    { RowId: 'HospStock', Description: '根据全院库存' },
                    { RowId: 'OnlyZB', Description: '仅招标药品' },
                    { RowId: 'ExcludeZB', Description: '非招标药品' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        BizRange: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox', //显示成勾选行形式
                data: [
                    { RowId: 'P,PH', Description: '住院发药' },
                    { RowId: 'Y,YH', Description: '住院退药' },
                    { RowId: 'F,FH', Description: '门诊发药' },
                    { RowId: 'H,HH', Description: '门诊退药' },
                    { RowId: 'T', Description: '转移出库' },
                    { RowId: 'K', Description: '转移入库' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        CommonRange: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox', //显示成勾选行形式
                data: [
                    { RowId: 'OnlyZB', Description: '仅招标药品' },
                    { RowId: 'ExcludeZB', Description: '非招标药品' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        RoundType: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                data: [
                    { RowId: 'RepLev', Description: '按补货标准　' },
                    { RowId: 'PurchUom', Description: '按包装单位　' },
                    { RowId: 'PackUom', Description: '按大包装单位' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        ReqType: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox', //显示成勾选行形式
                url: PHA_IN_STORE.ReqType().url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        ReqStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                rowStyle: 'checkbox', //显示成勾选行形式
                panelHeight: 'auto',
                multiple: true,
                editable: false,
                url: PHA_IN_STORE.ReqStauts('TRANS').url,
                loadFilter: function (rows) {
                    return rows.filter(function (ele, index) {
                        if (ele.RowId.indexOf('REFUSE') >= 0) {
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
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        Banner: function (domID, options) {
            if (typeof options === 'object') {
                var dataArr = [];
                if (options.mouldFlag === 'Y') {
                    dataArr.push({
                        info: '模板',
                        append: '/',
                        labelClass: 'info'
                    });
                }
                dataArr = dataArr.concat([
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
                ]);
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
                rownumbers: true,
                pagination: false,
                autoSizeColumn: true,
                shiftCheck: true,
                singleSelect: true,
                checkOnSelect: false, // 互不干扰, 应保持输入与勾选分开, 但是勾选还需要能分出信息
                selectOnCheck: false,
                showFooter: true,
                showComCol: true,
                footerSumFields: ['rpAmt', 'spAmt'],
                editFieldSort: ['inci', 'qty', 'manf', 'vendor', 'carrier', 'reqLoc', 'rp'],

                onLoadSuccess: function (data) {
                    PHA_GridEditor.End(this.id);
                    PLAN_COM.SumGridFooter('#' + this.id, ['rpAmt', 'spAmt']);
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    //PHA_UX.DrugDetail({}, { inci: rowData.inci });
	                PHA_UX.HospInciStock({},{
	                    inci: rowData.inci,
	                    inclb: rowData.inclb,
	                    inciDesc: rowData.inciDesc
	                });
                    return;
                }
            },
            function(){PHA_UX.HospInciStock({},{},"close")}
            );
        },
        ItmGridColmuns: function (gridID) {
            gridID = gridID || 'gridItm';
            // 解决editor内this不统一无法正常获取表格属性的问题
            function GridOptions() {
                return {
                    gridID: gridID,
                    $grid: $('#' + gridID)
                };
            }
            var frozenColumns = [
                [
                    {
                        field: 'planItmID',
                        title: 'planItmID',
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
                                    locId: $('#loc').combobox('getValue'), //采购制单需要能显示所有,先显示本科室的
                                    userId: session['LOGON.USERID'],
                                    notUseFlag: 'N',
                                    qtyFlag: '',
                                    reqLocId: $('#loc').combobox('getValue'),
                                    notCheckLoc: 'Y'
                                });
                            },
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                var fullDataObj = PLAN_COM.InvokeSyn('GetFullData4InputRow', {
                                    inci: cmbRowData.inci,
                                    loc: $('#loc').combobox('getValue'),
                                    hosp: gridRowData.hosp
                                });
                                if (PLAN_COM.ValidateApiReturn(fullDataObj) === false) {
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
                        field: 'qty',
                        title: '数量',
                        width: 75,
                        sortable: true,
                        align: 'right',

                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                max: 999999999,
                                // validType: 'planQty',
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: {
                                            rpAmt: _.safecalc('multiply', val, gridRowData.rp),
                                            spAmt: _.safecalc('multiply', val, gridRowData.sp)
                                        }
                                    });
                                },
                                checkValue: function (val, checkRet) {
                                    var validate = PLAN_COM.ValidateQty(val);
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
                        field: 'uom',
                        title: '单位',
                        width: 75,
                        sortable: true,
                        descField: 'uomDesc',
                        formatter: function (value, row, index) {
                            return row.uomDesc;
                        },
                        editor: PHA_UX.Grid.INCItmUom({
                            required: true,
                            loadRemote: false,

                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                var calcData = PLAN_COM.InvokeSyn('CalcData4InputRow', {
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
                        field: 'manf',
                        title: '生产企业',
                        width: 150,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row.manfDesc;
                        }/*,
                        editor: PHA_GridEditor.ComboBox({ // 医保政策要求，生产企业不允许编辑
                            required: false,
                            tipPosition: 'top',
                            panelWidth: 200,
                            loadRemote: false,
                            url: PHA_STORE.PHManufacturer().url
                        })*/
                    },
                    {
                        field: 'vendor',
                        title: '经营企业',
                        width: 150,
                        sortable: true,
                        descField: 'vendorDesc',
                        formatter: function (value, row, index) {
                            return row.vendorDesc;
                        },
                        editor: PHA_GridEditor.ComboBox({
                            required: true,
                            tipPosition: 'top',
                            panelWidth: 200,
                            url: PHA_STORE.APCVendor().url,
                            loadRemote: false
                        })
                    },
                    {
                        field: 'carrier',
                        title: '配送企业',
                        width: 150,
                        sortable: true,
                        descField: 'carrierDesc',
                        formatter: function (value, row, index) {
                            return row.carrierDesc;
                        },
                        editor: PHA_GridEditor.ComboBox({
                            panelWidth: 200,
                            url: PHA_STORE.DHCCarrier().url,
                            loadRemote: false,
                            localOnInit: true
                        })
                    },
                    {
                        field: 'reqLoc',
                        title: '申购科室',
                        width: 150,
                        sortable: true,
                        descField: 'reqLocDesc',
                        formatter: function (value, row, index) {
                            return row.reqLocDesc;
                        },
                        editor: PHA_GridEditor.ComboBox({
                            panelWidth: '200',
                            url: PHA_STORE.CTLoc().url,
                            loadRemote: false,
                            localOnInit: true
                        })
                    },
                    {
                        field: 'rp',
                        title: '进价333',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {                           
                                required: (PLAN_COM.GetSettings().App.RpNotNull == 'Y') ? true : false, // 取配置值，可以不必填
                                // validType: 'planPrice',
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: {
                                            rpAmt: _.safecalc('multiply', val, gridRowData.qty)
                                        }
                                    });
                                }/*,
                                checkValue: function (val, checkRet) {
                                    var validate = PLAN_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                }*/
                            })
                        )
                    },
                    {
                        field: 'rpAmt',
                        title: '进价金额',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },

                    {
                        field: 'minQty',
                        title: '库存下限',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'maxQty',
                        title: '库存上限',
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
                        field: 'locQty',
                        title: '采购科室库存',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'reqLocQty',
                        title: '申购科室库存',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'adviceQty',
                        title: '建议采购量',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'consumeQty',
                        title: '消耗量',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'poItmID',
                        title: '关联订单',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'spec',
                        title: '规格',
                        width: 75,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'insuCode',
                        title: '国家医保编码',
                        sortable: true
                    },
                    {
                        field: 'insuDesc',
                        title: '国家医保名称',
                        sortable: true
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
                isAutoShowPanel: false,
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
            // 时间轴

            PHA.GridEvent(domID, 'click', ['pha-grid-a js-grid-planNo'], function (rowIndex, rowData, className) {
                if (className === 'pha-grid-a js-grid-planNo') {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
                            busiCode: 'PLAN',
                            pointer: rowData.planID
                        }
                    );
                }
            },
            function(){
	            PHA_UX.BusiTimeLine({},{},"close")
            });
        },
        MainGridColmuns: function () {
            var frozenColumns = [
                [
                    {
                        field: 'planID',
                        title: 'planID',
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
                            return '<a class="pha-grid-a js-grid-planNo">' + value + '</a>';
                        }
                    },
                    {
                        field: 'locDesc',
                        title: '采购科室',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '采购类型',
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
                        // width: 100,
                        sortable: true,
                        formatter: function (val, rowData) {
                            // var nextInfo = rowData.nextStatusInfo || ''
                            // if (nextInfo !== ''){
                            //    return  '<div><div style="float:left">'+val+ '</div><div style="float:left;color:#fff;background:red">(' +nextInfo+ ')</div></div>'
                            // }
                            return val;
                        },
                        styler: function (val, rowData, rowIndex) {
                            // 如果含有拒绝应有颜色提醒
                            // if (rowData.nextStatusInfo)
                        }
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
                        field: 'status',
                        title: '状态代码',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'poFlag',
                        title: '已拆分订单',
                        width: 100,
                        sortable: true,
                        align: 'center',
                        formatter: PHA_GridEditor.CheckBoxFormatter
                    },
                    {
                        field: 'mouldFlag',
                        title: '模板标志',
                        // width: 100,
                        sortable: true,
                        hidden: true
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
                        field: 'newestStatusInfo',
                        title: '最新流转信息',
                        // width: '150',
                        sortable: true,
                        showTip: true,
                        // formatter:function(val){
                        //     // return '<div style="text-overflow: ellipsis;">'+val+'</div>'

                        // },
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
        FindPlanWindow: function (domID, options) {
            options = options || {};
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: '查询采购计划',
                width: $('body').width() * 0.85,
                height: $('body').height() * 0.85,
                modal: true,
                closable: true,
                collapsible: false,
                maximizable: false,
                minimizable: false,
                onClose: function () {},
                onOpen: function () {
                    $.data($('#' + this.id)[0], 'retData', {});
                }
            };
            $('#' + domID)
                .window($.extend({}, defOptions, options))
                .window('open');
            // 固定就是调的query.csp
            PHA_COM.ResizePanel({
                layoutId: 'layout-plan-query',
                region: 'north',
                height: 0.5
            });
        },
        FindPlanMouldWindow: function (domID, options) {
            options = options || {};
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: '查询模板',
                width: $('body').width() * 0.85,
                height: $('body').height() * 0.85,
                modal: true,
                closable: true,
                collapsible: false,
                maximizable: false,
                minimizable: false,
                onClose: function () {},
                onOpen: function () {
                    $.data($('#' + this.id)[0], 'retData', {});
                    try {
                        $('#btnFind-m').click();
                    } catch (error) {}
                }
            };
            $('#' + domID)
                .window($.extend({}, defOptions, options))
                .window('open');
        },
        PlanInfo: function () {},
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