/**
 * ����ҩ������������
 * @author yunhaibao
 * @since  2023-02-23
 */
PHA_SYS_SET = undefined;

$(function () {
    PHA_COM.App.Csp = 'pha.ip.v4.reqbyconsume.csp';
    var defaultData = $.cm(
        {
            ClassName: 'PHA.IP.BasicDrug.Api',
            MethodName: 'GetNextDateTimeRange',
            loc: session['LOGON.CTLOCID'],
            reqType: LoadReqType
        },
        false
    );
    var PHA_IP_REQBYCONSUME = {
        WardFlag: session['LOGON.WARDID'] || '' != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: defaultData.startDate,
                endDate: defaultData.endDate,
                startTime: defaultData.startTime,
                endTime: defaultData.endTime,
                reqLoc: session['LOGON.CTLOCID'],
                reqType: LoadReqType
            }
        ],
        HandleVars: {}
    };
    PHA.ComboBox('reqLoc', {
        url: PHA_STORE.CTLoc().url,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        }
    });
    // PHA.ComboBox('proLoc', {
    //     url: PHA_STORE.RelLocByRec(session['LOGON.CTLOCID']).url
    // });

    PHA_UX.ComboBox.Loc('proLoc', {
        qParams: {
            recLocId: PHA_UX.Get('reqLoc', session['LOGON.CTLOCID']), // ����ʱ��̬ȡֵ,�ڶ�������ΪĬ��ֵ
            relType: 'TR'
        }
    });
    PHA.ComboBox('reqType', {
        data: [
            { RowId: '1', Description: $g('���ұ�ҩ����') },
            { RowId: '2', Description: $g('�����鲹��') },
            { RowId: '3', Description: $g('����Һ����') }
        ]
    });
    PHA.ComboBox('arcItmCat', {
        url: PHA_STORE.ARCItemCat().url,
        multiple: true,
        rowStyle: 'checkbox',
        disabled: LoadReqType == 2 ? true : false
    });
    PHA.SetVals(PHA_IP_REQBYCONSUME.DefaultData);
    InitGridDetail();
    $('#btnSave').on('click', Save);
    $('#btnFind').on('click', QueryDetail);
    function InitGridDetail() {
        var columns = [
            [
                { field: 'bddItmId', title: 'bddItmId', width: 200, halign: 'center', hidden: true },
                { field: 'reqItmId', title: 'reqItmId', width: 200, halign: 'center', hidden: true },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 150,
                    halign: 'left'
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 300,
                    halign: 'left'
                },
                {
                    field: 'reqQty',
                    title: '��������', // ��ʵ��Ҫ���������, ϵͳ�ɼ���
                    width: 125,
                    halign: 'right',
                    align: 'right'
                },
                // {
                //     field: 'adviceQty',
                //     title: '������������', // ���˺ϼ�
                //     width: 125,
                //     halign: 'right',
                //     align: 'right'
                // },
                {
                    field: 'consumeQty',
                    title: '��������', // ���˺ϼ�
                    width: 125,
                    halign: 'right',
                    align: 'right'
                },

                {
                    field: 'lastRestQty',
                    title: '�ϴ�ʣ��ɲ�������', // ����δת+����
                    width: 150,
                    align: 'right'
                },
                {
                    field: 'reqUomDesc',
                    title: '��λ',
                    width: 50,
                    halign: 'left'
                },
                {
                    field: 'proLocQty',
                    title: '�������ҿ��ÿ��',
                    width: 125,
                    align: 'right'
                },
                {
                    field: 'inci',
                    title: 'ҩƷId',
                    width: 400,
                    halign: 'left',
                    hidden: true
                },
                {
                    field: 'reqUomId',
                    title: '��λId',
                    width: 100,
                    halign: 'left',
                    hidden: true
                }
            ]
        ];
        var dataGridOption = {
            url: null,
            fit: true,
            border: false,
            singleSelect: true,
            fitColumns: false,
            rownumbers: true,
            columns: columns,
            toolbar: '#gridDetailBar',
            pageSize: 1000,
            pageList: [1000, 100, 300, 500],
            pagination: false,
            onLoadSuccess: function () {
                $('#gridDetail').datagrid('loaded');
            }
        };
        PHA.Grid('gridDetail', dataGridOption);
    }
    function QueryDetail() {
        var pJson = GetParamsJson();
        if (pJson.proLoc === '') {
            PHA.Popover({ type: 'info', msg: '��ѡ�񹩸�����' });
            return;
        }
        $('#gridDetail').datagrid('loading');
        var sort = $('#gridDetail').datagrid('options').sortName;
        var order = $('#gridDetail').datagrid('options').sortOrder;
        $.cm(
            {
                ClassName: 'PHA.IP.BasicDrug.Api',
                MethodName: 'GetConsumeRows',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1,
                sort: sort,
                order: order
            },
            function (rowsData) {
                $('#gridDetail').datagrid('loadData', rowsData);
            }
        );
    }
    function GetParamsJson() {
        var pJson = PHA_COM.Condition('#qCondition', 'get');
        pJson.loc = pJson.reqLoc;
        return pJson;
    }
    function Save() {
        var rows = $('#gridDetail').datagrid('getRows');
        if (rows.length === 0) {
            PHA.Popover({ type: 'info', msg: 'û�п������ɲ�����������' });
            return;
        }
        var data4save = {
            logonUser: session['LOGON.USERID'],
            logonLoc: session['LOGON.CTLOCID'],
            logonGroup: session['LOGON.GROUPID']
        };
        data4save.main = GetParamsJson();

        data4save.rows = [];
        for (var i = 0, length = rows.length; i < length; i++) {
            var row = rows[i];
            if (row.reqQty == 0) {
                continue;
            }
            data4save.rows.push({
                inci: row.inci,
                reqQty: row.reqQty,
                dispQty: row.consumeQty,
                lastRestQty: row.lastRestQty,
                reqUomId: row.reqUomId
            });
        }
        if (data4save.rows.length === 0) {
            PHA.Popover({ type: 'info', msg: '������������' });
            return;
        }
        if (data4save.main.proLoc === '') {
            PHA.Popover({ type: 'info', msg: '��ѡ�񹩸�����' });
            return;
        }
        PHA.Confirm('��ʾ', '��ȷ�����ɲ�������?', function () {
            var ret = $.cm(
                {
                    ClassName: 'PHA.IP.BasicDrug.Api',
                    MethodName: 'CreateBaseDrugReq',
                    pJsonStr: JSON.stringify(data4save),
                    dataType: 'text'
                },
                false
            );
            var retArr = ret.split('^');
            if (retArr[0] >= 0) {
                PHA.Alert('��ʾ', '���ɲ������ɹ�', 'success');
                $('#btnSave,#btnFind').linkbutton('disable');
                $('#btnSave,#btnFind').unbind();
            } else {
                $.messager.alert('��ʾ', retArr[1], 'warning');
            }
        });
    }
});
$g('δ���');
$g('����Һ����');
$g('�����鲹��');
$g('��������');
$g('δ���');
$g('�ѽ���');
$g('�ѳ���');
$g('���ֽ���');
$g('������˲�ͨ��');
$g('�ܾ�����');
$g('����ɵȴ�����');
