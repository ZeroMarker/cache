function InitCardType(){
	//�������б�
    var CTObj=$HUI.combobox("#cardType",{
    	valueField:'CardTypeId',   
    	textField:'CardTypeDesc',
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=FindCardType&ResultSetType=array",
    	onSelect:function(r){
	    	ChangeBtnReadCard(r.CardTypeId);
	    },
	    onLoadSuccess:function(row){
		    for(var i=0;i<row.length;i++){
				if(row[i].selected==1){
					$(this).combobox('setValue',row[i].CardTypeId);	
				}    
			}
			InitBtnReadCard($(this))
		}
	});	
}

function InitBtnReadCard(){
	var cardType="";
	cardType=$HUI.combobox('#cardType').getValue()
	if(cardType!=""){
		ChangeBtnReadCard(cardType);
	}
}

function ChangeBtnReadCard(val){
	var myoptval=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',val);
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")	{	return;	}
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		$('#btnReadCard').linkbutton({    
		    disabled: true  
		}); 
		$('#btnReadCard').unbind();
	}else{
		var myobj=document.getElementById("CardNo");
		$('#btnReadCard').linkbutton({    
		    disabled: false  
		}); 
		$('#btnReadCard').bind('click', function(){
			ReadCardClick();
		});  
	}
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		//DHCWeb_setfocus("ReadCard");
	}
		
}

function ReadCardClick(){
	var CardTypeRowId=$("#cardType").combobox('getValue');
	var myoptvalvar=tkMakeServerCall('web.UDHCOPOtherLB','ReadCardTypeDefineListBroker1',CardTypeRowId);
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptvalvar);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			if((typeof(CardNo)=="undefined")||(CardNo=="undefined")||(CardNo=="")){
				dhcsys_alert("����Ч,�����Ƿ��ѷſ�");
				return;
			}
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				$("#cardType").combobox('setValue',NewCardTypeRowId);	
			}
			var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",CardNo,NewCardTypeRowId)
			if(PatientID=="")
			{
				 dhcsys_alert("����Ч");
				 return;
			}
			$("#CardNo").val(CardNo);
			$("#PatientID").val(PatientID);			
			break;
		case "-200": //����Ч
			dhcsys_alert("����Ч");
			$("#CardNo").val("");
			break;
		case "-201": //�ֽ�
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId){
				$("#cardType").combobox('setValue',NewCardTypeRowId);
			}
         	if (NewCardTypeRowId ==="") CardNo="";
         	var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByCardNo",CardNo,NewCardTypeRowId)
			if(PatientID=="")
			{
				 dhcsys_alert("����Ч");
				 return;
			}
         	$("#CardNo").val(CardNo);
			$("#PatientID").val(PatientID);
			break;
		default:
	}
}

function InitPatNoEvent(callBackFun){
	$('#patNo').bind('keydown', function(event){
		if(event.keyCode==13){
			PatNoHandle(callBackFun);
		}
	});
	$('#patNo').bind('change', function(){
		if ($("#patNo").val()==""){
			$("#PatientID").val("");
		}
    });
}

function PatNoHandle(callBackFun,Element){
	if(typeof(Element)=="undefined"){Element="patNo";}
	var patNo=$("#"+Element).val();
	if(patNo!=""){
		for (var i=(10-patNo.length-1); i>=0; i--) {
			patNo="0"+patNo;
		}
		$("#"+Element).val(patNo);
		var PatientID=tkMakeServerCall("DHCDoc.DHCDocCure.Config","GetPatientIDByNo",patNo)
		if(PatientID==""){					
			$("#"+Element).val("");
			$.messager.alert("��ʾ","δ�ҵ��õǼǺŶ�Ӧ����",'error');
			//alert("δ�ҵ��õǼǺŶ�Ӧ����");
			return websys_cancel();
		}
		$("#PatientID").val(PatientID);
	}else{
		$("#PatientID").val("");	
	}
	$("#CardNo").val("");
	$("#CardTypeNew").val("");
	eval('(' + callBackFun + ')')();
	return;
}

function InitCardNoEvent(callBackFun){
	$('#btnReadCard').bind('click', function(){
		ReadCardClickHandler(callBackFun);
	});  
	$('#CardNo').bind('keydown', function(event){
		if(event.keyCode==13)
		{  
			CardNoHandle(callBackFun);
			return websys_cancel();
		}
	});
	
	$('#CardNo').bind('change', function(event){
		if($("#CardNo").val()==""){
			$("#patNo").val("");
			$("#PatientID").val("");
		}
    });	
}

function ReadCardClickHandler(callBackFun){
	DHCACC_GetAccInfo7(CardNoKeyDownCallBack);
	eval('(' + callBackFun + ')')();
}

function CardNoHandle(callBackFun){
	$("#patNo").val("");
	$("#PatientID").val("");
	var CardNo=$("#CardNo").val();
	if (CardNo=="") return false;
	var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardNoKeyDownCallBack);
	if(myrtn!=false){
		eval('(' + callBackFun + ')')();
	}
}

function CardNoKeyDownCallBack(myrtn,errMsg){
	//console.log("CardNoKeyDownCallBack_start")
	if (typeof errMsg == "undefined") errMsg="����Ч";
	var myary=myrtn.split("^");
    var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#CardTypeRowID").val(myary[8]);
			$("#PatientID").val(PatientID);
			$("#patNo").val(PatientNo);	
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ", errMsg, "error");
			$("#patNo").val("");
			$("#PatientID").val("");
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#CardTypeRowID").val(myary[8]);
		    $("#PatientID").val(PatientID);
			$("#patNo").val(PatientNo);
			break;
		default:
	}
	//console.log("CardNoKeyDownCallBack_end")
}
