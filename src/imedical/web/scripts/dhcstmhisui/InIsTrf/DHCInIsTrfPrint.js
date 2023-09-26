function PrintInIsTrf(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrf(Init, AutoFlag);
	}else{
		RQPrintInIsTrf(Init, AutoFlag);
	}
}

function PrintInIsTrfHVCol(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfHVCol(Init, AutoFlag);
	}else{
		RQPrintInIsTrfHVCol(Init, AutoFlag);
	}
}

function PrintInIsTrfReturn(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfReturn(Init, AutoFlag);
	}else{
		RQPrintInIsTrfReturn(Init, AutoFlag);
	}
}

function PrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if(PrintMethod==0){
		LodopPrintInIsTrfReturnHVCol(Init, AutoFlag);
	}else{
		RQPrintInIsTrfReturnHVCol(Init, AutoFlag);
	}
}


//出库单Lodop打印
function LodopPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetDetailDataInIs(Init,"T"); //明细信息
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var InitAckUser=MainObj.InitAckUserName;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="出库单打印";  //打印任务名称
	//标题信息
	var Title=FrLocDesc+"出库单"; 
	//页眉信息
	var Head="接收科室:"+ToLocDesc+"      "
			+"出库单号:"+InitNo+"      "
			+"制单日期:"+PrintDate;
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"制单:"+InitUser+"          "
			+"审核:"+InitAckUser+"          "
			+"接收:"+InitReqUser;
	//明细信息展示
	var Cols=[
	{field:"Num",title:"序号",width:"25px",align:"center"},
	{field:"InciCode",title:"物资代码",width:"10%",align:"left"},
	{field:"InciDesc",title:"物资名称",width:"13%",align:"left"},
	{field:"Spec",title:"规格",width:"7%",align:"left"},
	{field:"SterilizedBat",title:"灭菌批号",width:"10%",align:"left"},
	{field:"UomDesc",title:"单位",width:"5%",align:"left"},
	{field:"Qty",title:"数量",width:"5%",align:"right",format:"#,##0.00"},
	{field:"BatExp",title:"批号~效期",width:"15%",align:"left"},
	{field:"Rp",title:"进价",width:"7%",align:"right",format:"#,##0.00"},
	{field:"RpAmt",title:"进价金额",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
	{field:"SpecDesc",title:"具体规格",width:"10%",align:"left"},
	{field:"ManfDesc",title:"厂商",width:"10%",align:"left"}
//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
	];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//高值出库单Lodop打印
function LodopPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//标志和次数处理
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetHVColDetailData(Init,"T"); //明细信息
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var InitAckUser=MainObj.InitAckUserName;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="高值出库单打印";  //打印任务名称
	//标题信息
	var Title=FrLocDesc+"出库单"; 
	//页眉信息
	var Head="接收科室:"+ToLocDesc+"      "
			+"出库单号:"+InitNo+"      "
			+"制单日期:"+PrintDate;
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"制单:"+InitUser+"          "
			+"审核:"+InitAckUser+"          "
			+"接收:"+InitReqUser;
	//明细信息展示
	var Cols=[
		{field:"Num",title:"序号",width:"25px",align:"center"},
		{field:"InciCode",title:"物资代码",width:"10%",align:"left"},
		{field:"InciDesc",title:"物资名称",width:"13%",align:"left"},
		{field:"Spec",title:"规格",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"灭菌批号",width:"10%",align:"left"},
		{field:"UomDesc",title:"单位",width:"5%",align:"left"},
		{field:"Qty",title:"数量",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"批号~效期",width:"15%",align:"left"},
		{field:"Rp",title:"进价",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"进价金额",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"具体规格",width:"10%",align:"left"},
		{field:"ManfDesc",title:"厂商",width:"10%",align:"left"}
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//退库单Lodop打印
function LodopPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetDetailDataInIs(Init,"K"); //明细信息
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="退库单打印";  //打印任务名称
	//标题信息
	var Title=ToLocDesc+"退库单"; 
	//页眉信息
	var Head="退库科室:"+FrLocDesc+"      "
			+"退库单号:"+InitNo+"      "
			+"制单日期:"+PrintDate;
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"库管:"+"          "
			+"退库人:"+"          "
			+"制单人:"+InitUser;
	//明细信息展示
	var Cols=[
		{field:"Num",title:"序号",width:"25px",align:"center"},
		{field:"InciCode",title:"物资代码",width:"10%",align:"left"},
		{field:"InciDesc",title:"物资名称",width:"13%",align:"left"},
		{field:"Spec",title:"规格",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"灭菌批号",width:"10%",align:"left"},
		{field:"UomDesc",title:"单位",width:"5%",align:"left"},
		{field:"Qty",title:"数量",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"批号~效期",width:"15%",align:"left"},
		{field:"Rp",title:"进价",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"进价金额",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"具体规格",width:"10%",align:"left"},
		{field:"ManfDesc",title:"厂商",width:"10%",align:"left"}
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}
//高值退库单Lodop打印
function LodopPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	//获取打印次数，是否预览打印，处理打印标志和次数
	var PrintNum = parseInt(InitParamObj.PrintNum);
	var IndirPrint = InitParamObj.IndirPrint;
	//标志和次数处理
	if (isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	Common_PrintLog('T', Init, AutoFlag, PrintNum);
	var MainObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var DetailData=GetHVColDetailData(Init,"K"); //明细信息
	var FrLocDesc=MainObj.InitFrLoc.Description;
	var ToLocDesc=MainObj.InitToLoc.Description;
	var InitNo=MainObj.InitNo;
	var InitReqUser=MainObj.InitReqUser.Description;
	var InitDate=MainObj.InitDate;
	var InitUser=MainObj.InitUser.Description;
	var PrintDate=DateFormatter(new Date());
	//主单信息展示
	var TaskName="高值退库单打印";  //打印任务名称
	//标题信息
	var Title=ToLocDesc+"退库单"; 
	//页眉信息
	var Head="退库科室:"+FrLocDesc+"      "
			+"退库单号:"+InitNo+"      "
			+"制单日期:"+PrintDate;
	//页尾信息
	var Foot="打印日期:"+PrintDate+"          "
			+"库管:"+"          "
			+"退库人:"+"          "
			+"制单人:"+InitUser;
	//明细信息展示
	var Cols=[
		{field:"Num",title:"序号",width:"25px",align:"center"},
		{field:"InciCode",title:"物资代码",width:"10%",align:"left"},
		{field:"InciDesc",title:"物资名称",width:"13%",align:"left"},
		{field:"Spec",title:"规格",width:"7%",align:"left"},
		{field:"SterilizedBat",title:"灭菌批号",width:"10%",align:"left"},
		{field:"UomDesc",title:"单位",width:"5%",align:"left"},
		{field:"Qty",title:"数量",width:"5%",align:"right",format:"#,##0.00"},
		{field:"BatExp",title:"批号~效期",width:"15%",align:"left"},
		{field:"Rp",title:"进价",width:"7%",align:"right",format:"#,##0.00"},
		{field:"RpAmt",title:"进价金额",width:"10%",align:"right",format:"#,##0.00",sum:"Y"},
		{field:"SpecDesc",title:"具体规格",width:"10%",align:"left"},
		{field:"ManfDesc",title:"厂商",width:"10%",align:"left"}
	//	{field:"Sp",title:"售价",width:"100px",align:"right",format:"#,##0.00"},
	//	{field:"SpAmt",title:"售价金额",width:"100px",align:"right",format:"#,##0.00",sum:"Y"}
		];
	PrintDocument(PrintNum,IndirPrint,TaskName,Title,Head,Foot,Cols,DetailData)
}

function GetDetailDataInIs(Init,InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({Init:Init,InitType:InitType});
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'DHCINIsTrfD',
		Params: Params,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function GetHVColDetailData(Init,InitType) {
	if (isEmpty(Init)) {
		return;
	}
	var Params = JSON.stringify({Init:Init,InitType:InitType});
	var jsonData = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
		QueryName: 'QueryHVColDetail',
		Params: Params,
		rows:99999
	},false);
	var DetailData=jsonData.rows;
	return DetailData;
}

function RQPrintInIsTrf(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var InitObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var FrLocId = InitObj['InitFrLoc']['RowId'];
	var ScgId = InitObj['ScgId'];
	if(isEmpty(FrLocId)){
		return;
	}
	var PrintMode = GetPrintMode(FrLocId, ScgId);
	var RaqName = 'DHCSTM_HUI_InIsTrf_Common.raq';
	if(PrintMode == 'MO'){
		RaqName = 'DHCSTM_HUI_InIsTrf_MO_Common.raq';
	}
	///var Params = JSON.stringify({Init:Init});
	var Params="";
	var RQInitStr = Init;
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
	//打印标签
	//PrintItmLabel(Init);
}

/*
 * 打印高值汇总
 */
function RQPrintInIsTrfHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var RaqName = 'DHCSTM_HUI_InIsTrfHVCol_Common.raq';
	//var Params = JSON.stringify({Init:Init});
	var Params = "";
	var RQInitStr = Init;
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

/*
 * 打印退库单
 */
function RQPrintInIsTrfReturn(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var InitObj = $.cm({
		ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
		MethodName: 'Select',
		Init: Init
	},false);
	var ToLocId = InitObj['InitToLoc']['RowId'];
	var ScgId = InitObj['ScgId'];
	if(isEmpty(ToLocId)){
		return;
	}
	var PrintMode = GetPrintMode(ToLocId, ScgId);
	var RaqName = 'DHCSTM_HUI_InIsTrfRet_Common.raq';
	if(PrintMode == 'MO'){
		RaqName = 'DHCSTM_HUI_InIsTrfRet_MO_Common.raq';
	}
	//var Params = JSON.stringify({Init:Init, InitType:'K'});
	var Params = ""; 
	var RQInitStr = Init+"^K";
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init +';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}

/*
 * 打印退库单(高值汇总)
 */
function RQPrintInIsTrfReturnHVCol(Init, AutoFlag) {
	if (Init == null || Init == '') {
		return;
	}
	AutoFlag = typeof(AutoFlag)=='undefined'? 'N' : AutoFlag;
	var RaqName = 'DHCSTM_HUI_InIsTrfRetHVCol_Common.raq';
	//var Params = JSON.stringify({Init:Init, InitType:'K'});
	var Params = "";
	var RQInitStr = Init+"^K";
	var DirectPrintStr = '{' + RaqName + '(Params=' + Params + ';Init=' + Init + ';RQInitStr=' + RQInitStr + ')}';
	var PrintNum = parseInt(InitParamObj.PrintNum);
	if (!isNumber(PrintNum) || (PrintNum <= 0)) {
		PrintNum = 1;
	}
	var RQPrintStr = TranslateRQStr(DirectPrintStr);
	for (var i = 1; i <= PrintNum; i++) {
		if (InitParamObj.IndirPrint != 'N') {
			DHCSTM_DHCCPM_RQPrint(RQPrintStr);
		} else {
			DHCCPM_RQDirectPrint(DirectPrintStr);
		}
		Common_PrintLog('T', Init, AutoFlag);
	}
}
