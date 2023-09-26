
/// Creator: bianshuai
/// CreateDate: 2015-05-26

var url="dhcpha.clinical.action.csp";

$(function(){
	
	initScroll("#dg");//初始化显示横向滚动条
	
	$("#stdate").datebox("setValue", formatDate(0));  //Init起始日期
	$("#enddate").datebox("setValue", formatDate(0));  //Init结束日期
	
	//科室
	$('#dept').combobox({
		url:url+'?action=SelAllPhLoc&HospID='+session['LOGON.HOSPID']
		//onShowPanel:function(){
		//	$('#dept').combobox('reload',url+'?action=SelAllPhLoc&HospID='+session['LOGON.HOSPID'])
		//}
	}); 
	$('#dept').combobox('setValue',session['LOGON.CTLOCID']);

	//病区
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?actiontype=SelAllWard')
		}
	});
	
	//登记号回车事件
	$('#patno').bind('keypress',function(event){
	    if(event.keyCode == "13")    
	    {
	        SetPatNoLength();  //登记号前补0
	    }
	});
})

//查询
function Query()
{
	//1、清空datagrid 
	$('#dg').datagrid('loadData', {total:0,rows:[]});
	//2、查询
	var StDate=$('#stdate').datebox('getValue');   //起始日期
	var EndDate=$('#enddate').datebox('getValue'); //截止日期
	var LocID=$('#dept').combobox('getValue');     //科室ID
	if (LocID == ""){
		$.messager.alert("提示","请选择审核科室！","info");
	}
	var WardID=$('#ward').combobox('getValue');    //病区ID
	var PatNo=$.trim($("#patno").val());
	var HospID=session['LOGON.HOSPID'];
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+HospID;
	$('#dg').datagrid({
		url:url+'?action=jsQueryRefPatList',	
		queryParams:{
			params:params}
	});
}
        
//设置列颜色  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if((value>"0")||(value="↑")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//登记号设置连接 formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

//操作
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.CurState == ""){
    	html = '<a href="#" onclick="Meth_Appeal('+rowData.MonitorID+')"><span style="margin:0px 5px;font-weight:bold;color:red;">申诉</span></a>';
    	html = html + '|' + '<a href="#"  onclick="Meth_Agree('+rowData.MonitorID+','+rowIndex+')"><span style="margin:0px 5px;font-weight:bold;color:red;">接受</span></a>';
    }else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>已处理</span>";
	}
    return html;
}

///显示窗口 formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //调用窗体 createPatInfoWin.js
}

//取登记号长度，不足时补0
function SetPatNoLength()
{
	var PatNo=$('#patno').val();
	$.post(url+'?action=GetPatRegNoLen',function(PatNoLen){
		var PLen=PatNo.length; //输入登记号的长度
		for (i=1;i<=PatNoLen-PLen;i++)
		{
			PatNo="0"+PatNo; 
		}
		$('#patno').val(PatNo); //赋值
	},'text');
	Query();  //查询
}

///接受
function Meth_Agree(monitorID,rowIndex)
{
	$.post(url,{action:"AgreeRefDrg", "monitorID":monitorID},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("提示","更新失败！","info");
		}else{
			//$.messager.alert("提示","申诉成功！");
			$("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=modApp]"+" "+"div").html("<span style='margin:0px 5px;font-weight:bold;color:green;'>已处理</span>");
		}
	});
}

///申诉
function Meth_Appeal(monitorID)
{
	var lnk="dhcpha.clinical.drgrefuselist.csp?monitorID="+monitorID;
	window.open(lnk,"_target","height=400,width=800,menubar=no,status=no,toolbar=no");
}
