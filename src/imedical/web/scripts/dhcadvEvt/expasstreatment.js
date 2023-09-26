/// Description: ְҵ��¶- ��¶���������Ʒ���
/// Creator: 
/// CreateDate: 2019-10-31
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="",AdmID="";
var userName="";
$(document).ready(function(){
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	AuditList=getParam("AuditList");  //��˴�
	CancelAuditList=getParam("CancelAuditList");  //������˴�
	StaFistAuditUser=getParam("StaFistAuditUser");  //��һ������
	StsusGrant=getParam("StsusGrant");  //��˱�ʶ
	RepStaus=getParam("RepStaus");  //����״̬
	WinCode=getParam("code");  //��������¼code
	AdmID=getParam("AdmID");  // AdmID
	reportControl();			// ������  
	InitButton();				// ��ʼ����ť
	InitPatInfo(AdmID);
});

//��ȡ������Ϣ
function InitPatInfo(AdmID){
	if(AdmID==""){return;}
	runClassMethod("web.DHCADVCOMMON","GetPatInfoJson",{'PatNo':'','EpisodeID':AdmID},
	function(Data){ 
		var PatNo=Data.PatNo;					// �ǼǺ�
		RepSetValue("PatNo","input",PatNo);
		RepSetRead("PatNo","input",1);
		var PatAge=Data.PatAge;				// ��������
		RepSetValue("PatAge","input",PatAge);
		RepSetRead("PatAge","input",1);
		var PatSex=Data.PatSex;  				// �Ա�
		RepSetValue("PatSexRadio","radio",PatSex);
		RepSetRead("PatSexRadio","radio",1);
		
	},"json",false);
	
};
// ������
function reportControl(){
	$("#left-nav").hide();
	$("#anchor").hide();
	$("#gotop").hide();
	$("#gologin").hide();
	$("#footer").hide();
	$("#assefooter").show();
	$("#from").css({
		"margin-left":"20px",
		"margin-right":"20px"
	});
	$('#AuditMessage').hide(); //2018-06-12 cy ������Ϣչ��
	// ȷ��ʱ�����
	chkdate("DiagDate");
	// ��ʼ��ҩʱ������
	chkdate("PhaStartingDate");
	// ֹͣ��ҩʱ�����
	chkdate("PhaEndingDate");
	
	/* //��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio();
		});
	}) */
	if(EvaRecordId!=""){
		//HIV���� ���ɱ༭
		$("#AssPeoExpToHIV input").attr("readonly",'readonly');
		$("#DiagDate").datebox({"disabled":true});
		$("#AssRemarks").attr("readonly",'readonly');
		$("#AssPeoExpToHIV input[type=radio]").attr("disabled",true);  
		//���Ʒ��� ���ɱ༭
		$("#PreTreAftExposure input").attr("readonly",'readonly');
		$("#PhaStartingDate").datebox({"disabled":true});
		$("#PhaEndingDate").datebox({"disabled":true});
		$("#OccExpDrugInfo").attr("readonly",'readonly');
		$("#ModTreatPlan").attr("readonly",'readonly');
		$("#SideEffect").attr("readonly",'readonly');
		$("#PreTreAftExposure input[type=radio]").attr("disabled",true); 
		//֢״ ���ɱ༭
		$("#Symptom-Panel input[type=radio]").attr("disabled",true); 
		$("#Symptom-Panel input").attr("readonly",'readonly');
		$("#SymRemarks").attr("readonly",'readonly');
	}
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
	})
	setTimeout(function(){ //��ʱ���body
        $("body").click();
    },500)
	$(".lable-input").css('width','100px');
	$(".lable-input").css('max-width','100px');
}
//��ť�����뷽����
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
}
//�������۱���
function SaveAsse(flag)
{
	 ///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVFormRecord","SaveRecord",
		{'user':LgUserID,
		 'formId':$("#formId").val(),
		 'formVersion':$("#formVersion").val(),
		 'par':loopStr("#from"),
		 'recordId':EvaRecordId,
		 'linkRecordId':LinkRecordId
		 },
		function(datalist){ 
			var data=datalist.replace(/(^\s*)|(\s*$)/g,"").split("^");
			if (data[0]=="0") {
				window.parent.closeRepWindow();
				window.parent.location.reload();// 2018-11-20 cy ���汨���ˢ�¸�����
			}else{
				return;
			}
		},"text")
			
}

//�����湴ѡ�������Ƿ���д�����
function checkother(){
	if((!compareSelTowTime(trsUndefinedToEmpty($("#PhaStartingDate").datebox('getValue')),trsUndefinedToEmpty($("#PhaEndingDate").datebox('getValue'))))&&(trsUndefinedToEmpty($("#PhaEndingDate").datebox('getValue'))!="")){
		$.messager.alert("��ʾ:","����ʼ��ҩʱ�䡿���ܴ��ڡ�ֹͣ��ҩʱ�䡿��");
		return false;
	}
	return true;
}
//δ����Ĭ��Ϊ��
function trsUndefinedToEmpty(str)
{
	if(typeof str=="undefined"){
		str="";
	}
	return str;
}
