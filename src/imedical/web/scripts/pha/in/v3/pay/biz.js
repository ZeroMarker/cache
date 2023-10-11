/**
 * ������� - Ӧ�����
 * @creator �ƺ���
 */
$(function () {
    var biz = {
        data: {
            approveStatus: ''
        },
        getData: function (key) {
            switch (key) {
                case 'loc':
                    return $('#loc').combobox('getValue');
                default:
                	return this.data[key];
                    break;
            }
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;

        }
    };
    var components = PAY_COMPONENTS();
    var com = PAY_COM;
    var settings = com.GetSettings();

    components('No', 'no-biz');
    components('Date', 'startDate-biz');
    components('Date', 'endDate-biz');
    components('Vendor', 'vendor-biz');
    
    components('Status', 'status-biz');
    components('InvNo', 'invNo-biz');
    components('FilterField', 'filterField-biz');
    InitMainGrid();
    InitItmGrid();

    PHA_EVENT.Bind('#btnFind-biz', 'click', function () {
        var qJson = com.Condition('#qCondition-biz', 'get');
        qJson.loc = biz.getData('loc');
        qJson.approveStatus = biz.getData('approveStatus')
        PHA.Loading('Show')
        com.Invoke('GetVendorBizData', qJson, function (retData) {
        PHA.Loading('Hide')

            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.LoadData('gridMain-biz', {
                    pJson: JSON.stringify({ bizRows: retData }),
                    pMethodName: 'GetVendorRows4Create'
                });
            }
        });
    });
    // PHA_EVENT.Bind('#btnClean-biz', 'click', function () {
    //     com.Condition('#qCondition-biz', 'clear');
    //     $('#gridMain-biz').datagrid('clear');
    // });
    PHA_EVENT.Bind('#btnRetClose-biz', 'click', function () {
        $('#winQueryBiz').window('close');
    });
    PHA_EVENT.Bind('#btnRetOk-biz', 'click', function () {
        if (!PHA_GridEditor.EndCheck('gridItm')) {
            return;
        }
        var mainSel = com.GetSelectedRow('#gridMain-biz');
        var chks = $('#gridItm-biz').datagrid('getChecked');
        if (chks.length === 0) {
            return;
        }
        var rows = [];
        for (var chk of chks) {
            var row = {};
            row.bizType = chk.bizType;
            row.bizPointer = chk.bizPointer;
            row.payAmt = chk.inputAmt;
            rows.push(row);
        }
        var pJson = {
            main: {
                loc: biz.getData('loc'), 
                vendor: mainSel.vendor
            },
            rows: rows
        };
        com.Invoke('HandleSave', pJson, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                PHA_IN_PAY_ID = retData.data;
                $('#btnRetClose-biz').click();
            }
        });
    });
    PHA_EVENT.Bind('#btnSum-biz', 'click', function () {
        SumCheckedInputAmt();
    });
    function InitMainGrid() {
        var columns = [
            [
                {
                    field: 'vendor',
                    title: '��Ӫ��ҵID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'vendorDesc',
                    title: '��Ӫ��ҵ',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'bizItms',
                    title: 'bizItms',
                    hidden: true,
                    width: 100,
                    align: 'right',
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            fitColumns: true,
            toolbar: [],
            pageNumber: 1,
            pageSize: 100,
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            rownumbers: true,
            onClickRow: function (rowIndex, rowData) {
                $('#gridItm-biz').datagrid('clearChecked');
                SumCheckedInputAmt()
                com.LoadData('gridItm-biz', {
                    pJson: JSON.stringify(rowData),
                    pMethodName: 'GetVendorBizItmRows4Create'
                });
            },
            onLoadSuccess: function (data) {
                $('#gridItm-biz').datagrid('clearChecked').datagrid('clear');
            }
        };
        PHA.Grid('gridMain-biz', $.extend(dataGridOption, {}));
    }

    function InitItmGrid() {
        var frozenColumns = [[
            {
                field: 'bizCheck',
                checkbox: true
            },
            {
                field: 'bizTypeDesc',
                title: '����',
                width: 60,
                align: 'center',
                sortable: true,
                styler: function (value, rowData) {
                    if (value === '�˻�') {
                        return 'background: #ee4f38;color:#fff;';
                    }
                }
            },
            {
                field: 'inputAmt',
                title: '������',
                width: 100,
                sortable: true,
                align:'right',
                editor: PHA_GridEditor.NumberBox({
                    required: false,
                    checkValue: function (val, checkRet) {
                        return true;
                    },
                    onBeforeNext: function (val, rowData, gridRowIndex) {
                        rowData.inputAmt = val;
                        if ($('#swRefreshType-biz').switchbox('getValue') === true) {
                            setTimeout(function () {
                                SumCheckedInputAmt();
                                // $('#btnSum-biz').click()                            // Ҳ�Ǵ����س�
                            }, 0);
                        }
                    },
                    onEnter: function (val, rowData) {}
                })
            },
            {
                field: 'invNo',
                title: '��Ʊ��',
                width: 100,
                sortable: true
            },

            {
                field: 'no',
                title: '����',
                // width: 100,
                sortable: true
            }
        ]]
        var columns = [
            [
                
                {
                    field: 'auditDate',
                    title: 'ҵ���������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditTime',
                    title: 'ҵ�����ʱ��',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditUserName',
                    title: 'ҵ�������',
                    width: 100,
                    sortable: true
                },

                {
                    field: 'invAmt',
                    title: '��Ʊ���',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'invDate',
                    title: '��Ʊ����',
                    width: 100,
                    sortable: true
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
                    width: 100,
                    sortable: true
                },
                {
                    field: 'spec',
                    title: '���',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'qty',
                    title: '����',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },

                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'rp',
                    title: '����',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'paidAmt',
                    title: '�Ѹ����',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'restAmt',
                    title: '�������',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'sp',
                    title: '�ۼ�',
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
                    field: 'sxNo',
                    title: '���е���',
                    width: 100,
                    sortable: true
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
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            frozenColumns: frozenColumns,
            toolbar: '#gridItm-bizBar',
            pageNumber: 1,
            pageSize: 999999,
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            showFooter: true,
            singleSelect: false,
            showFooter:true,
            editFieldSort: ['inputAmt'],
            footerSumFields:['rpAmt', 'spAmt', 'invAmt'],
            allowEnd:true,
            loadFilter:PHA.LocalFilter,
            //idField:'inciCode',
            onClickCell: function (index, field, value) {
                PHA_GridEditor.Edit({
                    gridID: 'gridItm-biz',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onCheck: function (rowIndex, rowData) {
                SumCheckedInputAmt()
            },
            onUncheck: function (rowIndex, rowData) {
                SumCheckedInputAmt()
            },
            onCheckAll: function () {
                SumCheckedInputAmt()
            },
            onUncheckAll: function () {
                SumCheckedInputAmt()
            },
            onLoadSuccess: function () {
                // $(this).datagrid('clearChecked');
                com.SumGridFooter('#' + this.id);
                $(this).datagrid('loaded')
            }
        };
        PHA.Grid('gridItm-biz', $.extend(dataGridOption, {}));
    }
    function SumCheckedInputAmt() {
        if (!PHA_GridEditor.EndCheck('gridItm')) {
            return
        }
        var total = 0;
        for (var chk of $('#gridItm-biz').datagrid('getChecked')) {
            var inputAmt = chk.inputAmt;
            if (!isNaN(inputAmt)) {
                total += inputAmt * 1;
            }
        }
        $('#gridItm-biz-amt-sum').text(total);
    }
    function SetDefaults() {
        var defaultValObj = settings.DefaultValues;
        defaultValObj['startDate-biz'] = defaultValObj.startDate;
        defaultValObj['endDate-biz'] = defaultValObj.endDate;
        PHA.SetVals([defaultValObj]);
    }

    setTimeout(function () {
        SetDefaults();
        if (settings.App.ApprovalFlag === '1'){
            biz.setData('approveStatus','Y')
        }
        com.SetPage('pha.in.v3.pay.biz.csp');
        // @automatic
        // $('##btnFind-biz').trigger('click-i')
    }, 0);
});
