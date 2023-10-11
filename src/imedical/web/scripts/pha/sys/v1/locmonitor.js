/**
 * 名称:	 药房药库 - 系统管理 - 医嘱审核科室设置
 * 编写人:	 yunhaibao
 * 编写日期: 2020-10-23
 */

$.fn.tooltip.methods.show = function () {};
PHA_COM.App.Csp = 'pha.sys.v1.locmonitor.csp';
PHA_COM.App.Name = 'SYS.LOCMONITOR';
PHA_COM.App.Load = '';
var EG_Loc = PHA.EditGrid.ComboBox({
    required: true,
    tipPosition: 'top',
    defaultFilter: 5,
    url: PHA_STORE.CTLoc().url,
    loadFilter: function (rowsData) {
        var newRowsData = [];
        var locRowsData = $('#gridLoc').datagrid('getRows');
        for (var i = 0; i < rowsData.length; i++) {
            var pushFlag = true;
            var rowID = rowsData[i].RowId;
            for (var j = 0; j < locRowsData.length; j++) {
                var loc = locRowsData[j].loc;
                if (loc === rowID) {
                    pushFlag = false;
                    break;
                }
            }
            if (pushFlag === true) {
                newRowsData.push(rowsData[i]);
            }
        }

        return newRowsData;
    }
});

$(function () {
    InitHosp();
    InitDict();
    InitGridLoc();
    $('#btnFind').on('click', Query);

    $('#btnAdd').on('click', function () {
        var phaLoc = $('#conPhaLoc').combobox('getValue') || '';
        if (phaLoc === '') {
            PHA.Popover({
                msg: '请先选择药房',
                type: 'alert'
            });
            return;
        }

        $('#gridLoc').datagrid('addNewRow', {
            editField: 'loc',
            defaultRow: {
                phaLoc: phaLoc
            }
        });
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
});

// 字典
function InitDict() {
    // 初始化科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy().url,
        onLoadSuccess: function () {
            if (PHA_COM.App.Load == '') {
                var datas = $('#conPhaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == session['LOGON.CTLOCID']) {
                        $('#conPhaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
            PHA_COM.App.Load = 1;
        },
        onSelect: function (data) {
            Query();
        }
    });
}

// 表格-科室组
function InitGridLoc() {
    var columns = [
        [
            {
                field: 'rowID',
                title: 'rowID',
                hidden: true
            },
            {
                field: 'auditFlag',
                title: '是否需要审核',
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                },
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: 'locDesc',
                title: '科室描述',
                width: 100,
                hidden: true
            },
            {
                field: 'loc',
                title: '科室',
                width: 100,
                descField: 'locDesc',
                formatter: function (value, row, index) {
                    return row.locDesc;
                },
                editor: EG_Loc
            },
            {
                field: 'phaLoc',
                title: 'phaLoc',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        exportXls: false,
        pagination: false,
        columns: columns,
        toolbar: '#gridLocBar',
        enableDnd: false,
        fitColumns: true,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onLoadSuccess: function () {}
    };

    PHA.Grid('gridLoc', dataGridOption);
}
function Query() {
    var pJson = {};
    pJson.loc = $('#conPhaLoc').combobox('getValue');
    pJson.alias = '';

    var $grid = $('#gridLoc');

    $grid.datagrid('options').url = $URL;
    $grid.datagrid('query', {
        ClassName: 'PHA.SYS.LocMonitor.Query',
        QueryName: 'CTLoc',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}
function Save() {
    var $grid = $('#gridLoc');
    if ($grid.datagrid('endEditing') == false) {
        PHA.Popover({
            msg: '请先完成必填项',
            type: 'alert'
        });
        return;
    }
    var saveArr = GetSaveData();
    if (saveArr.length === 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.SYS.LocMonitor.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify(saveArr)
        },
        false
    );

    Query();
}
function Delete() {
    var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的科室',
            type: 'alert',
            timeout: 1000
        });
        return;
    }

    PHA.Confirm('删除提示', '您确认删除吗?', function () {
        var rowID = gridSelect.rowID || '';
        var rowIndex = $('#gridLoc').datagrid('getRowIndex', gridSelect);
        if (rowID != '') {
            var dataArr = [];
            dataArr.push(rowID);
            var retJson = $.cm(
                {
                    ClassName: 'PHA.COM.DataApi',
                    MethodName: 'HandleInAll',
                    pClassName: 'PHA.SYS.LocMonitor.Save',
                    pMethodName: 'Delete',
                    pJsonStr: JSON.stringify(dataArr)
                },
                false
            );
            if (retJson.success === 'N') {
                PHA.Alert('提示', retJson.message, 'warning');
                return;
            }
        }
        $('#gridLoc').datagrid('deleteRow', rowIndex);
    });
}

function GetSaveData() {
    var rowsData = $('#gridLoc').datagrid('getChanges');
    var deletedData = $('#gridLoc').datagrid('getChanges', 'deleted');
    var saveArr = [];
    for (var i = 0; i < rowsData.length; i++) {
        var rowData = rowsData[i];
        if (deletedData.indexOf(rowData) >= 0) {
            continue;
        }
        saveArr.push({
            phaLoc: rowData.phaLoc,
            ordLoc: rowData.loc,
            flag: rowData.auditFlag
        });
    }
    return saveArr;
}

function InitHosp() {
    var hospComp = GenHospComp('PHA-COM-DrugAuditLoc');
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        $('#conPhaLoc').combobox('options').url = PHA_STORE.Pharmacy().url;
        $('#conPhaLoc').combobox('clear').combobox('reload');
        $('#gridLoc').datagrid('getColumnOption', 'loc').editor.options.url = PHA_STORE.CTLoc().url;
        Query();
    };
}
