/// Description: ��·���ѱ��浥
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  			//ʱ��У��
	InitReport(recordId);		//����ҳ����Ϣ
	GetAsseInfo();				// ��ֵ��ҳ���������Ϣ  cy 2018-04-17
});
// ������
function ReportControl(){
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// ��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	// �ù����ڿ���
	chkdate("TubeDate");
	
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
	var HedNurEvaRecId=GetAssessRecordID("POHeaNurEvaluate");
	$("#HeadNurEvaBut").on("click",function(){
		showAssessmentWin("POHeaNurEvaluate",HedNurEvaRecId);
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
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
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
	
	// ���߼����Ƿ�������·�����¼� ����
	if($("input[type=radio][id='PipeOther-94517-94527']").is(':checked')){
		var PipeOthNum=$('#lablePipeOther-94517-94527 input:last-child').val();
		var TextNum=PipeOthNum.replace(/\D/g,'');
		if(TextNum.indexOf(".")< 0 && TextNum !=""){//�˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
	    	TextNum= parseInt(TextNum); 
	    } 
	    if(((PipeOthNum+"")!=(TextNum+""))||(TextNum<2)){
		    $.messager.alert("��ʾ:","�����߼����Ƿ�������·�����¼�����ѡ'����'��������д���淶,����д����1��������");	
			return false;
		}

	}	
	//��ȡ��ʩ
	var PipeTakeStepsoth=0;
	$("input[type=checkbox][id^='PipeTakeSteps']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93859'][class='lable-input']").val()=="")){
				PipeTakeStepsoth=-1;
			}
			if((this.value=="����Լ��")&&($("#PipeTakeSteps-94536-94258").val()=="")){
				PipeTakeStepsoth=-2;
			}
		}	
	})
	if(PipeTakeStepsoth==-2){
		$.messager.alert("��ʾ:","����ȡ��ʩ����ѡ'����Լ��'������д���ݣ�");	
		return false;
	}
	if(PipeTakeStepsoth==-1){
		$.messager.alert("��ʾ:","����ȡ��ʩ����ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//����֢ 
	var PipeComploth=0,PipeCompl="",PipeList="";
	$("input[type=radio][id='PipeComplication-94540']").each(function(){
		if ($(this).is(':checked')){
			PipeCompl=this.value;
		}
	})
	if(PipeCompl=="��"){
		$("input[type=checkbox][id^='PipeComplication-94540']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PipeList=this.value
			}
		})
		if (PipeList==""){
			$.messager.alert("��ʾ:","������֢����ѡ'��'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PipeComplication-94540-94541']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93546'][class='lable-input']").val()=="")){
				PipeComploth=-1; //��ѪΪ��
			}
		}
	})
	
	if(PipeComploth==-1){
		$.messager.alert("��ʾ:","������֢����ѡ'��Ѫ'������д���ݣ�");	
		return false;
	}
	$("input[type=checkbox][id^='PipeComplication-94540-94548']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93553'][class='lable-input']").val()=="")){
				PipeComploth=-2; //��������Ϊ��
			}
		}	
	})
	if(PipeComploth==-2){
		$.messager.alert("��ʾ:","������֢����ѡ'����'������д���ݣ�");	
		return false;
	}
	// ������֢�� '��Ѫ'
	var PipeCompNum=$('#lablePipeComplication-94540-94541 input:last-child').val()==undefined?"":$('#lablePipeComplication-94540-94541 input:last-child').val();
	if(PipeCompNum!=""){
		var TextNum=PipeCompNum.replace(/\D/g,'');
		if(TextNum.indexOf(".")< 0 && TextNum !=""){//�˴����Ƶ������û��С���㣬��λ����Ϊ������ 01��02�Ľ�� 
	    	TextNum= parseInt(TextNum); 
	    } 
	    if(((PipeCompNum+"")!=(TextNum+""))||(TextNum<1)){
		    $.messager.alert("��ʾ:","������֢����ѡ'��Ѫ'��������д���淶,����д����0��������");	
			return false;
		}

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
	/// �¼�����ʱ����������ڳ�  ��ѡ "��" "��֪��"ʱ ��ղ����� "����"�����
	if(id.indexOf("AccompnayNear-")>=0){
		if((id=="AccompnayNear-94998")||(id=="AccompnayNear-94999")){
			$("#AccompnayNear-94991-94996").nextAll(".lable-input").val("");
			$("#AccompnayNear-94991-94996").nextAll(".lable-input").hide();
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
	
}
//ʱ�� ����У��
function CheckTimeorNum(){
	//��ԺʱADL�÷�
	chknum("PatAdmADLScore",1,0,100);
	$('#PatAdmADLScore').live("keyup",function(){
		RepSetRead("PatSelfCareAbility-","radio",0);  //�����չ�����
		if((this.value>100)||(this.value=="")){
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
		}
		RepSetRead("PatSelfCareAbility-","radio",1);  //�����չ�����
	})
	//����ǰADL�÷�
	chknum("OccurADLScore",1,0,100);
	$('#OccurADLScore').live("keyup",function(){
		RepSetRead("OccurPatSelfCareAbility-","radio",0);  //�����չ�����
		if((this.value>100)||(this.value=="")){
			$("input[type=radio][id^='OccurPatSelfCareAbility-']").removeAttr("checked");
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94240']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94241']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='OccurPatSelfCareAbility-94239']").click();	
		}
		RepSetRead("OccurPatSelfCareAbility-","radio",1);  //�����չ�����
	})
	// Ramsay ����
	chknum("consciousState-94977",1,0,100);
	// RASS����
	chknum("consciousState-94978",1,0,100);	

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
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"POHeaNurEvaluate"},
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
	if((HeadNurEvaRecId!="")&&(RepStaus!="�")){SetRepInfo(HeadNurEvaRecId,"POHeaNurEvaluate");}
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
	if(FormCode=="POHeaNurEvaluate"){
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

	// ��ʿ��Ч������
	var ListHeadNurEva="";                       // ��ʿ��Ч�����ۼӴ�����
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //��ʿ�����۸���
	var HeadNurEvaluateList="��ʿ��Ч�����ۣ�";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>��¼"+(k+1)+"</font>��" 
		//var HNElist="\n"+"��¼"+(k+1)+"��"
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
	
	//var result = List.replace(/��¼/g, '<font color="red">��¼</font>');
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
