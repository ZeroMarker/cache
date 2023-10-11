/**
 * ������� - Ԥ��
 * @creator �ƺ���
 */
$(function () {
    var biz = {
        data: {
            status: '',
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    approveStatus: 'N',
                    loc: session['LOGON.CTLOCID'],
                    bizType: ['G', 'R']
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
    var components = PAY_COMPONENTS();
    var com = PAY_COM;
    var settings = com.GetSettings();

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    components('Vendor', 'vendor');
    components('InvStatus', 'invStatus');
    components('BizType', 'bizType');
    components('ApproveStatus', 'approveStatus');
    InitGridVendor();
    InitGridBiz();
    InitGridBizItm();

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get')
        if (qJson === undefined){
            return
        }
        com.Invoke('GetVendorBizData', qJson, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                com.LoadData('gridVendor', {
                    pJson: JSON.stringify({ bizRows: retData }),
                    pMethodName: 'GetVendorRows4Approve'
                });
            }
        });
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridVendor, #gridBiz, #gridBizItm').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnApprove', 'click', function () {
        biz.setData('handleStatus', 'Approve');
        Approve();
    });
    PHA_EVENT.Bind('#btnApproveCancel', 'click', function () {
        biz.setData('handleStatus', 'ApproveCancel');
        Approve();
    });

    PHA_EVENT.Bind('#btnRefresh', 'click', function () {
        var bizItmArr = [];
        var chks = $('#gridBiz').datagrid('getChecked');
        for (chk of chks) {
            bizItmArr.push(chk.bizItms);
        }
        com.LoadData('gridBizItm', {
            pJson: JSON.stringify({ bizItms: bizItmArr }),
            pMethodName: 'GetVendorBizItmRows4Approve'
        });
    });
    function InitGridVendor() {
        var frozenColumns = [
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
                    width: 150,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'paidAmt',
                    title: '�Ѹ�����',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'needPayAmt',
                    title: 'Ӧ������',
                    width: 100,
                    align: 'right',
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
            frozenColumns: frozenColumns,
            rownumbers: true,
            columns: columns,
            toolbar: [],
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            onSelect: function (rowIndex, rowData) {
                $('#gridBiz').datagrid('clearChecked');
                com.LoadData('gridBiz', {
                    pJson: JSON.stringify({
                        condition: com.Condition('#qCondition', 'get'),
                        vendorRowData: rowData
                    }),
                    pMethodName: 'GetVendorBizRows4Approve'
                });
            },
            onLoadSuccess: function (data) {
                $('#gridBiz').datagrid('clear');
            }
        };
        PHA.Grid('gridVendor', $.extend(dataGridOption, {}));
    }
    function InitGridBiz() {
        var frozenColumns = [
            [
                {
                    field: 'bizCheck',
                    checkbox: true
                },
                {
                    field: 'payAllowedFlag',
                    title: '����',
                    width: 40,
                    sortable: true,
                    align: 'center',
                    formatter: function (value) {
                        return value === 'Y' ? '��' : '��';
                    }
                },
                {
                    field: 'bizTypeDesc',
                    title: '����',
                    width: 50,
                    sortable: true
                },
                {
                    field: 'no',
                    title: '����',
                    width: 150,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 100,
                    sortable: true,
                    align:'right'
                },

                {
                    field: 'payOverFlag',
                    title: '����״̬',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: 'ҵ���Ƶ�����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: 'ҵ���Ƶ�ʱ��',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createUserName',
                    title: 'ҵ���Ƶ���',
                    width: 100,
                    sortable: true
                },
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
                    field: 'bizPointerMain',
                    title: 'bizPointerMain',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'payAllowedDate',
                    title: '�������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'payAllowedTime',
                    title: '���ʱ��',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'payAllowedUserName',
                    title: '�����',
                    width: 75,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            frozenColumns: frozenColumns,
            toolbar: [],
            pageNumber: 1,
            pageSize: 100,
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            singleSelect: false,
            toolbar: '#gridBizBar',
            rownumbers: true,
            onClickRow: function (rowIndex, rowData) {
                if ($('#swRefreshType').switchbox('getValue') === true) {
                    $('#btnRefresh').trigger('click-i');
                }
            },
            onCheck: function () {
                AutoRefreshBizItm();
            },
            onUncheck: function () {
                AutoRefreshBizItm();
            },
            onCheckAll: function () {
                AutoRefreshBizItm();
            },
            onUncheckAll: function () {
                AutoRefreshBizItm();
            },
            onLoadSuccess: function (data) {
                $('#gridBizItm').datagrid('clear');
            }
        };
        PHA.Grid('gridBiz', $.extend(dataGridOption, {}));
        function AutoRefreshBizItm() {
            if ($('#swRefreshType').switchbox('getValue') === true) {
                $('#btnRefresh').trigger('click-i');
            }
        }
    }
    function InitGridBizItm() {
        var frozenColumns = [
            [
                {
                    field: 'bizTypeDesc',
                    title: '����',
                    width: 75,
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
                    width: 200,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 150,
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
                },
                {
                    field: 'qty',
                    title: '����',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },

                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 75,
                    sortable: true
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
                    width: 100,
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
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'invNo',
                    title: '��Ʊ��',
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
                    field: 'sxNo',
                    title: '���е���',
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
        var dataGridOption = {
            url: '',
            exportXls: false,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: '#gridBizItmBar',
            pageNumber: 1,
            pageSize: 999999,
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            showFooter: true,
            rownumbers: true,
            showComCol: true,
            data: {
                rows: [],
                footer: [{ inciCode: '�ϼ�' }],
                total: 0
            },
            onLoadSuccess: function () {
                com.SumGridFooter('#gridBizItm', ['rpAmt', 'spAmt', 'invAmt']);
            }
        };
        PHA.Grid('gridBizItm', $.extend(dataGridOption, {}));
    }

    /**
     * ����
     */

    function Approve() {
        var funcName = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (funcName === '') {
            return;
        }
        var bizArr = [];
        for (var it of $('#gridBiz').datagrid('getChecked')) {
            // ��������
            var rowData = $.extend({}, it);
            if (funcName == 'HandleApprove' && rowData.payAllowedFlag == 'Y') {
                components('Pop', '�����Ѿ���˼�¼');
                return;
            }
            if (funcName == 'HandleApproveCancel' && rowData.payAllowedFlag != 'Y') {
                components('Pop', '����δ��˼�¼');
                return;
            }
            var bizRow = {
                bizType: rowData.bizType,
                bizPointerMain: rowData.bizPointerMain
            };
            com.AppendLogonData(bizRow);
            bizArr.push(bizRow);
        }
        if (bizArr.length === 0){
            components('Pop', '���ȹ�ѡ��¼', 'info');
            return
        }
        PHA.Loading('Show');
        com.Invoke(funcName, { bizArr: bizArr }, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '�����ɹ�');
                // ɾ����, �ؼ���
                // $('#gridBiz').datagrid('reload'); // ���Ϊ���ؼ���
                $('#gridVendor').datagrid('selectRow', com.GetSelectedRowIndex('#gridVendor'));
            }
        });
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.pay.approve.csp');
    }, 0);
});

