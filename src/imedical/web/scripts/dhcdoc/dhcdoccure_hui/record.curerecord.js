var cureItemList;
var cureAppId="";
$(document).ready(function(){
	var DCAARowId=$('#DCAARowId').val();
	var DCRRowId=$('#DCRRowId').val();
	var OEORERowID=$('#OEORERowID').val();
	if((DCAARowId=="")&&(DCRRowId=="")&&(OEORERowID=""))return;
	InitEvent();
	PageHandle();
	CureRecordInfoLoad();
	 
});

function InitEvent(){
	$('#btnSave').click(SaveCureRecord);	
}

function PageHandle(){
	var DCRRowId=$('#DCRRowId').val();
	if(DCRRowId==""){
		var trs = $("tr[class='ifhidden']"); 
		for(i = 0; i < trs.length; i++){ 
			trs[i].style.display = "none"; //�����ȡ��trs[i]��DOM���������jQuery������˲���ֱ��ʹ��hide()���� 
		}
	}	
}

function InitDate(){
    var CurDay=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Common",
		MethodName:"GetCurrendDateTime",
		dataType:"text"   
	},false);
    $("#DCRCureDate").datetimebox('setValue',CurDay);		
}

function CureRecordInfoLoad(){
	var DCRRowId=$('#DCRRowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var OEORERowID=$('#OEORERowID').val();
	var ret="";
	if(DCRRowId!=""){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"GetCureRecord",
			'DCRRowId':DCRRowId,
		},function(objScope){
			if (objScope=="") return;
			SetValue(objScope);
		})
	}else if((DCAARowId!="")||(OEORERowID!="")){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Record",
			MethodName:"GetCureRecordByDCA",
			'AppArriveDR':DCAARowId,
			'SpecFlag':"",
			'OEORERowID':OEORERowID,
			'HospId':session['LOGON.HOSPID']
		},function(objScope){
			if (objScope=="") return;
			SetValue(objScope);
		})
	}
	
	
}
function SetValue(val){
	if (val=="") return;
	var TempArr=val.split("^");
	var DCRTitle=TempArr[2];
	var DCRContent=TempArr[3];
	var CreateUser=TempArr[5];
	var CreateDate=TempArr[6];
	var UpdateUser=TempArr[8];
	var UpdateDate=TempArr[9];
	var DCRCureDate=TempArr[11];
	var DCRResponse=TempArr[12];
	var DCREffect=TempArr[13];
	var DCRDoseage=TempArr[14];
	var DCRCureEndDate=TempArr[15];
	$("#DCRTitle").val(DCRTitle);
	$("#DCRContent").val(DCRContent);
	$("#CreateUser").val(CreateUser);
	$("#CreateDate").val(CreateDate);
	$("#UpdateUser").val(UpdateUser);
	$("#UpdateDate").val(UpdateDate);	
	$("#DCRCureDate").datetimebox('setValue',DCRCureDate);
	$("#DCRCureEndDate").datetimebox('setValue',DCRCureEndDate);
	$("#DCRResponse").prop("innerText",DCRResponse);	
	$("#DCREffect").prop("innerText",DCREffect);	
	$("#DCRDosage").prop("innerText",DCRDoseage);	
 	if(DCRCureDate==""){
		InitDate();
	}
}
function SaveCureRecord()
{
    var OperateType=$('#OperateType').val();;
    if(OperateType!="ZLYS"){
	   	$.messager.alert("��ʾ","ֻ������ҽʦ�ſ��޸����Ƽ�¼");
		return; 
	}
	var DCRRowId=$('#DCRRowId').val();
	var DCAARowId=$('#DCAARowId').val();
	var OEORERowID=$('#OEORERowID').val();
	var source=$('#source').val();
    if((DCAARowId=="")&&(DCRRowId=="")&&(OEORERowID==""))return;
    var regS = new RegExp("\\^","g");
	var DCRTitle=$("#DCRTitle").val();
	DCRTitle=DCRTitle.replace(regS,"")
	if (DCRTitle==""){
		$.messager.alert("��ʾ","���Ʊ��ⲻ��Ϊ��");
		return;
	}
	var DCRContent=$("#DCRContent").val();
	DCRContent=DCRContent.replace(regS,"")
	if (DCRContent==""){
		$.messager.alert("��ʾ","���Ƽ�¼����Ϊ��");
		return;
	}
	var DCRCureDate=$("#DCRCureDate").datetimebox('getValue');
	if (DCRCureDate=="")
	{
		$.messager.alert("��ʾ","���ƿ�ʼʱ�䲻��Ϊ��");
		return;
	}
	var DCRCureEndDate=$("#DCRCureEndDate").datetimebox('getValue');
	if (DCRCureEndDate=="")
	{
		$.messager.alert("��ʾ","���ƽ���ʱ�䲻��Ϊ��");
		return;
	}
	var DCRDosage="";
	var DCRResponse="",DCREffect="";
	/* var DCRDosage=$("#DCRDosage").val();
	DCRDosage=DCRDosage.replace(regS,"")
	if (DCRDosage=="")
	{
		//$.messager.alert("��ʾ","���Ʋ�������Ϊ��");
		//return;
	}*/
	
	var DCRResponse=$("#DCRResponse").val();
	DCRResponse=DCRResponse.replace(regS,"")
	if (DCRResponse==""){
		$.messager.alert("��ʾ","���Ʒ�Ӧ����Ϊ��");
		return;
	}
	var DCREffect=$("#DCREffect").val();
	DCREffect=DCREffect.replace(regS,"")
	if (DCREffect==""){
		$.messager.alert("��ʾ","����Ч������Ϊ��");
		return;
	}
	var Para=DCRRowId+"^"+DCAARowId+"^"+DCRTitle+"^"+DCRContent+"^"+session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+OEORERowID;
	var Para=Para+"^"+DCRCureDate+"^"+DCRDosage+"^"+DCRResponse+"^"+DCREffect+"^"+DCRCureEndDate;
	//alert(Para);
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Record",
		MethodName:"SaveCureRecord",
		'Para':Para,
	},function(value){
		if(value==0){
			$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
			if(source=="exec"){
				if (websys_showModal("options")) {
					if (websys_showModal("options").CallBackFunc) {
						websys_showModal("options").CallBackFunc(true);
					}else{
						websys_showModal("close");
					}
					
				}else{
					window.returnValue = true;
					window.close();	
				}
			}else{
				websys_showModal("close");
			}
		}else if(value=="100"){
			$.messager.alert('����','����ʧ��,�������Ƽ�¼,����ѡ��һ��ԤԼ��¼');
		}else if(value=="101"){
			$.messager.alert('����','����ʧ��,����ʧ��,һ��ԤԼ�������һ�����Ƽ�¼');
		}else if(value=="102"){
			$.messager.alert('����','����ʧ��,ԤԼ��¼û�ж�Ӧ��ִ�м�¼,����������');
			
		}else if(value=="103"){
			$.messager.alert('����','����ʧ��,��ȡ��ԤԼ�Ĳ��ܹ�������Ƽ�¼');
		}else if(value=="104"){
			$.messager.alert('����','����ʧ��,���ƿ�ʼʱ�䲻���������ƽ���ʱ��');
		}else if(value=="-303"){
			$.messager.alert('����','����ʧ��,��ԤԼ��¼�ѱ�ִ��!');
		}else{
			errmsg='����ʧ��'+",�������:"+value
			$.messager.alert('����',errmsg);
		}
	})
}
