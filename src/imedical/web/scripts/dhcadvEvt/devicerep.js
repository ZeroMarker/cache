/// Description:��е�����¼�
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(function(){

	InitButton(); 					// �󶨱����ύ��ť ��ҽ
	reportControl(); 				// ������    ��ҽ
	InitCheckRadio();				//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	InitReportInfo(recordId);  		//���ر�����Ϣ  ��ҽ
	InitLayoutHtml();
});

function InitLayoutHtml(){
	$('#MedEventInfomation-97766').css('padding-bottom','22px');	
	$('#MedEventInfomation-97801').css('padding-bottom','22px');
}

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
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺ�/�����Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

//������
function reportControl(){
	
	// ����ʱ�����
	chkdate("MedNewEventResult-97739-97915");
	
	// �������ڿ���
	chkdate("MedAllDate-97762");
	
	// ͣ�����ڿ���
	chkdate("MedAllDate-97763");
	
	// ֲ�����ڿ���
	chkdate("MedAllDate-97764");
	
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	
}
//���ر�����Ϣ
function InitReportInfo(recordId)
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
	//�¼������ѡ������,����ʱ����� 
	$("input[type=radio][id^='MedNewEventResult-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id=="MedNewEventResult-97739"){
				var DeathDate=$('#MedNewEventResult-97739-97915').datebox('getValue');
				RepSetRead("MedNewEventResult-97739-97915","datebox",0);
				RepSetValue("MedNewEventResult-97739-97915","datebox",DeathDate); 	//��������
			}else{
				RepSetValue("MedNewEventResult-97739-97915","datebox",""); 	//��������
			}
		}
	})
}
function checkother()
{
	var deadflag=0
	$("input[type=radio][id^='MedNewEventResult-']").each(function(){
		if ($(this).is(':checked')){
			if((this.id=="MedNewEventResult-97739")&&($("#MedNewEventResult-97739-97915").datebox('getValue')=="")){
				deadflag=-1;
					
			}
		}
	})
	if(deadflag=="-1")
	{
		$.messager.alert('��ʾ',"��ѡ������ʱ�䣡")
		return false;
	}
	
	var effDate=$("#MedAllDate-97761").datebox('getValue');
	var proDate=$("#MedAllDate-97762").datebox('getValue');
	var stopdate=$("#MedAllDate-97763").datebox('getValue');
	var impDate=$("#MedAllDate-97764").datebox('getValue');
	if(DateTimecontrast(proDate,impDate)==0){
		$.messager.alert("��ʾ:","�����ڡ�ֲ�����ڲ���С���������ڣ�");
		return false;
	}
	if(DateTimecontrast(impDate,stopdate)==0){
		$.messager.alert("��ʾ:","�����ڡ�ͣ�����ڲ���С��ֲ�����ڣ�");
		return false;
	}
	if(DateTimecontrast(proDate,effDate)==0){
		$.messager.alert("��ʾ:","�����ڡ���Ч��������С���������ڣ�");
		return false;
	}
	return true;
}
function DateTimecontrast(stDateTime,endDateTime)
{
	var ret=1;
	var reg = new RegExp(":","g")
	var stDate=stDateTime.split(" ")[0];
	var stTime=stDateTime.split(" ")[1]==undefined?"":stDateTime.split(" ")[1].replace(reg,"");
	var endDate=endDateTime.split(" ")[0];
	var endTime=endDateTime.split(" ")[1]==undefined?"":endDateTime.split(" ")[1].replace(reg,"");
	if((stDate!="")&&(endDate!="")&&(stDate>endDate)){
		ret=0;
	}else if((stDate==endDate)&&(stTime>endTime)){
		ret=0
	}else{
		ret=1;
	}
	return ret;
}
