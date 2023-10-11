/// Description: ����(׹��)�¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-18
var eventtype=""
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  			//ʱ��У��
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	InitReport(recordId);		//����ҳ����Ϣ
	GetAsseInfo();				// ��ֵ��ҳ���������Ϣ  cy 2018-04-17
});
// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
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
	// ��ʿ������
	var HedNurEvaRecId=GetAssessRecordID("FDHeaNurEvaluate");  
	$("#HeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("FDHeaNurEvaluate",HedNurEvaRecId);
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
		showPatOutcomWin("PatOutcomform");
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
	var falltype=0;
	$("input[type=radio][id^='FallDownType-']").each(function(){
		if($(this).is(':checked')){
				falltype=this.value;
		}
	})
	if(falltype==""){
		$.messager.alert($g("��ʾ:"),$g("���������͡�����Ϊ�գ�"));	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){

	//����ԭ��(�ɶ�ѡ)  �������� 
	var PatReasonoth=0,PatReason="",PatReasonList="";
	$("input[type=checkbox][id='OccurReason-95068']").each(function(){
		if ($(this).is(':checked')){
			PatReason=this.value;
		}
	})
	if(PatReason=="��������"){
		$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatReasonList=this.value
			}
		})
		if (PatReasonList==""){
			$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'��������'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93730'][class='lable-input']").val()=="")){
				PatReasonoth=-1; 
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'��������  ����'������д���ݣ�"));	
		return false;
	}

	//����ԭ��(�ɶ�ѡ)  ҩ������  
	var DrugReasonoth=0,DrugReason="",DrugReasonList="";
	$("input[type=checkbox][id='OccurReason-95069']").each(function(){
		if ($(this).is(':checked')){
			DrugReason=this.value;
		}
	})
	if(DrugReason=="ҩ������"){
		$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugReasonList=this.value
			}
		})
		if (DrugReasonList==""){
			$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'ҩ������'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93739'][class='lable-input']").val()=="")){
				DrugReasonoth=-1; 
			}
		}
	})
	if(DrugReasonoth==-1){
		$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'ҩ������  ����'������д���ݣ�"));	
		return false;
	}

	//����ԭ��(�ɶ�ѡ)  ��������  
	var ManageReasonoth=0,ManageReason="",ManageReasonList="";
	$("input[type=checkbox][id='OccurReason-95070']").each(function(){
		if ($(this).is(':checked')){
			ManageReason=this.value;
		}
	})
	if(ManageReason=="��������"){
		$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				ManageReasonList=this.value
			}
		})
		if (ManageReasonList==""){
			$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'��������'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93746'][class='lable-input']").val()=="")){
				ManageReasonoth=-1; 
			}
		}
	})
	if(ManageReasonoth==-1){
		$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'��������  ����'������д���ݣ�"));	
		return false;
	}
	//����ԭ��(�ɶ�ѡ)  ��������  
	var OccurReasonoth=0;
	$("input[type=checkbox][id^='OccurReason-95071']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93747'][class='lable-input']").val()=="")){
				OccurReasonoth=-1; 
			}
		}
	})
	if(OccurReasonoth==-1){
		$.messager.alert($g("��ʾ:"),$g("������ԭ��(�ɶ�ѡ)����ѡ'��������'������д���ݣ�"));	
		return false;
	}
	
	//������
	var DiscoverManoth=0;
	$("input[type=radio][id^='DiscoverMan']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94080']").val()=="")){
				DiscoverManoth=-1;
			}
		}
	})
	if(DiscoverManoth==-1){
		$.messager.alert($g("��ʾ:"),$g("�������ˡ���ѡ'������Ա'������д���ݣ�"));	
		return false;
	}
	
	//����/׹���¼���ɵĽ��   ����סԺ����
	var FDResult="",FDResultList="";
	$("input[type=checkbox][id='FDResult-95132']").each(function(){
		if ($(this).is(':checked')){
			FDResult=this.value;
		}
	})
	if(FDResult=="����סԺ����"){
		$("input[type=radio][id^='FDResult-95132-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				FDResultList=this.value
			}
		})
		if (FDResultList==""){
			$.messager.alert($g("��ʾ:"),$g("������/׹���¼���ɵĽ������ѡ'����סԺ����'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	//����/׹���¼��� ��������  
	var FDResultoth=0;
	$("input[type=checkbox][id^='FDResult']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94245'][class='lable-input']").val()=="")){
				FDResultoth=-1; 
			}
		}
	})
	if(FDResultoth==-1){
		$.messager.alert($g("��ʾ:"),$g("������/׹���¼���ɵĽ������ѡ'����'������д���ݣ�"));	
		return false;
	}
	
	//���������¼�������
	var PatEventProoth=0,PatEventPro="",PatEventProList="";
	$("input[type=checkbox][id='PatEventProcess-95021']").each(function(){
		if ($(this).is(':checked')){
			PatEventPro=this.value;
		}
	})
	if(PatEventPro=="����֪ͨ"){
		$("input[type=checkbox][id^='PatEventProcess-95021']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatEventProList=this.value
			}
		})
		if (PatEventProList==""){
			$.messager.alert($g("��ʾ:"),$g("�����������¼�����������ѡ'����֪ͨ'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PatEventProcess-95033']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94100'][class='lable-input']").val()=="")){
				PatEventProoth=-1; 
			}
		}
	})
	$("input[type=checkbox][id^='PatEventProcess-95034']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94101'][class='lable-input']").val()=="")){
				PatEventProoth=-2; 
			}
		}
	})
	if(PatEventProoth==-1){
		$.messager.alert($g("��ʾ:"),$g("�����������¼�����������ѡ'ҽ�ƻ����ʩ'������д���ݣ�"));	
		return false;
	}
	if(PatEventProoth==-2){
		$.messager.alert($g("��ʾ:"),$g("�����������¼�����������ѡ'����'������д���ݣ�"));	
		return false;
	}
	
	return true;
}
//��ѡ radio ��Ԫ�ؿ��Թ�ѡ��ȡ����ѡʱ����Ԫ��ȡ����ѡ�Ҳ����Թ�ѡ
function InitRadio(id){

	if(id.indexOf("PatOrigin-label")>=0){
		if ((id!="PatOrigin-label-94335")){
			$('#PatAdmADLScore').val(""); //��ԺʱADL�÷�
			$('#PatAdmADLScore').css("background-color","#D4D0C8");
			$('#PatAdmADLScore').attr("readonly","readonly"); //��ԺʱADL�÷�
			$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //�����չ�����
			$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //�����չ�����
		}else{
			$('#PatAdmADLScore').attr("readonly",false); //��ԺʱADL�÷�
			$('#PatAdmADLScore').css("background-color","#fff");
			$("label[data-parref='PatSelfCareAbility']").css("color","#000")
			$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //�����չ�����
		}
	}
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
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //�����չ�����
			}
		}
	})
	
	//����ԭ��(�ɶ�ѡ)  ��������
	if($('#OccurReason-95068').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95068-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93730'][class='lable-input']").val("");  //�����������
	}
	
	//����ԭ��(�ɶ�ѡ)  ҩ������
	if($('#OccurReason-95069').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95069-']").attr("disabled",false);
		$("input[name$='.93739'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93739'][class='lable-input']").val("");  //�����������
	}
	
	//����ԭ��(�ɶ�ѡ)  ��������
	if($('#OccurReason-95070').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95070-']").attr("disabled",false);
		$("input[name$='.93746'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93746'][class='lable-input']").val("");  //�����������
	}
	//����/׹���¼���ɵĽ��   ��
	$("input[type=checkbox][id^='FDResult-']").each(function(){
		$(this).click(function(){
			if(this.id=='FDResult-95131'){
				$('#FDResult-95132').removeAttr("checked");
				$("input[type=radio][id^='FDResult-95132-']").removeAttr("checked");
				$('#FDResult-95134').removeAttr("checked");
				$('#FDResult-94245').removeAttr("checked");
				$('#FDResult-94245').nextAll(".lable-input").hide();
			}else{
				$('#FDResult-95131').removeAttr("checked");
			}
					//����/׹���¼���ɵĽ��   ����סԺ����
			if($('#FDResult-95132').is(':checked')){
				$("input[type=radio][id^='FDResult-95132-']").attr("disabled",false);
			}else{
				$("input[type=radio][id^='FDResult-95132-']").removeAttr("checked");
				$("input[type=radio][id^='FDResult-95132-']").attr("disabled",true);
			}
		});
	});
}
//ʱ�� ����У��
function CheckTimeorNum(){
	
}

//���ݿ���1��ѯ����2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //���������������
	});   

}
//2018-04-16 ���۽������ݼ���
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//ת�����¼id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"FDHeaNurEvaluate"},
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
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"PatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	if(HeadNurEvaRecId!=""){SetRepInfo(HeadNurEvaRecId,"FDHeaNurEvaluate");}//&&(RepStaus!="�")
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="�ƻ�ʿ�����")||(RepStaus=="�������"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="�������")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	//ת�����ݻ�ȡ
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"PatOutcomform");}
}
//2018-04-16 ���������������ݸ�ֵ
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	if(FormCode=="FDHeaNurEvaluate"){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	//ת�����ݸ�ֵ
	if(FormCode=="PatOutcomform"){
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
	//����ת�� PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	if(PatOutcom!=""){List=List+"\n ����ת�飺"+PatOutcom;}

	var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",data); 
	if(AftImpMeasures!=""){List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����"+AftImpMeasures+"��";}
	var AftImpMeasuresoth=$g(data["AftImpMeasures-94925-94927"]);  //δ��ʵ δ��ʵԭ�� 
	if ((AftImpMeasuresoth!="")){
		List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+AftImpMeasuresoth+"��";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n�����¼��д��"+ManaIfStandard+"��";}
	// ��ʿ��Ч������
	var ListHeadNurEva="";
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //��ʿ�����۸���
	var HeadNurEvaluateList="��ʿ��Ч�����ۣ�";
	for(var k=0;k<HeadNurEvaluatelen;k++){ 
		var HNElist="\n<font style='font-Weight:bold;'>��¼"+(k+1)+"</font>��"
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
		

	


	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
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
	//����ת�� PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	var POrow=0
	var POList=PatOutcom.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow+1)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(PatOutcom);

}
