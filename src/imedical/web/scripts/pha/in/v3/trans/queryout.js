/**
 * ģ��:     ���ת�Ƴ����ѯ
 * ��д����: 2022-05-11
 * ��д��:   yangsj
 */
var INITGRID = 'gridInit'
var INITIGRID = 'gridIniti'
var BARID = '#gridInitBar'
var BARIID = '#gridInitiBar';

var com = INIT_COM;
var compoments = INIT_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    SetRequired();
    SetDefa();
    setTimeout(function(){Query();}, 300);
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function InitDict(){
	/* ת������ */
    compoments.OpertId('opertId');

    /* ����״̬ */
    compoments.StatusCode('statusCode', 'ALL', '', true, true);
    
    /* �������Һ��������  */
    compoments.FrToLoc('proLocId', ['recLocId']);
    
    /* ҩƷ���� */
    compoments.Inci('inci');
}

function InitGrid(){
	compoments.InitMainGrid(INITGRID, BARID, QueryIniti);
	compoments.InitDetailGrid(INITIGRID,BARIID,true);
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate   : com.GetDateStr(com.ParamTrans.DefaEndDate)
	}]);
	$('#statusCode').combobox('reload');
}

function Query(){
	var pJson = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    com.QueryMain(INITGRID, pJson[0]);
}

function QueryIniti(){
	com.QueryDetail(INITIGRID, {initId:com.GetInitId(INITGRID)});
}

function Clear(){
	compoments.Clear([INITGRID, INITIGRID], [BARID]);
	SetDefa();
}