/*
模块:门诊药房
子模块:门诊药房-选择配药窗口
createdate:2016-04-25
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
	textField :'Desc',
	panelHeight:"auto"
} 	 
$(function(){
	var pyWinCombo=new ListCombobox("pyWin",commonOutPhaUrl+'?action=GetPYWinList&gLocId='+gLocId,'',combooption);
	pyWinCombo.init(); //初始化配药人下拉框	
	InitPYWinList(); //初始化列表
	$('#btnSure').bind("click",PostToDisp);
	$('#btnModify').bind("click",ChangeWinStat);  
	$('#stepTime').val("30");
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
function InitPYWinList(){
	//定义columns
	var columns=[[
		{field:"phwpid",title:'phwpid',hidden:true},
		{field:"phwid",title:'phwid',hidden:true},
		{field:'phwWinDesc',title:'药房窗口',width:200},
		{field:'phwWinStat',title:'窗口状态',width:200}		
	]];
	
	//定义datagrid
	$('#pywingrid').datagrid({
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
	var fydr=""
	var pywin=$('#pyWin').combobox("getValue");
	if ($('#pyWin').combobox("getText")==""){
		pywin=""
		$.messager.alert('提示','请先选择配药窗口','warning');
		return;
	}
	if (gOutPhUser==""){
		return;
	}
	if (gOutPhLoc==""){
		return;
	}
	var pos=""
	var steptime=$("#stepTime").val();
	var reqstr=""
	reqstr=gOutPhLoc+"^"+gOutPhUser+"^"+fydr+"^"+pywin+"^"+pos+"^"+steptime
	var Rel='dhcpha.outpha.py.csp?ReqStr='+reqstr
	location.href=Rel;
}
function ChangeWinStat(){
	var selecteddata = $('#pywingrid').datagrid('getSelected');
	if(selecteddata==null){
		$.messager.alert('提示','请先选中需要修改状态的窗口!','warning');
		return;	
	}
	var phwpid=selecteddata["phwpid"];
	var phwWinStat=selecteddata["phwWinStat"];
	if (phwWinStat=="有人"){ phwWinStat="0"; }
    else{phwWinStat="1";}
	var modifyret=tkMakeServerCall("web.DHCOutPhDisp","UpdatePhwp",phwpid,phwWinStat)
	Query();
}
function Query()
{
	var params=gLocId
	$('#pywingrid').datagrid({
		url:commonOutPhaUrl+'?action=QueryDispWinList&gLocId='+gLocId,	
		onLoadSuccess: function(){
          
	    }
	});
}
function InitBodyStat()
{
	var getTQsurewin=tkMakeServerCall("web.DHCOutPhTQDisp","GetSureWin",gLocId,gUserId)
   	if (getTQsurewin!="0"){
	  var surewinstr=getTQsurewin.split("^")
	  gOutPhLoc=surewinstr[2]
	  gOutPhUser=surewinstr[3]	   
   } 
  	var checkpy=tkMakeServerCall("web.DHCOutPhTQDisp","CheckPy",gLocId,gUserId,1)
	if (checkpy!="0"){
		$.messager.alert('提示','无权配药!','warning');
		$('#btnSure').hide();
		return;
	}
	var getsurewin=tkMakeServerCall("web.DHCOutPhDisp","GetSureWin",gLocId)
	if (getsurewin!="0"){
		$.messager.alert('提示','药房未设置提前摆药流程!','warning');
		$('#btnSure').hide();
		$('#btnModify').hide();
		return;
	}
}