/// Description: ����׹����ʿ�����۵����۽��� 
/// Creator: congyue
/// CreateDate: 2018-04-17
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
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
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
			//setCheckBoxRelation(this.id);
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
	});
	// ���ᱨ�����ڿ��� sufan 2019-06-18 ��ͳһȥ�����Ჿ
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
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!="")	{
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
	bodywidth=$("body").width();
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
	
	
	//�λ���Ա ��Ӱ�ť�¼�
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //�����ѯ
   	$('#Add').bind("click",MemAdd);     //�����ӣ�����ѡ����Ա��ӵ������ �λ���Ա
  	//$('#MonAdd').bind("click",MonAdd);  //�����ӣ�����ѡ����Ա��ӵ������ ������Ա sufan 2019-06-18 ��ͳһȥ�����Ჿ��
}

function setManImprove()
{
    var list="",PersonFactor="",DiviceFactor="",ManaFactor="",EnvirFactor="";
    var i=0,j=0,k=0,l=0;
    var PersonFactorlist="",DiviceFactorlist="",ManaFactorlist="",EnvirFactorlist="";
	$("input[id^='PersonFactor']").each(function(){  
		if($(this).is(':checked')){                
			if(this.id.indexOf("PersonFactor-94800-94803")>=0) {         //��������-���߻��м������������ϰ�
				if(this.id.indexOf("PersonFactor-94800-94803-94815")>=0){  //��������-���߻��м������������ϰ�-����
					i=i+1;
					if($(this).val()==$g("����")){
						i=i-1;
						PersonFactor="";
					}else{
						PersonFactor=i+"��"+$g("��������")+"����"+$g("���߻��м������������ϰ�")+"����"+$g("����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
					}
					PersonFactorlist=PersonFactorlist+PersonFactor;
				}else if(this.id.indexOf("PersonFactor-94800-94803-94957")>=0) { //��������-���߻��м������������ϰ�-ͻ������仯
					i=i+1;
					if($(this).val()==$g("ͻ������仯")){
						i=i-1;
						PersonFactor="";
					}else{
						PersonFactor=i+"��"+$g("��������")+"����"+$g("���߻��м������������ϰ�")+"����"+$g("ͻ������仯")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
					}
					PersonFactorlist=PersonFactorlist+PersonFactor;
				}else{  
			    	i=i+1;
					PersonFactor=i+"��"+$g("��������")+"����"+$g("���߻��м������������ϰ�")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			    	PersonFactorlist=PersonFactorlist+PersonFactor;
				}
			
			}
			if(this.id.indexOf("PersonFactor-94800-94804")>=0){        //�������ء������������Բ�               
				i=i+1;
				PersonFactor=i+"��"+$g("��������")+"����"+$g("���������Բ�")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}
			if(this.id.indexOf("PersonFactor-94800-94805")>=0){     //�������ء�������������֪������ 
				i=i+1;	
				PersonFactor=i+"��"+$g("��������")+"����"+$g("����������֪������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			} 

			if(this.id.indexOf("PersonFactor-94801")>=0) { //�������ء����������ҳ������㻤��Ա
				i=i+1;	
				PersonFactor=i+"��"+$g("�������ҳ������㻤��Ա")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			} 

			if(this.id.indexOf("PersonFactor-94802-94806")>=0){ //������Ա������������λ
				i=i+1;	
				PersonFactor=i+"��"+$g("������Ա")+"����"+$g("��������λ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}

			if(this.id.indexOf("PersonFactor-94802-94807")>=0){ //������Ա������ȫ��ʩ��ʵ����λ
				i=i+1;	
				PersonFactor=i+"��"+$g("������Ա")+"����"+$g("��ȫ��ʩ��ʵ����λ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				PersonFactorlist=PersonFactorlist+PersonFactor;
			}  
		}
	});
	if(PersonFactorlist!=""){
		list=list+"\n"+$g("һ����Ա����")+"\n"+PersonFactorlist;
	}

	$("input[id^='DiviceFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("DiviceFactor-94874")>=0){   //����
				j=j+1;
				DiviceFactor=j+"��"+$g("����")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;
			}
			if(this.id.indexOf("DiviceFactor-94875")>=0){
				j=j+1;
				DiviceFactor=j+"��"+$g("����ƽ��")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor	;
			}
			if(this.id.indexOf("DiviceFactor-94876")>=0){
				j=j+1;
				DiviceFactor=j+"��"+$g("����ϵͳ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
			if(this.id.indexOf("DiviceFactor-94877")>=0) {
				j=j+1;
				DiviceFactor=j+"��"+$g("������ʩ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}

			if(this.id.indexOf("DiviceFactor-94878")>=0){
				j=j+1;
				DiviceFactor=j+"��"+$g("�����䡢ϴԡ����ʩ�ϰ�")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
			if(this.id.indexOf("DiviceFactor-94879")>=0){
				j=j+1;
				DiviceFactor=j+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DiviceFactorlist=DiviceFactorlist+DiviceFactor;	
			}
		}
	});	
	if(DiviceFactorlist!=""){
		list=list+"\n"+$g("���������豸����")+"\n"+DiviceFactorlist;
	}

	$("input[id^='ManaFactor']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			ManaFactor=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorlist=ManaFactorlist+ManaFactor;

		}
	});
	if(ManaFactorlist!=""){
		list=list+"\n"+$g("�����������������ߡ���������")+"\n"+ManaFactorlist;
	}
		
	$("input[id^='EnvirFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			EnvirFactor=l+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorlist=EnvirFactorlist+EnvirFactor;
		}
	});
	if(EnvirFactorlist!=""){
		list=list+"\n"+$g("�ġ������������أ���ʪ�ȡ������������ȣ�")+"\n"+EnvirFactorlist;
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
			EvaRecordId=data[1]
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
//У��
function checkother(){
	//��������-���߻��м������������ϰ�  ����
	var PersonFactorjboth=0,PersonFactorjb="",PersonFactorjbList="";
	$("input[type=checkbox][id='PersonFactor-94800-94803-94815']").each(function(){
		if ($(this).is(':checked')){
			PersonFactorjb=this.value;
		}
	})
	if(PersonFactorjb==$g("����")){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PersonFactorjbList=this.value
			}
		})
		if (PersonFactorjbList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("���߻��м������������ϰ�")+"��"+$g("��ѡ")+$g('����')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-94955']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95725'][class='lable-input']").val()=="")){
				PersonFactorjboth=-1;
			}
		}
	})
	if(PersonFactorjboth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("���߻��м������������ϰ�")+"-"+$g("����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//��������-���߻��м������������ϰ�  ͻ������仯
	var PersonFactortfoth=0,PersonFactortf="",PersonFactortfList="";
	$("input[type=checkbox][id='PersonFactor-94800-94803-94957']").each(function(){
		if ($(this).is(':checked')){
			PersonFactortf=this.value;
		}
	})
	if(PersonFactortf==$g("ͻ������仯")){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PersonFactortfList=this.value
			}
		})
		if (PersonFactortfList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("���߻��м������������ϰ�")+"��"+$g("��ѡ")+$g('ͻ������仯')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-94965']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95735'][class='lable-input']").val()=="")){
				PersonFactortfoth=-1;
			}
		}
	})
	if(PersonFactortfoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("���߻��м������������ϰ�")+"-"+$g("ͻ������仯")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//��������-���������Բ�
	var PersonFactorycxoth=0;
	$("input[type=checkbox][id^='PersonFactor-94800-94804-94872']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95743'][class='lable-input']").val()=="")){
				PersonFactorycxoth=-1;
			}
		}
	})
	if(PersonFactorycxoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("���������Բ�")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//��������-����������֪������
	var PersonFactorrzoth=0;
	$("input[type=checkbox][id^='PersonFactor-94800-94805-94845']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95748'][class='lable-input']").val()=="")){
				PersonFactorrzoth=-1;
			}
		}
	})
	if(PersonFactorrzoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("����������֪������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�������ҳ������㻤��Ա
	var PersonFactorjsoth=0;
	$("input[type=checkbox][id^='PersonFactor-94801-94853']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95757'][class='lable-input']").val()=="")){
				PersonFactorjsoth=-1;
			}
		}
	})
	if(PersonFactorjsoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�������ҳ������㻤��Ա")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}

	//������Ա-��������λ
	var PersonFactorhlpgoth=0;
	$("input[type=checkbox][id^='PersonFactor-94802-94806-94862']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95768'][class='lable-input']").val()=="")){
				PersonFactorhlpgoth=-1;
			}
		}
	})
	if(PersonFactorhlpgoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("������Ա")+"-"+$g("��������λ")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//������Ա-��ȫ��ʩ��ʵ����λ
	var PersonFactorhlcsoth=0;
	$("input[type=checkbox][id^='PersonFactor-94802-94807-94870']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95777'][class='lable-input']").val()=="")){
				PersonFactorhlcsoth=-1;
			}
		}
	})
	if(PersonFactorhlcsoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("������Ա")+"-"+$g("��ȫ��ʩ��ʵ����λ")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�����������������ߡ���������
	var ManaFactoroth=0;
	$("input[type=checkbox][id^='ManaFactor-94904']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95809'][class='lable-input']").val()=="")){
				ManaFactoroth=-1;
			}
		}
	})
	if(ManaFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�������������ߡ���������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�ġ������������أ���ʪ�ȡ������������ȣ�
	var EnvirFactoroth=0;
	$("input[type=checkbox][id^='EnvirFactor-94912']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.95816'][class='lable-input']").val()=="")){
				EnvirFactoroth=-1;
			}
		}
	})
	if(EnvirFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�������أ���ʪ�ȡ������������ȣ�")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
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
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//��������-���߻��м������������ϰ�  ����
	if($("input[type=checkbox][id='PersonFactor-94800-94803-94815']").is(':checked')){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").attr("disabled",false);

	}else{
		$("input[name$='.95725'][class='lable-input']").val("");
		$("input[name$='.95725'][class='lable-input']").hide();
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").removeAttr("checked");
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").attr("disabled",true);
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94815-']").nextAll(".lable-input").hide();
	}	
	//��������-���߻��м������������ϰ�  ͻ������仯
	if($("input[type=checkbox][id='PersonFactor-94800-94803-94957']").is(':checked')){
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").attr("disabled",false);
	}else{
		$("input[name$='.95735'][class='lable-input']").val("");
		$("input[name$='.95735'][class='lable-input']").hide();
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").removeAttr("checked");
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").attr("disabled",true);
		$("input[type=checkbox][id^='PersonFactor-94800-94803-94957-']").nextAll(".lable-input").hide();
	}
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
	}) */
	
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
			$.messager.alert($g("��ʾ:"),"��˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
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
		$.messager.alert($g("��ʾ:"),"����Ϊ���ر��棬��δ���ظ���ǰ��¼�ˣ���Ȩ�޳�����ˣ�");
		return;
	}
	//��������
	runClassMethod("web.DHCADVCOMMONPART","CancelAuditReport",{'params':CancelAuditList},
	function(jsonString){ 
		if(jsonString.ErrCode < 0){
			$.messager.alert($g("��ʾ:"),"������˴���,����ԭ��:"+"<font style='color:red;'>"+jsonString.ErrMsg+"</font>");   ///+"��"+errnum+"������"
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
