/// Description: ����ת�˲����¼�
/// Creator: guoguomin
/// CreateDate: 2017-12-15
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	ReportControl();			// ������
	InitCheckRadio();
	CheckTimeorNum();		//ʱ��У��
	InitReport(recordId);	//����ҳ����Ϣ
	
});

function InitButton()
{
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
// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
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
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!checkRequired()){
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
	// �¼�����ǰ��ҩ
	$("input[type=checkbox][id^='EventBefoDrug-']").click(function(){
		var tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			if(tmpid=='EventBefoDrug-94928'){
				$("input[type=checkbox][id^='EventBefoDrug-'][id!='EventBefoDrug-94928']").removeAttr("checked");
				$('#EventBefoDrug-94932').nextAll(".lable-input").val("");
				$('#EventBefoDrug-94932').nextAll(".lable-input").hide();
			}else{
				$("input[type=checkbox][id='EventBefoDrug-94928']").removeAttr("checked");
			}
		}
	});
}

//ʱ�� ����У��
function CheckTimeorNum(){
	// ��������У��
	// P ����
	chknum("PatientStatus-94856-94858-94863",0);
	chknum("PatientStatus-94856-94871-94877",0);
	// R ����
	chknum("PatientStatus-94856-94858-94866",0);
	chknum("PatientStatus-94856-94871-94880",0);
	// SpO2
	chknum("PatientStatus-94856-94858-94869",1,1,100);
	chknum("PatientStatus-94856-94871-94883",1,1,100);
	// BP
	checkBP("PatientStatus-94856-94858-94860");
	checkBP("PatientStatus-94856-94871-94874");
	
}
