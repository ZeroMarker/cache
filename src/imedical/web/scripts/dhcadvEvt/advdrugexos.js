///Description: ҩ������ר��浥
///Creator: lp
///Creatdate: 18-5-18
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitCheckRadio();			//���ؽ���checkbox radio Ԫ�ع�ѡ����
	InitButton();				// ��ʼ����ť
	CheckTimeorNum();  			// ����,ʱ�� ����У��
	ReportControl();			// ������ 
	InitReport(recordId);//����ҳ����Ϣ
	//InitLayoutHtml(); //��ʼ��ҳ�沼�� 18-1-20
})
function InitButton(){
	// ����
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})	
	if (RepStaus!=""){
		$("#PatOutcomBut").show(); //��ʾת�鰴ť		
		if(winflag==2){
			if(LocHeadNurEvaFlag=="1"){
				$("#LocHeadNurEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
			if(NurDepEvaFlag=="1"){
				$("#NurDepEvaBut").show(); // ����������ʾ���۰�ť 2019-07-25 cy
			}
		} 
	}
	var LocHeadNurEvaId=GetAssessRecordID("LocHeaNurEvaluate"); 
	if(LocHeadNurEvaId!=""){
		$("#LocHeadNurEvaBut").show();
	}
   	$("#LocHeadNurEvaBut").on("click",function(){ 
		showAssessmentWin("LocHeaNurEvaluate",LocHeadNurEvaId);
	})
	// ��������
	var NurDepEvaId=GetAssessRecordID("NurDepEvaluate");  
	if(NurDepEvaId!=""){
		$("#NurDepEvaBut").show();
	}
	$("#NurDepEvaBut").on("click",function(){ 
		showAssessmentWin("NurDepEvaluate",NurDepEvaId);
	})
	/// ת�����
	$("#PatOutcomBut").on("click",function(){ 
		showPatOutcomWin("PatOutcomform");
	})
}
// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			//setCheckBoxRelation(this.id);
			InitCheckRadio();
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitRadio(this.id);
			InitCheckRadio();
		});
	});
	
	
	
}
//��ѡ radio ��Ԫ�ؿ��Թ�ѡ��ȡ����ѡʱ����Ԫ��ȡ����ѡ�Ҳ����Թ�ѡ
function InitRadio(id){

	if(id.indexOf("PatOrigin-label")>=0){
		if ((id!="PatOrigin-label-94335")){
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
}
//����ҳ��Ԫ���¼�
function InitCheckRadio(){
	//������Դ
	$("input[type=radio][id^='PatOrigin-label']").each(function(){
		if ($(this).is(':checked')){
			var id=this.id;
			if ((id!="PatOrigin-label-94335")){
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
	
	//������
	if($('#DrugExosStimInt-846').is(':checked')){
		$('#DrugExosStimInt-846-851').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-846-851').attr('readonly','readonly');
		$('#DrugExosStimInt-846-851').val("");
	}
	//�̼���
	if($('#DrugExosStimInt-847').is(':checked')){
		$('#DrugExosStimInt-847-854').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-847-854').attr('readonly','readonly');
		$('#DrugExosStimInt-847-854').val("");		
	}
	//�Ƿ�����
	if($('#DrugExosStimInt-848').is(':checked')){
		$('#DrugExosStimInt-848-857').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-848-857').attr('readonly','readonly');
		$('#DrugExosStimInt-848-857').val("");		
	}
	//����
	if($('#DrugExosStimInt-849').is(':checked')){
		$('#DrugExosStimInt-849-860').attr('readonly',false);	
	}else{
		$('#DrugExosStimInt-849-860').attr('readonly','readonly');
		$('#DrugExosStimInt-849-860').val("");		
	}
	
	
	//����
	if($('#DrugExosPuncExos-882-884').is(':checked')){
		$('#DrugExosPuncExos-882-884-886').attr('disabled',false);	
		$('#DrugExosPuncExos-882-884-900').attr('disabled',false);
	}else{
		$('#DrugExosPuncExos-882-884-886').attr("disabled",true);
		$('#DrugExosPuncExos-882-884-900').attr("disabled",true);
		$('#DrugExosPuncExos-882-884-886').val("");
		$('#DrugExosPuncExos-882-884-900').val("");		
	}
	//��ʹ
	if($('#DrugExosPuncExos-905-907').is(':checked')){
		$('#DrugExosPuncExos-905-907-909').attr('disabled',false);	
	}else{
		$('#DrugExosPuncExos-905-907-909').attr('disabled',true);
		$('#DrugExosPuncExos-905-907-909').val("");			
	}
	//����
	if($('#DrugExosPuncExos-917-919').is(':checked')){
		$('#DrugExosPuncExos-917-919-921').attr('disabled',false);
		$('#DrugExosPuncExos-917-919-923').attr('disabled',false);
	}else{
		$('#DrugExosPuncExos-917-919-921').attr('disabled',true);	
		$('#DrugExosPuncExos-917-919-923').attr('disabled',true);
		$('#DrugExosPuncExos-917-919-921').val("");
		$('#DrugExosPuncExos-917-919-923').val("");		
	}
	//�����Ƿ��������Ƶ��¼� �Ƿ���Ƶ�ѡ
	$("input[type=checkbox][id^='DeptIfOccSimEvent-']").click(function(){
		var tmpid=this.id;
		if($('#'+tmpid).is(':checked')){
			$("input[type=checkbox][id^='DeptIfOccSimEvent-']").each(function(){
				if((this.id!=tmpid)&($('#'+this.id).is(':checked'))){
					$('#'+this.id).removeAttr("checked");
				}
			})
		}
	});
	//�����Ƿ��������Ƶ��¼� ��
	if($('#DeptIfOccSimEvent-94119').is(':checked')){
		$('#DeptIfOccSimEvent-94119-94120').attr('disabled',false);
	}else{
		$('#DeptIfOccSimEvent-94119-94120').val("");
	}
	//�����Ƿ��������Ƶ��¼� ��
	if($('#DeptIfOccSimEvent-94121').is(':checked')){
		$('#DeptIfOccSimEvent-94119-94120').val("");
	}else{
		$('#DeptIfOccSimEvent-94119-94120').attr('disabled',false);
	}
	//�����Ƿ��������Ƶ��¼� �� ����ȣ��Σ�
	$("#DeptIfOccSimEvent-94119-94120").bind("blur",function(){
		if($("#DeptIfOccSimEvent-94119-94120").val()!=""){
			$("#DeptIfOccSimEvent-94119").prop("checked",true) ;
			$('#DeptIfOccSimEvent-94121').removeAttr("checked");
		}
	})
	
}
function InitLayoutHtml(){
	///�̼�ǿ�ȵ�ҩ�����ƿ��
	$('#DrugExosStimInt-846-851,#DrugExosStimInt-847-854,#DrugExosStimInt-848-857,#DrugExosStimInt-849-860').css('max-width','300px');	
	//�������˵��
	$('#DrugExosAssother').css('max-width','300px');
	
	//$('#OccurBefDealMethod').find("label").eq(0).css("color","red");
	$('#OccurAfterDealMethod').find("label").eq(0).css("color","red");
	$('#PatSafeGroupResult-label').css("color","blue");
	
	$('#DeptIfOccSimEvent').find("label").eq(0).css("color","red");
	
	//alert(LgGroupDesc)
	//15����
		if((LgGroupDesc.indexOf("��ʿ��")<0)&(LgGroupDesc!="����")){
			//��ʿ����д start
			$("label[data-parref='OccurAfterDealMethod']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='OccurAfterDealMethod']").attr("disabled",true);  
			$("label[data-parref='DeptIfOccSimEvent']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='DeptIfOccSimEvent']").attr("disabled",true);
			$("#DeptIfOccSimEvent-94119-94120").css("background-color","#D4D0C8");
			$("#DeptIfOccSimEvent-94119-94120").attr("readonly","readonly");
			
			$("label[data-parref='NurReasonCase']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurReasonCase']").attr("disabled",true);  
			$("label[data-parref='NurCorrectAction']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurCorrectAction']").attr("disabled",true); 
			$("label[data-parref='NurDisposition']").css("color","#D4D0C8")
			$("input[type=checkbox][id^='NurDisposition']").attr("disabled",true); 
			$("#NurHeadNurse").css("background-color","#D4D0C8");
			$("#NurHeadNurse").attr("readonly","readonly"); 
			$("#NurSignDate").datetimebox({disabled:true});
			//��ʿ����д end
			
			//������д start
			$("label[data-parref^='PatSafeGroupResult-label']").css("color","#D4D0C8");
			$("input[type=radio][id^='PatSafeGroupResult-label']").attr("disabled",true);
			$("input[type=input][id^='PatSafeGroupResult-label']").css("background-color","#D4D0C8");
			$("input[type=input][id^='PatSafeGroupResult-label']").attr("disabled",true);

			$("#NurTeamReferPerson").css("background-color","#D4D0C8");
			$("#NurTeamReferPerson").attr("disabled",true);
			$("#ReferDate").datetimebox({disabled:true});
			//������д end
			
		}else{
			if(LgGroupDesc.indexOf("��ʿ��")>0){
				//������д start
				$("label[data-parref^='PatSafeGroupResult-label']").css("color","#D4D0C8");
				$("input[type=radio][id^='PatSafeGroupResult-label']").attr("disabled",true);
				$("input[type=input][id^='PatSafeGroupResult-label']").css("background-color","#D4D0C8");
				$("input[type=input][id^='PatSafeGroupResult-label']").attr("disabled",true);

				$("#NurTeamReferPerson").css("background-color","#D4D0C8");
				$("#NurTeamReferPerson").attr("disabled",true);
				$("#ReferDate").datetimebox({disabled:true});
				//������д end 	
			}
			if(LgGroupDesc=="����"){
				//��ʿ����д start
				$("label[data-parref='OccurAfterDealMethod']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='OccurAfterDealMethod']").attr("disabled",true);  
				$("label[data-parref='DeptIfOccSimEvent']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='DeptIfOccSimEvent']").attr("disabled",true);
				$("#DeptIfOccSimEvent-94119-94120").css("background-color","#D4D0C8");
				$("#DeptIfOccSimEvent-94119-94120").attr("readonly","readonly");
				
				$("label[data-parref='NurReasonCase']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurReasonCase']").attr("disabled",true);  
				$("label[data-parref='NurCorrectAction']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurCorrectAction']").attr("disabled",true); 
				$("label[data-parref='NurDisposition']").css("color","#D4D0C8")
				$("input[type=checkbox][id^='NurDisposition']").attr("disabled",true); 
				$("#NurHeadNurse").css("background-color","#D4D0C8");
				$("#NurHeadNurse").attr("readonly","readonly"); 
				$("#NurSignDate").datetimebox({disabled:true});
				//��ʿ����д end	
			}
			
		}
}

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
	InitCheckRadio();

}
//���ر�����Ϣ
function InitReport(recordId)
{
	InitReportCom(recordId);
	if((recordId=="")||(recordId==undefined)){
	}else{
		//������Ϣ
    	$("#from").form('validate');			
	} 
}


//���汣��
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(!(checkRequired()&&checkother())){
		return;
	}
	SaveReportCom(flag);
}

function doOther(obj){
}
//�����湴ѡ�������Ƿ���д�����
function checkother(){
	//���̲�λҩ���������
	var DrugExosPuncExos=0;
	$("input[type=radio][id^='DrugExosPuncExos']").each(function(){
		if($(this).is(':checked')){
			if ((this.id=="DrugExosPuncExos-882-884")&&(($("#DrugExosPuncExos-882-884-886").val()=="")||($("#DrugExosPuncExos-882-884-900").val()==""))){
				DrugExosPuncExos=-1;
				return false;
			}
			if ((this.id=="DrugExosPuncExos-905-907")&&($("#DrugExosPuncExos-905-907-909").val()=="")){
				DrugExosPuncExos=-2;
				return false;
			}
			if ((this.id=="DrugExosPuncExos-917-919")&&(($("#DrugExosPuncExos-917-919-921").val()=="")||($("#DrugExosPuncExos-917-919-923").val()==""))){
				DrugExosPuncExos=-3;
				return false;
			}
		}
	})
	if(DrugExosPuncExos==-1){
		$.messager.alert($g("��ʾ:"),$g("�����̲�λҩ���������-���ס���ѡ'��'������д���ݣ�"));	
		return false;
	}
	if(DrugExosPuncExos==-2){
		$.messager.alert($g("��ʾ:"),$g("�����̲�λҩ���������-��ʹ����ѡ'��'������д���ݣ�"));	
		return false;
	}
	if(DrugExosPuncExos==-3){
		$.messager.alert($g("��ʾ:"),$g("�����̲�λҩ���������-���񡿹�ѡ'��'������д���ݣ�"));	
		return false;
	}
	
	//�����ʩ ����ҩ�����ʸ��� 
	var DrugExosTM="",DrugExosTMList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTM=this.value;
		}
	})
	if(DrugExosTM=="����ҩ�����ʸ���"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMList=this.value
			}
		})
		if (DrugExosTMList==""){
			$.messager.alert($g("��ʾ:"),$g("�������ʩ����ѡ'����ҩ�����ʸ���'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	//�����ʩ ����ҩ�����ʸ���  ʪ��
	var DrugExosTMsf=0,DrugExosTMsfList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938-939']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMsf=this.value;
		}
	})
	if(DrugExosTMsf=="ʪ��"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-939-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMsfList=this.value
			}
		})
		if (DrugExosTMsfList==""){
			$.messager.alert($g("��ʾ:"),$g("�������ʩ����ѡ'����ҩ�����ʸ���-ʪ��'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	
	//�����ʩ ����ҩ�����ʸ���  ��������
	var DrugExosTMwlzl=0,DrugExosTMwlzlList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-938-942']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMwlzl=this.value;
		}
	})
	if(DrugExosTMwlzl=="��������"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-938-942-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMwlzlList=this.value
			}
		}) 
		if (DrugExosTMwlzlList==""){
			$.messager.alert($g("��ʾ:"),$g("�������ʩ����ѡ'����ҩ�����ʸ���-��������'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}
	//�����ʩ ����� 
	var DrugExosTMHZ=0,DrugExosTMHZList="";
	$("input[type=checkbox][id='DrugExosTreatMeas-947']").each(function(){
		if ($(this).is(':checked')){
			DrugExosTMHZ=this.value;
		}
	})
	if(DrugExosTMHZ=="�����"){
		$("input[type=checkbox][id^='DrugExosTreatMeas-947-']").each(function(){
			if (($(this).is(':checked'))&&(this.value!="")){
				DrugExosTMHZList=this.value
			}
		})
		if (DrugExosTMHZList==""){
			$.messager.alert($g("��ʾ:"),$g("�������ʩ����ѡ'�����'���빴ѡ��Ӧ���ݣ�"));	
			return false;
		}
	}

	return true;
}
//ʱ�� ����У��
function CheckTimeorNum(){	
	//��������У��  
	
	///���ƴ��̲�λҩ���������
	chknum("DrugExosPuncExos",1,1,100);
}


