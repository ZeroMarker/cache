/**
 * ����:	 סԺ�ƶ�ҩ��-��ҩ����ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2020-05-07
 */

$(function () {
    PHA_IP_PHDRAW_NS();
});

var PHA_IP_PHDRAW_NS = function () {
    var PHA_IP_PHDRAW = {
        WardFlag: (session['LOGON.WARDID'] || '') !== '' ? 'Y' : 'N',
        DefaultData: [
            {
                conStartDate: 't',
                conEndDate: 't',
                conPhaLoc: (session['LOGON.WARDID'] || '') != '' ? '' : session['LOGON.CTLOCID']
            }
        ]
    };

    InitDict();
    InitGridPhDraw();
    InitGridPhDrawInc();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    PHA_COM.ResizePanel({
        layoutId: 'lyPhDraw',
        region: 'north',
        height: 0.5
    });
    PHA.SetVals(PHA_IP_PHDRAW.DefaultData);

    function InitDict() {
        PHA.ComboBox('conPhaLoc', {
            url: PHA_STORE.Pharmacy('IP').url,
            panelHeight: 'auto',
            onLoadSuccess: function (data) {
                if (PHA_IP_PHDRAW.WardFlag != 'Y') {
                    $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
                }
            },
            onSelect: function (data) {
                $('#conDrawType').combobox('options').url = PHAIP_STORE.PHAIPReqType().url + '&loc=' + data.RowId;
                $('#conDrawType').combobox('clear').combobox('reload');
            }
        });
        PHA.ComboBox('conWardLoc', {
            url: PHA_STORE.WardLoc().url
        });
        PHA.ComboBox('conDrawType', {
            url: PHAIP_STORE.PHAIPReqType().url,
            panelHeight: 'auto'
        });
        PHA.ComboBox('conDrawStatus', {
            url: PHA_STORE.ComDictionaryAsCode('DrawStatus').url,
            panelHeight: 'auto'
        });
        PHA.ComboBox('conBoxStatus', {
            url: PHA_STORE.ComDictionaryAsCode('BoxStatus').url,
            panelHeight: 'auto'
        });
    }

    function InitGridPhDraw() {
        var columns = [
            [
                {
                    field: 'phdw',
                    title: '��ҩ��ID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'drawNo',
                    title: '��ҩ����',
                    width: 150
                },
                {
                    field: 'wardLocDesc',
                    title: '����',
                    width: 150
                },
                {
                    field: 'typeDesc',
                    title: '����',
                    width: 65
                },
                {
                    field: 'statusDesc',
                    title: '��ҩ״̬',
                    width: 100
                },
                {
                    field: 'boxStatusDesc',
                    title: '������״̬',
                    width: 155
                },
                {
                    field: 'createUserName',
                    title: '������',
                    width: 100
                },
                {
                    field: 'createDateTime',
                    title: '����ʱ��',
                    width: 155
                },
                {
                    field: 'completeUserName',
                    title: '�����',
                    width: 100
                },
                {
                    field: 'completeDateTime',
                    title: '���ʱ��',
                    width: 155
                },
                {
                    field: 'packUserName',
                    title: 'װ����',
                    width: 100
                },
                {
                    field: 'packDateTime',
                    title: 'װ��ʱ��',
                    width: 155
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: true,
            columns: columns,
            fitColumns: false,
            toolbar: '#gridPhDrawBar',
            onSelect: function () {
                QueryInc();
            }
        };
        PHA.Grid('gridPhDraw', dataGridOption);
    }

    function InitGridPhDrawInc() {
        var columns = [
            [
                {
                    field: 'phdwi',
                    title: '��ҩ�ӱ�ID',
                    width: 155,
                    hidden: true
                },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 150
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 350
                },
                {
                    field: 'qty',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'actualQty',
                    title: '��ҩ����',
                    width: 100
                },
                {
                    field: 'lastQty',
                    title: 'ʵ������',
                    width: 100
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 50
                },
                {
                    field: 'completeUserName',
                    title: '��ҩ��',
                    width: 100
                },
                {
                    field: 'completeDateTime',
                    title: '��ҩʱ��',
                    width: 155
                },
                {
                    field: 'packUserName',
                    title: 'װ����',
                    width: 100
                },
                {
                    field: 'packDateTime',
                    title: 'װ��ʱ��',
                    width: 155
                },
                {
                    field: 'compFlag',
                    title: '��ҩ���',
                    align: 'center',
                    formatter: PHAIP_COM.Grid.Formatter.YesNo
                },
                {
                    field: 'compPackFlag',
                    title: 'װ�����',
                    align: 'center',
                    formatter: PHAIP_COM.Grid.Formatter.YesNo
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: true,
            columns: columns
        };
        PHA.Grid('gridPhDrawInc', dataGridOption);
    }

    function Query() {
        $('#gridPhDrawInc').datagrid('clear');
        var pJson = GetQueryParamsJson();
        if (pJson.loc === '') {
            PHA.Popover({
                msg: '��ѡ��ҩ��',
                type: 'alert'
            });
            return;
        }

        $('#gridPhDraw').datagrid('options').url = $URL;
        $('#gridPhDraw').datagrid('query', {
            ClassName: 'PHA.IP.PhDraw.Query',
            QueryName: 'PHDraw',
            pJsonStr: JSON.stringify(pJson),
            rows: 999
        });
    }

    function QueryInc() {
        var gridSel = $('#gridPhDraw').datagrid('getSelected');
        if (gridSel === null) {
            $('#gridPhDrawInc').datagrid('clear');
        }
        var pJson = {
            phdw: gridSel.phdw
        };
        $('#gridPhDrawInc').datagrid('options').url = $URL;
        $('#gridPhDrawInc').datagrid('query', {
            ClassName: 'PHA.IP.PhDraw.Query',
            QueryName: 'PHDrawInc',
            pJsonStr: JSON.stringify(pJson)
        });
    }

    function GetQueryParamsJson() {
        var phdw = '';
        var gridSel = $('#gridPhDraw').datagrid('getSelected');
        if (gridSel != null) {
            phdw = gridSel.phdw;
        }

        return {
            loc: $('#conPhaLoc').combobox('getValue') || '',
            wardLoc: $('#conWardLoc').combobox('getValue') || '',
            startDate: $('#conStartDate').datebox('getValue') || '',
            endDate: $('#conEndDate').datebox('getValue') || '',
            startTime: $('#conStartTime').timespinner('getValue') || '',
            endTime: $('#conEndTime').timespinner('getValue') || '',
            drawType: $('#conDrawType').combobox('getValue') || '',
            drawStatus: $('#conDrawStatus').combobox('getValue') || '',
            boxStatus: $('#conBoxStatus').combobox('getValue') || '',
            phacNo: $('#conPhacNo').val().trim() || '',
            drawNo: $('#conDrawNo').val().trim() || '',
            drawUser: $('#conDrawUser').val().trim() || '',
            phdw: phdw
        };
    }

    function Clean() {
        PHA.DomData('.js-con-data', {
            doType: 'clear'
        });
        $('#gridPhDraw').datagrid('clear');
        $('#gridPhDrawInc').datagrid('clear');
        PHA.SetVals(PHA_IP_PHDRAW.DefaultData);
    }
};
