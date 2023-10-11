/**
 * ģ��		: С������ά��
 * ��д����	: 2022-05-31
 * ��д��	: yangsj
 */
 
var hospWidth = 330;
var TABLENAME = 'DHC_StkDecimal';  // �ӱ� DHC_StkDecimalItm

var GRIDID_M = 'gridDecimal';
var GRIDID_D = 'gridItm';
var GRIDBARID_M = '#gridDecimalBar';
var GRIDBARID_D = '#gridItmBar';
var APINAME = 'PHA.IN.MarkInfo.Api';

$(function () {
	InitHosp();		// ��ʼ��ҽԺ
    InitDict();    	// ��ʼ���ֵ�
    InitGrid();    	// ��ʼ�����
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
	InitGridDecimal();
	InitGridItm();
}

function InitGridDecimal(){
	var columns = [
        [
            { field: 'sdId', 	title: 'sdId', 		hidden: true },
            { field: 'sdCode', 	title: '����',  	align: 'left',		width: 80,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'sdDesc', 	title: '����',  	align: 'left',		width: 100,		editor: {type: 'validatebox',options: {required: true}}},  
        	{ field: 'useFlag', title: 'ʹ��',  	align: 'left',		width: 60,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryDecimal',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        //idField: 'sdId',
        columns: columns,
        toolbar: GRIDBARID_M,  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;
	        QueryItm();
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;
			PHA_GridEditor.Edit({
				gridID : GRIDID_M,
				index  : index,
				field  : field,
				forceEnd : true
			});
		}
    };
    PHA.Grid(GRIDID_M, dataGridOption);
}

function InitGridItm(){
	var columns = [
        [
            { field: 'sdiId', 	title: 'sdiId', 		hidden: true },
            { field: 'min', 	title: '����',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4,required: true})},  
            { field: 'max', 	title: '����',  		align: 'right',		width: 100,		editor: PHA_GridEditor.NumberBox({precision: 4,required: true})},  
        	{ field: 'len', 	title: 'С��λ��',  	align: 'left',		width: 500,		
        		editor: PHA_GridEditor.NumberBox(
        			{
	        			precision: 0,
	        			required: true,
	        			checkValue: function (val, checkRet) {
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "���������֣�";
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = "���������0�����֣�";
							return false;
						}
						return true;
					},
	        		}
	        	)
	        }
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryDecimalItm',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        columns: columns,
        toolbar: GRIDBARID_D,  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
			PHA_GridEditor.Edit({
				gridID : GRIDID_D,
				index  : index,
				field  : field,
				forceEnd : true
			});
		}
    };
    PHA.Grid(GRIDID_D, dataGridOption);
}

function Query(){
	$('#' + GRIDID_D).datagrid('loadData', []);
	$('#' + GRIDID_M).datagrid('query', {
        pJson : JSON.stringify({hospId:PHA_COM.Session.HOSPID}),
    });
}

function QueryItm(){
	$('#' + GRIDID_D).datagrid('loadData', []);
	var sdId = GetSdId();
	if(!sdId){
		PHA.Msg('alert', '��ѡ��һ�������¼��');
	    return;
	}
	$('#' + GRIDID_D).datagrid('query', {
        pJson : JSON.stringify({sdId:sdId}),
    });
}

function Clear(){
	$('#' + GRIDID_M).datagrid('loadData', []);
}

function Add(){
	PHA_GridEditor.Add({
		gridID   : GRIDID_M,
		field    : 'sdCode',
		checkRow : true,
		rowData  : {
			useFlag : 'Y'
		}
	});
}
function Addi(){
	var sdId = GetSdId();
	if(!sdId){
		PHA.Msg('alert', '��ѡ��һ�������¼��');
	    return;
	}
	PHA_GridEditor.Add({
		gridID   : GRIDID_D,
		field    : 'min',
		checkRow : true,
		rowData  : {
			len : 2
		}
	});
}

function GetSdId(){
	var gridSelect = $('#' + GRIDID_M).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.sdId;
    return '';
}

function Save(){
	if (!PHA_GridEditor.EndCheck(GRIDID_M)) return;	
    var gridChanges = $('#' + GRIDID_M).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', 'û����Ҫ��������ݣ�');
	    return;
    }
    var pJson = {
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveDecimal',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
}

function Savei(){
	if (!PHA_GridEditor.EndCheck(GRIDID_D)) return;
	
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues(GRIDID_D);
	if (chkRetStr != "") {
		PHA.Msg('alert', chkRetStr);
		return;
	}
	
    var gridChanges = $('#' + GRIDID_D).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert', 'û����Ҫ��������ݣ�');
	    return;
    }
    var sdId = GetSdId();
	if(!sdId){
		PHA.Msg('alert', '��ѡ��һ�������¼��');
	    return;
	}
    var pJson = {
	    sdId   : sdId,
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveDecimalItm',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryItm();
			}
        }
    )
}

function Delete(){
	var gridSelect = $('#' + GRIDID_M).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'��ѡ����Ҫɾ���ļ�¼��');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var sdId = gridSelect.sdId || '';
            if (sdId == '') {
                var rowIndex = $('#' + GRIDID_M).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID_M).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            sdId  : sdId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteDecimal',
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

function Deletei(){
	var gridSelect = $('#' + GRIDID_D).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'��ѡ����Ҫɾ���ļ�¼��');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var sdiId = gridSelect.sdiId || '';
            if (sdiId == '') {
                var rowIndex = $('#' + GRIDID_D).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID_D).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            sdiId  : sdiId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteDecimalItm',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryItm();
						}
			        }
			    )
            }
        }
    });
}