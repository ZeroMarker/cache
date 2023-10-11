/**
 * ģ��:	����ҩƷ�Զ������
 * ��д����: 2020-11-01
 * ��д��:  yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var SessionHosp = session['LOGON.HOSPID'];
var searchboxWidth = 232;
$(function () {
	InitDict();
    InitGrid();
    InitBtn();
    
    InitEvent();
    Queryloc();
});

function InitGrid() {
    InitLoc();
    InitConstGroup();
    InitConstGroupItm();
    InitInciIn();
    InitInciOut();
    InitConstGroupItmUser();
}

function InitBtn() {
    //�Զ������
    $('#btnAddCG').on('click', AddCG);
    $('#btnSaveCG').on('click', SaveCG);
    $('#btnDeleteCG').on('click', DeleteCG);
    //����С��
    $('#btnAddCGi').on('click', AddCGi);
    $('#btnSaveCGi').on('click', SaveCGi);
    $('#btnDelCGi').on('click', DeleteCGi);
    // ����С����Ա��Ȩ
    $('#btnAddCGiU').on('click', AddCGiU);
    $('#btnSaveCGiU').on('click', SaveCGiU);
    $('#btnDelCGiU').on('click', DeleteCGiU);
    
}

function InitDict() 
{
	    GridCmbUserAll = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHA_STORE.SSUser().url,
    });
}

function InitEvent() {
    /// ����ģ����ѯ
    $('#LocFilter').searchbox({
	    searcher:function(value,name){
	    Queryloc();
	    },
	    width:searchboxWidth,
	    prompt:$g('����ģ����ѯ...')
	});

    /// ��ά��ҩƷ����
    $('#txtAliasIn').searchbox({
	    searcher:function(value,name){
	    QueryInciIn();
	    },
	    width:searchboxWidth,
	    prompt:$g('����ģ����ѯ...')
	});
    
    /// δά��ҩƷ����
    $('#txtAliasOut').searchbox({
	    searcher:function(value,name){
	    QueryInciOut();
	    },
	    width:searchboxWidth,
	    prompt:$g('����ģ����ѯ...')
	});    
  
}



///----------------��ѯ��������---Start--------------///
///��ѯ�����б�
function Queryloc() {
    $('#gridLoc').datagrid('query', {
        GroupId: SessionGroup,
        HospId: SessionHosp,
        StrFilter: $('#LocFilter').searchbox("getValue"),
        page	: 1, 
        rows	: 99999
    });
}

///��ѯ�Զ������
function QueryConstGroup() {
	
	clearLCG();
	clearLCGI();
	clearLCGII();
	clearLCGIU();
	
    var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    var Loc = '';
    if (gridSelect) Loc = gridSelect.Loc;
    if (Loc == '') return;
    $('#gridConstGroup').datagrid('query', {
        Loc: Loc,
        page	: 1, 
        rows	: 99999
    });
}

///��ѯС��
function QueryConstGroupItm() {
	
	clearLCGI();
	clearLCGII();
	clearLCGIU();
	
    var gridSelect = $('#gridConstGroup').datagrid('getSelected') || '';
    var LCG = '';
    if (gridSelect) LCG = gridSelect.LCG;
    if (LCG == '') return;
    $('#gridConstGroupItm').datagrid('query', {
        LCG: LCG,
        page	: 1, 
        rows	: 99999
    });
}

///��ѯ��ά��ҩƷ
function QueryInciIn() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') return;
    $('#gridInciIn').datagrid('query', {
        LCGI: LCGI,
        HospId: SessionHosp,
        InciFilter: $('#txtAliasIn').searchbox("getValue")  
    });
}

///��ѯδά��ҩƷ
function QueryInciOut() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') return;
    $('#gridInciOut').datagrid('query', {
        LCGI: LCGI,
        HospId: SessionHosp,
        InciFilter: $('#txtAliasOut').searchbox("getValue")  
    });
}

///��ѯС����Ȩ��Ա
function QueryIConstGroupItmUser() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') return;
    $('#gridConstGroupItmUser').datagrid('query', {
        LCGI: LCGI,
        HospId: SessionHosp,
    });
}


///----------------��ѯ��������---End--------------///

///----------------�����������---Start--------------///

function clearLCG()
{
	$('#gridConstGroup').datagrid('clear');
    $('#gridConstGroup').datagrid('clearSelections');
} 

function clearLCGI()
{
	$('#gridConstGroupItm').datagrid('clear');
    $('#gridConstGroupItm').datagrid('clearSelections');
} 

function clearLCGII()
{
	$('#gridInciIn').datagrid('clear');
    $('#gridInciIn').datagrid('clearSelections');
    $('#gridInciOut').datagrid('clear');
    $('#gridInciOut').datagrid('clearSelections');
} 

function clearLCGIU()
{
	$('#gridConstGroupItmUser').datagrid('clear');
    $('#gridConstGroupItmUser').datagrid('clearSelections');
} 
    
    
///----------------�����������---End--------------///


///----------------��ʼ��grid����---Start--------------///
/// ��ʼ�������б� �����Ȩ����
function InitLoc() {
    //����columns
    var columns = [
        [
            { field: 'Loc', title: 'Loc', width: 100, hidden: true },
            { field: 'LocCode', title: '���Ҵ���', width: 100, align: 'left' },
            { field: 'LocDesc', title: '��������', width: 140, align: 'left' },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryLoc',
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        idField: 'Loc',
        rownumbers: true,
        columns: columns,
        toolbar: '#gridLocBar',
        onClickRow: function (rowIndex, rowData) {
            QueryConstGroup();
        },
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {/*QueryConstGroup()*/},
    };
    PHA.Grid('gridLoc', dataGridOption);
}

/// ��ʼ���Զ������
function InitConstGroup() {
    var columns = [
        [
            // LCG ,LCGCode,LCGDesc
            { field: 'LCG', title: 'LCG', hidden: true, align: 'center' },
            {
                field: 'LCGCode',
                title: '����',
                width: 80,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
            {
                field: 'LCGDesc',
                title: '����',
                width: 150,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryLCG',
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        idField: 'LCG',
        rownumbers: true,
        columns: columns,
        toolbar: '#gridConstGroupBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            var editIndex = $(this).datagrid('options').editIndex
            if (editIndex == undefined) {
                QueryConstGroupItm();
            }
            else {
	            var nextRow=editIndex+1
                PHA.Popover({ showType: 'show', msg: '�� ' + nextRow + " �б�����δ����Ȳ�������", type: 'alert' });
        		return;
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'LCGCode',
            });
        },
        onLoadSuccess: function () {/*QueryConstGroupItm()*/},
    };
    PHA.Grid('gridConstGroup', dataGridOption);
}

/// ��ʼ������С��
function InitConstGroupItm() {
    var columns = [
        [
            //LCGI,LCGICode,LCGIDesc
            { field: 'LCGI', title: 'LCGI', hidden: true },
            {
                field: 'LCGICode',
                title: '����',
                width: 80,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
            {
                field: 'LCGIDesc',
                title: '����',
                width: 150,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    },
                },
            },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryLCGItm',
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        idField: 'LCGI',
        rownumbers: true,
        columns: columns,
        toolbar: '#gridConstGroupItmBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            var editIndex = $(this).datagrid('options').editIndex
            if (editIndex == undefined) {
	            QueryIConstGroupItmUser();
	            QueryInciIn();
	            QueryInciOut();
            }
            else {
	            var nextRow=editIndex+1
                PHA.Popover({ showType: 'show', msg: '�� ' + nextRow + " �б�����δ����Ȳ�������", type: 'alert' });
        		return;
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'desc',
            });
        },
        onLoadSuccess: function () {
            /*QueryIConstGroupItmUser();*/
            /*QueryInciIn();*/
            /*QueryInciOut();*/
        },
    };
    PHA.Grid('gridConstGroupItm', dataGridOption);
}

//��ʼ���ѷ���ҩƷ�б�
function InitInciIn() {
    //����columns
    var columns = [
        [
            // LCGII,InciCode,InciDesc
            { field: 'LCGII', title: 'LCGII', width: 100, hidden: true },
            {
                field: 'operate',
                title: '����',
                width: 60,
                align: 'center',
                formatter: statusFormatterDel,
            },
            { field: 'InciCode', title: 'ҩƷ����', width: 120, align: 'left' },
            { field: 'InciDesc', title: 'ҩƷ����', width: 240, align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryInciIn',
        },
        pagination: true,
        fitColumns: true,
        fit: true,
        idField: 'LCGII',
        rownumbers: true,
        columns: columns,
        toolbar: '#InciInlBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        showPageList: false, 
        showRefresh: false,
		afterPageText: 'ҳ,��{pages}ҳ', 
        beforePageText: '��',
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciIn', dataGridOption);
}
//��ʼ��δ����ҩƷ�б�
function InitInciOut() {
    //����columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'inci', title: 'inci', width: 100, hidden: true },
            {
                field: 'operate',
                title: '����',
                width: 60,
                align: 'center',
                formatter: statusFormatterAdd,
            },
            { field: 'incicode', title: 'ҩƷ����', width: 120, align: 'left' },
            { field: 'incidesc', title: 'ҩƷ����', width: 240, align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryInciOut',
        },
        toolbar: '#toolbar', //���ֲ��ı�߶�
        pagination: true,
        fitColumns: true,
        fit: true,
        idField: 'inci',
        rownumbers: true,
        columns: columns,
        toolbar: '#InciOutBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        showPageList: false, 
        showRefresh: false,
		afterPageText: 'ҳ,��{pages}ҳ', 
        beforePageText: '��',
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciOut', dataGridOption);
}



//��ʼ������С����Ա��Ȩ
function InitConstGroupItmUser() {
    //����columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'LCGIU', title: 'LCGIU', width: 100, hidden: true },
            { field: 'UserCode', title: '��Ա����', width: 140, align: 'left' },
            {
                field: 'UserId',
                title: '��Ա����',
                width: 225,
                descField: 'UserName',
                editor: GridCmbUserAll,
                formatter: function (value, row, index) {
                    return row.UserName;
                },
            },
            { field: 'UserName', title: '��Ա����', width: 120, align: 'left',hidden: true },
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryLCGItmUser',
        },
        toolbar: '#toolbar', //���ֲ��ı�߶�
        pagination: false,
        fitColumns: true,
        fit: true,
        idField: 'LCGIU',
        rownumbers: true,
        columns: columns,
        toolbar: '#gridConstGroupItmUserBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridConstGroupItmUser', dataGridOption);
}

///----------------��ʼ��grid����---End--------------///

///----------------�б༭��������---Start--------------///

/// �����Զ������������
function AddCG() {
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect=="")
    {
        PHA.Popover({ showType: 'show', msg: '��ѡ�����', type: 'alert' });
        return;
    }
    var Loc = '';
    if (gridSelect) Loc = gridSelect.Loc || '';
    if (Loc == '') 
    {
        PHA.Popover({ showType: 'show', msg: '��ѡ�����', type: 'alert' });
        return;
    }
    $('#gridConstGroup').datagrid('addNewRow', {
        editField: 'LCGCode',
    });
    $('#gridConstGroupItm').datagrid('clear');
}

/// ����С��������
function AddCGi() {
    var gridSelect = $('#gridConstGroup').datagrid('getSelected') || '';
    if (gridSelect=="") 
    {
        PHA.Popover({ showType: 'show', msg: '��ѡ������Զ������', type: 'alert' });
        return;
    }
    var LCG = '';
    if (gridSelect) LCG = gridSelect.LCG || '';
    if (LCG == '') 
    {
        PHA.Popover({ showType: 'show', msg: '��ѡ������Զ������', type: 'alert' });
        return;
    }
    $('#gridConstGroupItm').datagrid('addNewRow', {
        editField: 'LCGICode',
    });
    $('#gridInciIn').datagrid('clear');
    $('#gridConstGroupItmUser').datagrid('clear');
    $('#gridInciOut').datagrid('clear');
       
}


/// С����Ȩ��Ա����
function AddCGiU() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    if (gridSelect=="")
    {
        PHA.Popover({ showType: 'show', msg: '��ѡ�����С��', type: 'alert' });
        return;
    }
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI || '';
    if (LCGI == '')
     {
        PHA.Popover({ showType: 'show', msg: '��ѡ�����С��', type: 'alert' });
        return;
    }
    $('#gridConstGroupItmUser').datagrid('addNewRow', {
        editField: 'UserId',
    });
}

///----------------�б༭��������---End--------------///

///----------------���淽������---Start--------------///
/// ��������Զ������
function SaveCG() {
    var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    var Loc = '';
    if (gridSelect) Loc = gridSelect.Loc;
    if (Loc == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ�����', type: 'alert' });
        return;
    }

    $('#gridConstGroup').datagrid('endEditing');
    var gridChanges = $('#gridConstGroup').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var paramsStr = '';
    // LCG ,LCGCode,LCGDesc
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.LCG || '') + '^' + (iData.LCGCode || '') + '^' + (iData.LCGDesc || '');
        if (params != '^^') paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if(paramsStr=="")
    {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var saveRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'SaveCG', Loc, paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: saveInfo, type: 'alert' });
    }
    QueryConstGroup();
}

/// �������С��
function SaveCGi() {
    if ($("#gridConstGroup").datagrid('options').editIndex != undefined) {
	     PHA.Popover({ showType: 'show', msg: '���ȱ����Զ������', type: 'alert' });
        return;
    }
    var gridSelect = $('#gridConstGroup').datagrid('getSelected') || '';
    var LCG = '';
    if (gridSelect) LCG = gridSelect.LCG;
    if (LCG == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡһ���Զ������', type: 'alert' });
        return;
    }

    $('#gridConstGroupItm').datagrid('endEditing');
    var gridChanges = $('#gridConstGroupItm').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var paramsStr = '';
    // LCG ,LCGCode,LCGDesc
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =(iData.LCGI || '') + '^' + (iData.LCGICode || '') + '^' + (iData.LCGIDesc || '');
        if (params != '^^') paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if(paramsStr=="")
    {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var saveRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'SaveCGI', LCG, paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: saveInfo, type: 'alert' });
    }
    QueryConstGroupItm();
}


/// �������С�����Ȩ��Ա
function SaveCGiU() {
	if ($("#gridConstGroupItm").datagrid('options').editIndex != undefined) {
	     PHA.Popover({ showType: 'show', msg: '���ȱ������С��', type: 'alert' });
        return;
    }
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡһ������С��', type: 'alert' });
        return;
    }

    $('#gridConstGroupItmUser').datagrid('endEditing');
    var gridChanges = $('#gridConstGroupItmUser').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var paramsStr = '';
    // LCG ,LCGCode,LCGDesc
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =
            (iData.LCGIU || '') + '^' + (iData.UserId || '') ;
        if (params != '^') paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if(paramsStr=="")
    {
        PHA.Popover({ showType: 'show', msg: 'û����Ҫ���������', type: 'alert' });
        return;
    }
    var saveRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'SaveLCGIU', LCGI, paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: saveInfo, type: 'alert' });
    }
    QueryIConstGroupItmUser();
}


///----------------���淽������---End--------------///
///----------------ɾ����������---Start--------------///
/// ɾ���Զ������
function DeleteCG() {
    var gridSelect = $('#gridConstGroup').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫɾ���ļ�¼!', type: 'alert' });
        return;
    }
    PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
        var LCG = gridSelect.LCG || '';
        if (LCG == '') {
            var rowIndex = $('#gridConstGroup').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroup').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCG', LCG);
            var delRetArr = delRet.split('^')
            if (delRetArr[0] == 0) {
                PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�', type: 'success' });
                QueryConstGroup();
            }
            else {
                PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                 return;
            }
        }
    });
}
/// ɾ���Զ������С��
function DeleteCGi() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫɾ���ļ�¼!', type: 'alert' });
        return;
    }
    PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
        var LCGI = gridSelect.LCGI || '';
        if (LCGI == '') {
            var rowIndex = $('#gridConstGroupItm').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroupItm').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCGI', LCGI);     
            var delRetArr = delRet.split('^')
            if (delRetArr[0] == 0) {
                PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�', type: 'success' });
                QueryConstGroupItm();
            }
            else {
                PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                 return;
            }
        }
    });
}

/// ɾ��С����Ȩ��Ա
function DeleteCGiU() {
    var gridSelect = $('#gridConstGroupItmUser').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫɾ���ļ�¼!', type: 'alert' });
        return;
    }
    PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
        var LCGIU = gridSelect.LCGIU || '';
        if (LCGIU == '') {
            var rowIndex = $('#gridConstGroupItmUser').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroupItmUser').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCGIU', LCGIU);
            if (delRet == 0) {
                PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�', type: 'success' });
                QueryIConstGroupItmUser();
            }
        }
    });
}



///----------------ɾ����������---End--------------///

///----------------Formatter��������---Start--------------///

function statusFormatterDel(value, rowData, rowIndex) {
    //������󴫲���ȥ,ת���ַ����ʹ���ȥ��,��Ӧ��������ȡֵ�ֳ��˶���
    var dataString = JSON.stringify(rowData);
    var IndexString = JSON.stringify(rowIndex);
    var LCGII = rowData.rowData;
    return (
        "<span class='icon-cancel' style='cursor:pointer;width: 24px;height: 16px;display: inline-block;' onclick='delInci(" +
        dataString +
        ',+' +
        IndexString +
        ")'>&ensp;</span>"
    );
}

function statusFormatterAdd(value, rowData, rowIndex) {
    //������󴫲���ȥ,ת���ַ����ʹ���ȥ��,��Ӧ��������ȡֵ�ֳ��˶���
    var dataString = JSON.stringify(rowData);
    var IndexString = JSON.stringify(rowIndex);
    return (
        "<span class='icon-add' style='cursor:pointer;width: 24px;height: 16px;display: inline-block;' onclick='addInci(" +
        dataString +
        ',+' +
        IndexString +
        ")'>&ensp;</span>"
    );
}

/// ���ҩƷ
function addInci(rowData, Index) {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��һ������С��!', type: 'alert' });
        return;
    }
    var inci = rowData.inci || '';
    if (inci == '') {
        PHA.Popover({ showType: 'show', msg: '��ѡ��Ҫ��ӵ�ҩƷ', type: 'alert' });
        return;
    }
    var saveRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'addInci', LCGI, inci);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: '���ʧ��' + saveInfo, type: 'alert' });
        return;
    } else {
        PHA.Popover({ showType: 'show', msg: '��ӳɹ�', type: 'success' });
        $('#gridInciIn').datagrid('reload');
        $('#gridInciOut').datagrid('reload');
    }
}

/// ɾ��ҩƷ
function delInci(rowData, Index) {
    if (rowData == null) {
        PHA.Popover({ showType: 'show', msg: '��ѡ����Ҫɾ���ļ�¼!', type: 'alert' });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
            var LCGII = rowData.LCGII || '';
            if (LCGII == '') {
                $('#StatInciDetail').datagrid('deleteRow', Index);
            } else {
                var Ret = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'delInci', LCGII);
                if (Ret == 0) {
                    PHA.Popover({ showType: 'show', msg: 'ɾ���ɹ�', type: 'success' });
                    $('#gridInciIn').datagrid('reload');
                    $('#gridInciOut').datagrid('reload');
                } else {
                    PHA.Popover({ showType: 'show', msg: 'ɾ��ʧ��' + saveInfo, type: 'alert' });
                    return;
                }
            }
        }
    });
}

///----------------Formatter��������---End--------------///