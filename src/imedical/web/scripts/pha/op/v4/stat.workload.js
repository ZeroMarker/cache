/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.06
 *	Description	门诊药房--工作量统计
 *	JS			scripts/pha/op/v4/stat.workload.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridWorkLoad();	//	处方列表
	InitEvent();			//	按钮事件
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryWorkLoad();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
// 初始化查询条件
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");

}
function InitGridWorkLoad(){
	var normalCol = [[
		{field: 'TPhName',			title: ("药房人员"),			align: 'center',	width: 125},
		{field: 'TPYRC',			title: ("配药处方"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFYRC',			title: ("发药处方"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TPYJE',			title: ("配药金额"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFYJE',			title: ("发药金额"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TPYL',				title: ("配药量"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TFYL',				title: ("发药量"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetPresc',		title: ("退药处方"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetMoney',		title: ("退药金额"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TRetYL',			title: ("退药量"),			width: 110,			align: 'right',			sortable: true},
		{field: 'TPyFS',			title: ("配药付数"),			width: 120,			align: 'right',			sortable: true},
		{field: 'TFyFS',			title: ("发药付数"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TTyFS',			title: ("退药付数"),			width: 100,			align: 'right',			sortable: true},
		{field: 'TJYFS',			title: ("煎药付数"),			width: 120,			sortable: true,			hidden: true},
		{field: 'TJYCF',			title: ("煎药处方"),			width: 120,			sortable: true,			hidden: true},
		{field: 'TRetCancleAmt',	title: ("撤消退药金额"),		width: 120,			sortable: true},
		{field: 'TRetCancleItmNum',	title: ("撤消退药量"),		width: 120,			sortable: true},
		{field: 'TRetCanclePrescNum',title: ("撤消退药处方数"),	width: 120,			sortable: true},
		{field: 'TRetCancleCyFs',	title: ("撤消退药付数"),		width: 120,			sortable: true,			hidden: true},
		{field: 'TSumAmt',			title: ("合计金额"),			width: 120,			sortable: true}
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
// 查询退药汇总
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
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridWorkLoad').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridWorkLoad");
}
// 打印
function Print(){
	var $grid = $("#gridWorkLoad");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("页面没有数据,无法打印!");
		return;
	}
	var startdatetime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
	var enddatetime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
	var datetimerange=startdatetime+" 至 "+enddatetime;
	var hospDesc = PHAOP_COM.LogonData.HospDesc;
	var Para = {
		titlemain:hospDesc + "门诊工作量统计",
		titlesecond: "药房:" + PHAOP_COM.LogonData.LocDesc + "     统计范围:"+datetimerange,
		lasttitle:"打印人:" + PHAOP_COM.LogonData.UserName +"      打印时间:"+PHAOP_COM.PrintDateTime(),
		
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
	/* 打印日志 */
	OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "工作量统计",
			pointer: App_MenuCsp || ""
		}
	)
	
}