/// Description: ��Σѹ�����浥
$(function(){
	InitButton(); 	// �󶨱����ύ��ť 
	InitReport(recordId);  		//���ر�����Ϣ  
});

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
	///����ǰ,��ҳ���������м��
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
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

