/**
	*Description: ҽ��Ͷ�ߡ����׵ǼǱ� 
	*Creator: yangyongtao
	*CreateDate: 2018-03-09
**/
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	reportControl();			// ������   	
	InitDisReport(recordId);	// ����ҳ����Ϣ

})


function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SaveDisputeReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SaveDisputeReport(1);
	})
}

// ������
function reportControl(){
	
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');		
		});
	});
	
	// ����ǩ�� ʱ�����
	chkdate("LocDateTime");
	// ҽ��ǩ�� ʱ�����
	chkdate("MedServiceTime");
	// Ժ�쵼ǩ�� ʱ�����
	chkdate("LeaderTime");
		
}

	
//���汣��
function SaveDisputeReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
	
}

//���ر�����Ϣ
function InitDisReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');				
	} 
}

//������Ϣ��ֵ���س��¼���
function InitPatInfo(EpisodeID)
{
	
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate');
}



