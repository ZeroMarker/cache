/**
 * 名称:	 住院移动药房-备药单查询
 * 编写人:	 yunhaibao
 * 编写日期: 2020-05-07
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
                    title: '备药单ID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'drawNo',
                    title: '备药单号',
                    width: 150
                },
                {
                    field: 'wardLocDesc',
                    title: '病区',
                    width: 150
                },
                {
                    field: 'typeDesc',
                    title: '类型',
                    width: 65
                },
                {
                    field: 'statusDesc',
                    title: '备药状态',
                    width: 100
                },
                {
                    field: 'boxStatusDesc',
                    title: '物流箱状态',
                    width: 155
                },
                {
                    field: 'createUserName',
                    title: '建单人',
                    width: 100
                },
                {
                    field: 'createDateTime',
                    title: '建单时间',
                    width: 155
                },
                {
                    field: 'completeUserName',
                    title: '完成人',
                    width: 100
                },
                {
                    field: 'completeDateTime',
                    title: '完成时间',
                    width: 155
                },
                {
                    field: 'packUserName',
                    title: '装箱人',
                    width: 100
                },
                {
                    field: 'packDateTime',
                    title: '装箱时间',
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
                    title: '备药子表ID',
                    width: 155,
                    hidden: true
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 150
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 350
                },
                {
                    field: 'qty',
                    title: '申请数量',
                    width: 100
                },
                {
                    field: 'actualQty',
                    title: '备药数量',
                    width: 100
                },
                {
                    field: 'lastQty',
                    title: '实发数量',
                    width: 100
                },
                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 50
                },
                {
                    field: 'completeUserName',
                    title: '备药人',
                    width: 100
                },
                {
                    field: 'completeDateTime',
                    title: '备药时间',
                    width: 155
                },
                {
                    field: 'packUserName',
                    title: '装箱人',
                    width: 100
                },
                {
                    field: 'packDateTime',
                    title: '装箱时间',
                    width: 155
                },
                {
                    field: 'compFlag',
                    title: '备药完成',
                    align: 'center',
                    formatter: PHAIP_COM.Grid.Formatter.YesNo
                },
                {
                    field: 'compPackFlag',
                    title: '装箱完成',
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
                msg: '请选择药房',
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
