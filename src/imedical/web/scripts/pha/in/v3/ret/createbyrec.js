/**
 * �˻� - �Ƶ� - ������� / ��Ŀ�Ķ���
 * @creator �ƺ���
 */

$(function () {
    if(self.frameElement.parentElement.id == "pha_in_v3_ret_createbyrec_win"){
        $("#mainDiv-rec").css('background-color', 'white');
    }
    var biz = {
        data: {
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID'],
                    recRetStatus: ['0']
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
    var components = RET_COMPONENTS();
    var com = RET_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Vendor', 'vendor');
    components('No', 'no');
    InitGridMain();
    InitGridItm();
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        com.LoadData('gridMain', {
            pJson: JSON.stringify(com.Condition('#qCondition', 'get')),
            pMethodName: 'GetRecMainDataRows'
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnCopyGo', 'click', function () {
        CopyGo();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        Save();
    });
    function Save() {
        if (!PHA_GridEditor.End('gridPlan')) {
            return;
        }
        var data4save = GetSaveData();
        if (data4save === false) {
            return;
        }
        com.Invoke(com.Fmt2ApiMethod('Save4Rec'), data4save, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.Top.Set('retID', retData.data);
                PHA_COM.GotoMenu({
                    title: '�˻��Ƶ�',
                    url: 'pha.in.v3.ret.create.csp'
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
                    PHA_COM.TOP.Set('pha.in.v3.ret.create.csp_copy', retData);
                    if (top.$('#pha_in_v3_ret_createbyrec_win').html()) {
                        top.$('#pha_in_v3_ret_createbyrec_win').window('close');
                    } else {
                        PHA_COM.GotoMenu({
                            title: '�˻��Ƶ�',
                            url: 'pha.in.v3.ret.create.csp'
                        });
                    }
                }
            });
        });
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
                retID: '',
                retItmID: '',
                recItmID: rowData.recItmID,
                inci: rowData.inci,
                batNo: rowData.batNo,
                expDate: rowData.expDate,
                manf: rowData.manf,
                uom: rowData.uom,
                qty: rowData.inputQty,
                rp: rowData.rp,
                sp: rowData.sp,
                sxNo: rowData.sxNo,
                invNo: rowData.invNo,
                invAmt: rowData.invAmt,
                invDate: rowData.invDate,
                invCode: rowData.invCode,
                reason: rowData.reason,
                reasonDesc: rowData.reasonDesc
            });
        }
        if (rows.length === 0) {
            components('Pop', 'û�пɱ��������, ���ʵ�Ƿ���ȷ������������Ϣ');
            return false;
        }

        var mainSel = com.GetSelectedRow('#gridMain');
        var data4save = {
            main: {
                retID: '',
                loc: mainSel.loc,
                createUser: session['LOGON.CTLOCID'],
                stkCatGrp: mainSel.stkCatGrp,
                vendor: mainSel.vendor,
                remarks: '������ⵥ' + mainSel.no
            },
            rows: rows
        };
        return data4save;
    }
    function InitGridMain() {
        var columns = [
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
                    width: 100,
                    sortable: true
                },
                {
                    field: 'locDesc',
                    title: '������',
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
                    field: 'auditDate',
                    title: '�������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditTime',
                    title: '���ʱ��',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditUserName',
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
            onSelect: function (rowIndex, rowData) {
                com.LoadData('gridItm', {
                    pJson: JSON.stringify({ recID: rowData.recID }),
                    pMethodName: 'GetRecItmDataRows'
                });
            },
            onLoadSuccess: function () {
                $('#gridItm').datagrid('clear');
            }
        };
        PHA.Grid('gridMain', dataGridOption);
    }
    // ��¼������������Ϊ��Ч������
    function InitGridItm() {
        var frozenColumns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'recItmID',
                    title: 'recItmID',
                    width: 100,
                    sortable: true,
                    hidden: true
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
                    descField: 'inciDesc',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'inputQty',
                    title: 'Ԥ�˻�����',
                    width: 100,
                    sortable: true,
                    editor: PHA_GridEditor.ValidateBox({
                        required: false,
                        checkValue: function (val, checkRet) {
                            if (_.isLikeNumber(val) === false) {
                                checkRet.msg = '����: ����������';
                                return false;
                            }
                            return true;
                        },
                        onBlur: function (val, gridRowData, gridRowIndex) {
                            $('#gridItm').datagrid('updateRowData', {
                                index: gridRowIndex,
                                row: {
                                    rpAmt: _.safecalc('multiply', val, gridRowData.rp),
                                    spAmt: _.safecalc('multiply', val, gridRowData.sp)
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
                    field: 'reason',
                    title: '�˻�ԭ��',
                    width: 150,
                    sortable: true,
                    descField: 'reasonDesc',
                    formatter: function (value, row, index) {
                        return row[this.descField];
                    },
                    editor: PHA_GridEditor.ComboBox({
                        required: false,
                        loadRemote: true,
                        panelHeight: 'auto',
                        url: PHA_IN_STORE.ReasonForReturn().url
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
                    }
                },
                {
                    field: 'rp',
                    title: '����',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'sp',
                    title: '�ۼ�',
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
                    }
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
            // editFieldSort: ['inci', 'qty', 'uom', 'rp'],
            showFooter: true,
            isAutoShowPanel: false,
            allowEnd: true,
            singleSelect: false,
            onLoadSuccess: function (data) {
                PHA_GridEditor.End('gridItm');
                $('#gridItm').datagrid('clearChecked');
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
        $.extend(biz.getData('defaultData')[0], settings.DefaultData ||{});
        SetDefaults();
        com.SetPage('pha.in.v3.ret.createbyrec.csp')
    }, 0);
});
function ValidateNumber(num, type) {
    if (num === '') {
        return '����Ϊ��';
    }
    if (isNaN(num)) {
        return '��Ϊ����';
    }

    return true;
}
