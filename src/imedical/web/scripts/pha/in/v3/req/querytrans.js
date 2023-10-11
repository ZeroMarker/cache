/**
 * ģ��:     ����ת�Ʋ�ѯ
 * ��д����: 2022-05-12
 * ��д��:   yangsj
 */
var BARID = '#gridInrqBar'

var com = INRQ_COM;
var compoments = INRQ_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    SetRequired();  //ռ��̫����Ҫ��
    SetDefa();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function InitDict(){
	/* �������� */
	compoments.ReqTypeId('reqTypeId');
	
	/* ������Һ͹�������  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    
    /* ���� */
    compoments.Scg('scg', 'recLocId');
	
	/* ���뵥״̬ */
	compoments.ReqStatus('reqStatus', 'ALL', true, true);
}

function InitGrid(){
	InitGridInrq();
	InitGridInrqiIniti();
	InitGridInitiInrqi();
}

function SetDefa(){
	PHA.SetVals([{ 
		recLocId  : session['LOGON.CTLOCID'],
		startDate : 't - 7',
		endDate   : 't',
		reqStatus : ['SAVE', 'COMP']
	}])	
}

function InitGridInrq(){
	var columns = [[
		{ field: 'inrqId', 		title: 'inrqId', 		hidden: true 					},
        { field: 'reqNo',		title: '���󵥺�',		width: 200,		align: 'left' 	},
        { field: 'proLocDesc', 	title: '��������', 		width: 100, 	align: 'left'	},
        { field: 'statusDesc', 	title: '����״̬', 		width: 70, 		align: 'left'	},
        { field: 'creator', 	title: '������', 		width: 70, 	align: 'left'	},
        { field: 'createDate', 	title: '��������', 		width: 100, 	align: 'left'	},
        { field: 'createTime', 	title: '����ʱ��', 		width: 100, 	align: 'left'	}
	]];
		
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : INRQ_COM.API,
            pMethodName: 'QueryInrq',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: '#gridInrqBar',
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		      	QueryInrqiIniti();
            }
        }
    };
    PHA.Grid('gridInrq', dataGridOption);
}

function InitGridInrqiIniti(){
	var columns = [[
		{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true 					},
        { field: 'inciCode',	title: 'ҩƷ����',		width: 100,		align: 'left' 	},
        { field: 'inciDesc', 	title: 'ҩƷ����', 		width: 150, 	align: 'left'	},
        { field: 'transFlag', 	title: 'ת��״̬', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
        { field: 'qty', 		title: '��������', 		width: 70, 		align: 'right'	},
        { field: 'transQty', 	title: 'ת������', 		width: 70, 		align: 'right'	},
        { field: 'uomDesc', 	title: '��λ', 			width: 60, 		align: 'left'	},
	]];
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : INRQ_COM.API,
            pMethodName: 'QueryDetail',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        fitColumns: true,
		singleSelect: true,
		pagination: true,
		columns: columns,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		      	QueryInitiInrqi();
            }
        }
	};
	PHA.Grid('gridInrqiIniti', dataGridOption);
}
function InitGridInitiInrqi(){
	var columns = [[
		{ field: 'initId', 		title: 'initId', 		hidden: true 					},
        { field: 'reqNo',		title: '���󵥺�',		width: 150,		align: 'left' 	},
        { field: 'qty', 		title: '��������', 		width: 80, 		align: 'right'	},
        { field: 'uomDesc', 	title: '��λ', 			width: 60, 		align: 'left'	},
	]];
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : INRQ_COM.API,
            pMethodName: 'QueryInrqiRela',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
		singleSelect: true,
		pagination: true,
		columns: columns,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true
	};
	PHA.Grid('gridInitiInrqi', dataGridOption);
}

function Query(){
	QueryInrq();	
}

function QueryInrq(){
	var pJson = PHA.DomData('#gridInrqBar', {
        doType: 'query',
        retType: 'Json'
    });
	$('#gridInrq').datagrid('query', {
        pJson : JSON.stringify(pJson[0]),
    });
}

function QueryInrqiIniti(){
	var inrqId = GetInrqId();
	if (!inrqId) return;
	$('#gridInrqiIniti').datagrid('query', {
        pJson : JSON.stringify({inrqId:inrqId}),
    });
}
function QueryInitiInrqi(){
	var inrqiId = GetInrqiId();
	if (!inrqiId) return;
	$('#gridInitiInrqi').datagrid('query', {
        pJson : JSON.stringify({inrqiId:inrqiId}),
    });
}

function GetInrqId(){
	var gridSelect = $('#gridInrq').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.inrqId;
    return '';
}

function GetInrqiId(){
	var gridSelect = $('#gridInrqiIniti').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.inrqiId;
    return '';
}

function GetMainObj(){
	var initJsonStr = PHA.DomData('#gridInitBar', {
        doType: 'query',
        retType: 'Json'
    });
	var mainObj = initJsonStr[0];
	mainObj['initId'] = InitId;
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Clear(){
	compoments.Clear(['gridInrq', 'gridInrqiIniti', 'gridInitiInrqi'], [BARID]);
	SetDefa();
}

function Print(){
	var inrqId = GetInrqId();
	if (!inrqId) {
		PHA.Msg('info', '��ѡ��һ�ſ������' );
		return;
	}
	PrintReq(inrqId);
}