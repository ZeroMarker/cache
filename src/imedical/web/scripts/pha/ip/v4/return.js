/**
 * סԺҩ�� - ֱ����ҩ
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
                startDate: 't-1', // Ĭ��ǰ��һ��, ����©
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
                    title: '��ҩ���ID',
                    hidden: true,
                    width: 100
                },
                {
                    field: 'dspSubID',
                    title: '����ӱ�ID',
                    hidden: true,
                    width: 100
                },

                {
                    field: 'adm',
                    title: '����ID',
                    hidden: true,
                    width: 100
                },
                {
                    field: 'warnInfo',
                    title: '��ܰ��ʾ',
                    width: 100
                },
                {
                    field: 'takeLocDesc',
                    title: 'ȡҩ����',
                    width: 150
                },
                {
                    field: 'doseDateTime',
                    title: '��ҩʱ��',
                    width: 100,
                    formatter: function (rowIndex, rowData) {
                        return rowData.doseDate + ' ' + rowData.doseTime;
                    }
                },

                {
                    field: 'orderLinkSign',
                    title: '��',
                    width: 30,
                    formatter: function (value) {
                        return PHAIP_COM.OrderLinkSign(value);
                    }
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 250,
                    showTip: false
                },
                {
                    field: 'retQty',
                    title: '��ҩ����',
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
                                var msg = '���������0������';
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
                    title: '��λ'
                },
                {
                    field: 'dispQty',
                    title: 'ԭ��ҩ����',
                    align: 'right'
                },
                {
                    field: 'retedQty',
                    title: '��������',
                    align: 'right'
                },
                {
                    field: 'reqedQty',
                    title: '����������',
                    align: 'right'
                },
                {
                    field: 'batNo',
                    title: '����',
                    width: 100
                },
                {
                    field: 'sp',
                    title: '�ۼ�',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'insuCode',
                    title: '����ҽ������'
                },
                {
                    field: 'insuDesc',
                    title: '����ҽ������'
                },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 100
                },
                {
                    field: 'oeore',
                    title: 'ִ�м�¼ID',
                    width: 100
                },
                {
                    field: 'docLocDesc',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'priDesc',
                    title: 'ҽ������',
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
                            msg: '��' + (rowIndex + 1) + '��,��ҩ��������ʣ���������',
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
                        title: 'ԭ��',
                        width: 1000
                    }
                ]
            ],
            onDblClickRow: function () {
                $('#winReturnReason-ok').click();
            }
        });
        $('#winReturnReason').dialog({
            title: '��ҩԭ�򣨿���˫��ȷ����',
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
                    text: 'ȷ��',
                    handler: function () {
                        var selData = $('#gridReturnReason').datagrid('getSelected');
                        if (selData === null) {
                            PHA.Popover({ type: 'info', msg: '����ѡ��ԭ��' });
                            return;
                        }
                        PHA_IP_RETURN.HandleVars.ReturnReason = selData.RowId;
                        $('#winReturnReason').window('close');
                        $('#gridReturnReason').datagrid('reload');
                        ExecuteReturn();
                    }
                },
                {
                    text: 'ȡ��',
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
                { text: $g('Ĭ�ϴ�ӡ'), id: 'default', selected: true },
                { text: $g('��ӡҩƷ����'), id: 'total' },
                { text: $g('��ӡ����ҩƷ����'), id: 'detail' }
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
            title: '��ӡ��ʽ',
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
                    text: 'ȷ��',
                    handler: function () {
                        $('#winSelectPrintWay').dialog('close');
                        PrintReturnCom(PHA_IP_RETURN.HandleVars.RetID, '', $('#kwPrintWay').keywords('getSelected')[0].id);
                    }
                },
                {
                    text: 'ȡ��',
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
    // һ������
    function HandleReturn() {
        if (!PHA_GridEditor.End('gridDetail')) {
            return;
        }
        var returnData = GetReturnData();
        if (returnData.rows.length === 0) {
            PHA.Popover({ type: 'info', msg: '���ȹ�ѡ��¼' });
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
                    PHA.Alert('��ʾ', retJson.msg, 'warning');
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
                PHA.Alert('��ʾ', '�����쳣' + retData, 'error');
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