/**
 * 基数药补货依据消耗
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
            recLocId: PHA_UX.Get('reqLoc', session['LOGON.CTLOCID']), // 加载时动态取值,第二个参数为默认值
            relType: 'TR'
        }
    });
    PHA.ComboBox('reqType', {
        data: [
            { RowId: '1', Description: $g('科室备药补货') },
            { RowId: '2', Description: $g('精神毒麻补货') },
            { RowId: '3', Description: $g('大输液补货') }
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
                    title: '药品代码',
                    width: 150,
                    halign: 'left'
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 300,
                    halign: 'left'
                },
                {
                    field: 'reqQty',
                    title: '请求数量', // 真实的要请求的数量, 系统可计算
                    width: 125,
                    halign: 'right',
                    align: 'right'
                },
                // {
                //     field: 'adviceQty',
                //     title: '理论请求数量', // 发退合计
                //     width: 125,
                //     halign: 'right',
                //     align: 'right'
                // },
                {
                    field: 'consumeQty',
                    title: '销售数量', // 发退合计
                    width: 125,
                    halign: 'right',
                    align: 'right'
                },

                {
                    field: 'lastRestQty',
                    title: '上次剩余可补货数量', // 请求未转+保留
                    width: 150,
                    align: 'right'
                },
                {
                    field: 'reqUomDesc',
                    title: '单位',
                    width: 50,
                    halign: 'left'
                },
                {
                    field: 'proLocQty',
                    title: '供给科室可用库存',
                    width: 125,
                    align: 'right'
                },
                {
                    field: 'inci',
                    title: '药品Id',
                    width: 400,
                    halign: 'left',
                    hidden: true
                },
                {
                    field: 'reqUomId',
                    title: '单位Id',
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
            PHA.Popover({ type: 'info', msg: '请选择供给科室' });
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
            PHA.Popover({ type: 'info', msg: '没有可以生成补货单的数据' });
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
            PHA.Popover({ type: 'info', msg: '请检查请求数量' });
            return;
        }
        if (data4save.main.proLoc === '') {
            PHA.Popover({ type: 'info', msg: '请选择供给科室' });
            return;
        }
        PHA.Confirm('提示', '您确认生成补货单吗?', function () {
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
                PHA.Alert('提示', '生成补货单成功', 'success');
                $('#btnSave,#btnFind').linkbutton('disable');
                $('#btnSave,#btnFind').unbind();
            } else {
                $.messager.alert('提示', retArr[1], 'warning');
            }
        });
    }
});
$g('未完成');
$g('大输液补货');
$g('精神毒麻补货');
$g('基数补货');
$g('未完成');
$g('已接收');
$g('已出库');
$g('部分接收');
$g('出库审核不通过');
$g('拒绝接收');
$g('已完成等待出库');
