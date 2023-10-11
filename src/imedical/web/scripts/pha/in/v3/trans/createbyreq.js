/**
 * 模块:     库存转移制单(依据请求单)
 * 编写日期: 2022-05-06
 * 编写人:   yangsj
 */

var cmbWidth = '140';
var LongCmbWidth1 = '300'; 
var LongCmbWidth2 = '300';
var INRQGRID = 'gridInrq';
var INRQIGRID = 'gridInrqi';
var BARID = '#gridInrqBar';

var com = INIT_COM;
var com_req = INRQ_COM;
var compoments = INIT_COMPOMENTS;
var compoments_req = INRQ_COMPOMENTS;

$(function () {
	WidthCss();
    InitDict();
    InitGrid();
    SetRequired()
    SetDefu();
    Config();
    Query();     //默认查询
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function InitDict(){
    /* 供给科室和请求科室  */
    compoments.FrToLoc('proLocId', ['recLocId']);
    
    /* 申请单状态 */
	compoments_req.ReqStatus('reqStatus', 'TRANS', true,  true, LongCmbWidth1);
	
	/* 申请类型 */
	compoments_req.ReqTypeId('reqTypeId');
    
    /* 药品名称 */
    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: LongCmbWidth2,
    });
    PHA.LookUp('inci', opts);  
   
}

function SetDefu(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate   : com.GetDateStr(com.ParamTrans.DefaEndDate)
	}])
	$('#reqStatus').combobox('setValues',['COMP','PARTTRANS','PARTREFUSE'])
}

function InitGrid(){
	InitGridInrq();
	InitGridInrqi();
}


function InitGridInrq(){
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {},
		singleSelect: false,
		pagination: true,
		columns: compoments_req.Columns.Main.Normal(),
		frozenColumns: compoments_req.Columns.Main.Frozen({select:true}),
		toolbar: BARID,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		 onSelectAll:function(e){
	        setTimeout('QueryCombineInrqi()',200)
        },
        onUnselectAll:function(e){
	        setTimeout('QueryCombineInrqi()',200)
        },
        onSelect: function (rowIndex, rowData) {
			setTimeout('QueryCombineInrqi()',200)
	    },
	    onUnselect: function (rowIndex, rowData) {
			setTimeout('QueryCombineInrqi()',200)
		},
		onClickCell: function (index, field, value) {      
			if(field == "reqNo"){
				var rowData = $('#' + INRQGRID).datagrid('getData').rows[index];
				PHA_UX.BusiTimeLine({},{
					busiCode: INRQ_COMPOMENTS.BUSICODE,
					locId: session['LOGON.CTLOCID'],
					pointer: rowData.inrqId
				});
			}else{
				PHA_UX.BusiTimeLine({},{},"close")
			}
		}
	};
	PHA.Grid(INRQGRID, dataGridOption);
}

function InitGridInrqi(){
	var frozenColumns = [
		[	
			{ field: 'tSelect', 	checkbox: true },
            { field: 'inrqiIdStr', 	title: 'inrqiIdStr', 	hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 100,		align: 'left'  },
            { field: 'inciDesc',	title: '药品名称',		width: 200,		align: 'left'  },
            { field: 'refuseFlag', 	title: '拒绝', 			width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'transFlag', 	title: '已转移', 		width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'inci', 		title: 'inci', 			hidden: true }
           
        ]
	];
    var dataGridOption = {
        url: PHA.$URL,
		queryParams: {},
        singleSelect: false,
        gridSave: false,
        toolbar: '#gridInrqiBar',
        pagination: false,
        fitColumns: false,
        columns: INRQ_COMPOMENTS.Columns.Detail.Normal(),
        frozenColumns: frozenColumns,
        exportXls: false,
        showFooter: true,
		onLoadSuccess: function (data) {
			PHA_COM.SumGridFooter('#' + INRQIGRID, ['rpAmt', 'spAmt']);
		},
    };
    PHA.Grid(INRQIGRID, dataGridOption);
}

function Query(){
	compoments.Clear([INRQGRID, INRQIGRID]);
	var pJson = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    if(!pJson.length) return;
    com_req.QueryMain(INRQGRID, pJson[0]);
}

function QueryCombineInrqi(){
	compoments.Clear([INRQIGRID]);
	var inrqIdStr = GetInrqIdStr();
	var $grid = $('#' + INRQIGRID);
    $grid.datagrid('query', {
        pClassName: com_req.API,
        pMethodName: 'QueryCombineInrqi',
        pJson: JSON.stringify({inrqIdStr:inrqIdStr}),
        pPlug: 'datagrid'
    });
}

function GetInrqIdStr(){
	var inrqIdStr = '';
    var gridChecked = $('#' + INRQGRID).datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        inrqIdStr = inrqIdStr == '' ? gridChecked[i].inrqId : inrqIdStr + ',' + gridChecked[i].inrqId;
    }
    return inrqIdStr
}

function GetInrqiIdStr(){
	var inrqiIdStr = '';
    var gridChecked = $('#' + INRQIGRID).datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        inrqiIdStr = inrqiIdStr == '' ? gridChecked[i].inrqiIdStr : inrqiIdStr + ',' + gridChecked[i].inrqiIdStr;
    }
    return inrqiIdStr
}

function Clear(){
	compoments.Clear([INRQGRID, INRQIGRID], [BARID]);
	SetDefu();
}

function SaveByInrq(){
	var inrqIdStr = GetInrqIdStr();
    if (inrqIdStr == '') 
    {
	   PHA.Msg('info' ,'请选择请求单！');
	   return;
    }
	var	pJson = {
		inrqIdStr : inrqIdStr,
	}
	com_req.Biz(pJson, 'CreateByInrqIdStr', com.SkipLink);
}

function SaveByInrqi(){
    var inrqiIdStr = GetInrqiIdStr();
    if (inrqiIdStr == '') 
    {
	   PHA.Msg('info' ,'请选择请求单明细！');
	   return;
    }
	var	pJson = {
		inrqiIdStr : inrqiIdStr,
	}
	com_req.Biz(pJson, 'CreateByInrqiIdStr', com.SkipLink);    
}

function RefuseInrqi(CancelType){
	var CancelType = (CancelType == 'Y') ? 'Y' : 'N'
	var msgStr = (CancelType == 'Y') ? $g('拒绝') : $g('取消拒绝')
	var gridChecked = $('#' + INRQIGRID).datagrid('getChecked');
	if(!gridChecked.length){
		PHA.Msg('info' ,'请勾选需要' + msgStr + '的明细！' );
	    return;
	}
	
	var pJson = {
	    rows:gridChecked,
	    cancelType:CancelType
    }
    com_req.Biz(pJson, 'RefuseInrqi', QueryCombineInrqi);  
}

function Config(){
	if (com.ParamTrans.CancelReqItm != 'Y'){
		$('#btnCancelCancel').hide();
		$('#btnCancel').hide();
	}
}

function WidthCss(){
	if(HISUIStyleCode == 'lite'){
		LongCmbWidth2 = '293';
	}
}