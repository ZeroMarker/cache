/**
 * ģ��		: �����̵���
 * ��д����	: 2022-05-30
 * ��д��	: yangsj
 */
 
var hospWidth = 225;
var TABLENAME = 'CT_Loc';  //'DHC_LocManGrp'; �����ڿ����½������ԣ����Կ��ұ���Ϊ��ȨҽԺȡֵ�Ĳο���

var GRIDID = 'gridStktkGrp';
var GRIDBARID = '#gridStktkGrpBar';
var APINAME = 'PHA.IN.Stktkgrp.Api';

$(function () {
	InitHosp();		// ��ʼ��ҽԺ
    InitDict();    	// ��ʼ���ֵ�
    InitGrid();    	// ��ʼ�����
    setTimeout("QueryLoc()", 500);
});

function InitHosp(){
    var hospComp = GenHospComp(TABLENAME, '', { width: hospWidth });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        QueryLoc();
        
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
}

function InitDict(){}

function InitGrid(){
	InitGridLoc();
	InitGridStktkWin();
}

function InitGridLoc(){
	Loc_Com.Init('gridLoc', 'gridLocBar', QueryStktkWin)
}

function InitGridStktkWin(){
	var columns = [
        [
            { field: 'lmgId', 		title: 'lmgId', 		hidden: true },
            { field: 'lmgCode', 	title: '����',  		align: 'left',		width: 300,		editor: {type: 'validatebox',options: {required: true}}},  
            { field: 'lmgDesc', 	title: '����',  		align: 'left',		width: 450,		editor: {type: 'validatebox',options: {required: true}}},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryStktkGrp',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'lmgId',
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

function QueryLoc(){
	var locJsonStr = PHA.DomData('#gridLocBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = locJsonStr[0];
	pJson["hospId"] = PHA_COM.Session.HOSPID;
	pJson["groupId"] = session['LOGON.GROUPID'];
	
	$('#gridLoc').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

function QueryStktkWin(){
	var locId = GetLocId();
	if(!locId) return;
	$('#' + GRIDID).datagrid('query', {
        pJson : JSON.stringify({locId:locId}),
    });
}
function Clear(){
	PHA.DomData('#gridLocBar', {
    	doType: 'clear',
	});
	$('#gridLoc').datagrid('loadData', []);
	$('#' + GRIDID).datagrid('loadData', []);
}

function Add(){
	var locId = GetLocId();
	if(!locId){
		PHA.Msg('alert', '��ѡ��һ�����ң�');
	    return;
	}
	
	PHA_GridEditor.Add({
		gridID   : GRIDID,
		field    : 'lmgCode',
		checkRow : true,
		rowData  : {}
	});
}

function GetLocId(){
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.locId;
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
    var locId = GetLocId();
	if(!locId){
		PHA.Msg('alert', '��ѡ��һ�����ң�');
	    return;
	}
    
    var pJson = {
	    locId : locId,
	    rows  : gridChanges
    }
    
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveStktkGrp',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryStktkWin();
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
            var lmgId = gridSelect.lmgId || '';
            if (lmgId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            lmgId  : lmgId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteStktkGrp',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryStktkWin();
						}
			        }
			    )
            }
        }
    });
}