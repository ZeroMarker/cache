/**
 * 模块:     辅助转移(依据入库单)
 * 编写日期: 2022-04-41
 * 编写人:   yangsj
 */
var cmbWidth = '150'; 

var RECGRID = 'gridRec';
var RECIGRID = 'gridReci';
var BARID = '#gridRecBar';

var com = INIT_COM;
var compoments = INIT_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    BindBtnEvent();
    SetDefa();
    SetRequired();
    DefultQuery();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'));
}

function BindBtnEvent(){
	PHA.BindBtnEvent(BARID);
}

function InitDict(){
	/* 经营企业 */
    PHA.ComboBox('vendorId', {
        width: cmbWidth,
        url: PHA_STORE.APCVendor().url,
    });

	/* 供给科室和请求科室  */
    compoments.FrToLoc('proLocId', ['recLocId']);
}

function InitGrid(){
	InitGridInit();
	InitGridIniti();
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate   : com.GetDateStr(com.ParamTrans.DefaEndDate)
	}])
	$('#nextStatusCode').combobox('reload')
}

function InitGridInit(){
	var frozenColumns = [
		[
			{ field: 'recId', 		title: 'ingdId', 		hidden: true 						},
        	{ field: 'recNo', 		title: '入库单号', 		width: 180,			align: 'left' 	},
		]
    ];
	
	var columns = [
        [
            { field: 'recLocDesc', 	title: '入库科室', 			width: 100, 	align: 'left'	},
            { field: 'transFlag', 	title: '已转移', 			width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'createDT', 	title: '建单时间', 			width: 180, 	align: 'left'	},
            { field: 'creator', 	title: '建单人', 			width: 100, 	align: 'left'	}
        ]
    ];

    var dataGridOption = {
		url: PHA.$URL,
		singleSelect: true,
		pagination: true,
		columns: columns,
		frozenColumns:frozenColumns,
		toolbar: BARID,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		      	QueryReci();
            }
        },
		onDblClickRow: function (rowIndex, rowData) {}
	};
	PHA.Grid(RECGRID, dataGridOption);
}

function InitGridIniti(){
	var frozenColumns = [
		[
			{ field: 'recItmID', 	title: 'recItmID', 		hidden: true },
        	{ field: 'inclb', 		title: 'inclb', 		hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 200,			align: 'left' },
            { field: 'inciDesc',	title: '药品名称',		width: 200,			align: 'left' },
		]
    ];
	
	var columns = [
        [
            { field: 'qty', 		title: '入库数量', 			width: 100, 	align: 'right'	},
            { field: 'uomDesc', 	title: '单位', 				width: 120, 	align: 'left'	},
            { field: 'rp', 			title: '进价', 				width: 120, 	align: 'right'	},
            { field: 'sp', 			title: '售价', 				width: 120, 	align: 'right'	},
            { field: 'rpAmt', 		title: '进价金额', 			width: 120, 	align: 'right'	},
            { field: 'spAmt', 		title: '售价金额', 			width: 120, 	align: 'right'	},
            { field: 'batNo', 		title: '批号', 				width: 120, 	align: 'left'	},
            { field: 'expDate', 	title: '效期', 				width: 120, 	align: 'left'	}
        ]
    ];
	
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {},
		singleSelect: false,
		pagination: false,
		columns: columns,
		frozenColumns: frozenColumns,
		gridSave: false,
		idField: 'recItmID',
		isCellEdit: false,
		allowEnd: true,
		loadFilter:PHA.localFilter,
		showFooter: true,
		onLoadSuccess: function (data) {
			PHA_COM.SumGridFooter('#' + RECIGRID, ['rpAmt', 'spAmt']);
		}
	};
	PHA.Grid(RECIGRID, dataGridOption);
}

function Query(){
	QueryRec();	
}

function CreateByRec()
{
    var recId = GetRecId()
    if(!recId){
	    PHA.Msg('alert', '请选择一张入库单！');
	    return;
    }
    var recLocId = $('#recLocId').combobox('getValue')
    if(!recLocId){
	    PHA.Msg('alert', '请选择请求科室！');
	    return;
    }
    
    var pJson = {
	    recId : recId,
	    recLocId:recLocId,
    }
    com.Biz(pJson, 'CreateByRec', com.SkipLink); 
}

function GetMainObj(){
	var initJsonStr = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    if (!initJsonStr.length) return {};
	var mainObj = initJsonStr[0];
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Clear(){
	compoments.Clear([RECGRID, RECIGRID], [BARID]);
	SetDefa();
}

function QueryRec(){
	compoments.Clear([RECIGRID]);
	var pJson = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    
	$('#gridRec').datagrid('query', {
        pJson : JSON.stringify(pJson[0]),
        pClassName: com.API,
        pMethodName: 'QueryRec',
        pPlug: 'datagrid'
    });
}

function QueryReci(){
	var recId = GetRecId();
	if (!recId) return;
    
    $('#gridReci').datagrid('query', {
        pJson : JSON.stringify({recID:GetRecId()}),
        pClassName: 'PHA.IN.REC.Api',
        pMethodName: 'GetItmDataRows',
        pPlug: 'datagrid'
    });
    
    /*
    $('#gridReci').datagrid('query', {
        pJson : JSON.stringify({recID:recId}),
    });
            pClassName : 'PHA.IN.REC.Api',
            pMethodName: 'GetItmDataRows',
            pPlug	   : 'datagrid',
            pJson      : '{}',
 */       
}

function GetRecId(){
	var gridSelect = $('#gridRec').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.recId;
    return '';
}

