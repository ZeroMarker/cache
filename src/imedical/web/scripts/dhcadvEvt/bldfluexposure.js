/// Description:ѪҺ/��Һ��¶�¼�
/// Creator: yangyongtao
/// CreateDate: 2018-10-11
var eventtype=""
$(document).ready(function(){
	ReportControl();			// ������
	InitButton();				// ��ʼ����ť
	InitReport(recordId);		//����ҳ����Ϣ
	//BldFluInitUI(); //���ƽ���Ĭ�Ϲ�ѡ����

});
// ������
function ReportControl(){
	//��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this);
		});
	});
}
//��ť�����뷽����
function InitButton(){
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
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
//���ƽ���Ĭ�Ϲ�ѡ����
function BldFluInitUI(){
	$("#RepDept-98359").attr("checked",true)  //ҽԺ��Ⱦ�����
	$("#RepDept-98359").attr({disabled:true})
}

//���汣��
function SaveReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻس�ѡ���¼¼�뻼����Ϣ��");	
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

//���ر�������Ϣ
function InitPatInfo(EpisodeID)
{
	if(EpisodeID==""){return;}
	InitPatInfoCom(EpisodeID);
	$("#from").form('validate'); 
}

//combobox��ѡ����
function InitCheckRadio(obj){
	
	id=$(obj).attr("id")

	
	
	///2���Ƿ���ֹ��Ҹ�����
	if(id.indexOf("BldIfHepBVaccine-")>=0){
		 if($(obj).is(":checked")){
                 $("input[id^='BldIfHepBVaccine-']").not("input[id*='BldIfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
	     }
	}
	
	///���ֹ��Ҹ�������ش�ע��ʱ��
	if(id.indexOf("BldIfHepBVaccine-98843-98844-")>=0){
		if($(obj).is(":checked")){
				$("input[id^='BldIfHepBVaccine-98843-98844-']").not("#"+id).removeAttr("checked")
				$("#BldIfHepBVaccine-98843").attr("checked",true)
				$("input[id^='IfHepBVaccine-']").not("input[id*='IfHepBVaccine-"+ id.split("-")[1] +"']").removeAttr("checked")
		}else{
			    $("#BldIfHepBVaccine-98843").attr("checked",false)	
		}
	}
	   
	
	///3.�Ƿ񾭹�ְҵ������ѵ
	 if(id.indexOf("BldIfSkillTrain-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='BldIfSkillTrain-']").not("#"+id).removeAttr("checked")
		}	
	}
	///4.�������Ƿ�֪�����ߵĴ������
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
	///6.����ʱ��ȷ���������Ʒ
	 if(id.indexOf("IfAdornProtectArtic-")>=0){
		if($(obj).is(":checked")){
			$("input[id^='IfAdornProtectArtic-']").not("#"+id).removeAttr("checked")
		}	
	}
	///7.�����¶���뻼���йأ���ѡ���ߵĴ������
	if(id.indexOf("ExPatCondition-")>=0){
		if($(obj).is(":checked")){ 
		    if((id=="ExPatCondition-98856")||(id=="ExPatCondition-98857")||(id=="ExPatCondition-98858")){
				   $("input[id^='ExPatCondition-']").not("#"+id).removeAttr("checked")
				   $("#ExPatCondition-98863").next().next().val("");
				   $("#ExPatCondition-98863").next().next().hide();
			}else{
				   $("input[id='ExPatCondition-98856']").not("#"+id).removeAttr("checked")
				   $("input[id='ExPatCondition-98857']").not("#"+id).removeAttr("checked")
				   $("input[id='ExPatCondition-98858']").not("#"+id).removeAttr("checked")
			}
		 }	
	}
	
	///2����¶���������
	 if(id.indexOf("OccuExpAfter-")>=0){
		if($(obj).is(":checked")){
			if(id!="OccuExpAfter-98876"){
			    $("#OccuExpAfter-98876").next().next().val("");
			    $("#OccuExpAfter-98876").next().next().hide();
			    $("input[id^='OccuExpAfter-']").not("#"+id).removeAttr("checked")	
			}else{
			   $("input[id^='OccuExpAfter-']").not("#"+id).removeAttr("checked")
			}
		}	
	}

	
}