/**
 * ģ��		: �б꼶��ά��
 * ��д����	: 2022-05-25
 * ��д��	: yangsj
 */
 
var hospWidth = 360;
var TABLENAME = 'DHC_ItmPBLevel';

var GRIDID = 'gridItmPBLevel';
var GRIDBARID = '#gridItmPBLevelBar';
var APINAME = 'PHA.IN.Pblevel.Api';

$(function () {
	InitHosp();		// ��ʼ��ҽԺ
    InitDict();    	// ��ʼ���ֵ�
    InitGrid();    	// ��ʼ�����
    setTimeout("Query()", 500);
});

function InitHosp(){
    var hospComp = GenHospComp(TABLENAME,'', { width: hospWidth });
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
            // Id, pblCode, pblDesc, pblDate, Tenderee, startDate, EfficDateTo, remark, activeFlag
            { field: 'ipblId', 			title: 'ipblId', 		hidden: true },
            { field: 'ipblCode', 		title: '����',  		align: 'left',		width: 100,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'ipblDesc', 		title: '����',  		align: 'left',		width: 200,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'startDate', 		title: '��ʼ����',  	align: 'left',		width: 170,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'endDate', 		title: '��ֹ����',  	align: 'left',		width: 170,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'null', 			title: '', 		       width: 500 },
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryPblevel',
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
		field    : 'ipblCode',
		checkRow : true,
		rowData  : {}
	});
}

function GetIpblId(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.ipblId;
    return '';
}

function Save(){
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = $('#' + GRIDID).datagrid('getChanges');
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
            pMethodName: 'SavePblevel',
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
	    PHA.Msg('alert' ,'��ѡ����Ҫɾ���ļ�¼��');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var ipblId = gridSelect.ipblId || '';
            if (ipblId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            ipblId  : ipblId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeletePblevel',
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