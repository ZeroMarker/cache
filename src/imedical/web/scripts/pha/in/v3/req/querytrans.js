/**
 * 模块:     请求单转移查询
 * 编写日期: 2022-05-12
 * 编写人:   yangsj
 */
var BARID = '#gridInrqBar'

var com = INRQ_COM;
var compoments = INRQ_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    SetRequired();  //占行太宽，不要了
    SetDefa();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function InitDict(){
	/* 申请类型 */
	compoments.ReqTypeId('reqTypeId');
	
	/* 请求科室和供给科室  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    
    /* 类组 */
    compoments.Scg('scg', 'recLocId');
	
	/* 申请单状态 */
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
        { field: 'reqNo',		title: '请求单号',		width: 200,		align: 'left' 	},
        { field: 'proLocDesc', 	title: '供给科室', 		width: 100, 	align: 'left'	},
        { field: 'statusDesc', 	title: '单据状态', 		width: 70, 		align: 'left'	},
        { field: 'creator', 	title: '建单人', 		width: 70, 	align: 'left'	},
        { field: 'createDate', 	title: '建单日期', 		width: 100, 	align: 'left'	},
        { field: 'createTime', 	title: '建单时间', 		width: 100, 	align: 'left'	}
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
        { field: 'inciCode',	title: '药品代码',		width: 100,		align: 'left' 	},
        { field: 'inciDesc', 	title: '药品名称', 		width: 150, 	align: 'left'	},
        { field: 'transFlag', 	title: '转移状态', 		width: 70, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
        { field: 'qty', 		title: '请求数量', 		width: 70, 		align: 'right'	},
        { field: 'transQty', 	title: '转移数量', 		width: 70, 		align: 'right'	},
        { field: 'uomDesc', 	title: '单位', 			width: 60, 		align: 'left'	},
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
        { field: 'reqNo',		title: '请求单号',		width: 150,		align: 'left' 	},
        { field: 'qty', 		title: '请求数量', 		width: 80, 		align: 'right'	},
        { field: 'uomDesc', 	title: '单位', 			width: 60, 		align: 'left'	},
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
		PHA.Msg('info', '请选择一张库存请求单' );
		return;
	}
	PrintReq(inrqId);
}