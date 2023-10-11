/**
 * ģ��:     ���������ά��
 * ��д����: 2021-10-27
 * ��д��:   yangsj
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
                Description: $g('����'),
            },
            {
                RowId: 'I',
                Description: $g('���'),
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
            { field: 'Code', 			title: '����',  		width: 100,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'Desc', 			title: '����', 			width: 200,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'IOType', 			title: '��/���', 		width: 120 ,	descField: 'IODesc', 	editor: GridCmbIOData,
            	formatter: function (value, row, index) {
                    return row.IODesc;
                }
            },
            { field: 'IODesc', 			title: '��������', 		width: 60,	hidden: true },
            { field: 'DefaultFlag', 	title: 'Ĭ��', 			width: 60 ,	align:"center", formatter: PHA_GridEditor.CheckBoxFormatter,
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
		                PHA.Msg("alert",'�� ' + nextRow + " �б�����δ����Ȳ�������");
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
	    PHA.Msg('alert' ,"û����Ҫ��������ݣ�");
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
	            PHA.Msg('success' ,"����ɹ���");
	            Query();
            }
            else{
	            PHA.Msg('alert' ,"����ʧ�ܣ�" + retData.msg );
	            return;
            }
        }
    );
}

function DeleteOpType(){
	var gridSelect = $('#GridOpType').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"��ѡ����Ҫɾ���ļ�¼��");
        return;
    }
    var opertId = gridSelect.OpertId || '';
    if (opertId == '') {
        var rowIndex = $('#GridOpType').datagrid('getRowIndex', gridSelect);
        $('#GridOpType').datagrid('deleteRow', rowIndex);
        return;
    }
    PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
        $.cm(
		    {
		        ClassName : 'PHA.IN.OpType.Save',  
		        MethodName: 'Delete',
		        OpertId   : opertId,
		        HospId    : PHA_COM.Session.HOSPID
		    },
		    function (retData) {
		        if(retData.code >= 0){
		            PHA.Msg('success' ,"ɾ���ɹ���");
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


