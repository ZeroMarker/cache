/// Description: ʧ����Ƥ��
/// Creator: guoguomin
/// CreateDate: 2017-12-15
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	
	InitButton();
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	CheckTimeorNum()
	InitReport(recordId);//����ҳ����Ϣ
	
});
function InitButton()
{
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
	
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheck(this.id);
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
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
	///����ǰ,��ҳ���������м��
	if(!(checkRequired())){
		return;
	}
	SaveReportCom(flag);
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
		/// ����Һ
	InitUIStatus("DermaExudate");
	/// �˿ڸ�Ⱦ
	InitUIStatus("WoundInfection");
	/// ��֯����
	InitUIStatus("TissueNecrosis");
	/// ��ʹ
	InitUIStatus("DermaPain");
	/// ���
	InitUIStatus("DermaSkin");
	/// �ٴ��ּ�
	InitUIStatus("ClinicalScale");

}
// ʧ����Ƥ����Դ
function InitCheck(id){
	if(id.indexOf("Resourse-")>=0){
		// Ժ�����
		if(id=="Resourse-94674"){
			$("input[type=checkbox][id^='Resourse-94675']").removeAttr("checked"); 
		}
		// Ժ�ڷ���
		if(id=="Resourse-94675"){
			$("#Resourse-94674").removeAttr("checked"); 
		}
		// Ժ�ڷ��� ����
		if(id=="Resourse-94675-94677"){
			$("#Resourse-94675-94678").removeAttr("checked");
			$("#Resourse-94674").removeAttr("checked"); 
		}
		// Ժ�ڷ��� ��������
		if(id=="Resourse-94675-94678"){
			$("#Resourse-94675-94677").removeAttr("checked"); 
			$("#Resourse-94674").removeAttr("checked"); 
		}		
	}
}

//ʱ�� ����У��
function CheckTimeorNum(){	
	//��������У��  
	// Ƥ�״�С
	chknum("DermaSize",1,1,100);
}

///��ʼ�����渴ѡ�� ��ѡ�¼�
function InitUIStatus(id)
{
	var tmpid="";
	$("input[type=checkbox][id^="+id+"]").click(function(){
		tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][id^="+id+"]").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
}
