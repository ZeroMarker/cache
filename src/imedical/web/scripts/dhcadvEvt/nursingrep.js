/// Description: �������¼�
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){

	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  			//ʱ��У��
	InitReport(recordId);  		//���ر�����Ϣ  ��ҽ
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
	// ��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	// ֪ͨ��������
	chkdate("FDIfNotiFamily-96520-96522");
	// ֪ͨҽ������
	chkdate("FDEventDeal-96526-96529");
	// ҽ��������������
	chkdate("FDEventDeal-96526-96531");	
	
}
// �󶨱����ύ��ť
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
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
function SaveReport(flag){
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
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

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}

//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	// �Ƿ�֪ͨ����  �� 
	if($('#FDIfNotiFamily-96520').is(':checked')){
		RepSetRead("FDIfNotiFamily-96520-96522","datebox",0);
	}else{
		RepSetRead("FDIfNotiFamily-96520-96522","datebox",1);
		RepSetValue("FDIfNotiFamily-96520-96522","datebox","");
	}
	// �Ƿ�֪ͨ����  �� 
	if($('#FDIfNotiFamily-96521').is(':checked')){
		RepSetRead("FDIfNotiFamily-96521-96524","input",0);
	}else{
		RepSetValue("FDIfNotiFamily-96521-96524","input","");
		RepSetRead("FDIfNotiFamily-96521-96524","input",1);
	}
	// �¼�����ʱ����  ����֪ͨҽ��
	if($('#FDEventDeal-96526').is(':checked')){
		RepSetRead("FDEventDeal-96526-96529","datebox",0);
		RepSetRead("FDEventDeal-96526-96530","input",0);
		RepSetRead("FDEventDeal-96526-96531","datebox",0);
	}else{
		RepSetRead("FDEventDeal-96526-96529","datebox",1);
		RepSetValue("FDEventDeal-96526-96529","datebox","");
		RepSetValue("FDEventDeal-96526-96530","input","");
		RepSetRead("FDEventDeal-96526-96530","input",1);
		RepSetRead("FDEventDeal-96526-96531","datebox",1);
		RepSetValue("FDEventDeal-96526-96531","datebox","");
	}
		
	// �Ƿ����������¼�  ���� 
	if($('#FDIfOccSimEvent-96551').is(':checked')){
		$("#FDIfOccSimEvent-96551-96554").attr("readonly",false);
	}else{
		$("#FDIfOccSimEvent-96551-96554").val("");
		$("#FDIfOccSimEvent-96551-96554").attr("readonly","readonly");
	}	
}
//ʱ�� ����У��
function CheckTimeorNum(){
	// �Ƿ����������¼�  ����
	chknum("FDIfOccSimEvent-96551-96554",1,1);
	// T ����
	chknum("PatVitSigns-96438",1);
	// P ����
	chknum("PatVitSigns-96439",0);
	// R ����
	chknum("PatVitSigns-96440",0);
	// BP
	checkBP("PatVitSigns-96441");

}
