/// Description: ��·���ѻ�ʿ�����۵����۽��� 
/// Creator: congyue
/// CreateDate: 2018-04-13
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
	})
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
			setManImprove()
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
	var EvaData=EvaFlagList.replace(/(^\s*)|(\s*$)/g,"").split("^");
	AssessFlag=EvaData[0];
	LocHeadNurEvaFlag=EvaData[1];
	NurDepEvaFlag=EvaData[2];
	if(EvaRecordId!=""){ 
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
				$('a:contains("ɾ��")').parent().hide();
			}
			if(AssessFlag!="Y"){
				$("[id^='"+rowid+"'][id$='"+rownum+"']").attr("readonly",'readonly');
				$("input[id^='"+rowid+"'][id$='"+rownum+"']").datebox({"disabled":true});
				$('a:contains("����")').parent().hide();
			}

		})
	}

}
//��ť�����뷽����
function InitButton(){
	$("#AsseSaveBut").on("click",function(){
		SaveAsse(0);
	})
	/* //������Ա ��Ӱ�ť�¼�
	$('#MorRepMeetAddBut').on("click",function(){
		StaffEnter();
	}) */
	 
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
    var list="",POHumFactor="",POMatFactor="",POManaFactor="",POEnvirFactor="",POOthFactor="";
    var i=0,j=0,k=0,l=0,h=0
    var POHumFactorlist="",POMatFactorlist="",POManaFactorlist="",POEnvirFactorlist="",POOthFactorlist=""; 
	$("input[id^='POHumFactor']").each(function(){  //PersonFactor-94800-94803-94815-94945  PersonFactor-94800-94803-94815
		if($(this).is(':checked')){                //PersonFactor-94800-94803
			if(this.id.indexOf("POHumFactor-94279")>=0){ //��������	
				i=i+1;
				POHumFactor=i+"��"+"�������أ�"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			}
			if(this.id.indexOf("POHumFactor-94280-94295")>=0){     //��ʿ���ء�����������
				i=i+1;	
				POHumFactor=i+"��"+"��ʿ���ء�������������"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94296")>=0){     //��ʿ���ء���Լ������
				i=i+1;	
				POHumFactor=i+"��"+"��ʿ���ء���Լ��������"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94297")>=0){     //��ʿ���ء����ùܼ��̶�����
				i=i+1;	
				POHumFactor=i+"��"+"��ʿ���ء����ùܼ��̶�������"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94280-94298")>=0){     //��ʿ���ء���������������
				i=i+1;	
				POHumFactor=i+"��"+"��ʿ���ء�����������������"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			} 
			if(this.id.indexOf("POHumFactor-94281")>=0){ //ҽ������	
				i=i+1;
				POHumFactor=i+"��"+"ҽ�����أ�"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor
			}
			if(this.id.indexOf("POHumFactor-94283")>=0){ //��������	
				i=i+1;
				POHumFactor=i+"��"+"�������أ�"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POHumFactorlist=POHumFactorlist+POHumFactor;
			}
		}
	});
	if(POHumFactorlist!=""){
		list=list+"\n"+"һ����Ա���أ�ҽ�������ߡ��㻤��"+"\n"+POHumFactorlist;
	}

	$("input[id^='POMatFactor']").each(function(){
		if($(this).is(':checked')){
			if(this.id.indexOf("POMatFactor-94348-")>=0){	//�������ء������ܻ�̶�������ʹ���г��ֹ���
				i=i+1;
				POMatFactor=i+"��"+"�������ء������ܻ�̶�������ʹ���г��ֹ��ϣ�"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			} 
			if(this.id.indexOf("POMatFactor-94349-")>=0){	//�������ء���ȱ����Ӧ�Ĺ̶���
				i=i+1;
				POMatFactor=i+"��"+"�������ء���ȱ����Ӧ�Ĺ̶��ģ�"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			}
			if(this.id.indexOf("POMatFactor-94350")>=0){	//�������ء�������
				i=i+1;
				POMatFactor=i+"��"+"�������ء���������"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
				POMatFactorlist=POMatFactorlist+POMatFactor;
			}   
		}
	});	
	if(POMatFactorlist!=""){
		list=list+"\n"+"�������������"+"\n"+POMatFactorlist;
	}
		
	$("input[id^='POManaFactor']").each(function(){
		if($(this).is(':checked')){
			k=k+1;
			POManaFactor=k+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POManaFactorlist=POManaFactorlist+POManaFactor;
		}
	});
	if(POManaFactorlist!=""){
		list=list+"\n"+"�����������������ߡ���������"+"\n"+POManaFactorlist;
	}
	
	$("input[id^='POEnvirFactor']").each(function(){
		if($(this).is(':checked')){
			l=l+1;
			POEnvirFactor=l+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POEnvirFactorlist=POEnvirFactorlist+POEnvirFactor;
		}
	});
	if(POEnvirFactorlist!=""){
		list=list+"\n"+"�ġ������������أ���ʪ�ȡ������������ȣ�"+"\n"+POEnvirFactorlist;
	}
	
	$("input[id^='POOthFactor']").each(function(){
		if($(this).is(':checked')){
			h=h+1;
			POOthFactor=h+"��"+this.parentElement.innerText+"			"+getInputValue(this.id)+"\n";
			POOthFactorlist=POOthFactorlist+POOthFactor;
		}
	});
	if(POOthFactorlist!=""){
		list=list+"\n"+"�塢��������"+"\n"+POOthFactorlist;
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
	//��������
	var POHumFactorhzoth=0;
	$("input[type=checkbox][id^='POHumFactor-94279-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94294'][class='lable-input']").val()=="")){
				POHumFactorhzoth=-1;
			}
		}
	})
	if(POHumFactorhzoth==-1){
		$.messager.alert("��ʾ:","���������ء���ѡ'����'������д���ݣ�");	
		return false;
	}
	//��ʿ����-��������
	var POHumFactorhspgoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94295-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94309'][class='lable-input']").val()=="")){
				POHumFactorhspgoth=-1;
			}
		}
	})
	if(POHumFactorhspgoth==-1){
		$.messager.alert("��ʾ:","����ʿ����-������������ѡ'����'������д���ݣ�");	
		return false;
	}
	//��ʿ����-Լ������
	var POHumFactorhsysoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94296-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94316'][class='lable-input']").val()=="")){
				POHumFactorhsysoth=-1;
			}
		}
	})
	if(POHumFactorhsysoth==-1){
		$.messager.alert("��ʾ:","����ʿ����-Լ����������ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//��ʿ����-�ùܼ��̶�����
	var POHumFactorhszgoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94297-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94324'][class='lable-input']").val()=="")){
				POHumFactorhszgoth=-1;
			}
		}
	})
	if(POHumFactorhszgoth==-1){
		$.messager.alert("��ʾ:","����ʿ����-�ùܼ��̶���������ѡ'����'������д���ݣ�");	
		return false;
	}
	//��ʿ����-������������
	var POHumFactorhsjkjyoth=0;
	$("input[type=checkbox][id^='POHumFactor-94280-94298-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94328'][class='lable-input']").val()=="")){
				POHumFactorhsjkjyoth=-1;
			}
		}
	})
	if(POHumFactorhsjkjyoth==-1){
		$.messager.alert("��ʾ:","����ʿ����-����������������ѡ'����'������д���ݣ�");	
		return false;
	}
	//ҽ������
	var POHumFactorysoth=0;
	$("input[type=checkbox][id^='POHumFactor-94281-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94336'][class='lable-input']").val()=="")){
				POHumFactorysoth=-1;
			}
		}
	})
	if(POHumFactorysoth==-1){
		$.messager.alert("��ʾ:","��ҽ�����ء���ѡ'����'������д���ݣ�");	
		return false;
	}
	//��������
	var POHumFactoroth=0;
	$("input[type=checkbox][id^='POHumFactor-94283-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94347'][class='lable-input']").val()=="")){
				POHumFactoroth=-1;
			}
		}
	})
	if(POHumFactoroth==-1){
		$.messager.alert("��ʾ:","���������ء���ѡ'����'������д���ݣ�");	
		return false;
	}

	//��������-���ܻ�̶�������ʹ���г��ֹ���
	var POMatFactordgoth=0,POMatFactordg="",POMatFactordgList="";
	$("input[type=checkbox][id='POMatFactor-94348']").each(function(){
		if ($(this).is(':checked')){
			POMatFactordg=this.value;
		}
	})
	if(POMatFactordg=="���ܻ�̶�������ʹ���г��ֹ���"){
		$("input[type=checkbox][id^='POMatFactor-94348-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				POMatFactordgList=this.value
			}
		})
		if (POMatFactordgList==""){
			$.messager.alert("��ʾ:","���������ء���ѡ'���ܻ�̶�������ʹ���г��ֹ���'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	$("input[type=checkbox][id^='POMatFactor-94348-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94356'][class='lable-input']").val()=="")){
				POMatFactordgoth=-1;
			}
		}
	})
	if(POMatFactordgoth==-1){
		$.messager.alert("��ʾ:","����������-���ܻ�̶�������ʹ���г��ֹ��ϡ���ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//��������-ȱ����Ӧ�Ĺ̶���
	var POMatFactorqsoth=0,POMatFactorqs="",POMatFactorqsList="";
	$("input[type=checkbox][id='POMatFactor-94349']").each(function(){
		if ($(this).is(':checked')){
			POMatFactorqs=this.value;
		}
	})
	if(POMatFactorqs=="ȱ����Ӧ�Ĺ̶���"){
		$("input[type=checkbox][id^='POMatFactor-94349-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				POMatFactorqsList=this.value
			}
		})
		if (POMatFactorqsList==""){
			$.messager.alert("��ʾ:","���������ء���ѡ'ȱ����Ӧ�Ĺ̶���'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	$("input[type=checkbox][id^='POMatFactor-94349-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94359'][class='lable-input']").val()=="")){
				POMatFactorqsoth=-1;
			}
		}
	})
	if(POMatFactorqsoth==-1){
		$.messager.alert("��ʾ:","��ȱ����Ӧ�Ĺ̶��ġ���ѡ'����'������д���ݣ�");	
		return false;
	}
	//��������
	var POMatFactoroth=0;
	$("input[type=checkbox][id^='POMatFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94350'][class='lable-input']").val()=="")){
				POMatFactoroth=-1;
			}
		}
	})
	if(POMatFactoroth==-1){
		$.messager.alert("��ʾ:","���������ء���ѡ'����'������д���ݣ�");	
		return false;
	}
	//�����������������ߡ���������
	var POManaFactoroth=0;
	$("input[type=checkbox][id^='POManaFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94365'][class='lable-input']").val()=="")){
				POManaFactoroth=-1;
			}
		}
	})
	if(POManaFactoroth==-1){
		$.messager.alert("��ʾ:","�����������ߡ��������ء���ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//�ġ������������أ���ʪ�ȡ������������ȣ�
	var POEnvirFactoroth=0;
	$("input[type=checkbox][id^='POEnvirFactor-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94368'][class='lable-input']").val()=="")){
				POEnvirFactoroth=-1;
			}
		}
	})
	if(POEnvirFactoroth==-1){
		$.messager.alert("��ʾ:","���������أ���ʪ�ȡ������������ȣ�����ѡ'����'������д���ݣ�");	
		return false;
	}
	//�塢����
	var POOthFactor=0;
	$("input[type=checkbox][id^='POOthFactor']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94287'][class='lable-input']").val()=="")){
				POOthFactor=-1;
			}
		}
	})
	if(POOthFactor==-1){
		$.messager.alert("��ʾ:","��ԭ�������������ѡ'����'������д���ݣ�");	
		return false;
	}
	//����Ľ�  ManaImprovement-94378-96091
	var ManaImprovementoth=0;
	$("input[type=checkbox][id^='ManaImprovement']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.96082'][class='lable-input']").val()=="")){
				ManaImprovementoth=-1;
			}
			if((this.value=="�ƶȡ����̼��淶�ƶ����޶�")){
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
		$.messager.alert("��ʾ:","������Ľ�����ѡ'�ƶȡ����̼��淶�ƶ����޶�'���빴ѡ����д���ݣ�");	
		return false;
	}
	if(ManaImprovementoth==-1){
		$.messager.alert("��ʾ:","������Ľ�����ѡ'����'������д���ݣ�");	
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
		$.messager.alert("��ʾ:","���¼����������Ĵ�ʩ��ʵЧ������ѡ'δ��ʵ'������д���ݣ�");	
		return false;
	}
	
	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//�������������  ���ܻ�̶�������ʹ���г��ֹ���
	if($("input[type=checkbox][id='POMatFactor-94348']").is(':checked')){
		$("input[type=checkbox][id^='POMatFactor-94348-']").attr("disabled",false);

	}else{
		$("input[name$='.94356'][class='lable-input']").val("");
		$("input[name$='.94356'][class='lable-input']").hide();
		$("input[type=checkbox][id^='POMatFactor-94348-']").removeAttr("checked");
		$("input[type=checkbox][id^='POMatFactor-94348-']").attr("disabled",true);
		$("input[type=checkbox][id^='POMatFactor-94348-']").nextAll(".lable-input").hide();
	}	
	//�������������   ȱ����Ӧ�Ĺ̶���
	if($("input[type=checkbox][id='POMatFactor-94349']").is(':checked')){
		$("input[type=checkbox][id^='POMatFactor-94349-']").attr("disabled",false);
	}else{
		$("input[name$='.94359'][class='lable-input']").val("");
		$("input[name$='.94359'][class='lable-input']").hide();
		$("input[type=checkbox][id^='POMatFactor-94349-']").removeAttr("checked");
		$("input[type=checkbox][id^='POMatFactor-94349-']").attr("disabled",true);
		$("input[type=checkbox][id^='POMatFactor-94349-']").nextAll(".lable-input").hide();
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
	   title:'������Ա��Ϣ',
	   collapsible:true,
	   border:false,
	   closed:"true",
	   modal:true,
	   width:500,
	   height:400
	 }); 
    $('#staffwin').window('open');
    $("#UserNames").val("");
    $('#MonAdd').hide();// ��ӳ�����Ա��ť����
    InitStaffGrid() ;      
}

//��ʼ��������Ա�б�
function InitStaffGrid()
{
	//����columns
	var columns=[[
	     {field:"ck",checkbox:'true',width:40},
		 {field:'userCode',title:'�û�Code',width:100},
		 {field:'userName',title:'�û�����',width:100}
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
		 },	
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
		inputvalue="���Ĵ�ʩ��"+inputvalue;
	}
	return inputvalue;
	
}
