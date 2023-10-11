/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.08.24
 *	Description	门诊药房--退药汇总
 *	JS			scripts/pha/op/v4/stat.return.js
 */
var COMPOMENTS ={};
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridReturnStat();	//	处方列表
	InitDict();				// 初始化下拉
	InitEvent();			//	按钮事件
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryReturnStat();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
function InitDict(){
	// 医生科室--  医生科室、急诊、手术科室
    PHA.ComboBox('docLoc',{
	    blurValidValue:true, 
    	url:  PHAOP_STORE.CTLOC().url+"&TypeStr="+"E,EM,OP"	
    });
}
// 初始化查询条件
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
}
function InitGridReturnStat(){
	var normalCol = [[
		{field: 'TPhDesc',			title: ("药品名称"),		width: 300,		align: 'left'}, 
		{field: 'TPhUom',			title: ("单位"),			width: 125,		align: 'left'}, 
		{field: 'TRetQty',			title: ("退药数量"),		width: 125,		align: 'right'}, 
		{field: 'TRetMoney',		title: ("退药金额"),		width: 125,		align: 'right'}, 
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
// 查询退药汇总
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
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridReturnStat').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridReturnStat");
}
// 打印
function Print(){
	var $grid = $("#gridReturnStat");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("页面没有数据,无法打印!");
		return;
	}
	var stDate=$("#stDate").datebox("getValue");
	var endDate=$("#endDate").datebox("getValue");
	var dateRange=stDate+" 至 "+endDate;
	var title = PHAOP_COM.LogonData.HospDesc+PHAOP_COM.LogonData.LocDesc + "退药汇总";
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
		page: {rows:30, x:6, y:4, fontname:'黑体', fontbold:'false', fontsize:'12', format:'第{1}页/共{2}页'}
	});
	/* 打印日志 */
    OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "退药统计",
			pointer: App_MenuCsp || ""
		}
	)
}