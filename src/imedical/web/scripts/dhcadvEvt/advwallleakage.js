/// Description: ҽ�ƻ�����շ���(��©/����)�¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-15
var eventtype=""
$(document).ready(function(){
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  //ʱ��У��
	InitReport(recordId);//����ҳ����Ϣ
});
// ������
function ReportControl(){
	// ��©����
	chkcombobox("WallLoc","dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId="+LgHospID);
	// ��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
}

//��ť�����뷽����
function InitButton(){
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

//���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){	
	}else{
    	$("#from").form('validate');			
	}
}
//���汣��
function SaveReport(flag)
{
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
	//�¼���ɵĽ��   ����סԺ����
	if($('#IfWLBehavior-93873').is(':checked')){
		RepSetRead("WLMan","input",0);
		RepSetRead("WLManWorkLife","input",0);
		var WallLoc=$('#WallLoc').combobox('getValue');
		RepSetRead("WallLoc","combobox",0);
		RepSetValue("WallLoc","combobox",WallLoc); 	// ��©�˿���
		RepSetRead("WLBehavior","textarea",0);
	
	}else{
		RepSetValue("WLMan","input","");
		RepSetRead("WLMan","input",1);
		RepSetValue("WLManWorkLife","input","");
		RepSetRead("WLManWorkLife","input",1);
		RepSetRead("WallLoc","combobox",1);
		RepSetValue("WallLoc","combobox","");
		RepSetValue("WLBehavior","textarea","");
		RepSetRead("WLBehavior","textarea",1);
	}	
}

//ʱ�� ����У��
function CheckTimeorNum(){
	//��������У��  WallWorkYears
	//��������(��)
	chknum("WLManWorkLife",1);

}

