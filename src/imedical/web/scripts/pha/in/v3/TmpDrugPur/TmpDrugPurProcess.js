/**
 * 模块:     临购流程配置
 * 编写日期: 2020-09-20
 * 编写人:   yangshijie
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
$(function () {
	InitHospCombo();
    InitGridDict();
    InitDict();
    InitgridProcess();
    InitgridProcessUser();
    InitProcessData(SessionHosp);
    BtnEvent();
});

function InitHospCombo() {
    var genObj = GenHospComp('CF_PHA_IN.TmpDrugPurProcess', '', { width: 280 });
    //增加选择事件
    $('#_HospList').combogrid('options').onSelect = function (index, record) {
        var newHospId = record.HOSPRowId;
        var oldHospId = PHA_COM.Session.HOSPID;
        if (newHospId != oldHospId) {
            PHA_COM.Session.HOSPID = newHospId;
            PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
            //医院变换时字典也需要更新
            InitGridDict();
            InitProcessData(newHospId);
            $('#gridProcessUser').datagrid('clear');
    		$('#gridProcessUser').datagrid('clearSelections');
            QueryProcess();
            
        }
    };
}

function InitProcessData(Hosp) {
    var ret = tkMakeServerCall('PHA.IN.TmpDrugPurProcess.Save', 'InitProcessByHosp', Hosp);
    if (ret.code<0) {
        PHA.Popover({ showType: 'show', msg: ret.Desc, type: 'alert' });
        $('#btnAdd').addClass('l-btn-disabled');
        $('#btnAdd').css('pointer-events', 'none');
        return;
    }
}

function BtnEvent() {
    $('#btnAdd').on('click', AddNewRow);
    $('#btnSave').on('click', SaveProcess);
    $('#btnDelete').on('click', DeleteProcess);
    $('#btnMoveUp').on('click', function () {
        btnMove('UP');
    });
    $('#btnMoveDown').on('click', function () {
        btnMove('DOWN');
    });

    $('#btnAddi').on('click', AddNewRowi);
    $('#btnSavei').on('click', SaveProcessUser);
    $('#btnDeletei').on('click', DeleteProcessUser);
}

function btnMove(MoveType) {
    var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP;
    if (TDPP == '') {
        PHA.Popover({ showType: 'show', msg: '请选中一行数据！', type: 'alert' });
        return;
    }
    var level = gridSelect.level;
    if (level == 1){
        PHA.Popover({ showType: 'show', msg: '固定流程不可移动！', type: 'alert' });
        return;
    }
    MoveProcess(TDPP, MoveType);
}

function QueryProcess() {
	//clearProcess();
    $('#gridProcess').datagrid('query', {
        Hosp: PHA_COM.Session.HOSPID,
    });
}

function QueryProcessUser() {
    var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP;
    if (TDPP == '') {
	    clearProcessUser()
	    return;
    }
    var DefaultFlag = gridSelect.DefaultFlag;
    var TDPPDesc = gridSelect.TDPPDesc;
    if (DefaultFlag == 'Y' ) {
        $('#btnAddi').addClass('l-btn-disabled');
        $('#btnAddi').css('pointer-events', 'none');
    } else {
        $('#btnAddi').removeClass('l-btn-disabled');
        $('#btnAddi').css('pointer-events', '');
    }
    clearProcessUser()
    $('#gridProcessUser').datagrid('query', {
        TDPP: TDPP,
    });
}

function clearProcess(){
	$('#gridProcess').datagrid('clear');
    $('#gridProcess').datagrid('clearSelections');
}

function clearProcessUser(){
	$('#gridProcessUser').datagrid('clear');
    $('#gridProcessUser').datagrid('clearSelections');
}

function InitDict() {}

function InitGridDict() {
    GridCmbUserAll = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHA_STORE.SSUser().url,
        mode : 'remote',
    },{ SessionField: 'HospId', SessionPos: 3 });
}

function InitgridProcess() {
    var columns = [
        [
            // TDPP,TDPPDesc,level,DefaultFlag,ActiveFlag
            { field: 'TDPP', title: 'TDPP', hidden: true },
            {
                field: 'TDPPDesc',
                title: '流程描述',
                width: 225,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
            { field: 'level', title: '流程等级', align: 'center', width: 100 },
            {
                field: 'DefaultFlag',
                title: '系统流程',
                align: 'center',
                width: 100,
                formatter: DefaultFormatter,
            },
            {
                field: 'ActiveFlag',
                title: '使用状态',
                align: 'center',
                width: 100,
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N',
                    },
                },
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                },
            }/*,
            {
                field: 'UpMove',
                title: '上移',
                align: 'center',
                width: 60,
                formatter: UpMoveFormatter,
            },
            {
                field: 'DownMove',
                title: '下移',
                align: 'center',
                width: 60,
                formatter: DownMoveFormatter,
            }*/
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurProcess.Query',
            QueryName: 'QueryProcess',
            Hosp: session['LOGON.HOSPID'],
        },
        exportXls: false,
        fitColumns: true,
        fit: true,
        columns: columns,
        idField: 'TDPP',
        toolbar: '#gridProcessBar',
        onClickRow: function (rowIndex, rowData) {
             QueryProcessUser();
        },
        onDblClickRow: function (rowIndex, rowData) {
	         if (rowData) {
                if (rowData.DefaultFlag != 'Y') {
                    $(this).datagrid('beginEditRow', {
                        rowIndex: rowIndex,
                        editField: 'configCode',
                    });
                }
             }
        }
    };
    PHA.Grid('gridProcess', dataGridOption);
}

function InitgridProcessUser() {
    var columns = [
        [
            // TDPPI,UserId,UserCode,UserName
            { field: 'TDPPI', title: 'TDPPI', hidden: true },
            {
                field: 'UserId',
                title: '人员描述',
                width: 150,
                descField: 'UserName',
                editor: GridCmbUserAll,
                formatter: function (value, row, index) {
                    return row.UserName;
                },
            },

            { field: 'UserCode', title: '人员代码', align: 'left', width: 150 },
            { field: 'UserName', title: 'UserName', align: 'center', width: 100, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurProcess.Query',
            QueryName: 'QueryProcessAuditUser',
            TDPP: '',
        },
        //fitColumns: true,
        exportXls: false,
        fit: true,
        columns: columns,
        toolbar: '#gridProcessUserBar',
        onClickRow: function (rowIndex, rowData) {
            if (!rowData.TDPPI) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'UserName',
                });
            }
        },
    };
    PHA.Grid('gridProcessUser', dataGridOption);
}

function DefaultFormatter(value, rowData, rowIndex) {
    var DefaultFlag = rowData.DefaultFlag;
    if (DefaultFlag == 'Y')
        return "<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/accept.png' border=0/>";
}

function UpMoveFormatter(value, rowData, rowIndex) {
    var DefaultFlag = rowData.DefaultFlag;
    var TDPP = rowData.TDPP;
    var level = rowData.level;
    if (level != 1)
        return (
            "<a href='#' onclick='MoveProcess(\"" +
            TDPP +
            '","UP")\'><img src=\'../scripts_lib/hisui-0.1.0/dist/css/icons/up_gray.png\' border=0/></a>'
        );
}
function DownMoveFormatter(value, rowData, rowIndex) {
    var DefaultFlag = rowData.DefaultFlag;
    var TDPP = rowData.TDPP;
    var level = rowData.level;
    if (level != 1)
        return (
            "<a href='#' onclick='MoveProcess(\"" +
            TDPP +
            '","DOWN")\'><img src=\'../scripts_lib/hisui-0.1.0/dist/css/icons/down_gray.png\' border=0/></a>'
        );
}

function MoveProcess(TDPP, MoveType) {
    if (TDPP == '') {
        PHA.Popover({ showType: 'show', msg: '请选中一行数据', type: 'alert' });
        return;
    }
    if (MoveType == '') {
        PHA.Popover({ showType: 'show', msg: '未选择移动类型', type: 'alert' });
        return;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurProcess.Save',
            MethodName: 'MoveProcess',
            TDPP: TDPP,
            MoveType: MoveType,
        },
        function (retData) {
            if (retData.code>=0) {
                PHA.Popover({
                    showType: 'show',
                    msg: '移动成功',
                    type: 'success',
                });
                QueryProcess();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData.desc,
                    type: 'alert',
                });
        }
    );
}

// 新增行
function AddNewRow() {
    $('#gridProcess').datagrid('addNewRow', {
        editField: 'TDPPDesc',
        defaultRow: {
            ActiveFlag: 'Y',
        },
    });
    clearProcessUser();
}

// 新增行
function AddNewRowi() {
	
	var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP || '';
    if (TDPP == '') {
	    DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选择一个流程',
            type: 'alert',
        });
	    return;
    }
	
    $('#gridProcessUser').datagrid('addNewRow', {
        editField: 'UserId',
    });
}

function SaveProcess() {
    $('#gridProcess').datagrid('endEditing');
    var gridChanges = $('#gridProcess').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert',
        });
        return;
    }
    // TDPP,TDPPDesc,level,DefaultFlag,ActiveFlag
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var TDPPDesc=iData.TDPPDesc || ''
        if(!TDPPDesc) continue;
        var params =
            (iData.TDPP || '') + '^' + (iData.TDPPDesc || '') + '^' + (iData.ActiveFlag || '');
        if (params.replace(/\^/g, '') == '') continue;
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if (paramsStr == '') {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的明细！', type: 'alert' });
        return;
    }
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurProcess.Save',
            MethodName: 'Save',
            Hosp: PHA_COM.Session.HOSPID,
            paramsStr: paramsStr,
        },
        function (retData) {
            if (retData.code>=0) {
                PHA.Popover({
                    showType: 'show',
                    msg: '保存成功',
                    type: 'success',
                });
                QueryProcess();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData.desc,
                    type: 'alert',
                });
        }
    );
}

function DeleteProcess() {
    var gridSelect = $('#gridProcess').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert',
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var TDPP = gridSelect.TDPP || '';
            if (TDPP == '') {
                var rowIndex = $('#gridProcess').datagrid('getRowIndex', gridSelect);
                $('#gridProcess').datagrid('deleteRow', rowIndex);
            } else {
                $.cm(
                    {
                        ClassName: 'PHA.IN.TmpDrugPurProcess.Save',
                        MethodName: 'DeleteProcess',
                        TDPP: TDPP,
                    },
                    function (retData) {
                        if (retData.code>=0) {
                            PHA.Popover({
                                showType: 'show',
                                msg: '删除成功',
                                type: 'success',
                            });
                            QueryProcess();
                            clearProcessUser();
                        } else
                            PHA.Popover({
                                showType: 'show',
                                msg: retData.desc,
                                type: 'alert',
                            });
                    }
                );
            }
        }
    });
}

function SaveProcessUser() {
    $('#gridProcessUser').datagrid('endEditing');
    var gridChanges = $('#gridProcessUser').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert',
        });
        return;
    }
    // TDPP,TDPPDesc,level,DefaultFlag,ActiveFlag
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var UserId = iData.UserId || '';
        var UserName = iData.UserName || '';
        if (UserId == '') continue;
        if (UserId == UserName) continue;
        paramsStr = paramsStr == '' ? UserId : paramsStr + '^' + UserId;
    }
    if (paramsStr == '') {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的明细！', type: 'alert' });
        return;
    }
    
    var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP;
    if (TDPP == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一条流程记录！', type: 'alert' });
        return;
    }

    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurProcess.Save',
            MethodName: 'SaveUser',
            TDPP: TDPP,
            paramsStr: paramsStr,
        },
        function (retData) {
            if (retData.code>=0) {
                PHA.Popover({
                    showType: 'show',
                    msg: '保存成功',
                    type: 'success',
                });
                QueryProcessUser();
            } else
                PHA.Popover({
                    showType: 'show',
                    msg: retData.desc,
                    type: 'alert',
                });
        }
    );
}

function DeleteProcessUser() {
    var gridSelect = $('#gridProcessUser').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert',
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var TDPPI = gridSelect.TDPPI || '';
            if (TDPPI == '') {
                var rowIndex = $('#gridProcessUser').datagrid('getRowIndex', gridSelect);
                $('#gridProcessUser').datagrid('deleteRow', rowIndex);
            } else {
                $.cm(
                    {
                        ClassName: 'PHA.IN.TmpDrugPurProcess.Save',
                        MethodName: 'DeleteProcessUser',
                        TDPPI: TDPPI,
                    },
                    function (retData) {
                        if (!retData) {
                            PHA.Popover({
                                showType: 'show',
                                msg: '删除成功',
                                type: 'success',
                            });
                            QueryProcessUser();
                        } else
                            PHA.Popover({
                                showType: 'show',
                                msg: '删除失败:' + retData,
                                type: 'alert',
                            });
                    }
                );
            }
        }
    });
}
