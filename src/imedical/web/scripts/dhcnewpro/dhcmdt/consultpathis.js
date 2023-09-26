//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-04-19
// 描述:	   mdt会诊处理
//===========================================================================================
var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mdtID = "";         /// 会诊申请ID
var editSelRow = -1;
var isEditFlag = 0;     /// 页面是否可编辑
var CstOutFlag = "N";   /// 院际会诊标志
var CsNoType = "";      /// 会诊单据类型 医生/护士/MDT
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var TimesArr = [{"value":"1","text":'1'}, {"value":"2","text":'2'}, {"value":"3","text":'3'}, {"value":"4","text":'4'}, {"value":"5","text":'5'}
                 , {"value":"6","text":'6'}, {"value":"7","text":'7'}, {"value":"8","text":'8'}, {"value":"9","text":'9'}, {"value":"10","text":'10'}];
var LODOP="";
var del = String.fromCharCode(2);

/// 页面初始化函数
function initPageDefault(){
	
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	/// 初始化加载病人列表
	InitPatList();
	
	/// 初始化病人基本信息
	InitPatInfoPanel();
	
	QryPatList();
	
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");
	
}

/// 初始化病人基本信息
function InitPatInfoPanel(){
	
	/// 开始日期
	$HUI.datebox("#StartDate").setValue(GetCurSystemDate(-30));
	
	/// 结束日期
	$HUI.datebox("#EndDate").setValue(GetCurSystemDate(0));
	
	/// 申请科室
	$HUI.combobox("#CstRLoc",{
		url:$URL+"?ClassName=web.DHCMDTCom&MethodName=JsonGrpLoc",
		valueField:'value',
		textField:'text',
		mode:'remote',
		onSelect:function(option){
	        //QryEmPatList();
	    }	
	})
	/// 疑难病种
	$HUI.combobox("#mdtDisGrp",{
		url:$URL+"?ClassName=web.DHCMDTGroup&MethodName=jsonGroupAll&HospID="+ LgHospID,
		valueField:'value',
		textField:'text',
		onSelect:function(option){

	    }	
	})	
	
	$HUI.combobox("#TimesArr",{
		url:'',
		data : TimesArr,
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	    }	
	})
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	var columns=[[
		{field:'DisGrpID',title:'DisGrpID',width:100,hidden:true},
		{field:'DisGroup',title:'疑难病种',width:140},
		{field:'PrvDesc',title:'号别',width:120},
		{field:'PreTime',title:'预约时间',width:140},
		{field:'PayMony',title:'收费状态',width:80,formatter:
			function (value, row, index){
				if (value == "未收费"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},
		{field:'CstStatusDesc',title:'会诊状态',width:80,formatter:
			function (value, row, index){
				if (value == "撤销"){return '<font style="color:red;font-weight:bold;">'+value+'</font>'}
				else {return '<font style="color:green;font-weight:bold;">'+value+'</font>'}
			}
		},{field:'PrintFlag',title:'打印',width:80,align:'center',hidden:true,formatter:
			function (value, row, index){
				if (value.indexOf("Y")!=-1){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},{field:'PrintCons',title:'打印告知单',width:80,align:'center',formatter:
			function (value, row, index){
				
				if (row.PrintFlag.indexOf("Z")!=-1){return '<font style="color:green;font-weight:bold;">已打印</font>'}
				else {return '<font style="color:red;font-weight:bold;">未打印</font>'}
			}
		},
		{field:'PatNo',title:'登记号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:60},
		{field:'PatAge',title:'年龄',width:60},
		{field:'MCTimes',title:'第几次会诊',width:120},
		{field:'PatLoc',title:'就诊科室',width:120},
		{field:'PatDiag',title:'诊断',width:140},
		{field:'CstRLoc',title:'申请会诊科室',width:120},
		{field:'CstRUser',title:'申请会诊医师',width:100},
		{field:'CstRTime',title:'申请时间',width:160},
		{field:'CstLocArr',title:'参加会诊科室',width:220},
		{field:'CstPrvArr',title:'参加会诊医师',width:220},
		{field:'CstNPlace',title:'会诊地点',width:200},
		{field:'ID',title:'ID',width:100},
		{field:'mdtMakResID',title:'mdtMakResID',width:100},
		{field:'EpisodeID',title:'EpisodeID',width:100,hidden:true}
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true,
		pagination: true,
		onLoadSuccess:function(data){
		
			var rows = $("#bmDetList").datagrid('getRows');		   
			if (rows.length == 0){
				InsPageConsult({CstTrePro:"",CstPurpose:"",TreMeasures:""})
				return;
			}
			var rowData = $('#bmDetList').datagrid('getData').rows[0];
			$("#bmDetList").datagrid('selectRow',0)
			InsPageConsult(rowData);	
		
		},
		onClickRow: function (rowIndex, rowData) {
			InsPageConsult(rowData);
        },
		onDblClickRow: function (rowIndex, rowData) {
			WriteMdt(rowData.EpisodeID);
        },
	};
	/// 就诊类型
	var param = "^^^^" + PatientID +"^"+ EpisodeID +"^"+TimesArr;
	var uniturl = $URL+"?ClassName=web.DHCMDTConsultQuery&MethodName=JsGetPatHisCons&Params="+param;
	new ListComponent('bmDetList', columns, uniturl, option).Init(); 
  
  
}

/// 查询
function QryPatList(){
	
	var StartDate = $HUI.datebox("#StartDate").getValue(); /// 开始日期
	var EndDate = $HUI.datebox("#EndDate").getValue();     /// 结束日期
	var RLocID = $HUI.combobox("#CstRLoc").getValue()||"";       /// 请会诊科室
	var mdtDisGrp = $HUI.combobox("#mdtDisGrp").getValue()||"";  /// 疑难病种
	var TimesArr = $HUI.combobox("#TimesArr").getValue()||"";  /// 疑难病种
	var params = StartDate +"^"+ EndDate +"^"+ RLocID +"^"+ mdtDisGrp +"^"+ PatientID +"^"+ EpisodeID+"^"+TimesArr;
	$("#bmDetList").datagrid("load",{"Params":params});
}

/// 填写MDT申请
function WriteMdt(EpisodeID, CstID){

		$("#newWinFrame").attr("src","dhcmdt.consultwrite.csp?EpisodeID="+EpisodeID +"&CstID="+CstID);
	
}
/// 处理特殊字符
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}

/// 会诊记录
function InsPageConsult(jsonObj){
	
	$("#ConsTrePro").text($_TrsTxtToSymbol(jsonObj.CstTrePro));    /// 病情摘要
	$("#ConsPurpose").text($_TrsTxtToSymbol(jsonObj.CstPurpose));  /// 会诊目的
	$("#TreMeasure").text($_TrsTxtToSymbol(jsonObj.TreMeasures));  /// 会诊目的
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

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
