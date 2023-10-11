/**
 * ģ��		: �������ݲ�����־
 * ��д����	: 2021-12-29
 * ��д��	: yangsj
 */
 
PHA_COM.ResizePhaColParam.auto = false;
$(function () {
	InitHosp();		// ��ʼ��ҽԺ
    InitDict();    	// ��ʼ���ֵ�
    InitGrid();    	// ��ʼ�����
    
    Query();
    
    if (PHA_COM.IsLiteCss) {
	    $('#dialogLayoutCenter').css('border', '1px solid #e2e2e2');
	}
});

function InitHosp(){
}

function InitDict(){
	/* ��ʼ���� */
	$('#startDate').datebox('setValue', 't-3');
	
	/* ��ֹ���� */
	$('#endDate').datebox('setValue', 't');
	
	/* ������ */
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
            { field: 'dclId', 			title: '��־ID', 		hidden: false },
            { field: 'classNameDesc', 	title: '��������',  	align: 'left',		width: 200},  
            { field: 'tableName', 		title: '������',  		align: 'left',		width: 220},  
            { field: 'className', 		title: '������',  		align: 'left',		width: 220},  
            { field: 'operateType', 	title: '��������',  	align: 'center',	width: 70,		formatter:OperateTypeFormatter},
            { field: 'updateUserName', 	title: '������',  		align: 'left',		width: 100},  
            { field: 'objectReference', title: '����ID',  		align: 'left',		width: 80},  
            { field: 'objectDesc', 		title: '��������',  	align: 'left',		width: 100},  
            { field: 'ipAddress', 		title: '������IP',  	align: 'left',		width: 100},  
            { field: 'updateDate', 		title: '��������',  	align: 'left',		width: 100},  
            { field: 'updateTime', 		title: '����ʱ��',  	align: 'left',		width: 100},  
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
            { field: 'fieldCode', 	title: '�ֶ�', 		align: 'left',		width: 200},
            { field: 'fieldName', 	title: '����',  	align: 'left',		width: 150},  
            { field: 'oldVal', 		title: 'ԭֵ',  	align: 'left',		width: 80},  
            { field: 'newVal', 		title: '��ֵ',  	align: 'left',		width: 80,		styler:NewValStyler}, 
            { field: 'drTalbe', 	title: 'ָ���',  	align: 'left',		width: 200,  	formatter:DrFormatter}, 
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
        return '<font color="#21ba45">'+$g("�½�")+'</font>';
    } 
    else if (value == 'U'){
        return '<font color="#f1c516">'+$g("�޸�")+'</font>';
    } 
    else if (value == 'D'){
        return '<font color="#f16e57">'+$g("ɾ��")+'</font>';
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
            { field: 'fieldCode', 	title: '�ֶ�', 		align: 'left',		width: 200},
            { field: 'fieldName', 	title: '����',  	align: 'left',		width: 150},  
            { field: 'oldVal', 		title: 'ԭֵ',  	align: 'left',		width: 80},  
            { field: 'newVal', 		title: '��ֵ',  	align: 'left',		width: 80,		styler:NewValStyler}, 
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
    QueryDr(pJson); //����˴������µ�һ���ѯ������Ĭ�ϲ�������ִ�в�ѯ����
    
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