/**
*Description:	��ҽҽ�Ʋ����¼����浥
*Creator: 		Qunianpeng
*CreDate: 		2018-05-25
**/
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	ReportControl();			// ������   	
	InitReport(recordId);	// ����ҳ����Ϣ
})
// ��ʼ����ť
function InitButton(){
	// ����
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// �ύ 
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
// ������
function ReportControl(){
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');		
		});
	});
	// ����ҽ��ȱ��(Ĭ������) 
	$('#advMedicalReportType-label-97195-97894').hide();
	$('#advMedicalReportType-label-97195').click(function () { 
		var $isChecked = $("#advMedicalReportType-label-97195").is(":checked");
		if($isChecked){
			 $('#advMedicalReportType-label-97195-97894').show();
		}else{
		     $('#advMedicalReportType-label-97195-97894').hide();
		}
	}); 
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
		$.messager.alert("��ʾ:","��������Ϊ�գ�����ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	// ����ǰ,��ҳ���������м��
	if(!checkRequired()){
		return;
	}
	var caflag=dhcsys_getcacert();  //ca��֤
	if(caflag.IsSucc){
		SaveReportCom(flag);
	}else{
		$.messager.alert("��ʾ:","ǩ��ʧ�ܣ�");	
		return false;
	}
	
}
//������Ϣ��ֵ���س��¼���
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}
