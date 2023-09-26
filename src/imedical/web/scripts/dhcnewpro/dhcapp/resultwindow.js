/// 页面初始化函数
function initPageDefault(){
	initcolumns();	 /// 初始化加载数据
}
function initcolumns()
{
	/// 主诉datagrid
	var symcolumns=[[
		{field:'EpisodeID',title:'就诊ID',width:50,hidden:true},
		{field:'PatStmTom',title:'主诉',width:430},
		{field:'amSave',title:'保存对象',width:50,hidden:true},
		{field:'amPointer',title:'对应ID',width:50,hidden:true},
		{field:'opUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'amRowId',title:'ID',width:40,hidden:true},
	
	]];
	
	///  定义datagrid  
	var symoption = {
		rownumbers : true,
		singleSelect : true,
		columns:symcolumns,
		onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
           var rowsData = $("#patsymtomlist").datagrid('getSelected');
           window.parent.$("#arPatSym").val(rowsData.PatStmTom);
           parent.$('#winonline').window('close');
        } 
	};

	var symuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patsymtomlist', symcolumns, symuniturl, symoption).Init();
	
	
	/// 现病史 datagrid
	var precolumns=[[
		
		{field:'EpisodeID',title:'就诊ID',width:50,hidden:true},
		{field:'PatPreHis',title:'现病史',width:430},
		{field:'apSave',title:'保存对象',width:50,hidden:true},
		{field:'apPointer',title:'对应ID',width:50,hidden:true},
		{field:'opUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'apRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  定义datagrid  
	var preoption = {
		rownumbers : true,
		singleSelect : true,
		columns:precolumns,
		onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
           var rowsData = $("#patprehislist").datagrid('getSelected');
           window.parent.$("#arDisHis").val(rowsData.PatPreHis);
           parent.$('#winonline').window('close');
        } 
	};

	var preuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPrehisPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patprehislist', precolumns, preuniturl, preoption).Init(); 
	
	
	/// 体征 datagrid
	var signcolumns=[[
		
		{field:'EpisodeID',title:'就诊ID',width:50,hidden:true},
		{field:'PatSign',title:'体征',width:430},
		{field:'aptSave',title:'保存对象',width:50,hidden:true},
		{field:'aptPointer',title:'对应ID',width:50,hidden:true},
		{field:'optUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'aptRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  定义datagrid  
	var signoption = {
		rownumbers : true,
		singleSelect : true,
		columns:signcolumns,
		onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
           var rowsData = $("#patsignlist").datagrid('getSelected');
           window.parent.$("#arPhySig").val(rowsData.PatSign);
           parent.$('#winonline').window('close');
        } 
	};

	var signuniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySignPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patsignlist', signcolumns, signuniturl, signoption).Init(); 
	
		/// 检查目的 datagrid
	var purcolumns=[[
		
		{field:'EpisodeID',title:'就诊ID',width:50,hidden:true},
		{field:'PatPur',title:'检查目的',width:430},
		{field:'aptSave',title:'保存对象',width:50,hidden:true},
		{field:'aptPointer',title:'对应ID',width:50,hidden:true},
		{field:'optUserDr',title:'opUserDr',width:50,hidden:true},
		{field:'aptRowId',title:'ID',width:40,hidden:true}
	
	]];
	
	///  定义datagrid  
	var puroption = {
		rownumbers : true,
		singleSelect : true,
		columns:purcolumns,
		onDblClickRow: function (rowIndex, rowData) {// 双击选择行编辑
           var rowsData = $("#patpurposelist").datagrid('getSelected');
           window.parent.$("#ExaPurp").val(rowsData.PatPur);
           parent.$('#winonline').window('close');
        } 
	};
	var puruniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPersonalFormat&params="+window.parent.LgUserID;
	new ListComponent('patpurposelist', purcolumns, puruniturl, puroption).Init(); 
}

/// 引用主诉数据
function quotesymdata()
{
	var rowsData = $("#patsymtomlist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要引用的数据！");
		return;
		}
	window.parent.$("#arPatSym").val(rowsData.PatStmTom);
	parent.$('#winonline').window('close');
}
/// 删除主诉模板
function deletesymrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patsymtomlist").datagrid('getSelected'); //选中要删除的行
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
				runClassMethod("web.DHCAPPExaReport","DeletePatSymTom",{"amRowId":rowsData.amRowId,"OpUserId":rowsData.opUserDr},function(jsonString){
					$('#patsymtomlist').datagrid('reload'); //重新加载
				})
			}
		});
	}else{
		 $.messager.alert('提示','请选择要删除的项','warning');
		 return;
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
/// 引用检查目的数据
function quotepurdata()
{
	var rowsData = $("#patpurposelist").datagrid('getSelected');
	if (rowsData == null)
	{
		$.messager.alert("提示", "请选择要引用的数据！");
		return;
		}
	window.parent.$("#ExaPurp").val(rowsData.PatPur);
	parent.$('#winonline').window('close');
}
/// 删除体征模板
function deletepurrow()
{
	var UserId=window.parent.LgUserID;
	var rowsData = $("#patpurposelist").datagrid('getSelected'); //选中要删除的行
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
				runClassMethod("web.DHCAPPExaReport","DeletePur",{"aptRowId":rowsData.aptRowId,"OpUserId":rowsData.optUserDr},function(jsonString){
					$('#patpurposelist').datagrid('reload'); //重新加载
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
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPublicFormat&params="+Saveas;
	$('#patsymtomlist').datagrid({url:uniturl});
}


///获取主诉个人模板
function symtompersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QuerySymPersonalFormat&params="+Saveas;
	$('#patsymtomlist').datagrid({url:uniturl});
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
/// 获取检查目的科室模板
function purpublicmodel()
{
	var Saveas=window.parent.LgCtLocID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPublicFormat&params="+Saveas;
	$('#patpurposelist').datagrid({url:uniturl});
}
/// 获取检查目的个人模板
function purpersonalmodel()
{
	var Saveas=window.parent.LgUserID
	var uniturl = LINK_CSP+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryPurPersonalFormat&params="+Saveas;
	$('#patpurposelist').datagrid({url:uniturl});
}
/// JQuery 初始化页面
$(function(){initPageDefault(); })