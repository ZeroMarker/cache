/// Description: ѹ�����浥
/// Creator: congyue
/// CreateDate: 2017-12-19
var eventtype="";
var PatOrignin="",PatOrignout="";
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum(); 	 		//ʱ��У��
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	InitReport(recordId);		//����ҳ����Ϣ
	GetAsseInfo();				// ��ֵ��ҳ���������Ϣ cy 2018-04-17
	
});
// ������
function ReportControl(){
	
	//ѹ����λ  ��Դ Ժ����� labelUlcerPart-95158-95163-95170
	$("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrignin=this.value;
		}
	});
	$("input[type=radio][id^='UlcerPart-95158-95163-95171.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrignout=this.value;
		}
	});	
	
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});	
	//��λ 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	})

}

//��ť�����뷽����
function InitButton(){
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //��ʾת�鰴ť
		if(winflag==2){
			/// ������ť��ʾ ��ζ��������Ȩ�ޣ����Թ�·������ʾ��ʿ�����۰�ť
			if($("#AssessmentBut").is(":visible")){ 
				$("#HeadNurEvaBut").show(); //��ʾ���۰�ť 2018-04-13 cy ���۽���
			}
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
		} 
		$("#AssessmentBut").hide(); //2019-07-26  ����ҽ��������û��ԭ������Ļ������͵�������ť
	}
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	//��ʿ������
	var HedNurEvaRecId=""; 
	if(PatOrignin=="Ժ�ڷ���"){
		HedNurEvaRecId=GetAssessRecordID("UlcerHeaNurEvaluate");
	}
	if(PatOrignout=="Ժ�����"){
		HedNurEvaRecId=GetAssessRecordID("UlcOutHeaNurEvaluate");
	}
	$("#HeadNurEvaBut").on("click",function(){ 
		if(PatOrignin=="Ժ�ڷ���"){
			showAssessmentWin("UlcerHeaNurEvaluate",HedNurEvaRecId);
		}
		if(PatOrignout=="Ժ�����"){
			showAssessmentWin("UlcOutHeaNurEvaluate",HedNurEvaRecId);
		}
	})
	// �ƻ�ʿ������
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// ��������
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// ת�����
	$("#PatOutcomBut").on("click",function(){
		showPatOutcomWin("UlcPatOutcomform");
	})
}


//���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');			
	} 
}
//���汣��
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!(checkother()&&checkRequired())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
		return;
	}
	SaveReportCom(flag);
}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	// 2021-05-25 cy str
	runClassMethod("web.DHCADVCOMMON","GetNurMarkInfo",{'EpisodeID':EpisodeID},
	function(Data){ 
		if(Data!=""){
			var dataarr=Data.replace(/(^\s*)|(\s*$)/g,"").split("$$");
			var HospScoreList=dataarr[2]; // ��Ժʱѹ���������ֱ� ^ ����
			var OccScoreList=dataarr[3]; // ����ʱѹ���������ֱ� ^ ����
			var UseUlcerRiskpointtab=HospScoreList.split("^")[0];				// ѹ���������ֱ�
			if((UseUlcerRiskpointtab!="")&&(UseUlcerRiskpointtab!=undefined)){
				RepSetValue("UseUlcerRiskpointtab","radio",UseUlcerRiskpointtab);
				RepSetRead("UseUlcerRiskpointtab","radio",1);
			}else {
				RepSetValue("UseUlcerRiskpointtab","radio","");
				RepSetRead("UseUlcerRiskpointtab","radio",0);
			}
				
			var HospUlcerRiskScore=HospScoreList.split("^")[1];					// ��Ժʱѹ������
	      	if((HospUlcerRiskScore!="")&&(HospUlcerRiskScore!=undefined)){
				RepSetValue("HospUlcerRiskScore","input",HospUlcerRiskScore);
				RepSetRead("HospUlcerRiskScore","input",1);	
				ChkHospUlcerRiskLev(HospUlcerRiskScore);
			}else {
				RepSetValue("HospUlcerRiskScore","input","");
				RepSetRead("HospUlcerRiskScore","input",0);		
			}	
			var OccurUlcerRiskScore=OccScoreList.split("^")[1];					// ����ʱѹ������
	      	if((OccurUlcerRiskScore!="")&&(OccurUlcerRiskScore!=undefined)){
				RepSetValue("OccurUlcerRiskScore","input",OccurUlcerRiskScore);
				RepSetRead("OccurUlcerRiskScore","input",1);		
				ChkOccurUlcerRiskLev(OccurUlcerRiskScore);
			}else {
				RepSetValue("OccurUlcerRiskScore","input","");
				RepSetRead("OccurUlcerRiskScore","input",0);		
			}
		}	
	
	},"text",false);
	// 2021-05-25 cy end
	$("#from").form('validate'); 
	InitCheckRadio();
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	
	//ѹ����λ  ��Դ Ժ����� labelUlcerPart-95158-95163-95170
	var PatOrign="",PatOrignList="",OrignErr="";
	 $("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrign=this.value;
		}
	});
		
	$("input[type=radio][id^='UlcerPart-95158-95163-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id.split("-").length==4){
				var PatOrignList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				PatOrign=this.value;
				
				$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatOrignList=this.value
					}
				});
				if((radiorowid=="UlcerPart-95158-95163-95171")&&(PatOrignList=="")){
					$.messager.alert($g("��ʾ:"),$g("��ѹ����Դ����ѡ��Ժ����롿���빴ѡԺ����Ӧ���ݣ�"));	
					OrignErr=-1;
					return false;
				}		
				
			}
		}
	});
	if (PatOrign==""){
		$.messager.alert($g("��ʾ:"),$g("��ѹ����Դ��δ��ѡ���빴ѡ��Ӧ���ݣ�"));	
		OrignErr=-1;
		return false;
	}
	if(OrignErr=="-1"){
		return false;
	}
	//ѹ����λ ��λ   
	var PatReason="",PartErr=0,radiorownum="";
	$("input[type=radio][id^='UlcerPart-95158-95166-']").each(function(){
		if(this.id.split("-").length==4){
			var PatReasonList="";
			if ($(this).is(':checked')){
				var radiorowid=this.id.split(".")[0];
				radiorownum=this.id.split(".")[1];
				PatReason=this.value;
				$("input[type=checkbox][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatReasonList=this.value
					}
				});
				if((PatReason=="title")&&($("input[name$='.93932."+radiorownum+"'][class='lable-input']").val()=="")){ //UlcerPart-95158-95166-95182
					$.messager.alert($g("��ʾ:"),$g("��ѹ����λ����ѡ����������д��Ӧ���ݣ�"));	
					PartErr=-1;
					return false;
				}		
				if ((PatReason!="��")&&(PatReason!="��β��")&&(PatReason!="title")&&(PatReasonList=="")){
					$.messager.alert($g("��ʾ:"),$g("��ѹ����λ����ѡ'"+PatReason+"'���빴ѡ��Ӧ���ݣ�"));	
					PartErr=-1;
					return false;
				}
				
			 }
		}
	});
	if(PartErr=="-1"){
		return false;
	}
	if(PatReason==""){
		$.messager.alert($g("��ʾ:"),$g("��ѹ����λ��δ��ѡ���ݣ��빴ѡ��Ӧ���ݣ�"));	
		return false;
	}
	
	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//������Դ
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if ((id!="PatOrigin-label-94335")){
				$('#PatAdmADLScore').val(""); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //��ԺʱADL�÷�
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //�����չ�����
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //�����չ�����
				$('#HospUlcerRiskScore').val(""); // ��Ժѹ����������
				$('#HospUlcerRiskScore').css("background-color","#D4D0C8");
				$('#HospUlcerRiskScore').attr("readonly","readonly"); // ��Ժѹ����������
				$("label[data-parref='HospUlcerRiskLev']").css("color","#D4D0C8")
				$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");  // ѹ�����յȼ�
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",true);  // ѹ�����յȼ�
				
			}else{
				$('#PatAdmADLScore').attr("readonly",false); // ��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //�����չ�����
				$('#HospUlcerRiskScore').attr("readonly",false); // ��Ժѹ����������
				$('#HospUlcerRiskScore').css("background-color","#fff");
				$("label[data-parref='HospUlcerRiskLev']").css("color","#000")
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",false);  // ѹ�����յȼ�
			}
		}
	})
	//ѹ����λ  ��Դ
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",false);

	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",true);
	}	
	//����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95173.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",true);
	}
	//���β�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95174.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",true);
	}	
	//�ⲿ
	if($("input[type=radio][id^='UlcerPart-95158-95166-95175.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",true);
	}
	 //��ǰ�ϼ�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95176.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",true);
	}
	//�Ų�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95177.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",true);
	}
	//ϥ��
	if($("input[type=radio][id^='UlcerPart-95158-95166-95179.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",true);
	}
	//�ײ�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95180.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",true);
	}
	//�����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95181.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",true);
	}
	//����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95182.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93730'][class='lable-input']").val("");  //�����������
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}		
}
//��ѡ radio ��Ԫ�ؿ��Թ�ѡ��ȡ����ѡʱ����Ԫ��ȡ����ѡ�Ҳ����Թ�ѡ
function InitRadio(id){
	//��Դ  Ժ����� 
	var radiorowid=id.split(".")[0];
	var radiorownum=id.split(".")[1];
	//ѹ����λ  ��Դ
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.'][id$='"+radiorownum+"']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").removeAttr("checked");
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",true);
	}
	 //��λ 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	if(checkrowid.indexOf("95166")>0){
		if($("input[type=radio][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").is(':checked')){
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").removeAttr("checked");
			if (checkrowid!=="UlcerPart-95158-95166-95182"){
				$("input[name$='.93932."+checkrownum+"'][class='lable-input']").val("");  //�����������
				$("input[name$='.93932."+checkrownum+"'][class='lable-input']").hide();  
			}
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
			$("input[type=checkbox][id^='"+checkrowid+"'][id$='."+checkrownum+"']").attr("disabled",false);
			
		}else{
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
		} 	 
	}
	// ������Դ
	if(id.indexOf("PatOrigin-label")>=0){
		if ((id!="PatOrigin-label-94335")){
				$('#PatAdmADLScore').val(""); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //��ԺʱADL�÷�
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //�����չ�����
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //�����չ�����
				$('#HospUlcerRiskScore').val(""); // ��Ժѹ����������
				$('#HospUlcerRiskScore').css("background-color","#D4D0C8");
				$('#HospUlcerRiskScore').attr("readonly","readonly"); // ��Ժѹ����������
				$("label[data-parref='HospUlcerRiskLev']").css("color","#D4D0C8")
				$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");  // ѹ�����յȼ�
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",true);  // ѹ�����յȼ�
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //�����չ�����
				$('#HospUlcerRiskScore').attr("readonly",false); // ��Ժѹ����������
				$('#HospUlcerRiskScore').css("background-color","#fff");
				$("label[data-parref='HospUlcerRiskLev']").css("color","#000")
				$("input[type=radio][id^='HospUlcerRiskLev-']").attr("disabled",false);  // ѹ�����յȼ�
			}
	}
	
	//ʹ��ѹ�����ֱ�
	if (id.indexOf("UseUlcerRiskpointtab-")>=0){
		$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
		RepSetValue("HospUlcerRiskScore","input","");
		$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
		RepSetValue("OccurUlcerRiskScore","input","");
	}
	
	
}
function InitCheck(id){
	
	
}

//ʱ�� ����У��
function CheckTimeorNum(){
	//��������У��  
	//ѹ����� UlcerPart-95158-95189-94247
	chknum("UlcerPart-95158-95189-94247",1);
	chknum("UlcerPart-95158-95189-94249",1);
	chknum("UlcerPart-95158-95189-94251",1);
	
	// ���� Сʱ
	chknum("OpeDuration",1,0);
	// ʹ��ѹ���������ֱ�  
	// ��Ժѹ���������� 
	chknum("HospUlcerRiskScore",0);
	$('#HospUlcerRiskScore').live("keyup",function(){
		ChkHospUlcerRiskLev(this.value);
	})
		
	// ����ѹ��ʱ��������
	chknum("OccurUlcerRiskScore",0);
	$('#OccurUlcerRiskScore').live("keyup",function(){
		ChkOccurUlcerRiskLev(this.value);
	})

}

function add_event(){
	AllStyle("textarea","",100);
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	CheckTimeorNum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	
	//��Դ  Ժ����� 
	var orign="";
	$("input[type=radio][id^='UlcerPart-95158-95163']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			orign=this.value;
			var list=$("input[type=radio][id^='UlcerPart-95158-95163-95170."+checkrownum+"']:checked").val();
			if((this.id.split("-").length==4)){
				$("input[type=radio][id^='"+checkrowid+".']").click();		
			}else if(this.id.split("-").length==5){
				$("input[type=radio][id^='"+checkrowid+"']").click();
			}
		}
	})
	
	//��λ 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	}) 
}

//���ݿ���1��ѯ����2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //���������������
	});   

}

//���table�еı���
//�����д�˳���ߣ��������Ϣ��Ϊ���������ζ
function checkTableRequired(){
	var errMsg=""
	
	$("#UlcerPart").next().find("tbody tr").each(function(i){
		var rowMsg=""
		// ��Դ
		var str=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(0));
		if(str.length==0){
			rowMsg=rowMsg+"��Դ,"
		}
		// ��λ
		var str1=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(1));
		if(str1.length==0){
			rowMsg=rowMsg+"��λ,"
		}
		// ѹ������
		var str2=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(2));
		if(str2.length==0){
			rowMsg=rowMsg+"ѹ������,"
		}
		// ���
		var str3=$(this).children('td').eq(3).find("input").val()
		if(str3.length==0){
			rowMsg=rowMsg+"���,"
		}
		// ��ɫ
		var str4=$(this).children('td').eq(4).find("input").val()
		if(str4.length==0){
			rowMsg=rowMsg+"��ɫ,"
		}
		// ��ζ
		var str5=$(this).children('td').eq(5).find("input").val()
		if(str5.length==0){
			rowMsg=rowMsg+"��ζ,"
		}
		if((str.length==0)&&(str1.length==0)&&(str2.length==0)&&(str3.length==0)&&(str4.length==0)&&(str5.length==0)){
			rowMsg="";
		}
		if(rowMsg!=""){
			errMsg=errMsg+"\n"+rowMsg+"����Ϊ��."
		}	
	
	})
	if(errMsg!=""){
		//$("html,body").stop(true);$("html,body").animate({scrollTop: $("#UlcerPart").offset().top}, 1000);
		$.messager.alert($g("��ʾ:"),errMsg);
	}
	return errMsg;
}
//2018-04-16 ���۽������ݼ���
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="",OutHeadNurEvaRecId="";	 
	var PatOutcomRecId="";//ת�����¼id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcerHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcOutHeaNurEvaluate"},
	function(data){ 
			 OutHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"UlcPatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	if((HeadNurEvaRecId!="")&&(RepStaus!="�")){SetRepInfo(HeadNurEvaRecId,"UlcerHeaNurEvaluate");}
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="�ƻ�ʿ�����")||(RepStaus=="�������"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="�������")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	if((OutHeadNurEvaRecId!="")&&(RepStaus!="�")){SetRepInfo(OutHeadNurEvaRecId,"UlcOutHeaNurEvaluate");}
	//ת�����ݻ�ȡ
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"UlcPatOutcomform");}
}
//2018-04-16 ���������������ݸ�ֵ
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	if((FormCode=="UlcerHeaNurEvaluate")&&(PatOrignin=="Ժ�ڷ���")){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	if((FormCode=="UlcOutHeaNurEvaluate")&&(PatOrignout=="Ժ�����")){
		SetOutHeadNurInfo(data);
	}
	//ת�����ݸ�ֵ
	if(FormCode=="UlcPatOutcomform"){
		SetPatOutcomInfo(data);
	}
}

function SetHeadNurInfo(data){
	var List="";
	var MornRepMeetDate=$g(data["MornRepMeetDate"]); //���ᱨ������
	if(MornRepMeetDate!=""){List=List+"���ᱨ�����ڣ�"+MornRepMeetDate+"��";}
	var MornRepMeetTime=$g(data["MornRepMeetTime"]); //���ᱨ��ʱ��
	if(MornRepMeetTime!=""){List=List+"���ᱨ��ʱ�䣺"+MornRepMeetTime+"��";}
	var MornRepMeetPlace=$g(data["MornRepMeetPlace"]); //����ص�
	if(MornRepMeetPlace!=""){List=List+"����ص㣺"+MornRepMeetPlace+"��";}
	var MornRepMeetpants=$g(data["MornRepMeetpants"]); //������Ա
	if(MornRepMeetpants!=""){List=List+"������Ա��"+MornRepMeetpants+"��";}
	var MornRepMeetContent=$g(data["MornRepMeetContent"]); //��������
	if(MornRepMeetContent!=""){List=List+"�������ݣ�"+MornRepMeetContent+"��";}
     
	var MeetDate=$g(data["MeetDate"]); //��������
	if(MeetDate!=""){List=List+"\n�������ڣ�"+MeetDate+"��";}
	var MeetTime=$g(data["MeetTime"]); //����ʱ��
	if(MeetTime!=""){List=List+"����ʱ�䣺"+MeetTime+"��";}
	var MeetPlace=$g(data["MeetPlace"]); //����ص�
	if(MeetPlace!=""){List=List+"����ص㣺"+MeetPlace+"��";}
	var Participants=$g(data["Participants"]); //�λ���Ա
	if(Participants!=""){List=List+"�λ���Ա��"+Participants+"��";}

	//�����Ľ�����ӦҪ�ؼ���ԭ��
	var CaseImprovement=$g(data["CaseImprovement"]); 
	if(CaseImprovement!=""){List=List+"\n�����Ľ�����ӦҪ�ؼ���ԭ�򣩣�\n"+CaseImprovement;}
	
	//����Ľ�
	var ManaImprovement=$g(data["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",data); 
	if (ManaImprovement!=""){
		List=List+"\n����Ľ���  �ƶȡ����̼��淶�ƶ����޶���"+ManaImprovementzdoth+"���ƣ�"+ManaImprovement+"����";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",data); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		List=List+"\n����Ľ���"+ManaImprovementoth+"��"
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		List=List+ManaImprovementoth+"��";
	}

	// ��ʿ��Ч������
	var ListHeadNurEva=""; 
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //��ʿ�����۸���
	var HeadNurEvaluateList="��ʿ��Ч�����ۣ�";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>��¼"+(k+1)+"</font>��"
		//var HNElist="\n��¼"+(k+1)+"��"
		var HNEdate=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94393-94398"]); //����ʱ��
		if(HNEdate!=""){HNElist=HNElist+"����ʱ�䣺"+HNEdate+"��";}
		var HNEobject=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94394-94399"]); //�������
		if(HNEobject!=""){HNElist=HNElist+"�������"+HNEobject+"��";}
		var HNEcontent=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94395-94400"]); //��������
		if(HNEcontent!=""){HNElist=HNElist+"�������ݣ�"+HNEcontent+"��";}		
		var HNEresult=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94396-94401"]); //������
		if(HNEresult!=""){HNElist=HNElist+"��������"+HNEresult+"��";}		
		var HNEpeople=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94397-94403"]); //������
		if(HNEpeople!=""){HNElist=HNElist+"�����ˣ�"+HNEpeople+"��";}		
		HeadNurEvaluateList=HeadNurEvaluateList+HNElist
	}
	if(HeadNurEvaluateList!=""){ListHeadNurEva=ListHeadNurEva+HeadNurEvaluateList;}
	
	var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",data); 
	if(AftImpMeasures!=""){List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����"+AftImpMeasures+"��";}
	var AftImpMeasuresoth=$g(data["AftImpMeasures-94925-94927"]);  //δ��ʵ δ��ʵԭ�� 
	if ((AftImpMeasuresoth!="")){
		List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+AftImpMeasuresoth+"��";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n�����¼��д��"+ManaIfStandard+"��";}
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);
}
//Ժ��ѹ��
function SetOutHeadNurInfo(data)
{
	var List="";
	var MornRepMeetDate=$g(data["MornRepMeetDate"]); //���ᱨ������
	if(MornRepMeetDate!=""){List=List+"���ᱨ�����ڣ�"+MornRepMeetDate+"��";}
	var MornRepMeetTime=$g(data["MornRepMeetTime"]); //���ᱨ��ʱ��
	if(MornRepMeetTime!=""){List=List+"���ᱨ��ʱ�䣺"+MornRepMeetTime+"��";}
	var MornRepMeetPlace=$g(data["MornRepMeetPlace"]); //����ص�
	if(MornRepMeetPlace!=""){List=List+"����ص㣺"+MornRepMeetPlace+"��";}
	var MornRepMeetpants=$g(data["MornRepMeetpants"]); //������Ա
	if(MornRepMeetpants!=""){List=List+"������Ա��"+MornRepMeetpants+"��";}
	var MornRepMeetContent=$g(data["MornRepMeetContent"]); //��������
	if(MornRepMeetContent!=""){List=List+"�������ݣ�"+MornRepMeetContent+"��";}
     
	var MeetDate=$g(data["MeetDate"]); //��������
	if(MeetDate!=""){List=List+"\n�������ڣ�"+MeetDate+"��";}
	var MeetTime=$g(data["MeetTime"]); //����ʱ��
	if(MeetTime!=""){List=List+"����ʱ�䣺"+MeetTime+"��";}
	var MeetPlace=$g(data["MeetPlace"]); //����ص�
	if(MeetPlace!=""){List=List+"����ص㣺"+MeetPlace+"��";}
	var Participants=$g(data["Participants"]); //�λ���Ա
	if(Participants!=""){List=List+"�λ���Ա��"+Participants+"��";}
	//ԭ�����
	var CauseAnalysis=$g(data["CauseAnalysis-text"]); 
	if(CauseAnalysis!=""){List=List+"\n ԭ�������\n"+CauseAnalysis;}
   
	//�����Ľ�����ӦҪ�ؼ���ԭ��
	var CaseImprovement=$g(data["CaseImprovement"]); 
	if(CaseImprovement!=""){List=List+"\n�����Ľ�����ӦҪ�ؼ���ԭ�򣩣�\n"+CaseImprovement;}

	//����Ľ�
	var ManaImprovement=$g(data["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",data); 
	if (ManaImprovement!=""){
		List=List+"\n����Ľ���  �ƶȡ����̼��淶�ƶ����޶���"+ManaImprovementzdoth+"���ƣ�"+ManaImprovement+"����";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",data); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		List=List+"\n����Ľ���"+ManaImprovementoth+"��"
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		List=List+ManaImprovementoth+"��";
	}	

	// ��ʿ��Ч������
	var ListHeadNurEva=""; 
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //��ʿ�����۸���
	var HeadNurEvaluateList="��ʿ��Ч�����ۣ�";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>��¼"+(k+1)+"</font>��"
		//var HNElist="\n��¼"+(k+1)+"��"
		var HNEdate=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94393-94398"]); //����ʱ��
		if(HNEdate!=""){HNElist=HNElist+"����ʱ�䣺"+HNEdate+"��";}
		var HNEobject=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94394-94399"]); //�������
		if(HNEobject!=""){HNElist=HNElist+"�������"+HNEobject+"��";}
		var HNEcontent=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94395-94400"]); //��������
		if(HNEcontent!=""){HNElist=HNElist+"�������ݣ�"+HNEcontent+"��";}		
		var HNEresult=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94396-94401"]); //������
		if(HNEresult!=""){HNElist=HNElist+"��������"+HNEresult+"��";}		
		var HNEpeople=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94397-94403"]); //������
		if(HNEpeople!=""){HNElist=HNElist+"�����ˣ�"+HNEpeople+"��";}		
		HeadNurEvaluateList=HeadNurEvaluateList+HNElist
	}
	if(HeadNurEvaluateList!=""){ListHeadNurEva=ListHeadNurEva+HeadNurEvaluateList;}
	
	var UlcNurImpMeasures=radioValue("UlcNurImpMeasures-label-94930,UlcNurImpMeasures-label-94931",data); 
	if(UlcNurImpMeasures!=""){List=List+"\nԺ��ѹ���������ʩ��ʵЧ����"+UlcNurImpMeasures+"��";}
	var UlcNurImpMeasuresoth=$g(data["UlcNurImpMeasures-label-94932-94933"]);  //δ��ʵ δ��ʵԭ�� 
	if ((UlcNurImpMeasuresoth!="")){
		List=List+"\nԺ��ѹ���������ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+UlcNurImpMeasuresoth+"��";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n�����¼��д��"+ManaIfStandard+"��";}
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});		
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);
}
//2018-05-09 ת����Ϣ��ֵ
function SetPatOutcomInfo(data)
{
	var List="";
	//����ת�� UlcPatOutcom
	var UlcPatOutcom=$g(data["UlcPatOutcom"]);
	var UlcPatOutcomlen=UlcPatOutcom.length; //��ʿ�����۸���
	var UlcPatOutcomList="";
	for(var k=0;k<UlcPatOutcomlen;k++){
		var POlist="\n��¼"+(k+1)+"��"
		var POpart=$g(UlcPatOutcom[k]["UlcPatOutcom-94937-94940-94943"]); //ѹ����λ
		if(POpart!=""){POlist=POlist+"ѹ����λ��"+POpart+"��";}  
		var POobject=$g(radioValue("UlcPatOutcom-94937-94942-94944,UlcPatOutcom-94937-94942-94945,UlcPatOutcom-94937-94942-94946,UlcPatOutcom-94937-94942-94947",UlcPatOutcom[k])); //����ת��
		if(POobject!=""){POlist=POlist+"����ת�飺"+POobject+"��";}
		UlcPatOutcomList=UlcPatOutcomList+POlist
	}
	if(UlcPatOutcomList!=""){List=List+UlcPatOutcomList;}
	var POrow=0
	var POList=List.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(List);

}
function ChkHospUlcerRiskLev(value){
	RepSetRead("HospUlcerRiskLev-","radio",0);
	if($("input[type=radio][id='UseUlcerRiskpointtab-94929']").is(':checked')){  // Braden
		if((value>18)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Braden' ��������1-18������"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value<=9)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// ����Σ
		}
		if((value>=10)&&(value<=12)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // ��Σ	
		}
		if((value>=13)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94938']").click();	 // ��Σ
		}
		if((value>=15)&&(value<=18)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // ��Σ
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94930']").is(':checked')){  // Norton 
		if((value>14)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Norton' ��������1-14������"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value<=8)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// ����Σ
		}
		if((value>8)&&(value<=12)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // ��Σ	
		}
		if((value>12)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // ��Σ
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94931']").is(':checked')){  // Waterlow 
		if((value>100)||(value=="")||(value<1)){
			$("input[type=radio][id^='HospUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Waterlow' ��������1-100������"));
			}
			RepSetValue("HospUlcerRiskScore","input","");
		}else if((value>=20)){
			$("input[type=radio][id^='HospUlcerRiskLev-94936']").click();	// ����Σ
		}
		if((value>=15)&&(value<=19)){
			$("input[type=radio][id^='HospUlcerRiskLev-94937']").click();  // ��Σ	
		}
		if((value>=1)&&(value<=14)){
			$("input[type=radio][id^='HospUlcerRiskLev-94939']").click();	 // ��Σ
		}
		RepSetRead("HospUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94932']").is(':checked')){  // ����
		
	}else{
		$.messager.alert($g("��ʾ:"),$g("�빴ѡ��ʹ��ѹ���������ֱ�"));
	}
}
function ChkOccurUlcerRiskLev(value){
	RepSetRead("OccurUlcerRiskLev-","radio",0);
	if($("input[type=radio][id='UseUlcerRiskpointtab-94929']").is(':checked')){  // Braden
		if((value>18)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Braden' ��������1-18������"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value<=9)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// ����Σ
		}
		if((value>=10)&&(value<=12)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // ��Σ	
		}
		if((value>=13)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94945']").click();	 // ��Σ
		}
		if((value>=15)&&(value<=18)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // ��Σ
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94930']").is(':checked')){  // Norton 
		if((value>14)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Norton' ��������1-14������"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value<=8)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// ����Σ
		}
		if((value>8)&&(value<=12)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // ��Σ	
		}
		if((value>12)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // ��Σ
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94931']").is(':checked')){  // Waterlow 
		if((value>100)||(value=="")||(value<1)){
			$("input[type=radio][id^='OccurUlcerRiskLev-']").removeAttr("checked");
			if(value!=""){
				$.messager.alert($g("��ʾ:"),$g("��ʹ��ѹ���������ֱ���ѡ'Waterlow' ��������1-100������"));
			}
			RepSetValue("OccurUlcerRiskScore","input","");
		}else if((value>=20)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94943']").click();	// ����Σ
		}
		if((value>=15)&&(value<=19)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94944']").click();  // ��Σ	
		}
		if((value>=1)&&(value<=14)){
			$("input[type=radio][id^='OccurUlcerRiskLev-94946']").click();	 // ��Σ
		}
		RepSetRead("OccurUlcerRiskLev-","radio",1);
	}else if($("input[type=radio][id='UseUlcerRiskpointtab-94932']").is(':checked')){  // ����
		
	}else{
		$.messager.alert($g("��ʾ:"),$g("�빴ѡ��ʹ��ѹ���������ֱ�"));
	}
}
