/// Description:���������
/// Creator: yangyongtao
/// CreateDate: 2018-10-11
var eventtype=""
$(document).ready(function(){
	ReportControl();			// ������
	InitButton(); 			// �󶨱����ύ��ť ��ҽ
	InitReport(recordId);//����ҳ����Ϣ


});
// ������
function ReportControl(){
	
	
	///��������λ�ú���
	chknum("InjuryLocatNo",0,1,64);
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this);
		});
	});
}
function InitButton()
{
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}

//���汣��
function SaveReport(flag)
{
	if(($('#PatName').val()=="")&&($("#PatName").is(":visible"))){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	}
	///����ǰ,��ҳ���������м��
	if(flag==1){
		if(!(checkRequired())){
			return;
		}
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



//combobox��ѡ����
function InitCheckRadio(obj){
	
	id=$(obj).attr("id")
	parref=$(obj).parent().attr("data-parref")

	/* ///������Ϣ�Ƿ����
	if(id.indexOf("PatInfoIfRequest-")>=0){
		if($(obj).is(":checked")){
		  $("input[id^='PatInfoIfRequest-']").not("#"+id).removeAttr("checked")	
		}
	} */
	

	///2.������ǰ�Ƿ���ֹ��Ҹ�����
	if(id.indexOf("IfHepBVaccine-")>=0){
                 $("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
	}
	
	///���ֹ��Ҹ�������ش�ע��ʱ��
	if(id.indexOf("IfHepBVaccine-98082-98089-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfHepBVaccine-98082-98089-']").not("#"+id).removeAttr("checked")
			$("#IfHepBVaccine-98082").attr("checked",true)
			$("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
		}else{
			$("#IfHepBVaccine-98082").attr("checked",false)
		}
	}
	   
	
	///3.�Ƿ񾭹�ְҵ�������������������ѵ
	 if(id.indexOf("IfSkillTrain-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfSkillTrain-']").not("#"+id).removeAttr("checked")
		}	
	}
	///4.�������Ƿ�֪�����˵Ĵ������
	 if(id.indexOf("IfPatDisease-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfPatDisease-']").not("#"+id).removeAttr("checked")
		}	
	}
    ///5.����������ϰ��Ϊ
	 if(id.indexOf("HandHabit-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='HandHabit-']").not("#"+id).removeAttr("checked")
		}	
	}
	///6.�������Ƿ�Ϊ�������ʹ����
	 if(id.indexOf("SharpFirUser-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='SharpFirUser-']").not("#"+id).removeAttr("checked")
		}	
	}
	///1.�����˺�������������
	if(id.indexOf("SharpKinds-")>=0){
		if($(obj).is(":checked")){ 
		   if(id!="SharpKinds-98123"){
			 $("#SharpKinds-98123").next().next().val("");
		     $("#SharpKinds-98123").next().next().hide();
			 $("input[id^='SharpKinds-']").not("#"+id).removeAttr("checked")
		   }else{
			 $("input[id^='SharpKinds-']").not("#"+id).removeAttr("checked")
		   }
		}	  
	}
	///2.���������Ŀ��
	if(id.indexOf("SharpFirPurpose-")>=0){
		if($(obj).is(":checked")){ 
		   if(id!="SharpFirPurpose-98140"){
			 $("#SharpFirPurpose-98140").next().next().val("");
		     $("#SharpFirPurpose-98140").next().next().hide();
			 $("input[id^='SharpFirPurpose-']").not("#"+id).removeAttr("checked")
		   }else{
			 $("input[id^='SharpFirPurpose-']").not("#"+id).removeAttr("checked")
		   }
		}	  
	}
	///3.�����Ƿ�Ѫ��Ⱦ
	if(id.indexOf("IfSharpBlood-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfSharpBlood-']").not("#"+id).removeAttr("checked")
		}	
	}
	
	///5.�˺��ķ������޲���ȷ�Ĳ�����
	if(id.indexOf("IfOperCorrect-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfOperCorrect-']").not("#"+id).removeAttr("checked")
		}	
	}
	///6.����������벡���йأ���ѡ���˵Ĵ������
	if(id.indexOf("PatCondition-label-")>=0){
		if($(obj).is(":checked")){ 
		    if((id=="PatCondition-label-98155")||(id=="PatCondition-label-98156")||(id=="PatCondition-label-98157")){
				   $("input[id^='PatCondition-label-']").not("#"+id).removeAttr("checked")
				   $("#PatCondition-label-98162").next().next().val("");
				   $("#PatCondition-label-98162").next().next().hide();
			}else{
				   $("input[id='PatCondition-label-98155']").not("#"+id).removeAttr("checked")
				   $("input[id='PatCondition-label-98156']").not("#"+id).removeAttr("checked")
				   $("input[id='PatCondition-label-98157']").not("#"+id).removeAttr("checked")
			}
		 }	
	}
	
	///7.�˺���������  $("input[id^='OccurInjuryLink-"+idArr[1]+"']").not("#"+id).removeAttr("checked")
	if(id.indexOf("OccurInjuryLink-")>=0){
		 if($(obj).is(":checked")){
                $("input[id^='OccurInjuryLink-']").not("input[id*='OccurInjuryLink-"+ id.split("-")[1] +"']").removeAttr("checked")
	     }
	}
			  
	///2��������͸��
	if(id.indexOf("Sharpen-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='Sharpen-']").not("#"+id).removeAttr("checked")
		}	
	}
	///3�����˺��˿ڴ������
	if(id.indexOf("WoundManage-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='WoundManage-']").not("#"+id).removeAttr("checked")
		}	
	}
}
