/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.08.24
 *	Description	����ҩ��--��ҩ����
 *	JS			scripts/pha/op/v4/stat.return.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridReturnStat();	//	�����б�
	InitDict();				// ��ʼ������
	InitEvent();			//	��ť�¼�
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryReturnStat();});
	//��� toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
function InitDict(){
	// ҽ������--  ҽ�����ҡ������������
    PHA.ComboBox('docLoc',{
	    blurValidValue:true, 
    	url:  PHAOP_STORE.CTLOC().url+"&TypeStr="+"E,EM,OP"	
    });
}
// ��ʼ����ѯ����
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
}
function InitGridReturnStat(){
	var normalCol = [[
		{field: 'TPhDesc',			title: ("ҩƷ����"),		width: 300,		align: 'left'}, 
		{field: 'TPhUom',			title: ("��λ"),			width: 125,		align: 'left'}, 
		{field: 'TRetQty',			title: ("��ҩ����"),		width: 125,		align: 'right'}, 
		{field: 'TRetMoney',		title: ("��ҩ���"),		width: 125,		align: 'right'}, 
	]];
	COMPOMENTS.ComomGrid("gridReturnStat",{
		toolbar : '#gridReturnStatBar',
		columns: normalCol,
		//showFooter: true,
		onLoadSuccess: function (data) {
            //PHA_COM.SumGridFooter('#gridReturnStat' , ['TRetMoney']);
        }
	})
}
function GetParams(){
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.locId = PHAOP_COM.LogonData.LocId;
	return pJson;
}
// ��ѯ��ҩ����
function QueryReturnStat(){
	var $grid =  $("#gridReturnStat");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.RetQuery.Api' ,
        pMethodName:'GetReturnTotal',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridReturnStat').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridReturnStat");
}
// ��ӡ
function Print(){
	var $grid = $("#gridReturnStat");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("ҳ��û������,�޷���ӡ!");
		return;
	}
	var stDate=$("#stDate").datebox("getValue");
	var endDate=$("#endDate").datebox("getValue");
	var dateRange=stDate+" �� "+endDate;
	var title = PHAOP_COM.LogonData.HospDesc+PHAOP_COM.LogonData.LocDesc + "��ҩ����";
	var Para = {
		daterange: dateRange,
		title: title
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPReturnTotal',
		data: {
			Para: Para,
			Grid: {type:'hisui', grid:'gridReturnStat'}
		},
		listBorder: {style:4, startX:6, endX:160},
		page: {rows:30, x:6, y:4, fontname:'����', fontbold:'false', fontsize:'12', format:'��{1}ҳ/��{2}ҳ'}
	});
	/* ��ӡ��־ */
    OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "��ҩͳ��",
			pointer: App_MenuCsp || ""
		}
	)
}