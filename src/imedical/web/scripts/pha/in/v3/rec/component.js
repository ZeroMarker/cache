/**
 * ��� - ���
 * @creator �ƺ���
 */
var REC_COMPONENTS = function () {
    var components = {
	    AppSettings : PHA_COM.ParamProp(REC_COM.AppCode),  //��д��������ȡ����������Ϣ��Ϊɶysj
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
                    LocId: PHA_UX.Get('loc', session['LOGON.CTLOCID']), // ֻ���߹����������ôд��Ч
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
                            PHA.Alert('��ʾ', vendorCertExpDateData, 'warning');
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
         * ��������˽���
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
                // rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
                    { RowId: 'N', Description: 'δ����' },
                    { RowId: 'Y', Description: '������' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, { placeholder: '��ע..' });
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
                    { RowId: '0', Description: 'δ���' },
                    { RowId: '0.5', Description: '�������' },
                    { RowId: '1', Description: '��ȫ�����' }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        /* ����һ */
		MZJY : function(domId, options){
			options = options || {};
			PHA.ComboBox(domId, {
		        width: 160,
		        panelHeight: 'auto',
		        data: [
	                { RowId: '', Description: 'ȫ��' },
	                { RowId: 'ONLY', Description: '��' },
	                { RowId: 'NOT', Description: '��' },
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
                        prepend: '�Ƶ�: ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc,
                        labelClass: 'info'
                    }
                ];
                if (options.poNo !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: '���ݶ���: ', info: options.poNo });
                }

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
                        PHA.Alert('��ʾ', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('��ʾ', data.rows[0], 'warning');
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
                    if(PHA_COM.ParamProp(REC_COM.AppCode).ShowInciRecList == 'Y'){ // �����ʷ������ʾ��������ʾ��ʷ������Ϣ
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
                                //     PHA.Popover({ msg: '���ڱ༭�е��� �� ��' + (pos + 1) + '��ҩƷ�ظ�' });
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
                        title: '��λ',
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
                                // ������, �����õ�����
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
                        title: '������ҵ',
                        width: 150,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row.manfDesc;
                        }/*,
                        editor: PHA_GridEditor.ComboBox({   // ҽ������Ҫ��������ҵ������༭
                            panelWidth: 200,
                            loadRemote: false,
                            url: PHA_STORE.PHManufacturer().url
                        })*/
                    },
                    {
                        field: 'rp',
                        title: '����',
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
	                                    PHA.Msg('info', gridRowData.inciDesc + 'Ϊ��ӳ�ҩƷ,���ۼ۲���');
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
                        title: '�ۼ�',
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
	                                    PHA.Msg('info', gridRowData.inciDesc + 'Ϊ��ӳ�ҩƷ,���ۼ۲���');
                                    }
                                }
                            })
                        )
                    },
                    {
                        field: 'rpAmt',
                        title: '���۽��', // ������༭, �ܱ༭��Ӧ���Ƿ�Ʊ���, ֮ǰһֱ��д���˵İ�
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
                        field: 'batNo',
                        title: '����',
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
                        field: 'expDate', // ��ҩûЧ��, ��δ���? Ĭ��9999һ����ʵ
                        title: 'Ч��',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({
                            required: true,
                            checkValue: function (value, checkRet) {
                                if (value !== '') {
                                    // Ч���߼����� ��Щ�Ǽ�ʱ˥�ܵ�
                                    // if (PHA_UTIL.CompareDate(value, '>', newDate()))
                                }
                                return true;
                            }
                        })
                    },
                    {
                        field: 'produceDate',
                        title: '��������',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'invNo',
                        title: '��Ʊ��',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'invDate',
                        title: '��Ʊ����',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'invCode',
                        title: '��Ʊ����',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'invAmt',
                        title: '��Ʊ���',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        editor: PHA_GridEditor.NumberBox({})
                    },
                    {
                        field: 'sxNo',
                        title: '���е���',
                        width: 100,
                        sortable: false,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'origin',
                        title: '����',
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
                        title: '�ӳ���',
                        width: 75,
                        sortable: true,
                        formatter: function (value, rowData, rowIndex) {
                            return ((rowData.sp)&&(rowData.rp)) ? parseFloat(_.safecalc('divide', rowData.sp, rowData.rp)).toFixed(4) : '';
                        }
                    },
                    {
                        field: 'diffAmt',
                        title: '���',
                        width: 75,
                        sortable: true,
                        formatter: function (value, rowData, rowIndex) {
                            var rpAmt = _.safecalc('multiply', rowData.rpAmt, -1);
                            return _.safecalc('add', rowData.spAmt, rpAmt);
                        }
                    },
                    {
                        field: 'zbFlag',
                        title: '�Ƿ��б�',
                        width: 75,
                        sortable: true,
                        align: 'center'	,
                        formatter: PHA_GridEditor.CheckBoxFormatter
                    },
                    {
                        field: 'markType',
                        title: '��������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'checkRemark',
                        title: 'ժҪ',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkPort',
                        title: '���ڰ�',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkRepNo',
                        title: '��ⱨ��',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkRepDate',
                        title: '��ⱨ������',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'checkAdmNo',
                        title: '����ע��֤��',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'checkAdmExpDate',
                        title: '����ע��֤��Ч��',
                        width: 100,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'insuCode',
                        title: '����ҽ������',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'insuDesc',
                        title: '����ҽ������',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'poItmID',
                        title: '��������ID',
                        sortable: true,
                        width: 150
                    },
                    {
                        field: 'zeroMarginFlag',
                        title: '��ӳɱ�־',
                        sortable: true,
                        width: 100,
                        hidden: true,
                        align: 'center'
                    }
                    
                ]
            ];
            // �����Ƿ��Ƕ�ѡ, ���¼��, ���Ƕ�Ӧ��ϸ
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
                        PHA.Alert('��ʾ', data.msg, 'warning');
                    } else {
                        if (data.rows.length > 0) {
                            if (typeof data.rows[0] === 'string') {
                                PHA.Alert('��ʾ', data.rows[0], 'warning');
                            }
                        }
                    }
                    return data;
                },
                onBeforeLoad: function (params) {
                    // ��У���������
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
                        title: '����',
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
                        title: '������',
                        width: 100,
                        sortable: true
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
                            panelWidth: 'auto',
                            required: true,
                            url: PHA_STORE.APCVendor().url
                        })
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '�������',
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
                        field: 'finishDate',
                        title: '�������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'finishDate',
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
                        field: 'auditDate',
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
                        field: 'purchUserName',
                        title: '�ɹ���',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'acceptUserName',
                        title: '������',
                        // width: 100,
                        sortable: true
                    },
                    {
                        field: 'acceptDate',
                        title: '��������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'remarks',
                        title: '��ע',
                        // width: 100,
                        sortable: true
                    },

                    {
                        field: 'rpAmt',
                        title: '���۽��',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'spAmt',
                        title: '�ۼ۽��',
                        width: 100,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'diffAmt',
                        title: '���',
                        width: 100,
                        sortable: true,
                        align: 'right'
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
                            if (val !== undefined) {
                                if (val.indexOf('�ܾ�') > 0) {
                                    return { class: 'pha-datagrid-status-warn' };
                                }
                            }
                        }
                    },
                    { 
                        field: 'mzjyFlag', 	
                        title: '����һ', 		
                        width: 80, 		
                        align: 'center'	,
                        formatter: PHA_GridEditor.CheckBoxFormatter //, 
                        //hidden: this.AppSettings.PoisonDoubleSign == 'Y' ? false : true
                    },
			        { 
                        field: 'mzjyAuditStatus', 	
                        title: '����һ��˱�־', 		
                        width: 200, 	
                        align: 'left'//,	
                        //hidden: this.AppSettings.PoisonDoubleSign == 'Y' ? false : true
                    },
                    {
                        field: 'recInfo',
                        title: '������Ϣ',
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
                title: 'ѡ����ⵥ',
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
        // ע��apply ��һ������this�ı仯, �˴�Ĭ��thisָwindow, ������Ķ�
        return components[type].apply(components, pParams);
    };
};