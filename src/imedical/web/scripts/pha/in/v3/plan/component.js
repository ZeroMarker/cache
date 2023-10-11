/**
 * �ɹ��ƻ�ͨ�����
 * @creator �ƺ���
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
         * ��������˽���
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
        /* ����״̬ */
        PoStatus : function(domId, des){
			PHA.ComboBox(domId, {
		        width: 155,
		        panelHeight: 'auto',
		        data: [
	                { RowId: '', 		Description: 'ȫ��' },
	                { RowId: 'ONLY', 	Description: '����' },
	                { RowId: 'NOT', 	Description: 'δ����' },
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
                rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                data: [
                    { RowId: 'HospConsume', Description: '����ȫԺ����' },
                    { RowId: 'HospStock', Description: '����ȫԺ���' },
                    { RowId: 'OnlyZB', Description: '���б�ҩƷ' },
                    { RowId: 'ExcludeZB', Description: '���б�ҩƷ' }
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
                rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                data: [
                    { RowId: 'P,PH', Description: 'סԺ��ҩ' },
                    { RowId: 'Y,YH', Description: 'סԺ��ҩ' },
                    { RowId: 'F,FH', Description: '���﷢ҩ' },
                    { RowId: 'H,HH', Description: '������ҩ' },
                    { RowId: 'T', Description: 'ת�Ƴ���' },
                    { RowId: 'K', Description: 'ת�����' }
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
                rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                data: [
                    { RowId: 'OnlyZB', Description: '���б�ҩƷ' },
                    { RowId: 'ExcludeZB', Description: '���б�ҩƷ' }
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
                    { RowId: 'RepLev', Description: '��������׼��' },
                    { RowId: 'PurchUom', Description: '����װ��λ��' },
                    { RowId: 'PackUom', Description: '�����װ��λ' }
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
                rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                url: PHA_IN_STORE.ReqType().url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        ReqStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
                rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
                // rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
                        info: 'ģ��',
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
                        prepend: '�Ƶ�: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == '����' ? 'δ���' : options.statusDesc,
                        labelClass: options.statusDesc == '����' ? 'danger' : 'info'
                    }
                ]);
                $('#' + domID).phabanner('loadData', dataArr);
            } else {
                $('#' + domID).phabanner({
                    title: $g('ѡ�񵥾ݺ�, ��ʾ��ϸ��Ϣ')
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
                checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
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
            // ���editor��this��ͳһ�޷�������ȡ������Ե�����
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
                        title: 'ҩƷ����',
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
                        title: 'ҩƷ����',
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
                                    locId: $('#loc').combobox('getValue'), //�ɹ��Ƶ���Ҫ����ʾ����,����ʾ�����ҵ�
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
                                    PHA.Alert('��ʾ', msgDataRows.join('</br>'), 'wanning');
                                    return;
                                }
                                if (msgDataRows.length > 0) {
                                    // �����ûص�
                                    PHA.Alert('��ʾ', msgDataRows.join('</br>'), 'info');
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
                        title: '����',
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
                        title: '��λ',
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
                        title: '������ҵ',
                        width: 150,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row.manfDesc;
                        }/*,
                        editor: PHA_GridEditor.ComboBox({ // ҽ������Ҫ��������ҵ������༭
                            required: false,
                            tipPosition: 'top',
                            panelWidth: 200,
                            loadRemote: false,
                            url: PHA_STORE.PHManufacturer().url
                        })*/
                    },
                    {
                        field: 'vendor',
                        title: '��Ӫ��ҵ',
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
                        title: '������ҵ',
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
                        title: '�깺����',
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
                        title: '����333',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox(
                            $.extend({}, $.fn.numberbox.defaults.phaOptions, {                           
                                required: (PLAN_COM.GetSettings().App.RpNotNull == 'Y') ? true : false, // ȡ����ֵ�����Բ�����
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
                        title: '���۽��',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },

                    {
                        field: 'minQty',
                        title: '�������',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'maxQty',
                        title: '�������',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'spAmt',
                        title: '�ۼ۽��',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'locQty',
                        title: '�ɹ����ҿ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'reqLocQty',
                        title: '�깺���ҿ��',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'adviceQty',
                        title: '����ɹ���',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'consumeQty',
                        title: '������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'poItmID',
                        title: '��������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'spec',
                        title: '���',
                        width: 75,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'insuCode',
                        title: '����ҽ������',
                        sortable: true
                    },
                    {
                        field: 'insuDesc',
                        title: '����ҽ������',
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
                        PHA.Alert('��ʾ', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('��ʾ', data.rows[0], 'warning');
                            }
                        }
                    }
                    return data;
                }
            };
            PHA.Grid(domID, $.extend(dataGridOption, opts));
            // ʱ����

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
                        title: '����',
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
                        title: '�ɹ�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '�ɹ�����',
                        width: 100,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'createDate',
                        title: '�Ƶ�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '�Ƶ�ʱ��',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '�Ƶ���',
                        width: 75,
                        sortable: true
                    },
                    {
                        field: 'finishDate',
                        title: '�������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishTime',
                        title: '���ʱ��',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishUserName',
                        title: '�����',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditDate',
                        title: '�������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditTime',
                        title: '���ʱ��',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'auditUserName',
                        title: '�����',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'statusDesc',
                        title: '״̬',
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
                            // ������оܾ�Ӧ����ɫ����
                            // if (rowData.nextStatusInfo)
                        }
                    },
                    {
                        field: 'statusDate',
                        title: '״̬��������',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusTime',
                        title: '״̬����ʱ��',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'statusUserName',
                        title: '״̬������',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'status',
                        title: '״̬����',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'poFlag',
                        title: '�Ѳ�ֶ���',
                        width: 100,
                        sortable: true,
                        align: 'center',
                        formatter: PHA_GridEditor.CheckBoxFormatter
                    },
                    {
                        field: 'mouldFlag',
                        title: 'ģ���־',
                        // width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'remarks',
                        title: '��ע',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'labels',
                        title: '��ǩ',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'newestStatusInfo',
                        title: '������ת��Ϣ',
                        // width: '150',
                        sortable: true,
                        showTip: true,
                        // formatter:function(val){
                        //     // return '<div style="text-overflow: ellipsis;">'+val+'</div>'

                        // },
                        styler: function (val) {
                            if (val.indexOf('�ܾ�') > 0) {
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
                title: '��ѯ�ɹ��ƻ�',
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
            // �̶����ǵ���query.csp
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
                title: '��ѯģ��',
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
        // ע��apply ��һ������this�ı仯, �˴�Ĭ��thisָwindow, ������Ķ�
        return components[type].apply(components, pParams);
    };
};