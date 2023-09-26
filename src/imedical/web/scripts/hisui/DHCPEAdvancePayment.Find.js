
//����	DHCPEAdvancePayment.Find.js
//����	Ԥ�ɽ�/���𿨹���
//���	DHCPEAdvancePayment.Find  	
//����	2019.04.02
//������  xy
function BodyLoadHandler(){
	
	//��ѯ
    $("#BFind").click(function() {		
			BFind_click();	
        });
  
    $("#RegNo").keydown(function(e) {
			if(e.keyCode==13){
				BFind_click();
			}
			
        });
        
    obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_keydown;
	}
	
	//����
	 $("#BNew").click(function() {		
			BNew_click();	
        });
        
	//�˷�
	 $("#BRefund").click(function() {		
			BRefund_click();	
        });
        
        
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCardClickHandler;}
	
	$("#CardType").combobox({
		onSelect:function(){
		CardType_change();	
		}
	});
	
	ElementEnble();
	
	initialReadCardButton();

	
}
function ElementEnble()
{
	CardType=getValueById("CardType");
     if (CardType=="C")
		{
			var obj=document.getElementById("cRegNo");
			if (obj) obj.innerText="���𿨺�";
			var obj=document.getElementById("cCardNo");
			if (obj) obj.style.display="none";
			var obj=document.getElementById("CardNo");
			if (obj) obj.style.display="none";
			var obj=document.getElementById("BReadCard");
			if (obj) obj.style.display="none";
		}
	 if (CardType=="R")
		{
			var obj=document.getElementById("cRegNo");
			if (obj) obj.innerText="�ǼǺ�";
			
			
		}	
}


function CardType_change()
{
	ElementEnble();
	
}
function BRefund_click()
{
	/*
	if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ����˷ѵļ�¼","info");
	 	 return false;
		}
		*/
		
	var CardType=getValueById("CardType");
	var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAPAC.Refund'+"&Type="+CardType;
    //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=800,left=120,top=0')
    websys_lu(lnk,false,'width=620,height=335,hisui=true,title=�˷�')
}

function BNew_click()
{
	
	var lnk='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAdvancePayment';
    //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=800,left=120,top=0')
     websys_lu(lnk,false,'width=800,height=435,hisui=true,title=��쿨')
}


function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	 var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	if (myCardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",myCardNo,"","BFind_click()",CardTypeCallBack);
		return false;
	
}

//����
function ReadCardClickHandler(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			BFind_click();
			$("#CardTypeNewID").val(CardTypeNewID);
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#RegNo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			BFind_click();
			event.keyCode=13;
			break;
		default:
	}
}

function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}

function BFind_click()
{
	
	var CardType=getValueById("CardType");
	if(CardType!="C"){
		var RegNo=getValueById("RegNo");
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		if (RegNo.length<RegNoLength&&RegNo.length>0) {RegNo=RegNoMask(RegNo);}
	}else{
		var RegNo=getValueById("RegNo");
	}
	
	var Name=getValueById("Name");
	var Status=getValueById("Status");
	var BeginDate=getValueById("BeginDate");
	var EndDate=getValueById("EndDate");
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAdvancePayment.Find"
			+"&RegNo="+RegNo
			+"&Name="+Name
			+"&Status="+Status
			+"&BeginDate="+BeginDate
			+"&EndDate="+EndDate
			+"&CardType="+CardType;
			
	
	location.href=lnk; 
    
}




var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{		
	}else
	{
		selectrow=-1;	
	}
	
}
document.body.onload = BodyLoadHandler;
