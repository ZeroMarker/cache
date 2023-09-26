
var LINK_CSP="dhcapp.broker.csp";

/// 页面初始化函数
function initPageDefault(){
	initcolumns();	 /// 初始化加载数据
}
function initcolumns()
{
	/// 主诉datagrid
	var symcolumns=[[
		{field:'CotText',title:'会诊意见',width:430},
		{field:'CotID',title:'会诊ID',width:50,hidden:true}
	]];
	
	///  定义datagrid  
	var symoption = {
		height:200,
		rownumbers : true,
		singleSelect : true,
		columns:symcolumns,
		onDblClickRow: function (rowIndex, rowData) {
           var rowsData = $("#patcotlist").datagrid('getSelected');
           window.parent.$("#ConsOpinion").val(rowsData.CotText);
           parent.$('#winonline').window('close');
        } 
	};

	var symuniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByLoc&LocDr="+window.parent.session['LOGON.CTLOCID'];
	new ListComponent('patcotlist', symcolumns, symuniturl, symoption).Init();
	
}

/// 引用主诉数据
function quotesymdata()
{
	var rowsData = $("#patcotlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要引用的数据！");
		return;
		}
	window.parent.$("#ConsOpinion").val(rowsData.CotText);
	parent.$('#winonline').window('close');
}
/// 删除主诉模板
function deletesymrow()
{

	var UserID = window.parent.session['LOGON.USERID'];
	var LocID = window.parent.session['LOGON.CTLOCID'];
	var rowsData = $("#patcotlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null)
	{
		debugger;
		if((rowsData.CotLoc!="")&&(rowsData.CotLoc!=LocID)){
			$.messager.alert("提示","没有权限删除!");
			return;
		}
		
		if((rowsData.CotUser!="")&&(rowsData.CotUser!=UserID)){
			$.messager.alert("提示","没有权限删除!");
			return;
		}
		
		runClassMethod("web.DHCEMConsult","DeleteCot",{"CotID":rowsData.CotID},function(jsonString){
			$HUI.datagrid("#patcotlist").reload();
		})
	}
}

/// 引用现病史数据
function quoteprehisdata()
{
	
	var rowsData = $("#patprehislist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要引用的数据！");
		return;
		}
	window.parent.$("#arDisHis").val(rowsData.PatPreHis);
	parent.$('#winonline').window('close');
}
/// 删除现病史模板
function deleteprehisrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patprehislist").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要删除的数据！");
		return;
		}
	if (UserId!=rowsData.opUserDr){
		$.messager.alert('提示','您没有操作权限','warning');
		 return;
		}
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPExaReport","DeletePreHis",{"apRowId":rowsData.apRowId,"OpUserId":rowsData.opUserDr},function(jsonString){
					$('#patprehislist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 引用体征数据
function quotesigndata()
{
	var rowsData = $("#patsignlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要引用的数据！");
		return;
		}
	window.parent.$("#arPhySig").val(rowsData.PatSign);
	parent.$('#winonline').window('close');
}
/// 删除体征模板
function deletesignrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patsignlist").datagrid('getSelected'); //选中要删除的行
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要删除的数据！");
		return;
		}
	if (UserId!=rowsData.optUserDr){
		$.messager.alert('提示','您没有操作权限','warning');
		 return;
		}
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要删除这些数据吗？", function (res) {//提示是否删除
			if (res) {
				runClassMethod("web.DHCAPPExaReport","DeleteSign",{"aptRowId":rowsData.aptRowId,"OpUserId":rowsData.optUserDr},function(jsonString){
					$('#patsignlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
	}
}

/// 获取主诉科室模板
function symtompublicmodel()
{
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByLoc&LocDr="+window.parent.session['LOGON.CTLOCID'];
	$('#patcotlist').datagrid({url:uniturl});
}


///获取主诉个人模板
function symtompersonalmodel()
{
	var uniturl = LINK_CSP+"?ClassName=web.DHCEMConsultQuery&MethodName=QueryCotByUser&UserDr="+window.parent.session['LOGON.USERID'];
	$('#patcotlist').datagrid({url:uniturl});
}

/// 获取现病史科室模板
function prehispublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPublicFormat&params="+Saveas;
	$('#patprehislist').datagrid({url:uniturl});
}

/// 获取现病史个人模板
function prehispersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPersonalFormat&params="+Saveas;
	$('#patprehislist').datagrid({url:uniturl});
}

/// 获取体征科室模板
function signpublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPublicFormat&params="+Saveas;
	$('#patsignlist').datagrid({url:uniturl});
}

/// 获取体征个人模板
function signpersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPersonalFormat&params="+Saveas;
	$('#patsignlist').datagrid({url:uniturl});
}
/// JQuery 初始化页面
$(function(){initPageDefault(); })