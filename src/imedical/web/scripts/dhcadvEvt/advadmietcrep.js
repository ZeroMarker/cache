/// Description: ���������¼�
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
}
function SaveReport(flag){
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

