/**
 * ģ��		: ���������ϵ
 * ��д����	: 2022-05-30
 * ��д��	: yangsj
 */
 
var hospWidth = 225;
var searchboxWidth = 300;
var TABLENAME = 'CT_Loc';  //'DHCST_LocRelation'; �����ڿ����½������ԣ����Կ��ұ���Ϊ��ȨҽԺȡֵ�Ĳο���

var GRIDID = 'gridReqLoc';
var GRIDBARID = '#gridReqLocBar';
var APINAME = 'PHA.IN.Locreqrela.Api';

$(function () {
	InitHosp();		// ��ʼ��ҽԺ
    InitDict();    	// ��ʼ���ֵ�
    InitGrid();    	// ��ʼ�����
    setTimeout('QueryLoc()', 500);
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
		$('.icon-help').popover({
			title:'��ʾ',
			width:'400',
			content:$g('<b>������ϵ</b>��ѡ��\'��������\'��ϵͳ���Զ��������������ϵ�������Ҫ��\'��������\'��Ϊ\'��������\'���ֶ�ɾ��������ҵ������ϵ��')
			
		});

	
	GridCmbEachRela = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        data : [
        	{
	        	RowId:'Each',
	        	Description : $g('��������')
	        },
	        {
	        	RowId:'Single',
	        	Description : $g('��������')
	        }
        ]
    });
    
    /// ��ά��ҩƷ����
    $('#txtAliasIn').searchbox({
	    searcher:function(value,name){
	    QueryInciIn();
	    },
	    width:searchboxWidth,
	    prompt:$g('����ģ����ѯ...')
	});
    
    /// δά��ҩƷ����
    $('#txtAliasOut').searchbox({
	    searcher:function(value,name){
	    QueryInciOut();
	    },
	    width:searchboxWidth,
	    prompt:$g('����ģ����ѯ...')
	});
}

function InitGrid(){
	InitGridLoc();
	InitGridStktkWin();
	InitGridInciIn();
	InitGridInciOut();
}

function InitGridLoc(){
	Loc_Com.Init('gridLoc', 'gridLocBar', QueryReqLoc)
}

function InitGridStktkWin(){
	var columns = [
        [
            { field: 'lrrId', 		title: 'lrrId', 			hidden: true },
            { field: 'recLocCode', 	title: '���Ҵ���',  		width: 80,		align: 'left'	},  
            { field: 'recLocId',	title: '��������',			width: 120,	  	descField: 'recLocDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					url: PHA_STORE.CTLoc().url
				}),
                formatter: function (value, row, index) {
                    return row.recLocDesc;
                }
            },
            { field: 'eachRela', 	title: '������ϵ', 		width: 80,		descField: 'eachRelaDesc', editor: GridCmbEachRela,
            	formatter: function (value, row, index) {
                    return row.eachRelaDesc;
                }
            },
            { field: 'eachRelaDesc', 	title: 'eachRelaDesc', 			hidden: true },
            { field: 'opertId', 		title: 'ת�Ƴ�������',  	width: 100,		align: 'left',				descField: 'opertDesc',
                editor: PHA_GridEditor.ComboBox({
					tipPosition: 'top',
					url: PHA_IN_STORE.OperateType('O').url
				}),
                formatter: function (value, row, index) {
                    return row.opertDesc;
                }
            }, 
            { field: 'opertDesc', 		title: 'ת�Ƴ�����������',  hidden: true },
            
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryLocReqRela',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        //idField: 'lrrId',
        columns: columns,
        toolbar: GRIDBARID,  
        exportXls: false,
        isAutoShowPanel: true,
        isCellEdit: false,
        onClickRow: function (rowIndex, rowData){
	        if (!PHA_GridEditor.EndCheck(GRIDID)) return;
	        QueryInci();
        },
	    onDblClickCell: function (index, field, value) {
		    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
		    
		    var gridSelect = $('#' + GRIDID).datagrid('getSelected') || '';
			var tt = $('#' + GRIDID).datagrid('getColumnOption', 'eachRela');
    		if (gridSelect.lrrId != '' && gridSelect.lrrId != undefined){
	    		tt.editor = {};
    		}
    		else {
	    		tt.editor = GridCmbEachRela;
    		}
    		
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

//��ʼ���ѷ���ҩƷ�б�
function InitGridInciIn() {
    //����columns
    var columns = [
        [
            // LCGII,InciCode,InciDesc
            { field: 'lrriId', title: 'lrriId', width: 100, hidden: true },
            {
                field: 'operate',
                title: '����',
                width: 60,
                halign: 'center',
                align: 'center',
                formatter: statusFormatterDel,
            },
            { field: 'inciCode', title: 'ҩƷ����', width: 120, halign: 'center', align: 'left' },
            { field: 'inciDesc', title: 'ҩƷ����', width: 240, halign: 'center', align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryInciIn',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        pagination: true,
        //fitColumns: true,
        fit: true,
        //idField: 'LCGII',
        rownumbers: true,
        columns: columns,
        nowrap: false,
        toolbar: '#InciInBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciIn', dataGridOption);
}
//��ʼ��δ����ҩƷ�б�
function InitGridInciOut() {
    //����columns
    var columns = [
        [
            // inci,incicode,incidesc
            { field: 'inci', title: 'inci', width: 100, hidden: true },
            {
                field: 'operate',
                title: '����',
                width: 60,
                halign: 'center',
                align: 'center',
                formatter: statusFormatterAdd,
            },
            { field: 'inciCode', title: 'ҩƷ����', width: 120, halign: 'center', align: 'left' },
            { field: 'inciDesc', title: 'ҩƷ����', width: 240, halign: 'center', align: 'left' },
            
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        queryParams: {
            pClassName : APINAME,
            pMethodName: 'QueryInciOut',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        toolbar: '#toolbar', //���ֲ��ı�߶�
        pagination: true,
        fit: true,
        //idField: 'inci',
        rownumbers: true,
        columns: columns,
        toolbar: '#InciOutBar',
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {},
    };
    PHA.Grid('gridInciOut', dataGridOption);
}

function QueryLoc(){
	ClearGridArr(['gridReqLoc', 'gridInciIn', 'gridInciOut'])
	
	var locJsonStr = PHA.DomData('#gridLocBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = locJsonStr[0];
	pJson['hospId'] = PHA_COM.Session.HOSPID;
	pJson['groupId'] = session['LOGON.GROUPID'];
	
	$('#gridLoc').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

function QueryReqLoc(){
	var locId = GetLocId();
	if(!locId) return;
	
	ClearGridArr(['gridInciIn','gridInciOut'])
	$('#' + GRIDID).datagrid('query', {
        pJson : JSON.stringify({proLocId:locId}),
    });
}

function QueryInci(){
	QueryInciIn();
	QueryInciOut();
}

///��ѯ��ά��ҩƷ
function QueryInciIn() {
	var lrrId = GetLrrId();
	if(!lrrId) return;
	var alias = $('#txtAliasIn').searchbox('getValue')
	var pJson = {
		lrrId : lrrId,
		alias : alias
	}
    $('#gridInciIn').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

///��ѯδά��ҩƷ
function QueryInciOut() {
    var lrrId = GetLrrId();
	if(!lrrId) return;
	var alias = $('#txtAliasOut').searchbox('getValue')
	var pJson = {
		lrrId : lrrId,
        alias: alias,
        hospId : PHA_COM.Session.HOSPID
	}
    $('#gridInciOut').datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}


function Clear(){
	PHA.DomData('#gridLocBar', {
    	doType: 'clear',
	});
	$('#txtAliasIn').searchbox('clear');
	$('#txtAliasOut').searchbox('clear');
	ClearGridArr(['gridLoc', GRIDID, 'gridInciIn', 'gridInciOut'])
}

function Add(){
	var locId = GetLocId();
	if(!locId){
		PHA.Msg('alert', '��ѡ��һ�����ң�');
	    return;
	}
	var tt = $('#' + GRIDID).datagrid('getColumnOption', 'eachRela');
	tt.editor = GridCmbEachRela;

	
	
	PHA_GridEditor.Add({
		gridID   : GRIDID,
		field    : 'recLocId',
		checkRow : true,
		rowData  : {
				eachRela : 'Each'
			}
	});
	
	
}

function GetLocId(){
	var gridSelect = $('#gridLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.locId;
    return '';
}


function GetLrrId(){
	var gridSelect = $('#gridReqLoc').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.lrrId;
    return '';
}

function Save(){
	PHA_GridEditor.GridFinalDone('#' + GRIDID, ['lrrId', 'recLocId']);
	
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    var gridChanges = PHA_GridEditor.GetChangedRows('#' + GRIDID);
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
	    proLocId : locId,
	    rows  : gridChanges
    }
    
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'SaveLocReqRela',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryReqLoc();
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
            var lrrId = gridSelect.lrrId || '';
            if (lrrId == '') {
                var rowIndex = $('#' + GRIDID).datagrid('getRowIndex', gridSelect);
                $('#' + GRIDID).datagrid('deleteRow', rowIndex);
            } else {
	            var pJson = {
		            lrrId  : lrrId,
		            hospId : PHA_COM.Session.HOSPID
	            }
            	PHA.CM(
			        {
			            pClassName : APINAME,  
			            pMethodName: 'DeleteLocReqRela',
			            pJson   : JSON.stringify(pJson),
			        },
			        function (retData) {
				        if (PHA.Ret(retData)) {
							QueryReqLoc();
						}
			        }
			    )
            }
        }
    });
}



function statusFormatterDel(value, rowData, rowIndex) {
    var lrriId = rowData.lrriId;
    return (
        '<span class="icon icon-cancel"  onclick="DelInci(\'' +
        lrriId +
        '\')">&ensp;</span>'
    );
}

function statusFormatterAdd(value, rowData, rowIndex) {
    var inci = rowData.inci
    return (
        '<span class="icon icon-add" style="cursor:pointer;width: 24px;height: 16px;display: inline-block;" onclick="AddInci(\'' +
        inci +
        '\')">&ensp;</span>'
    );
}

/// ���ҩƷ
function AddInci(inci) {
	var lrrId = GetLrrId();
	if(!lrrId){
		PHA.Msg('alert' ,'��ѡ��һ��������Ҽ�¼��');
        return;
	}
    var pJson = {
        lrrId  : lrrId,
        inci   : inci,
        hospId : PHA_COM.Session.HOSPID
    }
	PHA.CM(
        {
            pClassName : APINAME,  
            pMethodName: 'AddInci',
            pJson   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
				QueryInci();
			}
        }
    )
}

/// ɾ��ҩƷ
function DelInci(lrriId) {
	if(!lrriId){
		PHA.Msg('alert' ,'��ѡ����Ҫɾ���ļ�¼��');
        return;
	}
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
	        var pJson = {
		        lrriId : lrriId,
		        hospId : PHA_COM.Session.HOSPID
	        }
        	PHA.CM(
		        {
		            pClassName : APINAME,  
		            pMethodName: 'DelInci',
		            pJson   : JSON.stringify(pJson),
		        },
		        function (retData) {
			        if (PHA.Ret(retData)) {
						QueryInci();
					}
		        }
		    )
        }
    });
}

function ClearGridArr(gridArr){
	var len = gridArr.length
	for (var i=0;i<len;i++){
		var gridId = gridArr[i];
		$('#' + gridId).datagrid('loadData', []);
	}
		
}