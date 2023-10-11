/**
 * ģ��		: �½�����
 * ��д����	: 2021-11-15
 * ��д��	: yangsj
 */

var APINAME = 'PHA.IN.MonSettle.Api';


$(function () {
	InitHosp();    // ��ʼ��ҽԺ
    InitDict();    // ��ʼ���ֵ�
    InitGrid();    // ��ʼ�����
    DefaQuery();    
});

function InitHosp(){
    var hospComp = GenHospComp("CF_PHA_IN.MonSettle",'', { width: 300 }); //CF_PHA_IN.MonSettle
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        //$("#GridMonSettle").datagrid("getColumnOption", "SSGroupId").editor.options.url = PHA_STORE.SSGroup().url,
        Query();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'CF_PHA_IN.MonSettle',
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
            // MonSId, HospId, Loc, LocDesc, GroupType, Day, ActiveFlag, UserId, UserName, InitAutoAcc, OverMonBanAcc
            { field: 'msId', 		title: 'msId', 	    hidden: true 		},
            { field: 'hospId', 		title: 'hospId', 	hidden: true 		},
            { field: 'groupType', 	title: '���÷�Χ',  align: 'center',	width: 100,
            	formatter: function (value, row, index) {
                    if (value == 'HOS') {
                        return $g("Ժ��");
                    } else if (value == 'LOC'){
                        return $g("���Ҽ�");
                    }
                },
            },  
            { 
            	field: 'locId',
                title: '����',
                width: 250,
                descField: 'locDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.HospId = PHA_COM.Session.HOSPID;
                        param.QText = param.q;
					}
				}),
                formatter: function (value, row, index) {
                    return row.locDesc;
                }
            },
            /*
            { field: 'ActiveFlag', 	title: '�Զ������±�',      width: 120,     align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'Day',         title: '�½���',            width: 80,      align:"center",	editor: PHA_GridEditor.NumberBox({precision:0,required: true})},
            */
            { field: 'autoDayFlag', title: '�Զ������ձ�',      width: 120,     align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'autoDays', 	title: '�ձ����ڷ�Χ',      width: 100,		align:"right",	editor: PHA_GridEditor.NumberBox({precision:0})},
            { 
            	field: 'userId',
                title: 'Ĭ�ϲ�����',
                width: 120,
                descField: 'userName',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.SSUser().url,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						param.HospId = PHA_COM.Session.HOSPID;
                        param.QText = param.q;
					}
				}),
                formatter: function (value, row, index) {
                    return row.userName;
                }
            }
            /*
            ,
            { field: 'InitAutoAcc', 	title: '�µ��Զ�ת�ƽ���', 		width: 130,  align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({}) }, 
            { field: 'OverMonBanAcc', 	title: '���½�ֹ�ܾ�����', 		width: 130,  align:"center",	formatter: PHA_GridEditor.CheckBoxFormatter,	editor: PHA_GridEditor.CheckBox({})	}
            */
        
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.MonSettle.Api',
            pMethodName: 'QueryMs',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        /*
        queryParams: {
            ClassName: 'PHA.IN.MonSettle.Query',
            QueryName: 'QueryMonS',
            pHospId  : PHA_COM.Session.HOSPID,
            page	: 1, 
        	rows	: 99999
        },*/
        pagination: false,
        //fitColumns: true,
        fit: true,
        idField: 'msId',
        columns: columns,
        toolbar: '#GridMonSettleBar',  
        exportXls: false,
        isCellEdit: false,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		        if (!EncCheck('GridMonSettle')) return;
		    }
        },
	    onDblClickRow: function (rowIndex, rowData) { 
            PHA_GridEditor.Edit({
	            gridID: 'GridMonSettle',
	            index: rowIndex,
	            field: 'locId',
	        });
	    }
    };
    PHA.Grid('GridMonSettle', dataGridOption);
}



function Clean()
{
	$('#GridMonSettle').datagrid('clearSelections');   
    $('#GridMonSettle').datagrid('clear');
}

function  Query(){
	Clean();
    $('#GridMonSettle').datagrid('query', {
        pJson : JSON.stringify({hospId : PHA_COM.Session.HOSPID})
    });
}

function AddSAL(){
    PHA_GridEditor.Add({
		gridID: 'GridMonSettle',
		field: 'locId'
	});
}

function EncCheck(gridID){
	if (!PHA_GridEditor.End(gridID)) {
        var gridOptions = $('#' + gridID).datagrid('options');
        var editIndex = gridOptions.editIndex;
        if (editIndex >= 0) {
            PHA_GridEditor.popoverTips('��' + (editIndex + 1) + '��, �б�����δ��д, ������ɱ༭��');
            return false;
        }
	}
	return true;
}

function SaveSAL(){
	if (!EncCheck('GridMonSettle')) return;
    var gridChanges = $('#GridMonSettle').datagrid('getChanges');
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
            pMethodName: 'Save',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				Query();
			}
        }
    )
    /*
    $.cm(
        {
            ClassName : 'PHA.IN.MonSettle.Save',  
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
	            return
            }
        }
    );
    */
}

function DeleteSAL(){
	var gridSelect = $('#GridMonSettle').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"��ѡ����Ҫɾ���ļ�¼��");
        return;
    }
    var msId = gridSelect.msId || '';
    if (msId == '') {
        var rowIndex = $('#GridMonSettle').datagrid('getRowIndex', gridSelect);
        $('#GridMonSettle').datagrid('deleteRow', rowIndex);
        return;
    } 
    
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            $.cm(
			    {
			        ClassName : 'PHA.IN.MonSettle.Save',  
			        MethodName: 'Delete',
			        HospId    : PHA_COM.Session.HOSPID,
			        MonSId	  : msId,
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
        }
    });
}

function DefaQuery(){
    setTimeout(function () { Query(); }, 500)
}