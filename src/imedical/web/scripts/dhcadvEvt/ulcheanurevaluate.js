/// Description: ѹ����ʿ�����۵����۽��� 
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
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д	
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
			setManImprove()
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
	// ���ᱨ�����ڿ���  sufan 2019-06-18 ��ͳһȥ�����Ჿ��
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
		$("#CauseAnalysis-text").attr("readonly",'readonly');
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
		}) */ 
		
	}
	//�λ���Ա 
	$('#Participants').css({
		"width":800,
		"max-width":800
	});
	RepSetRead("Participants","input",1);	
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
	
	
	//�λ���Ա ��Ӱ�ť�¼�
	$('#ParPantsAddBut').on("click",function(){
		StaffEnter();
	})
	$('#Find').bind("click",QueryName);   //�����ѯ
   	$('#Add').bind("click",MemAdd);     //�����ӣ�����ѡ����Ա��ӵ������ �λ���Ա
  	//$('#MonAdd').bind("click",MonAdd);  //�����ӣ�����ѡ����Ա��ӵ������ ������Ա sufan 2019-06-18 ��ͳһȥ�����Ჿ��
}
//��ȡԭ��������������Ĵ�ʩ
function setManImprove()
{
    var list="",HumFactor="",DeviceCause="",MatFactor="",MethodFactor="",  EnvirFactor="", ManaFactor="";
	var i=0,j=0,k=0,l=0,m=0,n=0
    var HumFactorlist="",DeviceCauselist="",MatFactorlist="",MethodFactorlist="",  EnvirFactorlist="", ManaFactorlist="";
	$("input[id^='HumFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("HumFactor-94914-95118")>=0){	
				i=i+1;
				if($(this).val()==$g("12��������Ⱥ")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("12��������Ⱥ")+$g("����ָ����BMI��")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95122")>=0){	
				i=i+1;
				if($(this).val()==$g("12��������Ⱥ")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("12��������Ⱥ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95122")>=0){	
				i=i+1;
				if($(this).val()==$g("12��������Ⱥ")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("12��������Ⱥ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95127")>=0){	
				i=i+1;
				if($(this).val()==$g("Ƥ������")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("Ƥ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95135")>=0){	
				i=i+1;
				if($(this).val()==$g("�")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("�")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95136")>=0){	
				i=i+1;
				if($(this).val()==$g("�˶�")){
					i=i-1;
					HumFactor="";
				}else{ 
					HumFactor=i+"��"+$g("��������")+"����"+$g("�˶�")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95137")>=0){	
				i=i+1;
				if($(this).val()==$g("Ӫ������")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("Ӫ������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95155")>=0){	
				i=i+1;
				if($(this).val()==$g("����״��")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("����״��")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95160")>=0){	
				i=i+1;
				if($(this).val()==$g("��֯��ע������")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("��֯��ע������")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914-95162")>=0){	
				i=i+1;
				if($(this).val()==$g("�ܾ�ʹ�ñ�����ʩ")){
					i=i-1;
					HumFactor="";
				}else{
					HumFactor=i+"��"+$g("��������")+"����"+$g("�ܾ�ʹ�ñ�����ʩ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor;
			}else if(this.id.indexOf("HumFactor-94914")>=0){
				i=i+1;
				HumFactor=i+"��"+$g("��������")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor; 		
			}else if(this.id.indexOf("HumFactor-94915-95180-95183")>=0){
				i=i+1;
				HumFactor=i+"��"+$g("��ʿ����")+"����"+$g("������������λ")+"����"+$g("ѹ��Ԥ��������������Բ�ǿ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94915-95169")>=0){
				i=i+1;
				if($(this).val()==$g("�����ʩ��ʵ����λ")){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"��"+$g("��ʿ����")+"����"+$g("�����ʩ��ʵ����λ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor; 		
			}else if(this.id.indexOf("HumFactor-94915-95180")>=0){
				i=i+1;
				if($(this).val()==$g("������������λ")){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"��"+$g("��ʿ����")+"����"+$g("������������λ")+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94915")>=0){
				i=i+1;
				HumFactor=i+"��"+$g("��ʿ����")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;
			}else if(this.id.indexOf("HumFactor-94916")>=0){
				i=i+1;
				HumFactor=i+"��"+$g("ҽ������")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf(" HumFactor-94917-95198")>=0){
				i=i+1;
				if($(this).val()==$g("δ��ʵѹ��Ԥ����������Ҫ��")){
					i=i-1;
					HumFactor="";
				}else{  
					HumFactor=i+"��"+$g("����Ա���㻤����")+"����"+$g("δ��ʵѹ��Ԥ����������Ҫ��")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				HumFactorlist=HumFactorlist+HumFactor ;		
			}else if(this.id.indexOf("HumFactor-94917")>=0){
				i=i+1;
				HumFactor=i+"��"+$g("����Ա���㻤����")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				HumFactorlist=HumFactorlist+HumFactor ;		
			}
		}
	});
	if(HumFactorlist!=""){
		list=list+"\n"+$g("һ���˵�����:")+"\n"+HumFactorlist;
	}

	$("input[id^='UlcDeviceCause']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("UlcDeviceCause-94920")>=0){	
				j=j+1;
				if($(this).val()==$g("�豸��ʩ������")){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"��"+$g("�豸��ʩ������")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause-94921")>=0){	
				j=j+1;
				if($(this).val()==$g("�ṩԤ��ѹ����Ӧ��ʩ���豸����")){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"��"+$g("�ṩԤ��ѹ����Ӧ��ʩ���豸����")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause-94922")>=0){	
				j=j+1;
				if($(this).val()==$g("�������豸����")){
					j=j-1;
					DeviceCause="";
				}else{
					DeviceCause=j+"��"+$g("�������豸����")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				list=list+DeviceCause;
			}else if(this.id.indexOf("UlcDeviceCause")>=0){	
				j=j+1;
				DeviceCause=j+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				DeviceCauselist=DeviceCauselist+DeviceCause;
			}
		}
	});
	if(DeviceCauselist!=""){
		list=list+"\n"+$g("�����豸��ʩ����:")+"\n"+DeviceCauselist;
	}

	$("input[id^='MatFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("MatFactor-94925")>=0){	
				k=k+1;
				if($(this).val()==$g("ҽ������ѹ��")){
					k=k-1;
					MatFactor="";
				}else{
					MatFactor=k+"��"+$g("ҽ������ѹ��")+":"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				}
				MatFactorlist=MatFactorlist+MatFactor;
			}else if(this.id.indexOf("MatFactor")>=0){	
				k=k+1;
				MatFactor=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				MatFactorlist=MatFactorlist+MatFactor;
			} 
		}
	});
	if(MatFactorlist!=""){
		list=list+"\n"+$g("������������:")+"\n"+MatFactorlist;
	}

	$("input[id^='UlcMethodFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			MethodFactor=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			MethodFactorlist=MethodFactorlist+MethodFactor;
		}
	});
	if(MethodFactorlist!=""){
		list=list+"\n"+$g("�ġ���������:")+"\n"+MethodFactorlist;
	}

	$("input[id^='UlcEnvirFactor']").each(function(){
		if($(this).is(':checked')){
			m=m+1;
			EnvirFactor=m+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			EnvirFactorlist=EnvirFactorlist+EnvirFactor;
		}
	});
	if(EnvirFactorlist!=""){
		list=list+"\n"+$g("�塢��������:")+"\n"+EnvirFactorlist;
	}

	$("input[id^='UlcManaFactor']").each(function(){
		if($(this).is(':checked')){
			n=n+1;
			ManaFactor=n+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			ManaFactorlist=ManaFactorlist+ManaFactor;
		}
	});
	if(ManaFactorlist!=""){
		list=list+"\n"+$g("������������:")+"\n"+ManaFactorlist;
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
	//һ���˵�����
	//��������-12��������Ⱥ
	var HumFactorys=0,HumFactorysList="";
	$("input[type=checkbox][id='HumFactor-94914-95118']").each(function(){
		if ($(this).is(':checked')){
			HumFactorys=this.value;
		}
	})
	if(HumFactorys==$g("12��������Ⱥ")){
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorysList=this.value
			}
		})
		if (HumFactorysList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('12��������Ⱥ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	
	//��������-12��������Ⱥ
	var HumFactoryx=0,HumFactoryxList="";
	$("input[type=checkbox][id='HumFactor-94914-95122']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryx=this.value;
		}
	})
	if(HumFactoryx==$g("12��������Ⱥ")){
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryxList=this.value
			}
		})
		if (HumFactoryxList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('12��������Ⱥ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��������-Ƥ������
	var HumFactorpf=0,HumFactorpfList="";
	$("input[type=checkbox][id='HumFactor-94914-95127']").each(function(){
		if ($(this).is(':checked')){
			HumFactorpf=this.value;
		}
	})
	if(HumFactorpf==$g("Ƥ������")){
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorpfList=this.value
			}
		})
		if (HumFactorpfList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('Ƥ������')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��������-�
	var HumFactorhd=0,HumFactorhdList="";
	$("input[type=checkbox][id='HumFactor-94914-95135']").each(function(){
		if ($(this).is(':checked')){
			HumFactorhd=this.value;
		}
	})
	if(HumFactorhd==$g("�")){
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorhdList=this.value
			}
		})
		if (HumFactorhdList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('�')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��������-�˶�
	var HumFactoryd=0,HumFactorydList="";
	$("input[type=checkbox][id='HumFactor-94914-95136']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryd=this.value;
		}
	})
	if(HumFactoryd==$g("�˶�")){
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorydList=this.value
			}
		})
		if (HumFactorydList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('�˶�')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��������-Ӫ������
	var HumFactoryy=0,HumFactoryyList="";
	$("input[type=checkbox][id='HumFactor-94914-95137']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryy=this.value;
		}
	})
	if(HumFactoryy==$g("Ӫ������")){
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryyList=this.value
			}
		})
		if (HumFactoryyList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('Ӫ������')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	
	//��������-����״��
	var HumFactorjs=0,HumFactorjsList="";
	$("input[type=checkbox][id='HumFactor-94914-95155']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjs=this.value;
		}
	})
	if(HumFactorjs==$g("����״��")){
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjsList=this.value
			}
		})
		if (HumFactorjsList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('����״��')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	
	//��������-��֯��ע������
	var HumFactoryh=0,HumFactoryhList="";
	$("input[type=checkbox][id='HumFactor-94914-95160']").each(function(){
		if ($(this).is(':checked')){
			HumFactoryh=this.value;
		}
	})
	if(HumFactoryh==$g("��֯��ע������")){
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactoryhList=this.value
			}
		})
		if (HumFactoryhList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('��֯��ע������')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��������-�ܾ�ʹ�ñ�����ʩ
	var HumFactorcs=0,HumFactorcsList="";
	$("input[type=checkbox][id='HumFactor-94914-95162']").each(function(){
		if ($(this).is(':checked')){
			HumFactorcs=this.value;
		}
	})
	if(HumFactorcs==$g("�ܾ�ʹ�ñ�����ʩ")){
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorcsList=this.value
			}
		})
		if (HumFactorcsList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('�ܾ�ʹ�ñ�����ʩ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}

	//��ʿ����-���߻��м������������ϰ�
	var HumFactorzaoth=0,HumFactorza="",HumFactorzaList="";
	$("input[type=checkbox][id='HumFactor-94915-95169']").each(function(){
		if ($(this).is(':checked')){
			HumFactorza=this.value;
		}
	})
	if(HumFactorza==$g("�����ʩ��ʵ����λ")){
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorzaList=this.value
			}
		})
		if (HumFactorzaList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"��"+$g("��ѡ")+$g('�����ʩ��ʵ����λ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94915-95169-95179']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96008'][class='lable-input']").val()=="")){
				HumFactorzaoth=-1;
			}
		}
	})
	if(HumFactorzaoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("�����ʩ��ʵ����λ")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//��ʿ����-������������λ
	var HumFactorjy="",HumFactorjyList="";
	$("input[type=checkbox][id='HumFactor-94915-95180']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjy=this.value;
		}
	})
	if(HumFactorjy==$g("������������λ")){
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjyList=this.value
			}
		})
		if (HumFactorjyList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"��"+$g("��ѡ")+$g('������������λ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	//ѹ��Ԥ��������������Բ�ǿ
	var HumFactorffoth=0,HumFactorff="",HumFactorffList="";
	$("input[type=checkbox][id='HumFactor-94915-95180-95183']").each(function(){
		if ($(this).is(':checked')){
			HumFactorff=this.value;
		}
	})
	if(HumFactorff=="ѹ��Ԥ��������������Բ�ǿ"){
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorffList=this.value
			}
		})
		if (HumFactorffList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("�����ʩ��ʵ����λ")+"��"+$g("��ѡ")+$g('ѹ��Ԥ��������������Բ�ǿ')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94915-95180-95183-95188']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96017'][class='lable-input']").val()=="")){
				HumFactorffoth=-1;
			}
		}
	})
	if(HumFactorffoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��ʿ����")+"-"+$g("�����ʩ��ʵ����λ")+"-"+$g("ѹ��Ԥ��������������Բ�ǿ")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//ҽ������
	var HumFactoroth=0;
	$("input[type=checkbox][id^='HumFactor-94916-95196']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96026'][class='lable-input']").val()=="")){
				HumFactoroth=-1;
			}
		}
	})
	if(HumFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("ҽ������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}

	//����Ա���㻤����
	var HumFactoroth=0;
	$("input[type=checkbox][id^='HumFactor-94917-95210']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96041'][class='lable-input']").val()=="")){
				HumFactoroth=-1;
			}
		}
	})
	if(HumFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ա���㻤����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//����Ա���㻤����--δ��ʵѹ��Ԥ����������Ҫ��
	var HumFactorjyoth=0,HumFactorjy="",HumFactorjyList="";
	$("input[type=checkbox][id='HumFactor-94917-95198']").each(function(){
		if ($(this).is(':checked')){
			HumFactorjy=this.value;
		}
	})
	if(HumFactorjy==$g("δ��ʵѹ��Ԥ����������Ҫ��")){
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				HumFactorjyList=this.value
			}
		})
		if (HumFactorjyList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("����Ա���㻤����")+"��"+$g("��ѡ")+$g('δ��ʵѹ��Ԥ����������Ҫ��')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='HumFactor-94917-95198-95206']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96037'][class='lable-input']").val()=="")){
				HumFactorjyoth=-1;
			}
		}
	})
	if(HumFactorjyoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("����Ա���㻤����")+"-"+$g("δ��ʵѹ��Ԥ����������Ҫ��")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�����豸��ʩ����
	var UlcDeviceCauseoth=0;
	$("input[type=checkbox][id^='UlcDeviceCause-94923']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96055'][class='lable-input']").val()=="")){
				UlcDeviceCauseoth=-1;
			}
		}
	})
	if(UlcDeviceCauseoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	//�豸��ʩ����-�豸��ʩ������
	var UlcDeviceCausesboth=0,UlcDeviceCausesb="",UlcDeviceCausesbList="";
	$("input[type=checkbox][id='UlcDeviceCause-94920']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausesb=this.value;
		}
	})
	if(UlcDeviceCausesb==$g("�豸��ʩ������")){
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausesbList=this.value
			}
		})
		if (UlcDeviceCausesbList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"��"+$g("��ѡ")+$g('�豸��ʩ������')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94920-95213']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96045'][class='lable-input']").val()=="")){
				UlcDeviceCausesboth=-1;
			}
		}
	})
	if(UlcDeviceCausesboth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"-"+$g("�豸��ʩ������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�ṩԤ��ѹ����Ӧ��ʩ���豸����
	var UlcDeviceCausecsoth=0,UlcDeviceCausecs="",UlcDeviceCausecsList="";
	$("input[type=checkbox][id='UlcDeviceCause-94921']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausecs=this.value;
		}
	})
	if(UlcDeviceCausecs==$g('�ṩԤ��ѹ����Ӧ��ʩ���豸����')){
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausecsList=this.value
			}
		})
		if (UlcDeviceCausecsList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"��"+$g("��ѡ")+$g('�ṩԤ��ѹ����Ӧ��ʩ���豸����')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94921-95221']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96050'][class='lable-input']").val()=="")){
				UlcDeviceCausecsoth=-1;
			}
		}
	})
	if(UlcDeviceCausecsoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"-"+$g('�ṩԤ��ѹ����Ӧ��ʩ���豸����')+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�������豸����
	var UlcDeviceCausegzoth=0,UlcDeviceCausegz="",UlcDeviceCausegzList="";
	$("input[type=checkbox][id='UlcDeviceCause-94922']").each(function(){
		if ($(this).is(':checked')){
			UlcDeviceCausegz=this.value;
		}
	})
	if(UlcDeviceCausegz==$g("�������豸����")){
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				UlcDeviceCausegzList=this.value
			}
		})
		if (UlcDeviceCausegzList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"��"+$g("��ѡ")+$g('�������豸����')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='UlcDeviceCause-94922-95218']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96054'][class='lable-input']").val()=="")){
				UlcDeviceCausegzoth=-1;
			}
		}
	})
	if(UlcDeviceCausegzoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("�豸��ʩ����")+"-"+$g("�������豸����")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//������������
	var MatFactoroth=0;
	$("input[type=checkbox][id^='MatFactor-94927']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96064'][class='lable-input']").val()=="")){
				MatFactoroth=-1;
			}
		}
	})
	if(MatFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//������������ ҽ������ѹ��
	var MatFactorqjoth=0,MatFactorqj="",MatFactorqjList="";
	$("input[type=checkbox][id='MatFactor-94925']").each(function(){
		if ($(this).is(':checked')){
			MatFactorqj=this.value;
		}
	})
	if(MatFactorqj==$g("ҽ������ѹ��")){
		$("input[type=checkbox][id^='MatFactor-94925-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				MatFactorqjList=this.value
			}
		})
		if (MatFactorqjList==""){
			$.messager.alert($g("��ʾ:"),"��"+$g("ҽ������ѹ��")+"��"+$g("��ѡ")+$g('�������豸����')+"��"+$g("�빴ѡ��Ӧ����")+"��");	
			return false;
		}
	}
	$("input[type=checkbox][id^='MatFactor-94925-95227']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96062'][class='lable-input']").val()=="")){
				MatFactorqjoth=-1;
			}
		}
	})
	if(MatFactorqjoth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"-"+$g("ҽ������ѹ��")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//�ġ���������
	var methodFactoroth=0;
	$("input[type=checkbox][id^='methodFactor-94931']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96067'][class='lable-input']").val()=="")){
				methodFactoroth=-1;
			}
		}
	})
	if(methodFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
		return false;
	}
	
	//������������
	var UlcManaFactoroth=0;
	$("input[type=checkbox][id^='UlcManaFactor-94942']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.96076'][class='lable-input']").val()=="")){
				UlcManaFactoroth=-1;
			}
		}
	})
	if(UlcManaFactoroth==-1){
		$.messager.alert($g("��ʾ:"),"��"+$g("��������")+"��"+$g("��ѡ")+$g('����')+"��"+$g("����д����")+"��");	
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
	//��������-12��������Ⱥ 
	if($("input[type=checkbox][id='HumFactor-94914-95118']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95118-']").attr("disabled",true);
	}	
	//��������-12��������Ⱥ 
	if($("input[type=checkbox][id='HumFactor-94914-95122']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95122-']").attr("disabled",true);
	}	
	//��������-Ƥ������
	if($("input[type=checkbox][id='HumFactor-94914-95127']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95127-']").attr("disabled",true);
	}	
	//��������-�
	if($("input[type=checkbox][id='HumFactor-94914-95135']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95135-']").attr("disabled",true);
	}	
	//��������-�˶�
	if($("input[type=checkbox][id='HumFactor-94914-95136']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95136-']").attr("disabled",true);
	}	
	//��������-Ӫ������
	if($("input[type=checkbox][id='HumFactor-94914-95137']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95137-']").attr("disabled",true);
	}	
	//��������-����״��
	if($("input[type=checkbox][id='HumFactor-94914-95155']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95155-']").attr("disabled",true);
	}	
	//��������-��֯��ע������
	if($("input[type=checkbox][id='HumFactor-94914-95160']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95160-']").attr("disabled",true);
	}	
	//��������-�ܾ�ʹ�ñ�����ʩ
	if($("input[type=checkbox][id='HumFactor-94914-95162']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").attr("disabled",false);

	}else{
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94914-95162-']").attr("disabled",true);
	}	
	
	//��ʿ����-�����ʩ��ʵ����λ
	if($("input[type=checkbox][id='HumFactor-94915-95169']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").attr("disabled",false);
	}else{
		$("input[name$='.96008'][class='lable-input']").val("");
		$("input[name$='.96008'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95169-']").attr("disabled",true);
	}
	//��ʿ����-������������λ
	if($("input[type=checkbox][id='HumFactor-94915-95180']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").attr("disabled",false);
	}else{
		$("input[name$='.96017'][class='lable-input']").val("");
		$("input[name$='.96017'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95180-']").attr("disabled",true);
	}
	//��ʿ����-������������λ-ѹ��Ԥ��������������Բ�ǿ
	if($("input[type=checkbox][id='HumFactor-94915-95180-95183']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").attr("disabled",false);
	}else{
		$("input[name$='.96017'][class='lable-input']").val("");
		$("input[name$='.96017'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94915-95180-95183-']").attr("disabled",true);
	}
	//����Ա���㻤����-δ��ʵѹ��Ԥ����������Ҫ��
	if($("input[type=checkbox][id='HumFactor-94917-95198']").is(':checked')){
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").attr("disabled",false);
	}else{
		$("input[name$='.96037'][class='lable-input']").val("");
		$("input[name$='.96037'][class='lable-input']").hide();
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").removeAttr("checked");
		$("input[type=checkbox][id^='HumFactor-94917-95198-']").attr("disabled",true);
	}
	
	//�����豸��ʩ����-�豸��ʩ������
	if($("input[type=checkbox][id='UlcDeviceCause-94920']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").attr("disabled",false);
	}else{
		$("input[name$='.96045'][class='lable-input']").val("");
		$("input[name$='.96045'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94920-']").attr("disabled",true);
	}
	//�����豸��ʩ����-�ṩԤ��ѹ����Ӧ��ʩ���豸����
	if($("input[type=checkbox][id='UlcDeviceCause-94921']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").attr("disabled",false);
	}else{
		$("input[name$='.96050'][class='lable-input']").val("");
		$("input[name$='.96050'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94921-']").attr("disabled",true);
	}
	//�����豸��ʩ����-�ṩԤ��ѹ����Ӧ��ʩ���豸����
	if($("input[type=checkbox][id='UlcDeviceCause-94922']").is(':checked')){
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").attr("disabled",false);
	}else{
		$("input[name$='.96054'][class='lable-input']").val("");
		$("input[name$='.96054'][class='lable-input']").hide();
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcDeviceCause-94922-']").attr("disabled",true);
	}
	
	//������������-ҽ������ѹ��
	if($("input[type=checkbox][id='MatFactor-94925']").is(':checked')){
		$("input[type=checkbox][id^='MatFactor-94925-']").attr("disabled",false);
	}else{
		$("input[name$='.96062'][class='lable-input']").val("");
		$("input[name$='.96062'][class='lable-input']").hide();
		$("input[type=checkbox][id^='MatFactor-94925-']").removeAttr("checked");
		$("input[type=checkbox][id^='MatFactor-94925-']").attr("disabled",true);
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
	})*/ 
	
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
