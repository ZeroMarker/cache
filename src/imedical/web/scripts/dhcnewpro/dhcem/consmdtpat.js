//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2018-07-18
// 描述:	   MDT病人列表
//===========================================================================================

/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人列表
	InitPatList();
	
	InitPatInfoPanel();
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(formatDate(0));
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(formatDate(0));
	
	/// Mdt科室
	$HUI.combobox("#MdtLoc",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsMdtPat&MethodName=jsonListMdtLoc&HospID=2",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        QryEmPatList();
	    }	
	})
	
	/// Mdt诊断
	$HUI.combobox("#MdtDiag",{
		url:LINK_CSP+"?ClassName=web.DHCEMDocMainOutPat&MethodName=jsonListWard&HospID=2",
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	        QryEmPatList();
	    }	
	})
	
	/// 登记号
	$("#PatNo").bind('keypress',PatNo_KeyPress);
	
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	
	///  定义columns
	var columns=[[
		{field:'PatNo',title:'登记号',width:120},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60,align:'center'},
		{field:'PatAge',title:'年龄',width:70,align:'center'},
		{field:'PAAdmDepCodeDR',title:'就诊科室',width:120},
		//{field:'PAAdmWard',title:'病区',width:120,align:'center'},
		//{field:'PAAdmBed',title:'床号',width:80,align:'center'}, 
		{field:'Diagnosis',title:'诊断',width:190},
		{field:'PAAdmDate',title:'就诊日期',width:120,align:'center'},
		{field:'BillType',title:'病人类型',width:80,align:'center'},
		{field:'PAAdmDocCodeDR',title:'医生',width:100,align:'center'},
		{field:'CareProv',title:'号别',width:100,align:'center'},
		{field:'CurStatus',title:'申请状态',width:100,align:'center'},
		{field:'EpisodeID',title:'EpisodeID',width:100,align:'center'}
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
	var param = "^"+ session['LOGON.CTLOCID'] +"^E";
	var uniturl = $URL+"?ClassName=web.DHCEMConsMdtPat&MethodName=JsQryConsMdtPatList&params="+param;
	new ListComponent('PatList', columns, uniturl, option).Init(); 
}

/// 登记号
function PatNo_KeyPress(e){

	if(e.keyCode == 13){
		var PatNo = $("#PatNo").val();
		if (!PatNo.replace(/[\d]/gi,"")&(PatNo != "")){
			///  登记号补0
			$("#PatNo").val(GetWholePatNo(PatNo));
		}
		QryPatList();  /// 查询
	}
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var PatNo = $("#PatNo").val();    /// 登记号
	var MdtLoc = $HUI.combobox("#MdtLoc").getValue();
	if (MdtLoc == ""){
		MdtLoc = session['LOGON.CTLOCID'];
	}
	var params = PatNo +"^"+ MdtLoc +"^E^"+ StartDate +"^"+ EndDate;
	$("#PatList").datagrid("load",{"params":params}); 
}

/// 填写MDT申请
function WriteMdt(){
	
	var rowsData = $("#PatList").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		OpenMdtConsWin();
		$("#newWinFrame").attr("src","dhcem.consultmdt.csp?EpisodeID="+rowsData.EpisodeID +"&ConsID="+ rowsData.ConsID);
	}else{
		$.messager.alert('提示','请选择要填写申请的记录！','warning');
		return;
	}
}

/// 打卡MDT填写页面
function OpenMdtConsWin(){
	
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	new WindowUX('MDT申请', 'MdtConsWin', '950', '550', option).Init();
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
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
