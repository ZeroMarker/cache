/// Description: ���ڲ����¼�
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){

	InitButton(); 			// �󶨱����ύ��ť ��ҽ
	InitReport(recordId);  		//���ر�����Ϣ  ��ҽ
});

// �󶨱����ύ��ť
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveMedReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveMedReport(1);
	})
}
function SaveMedReport(flag){
	
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�����ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	// ����ǰ,��ҳ���������м��
	if(!checkRequired()){
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
