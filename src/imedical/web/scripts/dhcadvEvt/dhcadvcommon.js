/// Description: �����¼����� �������� �����ύ��������ת
/// Creator: congyue
/// CreateDate: 2017-09-06
var url="dhcadv.repaction.csp";
var RepID="",formId="",recordId="",RepStaus="",RepTypeDr="",StatusLast="",RepTypeCode="",RepType="";
var EpisodeID="",patientID="",editFlag="",RepUser="";
var adrNextLoc="";adrLocAdvice="";adrReceive="";
var discover=""; //������
var bodywidth="",freshflag=0,TmpEpisodeID="";
var WinUserId="",WinLocId="",WinGroupId="";
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/cmcommon.js"></script>');
var AssWinRecId="",PatOutWinRecId="";// 2018-04-15 cy �������۽���id   2018-05-07 ת�����id
var RepStausDr="",StatusNextID="",FileFlag="",StsusGrant="",StatusLastID="",StaFistAuditUser="",SubUserflag="",AuditList="",CancelAuditList="",UserLeadflag="",StatusNext="",RepAppAuditFlag="",RepLocDr="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///���۰�ť��ʶ���ƻ�ʿ�����۰�ť��ʶ���������۰�ť��ʶ
var EvaFlagList=""; /// ���۱�ʶ��  ���۰�ť��ʶ^�ƻ�ʿ�����۰�ť��ʶ^�������۰�ť��ʶ 
var editRow="";
var winflag=""; /// 1 ��ѯ��������޸�  2 ��˽�������޸�  3 portal ���� �����޸�
var MKIOrdFlag="";  /// �ֹ�����ҽ����ʶ
var NextLocFlag=0;
var OrdList="";  /// ҽ��ID�� 2021-02-09 cy �����ҽ��id
$(document).ready(function(){
	InitRepParam(); 	  	// ��ʼ�������������
	ReportControlCom();		// ������  	
	BtnControlCom();		//��ť�����뷽����
    CheckTimeorNumCom();	//ʱ�������ݿ�������
	ReportEnter();			//����س��¼�
    InitBasicInfoCom(RepID);	///���ر��������Ϣ
    ReportBack(); // ���� ����ɾ���¼�
    bandFromNotes(); // ������ע
    
});
// ��ʼ�������������
function InitRepParam(){
  	RepID=getParam("RepID"); 		//����ID   yangyongtao  2017-11-24
	formId=$("#formId").val();  		//��id
	recordId=$("#recordId").val();  	//����д��¼id
	RepStaus=getParam("RepStaus");  	//��״̬����
	RepTypeDr=getParam("RepTypeDr");    //������id
	editFlag=getParam("editFlag");
	RepTypeCode=getParam("code");  		//�������ʹ���
	RepType=getParam("desc");  			//������������
	freshflag=getParam("freshflag");	//ˢ�±�ʶ
	TmpEpisodeID=getParam("TmpEpisodeID");  //ѡ���datagrid�ľ���ID
	adrReceive=getParam("adrReceive");  //����״̬dr
	RepStausDr=getParam("RepStausDr");  //����״̬id
	StatusNextID=getParam("StatusNextID");  //������һ״̬id
	StatusNext=getParam("StatusNext");  //������һ״̬
	FileFlag=getParam("FileFlag");  	//�鵵��ʶ
	StsusGrant=getParam("StsusGrant");  //��˱�ʶ
	StatusLastID=getParam("StatusLastID");  		//��һ��״̬id
	StaFistAuditUser=getParam("StaFistAuditUser");  //��������
	winflag=getParam("winflag");  					//���ڱ�ʶ  1 ��ѯ���棬  2 ��˽���
	SubUserflag=getParam("SubUserflag");  			//ת���˱�ʶ
	UserLeadflag=getParam("UserLeadflag") 			//�ƻ�ʿ����ʶ 1�ƻ�ʿ�� 0 �ǿƻ�ʿ��
	RepLocDr=getParam("RepLocDr");  				//���ϱ����� sufan 2019-06-24
	RepAppAuditFlag=getParam("RepAppAuditFlag") 	//��������ʶ 1��Ҫ���� 0 ����Ҫ����
	WinUserId=getParam("WinUserId");  				//��¼��id
	RepUser=getParam("RepUser"); 					//���
	EpisodeID=getParam("AdmID"); 
	if((WinUserId!="")&&(WinUserId!=undefined)){
		LgUserID=WinUserId;
	}
	WinLocId=getParam("WinLocId");  				//��¼����id
	if((WinLocId!="")&&(WinLocId!=undefined)){
		LgCtLocID=WinLocId;
	}
	WinGroupId=getParam("WinGroupId");  //��¼��ȫ��id
	if((WinGroupId!="")&&(WinGroupId!=undefined)){
		LgGroupID=WinGroupId;
	}
	AuditList=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+""+"^"+adrReceive+"^"+RepTypeCode;
	CancelAuditList=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+""+"^"+""+"^"+adrReceive+"^"+RepTypeCode;
	bodywidth=$("body").width();
}

// ������
function ReportControlCom(){
	$.messager.defaults = { ok: $g("ȷ��"),cancel: $g("ȡ��")};
	if ((recordId=="")&&(freshflag==0)){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
	        var adm = frm.EpisodeID.value;
		    EpisodeID=adm;
	        InitPatInfo(adm);//��ȡ������Ϣ
		}
	}
	if(freshflag==1)
	{
		EpisodeID=TmpEpisodeID
		InitPatInfo(EpisodeID);//��ȡ������Ϣ
	}
	// �ֹ�����ҽ����ʶ
	runClassMethod("web.DHCADVCOMMON","GetEmSysConfig",{'AdvCode':'MKIORD','Params':LgParam},
	function(data){
		MKIOrdFlag=data;
	},"text",false);
	//���� url
	var locurl='dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+''
	// ��Ժ/�������
	chkcombobox("InOrOutHospLoc",locurl);
	// ��������
	chkcombobox("OccuLoc",locurl);
	// ҽ����� url
	var socurl='dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QuerySocialStatusCombo&hospId='+LgHospID+''
	// ��Ժ/�������
	chkcombobox("MedicalCategory",socurl);
	
	
	
	// �������ڿ���
	chkdate("ReportDate");
	// �������ڿ���
	chkdate("OccurDate","OccurTime");
	// �������� ��ѡ�Զ���¼ ��������
	$('#OccurDate').datebox({
	    onChange: function(){
		    var date=$("#OccurDate").datebox("getValue");
	        var DateType=QueryDateType(date);//��������
			RepSetValue("DateType","input",$g(DateType));
			RepSetRead("DateType","input",1);
	    }
	})
	// ��Ժʱ�����
	chkdate("InOrOutHospDate");
	// ��Ժʱ�����
	chkdate("LeavHospTime");
		
	//ְ�� url
	var titleurl='dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryCarPrvTpCombo';
	// ���ְ��
	chkcombobox("RepUserTitle",titleurl);
	// ������ְ��
	chkcombobox("PartyTitleR",titleurl);
	// ������ְ��
	chkcombobox("FindTitle",titleurl);
	
	//�ж�����Ĳ���ID�Ƿ�Ϊ����
	$('#PatNo').bind("blur",function(){
		var	PatNo=$('#PatNo').val();
		if(isNaN(PatNo)){
			$.messager.alert($g("��ʾ")+":",$g("����������")+"��");
			$('#PatNo').val("");
			return;
		}
	})
	//�ж�����Ĳ������Ƿ�Ϊ����
	$('#PatMedicalNo').bind("blur",function(){
		var	PatMedicalNo=$('#PatMedicalNo').val();	
		if(isNaN(PatMedicalNo)){
			$.messager.alert($g("��ʾ")+":",$g("����������")+"��");
			$('#PatMedicalNo').val("");
			return;
		}
	})
	
	// ��ʼ�� -input���͵�������ȡ�����¼�
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //��ʱ���body
        $("body").click();
    },500)
    
    // ���Ƶȼ����˺����س̶ȼ�
    ConLevInjury();   
    
    //������ϵ�绰  sufan 2019-11-07
	$("#HospPhone").on('keyup',function(){
		if(isNaN($(this).val())){
			$.messager.alert($g("��ʾ")+":",$g("��¼����ȷ�ĵ绰����")+"��");
			$(this).val("");
		}
	})
	
	// ������� ��������
	discover=$('#RepUserName').val();
	if ((discover==$g("����"))){
		$('#RepUserName-label').append('<div id="switch-out" class="open-out"style="margin-left:15px;margin-right:10px;display:inline-block;" onclick="ClickTabs()"><div style="color:#FFFFFF;padding:5px 0 0 2px;">'+$g("����")+'</div><div id="switch-in" class="open-in"></div></div>');
		$('#RepUserName').val($g("����"));
	}else {
		$('#RepUserName-label').append('<div id="switch-out" class="close-out"style="margin-left:5px;margin-right:10px;display:inline-block;" onclick="ClickTabs()"><div style="color:#FFFFFF;padding:5px 0 0 2px;">'+$g("����")+'</div><div id="switch-in" class="close-in"></div></div>');
	}
	ClickTabs();
	$('#RepUserName').css("margin-left","0px");
}
//��ť�����뷽����
function BtnControlCom(){
	
	// ������־
	runClassMethod("web.DHCADVCOMMON","GetAssessAuthority",{'RepTypeCode':RepTypeCode,'LgParam':LgParam},
		function(data){
			AssessFlag=data;
		},"text",false);
	// �ƻ�ʿ��������־
	runClassMethod("web.DHCADVCOMMON","GetEmSysConfig",{'AdvCode':"LOCHEADNUREVAFLAG",'Params':LgParam},
		function(data){
			LocHeadNurEvaFlag=data;
		},"text",false);
	// ����������־
	runClassMethod("web.DHCADVCOMMON","GetEmSysConfig",{'AdvCode':"NURDEPEVAFLAG",'Params':LgParam},
		function(data){
			NurDepEvaFlag=data;
		},"text",false);
	EvaFlagList=AssessFlag+"^"+LocHeadNurEvaFlag+"^"+NurDepEvaFlag;
	// ���Ʋ�����ť��ʾ������
	if ((RepStaus!="")&&(RepStaus!=$g("δ�ύ"))){
		$("#SubmitBut").hide();
		if((winflag==2)||(winflag==3)){
			if(StsusGrant=="1"){
				// ��������鵵��ť ��������ʾȡ����˰�ť 
				if((FileFlag!=$g("δ�鵵"))&&(FileFlag!=$g("�����鵵"))){
					$("#RepCancelAudit").hide(); 
				}else{
					$("#RepCancelAudit").show(); //������� 
				}
				if(StatusLastID==""){ //2018-01-17
					$('#RepCancelAudit').text($g("ȡ���ύ"));
			    }else{
					$('#RepCancelAudit').text($g("ȡ�����"));            
			    }
			}
			if(RepAppAuditFlag=="1"){
				$("#RepAudit").show(); //ȷ������ 
				$("#Back").show(); //����  
				$("#Transcription").show(); // ת��  
			}
			if(SubUserflag=="1"){  ///ת���˱�־
				$("#Transcription").show(); // ת�� 
				$('#Transcription').text($g("ת���ظ�"));
			}
			if(AssessFlag.indexOf("Y")>=0){
				$('#AssessmentBut').show(); //2019-01-22 ������ťչ��(ҽ����û��ԭ������Ļ�������ʹ�ô�����)
			}
		}
		$('#AuditMessage').show(); //2018-06-12 cy ������Ϣչ��
		$('#PicUpLoad').show();
		RepSetAudMessage();
	}else{
		$("#anchor>ul>li>a:contains("+$g('�¼���������Ϣ')+")").parent().hide(); //hxy 2020-03-21
	}
	// �ϴ��ļ���־
	runClassMethod("web.DHCADVFile","ChkRepUpload",{'RepId':RepID,'RepTypeDr':RepTypeDr},
		function(data){
			var UploadFlag=data;
			if(UploadFlag=="1"){ 
				$('#PicUpLoad').text($g("�ļ��鿴"));
		    }else{
				$('#PicUpLoad').text($g("�ļ��ϴ�"));            
		    }
	},"text",false);
	if (editFlag==-1){
		$("#SaveBut").hide(); //���ر��水ť
		$("#Back").css("margin-left","400px"); //�������� hxy 2018-05-30
		$("#SubmitBut").hide(); //�����ύ��ť
	}
	// ���������굥�İ�ť
	$("#assefooter").hide();  
	//������������
	$('#RepAudit').on("click",function(){
		RepAudit();
	})
	//ȷ������   
	$('#RepConfirmAudit').on("click",function(){
		RepConfirmAudit();
	}) 
	//�������
	$('#RepCancelAudit').on("click",function(){
		RepCancelAuditBt();
	}) 
	//����
	$('#Back').on("click",function(){
		RejectWin();
	}) 
	//���沵��
	$('#Reject').on("click",function(){
		BackBt();
	}) 
	//ת�� 
	$('#Transcription').on("click",function(){
		Transcription();
	}) 
	// ����
	$("#AssessmentBut").on("click",function(){
		assessmentRep();
	})
	// �ļ��ϴ�
	$('#PicUpLoad').on("click",function(){
		Uploadfy();
	})
	

}
//ʱ�������ݿ�������
function CheckTimeorNumCom(){
	//ʱ������У��
	//����ʱ��
	chktime("ReportTime");
	//����ʱ��
	chktime("OccurTime","OccurDate");
	//��������У��  
	//�����˹�������(��)
	chknum("PartyWorkYears",1);
	//��˹�������(��)
	chknum("RepUserWorkYears",1);
	//�����˹�������(��)
	chknum("FindWorkYears",1);
	//��ԺʱADL�÷�
	if ($("#PatAdmADLScore").length > 0){
		chknum("PatAdmADLScore",1,0,100);
		$('#PatAdmADLScore').live("keyup",function(){
			ChkPatSelfCareAbility(this.value);
		})
	}
	//����ǰADL�÷�
	if ($("#OccurADLScore").length > 0){
		chknum("OccurADLScore",1,0,100);
		$('#OccurADLScore').live("keyup",function(){
			OccurPatSelfCareAbility(this.value);
		})
	}
}
//��������
function ClickTabs(){
	var div2=document.getElementById("switch-in");
	var div1=document.getElementById("switch-out");
	div2.onclick=function(){
		if((RepUser!="")&&(RepUser!=LgUserName)){return false;}   //�Ǳ��˲����޸� sufan 2019-11-07
		div1.className=(div1.className=="close-out")?"open-out":"close-out";
		div2.className=(div2.className=="close-in")?"open-in":"close-in";
           var discovers=((discover=="")||(discover==$g("����")))?LgUserName:discover;
           var discovers=(div1.className=="close-out")?discovers:$g("����");
		$('#RepUserName').val(discovers);
		// ������ְ������ 
		if(discovers==$g("����")){
			RepSetRead("RepUserTitle","combobox",1);	
			RepSetValue("RepUserTitle","combobox","����"); 
		}else{
			GetRepUserInfo(0);
		}
	}
         
}
//���ر�������Ϣ����
function InitPatInfoCom(EpisodeID)
{
	if(EpisodeID==""){return;}
	runClassMethod("web.DHCADVCOMMON","GetPatInfoJson",{'PatNo':'','EpisodeID':EpisodeID},
	function(Data){ 
      	var AdmType=Data.AdmType;				// ������Դ
		RepSetValue("PatOrigin-label","radio",AdmType);
		RepSetRead("PatOrigin-label","radio",1);//������Դ
		var PatNo=Data.PatNo;					// �ǼǺ�
		RepSetValue("PatNo","input",PatNo);
		var MedicalNo=Data.MedicalNo;			// ������
		RepSetValue("PatMedicalNo","input",MedicalNo);
		RepSetRead("PatMedicalNo","input",1);
		var PatName=Data.PatName;				// ��������
		RepSetValue("PatName","input",PatName);
		RepSetRead("PatName","input",1);
		var PatSex=Data.PatSex;  				// �Ա�
		RepSetValue("PatSexinput","input",PatSex);
		RepSetRead("PatSexinput","input",1);
		var PatAge=Data.PatAge;					// ����
		RepSetValue("PatAge","input",PatAge);
		RepSetRead("PatAge","input",1);		
      	var PatDOB=Data.Birthday;			// ��������
      	if(PatDOB!=""){
			RepSetRead("PatDOB","datebox",1);
			RepSetValue("PatDOB","datebox",PatDOB);
		}else {
			RepSetRead("PatDOB","datebox",0);
			RepSetValue("PatDOB","datebox","");
		}		
		var PatPhone=Data.PatTelH;					// ��ϵ�绰
      	if(PatPhone!=""){
			RepSetValue("PatPhone","input",PatPhone);
			RepSetRead("PatPhone","input",1);		
		}else {
			RepSetValue("PatPhone","input","");
			RepSetRead("PatPhone","input",0);		
		}		
      	var CurBedcode=Data.CurBedcode;			// ��λ�� 
      	if(CurBedcode!=""){
      		RepSetValue("AdmBedNum","input",CurBedcode);
      	}else {
      		RepSetValue("AdmBedNum","input","");
      	}
      	RepSetRead("AdmBedNum","input",1);
      	var AdmDoctor=Data.AdmDoctor;			// ����ҽʦ
		if(AdmDoctor!=""){
      		RepSetValue("Physician","input",AdmDoctor);
      	}else {
      		RepSetValue("Physician","input","");
      	}
      	RepSetRead("Physician","input",1);
		var HospTimes=Data.InTimes; //סԺ����
		if(HospTimes!=""){
    		RepSetValue("HospTimes","input",HospTimes);
			
		}else {
    		RepSetValue("HospTimes","input","");
		}
		RepSetRead("HospTimes","input",1);
		var AdmLoc=Data.AdmLoc;					// ��Ժ/�������
		RepSetRead("InOrOutHospLoc","combobox",1);
		if(AdmLoc!==""){
			RepSetValue("InOrOutHospLoc","combobox",AdmLoc);
		}else{
			RepSetValue("InOrOutHospLoc","combobox","");
		}
		// ��Ժ����
		RepSetRead("InOrOutHospDate","datebox",1);
		if(AdmType=="סԺ"){
			var AdminDate=Data.AdminDate;			
			if(AdminDate!=""){
				RepSetValue("InOrOutHospDate","datebox",AdminDate);
			}else{
				RepSetValue("InOrOutHospDate","datebox","");
			}
		}else if(AdmType=="����"){
			var AdmDate=Data.AdmDate;			// ��������
			if(AdmDate!=""){
				RepSetValue("InOrOutHospDate","datebox",AdmDate);
			}else{
				RepSetValue("InOrOutHospDate","datebox","");
			}
		}else{
			RepSetValue("InOrOutHospDate","datebox","");
		}
      	var DischgDate=Data.DischgDate;			// ��Ժ����
		RepSetRead("LeavHospTime","datebox",1);
      	if(DischgDate!=""){
			RepSetValue("LeavHospTime","datebox",DischgDate);
		}else {
			RepSetValue("LeavHospTime","datebox","");
		}				
		var PatOccupation=Data.PatOccupation;	// ����ְ��
		RepSetValue("AdmOfficeRank","combobox",PatOccupation);
		var PatBill=Data.PatBill;				// ҽ�����
		RepSetValue("MedicalCategory","combobox",PatBill);
		var PatDiag=Data.PatDiag;				// ���
		if(PatDiag!=""){
      		RepSetValue("PatDiag","input",PatDiag);
      	}else{
      		RepSetValue("PatDiag","input","");
      	}
      	RepSetRead("PatDiag","input",1);
      	var NurLevel=Data.NurLevel;				// ������
		RepSetValue("NursingLev","radio",NurLevel);
		
		var PatNational=Data.Nation;	// ����
		if(PatNational!==""){
			RepSetValue("PatNational","input",PatNational);
		}else{
			RepSetValue("PatNational","input","");
		}
		RepSetRead("PatNational","input",1);
      	var PatWeight=Data.Weight;			// ���� 
      	if(PatWeight!=""){
      		RepSetValue("PatWeight","input",PatWeight);
      	}else {
      		RepSetValue("PatWeight","input","");
      	}
      	RepSetRead("PatWeight","input",1);
      	// 2021-05-25 cy str
      	var PatAdmADLScore=Data.PatAdmADLScore;					// ��ԺʱADL�÷�
      	if(PatAdmADLScore!=""){
			RepSetValue("PatAdmADLScore","input",PatAdmADLScore);
			RepSetRead("PatAdmADLScore","input",1);	
			ChkPatSelfCareAbility(PatAdmADLScore);	
		}else {
			RepSetValue("PatAdmADLScore","input","");
			RepSetRead("PatAdmADLScore","input",0);		
		}
		var OccurADLScore=Data.OccurADLScore;					// ����ʱADL�÷�
      	if(OccurADLScore!=""){
			RepSetValue("OccurADLScore","input",OccurADLScore);
			RepSetRead("OccurADLScore","input",1);
			OccurPatSelfCareAbility(OccurADLScore);		
		}else {
			RepSetValue("OccurADLScore","input","");
			RepSetRead("OccurADLScore","input",0);		
		}
		//  2021-05-25 cy end

	},"json",false);
}

function SaveReportCom(flag)
{
	///����ǰ,��ҳ���������м��
	if(!checkRequired()){
		return;
	}

	var RepAuditList=""
	if ((adrReceive==2)||(adrReceive==4)){
		adrReceive=1;
	}
	if((adrReceive==$g("δ����"))&&(WinUserId==RepUser)){adrReceive="";}  //sufan 20200320 ��������ύ�ı��棬���˱༭����ɽ���״̬
	
	//if((flag==1)&&(adrReceive!=2)){
	//alert(RepAuditList)
	//}

	//���ݱ���/�ύ
	var mesageShow=""
	if(flag==0){
		mesageShow=$g("����");
	}
	if(flag==1){		
		mesageShow=$g("�ύ");
		adrReceive="";	
	}
	if(LgCtLocID==""){
		$.messager.alert($g("��ʾ")+":",$g("���ݱ���ʧ�ܣ������µ�½ҳ��")+"!");
		return ;	
	}
	RepAuditList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
	$.messager.confirm($g("��ʾ"), $g("�Ƿ�ȷ��")+mesageShow+$g("����"), function (res) {//��ʾ�Ƿ񱣴�
		if (res) {
			var RepMaxNo="";
			if($("#EventNum").val()==""){
				runClassMethod("web.DHCADVCOMMONPART","GetAdrRepMaxNo",{'CurCode':'ADV','NoLen':4,'formId':""},
				function(val){ 
					RepMaxNo=val;
					if(RepMaxNo.indexOf("msg")>=0){
						return ;	
					}
					if((RepMaxNo=="")||(RepMaxNo==-100)){
						$.messager.alert($g("��ʾ")+":",$g("����")+"!");
						return ;	
					}
					RepSetRead("EventNum","input",0);
					RepSetValue("EventNum","input",RepMaxNo);
					RepSetRead("EventNum","input",1);
					
				},"text",false)
			
			}
			runClassMethod("web.DHCADVCOMMONPART","SaveRepInfo",
			{
				'user':LgUserID,'formId':formId,
				'formVersion':$("#formVersion").val(),
				'par':loopStr("#from"),  //+"^"+loopStr("#popModalContent"),
				'recordId':recordId,
				'AuditList':RepAuditList,
				'locdr':LgCtLocID ,
				'EpisodeID':EpisodeID,
				'flag':flag,
				'order':OrdList,
				'LgParam':LgParam},
				function(val){ 
					var data=val.replace(/(^\s*)|(\s*$)/g,"").split("^");
					if (data[0]=="0") {
						$.messager.alert($g("��ʾ")+":",mesageShow+$g("�ɹ�")+"!");
						RepID=data[1];
						recordId=data[2];
						RepTypeDr=data[3];
						InitBasicInfoCom(RepID);
						if(flag==1){		
							$("#SubmitBut").hide(); // �������ύ��ť���ύ����ɹ��������ύ��ť		
							//window.location.href='layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID;//ˢ�´���adrDataListΪ��
							//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="layoutform.csp?recordId='+recordID+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&editFlag='+editFlag+'&RepID='+RepID+'&adrReceive='+adrReceive+'"></iframe>';
						}
						if(editFlag==1){
							if(((winflag!=2)&&(winflag!=3))||(flag!=0)){
								window.parent.CloseWinUpdate();
								window.parent.Query();
							}
						} 
					}else{
					
	  	 				if(val==-1){
		  	 				$.messager.alert($g("��ʾ")+":",$g("��Ȩ��")+"!");
						}else if(val==-2){
							$.messager.alert($g("��ʾ")+":",$g("�������һ��Ȩ��")+"!");
						}else if(val==-3){
							$.messager.alert($g("��ʾ")+":",$g("����Ȩ������")+"!");	
						}else if(val==-4){
							$.messager.alert($g("��ʾ")+":",$g("����������")+"!");
						}else if(val.indexOf("msg")>=0){
							$.messager.alert($g("��ʾ")+":",$g("��¼��ʱ")+"��"+$g("�����µ�¼")+"!");
						}else{
							$.messager.alert($g("��ʾ")+":",$g("����")+val+"!");
						}
					}
				
				},"text",false)
			}
	});
}
//���ر�����Ϣ
function InitReportCom(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		RepSetRead("ReportDate","datebox",1);
		RepSetValue("ReportDate","datebox",RepDate);		// ��������
		RepSetRead("ReportTime","input",1);		// ����ʱ��
		RepSetRead("PatName","input",1);		// ��������
		GetRepUserInfo(0);		
	}else{
		//������Ϣ
		RepSetRead("PatNo","input",1);							// �ǼǺ�
		RepSetRead("PatMedicalNo","input",1);						// ������
		RepSetRead("PatOrigin-label","radio",1);					// ������Դ
		RepSetRead("PatName","input",1);							// ��������
		RepSetRead("PatSexinput","input",1);						// �Ա�
		RepSetRead("PatAge","input",1);								// ����
		RepSetRead("PatDOB","datebox",1);							// ��������
		RepSetValue("PatDOB","datebox",$('#PatDOB').datebox('getValue'));
		RepSetRead("AdmBedNum","input",1);							// ��λ�� 
		RepSetRead("Physician","input",1);							// ����ҽʦ
		RepSetRead("HospTimes","input",1);							// סԺ����
		if($('#InOrOutHospLoc').combobox('getValue')!=""){
			RepSetRead("InOrOutHospLoc","combobox",1);
			RepSetValue("InOrOutHospLoc","combobox",$('#InOrOutHospLoc').combobox('getValue')); 	// ��Ժ/�������
		}
		if($('#InOrOutHospDate').datebox('getValue')!=""){
			RepSetRead("InOrOutHospDate","datebox",1);						
			RepSetValue("InOrOutHospDate","datebox",$('#InOrOutHospDate').datebox('getValue'));		// ��Ժ����
		}
		if($('#LeavHospTime').datebox('getValue')!=""){
			RepSetRead("LeavHospTime","datebox",1);						
			RepSetValue("LeavHospTime","datebox",$('#LeavHospTime').datebox('getValue'));			// ��Ժ����
		}else{ //hxy 2020-03-19 st
			RepSetRead("LeavHospTime","datebox",1);	 
		} //ed
		RepSetRead("PatDiag","input",1);							// ��������
		RepSetRead("ReportDate","datebox",1);						// ��������
		RepSetValue("ReportDate","datebox",$('#ReportDate').datebox('getValue'));
		RepSetRead("ReportTime","input",1);		// ����ʱ��		// ��������
		if($('#OccuLoc').combobox('getValue')!=""){
			RepSetRead("OccuLoc","combobox",1);
			RepSetValue("OccuLoc","combobox",$('#OccuLoc').combobox('getValue')); 				// ��������
		}
		RepSetRead("RepUserName","input",1);						// �������Ϊ��¼��
		// ������ְ��
		if($('#RepUserTitle').combobox('getValue')!=""){
			RepSetRead("RepUserTitle","combobox",1);		
			RepSetValue("RepUserTitle","combobox",$('#RepUserTitle').combobox('getValue')); 
		}
		
		RepSetRead("RepHospType","input",1);						// ���浥λ
		GetRepUserInfo(1);		
	}
	RepSetRead("EventNum","input",1);								// �¼���Ų��ɱ༭
	if(RepStaus==""){								// �¼���Ų��ɱ༭
		RepSetValue("ReportCardSta","input",$g("δ�ύ")); //���濨״̬
		RepSetRead("ReportCardSta","input",1);							// ���濨״̬���ɱ༭	
	}
}
function GetRepUserInfo(RepFlag){

	// ��ȡ��¼�� ��Ϣ
	runClassMethod("web.DHCADVCOMMONPART","GetRepUserInfo",{'UserID':LgUserID,'LocID':LgCtLocID,'HospID':LgHospID,'GroupID':LgGroupID},
	function(Data){ 
      	if(RepFlag==0){
			var CTCptDesc=Data.CTCptDesc;				// ���ְ��  
			if(CTCptDesc!=""){
				RepSetRead("RepUserTitle","combobox",1);		
				RepSetValue("RepUserTitle","combobox",CTCptDesc); 
			}
			RepSetRead("OccuLoc","combobox",0);			// ��������
			RepSetValue("OccuLoc","combobox",Data.LocDesc);			
			RepSetValue("RepHospType","input",Data.HospDesc);		// ���浥λ
			RepSetRead("RepHospType","input",1);
			RepSetValue("RepUserName","input",Data.User);		// �������Ϊ��¼��
			RepSetRead("RepUserName","input",1);
			LgGroupDesc=Data.GroupDesc;
		}
		if(RepFlag==1){
			LgGroupDesc=Data.GroupDesc;
			LgUserName=Data.User;
		}
	},"json",false);
}
//congyue 2017-09-06 �����ҳͼ�꣬������ҳ
function Gologin(){
	if((RepID=="")){   //sufan ����ID���˺󣬴����б�����
		$.messager.confirm($g("��ʾ"), $g("��Ϣδ����,�Ƿ��������"), function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				location.href='dhcadv.homepage.csp';
			}else{
				return false;
			}
		})
	}else{
		location.href='dhcadv.homepage.csp';
	}
	
}
//congyue 2017-09-06 �����˵���תҳ��(�����ҳ�������תҳ��)
function InterfaceJump(code,desc){
	if (code=="index"){
		Gologin();
	}else{
		var Rel='dhcadv.layoutform.csp?code='+code+'&desc='+desc;
		location.href=Rel;
	}
}

//�༭����  ר����������
function assessmentRep()
{
	if($('#assessmentwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="assessmentwin"></div>');
	$('#assessmentwin').window({
		title:$g('��������'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:screen.availWidth-300,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-150,
		top:$('body').scrollTop()+(50/8)
	});
	//��������׷�ټ�¼��
	var AssWinRecId=GetAssessRecordID("RepComEvaluate");
	var AssWinCode="RepComEvaluate";
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+AssWinRecId+'&code='+AssWinCode+'&LinkRecordId='+recordId+'&AuditList='+escape(AuditList)+'&CancelAuditList='+escape(CancelAuditList)+'&StaFistAuditUser='+escape(StaFistAuditUser)+'&StsusGrant='+escape(StsusGrant)+'&RepStaus='+escape(RepStaus)+'&EvaFlagList='+escape(EvaFlagList)+'"></iframe>'; 
	//var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.newrepmanage.csp?RepID='+RepID+'&RepTypeDr='+RepTypeDr+'&RepType='+RepType+'"></iframe>';
	$('#assessmentwin').html(iframe);
	$('#assessmentwin').window('open');
	ConWinSroll("assessmentwin");
}
function closeRepWindow(assessID)   //wangxuejian 2016-10-09      �ر���������
{   
	//2017-06-12 �����������������޸�
	if(assessID!=""){
		$("#SaveBut").hide();
		$("#Back").css("margin-left","400px"); //�������� hxy 2018-05-30
		$("#SubmitBut").hide();
	}
	$('#assessmentwin').window('close');
}
///2017-11-13 congyue  ��ӻ�ȡ���˲˵���Ϣ����
function dhcadvdhcsys_getmenuform(){
	var frm = null;
	try{
		var win=top.frames['eprmenu'];
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if(frm) return frm;
		}
		//���´��ڴ򿪵Ľ���
		win = opener;
		if (win) {
			frm = win.document.forms['fEPRMENU'];
			if (frm) return frm;
		}
		win = parent.frames[0];
		if (win){
			frm = win.document.forms["fEPRMENU"];
			if (frm) return frm;
		}
		if (top){
			frm =top.document.forms["fEPRMENU"];
			if(frm) return frm
		}
	}catch(e){}
	return frm;
}
//�ǼǺ��Զ���0
function getRegNo(regno)
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
//ͨ��סԺ�ţ������ţ����ǼǺ� ��ȡ���˻�����Ϣ
function ReportEnter(){
	var patientNO="",actiontype="",PatOrigin="",PatOrigintype="";
	if((recordId!="")&&(recordId!=undefined)){
		return ;
	}else{
		$('#PatMedicalNo').bind('keydown',function(event){
			if(event.keyCode == "13")    
			{
				patientNO=$('#PatMedicalNo').val();
				if (patientNO=="")
				{
					$.messager.alert($g("��ʾ")+":",$g("�����Ų���Ϊ��")+"��");
					return false;
				}
				if($("#admnogrid").length>0)
				{
				   $("#admnogrid").remove(); 
				   $("#admdsgrid").remove(); 
				}
				GetGridWin(patientNO,"PatMedicalNo","GetAdmList","admgrid");
			}
		});
		$('#PatNo').bind('keydown',function(event){
			if(event.keyCode == "13")    
			{
				patientNO=$('#PatNo').val();
				if (patientNO=="")
				{
					$.messager.alert($g("��ʾ")+":",$g("�ǼǺŲ���Ϊ��")+"��");
					return false;
				}
				patientNO=getRegNo(patientNO); //�ǼǺŲ�0
				if($("#admgrid").length>0)
				{
				   $("#admgrid").remove(); 
				   $("#admdsgrid").remove(); 
				}
				GetGridWin(patientNO,"PatNo","GetAdmDs","admnogrid");
			}
		});
	}
	
}
//ͨ��סԺ�ţ������ţ����ǼǺ� ��ȡ���˻�����Ϣ
function GetGridWin(patientNO,id,actiontype,tableid){
	var input=input+'&StkGrpRowId=&StkGrpType=G&Locdr=&NotUseFlag=N&QtyFlag=0&HospID=' ;
	var mycols = [[
		{field:'RegNo',title:$g('����id'),width:80},
		{field:'AdmTypeDesc',title:$g('��������'),width:60}, 
		{field:'AdmLoc',title:$g('�������'),width:120}, 
		{field:'AdmDate',title:$g('��������'),width:80},
		{field:'AdmTime',title:$g('����ʱ��'),width:70},
		{field:'Adm',title:'Adm',width:60,hidden:true} 
	]];
	var mydgs = {
		url:'dhcadv.repaction.csp'+'?action='+actiontype+'&Input='+patientNO+'&Type='+""+'&LgHospID='+LgHospID , //hxy 2020-02-18 +'&LgHospID='+LgHospID 
		columns: mycols,  //����Ϣ
		nowrap:false,
		pagesize:10,  //һҳ��ʾ��¼��
		table: '#admdsgrid', //grid ID
		field:'Adm', //��¼Ψһ��ʶ
		params:null,  // �����ֶ�,��Ϊnull
		tbar:null //�Ϲ�����,��Ϊnull
	}
	var win=new CreatMyDiv(input,$("#"+id),tableid,"460px","335px","admdsgrid",mycols,mydgs,"","",SetAdmIdTxtVal);	
	win.init();
}
//��ȡ������/�ǼǺ�ѡ���¼����
function SetAdmIdTxtVal(rowData)
{
	if((rowData.Adm!=undefined)&&(EpisodeID!="")&&(rowData.Adm!=EpisodeID)){   //sufan ����ID���˺󣬴����б�����
		$.messager.confirm($g("��ʾ"), $g("��Ϣδ����,�Ƿ��������"), function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				freshflag=1
				EpisodeID=rowData.Adm==undefined?"":rowData.Adm;
				location.href='dhcadv.layoutform.csp?code='+RepTypeCode+'&freshflag='+freshflag+'&TmpEpisodeID='+EpisodeID;
				/* EpisodeID=rowData.Adm==undefined?EpisodeID:rowData.Adm;   //sufan 2019-11-12 ����Ѿ�ѡ���˻��ߣ����ֶ��رյǼǺŴ��ڻ��ԭ���ľ���id��Ϊ""
				if(EpisodeID==undefined){
					EpisodeID="";
				}
				InitPatInfoCom(EpisodeID);	 */
			}else{
				InitPatInfo(EpisodeID);
				return false;
			}
		})
	}else{
		EpisodeID=rowData.Adm==undefined?EpisodeID:rowData.Adm;
		InitPatInfo(EpisodeID);
	}
}
function bindEnter(){
	var suspectWin='<div id="mwin">';
	    suspectWin+='<div class="easyui-layout" fit="true">';
	    suspectWin+='<div region="north"  style="width:100%;height:30px">'
	    suspectWin+='<div id="dlg-buttons">';
        suspectWin+='<table cellpadding="0" cellspacing="0" style="width:100%">'
		suspectWin+='<tr>'
		suspectWin+='<td style="text-align:left">'		
		suspectWin+='<button  id="addDrg" class="dhcc-btn" style="margin-left:5px;margin-top:1px"">$g("���")</button>';
		suspectWin+='<button  class="dhcc-btn" style="margin-left:5px;margin-top:1px" onclick="clsDrgWin()">$g("ȡ��")</button>';	
		suspectWin+='</td>'			
		suspectWin+='</tr>'		
		suspectWin+='</table>'	
		suspectWin+='</div>'
		suspectWin+='</div>'
		suspectWin+='<div region="center" style="width:100%;height:430px">';
		suspectWin+='<div id="medInfo"></div>';
		suspectWin+='</div>';
		suspectWin+='</div>';
	    suspectWin+='</div>';
	$('body').append(suspectWin);
	var height=510,width=1000; //hxy 2018-01-22 
	var top=Math.round((window.screen.height-height)/2); 
    var left=Math.round((window.screen.width-width)/2);  
	$('#mwin').window({
		title:$g('��ҩ�б�'),
		collapsible:false,
		collapsed:false, 
		border:false,
		closed:"true",
		minimizable: false, 
		maximizable: false,
		width:1000,
		height:510,
		top:top,
		left:left,
		resizable:false
	});	
   
	$("input[id^='SuspectNewDrug-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   if(EpisodeID==""){
			   $.messager.alert('Warning',$g('����ѡ���߾����¼')+'��');
			   return;
			   }
		   drgname=$(this).attr("name")
           showDrugListWin();
        }
    });
    $("input[id^='BlendNewDrug-']").live('keydown',function(event){	
		 if(event.keyCode == "13")    
		 {
		   if(EpisodeID==""){
			   $.messager.alert('Warning',$g('����ѡ���߾����¼')+'��');
			   return;
			 }
		   drgname=$(this).attr("name")
           showDrugListWin();
        }
    });
	}
function showDrugListWin(){
	InitPatMedGrid();
	$('#mwin').window('open');
	//�����Ӱ�ť
	$("#addDrg").click(function(){
		addDrg()
		});
	}
	
	
//��ʼ��������ҩ�б�
function InitPatMedGrid()
{
	//����columns
	var columns=[[
		{field:"orditm",title:'orditm',width:90,hidden:true},
		{field:'phcdf',title:'phcdf',width:80,hidden:true},
		{field:'incidesc',title:$g('����'),width:140},
		{field:'genenic',title:$g('ͨ����'),width:140},
	    {field:'batno',title:$g('��������'),width:60,hidden:true},
	    {field:'staDate',title:$g('��ʼ����'),width:60,hidden:true},
	    {field:'endDate',title:$g('��������'),width:60,hidden:true},
		{field:'genenicdr',title:'genenicdr',width:80,hidden:true},
		{field:'dosage',title:$g('����'),width:60},
		{field:'dosuomID',title:'dosuomID',width:80,hidden:true},
		{field:'instru',title:$g('�÷�'),width:80},
		{field:'instrudr',title:'instrudr',width:80,hidden:true},
		{field:'freq',title:$g('Ƶ��'),width:40},//priorty
		{field:'priorty',title:$g('���ȼ�'),width:60},//priorty
		{field:'freqdr',title:'freqdr',width:80,hidden:true},
		{field:'duration',title:$g('�Ƴ�'),width:40},
		{field:'durId',title:'durId',width:80,hidden:true},
		{field:'apprdocu',title:$g('��׼�ĺ�'),width:140},
		{field:'manf',title:$g('����'),width:140},
		{field:'manfdr',title:'manfdr',width:80,hidden:true},
		{field:'form',title:$g('����'),width:80},
		{field:'formdr',title:'formdr',width:80,hidden:true}
	]];
	
	//����datagrid
	$('#medInfo').datagrid({
		url:'',
        fit:true,
		border:false,
		rownumbers:false,
		columns:columns,
		pageSize:15,  // ÿҳ��ʾ�ļ�¼����
		pageList:[15,30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true
	});
	$('#medInfo').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetPatOEInfo',	
		queryParams:{
			params:EpisodeID}
	});
	
	$('#medInfo').datagrid('reload'); //���¼���
}

//�رղ�����ҩ����
function clsDrgWin()
{
	$('#mwin').window('close');
}

//���ҩƷ
function addDrg()
{   
       var row = $('#medInfo').datagrid('getSelected');
	   if(row==""){	
	    $.messager.alert("warning",$g("��ѡ������ҩƷ��"));
		return;
	    }
	  clsDrgWin();
      var $td =$("input[name='"+drgname+"'][type=input]").parent().parent().children('td');
      $td.eq(0).find("input").val(row.apprdocu);
      $td.eq(1).find("input").val(row.incidesc);
      $td.eq(2).find("input").val(row.genenic+"/["+row.form+"]");
      $td.eq(3).find("input").val(row.manf) 
      $td.eq(5).find("input").val(row.dosage+"/"+row.instru+"/"+row.freq);
      $td.eq(6).find("input").datebox("setValue",row.staDate); 
      $td.eq(7).find("input").datebox("setValue",row.endDate); 
  
}

function GetAssessRecordID(AssWinCode){
	var AssWinRecId="";
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':AssWinCode},
		function(data){ 
			 AssWinRecId=data
	},"text",false) 
	return AssWinRecId;
}
//�༭����  2018-04-13 cy ���۽���
function showAssessmentWin(AssWinCode,AssWinRecId)
{
	if($('#assewin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="assewin"></div>');
	$('#assewin').window({
		title:LgGroupDesc+$g('����'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:screen.availWidth-150,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:screen.availHeight-150,
		top:$('body').scrollTop()+(50/8)
	});
	
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+AssWinRecId+'&code='+AssWinCode+'&LinkRecordId='+recordId+'&AuditList='+escape(AuditList)+'&CancelAuditList='+escape(CancelAuditList)+'&StaFistAuditUser='+escape(StaFistAuditUser)+'&StsusGrant='+escape(StsusGrant)+'&RepStaus='+escape(RepStaus)+'&EvaFlagList='+escape(EvaFlagList)+'&AdmID='+escape(EpisodeID)+'"></iframe>'; 
	$('#assewin').html(iframe);
	$('#assewin').window('open');
	ConWinSroll("assewin");
}
//2018-04-14 �ر����۴���
function CloseAsseWin(){
	$('#assewin').window('close');
}
//�༭����  2018-05-07 cy ת�����
function showPatOutcomWin(PatOutWinCode)
{
	if($('#patoutwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="patoutwin"></div>');
	$('#patoutwin').window({
		title:$g('����ת��'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:800,    ///2017-11-23  cy  �޸ĵ��������С 1250
		height:400,
		top:$('body').scrollTop()+((screen.availHeight-400)/4)
	});
	 runClassMethod("web.DHCADVCOMMONPART","GetRecordId",
		{'LinkRecordId':recordId,
		 'FormCode':PatOutWinCode},
		function(data){ 
			 PatOutWinRecId=data
	},"text",false) 
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+PatOutWinRecId+'&code='+PatOutWinCode+'&LinkRecordId='+recordId+'&RepID='+RepID+'"></iframe>'; 
	$('#patoutwin').html(iframe);
	$('#patoutwin').window('open');
	ConWinSroll("patoutwin");
}
//2018-05-09 �ر�ת�鴰��
function ClosePatOutWin(){
	$('#patoutwin').window('close');
}
//radio��checkbox���ݻ�ȡ
function radioValue(param,data){
	//alert(param);
	var ret=[]
	
	if(param==="") return "";
	paramArray = param.split(",");
	
	for(var i =0;i<paramArray.length;i++){
		if($getValue(data[paramArray[i]])!=""){
			ret.push($getValue(data[paramArray[i]]));
		}
	}
	
	return ret.join("�� ");
}

//radio��checkbox���ݻ�ȡ  ������Ԫ��ƴ��
function checksubValue(data,param,subdata){
	//alert(param);
	var ret=[]
	if(param==="") return "";
	paramArray = param.split(",");
	for(var i =0;i<paramArray.length;i++){
		if($getValue(subdata[paramArray[i]])!=""){
			ret.push($getValue(subdata[paramArray[i]]));
		}
	}
	if (ret.join("�� ")!=""){
		data=data+"��"+ret.join("�� ")+"��";
	}
	return data;
}
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="��";
	}
	return ret;
}
//������ �ƻ�ʿ�����۸�ֵ
function SetLocHeaNurInfo(data){
	var List="";
	var MeetDate=$getValue(data["MeetDate"]); //��������
	if(MeetDate!=""){List=List+"\n"+$g("��������")+"��"+MeetDate+"��";}
	var MeetTime=$getValue(data["MeetTime"]); //����ʱ��
	if(MeetTime!=""){List=List+$g("����ʱ��")+"��"+MeetTime+"��";}
	var MeetPlace=$getValue(data["MeetPlace"]); //����ص�
	if(MeetPlace!=""){List=List+$g("����ص�")+"��"+MeetPlace+"��";}
	var Participants=$getValue(data["Participants"]); //�λ���Ա
	if(Participants!=""){List=List+$g("�λ���Ա")+"��"+Participants+"��";}
	//������������ 
	var LocCaseTimeliness=radioValue("LocCaseTimeliness-94432,LocCaseTimeliness-94433",data); 
	if(LocCaseTimeliness!=""){List=List+"\n"+$g("���Ұ���������ʱ��")+"��"+LocCaseTimeliness+"��";}
	var FindReason=radioValue("FindReason-94434,FindReason-94435",data); 
	if(FindReason!=""){List=List+"\n"+$g("ԭ������ҵ�����")+"��"+FindReason+"��";}
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",data); 
	if(BefPreventMeasures!=""){List=List+"\n"+$g("����ǰ������ʩ��ʵ���")+"��"+BefPreventMeasures+"��";}
	var BefPreventMeasuresipt=$getValue(data["BefPreventMeasures-94439"]);  //�������
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures=="")){
		List=List+"\n"+$g("����ǰ������ʩ��ʵ���")+"��"+$g("δ��ʵ�������")+"��"+BefPreventMeasuresipt+"��";
	}
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		List=List+$g("δ��ʵ�������")+"��"+BefPreventMeasuresipt+"��";
	}
	var BefPreMeaReason=radioValue("BefPreMeaReason-94441,BefPreMeaReason-94442,BefPreMeaReason-94443,BefPreMeaReason-94444,BefPreMeaReason-94445,BefPreMeaReason-94446,BefPreMeaReason-94447,BefPreMeaReason-94448",data); 
	if(BefPreMeaReason!=""){List=List+"\n"+$g("����ǰ������ʩδ��ʵ��ԭ��")+"��"+$g("�������")+"��"+BefPreMeaReason+"��";}
	var AftImpPertinence=radioValue("AftImpPertinence-94449,AftImpPertinence-94450",data); 
	if(AftImpPertinence!=""){List=List+"\n"+$g("�¼����������Ĵ�ʩ�������")+"��"+AftImpPertinence+"��";}
	var AftImpTimeliness=radioValue("AftImpTimeliness-94451,AftImpTimeliness-94452",data); 
	if(AftImpTimeliness!=""){List=List+"\n"+$g("�¼����������Ĵ�ʩ��ʵ�ļ�ʱ��")+"��"+AftImpTimeliness+"��";}
	var HeadNurReformMark=radioValue("HeadNurReformMark-94453,HeadNurReformMark-94454",data); 
	if(HeadNurReformMark!=""){List=List+"\n"+$g("��ʿ��������ʵ�ĺۼ�")+"��"+HeadNurReformMark+"��";}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n"+$g("�����¼��д")+"��"+ManaIfStandard+"��";}
	var LocHeadView=$getValue(data["LocHeadView"]);  //������
	if(LocHeadView!=""){List=List+"\n"+$g("������")+"��"+LocHeadView+"��";}

	// �ֳ���������
	var ListLocaleEvaluate=""                           //�ֳ���������Ӵ�
	var LocHeadNurEvaluate=$getValue(data["LocHeadNurEvaluate"]);
	var LocHeadNurEvaluatelen=LocHeadNurEvaluate.length; //�ƻ�ʿ�����۸���
	var LocHeadNurEvaluateList=$g("�ƻ�ʿ��Ч������")+"��";
	for(var k=0;k<LocHeadNurEvaluatelen;k++){
		var LHNElist="\n<font style='font-Weight:bold;'>"+$g('��¼')+(k+1)+"</font>��"
		//var LHNElist="\n��¼"+(k+1)+"��"
		var LHNEdate=$getValue(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94422-94427"]); //����ʱ��
		if(LHNEdate!=""){LHNElist=LHNElist+$g("����ʱ��")+"��"+LHNEdate+"��";}
		var LHNEobject=$getValue(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94423-94428"]); //�������
		if(LHNEobject!=""){LHNElist=LHNElist+$g("�������")+"��"+LHNEobject+"��";}
		var LHNEcontent=$getValue(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94424-94429"]); //��������
		if(LHNEcontent!=""){LHNElist=LHNElist+$g("��������")+"��"+LHNEcontent+"��";}		
		var LHNEresult=$getValue(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94425-94430"]); //������
		if(LHNEresult!=""){LHNElist=LHNElist+$g("������")+"��"+LHNEresult+"��";}		
		var LHNEpeople=$getValue(LocHeadNurEvaluate[k]["LocHeadNurEvaluate-94416-94425-94431"]); //������
		if(LHNEpeople!=""){LHNElist=LHNElist+$g("������")+"��"+LHNEpeople+"��";}		
		LocHeadNurEvaluateList=LocHeadNurEvaluateList+LHNElist
	}
	if(LocHeadNurEvaluateList!=""){ListLocaleEvaluate=ListLocaleEvaluate+LocHeadNurEvaluateList;}
	var LHNrow=0
	var LHNList=List.split("\n")
	var LHNlen=LHNList.length;
	for(i=0;i<LHNlen;i++){
		LHNrow=LHNrow+parseInt(LHNList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var LHNheightlen=(LHNrow+LocHeadNurEvaluatelen)*18;
	$("#LocHeadNurEvale").css({
		"height":LHNheightlen
	});	
	$('#LocHeadNurEvale').val(List);
	$('#LocHeadNurEvale').append('<div id="LocaleEvaluate"></div>');  
	$('#LocaleEvaluate').html(ListLocaleEvaluate);
}

//������ �������۸�ֵ
function SetNurDepInfo(data){
	var List="";
	var MeetDate=$getValue(data["MeetDate"]); //��������
	if(MeetDate!=""){List=List+"\n"+$g("��������")+"��"+MeetDate+"��";}
	var MeetTime=$getValue(data["MeetTime"]); //����ʱ��
	if(MeetTime!=""){List=List+$g("����ʱ��")+"��"+MeetTime+"��";}
	var MeetPlace=$getValue(data["MeetPlace"]); //����ص�
	if(MeetPlace!=""){List=List+$g("����ص�")+"��"+MeetPlace+"��";}
	var Participants=$getValue(data["Participants"]); //�λ���Ա
	if(Participants!=""){List=List+$g("�λ���Ա")+"��"+Participants+"��";}
	//������������ 
	
	var RepLevel=radioValue("RepLevel-94496,RepLevel-94498,RepLevel-94499,RepLevel-94500,RepLevel-94501,RepLevel-94502",data); 
	if(RepLevel!=""){List=List+"\n"+$g("�������¼�����")+"��"+RepLevel+"��";}
	var MLocCaseTimeliness=radioValue("MLocCaseTimeliness-94503,MLocCaseTimeliness-94504",data); 
	if(MLocCaseTimeliness!=""){List=List+"\n"+$g("���Ұ���������ʱ��")+"��"+MLocCaseTimeliness+"��";}
	var HadeLocCaseTimeliness=radioValue("HadeLocCaseTimeliness-94505,HadeLocCaseTimeliness-94506",data); 
	if(HadeLocCaseTimeliness!=""){List=List+"\n"+$g("����Ұ�������")+"��"+HadeLocCaseTimeliness+"��";}
	var FindReason=radioValue("FindReason-94434,FindReason-94435",data); 
	if(FindReason!=""){List=List+"\n"+$g("ԭ������ҵ�����")+"��"+FindReason+"��";}
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",data); 
	if(BefPreventMeasures!=""){List=List+"\n"+$g("����ǰ������ʩ��ʵ���")+"��"+BefPreventMeasures+"��";}
	var BefPreventMeasuresipt=$getValue(data["BefPreventMeasures-94439"]);  //�������
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures=="")){
		List=List+"\n"+$g("����ǰ������ʩ��ʵ���")+"��"+$g("δ��ʵ�������")+"��"+BefPreventMeasuresipt+"��";
	}
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		List=List+$g("δ��ʵ�������")+"��"+BefPreventMeasuresipt+"��";
	}
	var BefPreMeaReason=radioValue("BefPreMeaReason-94441,BefPreMeaReason-94442,BefPreMeaReason-94443,BefPreMeaReason-94444,BefPreMeaReason-94445,BefPreMeaReason-94446,BefPreMeaReason-94447,BefPreMeaReason-94448",data); 
	if(BefPreMeaReason!=""){List=List+"\n"+$g("����ǰ������ʩδ��ʵ��ԭ��")+"��"+$g("�������")+"��"+BefPreMeaReason+"��";}
	var AftImpPertinence=radioValue("AftImpPertinence-94449,AftImpPertinence-94450",data); 
	if(AftImpPertinence!=""){List=List+"\n"+$g("�¼����������Ĵ�ʩ�������")+"��"+AftImpPertinence+"��";}
	var AftImpTimeliness=radioValue("AftImpTimeliness-94451,AftImpTimeliness-94452",data); 
	if(AftImpTimeliness!=""){List=List+"\n"+$g("�¼����������Ĵ�ʩ��ʵ�ļ�ʱ��")+"��"+AftImpTimeliness+"��";}
	var HeadNurReformMark=radioValue("HeadNurReformMark-94453,HeadNurReformMark-94454",data); 
	if(HeadNurReformMark!=""){List=List+"\n"+$g("��ʿ��������ʵ�ĺۼ�")+"��"+HeadNurReformMark+"��";}
	var LocHeadNurReformMark=radioValue("LocHeadNurReformMark-94507,LocHeadNurReformMark-94508",data); 
	if(LocHeadNurReformMark!=""){List=List+"\n"+$g("�ƻ�ʿ��Ч�����ۺۼ�")+"��"+LocHeadNurReformMark+"��";}
	var ManaIfStandard=radioValue("ManaIfStandard-94455,ManaIfStandard-94456",data); 
	if(ManaIfStandard!=""){List=List+"\n"+$g("�����¼��д")+"��"+ManaIfStandard+"��";}
	
	//�¼������뿼��
	var InSkiUlcQualita=radioValue("InSkiUlcQualita-94509,InSkiUlcQualita-94510",data); 
	if(InSkiUlcQualita!=""){List=List+"\n"+$g("Ժ��ѹ���¼�����")+"��"+InSkiUlcQualita+"��";}
	var DrugErrQualita=radioValue("DrugErrQualita-94511,DrugErrQualita-94512,DrugErrQualita-94513,DrugErrQualita-94514",data); 
	if(DrugErrQualita!=""){List=List+"\n"+$g("��ҩȱ���¼�����")+"��"+DrugErrQualita+"��";}
	var OthQualita=radioValue("OthQualita-94515,OthQualita-94516",data); 
	if(OthQualita!=""){List=List+"\n"+$g("�����¼�����")+"��"+OthQualita+"��";}
	var OverEvaluation=radioValue("OverEvaluation-94517,OverEvaluation-94518,OverEvaluation-94519",data); 
	if(OverEvaluation!=""){List=List+"\n"+$g("��������")+"��"+OverEvaluation+"��";}
	var NextStep=radioValue("NextStep-94520,NextStep-94521,NextStep-94522",data); 
	if(NextStep!=""){List=List+"\n"+$g("��һ��Ҫ��")+"��"+NextStep+"��";}
	var NurDepAdvice=$getValue(data["NurDepAdvice"]);  //�������
	if(NurDepAdvice!=""){List=List+"\n"+$g("�������")+"��"+NurDepAdvice+"��";}

	// ����׷�ټ�¼
	var ListTraRecord=""                           //׷�ټ�¼����Ӵ�
	var NurDepRecord=$getValue(data["NurDepRecord"]);
	var NurDepRecordlen=NurDepRecord.length; //�ƻ�ʿ�����۸���
	var NurDepRecordList=$g("����׷�ټ�¼")+"��";
	for(var k=0;k<NurDepRecordlen;k++){
	//	var NDRlist="\n��¼"+(k+1)+"��"
		var NDRlist="\n<font style='font-Weight:bold;'>"+$g("��¼")+(k+1)+"</font>��" 
		var NDRdate=$getValue(NurDepRecord[k]["NurDepRecord-94470-94476-94480"]); //����
		if(NDRdate!=""){NDRlist=NDRlist+$g("����")+"��"+NDRdate+"��";}
		var NDRmode=radioValue("NurDepRecord-94470-94477-94481,NurDepRecord-94470-94477-94482,NurDepRecord-94470-94477-94483,NurDepRecord-94470-94477-94484",data); //��ʽ
		if(NDRmode!=""){NDRlist=NDRlist+$g("��ʽ")+"��"+NDRmode+"��";}
		var NDRcontent=$getValue(NurDepRecord[k]["NurDepRecord-94470-94478-94485"]); //����
		if(NDRcontent!=""){NDRlist=NDRlist+$g("����")+"��"+NDRcontent+"��";}		
		var NDRpeople=$getValue(NurDepRecord[k]["NurDepRecord-94470-94479-94486"]); //��¼��
		if(NDRpeople!=""){NDRlist=NDRlist+$g("��¼��")+"��"+NDRpeople+"��";}		
		NurDepRecordList=NurDepRecordList+NDRlist
	}
	if(NurDepRecordList!=""){ListTraRecord=ListTraRecord+NurDepRecordList;}
	var NDrow=0
	var NDList=List.split("\n");
	var NDlen=NDList.length;
	for(i=0;i<NDlen;i++){
		NDrow=NDrow+parseInt(NDList[i].length/60)+1;
	}
	//var HNrow=parseInt(HeadNurEvaList.length/60);
	var NDheightlen=(NDrow+1+NurDepRecordlen)*18;
	$("#NurDepEvale").css({
		"height":NDheightlen
	});	
	
	$('#NurDepEvale').val(List);
	$('#NurDepEvale').append('<div id="TraRecord"></div>');
	$('#TraRecord').html(ListTraRecord);
}
//��� ����
function RepAudit()
{
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	if (FileFlag==$g("�ѹ鵵")){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ��������ѹ鵵����")+"��"+$g("���ܲ���")+"��");
		return;
	}
	$('#Process').window({
		title:$g('���'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		closable:true,
		modal:true,
		width:400,
		height:420,
		top:$('body').scrollTop()+((screen.availHeight-400)/4)
	});
	//ָ����� 2018-07-05 cy ָ����Ҽ�Ϊ���ɿ���
	$('#matadrNextLoc').combobox({
		//url:url+'?action=QueryAuditLocList&RepID='+RepID+'&RepTypeCode='+RepTypeCode+'&CurStatusDR='+StatusNextID,
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=QueryAuditLocList&RepID='+RepID+'&RepTypeCode='+RepTypeCode+'&CurStatusDR='+StatusNextID+'&HospId='+LgHospID,  // 2021-04-30 cy ��Ժ������
		onLoadSuccess:function(){
			var NextLocdata=$("#matadrNextLoc").combobox('getData'); 
			NextLocFlag=NextLocdata.length;
			if(NextLocFlag==0){
				$('#NextLocList').hide();
			}else{
				$('#NextLocList').show();
			}
		}
	}); 
	
	$('#Process').window('open'); 
	$("#matadrLocAdvice").empty();
	$("#matadrRecProgress").empty(); // 2018-07-12 �����ʵ�������
	ConWinSroll("Process");
}
//ȷ������  2018-04-24
function RepConfirmAudit()
{	
	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	if ((NextLocFlag>0)&&(NextLoc=="")){
		$.messager.alert($g("��ʾ")+":",$g("����ָ����Ϊ��")+"��");
		return;
	}
	var RecProgress=$.trim($('#matadrRecProgress').val());
	if (RecProgress==""){
		$.messager.alert($g("��ʾ")+":",$g("�����ʵ����Ϊ��")+"��");
		return;
	}
	RecProgress = $_TrsSymbolToTxt(RecProgress); /// �����������	
	var LocAdvice=$.trim($('#matadrLocAdvice').val());
	if (LocAdvice==""){
		$.messager.alert($g("��ʾ")+":",$g("�����������Ϊ��")+"��");
		return;
	}
	LocAdvice = $_TrsSymbolToTxt(LocAdvice); /// �����������	
	var params=RepID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RecProgress;   //������
	
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':params,'LgParam':LgParam},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert($g("��ʾ")+":",$g("��˴���")+","+$g("����ԭ��")+":"+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
		}
		if(jsonString.ErrCode == 0){
			if(editFlag==1){
				runClassMethod("web.DHCADVFormRecord","SaveRecord",
				{'user':LgUserID,'formId':formId,'formVersion':$("#formVersion").val(),'par':loopStr("#from"),'recordId':recordId},
				function(datalist){ 
					var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
					if (data[0]!="0") {
						return;
					}
				},"text")
			}
			if(winflag==3){
				$.messager.alert($g("��ʾ")+":",$g("��˳ɹ�")+"��");   
			}else{
				window.parent.CloseWinUpdate();
				window.parent.Query();
			}
		}
	},"json");
		
}
//�������� 2018-04-24
function RepCancelAuditBt()
{	var NextLoc=""; //$('#matadrNextLoc').combobox('getValue');
	var RecProgress="";
	var LocAdvice=""; //$('#matadrLocAdvice').val();
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert($g("��ʾ")+":",$g("����Ϊ���ر���")+"��"+$g("��δ���ظ���ǰ��¼��")+"��"+$g("��Ȩ�޳������")+"��" );
		return;
	}
	var params=RepID+"^"+StatusLastID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RecProgress;   //������
	var mesageShow="";
	if(StatusLastID==""){ //2018-01-17
		mesageShow=$g("ȡ���ύ");
    }else{
		mesageShow=$g("ȡ�����");            
    }
	//��������
	$.messager.confirm($g("��ʾ")+":", $g("�Ƿ�ȷ��")+mesageShow+$g("����"), function (res) {//��ʾ�Ƿ񱣴�
	if (res) {

		runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':params},
		function(jsonString){ 
			//var resobj = jQuery.parseJSON(jsonString);
			//var num=$('#maindg').datagrid("getRowIndex",item)+1; //2017-04-06  ��ȡ���� ������һ�в�������
			if(jsonString.ErrCode < 0){
				$.messager.alert($g("��ʾ")+":",$g("������˴���")+","+$g("����ԭ��")+":"+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
			}
			if(jsonString.ErrCode == 0){
				if(winflag==3){
					$.messager.alert($g("��ʾ")+":",$g("������˳ɹ�")+"��");   
				}else{
					window.parent.CloseWinUpdate();
					window.parent.Query();
				}
			}
		},"json");
	}
	})
		
}
//���� 2018-04-24
function RejectWin()
{
	var RepFileFlag=""; //�鵵״̬ 2018-01-23
	if (FileFlag==$g("�ѹ鵵")){
		RepFileFlag="-1";
	}
	
	if (RepFileFlag=="-1"){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ��������ѹ鵵����")+"��"+$g("���ܲ���")+"��");
		return;
	}
	$('#RetWin').window({
		title:$g('����'),
		collapsible:false,
		border:false,
		closed:false,
		minimizable:false,
		maximizable:false,
		closable:false,
		modal:true,
		width:400,
		height:280,
		top:$('body').scrollTop()+((screen.availHeight-280)/4)
	}); 
	//����ָ�� ״̬
	$('#RevStatus').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetRevStatusComboxNew&EvenCode='+RepTypeCode+'&Status='+RepStausDr+'&RepID='+RepID //"NursingRep"
	});
	//if (LgGroupDesc!="����"){
		//$('#RevStatus').combobox({disabled:true});;  //����ָ��
		$('#RevStatus').combobox('setValue',RepStausDr);  //����ָ��
	//}
	$('#RetWin').window('open'); 
	$("#retreason").empty(); 
	ConWinSroll("RetWin");
}
//ȷ�ϲ��� 2018-04-24
function BackBt()
{
	var NextLoc="";
	var LocAdvice="";
	var Retreason=$.trim($('#retreason').val());
	Retreason = $_TrsSymbolToTxt(Retreason); /// �����������	
	var RevStatus=$('#RevStatus').combobox('getValue');  //����ָ��
	if (RevStatus==""){
		$.messager.alert($g("��ʾ")+":",$g("��ѡ�񲵻�ָ��")+"��");
		return;
	}
	if ($('#RevStatus').combobox('getText')==$g("�������")){
		$.messager.alert($g("��ʾ")+":",$g("����δ���")+"��"+$g("����ָ����Ϊ�������")+"��");
		return;
	}
	if (Retreason==""){
		$.messager.alert($g("��ʾ")+":",$g("����д��������")+"��");
		/*var scrollTop=$('body').scrollTop(); //hxy 2020-03-21 chrome st
		$("body").css("height",scrollTop);
		$('#RetWin').panel('resize',{ 
			top:scrollTop+((screen.availHeight-280)/4)
		}); //ed
		*/
		return;
	}
	var params=RepID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+adrReceive+"^"+RepTypeCode+"^"+RepStausDr+"^"+Retreason+"^"+RevStatus;   //������
	runClassMethod("web.DHCADVCOMMONPART","ReportBack",{'params':params,'LgParam':LgParam},
			function(jsonString){ 
				if(jsonString.ErrCode < 0){
					$.messager.alert($g("��ʾ")+":",$g("���ش���")+"��"+$g("����ԭ��")+":"+"<font style='color:red;'>"+$g(jsonString.ErrMsg)+"</font>");   ///+"��"+errnum+"������"
				}
				if(jsonString.ErrCode == 0){
					if(winflag==3){
						$.messager.alert($g("��ʾ")+":",$g("���سɹ�")+"��");
					}else{
						window.parent.CloseWinUpdate();
						window.parent.Query();
					}
				}
	},"json");
	$('#RetWin').window('close');
}
//ѡ��ʱ���뵱ǰʱ��Ƚ� 2017-03-06
function compareSelTimeAndCurTime(SelDateTime)
{
	var SelDateArr="",SelYear="",SelMonth="",SelDate="";
	if(DateFormat=="4"){ //���ڸ�ʽ 4:"DMY" DD/MM/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[0]);
	}else if(DateFormat=="3"){ //���ڸ�ʽ 3:"YMD" YYYY-MM-DD
		SelDateArr=SelDateTime.split("-");
		SelYear=SelDateArr[0];
		SelMonth=parseInt(SelDateArr[1]);
		SelDate=parseInt(SelDateArr[2]);
	}else if(DateFormat=="1"){ //���ڸ�ʽ 1:"MDY" MM/DD/YYYY
		SelDateArr=SelDateTime.split("/");
		SelYear=SelDateArr[2];
		SelMonth=parseInt(SelDateArr[0]);
		SelDate=parseInt(SelDateArr[1]);
	}
	
	var myDate=new Date();
	var curYear=myDate.getFullYear();
	if(SelYear>curYear){
		return false;
	}
	var curMonth=myDate.getMonth()+1;
	if((SelYear==curYear)&(SelMonth>curMonth)){
		return false;
	}
	var curDate=myDate.getDate();
	if((SelYear==curYear)&(SelMonth==curMonth)&(SelDate>curDate)){
		return false;
	}
	return true;
}
function RepSetAudMessage(){
	runClassMethod("web.DHCADVCOMMONPART","QueryAuditMesJson",{'ReportID':RepID,'TypeDr':RepTypeDr},
	function(data){ 
		var len=data.length;  //������Ϣ
		var SubmitUser="";
		if(len>0){
			SubmitUser=data[0].AuditUser;
		}
		
		var List="<div class='dhcc-panel-header'><div class='dhcc-panel-title'>"+$g('�¼���������Ϣ')+"</div></div>  ";
		for(var k=0;k<len;k++){
			var UserList=data[k].AuditUser;
			var ReceiveList=data[k].Receive;
			var StausList=data[k].Status;
			if((discover==$g("����"))&&(((ReceiveList==$g("����")))&&(SubmitUser==UserList))){
				UserList=$g("����");
			}
			
			List=List+"<table class='dhcadv-auditTable'>"
			List=List+"<tr><th colspan='10'><img src='../scripts/dhcadvEvt/images/th-list.png'></img><span>"+data[k].Status+"</span></i></th></tr>"
			List=List+"<tr><td>"+$g('������')+"</td><td>"+UserList+"</td></tr>"
			List=List+"<tr><td>"+$g('����״̬')+"</td><td>"+data[k].Receive+"</td></tr>"
			List=List+"<tr><td>"+$g('����ʱ��')+"</td><td>"+data[k].AuditDateTime+"</td></tr>"
			List=List+"<tr><td>"+$g('����ָ��')+"</td><td>"+data[k].NextLoc+"</td></tr>"
			List=List+"<tr><td>"+$g('�����ʵ')+"</td><td>"+$_TrsTxtToSymbol(data[k].RecProgress)+"</td></tr>"
			List=List+"<tr><td>"+$g('�������')+"</td><td>"+$_TrsTxtToSymbol(data[k].LocAdvice)+"</td></tr>"  ///data[k].LocAdvice
			List=List+"</table>"
			
			var TranMessdata=data[k].TranMess; //ת����Ϣ
			var sublen=TranMessdata.length; //ת����Ϣ����
			var Sublist="";
			for (var i=0;i<sublen;i++){
				Sublist=Sublist+"<table class='dhcadv-auditTable'>"
				Sublist=Sublist+"<tr><th colspan='10'><img src='../scripts/dhcadvEvt/images/th-list.png'></img><span>"+$g("ת��")+"</span></i></th></tr>"
				Sublist=Sublist+"<tr><td>"+$g('������')+"</td><td>"+TranMessdata[i].MedIAuditUser+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('����ʱ��')+"</td><td>"+TranMessdata[i].MedIAuditDateTime+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('����ָ��')+"</td><td>"+TranMessdata[i].MedINextLoc+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('�������')+"</td><td>"+$_TrsTxtToSymbol(TranMessdata[i].MedILocAdvice)+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('��Աָ��')+"</td><td>"+TranMessdata[i].MedINextUser+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('��Ա����ʱ��')+"</td><td>"+TranMessdata[i].MedIReceiveDateTime+"</td></tr>"
				Sublist=Sublist+"<tr><td>"+$g('��Ա���')+"</td><td>"+$_TrsTxtToSymbol(TranMessdata[i].MedIUserAdvice)+"</td></tr>"
				Sublist=Sublist+"</table>"
				
			}
			List=List+Sublist
		}
		$('#AuditMessage').html(List);
		if(len==0){
			$('#AuditMessage').hide();
			$("#anchor>ul>li>a:contains("+$g("�¼���������Ϣ")+")").parent().hide(); //hxy 2020-03-21
		}
	},"json",false)

}
//ͨ�������ȡ�����
function getAgeBracket(age){
	var rtnStr=""
	
	if(age==""){
		rtnStr=$g("����");
		}
	if(rtnStr!="")
	return rtnStr;
	
	
	if((age.split("��").length>1)&&(age.split("��").length>1)){
		
		var month=age.split("��")[0].replace(/[^0-9]/ig,"");
		var day=age.split("��")[1].replace(/[^0-9]/ig,"");
		if((month==1)&&(day>0)){
			rtnStr="������";
		}else if((month==2)&&(day==0)){
			rtnStr="������";
			}else if((month>2)&&(month<12)){
				rtnStr="��������";
				}
	}
	if(rtnStr!="")
	return rtnStr;

	if((age.split("��").length>1)){
		var ageNum= age.replace(/[^0-9]/ig,"")/30;
		if((ageNum>0)&&(ageNum<=2)){
			rtnStr="������";
		}else if((ageNum>2)&&(ageNum<12)){
				rtnStr="��������";	
		}
		}
	if(rtnStr!="")
	return rtnStr;
	
	if(age.split("��").length>1){				//�����µ�
		var ageNum= age.replace(/[^0-9]/ig,"");
		if((ageNum==1)||(ageNum==2)){
			rtnStr="������";
		}else if((ageNum>2)&&(ageNum<12)){
				rtnStr="��������";	
		}
	}
	if(rtnStr!="")
	return rtnStr;


	if(age.split("��").length>1){				//�����µ�
		var ageNum= age.replace(/[^0-9]/ig,"");
		if((ageNum>0)&&(ageNum<18)){
			rtnStr="δ����";	

		}else if((ageNum<=0)||(ageNum>130)){
			rtnStr="��������ȷ�����䣡";
		}else{
			rtnStr="����";	
		}
	}
	if(rtnStr!="")
	return rtnStr;
	return rtnStr;


}
//ת��  2016-05-13 ����
function Transcription()
{	
	//��������
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	if((checkTranPermiss() == -1)&&(SubUserflag!="1")){	//qunianpeng 2018/1/11 ����ת����ֱ�Ӳ���ת������
		$.messager.alert($g("��ʾ")+":","<font style='color:red;'>"+$g("�����Ȩ�޲��ܽ���ת��")+"</font>");
		return ;	
	}
	$('#TranWin').window({
		title:$g('ת��'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:false,
		modal:true,
		width:950,
		height:600,
		top:$('body').scrollTop()+((screen.availHeight-600)/4)
	});
	$('#TranWin').window('open');
	ConWinSroll("TranWin");
	var params=RepID+"^"+RepTypeCode+"^"+LgUserID+"^"+RepStausDr;
	TranUserList(RepID,RepTypeCode,SubUserflag);//ת��ָ����Ա
	TranLocUserList(RepID,RepTypeCode,SubUserflag);//ת��������Ա�����Ϣ
	if(SubUserflag==0){
		//��������
		getDateTime(); //2016-10-08 congyue
		$('#medadrUser').attr("disabled",false);
		$('#medadrDateTime').attr("disabled",false);
		$("#tranLocAdvic").attr("disabled",false);
		$("#medadrUser").val(LgUserName);//��ʾת����(��ǰ��½��)
		$("#medadrUser").attr("disabled",true);
		$("#medadrDateTime").attr("disabled",true);
		$("#tranLocAdvic").val("");
		$("#tranLocDr").combobox('setValue',"");
		$("#tranReplyMess").val("");
		$("#tranReply").hide();
		$("#tranReplyMess").hide();	
		$("#replyFlag").hide();//�Ƿ�ת���ظ�

	}
	if(SubUserflag==1){
		$("#tranLocDr").combobox({disabled:true});
	}
	$.ajax({
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=SearchAuditMess&params="+params,
		success: function(data){
			var tmp=data.split("^");
			if(SubUserflag==1){
				$('#medadrUser').val(tmp[0]); //������Ա
				$('#medadrUser').attr("disabled","true");
				$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //����ʱ��
				$('#medadrDateTime').attr("disabled","true");
				$('#tranLocAdvic').val(tmp[3].replace(/\��/g,'"')); //�������
				$('#tranLocAdvic').attr("disabled","true");
				$("#tranReply").show();
		        $("#tranReplyMess").show();
		        $("#replyFlag").show();//�Ƿ�ת���ظ�
				//var UserID=rowData.UserID;
				if ((tmp[5]!=LgUserID)&(tmp[6]!=LgCtLocID)){
					errflag=1;
					$("#tranLocDr").combobox('setValue',"");
				}else{
					errflag=0;
				}
	
			}
			else{
				errflag=0;
			}
		}
	});
	if(SubUserflag==1){
		$('#transub').hide();
		$('#tranreply').show();
		$('#tranrec').show();

	}else{
		$('#transub').show();
		$('#tranreply').hide();
		$('#tranrec').hide();
    }
   $("#reply").attr("checked",false);   //quninapeng 2018/1/26 ÿ�ν���ת���ظ� ��������˵�ѡ��״̬	
}
//ת��ָ����Ա
function TranUserList(RepID,RepTypeCode,SubUserflag)
{
	//ת������
	$('#tranLocDr').combobox({
		//url:url+'?action=GetQueryLoc&HospID='+LgHospID,
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#tranLocDr').combobox('reload',url+'?action=GetQueryLoc&HospID='+LgHospID+'');
		},
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:RepTypeCode+"^"+tranLocDr}
			});
		},
		onHidePanel : function() {
			// ����������ֵУ��--�����������ʹ�ã����������ѡ���������� 2021-0-6-25 cy
			chkcomboxvalue(this);
		}
	}); 
	//����columns
	var usercolumns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:$g('������Ա'),width:120}
	]];
	var titleNotes="";
	if(SubUserflag==1){
		titleNotes=$g("ָ����Ա");
	}else{
		titleNotes=$g("ָ����Ա")+'<span style="font-size:10pt;font-family:���Ŀ���;color:red;">['+$g("˫���м��������ת����Ϣ��")+']</span>';
	}
	$('#sldgtitle').html(titleNotes);
	
	var params=RepID+"^"+RepTypeCode+"^"+RepStausDr;
	//����datagrid
	$('#selectdg').datagrid({
		title:'' ,  ///'ָ����Ա'+titleNotes,
		url:url+'?action=QueryUserMess&paramsuser='+params,
		fit:true,
		rownumbers:true,
		columns:usercolumns,
		border:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				$('#sldgtitle').html($g('ָ����Ա'));
				return;
			}else{
				$('#sldgtitle').html(titleNotes);
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
				if(UserID==LgUserID){
					$.messager.alert("��ʾ:","ת����Ա����Ϊ���ˣ�");	
					return;
				}
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				//2017-11-23 cy �ж�ת������Ϊ�ղ��������Ա
				if(tranLocDesc==""){
					$.messager.alert($g("��ʾ")+":",$g("ת�����Ҳ���Ϊ��")+"��");	
					return;
				}
				//2017-11-23 cy �ж������Ա�����ظ����
				var  dataList=$('#tranmesdg').datagrid('getData'); 
				for(var i=0;i<dataList.rows.length;i++){
					if(UserID==dataList.rows[i].nameID){
						$.messager.alert($g("��ʾ")+":",$g("����Ա�����")+"��");	
						return ;
					}
				}				

				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
}
//ת��������Ա�����Ϣ
function TranLocUserList(RepID,RepTypeCode,SubUserflag)
{
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:$g('ת��ʱ��'),width:90,hidden:true},
		{field:'tranuser',title:$g('ת����'),width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:$g('����'),width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:$g('��Ա'),width:80},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'LocAdvice',title:$g('�������'),width:100,formatter:transAdvice},
		{field:'advice',title:$g('�ظ�����'),width:100,formatter:transAdvice},
		{field:'DutyFlag',title:$g('��ע'),width:200},
		{field:"tranreceive",title:$g('����״̬'),width:90,hidden:true},
		{field:"tranrecedate",title:$g('��������'),width:90,hidden:true},
		{field:"trancompdate",title:$g('�������'),width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(SubUserflag==1){
		titleOpNotes=$g("ת����Ϣ��");
	}else{
		titleOpNotes=$g("ת����Ϣ��")+'<span style="font-size:10pt;font-family:���Ŀ���;color:red;">['+$g("˫���м��������������")+']</span>';
	}
	$('#trandgtitle').html(titleOpNotes);
	var params=RepID+"^"+RepTypeCode+"^"+RepStausDr;
	//����datagrid
	$('#tranmesdg').datagrid({
		title:'' ,  ///'ת����Ϣ��'+titleOpNotes,
		url:url+'?action=QueryTranLocUser&params='+params,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //˫�����ѡ����
			if((SubUserflag==1)){ //(SubUserflag==1)||(TranFlag==1)
				return;
			}else{
				if((rowData.LocAdvice==undefined)||(rowData.LocAdvice=="")){
					$('#tranmesdg').datagrid('deleteRow',rowIndex);
				}else{
					$.messager.alert($g("��ʾ"),$g("��ת��")+","+$g("����ɾ��")+"��"); 
					return ;
				}
			}
		}
	});	
	
}
//ת���ύ
function TranSub(id) //hxy 2018-01-25 (id) ie8�س�Ī����δд�����޸�
{
	if(errflag==1){
		$.messager.alert($g("��ʾ")+":",$g("��ת����ָ����Ա")+"��"+$g("��Ȩ�޲���"));
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	tranLocAdvic = tranLocAdvic.replace(/\"/g,"��");	 //qunianpeng 2018/1/10 ת������
	tranLocAdvic=$_TrsSymbolToTxt(tranLocAdvic);
	var tranReplyMess=$('#tranReplyMess').val();
	tranReplyMess = tranReplyMess.replace(/\"/g,"��");  //qunianpeng 2018/1/10 ת������
	tranReplyMess=$_TrsSymbolToTxt(tranReplyMess);
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	if (RepID==""){
		$.messager.alert($g("��ʾ")+":",$g("����δ�ύ")+"��"+$g("������ת��")+"��");
		return;
	}
	medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+adrReceive+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+RepStausDr+"^"+RepType;   //������
	var rows = $("#tranmesdg").datagrid('getChanges');
	if(rows.length<=0){
		$.messager.alert($g("��ʾ")+":",$g("û�д���������")+"��");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert($g("��ʾ")+":",$g("����ָ�����Ա����Ϊ��")+"��"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert($g("��ʾ")+":",$g("�����������Ϊ��")+"��"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime; /// ȥ��+"^"+tranLocAdvic
	
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 

	//��������
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList,"LgParam":LgParam},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			//TranFlag=1;
     		$('#tranmesdg').datagrid('reload'); //���¼��� qunianpeng 2018/1/17	
     		closeDrgWindow();		
		}
		if(resobj.ErrCode < 0){
			$.messager.alert($g("��ʾ")+":",$g("ת���ύ����")+"��"+$g("����ԭ��")+":"+"<font style='color:red;'>"+$g(resobj.ErrMsg)+"</font>");
			return ;
		}
	});
}
//ת���ظ�
function TranReply(Replyflag)
{   var tranDutyFlag="N"  //ת��֮��δ�ظ�
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	tranReplyMess = tranReplyMess.replace(/\"/g,"��"); //qunianpeng 2018/1/10 ת������
	tranReplyMess=$_TrsSymbolToTxt(tranReplyMess);
	if($("#reply").is(':checked')){
		tranDutyFlag="Y";
	}
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag+"^"+tranDutyFlag;
	
	var rows = $("#tranmesdg").datagrid('getRows');
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((Replyflag==1)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert($g("��ʾ")+":",$g("���ύ�ɹ�")+"��"+$g("�����ظ����")+"��");
			return false;
		}
		
		if((Replyflag==0)&&(rows[i].tranrecedate!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert($g("��ʾ")+":",$g("�ѽ��ճɹ�")+"��"+$g("�����ظ����")+"��");
			return false;
		}
		if((Replyflag==0)&&(rows[i].advice!="")&&(rows[i].nameID==LgUserID)){
			$.messager.alert($g("��ʾ")+":",$g("�ظ����ύ")+"��"+$g("������Ч")+"��");
			return false;
		}
	} 
	/* if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
		return;
	} */
	
	if((errflag==1)&(Replyflag==0)){
		$.messager.alert($g("��ʾ")+":",$g("��ת����ָ����Ա")+"��"+$g("��Ȩ�޲���")+"��");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert($g("��ʾ")+":",$g("�ظ��ύ����")+"��"+$g("�ظ����ݲ���Ϊ��")+"��");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert($g("��ʾ")+":",$g("���ղ���")+"��"+$g("�ظ����ݲ���")+"��");
		return;
	}
	if (RepID==""){
		$.messager.alert($g("��ʾ")+":",$g("����δ�ύ")+"��"+$g("������ת��")+"��");
		return;
	}
	medadrList=RepID+"^"+RepTypeCode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+adrReceive+"^"+StatusNextID;   //������
		
	//��������
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			   closeDrgWindow();	
		}
		if(resobj.ErrCode < 0){
			$.messager.alert($g("��ʾ")+":",$g("��������")+"��"+$g("����ԭ��")+":"+"<font style='color:red;'>"+$g(resobj.ErrMsg)+"</font>");
		}
		
	});
}

//�ر�ת������
function closeDrgWindow()
{  
	$('#TranWin').window('close');
}
///qunianpeng 2018/1/11 �ж��Ƿ������Ȩ�ޣ��Ƿ����ת��
function checkTranPermiss(){
	var ret=0;	
	var paramss=RepID+"^"+RepTypeDr+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID;
	$.ajax({  
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMON&MethodName=CheckTranPermiss'+'&params='+paramss+'&LgParam='+LgParam, 	        
        async : false,	 // ע��˴���Ҫͬ������Ϊ���������ݺ���������ý���ĵ�һ��selected  
        type : "POST",  
        success : function(data) {       
        	if (data == -1){ret = -1;}
			else{ret = 0; }
			
        }  
	});	
	return ret;
}
/// qunianpeng 2018/1/3 ��ת����^    ��ת����"
function transAdvice(value, rowData, rowIndex){
	if (value != undefined) {
		value = $_TrsTxtToSymbol(value);
		return value;
	}
	return "";
}
//��ȡ����ʱ�� 2016-10-08 congyue
function getDateTime(){
	var tmp="";
	var time="";
  		$.ajax({
	  	async: false,
		type: "POST",// ����ʽ
    	url: url,
    	data: "action=GetDealDateTime",
		success: function(data){
		var tmp=data.split("^");
		$('#medadrDateTime').val(tmp[0]+" "+tmp[1]);   //����ʱ��
		}
  	}); 
} 
//���ڹ��������� 2018-12-20 cy �򿪴��ڸ����ڹ��������أ��رմ��ڸ����ڹ�������ʾ
function ConWinSroll(id){
	$('body').css('overflow-y','hidden');
	setInterval(function() { 
		if($('#'+id).is(":hidden")) { 
			clearInterval(ConWinSroll());    
			$('body').css('overflow-y','scroll');
			id="";
		}  
	}, 100); 
}
//���Ƶȼ����˺����س̶ȼ�
function ConLevInjury()
{
	$("input[type=radio][id^='EventRepLevel-']").attr("disabled",true);
	$("input[type='radio'][id^='Severity']").on("click",function()
	{
		if($("input[type='radio'][id='Severity-98857']").is(":checked")==true)
		{
	
			$("input[type=radio][id^='EventRepLevel-96426']").attr("checked",true);
		}
		if(($("input[type='radio'][id='Severity-98858']").is(":checked")==true)||($("input[type='radio'][id='Severity-98859']").is(":checked")==true)||($("input[type='radio'][id='Severity-98860']").is(":checked")==true))
		{
			$("input[type=radio][id^='EventRepLevel-96425']").attr("checked",true);
		}
		if(($("input[type='radio'][id='Severity-98861']").is(":checked")==true)||($("input[type='radio'][id='Severity-98862']").is(":checked")==true)||($("input[type='radio'][id='Severity-98863']").is(":checked")==true)||($("input[type='radio'][id='Severity-98864']").is(":checked")==true))
		{
			$("input[type=radio][id^='EventRepLevel-96424']").attr("checked",true);
		}
		if($("input[type='radio'][id='Severity-98865']").is(":checked")==true)
		{
			$("input[type=radio][id^='EventRepLevel-96423']").attr("checked",true);
		}
		if($("input[type='radio'][id='Severity-98866']").is(":checked")==true)
		{
			$("input[type=radio][id^='EventRepLevel-96426']").attr("checked",true);
		}
		// 2021-02-02 cy ȡ����ѡ���س̶ȶ�̬ȡ����ѡ�¼��ȼ�
		if(!($('#'+this.id).is(':checked'))){
			$("input[id^=EventRepLevel]").removeAttr("checked");
		}
	})
}
 
//���ر��������Ϣ����
function InitBasicInfoCom(RepID)
{
	if(RepID==""){return;}
	runClassMethod("web.DHCADVCOMMONPART","GetRepBasicInfo",{'RepID':RepID},
	function(Data){ 
      	var ReportTime=Data.RepTime;				// ����ʱ��
		RepSetRead("ReportTime","input",0);								
		RepSetValue("ReportTime","input",ReportTime); 
		RepSetRead("ReportTime","input",1);		
		
		var ReportCardSta=Data.RepStaus;					// ���濨״̬
		if(ReportCardSta!=""){
			RepSetRead("ReportCardSta","input",0);								
			RepSetValue("ReportCardSta","input",$g(ReportCardSta)); 
			RepSetRead("ReportCardSta","input",1);							// ���濨״̬���ɱ༭	
		}
		OrdList=Data.OrderList; ///2021-02-09 cy �����ҽ��id
	},"json",false);
}
// 2020-03-26 ���� ����ɾ���¼� ����ie������������ֻ������£����ɾ���������Զ���ת��һҳ
function ReportBack(){
	document.onkeydown =function (e) {            
		var ev = e || window.event; //��ȡevent����            
		if (ev.keyCode == 8) {                
			var obj = ev.target || ev.srcElement; //��ȡ�¼�Դ                
			var t = obj.type || obj.getAttribute('type'); //��ȡ�¼�Դ����                
			//��ȡ��Ϊ�ж��������¼�����                
			var vReadOnly = obj.getAttribute('readonly') || obj.readOnly;                
			var vdisabled = obj.getAttribute('disabled') || obj.disabled;                 
			var flag1 = ((t == "password") || (t == "text") || (t == "textarea")|| (t == "email")|| (t == "url")|| (t == "number")|| (t == "range")|| (t == "Date")|| (t == "search")|| (t == "color")) && ((vReadOnly == true)||(vReadOnly == "readonly") || (vdisabled == true)||(vdisabled == "disabled")) ? true : false;                
			var flag2 = ((t != "password") && (t != "text") && (t != "textarea")&& (t != "email")&& (t != "url")&& (t != "number")&& (t != "range")&& (t != "Date")&& (t != "search")&& (t != "color")) ? true : false;                
			//�ж�                
			if (flag1 || flag2) 
			{                    
				return false;                
			}            
		}        
	}; 
}

// 2020-04-07 �ļ��ϴ�
function Uploadfy(){
		
	if(recordId=="")
	{
		$.messager.alert($g("��ʾ")+":",$g("����IDΪ��")+"��"+$g("�����ϴ��ļ�")+"��");
		return;	
	}
	if($('#patoutwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="patoutwin"></div>');
	$('#patoutwin').window({
		iconCls:"icon-w-paper",
		title:$g('�ϴ��鿴�ļ�'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:1300,
		height:700
	});
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.uploadify.csp?recordId='+recordId+'"></iframe>'; 
	$('#patoutwin').html(iframe);
	$('#patoutwin').window('open');
	
}
// ��ѡ �����չ������ȼ�����Ժʱ��
function ChkPatSelfCareAbility(value){
	RepSetRead("PatSelfCareAbility-","radio",0);  //�����չ�����
	if((value>100)||(value=="")){
		$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
	}
	if(((value>0)&&(value<41))||((value==0)&&(value!=""))){// 0-40 �ض�����
		$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
	}
	if((value>40)&&(value<61)){ // 41-60 �ж�����
		$("input[type=radio][id^='PatSelfCareAbility-99921']").click();	
	}
	if((value>60)&&(value<100)){// 61-99 �������
		$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
	}
	if(value==100){//100 ��������
		$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
	}
	RepSetRead("PatSelfCareAbility-","radio",1);  //�����չ�����
}
// ��ѡ �����չ������ȼ�������ʱ��
function OccurPatSelfCareAbility(value){
	RepSetRead("OccurPatSelfCareAbility-","radio",0);  //�����չ�����
	if((value>100)||(value=="")){
		$("input[type=radio][id^='OccurPatSelfCareAbility-']").removeAttr("checked");
	}
	if(((value>0)&&(value<41))||((value==0)&&(this.value!=""))){// 0-40 �ض�����
		$("input[type=radio][id^='OccurPatSelfCareAbility-94241']").click();	
	}
	if((value>40)&&(value<61)){ // 41-60 �ж�����
		$("input[type=radio][id^='OccurPatSelfCareAbility-99922']").click();	
	}
	if((value>60)&&(value<100)){// 61-99 �������
		$("input[type=radio][id^='OccurPatSelfCareAbility-94240']").click();	
	}
	if(value==100){//100 ��������
		$("input[type=radio][id^='OccurPatSelfCareAbility-94239']").click();	
	}
	RepSetRead("OccurPatSelfCareAbility-","radio",1);  //�����չ�����
}
