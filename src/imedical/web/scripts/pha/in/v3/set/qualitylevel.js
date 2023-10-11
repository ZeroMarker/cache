/**
 * 模块		: 质量层次维护
 * 编写日期	: 2022-05-25
 * 编写人	: yangsj
 */
 
var hospWidth = 360;
var TABLENAME = 'DHC_ItmQualityLevel';

var GRIDID = 'gridQualitylevel';
var GRIDBARID = '#gridQualitylevelBar';
var APINAME = 'PHA.IN.Iqlevel.Api';

$(function () {
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
    setTimeout("Query()", 500);
});
function InitDict(){}

function InitGrid(){
	var columns = [
        [
            { field: 'qlId', 		title: 'qlId', 			hidden: true },
            { field: 'qlCode', 		title: '代码',  		align: 'left',		width: 120,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'qlDesc', 		title: '名称',  		align: 'left',		width: 120,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'startDate', 	title: '开始日期',  	align: 'left',		width: 160,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'endDate', 	title: '截止日期',  	align: 'left',		width: 160,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'null', 	    title: '',  	       align: 'left',	   width: 680},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryIqlevel',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        columns: columns,
        toolbar: GRIDBARID,  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID)) return;
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
			PHA_GridEditor.Edit({
				gridID : GRIDID,
				index  : index,
				field  : field,
				forceEnd : true
			});
		}
    };
    PHA.Grid(GRIDID, dataGridOption);
}

function Query(){
	 $('#' + GRIDID).datagrid('query', {
        pJson : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
    });
}
function Clear(){
	$('#' + GRIDID).datagrid('loadData', []);
}

function Add(){
	PHA_GridEditor.Add({
		gridID   : GRIDID,
		field    : 'qlCode',
		checkRow : true,
		rowData  : {}
	});
}

function GetIpblId(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.qlId;
    return '';
}

function Save(){
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = $('#' + GRIDID).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    var pJson = {
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveIqlevel',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
}

function Delete(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'请选择需要删除的记录！');
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var qlId = gridSelect.qlId || '';
            if (qlId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            qlId  : qlId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteIqlevel',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							Query();
						}
			        }
			    )
            }
        }
    });
}
