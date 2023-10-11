/*
 *	Creator		zhaozhiduan
 *  CreatDate	2022.09.07
 *	Description	门诊药房--基数药补货单查询
 *	JS			scripts/pha/op/v4/query.supply.js
 */
 
var COMPOMENTS ={};
var APP_PROP = PHA_COM.ParamProp(PHAOP_COM.APP_NAME);
$(function () {
	COMPOMENTS = OP_COMPOMENTS;
	InitGridSupplyList();	//	处方列表
	InitGridSupplyDetail();	//	处方明细
	InitDict();
	InitEvent();			//	按钮事件
	ResizePanel();			//	布局调整	
	Clean();				//	包含初始化查询条件
})
function InitEvent(){
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QuerySupplyList();});
	//表格 toolbar
	PHA_EVENT.Bind('#btnRePrint', 		'click', function () {RePrint();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
}
// 布局调整
function ResizePanel(){	
	setTimeout(function () {   
        PHA_COM.ResizePanel({
            layoutId: 'layout-op—condition',
            region: 'north',
            height: 0.5 
        });
    }, 0);
}
function InitDict(){
	 // 门诊科室
    PHA.ComboBox('phLocId',{
	    editable:false, 
    	url: PHAOP_STORE.PHLOC().url,
    	onLoadSuccess: function () {
	    	var datas = $("#phLocId").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == session['LOGON.CTLOCID']) {
                    $("#phLocId").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
    	}
    });
     // 基数药
    PHA.ComboBox('baseLocId',{
	    blurValidValue:true,
    	url: PHAOP_STORE.BaseLoc().url
    });
}
// 初始化查询条件
function InitDefVal(){
	$("#stDate").datebox("setValue",PHAOP_COM.DEFAULT.StDate) ;
	$("#endDate").datebox("setValue",'t') ;
	$("#stTime").timespinner("setValue","000000");
	$("#endTime").timespinner("setValue","235959");
	$("#phLocId").combobox("setValue",session['LOGON.CTLOCID']);
}
function InitGridSupplyList(){
	var normalCol=[[
		{ field: 'Tward', 			title: ('病区'), 			width: 120,		align: 'left', 		hidden: true},
		{ field: 'Tdocloc', 		title: ('基数科室'),		width: 150,		align: 'left'},
		{ field: 'Tsuppdate', 		title: ('日期'),	 		width: 120,		align: 'left'},
        { field: 'Tsupptime',		title: ('时间'),			width: 130,		align: 'left'},
		{ field: 'Tusername', 		title: ('操作人'),	 		width: 100,		align: 'left'},
		{ field: 'Tsuppno', 		title: ('单号'),	 		width: 250,		align: 'left'},
		{ field: 'Tsupp', 			title: ('补货单id'),	 	width: 80,		align: 'left', 		hidden: true},
	]]
	COMPOMENTS.ComomGrid("gridSupplyList",{
		columns: normalCol,
		toolbar : '#gridSupplyListBar',
		onSelect : function(rowIndex, rowData) {
			QuerySupplyDetail();
		},onLoadSuccess : function(data) {
			if(data.total>0){
				$('#gridSupplyList').datagrid("selectRow",0);
			}else{
				$('#gridSupplyDetail').datagrid('clear');
			}
		}
	})
}
function InitGridSupplyDetail(){
	var normalCol = [[
		{field: 'Tincicode',		title: ("药品代码"),		width: 100,		align: 'left'}, 
		{field: 'Tincidesc',		title: ("药品名称"),		width: 300,		align: 'left'}, 
		{field: 'Tqty',				title: ("发药数量"),		width: 125,		align: 'right'}, 
		{field: 'Tspec',			title: ("规格"),			width: 125,		align: 'left'}
	]];
	COMPOMENTS.ComomGrid("gridSupplyDetail",{
		columns: normalCol
	})
}
function GetParams(){
	var retJson = PHA.DomData("#qCondition",{doType: 'query',retType: 'Json'});
	if(retJson[0] == undefined) {return false;}
	var pJson = {};
	pJson = retJson[0];
	pJson.outFlag ="1";
	pJson.inFlag ="0";
	pJson.locId = PHAOP_COM.LogonData.LocId;
	
	return pJson;
}
// 查询处方列表
function QuerySupplyList(){
	var $grid =  $("#gridSupplyList");
	var pJson = GetParams();
	if(pJson==false){return;}
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Supply.Api' ,
        pMethodName:'GetSupplyList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 

}

// 查询处方明细
function QuerySupplyDetail(){	
	var $grid =  $("#gridSupplyDetail");
	var rowData = $("#gridSupplyList").datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "请选择基数补货单数据！");
		return false;
	}
	var pJson = {};
	pJson.suppStr = rowData.Tsupp;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.OP.Supply.Api' ,
        pMethodName:'GetSupplyDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
// 清屏
function Clean(){
	PHA.DomData("#qCondition",{doType: 'clear'});
	$('#gridSupplyList').datagrid('clear');
	$('#gridSupplyDetail').datagrid('clear');
	InitDefVal();
}


// 打印
function RePrint(){
	var $grid = $("#gridSupplyList");
	var rowData = $grid.datagrid('getSelected');
	if(rowData == null){
		PHAOP_COM._Msg('error', "请选择基数补货单数据！");
		return false;
	}
	var suppId = rowData.Tsupp;
	OP_PRINTCOM.PrintSupply(suppId);
}

