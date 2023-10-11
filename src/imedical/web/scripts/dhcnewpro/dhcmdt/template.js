//===========================================================================================
// 作者：      bianshuai
// 编写日期:   2019-07-10
// 描述:	   mdt选择会诊模板界面
//===========================================================================================
var DisGrpID = ""; /// 病种ID
var LgUserID = session['LOGON.USERID'];  /// 用户ID
var LgLocID = session['LOGON.CTLOCID'];  /// 科室ID
var LgHospID = session['LOGON.HOSPID'];  /// 医院ID
var LgGroupID = session['LOGON.GROUPID'] /// 安全组ID
var LgParam=LgHospID+"^"+LgLocID+"^"+LgGroupID+"^"+LgUserID
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	
	/// 初始化加载病人列表
	InitPatList();
	
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");   /// 病人ID
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	DisGrpID = getParam("DisGrpID");   /// 病种ID
}

/// 页面DataGrid初始定义已选列表
function InitPatList(){
	///  定义columns
	 var ConsDetArr=[];
	 var makLocParams="";
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:'ID',title:'ID',width:100,hidden:true},
		{field:'Text',title:'模板内容',width:600},
		{field:'Title',title:'模板标题',width:180},
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		loadMsg:$g("正在加载信息"),
		rownumbers : true,
		singleSelect:false,
		pagination: true,
		iconCls:'icon-paper',
		bodyCls:'panel-header-gray',
		border:true,
		onLoadSuccess:function(data){
			$(".datagrid-header-check").html("");
		},
		onCheck: function (rowIndex,rowData){
		     var TmpData = rowData.Text;
		     ConsDetArr.push(TmpData);
		     var makLocParams = ConsDetArr.join(" ");
		     window.parent.$("#mdtPurpose").val(makLocParams);   /// 会诊目的
		},
		onUncheck: function (rowIndex,rowData){
		     var TmpData = rowData.Text;
		     ConsDetArr.push(TmpData);
		     for(var i=0;i<ConsDetArr.length;i++){
			     if(TmpData==ConsDetArr[i]){
				     delete ConsDetArr[i]
				     }
			     }
		     var makLocParams = ConsDetArr.join(" ");
		     window.parent.$("#mdtPurpose").val(makLocParams);   /// 会诊目的
		 }    
		     
	};
	/// 就诊类型
	//var Type = "";
	var Type = DisGrpID;
	var uniturl = $URL+"?ClassName=web.DHCMDTOpiTemp&MethodName=QryOpiTemp&Type="+DisGrpID+"&LgParam="+LgParam+"&MWToken="+websys_getMWToken();
	new ListComponent('main', columns, uniturl, option).Init(); 
}

/// 删除选中行
function deleteRow(){
	
	var rowsData = $("#main").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除模板数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCMDTOpiTemp","delete",{"ID":rowsData.ID},function(jsonString){
					if (jsonString < 0){
						$.messager.alert('提示','删除失败！','warning');
					}
					$('#main').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })