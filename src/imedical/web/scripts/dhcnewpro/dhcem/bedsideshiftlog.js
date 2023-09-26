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
	$HUI.combobox("#Schedule",{
		url:'',
		data : ItemTypeArr,
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
}

/// 初始化加载交班列表
function InitMainList(){
	
	///  定义columns
	var columns=[[
		{field:'bsID',title:'bsID',width:100,hidden:true},
		{field:'bsDate',title:'交班日期',width:120,align:'center'},
		{field:'bsMedGrp',title:'医疗组',width:120,align:'center'},
		{field:'bsWard',title:'留观区',width:160},
		{field:'bsSchedule',title:'班次',width:120,align:'center'},
		{field:'bsUser',title:'交班人',width:120,align:'center'},
		{field:'bsAccUser',title:'接班人',width:120,align:'center'},
		{field:'bsCreateDate',title:'创建日期',width:120,align:'center'},
		{field:'bsCreateTime',title:'创建时间',width:120,align:'center'},
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
		{field:'PatBed',title:'床号',width:60,align:'center'},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatAge',title:'年龄',width:60,align:'center'},
		{field:'PatSex',title:'性别',width:50,align:'center'},
		{field:'PAAdmDate',title:'就诊日期',width:100,align:'center'},
		{field:'PAAdmTime',title:'就诊时间',width:100,align:'center'},
		{field:'PatDiag',title:'诊断',width:320},
		{field:'BsVitalSign',title:'生命体征',width:320},
		{field:'BsContents',title:'交班内容',width:320},
		//{field:'WaitToHos',title:'待入院科室',width:300},
		{field:'BsMedHis',title:'病史',width:320},
		{field:'BsTreatMet',title:'治疗方式',width:120},
		{field:'BsCotNumber',title:'联系方式',width:120},
		{field:'BsNotes',title:'备注',width:320},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
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
	var params = StartDate +"^"+ EndDate +"^"+ WardID +"^"+ Schedule +"^"+ MedGrpID +"^"+ EmType;
	$("#bmMainList").datagrid("load",{"Params":params}); 
}

/// 打印
function print_click(){
	
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

/// 导出排班记录
function Export_Xml(jsonObjArr, jsonItemArr){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCEM_BedSideShift.xlsx";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(2, 2).value = jsonObjArr.MedGrp;    /// 医生分组
	objSheet.Cells(2, 4).value = jsonObjArr.Ward;      /// 留观区
	objSheet.Cells(2, 6).value = jsonObjArr.Schedule;  /// 班次
	objSheet.Cells(2, 8).value = "" // jsonObjArr.UserName;  //人数
	objSheet.Cells(2, 10).value = jsonObjArr.WrDate;    /// 交班日期
	objSheet.Cells(2, 12).value = jsonObjArr.UserName;  /// 交班人员
		
	for (var i=0; i<jsonItemArr.length; i++){
		objSheet.Cells(4+i, 1).value = jsonItemArr[i].PatBed;      /// 床号
		objSheet.Cells(4+i, 2).value = jsonItemArr[i].PatName;     /// 姓名
		objSheet.Cells(4+i, 3).value = jsonItemArr[i].PatNo;       /// 登记号
		objSheet.Cells(4+i, 4).value = jsonItemArr[i].PatAge;      /// 年龄
		objSheet.Cells(4+i, 5).value = jsonItemArr[i].PatSex;      /// 性别
		objSheet.Cells(4+i, 6).value = jsonItemArr[i].PAAdmDate;   /// 就诊日期
		objSheet.Cells(4+i, 7).value = jsonItemArr[i].PAAdmTime;   /// 就诊时间
		objSheet.Cells(4+i, 8).value = jsonItemArr[i].PatDiag;     /// 诊断
		objSheet.Cells(4+i, 9).value = jsonItemArr[i].BsVitalSign; /// 生命体征
		objSheet.Cells(4+i, 10).value = jsonItemArr[i].BsMedHis;   /// 病史
		objSheet.Cells(4+i, 11).value = jsonItemArr[i].BsTreatMet; /// 治疗方式
		objSheet.Cells(4+i, 12).value = jsonItemArr[i].BsContents; /// 交班内容
		//objSheet.Cells(4+i, 13).value = jsonItemArr[i].WaitToHos;  /// 待入院科室
		objSheet.Cells(4+i, 13).value = "" //jsonItemArr[i].WaitToHos;  ///天数
		objSheet.Cells(4+i, 14).value = jsonItemArr[i].BsCotNumber;/// 联系方式
		//objSheet.Cells(4+i, 12).value = jsonItemArr[i].BsNotes;    /// 备注
		setCellLine(objSheet,4+i,1,14);
	}
	//objSheet.printout();
	objSheet.Application.Visible = true;
	xlBook.SaveAs("交班明细.xlsx");
	xlApp=null;
	//xlBook.Close(savechanges=false);
	objSheet=null;	
}

/// 设置边框
function setCellLine(objSheet,row,startcol,colnum){
	
	for (var m=startcol;m<=colnum;m++){
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(10).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(9).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(8).LineStyle=1;
		objSheet.Range(objSheet.Cells(row, m), objSheet.Cells(row,m)).Borders(7).LineStyle=1;
	}
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

window.onload = onload_handler;
window.onresize = onresize_handler;

/// JQuery 初始化页面
$(function(){ initPageDefault(); })