/**
 * ���� - ͳһ�� - ���
 * @creator �ƺ���
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
         * ��������˽���
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
                // rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                data: [
                    { RowId: 'UN', Description: 'δ���' },
                    { RowId: 'PASS', Description: '�����' }
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
                        Description: '�Ƶ�����'
                    },
                    {
                        RowId: 'INASP_REASON_DR|reasonDesc',
                        Description: '����ԭ��'
                    },
                    {
                        RowId: 'INASP_SSUSR_DR|createUserName',
                        Description: '�Ƶ���'
                    },
                    {
                        RowId: 'INASP_ExecuteDate|executeDate',
                        Description: '��Ч����'
                    },
                    {
                        RowId: 'INASP_PreExeDate|preExecuteDate',
                        Description: '�ƻ���Ч����'
                    }
                ]
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
            $('#' + domID).combobox('setValues', ['INASP_Date']);
        },
        /**
         * ȫ��ģ������
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
                editFieldSort: ['inci', 'retUomRp', 'retUomSp', 'reason', 'preExecuteDate', 'remark'], // һ�㵥λ����ô�޸�, ��˲�����ת
                distinctFields: ['inci'],
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
                        title: '����',
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
                                //     PHA.Popover({ msg: '���ڱ༭�е��� �� ��' + (pos + 1) + '��ҩƷ�ظ�' });
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
                    },
                    {
                        field: 'uom',
                        title: '��λ',
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
                        title: '��ǰ����',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'priUomSp',
                        title: '��ǰ�ۼ�',
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
                        title: '<b>' + $g('�������') + '</b>',
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
                                    /* ������۲� */
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
                        title: '<b>' + $g('�����ۼ�') + '</b>',
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
                        title: '���۲�',
                        width: 75,
                        sortable: true,
                        align: 'right'
                        
                    },
                    {
                        field: 'diffSp',
                        title: '�ۼ۲�',
                        width: 75,
                        sortable: true,
                        align: 'right'          
                    },
                    {
                        field: 'diffPrice',
                        title: '���',
                        width: 75,
                        sortable: true,
                        hidden: true,
                        align: 'right'/*,
                        formatter: function (value, row, index) {
                            return _.toFixed(_.safecalc('add', row.retUomSp, _.safecalc('multiply', -1, row.retUomRp)), 2);  //��Ϊ��̨ȡֵ��ǰ̨ȡֵ��Ӱ��ǰ̨�����¼�
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
                        title: '�ӳ���',
                        width: 75,
                        sortable: true,
                        align: 'right',
                        formatter: function (value, row, index) {
	                        if(row.zeroMarginFlag && (value != '') && (parseFloat(value) != 1)){
		                        PHA.Msg('info', row.inciDesc + 'Ϊ��ӳ�ҩƷ,���ۼ۲���');
	                        }
	                        if (value > ASP_COM.GetSettings().App.Warn4PriceRate) return '<div style="color:red">' + value + '</div>';  
	                        else return value;
                            //return _.toFixed(_.safecalc('divide', row.retUomSp, row.retUomRp), 2); //��Ϊ��̨ȡֵ��ǰ̨ȡֵ��Ӱ��ǰ̨�����¼�
                        }
                    },
                    {
                        field: 'reason',
                        title: '����ԭ��',
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
                        title: '�ƻ���Ч����',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({
                            checkValue: function (value, checkRet) {
                                if (value === '') {
                                    checkRet.msg = '�ƻ���Ч����: ����������Ӧ�ڽ���֮��';
                                    return false;
                                }
                                if (value !== '') {
                                    if (!PHA_UTIL.CompareDate(value, '>', PHA_UTIL.GetDate('t'))) {
                                        checkRet.msg = '�ƻ���Ч����: Ӧ�ڽ���֮��';
                                        return false;
                                    }
                                }
                                return true;
                            }
                        })
                    },

                    {
                        field: 'remark',
                        title: '��ע',
                        width: 125,
                        sortable: true,
                        showTip:true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'warrentNo',
                        title: '����ļ���',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.ValidateBox({})
                    },
                    {
                        field: 'warrentNoDate',
                        title: '����ļ�������',
                        width: 125,
                        sortable: true,
                        editor: PHA_GridEditor.DateBox({})
                    },
                    {
                        field: 'invDate',
                        title: '��Ʊ����',
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
                        field: 'maxSp',
                        title: '����ۼ�',
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'hosp',
                        title: 'ҽԺ',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
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
                        field: 'auditDate',
                        title: '�������',
                        width: 100,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditDate') >= 0)
                    },
                    {
                        field: 'auditTime',
                        title: '���ʱ��',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditTime') >= 0)
                    },
                    {
                        field: 'auditUserName',
                        title: '�����',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('auditUserName') >= 0)
                    },
                    {
                        field: 'executeDate',
                        title: '��Ч����',
                        width: 100,
                        sortable: true,
                        hidden : (deleteField.indexOf('executeDate') >= 0)
                    },
                    {
                        field: 'executeTime',
                        title: '��Чʱ��',
                        width: 75,
                        sortable: true,
                        hidden : (deleteField.indexOf('executeTime') >= 0)
                    },
                    {
                        field: 'executeUserName',
                        title: '��Ч��',
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
                        title: '��������',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'markTypeDesc',
                        title: '��������',
                        sortable: true,
                        width: 100
                    },
                    {
                        field: 'zeroMarginFlag',
                        title: '��ӳɱ�־',
                        sortable: true,
                        width: 100,
                        hidden: true,
				        align: 'center'
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
                        title: '����',
                        width: 125,
                        sortable: true
                    },
                    {
                        field: 'inciCnt',
                        title: 'Ʒ����',
                        width: 50,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'dataCnt',
                        title: '��¼��',
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
        // ע��apply ��һ������this�ı仯, �˴�Ĭ��thisָwindow, ������Ķ�
        return components[type].apply(components, pParams);
    };
};
