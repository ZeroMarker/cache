/**
 * �˻� - ���
 * @creator �ƺ���
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
                // rowStyle: 'checkbox', //��ʾ�ɹ�ѡ����ʽ
                url: PHA_IN_STORE.BusiStatusResult().url
            };
            PHA.ComboBox(domID, $.extend(defaultOptions, options));
        },
        Remarks: function (domID) {
            PHA.ValidateBox(domID, { placeholder: '��ע..' });
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
                    { RowId: '0', Description: $g('δ�˻�') },
                    { RowId: '0.5', Description: $g('�����˻�') },
                    { RowId: '1', Description: $g('��ȫ���˻�') }
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
                        prepend: $g('�Ƶ�')+': ',
                        info: options.createUserName + ' ' + options.createDate + ' ' + options.createTime
                    },
                    {
                        info: options.statusDesc == $g('����') ? $g('δ���') : options.statusDesc,
                        labelClass: options.statusDesc == $g('����') ? 'danger' : 'info'
                    }
                ];
                if ((options.recNo || '') !== '') {
                    dataArr.push({ append: '/', info: '' });
                    dataArr.push({ prepend: $g('������ⵥ')+': ', info: options.recNo });
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
                        field: 'inciDesc', // ����Ҫ�����������descFieldת��
                        title: 'ҩƷ����',
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
                                // ���ڹرպ��Ƚ���onClickSure, �ֽ���onBeforeNext, ͳһʹ��onClickSure �������
                                onBeforeNext: function (retData, gridRowData, gridRowIndex) {
                                    // �����ڼ�¼˫����ֱ�ӷ��ش˴�, ��centerΪ����
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
                                        // ��ֱ����ʾ��ʾ, �Ͳ�ÿ��������, ������������
                                        // �ߵ�method , û��ҳ, �˴�dataֱ�Ӿ��� rows��
                                        var retRows = $('#gridItm').datagrid('getRows');
                                        var rows = data;
                                        if (Array.isArray(rows)) {
                                            for (const row of rows) {
                                                var recItmID = row.recItmID;
                                                for (const retRow of retRows) {
                                                    if (retRow.recItmID === recItmID) {
                                                        row.warnInfo = '�Ѵ���';
                                                        row.banFlag = true;
                                                    }
                                                    if (retRow.inclbAvaQty == 0) {
                                                        row.warnInfo = '���Ϊ��';
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
                        title: '���',
                        width: 100,
                        sortable: true
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
                            loadRemote: true,
                            required: true,
                            onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
                                if (cmbRowData.RowId === gridRowData.uom) {
                                    return true;
                                }
                                // ������, �����õ�����
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
                        title: '����',
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
                        title: '���ÿ��', // �����ʾȫԺ�ֲ�, �Լ�ռ����Ϣ?
                        width: 75,
                        sortable: true,
                        align: 'right'
                    },
                    {
                        field: 'reason',
                        title: '�˻�ԭ��',
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
                        title: '������ҵ',
                        width: 150,
                        sortable: true,
                        descField: 'manfDesc',
                        formatter: function (value, row, index) {
                            return row[this.descField];
                        }
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
                        title: '�ۼ�',
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
                        field: 'batNo',
                        title: '����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'expDate',
                        title: 'Ч��',
                        width: 100,
                        sortable: true
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
                        title: '�˷�Ʊ���', // ��Ʊ���
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
                        }
                    },

                    {
                        field: 'recItmID',
                        title: '����¼id', // @todo �����ӿɲ鿴�����ϸ��Ϣ
                        width: 100,
                        sortable: true
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
                    // ȫ�ֱ���, �����ڵ�����׷��������ʹ��
                    PHA_IN_RET_ROWINDEX = needUpdateRowIndex;
                }
                var defaultRow = {};
                for (var i = 0, length = recItmRows.length; i < length; i++) {
                    var ele = recItmRows[i];
                    // ѡ������β�����ѡ��, ���Ѿ������ڱ����߲����õ�, �߼�����һ������
                    if (ele.banFlag === true) {
                        continue;
                    }
                    // �˴���ε��ò��޴�, �п��ڸĳ�һ���Ե�
                    var msgData = RET_COM.GetFullData4InputRow(ele);

                    var mRowData = msgData.rowData;
                    var mMsgData = msgData.msgData;
                    var mMsgData_rows = mMsgData.rows;
                    if (mMsgData_rows.length > 0) {
                        // ���ڴ���ʾ��
                        // PHA.Alert('��ʾ', mMsgData_rows.join('</br>'), 'warning');
                        // return;
                    }
                    // �����|������߼�һ��, ��Ч�����, ����׷��
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
                        // ���ڹرպ�, ����������֤ onAfterEdit
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
                        title: '����',
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
                        title: '�˻�����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'vendorDesc',
                        title: '��Ӫ��ҵ',
                        width: 150,
                        sortable: true
                    },
                    {
                        field: 'operateTypeDesc',
                        title: '�˻�����',
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
                        field: 'retInfo',
                        title: '������Ϣ',
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
                title: 'ѡ���˻���',
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
        // ע��apply ��һ������this�ı仯, �˴�Ĭ��thisָwindow, ������Ķ�
        return components[type].apply(components, pParams);
    };
};
