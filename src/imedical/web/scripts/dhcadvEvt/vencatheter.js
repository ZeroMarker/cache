/// Description:�������ܲ���֢
/// Creator: hjh
/// CreateDate: 2020-12-15
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	InitReport(recordId);//����ҳ����Ϣ
});

// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// �ù�����
	chkdate("TubeDate");
}
//��ť�����뷽����
function InitButton(){
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //��ʾת�鰴ť
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
		} 
	}

	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
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
	///����ǰ,��ҳ���������м��
	 if(!checkRequired()){
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
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	/// �������ܲ���֢ - ҩ������
	if($("#CompVenousCa-3028").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3028-']").attr("disabled",false);
		$("input[type=checkbox][id^='CompVenousCa-3028-']").attr("disabled",false);
		$("input[id='CompVenousCa-3028-3042']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3803']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3804']").attr("readonly",false);
		$("input[id='CompVenousCa-3028-3805-3806']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3028-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3028-']").removeAttr("checked");
		$("input[type=checkbox][id^='CompVenousCa-3028-']").attr("disabled",true);
		$("input[type=checkbox][id^='CompVenousCa-3028-']").removeAttr("checked");
		
		$("input[id='CompVenousCa-3028-3042']").val("");
		$("input[id='CompVenousCa-3028-3803']").val("");
		$("input[id='CompVenousCa-3028-3804']").val("");
		$("input[id='CompVenousCa-3028-3805-3806']").val("");

		$("input[id='CompVenousCa-3028-3042']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3803']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3804']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3028-3805-3806']").attr("readonly","readonly");
	}
	
	/// �������ܲ���֢ - ������
	if($("#CompVenousCa-3029").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3029-']").attr("disabled",false);
		$("input[type=checkbox][id^='CompVenousCa-3029-']").attr("disabled",false);
		$("input[id='CompVenousCa-3029-3808']").attr("readonly",false);
		$("input[id='CompVenousCa-3029-3809']").attr("readonly",false);
		$("input[id='CompVenousCa-3029-3811']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3029-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3029-']").removeAttr("checked");
		$("input[type=checkbox][id^='CompVenousCa-3029-']").attr("disabled",true);
		$("input[type=checkbox][id^='CompVenousCa-3029-']").removeAttr("checked");
		
		$("input[id='CompVenousCa-3029-3808']").val("");
		$("input[id='CompVenousCa-3029-3809']").val("");
		$("input[id='CompVenousCa-3029-3811']").val("");

		$("input[id='CompVenousCa-3029-3808']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3029-3809']").attr("readonly","readonly");
		$("input[id='CompVenousCa-3029-3811']").attr("readonly","readonly");
	}
	/// �������ܲ���֢ - �¹�
	if($("#CompVenousCa-3062").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3062-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3062-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3062-']").removeAttr("checked");
	}
	/// �������ܲ���֢ - Ƥ��
	if($("#CompVenousCa-3063").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3063-']").attr("disabled",false);
		$("input[id='CompVenousCa-3063-3075-3076']").attr("readonly",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3063-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3063-']").removeAttr("checked");
		$("input[id='CompVenousCa-3063-3075-3076']").val("");
		$("input[id='CompVenousCa-3063-3075-3076']").attr("readonly","readonly");
	}
	/// �������ܲ���֢ - ��������
	if($("#CompVenousCa-3064").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3064-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3064-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3064-']").removeAttr("checked");
	}
	/// �������ܲ���֢ - ���ܸ�Ⱦ
	if($("#CompVenousCa-3065").is(':checked')){
		$("input[type=radio][id^='CompVenousCa-3065-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='CompVenousCa-3065-']").attr("disabled",true);
		$("input[type=radio][id^='CompVenousCa-3065-']").removeAttr("checked");
	}
	/// �������ܲ���֢ - �ѹ�
	if($("#CompVenousCa-3765").is(':checked')){ 
		$("input[id='CompVenousCa-3765-3768']").attr("readonly",false);
	}else{
		$("input[id='CompVenousCa-3765-3768']").val("");
		$("input[id='CompVenousCa-3765-3768']").attr("readonly","readonly");
	}
	
	
}
//ʱ�� ����У��
function CheckTimeorNum(){
	//ʱ������У��
	// �ù�ʱ��
	chktime("TubeTime");
}
