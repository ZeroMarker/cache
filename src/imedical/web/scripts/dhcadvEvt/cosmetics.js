/**
*Description:	��ױƷ�����¼�
*Creator: 		hujianghai
*CreDate: 		2020-07-06
**/
var RepDate=formatDate(0);	// ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	InitButton();				// ��ʼ����ť
	reportControl();			// ������ 
	InitReport(recordId);	// ����ҳ����Ϣ

})


function InitButton(){
	
	// ����
	$("#SaveBut").on("click",function(){
		SaveCosReport(0);
	})
	
	// �ύ
	$("#SubmitBut").on("click",function(){
		SaveCosReport(1);
	})
	
}

// ������
function reportControl(){
	
	// ��ѡ��ť�¼�
	$("input[type=checkbox]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');	
			InitCheckRadio(this.id);	
		});
	});
	//��ѡ��ť�¼�
	$("input[type=radio]").each(function(){
		$(this).click(function(){
			$(this).is(':checked');
			InitCheckRadio(this.id);
		});
	});
	
	/// �������� ��ѡ���� ����ѡ��ɹ�ѡ������ ����ѡ��ɹ�ѡ
	$("input[type=radio][id^='repTypeHz-']").each(function(){
		if($("#repTypeHz-99880").is(':checked')){
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",false);
		}else{
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",true);
		}
	})
	
	/// ��ױƷ��Ϣ-��� ���� Cosmetics-101199-101220-101235
	$("input[type=radio][id^='Cosmetics-101199-101220-101235']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101220-101235'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	/// ��ױƷ��Ϣ-��� ��ͨ
	$("input[type=radio][id^='Cosmetics-101199-101220-101236']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101220-101236'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				if($("input[type=radio][id^='Cosmetics-101199-101220-101236-101260'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else if ($("input[type=radio][id^='Cosmetics-101199-101220-101236-101261.']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else if ($("input[type=radio][id^='Cosmetics-101199-101220-101236-101262.']").is(':checked')){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
				}else {
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
				}
				
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	
	/// ��ױƷ��Ϣ-��ױƷ�йذ�������
	$("input[type=radio][id^='Cosmetics-101199-101225-101245']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101225-101245'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101225-101245-'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101225-101245-'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
		}
	})
	/// ��ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а�������
	$("input[type=radio][id^='Cosmetics-101199-101226-101247']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",false);
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+this.id.split(".")[1]+"']").attr("disabled",true);
		}
	})
	/// ��ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а������� ����  �г�������������
	$("input[type=radio][id^='Cosmetics-101199-101226-101247-101287']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247-101287'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").show();
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+this.id.split(".")[1]+"']").hide();
		}
	})
	
	/// ��ױƷ��Ϣ-�����������
	$("input[type=radio][id^='Cosmetics-101199-101227-']").each(function(){
		if($("input[type=radio][id^='Cosmetics-101199-101227-101248'][id$='."+this.id.split(".")[1]+"']").is(':checked')){
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").attr("readonly",false);
		}else{
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").val("");
			$("input[id^='Cosmetics-101199-101227-101248-101310.'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101227-101248-101312.'][id$='."+this.id.split(".")[1]+"']").attr("readonly","readonly");
		}
	})
	// ��ʼʹ������
	chkdate("StartUseDate");
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
function SaveCosReport(flag)
{
	if($('#PatName').val()==""){
		$.messager.alert($g("��ʾ:"),$g("��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��"));	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!(checkother()&&checkRequired())){
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



function InitCheckRadio(id){
	/// �������� ��ѡ���� ����ѡ��ɹ�ѡ������ ����ѡ��ɹ�ѡ
	if(id.indexOf("repTypeHz-")>=0){
		if($("#repTypeHz-99880").is(':checked')){
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",false);
		}else{
			$("input[type=checkbox][id^='CriticalOptions-']").removeAttr("checked");
			$("input[type=checkbox][id^='CriticalOptions-']").attr("disabled",true);
		}
	}
	var checkrowid=id.split(".")[0];
	var checkrownum=id.split(".")[1];
	/// ��ױƷ��Ϣ-��� ���� Cosmetics-101199-101220-101235 Cosmetics-101199-101220-101235
	if(checkrowid.indexOf("101220")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101220-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){ // ���⡢ ��ͨ
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101220-'][id$='"+checkrownum+"']").removeAttr("checked");
				if(checkrowid=="Cosmetics-101199-101220-101235"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101235-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
			}
			if(checkrowid.split("-").length==5){ //  ��ͨ  ������ ������ ���������� ��ˮ��
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101220-101236-'][id$='"+checkrownum+"']").removeAttr("checked");
				if(checkrowid=="Cosmetics-101199-101220-101236-101260"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101261"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",false);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101262"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
				if(checkrowid=="Cosmetics-101199-101220-101236-101263"){
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101260-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101261-'][id$='."+checkrownum+"']").attr("disabled",true);
					$("input[type=radio][id^='Cosmetics-101199-101220-101236-101262-'][id$='."+checkrownum+"']").attr("disabled",true);
				}
			}
		}	 
	}
	/// ��ױƷ��Ϣ-��Ʒ��Դ ����
	if(checkrowid.indexOf("101223")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101223-'][id$='"+checkrownum+"']").is(':checked')){
			if (checkrowid!=="Cosmetics-101199-101223-101242"){
				$("input[type=radio][id^='Cosmetics-101199-101223-101242'][id$='."+checkrownum+"']").nextAll(".lable-input").val("");
				$("input[type=radio][id^='Cosmetics-101199-101223-101242'][id$='."+checkrownum+"']").nextAll(".lable-input").hide();
			}
		}	 
	}	
	/// ��ױƷ��Ϣ-��ױƷ�йذ������� 
	if(checkrowid.indexOf("101225")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101225-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){
				$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101225-'][id$='"+checkrownum+"']").removeAttr("checked");
				if (checkrowid!=="Cosmetics-101199-101225-101245"){
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly","readonly");
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly","readonly");
				}else{
					$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly",false);
					$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly",false);
				}
			}
		}else{
			$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").val("");
			$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+checkrownum+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").val("");
			$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+checkrownum+"']").attr("readonly","readonly");
		} 	 
	}
	/// ��ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а�������
	if(checkrowid.indexOf("101226")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101226-'][id$='"+checkrownum+"']").is(':checked')){
			if(checkrowid.split("-").length==4){
				if ((checkrowid!=="Cosmetics-101199-101226-101247")){
					$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").val("");
					$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").hide();
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").removeAttr("checked");
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").attr("disabled",true);
				}else{
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+checkrownum+"']").attr("disabled",false);
				}
			}
		}else{
			$("input[type=radio][id^='Cosmetics-101199-101226-'][id$='."+checkrownum+"']").removeAttr("checked");
			$("input[type=radio][id^='Cosmetics-101199-101226-'][id$='."+checkrownum+"']").attr("disabled",true);
		} 	 
	}
	
	
	/// ��ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а������� ��Ԫ�ص�ѡ	Cosmetics-101199-101226-101247-101287-101327
	if(checkrowid.indexOf("101247")>0){
		if($("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='"+checkrownum+"']").is(':checked')){
			if (checkrowid!=="Cosmetics-101199-101226-101247-101287"){
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").val("");
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").hide();
			}else{
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").show();
				$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+checkrownum+"']").attr("readonly",false);
			}
		}	 
	}
	/// ��ױƷ��Ϣ-�����������
	if(checkrowid.indexOf("101227")>0){ 
		if($("input[type=radio][id^='Cosmetics-101199-101227-'][id$='"+checkrownum+"']").is(':checked')){
			$("input:not([id='"+id+"'])input[type=radio][id!='"+checkrowid+"'][id^='Cosmetics-101199-101227-'][id$='"+checkrownum+"']").removeAttr("checked");
			if (checkrowid!=="Cosmetics-101199-101227-101248"){
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly","readonly");
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly","readonly");
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").val("");
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").val("");
			}else{
				$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly",false);
				$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly",false);
			}			
		}else{
			$("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+checkrownum+"']").attr("readonly","readonly");
			$("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+checkrownum+"']").attr("readonly","readonly");
		} 	 
	}
	/// �������� 3.Ƥ��λ ��ѡ �� ȡ���� �� �Ĺ�ѡ��Ĺ�ѡ
	if(id.indexOf("ProcessDescriptionHZ-99921-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99921-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99921-99948"){
				$("input:not([id='ProcessDescriptionHZ-99921-99948'])input[type=checkbox][id^='ProcessDescriptionHZ-99921-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99921-99949").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99921-99949").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99921-99948").removeAttr("checked");
			}
		}
	}
	
	/// �������� 4.Ƥ����̬ ��ѡ �� ȡ���� �� �Ĺ�ѡ��Ĺ�ѡ
	if(id.indexOf("ProcessDescriptionHZ-99922-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99922-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99922-99980"){
				$("input:not([id='ProcessDescriptionHZ-99922-99980'])input[type=checkbox][id^='ProcessDescriptionHZ-99922-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99922-99981").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99922-99981").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99922-99980").removeAttr("checked");
			}
		}
	}
	/// �������� 5.������ ��ѡ �� ȡ���� �� �Ĺ�ѡ��Ĺ�ѡ
	if(id.indexOf("ProcessDescriptionHZ-99923-")>=0){
		if($("input[type=checkbox][id^='ProcessDescriptionHZ-99923-").is(':checked')){
			if(id=="ProcessDescriptionHZ-99923-99986"){
				$("input:not([id='ProcessDescriptionHZ-99923-99986'])input[type=checkbox][id^='ProcessDescriptionHZ-99923-']").removeAttr("checked");
				$("#ProcessDescriptionHZ-99923-99987").nextAll(".lable-input").val("");
				$("#ProcessDescriptionHZ-99923-99987").nextAll(".lable-input").hide();
			}else{
				$("#ProcessDescriptionHZ-99923-99986").removeAttr("checked");
			}
		}
	}

}

//�����湴ѡ�������Ƿ���д�����
function checkother(){
	// �������� ���� repTypeHz-99880
	var RepTypeList="",RepTypeOthErr="";
	if($("#repTypeHz-99880").is(':checked')){
		$("input[type=checkbox][id^='CriticalOptions-']").each(function(){
			if ($(this).is(':checked')){
				RepTypeList=this.value;
			}
		})
		if ((RepTypeList=="")){
			$.messager.alert($g("��ʾ:"),$g("���������͡���ѡ'����'���빴ѡ������ѡ���"));	
			RepTypeOthErr=-1;
			return false;
		}
	}
	if(RepTypeOthErr=="-1"){
		return false;
	}
	
	// ��ױƷ��Ϣ-��� 
	var TypeList="",TypeOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101220-']").each(function(){
		if ($(this).is(':checked')){
				var TypeList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				var TypeValue=this.value;
				if(radiorowid.split("-").length==4){ // ���⡢ ��ͨ
					$("input[type=radio][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							TypeList=this.value;
						}
					});
					if ((TypeValue!="")&&(TypeList=="")){
						$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-��𡿹�ѡ'"+TypeValue+"'���빴ѡ��Ӧ���ݣ�"));	
						TypeOthErr=-1;
						return false;
					}
				}
				
				if((radiorowid.split("-").length==5)&&(radiorowid.indexOf("Cosmetics-101199-101220-101236")>=0)){ //  ��ͨ  ������ ������ ���������� ��ˮ��
					$("input[type=radio][id^='"+radiorowid+"-'][id$='."+radiorownum+"']").each(function(){
							if (($(this).is(':checked'))&&(this.value!="")){
								TypeList=this.value;
							}
						});
						if ((TypeValue!="")&&(TypeValue!="��ˮ��")&&(TypeList=="")){
							$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-���-��ͨ����ѡ'"+TypeValue+"'���빴ѡ��Ӧ���ݣ�"));	
							TypeOthErr=-1;
							return false;
						}
				}
		}
	});
	if(TypeOthErr=="-1"){
		return false;
	}

	// ��ױƷ��Ϣ  ��ױƷ�йذ������� 
	var BTDoneList="",BTOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101225-']").each(function(){
		if ($(this).is(':checked')){
				var BTDoneList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				if(radiorowid=="Cosmetics-101199-101225-101245"){
					BTDoneList=BTDoneList+$("input[id^='Cosmetics-101199-101225-101245-101280'][id$='."+radiorownum+"']").val();
					BTDoneList=BTDoneList+$("input[id^='Cosmetics-101199-101225-101245-101281'][id$='."+radiorownum+"']").val();
				}
				if((radiorowid=="Cosmetics-101199-101225-101245")&&(BTDoneList=="")){
					$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-��ױƷ�йذ������顿��ѡ��������������д������Ӧ���ݣ�"));	
					BTOthErr=-1;
					return false;
				}		
		}
	});
	if(BTOthErr=="-1"){
		return false;
	}
	
	// ��ױƷ��Ϣ  ŷ�ꡢ�ı��Ӧԭϵ�а�������
	var OBDoneList="",OBOthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101226-']").each(function(){
		if ($(this).is(':checked')){
				var OBDoneList="";
				var radiorowid=this.id.split(".")[0];
				var radiorownum=this.id.split(".")[1];
				if((radiorowid.split("-").length==4)||(radiorowid=="Cosmetics-101199-101226-101247")){ // ����
					$("input[type=radio][id^='Cosmetics-101199-101226-101247-'][id$='."+radiorownum+"']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							OBDoneList=this.value;
						}
					});
					if((radiorowid=="Cosmetics-101199-101226-101247")&&(OBDoneList=="")){
						$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а������顿��ѡ�����������빴ѡ������Ӧ���ݣ�"));	
						OBOthErr=-1;
						return false;
					}
				}
				if((radiorowid.split("-").length==5)||(radiorowid=="Cosmetics-101199-101226-101247-101287")){ // �г�������������
					OBDoneList=$("input[id^='Cosmetics-101199-101226-101247-101287-101327'][id$='."+radiorownum+"']").val();
					if((radiorowid=="Cosmetics-101199-101226-101247-101287")&&(OBDoneList=="")){
						$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-ŷ�ꡢ�ı��Ӧԭϵ�а�������-��������ѡ���г������������ʡ�������д��Ӧ���ݣ�"));		
						OBOthErr=-1;
						return false;
					}
				}
		}
	});
	if(OBOthErr=="-1"){
		return false;
	}
	// ��ױƷ��Ϣ  ��Ʒ��Դ 
	var OrignErr="";
	$("input[type=radio][id^='Cosmetics-101199-101223-']").each(function(){
		if ($(this).is(':checked')){
			var radiorowid=this.id.split(".")[0];
			var radiorownum=this.id.split(".")[1];
			if((radiorowid=="Cosmetics-101199-101223-101242")&&($("input[type=radio][id^='"+radiorowid+"'][id$='."+radiorownum+"']").nextAll(".lable-input").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-��Ʒ��Դ����ѡ��������������д��Ӧ���ݣ�"));	
				OrignErr=-1;
				return false;
			}
		}
	});
	if(OrignErr=="-1"){
		return false;
	}
	// ��ױƷ��Ϣ  ����������� 
	var OthErr="";
	$("input[type=radio][id^='Cosmetics-101199-101227-101248']").each(function(){
		if ($(this).is(':checked')){
			var radiorowid=this.id.split(".")[0];
			var radiorownum=this.id.split(".")[1];
			if(($("input[id^='Cosmetics-101199-101227-101248-101310'][id$='."+radiorownum+"']").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-����������顿��ѡ���С�������д���ƣ�"));	
				OthErr=-1;
				return false;
			}
			if(($("input[id^='Cosmetics-101199-101227-101248-101312'][id$='."+radiorownum+"']").val()=="")){ //UlcerPart-95158-95166-95182
				$.messager.alert($g("��ʾ:"),$g("����ױƷ��Ϣ-����������顿��ѡ���С�����������"));	
				OthErr=-1;
				return false;
			}
		}
	});
	if(OthErr=="-1"){
		return false;
	}
	
	// ��������-Ƥ��λ 
	var SkinList="",SkinOthErr="";
	$("input[type=checkbox][id^='ProcessDescriptionHZ-99921-']").each(function(){
		if ($(this).is(':checked')){
				var SkinList="";
				var radiorowid=this.id;
				var SkinValue=this.value;
				if(radiorowid.split("-").length==3){ 
					$("input[type=checkbox][id^='"+radiorowid+"-']").each(function(){
						if (($(this).is(':checked'))&&(this.value!="")){
							SkinList=this.value;
						}
					});
					if ((SkinValue=="�沿")&&(SkinList=="")){
						$.messager.alert($g("��ʾ:"),$g("����������-Ƥ��λ����ѡ'"+SkinValue+"'���빴ѡ��Ӧ���ݣ�"));	
						SkinOthErr=-1;
						return false;
					}
				}
			
		}
	});
	if(SkinOthErr=="-1"){
		return false;
	}
	return true;
}

function add_event(){
	reportControl();
}
