/// Description: ѹ�����浥
/// Creator: congyue
/// CreateDate: 2017-12-19
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
		SaveUlcerReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveUlcerReport(1);
	})
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
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
	$("input[id^='UlcerPart-95158-95162-95192']").datebox().datebox('calendar').calendar({
		validator: function(date){
			var now = new Date();
			return date<=now;
		}
	});
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	//��λ 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
		}
	})
	
	PatMedNoEnter();//�����Żس��¼�
	PatIDEnter();//�ǼǺŻس��¼�
	InitUlcerReport(recordId);//����ҳ����Ϣ
});
//���ر�����Ϣ
function InitUlcerReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //��������
		$('#RepHospType').val(LgHospDesc); //���浥λ
		$('#RepHospType').attr("readonly","readonly"); //���浥λ
		$('#RepUserName').val(LgUserName); //�������Ϊ��¼��
		$('#RepUserName').attr("readonly","readonly");//�������Ϊ��¼
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
		$('#PatMedicalNo').attr("readonly","readonly"); //������
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
function SaveUlcerReport(flag)
{
	if($('#DisMedThingPatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!(checkRequired()&&checkother())){
		return;
	}
	var msg=checkTableRequired();
	if(msg!=""){
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
	//ʹ��ѹ���������ֱ�
	var Riskpointtaboth=0;
	$("input[type=radio][id^='UseUlcerRiskpointtab']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93878']").val()=="")){
				Riskpointtaboth=-1;
			}
		}
	})
	if(Riskpointtaboth==-1){
		$.messager.alert("��ʾ:","��ʹ��ѹ���������ֱ���ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//ѹ������ԭ��  ��������
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94948-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93950'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'������������'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ��  ��������
	var IllnessReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94949-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93956'][class='lable-input']").val()=="")){
				IllnessReasonoth=-1;
			}
		}
	})
	if(IllnessReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'������������'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ��  ������Ա����
	var NurReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94950-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93966'][class='lable-input']").val()=="")){
				NurReasonoth=-1;
			}
		}
	})
	if(NurReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'������Ա��������'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ��  ��������
	var OthReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94951-']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93969'][class='lable-input']").val()=="")){
				OthReasonoth=-1;
			}
		}
	})
	if(OthReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'��������'������д���ݣ�");	
		return false;
	}
	//�Ѳ�ȡ�����ʩ(�ɶ�ѡ)
	var AdoptNursMeasureoth=0;
	$("input[type=checkbox][id^='AdoptNursMeasure']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93979'][class='lable-input']").val()=="")){
				AdoptNursMeasureoth=-1;
			}
		}
	})
	if(AdoptNursMeasureoth==-1){
		$.messager.alert("��ʾ:","���Ѳ�ȡ�����ʩ(�ɶ�ѡ)����ѡ'����'������д���ݣ�");	
		return false;
	}
	var UlcerPartDate="",UlcerDateErr="";
	//��������
	 $("input[id^='UlcerPart-95158-95162-95192']").each(function(){
		if((this.id.split("-").length==4)){
			UlcerPartDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (UlcerPartDate!=""){
				UlcerDateErr=1;
			}else if(!compareSelTimeAndCurTime(UlcerPartDate)){
				UlcerDateErr=-2;
				return ;	
			} 
		}
	}) 
	if ((UlcerDateErr!="1")&&(UlcerDateErr!="-2")){
		$.messager.alert("��ʾ:","��ѹ����λ�������ڡ�δ��д������д��Ӧ���ݣ�");	
		return false;
	}
	if (UlcerDateErr=="-2"){
		$.messager.alert("��ʾ:","��ѹ����λ�������ڡ����ܴ��ڵ�ǰ���ڣ�����д��Ӧ���ݣ�");	
		return false;
	}
	//ѹ����λ  ��Դ Ժ����� labelUlcerPart-95158-95163-95170
	var PatOrign="",PatOrignList="",OrignErr="";
	 $("input[type=radio][id^='UlcerPart-95158-95163-95170.']").each(function(){
		if ($(this).is(':checked')){	
			PatOrign=this.value;
		}
	});
		
	$("input[type=radio][id^='UlcerPart-95158-95163-']").each(function(){
		if ($(this).is(':checked')){
			if(this.id.split("-").length==4){
				var PatOrignList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				PatOrign=this.value;
				
				$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatOrignList=this.value
					}
				});
				if((radiorowid=="UlcerPart-95158-95163-95171")&&(PatOrignList=="")){
					$.messager.alert("��ʾ:","��ѹ����Դ����ѡ��Ժ����롿���빴ѡԺ����Ӧ���ݣ�");	
					OrignErr=-1;
					return false;
				}		
				
			}
		}
	});
	if (PatOrign==""){
		$.messager.alert("��ʾ:","��ѹ����Դ��δ��ѡ���빴ѡ��Ӧ���ݣ�");	
		OrignErr=-1;
		return false;
	}
	if(OrignErr=="-1"){
		return false;
	}
	//ѹ����λ ��λ   
	var PatReason="",PartErr=0,radiorownum="";
	$("input[type=radio][id^='UlcerPart-95158-95166-']").each(function(){
		if(this.id.split("-").length==4){
			var PatReasonList="";
			if ($(this).is(':checked')){
				var radiorowid=this.id.split(".")[0];
				radiorownum=this.id.split(".")[1];
				PatReason=this.value;
				$("input[type=checkbox][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
					if (($(this).is(':checked'))&&(this.value!="")){
						PatReasonList=this.value
					}
				});
				if((PatReason=="title")&&($("input[name$='.93932."+radiorownum+"'][class='lable-input']").val()=="")){ //UlcerPart-95158-95166-95182
					$.messager.alert("��ʾ:","��ѹ����λ����ѡ����������д��Ӧ���ݣ�");	
					PartErr=-1;
					return false;
				}		
				if ((PatReason!="��")&&(PatReason!="��β��")&&(PatReason!="title")&&(PatReasonList=="")){
					$.messager.alert("��ʾ:","��ѹ����λ����ѡ'"+PatReason+"'���빴ѡ��Ӧ���ݣ�");	
					PartErr=-1;
					return false;
				}
				
			 }
		}
	});
	if(PartErr=="-1"){
		return false;
	}
	if(PatReason==""){
		$.messager.alert("��ʾ:","��ѹ����λ��δ��ѡ���ݣ��빴ѡ��Ӧ���ݣ�");	
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
	//ѹ����λ  ��Դ
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",false);

	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-']").attr("disabled",true);
	}	
	//����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95173.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95173-']").attr("disabled",true);
	}
	//���β�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95174.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95174-']").attr("disabled",true);
	}	
	//�ⲿ
	if($("input[type=radio][id^='UlcerPart-95158-95166-95175.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95175-']").attr("disabled",true);
	}
	 //��ǰ�ϼ�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95176.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95176-']").attr("disabled",true);
	}
	//�Ų�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95177.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95177-']").attr("disabled",true);
	}
	//ϥ��
	if($("input[type=radio][id^='UlcerPart-95158-95166-95179.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95179-']").attr("disabled",true);
	}
	//�ײ�
	if($("input[type=radio][id^='UlcerPart-95158-95166-95180.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95180-']").attr("disabled",true);
	}
	//�����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95181.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",true);
	}
	//����
	if($("input[type=radio][id^='UlcerPart-95158-95166-95182.']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-95181-']").attr("disabled",false);
		$("input[name$='.93730'][class='lable-input']").attr("readonly",false); 
	}else{
		$("input[name$='.93730'][class='lable-input']").val("");  //�����������
		$("input[name$='.93730'][class='lable-input']").attr("readonly","readonly"); 
		$("input[name$='.93730'][class='lable-input']").hide();  
	}		
}
//��ѡ radio ��Ԫ�ؿ��Թ�ѡ��ȡ����ѡʱ����Ԫ��ȡ����ѡ�Ҳ����Թ�ѡ
function InitRadio(id){
	//��Դ  Ժ����� 
	var radiorowid=id.split(".")[0];
	var radiorownum=id.split(".")[1];
	//ѹ����λ  ��Դ
	if($("input[type=radio][id^='UlcerPart-95158-95163-95171.'][id$='"+radiorownum+"']").is(':checked')){
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",false);
	}else{
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").removeAttr("checked");
		$("input[type=radio][id^='UlcerPart-95158-95163-95171-'][id$='"+radiorownum+"']").attr("disabled",true);
	}
	 //��λ 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	if(checkrowid.indexOf("95166")>0){
	if($("input[type=radio][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").is(':checked')){
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
		$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='UlcerPart-95158-95166-'][id$='"+checkrownum+"']").removeAttr("checked");
		if (checkrowid!=="UlcerPart-95158-95166-95182"){
			$("input[name$='.93932."+checkrownum+"'][class='lable-input']").val("");  //�����������
			$("input[name$='.93932."+checkrownum+"'][class='lable-input']").hide();  
		}
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
		$("input[type=checkbox][id^='"+checkrowid+"'][id$='."+checkrownum+"']").attr("disabled",false);
		
	}else{
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").removeAttr("checked");
		$("input[type=checkbox][id^='UlcerPart-95158-95166-'][id$='."+checkrownum+"']").attr("disabled",true);
	} 	 
	}
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
}
function InitCheck(id){
	/* //��λ 
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	// 
	if($("input[type=radio][id^='"+checkrowid+".'][id$='"+checkrownum+"']").is(':checked')){
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").attr("disabled",false);
	}else{
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").removeAttr("checked");
		$("input[type=checkbox][id^='"+checkrowid+"-'][id$='"+checkrownum+"']").attr("disabled",true);
	}	 */
	
}

//ʱ�� ����У��
function CheckTimeornum(){
	//ʱ������У��
	//ѹ����� UlcerPart-95158-95189-94247
	//var regu="^([0-9])[0-9]*(\\.\\w*)?$";
	//var re=new RegExp(regu);
	$("input[id^='UlcerPart-95158-95189-94247']").live("keyup",function(){
		/* if(re.test(this.value)){
			this.value=this.value
		}else{
			this.value=""
		} */
		this.value=this.value.replace(/\D/g,'');
	})
	$("input[id^='UlcerPart-95158-95189-94249']").live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	$("input[id^='UlcerPart-95158-95189-94251']").live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
	//��������У��  
	//��˹�������(��)
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
	
	//��Ժѹ����������
	$('#HospUlcerRiskScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if(this.value>100){
			$.messager.alert("��ʾ:","����Ժѹ���������֡����벻�ܴ���100��");	
			this.value="";
		}
	})
	//����ѹ��ʱ��������
	$('#OccurUlcerRiskScore').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
		if(this.value>100){
			$.messager.alert("��ʾ:","������ѹ��ʱ�������֡����벻�ܴ���100��");	
			this.value="";
		}
	})

}

function add_event(){
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
		});
	});
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheck(this.id);
		});
	});
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	//��������
	 $("input[id^='UlcerPart-95158-95162-95192']").each(function(){
		if((this.id.split("-").length==4)){
			var UlcerPartDate=$("input[id^='"+this.id+"']").datebox("getValue");
			if (UlcerPartDate!=""){
				$("input[id^='UlcerPart-95158-95162-95192.']").datebox("setValue",UlcerPartDate);
			}
		}
	}) 
	//��Դ  Ժ����� 
	var orign="";
	$("input[type=radio][id^='UlcerPart-95158-95163']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			orign=this.value;
			var list=$("input[type=radio][id^='UlcerPart-95158-95163-95170."+checkrownum+"']:checked").val();
			if((this.id.split("-").length==4)){
				$("input[type=radio][id^='"+checkrowid+".']").click();		
			}else if(this.id.split("-").length==5){
				$("input[type=radio][id^='"+checkrowid+"']").click();
			}
		}
	})
	
	//��λ 
	$("input[type=radio][id^='UlcerPart-95158-95166']").each(function(){
		if ($(this).is(':checked')){
			var checkrowid=this.id.split(".")[0];
			var checkrownum=this.id.split(".")[1];
			$("input:not([id$='"+checkrownum+"'])input[type=checkbox][id^='"+checkrowid+"']").attr("disabled",true);
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

//���table�еı���
//�����д�˳���ߣ��������Ϣ��Ϊ���������ζ
function checkTableRequired(){
	var errMsg=""
	$("#UlcerPart").next().find("tbody tr").each(function(i){
		var flag=0
		$(this).children('td').eq(0).find("input").each(function(){
			if($(this).val()!=""){
				flag=1;
			}	
		})
		if(flag==1){
			var rowMsg=""
			//��Դ
			var str=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(1));
			if(str.length==0){
				rowMsg=rowMsg+"��Դ,"
			}
			//��λ
			var str1=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(2));
			if(str1.length==0){
				rowMsg=rowMsg+"��λ,"
			}
			//ѹ������
			var str2=jQuery("input[name][type=radio]:checked", $(this).children('td').eq(3));
			if(str2.length==0){
				rowMsg=rowMsg+"ѹ������,"
			}
			//���
			var str3=$(this).children('td').eq(4).find("input").val()
			if(str3.length==0){
				rowMsg=rowMsg+"���,"
			}
			if(rowMsg!=""){
				errMsg=errMsg+"\n"+rowMsg+"����Ϊ��."
			}	
		}
	
	})
	if(errMsg!=""){
		$("html,body").stop(true);$("html,body").animate({scrollTop: $("#UlcerPart").offset().top}, 1000);
		$.messager.alert("��ʾ:",errMsg);
	}
	return errMsg;
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
