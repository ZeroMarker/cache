/// Description: ��ҩ�¼����浥
/// Creator: yuliping
/// CreateDate: 2018-08-31
var eventtype=""
var RepDate=formatDate(0); //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	
	InitButton(); 			// �󶨱����ύ��ť ��ҽ
	InitReport(recordId);//����ҳ����Ϣ	
	addDomMethod();   //������������Ԫ�ص�dom����
})
function InitButton()
{
	
	$("#SaveBut").on("click",function(){
		SaveReport(0);
	})
	$("#SubmitBut").on("click",function(){
		SaveReport(1);
	})
}
//qqa 2018-12-03 ���ڽ������Ԫ�ؿ��ƣ���������
function addDomMethod(){
	//�¼���������
	$("#drughapdate-94692").on("click",enabDate);
	$("#drughapdate-94693").on("click",disDate);
	
	/// ҽԺҩ���׼��ҵ����
	var tempckid="";
	$("input[type='checkbox'][id^='hospDrugFlow']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='hospDrugFlow']").each(function(){
				if($("#"+this.id).is(':checked')&&(tempckid.indexOf(this.id)<0)){
					if((tempckid.split("-").length==2)&&(this.id!=tempckid)){
						$("#"+this.id).removeAttr("checked");
						$("#hospDrugFlow-94830-94837").nextAll(".lable-input").val("");
						$("#hospDrugFlow-94830-94837").nextAll(".lable-input").hide();
					}
					if((tempckid.split("-").length==3)&&(this.id.split("-").length!=3)){
						$("#"+this.id).removeAttr("checked");
					}
				}
			})
		}
	})
	/// ���¼�����������������ɶ�ѡ��
	var tempckid="";
	$("input[type='checkbox'][id^='drugHandle']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='drugHandle']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))&&(tempckid.indexOf(this.id)<0)){
					$("#"+this.id).removeAttr("checked");
				}
			})
		}
	})
}

function enabDate(){
	$("#drughapdate-94692-94731").datetimebox("enable");
}

function disDate(){
	$("#drughapdate-94692-94731").datetimebox("setValue","");	
	$("#drughapdate-94692-94731").datetimebox("disable");
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

function SaveReport(flag,status){
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
