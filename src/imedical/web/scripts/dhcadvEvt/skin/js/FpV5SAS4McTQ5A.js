/// Description: ѹ�����浥
/// Creator: congyue
/// CreateDate: 2017-12-16
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	if ((recordId=="")){
		var frm = dhcadvdhcsys_getmenuform();
		if (frm) {
			var papmi = frm.PatientID.value;		
	        var adm = frm.EpisodeID.value;
	        if ((papmi=="")||(papmi=="undefined")){
		        papmi="" ;
		    }
	        $.ajax({
			   	   type: "POST",
			       url: url,
			       async: false, //ͬ��
			       data: "action=getPatNo&patID="+papmi,
			       success: function(val){
				      	 papmi=val;
			       }
			    });	
		    EpisodeID=adm;
		    patientID=papmi;
	        InitPatInfo(papmi,adm);//��ȡ������Ϣ
		}
	}
	$('#OccuLoc').combobox({ 
		//url:'dhcapp.broker.csp?ClassName=web.DHCADVCOMMONPART&MethodName=QueryLocDescCombo',
		mode:'remote'  //,  //���������������
	});
	$("#SaveBut").on("click",function(){
		SaveDrugErrReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveDrugErrReport(1);
	})
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			//InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio(id);
		});
	});
	
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	InitDrugErrReport(recordId);//����ҳ����Ϣ
	
});
//���ر�����Ϣ
function InitDrugErrReport(recordId)
{
	if((recordId=="")||(recordId==undefined)){
		
		$('#OccuLoc').combobox('setValue',LgCtLocDesc);  //��������
		$('#RepHospType').val(LgHospDesc); //���浥λ
		
		$('#RepUserName').val(LgUserName); //�������Ϊ��¼��
		$('#ReportDate').datebox("setValue",RepDate);   //��������
		$('#HospPhone').val("64456715");//��ϵ�绰
	
	}else{
		
	} 
}

function SaveDrugErrReport(flag)
{
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	
	//alert(ss);
	var AuditList=""
	
	if(flag==1){
		var AuditList=LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
		//AuditList=359+"^"+6+"^"+134+"^"+adrNextLoc+"^"+adrLocAdvice+"^"+adrReceive;
	}
	//���ݱ���/�ύ
	var mesageShow=""
	if(flag==0){
		mesageShow="����"
	}
	if(flag==1){		
		mesageShow="�ύ"		
	}
	SaveReport(flag)
}
//���ر�������Ϣ
function InitPatInfo(patientID,EpisodeID)
{
	if((patientID=="")&&(EpisodeID=="")){return;}
	$.ajax({
		type: "POST",
		url: url,
		data: "action=getRepPatInfo&PatNo="+patientID+"&EpisodeID="+EpisodeID,
		success: function(val){
	    	var tmp=val.split("^");
			//������Ϣ
			$('#DisMedThingPatName').val(tmp[1]); //��������
			$('#DisMedThingPatName').attr("disabled","readonly");
			$('#PatSexinput').val(tmp[3]);  //�Ա�
			$('#PatSexinput').attr("disabled","readonly");
			$('#PatAge').val(tmp[4]);  //����
			$('#PatAge').attr("disabled","readonly");
			$('#PatMedicalNo').val(tmp[5]); //������
			$('#PatMedicalNo').attr("disabled","readonly");
			$('#PatAdmDate').datebox({disabled:'true'});
			$('#PatAdmDate').datebox("setValue",tmp[8]);  //��������
           	$('#PatDiag').val(tmp[10]);  //���
			$('#PatDiag').attr("disabled","readonly");
           	$("#from").form('validate')
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
	var UlcerRiskpointtaboth=0;
	$("input[type=radio][id^='UseUlcerRiskpointtab-94932']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93878']").val()=="")){
				UlcerRiskpointtaboth=-1;
			}
		}
	})
	if(UlcerRiskpointtaboth==-1){
		$.messager.alert("��ʾ:","��ʹ��ѹ���������ֱ���ѡ'����'������д���ݣ�");	
		return false;
	}
	
	//ѹ������ԭ�� ��������
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94948']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93950'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'��������  ����'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ�� ��������
	var IllnesReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94949']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93956'][class='lable-input']").val()=="")){
				IllnesReasonoth=-1;
			}
		}
	})
	if(IllnesReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'��������  ����'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ�� ������Ա����
	var NurReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94950']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93966'][class='lable-input']").val()=="")){
				NurReasonoth=-1;
			}
		}
	})
	if(NurReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'������Ա����  ����'������д���ݣ�");	
		return false;
	}
	//ѹ������ԭ�� ��������
	var PatReasonoth=0;
	$("input[type=checkbox][id^='UlcerOccurReason-94951']").each(function(){
		if($(this).is(':checked')){
			if ((this.value=="title")&&($("input[name$='.93969'][class='lable-input']").val()=="")){
				PatReasonoth=-1;
			}
		}
	})
	if(PatReasonoth==-1){
		$.messager.alert("��ʾ:","��ѹ������ԭ�򡿹�ѡ'��������  ����'������д���ݣ�");	
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
		$.messager.alert("��ʾ:","���Ѳ�ȡ�����ʩ(�ɶ�ѡ)����ѡ'��������  ����'������д���ݣ�");	
		return false;
	}

	return true;
}
//ҳ���ʼ����checkbox,radio������Ԫ�ز�������д
function InitCheckRadio(){
	// 
	//var a=$('#UlcerPart').datagrid('getRows');
	//alert(a);
	//��ҩʱ�����
	if($("input[type=radio][id^='labelUlcerPart-95158-95163-95171.']").is(':checked')){
		//var id=inputid.split(".")[1];
		//var id=this.split(".")[1];
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").attr("disabled",false);//ҽ����ҩʱ��
	}else{
		var id=inputid.split(".")[1];
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").removeAttr("checked");
		$("input[type=radio][id^='labelUlcerPart-95158-95163-95171-9'][id$=.'"+id+"']").attr("disabled",true);
	}	
	
}
//ʱ�� ����У��
function CheckTimeornum(){
	
	//��������У��
	//��˹�������
	$('#RepUserWorkYears').live("keyup",function(){
		this.value=this.value.replace(/\D/g,'');
	})
}
function add_event(){
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	
	CheckTimeornum();  //ʱ��У��
	InitCheckRadio();//���ؽ���checkboxradio�ڸ�Ԫ��û�й�ѡ������£���Ԫ�ز��ɹ�ѡ����д
	
	
}
