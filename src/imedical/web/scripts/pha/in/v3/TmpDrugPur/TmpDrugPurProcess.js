/**
 * ģ��:     �ٹ���������
 * ��д����: 2020-09-20
 * ��д��:   yangshijie
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
    //����ѡ���¼�
    $('#_HospList').combogrid('options').onSelect = function (index, record) {
        var newHospId = record.HOSPRowId;
        var oldHospId = PHA_COM.Session.HOSPID;
        if (newHospId != oldHospId) {
            PHA_COM.Session.HOSPID = newHospId;
            PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
            //ҽԺ�任ʱ�ֵ�Ҳ��Ҫ����
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
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����ݣ�', type: 'alert' });
        return;
    }
    var level = gridSelect.level;
    if (level == 1){
        PHA.Popover({ showType: 'show', msg: '�̶����̲����ƶ���', type: 'alert' });
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
                title: '��������',
                width: 225,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
            { field: 'level', title: '���̵ȼ�', align: 'center', width: 100 },
            {
                field: 'DefaultFlag',
                title: 'ϵͳ����',
                align: 'center',
                width: 100,
                formatter: DefaultFormatter,
            },
            {
                field: 'ActiveFlag',
                title: 'ʹ��״̬',
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
                title: '����',
                align: 'center',
                width: 60,
                formatter: UpMoveFormatter,
            },
            {
                field: 'DownMove',
                title: '����',
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
                title: '��Ա����',
                width: 150,
                descField: 'UserName',
                editor: GridCmbUserAll,
                formatter: function (value, row, index) {
                    return row.UserName;
                },
            },

            { field: 'UserCode', title: '��Ա����', align: 'left', width: 150 },
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
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ������', type: 'alert' });
        return;
    }
    if (MoveType == '') {
        PHA.Popover({ showType: 'show', msg: 'δѡ���ƶ�����', type: 'alert' });
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
                    msg: '�ƶ��ɹ�',
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

// ������
function AddNewRow() {
    $('#gridProcess').datagrid('addNewRow', {
        editField: 'TDPPDesc',
        defaultRow: {
            ActiveFlag: 'Y',
        },
    });
    clearProcessUser();
}

// ������
function AddNewRowi() {
	
	var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP || '';
    if (TDPP == '') {
	    DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ��һ������',
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
            msg: 'û����Ҫ���������',
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
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ�������ϸ��', type: 'alert' });
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
                    msg: '����ɹ�',
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
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert',
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
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
                                msg: 'ɾ���ɹ�',
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
            msg: 'û����Ҫ���������',
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
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ�������ϸ��', type: 'alert' });
        return;
    }
    
    var gridSelect = $('#gridProcess').datagrid('getSelected') || '';
    var TDPP = '';
    if (gridSelect) TDPP = gridSelect.TDPP;
    if (TDPP == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ�����̼�¼��', type: 'alert' });
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
                    msg: '����ɹ�',
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
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert',
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
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
                                msg: 'ɾ���ɹ�',
                                type: 'success',
                            });
                            QueryProcessUser();
                        } else
                            PHA.Popover({
                                showType: 'show',
                                msg: 'ɾ��ʧ��:' + retData,
                                type: 'alert',
                            });
                    }
                );
            }
        }
    });
}
