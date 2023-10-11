/**
 * ��� - �Ƶ� - ���ݶ���
 * @creator �ƺ���
 */

$(function () {
    var biz = {
        data: {
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID'],
                    poRecStatus: ['0']
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = REC_COMPONENTS();
    var com = REC_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc');
    components('Loc', 'reqLoc', { onLoadSuccess: function () {} });
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Vendor', 'vendor');
    components('PORecStatus', 'poRecStatus');
    InitGridMain();
    InitGridItm();

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        if (qJson === undefined) {
            return;
        }
        com.LoadData('gridMain', {
            pJson: JSON.stringify(qJson),
            pMethodName: 'GetPOMainDataRows'
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        $('#gridItm').datagrid('clear');
        SetDefaults();
    });

    PHA_EVENT.Bind('#btnCopyGo', 'click', function () {
        CopyGo();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        Save();
    });
    function Save() {
        if (!PHA_GridEditor.End('gridItm')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        com.Invoke(com.Fmt2ApiMethod('Save4PO'), data4save, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.Top.Set('recID', retData.data);
                // window.location.href = 'pha.in.v3.plan.create.csp';
                PHA_COM.GotoMenu({
                    title: '����Ƶ�',
                    url: 'pha.in.v3.rec.create.csp'
                });
            }
        });
    }
    function CopyGo() {
        if (!PHA_GridEditor.End('gridItm')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        PHA.Confirm('��ʾ', '��ȷ�ϸ��ƹ�ѡ��¼���Ƶ�������</br>���������Ƶ���������޸�</br>��ע�⼰ʱ����', function () {
            com.Invoke(com.Fmt2ApiMethod('GenerateCreateData'), data4save, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    PHA_COM.TOP.Set('pha.in.v3.rec.create.csp_copy', retData);
                    if (top.$('#pha_in_v3_rec_createbypo_win').html()) {
                        top.$('#pha_in_v3_rec_createbypo_win').window('close');
                    } else {
                        PHA_COM.GotoMenu({
                            title: '����Ƶ�',
                            url: 'pha.in.v3.rec.create.csp'
                        });
                    }
                }
            });
        });
    }
    function ValidateNumber(num, type) {
        if (num === '') {
            return '����Ϊ��';
        }
        if (isNaN(num)) {
            return '��Ϊ����';
        }

        return true;
    }
    function GetSaveData() {
        var rows = [];
        for (const it of $('#gridItm').datagrid('getChecked')) {
            var rowData = $.extend({}, it);
            var inputQty = rowData.inputQty || '';
            if (ValidateNumber(inputQty) !== true) {
                continue;
            }
            rows.push({
                recID: '',
                recItmID: '',
                inci: rowData.inci,
                batNo: rowData.batNo,
                expDate: rowData.expDate,
                manf: rowData.manf,
                uom: rowData.uom,
                uomDesc: rowData.uomDesc,
                qty: rowData.inputQty,
                rp: rowData.rp,
                sxNo: rowData.sxNo,
                invNo: rowData.invNo,
                invDate: rowData.invDate,
                invAmt: rowData.invAmt,
                poItmID: rowData.poItmID,
                invCode: rowData.invCode
            });
        }
        if (rows.length === 0) {
            components('Pop', 'û�пɱ��������, ���ʵ�Ƿ���ȷ������������Ϣ');
            return false;
        }
        var mainSel = com.GetSelectedRow('#gridMain');
        var data4save = {
            main: {
                recID: '',
                loc: mainSel.loc,
                createUser: session['LOGON.CTLOCID'],
                stkCatGrp: mainSel.stkCatGrp,
                poID: mainSel.poID,
                vendor: mainSel.vendor
            },
            rows: rows
        };
        return data4save;
    }

    function InitGridMain() {
        var columns = [
            [
                {
                    field: 'poID',
                    title: 'poID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'recStateDesc',
                    title: '������',
                    width: 100,
                    sortable: true,
                    styler: function (value, rowData, rowIndex) {
                        if (rowData.recState === 'AllIn') {
                            return { class: 'pha-datagrid-td-trans-all' };
                        }
                        if (rowData.recState === 'PartIn') {
                            return { class: 'pha-datagrid-td-trans-part' };
                        }
                    }
                },
                {
                    field: 'no',
                    title: '��������',
                    width: 100,
                    sortable: true
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
                    width: 100,
                    sortable: true
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
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createUserName',
                    title: '�Ƶ���',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'needDate',
                    title: 'Ҫ�󵽻�����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'statusDesc',
                    title: '״̬',
                    width: 100,
                    sortable: true
                },

                {
                    field: 'remarks',
                    title: '��ע',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'labels',
                    title: '��ǩ',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishDate',
                    title: '�������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishTime',
                    title: '���ʱ��',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'finishUserName',
                    title: '�����',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: '#gridMainBar',
            pageNumber: 1,
            pageSize: 100,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            loadFilter: PHA.LocalFilter,
            // loadFilter: function (data) {
            //     if (data.success === 0) {
            //         PHA.Alert('����ʧ��', data.msg, 'error');
            //     }
            //     return data;
            // },
            onSelect: function (rowIndex, rowData) {
                com.LoadData('gridItm', {
                    pJson: JSON.stringify({ poID: rowData.poID }),
                    pMethodName: 'GetPOItmDataRows'
                });
            },
            onLoadSuccess: function () {
                $('#gridItm').datagrid('clear');
            }
        };
        PHA.Grid('gridMain', dataGridOption);
    }
    function InitGridItm() {
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
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 200,
                    sortable: true
                },

                {
                    field: 'inputQty',
                    title: 'Ԥ�������',
                    width: 100,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            return true;
                        },
                        onBlur: function (val, gridRowData, gridRowIndex) {
                            $('#gridItm').datagrid('updateRowData', {
                                index: gridRowIndex,
                                row: {
                                    rpAmt: _.safecalc('multiply', val, gridRowData.rp)
                                }
                            });
                        }
                    })
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'uom',
                    title: '��λ',
                    width: 75,
                    sortable: true,
                    descField: 'uomDesc',
                    formatter: function (value, row, index) {
                        return row.uomDesc;
                    }
                },
                {
                    field: 'manf',
                    title: '������ҵ',
                    width: 150,
                    sortable: true,
                    descField: 'manfDesc',
                    formatter: function (value, row, index) {
                        return row.manfDesc;
                    },
                    editor: PHA_GridEditor.ComboBox({
                        required: false,
                        tipPosition: 'top',
                        panelWidth: 'auto',
                        loadRemote: true,
                        url: PHA_STORE.PHManufacturer().url,
                        onBeforeLoad: function (param) {},
                        onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {}
                    })
                },
                {
                    field: 'rp',
                    title: '����',
                    width: 75,
                    sortable: true,
                    align: 'right'
                    // ,
                    // editor: PHA_GridEditor.NumberBox({
                    //     required: false,
                    //     checkValue: function (val, checkRet) {
                    //         return true;
                    //     },
                    //     onBeforeNext: function (val, gridRowData, gridRowIndex) {
                    //         var rp = val * 1;
                    //         var qty = gridRowData.qty * 1;
                    //         gridRowData.rpAmt = _.multiply(qty, rp);
                    //     }
                    // })
                },
                {
                    field: 'batNo',
                    title: '����',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({})
                },
                {
                    field: 'expDate',
                    title: 'Ч��',
                    width: 100,
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
                    width: 100,
                    sortable: true,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({})
                },
                {
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'qty',
                    title: '��������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'recedQty',
                    title: '���������',
                    width: 100,
                    sortable: true
                }
            ]
        ];

        var dataGridOption = {
            url: '',
            exportXls: false,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: '#gridItmBar',
            pageNumber: 1,
            pageSize: 10000,
            pagination: false,
            autoSizeColumn: true,
            editFieldSort: ['inputQty', 'rp', 'batNo', 'expDate'],
            showFooter: true,
            isAutoShowPanel: false, //
            allowEnd: true,
            singleSelect: false,
            onLoadSuccess: function (data) {
                PHA_GridEditor.End(this.id);
                $(this).datagrid('clearChecked');
                com.SumGridFooter(this.id, ['rpAmt', 'spAmt', 'invAmt']);
            },
            onClickCell: function (index, field, value) {
                PHA_GridEditor.Edit({
                    gridID: 'gridItm',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            }
        };
        PHA.Grid('gridItm', dataGridOption);
    }

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
	    $.extend(biz.getData('defaultData')[0], settings.DefaultData || {});
        SetDefaults();
        com.SetPage('pha.in.v3.rec.createbypo.csp');
        $('#btnFind').trigger('click-i');
    }, 0);
});

