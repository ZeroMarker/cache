/**
 * ����:	 סԺ�ƶ�ҩ��-��ҩ����ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2020-05-06
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
                title: '��ҩ��ID',
                width: 100,
                hidden: true
            },
            {
                field: 'reqNo',
                title: '��ҩ����',
                width: 150
            },
            {
                field: 'wardLocDesc',
                title: '����',
                width: 150
            },
            {
                field: 'locDesc',
                title: 'ҩ��',
                width: 150,
                hidden: true
            },
            {
                field: 'reqUserName',
                title: '������',
                width: 100
            },
            {
                field: 'reqDateTime',
                title: '����ʱ��',
                width: 155
            },
            {
                field: 'reqTypeDesc',
                title: '����',
                width: 65
            },
            {
                field: 'reqStatusDesc',
                title: '��ҩ״̬',
                width: 100
            },
            {
                field: 'drawNo',
                title: '��ҩ����',
                width: 150
            },
            {
                field: 'cancelUserName',
                title: '������',
                width: 100
            },
            {
                field: 'cancelDateTime',
                title: '����ʱ��',
                width: 155
            },
            {
                field: 'connectNo',
                title: '��������',
                width: 150
            },
            {
                field: 'alertDrawUserName',
                title: '����ҩ����ҩ��',
                width: 120
            },
            {
                field: 'alertDrawDateTime',
                title: '����ҩ����ҩʱ��',
                width: 155
            },
            {
                field: 'boxStatusDesc',
                title: '������״̬',
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
                title: '����',
                width: 50
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 50
            },
            {
                field: 'statusDesc',
                title: '״̬',
                width: 100
            },
            {
                field: 'cancelUserName',
                title: '������',
                width: 100
            },
            {
                field: 'cancelDateTime',
                title: '����ʱ��',
                width: 155
            },
            {
                field: 'bedNo',
                title: '����',
                width: 100
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
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
            msg: '��ѡ��ҩ��',
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
