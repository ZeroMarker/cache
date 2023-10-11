/**
 * 入库 - 组件
 * @creator 云海宝
 */
var REC_COMPONENTS = function () {
    var components = {
	    AppSettings : PHA_COM.ParamProp(REC_COM.AppCode),  //不写成这样获取不到配置信息，为啥ysj
        Loc: function (domID, options) {
            options = options || {};
            //options.simple = true;
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
            defOptions = { 
            	url: PHA_IN_STORE.LocPurPlanUser().url,
            	onLoadSuccess: function (rows) {
                    if (rows.length) {
                        rows.forEach((element) => {
				            if (element.DefaultFlag === 'Y') {
				                $('#' + domID).combobox('setValue', element.RowId);
				            }
				        });
                    }
                }
            };
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
            var s = this.AppSettings;
            var def = {
                panelWidth: 'auto',
                panelHeight: $.fn.combobox.defaults.height * 10 + 5,
                onChange: function (newVal, oldVal) {     
                    if(REC_COM.GetSettings().App.ValVendorQualification == 'Y'){
                        var vendorCertExpDateObj = REC_COM.InvokeSyn('CheckVendorCertExpDate', {
                            vendor: newVal,                       
                        });
                        var vendorCertExpDateData = vendorCertExpDateObj.data
                        if (vendorCertExpDateData != '') {
                            PHA.Alert('提示', vendorCertExpDateData, 'warning');
                            setTimeout(function () { $('#' + domID).combobox('setValue', oldVal) }, 500);
                            return;
                        }
                    }
                }
            };
            $.extend(def, options);
            PHA_UX.ComboBox.Vendor(domID, $.extend(def, options));
        },
        OperateType: function (domID, options, callBack) {
            PHA.ComboBox(domID, {
                url: PHA_IN_STORE.OperateType('I').url,
                panelHeight: 'auto',
                editable: false,
                onLoadSuccess: function (rows) {
                    if (callBack) {
                        callBack(rows);
                    }
                }
            });
            PHA.DataPha.Set(domID, {
                class: 'hisui-combobox',
                query: true,
                clear: true
            });
        },
        Status: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                multiple: true,
                rowStyle: 'checkbox',
                editable: false,
                panelHeight: 'auto',
                url: PHA_STORE.BusiProcess('REC', session['LOGON.CTLOCID'], session['LOGON.USERID']).url
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
                url: PHA_STORE.BusiProcess('REC', session['LOGON.CTLOCID'], session['LOGON.USERID']).url,
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
        CheckInResult: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    { RowId: 'N', Description: '未验收' },
                    { RowId: 'Y', Description: '已验收' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, { placeholder: '备注..' });
        },
        FilterField: function (domID) {
            PHA.ValidateBox(domID, {});
        },
        PORecStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
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
        /* 麻醉精一 */
		MZJY : function(domId, options){
			options = options || {};
			PHA.ComboBox(domId, {
		        width: 160,
		        panelHeight: 'auto',
		        data: [
	                { RowId: '', Description: '全部' },
	                { RowId: 'ONLY', Description: '仅' },
	                { RowId: 'NOT', Description: '非' },
	            ]
		    });
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
                        info: options.statusDesc,
                        labelClass: 'info'
                    }
                ];
                if (options.poNo !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '依据订单: ', info: options.poNo });
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
                editFieldSort: ['inci', 'qty', 'batNo', 'expDate', 'rp', 'sp'],
                footerSumFields: ['rpAmt', 'spAmt', 'invAmt'],
                distinctFields: ['inciCode', 'batNo', 'invNo'],
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
                    // if ($(this).datagrid('options').view.type === 'scrollview'){
                    //     data.footer = PHA_COM.SumGridFooterData(this.id)
                    // }
                    return data;
                },
                onLoadSuccess: function (data) {
                    var gridID = this.id;
                    PHA_GridEditor.End(gridID);
                    if ($(this).datagrid('options').view.type !== 'scrollview'){
                        REC_COM.SumGridFooter(gridID, ['rpAmt', 'spAmt', 'invAmt']);
                    }
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            var eventClassArr = ['pha-grid-a js-grid-inciCode'];
            PHA.GridEvent(domID, 'click', eventClassArr, function (rowIndex, rowData, className) {
                if (className.indexOf('js-grid-inciCode') >= 0) {
                    if(PHA_COM.ParamProp(REC_COM.AppCode).ShowInciRecList == 'Y'){ // 如果历史批次显示开启则显示历史批次信息
		            	PHA_UX.InciRecList({}, { inci: rowData.inci });
	                }
                    else {
	                    PHA_UX.DrugDetail({}, { inci: rowData.inci });
                    }
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
                        field: 'recItmID',
                        title: 'recItmID',
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
                                    locId: $('#loc').combobox('getValue') || '',
                                    userId: session['LOGON.USERID'],
                                    notUseFlag: 'N',
                                    qtyFlag: '',
                                    reqLocId: $('#loc').combobox('getValue'),
                                    notCheckLoc: 'Y'
                                });
                            },
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                // var pos = PHA_UTIL.Array.IsFieldsInArray($('#gridItm').datagrid('getRows'), { inci: cmbRowData.inci }, gridRowIndex);
                                // if (pos !== '') {
                                //     PHA.Popover({ msg: '正在编辑中的行 与 第' + (pos + 1) + '行药品重复' });
                                // }
                                var fullDataObj = REC_COM.InvokeSyn('GetFullData4InputRow', {
                                    inci: cmbRowData.inci,
                                    loc: $('#loc').combobox('getValue')
                                });
                                if (REC_COM.ValidateApiReturn(fullDataObj) === false) {
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
                                checkValue: function (val, checkRet) {
                                    var validate = REC_COM.ValidateQty(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    var rowData = {
                                        rpAmt: _.safecalc('multiply', val, gridRowData.rp),
                                        spAmt: _.safecalc('multiply', val, gridRowData.sp)
                                    };
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: rowData
                                    });
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
                            panelHeight: 'auto',
                            loadRemote: false,
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                // 表格控制, 数据用单独起
                                var calcData = REC_COM.InvokeSyn('CalcData4InputRow', {
                                    value: cmbRowData.RowId,
                                    rowData: gridRowData,
                                    trigger: {
                                        field: 'uom',
                                        type: 'onBeforeNext'
                                    }
                                });
                                if (REC_COM.ValidateApiReturn(calcData) === true) {
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: calcData.rowData
                                    });
                                }
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
                        editor: PHA_GridEditor.ComboBox({   // 医保政策要求，生产企业不允许编辑
                            panelWidth: 200,
                            loadRemote: false,
                            url: PHA_STORE.PHManufacturer().url
                        })*/
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
                                    var validate = REC_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onEnter: function (val, gridRowData, gridRowIndex) {
                                    var calcData = REC_COM.InvokeSyn('CalcData4InputRow', {
                                        rowData: gridRowData,
                                        value: val,
                                        trigger: {
                                            field: 'rp',
                                            type: 'onEnter'
                                        }
                                    });
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: calcData
                                    });
                                    if((gridRowData.zeroMarginFlag)&&(val != "")&&(gridRowData.sp)&&(parseFloat(val)!=(parseFloat(gridRowData.sp)))){
	                                    PHA.Msg('info', gridRowData.inciDesc + '为零加成药品,进售价不符');
                                    }
                                }
                                
                                // onBlur: function (val, gridRowData, gridRowIndex) {
                                //     var rowData = {
                                //         rpAmt: _.safecalc('multiply', val, gridRowData.qty)
                                //     };
                                //     GridOptions().$grid.datagrid('updateRowData', {
                                //         index: gridRowIndex,
                                //         row: rowData
                                //     });
                                // }
                            })
                        )
                    },
                    {
                        field: 'sp',
                        title: '售价',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                                required: true,
                                checkValue: function (val, checkRet) {
                                    var validate = REC_COM.ValidatePrice(val);
                                    if (validate !== true) {
                                        checkRet.msg = validate;
                                        return false;
                                    }
                                    return true;
                                },
                                onBlur: function (val, gridRowData, gridRowIndex) {
                                    var rowData = {
                                        spAmt: _.safecalc('multiply', val, gridRowData.qty)
                                    };
                                    GridOptions().$grid.datagrid('updateRowData', {
                                        index: gridRowIndex,
                                        row: rowData
                                    });
                                    if((gridRowData.zeroMarginFlag)&&(val != "")&&(gridRowData.rp)&&(parseFloat(val)!=(parseFloat(gridRowData.rp)))){
	                                    PHA.Msg('info', gridRowData.inciDesc + '为零加成药品,进售价不符');
                                    }
                                }
                            })
                        )
                    },
                    {
                        field: 'rpAmt',
                        title: '进价金额', // 不允许编辑, 能编辑的应该是发票金额, 之前一直是写错了的吧
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
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({
                            checkValue: function (value, checkRet) {
                                value = value || '';
                                if (value === '') {
                                    checkRet.msg = validate;
                                    return false;
                                }
                                return true;
                            },
                            required: true
                        })
                    },
                    {
                        field: 'expDate', // 草药没效期, 如何处理? 默认9999一样其实
                        title: '效期',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({
                            required: true,
                            checkValue: function (value, checkRet) {
                                if (value !== '') {
                                    // 效期逻辑待定 有些是及时衰败的
                                    // if (PHA_UTIL.CompareDate(value, '>', newDate()))
                                }
                                return true;
                            }
                        })
                    },
                    {
                        field: 'produceDate',
                        title: '生产日期',
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
                        },
                        editor: PHA_GridEditor.ComboBox({
                            panelWidth: '200',
                            loadRemote: false,
                            url: PHA_STORE.DHCSTOrigin().url
                        })
                    },
                    {
                        field: 'margin',
                        title: '加成率',
                        width: 75,
                        sortable: true,
                        formatter: function (value, rowData, rowIndex) {
                            return ((rowData.sp)&&(rowData.rp)) ? parseFloat(_.safecalc('divide', rowData.sp, rowData.rp)).toFixed(4) : '';
                        }
                    },
                    {
                        field: 'diffAmt',
                        title: '差额',
                        width: 75,
                        sortable: true,
                        formatter: function (value, rowData, rowIndex) {
                            var rpAmt = _.safecalc('multiply', rowData.rpAmt, -1);
                            return _.safecalc('add', rowData.spAmt, rpAmt);
                        }
                    },
                    {
                        field: 'zbFlag',
                        title: '是否招标',
                        width: 75,
                        sortable: true,
                        align: 'center'	,
                        formatter: PHA_GridEditor.CheckBoxFormatter
                    },
                    {
                        field: 'markType',
                        title: '定价类型',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'checkRemark',
                        title: '摘要',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkPort',
                        title: '检测口岸',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkRepNo',
                        title: '检测报告',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkRepDate',
                        title: '检测报告日期',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'checkAdmNo',
                        title: '进口注册证号',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkAdmExpDate',
                        title: '进口注册证有效期',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
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
                    },
                    {
                        field: 'poItmID',
                        title: '订单关联ID',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'zeroMarginFlag',
                        title: '零加成标志',
                        sortable: true,
                        width: 100,
                        hidden: true,
                        align: 'center'
                    }
                    
                ]
            ];
            // 验收是否考虑多选, 表格录入, 而非对应明细
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
            PHA.GridEvent(domID, 'click', ['pha-grid-a js-grid-recNo'], function (rowIndex, rowData, className) {
                if (className === 'pha-grid-a js-grid-recNo') {
                    PHA_UX.BusiTimeLine(
                        {},
                        {
                            busiCode: 'REC',
                            pointer: rowData.recID
                        }
                    );
                }
            });
        },
        MainGridColmuns: function () {
            var frozenColumns = [
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
                        // width: 100,
                        sortable: true,
                        formatter: function (value, rowData, index) {
                            if (!value) {
                                return;
                            }
                            return '<a class="pha-grid-a js-grid-recNo">' + value + '</a>';
                        }
                    },
                    {
                        field: 'locDesc',
                        title: '入库科室',
                        width: 100,
                        sortable: true
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
                            panelWidth: 'auto',
                            required: true,
                            url: PHA_STORE.APCVendor().url
                        })
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '入库类型',
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
                        field: 'finishDate',
                        title: '完成日期',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishDate',
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
                        field: 'auditDate',
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
                        field: 'purchUserName',
                        title: '采购人',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'acceptUserName',
                        title: '验收人',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'acceptDate',
                        title: '验收日期',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'remarks',
                        title: '备注',
                        // width: 100,
                        sortable: true
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
                        field: 'mzjyFlag', 	
                        title: '麻醉精一', 		
                        width: 80, 		
                        align: 'center'	,
                        formatter: PHA_GridEditor.CheckBoxFormatter //, 
                        //hidden: this.AppSettings.PoisonDoubleSign == 'Y' ? false : true
                    },
			        { 
                        field: 'mzjyAuditStatus', 	
                        title: '麻醉精一审核标志', 		
                        width: 200, 	
                        align: 'left'//,	
                        //hidden: this.AppSettings.PoisonDoubleSign == 'Y' ? false : true
                    },
                    {
                        field: 'recInfo',
                        title: '更多信息',
                        // width: 300,
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
            options = options || {};
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: '选择入库单',
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
                layoutId: 'layout-rec-query',
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