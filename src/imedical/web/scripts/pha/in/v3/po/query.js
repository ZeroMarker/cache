/**
 * 采购订单 - 查询 - 能够直接套用到csp中
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            defaultData: [
                {
                    'startDate-q': 't',
                    'endDate-q': 't',
                    'loc-q': session['LOGON.CTLOCID'],
                    'status-q': App_MenuCsp !== 'pha.in.v3.po.query.csp' ? ['SAVE', 'COMP'] : []
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = PO_COMPONENTS();
    var com = PO_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc-q');
    components('Inci', 'inci-q');
    components('No', 'no-q');
    components('Date', 'startDate-q');
    components('Date', 'endDate-q');
    components('Vendor', 'vendor-q');
    components('Status', 'status-q',{
        multiple:true,
        rowStyle: 'checkbox',
        editable:false
    });
	components('PORecStatus', 'poRecStatus-q');
    components('FilterField', 'filterField-q');
    components('MainGrid', 'gridMain-q', {
        toolbar: '#gridMain-qBar',
        onSelect: function (rowIndex, rowData) {
            // 控制双击, 避免双击选取时, 连续调用查询
            if (PHA_COM.GridSelecting(this.id, rowIndex) == true) {
                return;
            }
            $('#gridItm-q').datagrid('clearChecked');
            var pJson = com.Condition('#qCondition-q', 'get');
            pJson.poID = com.GetSelectedRow('#gridMain-q', 'poID');
            com.QueryItmGrid('gridItm-q', pJson);
        },
        onDblClickRow: function () {
            if ($('#btnRetOk-q').parent().css('display') !== 'none') {                
                $('#btnRetOk-q').click();
            }
        },
        onLoadSuccess:function(){
            $('#gridItm-q').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm-q'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm-q', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });

    PHA_EVENT.Bind('#btnFind-q', 'click', function () {
        com.QueryMainGrid('gridMain-q', com.Condition('#qCondition-q', 'get'));
    });
    PHA_EVENT.Bind('#btnClean-q', 'click', function () {
        com.Condition('#qCondition-q', 'clear');
        $('#gridMain-q').datagrid('clear');
        $('#gridItm-q').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnRetClose-q', 'click', function () {
        $('#winQueryPO').window('close');
    });
    PHA_EVENT.Bind('#btnRetOk-q,#btnRetCopy-q', 'click', function () {
        var poID = com.GetSelectedRow('#gridMain-q', 'poID');
        if (poID === '') {
            components('Pop', '请先选择记录');
            return;
        }
        var winTarget = '#' + com.GetWindowId4Event();
        $.data($(winTarget)[0], 'retData', {
            poID: poID,
            type: this.id === 'btnRetCopy-q' ? 'copy' : ''
        });
        $(winTarget).window('close');

    });
    PHA_EVENT.Bind('#btnDelete-q', 'click', function () {
        var poID = com.GetSelectedRow('#gridMain-q', 'poID');
        if (poID === '') {
            components('Pop', '请先选择需要删除的记录');
            return;
        }   
        PHA.Confirm('提示', '确认删除吗', function(){
            com.Invoke(com.Fmt2ApiMethod('Delete'), { poID: poID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    $('#gridMain-q').datagrid('reload');
                }
            });
        });
    });
    PHA_EVENT.Bind('#btnPrint-q', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain-q', 'poID'))
    })
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        var defaultData = settings.DefaultData;
        defaultData['startDate-q'] = defaultData.startDate;
        defaultData['endDate-q'] = defaultData.endDate;
        $.extend(biz.getData('defaultData')[0], defaultData);
        SetDefaults();
        com.SetPage('pha.in.v3.po.query.csp');
    }, 0);
});
