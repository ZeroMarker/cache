/**
 * 采购计划 - 模板, 无法独立, 只是没在制单界面的代码直接掺和
 * @creator 云海宝
 */

 $(function () {
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    components('Loc', 'loc-m');
    InitGridMain();
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm-m', {
        pagination: false,
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });
    PHA_EVENT.Bind('#btnFind-m', 'click', function () {
        var pJson = com.Condition('#qCondition-m', 'get');
        pJson.mouldFlag = 'Y';
        var pJsonStr = JSON.stringify(pJson).replace(/-q|-m/g, '');
        $('#gridMain-m').datagrid('options').url = PHA.$URL;
        $('#gridMain-m').datagrid('query', {
            pClassName: PLAN_COM.ApiClass,
            pMethodName: 'GetMainDataRows4Mould',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    });
    PHA_EVENT.Bind('#btnSelect4Create-m, #btnSelect4Edit-m', 'click', function (e) {
        var planID = com.GetSelectedRow('#gridMain-m','planID');
        if (planID === '') {
            components('Pop', '请先选择模板');
            return
        }
        var winTarget = '#' + com.GetWindowId4Event()
        $.data($(winTarget)[0], 'retData', {
            planID: planID,
            type: this.id === 'btnSelect4Create-m' ? 'mould' : ''
        });
        $(winTarget).window('close');
    });
    
    PHA_EVENT.Bind('#btnClose-m', 'click', function () {
        var winTarget = '#' + com.GetWindowId4Event()
        $.data($(winTarget), 'retData', {});
        $(winTarget).window('close');
    });

    function InitGridMain() {
        var columns = [
            [
                {
                    field: 'planID',
                    title: 'planID',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'no',
                    title: '单号',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'locDesc',
                    title: '采购科室',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createDate',
                    title: '制单日期',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createTime',
                    title: '制单时间',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'createUserName',
                    title: '制单人',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'remarks',
                    title: '备注',
                    width: 100,
                    sortable: true
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            fitColumns: true,
            rownumbers: true,
            toolbar: '#gridMain-mBar',
            loadFilter: function (data) {
                if (data.success === 0) {
                    PHA.Alert('提示', data.msg, 'warning');
                } else {
                    if (data.rows.length > 0) {
                        if (typeof data.rows[0] === 'string') {
                            PHA.Alert('提示', data.rows[0], 'warning');
                        }
                    }
                }
                return data;
            },
            onClickRow: function () {
                com.QueryItmGrid('gridItm-m', {
                    planID: com.GetSelectedRow('#gridMain-m', 'planID')
                });
            },
            onLoadSuccess: function () {
                $('#gridItm-m').datagrid('clear');
            }
        };
        PHA.Grid('gridMain-m', dataGridOption);
    }
});

