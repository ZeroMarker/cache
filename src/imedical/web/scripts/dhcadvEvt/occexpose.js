///Description:��ҽְҵ��¶�����¼����浥 
///Creator:    wangxuejian  
///CreatDate:  2018-05-20   
var RepDate=formatDate(0);               //ϵͳ�ĵ�ǰ����
$(document).ready(function(){
	ReportControl();                    //������Ŀ���	
	InitButton();               		//����(������input���ؿ����֤)
	InitReport(recordId);           //���ر�����Ϣ

})

// �󶨱��桢�ύ��ť
function InitButton()
{
	if (RepStaus!=""){
		if(winflag==2){
			/// ������ť��ʾ ��ζ��������Ȩ�ޣ�����ְҵ��¶��ʾ��¶��������ť
			if($("#AssessmentBut").is(":visible")){ 
				$("#ExpoAssBut").show(); //��ʾ���۰�ť 2020-02-20
			}
		}
		$("#ExpoFolBut").show(); //��ʾ��¶����ð�ť
		$("#AssessmentBut").hide(); //2019-07-26  ����ҽ��������û��ԭ������Ļ������͵�������ť
	}
	$("#SaveBut").on("click",function()
	{
	    SaveReport(0)                    //ְҵ��¶�¼����ı���
	})
	$("#SubmitBut").on("click",function()
	{
	   SaveReport(1)
	})
	var ExpAssTreId=GetAssessRecordID("ExpAssTreatment"); 
	if(ExpAssTreId!=""){
		$("#ExpoAssBut").show();
	}
	$("#ExpoAssBut").on("click",function(){ 
		showAssessmentWin("ExpAssTreatment",ExpAssTreId);
	})
	var ExpFlupFormId=GetAssessRecordID("ExposerFlupForm"); 
	$("#ExpoFolBut").on("click",function(){ 
		showAssessmentWin("ExposerFlupForm",ExpFlupFormId);
	})
	
	
	
}

function ReportControl()    //������Ŀ���
{
	  //Ԥ�����֣����Ԥ������ѡ���ǣ����������ƿ������룬���ѡ������������Ʋ��ܽ������룩
	 $("input[type=radio][id^='OccuExpVaccination']").each(function()
	 {
	    $(this).click(function()
	    {
	      if($(this).is(':checked'))
	      {
		     var id=this.id;
		     if(id=="OccuExpVaccination-97007")
		     {
			     RepSetRead("OccuExpVaccineName","input",2);  //��������
			    $('#OccuExpVaccineName').css("background-color","#fff");
		     }else
			 {
			    $('#OccuExpVaccineName').val("");                 //��������
			    $('#OccuExpVaccineName').css("background-color","#D4D0C8");
			    RepSetRead("OccuExpVaccineName","input",1);
			 }
		   }
	     })
	  })
	/*2018-06-06 ��ɾ�����ӵ�table����*/
	$(".dhc-table>tbody td>input").css({"margin-left":"-10px","margin-right":"8px"})
	/// ��¶����
	chknum("ExposeTimes",0,1);
	$('#ResponSex').combobox({editable:false});
}

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
//2018-04-14 �رմ���
function CloseAsseWin(){
	$('#assewin').window('close');
}
