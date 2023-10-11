/**
 * 模块:     业务单据类型维护
 * 编写日期: 2022-06-23
 * 编写人:   yangsj
 */
 
var hospWidth = 360;
var TABLENAME = 'DHC_OperateType';

var GRIDID = 'gridIOpType';
var GRIDBARID = '#gridIOpTypeBar';
var APINAME = 'PHA.IN.Businotype.Api';
 
$(function () {
	InitHosp();
    InitDict();
    InitGrid();
    DefaQuery();
});

function InitHosp(){
	var hospComp = GenHospComp(TABLENAME);
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
            tableName : TABLENAME,
            HospID    : PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL    = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){}

function InitGrid(){
	InitGridOpType();
}

function InitGridOpType(){
	var columns = [
        [
            // OpertId, Code, Desc, IOType, IODesc, DefaultFlag
            { field: 'iptId', 		title: 'opertId', 		hidden: true },
            { field: 'iptCode', 			title: '代码',  		width: 120,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'iptDesc', 			title: '名称', 			width: 200,
            	editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                    }
                }
            },
            { field: 'busiNoTypeCode', 		title: '业务类型',  	width: 140,		align: 'left',				descField: 'busiNoTypeDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					url: PHA_IN_STORE.BusiForNoType().url
				}),
                formatter: function (value, row, index) {
                    return row.busiNoTypeDesc;
                }
            }, 
            { field: 'busiNoTypeDesc', 		title: '业务类型描述',  hidden: true },
            { field: 'defaultFlag', 		title: '默认', 			width: 80 ,	align:"center", formatter: PHA_GridEditor.CheckBoxFormatter,
            	editor: PHA_GridEditor.CheckBox({})	
            },
            { field: 'null', 		title: '', 		width: 700 },
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'Query',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave: false,
        pagination: false,
        fitColumns: false,
        columns: columns,
        toolbar: GRIDBARID,
        exportXls: false,
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

function DefaQuery(){
	setTimeout(function(){Query();}, 500)
}

function Query(){
	Clear();
	$('#' + GRIDID).datagrid('query', {
		pJson : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
    });
}

function Clear()
{
	$('#' + GRIDID).datagrid('loadData', []);
}

function Add(){
    PHA_GridEditor.Add({
		gridID: GRIDID,
		field: 'iptCode',
	}, 1);
}

function Save(){
	PHA_GridEditor.GridFinalDone('#' + GRIDID, ['iptId', 'iptCode', 'iptDesc']);
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = PHA_GridEditor.GetChangedRows('#' + GRIDID); 
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
            pMethodName: 'Save',
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
            var iptId = gridSelect.iptId || '';
            if (iptId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            iptId  : iptId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'Delete',
			            pJson      : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							Query();
						}
			        }
			    )
            }
        }
    });}


