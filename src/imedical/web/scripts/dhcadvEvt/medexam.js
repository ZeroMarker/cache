///Description: ҽ����鲻���¼����浥
///Creator: sufan
///Creatdate: 2018-12-04
var RepDate=formatDate(0); 
$(document).ready(function(){
	reportControl();			// ������  
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
		$.messager.alert("��ʾ:","��������Ϊ�գ�������ǼǺŻ򲡰��Żس�ѡ���¼¼�뻼����Ϣ��");	
		return false;
	} 
	///����ǰ,��ҳ���������м��
	 if(!checkRequired()){
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

function reportControl()
{
	/// 1.���������¼�/���������(��ѡһ)
	var tempckid="";
	$("input[type='checkbox'][id^='AdvEventErr']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='AdvEventErr']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 2.���������¼�����Ҫ����/Ҫ��(��ѡһ)
	var tempckid="";
	$("input[type='checkbox'][id^='MajorCausesAdv']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='MajorCausesAdv']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 3.�¼������˿�����ص�����
	var tempckid="";
	$("input[type='checkbox'][id^='PosRelFactors']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='PosRelFactors']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
	/// 4.Ԥ�������¼�������ٴη����ķ������ʩ
	var tempckid="";
	$("input[type='checkbox'][id^='MedPreEvent']").on("click",function(){
		tempckid=this.id;
		if($("#"+tempckid).is(':checked')){
			$("input[type='checkbox'][id^='MedPreEvent']").each(function(){
				if((this.id!=tempckid)&&($("#"+this.id).is(':checked'))){
					$("#"+this.id).removeAttr("checked");
					$("input[type='radio'][id^='"+this.id+"-']").removeAttr("checked");
					//$("[id$='-"+this.id.split("-")[1]+"']div:not([id^='-"+this.id.split("-")[0]+"'])").html("");
					$("#"+this.name.replace('.','-')).html("");
					}
				})
			}
		})
}

