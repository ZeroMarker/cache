/// Description: ��ҩ���󱨸浥
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
$(document).ready(function(){
	ReportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	InitReport(recordId);//����ҳ����Ϣ
    GetAsseInfo();// ��ֵ��ҳ�������ת����Ϣ
	
});
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
//��ť�����뷽����
function InitButton(){
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //��ʾת�鰴ť		
		if(winflag==2){
			/// ������ť��ʾ ��ζ��������Ȩ�ޣ����Թ�·������ʾ��ʿ�����۰�ť
			if($("#AssessmentBut").is(":visible")){ 
				$("#HeadNurEvaBut").show(); //��ʾ���۰�ť 2018-04-13 cy ���۽���
			}
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
		} 
		$("#AssessmentBut").hide(); //2019-07-26  ����ҽ��������û��ԭ������Ļ������͵�������ť
	}
	// ��ʿ������
	var HedNurEvaRecId=GetAssessRecordID("DrugHeaNurEvaluate");  
	$("#HeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("DrugHeaNurEvaluate",HedNurEvaRecId);
	})
	// �ƻ�ʿ������
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
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
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
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
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
	InitCheckRadio();
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){

	//�������� ��ҩʱ�����
	var dosetimeerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94617']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94617-94204").val()=="")||($("#DrugUseErrType-94617-94205").val()=="")){
				dosetimeerr=-1;
			}
		}
	})
	if(dosetimeerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��ҩʱ�����'������д���ݣ�");	
		return false;
	}
	//�������� ��ҩ;������
	var dosewayerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94618']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94618-94208").val()=="")||($("#DrugUseErrType-94618-94209").val()=="")){
				dosewayerr=-1;
			}
		}
	})
	if(dosewayerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��ҩ;������'������д���ݣ�");	
		return false;
	}
	//�������� ��©��ҩ
	var missdose=0;
	$("input[type=checkbox][id^='DrugUseErrType-94619']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94619-94212").val()=="")||($("#DrugUseErrType-94619-94213").val()=="")){
				missdose=-1;
			}
		}
	})
	if(missdose==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��©��ҩ'������д���ݣ�");	
		return false;
	}
	//�������� ��Һ�ٶȴ���
	var infusionspeed=0;
	$("input[type=checkbox][id^='DrugUseErrType-94620']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94620-94215").val()=="")||($("#DrugUseErrType-94620-94216").val()=="")){
				infusionspeed=-1;
			}
		}
	})
	if(infusionspeed==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��Һ�ٶȴ���'������д���ݣ�");	
		return false;
	}
	//�������� ��������
	var dosageerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94621']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94621-94219").val()=="")||($("#DrugUseErrType-94621-94220").val()=="")){
				dosageerr=-1;
			}
		}
	})
	if(dosageerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'��������'������д���ݣ�");	
		return false;
	}
	//�������� ���ʹ���
	var dosageformerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94622']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94622-94223").val()=="")||($("#DrugUseErrType-94622-94224").val()=="")){
				dosageformerr=-1;
			}
		}
	})
	if(dosageformerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'���ʹ���'������д���ݣ�");	
		return false;
	}
	//�������� ҩ�����
	var drugerr=0;
	$("input[type=checkbox][id^='DrugUseErrType-94623']").each(function(){
		if($(this).is(':checked')){
			if (($("#DrugUseErrType-94623-94227").val()=="")||($("#DrugUseErrType-94623-94228").val()=="")){
				drugerr=-1;
			}
		}
	})
	if(drugerr==-1){
		$.messager.alert("��ʾ:","���������͡���ѡ'ҩ�����'������д���ݣ�");	
		return false;
	}
	
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//��ҩʱ�����
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').attr("readonly",false);//ҽ����ҩʱ��
			$('#DrugUseErrType-94617-94205').attr("readonly",false);//�����ҩʱ��
		}
		//��ҩ;������
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').attr("readonly",false);//ҽ����ҩ;��
			$('#DrugUseErrType-94618-94209').attr("readonly",false);//�����ҩ;��
		}
		
	}else{
		///��ҩʱ�����
		if(id=="DrugUseErrType-94617"){
			$('#DrugUseErrType-94617-94204').val("");
			$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //ҽ����ҩʱ��
			$('#DrugUseErrType-94617-94205').val("");
			$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //�����ҩʱ��
		}
		//��ҩ;������
		if(id=="DrugUseErrType-94618"){
			$('#DrugUseErrType-94618-94208').val("");
			$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //ҽ����ҩ;��
			$('#DrugUseErrType-94618-94209').val("");
			$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //�����ҩ;��
		} 
	}
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//��ҩʱ�����
	if($('#DrugUseErrType-94617').is(':checked')){
		$('#DrugUseErrType-94617-94204').attr("readonly",false);//ҽ����ҩʱ��
		$('#DrugUseErrType-94617-94205').attr("readonly",false);//�����ҩʱ��
	}else{
		$('#DrugUseErrType-94617-94204').val("");
		$('#DrugUseErrType-94617-94204').attr("readonly","readonly"); //ҽ����ҩʱ��
		$('#DrugUseErrType-94617-94205').val("");
		$('#DrugUseErrType-94617-94205').attr("readonly","readonly"); //�����ҩʱ��
	}
	//��ҩ;������
	if($('#DrugUseErrType-94618').is(':checked')){
		$('#DrugUseErrType-94618-94208').attr("readonly",false);//ҽ����ҩ;��
		$('#DrugUseErrType-94618-94209').attr("readonly",false);//�����ҩ;��
	}else{
		$('#DrugUseErrType-94618-94208').val("");
		$('#DrugUseErrType-94618-94208').attr("readonly","readonly"); //ҽ����ҩ;��
		$('#DrugUseErrType-94618-94209').val("");
		$('#DrugUseErrType-94618-94209').attr("readonly","readonly"); //�����ҩ;��
	}
	//��©��ҩ
	if($('#DrugUseErrType-94619').is(':checked')){
		$('#DrugUseErrType-94619-94212').attr("readonly",false);//��©����
		$('#DrugUseErrType-94619-94213').attr("readonly",false);//ҽ����ҩʱ��
	}else{
		$('#DrugUseErrType-94619-94212').val("");
		$('#DrugUseErrType-94619-94212').attr("readonly","readonly"); //��©����
		$('#DrugUseErrType-94619-94213').val("");
		$('#DrugUseErrType-94619-94213').attr("readonly","readonly"); //ҽ����ҩʱ��
	}
	//��Һ�ٶȴ��� 
	if($('#DrugUseErrType-94620').is(':checked')){
		$('#DrugUseErrType-94620-94215').attr("readonly",false);//ҩ������
		$('#DrugUseErrType-94620-94216').attr("readonly",false);//�����ҩ�ٶ�
	}else{
		$('#DrugUseErrType-94620-94215').val("");
		$('#DrugUseErrType-94620-94215').attr("readonly","readonly"); //ҩ������
		$('#DrugUseErrType-94620-94216').val("");
		$('#DrugUseErrType-94620-94216').attr("readonly","readonly"); //�����ҩ�ٶ�
	}
	//��������  
	if($('#DrugUseErrType-94621').is(':checked')){
		$('#DrugUseErrType-94621-94219').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94621-94220').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94621-94219').val("");
		$('#DrugUseErrType-94621-94219').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94621-94220').val("");
		$('#DrugUseErrType-94621-94220').attr("readonly","readonly"); //�����ҩ����
	}
	//���ʹ��� 
	if($('#DrugUseErrType-94622').is(':checked')){
		$('#DrugUseErrType-94622-94223').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94622-94224').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94622-94223').val("");
		$('#DrugUseErrType-94622-94223').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94622-94224').val("");
		$('#DrugUseErrType-94622-94224').attr("readonly","readonly"); //�����ҩ����
	}
	//ҩ����� 
	if($('#DrugUseErrType-94623').is(':checked')){
		$('#DrugUseErrType-94623-94227').attr("readonly",false);//ҽ����ҩ����
		$('#DrugUseErrType-94623-94228').attr("readonly",false);//�����ҩ����
	}else{
		$('#DrugUseErrType-94623-94227').val("");
		$('#DrugUseErrType-94623-94227').attr("readonly","readonly"); //ҽ����ҩ����
		$('#DrugUseErrType-94623-94228').val("");
		$('#DrugUseErrType-94623-94228').attr("readonly","readonly"); //�����ҩ����
	}
	
	
}
//ʱ�� ����У��
function CheckTimeorNum(){
	//ʱ������У��
	//��ҩʱ����� ҽ����ҩʱ��
	chktime("DrugUseErrType-94617-94204");
	
	//��ҩʱ����� �����ҩʱ��
	chktime("DrugUseErrType-94617-94205");
	
	//��©��ҩ ҽ����ҩʱ��
	chktime("DrugUseErrType-94619-94213");
	
	
	//��������У��
	//��©��ҩ ��©����
	chknum("DrugUseErrType-94619-94212");

}
/* //�ǼǺ��Զ���0
function getRePatNo(regno)
{
	//return regno;
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	return zero+regno ;
}
//ͨ��סԺ�ţ������ţ���ȡ���˻�����Ϣ
function PatMedNoEnter(){
	$('#PatMedicalNo').bind('keydown',function(event){
		if(event.keyCode == "13")    
		{
			var patientNO=$('#PatMedicalNo').val();
			if (patientNO=="")
			{
				$.messager.alert("��ʾ:","���˲����Ų���Ϊ�գ�");
				return;
			}
			var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			var mycols = [[
				{field:'RegNo',title:'����id',width:80},
				{field:'AdmTypeDesc',title:'��������',width:60}, 
				{field:'AdmLoc',title:'�������',width:120}, 
				{field:'AdmDate',title:'��������',width:80},
				{field:'AdmTime',title:'����ʱ��',width:70},
				{field:'Adm',title:'Adm',width:60,hidden:true} 
			]];
			var mydgs = {
				url:'dhcadv.repaction.csp'+'?action=GetAdmList&Input='+patientNO ,
				columns: mycols,  //����Ϣ
				nowrap:false,
				pagesize:10,  //һҳ��ʾ��¼��
				table: '#admdsgrid', //grid ID
				field:'Adm', //��¼Ψһ��ʶ
				params:null,  // �����ֶ�,��Ϊnull
				tbar:null //�Ϲ�����,��Ϊnull
			}
			var win=new CreatMyDiv(input,$("#PatMedicalNo"),"drugsfollower","460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
			win.init();
		}
	});
}
//��ȡ������ѡ���¼����
function SetAdmIdTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID="";
	}
	InitPatInfo(EpisodeID);
} */
//���ݿ���1��ѯ����2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //���������������
	});   

}
/*//�ǼǺŻس��¼�
function PatIDEnter(){
	$('#PatID').bind('keydown',function(event){

		 if(event.keyCode == "13")    
		 {
			 var PatID=$('#PatID').val();
			 if (PatID=="")
			 {
				 	$.messager.alert("��ʾ:","���˵ǼǺŲ���Ϊ�գ�");
					return;
			 }
			 var PatID=getRegNo(PatID);
			 var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
			 var mycols = [[
			 	{field:'Adm',title:'Adm',width:60}, 
			 	{field:'AdmLoc',title:'�������',width:220}, 
			 	{field:'AdmDate',title:'��������',width:80},
			 	{field:'AdmTime',title:'����ʱ��',width:80},
			 	{field:'RegNo',title:'����id',width:80}
			 ]];
			 var mydgs = {
				 url:'dhcadv.repaction.csp'+'?action=GetAdmDs&Input='+PatID ,
				 columns: mycols,  //����Ϣ
				 pagesize:10,  //һҳ��ʾ��¼��
				 table: '#admdsgrid', //grid ID
				 field:'Adm', //��¼Ψһ��ʶ
				 params:null,  // �����ֶ�,��Ϊnull
				 tbar:null //�Ϲ�����,��Ϊnull
				}
			 var win=new CreatMyDiv(input,$("#PatID"),"drugsfollower","650px","335px","admdsgrid",mycols,mydgs,"","",SetAdmTxtVal);	
			 win.init();
		}
	});	
}
//��ȡ�ǼǺ�ѡ���¼����
function SetAdmTxtVal(rowData)
{
	EpisodeID=rowData.Adm;
	if(EpisodeID==undefined){
		EpisodeID=""
	}
	InitPatInfo(EpisodeID);
	
}*/
//2018-04-16 ���۽������ݼ��� 
function GetAsseInfo(){
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	var PatOutcomRecId="";//ת�����¼id
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"DrugHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordId,'FormCode':"PatOutcomform"},
	function(data){ 
			 PatOutcomRecId=data
	},"text",false)
	
	if((HeadNurEvaRecId!="")&&(RepStaus!="�")){SetRepInfo(HeadNurEvaRecId,"DrugHeaNurEvaluate");}
	if((LocHeadNurEvaRecId!="")&&((RepStaus=="�ƻ�ʿ�����")||(RepStaus=="�������"))){SetRepInfo(LocHeadNurEvaRecId,"LocHeaNurEvaluate");}
	if((NurDepEvaRecId!="")&&(RepStaus=="�������")){SetRepInfo(NurDepEvaRecId,"NurDepEvaluate");}
	//ת�����ݻ�ȡ
	if((PatOutcomRecId!="")){SetRepInfo(PatOutcomRecId,"PatOutcomform");}
}
//2018-04-16 ���������������ݸ�ֵ
function SetRepInfo(FormRecId,FormCode){
	var data="" ;
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
		{'ADVFormRecDr':FormRecId},
		function(datalist){ 
			 data=datalist
	},"json",false)
	if(FormCode=="DrugHeaNurEvaluate"){
		SetHeadNurInfo(data);
	}
	if(FormCode=="LocHeaNurEvaluate"){
		SetLocHeaNurInfo(data);
	}
	if(FormCode=="NurDepEvaluate"){
		SetNurDepInfo(data);
	}
	//ת�����ݸ�ֵ
	if(FormCode=="PatOutcomform"){
		SetPatOutcomInfo(data);
	}
}
function SetHeadNurInfo(data)
{
	var List="";
	var MornRepMeetDate=$g(data["MornRepMeetDate"]); //���ᱨ������
	if(MornRepMeetDate!=""){List=List+"���ᱨ�����ڣ�"+MornRepMeetDate+"��";}
	var MornRepMeetTime=$g(data["MornRepMeetTime"]); //���ᱨ��ʱ��
	if(MornRepMeetTime!=""){List=List+"���ᱨ��ʱ�䣺"+MornRepMeetTime+"��";}
	var MornRepMeetPlace=$g(data["MornRepMeetPlace"]); //����ص�
	if(MornRepMeetPlace!=""){List=List+"����ص㣺"+MornRepMeetPlace+"��";}
	var MornRepMeetpants=$g(data["MornRepMeetpants"]); //������Ա
	if(MornRepMeetpants!=""){List=List+"������Ա��"+MornRepMeetpants+"��";}
	var MornRepMeetContent=$g(data["MornRepMeetContent"]); //��������
	if(MornRepMeetContent!=""){List=List+"�������ݣ�"+MornRepMeetContent+"��";}
     
	var MeetDate=$g(data["MeetDate"]); //��������
	if(MeetDate!=""){List=List+"\n�������ڣ�"+MeetDate+"��";}
	var MeetTime=$g(data["MeetTime"]); //����ʱ��
	if(MeetTime!=""){List=List+"����ʱ�䣺"+MeetTime+"��";}
	var MeetPlace=$g(data["MeetPlace"]); //����ص�
	if(MeetPlace!=""){List=List+"����ص㣺"+MeetPlace+"��";}
	var Participants=$g(data["Participants"]); //�λ���Ա
	if(Participants!=""){List=List+"�λ���Ա��"+Participants+"��";}
	
	//�����Ľ�����ӦҪ�ؼ���ԭ��
	var CaseImprovement=$g(data["CaseImprovement"]); 
	if(CaseImprovement!=""){List=List+"\n�����Ľ�����ӦҪ�ؼ���ԭ�򣩣�\n"+CaseImprovement;}

	//����Ľ�
	var ManaImprovement=$g(data["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",data); 
	if (ManaImprovement!=""){
		List=List+"\n����Ľ���  �ƶȡ����̼��淶�ƶ����޶���"+ManaImprovementzdoth+"���ƣ�"+ManaImprovement+"����";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",data); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		List=List+"\n����Ľ���"+ManaImprovementoth+"��"
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		List=List+ManaImprovementoth+"��";
	}
	//����ת�� PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	if(PatOutcom!=""){List=List+"\n ����ת�飺"+PatOutcom;}

	// ��ʿ��Ч������
	var ListHeadNurEva="";                       // ��ʿ��Ч�����ۼӴ�����
	var HeadNurEvaluate=$g(data["HeadNurEvaluate"]);
	var HeadNurEvaluatelen=HeadNurEvaluate.length; //��ʿ�����۸���
	var HeadNurEvaluateList="��ʿ��Ч�����ۣ�";
	for(var k=0;k<HeadNurEvaluatelen;k++){
		var HNElist="\n<font style='font-Weight:bold;'>��¼"+(k+1)+"</font>��"    
		//var HNElist="\n��¼"+(k+1)+"��"
		var HNEdate=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94393-94398"]); //����ʱ��
		if(HNEdate!=""){HNElist=HNElist+"����ʱ�䣺"+HNEdate+"��";}
		var HNEobject=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94394-94399"]); //�������
		if(HNEobject!=""){HNElist=HNElist+"�������"+HNEobject+"��";}
		var HNEcontent=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94395-94400"]); //��������
		if(HNEcontent!=""){HNElist=HNElist+"�������ݣ�"+HNEcontent+"��";}		
		var HNEresult=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94396-94401"]); //������
		if(HNEresult!=""){HNElist=HNElist+"��������"+HNEresult+"��";}		
		var HNEpeople=$g(HeadNurEvaluate[k]["HeadNurEvaluate-94387-94397-94403"]); //������
		if(HNEpeople!=""){HNElist=HNElist+"�����ˣ�"+HNEpeople+"��";}		
		HeadNurEvaluateList=HeadNurEvaluateList+HNElist
	}
	if(HeadNurEvaluateList!=""){ListHeadNurEva=ListHeadNurEva+HeadNurEvaluateList;}
	var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",data); 
	if(AftImpMeasures!=""){List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����"+AftImpMeasures+"��";}
	var AftImpMeasuresoth=$g(data["AftImpMeasures-94925-94927"]);  //δ��ʵ δ��ʵԭ�� 
	if ((AftImpMeasuresoth!="")){
		List=List+"\n�¼����������Ĵ�ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+AftImpMeasuresoth+"��";
	}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n�����¼��д��"+ManaIfStandard+"��";}
	
	var HNrow=0
	var HNList=List.split("\n")
	var HNlen=HNList.length;
	for(i=0;i<HNlen;i++){
		HNrow=HNrow+parseInt(HNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var HNheightlen=(HNrow+HeadNurEvaluatelen)*18;
	$("#FormCauseAnalysis").css({
		"height":HNheightlen
	});
	$('#FormCauseAnalysis').val(List);
	$('#FormCauseAnalysis').append('<div id="HeadNurEvaluate"></div>');
	$('#HeadNurEvaluate').html(ListHeadNurEva);

}

//2018-05-09 ת����Ϣ��ֵ
function SetPatOutcomInfo(data)
{
	//����ת�� PatOutcom
	var PatOutcom=$g(data["PatOutcom"]); 
	var POrow=0
	var POList=PatOutcom.split("\n")
	var POlen=POList.length;
	for(i=0;i<POlen;i++){
		POrow=POrow+parseInt(POList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var POheightlen=(POrow+1)*18;
	$("#FormPatOutcom").css({
		"height":POheightlen
	});
	$('#FormPatOutcom').val(PatOutcom);

}
