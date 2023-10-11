/**
 * ģ��:     ���ת���������
 * ��д����: 2022-04-41
 * ��д��:   yangsj
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
	/* ת������ */
    compoments.OpertId('opertId');

    /* Ԥ������ */
    compoments.StatusCode('nextStatusCode', 'AUDIT', '', false, true, Query);
    
    /* ����״̬ */
    compoments.StatusResult('nextStatusResult', true, Query);
    
    /* �������Һ��������  */
    compoments.FrToLoc('proLocId', ['recLocId']);
    
    /* ����һ  */
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
		PHA.Msg('alert', '��ѡ��һ�ſ��ת�Ƶ�');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue');
	if(!nextStatusCode){
		PHA.Msg('alert', '��ѡ��һ��Ԥ����״̬');
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
			    // '�������'֮���Զ��Զ���˵�'ת�ƽ���'
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
		PHA.Msg('alert', '��ѡ��һ�ſ��ת�Ƶ�');
	    return;
	}
	
	var statusDesc = gridSelect.statusDesc;
	var statusCode = gridSelect.statusCode;
	
	var	pJson = {
		initId	 : initId,
		statusCode : statusCode,
		userId 	 : session['LOGON.USERID']
	}

	var cancelMsg = '��ȷ��ȡ�� "'+ statusDesc + '" ������״̬ô��'
	if (statusCode == 'OUTAUDIT') cancelMsg = 'ȡ�� "' + gridSelect.statusDesc +'" ��������������ת�Ƶ���Ϊ (����) ״̬���Ƿ����������'
	
	com.BizConfirm(pJson, 'CancelAudit', function(){
		Query();
	}, '', cancelMsg);
}


function Refuse(){
	var initId = com.GetInitId(INITGRID);
	if(!initId){
		PHA.Msg('alert', '��ѡ��һ�ſ��ת�Ƶ�');
	    return;
	}
	var nextStatusCode = $('#nextStatusCode').combobox('getValue')
	if(!nextStatusCode){
		PHA.Msg('alert', '��ѡ��һ��Ԥ����״̬');
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
		PHA.Msg('alert', '��ѡ��һ�ſ��ת�Ƶ�');
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


