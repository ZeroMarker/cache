/// Description: Ⱥ�˲����¼�
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){

	InitButton(); 			// �󶨱����ύ��ť 
	ReportControl();
	InitReport(recordId);  		//���ر�����Ϣ 
	CheckTimeorNum();	               //ʱ��У�� 
	

});

// �󶨱����ύ��ť
function InitButton(){
	
	$("#SaveBut").on("click",function(){
		SaveGroupRep(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveGroupRep(1);
	})
}
//������
function ReportControl(){
	// ������ҩ����
	chkdate("FirstDrugDate");
	// ������������
	chkdate("FirstHappenDate");
}

function SaveGroupRep(flag){
	
	///����ǰ,��ҳ���������м��
	if(!(checkother()&&checkRequired())){
		return;
	}
	//var repCode="advDrugGroup"   //wxj 2021-02-02    �����ʱ�򴫱���Code ���Ƿ��ȡ���˾����
	EpisodeID="";
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
	//InitPatInfoCom(EpisodeID);
  	$("#from").form('validate'); 
}

//ʱ�� ����У��
function CheckTimeorNum(){
	//ʱ������У��
	// ������ҩ����ʱ��
	chktime("FirstDrugTime","FirstDrugDate");
	// ������������ʱ��
	chktime("FirstHappenTime","FirstHappenDate");
	
	//��������У��  
	// ��ҩ����
	chknum("UseDrugNumber",0);
	// ���������¼�����
	chknum("DverseEventsNum",0);
	// ���ز����¼�����
	chknum("SeriousEventsNum",0);
	// ��������
	chknum("DeathNum",0);
	
}
///�ж���Ѫ�б��Ƿ�Ϊ�� sufan 2019-11-14
function checkother()
{
	
	chkdate("FirstDrugDate");
	// ������������
	chkdate("FirstHappenDate");
	// ������ҩ����ʱ��
	chktime("FirstDrugTime","FirstDrugDate");
	// ������������ʱ��
	chktime("FirstHappenTime","FirstHappenDate");
	
	// ������ҩ����
	var FirstDrugDate=$('#FirstDrugDate').datebox('getValue');
	// ������������
	var FirstHappenDate=$('#FirstHappenDate').datebox('getValue');
	// ������ҩʱ��
	var FirstDrugTime=$('#FirstDrugTime').val();
	// ��������ʱ��
	var FirstHappenTime=$('#FirstHappenTime').val();
	var reg = new RegExp(":","g")
	FirstDrugTime=FirstDrugTime==undefined?"":FirstDrugTime.replace(reg,"");
	FirstHappenTime=FirstHappenTime==undefined?"":FirstHappenTime.replace(reg,"");
	if(!compareSelTowTime(FirstDrugDate,FirstHappenDate)){
		$.messager.alert($g("��ʾ:"),$g("������ҩ����ӦС�������������ڣ���������д���ڣ�"));
		return false;
	}
	if((FirstDrugDate==FirstHappenDate)&&(FirstDrugTime>FirstHappenTime)){
		$.messager.alert($g("��ʾ:"),$g("������ҩʱ��ӦС����������ʱ�䣬��������дʱ�䣡"));
		return false;
	}
	// ��ҩ����
	var UseDrugNumber=$('#UseDrugNumber').val();
	// ���������¼�����
	var DverseEventsNum=$('#DverseEventsNum').val();
	// ���ز����¼�����
	var SeriousEventsNum=$('#SeriousEventsNum').val();
	// ��������
	var DeathNum=$('#DeathNum').val();
	if((UseDrugNumber!="")&&(DverseEventsNum!="")&&(parseInt(DverseEventsNum)>parseInt(UseDrugNumber))){
		$.messager.alert($g("��ʾ:"),$g("���������¼�����������ҩ��������������д��"));
		return false;
	}
	if((DverseEventsNum!="")&&(SeriousEventsNum!="")&&(parseInt(SeriousEventsNum)>parseInt(DverseEventsNum))){
		$.messager.alert($g("��ʾ:"),$g("���ز����¼��������ڷ��������¼���������������д��"));
		return false;
	}
	if((DverseEventsNum!="")&&(DeathNum!="")&&(parseInt(DeathNum)>parseInt(DverseEventsNum))){
		$.messager.alert($g("��ʾ:"),$g("�����������ڷ��������¼���������������д��"));
		return false;
	}
	
	return true;
}
