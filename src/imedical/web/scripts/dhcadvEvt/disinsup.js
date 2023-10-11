/**
*Description:	������Ӧ�����¼�
*Creator: 		cy
*CreDate: 		2021-07-27
**/
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	ReportControl();			// ������   	
	InitReport(recordId);	// ����ҳ����Ϣ
	InitCheckRadio();
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
	// ����ҽ��ȱ�� input (��ֵ��ʾ����ֵ����) 
	var MedTypeOth= $('#advMedicalReportType-label-97195-97894').val();
	if(MedTypeOth!=""){
		 $('#advMedicalReportType-label-97195-97894').show();
	}else{
	     $('#advMedicalReportType-label-97195-97894').hide();
	}
	
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	// ����ҽ��ȱ�� input(Ĭ������ ��ѡ��ʾ) 
	$('#advMedicalReportType-label-97195').click(function () { 
		if ($(this).is(':checked')){
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
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�����ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
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
		$.messager.alert($g("��ʾ:"),$g("ǩ��ʧ�ܣ�"));	
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
