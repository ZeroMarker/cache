/**
 * ����ҩƷʹ�õǼ�
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
                    msg: '���ȹ�ѡ��Ҫ���������',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('��ʾ', '��ȷ�ϵǼ���?', HandleReg);
        });
        $('#btnUpdateRecLoc').on('click', function () {
            if (GetCheckedOrder().length === 0) {
                PHA.Popover({
                    msg: '���ȹ�ѡ��Ҫ���������',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('��ʾ', '��ȷ���޸Ľ��տ��ҵ���������?', HandleUpdateRecLoc);
        });
        // // ����, �ݲ�֧��, ��������˿��Ӧ�޷�ȡ��
        // $('#btnCancelReg').on('click', function () {
        //     if ($('#gridOrder').datagrid('getChecked').length === 0) {
        //         PHA.Popover({
        //             msg: '���ȹ�ѡ��Ҫ���������',
        //             type: 'info'
        //         });
        //         return;
        //     }
        //     PHA.Confirm('��ʾ', '��ȷ��ȡ���Ǽ���?', HandleReg);
        // });
    }
    /** ��ʼ������ */
    function InitDict() {
        PHA.ComboBox('regStatus', {
            data: [
                { RowId: '0', Description: $g('δ�Ǽ�') },
                { RowId: '1', Description: $g('�ѵǼ�') }
            ],
            editable: false,
            panelHeight: 'auto',
            onSelect: function () {
                $('#btnFind').click();
            }
        });
    }
    /** ��ʼ������ҩ��ҽ�� */
    function InitGridOrder() {
        var columns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'regInfo',
                    title: '������Ϣ',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'orderDateTime',
                    title: '����ʱ��',
                    width: 105
                },
                {
                    field: 'doseDateTime',
                    title: 'Ҫ��ִ��ʱ��',
                    width: 105
                },
                {
                    field: 'orderName',
                    title: 'ҽ������',
                    width: 200
                },
                {
                    field: 'dosage',
                    title: '����',
                    width: 100
                },
                {
                    field: 'instructDesc',
                    title: '�÷�',
                    width: 100
                },
                {
                    field: 'oeoreStatusDesc',
                    title: 'ִ�м�¼״̬',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'oeoreStatusUserName',
                    title: '������',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'oeoreStatusDateTime',
                    title: '����ʱ��',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'qtyData',
                    title: '�����ҿ��',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'mainLocQtyData',
                    title: '�����ҿ��',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'recLocDesc',
                    title: '���տ���',
                    width: 100
                },
                {
                    field: 'docLocDesc',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'regUserName',
                    title: '�Ǽ���',
                    width: 100
                },
                {
                    field: 'regDateTime',
                    title: '�Ǽ�ʱ��',
                    width: 160
                },
                {
                    field: 'priorityDesc',
                    title: 'ҽ������',
                    width: 100
                },
                {
                    field: 'oeore',
                    title: 'ִ�м�¼ID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'oeori',
                    title: 'ҽ��ID',
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

    /** ��ѯ����ҩҽ�� */
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
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $('#gridOrder').datagrid('loaded');
                }
                $('#gridOrder').datagrid('loadData', retData);
            }
        );
    }

    /**  �Ǽ� */
    function HandleReg() {
        if ($('#regStatus').combobox('getValue') === '1') {
            PHA.Popover({
                msg: '�������������ѵǼǣ������ٴεǼ�',
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
                msg: '�빴ѡ��Ҫ����ļ�¼',
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
                        msg: '�Ǽǳɹ�',
                        type: 'success'
                    });
                    $('#btnFind').click();
                } else {
                    PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
                }
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
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
    /** У����տ����Ƿ����¼����һ�� */
    function ValidateOrder() {
        var dataRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = dataRows.length; i < length; i++) {
            var iData = dataRows[i];
            if (iData.recLocID !== session['LOGON.CTLOCID']) {
                return '���ܵǼǽ��տ��Ҳ��Ǳ����ҵļ�¼';
            }
        }
        return true;
    }

    /**  �޸Ľ��տ��� */
    function HandleUpdateRecLoc() {
        if ($('#regStatus').combobox('getValue') === '1') {
            PHA.Popover({
                msg: '�������������ѵǼǣ��޷��޸�',
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
                msg: '���տ������¼������ͬʱ����Ҫ�޸�, �빴��Ҫ�޸ĵļ�¼',
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
                        msg: '�޸ĳɹ�',
                        type: 'success'
                    });
                    $('#btnFind').click();
                } else {
                    PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
                }
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
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
