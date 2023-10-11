/**
 * �ɹ�����ͨ�����
 * @creator     �ƺ���
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
            PHA.ValidateBox(domID, { placeholder: '��ע..' });
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
                // rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                url: PHA_IN_STORE.BusiStatusResult().url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        /* ���״̬ */
        PORecStatus: function (domID, options) {
            options = options || {};
            var defaultOptions = {
	            width: 155,
                panelHeight: 'auto',
                editable: false,
                multiple: true,
                rowStyle: 'checkbox',
                data: [
                    { RowId: '0', Description: 'δ���' },
                    { RowId: '0.5', Description: '�������' },
                    { RowId: '1', Description: '��ȫ�����' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        
        
        /**
         * ȫ��ģ������
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
                        prepend: '�Ƶ�: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == '����' ? 'δ���' : options.statusDesc,
                        labelClass: options.statusDesc == '����' ? 'danger' : 'info'
                    }
                ];

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
                pagination: false,
                toolbar: [],
                pageNumber: 1,
                pageSize: 100,
                autoSizeColumn: true,
                shiftCheck: true,
                singleSelect: true,
                checkOnSelect: false, // ��������, Ӧ���������빴ѡ�ֿ�, ���ǹ�ѡ����Ҫ�ֳܷ���Ϣ
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
                                //     PHA.Popover({ msg: '���ڱ༭�е��� �� ��' + (pos + 1) + '��ҩƷ�ظ�' });
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
                        field: 'spec',
                        title: '���',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'qty',
                        title: '����',
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
                        title: '��λ',
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
                        title: '������ҵ',
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
                        title: '����',
                        width: 100,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox($.extend({}, $.fn.numberbox.defaults.phaOptions, {
                            required: (PLAN_COM.GetSettings().App.RpNotNull == 'Y') ? true : false, // ȡ��ɹ��ƻ���ֵ�����Բ�����
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
                        title: '���۽��',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'recedQty',
                        title: '���������',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'insuCode',
                        title: '����ҽ������',
                        sortable: true,
                        width: 150 //,
                        // showTip:true
                    },
                    {
                        field: 'insuDesc',
                        title: '����ҽ������',
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
                        title: '����',
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
                        title: '��������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'vendorDesc',
                        title: '��Ӫ��ҵ',
                        width: 200,
                        sortable: true
                    }
                ]
            ];
            var columns = [
                [
                    {
                        field: 'createDate',
                        title: '�Ƶ�����',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'createTime',
                        title: '�Ƶ�ʱ��',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'createUserName',
                        title: '�Ƶ���',
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
                        field: 'statusDesc',
                        title: '״̬',
                        width: 100,
                        sortable: true
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
                        field: 'needDate',
                        title: 'Ҫ�󵽻�����',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'reqLocDesc',
                        title: '�깺����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'recState',
                        title: '������',
                        width: 100,
                        sortable: true,
                        formatter: function (value, rowData) {
                            return rowData.recStateDesc;
                        }
                    },
                    {
                        field: 'remarks',
                        title: '��ע',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'newestStatusInfo',
                        title: '������ת��Ϣ',
                        // width: '150',
                        sortable: true,
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
        QueryWindow: function (domID, options) {
            options = options || {};
            var defOptions = {
                iconCls: 'icon-w-paper',
                title: 'ѡ��ɹ�����',
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
        // ע��apply ��һ������this�ı仯, �˴�Ĭ��thisָwindow, ������Ķ�
        return components[type].apply(components, pParams);
    };
};