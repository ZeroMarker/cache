$(document).ready(function(){
	Init();
	InitEvent();
});

function Init(){
	if(ServerObj.DCAssRowId!=""){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"GetCureAssessment",
			'DCAssRowId':ServerObj.DCAssRowId
		},function(objScope){
			if (objScope=="") return;
			var TempArr=objScope.split("^");
			var DCAssUser=TempArr[0];
			var DCAssDate=TempArr[1];
			var DCAssContent=TempArr[8];
			var DCAssArcim=TempArr[10];
			DCAssContent=isJSON(DCAssContent);
			DCAssContent=eval("("+DCAssContent+")");
			$("#DCAssContent").val(DCAssContent.DCAssContent);
			$("#CBAss_ConsTrePro").val(DCAssContent.CBAss_ConsTrePro);
			$("#DCAssArcim").val(DCAssArcim);
		})	
	}else{
		if(ServerObj.DCRowIdStr==""){
			ServerObj.DCRowIdStr=ServerObj.DCARowId;
		}
		if(ServerObj.DCRowIdStr!=""){
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Assessment",
				MethodName:"GetArcimDesc",
				'DCRowIDStr':ServerObj.DCRowIdStr
			},function(val){
				if (val=="") return;
				$("#DCAssArcim").val(val);
			})
		}
	}
	comAssConsTrePro.Init("CBAss_ConsTrePro");
	//com_Util.InitPatientInfo(ServerObj.EpisodeID);
	ConTroClick();
}

function InitEvent(){
	$("#CureAssSave").click(function(){
	    Save();	
	}) 
	$("#CureAssPrt").click(function(){
	    CureAssPrt();	
	})
}

function ConTroClick(){
	if((ServerObj.DCAssRowId=="")){
		$("#CureAssPrt").linkbutton('disable');
	}else if((ServerObj.DCAssRowId!="")){
		$("#CureAssSave").linkbutton({text:"����"});
		$("#CureAssPrt").linkbutton('enable');
	}
}

function Save()
{
    var OperateType=ServerObj.OperateType;
    if((ServerObj.DCRowIdStr=="")&&(ServerObj.DCAssRowId=="")){
	   	$.messager.alert("��ʾ","��ȡ������Ϣ����.","warning");
		return; 
	}
    var regS = new RegExp("\\^","g");
	var DCAssContent=$("#DCAssContent").val();
	DCAssContent=DCAssContent.replace(regS,"")
	if ((DCAssContent==""))
	{
		$.messager.alert("��ʾ","�����������ݲ���Ϊ��","warning");
		return;
	}
	var CBAssConsTrePro=$("#CBAss_ConsTrePro").val();
	DCAssContent=DCAssContent.replace(regS,"");
	
	var UpdateObj={}
	if(typeof CASignObj == 'undefined'){
		CASignObj=window.CASignObj;
	}
	new Promise(function(resolve,rejected){
		//����ǩ��
		CASignObj.CASignLogin(resolve,"CureAss",false)
	}).then(function(CAObj){
		return new Promise(function(resolve,rejected){
	    	if (CAObj == false) {
	    		return websys_cancel();
	    	} else{
		    	$.extend(UpdateObj, CAObj);
		    	resolve(true);
	    	}
		})
	}).then(function(){
		
		var JsonObj={
			DCAssContent:DCAssContent,
			CBAss_ConsTrePro:CBAssConsTrePro
		}
		var JsonStr=JSON.stringify(JsonObj);
		var MapID="";
		var Para=ServerObj.DCARowId+"^"+ServerObj.DCAssRowId+"^"+JsonStr+"^"+session['LOGON.USERID']+"^"+"";
			Para=Para+"^"+""+"^"+MapID;
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"SaveCureAssBroker",
			Para:Para,
			DCRowIDStr:ServerObj.DCRowIdStr
		},function(retVal){
			var value=retVal.split(String.fromCharCode(1))[0];
			var RowidStr=retVal.split(String.fromCharCode(1))[1];
			if ( UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, RowidStr, "CureAss");
			ServerObj.DCAssRowId=RowidStr;
			if((value==0)||(value==""))
			{
				$("#CureAssPrt").removeClass('btn-lighttempgreen');
				$("#CureAssPrt").linkbutton('enable');
				$.messager.confirm('��ʾ','�Ƿ��ӡ�����ύ�����������?',function(r){
					if(r){
						CureAssPrt(RowidStr);
						$.messager.confirm('��ʾ','�Ƿ�رյ�ǰ����?',function(r){
							if(r){
								websys_showModal("close");
							}	
						});
					}else{
						$.messager.confirm('��ʾ','�Ƿ�رյ�ǰ����?',function(r){
							if(r){
								websys_showModal("close");
							}	
						});	
					}
				});
			}else{
				errmsg='����ʧ��'+",�������:"+value
				$.messager.alert('����',errmsg);
			}
		})
	})
}


function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj=JSON.parse(str);
            if(typeof obj == 'object' && obj ){
                return str;
            }else{
	            str={
		        	DCAssContent:str,
		        	CBAss_ConsTrePro:""     
		        }
                return JSON.stringify(str);
            }

        } catch(e) {
            str={
	        	DCAssContent:str,
	        	CBAss_ConsTrePro:"" 
	        }
            return JSON.stringify(str);
        }
    }
}

function CureAssPrt(DCAssRowId){
	if(typeof DCAssRowId=="undefined"){
		DCAssRowId=	ServerObj.DCAssRowId;
	}
	assTempPrint.AssTemp_Print(DCAssRowId,"����������")
}