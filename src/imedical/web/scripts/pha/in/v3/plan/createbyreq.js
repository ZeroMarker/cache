/**
 * 采购计划 - 辅助计划 - 依据请求
 * @creator 云海宝
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
            components('Pop', '请先勾选需要保存的记录');
            return;
        }
        var includeInciArr = [];
        $('#gridPlan')
            .datagrid('getChecked')
            .forEach(function (ele) {
                includeInciArr.push(ele.inci);
            });

        PHA.Confirm('提示', '您确认保存勾选记录为采购计划吗?', function () {
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
                        title: '采购计划制单',
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
            components('Pop', '请求明细没有数据, 无法操作');
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
                components('Pop', '审核成功');
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
                    title: '类型',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'proLocDesc',
                    title: '采购科室',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'recLocDesc',
                    title: '申购科室',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'statusDesc',
                    title: '转移状态',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: '请求日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '请求时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'creator',
                    title: '请求人',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'reqNo',
                    title: '请求单号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'remarks',
                    title: '请求备注',
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
                    title: '药品代码',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'adviceQty',
                    title: '建议采购数量',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'qty',
                    title: '请求数量',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'transedQty',
                    title: '已转移数量',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'reqLocQty',
                    title: '请求科室库存',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'locQty',
                    title: '供给科室库存',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },
                {
                    field: 'manfName',
                    title: '生产企业',
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
                    title: '药品代码',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'qty',
                    title: '数量',
                    width: 100,
                    sortable: true,
                    align: 'right'
                },

                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 100,
                    sortable: true
                },

                {
                    field: 'rp',
                    title: '进价',
                    width: 100,
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
                    field: 'manfDesc',
                    title: '生产企业',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'vendorDesc',
                    title: '经营企业',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'carrierDesc',
                    title: '配送企业',
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