/*
ģ��:		������Һ����
��ģ��:		������Һ����-Һ����ά��
Creator:	hulihua
CreateDate:	2016-12-16
*/

var polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//��ʼ������Ĭ����Ϣ
	InitDefault();

	//��ʼ��Һ����
	QueryLiquid();
})

///��ʼ������Ĭ����Ϣ
function InitDefault(){
	polid=getParam("polid");  ///��Һ�������ID
}

///��ʼ��Һ����
function QueryLiquid(){
	var result=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","GetPivaCatLiquid",polid);
	if((result=="")||(result==null))
	{
		$('#POLMinVolume').focus()
		return;
	}
	$('#POLMinVolume').val(result.split("^")[0]);
	$('#POLMaxVolume').val(result.split("^")[1]);
}

/// ���±༭��
function SaveData(){
	if(polid==""){		
		$.messager.alert('��ʾ','��ѡ����Ҫά������Һ���࣡')
		return;	
	}
	
	var POLMinVolume=$('#POLMinVolume').val();
	var POLMaxVolume=$('#POLMaxVolume').val();		
	if((POLMinVolume=="")&&(POLMaxVolume=="")){
		$.messager.alert("��ʾ","��С���������������������ͬʱΪ��!"); 
		return false;
	}
	if(POLMinVolume>POLMaxVolume){
		$.messager.alert("��ʾ","��С���������ܴ������������!"); 
		return false;
	}
	var params=polid+"^^"+POLMinVolume+"^"+POLMaxVolume;
	//��������
	var savetype="2";
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVAOrderLink",params,savetype)
	if(data!=""){
		if(data==-1){
			$.messager.alert("��ʾ","��С�����������������ͬʱΪ��,���ܱ���!"); 
		}else if(data==-2){	
			$.messager.alert('��ʾ','����ʧ��!');		
		}else{	
			$.messager.alert('��ʾ','���³ɹ�!');		
		}
		QueryLiquid();
	}
}

///���
function ClearLabel()
{ 
	$('#POLMinVolume').val(''); 
	$('#POLMaxVolume').val('');						
}