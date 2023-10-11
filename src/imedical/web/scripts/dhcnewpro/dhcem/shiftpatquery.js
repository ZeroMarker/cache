//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-11-01
// 描述:	   交班日志JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";         /// ID
var modeType = "";      /// 打开方式
var EmType = "";        /// 医护类型
var pid = "";           /// 计数器
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"早班","text":'早班'}, {"value":"中班","text":'中班'}, {"value":"夜班","text":'夜班'}];;

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	
	InitMainList();    /// 初始化交班列表
}

/// 初始化页面参数
function InitParams(){
	
	modeType = getParam("Type");   /// 打开方式
	EmType = getParam("EmType");   /// 交班类型
}

/// 初始化界面组件
function InitComponents(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-1));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 医生分组
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevCom&MethodName=jsonCTMedUnit&LocID="+LgLocID;
	$HUI.combobox("#MedGrp",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 班次
	var uniturl = $URL+"?ClassName=web.DHCEMTimeInterval&MethodName=jsonTimeInterval&HospID="+ LgHospID +"&Module="+ EmType;
	$HUI.combobox("#Schedule",{
		url:uniturl,
		//data : ItemTypeArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 病区
	var uniturl = $URL+"?ClassName=web.DHCEMPatCheckLevQuery&MethodName=jsonWard&HospID="+LgHospID;
	$HUI.combobox("#Ward",{
		url:uniturl,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
	if (EmType == "Nur"){
		$("#MedGrp").next(".combo").hide();
		$("#MedGrpLabel").hide();
	}
}

/// 初始化加载交班列表
function InitMainList(){
	
	///  定义columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'Log',title:'操作',width:70,align:'center',formatter:SetCellLogUrl},
		{field:'bsDate',title:'交班日期',width:120},
		{field:'PatBed',title:'床号',width:60},
		{field:'Type',title:'类型',width:80,styler:setCellType},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'bsSchedule',title:'班次',width:120},
		{field:'bsUser',title:'交班人',width:120},
		{field:'bsAccUser',title:'接班人',width:120},
		{field:'bsBackground',title:'背景',width:320},
		{field:'bsAssessment',title:'评估',width:320},
		{field:'bsSuggest',title:'建议',width:320},
	]];
	
	///  定义datagrid
	var option = {
		headerCls:'panel-header-gray',
		title:'',
		toolbar:'#toolbar',
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onClickRow:function(rowIndex, rowData){
			$("#bmDetList").datagrid("load",{"Params":rowData.BsID});
		},
		onDblClickRow:function(rowIndex, rowData){
			parent.GetEmShift(rowData.BsID);
			parent.commonCloseWin();
		},
		onLoadSuccess:function(data){
			if (typeof data.rows[0] != "undefined"){
				$("#bmDetList").datagrid("load",{"Params":data.rows[0].BsID});
				pid = data.rows[0].pid;
			}else{
				$("#bmDetList").datagrid("load",{"Params":0});
			}
		},
        rowStyler:function(rowIndex, rowData){
//			if(rowData.bsStatus != "Y"){
//				return 'background-color:#fec0c0;';
//			}
		}
	};
	/// 就诊类型
	var param = "^^^^^" + EmType +"^"+ pid+"^^"+LgHospID; //hxy 2020-06-05 +"^^"+LgHospID
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShiftQuery&MethodName=GetEmPatShiftHis&Params="+param;
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// 类型
function setCellType(value, row, index){
	
	if (value == "红区"){
		return 'background-color:#F16E57;color:white';
	}else if (value == "黄区"){
		return 'background-color:#FFB746;color:white';
	}else if (value == "绿区"){
		return 'background-color:#2AB66A;color:white';
	}else if (value == "蓝色"){
		return 'background-color:#449be2;color:white';
	}else{
		return '';
	}
}

/// 链接
function SetCellLogUrl(value, rowData, rowIndex){
	
	var html = "<a href='#' onclick='log("+ rowData.EpisodeID +")' style='display:block;width:38px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>"+$g("日志")+"</a>";
	return html;
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		find_click();  /// 查询
	}
}

///补0病人登记号
function GetWholePatNo(EmPatNo){

	///  判断登记号是否为空
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  登记号长度值
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('错误提示',"登记号输入错误！");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;

}

/// 查询
function find_click(){

	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var MedGrpID = $HUI.combobox("#MedGrp").getValue();    /// 医疗组
	if (typeof MedGrpID == "undefined") MedGrpID = "";
	var WardID = $HUI.combobox("#Ward").getValue();        /// 留观区
	if (typeof WardID == "undefined") WardID = "";
	var Schedule = $HUI.combobox("#Schedule").getValue();  /// 班次
	if (typeof Schedule == "undefined") Schedule = "";
	var PatNo = $("#PatNo").val();    /// 登记号
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType +"^"+ pid +"^"+ PatNo+"^"+LgHospID; //hxy 2020-06-05
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// 打印
function print_click(){
	
}

/// 导出
function export_click(){
	
	if (pid == "") {
		$.messager.alert("提示:","数据为空，无法导出！","warning");
		return;
	}
	
	runClassMethod("web.DHCEMBedSideShiftQuery","GetPrintDetail",{"pid":pid},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","导出异常！","warning");
		}else{
			var jsonObjArr = jsonString;
			Export_Xml(jsonObjArr);
		}
	},'json',false)	
}

/// 查看日志
function log(EpisodeID){
	var link="dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType="+ EmType;
	if ('undefined'!==typeof websys_getMWToken){
		link += "&MWToken="+websys_getMWToken();
	}
	commonShowWin({
		url:link,
		title:"历次交班信息",
		height: (window.screen.availHeight - 180)	
	})
}

/// 导出排班记录
function Export_Xml(jsonObjArr){

	var str = '(function test(x){' +
		'var xlApp = new ActiveXObject("Excel.Application");'  +
		'var xlBook = xlApp.Workbooks.Add();' +
		'var objSheet = xlBook.ActiveSheet;' +
		
		'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true;' + //合并单元格
		'objSheet.Cells(1, 1).value = "'+$g("急诊交班病人列表")+'";'+		 
		'objSheet.Cells(2, 1).value = "'+$g("交班日期")+'";' +  /// 交班日期
		'objSheet.Cells(2, 2).value = "'+$g("床号")+'";' +      /// 床号
		'objSheet.Cells(2, 3).value = "'+$g("姓名")+'";' +      /// 姓名
		'objSheet.Cells(2, 4).value = "'+$g("班次")+'";' +      /// 班次
		'objSheet.Cells(2, 5).value = "'+$g("交班人")+'";' +    /// 交班人
		'objSheet.Cells(2, 6).value = "'+$g("接班人")+'";' +    /// 接班人
		'objSheet.Cells(2, 7).value = "'+$g("背景")+'";' +      /// 背景
		'objSheet.Cells(2, 8).value = "'+$g("评估")+'";' +      /// 评估
		'objSheet.Cells(2, 9).value = "'+$g("建议")+'";'        /// 建议
		str = str +setCellLine("",2,1,9);
		for (var i=0; i<jsonObjArr.length; i++){
			str = str +
			'objSheet.Cells('+ (3+ i) +', 1).NumberFormatLocal = "@";' +           /// 设置导出为文本
			'objSheet.Cells('+ (3+ i) +', 1).value = "' +jsonObjArr[i].bsDate +'";' +      /// 交班日期
			'objSheet.Cells('+ (3+ i) +', 2).value = "' +jsonObjArr[i].PatBed +'";' +      /// 床号
			'objSheet.Cells('+ (3+ i) +', 3).value = "' +jsonObjArr[i].PatName +'";' +     /// 姓名
			'objSheet.Cells('+ (3+ i) +', 4).value = "' +jsonObjArr[i].bsSchedule +'";' +  /// 班次
			'objSheet.Cells('+ (3+ i) +', 5).value = "' +jsonObjArr[i].bsUser +'";' +      /// 交班人
			'objSheet.Cells('+ (3+ i) +', 6).value = "' +jsonObjArr[i].bsAccUser +'";' +   /// 接班人
			'objSheet.Cells('+ (3+ i) +', 7).value = "' +escape2Html(jsonObjArr[i].bsBackground) +'";' +    /// 背景
			'objSheet.Cells('+ (3+ i) +', 8).value = "' +escape2Html(jsonObjArr[i].bsAssessment) +'";'      /// 评估
			var bsSuggest = "";
			if (jsonObjArr[i].bsSuggest != ""){
				bsSuggest = jsonObjArr[i].bsSuggest.replace(/<\/?[^>]*>/g,"");
			}
			str = str +
			'objSheet.Cells('+ (3+ i) +', 9).value = "' + escape2Html(bsSuggest.replace(/(\n)/g, "")) +'";'   /// 建议
			str = str +setCellLine("",3+i,1,9);
		}
		str = str +
		"xlApp.Visible=true;" +
		'xlBook.SaveAs("'+$g("交班个人明细")+'.xlsx");' +
		'xlApp=null;' +
		'objSheet=null;' +
		"return 1;}());";
	//以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.CurrentUserEvalJs(str);   //通过中间件运行打印程序 
	return;
		
//	var xlApp = new ActiveXObject("Excel.Application");
//	var xlBook = xlApp.Workbooks.Add();
//	var objSheet = xlBook.ActiveSheet;
//	
//	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true; //合并单元格
//	objSheet.Cells(1, 1).value = "急诊交班病人列表";
//	
//	objSheet.Cells(2, 1).value = "交班日期";  /// 交班日期
//	objSheet.Cells(2, 2).value = "床号";      /// 床号
//	objSheet.Cells(2, 3).value = "姓名";      /// 姓名
//	objSheet.Cells(2, 4).value = "班次";  	/// 班次
//	objSheet.Cells(2, 5).value = "交班人";    /// 交班人
//	objSheet.Cells(2, 6).value = "接班人";    /// 接班人
//	objSheet.Cells(2, 7).value = "背景"       /// 背景
//	objSheet.Cells(2, 8).value = "评估";      /// 评估
//	objSheet.Cells(2, 9).value = "建议";      /// 建议
//	
//	for (var i=0; i<jsonObjArr.length; i++){
//		objSheet.Cells(3+i, 1).NumberFormatLocal = "@";//设置导出为文本
//		objSheet.Cells(3+i, 1).value = jsonObjArr[i].bsDate;      /// 交班日期
//		objSheet.Cells(3+i, 2).value = jsonObjArr[i].PatBed;      /// 床号
//		objSheet.Cells(3+i, 3).value = jsonObjArr[i].PatName;     /// 姓名
//		objSheet.Cells(3+i, 4).value = jsonObjArr[i].bsSchedule;  /// 班次
//		objSheet.Cells(3+i, 5).value = jsonObjArr[i].bsUser;      /// 交班人
//		objSheet.Cells(3+i, 6).value = jsonObjArr[i].bsAccUser;   /// 接班人
//		objSheet.Cells(3+i, 7).value = jsonObjArr[i].bsBackground;  /// 背景
//		objSheet.Cells(3+i, 8).value = jsonObjArr[i].bsAssessment;  /// 评估
//		var bsSuggest = "";
//		if (jsonObjArr[i].bsSuggest != ""){
//			bsSuggest = jsonObjArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
//		}
//		objSheet.Cells(3+i, 9).value = bsSuggest;     /// 建议
//		setCellLine(objSheet,3+i,1,9);
//	}
//	//objSheet.printout();
//	objSheet.Application.Visible = true;
//	xlBook.SaveAs("交班个人明细.xlsx");
//	xlApp=null;
//	//xlBook.Close(savechanges=false);
//	objSheet=null;	
}

/// 设置边框
function setCellLine(objSheet,row,startcol,colnum){

	var mstr = "";
	for (var m=startcol;m<=colnum;m++){
		mstr = mstr +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(10).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(9).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(8).LineStyle=1;' +
		'objSheet.Range(objSheet.Cells('+ row +','+ m +'), objSheet.Cells('+ row +','+ m +')).Borders(7).LineStyle=1;'
	}
	return mstr;
		
//	for (var m=startcol;m<=colnum;m++){
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(10).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(9).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(8).LineStyle=1;
//		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(7).LineStyle=1;
//	}
}

//转意符换成普通字符
function escape2Html(str) {
	
	str = str.trim().replace("\n", String.valueOf(10));
	str = str.replace(/\s/g," ");
	var arrEntities={'lt':'<','gt':'>','nbsp':' ','amp':'&','quot':'"'}; 
	return str.replace(/&(lt|gt|nbsp|amp|quot);/ig,function(all,t){return arrEntities[t];}); 
}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}


/// 删除临时global
function killTmpGlobal(){

	runClassMethod("web.DHCEMBedSideShiftQuery","killTmpGlobal",{"pid":pid},function(jsonString){
	},'',false)
}

/// 页面关闭之前调用
function onbeforeunload_handler() {
    killTmpGlobal();  /// 清除临时global
}

window.onload = onload_handler;
window.onresize = onresize_handler;
window.onbeforeunload = onbeforeunload_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
