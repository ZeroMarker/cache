
/// Creator: bianshuai
/// CreateDate: 2015-05-26

var url="dhcpha.clinical.action.csp";

$(function(){
	
	initScroll("#dg");//��ʼ����ʾ���������
	
	$("#stdate").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
	//����
	$('#dept').combobox({
		url:url+'?action=SelAllPhLoc&HospID='+session['LOGON.HOSPID']
		//onShowPanel:function(){
		//	$('#dept').combobox('reload',url+'?action=SelAllPhLoc&HospID='+session['LOGON.HOSPID'])
		//}
	}); 
	$('#dept').combobox('setValue',session['LOGON.CTLOCID']);

	//����
	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?actiontype=SelAllWard')
		}
	});
	
	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	    if(event.keyCode == "13")    
	    {
	        SetPatNoLength();  //�ǼǺ�ǰ��0
	    }
	});
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#dg').datagrid('loadData', {total:0,rows:[]});
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	if (LocID == ""){
		$.messager.alert("��ʾ","��ѡ����˿��ң�","info");
	}
	var WardID=$('#ward').combobox('getValue');    //����ID
	var PatNo=$.trim($("#patno").val());
	var HospID=session['LOGON.HOSPID'];
	var params=StDate+"^"+EndDate+"^"+WardID+"^"+LocID+"^"+PatNo+"^"+HospID;
	$('#dg').datagrid({
		url:url+'?action=jsQueryRefPatList',	
		queryParams:{
			params:params}
	});
}
        
//��������ɫ  formatter="SetCellColor"
function SetCellColor(value, rowData, rowIndex)
{
	var color="";
	if((value>"0")||(value="��")){
		color="green";
	}else{
		color="red";}
	return '<span style="font-weight:bold;color:'+color+'">'+value+'</span>';
}

//�ǼǺ��������� formatter="SetCellUrl"
function SetCellUrl(value, rowData, rowIndex)
{
	return "<a href='#' onclick='showWin("+rowData.AdmDr+")'>"+value+"</a>";
}

//����
function SetCellOpUrl(value, rowData, rowIndex)
{
	var html = "";
	if (rowData.CurState == ""){
    	html = '<a href="#" onclick="Meth_Appeal('+rowData.MonitorID+')"><span style="margin:0px 5px;font-weight:bold;color:red;">����</span></a>';
    	html = html + '|' + '<a href="#"  onclick="Meth_Agree('+rowData.MonitorID+','+rowIndex+')"><span style="margin:0px 5px;font-weight:bold;color:red;">����</span></a>';
    }else{
		html = "<span style='margin:0px 5px;font-weight:bold;color:green;'>�Ѵ���</span>";
	}
    return html;
}

///��ʾ���� formatter="SetCellUrl"
function showWin(AdmDr)
{
	createPatInfoWin(AdmDr); //���ô��� createPatInfoWin.js
}

//ȡ�ǼǺų��ȣ�����ʱ��0
function SetPatNoLength()
{
	var PatNo=$('#patno').val();
	$.post(url+'?action=GetPatRegNoLen',function(PatNoLen){
		var PLen=PatNo.length; //����ǼǺŵĳ���
		for (i=1;i<=PatNoLen-PLen;i++)
		{
			PatNo="0"+PatNo; 
		}
		$('#patno').val(PatNo); //��ֵ
	},'text');
	Query();  //��ѯ
}

///����
function Meth_Agree(monitorID,rowIndex)
{
	$.post(url,{action:"AgreeRefDrg", "monitorID":monitorID},function(data){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!="0"){
			$.messager.alert("��ʾ","����ʧ�ܣ�","info");
		}else{
			//$.messager.alert("��ʾ","���߳ɹ���");
			$("tr[datagrid-row-index="+rowIndex+"]"+" "+"td[field=modApp]"+" "+"div").html("<span style='margin:0px 5px;font-weight:bold;color:green;'>�Ѵ���</span>");
		}
	});
}

///����
function Meth_Appeal(monitorID)
{
	var lnk="dhcpha.clinical.drgrefuselist.csp?monitorID="+monitorID;
	window.open(lnk,"_target","height=400,width=800,menubar=no,status=no,toolbar=no");
}
