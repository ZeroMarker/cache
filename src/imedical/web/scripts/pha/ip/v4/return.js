/**
 * 住院药房 - 直接退药
 * creator:    yunhaibao
 * createDate: 2022-09-09
 */
// PHA_SYS_SET = undefined;
PHA_COM.Val.CAModelCode = "PHAIPReturn"; 
$(function () {
    var settings = PHA.CM(
        {
            pClassName: 'PHA.IP.Return.Api',
            pMethodName: 'GetSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                macAddr: PHAIP_COM.GetMac()
            })
        },
        false
    );
    PHA_COM.App.Csp = 'pha.ip.v4.return.csp';
    var PHA_IP_RETURN = {
        WardFlag: session['LOGON.WARDID'] || '' != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: 't-1', // 默认前后一天, 避免漏
                endDate: 't+1',
                loc: session['LOGON.CTLOCID'],
                patNo: ''
            }
        ],
        HandleVars: {
            ReturnReason: '',
            RetID: ''
        },
        Config: settings.config
    };

    PHA_COM.SetPanel('#pha_ip_v4_return', $('#pha_ip_v4_return').panel('options').title);
    PHA.ComboBox('loc', {
        panelWidth: 200,
        panelHeight: 'auto',
        url: PHA_STORE.Pharmacy('IP').url + '&OnlyLogon=1',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function (data) {}
    });

    PHA.SetVals(PHA_IP_RETURN.DefaultData);

    InitGridDetail();
    InitReturnReason();
    InitSelectPrintWay();
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            Query();
        }
    });
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        Query();
    });
    PHA_EVENT.Bind('#btnReturn', 'click', function () {
        PHAIP_COM.CACert('PHAIPReturn', HandleReturn);
    });
    PHA_EVENT.Bind('#btnClean', 'click', HandleClean);
    function InitGridDetail() {
        var frozenColumns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck'
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'phacItmLbID',
                    title: '发药孙表ID',
                    hidden: true,
                    width: 100
                },
                {
                    field: 'dspSubID',
                    title: '打包子表ID',
                    hidden: true,
                    width: 100
                },

                {
                    field: 'adm',
                    title: '就诊ID',
                    hidden: true,
                    width: 100
                },
                {
                    field: 'warnInfo',
                    title: '温馨提示',
                    width: 100
                },
                {
                    field: 'takeLocDesc',
                    title: '取药科室',
                    width: 150
                },
                {
                    field: 'doseDateTime',
                    title: '用药时间',
                    width: 100,
                    formatter: function (rowIndex, rowData) {
                        return rowData.doseDate + ' ' + rowData.doseTime;
                    }
                },

                {
                    field: 'orderLinkSign',
                    title: '组',
                    width: 30,
                    formatter: function (value) {
                        return PHAIP_COM.OrderLinkSign(value);
                    }
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 250,
                    showTip: false
                },
                {
                    field: 'retQty',
                    title: '退药数量',
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox(
                        $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                            required: false,
                            min: 0,
                            minPrecision: 0,
                            onBeforeNext: function (data, rowData, rowIndex) {
                                debugger;
                            },
                            checkValue: function (val, checkRet) {
                                var msg = '请输入大于0的数字';
                                if (_.isLikeNumber(val) === false) {
                                    checkRet.msg = msg;
                                    return false;
                                }
                                if (parseFloat(val) <= 0) {
                                    checkRet.msg = msg;
                                    return false;
                                }
                                return true;
                            }
                        })
                    ),
                    styler: function () {
                        return 'font-weight:bold;';
                    }
                },
                {
                    field: 'uomDesc',
                    title: '单位'
                },
                {
                    field: 'dispQty',
                    title: '原发药数量',
                    align: 'right'
                },
                {
                    field: 'retedQty',
                    title: '已退数量',
                    align: 'right'
                },
                {
                    field: 'reqedQty',
                    title: '已申请数量',
                    align: 'right'
                },
                {
                    field: 'batNo',
                    title: '批号',
                    width: 100
                },
                {
                    field: 'sp',
                    title: '售价',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'insuCode',
                    title: '国家医保编码'
                },
                {
                    field: 'insuDesc',
                    title: '国家医保名称'
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 100
                },
                {
                    field: 'oeore',
                    title: '执行记录ID',
                    width: 100
                },
                {
                    field: 'docLocDesc',
                    title: '开单科室',
                    width: 100
                },
                {
                    field: 'priDesc',
                    title: '医嘱类型',
                    width: 100
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            pagination: false,
            pageNumber: 1,
            pageSize: 9999,
            pageList: [9999],
            frozenColumns: frozenColumns,
            columns: columns,
            rownumbers: true,
            toolbar: '#gridDetailBar',
            enableDnd: false,
            singleSelect: false,
            linkField: 'mOeore',
            view: groupview,
            groupField: 'patNo',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                var divArr = [];
                divArr.push('<div style="padding-left:133px;">');
                divArr.push('<span>' + rowData.bedNo + '</span>');
                divArr.push('<span style="padding:0px 10px;"> / </span>');
                divArr.push('<span>' + rowData.patNo + '</span>');
                divArr.push('<span style="padding:0px 10px;"> / </span>');
                divArr.push('<span>' + rowData.patName + '</span>');
                divArr.push('<span style="padding:0px 10px;"> / </span>');
                divArr.push('<span>' + rowData.patSex + '</span>');
                divArr.push('<span style="padding:0px 10px;"> / </span>');
                divArr.push('<span>' + rowData.patAge + '</span>');
                divArr.push('</div>');
                return divArr.join('');
            },
            onBeforeCheck: function (rowIndex, rowData) {
                if (rowData.cantReturnInfo !== '') {
                    return false;
                }
            },
            onBeforeSelect: function (rowIndex, rowData) {
                if (rowData.cantReturnInfo !== '') {
                    return false;
                }
            },
            onClickCell: function (index, field, value) {
                if (field !== 'retQty') {
                    return;
                }
                var rowData = $(this).datagrid('getRows')[index];

                if (rowData.cantEditInfo !== '') {
                    PHA.Popover({
                        msg: rowData.cantReturnInfo,
                        type: 'info'
                    });
                    return;
                }
                if (rowData.cantReturnInfo !== '') {
                    PHA.Popover({
                        msg: rowData.cantReturnInfo,
                        type: 'info'
                    });
                    return;
                }
                $('#gridDetail').datagrid('uncheckRow', index);
                PHA_GridEditor.Edit({
                    gridID: 'gridDetail',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onAfterEdit: function (rowIndex, rowData, changes) {
                var retQty = rowData.retQty;
                var canRetQty = rowData.canRetQty;
                if (retQty !== '' && canRetQty !== '') {
                    if (retQty * 1 > canRetQty * 1) {
                        PHA.Popover({
                            msg: '第' + (rowIndex + 1) + '行,退药数量大于剩余可退数量',
                            type: 'alert'
                        });
                    }
                }
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'checkRow', rowIndex, rowData, function (i, data) {});
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'uncheckRow', rowIndex, rowData, function (i, data) {});
                $(this).datagrid('options').checking = '';
            },
            onLoadSuccess: function () {
                var $grid = $(this);
                $grid.datagrid('options').checking = '';
                $grid.datagrid('uncheckAll');
            }
        };
        PHA.Grid('gridDetail', dataGridOption);
    }
    function InitReturnReason() {
        PHA.Grid('gridReturnReason', {
            toolbar: null,
            exportXls: false,
            url: $URL,
            queryParams: {
                ClassName: 'PHA.IP.COM.Store',
                QueryName: 'ReturnReason',
                pHosp: session['LOGON.HOSPID']
            },
            pagination: false,
            fitColumns: true,
            rownumbers: true,
            headerCls: 'panel-header-gray',
            bodyCls: 'panel-body-gray',
            border: true,
            columns: [
                [
                    {
                        field: 'RowId',
                        title: 'RowId',
                        width: 100,
                        hidden: true
                    },
                    {
                        field: 'Description',
                        title: '原因',
                        width: 1000
                    }
                ]
            ],
            onDblClickRow: function () {
                $('#winReturnReason-ok').click();
            }
        });
        $('#winReturnReason').dialog({
            title: '退药原因（可以双击确定）',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: true,
            closed: true,
            modal: true,
            width: 500,
            height: 500,
            buttons: [
                {
                    id: 'winReturnReason-ok',
                    text: '确定',
                    handler: function () {
                        var selData = $('#gridReturnReason').datagrid('getSelected');
                        if (selData === null) {
                            PHA.Popover({ type: 'info', msg: '请先选择原因' });
                            return;
                        }
                        PHA_IP_RETURN.HandleVars.ReturnReason = selData.RowId;
                        $('#winReturnReason').window('close');
                        $('#gridReturnReason').datagrid('reload');
                        ExecuteReturn();
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        $('#winReturnReason').window('close');
                        $('#gridReturnReason').datagrid('reload');
                    }
                }
            ]
        });
    }
    function InitSelectPrintWay() {
        $('#kwPrintWay').keywords({
            singleSelect: true,
            items: [
                { text: $g('默认打印'), id: 'default', selected: true },
                { text: $g('打印药品汇总'), id: 'total' },
                { text: $g('打印患者药品汇总'), id: 'detail' }
            ],
            onSelect: function (rowData) {
                if (rowData.id === 'default') {
                    PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['total', 'detail']);
                } else {
                    PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['default']);
                }
            }
        });
        $('#winSelectPrintWay').dialog({
            title: '打印方式',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: false,
            closed: true,
            modal: true,
            onOpen: function () {
                $('#winSelectPrintWay')
                    .window('resize', {
                        width: $('#winSelectPrintWay .pha-con-table').width() + 10,
                        height: 'auto'
                    })
                    .window('center');
            },
            buttons: [
                {
                    text: '确定',
                    handler: function () {
                        $('#winSelectPrintWay').dialog('close');
                        PrintReturnCom(PHA_IP_RETURN.HandleVars.RetID, '', $('#kwPrintWay').keywords('getSelected')[0].id);
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        $('#winSelectPrintWay').dialog('close');
                    }
                }
            ]
        });
    }
    function Query() {
        var pJson = PHA_COM.Condition('#qCondition', 'get');
        if (!pJson) {
            $('#patNo').focus();
            return;
        }
        PHA_COM.LoadData(
            'gridDetail',
            {
                pClassName: 'PHA.IP.Return.Api',
                pMethodName: 'GetCanReturnDataRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {}
        );
    }
    // 一个事务
    function HandleReturn() {
        if (!PHA_GridEditor.End('gridDetail')) {
            return;
        }
        var returnData = GetReturnData();
        if (returnData.rows.length === 0) {
            PHA.Popover({ type: 'info', msg: '请先勾选记录' });
            return;
        }
        $('#winReturnReason').dialog('open');
    }
    function ExecuteReturn() {
        PHA.Loading('Show');
        var returnData = GetReturnData();

        PHA.CM(
            {
                pClassName: 'PHA.IP.Return.Api',
                pMethodName: 'HandleReturn',
                dataJson: JSON.stringify(returnData)
            },
            function (retJson) {
                PHA.Loading('Hide');
                if (retJson.msg) {
                    PHA.Alert('提示', retJson.msg, 'warning');
                    return;
                }
                PHA_COM.SaveCACert({
                    signVal: retJson.data,
                    type: "Y"
                })
                PHA_IP_RETURN.HandleVars.RetID = retJson.data;
                if (PHA_IP_RETURN.Config.needSelectPrintWay === 'Y') {
                    $('#winSelectPrintWay').window('open');
                } else {
                    PrintReturnCom(PHA_IP_RETURN.HandleVars.RetID, '');
                }
                $('#btnFind').trigger('click');
            },
            function (retData) {
                PHA.Loading('Hide');
                PHA.Alert('提示', '访问异常' + retData, 'error');
            }
        );
    }
    function GetReturnData() {
        var mainObj = {
            reason: PHA_IP_RETURN.HandleVars.ReturnReason,
            logonUser: session['LOGON.USERID'],
            loc: $('#loc').combobox('getValue')
        };
        var rowArr = [];
        var rows = $('#gridDetail').datagrid('getRows');
        var checkRows = $('#gridDetail').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var rowData = checkRows[i];
            var qty = rowData.retQty;
            if (qty === '' || qty === 0) {
                continue;
            }
            if (rowData.cantReturnInfo !== '') {
                continue;
            }
            var rowIndex = rows.indexOf(rowData);
            rowArr.push({
                rowIndex: rowIndex,
                phacItmLbID: rowData.phacItmLbID,
                qty: rowData.retQty,
                reason: PHA_IP_RETURN.HandleVars.ReturnReason
            });
        }
        return {
            main: mainObj,
            rows: rowArr
        };
    }
    function HandleClean() {
        PHA_COM.Condition('#qCondition', 'clear');
        $('#gridDetail').datagrid('clear');
        PHA.SetVals(PHA_IP_RETURN.DefaultData);
    }
});