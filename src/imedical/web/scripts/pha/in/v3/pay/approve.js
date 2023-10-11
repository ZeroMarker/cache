/**
 * 付款管理 - 预审
 * @creator 云海宝
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
                    title: '经营企业ID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'vendorDesc',
                    title: '经营企业',
                    width: 150,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'rpAmt',
                    title: '进价金额',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'paidAmt',
                    title: '已付款金额',
                    width: 100,
                    align: 'right',
                    sortable: true
                },
                {
                    field: 'needPayAmt',
                    title: '应付款金额',
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
                    title: '已审',
                    width: 40,
                    sortable: true,
                    align: 'center',
                    formatter: function (value) {
                        return value === 'Y' ? '是' : '否';
                    }
                },
                {
                    field: 'bizTypeDesc',
                    title: '类型',
                    width: 50,
                    sortable: true
                },
                {
                    field: 'no',
                    title: '单号',
                    width: 150,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'rpAmt',
                    title: '进价金额',
                    width: 100,
                    sortable: true,
                    align:'right'
                },

                {
                    field: 'payOverFlag',
                    title: '结清状态',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: '业务制单日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '业务制单时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createUserName',
                    title: '业务制单人',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditDate',
                    title: '业务审核日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditTime',
                    title: '业务审核时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'auditUserName',
                    title: '业务审核人',
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
                    title: '审核日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'payAllowedTime',
                    title: '审核时间',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'payAllowedUserName',
                    title: '审核人',
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
                    title: '类型',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 200,
                    sortable: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'manfDesc',
                    title: '生产企业',
                    width: 150,
                    sortable: true
                },
                {
                    field: 'batNo',
                    title: '批号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'expDate',
                    title: '效期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'qty',
                    title: '数量',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },

                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 75,
                    sortable: true
                },
                {
                    field: 'rp',
                    title: '进价',
                    width: 75,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'rpAmt',
                    title: '进价金额',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'sp',
                    title: '售价',
                    width: 75,
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
                    field: 'invNo',
                    title: '发票号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'invAmt',
                    title: '发票金额',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'invDate',
                    title: '发票日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'sxNo',
                    title: '随行单号',
                    width: 100,
                    sortable: true
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
                footer: [{ inciCode: '合计' }],
                total: 0
            },
            onLoadSuccess: function () {
                com.SumGridFooter('#gridBizItm', ['rpAmt', 'spAmt', 'invAmt']);
            }
        };
        PHA.Grid('gridBizItm', $.extend(dataGridOption, {}));
    }

    /**
     * 函数
     */

    function Approve() {
        var funcName = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (funcName === '') {
            return;
        }
        var bizArr = [];
        for (var it of $('#gridBiz').datagrid('getChecked')) {
            // 审批主表
            var rowData = $.extend({}, it);
            if (funcName == 'HandleApprove' && rowData.payAllowedFlag == 'Y') {
                components('Pop', '存在已经审核记录');
                return;
            }
            if (funcName == 'HandleApproveCancel' && rowData.payAllowedFlag != 'Y') {
                components('Pop', '存在未审核记录');
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
            components('Pop', '请先勾选记录', 'info');
            return
        }
        PHA.Loading('Show');
        com.Invoke(funcName, { bizArr: bizArr }, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '操作成功');
                // 删数据, 重加载
                // $('#gridBiz').datagrid('reload'); // 表格为本地加载
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

