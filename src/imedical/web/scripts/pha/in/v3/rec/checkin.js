/**
 * 入库 - 验收
 * @creator 云海宝
 * 终究还是没和查询并一起, 不共用更容易修改
 */

$(function () {
    /**
     * 内部全局
     */
    var biz = {
        data: {
            recID: '',
            status: 'SAVE',
            handleStatus: '',
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID'],
                    startDate: PHA_UTIL.GetDate('t'),
                    endDate: PHA_UTIL.GetDate('t'),
                    status: ['COMP', 'AUDIT'],
                    checkInResult: ['N']
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
    var com = REC_COM;
    var settings = com.GetSettings();
    var components = REC_COMPONENTS();

    components('Loc', 'loc');
    components('CheckInResult', 'checkInResult');
    components('No', 'no');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Vendor', 'vendor');
    components('Status', 'status', {
        loadFilter: function (rows) {
            return rows.filter(function (ele, index) {
                if (['SAVE', 'CANCEL', 'COPY'].indexOf(ele.RowId) >= 0) {
                    return false;
                }
                return true;
            });
        }
    });
    components('FilterField', 'filterField');
    components('MainGrid', 'gridMain', {
        toolbar: '#gridMainBar',
        onSelect: function (rowIndex, rowData) {
            if (rowData === undefined) {
                $('#gridItm').datagrid('clear');
                return;
            }
            var pJson = com.Condition('#qCondition', 'get');
            pJson.recID = com.GetSelectedRow('#gridMain', 'recID');
            com.QueryItmGrid('gridItm', pJson);
        },
        onLoadSuccess: function () {
            $('#gridItm').datagrid('clear');
        }
    });
    components('MZJY', 'mzjy');
    
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck'],
        frozenFields: ['inciCode', 'inci'],
        fields: ['checkRemark', 'checkPort', 'checkRepNo', 'checkRepDate', 'checkAdmNo', 'checkAdmExpDate'],
        editFields: ['checkRemark', 'checkPort', 'checkRepNo', 'checkRepDate', 'checkAdmNo', 'checkAdmExpDate']
    });
    components('ItmGrid', 'gridItm', {
        toolbar: '#gridItmBar',
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        onClickCell: function (index, field, value) {
            if (com.GetSelectedRow('#gridMain', 'checkInFlag') === 'Y') {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: 'gridItm',
                index: index,
                field: field,
                forceEnd: true
            });
        }
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        if (qJson === undefined) {
            return;
        }
        com.QueryMainGrid('gridMain', qJson);
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        $('#gridItm').datagrid('clear');
        SetDefaults();
    });

    PHA_EVENT.Bind('#btnCheckIn', 'click', function () {
        biz.setData('handleStatus', 'CheckIn');
        CheckIn(function (recID) {
            var target = '#gridMain';
            var rowIndex = com.GetSelectedRowIndex(target);
            com.UpdateRow(target, rowIndex, { recID: recID });
            $(target).datagrid('selectRow', rowIndex);
            components('Pop', '验收成功', 'success');
        });
    });
    PHA_EVENT.Bind('#btnCheckInNext', 'click', function () {
        biz.setData('handleStatus', 'CheckIn');
        CheckIn(function (recID) {
            try {
                var target = '#gridMain';
                var curIndex = com.GetSelectedRowIndex(target);
                $(target).datagrid('deleteRow', curIndex);
                var rowsLen = $(target).datagrid('getRows').length - 1;
                $(target).datagrid('selectRow', curIndex > rowsLen ? rowsLen : curIndex);
                components('Pop', '验收成功', 'success');
            } catch (error) {}
        });
    });
    PHA_EVENT.Bind('#btnCheckMJAudit1', 'click', function () {
        biz.setData('handleStatus', 'MJAudit');
        DMJYAudit("MZJY1");
    });
    PHA_EVENT.Bind('#btnCheckMJAudit2', 'click', function () {
        biz.setData('handleStatus', 'MJAudit');
        DMJYAudit("MZJY2");
    });
    function DMJYAudit(statusCode){
        PHA_GridEditor.End('gridItm');
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var recID = com.GetSelectedRow('#gridMain', 'recID');
        if (recID === '') {
            components('Pop', '请先选择需要审核的记录');
            return;
        }
        PHA.BizPrompt({ title: '确认提醒' }, function (promptRet) {
            if (promptRet !== undefined) {
                var data4save = {
                    recID: recID,
                    statusCode: statusCode,
                    remarks:promptRet
                };
                PHA.Loading('Show');
                com.Invoke(apiMethod, data4save , function (retData) {
                    PHA.Loading('Hide');
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        
                    }
                });
            }
        });
       
    }
    function CheckIn(callback) {
        PHA_GridEditor.End('gridItm');
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var recID = com.GetSelectedRow('#gridMain', 'recID');
        if (recID === '') {
            components('Pop', '请先选择需要验收的记录');
            return;
        }
        var rows = [];
        for (const it of com.GetChangedRows('gridItm')) {
            var rowData = _.cloneDeep(it);
            rows.push(rowData);
        }
        PHA.Loading('Show');
        com.Invoke(apiMethod, { main: { recID: recID }, rows: rows }, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                if (callback) {
                    callback(recID);
                }
            }
        });
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    function ControlOperation(){
        if(settings.App.PoisonDoubleSign != "Y"){
            com.ControlOperation({
                '#btnCheckMJAudit1': {
                    hide: true
                },
                '#btnCheckMJAudit2': {
                    hide: true
                },
                'tdMzjy1': {
                    hide: true
                },
                'tdMzjy2': {
                    hide: true
                },
                'tdMzjy3': {
                    hide: true
                },
                'tdMzjy4': {
                    hide: true
                },
            });
            $('#tdMzjy1').hide();
            $('#tdMzjy2').hide();
            $('#tdMzjy3').hide();
            $('#tdMzjy4').hide();

        }
    }
    setTimeout(function () {
        var defaultData = settings.DefaultData;
        defaultData['startDate'] = defaultData.startDate;
        defaultData['endDate'] = defaultData.endDate;
        $.extend(biz.getData('defaultData')[0], defaultData);
        SetDefaults();
        ControlOperation();
        com.SetPage('pha.in.v3.rec.query.csp');
    }, 0);
});

