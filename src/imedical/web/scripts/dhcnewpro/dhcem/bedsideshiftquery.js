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
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var ItemTypeArr = [{"value":"早班","text":'早班'}, {"value":"中班","text":'中班'}, {"value":"夜班","text":'夜班'}];;

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始华参数
	InitComponents();  /// 初始化界面组件
	
	InitMainList();    /// 初始化交班列表
	InitDetList();     /// 初始化明细列表
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
	
	if (modeType == "T"){
		$(".panel-south").hide();
	}
	
	if (EmType == "Nur"){
		$("#MedGrp").next(".combo").hide();
		$("#MedGrpLabel").hide();
	}
}

/// 初始化加载交班列表
function InitMainList(){
	
	///  定义columns
	var columns=[[
		{field:'bsID',title:'bsID',width:100,hidden:true},
		{field:'bsDate',title:'交班日期',width:120},
		{field:'bsMedGrp',title:'医疗组',width:120},
		{field:'bsWard',title:'留观区',width:160},
		{field:'bsSchedule',title:'班次',width:120},
		{field:'bsUser',title:'交班人',width:120},
		{field:'bsAccUser',title:'接班人',width:120},
		{field:'bsCreateDate',title:'创建日期',width:120},
		{field:'bsCreateTime',title:'创建时间',width:120},
		{field:'bsPatNum',title:'交班人数',width:120,align:'center',formatter:
			function (value, row, index){
				return '<font style="color:red;font-weight:bold;">'+value+'</font>';
			}
		},
		{field:'bsStatus',title:'状态',width:120,align:'center',formatter:
			function (value, row, index){
				if (value == "N"){return '<font style="color:#ff3d2c;font-weight:700;">未完成</font>'}
				else {return '<font style="color:green;font-weight:700;">已完成</font>'}
			}
		}
	]];
	
	///  定义datagrid
	var option = {
		headerCls:'panel-header-gray',
		//title:'交班记录'+titleNote,
		//showHeader:false,
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
			}else{
				$("#bmDetList").datagrid("load",{"Params":0});
			}
			if (EmType == "Nur"){
				$("#bmMainList").datagrid('hideColumn','bsMedGrp');
			}
		},
        rowStyler:function(rowIndex, rowData){
			if(rowData.bsStatus != "Y"){
				return 'background-color:#fec0c0;';
			}
		}
	};
	/// 就诊类型
	var param = "^^^^^" + EmType;
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmShiftList&Params="+param;
	new ListComponent('bmMainList', columns, uniturl, option).Init(); 
}

/// 页面DataGrid初始定义已选列表
function InitDetList(){
	
	///  定义columns
	var columns=[[
		{field:'BsItmID',title:'BsItmID',width:100,hidden:true},
		{field:'PatBed',title:'床号',width:60},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatNo',title:'登记号',width:100},
		{field:'Log',title:'操作',width:70,align:'center',formatter:SetCellLogUrl},
		{field:'PatAge',title:'年龄',width:60},
		{field:'PatSex',title:'性别',width:50},
		{field:'ObsTime',title:'滞留时间',width:100},
		{field:'PAAdmDate',title:'就诊日期',width:100},
		{field:'PAAdmTime',title:'就诊时间',width:100},
		{field:'PatDiag',title:'诊断',width:320},
		{field:'BsBackground',title:'背景',width:320},
		{field:'BsAssessment',title:'评估',width:320},
		{field:'BsSuggest',title:'建议',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true
	};
	/// 就诊类型
	var param = "";
	var uniturl = $URL+"?ClassName=web.DHCEMBedSideShift&MethodName=GetEmShiftPatList&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 链接
function SetCellLogUrl(value, rowData, rowIndex){
	
	var html = "<a href='#' onclick='log("+ rowData.EpisodeID +")' style='display:block;width:38px;background:#7dba56;padding:3px 6px;color:#fff;border-radius: 4px 4px 4px 4px;'>日志</a>";
	return html;
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
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType+"^"+LgHospID; //hxy 2020-06-03
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// 打印
function print_click(){
		
	var rowsData = $("#bmMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示:","请先选择要打印的交班记录！","warning");
		return;
	}
	var jsonObjMain = "交班日期: " + rowsData.bsDate + "       医疗组: " + rowsData.bsMedGrp + "       留观区: " + rowsData.bsWard  + "       班次: " + rowsData.bsSchedule + "       交班人: " + rowsData.bsUser;
	window.open("dhcem.bedsideshiftprint.csp?BsID="+ rowsData.BsID +"&jsonObjMain="+ jsonObjMain);
	return;
}

/// 导出
function export_click(){
	
	var rowsData = $("#bmMainList").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null) {
		$.messager.alert("提示:","请先选择要导出的交班记录！","warning");
		return;
	}
	var jsonObjArr = rowsData;
	
	runClassMethod("web.DHCEMBedSideShift","GetExpEmShiftDetail",{"BsID":rowsData.BsID},function(jsonString){
		
		if (jsonString == null){
			$.messager.alert("提示:","导出异常！","warning");
		}else{
			var jsonItemArr = jsonString;
			Export_Xml(jsonObjArr, jsonItemArr);
		}
	},'json',false)	
}

/// 查看日志
function log(EpisodeID){
	
	if (!hasLog(EpisodeID)) return;  /// 病人是否有交班日志 
	
	commonShowWin({
		url:"dhcem.pattimeaxis.csp?PatientID=&EpisodeID="+ EpisodeID +"&EmType="+ EmType,
		title:"历次交班信息",
		height: (window.screen.availHeight - 180)	
	})
}

/// 导出交班记录
function Export_Xml(jsonObjArr, jsonItemArr){
	
	var title = "交班日期: " + jsonObjArr.bsDate + "       医疗组: " + jsonObjArr.bsMedGrp + "       留观区: " + jsonObjArr.bsWard  + "       班次: " + jsonObjArr.bsSchedule + "       交班人: " + jsonObjArr.bsUser;
	var str = '(function test(x){' +
		'var xlApp = new ActiveXObject("Excel.Application");'  +
		'var xlBook = xlApp.Workbooks.Add();' +
		'var objSheet = xlBook.ActiveSheet;' +
		
		'xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true;' + //合并单元格
		'xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,11)).MergeCells = true;' + //合并单元格
		'objSheet.Cells(1, 1).value = "急诊交班本";'+		 
   		'objSheet.Cells(2, 1).value = "' + title +'";' +
		'objSheet.Cells(3, 1).value = "床号";' +      /// 床号
		'objSheet.Cells(3, 2).value = "姓名";' +      /// 姓名
		'objSheet.Cells(3, 3).value = "登记号";' +    /// 登记号
		'objSheet.Cells(3, 4).value = "年龄";' +      /// 年龄
		'objSheet.Cells(3, 5).value = "性别";' +      /// 性别
		'objSheet.Cells(3, 6).value = "就诊时间";' +  /// 就诊日期
		'objSheet.Cells(3, 7).value = "滞留时间";' +  /// 滞留时间
		'objSheet.Cells(3, 8).value = "诊断";' +      /// 诊断
		'objSheet.Cells(3, 9).value = "背景";' +      /// 背景
		'objSheet.Cells(3, 10).value = "评估";' +     /// 评估
		'objSheet.Cells(3, 11).value = "建议";'       /// 建议
		str = str +setCellLine("",3,1,11);
		for (var i=0; i<jsonItemArr.length; i++){
			str = str +
			'objSheet.Cells('+ (4+ i) +', 1).value = "' +jsonItemArr[i].PatBed +'";' +      /// 床号
			'objSheet.Cells('+ (4+ i) +', 2).value = "' +jsonItemArr[i].PatName +'";' +     /// 姓名
			'objSheet.Cells('+ (4+ i) +', 3).NumberFormatLocal = "@";' +           /// 设置导出为文本
			'objSheet.Cells('+ (4+ i) +', 3).value = "' +jsonItemArr[i].PatNo +'";' +       /// 登记号
			'objSheet.Cells('+ (4+ i) +', 4).value = "' +jsonItemArr[i].PatAge +'";' +      /// 年龄
			'objSheet.Cells('+ (4+ i) +', 5).value = "' +jsonItemArr[i].PatSex +'";' +      /// 性别
			'objSheet.Cells('+ (4+ i) +', 6).NumberFormatLocal = "@";' +            /// 设置导出为文本
			'objSheet.Cells('+ (4+ i) +', 6).value = "' +jsonItemArr[i].PAAdmDate +" "+ jsonItemArr[i].PAAdmTime +'";' +   /// 就诊日期
			'objSheet.Cells('+ (4+ i) +', 7).value = "' +jsonItemArr[i].ObsTime +'";' +       /// 滞留时间
			'objSheet.Cells('+ (4+ i) +', 8).value = "' +jsonItemArr[i].PatDiag +'";' +       /// 诊断
			'objSheet.Cells('+ (4+ i) +', 9).value = "' +escape2Html(jsonItemArr[i].bsBackground) +'";' +  /// 背景
			'objSheet.Cells('+ (4+ i) +', 10).value = "' +escape2Html(jsonItemArr[i].bsAssessment) +'";'   /// 评估
			var bsSuggest = "";
			if (jsonItemArr[i].bsSuggest != ""){
				bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,"");
			}
			str = str +
			'objSheet.Cells('+ (4+ i) +', 11).value = "' + escape2Html(bsSuggest.replace(/(\n)/g, "")) +'";'   /// 建议
			str = str +setCellLine("",4+i,1,11);
		}
		str = str +
		"xlApp.Visible=true;" +
		'xlBook.SaveAs("急诊科交班本.xlsx");' +
		'xlApp=null;' +
		'objSheet=null;' +
		"return 1;}());";
	//以上为拼接Excel打印代码为字符串
    CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
	var rtn = CmdShell.EvalJs(str);   //通过中间件运行打印程序 
	return;
	
	/*	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add();
	var objSheet = xlBook.ActiveSheet;
	
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,11)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,11)).MergeCells = true; //合并单元格
	objSheet.Cells(1, 1).value = "急诊交班本";
	var title = "交班日期: " + jsonObjArr.bsDate + "       医疗组: " + jsonObjArr.bsMedGrp + "       留观区: " + jsonObjArr.bsWard  + "       班次: " + jsonObjArr.bsSchedule + "       交班人: " + jsonObjArr.bsUser;
	objSheet.Cells(2, 1).value = title;
	objSheet.Cells(3, 1).value = "床号";   /// 床号
	objSheet.Cells(3, 2).value = "姓名";   /// 姓名
	objSheet.Cells(3, 3).value = "登记号"; /// 登记号
	objSheet.Cells(3, 4).value = "年龄";   /// 年龄
	objSheet.Cells(3, 5).value = "性别";   /// 性别
	objSheet.Cells(3, 6).value = "就诊时间"; /// 就诊日期
	//objSheet.Cells(3, 7).value = "就诊时间"; /// 就诊时间
	objSheet.Cells(3, 7).value = "滞留时间"; /// 滞留时间
	objSheet.Cells(3, 8).value = "诊断";     /// 诊断
	objSheet.Cells(3, 9).value = "背景"; 	 /// 背景
	objSheet.Cells(3, 10).value = "评估"; 	 /// 评估
	objSheet.Cells(3, 11).value = "建议"; 	 /// 建议
		
	for (var i=0; i<jsonItemArr.length; i++){
		objSheet.Cells(4+i, 1).value = jsonItemArr[i].PatBed;      /// 床号
		objSheet.Cells(4+i, 2).value = jsonItemArr[i].PatName;     /// 姓名
		objSheet.Cells(4+i, 3).NumberFormatLocal = "@";//设置导出为文本
		objSheet.Cells(4+i, 3).value = jsonItemArr[i].PatNo;       /// 登记号
		objSheet.Cells(4+i, 4).value = jsonItemArr[i].PatAge;      /// 年龄
		objSheet.Cells(4+i, 5).value = jsonItemArr[i].PatSex;      /// 性别
		objSheet.Cells(4+i, 6).NumberFormatLocal = "@";//设置导出为文本
		objSheet.Cells(4+i, 6).value = jsonItemArr[i].PAAdmDate +" "+ jsonItemArr[i].PAAdmTime;   /// 就诊日期
		//objSheet.Cells(4+i, 7).value = jsonItemArr[i].PAAdmTime;   /// 就诊时间
		objSheet.Cells(4+i, 7).value = jsonItemArr[i].ObsTime;     /// 滞留时间
		objSheet.Cells(4+i, 8).value = jsonItemArr[i].PatDiag;     /// 诊断
		objSheet.Cells(4+i, 9).value = jsonItemArr[i].bsBackground; /// 背景
		objSheet.Cells(4+i, 10).value = jsonItemArr[i].bsAssessment; /// 评估
		var bsSuggest = "";
		if (jsonItemArr[i].bsSuggest != ""){
			bsSuggest = jsonItemArr[i].bsSuggest.replace(/<\/?[^>]*>/g,'')
		}
		objSheet.Cells(4+i, 11).value = bsSuggest;    /// 建议
		setCellLine(objSheet,4+i,1,11);
	}
	//objSheet.printout();
	objSheet.Application.Visible = true;
	xlBook.SaveAs("急诊科交班本.xlsx");
	xlApp=null;
	//xlBook.Close(savechanges=false);
	objSheet=null;
	*/	
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

/// 病人是否有交班日志 
function hasLog(EpisodeID){

	var hasFlag = false;
	runClassMethod("web.DHCEMBedSideShiftQuery","HasLog",{"EpisodeID":EpisodeID, "Type":EmType},function(jsonString){

		if (jsonString == 1){
			hasFlag = true;
		}else{
			$.messager.alert("提示:","该病人无交班日志！","warning");
		}
	},'',false)
	return hasFlag;
}

/// 自动设置页面布局
function onresize_handler(){
	
}

/// 页面全部加载完成之后调用(EasyUI解析完之后)
function onload_handler() {

	
	/// 自动设置页面布局
	onresize_handler();
}

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })