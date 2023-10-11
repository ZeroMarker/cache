$(function () {
    var biz = {
        data: {
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    groupWay: 'INASP_Date|createDate'
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
    var components = ASPB_COMPONENTS();
    var com=ASPB_COM;
    // var settings = com.GetSettings();

    components('StkCatGrp', 'stkCatGrp');
    components('Status', 'status', { multiple: true, rowStyle: 'checkbox', editable: false });
    components('No', 'no');
    components('Inci', 'inci');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('GroupWay', 'groupWay', {
        onChange: function (oldData, newData) {
            $.data($(this)[0], 'find', true);
        },
        onHidePanel: function (ee) {
            if ($.data($(this)[0], 'find') == true) {
                $('#btnFind').trigger('click-i');
            }
            $.data($(this)[0], 'find', false);
        }
    });
    // components('FilterField', 'filterField');
    components('GrpGrid', 'gridGrp', {
        toolbar: [],
        onSelect: function (rowIndex, rowData) {
            var qJson = com.Condition('#qCondition', 'get');
            var grpObj = com.GetSelectedRow('#gridGrp');
            $.extend(qJson, grpObj);
            com.LoadData('gridAspb', {
                pMethodName: 'GetAspbDataRows4IDArr',
                pJson: JSON.stringify(qJson)
            });
            // com.QueryAspbGrid('gridAspb', qJson);
        },
        onLoadSuccess: function (data) {
            $('#gridAspb').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('AspbGridColmuns', 'gridAspb'), {
        frozenFields: ['gCheck', 'inciCode', 'inci', 'uom'],
        hiddenFields: ['gCheck']
    });
    components('AspbGrid', 'gridAspb', {
        toolbar: [],
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        loadFilter: PHA.LocalFilter
    });

    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridGrp').datagrid('clear');
        SetDefaults();
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        com.QueryGrpGrid('gridGrp', com.Condition('#qCondition', 'get'));
    });

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }

    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.aspb.query.csp');
    }, 0);
});
