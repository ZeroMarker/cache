///Description:  Ժ�в����¼����浥
///Creator:      wangxuejian  
///CreatDate:    2018-05-21 
var RepDate=formatDate(0);             //ϵͳ�ĵ�ǰ����
$(document).ready(function()
{   
	InitButton();             		  //����
	InitReport(recordId);         //���ر�����Ϣ  
})

// �󶨱��桢�ύ��ť
function InitButton()
{
	$("#SaveBut").on("click",function()
	{
	   SaveReport(0)                            
	})
	$("#SubmitBut").on("click",function()
	{
	   SaveReport(1)
	})
}

function SaveReport(flag)
{
   if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��"));	
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

