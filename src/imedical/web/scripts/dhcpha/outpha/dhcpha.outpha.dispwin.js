/*
模块:门诊药房
子模块:门诊药房-直接发药选择发药窗口
createdate:2016-04-29
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
	var pyUserCombo=new ListCombobox("pyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	pyUserCombo.init(); //初始化配药人下拉框
	InitFYWinList(); //初始化列表
	$('#btnSure').bind("click",PostToDisp);
	$('#btnModify').bind("click",ChangeWinStat);  
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
	var pydr=$('#pyUser').combobox("getValue");
	var fywin=$('#fyWin').combobox("getValue");
	if ($('#fyWin').combobox("getText")==""){
		fywin=""
		$.messager.alert('提示','请先选择发药窗口!','warning');
		return;
	}
	if ($('#pyUser').combobox("getText")==""){
		pydr=""
		$.messager.alert('提示','请先选择配药人!','warning');
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
	var Rel='dhcpha.outpha.disp.csp?ReqStr='+reqstr; //直接发药
	if (DispType=="PRESCDISP"){
		var Rel='dhcpha.outpha.prescdisp.csp?ReqStr='+reqstr; //处方预览模式发药
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
function ChangeWinStat(){
	var selecteddata = $('#fywingrid').datagrid('getSelected');
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