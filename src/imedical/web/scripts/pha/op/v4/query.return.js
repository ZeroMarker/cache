/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.08.24
 *	Description	门诊药房--退药查询
 *	JS			scripts/pha/op/v4/query.retrun.js
 */
 
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
$(function () {
	COMPOMENTS = OP_COMPOMENTS;
	InitGridReturnList();	//	处方列表
	InitGridReturnDetail();	//	处方明细
	InitDict();
	InitEvent();			//	按钮事件
	ResizePanel();			//	布局调整	
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryReturnList();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnRePrint', 		'click', function () {RePrint();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnCancel', 		'click', function () {CancelReturn();});
	PHA_EVENT.Bind('#btnExport', 		'click', function () {
		PHAOP_COM.ExportGrid("gridReturnList");
	});
	// 登记号
	$('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#patNo").val());
            if (patNo != "") {
                var newPatNo = PHA_COM.FullPatNo(patNo);
                $(this).val(newPatNo);
                if(newPatNo==""){return;}
                QueryReturnList();
            }
        }
    });
}
// 布局调整
function ResizePanel(){	
	if(APP_PROP.CancleRetPermissions !=="Y"){
		$("#btnCancel").hide();
	}
	setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
	// 药品下拉表格
    PHA_UX.ComboBox.INCItm('inci', {
        width: 397,
        qParams: {
            pJsonStr: {
                stkType: App_StkType,
                scgId: "",
                locId: PHAOP_COM.LogonData.LocId
            }
        }
    });
	InitRetStat();
}
//初始化发药状态
function InitRetStat(){
    var data = [
        { RowId: 0, Description: $g("全部") },
        { RowId: 1, Description: $g("退药") }, 
		{ RowId: 2, Description: $g("已撤消") }
     ];
    PHA.ComboBox('retState',{
        editable:false, 
        data: data,
        onSelect:function(data){
            QueryReturnList();
        }
    }); 
}
// 初始化查询条件
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#retState").combobox("setValue",0) ;
	$("#stTime").timespinner("setValue","000000");
    $("#endTime").timespinner("setValue","235959");
}
function InitGridReturnList(){
	var frozenCol=[[
		{ field: 'TPmiNo', 			title: ('登记号'), 			width: 120,		align: 'left'},
		{ field: 'TPatName', 		title: ('姓名'),	 		width: 80,		align: 'left'},
		{ field: 'TRetDate', 		title: ('退药日期'),	 	width: 120,		align: 'left'},
		{ field: 'TRetTime', 		title: ('退药时间'),	 	width: 80,		align: 'left'},
        { field: 'TPrescNo',		title: ('处方号'),			width: 130,		align: 'left'}
	]];
	var normalCol = [[
		{ field: 'TRetMoney', 		title: ('退药金额'),	 	width: 60,		align: 'left'},
		{ field: 'TRetUser', 		title: ('操作人'),	 		width: 80,		align: 'right'},
		{ field: 'TDoctor', 		title: ('医生'),	 		width: 80,		align: 'left'},
		{ field: 'TLocDesc', 		title: ('科室'),	 		width: 150,		align: 'left'},
		{ field: 'TRetReason', 		title: ('退药原因'),	 	width: 120,		align: 'left'},
		{ field: 'TDispDate', 		title: ('发药日期'),	 	width: 120,		align: 'left'},
		{ field: 'TCancleUser', 	title: ('撤消人'),	 		width: 80,		align: 'left'},
		{ field: 'TCancleDate', 	title: ('撤消日期'),	 	width: 120,		align: 'left'},
		{ field: 'TCancleTime', 	title: ('撤消时间'),	 	width: 120,		align: 'left'},
		{ field: 'TRetRowid', 		title: ('退药单Id'),	 	width: 200,		align: 'left', 		hidden: true},
		{ field: 'TPatLevel', 		title: ('病人级别'),	 	width: 120,		align: 'left', 		hidden: true},
		{ field: 'TEncryptLevel', 	title: ('病人密级'), 		width: 200,		align: 'left', 		hidden: PHAOP_COM.ColHidden.PatLevel},
		{ field: 'TPatLevel', 		title: ('病人级别'),	 	width: 120,		align: 'left', 		hidden: PHAOP_COM.ColHidden.PatLevel}
	]]
	COMPOMENTS.ComomGrid("gridReturnList",{
		columns: normalCol,
		frozenColumns: frozenCol,
		toolbar : '#gridReturnListBar',
		onSelect : function(rowIndex, rowData) {
			QueryReturnDetail();
		},onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridReturnList').datagrid("selectRow",0);
			}else{
				$('#gridReturnDetail').datagrid('clear');
			}
		}
	})
}
function InitGridReturnDetail(){
	var normalCol = [[
		{field: 'TPhDesc',			title: ("药品名称"),		width: 300,		align: 'left'}, 
		{field: 'TPhUom',			title: ("单位"),			width: 125,		align: 'left'}, 
		{field: 'TRetQty',			title: ("退药数量"),		width: 125,		align: 'right'}, 
		{field: 'TPhprice',			title: ("单价"),			width: 125,		align: 'right'},
		{field: 'TRetMoney',		title: ("退药金额"),		width: 125,		align: 'right'}, 
		{field: 'TBatExpStr',		title: ("批号~效期"),		width: 125,		align: 'left'}
	]];
	COMPOMENTS.ComomGrid("gridReturnDetail",{
		columns: normalCol
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
// 查询处方列表
function QueryReturnList(){
	var $grid =  $("#gridReturnList");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.RetQuery.Api' ,
        pMethodName:'GetReturnList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 

}

// 查询处方明细
function QueryReturnDetail(){	
	var $grid =  $("#gridReturnDetail");
	var rowData = $("#gridReturnList").datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "请选择撤消退药数据！");
		return false;
	}
	var pJson = {};
	pJson.retId = rowData.TRetRowid;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.RetQuery.Api' ,
        pMethodName:'GetReturnDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridReturnList').datagrid('clear');
	$('#gridReturnDetail').datagrid('clear');
	InitDefVal();
}
// 撤消退药
function CancelReturn(){
	var $grid = $("#gridReturnList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "请选择撤消退药数据！");
		return false;
	}
	var pJson={
		retId : rowData.TRetRowid,
		locId : PHAOP_COM.LogonData.LocId,
		userId : PHAOP_COM.LogonData.UserId,
		groupId : PHAOP_COM.LogonData.GroupId,
	}
	var retVal = PHA.CM({
		pClassName: 'PHA.OP.Return.Api',
		pMethodName: 'CancelReturn',
		pJson: JSON.stringify(pJson)
	},false);
	var retCode = retVal.code; 
	if(retCode == 0){
		PHAOP_COM._Msg("success","撤消成功!");
		QueryReturnList();
	} else {
		PHAOP_COM._Alert(retVal.msg);
		return false;
	}
}


// 打印
function RePrint(){
	var $grid = $("#gridReturnList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "请选择打印的退药数据！");
		return false;
	}
	var retId = rowData.TRetRowid;
	OP_PRINTCOM.PrintReturn(retId, "补");
}
