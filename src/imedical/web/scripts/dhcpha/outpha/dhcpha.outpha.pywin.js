/*
ģ��:����ҩ��
��ģ��:����ҩ��-ѡ����ҩ����
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
	pyWinCombo.init(); //��ʼ����ҩ��������	
	InitPYWinList(); //��ʼ���б�
	$('#btnSure').bind("click",PostToDisp);
	$('#btnModify').bind("click",ChangeWinStat);  
	$('#stepTime').val("30");
	InitBodyStat();
	Query();
	if (gOutPhUser==""){
		$.messager.alert('��ʾ','��½��Ա��δ������ҩ����Աά����ά��!','warning');
		return;
	}
	if (gOutPhLoc==""){
		$.messager.alert('��ʾ','��½������δ������ҩ��������ά��!','warning');
	}
});
function InitPYWinList(){
	//����columns
	var columns=[[
		{field:"phwpid",title:'phwpid',hidden:true},
		{field:"phwid",title:'phwid',hidden:true},
		{field:'phwWinDesc',title:'ҩ������',width:200},
		{field:'phwWinStat',title:'����״̬',width:200}		
	]];
	
	//����datagrid
	$('#pywingrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
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
		$.messager.alert('��ʾ','����ѡ����ҩ����','warning');
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
		$.messager.alert('��ʾ','����ѡ����Ҫ�޸�״̬�Ĵ���!','warning');
		return;	
	}
	var phwpid=selecteddata["phwpid"];
	var phwWinStat=selecteddata["phwWinStat"];
	if (phwWinStat=="����"){ phwWinStat="0"; }
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
		$.messager.alert('��ʾ','��Ȩ��ҩ!','warning');
		$('#btnSure').hide();
		return;
	}
	var getsurewin=tkMakeServerCall("web.DHCOutPhDisp","GetSureWin",gLocId)
	if (getsurewin!="0"){
		$.messager.alert('��ʾ','ҩ��δ������ǰ��ҩ����!','warning');
		$('#btnSure').hide();
		$('#btnModify').hide();
		return;
	}
}