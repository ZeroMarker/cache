/// author:    xiaowenwu
/// date:      2020-03-06
/// descript:  待反馈列表
var CstID=""  //会诊ID
var PatientID=""  //病人ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID;
/// 页面初始化函数
function initPageDefault(){
	
	InitPatEpisodeID();       /// 初始化加载病人就诊ID

	///初始化combobox下拉框
	initCombobox();
	
	//初始化交班明细列表
	InitlogDetailsList();
	
	///初始化字典属性列表
	InitDetailList();
	
	initBTN();
	
	$("#bt_DocFol").hide();  /// 主管医生随访
	$("#bt_expopi").hide();  /// 专家意见
	

	search(); 				  /// 默认查询
	//InitTime();
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){

    CstID = getParam("CstID");              /// 会诊ID
    //PatientID=getParam("PatientID");    	/// 病人ID
	
}


///初始化combobox下拉框
function initCombobox(){
	

}

/// 获取系统当前日期
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCMDTCom","GetCurSysTime",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}

///初始化字典项目列表
function InitlogDetailsList(){
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'MCDate',title:'日期',width:150,align:'center'},
		{field:'MDDiseases',title:'病种',width:150,align:'center'},
		{field:'isFeedback',title:'是否反馈',width:90,align:'center'},
		{field:'FreebackNum',title:'反馈次数',width:90,align:'center',hidden:true},
		{field:'MCLocDr',title:'科室',width:120,align:'center'},
		{field:'PatNo',title:'登记号',width:120,align:'center'},
		{field:'PatName',title:'姓名',width:120,align:'center'},
		{field:'PatSex',title:'姓别',width:80,align:'center'},
		{field:'PatBed',title:'床号',width:80,align:'center'},
		{field:'MedicareNo',title:'住院号',width:120,align:'center'},
		{field:'CstRTime',title:'申请会诊时间',width:150,align:'center'},
		{field:'CstRUser',title:'申请人',width:80,align:'center'},
		{field:'ID',title:'ID',width:100,hidden:false,align:'center'},
		{field:'CstID',title:'CstID',width:100,hidden:true},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true}
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'MDT反馈内容',
		//nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		toolbar:[],
		border:false,

        onClickRow:function(rowIndex, rowData){
	        $("#folText").text(rowData.FolText);
	        /// 会诊专家回复内容列表
			$("#replyContent").datagrid('reload',{mID:rowData.ID});
			//setWaitFromData(rowData);
	    },
	    onLoadSuccess:function(data){
			if(data.rows.length){
				$('#logDetails').datagrid("selectRow",0);
				$("#replyContent").datagrid('reload',{mID:data.rows[0].ID});	
			}
			return;
		}
	    
	};
	var param = getParams();
	var uniturl = $URL+"?ClassName=web.DHCMDTWaitingListNew&MethodName=QryFolUpDetail&Params="+param+"&MWToken="+websys_getMWToken();
	new ListComponent('logDetails', columns, uniturl, option).Init();

}

//判断当前用户
function setWaitFromData(rowData){
	var CstID = rowData.CstID;
	var IsPerFlag=GetIsPerFlag(CstID)
	if(IsPerFlag==1){
		$("#bt_DocFol").show();  /// 主管医生随访
		$("#bt_expopi").hide();  /// 专家意见	
	}
	if(IsPerFlag==2){
		$("#bt_DocFol").hide();  /// 主管医生随访
		$("#bt_expopi").show();  /// 专家意见	
	}
	
	
}

///初始化属性列表
function InitDetailList(){
	
	
	/**
	 * 定义columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,align:'center',hidden:true},
		{field:'mID',title:'mID',width:100,align:'center',hidden:true},
		{field:'DocID',title:'专家',width:100,align:'center'},
		{field:'Advice',title:'建议',width:500,align:'left'},
	]];
	
	/**
	 * 定义datagrid
	 */
	var option = {
		title:'专家回复内容',
		nowrap:false,
		headerCls:'panel-header-gray',
		singleSelect : true,
		iconCls:'icon-paper',
		toolbar:[],
		border:false,

	};
	
	var uniturl = $URL+"?ClassName=web.DHCMDTWaitingListNew&MethodName=QryReplyContent&mID=0"+"&MWToken="+websys_getMWToken();
	new ListComponent('replyContent', columns, uniturl, option).Init();
}

//初始化按钮事件	
function initBTN(){
	$("#searchBtn").on('click',function(){search();})
}


 /// 初始化执行时间
/*function InitTime(){
	
	runClassMethod("web.DHCEMNurExe","GetSystemTime",{},function(jsonObject){
		if (jsonObject != null){
			$HUI.datebox("#startDate").setValue(jsonObject["SystemDate"]); /// 执行日期
			$("#endDate").val(jsonObject["SystemTime"]); /// 执行时间
		}
	},'json',false)
}
 */
function search(){
	var params = getParams();
	$("#logDetails").datagrid("load",{"params":params}); 
}

function getParams(){
	return CstID;
	var params="";
	var	startDate=$HUI.datebox("#startDate").getValue();	//开始日期
    var endDate=$HUI.datebox("#endDate").getValue();		//结束日期
    var Diseases=$HUI.combobox("#Diseases").getValue();		//疑难病种
    params = startDate +"^"+ endDate +"^"+Diseases+"^"+CstID;
	return params;	
}

//主管医生随访
function  DocFolWin(){
	
	
	var rowData = $('#logDetails').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var CstID=rowData.CstID
	var MCDate=rowData.MCDate
	if(GetIsFloVis(CstID,MCDate)!=1){
		$.messager.alert("提示:","当前待反馈记录，不允许进行MDT反馈操作！","warning");
		return;
	}
		
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择待反馈记录后重试！","warning");
		return;
	}
	
	var mradm = "";
	var link = "dhcmdt.folupmain.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&ID="+rowData.CstID+"&McID="+rowData.ID+"&MWToken="+websys_getMWToken();
	//window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	commonShowWin({
		url: link,
		title: $g("MDT反馈"),
		width: 1300,
		height: 600
	})
}

//专家意见
function  ExpertOp(){
	var rowData = $('#logDetails').datagrid('getSelected');
	if (rowData == null){
		$.messager.alert('提示',"请先选择一行记录!","error");
		return;
	}
	
	var EpisodeID = rowData.EpisodeID; ///rowData.AppAdmID;
	var PatientID = rowData.PatientID;
	if (EpisodeID == ""){
		$.messager.alert("提示:","请选择会诊记录后重试！","warning");
		return;
	}
	var mradm = "";
	var link = "dhcmdt.replymain.csp?PatientID="+ PatientID +"&EpisodeID="+ EpisodeID +"&mradm="+ mradm +"&ID="+rowData.CstID+"&McID="+rowData.ID+"&MWToken="+websys_getMWToken();
	//window.open(link, 'newWin', 'height='+ (window.screen.availHeight-100) +', width='+ (window.screen.availWidth-100) +', top=50, left=50, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no');
	commonShowWin({
		url: link,
		title: $g("专家意见"),
		width: 1300,
		height: 600
	})
}


/// 当前用户权限
function GetIsPerFlag(CstID){

	var IsPerFlag = ""; /// 是否允许修改
	runClassMethod("web.DHCMDTFolUpVis","GetIsPerFlag",{"CstID":CstID,"LgParam":LgParam},function(jsonString){
		if (jsonString != ""){
			IsPerFlag = jsonString;
		}
	},'',false)
	return IsPerFlag
}

//当前记录是否可以反馈
function GetIsFloVis(CstID,MCDate){
	var IsFloVis = ""; /// 是否允许反馈
	runClassMethod("web.DHCMDTFolUpVis","GetIsFloVis",{"CstID":CstID,"McDate":MCDate},function(jsonString){
		if (jsonString != ""){
			IsFloVis = jsonString;
		}
	},'',false)
	return IsFloVis
	
}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
