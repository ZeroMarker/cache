/**
 * 模块:     库存分类维护
 * 编写日期: 2021-09-26
 * 编写人:   yangsj
 */
$(function () {
	InitHosp();
    InitDict();
    InitGrid();
});

function InitHosp(){
	var hospComp = GenHospComp("INC_StkCat");
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL    = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        Query();
    };
    var defHosp = $cm(
        {
            dataType  : 'text',
            ClassName : 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName : 'INC_StkCat',
            HospID    : PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL    = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){

}

function InitGrid(){
	InitGridStkCat();
}

function InitGridStkCat(){
	var columns = [
        [
            // StkCat, Code, Desc
            { field: 'StkCat', 			title: 'StkCat', 			hidden: true },
            { field: 'Code', 			title: '代码',  		width: 400,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'Desc', 			title: '名称', 			width: 500,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.StkCat.Query',
            QueryName: 'QueryStkCat',
            HospId   : PHA_COM.Session.HOSPID,
            page   	 : 1, 
        	rows   	 : 99999
        },
        gridSave: false,
        pagination: false,
        idField: 'StkCat',
        fitColumns: false,
        columns: columns,
        toolbar: '#GridStkCatBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        $('#GridStkCat').datagrid('endEditing');
	                var editIndex = $(this).datagrid('options').editIndex
		            if (editIndex != undefined) {
		               	var nextRow=editIndex+1
		                PHA.Msg("alert",'第 ' + nextRow + " 行必填项未填，请先补充必填项！");
		        		return;
		            }
			    }
	        },
	    onDblClickRow: function (rowIndex, rowData) { 
	    		$(this).datagrid('beginEditRow', {
	                rowIndex: rowIndex,
	                editField: 'Code',
	            });
	    }
    };
    PHA.Grid('GridStkCat', dataGridOption);
}

function Query(){
	CleanGridStkCat();
	$('#GridStkCat').datagrid('query', {
		HospId : PHA_COM.Session.HOSPID,
		page   : 1, 
        rows   : 99999
    });
}

function CleanGridStkCat()
{
	$('#GridStkCat').datagrid('clearSelections');   
    $('#GridStkCat').datagrid('clear');
}

function AddScg(){
    $('#GridStkCat').datagrid('addNewRow', {
        editField: 'Code',
    });
}

function SaveScg(){
	$('#GridStkCat').datagrid('endEditing');
    var gridChanges = $('#GridStkCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkCat.Save',  
            MethodName: 'Save',
            HospId    : PHA_COM.Session.HOSPID,
            DetailData: JSON.stringify(gridChanges),
        },
        function (retData) {
            if(retData.code >= 0){
	            PHA.Msg('success' ,"保存成功！");
	            Query();
            }
            else{
	            PHA.Msg('alert' ,"保存失败！" + retData.msg );
	            return;
            }
        }
    );
}

function DeleteScg(){
	var gridSelect = $('#GridStkCat').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var StkCat = gridSelect.StkCat || '';
    if (StkCat == '') {
        var rowIndex = $('#GridStkCat').datagrid('getRowIndex', gridSelect);
        $('#GridStkCat').datagrid('deleteRow', rowIndex);
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        $.cm(
		    {
		        ClassName : 'PHA.IN.StkCat.Save',  
		        MethodName: 'Delete',
		        StkCat    : StkCat,
		        HospId    : PHA_COM.Session.HOSPID
		    },
		    function (retData) {
		        if(retData.code >= 0){
		            PHA.Msg('success' ,"删除成功！");
		            Query();
		        }
		        else{
		            PHA.Msg('alert' ,retData.msg );
		            return;
		        }
		    }
		);
    });
}


