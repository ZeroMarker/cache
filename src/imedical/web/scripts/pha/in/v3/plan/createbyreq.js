/**
 * �ɹ��ƻ� - �����ƻ� - ��������
 * @creator �ƺ���
 */
$(function () {
    var biz = {
        data: {
            planData: [],
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-3'),
                    endDate: PHA_UTIL.GetDate('t'),
                    loc: session['LOGON.CTLOCID'],
                    reqLoc: '',
                    reqType: ['C'],
                    reqStatus: ['COMP']
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
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    var settings = com.GetSettings();

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    components('Loc', 'reqLoc', { onLoadSuccess: function (data) {} });
    components('ReqStatus', 'reqStatus');
    components('ReqType', 'reqType');
    InitGridReq();
    InitGridReqItm();
    InitGridPlan();

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        if (qJson === undefined) {
            return;
        }
        $('#gridReqItm, #gridPlan').datagrid('clear').datagrid('clearChecked');
        com.QueryGrid('gridReq', 'GetReqMainDataRows', qJson);
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridReq, #gridReqItm, #gridPlan').datagrid('clear').datagrid('clearChecked');
        SetDefaults();
    });

    PHA_EVENT.Bind('#btnReqItm2Plan', 'click', function () {
        HandleReqItm2Plan();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        if ($('#gridPlan').datagrid('getChecked').length === 0) {
            components('Pop', '���ȹ�ѡ��Ҫ����ļ�¼');
            return;
        }
        var includeInciArr = [];
        $('#gridPlan')
            .datagrid('getChecked')
            .forEach(function (ele) {
                includeInciArr.push(ele.inci);
            });

        PHA.Confirm('��ʾ', '��ȷ�ϱ��湴ѡ��¼Ϊ�ɹ��ƻ���?', function () {
            var data4save = {
                main: {},
                rows: biz.getData('planData'),
                includeInciArr: includeInciArr
            };
            com.Invoke('HandleSave4Req', data4save, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    com.Top.Set('planID', retData.data);
                    PHA_COM.GotoMenu({
                        title: '�ɹ��ƻ��Ƶ�',
                        url: 'pha.in.v3.plan.create.csp'
                    });
                }
            });
        });
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
    function HandleReqItm2Plan(flag) {
        var itmRows = $('#gridReqItm').datagrid('getRows');
        if (itmRows.length === 0) {
            components('Pop', '������ϸû������, �޷�����');
            return;
        }
        var reqItmArr = [];
        itmRows.forEach(function (row) {
            reqItmArr.push({
                inrqiId: row.inrqiId,
                qty: row.qty,
                uom: row.uom
            });
        });

        var itmCheckedRows = $('#gridReqItm').datagrid('getChecked');
        var reqItmCheckedArr = [];
        itmCheckedRows.forEach(function (row) {
            reqItmCheckedArr.push({
                inrqiId: row.inrqiId,
                qty: row.qty,
                uom: row.uom
            });
        });

        var planReqItmArr = biz.getData('planData');
        var newArr = ArrayRemove(planReqItmArr, reqItmArr, 'inrqiId');
        newArr = ArrayDistinctConcat(newArr, reqItmCheckedArr, 'inrqiId');
        biz.setData('planData', newArr);
        $('#gridReq').datagrid('refreshRow', com.GetSelectedRowIndex('#gridReq'));
        LoadPlanRows();
    }
    function LoadPlanRows() {
        var reqItmArr = biz.getData('planData');
        PLAN_COM.LoadData('gridPlan', {
            pMethodName: 'SumReqItm4PlanDataRows',
            pJson: JSON.stringify({
                reqItmArr: reqItmArr,
                loc: $('#loc').combobox('getValue')
            })
        });
    }

    function ArrayDistinctConcat(arr1, arr2, idKey) {
        var rows = arr1.concat(arr2);
        var tmpIdKeyArr = [],
            idKeyValue,
            existFlag;
        return rows.filter(function (row) {
            idKeyValue = row[idKey];
            if (tmpIdKeyArr.indexOf(idKeyValue) < 0) {
                existFlag = false;
            } else {
                existFlag = true;
            }
            tmpIdKeyArr.push(idKeyValue);
            return !existFlag;
        });
    }
    function ArrayRemove(arr1, arr2, idKey) {
        var tmpIdKeyArr = [];
        arr2.forEach(function (ele) {
            tmpIdKeyArr.push(ele[idKey]);
        });
        return arr1.filter(function (row) {
            idKeyValue = row[idKey];
            if (tmpIdKeyArr.indexOf(idKeyValue) < 0) {
                return true;
            }
            return false;
        });
    }

    function IsReqInPlan(reqID) {
        var data = biz.getData('planData');
        if (Array.isArray(data)) {
            for (var i = 0, length = data.length; i < length; i++) {
                var iData = data[i];
                if (reqID === iData.inrqiId.split('||')[0]) {
                    return true;
                }
            }
        }

        return false;
    }
    function IsReqItmInPlan(reqItmID) {
        var data = biz.getData('planData');
        if (Array.isArray(data)) {
            for (var i = 0, length = data.length; i < length; i++) {
                var iData = data[i];
                if (reqItmID === iData.inrqiId) {
                    return true;
                }
            }
        }
        return false;
    }

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        biz.setData('planData', []);
    }

    function Approve() {
        var funcName = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (funcName === '') {
            return;
        }
        var bizItmsArr = [];
        for (var rowData of $('#gridBiz').datagrid('getChecked')) {
            bizItmsArr = bizItmsArr.concat(rowData.bizItms);
        }

        var saveJson = {
            main: {},
            bizItms: bizItmsArr
        };
        com.Invoke(funcName, saveJson, function (retData) {
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                components('Pop', '��˳ɹ�');
                $('#gridBiz').datagrid('reload');
            }
        });
    }

    function InitGridReq() {
        var columns = [
            [
                {
                    field: 'inrqId',
                    title: 'inrqId',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'reqTypeDesc',
                    title: '����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'proLocDesc',
                    title: '�ɹ�����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'recLocDesc',
                    title: '�깺����',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'statusDesc',
                    title: 'ת��״̬',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: '��������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '����ʱ��',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'creator',
                    title: '������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'reqNo',
                    title: '���󵥺�',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'remarks',
                    title: '����ע',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: '#gridReqBar',
            pageNumber: 1,
            rownumbers: true,
            pageSize: 100,
            onSelect: function (rowIndex, rowData) {
                QueryReqItm();
            },
            onLoadSuccess: function (data) {
                biz.setData('planData', []);
                $('#gridReqItm').datagrid('clear');
            },
            rowStyler: function (rowIndex, rowData) {
                var reqID = rowData.inrqId;
                if (IsReqInPlan(reqID) === true) {
                    return { class: 'pha-datagrid-req-used' };
                }
            }
        };
        PHA.Grid('gridReq', $.extend(dataGridOption, {}));
        function QueryReqItm() {
            var pJson = com.Condition('#qCondition', 'get');
            pJson.reqID = com.GetSelectedRow('#gridReq', 'inrqId');
            com.QueryGrid('gridReqItm', 'GetReqItmDataRows', pJson);
        }
    }
    function InitGridReqItm() {
        var columns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },

                {
                    field: 'inrqiId',
                    title: 'inrqiId',
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
                    width: 100,
                    sortable: true
                },
                {
                    field: 'adviceQty',
                    title: '����ɹ�����',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'qty',
                    title: '��������',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'transedQty',
                    title: '��ת������',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'reqLocQty',
                    title: '������ҿ��',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'locQty',
                    title: '�������ҿ��',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'manfName',
                    title: '������ҵ',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: [],
            pageNumber: 1,
            pageSize: 100,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            singleSelect: false,
            pagination: false,
            toolbar: '#gridReqItmBar',
            rownumbers: true,
            onClickRow: function (rowIndex, rowData) {
                // if ($('#swRefreshType').switchbox('getValue') === true) {
                //     $('#btnRefresh').click();
                // }
            },
            onLoadSuccess: function (data) {
                // $('#gridBizItm').datagrid('clear');
                $(this).datagrid('clearChecked');
                var rows = data.rows;
                for (var i = 0, length = rows.length; i < length; i++) {
                    var row = rows[i];
                    if (IsReqItmInPlan(row.inrqiId)) {
                        $(this).datagrid('checkRow', i);
                    }
                }
            }
        };
        PHA.Grid('gridReqItm', $.extend(dataGridOption, {}));
    }
    function InitGridPlan() {
        var columns = [
            [
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
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
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
                    field: 'rpAmt',
                    title: '���۽��',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
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
                    field: 'carrierDesc',
                    title: '������ҵ',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: '#gridPlanBar',
            singleSelect: false,
            pageNumber: 1,
            pageSize: 999999,
            pagination: false,
            autoSizeColumn: true,
            isAutoShowPanel: true,
            showFooter: true,
            rownumbers: true,
            onLoadSuccess: function () {}
        };
        PHA.Grid('gridPlan', $.extend(dataGridOption, {}));
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultData);
        SetDefaults();
        com.SetPage('pha.in.v3.plan.createbyreq.csp');
    }, 0);
});