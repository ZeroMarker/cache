/**
 * 模块:     库存转移接收
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
    SetDefa();
    BindBtnEvent();
    SetRequired();
    DefultQuery();
    Config();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function BindBtnEvent(){
	PHA.BindBtnEvent(BARID)
	PHA.BindBtnEvent(BARIID)
}

function InitDict(){
	/* 转移类型 */
    compoments.OpertId('opertId');

    /* 预审流程 */
    compoments.StatusCode('nextStatusCode', 'AUDIT', 'INAUDIT', false, true);
    
    /* 流程状态 */
    compoments.StatusResult('nextStatusResult', true, Query);
    
    /* 请求科室和供给科室  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    
    /* 麻醉精一  */
    compoments.MZJY('mzjy');
}

function InitGrid(){
	compoments.InitMainGrid(INITGRID, BARID, QueryIniti);
	compoments.InitDetailGrid(INITIGRID, BARIID, true);
}

function SetDefa(){
	PHA.SetVals([{ 
		recLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaDaysAudit),
		endDate   : com.GetDateStr(0)
	}]);
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
		initId		 : initId,
		nextStatusCode : nextStatusCode,
		userId 		 : session['LOGON.USERID']
	}
	com.BizConfirm(pJson, 'AuditForIn', function(){
		Query();
		if(nextStatusCode == 'INAUDIT'){
			if(com.ParamTrans.AutoPrintAfterAckIn == 'Y'){
				PrintTrans(initId);
			}
		}
	});
   
}

function CancelAudit(){
	var initId = '';
	var gridSelect = $('#' + INITGRID).datagrid('getSelected') || '';
    if (gridSelect)  initId = gridSelect.initId;
    if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	
	var statusDesc = gridSelect.statusDesc;
	var statusCode = gridSelect.statusCode;
	
	if(statusCode != 'INAUDIT'){
		PHA.Msg('alert', '该转移单状态为 ' + statusDesc + ' 不可取消审核！请选择一张已经转移接收的单据！');
	    return;
	} 
	var cancelMsg = '该操作将会回退库存，您确认取消 '+ statusDesc + '的流程状态么？ ';
	var	pJson = {
		initId	 : initId,
		statusCode : statusCode,
	}
	com.BizConfirm(pJson, 'CancelAuditForIn', function(){
		Query();
	}, '', cancelMsg);
}

function PartInAudit(){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	var initiChecked = $('#' + INITIGRID).datagrid('getChecked');
	var len = initiChecked.length
	if(!len){
		PHA.Msg('alert', '请勾选需要接收的转移明细！');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue')
	if(!nextStatusCode){
		PHA.Msg('alert', '请选择一个预流程状态');
	    return;
	}
	var	pJson = {
		initId		 : initId,
		nextStatusCode : nextStatusCode,
		rows		 : initiChecked
	}
	com.BizConfirm(pJson, 'AuditForIn', function(){
		PHA.CM({
            pClassName : com.API,  
            pMethodName: 'GetMainData',
            pJson	   : JSON.stringify({initId:initId}),
        },
        function (retData) {
	       var mainRowIndex = com.GetSelectRowIndex(INITGRID);
	        if(mainRowIndex != ''){
		        $('#' + INITGRID).datagrid('updateRowData', {
					index: mainRowIndex,
					row: retData
				});
	        }	        
		    QueryIniti();
        }) 
	});
}

function PartInCancel(){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '请选择一张库存转移单');
	    return;
	}
	var initiChecked = $('#' + INITIGRID).datagrid('getChecked');
	var len = initiChecked.length
	if(!len){
		PHA.Msg('alert', '请勾选需要取消接收的转移明细！');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue')
	if(!nextStatusCode){
		PHA.Msg('alert', '请选择一个预流程状态');
	    return;
	}
	var	pJson = {
		initId		 : initId,
		statusCode   : nextStatusCode,
		rows		 : initiChecked
	}
	com.BizConfirm(pJson, 'CancelAuditForIn', function(){
		PHA.CM({
            pClassName : com.API,  
            pMethodName: 'GetMainData',
            pJson	   : JSON.stringify({initId:initId}),
        },
        function (retData) {
	        var mainRowIndex = com.GetSelectRowIndex(INITGRID);
	        if(mainRowIndex != ''){
		        $('#' + INITGRID).datagrid('updateRowData', {
					index: mainRowIndex,
					row: retData
				});
	        }	        
		    QueryIniti();
        }) 
	});
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
	MZJYAudit('InMZJY1');
}

function MZJYAudit2(){
	MZJYAudit('InMZJY2');
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
		statusCode : 'INAUDIT'
	}
	com.BizConfirm(pJson, 'MZJYAudit', function(){
		Query();
	});
}

function Config(){
	if (com.ParamTrans.InPoisonDoubleSign != 'Y'){
		$('#btnMZJYAudit1').hide();
		$('#btnMZJYAudit2').hide();
		$('#labelFormzjy').hide();
		$('#mzjy').next(".combo").hide();
	}
}
