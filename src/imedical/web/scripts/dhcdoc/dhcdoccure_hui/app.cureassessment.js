$(document).ready(function(){
	Init();
	InitEvent();
});

function Init(){
	if(ServerObj.DCAccRowId!=""){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"GetCureAssessment",
			'DCAssRowId':ServerObj.DCAccRowId
		},function(objScope){
			if (objScope=="") return;
			var TempArr=objScope.split("^");
			var DCAssUser=TempArr[0];
			var DCAssDate=TempArr[1];
			var DCAssContent=TempArr[2];
			$("#DCAssContent").val(DCAssContent);
		})	
	}	
}

function InitEvent(){
	$('#btnSave').bind("click",function(){
		Save();	
	});	
}

function Save()
{
    var OperateType=ServerObj.OperateType;
    if((ServerObj.DCARowId=="")&&(ServerObj.DCAccRowId=="")){
	   	$.messager.alert("��ʾ","��ȡ������Ϣ����.","warning");
		return; 
	}
    var regS = new RegExp("\\^","g");
	var DCAssContent=$("#DCAssContent").val();
	DCAssContent=DCAssContent.replace(regS,"")
	//if ((ServerObj.DCAccRowId=="")&&(DCAssContent==""))
	if ((DCAssContent==""))
	{
		$.messager.alert("��ʾ","�����������ݲ���Ϊ��","warning");
		return;
	}

	var Para=ServerObj.DCARowId+"^"+ServerObj.DCAccRowId+"^"+DCAssContent+"^"+session['LOGON.USERID'];
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Assessment",
		MethodName:"SaveCureAssessment",
		'Para':Para,
	},function(value){
		if(value==0)
		{
			//$.messager.alert('��ʾ','����ɹ�');
			/*if(ServerObj.SourceFlag=="CureApp"){
				window.returnValue = true;
				window.close();	
			}else{*/
				websys_showModal("close");
			//}
		}else if(value=="100"){
			$.messager.alert('����','����ʧ��,��Ҫ����Ϊ��');
		}else{
			errmsg='����ʧ��'+",�������:"+value
			$.messager.alert('����',errmsg);
		}
	})
}
