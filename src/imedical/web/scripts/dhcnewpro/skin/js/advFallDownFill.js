/// Description: ����(׹��)�¼����浥
/// Creator: congyue
/// CreateDate: 2017-12-18
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
	        var adm = frm.EpisodeID.value;
		    EpisodeID=adm;
	        InitPatInfo(adm);//��ȡ������Ϣ
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote',  //,  //���������������
		onShowPanel:function(){ 
			$('#OccuLoc').combobox('reload','dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo&hospId='+LgHospID+'')
		}
	});
	
	/*//����1
	$('#DeptLocOne').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocCombox',
		mode:'remote',  //���������������
		onSelect: function(rec){  
           var LocOneDr=rec.value; 
			ComboboxLocTwo(LocOneDr);        
	  }
	});*/
	$("#SaveBut").on("click",function(){
		SaveFallDownReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveFallDownReport(1);
	})
	//��ѡ��ť�¼�
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
	});
	//��Ժʱ�����
	$('#PatAdmDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//�������ڿ���
	$('#ReportDate').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	//�������ڿ���
	$('#HappenTime').datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});

	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	PatMedNoEnter();//�����Żس��¼�
	PatIDEnter();//�ǼǺŻس��¼�
	InitFallDownReport(recordId);//����ҳ����Ϣ
	
});
//���ر�����Ϣ
function InitFallDownReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //��������
		$('#RepHospType').val(LgHospDesc); //���浥λ
		$('#RepHospType').attr("readonly","readonly"); //���浥λ
		$('#RepUserName').val(LgUserName); //�������Ϊ��¼��
		$('#RepUserName').attr("readonly","readonly");//�������Ϊ��¼��
		if(LgGroupDesc=="����"){
			$('#ReportDate').datebox({disabled:false});//��������
		}else{
			$('#ReportDate').datebox({disabled:'true'});//��������
		}
		$('#ReportDate').datebox("setValue",RepDate);   //��������
		//$('#HospPhone').val("64456715");//��ϵ�绰
		//$('#HospPhone').attr("readonly","readonly"); //��ϵ�绰
		//������Ϣ	 
		$('#DisMedThingPatName').attr("readonly","readonly");//��������	
	}else{
		//������Ϣ	 
		$('#DisMedThingPatName').attr("readonly","readonly");//��������
		$('#PatSexinput').attr("readonly","readonly"); //�Ա�
		$('#PatAge').attr("readonly","readonly"); //����
		//$('#PatMedicalNo').attr("readonly","readonly"); //������
		$('#PatAdmDate').datebox({disabled:'true'});//��Ժ����     
		$('#PatDiag').attr("readonly","readonly");//���
		var date=$('#ReportDate').datebox("getValue");//��������
		if(LgGroupDesc=="����"){
			$('#ReportDate').datebox({disabled:false});//��������
			$('#ReportDate').datebox("setValue",date);   //��������
		}else{
			$('#ReportDate').datebox({disabled:'true'});//��������
			$('#ReportDate').datebox("setValue",date);   //��������
		}
		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //�����չ�����
    	$('#RepHospType').attr("readonly","readonly"); //���浥λ
    	$('#RepUserName').attr("readonly","readonly");//�������Ϊ��¼��
    	//$('#HospPhone').attr("readonly","readonly"); //��ϵ�绰
    	$("#from").form('validate');			
	} 
}
//���汣��
function SaveFallDownReport(flag)
{
	if($('#DisMedThingPatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	}
	var falltype=0;
	$("input[type=radio][id^='FallDownType-']").each(function(){
		if($(this).is(':checked')){
				falltype=this.value;
		}
	})
	if(falltype==""){
		$.messager.alert("��ʾ:","���������͡�����Ϊ�գ�");	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReport(flag);
}
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+""+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//������Ϣ
			$('#PatID').val(tmp[0]); //�ǼǺ�
			$('#DisMedThingPatName').val(tmp[1]); //��������
			$('#DisMedThingPatName').attr("readonly","readonly");
			$('#PatSexinput').val(tmp[3]);  //�Ա�
			$('#PatSexinput').attr("readonly","readonly");
			$('#PatAge').val(tmp[4]);  //����
			$('#PatAge').attr("readonly","readonly");
			$('#PatMedicalNo').val(tmp[5]); //������
			$('#PatMedicalNo').attr("readonly","readonly");
			if(tmp[24]!=""){
	      		$('#PatAdmDate').datebox({disabled:'true'});	
	      	}
			$('#PatAdmDate').datebox("setValue",tmp[24]);  //��Ժ����
      		$('#PatDiag').val(tmp[10]);  //���
      		if(tmp[10]!=""){
	      		$('#PatDiag').attr("readonly","readonly");	
	      	}
	      	$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //�����չ�����
	      	if((tmp[22]=="סԺ")||(tmp[22]=="����")||(tmp[22]=="����")||(tmp[22]=="�ռ䲡��")||(tmp[22]=="����")){
		      	$("input[type=radio][value='"+tmp[22]+"']").click(); //������Դ
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",true);  //�����չ�����
	      	}else{
	      		$("input[type=radio][id^='PatOrigin-label']").attr("disabled",false);  //�����չ�����
		    }
	      	$("input[type=radio][value='"+tmp[23]+"']").click(); //������
      		$("#from").form('validate');
      		InitCheckRadio();
		}
	})
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	//������Դ
	var PatOriginoth=0;
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94109']").val()=="")){
				PatOriginoth=-1;
			}
		}
	})
	if(PatOriginoth==-1){
		$.messager.alert("��ʾ:","��������Դ����ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//�����ص�
	var HappenPlaceoth=0;
	$("input[type=radio][id^='HappenPlace-label']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94076']").val()=="")){
				HappenPlaceoth=-1;
			}
		}
	})
	if(HappenPlaceoth==-1){
		$.messager.alert("��ʾ:","�������ص㡿��ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//����/׹����ָ����������κβ�λ��������˫�ţ����ⴥ�����棩ʱ���ߵ�״̬
	var Rankoth=0;
	$("input[type=radio][id^='FDPatState']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93720']").val()=="")){
				Rankoth=-1;
			}
		}
	})
	if(Rankoth==-1){
		$.messager.alert("��ʾ:","������/׹����ָ����������κβ�λ��������˫�ţ����ⴥ�����棩ʱ���ߵ�״̬����ѡ'����'������д���ݣ�");	
		return false;
	}

	//����ԭ��(�ɶ�ѡ)  �������� 
	var PatReasonoth=0,PatReason="",PatReasonList="";
	$("input[type=checkbox][id='OccurReason-95068']").each(function(){
		if ($(this).is(':checked')){
			PatReason=this.value;
		}
	})
	if(PatReason=="��������"){
		$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatReasonList=this.value
			}
		})
		if (PatReasonList==""){
			$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'��������'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95068-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93730'][class='lable-input']").val()=="")){
				PatReasonoth=-1; 
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'��������  ����'������д���ݣ�");	
		return false;
	}

	//����ԭ��(�ɶ�ѡ)  ҩ������  
	var DrugReasonoth=0,DrugReason="",DrugReasonList="";
	$("input[type=checkbox][id='OccurReason-95069']").each(function(){
		if ($(this).is(':checked')){
			DrugReason=this.value;
		}
	})
	if(DrugReason=="ҩ������"){
		$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugReasonList=this.value
			}
		})
		if (DrugReasonList==""){
			$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'ҩ������'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95069-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93739'][class='lable-input']").val()=="")){
				DrugReasonoth=-1; 
			}
		}
	})
	if(DrugReasonoth==-1){
		$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'ҩ������  ����'������д���ݣ�");	
		return false;
	}

	//����ԭ��(�ɶ�ѡ)  ��������  
	var ManageReasonoth=0,ManageReason="",ManageReasonList="";
	$("input[type=checkbox][id='OccurReason-95070']").each(function(){
		if ($(this).is(':checked')){
			ManageReason=this.value;
		}
	})
	if(ManageReason=="��������"){
		$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				ManageReasonList=this.value
			}
		})
		if (ManageReasonList==""){
			$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'��������'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='OccurReason-95070-']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93746'][class='lable-input']").val()=="")){
				ManageReasonoth=-1; 
			}
		}
	})
	if(ManageReasonoth==-1){
		$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'��������  ����'������д���ݣ�");	
		return false;
	}
	//����ԭ��(�ɶ�ѡ)  ��������  
	var OccurReasonoth=0;
	$("input[type=checkbox][id^='OccurReason-95071']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.93747'][class='lable-input']").val()=="")){
				OccurReasonoth=-1; 
			}
		}
	})
	if(OccurReasonoth==-1){
		$.messager.alert("��ʾ:","������ԭ��(�ɶ�ѡ)����ѡ'��������'������д���ݣ�");	
		return false;
	}
	
	//������
	var DiscoverManoth=0;
	$("input[type=radio][id^='DiscoverMan']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.94080']").val()=="")){
				DiscoverManoth=-1;
			}
		}
	})
	if(DiscoverManoth==-1){
		$.messager.alert("��ʾ:","�������ˡ���ѡ'������Ա'������д���ݣ�");	
		return false;
	}
	
	//����/׹���¼���ɵĽ��   ����סԺ����
	var FDResult="",FDResultList="";
	$("input[type=checkbox][id='FDResult-95132']").each(function(){
		if ($(this).is(':checked')){
			FDResult=this.value;
		}
	})
	if(FDResult=="����סԺ����"){
		$("input[type=radio][id^='FDResult-95132-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				FDResultList=this.value
			}
		})
		if (FDResultList==""){
			$.messager.alert("��ʾ:","������/׹���¼���ɵĽ������ѡ'����סԺ����'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	//����/׹���¼��� ��������  
	var FDResultoth=0;
	$("input[type=checkbox][id^='FDResult']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94245'][class='lable-input']").val()=="")){
				FDResultoth=-1; 
			}
		}
	})
	if(FDResultoth==-1){
		$.messager.alert("��ʾ:","������/׹���¼���ɵĽ������ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//���������¼�������
	var PatEventProoth=0,PatEventPro="",PatEventProList="";
	$("input[type=checkbox][id='PatEventProcess-95021']").each(function(){
		if ($(this).is(':checked')){
			PatEventPro=this.value;
		}
	})
	if(PatEventPro=="����֪ͨ"){
		$("input[type=checkbox][id^='PatEventProcess-95021']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				PatEventProList=this.value
			}
		})
		if (PatEventProList==""){
			$.messager.alert("��ʾ:","�����������¼�����������ѡ'����֪ͨ'���빴ѡ��Ӧ���ݣ�");	
			return false;
		}
	}
	
	$("input[type=checkbox][id^='PatEventProcess-95033']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94100'][class='lable-input']").val()=="")){
				PatEventProoth=-1; 
			}
		}
	})
	$("input[type=checkbox][id^='PatEventProcess-95034']").each(function(){
		if ($(this).is(':checked')){
			if((this.value=="title")&&($("input[name$='.94101'][class='lable-input']").val()=="")){
				PatEventProoth=-2; 
			}
		}
	})
	if(PatEventProoth==-1){
		$.messager.alert("��ʾ:","�����������¼�����������ѡ'ҽ�ƻ����ʩ'������д���ݣ�");	
		return false;
	}
	if(PatEventProoth==-2){
		$.messager.alert("��ʾ:","�����������¼�����������ѡ'����'������д���ݣ�");	
		return false;
	}
	
	return true;
}


//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	//������Դ
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if (id=="PatOrigin-label-94337"){
				$('#PatAdmADLScore').val(""); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#D4D0C8");
				$('#PatAdmADLScore').attr("readonly","readonly"); //��ԺʱADL�÷�
				$("label[data-parref='PatSelfCareAbility']").css("color","#D4D0C8")
				$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");  //�����չ�����
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",true);  //�����չ�����
			}else{
				$('#PatAdmADLScore').attr("readonly",false); //��ԺʱADL�÷�
				$('#PatAdmADLScore').css("background-color","#fff");
				$("label[data-parref='PatSelfCareAbility']").css("color","#000")
				$("input[type=radio][id^='PatSelfCareAbility-']").attr("disabled",false);  //�����չ�����
			}
		}
	})
	
	//����ԭ��(�ɶ�ѡ)  ��������
	if($('#OccurReason-95068').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95068-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95068-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95068-']").attr("disabled",true);
		$("input[name$='.93730'][class='lable-input']").val("");  //�����������
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}
	
	//����ԭ��(�ɶ�ѡ)  ҩ������
	if($('#OccurReason-95069').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95069-']").attr("disabled",false);
		$("input[name$='.93739'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95069-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95069-']").attr("disabled",true);
		$("input[name$='.93739'][class='lable-input']").val("");  //�����������
		$("input[name$='.93739'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93739'][class='lable-input']").hide();  
	}
	
	//����ԭ��(�ɶ�ѡ)  ��������
	if($('#OccurReason-95070').is(':checked')){
		$("input[type=checkbox][id^='OccurReason-95070-']").attr("disabled",false);
		$("input[name$='.93746'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[type=checkbox][id^='OccurReason-95070-']").removeAttr("checked");
		$("input[type=checkbox][id^='OccurReason-95070-']").attr("disabled",true);
		$("input[name$='.93746'][class='lable-input']").val("");  //�����������
		$("input[name$='.93746'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93746'][class='lable-input']").hide();  
	}
	
	//����/׹���¼���ɵĽ��   ����סԺ����
	if($('#FDResult-95132').is(':checked')){
		$("input[type=radio][id^='FDResult-95132-']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='FDResult-95132-']").removeAttr("checked");
		$("input[type=radio][id^='FDResult-95132-']").attr("disabled",true);
	}
	
	//���������¼�������   ����֪ͨ
	if($('#PatEventProcess-95021').is(':checked')){
		$("input[type=checkbox][id^='PatEventProcess-95021-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='PatEventProcess-95021-']").removeAttr("checked");
		$("input[type=checkbox][id^='PatEventProcess-95021-']").attr("disabled",true);
	}

}
//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//����ʱ��
	$('#OccurTime').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#OccurTime').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#OccurTime').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��ҩʱ����� ҽ����ҩʱ��
	$('#DrugUseErrType-94617-94204').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94204').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94204').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��ҩʱ����� �����ҩʱ��
	$('#DrugUseErrType-94617-94205').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94617-94205').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94617-94205').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	//��©��ҩ ҽ����ҩʱ��
	$('#DrugUseErrType-94619-94213').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$('#DrugUseErrType-94619-94213').live("blur",function(){
		this.value=CheckEmPcsTime(this.id);
	})
	$('#DrugUseErrType-94619-94213').live("focus",function(){
		this.value=SetEmPcsTime(this.id);
	})
	
	//��������У��
	//��©��ҩ ��©����
	$('#DrugUseErrType-94619-94212').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//�����˹�������(��)
	$('#DrugUsePartyWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��������(��)
	$('#WLManWorkLife').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��˹�������
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��ԺʱADL�÷�
	$('#PatAdmADLScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if((this.value>100)||(this.value=="")){
			$.messager.alert("��ʾ:","����ԺʱADL�÷֡�����1-100��������");	
			$("input[type=radio][id^='PatSelfCareAbility-']").removeAttr("checked");
			this.value="";
		}else if((this.value>40)||(this.value<100)){
			$("input[type=radio][id^='PatSelfCareAbility-94346']").click();	
		}
		if(((this.value>0)||(this.value==0))&&((this.value<40)||(this.value==40))&&(this.value!="")){
			$("input[type=radio][id^='PatSelfCareAbility-94347']").click();	
		}
		if(this.value==100){
			$("input[type=radio][id^='PatSelfCareAbility-94345']").click();	
		}
	})
}
//�ǼǺ��Զ���0
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
}
//���ݿ���1��ѯ����2   2018-01-15
function ComboboxLocTwo(LocOne){
   $('#DeptLocTwo').combobox({ 
		url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=GetAutLocItmCombox'+'&AutLParentDesc='+encodeURI(LocOne),
		mode:'remote'  //,  //���������������
	});   

}
//�ǼǺŻس��¼�
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
	
}
