/// Description: ְҵ��¶-��¶�����
/// Creator: 
/// CreateDate: 2019-10-31
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
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
	reportControl();			// ������  	
	InitButton();				// ��ʼ����ť
});
//��ȡ������Ϣ
function InitPatInfo(){};
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
	if(EvaRecordId!="")	{
		$("[id^='ExposerFlup-']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				//var rownum=this.id.split(".")[1]; [id$='"+rownum+"']
				$("[id^='"+rowid+"']").attr("readonly",'readonly');
			}
		})
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
	//alert("formId:"+formId+"par:"+loopStr("#from")+"recordId:"+EvaRecordId+"linkRecordId:"+LinkRecordId);
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
				window.parent.CloseAsseWin();
				window.parent.location.reload();// 2018-11-20 cy ���汨���ˢ�¸�����
				if(flag==1){
					//window.parent.SetRepInfo(data[1],WinCode);
					window.parent.parent.CloseWinUpdate();
					window.parent.parent.Query();
				}
				
			}else{
				return;
			}
		},"text")
			
}

//�����湴ѡ�������Ƿ���д�����
function checkother(){
	
	
	return true;
}

//ҳ���������
function setCheckBoxRelation(id){
}

