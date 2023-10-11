/**
 * 模块:     库存转移流程审核
 * 编写日期: 2022-04-41
 * 编写人:   yangsj
 */
var INITGRID = 'gridInit'
var INITIGRID = 'gridIniti'
var BARID = '#gridInitBar'
var BARIID = '#gridInitiBar'

var com = INIT_COM;
var compoments = INIT_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    BindBtnEvent();
    SetRequired();
    SetDefa();
    DefultQuery();
    Config();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function BindBtnEvent(){
	PHA.BindBtnEvent(BARID);
	PHA.BindBtnEvent(BARIID)
}

function InitDict(){
	/* 转移类型 */
    compoments.OpertId('opertId');

    /* 预审流程 */
    compoments.StatusCode('nextStatusCode', 'AUDIT', '', false, true, Query);
    
    /* 流程状态 */
    compoments.StatusResult('nextStatusResult', true, Query);
    
    /* 供给科室和请求科室  */
    compoments.FrToLoc('proLocId', ['recLocId']);
    
    /* 麻醉精一  */
    compoments.MZJY('mzjy');
}

function InitGrid(){
	compoments.InitMainGrid(INITGRID, BARID, QueryIniti);
	compoments.InitDetailGrid(INITIGRID,BARIID,true);
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaDaysAudit),
		endDate   : com.GetDateStr('0')
	}])
	$('#nextStatusCode').combobox('reload');
	$('#nextStatusResult').combobox('reload');
}


function Query(){
	compoments.Clear([INITGRID, INITIGRID]);
	QueryInit();
}

function QueryInit(){
	var pJson = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    if(pJson.length == 0) return;
    com.QueryMain(INITGRID, pJson[0]);
}

function QueryIniti(){
	com.QueryDetail(INITIGRID, {initId:com.GetInitId(INITGRID)});
}

function DefultQuery(){
	setTimeout(function(){Query();}, 500);
}

function Clear(){
	compoments.Clear([INITGRID, INITIGRID], [BARID]);
	SetDefa();
}

function Audit(){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue');
	if(!nextStatusCode){
		PHA.Msg('alert', '请选择一个预流程状态');
	    return;
	}
	var	pJson = {
		initId		   : initId,
		nextStatusCode : nextStatusCode,
	}
	com.BizConfirm(pJson, 'Audit', function(){
		Query();
		if(nextStatusCode == 'OUTAUDIT'){
			if(com.ParamTrans.AutoPrintAfterAckOut == 'Y'){
				PrintTrans(initId);
			}
			if ((com.ParamTrans.AutoAckInAfterAckOut == 'Y')&&(nextStatusCode == 'OUTAUDIT')){
			    // '出库审核'之后自动自动审核到'转移接收'
			    com.Biz(pJson, 'AutoInAuditFrOutAudit', Query);
		    }
		}
	});
}

function CancelAudit(){
	var initId = ''
	var gridSelect = $('#' + INITGRID).datagrid('getSelected') || '';
    if (gridSelect)  initId = gridSelect.initId;
    if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	
	var statusDesc = gridSelect.statusDesc;
	var statusCode = gridSelect.statusCode;
	
	var	pJson = {
		initId	 : initId,
		statusCode : statusCode,
		userId 	 : session['LOGON.USERID']
	}

	var cancelMsg = '您确认取消 "'+ statusDesc + '" 的流程状态么？'
	if (statusCode == 'OUTAUDIT') cancelMsg = '取消 "' + gridSelect.statusDesc +'" 操作将处理并将该转移单置为 (作废) 状态，是否继续操作？'
	
	com.BizConfirm(pJson, 'CancelAudit', function(){
		Query();
	}, '', cancelMsg);
}


function Refuse(){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue')
	if(!nextStatusCode){
		PHA.Msg('alert', '请选择一个预流程状态');
	    return;
	}
	var pJson = {
        initId: initId,
        statusCode: nextStatusCode
    };
	
	com.BizPrompt(pJson, 'RefuseAudit', function(){
		Query();
	});
}


function MZJYAudit1(){
	MZJYAudit('OutMZJY1');
}

function MZJYAudit2(){
	MZJYAudit('OutMZJY2');
}

function MZJYAudit(mzjyAuditStatus){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	var pJson = {
		initId : initId,
		mzjyAuditStatus : mzjyAuditStatus,
		statusCode : 'OUTAUDIT'
	}
	com.BizConfirm(pJson, 'MZJYAudit', function(){
		Query();
	});
}

function Config(){
	if (com.ParamTrans.OutPoisonDoubleSign != 'Y'){
		$('#btnMZJYAudit1').hide();
		$('#btnMZJYAudit2').hide();
		$('#labelFormzjy').hide();
		$('#mzjy').next(".combo").hide();
	}
}


