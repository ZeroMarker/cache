/*
模块:门诊药房
子模块:门诊药房-选择发药窗口
createdate:2016-04-27
creator:yunhaibao
*/
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gOutPhLoc="";
var gOutPhUser="";	
var combooption = {
	valueField :'RowId',    
	textField :'Desc'
} 
$(function(){	
	var fyWinCombo=new ListCombobox("fyWin",commonOutPhaUrl+'?action=GetFYWinList&gLocId='+gLocId,'',combooption);
	fyWinCombo.init(); //初始化发药窗口下拉框
	InitFYWinList(); //初始化列表
	$('#btnSure').bind("click",PostToDisp);
	InitBodyStat();
	Query();
	if (gOutPhUser==""){
		$.messager.alert('提示','登陆人员尚未在门诊药房人员维护中维护!','warning');
		return;
	}
	if (gOutPhLoc==""){
		$.messager.alert('提示','登陆科室尚未在门诊药房科室中维护!','warning');
	}
});

function InitFYWinList(){
	//定义columns
	var columns=[[
		{field:"phwpid",title:'phwpid',hidden:true},
		{field:"phwid",title:'phwid',hidden:true},
		{field:'phwWinDesc',title:'药房窗口',width:200},
		{field:'phwWinStat',title:'窗口状态',width:200}		
	]];
	
	//定义datagrid
	$('#fywingrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '正在加载信息...',
		singleSelect: true,
		selectOnCheck: true, 
		checkOnSelect: true

	});

}
function PostToDisp(){
	var pydr=""
	var fywin=$('#fyWin').combobox("getValue");
	if ($('#fyWin').combobox("getText")==""){
		fywin=""
		$.messager.alert('提示','请先选择发药窗口','warning');
		return;
	}
	if (gOutPhUser==""){
		return;
	}
	if (gOutPhLoc==""){
		return;
	}
	var pos=""
	var reqstr=""
	reqstr=gOutPhLoc+"^"+pydr+"^"+gOutPhUser+"^"+fywin+"^"+pos;
	var Rel="";
	if (DispType=="FY"){ //门诊发药
		Rel='dhcpha.outpha.fy.csp?ReqStr='+reqstr
	}
	else if (DispType=="PRESCFY"){ //门诊处方预览发药
		Rel='dhcpha.outpha.prescfy.csp?ReqStr='+reqstr	
	}
	if(Rel==""){
		$.messager.alert('提示','请确认对应菜单的表达式是否为("&DispType=FY"或"&DispType=PRESCFY</br>"或"&DispType=DISP")','warning');
		return;
	}
	location.href=Rel;
}

function Query()
{
	var params=gLocId
	$('#fywingrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispWinList&gLocId='+gLocId,	
		onLoadSuccess: function(){
          
	    }
	});
}
function InitBodyStat()
{
	var getsurewin=tkMakeServerCall("web.DHCOutPhTQDisp","GetSureWin",gLocId,gUserId)
   	if (getsurewin!="0"){
	  var surewinstr=getsurewin.split("^")
	  gOutPhLoc=surewinstr[2]
	  gOutPhUser=surewinstr[3]	   
   } 
   	var checkpy=tkMakeServerCall("web.DHCOutPhTQDisp","CheckPy",gLocId,gUserId,2)
	if (checkpy!="0"){
		$.messager.alert('提示','无权发药!','warning');
		$('#btnSure').hide();
		return;
	}
	
}