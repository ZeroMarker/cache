/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	门诊药房--处方统计
 *	JS			scripts/pha/op/v4/stat.presc.js
 */
var COMPOMENTS ={};
var COM_PID = "" ;
$(function () {
	PHA_COM.SetPanel('#qcondPanel');
	COMPOMENTS = OP_COMPOMENTS;
	InitGridStatPresc();	//	处方列表
	InitDict();
	InitEvent();			//	按钮事件
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryStatPresc();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {Export();});
}
function InitDict(){
	 // 处方类型
    PHA.ComboBox('prescType',{
	    editable:false, 
    	data:[
    		{RowId:"1",Description:$g("门诊处方")},
    		{RowId:"2",Description:$g("急诊处方")},
    		{RowId:"3",Description:$g("体检处方")}
    	]
    });
     // 库存分类
    PHA.ComboBox('incCatId',{
	   blurValidValue:true,  
    	url: PHA_STORE.INCStkCat().url
    });
    PHA.TriggerBox('phcCatId', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('phcCatId', {}, function (data) {
                $('#phcCatId').triggerbox('setValue', data.phcCatDescAll);
                $('#phcCatId').triggerbox('setValueId', data.phcCatId);
            });
        },
        width:396
    });
}
// 初始化查询条件
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");
	$("#prescType").combobox("setValue","1");

}
function InitGridStatPresc(){
	var normalCol = [[
		{field:'TPrescType',		title: ("费别"),			width:100,		align:'left'},
	    {field:'TPrescNum',			title: ("处方数量"),		width:100,		align:'right'},
	    {field:'TPrescTotal',		title: ("处方总数"),		width:100,		align:'right'},
	    {field:'TPrescBL',			title: ("处方比率(%)"),		width:80,		align:'right'},
	    {field:'TPrescMax',			title: ("最高处方"),		width:100,		align:'right',		hidden:true},
	    {field:'TPrescMin',			title: ("最低处方"),		width:100,		align:'right',		hidden:true},
	    {field:'TPrescMaxPmi',		title: ("最高方登记号"),	width:100,		align:'center'},
	    {field:'TPrescMinPmi',		title: ("最低方登记号"),	width:100,		align:'center'},
	    {field:'TPrescMaxMoney',	title: ("最高方金额"),		width:80,		align:'right'},
	    {field:'TPrescMinMoney',	title: ("最低方金额"),		width:80,		align:'right'},
	    {field:'TPrescMoney',		title: ("合计金额"),		width:100,		align:'right'},
	    {field:'TPrescPhNum',		title: ("品种数"),			width:80,		align:'right'},
	    {field:'TCYFS',				title: ("草药付数"),		width:80,		align:'right',		hidden:true},
	    {field:'TJYFS',				title: ("代煎付数"),		width:80,		align:'right',		hidden:true},
	    {field:'TJYCF',				title: ("代煎处方数量"),	width:80,		align:'right',		hidden:true}
	]];
	COMPOMENTS.ComomGrid("gridStatPresc",{
		toolbar : '#gridStatPrescBar',
		columns: normalCol,
		showFooter: true,
		onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridStatPresc').datagrid("selectRow",0);
			}
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
function QueryStatPresc(){
	var $grid =  $("#gridStatPresc");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.PreStat.Api' ,
        pMethodName:'StatLocPresc',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridStatPresc').datagrid('clear');
	InitDefVal();
}
function Export(){
	PHAOP_COM.ExportGrid("gridStatPresc");
}
// 打印
function Print(){
	var $grid = $("#gridStatPresc");
	var rowNum = $grid.datagrid('getData').rows.length;
	if(rowNum == 0){
		PHAOP_COM._Alert("页面没有数据,无法打印!");
		return;
	}
	var stDateTime=$("#stDate").datebox("getValue") + " " + $("#stTime").timespinner('getValue');
	var endDateTime=$("#endDate").datebox("getValue")+ " " + $("#endTime").timespinner('getValue');
	var dateTimeRange=stDateTime+" 至 "+endDateTime;
	var hospDesc = PHAOP_COM.LogonData.HospDesc;
	var Para = {
		titlemain:hospDesc+"处方统计",
		titlesecond: "药房:"+PHAOP_COM.LogonData.LocDesc+"     统计范围:" + dateTimeRange,
		lasttitle:"打印人:"+PHAOP_COM.LogonData.UserName+"      打印时间:" + PHAOP_COM.PrintDateTime()
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAOPPrescStat',
		data:{
			Para: Para,
			Grid: {type:'hisui', grid:'gridStatPresc'}
		},
		aptListFields: ["lasttitle"],
		listBorder: {style:4, startX:1, endX:195,space:1},
	})
	/* 打印日志 */
    OP_PRINTCOM.PrintLog("page",{
			Para: Para
		},{},{
			remarks: "处方统计",
			pointer: App_MenuCsp || ""
		}
	)
}
window.onbeforeunload = function (){
}