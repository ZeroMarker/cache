/**
 * 备用药品使用登记
 * @creator yunhaibao
 * @date    2023-04-10
 */
PHA_SYS_SET = undefined;
$(function () {
    var PHA_IP_REGORDER = {
        WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: 't',
                endDate: 't',
                patNo: '',
                regStatus: '0' // UN|DONE|CANCEL
            }
        ],
        HandleVars: {
            Pid: '',
            PhacIDArr: []
        }
    };
    InitEvents();
    InitDict();
    InitGridOrder();

    function InitEvents() {
        $('#btnFind').on('click', function () {
            QueryOrder();
        });
        $('#btnClear').on('click', function () {
            PHA.SetVals(PHA_IP_REGORDER.DefaultData);
            $('#gridOrder').datagrid('loadData', { rows: [], total: 0 });
        });
        $('#patNo').on('keypress', function (event) {
            if (window.event.keyCode == '13') {
                $(this).val(PHA_COM.FullPatNo($(this).val()));
                $('#btnFind').click();
            }
        });
        $('#btnReg').on('click', function () {
            if (GetCheckedOrder().length === 0) {
                PHA.Popover({
                    msg: '请先勾选需要处理的数据',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('提示', '您确认登记吗?', HandleReg);
        });
        $('#btnUpdateRecLoc').on('click', function () {
            if (GetCheckedOrder().length === 0) {
                PHA.Popover({
                    msg: '请先勾选需要处理的数据',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('提示', '您确认修改接收科室到本科室吗?', HandleUpdateRecLoc);
        });
        // // 屏蔽, 暂不支持, 如果处理了库存应无法取消
        // $('#btnCancelReg').on('click', function () {
        //     if ($('#gridOrder').datagrid('getChecked').length === 0) {
        //         PHA.Popover({
        //             msg: '请先勾选需要处理的数据',
        //             type: 'info'
        //         });
        //         return;
        //     }
        //     PHA.Confirm('提示', '您确认取消登记吗?', HandleReg);
        // });
    }
    /** 初始化条件 */
    function InitDict() {
        PHA.ComboBox('regStatus', {
            data: [
                { RowId: '0', Description: $g('未登记') },
                { RowId: '1', Description: $g('已登记') }
            ],
            editable: false,
            panelHeight: 'auto',
            onSelect: function () {
                $('#btnFind').click();
            }
        });
    }
    /** 初始化备用药的医嘱 */
    function InitGridOrder() {
        var columns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'regInfo',
                    title: '提醒信息',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'orderDateTime',
                    title: '开单时间',
                    width: 105
                },
                {
                    field: 'doseDateTime',
                    title: '要求执行时间',
                    width: 105
                },
                {
                    field: 'orderName',
                    title: '医嘱名称',
                    width: 200
                },
                {
                    field: 'dosage',
                    title: '剂量',
                    width: 100
                },
                {
                    field: 'instructDesc',
                    title: '用法',
                    width: 100
                },
                {
                    field: 'oeoreStatusDesc',
                    title: '执行记录状态',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'oeoreStatusUserName',
                    title: '操作人',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'oeoreStatusDateTime',
                    title: '操作时间',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'qtyData',
                    title: '本科室库存',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'mainLocQtyData',
                    title: '主科室库存',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'recLocDesc',
                    title: '接收科室',
                    width: 100
                },
                {
                    field: 'docLocDesc',
                    title: '开单科室',
                    width: 100
                },
                {
                    field: 'regUserName',
                    title: '登记人',
                    width: 100
                },
                {
                    field: 'regDateTime',
                    title: '登记时间',
                    width: 160
                },
                {
                    field: 'priorityDesc',
                    title: '医嘱类型',
                    width: 100
                },
                {
                    field: 'oeore',
                    title: '执行记录ID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'oeori',
                    title: '医嘱ID',
                    width: 100,
                    hidden: false
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: null,
            fitColumns: true,
            toolbar: '#gridOrderBar',
            columns: columns,
            rownumbers: true,
            singleSelect: false,
            checkOnSelect: true,
            selectOnCheck: true,
            pagination: true,
            pageSize: 1000,
            pageList: [1000],
            pageNumber: 1,
            onLoadSuccess: function () {
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
            }
        };
        PHA.Grid('gridOrder', dataGridOption);
    }

    /** 查询备用药医嘱 */
    function QueryOrder() {
        $('#gridOrder').datagrid('loading');
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        PHA_COM.AppendLogonData(pJson);
        $.cm(
            {
                ClassName: 'PHA.IP.RegOrder.Api',
                MethodName: 'GetOrderRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                if ($.type(retData) === 'object' && typeof retData.msg !== 'undefined') {
                    PHA.Alert('提示', retData.msg, 'error');
                    $('#gridOrder').datagrid('loaded');
                }
                $('#gridOrder').datagrid('loadData', retData);
            }
        );
    }

    /**  登记 */
    function HandleReg() {
        if ($('#regStatus').combobox('getValue') === '1') {
            PHA.Popover({
                msg: '您操作的数据已登记，不能再次登记',
                type: 'info'
            });
            return;
        }
        var msg = ValidateOrder();
        if (msg !== true) {
            PHA.Popover({
                msg: msg,
                type: 'info'
            });
            return;
        }
        var checkedData = GetCheckedOrder();
        if (checkedData.length === 0) {
            PHA.Popover({
                msg: '请勾选需要保存的记录',
                type: 'info'
            });
            return false;
        }

        var saveData = {
            main: {},
            rows: checkedData
        };
        PHA_COM.AppendLogonData(saveData);
        $.cm(
            {
                ClassName: 'PHA.IP.RegOrder.Api',
                MethodName: 'HandleReg',
                pJson: JSON.stringify(saveData)
            },
            function (retData) {
                if (retData.code == 0) {
                    PHA.Popover({
                        msg: '登记成功',
                        type: 'success'
                    });
                    $('#btnFind').click();
                } else {
                    PHA.Alert('提示', JSON.stringify(retData.msg), 'error');
                }
            },
            function (retData) {
                PHA.Alert('提示', JSON.stringify(retData.msg), 'error');
            }
        );
    }
    function GetCheckedOrder() {
        var dataRows = $('#gridOrder').datagrid('getChecked');
        var retRows = [];
        dataRows.forEach(function (data) {
            retRows.push({
                oeore: data.oeore
            });
        });
        return retRows;
    }
    /** 校验接收科室是否与登录科室一致 */
    function ValidateOrder() {
        var dataRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = dataRows.length; i < length; i++) {
            var iData = dataRows[i];
            if (iData.recLocID !== session['LOGON.CTLOCID']) {
                return '不能登记接收科室不是本科室的记录';
            }
        }
        return true;
    }

    /**  修改接收科室 */
    function HandleUpdateRecLoc() {
        if ($('#regStatus').combobox('getValue') === '1') {
            PHA.Popover({
                msg: '您操作的数据已登记，无法修改',
                type: 'info'
            });
            return;
        }
        var newRecLocID = session['LOGON.CTLOCID'];
        var saveRows = [];
        var dataRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = dataRows.length; i < length; i++) {
            var iData = dataRows[i];
            if (iData.recLocID === newRecLocID) {
                continue;
            }
            saveRows.push({
                oeore: iData.oeore,
                recLocID: newRecLocID
            });
        }
        if (dataRows.length > 0 && saveRows.length === 0) {
            PHA.Popover({
                msg: '接收科室与登录科室相同时不需要修改, 请勾需要修改的记录',
                type: 'info'
            });
            return;
        }

        var saveData = {
            main: {},
            rows: saveRows
        };
        PHA_COM.AppendLogonData(saveData);
        $.cm(
            {
                ClassName: 'PHA.IP.RegOrder.Api',
                MethodName: 'HandleUpdateRecLoc',
                pJson: JSON.stringify(saveData)
            },
            function (retData) {
                if (retData.code == 0) {
                    PHA.Popover({
                        msg: '修改成功',
                        type: 'success'
                    });
                    $('#btnFind').click();
                } else {
                    PHA.Alert('提示', JSON.stringify(retData.msg), 'error');
                }
            },
            function (retData) {
                PHA.Alert('提示', JSON.stringify(retData.msg), 'error');
            }
        );
    }
    var patientInfo = $.cm(
        {
            ClassName: 'PHA.IP.RegOrder.Api',
            MethodName: 'GetPatientInfo',
            pJson: JSON.stringify({
                adm: LoadEpisodeID
            })
        },
        false
    );
    PHA_IP_REGORDER.DefaultData[0].patNo = patientInfo.patNo;
    PHA.SetVals(PHA_IP_REGORDER.DefaultData);
    PHA_IP_REGORDER.DefaultData[0].patNo = '';
});
