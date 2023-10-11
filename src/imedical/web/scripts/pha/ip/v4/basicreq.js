/**
 * ���ұ���ҩ����
 * @author yunhaibao
 * @since  2023-02-23
 */
$(function () {
    PHA_COM.App.Csp = 'pha.ip.v4.basicdrug.csp';
    var PHA_IP_BASICDRUG = {
        WardFlag: session['LOGON.WARDID'] || '' != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: 't',
                endDate: 't',
                reqLoc: session['LOGON.CTLOCID']
            }
        ],
        HandleVars: {}
    };
    PHA.ComboBox('reqLoc', {
        url: PHA_STORE.CTLoc().url,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        }
    });
    // PHA.ComboBox('proLoc', {
    //     url: PHA_STORE.RelLocByRec(session['LOGON.CTLOCID']).url
    // });

    PHA_UX.ComboBox.Loc('proLoc', {
        qParams: {
            recLocId: PHA_UX.Get('reqLoc', session['LOGON.CTLOCID']), // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
            relType: 'TR'
        }
    });
    $('#btnFind').on('click', Query);
    $('#btnAddByJSDM, #btnAddByBASE').on('click', function (e) {
        var reqType = '';
        if (this.id == 'btnAddByJSDM') {
            reqType = 2;
        } else if (this.id == 'btnAddByBASE') {
            reqType = 1;
        }
        if (reqType === '') {
            return;
        }
        var lnk = 'pha.ip.v4.reqbyconsume.csp?reqType=' + reqType;
        websys_createWindow(lnk, '����', 'width=80%,height=80%');
    });
    $('#btnEdit').on('click', function () {
        // �½��Ŀ�ݷ�ʽ����
        var lnk = 'pha.in.v3.req.create.csp';
        websys_createWindow(lnk, '����', 'width=85%,height=85%');
    });
    PHA.SetVals(PHA_IP_BASICDRUG.DefaultData);
    InitGridMain();
    InitGridDetail();
    function InitGridMain() {
        var columns = [
            [
                {
                    field: 'reqID',
                    title: 'reqID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'reqNo',
                    title: '����',
                    // width: 150,
                    formatter: function (value) {
                        return '<div style="direction: rtl;overflow:hidden;">' + value + '</div>';
                    }
                },
                {
                    field: 'reqStatusDesc',
                    title: '����״̬',
                    align: 'center',
                    styler: function (value) {}
                },
                {
                    field: 'proLocDesc',
                    title: '��������',
                    width: 150
                },
                {
                    field: 'createUserName',
                    title: '�Ƶ���',
                    width: 75
                },
                {
                    field: 'createDateTime',
                    title: '�Ƶ�ʱ��',
                    width: 155
                },

                {
                    field: 'fromDateTime',
                    title: '���Ŀ�ʼʱ��',
                    width: 155
                },
                {
                    field: 'toDateTime',
                    title: '���Ľ���ʱ��',
                    width: 155
                },
                {
                    field: 'reqTypeDesc',
                    title: '��ʽ',
                    width: 100
                },
                {
                    field: 'transInfo',
                    title: '������Ϣ',
                    formatter: function (value, rowData, index) {
                        if (!value) {
                            return '';
                        }
                        if (rowData.reqTransStatus.indexOf('TRANS') >= 0) {
                            return '<a class="pha-grid-a js-grid-no">' + value + '</a>';
                        } else {
                            return value;
                        }
                    }
                },
                {
                    field: 'init',
                    title: '���ⵥID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'reqType',
                    title: '��������Id',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'reqTransStatus',
                    title: '����ĳ������״̬',
                    width: 100,
                    hidden: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            loadFilter: PHAIP_COM.LocalFilter,
            border: false,
            singleSelect: true,
            rownumbers: true,
            columns: columns,
            toolbar: '#gridMainBar',
            pageSize: 1000,
            pageList: [1000, 100, 300, 500],
            pagination: true,
            pageNumber: 1,
            onLoadSuccess: function () {
                $('#gridMain').datagrid('loaded');
            },
            onSelect: function () {
                QueryDetail();
            }
        };
        PHA.Grid('gridMain', dataGridOption);
        PHA.GridEvent('gridMain', 'click', ['pha-grid-a js-grid-no'], function (rowIndex, rowData, className) {
            if (className === 'pha-grid-a js-grid-no') {
                PHA_UX.BusiTimeLine(
                    {},
                    {
                        busiCode: 'TRANS',
                        pointer: rowData.init
                    }
                );
            }
        });
    }
    function InitGridDetail() {
        var columns = [
            [
                { field: 'reqItmID', title: 'reqItmID', width: 200, hidden: true },
                { field: 'inciCode', title: 'ҩƷ����', width: 100 },
                { field: 'inciDesc', title: 'ҩƷ����', width: 300 },
                { field: 'manfName', title: '������ҵ', width: 200 },
                { field: 'reqUomDesc', title: '��λ', width: 50 },
                { field: 'reqQty', title: '����', width: 100, align: 'right' },
                { field: 'unTransQty', title: 'δת������', width: 100, align: 'right' },
                { field: 'consumeQty', title: 'ԭ��������', width: 100, align: 'right' }
            ]
        ];
        var dataGridOption = {
            url: null,
            loadFilter: PHAIP_COM.LocalFilter,
            border: false,
            fitColumns: true,
            singleSelect: true,
            rownumbers: true,
            columns: columns,
            toolbar: [],
            pageSize: 1000,
            pageList: [1000, 100, 300, 500],
            pagination: false,
            pageNumber: 1,
            onLoadSuccess: function () {
                $('#gridDetail').datagrid('loaded');
            }
        };
        PHA.Grid('gridDetail', dataGridOption);
    }
    function Query() {
        var pJson = PHA_COM.Condition('#qCondition', 'get');
        if (typeof pJson === 'undefined') {
            return;
        }
        $('#gridMain').datagrid('loading');
        var sort = $('#gridMain').datagrid('options').sortName;
        var order = $('#gridMain').datagrid('options').sortOrder;
        $.cm(
            {
                ClassName: 'PHA.IP.BasicDrug.Api',
                MethodName: 'GetBasicReqRows',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1,
                sort: sort,
                order: order
            },
            function (rowsData) {
                $('#gridMain').datagrid('loadData', {
                    rows: rowsData,
                    total: rowsData.length
                });
            }
        );
    }
    function QueryDetail() {
        $('#gridDetail').datagrid('loading');
        var reqID = $('#gridMain').datagrid('getSelected').reqID;
        $.cm(
            {
                ClassName: 'PHA.IP.BasicDrug.Api',
                MethodName: 'GetBasicReqItmRows',
                pJsonStr: JSON.stringify({ reqID: reqID }),
                rows: 9999,
                page: 1
            },
            function (rowsData) {
                $('#gridDetail').datagrid('loadData', {
                    rows: rowsData,
                    total: rowsData.length
                });
            }
        );
    }
    setTimeout(() => {
        $('#btnFind').click();
    }, 500);
});
