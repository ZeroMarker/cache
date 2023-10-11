/**
 * 模块:     出入库类型维护
 * 编写日期: 2021-10-27
 * 编写人:   yangsj
 */
$(function () {
	InitHosp();
    InitDict();
    InitGrid();
});

function InitHosp(){
	var hospComp = GenHospComp("DHC_OperateType");
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
            tableName : 'DHC_OperateType',
            HospID    : PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL    = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){
	var IOData=[
            {
                RowId: 'O',
                Description: $g('出库'),
            },
            {
                RowId: 'I',
                Description: $g('入库'),
            }
        ]
	GridCmbIOData = PHA.EditGrid.ComboBox(
        {
            tipPosition: 'top',
            data : IOData, 
            required: true
        }
    );
}

function InitGrid(){
	InitGridOpType();
}

function InitGridOpType(){
	var columns = [
        [
            // OpertId, Code, Desc, IOType, IODesc, DefaultFlag
            { field: 'OpertId', 		title: 'opertId', 		hidden: true },
            { field: 'Code', 			title: '代码',  		width: 100,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'Desc', 			title: '名称', 			width: 200,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'IOType', 			title: '出/入库', 		width: 120 ,	descField: 'IODesc', 	editor: GridCmbIOData,
            	formatter: function (value, row, index) {
                    return row.IODesc;
                }
            },
            { field: 'IODesc', 			title: '类型名称', 		width: 60,	hidden: true },
            { field: 'DefaultFlag', 	title: '默认', 			width: 60 ,	align:"center", formatter: PHA_GridEditor.CheckBoxFormatter,
            	editor: PHA_GridEditor.CheckBox({})	
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.OpType.Query',
            QueryName: 'QueryOpType',
            HospId   : PHA_COM.Session.HOSPID,
            page	: 1, 
        	rows	: 99999
        },
        gridSave: false,
        pagination: false,
        idField: 'OpertId',
        fitColumns: false,
        columns: columns,
        toolbar: '#GridOpTypeBar',
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
		        if (rowData) {
			        $('#GridOpType').datagrid('endEditing');
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
    PHA.Grid('GridOpType', dataGridOption);
}

function Query(){
	CleanGridOpType();
	$('#GridOpType').datagrid('query', {
		HospId : PHA_COM.Session.HOSPID,
		page	: 1, 
        rows	: 99999
    });
}

function CleanGridOpType()
{
	$('#GridOpType').datagrid('clearSelections');   
    $('#GridOpType').datagrid('clear');
}

function AddOpType(){
    $('#GridOpType').datagrid('addNewRow', {
        editField: 'Code',
    });
}

function SaveOpType(){
	$('#GridOpType').datagrid('endEditing');
    var gridChanges = $('#GridOpType').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"没有需要保存的数据！");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.OpType.Save',  
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

function DeleteOpType(){
	var gridSelect = $('#GridOpType').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"请选择需要删除的记录！");
        return;
    }
    var opertId = gridSelect.OpertId || '';
    if (opertId == '') {
        var rowIndex = $('#GridOpType').datagrid('getRowIndex', gridSelect);
        $('#GridOpType').datagrid('deleteRow', rowIndex);
        return;
    }
    PHA.Confirm('提示', '您确认删除吗?', function () {
        $.cm(
		    {
		        ClassName : 'PHA.IN.OpType.Save',  
		        MethodName: 'Delete',
		        OpertId   : opertId,
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


