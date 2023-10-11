/**
 * 模块		: 基础数据操作日志
 * 编写日期	: 2021-12-29
 * 编写人	: yangsj
 */
 
PHA_COM.ResizePhaColParam.auto = false;
$(function () {
	InitHosp();		// 初始化医院
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
    
    Query();
    
    if (PHA_COM.IsLiteCss) {
	    $('#dialogLayoutCenter').css('border', '1px solid #e2e2e2');
	}
});

function InitHosp(){
}

function InitDict(){
	/* 开始日期 */
	$('#startDate').datebox('setValue', 't-3');
	
	/* 截止日期 */
	$('#endDate').datebox('setValue', 't');
	
	/* 操作人 */
    PHA.ComboBox('updateUser', {
        url: PHA_STORE.SSUser().url
    });
}

function InitGrid(){
	InitGridLogList();
	InitGridLogDetailList();
}

function InitGridLogList(){
	var columns = [
        [
            { field: 'dclId', 			title: '日志ID', 		hidden: false },
            { field: 'classNameDesc', 	title: '功能描述',  	align: 'left',		width: 200},  
            { field: 'tableName', 		title: '表名称',  		align: 'left',		width: 220},  
            { field: 'className', 		title: '类名称',  		align: 'left',		width: 220},  
            { field: 'operateType', 	title: '操作类型',  	align: 'center',	width: 70,		formatter:OperateTypeFormatter},
            { field: 'updateUserName', 	title: '操作人',  		align: 'left',		width: 100},  
            { field: 'objectReference', title: '对象ID',  		align: 'left',		width: 80},  
            { field: 'objectDesc', 		title: '对象描述',  	align: 'left',		width: 100},  
            { field: 'ipAddress', 		title: '操作人IP',  	align: 'left',		width: 100},  
            { field: 'updateDate', 		title: '操作日期',  	align: 'left',		width: 100},  
            { field: 'updateTime', 		title: '操作时间',  	align: 'left',		width: 100},  
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.Basedatalog.Api',
            pMethodName: 'QueryLogList',
            pPlug	   : "datagrid",
            pJsonStr   : "{}",
        },
        pagination: true,
        //fitColumns: true,
        fit: true,
        idField: 'dclId',
        columns: columns,
        toolbar: '#GridLogListBar',  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData) {QueryDetail();},
	    onDblClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('GridLogList', dataGridOption);
}

function InitGridLogDetailList(){
	var columns = [   
        [
        	//fieldCode, fieldName, oldVal, newVal, drTalbe
            { field: 'fieldCode', 	title: '字段', 		align: 'left',		width: 200},
            { field: 'fieldName', 	title: '名称',  	align: 'left',		width: 150},  
            { field: 'oldVal', 		title: '原值',  	align: 'left',		width: 80},  
            { field: 'newVal', 		title: '新值',  	align: 'left',		width: 80,		styler:NewValStyler}, 
            { field: 'drTalbe', 	title: '指向表',  	align: 'left',		width: 200,  	formatter:DrFormatter}, 
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.Basedatalog.Api',
            pMethodName: 'QueryDetailList',
            pPlug	   : "datagrid",
            pJsonStr   : "{}",
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        columns: columns,
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData) {},
	    onDblClickRow: function (rowIndex, rowData) {}
    };
    PHA.Grid('GridLogDetailList', dataGridOption);
}


function OperateTypeFormatter(value, row, index){
	if (value == 'A') {
        return '<font color="#21ba45">'+$g("新建")+'</font>';
    } 
    else if (value == 'U'){
        return '<font color="#f1c516">'+$g("修改")+'</font>';
    } 
    else if (value == 'D'){
        return '<font color="#f16e57">'+$g("删除")+'</font>';
    }
    else {
	    return value;
    }
}



function NewValStyler(value, row, index,data)
{
	var oldVal = row.oldVal
	var newVal = row.newVal
	var colorStyle = 'background:white;color:black;';
	if ((newVal != "")&&(newVal != oldVal)) var colorStyle = 'background:#ee4f38;color:white;';
    return colorStyle;
}


function DrFormatter(value, row, index){
	var oldVal = row.oldVal
	var newVal = row.newVal
	if ((oldVal == "")&&(newVal == "")||(value == "")) return value;
	return "<a href='#' onclick='ShowDr(\"" + value + "\",\"" + oldVal + "\",\"" + newVal + "\")'>"+value+"</a>"
}

function ShowDr(value, oldVal, newVal){
    $('#diagDrTable')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
    var columns = [
        [	//FieldCode, FieldName, oldVal, newVal
            { field: 'fieldCode', 	title: '字段', 		align: 'left',		width: 200},
            { field: 'fieldName', 	title: '名称',  	align: 'left',		width: 150},  
            { field: 'oldVal', 		title: '原值',  	align: 'left',		width: 80},  
            { field: 'newVal', 		title: '新值',  	align: 'left',		width: 80,		styler:NewValStyler}, 
        ]
    ];
    //CleanDrTable();
    var pJson = {
	    className : value,
	    oldDr: oldVal,
	    newDr: newVal
    }
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : 'PHA.IN.Basedatalog.Api',
            pMethodName: 'QueryDrTableList',
            pPlug	   : "datagrid",
            pJsonStr   : JSON.stringify(pJson),
        },
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: true,
        enableDnd: false,
        toolbar: '',
        gridSave: false,
        onClickRow: function (rowIndex, rowData) {},
        onDblClickCell: function (rowIndex, field, value) {},
    };
    PHA.Grid('gridDrTable', dataGridOption);
    QueryDr(pJson); //如果此处不重新调一遍查询，可能默认参数不会执行查询方法
    
}

function QueryDr(pJson){
	$('#gridDrTable').datagrid('query', {
        pJsonStr : JSON.stringify(pJson),
    });
}

function Query(){
	//Clean();
	var pJson = PHA.DomData('#GridLogListBar', {
        doType: 'query',
        retType: 'Json'
    });
	$('#GridLogList').datagrid('query', {
        pJsonStr : JSON.stringify(pJson[0]),
    });
}


function QueryDetail(){
	//CleanDetail();
	var dclId = GetDclId();
    if (dclId == "") return;
	$('#GridLogDetailList').datagrid('query', {
        pJsonStr : JSON.stringify({dclId:dclId}),
    });
}
function GetDclId(){
	var gridSelect = $('#GridLogList').datagrid('getSelected') || '';
    var dclId = gridSelect ? gridSelect.dclId : "";
    return dclId
}

function Clean(){
	$('#GridLogList').datagrid('clearSelections');   
	$('#GridLogList').datagrid('clear');
}

function CleanDetail(){
	$('#GridLogDetailList').datagrid('clearSelections');   
	$('#GridLogDetailList').datagrid('clear');
}

function CleanDrTable(){
	$('#GridDrTable').datagrid('clearSelections');   
	$('#GridDrTable').datagrid('clear');
}