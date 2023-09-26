//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-10-21
// 描述:	   评分查询JS
//===========================================================================================

var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID

/// 页面初始化函数
function initPageDefault(){
	
	InitParams();      /// 初始化参数
	InitDetList();     /// 初始化列表
}

/// 初始化页面参数
function InitParams(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
}

/// 页面DataGrid初始定义已选列表
function InitDetList(){
	
	///  定义columns
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true},
		//{field:'Type',title:'类型',width:120},
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:120},
		{field:'ScoreDesc',title:'评分表',width:320},
		{field:'ScoreVal',title:'分值',width:100,formatter:
			function (value, row, index){
				if (value != ""){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'User',title:'评分人',width:120,},
		{field:'Date',title:'评分日期',width:120},
		{field:'Time',title:'评分时间',width:120},
		{field:'Detail',title:'详情',width:120,align:'center',formatter:
			function (value, row, index){
				return '<a href="#" onclick="review(\''+ row.ID +'\',\''+ row.ScoreID +'\')">详情</a>';
			}
		}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
			
		},
		onDblClickRow: function (rowIndex, rowData) {

        }
	};
	/// 就诊类型
	var param = "^^^^"+LgHospID; //hxy 2020-06-09 ""
	var uniturl = $URL+"?ClassName=web.DHCEMCScoreQuery&MethodName=JsGetScore&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
}

/// 评分表预览
function review(ID, ScoreID){
	
	if (ScoreID == ""){
		$.messager.alert("提示:","表单为空！","warning");
		return;
	}
	var link = "dhcemc.scoretabreview.csp?ScoreID="+ ScoreID +"&ID=" + ID +"&EditFlag=0";
	window.open(link, '_blank', 'height='+ (window.screen.availHeight - 180) +', width=1200, top=50, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
}

/// 查询
function find_click(){

	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var PatNo = $("#PatNo").val();  /// 登记号
	var params = StartDate +"^"+ EndDate +"^"+ PatNo+"^^"+LgHospID; //hxy 2020-06-09 +"^^"+LgHospID
	$("#bmDetList").datagrid("load",{"Params":params});
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