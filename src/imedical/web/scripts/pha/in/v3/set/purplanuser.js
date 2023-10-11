/**
 * ģ��		: �ɹ�Աά��
 * ��д����	: 2022-05-27
 * ��д��	: yangsj
 */
 
var hospWidth = 225;
var TABLENAME = 'CT_Loc';  //'DHC_InStkTkWindow'; �����ڿ����½������ԣ����Կ��ұ���Ϊ��ȨҽԺȡֵ�Ĳο���

var GRIDID = 'gridPlanUser';
var GRIDBARID = '#gridPlanUserBar';
var APINAME = 'PHA.IN.Planuser.Api';

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

function InitDict(){
	GridCmbUser = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.LocUser(PHA_COM.Session.CTLOCID).url,
        },
        { lnkField: 'Loc', lnkGrid: 'gridLoc', lnkQName: 'locId' }
    );
}

function InitGrid(){
	InitGridLoc();
	InitGridStktkWin();
}

function InitGridLoc(){
	Loc_Com.Init('gridLoc', 'gridLocBar', QueryUser)
}

function InitGridStktkWin(){
	var columns = [
        [
            { field: 'lppId', 			title: 'lppId', 		hidden: true },
            
            { field: 'userInitials', 	title: '����',  		align: 'left',		width: 200	},  
            {
                field: 'userId',
                title: '����',
                width: 300,
                descField: 'userName',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.LocUser().url,
					onBeforeLoad: function (param) {
						param.Loc = GetLocId();
					}
				}),
				formatter: function (value, row, index) {
                    return row.userName;
                },
            },
            
            
        	{ field: 'activeFlag', 		title: '����',  		align: 'center',	width: 120,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter},
        	{ field: 'defaultFlag', 	title: 'Ĭ��',  		align: 'center',	width: 120,		editor: PHA_GridEditor.CheckBox({})	, formatter: PHA_GridEditor.CheckBoxFormatter}
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryPlanUser',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        //idField: 'lppId',
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

function QueryUser(){
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
		field    : 'userId',
		checkRow : true,
		rowData  : {
			activeFlag : 'Y',
			defaultFlag : 'N'
		}
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
            pMethodName: 'SavePlanUser',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryUser();
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
            var lppId = gridSelect.lppId || '';
            if (lppId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            lppId  : lppId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeletePlanUser',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryUser();
						}
			        }
			    )
            }
        }
    });
}