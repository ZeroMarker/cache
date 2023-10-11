/**
 * ģ��		: �б�����ά��
 * ��д����	: 2022-05-25
 * ��д��	: yangsj
 */
 
var hospWidth = 360;
var TABLENAME = 'DHC_PublicBiddingList'

var GRIDID = 'gridPublicBidding';
var GRIDBARID = '#gridPublicBiddingBar';
var APINAME = 'PHA.IN.Pbname.Api';

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
            { field: 'pblId', 			title: 'pblId', 		hidden: true },
            { field: 'pblCode', 		title: '�б����',  	align: 'left',		width: 100,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'pblDesc', 		title: '�б�����',  	align: 'left',		width: 120,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'tenderee', 		title: '�����������',  align: 'left',		width: 120,		editor: {type: 'validatebox',options: {}}},  
            { field: 'pblDate', 		title: '�б�����',  	align: 'left',		width: 120,		editor: PHA_GridEditor.DateBox({})},  
            { field: 'startDate', 		title: '��ʼ����',  	align: 'left',		width: 120,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'endDate', 		title: '��ֹ����',  	align: 'left',		width: 120,		editor: PHA_GridEditor.DateBox({})}, 
            { field: 'activeFlag', 		title: '����',  		align: 'center',	width: 80,		editor: PHA_GridEditor.CheckBox({}),	 formatter: PHA_GridEditor.CheckBoxFormatter} , 
        	{ field: 'remark', 			title: '��ע',  		align: 'left',		width: 420,		editor: {type: 'validatebox',options: {}}},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryPbname',
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
		gridID: GRIDID,
		field: 'pblCode',
		checkRow: true,
		rowData:{
			activeFlag:"Y"
		}
	});
}

function Save(){
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = $('#' + GRIDID).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"û����Ҫ��������ݣ�");
	    return;
    }
    var pJson = {
	    hospId : PHA_COM.Session.HOSPID,
	    rows   : gridChanges
    } 
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SavePbname',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
}

function GetPblId(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.pbl;
    return "";
}

function Delete(){
	var gridSelect = $('#' + GRIDID).datagrid('getSelected');
    if (!gridSelect) {
	    PHA.Msg('alert' ,'��ѡ����Ҫɾ���ļ�¼��');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var pblId = gridSelect.pblId || '';
            if (pblId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            pblId  : pblId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeletePbname',
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
