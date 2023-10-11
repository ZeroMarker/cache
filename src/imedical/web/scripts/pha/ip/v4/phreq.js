/**
 * 名称:	 住院移动药房-领药单查询
 * 编写人:	 yunhaibao
 * 编写日期: 2020-05-06
 */
var PHA_IP_PHREQ = {
    WardFlag: (session['LOGON.WARDID'] || '') != '' ? 'Y' : 'N',
    DefaultData: [
        {
            conStartDate: 't',
            conEndDate: 't',
            conPhaLoc: session['LOGON.CTLOCID']
        }
    ]
};
$(function () {
    InitDict();
    InitGridPhReq();
    InitGridPhReqItm();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
        }
    });
    PHA_COM.ResizePanel({
        layoutId: 'lyPhReq',
        region: 'north',
        height: 0.5
    });

    PHA.SetVals(PHA_IP_PHREQ.DefaultData);
});
function InitDict() {
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            if (PHA_IP_PHREQ.WardFlag != 'Y') {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
        },
        onSelect: function (data) {
            $('#conReqType').combobox('options').url = PHAIP_STORE.PHAIPReqType().url + '&loc=' + data.RowId;
            $('#conReqType').combobox('clear').combobox('reload');
        }
    });
    PHA.ComboBox('conReqType', {
        url: PHAIP_STORE.PHAIPReqType().url,
        panelHeight: 'auto'
    });
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url
    });
    PHA.ComboBox('conReqStatus', {
        url: PHA_STORE.ComDictionaryAsCode('InPhReqStatus').url,
        panelHeight: 'auto'
    });
    PHA.ComboBox('conBoxStatus', {
        url: PHA_STORE.ComDictionaryAsCode('BoxStatus').url,
        panelHeight: 'auto'
    });
}
function InitGridPhReq() {
    var columns = [
        [
            {
                field: 'phr',
                title: '领药单ID',
                width: 100,
                hidden: true
            },
            {
                field: 'reqNo',
                title: '领药单号',
                width: 150
            },
            {
                field: 'wardLocDesc',
                title: '病区',
                width: 150
            },
            {
                field: 'locDesc',
                title: '药房',
                width: 150,
                hidden: true
            },
            {
                field: 'reqUserName',
                title: '申请人',
                width: 100
            },
            {
                field: 'reqDateTime',
                title: '申请时间',
                width: 155
            },
            {
                field: 'reqTypeDesc',
                title: '类型',
                width: 65
            },
            {
                field: 'reqStatusDesc',
                title: '领药状态',
                width: 100
            },
            {
                field: 'drawNo',
                title: '备药单号',
                width: 150
            },
            {
                field: 'cancelUserName',
                title: '撤消人',
                width: 100
            },
            {
                field: 'cancelDateTime',
                title: '撤消时间',
                width: 155
            },
            {
                field: 'connectNo',
                title: '关联单号',
                width: 150
            },
            {
                field: 'alertDrawUserName',
                title: '提醒药房备药人',
                width: 120
            },
            {
                field: 'alertDrawDateTime',
                title: '提醒药房备药时间',
                width: 155
            },
            {
                field: 'boxStatusDesc',
                title: '物流箱状态',
                width: 155
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridPhReqBar',
        onSelect: function () {
            QueryItm();
        }
    };
    PHA.Grid('gridPhReq', dataGridOption);
}

function InitGridPhReqItm() {
    var columns = [
        [
            {
                field: 'phrItmID',
                title: '领药子表ID',
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
                title: '数量',
                width: 50
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 50
            },
            {
                field: 'statusDesc',
                title: '状态',
                width: 100
            },
            {
                field: 'cancelUserName',
                title: '撤消人',
                width: 100
            },
            {
                field: 'cancelDateTime',
                title: '撤消时间',
                width: 155
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 100
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: true,
        columns: columns
    };
    PHA.Grid('gridPhReqItm', dataGridOption);
}

function Query() {
    $('#gridPhReqItm').datagrid('clear');
    var pJson = GetQueryParamsJson();
    if (pJson.loc === '') {
        PHA.Popover({
            msg: '请选择药房',
            type: 'alert'
        });
        return;
    }

    $('#gridPhReq').datagrid('options').url = $URL;
    $('#gridPhReq').datagrid('query', {
        ClassName: 'PHA.IP.PhReq.Query',
        QueryName: 'InPhReq',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

function QueryItm() {
    var gridSel = $('#gridPhReq').datagrid('getSelected');
    if (gridSel === null) {
        $('#gridPhReqItm').datagrid('clear');
    }
    var pJson = GetQueryParamsJson();
    pJson.phr = gridSel.phr;
    $('#gridPhReqItm').datagrid('options').url = $URL;
    $('#gridPhReqItm').datagrid('query', {
        ClassName: 'PHA.IP.PhReq.Query',
        QueryName: 'InPhReqItm',
        pJsonStr: JSON.stringify(pJson)
    });
}

function GetQueryParamsJson() {
    var phb = '';
    var gridSel = $('#gridPhReq').datagrid('getSelected');
    if (gridSel != null) {
        phb = gridSel.phb;
    }
    return {
        loc: $('#conPhaLoc').combobox('getValue') || '',
        wardLoc: $('#conWardLoc').combobox('getValue') || '',
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        reqType: $('#conReqType').combobox('getValue') || '',
        reqStatus: $('#conReqStatus').combobox('getValue') || '',
        boxStatus: $('#conBoxStatus').combobox('getValue') || '',
        reqNo: $('#conReqNo').val().trim() || '',
        drawNo: $('#conDrawNo').val().trim() || '',
        connectNo: $('#conConnectNo').val().trim() || '',
        patNo: $('#conPatNo').val().trim() || '',
        reqUserCode: $('#conReqUser').val().trim() || ''
    };
}

function Clean() {
    PHA.DomData('.js-con-data', {
        doType: 'clear'
    });
    $('#gridPhReq').datagrid('clear');
    $('#gridPhReqItm').datagrid('clear');
    PHA.SetVals(PHA_IP_PHREQ.DefaultData);
}
