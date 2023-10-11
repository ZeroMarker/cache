/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.06
 *	Description	����ҩ��--������ͳ��
 *	JS			scripts/pha/op/v4/stat.workload.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridWorkLoad();	//	�����б�
	InitEvent();			//	��ť�¼�
	Clean();				//	������ʼ����ѯ����
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryWorkLoad();});
	//��� toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
// ��ʼ����ѯ����
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");

}
function InitGridWorkLoad(){
	var normalCol = [[
		{field: 'TPhName',			title: ("ҩ����Ա"),			align: 'center',	width: 125},
		{field: 'TPYRC',			title: ("��ҩ����"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFYRC',			title: ("��ҩ����"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TPYJE',			title: ("��ҩ���"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFYJE',			title: ("��ҩ���"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TPYL',				title: ("��ҩ��"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TFYL',				title: ("��ҩ��"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetPresc',		title: ("��ҩ����"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetMoney',		title: ("��ҩ���"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetYL',			title: ("��ҩ��"),			width: 110,			align: 'right',			sortable: true},
		{field: 'TPyFS',			title: ("��ҩ����"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFyFS',			title: ("��ҩ����"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TTyFS',			title: ("��ҩ����"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TJYFS',			title: ("��ҩ����"),			width: 120,			sortable: true,			hidden: true},
		{field: 'TJYCF',			title: ("��ҩ����"),			width: 120,			sortable: true,			hidden: true},
		{field: 'TRetCancleAmt',	title: ("������ҩ���"),		width: 120,			sortable: true},
		{field: 'TRetCancleItmNum',	title: ("������ҩ��"),		width: 120,			sortable: true},
		{field: 'TRetCanclePrescNum',title: ("������ҩ������"),	width: 120,			sortable: true},
		{field: 'TRetCancleCyFs',	title: ("������ҩ����"),		width: 120,			sortable: true,			hidden: true},
		{field: 'TSumAmt',			title: ("�ϼƽ��"),			width: 120,			sortable: true}
	]];
	COMPOMENTS.ComomGrid("gridWorkLoad",{
		toolbar : '#gridWorkLoadBar',
		columns: normalCol,
		onLoadSuccess: function (data) {
            
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
function QueryWorkLoad(){
	var $grid =  $("#gridWorkLoad");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Workload.Api' ,
        pMethodName:'GetWorkLoad',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// ����
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridWorkLoad').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridWorkLoad");
}
// ��ӡ
function Print(){
	var $grid = $("#gridWorkLoad");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("ҳ��û������,�޷���ӡ!");
		return;
	}
	var startdatetime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
	var enddatetime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
	var datetimerange=startdatetime+" �� "+enddatetime;
	var hospDesc = PHAOP_COM.LogonData.HospDesc;
	var Para = {
		titlemain:hospDesc + "���﹤����ͳ��",
		titlesecond: "ҩ��:" + PHAOP_COM.LogonData.LocDesc + "     ͳ�Ʒ�Χ:"+datetimerange,
		lasttitle:"��ӡ��:" + PHAOP_COM.LogonData.UserName +"      ��ӡʱ��:"+PHAOP_COM.PrintDateTime(),
		
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPWorkLoad',
		data:{
			Para: Para,
			Grid: {type:'hisui', grid:'gridWorkLoad'}
		},
		aptListFields: ["lasttitle"],
		listBorder: {style:4, startX:1, endX:265,space:1},
	})
	/* ��ӡ��־ */
	OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "������ͳ��",
			pointer: App_MenuCsp || ""
		}
	)
	
}