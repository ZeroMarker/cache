/*
ģ��:����ҩ��
��ģ��:����ҩ��-ֱ�ӷ�ҩѡ��ҩ����
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
	fyWinCombo.init(); //��ʼ����ҩ����������
	var pyUserCombo=new ListCombobox("pyUser",commonOutPhaUrl+'?action=GetPYUserList&gLocId='+gLocId+'&gUserId='+gUserId,'',combooption);
	pyUserCombo.init(); //��ʼ����ҩ��������
	InitFYWinList(); //��ʼ���б�
	$('#btnSure').bind("click",PostToDisp);
	$('#btnModify').bind("click",ChangeWinStat);  
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

function InitFYWinList(){
	//����columns
	var columns=[[
		{field:"phwpid",title:'phwpid',hidden:true},
		{field:"phwid",title:'phwid',hidden:true},
		{field:'phwWinDesc',title:'ҩ������',width:200},
		{field:'phwWinStat',title:'����״̬',width:200}		
	]];
	
	//����datagrid
	$('#fywingrid').datagrid({
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
	var pydr=$('#pyUser').combobox("getValue");
	var fywin=$('#fyWin').combobox("getValue");
	if ($('#fyWin').combobox("getText")==""){
		fywin=""
		$.messager.alert('��ʾ','����ѡ��ҩ����!','warning');
		return;
	}
	if ($('#pyUser').combobox("getText")==""){
		pydr=""
		$.messager.alert('��ʾ','����ѡ����ҩ��!','warning');
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
	var Rel='dhcpha.outpha.disp.csp?ReqStr='+reqstr; //ֱ�ӷ�ҩ
	if (DispType=="PRESCDISP"){
		var Rel='dhcpha.outpha.prescdisp.csp?ReqStr='+reqstr; //����Ԥ��ģʽ��ҩ
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
		$.messager.alert('��ʾ','��Ȩ��ҩ!','warning');
		$('#btnSure').hide();
		return;
	}
	
}
function ChangeWinStat(){
	var selecteddata = $('#fywingrid').datagrid('getSelected');
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