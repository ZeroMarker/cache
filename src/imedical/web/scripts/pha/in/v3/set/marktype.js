/**
 * 模块		: 定价类型维护
 * 编写日期	: 2022-05-30
 * 编写人	: yangsj
 */
 
var hospWidth = 360;
var TABLENAME = 'DHC_MarkType';

var GRIDID = 'gridMarkType';
var GRIDBARID = '#gridMarkTypeBar';
var APINAME = 'PHA.IN.MarkInfo.Api';

$(function () {
	InitHosp();		// 初始化医院
    InitDict();    	// 初始化字典
    InitGrid();    	// 初始化表格
    setTimeout("Query()", 500);
});

function InitHosp(){
    var hospComp = GenHospComp(TABLENAME, '', { width: hospWidth });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        Query();
        
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: TABLENAME,
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){}

function InitGrid(){
	var columns = [
        [
            { field: 'mtId', 		title: 'mtId', 			hidden: true },
            { field: 'mtCode', 		title: '代码',  		align: 'left',		width: 150,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'mtDesc', 		title: '名称',  		align: 'left',		width: 300,		editor: {type: 'validatebox',options: {required: true}}},  
       		{ field: 'zbFlag', 		title: '中标',  		align: 'left',		width: 150,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
        	{ field: 'useFlag', 	title: '使用',  		align: 'left',		width: 500,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryMarkType',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'mtId',
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
		field    : 'mtCode',
		checkRow : true,
		rowData  : {
			zbFlag  : 'Y',
			useFlag : 'Y'	
		}
	});
}

function GetIpblId(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.mtId;
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
            pClassName  : APINAME,  
            pMethodName : 'SaveMarkType',
            pJson   	: JSON.stringify(pJson),
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
            var mtId = gridSelect.mtId || '';
            if (mtId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            mtId  : mtId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteMarkType',
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