/// Description: ҩƷ�¼���ʿ�����۵����۽��� 
/// Creator: wxj
/// CreateDate: 2018-04-16
var EvaRecordId="",LinkRecordId="",WinCode="",AuditList="",CancelAuditList="",StaFistAuditUser="",StsusGrant="",RepStaus="";
var userName="";
var AssessFlag="",LocHeadNurEvaFlag="",NurDepEvaFlag=""; ///���۰�ť��ʶ���ƻ�ʿ�����۰�ť��ʶ���������۰�ť��ʶ
var EvaFlagList=""; /// ���۱�ʶ��  ���۰�ť��ʶ^�ƻ�ʿ�����۰�ť��ʶ^�������۰�ť��ʶ 
$(document).ready(function(){
	
	EvaRecordId=getParam("recordId");  //������id
	LinkRecordId=getParam("LinkRecordId");  //��������¼ID
	AuditList=getParam("AuditList");  //��˴�
	CancelAuditList=getParam("CancelAuditList");  //������˴�
	StaFistAuditUser=getParam("StaFistAuditUser");  //��һ������
	StsusGrant=getParam("StsusGrant");  //��˱�ʶ
	RepStaus=getParam("RepStaus");  //����״̬
	WinCode=getParam("code");  //��������¼code
	EvaFlagList=getParam("EvaFlagList");  //���۱�ʶ��
	reportControl();			// ������  	
	InitButton();				// ��ʼ����ť
	InitCheckRadio()
	CheckTimeornum();  //ʱ��У��
		
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
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	})
	// ���ᱨ�����ڿ��� sufan 2019-06-18 ��ͳһȥ�����Ჿ��
	//chkdate("MornRepMeetDate");
	// �������ڿ���
	chkdate("MeetDate","MeetTime");
	add_event();
	var Caserow=0
	var CaseList=$('#CaseImprovement').val().split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	if($('#CaseImprovement').val()!=""){
		$("#CaseImprovement").css({
			"height":Caseheightlen
		});
	}
	//if(RepStaus!="�"){ //��ʿ�����
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
		//���ᱨ�� ���ɱ༭ sufan 2019-06-18 ��ͳһȥ�����Ჿ��
		//$("#MornMeetReport-panel input").attr("readonly",'readonly');
		//$("#MornRepMeetDate").datebox({"disabled":true});
		// ��Ӱ�ť���� 
		$('#ParPantsAddBut').hide();
		//���һ������¼����� ���ɱ༭
		$("#HeadNurCauseAnalysis-panel input").attr("disabled",true);
		$("#HeadNurCauseAnalysis-panel textarea").attr("readonly",'readonly');
		$("#MeetDate").datebox({"disabled":true});
		$("#HeadNurCauseAnalysis-panel input[type=checkbox]").attr("disabled",true);  
		//���Ĵ�ʩ ���ɱ༭
		$("#Recmeasure-panel input").attr("readonly",'readonly');
		$("#CaseImprovement").attr("readonly",'readonly');
		$("#Recmeasure-panel input[type=checkbox]").attr("disabled",true); 
		//��ʿ������ ���ɱ༭
		$("#HeadNurEvaluate-panel input[type=radio]").attr("disabled",true); 
		$("#AftImpMeasures-94925-94927").attr("readonly",'readonly');
		$("[id^='HeadNurEvaluate-94387-']").each(function(){
			var rowid=this.id.split(".")[0];
			var rownum=this.id.split(".")[1];
			if ((this.value!="")){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("ɾ��")+')').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains('+$g("����")+')').parent().hide();
			}
		})
		/* //��ʿ������ �������� ���ɱ༭
		 $("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
			if ((this.value!="")){
				var rowid=this.id.split(".")[0];
				var rownum=this.id.split(".")[1];
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
			}
		})  */
		
	}
	//������Ա  sufan 2019-06-18 ��ͳһȥ�����Ჿ��
	/*$('#MornRepMeetpants').css({
		"width":800,
		"max-width":800
	});*/
	//�λ���Ա 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("Participants","input",1);	
	//�������� sufan 2019-06-18 ��ͳһȥ�����Ჿ��
	/*$('#MornRepMeetContent').css({
		"width":800,
		"max-width":800
	});*/
	//����
	$('#ManaImprovement-94378-94951').css({
		"width":300,
		"max-width":300
	});
	//�����Ľ����ɱ༭
	$("#CaseImprovement").attr("readonly",'readonly');
	$("body").click(function(){
		AllStyle("textarea","",100);
  		InitLabInputText(".lable-input");
		$(".mytext").bind('input propertychange ',function(){
	    	setManImprove();
	 	});
	 	$(".mytext").blur('input propertychange ',function(){
	    	setManImprove();
	 	});
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
	/* //ȷ������   ///2018-04-13 cy ��ťҳ��չ��
	$('#FormAudit').on("click",function(){
		FormConfirmAudit();
	}) 
	//�������  ///2018-04-13 cy ��ťҳ��չ��
	$('#FormCancelAudit').on("click",function(){
		FormCancelAuditBt();
	}) 
	if(RepStaus!="�"){  //��ʿ�����
		$("#FormAudit").hide(); //ȷ������  2018-04-13 cy ���۽���
		$("#FormCancelAudit").show(); //�������  2018-04-13 cy ���۽���
	}else{
		$("#FormAudit").show(); //ȷ������  2018-04-13 cy ���۽���
		$("#FormCancelAudit").hide(); //�������  2018-04-13 cy ���۽���
	} 
	//������Ա ��Ӱ�ť�¼�
	$('#MorRepMeetAddBut').on("click",function(){
		StaffEnter();
	}) */
	 
	//�λ���Ա ��Ӱ�ť�¼�
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //�����ѯ
   	$('#Add').bind("click",MemAdd);     //�����ӣ�����ѡ����Ա��ӵ������ �λ���Ա
  	//$('#MonAdd').bind("click",MonAdd);  //�����ӣ�����ѡ����Ա��ӵ������ ������Ա  sufan 2019-06-18 ��ͳһȥ�����Ჿ��
}


//��ȡԭ��������������Ĵ�ʩ
function setManImprove()
{
	var list="",PersonCause="",DeviceCause="",goodsCase="",ManaCase="",EveCause="";
	var i=0,j=0,k=0,l=0,m=0
	var PersonCauselist="",DeviceCauselist="",goodsCaselist="",ManaCaselist="",EveCauselist="";
	$("input[id^='PersonCause']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("PersonCause-94275-94404")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("ҽ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94516")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("ҩ����ҩ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}		
			if(this.id.indexOf("PersonCause-94275-94517")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("ҩ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94518-94531")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("ִ�и�ҩ")+"����"+$g("������״ִ̬��")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94518-94532")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("ִ�и�ҩ")+"����"+$g("����״ִ̬��")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94519")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"����"+$g("������Ա��רҵ֪ʶȱ���¸�ҩ����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94275-94520")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��ʿ����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}
			if(this.id.indexOf("PersonCause-94276")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("ҽ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}	
			if(this.id.indexOf("PersonCause-94402")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("ҩ����Ա����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}			
			if(this.id.indexOf("PersonCause-94403")>=0){	
				i=i+1;
				PersonCause=i+"��"+$g("��������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonCauselist=PersonCauselist+PersonCause;
			}									
		}
	});
	if(PersonCauselist!=""){
		list=list+"\n"+$g("һ����Ա����")+"\n"+PersonCauselist;
	}

	$("input[id^='DeviceCause']").each(function(){
		if($(this).is(':checked')){
			j=j+1;
			DeviceCause=j+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			DeviceCauselist=DeviceCauselist+DeviceCause;
		}
	});
	if(DeviceCauselist!=""){
		list=list+"\n"+$g("�����豸���أ�����")+"\n"+DeviceCauselist;
	}

	$("input[id^='goodsCase']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			goodsCase=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			goodsCaselist=goodsCaselist+goodsCase;
		}
	});
	if(goodsCaselist!=""){
		list=list+"\n"+$g("������Ʒ���أ��")+"\n"+goodsCaselist;
	}

	$("input[id^='ManaCase']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			ManaCase=l+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaCaselist=ManaCaselist+ManaCase;
		}
	});
	if(ManaCaselist!=""){
		list=list+"\n"+$g("�ġ��������أ�����")+"\n"+ManaCaselist;
	}

	$("input[id^='EveCause']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			EveCause=m+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EveCauselist=EveCauselist+EveCause;
		}
		
	});
	if(EveCauselist!=""){
		list=list+"\n"+$g("�塢��������")+"\n"+EveCauselist;
	}
	var Caserow=0
	var CaseList=list.split("\n")
	var Caselen=CaseList.length;
	for(i=0;i<Caselen;i++){
		Caserow=Caserow+parseInt(CaseList[i].length/50)+1;
	}
	var Caseheightlen=(Caserow)*18;
	$("#CaseImprovement").css({
		"height":Caseheightlen
	});
	$('#CaseImprovement').val(list)
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
			//alert(11)
			if (data[0]=="0") {
				window.parent.CloseAsseWin();
				window.parent.location.reload();// 2018-11-20 cy ���汨���ˢ�¸�����
				if(flag==1){
					window.parent.SetRepInfo(data[1],WinCode);
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
	//��ʿ����-ҽ������
	var DocAdvice=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94404-94523']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94523'][class='lable-input']").val()=="")){
				DocAdvice=-1;	
			}
		}
	})
	if(DocAdvice==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("ҽ������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��ʿ����-ҩ����ȡ
	var DruReceive=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94516-94526']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94526'][class='lable-input']").val()=="")){
				DruReceive=-1;
				
			}
		}
	})
	if(DruReceive==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("ҩ����ȡ")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	
	//��ʿ����-ҩ������
	var DruAlloc=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94517-94530']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94530'][class='lable-input']").val()=="")){
				DruAlloc=-1;
				
			}
		}
	})
	if(DruAlloc==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("ҩ������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��ʿ����-ִ�и�ҩ-������״ִ̬��
	var NoRescue=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94518-94531-94543']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94543'][class='lable-input']").val()=="")){
				NoRescue=-1;
				
			}
		}
	})
	if(NoRescue==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("ִ�и�ҩ")+"-"+$g("������״ִ̬��")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��ʿ����-ִ�и�ҩ-����״ִ̬��
	var Rescue=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94518-94532-94545']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94545'][class='lable-input']").val()=="")){
				Rescue=-1;
				
			}
		}
	})
	if(Rescue==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("ִ�и�ҩ")+"-"+$g("����״ִ̬��")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��ʿ����-������Ա��רҵ֪ʶȱ���¸�ҩ����
	var DoseError=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94519-94546']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94546'][class='lable-input']").val()=="")){
				DoseError=-1;
				
			}
		}
	})
	if(DoseError==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("������Ա��רҵ֪ʶȱ���¸�ҩ����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��ʿ����-����
	var NurFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94275-94520']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94520'][class='lable-input']").val()=="")){
				NurFactor=-1;
				
			}
		}
	})
	if(NurFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
		
	//ҽ������-����
	var DocFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94276-94551']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94551'][class='lable-input']").val()=="")){
				DocFactor=-1;
				
			}
		}
	})
	if(DocFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("ҽ������")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//ҩ����Ա����-����
	var PhaFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94402-94554']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94554'][class='lable-input']").val()=="")){
				PhaFactor=-1;
				
			}
		}
	})
	if(PhaFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("ҩ����Ա����")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��������-����
	var PatFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='PersonCause-94403-94557']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94557'][class='lable-input']").val()=="")){
				PatFactor=-1;
				
			}
		}
	})
	if(PatFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	
	//�豸����-����
	var EquFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='DeviceCause-94561']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94561'][class='lable-input']").val()=="")){
				EquFactor=-1;
				
			}
		}
	})
	if(EquFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�豸����")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//��Ʒ����-����
	var GoodsFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='goodsCase-94565']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94565'][class='lable-input']").val()=="")){
				GoodsFactor=-1;
				
			}
		}
	})
	if(GoodsFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��Ʒ����")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
		
	//��������-����
	var EnvFactor=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=checkbox][id^='EveCause-94795']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94795'][class='lable-input']").val()=="")){
				EnvFactor=-1;
				
			}
		}
	})
	if(EnvFactor==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//����Ľ�  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value==$g("�ƶȡ����̼��淶�ƶ����޶�"))){
				if(!($("#ManaImprovement-94378-94949").is(':checked'))&&!($("#ManaImprovement-94378-94950").is(':checked'))){
					ManaImprovementoth=-2;
				}
				if($("input[id='ManaImprovement-94378-94951']").val()==""){
					ManaImprovementoth=-2;
				}
			}
		}	
	})
	if(ManaImprovementoth==-2){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ľ�")+"��"+$g("��ѡ")+$g('�ƶȡ����̼��淶�ƶ����޶�')+"��"+$g("�빴ѡ����д����")+"��");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ľ�")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�¼����������Ĵ�ʩ��ʵЧ�� δ��ʵ ԭ��
	var AftImpMeasures=0;   //id���Ժ�����ַ�����ͷ
	$("input[type=radio][id^='AftImpMeasures-94925']").each(function(){
		if($(this).is(':checked')){
			if (($("#AftImpMeasures-94925-94927").val()=="")){
				AftImpMeasures=-1;
			}
		}
	})
	if(AftImpMeasures==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�¼����������Ĵ�ʩ��ʵЧ��")+"��"+$g("��ѡ")+$g('δ��ʵ')+"��"+$g("����д����")+"��");	
		return false;
	}
	return true;
}
//ҳ���������
function setCheckBoxRelation(id){
	if($('#'+id).is(':checked')){
		//�Ľ���ʩ-����Ľ� ���Ƶ���д����
		if(id=="ManaImprovement-94378"){
			$('#ManaImprovement-94378-95229').attr("readonly",false);//ҽ����ҩʱ��
		}
	}
}
function InitCheckRadio()
{
	//����Ľ�  �ƶȡ����̼��淶�ƶ����޶�  ����  ��д�����Զ���ѡ�ƶȡ����̼��淶�ƶ����޶���ȡ����ѡʱ������Ϊ��
	if($("input[type=checkbox][id='ManaImprovement-94378']").is(':checked')){
		$("#ManaImprovement-94378-94951").attr("readonly",false);
	}else{
		$("#ManaImprovement-94378-94951").val("");
		$("input[type=radio][id^='ManaImprovement-94378-']").removeAttr("checked");
	}
	$("#ManaImprovement-94378-94951").bind("blur",function(){
		if($("#ManaImprovement-94378-94951").val()!=""){
			$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
		}
	})
	if($("input[type=radio][id^='ManaImprovement-94378-']").is(':checked')){
		$("input[type=checkbox][id='ManaImprovement-94378']").prop("checked",true) ;
	}
	//�¼����������Ĵ�ʩ��ʵЧ�� δ��ʵ ԭ��
	$("input[type=radio][id^='AftImpMeasures-']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="AftImpMeasures-94925"){
				$("#AftImpMeasures-94925-94927").attr("readonly",false);
				InitLabInputText("#AftImpMeasures-94925-94927");
			}else{
				$("#AftImpMeasures-94925-94927").val("");
				$("#AftImpMeasures-94925-94927").unbind('click').on('click',function(){
				}); 
				
			}
		}
	})
	$("#AftImpMeasures-94925-94927").bind('input propertychange ',function(){
		if($("#AftImpMeasures-94925-94927").val()!=""){
			$("input[type=radio][id='AftImpMeasures-94925']").prop("checked",true) ;
			InitLabInputText("#AftImpMeasures-94925-94927");
		}
	})
}

//ȷ������  2018-04-24
function FormConfirmAudit()
{	
	if(!(checkRequired()&&checkother())){
		return;
	} 
	runClassMethod("web.DHCADVCOMMONPART","AuditMataReport",{'params':AuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
	
}
//�������� 2018-04-24
function FormCancelAuditBt()
{	
	if ((StaFistAuditUser!="")&(StaFistAuditUser!=LgUserName)){
		$.messager.alert("��ʾ:","����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�");
		return;
	}
	//��������
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert("��ʾ:","������˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
			return;
		}
		if(jsonString.ErrCode == 0){
			SaveAsse(1);
		}
	},"json",false);
		
}
//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//����ʱ��  sufan 2019-06-18 ��ͳһȥ�����Ჿ��
	/*chktime("MornRepMeetTime");*/
	//����ʱ��
	chktime("MeetTime","MeetDate");
	
}
//��Ա�س��¼����ش���
function StaffEnter()
{
	$('#staffwin').show();
	$('#staffwin').window({
		title:$g('������Ա��Ϣ'),
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:false,
		closed:"true",
		modal:true,
		width:500,
		height:400
	 }); 
    $('#staffwin').window('open');
    $("#UserNames").val("");
    InitStaffGrid() ;      
}

//��ʼ��������Ա�б�
function InitStaffGrid()
{
	//����columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'userCode',title:$g('�û�Code'),width:100},
		 {field:'userName',title:$g('�û�����'),width:100}
		]];
	
	//����datagrid
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff&Input='+LgCtLocID,
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,400],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		selectOnCheck:true,
		onUnselect:function(rowIndex, rowData)
		{
			userName=$("#UserNames").val();
			var name =rowData.userName
             if(userName.indexOf(name) != -1)
             {
	             userName=userName.replace(name+"��","")
	             $("#UserNames").val(userName);
             }
		},
		 onSelect:function(rowIndex, rowData)
		 {
	       var userName = rowData.userName
	       MeetMember(userName)
		 },onLoadSuccess:function(data){  
			if(userName!=""){
				for(var i=0;i<data.rows.length;i++){
					var Name = data.rows[i].userName+"��";
					if(userName.indexOf(Name)>=0){
						$("#user").datagrid("selectRow",i);
					}
				}
			}
		}	
	});	
	$("#UserNames").val($("#Participants").val()); /// ����������Ա����������Ա��ֵ(���Ĳλ���Ա)
	$(".datagrid-header-check input[type=checkbox]").on("click",function(){ ///2018-04-13 cy ���۽���
		AllMember();
	})
}
function AllMember(){
	var rows = $("#user").datagrid('getSelections');
	if(rows.length==0){
		$("#UserNames").val("");
	}
	var userNames="";
	for(var i=0;i<rows.length;i++){
		if(userNames==""){
			userNames=rows[i].userName+"��";
		}else{
			userNames=userNames+rows[i].userName+"��";
		}
		
	}
	$("#UserNames").val(userNames);
	//MeetMember(userNames) ;
}
//��ѯ
function QueryName()
{
	//1�����datagrid 
	$('#user').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var UserName=$("#UserName").val();
	var params=UserName+"^"+LgCtLocID;
	$('#user').datagrid({
		url:'dhcadv.repaction.csp'+'?action=GetStaff',
		queryParams:{
		Input:params}	
	});
}

//��ӵ��λ���Ա
function MemAdd()
{
  userName=$("#UserNames").val()
  $("#Participants").val(userName)	
  $('#staffwin').window('close');
}
//��ӵ�������Ա
function MonAdd()
{
  userName=$("#UserNames").val()
  $("#MornRepMeetpants").val(userName)	
  $('#staffwin').window('close');
}
//ѡ��λ���Ա
function MeetMember(name)
{
	if(name==""){
	  $("#UserNames").val("");
	}
	userName=$("#UserNames").val();
    if(userName.indexOf(name) != -1){
	    return true;  
    }
	if(userName==""){
	  userName=name+"��";
	}else{
	  userName=userName+name+"��";
	}
	$("#UserNames").val(userName);		
}
function add_event(){
	AllStyle("textarea","",100);
	chkTableDate("HeadNurEvaluate-94387-94393-94398");
	//����ʱ�����
	/*$("input[id^='HeadNurEvaluate-94387-94393-94398']").each(function(){
		if((this.id.split("-").length==4)){
			var datevalue=$("input[id^='"+this.id+"']").datebox("getValue");
			$("input[id='"+this.id+"']").datebox().datebox('calendar').calendar({
				validator: function(date){
					var now = new Date();
					return date<=now;
				}
			});
			$("input[id^='"+this.id+"']").datebox("setValue",datevalue);
		}
	})*/ 
	
}
///���������¼�����ԭ�������ѡ��������д�ĸĽ���ʩ   ���inputֵΪ�Ľ���ʩ��  �򷵻�""
function getInputValue(id){
	var inputvalue=getHideInputValue(id);
	if(inputvalue=="��"){
		inputvalue="";
	}
	if((inputvalue!="��")&&(inputvalue!="")){
		inputvalue=$g("���Ĵ�ʩ��")+inputvalue;
	}
	return inputvalue;
	
}
