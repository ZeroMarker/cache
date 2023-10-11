/// Description: �����¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  			//ʱ��У��
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	InitReport(recordId);		//����ҳ����Ϣ
	GetAsseInfo();				// ��ֵ��ҳ���������Ϣ
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
	// ��ʿ������
	var HedNurEvaRecId=GetAssessRecordID("AccidentHeaNurEvaluate");  
	$("#HeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("AccidentHeaNurEvaluate",HedNurEvaRecId);
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
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
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

	//�¼���ɵĽ��
	var AFResultoth=0,AFResult="",AFResultList="";
	$("input[type=checkbox][id='AFResult-94566']").each(function(){
		if ($(this).is(':checked')){
			AFResult=this.value;
		}
	})
	if(AFResult=="����סԺ����"){
		$("input[type=radio][id^='AFResult-94566']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				AFResultList=this.value
			}
		})
		if (AFResultList==""){
			$.messager.alert($g("��ʾ:"),$g("���¼���ɵĽ������ѡ'����סԺ����'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='AFResult-94567']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94097'][class='lable-input']").val()=="")){
				AFResultoth=-1; 
			}
		}
	})
	if(AFResultoth==-1){
		$.messager.alert($g("��ʾ:"),$g("���¼���ɵĽ������ѡ'����'������д���ݣ�"));	
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
	//�¼���ɵĽ��   ��
	$("input[type=checkbox][id^='AFResult-']").each(function(){
		$(this).click(function(){
			if(this.id=='AFResult-94565'){
				$('#AFResult-94566').removeAttr("checked");
				$("input[type=radio][id^='AFResult-94566-']").removeAttr("checked");
				$('#AFResult-94567').removeAttr("checked");
				$('#AFResult-94567').nextAll(".lable-input").hide();
			}else{
				$('#AFResult-94565').removeAttr("checked");
			}
					//�¼���ɵĽ��   ����סԺ����
			if($('#AFResult-94566').is(':checked')){
				$("input[type=radio][id^='AFResult-94566-']").attr("disabled",false);
			}else{
				$("input[type=radio][id^='AFResult-94566-']").removeAttr("checked");
				$("input[type=radio][id^='AFResult-94566-']").attr("disabled",true);
			}
		});
	});
}
//ʱ�� ����У��
function CheckTimeorNum(){	
	//��������У��  
	
}


//2018-04-16 ���۽������ݼ���
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//ת�����¼id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"AccidentHeaNurEvaluate"},
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
	if((HeadNurEvaRecId!="")&&(RepStaus!="�")){SetRepInfo(HeadNurEvaRecId,"AccidentHeaNurEvaluate");}
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
	
	if(FormCode=="AccidentHeaNurEvaluate"){
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

function SetHeadNurInfo(data)
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
	var ListHeadNurEva="";                       // ��ʿ��Ч�����ۼӴ�����
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
