/**
 * ģ��		: ҵ�����ά��
 * ��д����	: 2021-09-4
 * ��д��	: yangsj
 */
$(function () {
	InitHosp();    // ��ʼ��ҽԺ
    InitDict();    // ��ʼ���ֵ�
    InitGrid();    // ��ʼ�����
});

function InitHosp(){
    var hospComp = GenHospComp("DHC_StkAuditLevel",'', { width: 300 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        $("#GridStkAuditLevel").datagrid("getColumnOption", "SSGroupId").editor.options.url = PHA_STORE.SSGroup().url,
        $("#GridStkAuditLevel").datagrid("getColumnOption", "ItmLocId").editor.options.url = PHA_STORE.CTLoc().url,
        Query();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_StkAuditLevel',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
}

function InitDict(){
	GridCmbScgSTALType = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: $URL + '?ResultSetType=Array&' + 'ClassName=PHA.IN.StkAuditLevel.Query&QueryName=GetSTALType',
            defaultFilter:6
        }
    );
    
    GridCmbSSGroup = PHA.EditGrid.ComboBox(
        {
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.SSGroup().url,
            defaultFilter:6
        }
    );
    GridCmbLoc = PHA.EditGrid.ComboBox(  
        {
	        qLen: 0,
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.CTLoc().url,
            defaultFilter:6
        }
    );
    GridCmbUser = PHA.EditGrid.ComboBox(
        {
	        qLen: 0,
            required: true,
            tipPosition: 'top',
            url: PHA_STORE.LocUser(PHA_COM.Session.CTLOCID).url,
           	defaultFilter:6
        },
        { lnkField: 'ItmLocId', lnkGrid: 'GridStkAuditLevel', lnkQName: 'Loc' }
    );
    
}

function InitGrid(){
	var columns = [
        [
            // STALRowId, Activeflag, activeflagdesc, TypeId, TypeDesc, STALItmDesc, ItmLevel, SSGroupId, SSGroupDesc, StkGrp, ItmLocId, ItmLocDesc, SSUserId, SSUserDesc
            { field: 'STALRowId', 		title: 'STALRowId', 	hidden: true 		},
            { field: 'Activeflag', 		title: '���ñ�־',  	align: 'center',	width: 100,					formatter: PHA_GridEditor.CheckBoxFormatter,
            	editor: PHA_GridEditor.CheckBox({})	
            },  
            { field: 'TypeId', 			title: '��Ŀ����', 		width: 150, 		descField: 'TypeDesc',		editor: GridCmbScgSTALType,
            	formatter: function (value, row, index) {
                    return row.TypeDesc;
                }
            },
            { field: 'TypeDesc', 		title: 'TypeDesc', 		hidden: true 		},
            { field: 'ItmLevel', 		title: '��Ŀ�ȼ�����', 	width: 150,  		
            	editor: {
                    type: 'numberbox',
                    options: {
	                    onEnter: function() {
		        			PHA_GridEditor.Next();
	                    },
                        required: true,
                    }
                }
            },
            { field: 'SSGroupId', 		title: '��ȫ��', 		width: 150,  		descField: 'SSGroupDesc',		
            	editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.SSGroup().url,
					defaultFilter:6,
					onBeforeLoad: function (param) {
						var curRowData = PHA_GridEditor.CurRowData('GridStkAuditLevel' );
						param.UsedId = curRowData.SSGroupId || "" ;
                        param.QText = param.q;
					}
				}),
            	formatter: function (value, row, index) {
                    return row.SSGroupDesc;
                }
            }, 
            { field: 'SSGroupDesc', 	title: 'SSGroupDesc', 	hidden: true 		},
            { field: 'ItmLocId', 		title: '����', 			width: 150,  		descField: 'ItmLocDesc',		
            	editor: PHA_GridEditor.ComboBox({
	            	qLen: 0,
		            required: true,
		            tipPosition: 'top',
		            url: PHA_STORE.CTLoc().url,
		            defaultFilter:6
            	}),
            	formatter: function (value, row, index) {
                    return row.ItmLocDesc;
                }  		
            }, 
            { field: 'ItmLocDesc', 		title: 'ItmLocDesc', 	hidden: true 		},
            { field: 'SSUserId', 		title: '�����', 		width: 225,  		descField: 'SSUserDesc',
                editor: PHA_GridEditor.ComboBox({
	                qLen: 0,
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					url: PHA_STORE.LocUser().url,
					onBeforeLoad: function (param) {
						var curRowData = PHA_GridEditor.CurRowData('GridStkAuditLevel' );
						param.Loc = curRowData.ItmLocId || "" ;
					}					
				}),
                
            	
            	formatter: function (value, row, index) {
                    return row.SSUserDesc;
                } 			
            },
            { field: 'SSUserDesc', 		title: 'SSUserDesc', 	hidden: true 		},
        ]
    ];
    var dataGridOption = {
        url: $URL,
        gridSave: false,
        queryParams: {
            ClassName: 'PHA.IN.StkAuditLevel.Query',
            QueryName: 'QueryAuditLevel',
            HospId   : PHA_COM.Session.HOSPID,
            page	: 1, 
        	rows	: 99999
        },
        pagination: false,
        //fitColumns: true,
        fit: true,
        idField: 'STALRowId',
        columns: columns,
        toolbar: '#GridStkAuditLevelBar',  
        exportXls: false,
        isAutoShowPanel: true,
        editFieldSort: ['Activeflag', 'TypeId', 'ItmLevel', 'SSGroupId', 'ItmLocId', 'SSUserId'],
	    onLoadSuccess: function (data) {
            $('.hisui-switchboxlocscg').switchbox();
        },
        onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "GridStkAuditLevel",
				index: index,
				field: field
			});
		},
		onLoadSuccess: function (data) {
            $('.hisui-switchboxActive').switchbox();
        }
    };
    PHA.Grid('GridStkAuditLevel', dataGridOption);
}

function  Query(){
	$('#GridStkAuditLevel').datagrid('clear');
    $('#GridStkAuditLevel').datagrid('clearSelections');
	$('#GridStkAuditLevel').datagrid('query', {
        HospId : PHA_COM.Session.HOSPID,
        page	: 1, 
        rows	: 99999
    });
}

function AddSAL(){
	PHA_GridEditor.Add({
		gridID: 'GridStkAuditLevel',
		field: 'TypeId'
	});
}

function SaveSAL(){
	$('#GridStkAuditLevel').datagrid('endEditing');
	if($("#GridStkAuditLevel").datagrid('options').editIndex != undefined) 
    {
        PHA.Msg('alert','����༭���Ƿ��б�����δ��д!');
        return;
    }
    var gridChanges = $('#GridStkAuditLevel').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (!gridChangeLen){
	    PHA.Msg('alert' ,"û����Ҫ��������ݣ�");
	    return
    }
    $.cm(
        {
            ClassName : 'PHA.IN.StkAuditLevel.Save',  
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
}

function DeleteSAL(){
	var gridSelect = $('#GridStkAuditLevel').datagrid('getSelected');
    if (gridSelect == null) {
	    PHA.Msg('alert' ,"��ѡ����Ҫɾ���ļ�¼��");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
        if (r) {
            var STALRowId = gridSelect.STALRowId || '';
            if (STALRowId == '') {
                var rowIndex = $('#GridStkAuditLevel').datagrid('getRowIndex', gridSelect);
                $('#GridStkAuditLevel').datagrid('deleteRow', rowIndex);
            } else {
                    $.cm(
					    {
					        ClassName : 'PHA.IN.StkAuditLevel.Save',  
					        MethodName: 'Delete',
					        STALRowId : STALRowId,
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
        }
    });
}
