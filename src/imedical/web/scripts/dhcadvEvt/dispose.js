///Description: �����봦��ʹ���������
///Creator: cy
///Creatdate: 2021-06-22
var RepDate=formatDate(0); 
$(document).ready(function(){
	ReportControl();			// ������  
	InitButton();				// ��ʼ����ť
	InitReport(recordId)
	
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
//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
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

function ReportControl()
{
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');	
			InitCheckRadio(this.id);	
		});
	});
	
}
function InitCheckRadio(id){
	/// 1.���������¼�/���������
	if(!(id.indexOf("DispOccuEventName")<0)){
		$("input[type='checkbox'][id^='DispOccuEventName']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 2.���������¼�����Ҫ����/Ҫ��
	if(!(id.indexOf("DispMainReason")<0)){
		$("input[type='checkbox'][id^='DispMainReason']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 3.�¼������˿�����ص�����
	if(!(id.indexOf("PosRelFactors")<0)){
		$("input[type='checkbox'][id^='PosRelFactors']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
	/// 4.Ԥ�������¼�������ٴη����ķ������ʩ
	if(!(id.indexOf("MedPreEvent")<0)){
		$("input[type='checkbox'][id^='MedPreEvent']").each(function(){
			if((this.id!=id)){
				$("#"+this.id).removeAttr("checked");
				$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
				$("#"+this.name.replace('.','-')).html("");
			}
		})
	}
}
function checkother()
{
	/// 1.���������¼�/���������(��ѡһ)
	var DispOccuEventNameList="",DispOccuEventNameErr="";
	$("input[type=checkbox][id^='DispOccuEventName-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					DispOccuEventNameList=this.value;
				}
			});
			if ((this.value!="")&&(DispOccuEventNameList=="")){
				$.messager.alert($g("��ʾ:"),$g("�����������¼�/��������ơ���ѡ'"+this.value+"'���빴ѡ��Ӧ���ݣ�"));	
				DispOccuEventNameErr=-1;
				return false;
			}
		}
	})
	if(DispOccuEventNameErr=="-1"){
		return false;
	}
	/// 2.���������¼�����Ҫ����/Ҫ��(��ѡһ)
	var DispMainReasonList="",DispMainReasonErr="";
	$("input[type=checkbox][id^='DispMainReason-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					DispMainReasonList=this.value;
				}
			});
			if ((this.value!="")&&(DispMainReasonList=="")){
				$.messager.alert($g("��ʾ:"),$g("�����������¼�����Ҫ����/Ҫ�ء���ѡ'"+this.value+"'���빴ѡ��Ӧ���ݣ�"));	
				DispMainReasonErr=-1;
				return false;
			}
		}
	})
	if(DispMainReasonErr=="-1"){
		return false;
	}
	/// 3.�¼������˿�����ص�����
	var PosRelFactorsList="",PosRelFactorsErr="";
	$("input[type=checkbox][id^='PosRelFactors-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					PosRelFactorsList=this.value;
				}
			});
			if ((this.value!="")&&(PosRelFactorsList=="")){
				$.messager.alert($g("��ʾ:"),$g("���¼������˿�����ص����ء���ѡ'"+this.value+"'���빴ѡ��Ӧ���ݣ�"));	
				PosRelFactorsErr=-1;
				return false;
			}
		}
	})
	if(PosRelFactorsErr=="-1"){
		return false;
	}
	/// 4.Ԥ�������¼�������ٴη����ķ������ʩ
	var MedPreEventList="",MedPreEventErr="";
	$("input[type=checkbox][id^='MedPreEvent-']").each(function(){
		if(($(this).is(':checked'))&&(this.id.split("-").length==2)){ 
			$("input[type=radio][id^='"+this.id+"-']").each(function(){
				if (($(this).is(':checked'))&&(this.value!="")){
					MedPreEventList=this.value;
				}
			});
			if ((this.value!="")&&(MedPreEventList=="")){
				$.messager.alert($g("��ʾ:"),$g("��Ԥ�������¼�������ٴη����ķ������ʩ����ѡ'"+this.value+"'���빴ѡ��Ӧ���ݣ�"));	
				MedPreEventErr=-1;
				return false;
			}
		}
	})
	if(MedPreEventErr=="-1"){
		return false;
	}
	
	return true;
}
