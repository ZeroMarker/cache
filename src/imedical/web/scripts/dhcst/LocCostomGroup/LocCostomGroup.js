/**
 * 模块:	科室药品自定义分类
 * 编写日期: 2020-11-01
 * 编写人:  yangsj
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
    //自定义分类
    $('#btnAddCG').on('click', AddCG);
    $('#btnSaveCG').on('click', SaveCG);
    $('#btnDeleteCG').on('click', DeleteCG);
    //分类小类
    $('#btnAddCGi').on('click', AddCGi);
    $('#btnSaveCGi').on('click', SaveCGi);
    $('#btnDelCGi').on('click', DeleteCGi);
    // 分类小类人员授权
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
    /// 科室模糊查询
    $('#LocFilter').searchbox({
	    searcher:function(value,name){
	    Queryloc();
	    },
	    width:searchboxWidth,
	    prompt:$g('科室模糊查询...')
	});

    /// 已维护药品别名
    $('#txtAliasIn').searchbox({
	    searcher:function(value,name){
	    QueryInciIn();
	    },
	    width:searchboxWidth,
	    prompt:$g('别名模糊查询...')
	});
    
    /// 未维护药品别名
    $('#txtAliasOut').searchbox({
	    searcher:function(value,name){
	    QueryInciOut();
	    },
	    width:searchboxWidth,
	    prompt:$g('别名模糊查询...')
	});    
  
}



///----------------查询方法集中---Start--------------///
///查询科室列表
function Queryloc() {
    $('#gridLoc').datagrid('query', {
        GroupId: SessionGroup,
        HospId: SessionHosp,
        StrFilter: $('#LocFilter').searchbox("getValue"),
        page	: 1, 
        rows	: 99999
    });
}

///查询自定义分类
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

///查询小类
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

///查询已维护药品
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

///查询未维护药品
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

///查询小类授权人员
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


///----------------查询方法集中---End--------------///

///----------------清除方法集中---Start--------------///

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
    
    
///----------------清除方法集中---End--------------///


///----------------初始化grid集中---Start--------------///
/// 初始化科室列表 库存授权科室
function InitLoc() {
    //定义columns
    var columns = [
        [
            { field: 'Loc', title: 'Loc', width: 100, hidden: true },
            { field: 'LocCode', title: '科室代码', width: 100, align: 'left' },
            { field: 'LocDesc', title: '科室名称', width: 140, align: 'left' },
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

/// 初始化自定义分类
function InitConstGroup() {
    var columns = [
        [
            // LCG ,LCGCode,LCGDesc
            { field: 'LCG', title: 'LCG', hidden: true, align: 'center' },
            {
                field: 'LCGCode',
                title: '代码',
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
                title: '描述',
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
                PHA.Popover({ showType: 'show', msg: '第 ' + nextRow + " 行必填项未填，请先补充必填项！", type: 'alert' });
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

/// 初始化分类小类
function InitConstGroupItm() {
    var columns = [
        [
            //LCGI,LCGICode,LCGIDesc
            { field: 'LCGI', title: 'LCGI', hidden: true },
            {
                field: 'LCGICode',
                title: '代码',
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
                title: '描述',
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
                PHA.Popover({ showType: 'show', msg: '第 ' + nextRow + " 行必填项未填，请先补充必填项！", type: 'alert' });
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

//初始化已分类药品列表
function InitInciIn() {
    //定义columns
    var columns = [
        [
            // LCGII,InciCode,InciDesc
            { field: 'LCGII', title: 'LCGII', width: 100, hidden: true },
            {
                field: 'operate',
                title: '操作',
                width: 60,
                align: 'center',
                formatter: statusFormatterDel,
            },
            { field: 'InciCode', title: '药品代码', width: 120, align: 'left' },
            { field: 'InciDesc', title: '药品名称', width: 240, align: 'left' },
            
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
		afterPageText: '页,共{pages}页', 
        beforePageText: '第',
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciIn', dataGridOption);
}
//初始化未分类药品列表
function InitInciOut() {
    //定义columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'inci', title: 'inci', width: 100, hidden: true },
            {
                field: 'operate',
                title: '操作',
                width: 60,
                align: 'center',
                formatter: statusFormatterAdd,
            },
            { field: 'incicode', title: '药品代码', width: 120, align: 'left' },
            { field: 'incidesc', title: '药品名称', width: 240, align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryInciOut',
        },
        toolbar: '#toolbar', //保持不改变高度
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
		afterPageText: '页,共{pages}页', 
        beforePageText: '第',
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciOut', dataGridOption);
}



//初始化分类小类人员授权
function InitConstGroupItmUser() {
    //定义columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'LCGIU', title: 'LCGIU', width: 100, hidden: true },
            { field: 'UserCode', title: '人员代码', width: 140, align: 'left' },
            {
                field: 'UserId',
                title: '人员姓名',
                width: 225,
                descField: 'UserName',
                editor: GridCmbUserAll,
                formatter: function (value, row, index) {
                    return row.UserName;
                },
            },
            { field: 'UserName', title: '人员姓名', width: 120, align: 'left',hidden: true },
            
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.LocCostomGroup.Query',
            QueryName: 'QueryLCGItmUser',
        },
        toolbar: '#toolbar', //保持不改变高度
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

///----------------初始化grid集中---End--------------///

///----------------行编辑方法集中---Start--------------///

/// 科室自定义分类增加行
function AddCG() {
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect=="")
    {
        PHA.Popover({ showType: 'show', msg: '请选择科室', type: 'alert' });
        return;
    }
    var Loc = '';
    if (gridSelect) Loc = gridSelect.Loc || '';
    if (Loc == '') 
    {
        PHA.Popover({ showType: 'show', msg: '请选择科室', type: 'alert' });
        return;
    }
    $('#gridConstGroup').datagrid('addNewRow', {
        editField: 'LCGCode',
    });
    $('#gridConstGroupItm').datagrid('clear');
}

/// 分类小类增加行
function AddCGi() {
    var gridSelect = $('#gridConstGroup').datagrid('getSelected') || '';
    if (gridSelect=="") 
    {
        PHA.Popover({ showType: 'show', msg: '请选择科室自定义分类', type: 'alert' });
        return;
    }
    var LCG = '';
    if (gridSelect) LCG = gridSelect.LCG || '';
    if (LCG == '') 
    {
        PHA.Popover({ showType: 'show', msg: '请选择科室自定义分类', type: 'alert' });
        return;
    }
    $('#gridConstGroupItm').datagrid('addNewRow', {
        editField: 'LCGICode',
    });
    $('#gridInciIn').datagrid('clear');
    $('#gridConstGroupItmUser').datagrid('clear');
    $('#gridInciOut').datagrid('clear');
       
}


/// 小类授权人员增加
function AddCGiU() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    if (gridSelect=="")
    {
        PHA.Popover({ showType: 'show', msg: '请选择分类小类', type: 'alert' });
        return;
    }
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI || '';
    if (LCGI == '')
     {
        PHA.Popover({ showType: 'show', msg: '请选择分类小类', type: 'alert' });
        return;
    }
    $('#gridConstGroupItmUser').datagrid('addNewRow', {
        editField: 'UserId',
    });
}

///----------------行编辑方法集中---End--------------///

///----------------保存方法集中---Start--------------///
/// 保存科室自定义分类
function SaveCG() {
    var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    var Loc = '';
    if (gridSelect) Loc = gridSelect.Loc;
    if (Loc == '') {
        PHA.Popover({ showType: 'show', msg: '请选择科室', type: 'alert' });
        return;
    }

    $('#gridConstGroup').datagrid('endEditing');
    var gridChanges = $('#gridConstGroup').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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

/// 保存分类小类
function SaveCGi() {
    if ($("#gridConstGroup").datagrid('options').editIndex != undefined) {
	     PHA.Popover({ showType: 'show', msg: '请先保存自定义分类', type: 'alert' });
        return;
    }
    var gridSelect = $('#gridConstGroup').datagrid('getSelected') || '';
    var LCG = '';
    if (gridSelect) LCG = gridSelect.LCG;
    if (LCG == '') {
        PHA.Popover({ showType: 'show', msg: '请选一条自定义分类', type: 'alert' });
        return;
    }

    $('#gridConstGroupItm').datagrid('endEditing');
    var gridChanges = $('#gridConstGroupItm').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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


/// 保存分类小类的授权人员
function SaveCGiU() {
	if ($("#gridConstGroupItm").datagrid('options').editIndex != undefined) {
	     PHA.Popover({ showType: 'show', msg: '请先保存分类小类', type: 'alert' });
        return;
    }
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') {
        PHA.Popover({ showType: 'show', msg: '请选一条分类小类', type: 'alert' });
        return;
    }

    $('#gridConstGroupItmUser').datagrid('endEditing');
    var gridChanges = $('#gridConstGroupItmUser').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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
        PHA.Popover({ showType: 'show', msg: '没有需要保存的数据', type: 'alert' });
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


///----------------保存方法集中---End--------------///
///----------------删除方法集中---Start--------------///
/// 删除自定义分类
function DeleteCG() {
    var gridSelect = $('#gridConstGroup').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '请选择需要删除的记录!', type: 'alert' });
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        var LCG = gridSelect.LCG || '';
        if (LCG == '') {
            var rowIndex = $('#gridConstGroup').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroup').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCG', LCG);
            var delRetArr = delRet.split('^')
            if (delRetArr[0] == 0) {
                PHA.Popover({ showType: 'show', msg: '删除成功', type: 'success' });
                QueryConstGroup();
            }
            else {
                PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                 return;
            }
        }
    });
}
/// 删除自定义分类小类
function DeleteCGi() {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '请选择需要删除的记录!', type: 'alert' });
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        var LCGI = gridSelect.LCGI || '';
        if (LCGI == '') {
            var rowIndex = $('#gridConstGroupItm').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroupItm').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCGI', LCGI);     
            var delRetArr = delRet.split('^')
            if (delRetArr[0] == 0) {
                PHA.Popover({ showType: 'show', msg: '删除成功', type: 'success' });
                QueryConstGroupItm();
            }
            else {
                PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                 return;
            }
        }
    });
}

/// 删除小类授权人员
function DeleteCGiU() {
    var gridSelect = $('#gridConstGroupItmUser').datagrid('getSelected');
    if (gridSelect == null) {
        PHA.Popover({ showType: 'show', msg: '请选择需要删除的记录!', type: 'alert' });
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        var LCGIU = gridSelect.LCGIU || '';
        if (LCGIU == '') {
            var rowIndex = $('#gridConstGroupItmUser').datagrid('getRowIndex', gridSelect);
            $('#gridConstGroupItmUser').datagrid('deleteRow', rowIndex);
        } else {
            var delRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'DeleteLCGIU', LCGIU);
            if (delRet == 0) {
                PHA.Popover({ showType: 'show', msg: '删除成功', type: 'success' });
                QueryIConstGroupItmUser();
            }
        }
    });
}



///----------------删除方法集中---End--------------///

///----------------Formatter方法集中---Start--------------///

function statusFormatterDel(value, rowData, rowIndex) {
    //好像对象传不进去,转成字符串就传进去了,对应函数内再取值又成了对象
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
    //好像对象传不进去,转成字符串就传进去了,对应函数内再取值又成了对象
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

/// 添加药品
function addInci(rowData, Index) {
    var gridSelect = $('#gridConstGroupItm').datagrid('getSelected') || '';
    var LCGI = '';
    if (gridSelect) LCGI = gridSelect.LCGI;
    if (LCGI == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一条分类小类!', type: 'alert' });
        return;
    }
    var inci = rowData.inci || '';
    if (inci == '') {
        PHA.Popover({ showType: 'show', msg: '请选择要添加的药品', type: 'alert' });
        return;
    }
    var saveRet = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'addInci', LCGI, inci);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg: '添加失败' + saveInfo, type: 'alert' });
        return;
    } else {
        PHA.Popover({ showType: 'show', msg: '添加成功', type: 'success' });
        $('#gridInciIn').datagrid('reload');
        $('#gridInciOut').datagrid('reload');
    }
}

/// 删除药品
function delInci(rowData, Index) {
    if (rowData == null) {
        PHA.Popover({ showType: 'show', msg: '请选择需要删除的记录!', type: 'alert' });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function (r) {
        if (r) {
            var LCGII = rowData.LCGII || '';
            if (LCGII == '') {
                $('#StatInciDetail').datagrid('deleteRow', Index);
            } else {
                var Ret = tkMakeServerCall('PHA.IN.LocCostomGroup.Save', 'delInci', LCGII);
                if (Ret == 0) {
                    PHA.Popover({ showType: 'show', msg: '删除成功', type: 'success' });
                    $('#gridInciIn').datagrid('reload');
                    $('#gridInciOut').datagrid('reload');
                } else {
                    PHA.Popover({ showType: 'show', msg: '删除失败' + saveInfo, type: 'alert' });
                    return;
                }
            }
        }
    });
}

///----------------Formatter方法集中---End--------------///