//===========================================================================================
// ���ߣ�      yuliping
// ��д����:   2018-08-21
// ����:	   �²����¼�html��ӡ
//===========================================================================================
var pageHeight=970;   //��ǰҳ��߶�
var cuPage=1;           //��ǰ�ڼ�ҳ

$(document).ready(function(){	

	HiddenPathDate(); //IE ���ش�ӡʱ�ļ�·��������
	initTable();	// ��ʼ��table���ݣ������ô�ӡ
	$("#PrintBut").on("click",function(){
		printOrExportHtml();// ���ô�ӡ�򵼳�
	}) 
	
  $('input,textarea').not("#print").attr("readonly","readonly");

})

//��ʼ�������ݣ����ö�Ӧ�Ĵ�ӡ����
function initTable(){
	//alert(RepTypeCode)
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintData",{AdvMasterDr:RepID},function(ret){
		if(RepTypeCode=="advWallLeakage"){ 
			printWallLData(ret); //ҽ�ƻ�����շ���(��©/����)�¼����浥
		}else if(RepTypeCode=="advPipeOff"){
			printPipeOffData(ret);//��·���䱨�浥  
		}else if(RepTypeCode=="advAccidentFill"){  
			printAccidentData(ret); //�����¼����浥
		}else if(RepTypeCode=="advDrugUseErr"){  
			printadvDrugUseErrData(ret); //��ҩ�����¼����浥
		}else if(RepTypeCode=="advFallDownFill"){  
			printAdvFDFillData(ret); //����(׹��)�¼����浥	
		}else if(RepTypeCode=="advSkinUlcer"){  
			printAdvSkinUlcerData(ret); //ѹ�����浥
		}else if(RepTypeCode=="advDisMedThing"){  
			printAdvDisMedData(ret);  //һ����ҽ����Ʒ�����¼����浥
		}else if(RepTypeCode=="advDevice"){
			printAdvDevicebyData(ret); // ��е
		}else if(RepTypeCode=="advBlood"){
			printAdvBloodbyData(ret); // ��Ѫ
		}else if(RepTypeCode=="advDrug"){
			printAdvdrugData(ret); //ҩƷ�����¼�
		}else if(RepTypeCode=="advMedical"){		 
			printAdvMedicalData(ret); // ҽ�Ʋ����¼�			
		}else if(RepTypeCode=="advMedDispute"){
			printAdvMedDisputeData(ret); // ҽ��Ͷ�ߡ����׵ǼǱ�
		}else if(RepTypeCode=="advHosInfect"){  
			printadvHosInfectData(ret); //Ժ�в����¼�
		}else if(RepTypeCode=="advOccExpose"){  
			printadvOccExposeData(ret); //ְҵ��¶�����¼����浥
		}else if(RepTypeCode=="advNonPlanRepa"){  
			printadvNonPlanRepaData(ret); //�Ǽƻ��ٴ��������浥
		}else if(RepTypeCode=="advTransRct"){  
			printadvTransRctData(ret); //��Һ��Ӧר��浥
		}else if(RepTypeCode=="advDrugExos"){  
			printadvDrugExosData(ret); //ҩ������ר��浥
		}else if(RepTypeCode=="advDrugquality"){  
			printAdvdrugqualityData(ret); //ҩƷ�������浥 
		}else {
			$.messager.alert("��ʾ:","�޴�ӡ��س���");
			return;
		}		
	})
}
/// ҽ�ƻ�����շ�������©/�������¼����浥
function printWallLData(data){
    var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҽ�ƻ�����շ�������©/�������¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
    htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["AFLoc"]),3,"","","<tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["FindDate"]),3,"","","");  					//��������
	htmlStr=htmlStr+initTableTdOne("�¼����"+$g(data["EveType"]),4,"","","</tr>");	//�¼����

    htmlStr=htmlStr+initTableTr("�¼�������","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	
	htmlStr=htmlStr+initTableTr("ԭ�������","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["WLCauseAnalysis"]),"10","border-top:0px"); //ԭ�����
	
	htmlStr=htmlStr+initTableTr("�Ľ��취��","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //�Ľ��취
	htmlStr=htmlStr+initTableTr($g(data["WLImprovedMethod"]),"10","border-top:0px"); //�Ľ��취
	
	htmlStr=htmlStr+initTableTdOne("�����ˣ�"+$g(data["WallDiscover"]),3,"","","<tr>");	//������
	htmlStr=htmlStr+initTableTdOne("ְ�ƣ�"+$g(data["JobTitle"]),7,"","","</tr>");	//ְ��
	htmlStr=htmlStr+initTableTdOne("ְ��"+$g(data["Duty"]),3,"","","<tr>");	//ְ��
	htmlStr=htmlStr+initTableTdOne("�������ޣ��꣩��"+$g(data["WallWorkYears"]),7,"","","</tr>");   	//�ϱ��˹�������	

	htmlStr=htmlStr+initTableTr("�������"+getRadioValueById("RelatedAreas",data),"10","");   	//�������
	htmlStr=htmlStr+initTableTr("���¼��Ƿ�Ϊ��©��Ϊ��"+getRadioValueById("IfWLBehavior",data),"10","");	//���¼��Ƿ�Ϊ��©��Ϊ
	htmlStr=htmlStr+initTableTdOne("��©�ˣ�"+$g(data["WLMan"]),3,"","","<tr>");  					//��©��
	htmlStr=htmlStr+initTableTdOne("�������ޣ�"+$g(data["WLManWorkLife"]),7,"","","</tr>");  					//��������
	htmlStr=htmlStr+initTableTr("��©�˿��ң�"+$g(data["WallLoc"]),"10","");  					//��©�˿���
	
	htmlStr=htmlStr+initTableTr("��©��Ϊ��","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //��©��Ϊ
	htmlStr=htmlStr+initTableTr($g(data["WLBehavior"]),"10","border-top:0px"); //��©��Ϊ
	htmlStr=htmlStr+initTableTdOne("����¹����ʽ��ۣ�"+getRadioValueById("EventConclusion",data),6,"","","<tr>");   	//����¹����ʽ���
	htmlStr=htmlStr+initTableTdOne("��Ч������"+getRadioValueById("PerformanceRewards",data),4,"","","</tr>");	//��Ч����
	htmlStr=htmlStr+initTableTr("����ίԱ�������","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //����ίԱ�����
	htmlStr=htmlStr+initTableTr($g(data["QualityCommitteeOpinion"]),"10","border-top:0px"); //����ίԱ�����
	
	htmlStr=htmlStr+"</table>";
	
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  
}
//��·���Ѳ����¼���ӡ
function printPipeOffData(data){
   var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��·���䱨�浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������

	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ

	htmlStr=htmlStr+initTableTdOne("������"+$g(data["DisMedThingPatName"]),3,"","","<tr>");   	//����
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatID"]),3,"","","<tr>");  					//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");	//��������

    htmlStr=htmlStr+initTableTdOne("�Ա�"+$g(data["PatSexinput"]),4,"","","</tr>");   	//�Ա�
	htmlStr=htmlStr+initTableTr("��һ��ϣ�"+$g(data["PatDiag"]),10,"");	//��һ���
	htmlStr=htmlStr+initTableTdOne("������Դ��"+getRadioValueById("PatOrigin",data),6,"","","<tr>");	//������Դ
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["PatAdmDate"]),4,"","","</tr>");  					//��Ժ����

	htmlStr=htmlStr+initTableTdOne("��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]),3,"","","<tr>");   	//��ԺʱADL�÷�
	htmlStr=htmlStr+initTableTdOne("��Ժʱ���������չ�������"+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//���������չ�����
	htmlStr=htmlStr+initTableTdOne("����ǰADL�÷֣�"+$g(data["OccurADLScore"]),3,"","","<tr>");	//����ǰADL�÷�
	htmlStr=htmlStr+initTableTdOne("����ǰ���������չ�������"+getRadioValueById("OccurPatSelfCareAbility",data),7,"","","</tr>");	//���������չ�����
	htmlStr=htmlStr+initTableTdOne("�㻤��Ա��"+getRadioValueById("PatEscort",data),3,"","","<tr>");   	//�㻤��Ա
	htmlStr=htmlStr+initTableTdOne("������"+getRadioValueById("NursingLev",data),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("�Ļ��̶ȣ�"+getRadioValueById("DegreeEducate",data),4,"","","</tr>");	//�Ļ��̶�
	
	
	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");			//�¼��������
	htmlStr=htmlStr+initTableTdOne("�ѹܷ������ڣ�"+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]),6,"","","<tr>");   	//�ѹܷ�������	
	htmlStr=htmlStr+initTableTdOne("�ù����ڣ�"+$g(data["TubeDate"]),4,"","","</tr>");	//�ù�����
	
	htmlStr=htmlStr+initTableTdOne("�����ˣ�"+getRadioValueById("PipeDiscoverers",data),3,"","","<tr>");	//������
	htmlStr=htmlStr+initTableTdOne("�¼��������໤ʿְ�ƣ�"+getRadioValueById("PipeDutyNurTitle",data),3,"","","");	//�¼��������໤ʿְ��
	htmlStr=htmlStr+initTableTdOne("�������ޣ��꣩��"+$g(data["WallWorkYears"]),4,"","","</tr>");   	//�ϱ��˹�������	

	htmlStr=htmlStr+initTableTr("�������ͣ�"+getRadioValueById("PipeType",data),"10",""); 	//��������
	
	 
	htmlStr=htmlStr+initTableTr("��������״��","10","font-weight:bold;font-size:16px;"); //��������״��
	htmlStr=htmlStr+initTableTdOne("��ʶ״̬��"+getRadioValueById("PipePS-94473",data),3,"","","<tr>");	//��ʶ״̬
	htmlStr=htmlStr+initTableTdOne("����״̬��"+getRadioValueById("PipePS-94474",data),3,"","","");   	//����״̬	
	htmlStr=htmlStr+initTableTdOne("�������"+getRadioValueById("PipePS-94475",data),4,"","","</tr>");	//�����
	
	htmlStr=htmlStr+initTableTr("�ѹ�ԭ��"+getRadioValueById("PipeReason",data),"10","");   	//�ѹ�ԭ��
	htmlStr=htmlStr+initTableTr("�̶�������"+getRadioValueById("PipeFixedMethod",data),"10","");   	//�̶�����
	
	htmlStr=htmlStr+initTableTr("����","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //����
	htmlStr=htmlStr+initTableTr("����������"+getRadioValueById("PipeOther-94512",data),10,"border-top:0px;border-bottom:0px");	//��������
	htmlStr=htmlStr+initTableTr("Լ����ʹ�ã�"+getRadioValueById("PipeOther-94513",data),10,"border-top:0px;border-bottom:0px");   	//Լ����ʹ��	
	htmlStr=htmlStr+initTableTr("�¼�����ǰ�����Ƿ�ʹ����ҩ�"+getRadioValueById("PipeOther-94515",data),10,"border-top:0px;border-bottom:0px");	//�¼�����ǰ�����Ƿ�ʹ����ҩ��
	htmlStr=htmlStr+initTableTr("��·����ʱ������Ա��"+getRadioValueById("PipeOther-94516",data),10,"border-top:0px;border-bottom:0px");	//��·����ʱ������Ա
	htmlStr=htmlStr+initTableTr("���߼����Ƿ�������·�����¼���"+getRadioValueById("PipeOther-94517",data),10,"border-top:0px");	//���߼����Ƿ�������·�����¼�

	
	var pipetakesteps=radioValue("PipeTakeSteps-94533,PipeTakeSteps-94534,PipeTakeSteps-94537",data) //��ȡ��ʩ���ɶ�ѡ��
	var pipetakename=$g(data["PipeTakeSteps-94536-94258"]); //����Լ�� ��������
	if (pipetakename!=""){
		pipetakename="����Լ�飨�������ƣ�"+pipetakename+"��";
	}
	if ((pipetakesteps!="")&&(pipetakename!="")){
		pipetakesteps=pipetakesteps+"��"+pipetakename;
	}
	
	htmlStr=htmlStr+initTableTr("��ȡ��ʩ","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //��ȡ��ʩ
	htmlStr=htmlStr+initTableTr(pipetakesteps,10,"border-top:0px;border-bottom:0px");	//��ȡ��ʩ
	var PipeComplication=radioValue("PipeComplication-94539,PipeComplication-94540",data); //����֢ �� ��
	var ifblood=$g(data["PipeComplication-94540-94541"]); //����֢��Ѫ
	if (ifblood!=""){
		ifblood="��Ѫ"+ifblood+"(ml)";
	}
	var otherlComp=radioValue("PipeComplication-94540-94542,PipeComplication-94540-94543,PipeComplication-94540-94544,PipeComplication-94540-94545,PipeComplication-94540-94546,PipeComplication-94540-94547,PipeComplication-94540-94548",data)
	if (PipeComplication=="��"){
		PipeComplication=otherlComp+"�� "+ifblood;
	}
	htmlStr=htmlStr+initTableTr("����֢","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //����֢
	htmlStr=htmlStr+initTableTr(PipeComplication,10,"border-top:0px;border-bottom:0px");	//����֢
	htmlStr=htmlStr+initTableTr("���浥λ��"+$g(data["RepHospType"]),10,"");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),3,"","","<tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),7,"","","</tr>");	//��ϵ�绰

	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["RepUserName"]),3,"","","<tr>");	//�������
	htmlStr=htmlStr+initTableTdOne("���ְ�ƣ�"+$g(data["RepUserTitle"]),3,"","","");   	//���ְ��	
	htmlStr=htmlStr+initTableTdOne("�������ޣ�"+$g(data["RepUserWorkYears"]),4,"","","</tr>");   	//��������	
	
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	
	htmlStr=htmlStr+initTableTr("�����ʩ","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�����ʩ
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //�����ʩ
	
	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"POHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	
	if(HeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':HeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data);
	}
	if(LocHeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':LocHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		LocHeadNurEvaList=SetLocHeaNurPrintInfo(data);
	}
	if(NurDepEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':NurDepEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		NurDepEvaList=SetNurDepPrintInfo(data);
	}
	htmlStr=htmlStr+HeadNurEvaList+LocHeadNurEvaList+NurDepEvaList;
    htmlStr=htmlStr+"</table>";
    $("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();	
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
/// �����¼����浥��ӡ
function printAccidentData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ

	htmlStr=htmlStr+initTableTdOne("������"+$g(data["DisMedThingPatName"]),3,"","","<tr>");   	//����
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatID"]),3,"","","<tr>");  					//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");	//��������

    htmlStr=htmlStr+initTableTdOne("�Ա�"+$g(data["PatSexinput"]),4,"","","</tr>");   	//�Ա�
	htmlStr=htmlStr+initTableTr("��һ��ϣ�"+$g(data["PatDiag"]),10,"");	//��һ���
	htmlStr=htmlStr+initTableTdOne("������Դ��"+getRadioValueById("PatOrigin",data),6,"","","<tr>");	//������Դ
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["PatAdmDate"]),4,"","","</tr>");  					//��Ժ����

    htmlStr=htmlStr+initTableTdOne("��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]),3,"","","<tr>");   	//��ԺʱADL�÷�
	htmlStr=htmlStr+initTableTdOne("��Ժʱ���������չ�������"+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//���������չ�����
    htmlStr=htmlStr+initTableTdOne("�㻤��Ա��"+getRadioValueById("PatEscort",data),3,"","","<tr>");   	//�㻤��Ա
	htmlStr=htmlStr+initTableTdOne("������"+getRadioValueById("NursingLev",data),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("�Ļ��̶ȣ�"+getRadioValueById("DegreeEducate",data),4,"","","</tr>");	//�Ļ��̶�
	
	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");			//�¼��������
	
	htmlStr=htmlStr+initTableTr("�����¼��������ͣ�"+getRadioValueById("AFType",data),10,"");   	//�����¼���������
	htmlStr=htmlStr+initTableTdOne("�����ص㣺"+getRadioValueById("HappenPlace-label",data),3,"","","<tr>");   	//�����ص�
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),7,"","","</tr>");	//��������

	htmlStr=htmlStr+initTableTdOne("�����ˣ�"+getRadioValueById("DiscoverMan",data),3,"","","<tr>");   	//������
	 htmlStr=htmlStr+initTableTdOne("�������ޣ�"+$g(data["WLManWorkLife"]),3,"","","");   	//��������
	htmlStr=htmlStr+initTableTdOne("�¼��������໤ʿְ�ƣ�"+getRadioValueById("PipeDutyNurTitle",data),4,"","","</tr>");	//�¼��������໤ʿְ��
	var AFResult="";
	var eventresult=radioValue("AFResult-94565,AFResult-94567",data); //�¼���ɵĺ��
	var patHOD=getRadioValueById("AFResult-94566",data); //����סԺ����
	if (eventresult!=""){
		AFResult=AFResult+eventresult+"��";
	}	
	if (patHOD!=""){
		AFResult=AFResult+$g(data["AFResult-94566"])+"��"+patHOD+"����";
	}	
	htmlStr=htmlStr+initTableTr("�¼���ɵĺ����","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //�¼���ɵĺ��
	htmlStr=htmlStr+initTableTr(AFResult,"10","border-top:0px"); //�¼���ɵĺ��
	htmlStr=htmlStr+initTableTr("���浥λ��"+$g(data["RepHospType"]),10,"");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),3,"","","<tr>");   	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),7,"","","</tr>");   	//��������
	
	htmlStr=htmlStr+initTableTr("�¼�������","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	var PatEventProcess="";
	var notice=getRadioValueById("PatEventProcess-95021",data);  //����֪ͨ
	if(notice!=""){
		PatEventProcess=PatEventProcess+"����֪ͨ��"+notice+"����" ;
	}
	if(radioValue("PatEventProcess-95032",data)!=""){
		PatEventProcess=PatEventProcess+radioValue("PatEventProcess-95032",data)+"��" ;
	}
	if($g(data["PatEventProcess-95033"])!=""){
		PatEventProcess=PatEventProcess+"ҽ�ƻ����ʩ��"+$g(data["PatEventProcess-95033"])+"����" ;
	}
	if($g(data["PatEventProcess-95034"])!=""){
		PatEventProcess=PatEventProcess+$g(data["PatEventProcess-95034"]);
	}
	
	htmlStr=htmlStr+initTableTr("���������¼���������","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //���������¼�������
	htmlStr=htmlStr+initTableTr(PatEventProcess,"10","border-top:0px"); //���������¼�������
	
	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"AccidentHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)

	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)

	if(HeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':HeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data,"advAccidentFill");
	}
	if(LocHeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':LocHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		LocHeadNurEvaList=SetLocHeaNurPrintInfo(data);
	}
	if(NurDepEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':NurDepEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		NurDepEvaList=SetNurDepPrintInfo(data);
	}
	
	htmlStr=htmlStr+HeadNurEvaList+LocHeadNurEvaList+NurDepEvaList;
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();	
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
	
}
//��ҩ�����¼����浥
function printadvDrugUseErrData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��ҩ���󱨸浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["DisMedThingPatName"]),3,"","","<tr>") //��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatID"]),3,"","","");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["PatSexinput"]),3,"","","<tr>") //�����Ա�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//������
	htmlStr=htmlStr+initTableTr("��һ��ϣ�"+$g(data["PatDiag"]),"10","border-top:0px"); //��һ���
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["PatAdmDate"]),3,"","","<tr>");				//��Ժ����
	htmlStr=htmlStr+initTableTdOne("������Դ��"+getRadioValueById("PatOrigin",data),7,"","","</tr>");	//������Դ
	htmlStr=htmlStr+initTableTdOne("������"+getRadioValueById("NursingLev",data),3,"","","<tr>");	//������
	htmlStr=htmlStr+initTableTdOne("�Ļ��̶ȣ�"+getRadioValueById("DegreeEducate",data),7,"","","</tr>");	//�Ļ��̶�

	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");			//�¼��������
	htmlStr=htmlStr+initTableTdOne("��ҩ�������ڣ�"+$g(data["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]),6,"","","<tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("�����ص㣺"+getRadioValueById("DrugUseHappenPlace-label",data),4,"","","</tr>");	//�����ص�
	htmlStr=htmlStr+initTableTdOne("���������� ��"+$g(data["PartyName"]),3,"","","<tr>");	//���������� 
	htmlStr=htmlStr+initTableTdOne("�ܼ���"+$g(data["DrugUseErrLevel"]),3,"","","");	//�ܼ�
	htmlStr=htmlStr+initTableTdOne("��Σ�"+$g(data["Shift"]),4,"","","</tr>");	//���
	htmlStr=htmlStr+initTableTdOne("��������ݣ�"+getRadioValueById("DrugUseErrRank",data),3,"","","<tr>");	//���������
	htmlStr=htmlStr+initTableTdOne("������ְ�ƣ�"+getRadioValueById("DrugUsePartyTitle",data),3,"","","");	//������ְ��
	htmlStr=htmlStr+initTableTdOne("�����˹������ޣ��꣩��"+$g(data["DrugUsePartyWorkYears"]),4,"","","</tr>");	//�����˹������ޣ��꣩
	htmlStr=htmlStr+initTableTdOne("������������"+$g(data["WallDiscover"]),3,"","","<tr>");	//����������
	htmlStr=htmlStr+initTableTdOne("��������(��)��"+$g(data["WLManWorkLife"]),7,"","","</tr>");	//��������(��)
	
	htmlStr=htmlStr+initTableTr("��������",10,"font-weight:bold;font-size:16px;"); 	//��������
	htmlStr=htmlStr+initTableTdOne("��ҩʱ�����",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҽ����ҩʱ�� ��"+$g(data["DrugUseErrType-94617-94204"])+"���������ҩʱ�� ��"+$g(data["DrugUseErrType-94617-94205"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("��ҩ;������",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҽ����ҩ;�� ��"+$g(data["DrugUseErrType-94618-94208"])+"���������ҩ;�� ��"+$g(data["DrugUseErrType-94618-94209"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("��©��ҩ��",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("��©���� ��"+$g(data["DrugUseErrType-94619-94212"])+"����ҽ����ҩʱ�� ��"+$g(data["DrugUseErrType-94619-94213"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("��Һ�ٶȴ���",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҩ������ ��"+$g(data["DrugUseErrType-94620-94215"])+"���������ҩ�ٶ� ��"+$g(data["DrugUseErrType-94620-94216"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("��������",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҽ����ҩ���� ��"+$g(data["DrugUseErrType-94621-94219"])+"���������ҩ���� ��"+$g(data["DrugUseErrType-94621-94220"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("���ʹ���",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҽ����ҩ���� ��"+$g(data["DrugUseErrType-94622-94223"])+"���������ҩ���� ��"+$g(data["DrugUseErrType-94622-94224"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("ҩ�����",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("ҽ����ҩ���� ��"+$g(data["DrugUseErrType-94623-94227"])+"���������ҩ���� ��"+$g(data["DrugUseErrType-94623-94228"])+"��",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("��������",2,0,"","<tr>");	
	htmlStr=htmlStr+initTableTdOne(radioValue("DrugUseErrType-94616,DrugUseErrType-94624,DrugUseErrType-94625",data),8,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("ȱ������ĺ����"+getRadioValueById("DrugUseDefectResult-label",data),10,"","");	//������ְ��

	htmlStr=htmlStr+initTableTr("���浥λ��"+$g(data["RepHospType"]),10,"");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),3,"","","<tr>");	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),7,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["RepUserName"]),3,"","","<tr>");	//�������
	htmlStr=htmlStr+initTableTdOne("���ְ�ƣ�"+$g(data["RepUserTitle"]),3,"","","");   	//���ְ��	
	htmlStr=htmlStr+initTableTdOne("��˹������ޣ�"+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//��˹�������
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	htmlStr=htmlStr+initTableTr("�����ʩ","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�����ʩ
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //�����ʩ

	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"DrugHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	
	if(HeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':HeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data);
	}
	if(LocHeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':LocHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		LocHeadNurEvaList=SetLocHeaNurPrintInfo(data);
	}
	if(NurDepEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':NurDepEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		NurDepEvaList=SetNurDepPrintInfo(data);
	}
	htmlStr=htmlStr+HeadNurEvaList+LocHeadNurEvaList+NurDepEvaList;
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})	
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
//����(׹��)�¼����浥html��ӡ
function printAdvFDFillData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����(׹��)�¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["DisMedThingPatName"]),3,"","","<tr>") //��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatID"]),3,"","","");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["PatSexinput"]),3,"","","<tr>") //�����Ա�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//������
	htmlStr=htmlStr+initTableTr("��һ��ϣ�"+$g(data["PatDiag"]),"10","border-top:0px"); //��һ���
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["PatAdmDate"]),3,"","","<tr>");				//��Ժ����
	htmlStr=htmlStr+initTableTdOne("������Դ��"+getRadioValueById("PatOrigin",data),7,"","","</tr>");	//������Դ
	htmlStr=htmlStr+initTableTdOne("��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]),3,"","","<tr>");				//��ԺʱADL�÷�
	htmlStr=htmlStr+initTableTdOne("�����չ�������"+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//�����չ�����
	htmlStr=htmlStr+initTableTdOne("�㻤��Ա��"+getRadioValueById("PatEscort",data),6,"","","<tr>");	//�㻤��Ա
	htmlStr=htmlStr+initTableTdOne("������"+getRadioValueById("NursingLev",data),4,"","","</tr>");	//������
	
	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");			//�¼��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),3,"","","<tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+getRadioValueById("FallDownType",data),3,"","","");	//��������
	htmlStr=htmlStr+initTableTdOne("�����ص㣺"+getRadioValueById("HappenPlace-label",data),4,"","","</tr>");	//�����ص�
	htmlStr=htmlStr+initTableTr("����/׹����ָ����������κβ�λ��������˫�ţ����ⴥ�����棩ʱ���ߵ�״̬��"+getRadioValueById("FDPatState",data),10,"");				//��������
	htmlStr=htmlStr+initTableTr("���˲�λ��"+$g(data["JuredPart"]),10,"");	//���˲�λ
	
	var ReasonStr=getRadioById(RepID,"OccurReason")
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var OccurReason="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				OccurReason=OccurReason+"  "+j+"��"+"�������أ�"+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("��")==-1){
				if(ReasonArr[1]!=""){
			 		OccurReason=OccurReason+"  "+j+"��"+ReasonArr[0]+"��"+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	OccurReason=OccurReason+"  "+j+"��"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("����ԭ��","10","border-bottom:0px;font-weight:bold;font-size:16px;")		//����ԭ��
	htmlStr=htmlStr+initTableTr(OccurReason,"10","border-top:0px")		//����ԭ��

	htmlStr=htmlStr+initTableTdOne("�����ˣ�"+getRadioValueById("DiscoverMan",data),3,"","","<tr>");	//������
	htmlStr=htmlStr+initTableTdOne("�¼��������໤ʿְ�ƣ�"+getRadioValueById("PipeDutyNurTitle",data),3,"","","");	//�¼��������໤ʿְ��
	htmlStr=htmlStr+initTableTdOne("��������(��)��"+$g(data["WLManWorkLife"]),4,"","","</tr>");	//��������(��)
	var eventresult=radioValue("FDResult-95131,FDResult-95134,FDResult-94245",data); //�¼���ɵĺ��
	var patHOD=radioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); //����סԺ����
	if (patHOD!=""){
		eventresult=$g(data["FDResult-95132"])+"��"+patHOD+"��"+"�� "+eventresult;
	}	
	htmlStr=htmlStr+initTableTr("����/׹���¼���ɵĽ����"+eventresult,"10","");	//����/׹���¼���ɵĽ��
	htmlStr=htmlStr+initTableTr("�˺����س̶ȣ�"+getRadioValueById("FDResult-label",data),"10","");	//�˺����س̶�

	htmlStr=htmlStr+initTableTr("���浥λ��"+$g(data["RepHospType"]),10,"");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),3,"","","<tr>");	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),7,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["RepUserName"]),3,"","","<tr>");	//�������
	htmlStr=htmlStr+initTableTdOne("���ְ�ƣ�"+$g(data["RepUserTitle"]),3,"","","");	//���ְ��
	htmlStr=htmlStr+initTableTdOne("��˹������ޣ�"+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//��˹�������
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //����֪ͨ
	var deal=radioValue("PatEventProcess-95032,PatEventProcess-95034",data); //���������¼�������
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"��"+notice+"���� "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"��ҽ�ƻ����ʩ��"+$g(data["PatEventProcess-95033"])+"��"
	}
	htmlStr=htmlStr+initTableTr("���������¼���������","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //���������¼�������
	htmlStr=htmlStr+initTableTr(deal,"10","border-top:0px"); //���������¼�������
	
	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="";	 
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"FDHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	
	if(HeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':HeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data);
	}
	if(LocHeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':LocHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		LocHeadNurEvaList=SetLocHeaNurPrintInfo(data);
	}
	if(NurDepEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':NurDepEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		NurDepEvaList=SetNurDepPrintInfo(data);
	}
	htmlStr=htmlStr+HeadNurEvaList+LocHeadNurEvaList+NurDepEvaList;
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
//ѹ�����浥html��ӡ
function printAdvSkinUlcerData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ѹ�����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["DisMedThingPatName"]),3,"","","<tr>") //��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatID"]),3,"","","");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["PatSexinput"]),3,"","","<tr>") //�����Ա�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//������
	htmlStr=htmlStr+initTableTr("��һ��ϣ�"+$g(data["PatDiag"]),"10",""); //��һ���
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["PatAdmDate"]),6,"","","<tr>");				//��Ժ����
	htmlStr=htmlStr+initTableTdOne("������Դ��"+getRadioValueById("PatOrigin",data),4,"","","</tr>");	//������Դ
	htmlStr=htmlStr+initTableTdOne("��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]),3,"","","<tr>");				//��ԺʱADL�÷�
	htmlStr=htmlStr+initTableTdOne("�����չ�������"+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//�����չ�����
	htmlStr=htmlStr+initTableTdOne("�㻤��Ա��"+getRadioValueById("PatEscort",data),6,"","","<tr>");	//�㻤��Ա
	htmlStr=htmlStr+initTableTdOne("������"+getRadioValueById("NursingLev",data),4,"","","</tr>");	//������
	htmlStr=htmlStr+initTableTr("ʹ��ѹ���������ֱ�"+getRadioValueById("UseUlcerRiskpointtab",data),10,"");				//ʹ��ѹ���������ֱ�
	htmlStr=htmlStr+initTableTdOne("��Ժѹ���������֣�"+$g(data["HospUlcerRiskScore"]),6,"","","<tr>");	//��Ժѹ����������
	htmlStr=htmlStr+initTableTdOne("ѹ�����յȼ���"+getRadioValueById("HospUlcerRiskLev",data),4,"","","</tr>");	//ѹ�����յȼ�
	htmlStr=htmlStr+initTableTdOne("����ѹ��ʱ�������֣�"+$g(data["OccurUlcerRiskScore"]),6,"","","<tr>");	//����ѹ��ʱ��������
	htmlStr=htmlStr+initTableTdOne("ѹ�����յȼ���"+getRadioValueById("OccurUlcerRiskLev",data),4,"","","</tr>");	//ѹ�����յȼ�
	htmlStr=htmlStr+initTableTdOne("�Ļ��̶ȣ�"+getRadioValueById("DegreeEducate",data),6,"","","<tr>");				//�Ļ��̶�
	htmlStr=htmlStr+initTableTdOne("����(Сʱ)��"+$g(data["OpeDuration"]),4,"","","</tr>");	//����(Сʱ)
	
	//htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;");			//�¼��������
	htmlStr=htmlStr+initTableTr("ѹ����λ��Ϣ","10","font-weight:bold;font-size:16px;");
	var UlcerPartlist=$g(data["UlcerPart"]);//ѹ����λ
	
	//var SuspectNewDrugList=$g(data["SuspectNewDrug"]);  //����ҩƷ�б�
   	if(UlcerPartlist!=""){//value,colspan,rowspan,valueCss,tr
   		htmlStr=htmlStr+initTableTdOne("��������","2","","background-color:#808080;width:20%;","<tr>");
		htmlStr=htmlStr+initTableTdOne("��Դ","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("��λ","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("����","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("��cm*��cm*��cm","2","","background-color:#808080","</tr>");

	   	$(UlcerPartlist).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["UlcerPart-95158-95162-95192"]),"2","","width:20%;","<tr>");
			var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",obj); //��Դ
			var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",obj); //Ժ�����
			if (orignout!=""){orign=orign+"��"+orignout+"��";}
			htmlStr=htmlStr+initTableTdOne(orign+" "+orignout,"2","","width:20%;","");
			//var UlcerPart=getRadioValueById("UlcerPart-95158-95166",obj);
			var part=""
			var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",obj); //��λ
			if (qtpart!=""){part=qtpart+"�� "+part; }
			var ekpart=checksubValue($g(obj["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",obj); //����
			if (ekpart!=""){part=ekpart+"�� "+part; }
			var jjpart=checksubValue($g(obj["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",obj); //���β�
			if (jjpart!=""){part=jjpart+"�� "+part; }
			var zbpart=checksubValue($g(obj["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",obj); //�ⲿ
			if (zbpart!=""){part=zbpart+"�� "+part; }
			var qqsjpart=checksubValue($g(obj["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95176-94181,UlcerPart-95158-95166-95176-94182",obj); //��ǰ�ϼ�
			if (qqsjpart!=""){part=qqsjpart+"�� "+part; }
			var kbpart=checksubValue($g(obj["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",obj); //�Ų�
			if (kbpart!=""){part=kbpart+"�� "+part; }
			var xbpart=checksubValue($g(obj["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",obj); //ϥ��
			if (xbpart!=""){part=xbpart+"�� "+part; }
			var hbpart=checksubValue($g(obj["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",obj); //�ײ�
			if (hbpart!=""){part=hbpart+"�� "+part; }
			var zgbpart=checksubValue($g(obj["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",obj); //�����
			if (zgbpart!=""){part=zgbpart+"�� "+part; }
			htmlStr=htmlStr+initTableTdOne(part,"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne(getRadioValueById("UlcerPart-95158-95169",obj),"2","","width:20%;","");
			
			var cmlistl=$g(obj["UlcerPart-95158-95189-94247"]),cmlistw=$g(obj["UlcerPart-95158-95189-94249"]),cmlists=$g(obj["UlcerPart-95158-95189-94251"]);
			if(cmlistl==""){
				cmlistl=0;
			}
			if(cmlistw==""){
				cmlistw=0;
			}
			if(cmlists==""){
				cmlists=0;
			}
			
			htmlStr=htmlStr+initTableTdOne(cmlistl+"��"+cmlistw+"��"+cmlists,"2","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û��ѹ����λ��Ϣ","10","");
	}
	
	htmlStr=htmlStr+initTableTr("ѹ������ԭ��","10","font-weight:bold;font-size:16px;border-bottom:0px");
	htmlStr=htmlStr+initTableTr("�������أ�"+getRadioValueById("UlcerOccurReason-94948",data),"10","border-bottom:0px;border-top:0px");				//��������
	htmlStr=htmlStr+initTableTr("�������أ�"+getRadioValueById("UlcerOccurReason-94949",data),"10","border-bottom:0px;border-top:0px");	//��������
	htmlStr=htmlStr+initTableTr("������Ա���أ�"+getRadioValueById("UlcerOccurReason-94950",data),"10","border-bottom:0px;border-top:0px");	//������Ա����
	htmlStr=htmlStr+initTableTr("�������أ�"+getRadioValueById("UlcerOccurReason-94951",data),"10","border-top:0px");	//��������
	
	htmlStr=htmlStr+initTableTr("�¼����","10","font-weight:bold;font-size:16px;");			//�¼����
	htmlStr=htmlStr+initTableTr("�Ѳ�ȡ�����ʩ��"+getRadioValueById("AdoptNursMeasure",data),"10","");
	htmlStr=htmlStr+initTableTr("���浥λ��"+$g(data["RepHospType"]),10,"");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),3,"","","<tr>");	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),7,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["RepUserName"]),3,"","","<tr>");	//�������
	htmlStr=htmlStr+initTableTdOne("���ְ�ƣ�"+$g(data["RepUserTitle"]),3,"","","");	//���ְ��
	htmlStr=htmlStr+initTableTdOne("��˹������ޣ�"+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//��˹�������
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	htmlStr=htmlStr+initTableTr("�����ʩ���˿ڻ�ҩ��","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�����ʩ
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //�����ʩ
	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="",OutHeadNurEvaRecId="";
	//Ժ��ѹ����ʿ������
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"UlcerHeaNurEvaluate"},
	function(data){ 
			 HeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"LocHeaNurEvaluate"},
	function(data){ 
			 LocHeadNurEvaRecId=data
	},"text",false)
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"NurDepEvaluate"},
	function(data){ 
			 NurDepEvaRecId=data
	},"text",false)
	//Ժ��ѹ����ʿ������
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"UlcOutHeaNurEvaluate"},
	function(data){ 
			 OutHeadNurEvaRecId=data
	},"text",false)
	if((HeadNurEvaRecId!="")&&(orign=="Ժ�ڷ���")){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':HeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data);
	}
	if(LocHeadNurEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':LocHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		LocHeadNurEvaList=SetLocHeaNurPrintInfo(data);
	}
	if(NurDepEvaRecId!=""){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':NurDepEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		NurDepEvaList=SetNurDepPrintInfo(data);
	}
	//Ժ��ѹ��
	if((OutHeadNurEvaRecId!="")&&(orign.indexOf("Ժ�����")>=0)){
		var data="" ;
		runClassMethod("web.DHCADVCOMMONPRINT","GetPrintDataList",
			{'ADVFormRecDr':OutHeadNurEvaRecId},
			function(datalist){ 
				 data=datalist
		},"json",false)
		HeadNurEvaList=HeadNurPrintInfo(data,orign);
	}
	htmlStr=htmlStr+HeadNurEvaList+LocHeadNurEvaList+NurDepEvaList;
		
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
//һ����ҽ����Ʒ�����¼����浥
function printAdvDisMedData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("һ����ҽ����Ʒ�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("����һ������","10","font-weight:bold;font-size:16px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["DisMedThingPatName"]),3,"","","<tr>") //��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatID"]),3,"","","");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccuLoc"]),4,"","","</tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["PatSexinput"]),3,"","","<tr>") //�����Ա�
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");   	//��������
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//������
	
	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");			//�¼��������
	htmlStr=htmlStr+initTableTr("�¼��������ڣ�"+$g(data["DisMedThingHappenDate"]),"10","");			//�¼���������
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //�¼�����
	htmlStr=htmlStr+initTableTdOne("ҽ����е�������ƣ�"+$g(data["DisMedThingMdType"]),3,"","","<tr>");	//ҽ����е��������
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ƣ�"+$g(data["DisMedThingGoodName"]),3,"","","");	//��Ʒ����
	htmlStr=htmlStr+initTableTdOne("ע��֤�ţ�"+$g(data["DisMedThingRegNumber"]),4,"","","</tr>");	//ע��֤��

	htmlStr=htmlStr+initTableTdOne("������ҵ���ƣ�"+$g(data["DisMedThingREnterpriseName"]),3,"","","<tr>");	//������ҵ����
	htmlStr=htmlStr+initTableTdOne("��ַ��"+$g(data["DisMedThingAddress"]),3,"","","");	//��ַ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),4,"","","</tr>");	//��ϵ�绰

	htmlStr=htmlStr+initTableTdOne("�ͺŹ��"+$g(data["DisMedThingModelSpecification"]),3,"","","<tr>");	//�ͺŹ��
	htmlStr=htmlStr+initTableTdOne("��Ʒ��ţ�"+$g(data["DisMedThingCode"]),3,"","","");	//��Ʒ���
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ţ�"+$g(data["DisMedThingProductNummber"]),4,"","","</tr>");	//��Ʒ����

	htmlStr=htmlStr+initTableTdOne("��Ч������"+$g(data["DisMedThingPeriodValidity"]),3,"","","<tr>");	//��Ч����
	htmlStr=htmlStr+initTableTdOne("ͣ�����ڣ�"+$g(data["DisMedThingDeactivateDate"]),3,"","","");	//ͣ������
	htmlStr=htmlStr+initTableTdOne("ֲ�����ڣ���ֲ�룩��"+$g(data["DisMedThingImlantDate"]),4,"","","</tr>");	//ֲ������
	
	htmlStr=htmlStr+initTableTr("�¼�����ԭ�����","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼�����ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingEventCauseAnaly"]),"10","border-top:0px"); //�¼�����ԭ�����
	htmlStr=htmlStr+initTableTr("�¼��������","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //�¼��������
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingEventResult"]),"10","border-top:0px"); //�¼��������
	
	htmlStr=htmlStr+initTableTr("�¼�����״̬��"+getRadioValueById("DisMedThingEventReportStatue",data),"10","");	//�¼�����״̬
	htmlStr=htmlStr+initTableTr("��ʾ","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //��ʾ
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingCaution"]),"10","border-top:0px"); //��ʾ

	htmlStr=htmlStr+initTableTr("��������ίԱ�᣺","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //��������ίԱ��
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingQMC"]),"10","border-top:0px"); //��������ίԱ��
	htmlStr=htmlStr+initTableTdOne("�����ˣ�ǩ������"+$g(data["DisMedThingEventUserOfReport"]),3,"","","<tr>");	//�����ˣ�ǩ����
	htmlStr=htmlStr+initTableTdOne("������ң�"+$g(data["DisMedThingDept"]),3,"","","");	//�������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTr("��ע","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //��ע
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingRepRemark"]),"10","border-top:0px"); //��ע


	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
//��е�����¼�
function printAdvDevicebyData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��е�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),4,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),6,"","","","</tr>");  //�ϱ�ʱ��

	htmlStr=htmlStr+initTableTr("������Դ :"+getRadioValueById("MedRepSource",data),10,"");   //������Դ
	htmlStr=htmlStr+initTableTr("��ϵ��ַ :"+$g(data["PatContactAddr"]),10,"");			 //��ϵ��ַ
	htmlStr=htmlStr+initTableTr("�ʱ� :"+$g(data["PatPostCode"]),10,""); 		 //�ʱ�

	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");						//���߻�����Ϣ

	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");  					//����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");			//��������
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//�Ա�
	
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["AgeType"]),3,"","","<tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["PatDOB"]),3,"","","");						//��������
	htmlStr=htmlStr+initTableTdOne("�绰��"+$g(data["MedNewRepTel"]),4,"","","</tr>");				//�绰
	htmlStr=htmlStr+initTableTr("Ԥ�����Ƽ���������","10","border-bottom:0px"); //Ԥ�����Ƽ���������
	htmlStr=htmlStr+initTableTr($g(data["MDProspectiveNewTreat"]),"10","border-top:0px"); //Ԥ�����Ƽ���������

	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");		//�¼�������Ϣ
	htmlStr=htmlStr+initTableTr("�¼���Ҫ����","10","");							//�¼���Ҫ����
	
	htmlStr=htmlStr+initTableTdOne("��е���ϣ�"+$g(data["EquipmentFailure"]),3,"","","<tr>");  		//��е����
	htmlStr=htmlStr+initTableTdOne("��Ҫ�˺���"+$g(data["MainDamage"]),3,"","","");  				//��Ҫ�˺�
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),4,"","","</tr>");  			//��������
	
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),6,"","","<tr>");  		//�ϱ���������
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),4,"","","</tr>");  			//�ϱ���ְ��
	
	htmlStr=htmlStr+initTableTr("�����¼��ĵȼ���"+getRadioValueById("EventRepLevel",data),"10","")	//�����¼��ĵȼ�
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"]),6,"","","<tr>");  			//�������� 
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["FindDate"]),4,"","","");  					//��������
	htmlStr=htmlStr+initTableTr("ҽ����еʵ��ʹ�ó�����"+getRadioValueById("MedDevicesPlace",data),"10","");  //ҽ����еʵ��ʹ�ó���
	var MedNewEventResult=getRadioValueById("MedNewEventResult",data)
	var dietime=$g(data["MedNewEventResult-97739-97915"])
	if(dietime!=""){
		MedNewEventResult=MedNewEventResult+" ����ʱ�䣺"+dietime
		}
	htmlStr=htmlStr+initTableTr("�¼������"+MedNewEventResult,"10","")	//�¼����
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px;"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["MdEventStatement"]),"10","border-top:0px"); //�¼�����

	htmlStr=htmlStr+initTableTr("ҽ����е���","10","font-weight:bold;font-size:16px;");			//ҽ����е���
	htmlStr=htmlStr+initTableTr("ҽ����е��Ϣ",10,"")				//ҽ����е��Ϣ
	
	htmlStr=htmlStr+initTableTdOne("ע��֤�ţ�"+$g(data["MDRegistrationNo"]),6,"","","<tr>");  		//ע��֤��
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ƣ�"+$g(data["MDProductNewName"]),4,"","","</tr>");  			//��Ʒ����
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ƣ�"+$g(data["MDCommodityNewName"]),6,"","","<tr>");  		//��Ʒ����
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ࣺ"+$g(data["MDRProductClassify"]),4,"","","</tr>");  	//��Ʒ����
	
	htmlStr=htmlStr+initTableTr("��Ʒ��Ϣ",10,"");  		//��Ʒ��Ϣ
	htmlStr=htmlStr+initTableTdOne("��ҵ���ƣ�"+$g(data["MDEnterpriseNameBy "]),6,"","","<tr>");  			//��ҵ����
	htmlStr=htmlStr+initTableTdOne("��ҵ��ַ��"+$g(data["MDREnterpriseAddressBy "]),4,"","","</tr>");  		//��ҵ��ַ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["MDEnterpriseRelateTelephone "]),6,"","","<tr>");  	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("����ͺţ�"+$g(data["MDlSpecificationMode"]),4,"","","</tr>");  		//����ͺ�
	htmlStr=htmlStr+initTableTdOne("��Ʒ��ţ�"+$g(data["DisMedCode"]),6,"","","<tr>");  		//��Ʒ���
	htmlStr=htmlStr+initTableTdOne("��Ʒ���ţ��Ĳıر�����"+$g(data["MDProductBatchNo"]),4,"","","</tr>");  	//��Ʒ���ţ��Ĳıر���
	htmlStr=htmlStr+initTableTr("�����ˣ�"+getRadioValueById("MedOperator",data),"10","")	//�¼����
	
	htmlStr=htmlStr+initTableTr("����",10,"");  		//��Ʒ��Ϣ
	htmlStr=htmlStr+initTableTdOne("��Ч������"+$g(data["MedAllDate-97761"]),6,"","","<tr>");  				//��Ч���� 
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["MedAllDate-97762"]),4,"","","</tr>");  		//�������� 
	htmlStr=htmlStr+initTableTdOne("ͣ�����ڣ�"+$g(data["MedAllDate-97763"]),6,"","","<tr>");  			//ͣ������
	htmlStr=htmlStr+initTableTdOne("ֲ�����ڣ�"+$g(data["MedAllDate-97764"]),4,"","","</tr>");  		//ֲ������
	htmlStr=htmlStr+initTableTr("�¼���������ԭ�����","10","border-bottom:0px"); //�¼���������ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["MedEventInfomation-97800"]),"10","border-top:0px"); //�¼���������ԭ�����
	htmlStr=htmlStr+initTableTr("�¼������������","10","border-bottom:0px"); //�¼������������
	htmlStr=htmlStr+initTableTr($g(data["MedEventInfomation-97802"]),"10","border-top:0px"); //�¼������������
	htmlStr=htmlStr+initTableTr("�¼�����״̬��"+getRadioValueById("MDNewEventReportStatue",data),"10","")	//�¼�����״̬
	htmlStr=htmlStr+initTableTr("�����¼�����","10","font-weight:bold;");			//�����¼�����
	htmlStr=htmlStr+initTableTr("ʡ����⼼�������������","10","border-bottom:0px"); //ʡ����⼼�������������
	htmlStr=htmlStr+initTableTr($g(data["MDProvincialEvaluationOpinion"]),"10","border-top:0px"); //ʡ����⼼�������������
	htmlStr=htmlStr+initTableTr("���Ҽ�⼼�������������","10","border-bottom:0px"); //���Ҽ�⼼�������������
	htmlStr=htmlStr+initTableTr($g(data["MDCountryEvaluationOpinion"]),"10","border-top:0px"); //���Ҽ�⼼�������������

	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
	}
//��Ѫ�����¼���ӡ
function printAdvBloodbyData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��Ѫ�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),3,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),7,"","","","</tr>");  //�ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ
	
	htmlStr=htmlStr+initTableTr("������Դ��"+getRadioValueById("PatOrigin",data),10,"");	//������Դ	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatNo"]),2,"","","<tr>");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatNo"]),3,"","","<tr>");				//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");			//������
	htmlStr=htmlStr+initTableTdOne("סԺ������"+$g(data["HospTimes"]),4,"","","</tr>");    //סԺ����
	
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");  					//����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["MedNewRepPatAge"]),3,"","","");			//��������
	htmlStr=htmlStr+initTableTdOne("���壺"+$g(data["PatNational"]),4,"","","</tr>");					//����
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),3,"","","<tr>");	//�Ա�
	htmlStr=htmlStr+initTableTdOne("�У�"+getRadioValueById("isPregnancy",data),3,"","","");//��
	htmlStr=htmlStr+initTableTdOne("���"+getRadioValueById("isMarry",data),4,"","","</tr>");		//���
	htmlStr=htmlStr+initTableTdOne("����"+getRadioValueById("isGive",data),3,"","","<tr>");			//��
	htmlStr=htmlStr+initTableTdOne("����ҽʦ��"+$g(data["Physician"]),7,"","","</tr>");			//����ҽʦ

	htmlStr=htmlStr+initTableTdOne("��Ժ/������ң�"+$g(data["InOrOutHospLoc"]),6,"","","<tr>");	//��Ժ/�������
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["LeavHospTime"]),4,"","","</tr>");				//��Ժ����
	htmlStr=htmlStr+initTableTdOne("��Ժ/�������ڣ�"+$g(data["InOrOutHospDate"]),6,"","","<tr>");		//��Ժ/��������
	htmlStr=htmlStr+initTableTdOne("��λ�ţ�"+$g(data["AdmBedNum"]),4,"","","</tr>");					//��λ��
	
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["AgeType"]),3,"","","<tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("����ְ��"+$g(data["AdmOfficeRank"]),3,"","","");				//����ְ��
	htmlStr=htmlStr+initTableTdOne("ҽ�����"+$g(data["MedicalCategory"]),4,"","","</tr>");			//ҽ�����
	htmlStr=htmlStr+initTableTdOne("Ѫ��(ABO)��"+$g(data["BloodType"]),3,"","","<tr>");			//Ѫ��(ABO)
	
	htmlStr=htmlStr+initTableTdOne("Rh(D)��"+$g(data["Rh(D)by"]),3,"","","");					//Rh(D)
	htmlStr=htmlStr+initTableTdOne("��������ɸ�飺"+$g(data["errAntibo"]),4,"","","</tr>");			//��������ɸ��
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["Disease"]),10,"");		//���
	
	htmlStr=htmlStr+initTableTr("��Ѫ�б�","10","font-weight:bold;font-size:16px;");			//��Ѫ�б�
	var SuspectNewDrugList=$g(data["BloodGiveList"]);  //��Ѫ�б�
   	if(SuspectNewDrugList!=""){
   		htmlStr=htmlStr+initTableTd("��Ѫ��Ż���������","ѪҺ�ɷ�(Ʒ��)","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("Ѫ��(ABO)","Rh(D)","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("Ѫ��(U/������)","��Ѫ��ʼʱ��","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTdOne("��Ѫ����ʱ��",2,"","background-color:#808080","</tr>");	
	   	$(SuspectNewDrugList).each(function(index,obj){
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97703-97710"]),$g(obj["BloodGiveList-97701-97704-97711"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97705-97712"]),$g(obj["BloodGiveList-97701-97706-97713"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97707-97714"]),$g(obj["BloodGiveList-97701-97708-97715"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTdOne($g(obj["BloodGiveList-97701-97709-97716"]),2,"","","</tr>");	

	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û����Ѫ�б�","10","");
	   	
	   	}
	
  	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");								//�¼�������Ϣ
	htmlStr=htmlStr+initTableTdOne("�������� ��"+$g(data["HappenTime"]),3,"","","<tr>");				//�������� 
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),7,"","","</tr>");				//�ϱ���������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),3,"","","<tr>");						//��������
	htmlStr=htmlStr+initTableTdOne("������Ѫʷ��"+getRadioValueById("BloodtransfusionHistory-label",data),7,"","","</tr>");				//������Ѫʷ
	
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),3,"","","<tr>");							//�ϱ���ְ��
	htmlStr=htmlStr+initTableTdOne("�����¼��ּ���"+getRadioValueById("DruPOEventLevel",data),7,"","","</tr>");				//�����¼��ּ�
	htmlStr=htmlStr+initTableTdOne("��Ѫ������Ӧ��"+getRadioValueById("AdvBloodsereactions",data),3,"","","<tr>");			//��Ѫ������Ӧ
	htmlStr=htmlStr+initTableTdOne("��Ѫ������Ӧʱ�䣺"+$g(data["AdvBloodSereaOccTime"]),7,"","","</tr>");			  	//��Ѫ������Ӧʱ��

	var BloodForTemperatureChange="��Ѫǰ�����±仯�������Ѫǰ��T(��C):"+$g(data["BloodForTemperatureChange-label-97460"])+",��Ѫ��T(��C):"+$g(data["BloodForTemperatureChange-label-97461"]) 
	htmlStr=htmlStr+initTableTr(BloodForTemperatureChange,10,"");							//��Ѫǰ�����±仯���
	htmlStr=htmlStr+initTableTr("��Ѫ������Ӧ֢״","10","border-bottom:0px"); //��Ѫ������Ӧ֢״
	htmlStr=htmlStr+initTableTr(getRadioValueById("AdvBloodSymptom-label",data)+","+$g(data["AdvBloodSymptom"]),"10","border-top:0px"); //��Ѫ������Ӧ֢״
	
	htmlStr=htmlStr+initTableTr("���ƴ�ʩ�����","10","border-bottom:0px"); //���ƴ�ʩ�����
	htmlStr=htmlStr+initTableTr($g(data["TreatmentPlan"]),"10","border-top:0px"); //���ƴ�ʩ�����

	htmlStr=htmlStr+initTableTr("����","10","border-bottom:0px"); //����
	htmlStr=htmlStr+initTableTr($g(data["Other"]),"10","border-top:0px"); //����

	htmlStr=htmlStr+initTableTr("�����¼��ĵȼ���"+getRadioValueById("EventRepLevel",data),10,"");   //�����¼��ĵȼ�
	
	htmlStr=htmlStr+initTableTr("��Ѫ�ƣ�Ѫ�⣩���������","10","font-weight:bold;font-size:16px;");  //��Ѫ�ƣ�Ѫ�⣩���������
	htmlStr=htmlStr+initTableTr("���鹩Ѫ�߼�����ABOѪ��(��������)���,��Ѫ�ߣ�"+$g(data["BloodTypeResult-97617"])+",��Ѫ��"+$g(data["BloodTypeResult-97618"]),10,"");   //���鹩Ѫ�߼�����ABOѪ��(��������)���
	htmlStr=htmlStr+initTableTr("���鹩Ѫ�߼�����RHDѪ�ͽ��,��Ѫ�ߣ�"+$g(data["BloodRHDTypeResult-97620"])+",��Ѫ��"+$g(data["BloodRHDTypeResult-97621"]),10,"");   //���鹩Ѫ�߼�����RHDѪ�ͽ��
	htmlStr=htmlStr+initTableTr("��������ɸ���ֱ�ӿ�����Ѫ��������,��Ѫ�ߣ�"+$g(data["BloodIrregularResult-97623"])+",��Ѫ��"+$g(data["BloodIrregularResult-97624"]),10,"");   //��������ɸ���ֱ�ӿ�����Ѫ��������
	htmlStr=htmlStr+initTableTr("�ظ�������Ѫʵ��,������"+$g(data["BloodRepeatRepeat-97628"])+",���"+$g(data["BloodRepeatRepeat-97630"]),10,"");   //�ظ�������Ѫʵ��	
	htmlStr=htmlStr+initTableTr("���۹۲�ѪҺ����������飬��Ѫ����Ƚ��","10","border-bottom:0px"); //���۹۲�ѪҺ����������飬��Ѫ����Ƚ��
	htmlStr=htmlStr+initTableTr($g(data["BloodAdviceResurt"]),"10","border-top:0px"); //���۹۲�ѪҺ����������飬��Ѫ����Ƚ��
	htmlStr=htmlStr+initTableTr("����","10","border-bottom:0px"); //����
	htmlStr=htmlStr+initTableTr($g(data["BloodAdviceOther"]),"10","border-top:0px"); //����
	
	htmlStr=htmlStr+initTableTr("Ѫվ���������","10","font-weight:bold;font-size:16px;"); 				//Ѫվ���������
	htmlStr=htmlStr+initTableTr("�������","10","border-bottom:0px"); //�������
	htmlStr=htmlStr+initTableTr($g(data["BloodWorkDealadviceDeil"]),"10","border-top:0px"); //�������
	htmlStr=htmlStr+initTableTdOne("���ʱ�䣺"+$g(data["BloodCreateDate"]),6,"","","<tr>");				//���ʱ��
	htmlStr=htmlStr+initTableTdOne("����ˣ�"+$g(data["BloodCreateCreator"]),4,"","","</tr>");				//�����
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
	}

//ҩƷ�����¼���ӡ
function printAdvdrugData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҩƷ�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),3,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),7,"","","","</tr>");  //�ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ
	htmlStr=htmlStr+initTableTr("������Դ��"+getRadioValueById("PatOrigin",data),"10","");			//������Դ
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatNo"]),3,"","","<tr>");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	//������

	htmlStr=htmlStr+initTableTdOne("���壺"+$g(data["PatNational"]),4,"","","</tr>");	//����

	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");  					//����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["MedNewRepPatAge"]),3,"","","");	//��������
	
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["PatDOB"]),4,"","","</tr>");				//��������

	htmlStr=htmlStr+initTableTdOne("�������أ�"+$g(data["PatWeight"]),3,"","","<tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("�绰��"+$g(data["MedNewRepTel"]),3,"","","");				//�绰
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//�Ա�
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["Disease"]),"10","");	//���

	htmlStr=htmlStr+initTableTr("����ҩƷ������Ӧ/�¼���"+getRadioValueById("EventNewHistory-label",data),"10","");	//����ҩƷ������Ӧ/�¼�
	htmlStr=htmlStr+initTableTr("����ҩƷ������Ӧ/�¼���"+getRadioValueById("EventNewFamily",data),"10","");				//����ҩƷ������Ӧ/�¼�
	htmlStr=htmlStr+initTableTr("�����Ҫ��Ϣ��"+getRadioValueById("ImpInfoNewData",data),"10","");				//����ҩƷ������Ӧ/�¼�

	//htmlStr=htmlStr+initTableTr("�����Ҫ��Ϣ��"+getRadioValueById("ImpInfoNewData",data),"10","");		//�¼�������Ϣ

	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");		//�¼�������Ϣ

	htmlStr=htmlStr+initTableTdOne("�״�/���ٱ��棺"+getRadioValueById("FirstOrAfterRep",data),3,"","","<tr>");	//�״�/���ٱ���
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+getRadioValueById("RepNewType",data),3,"","","");				//��������
	htmlStr=htmlStr+initTableTdOne("���浥λ���"+getRadioValueById("RepUnitType",data),4,"","","</tr>");	//���浥λ���


	var SuspectNewDrugList=$g(data["SuspectNewDrug"]);  //����ҩƷ�б�
	var BlendNewDrugList=$g(data["BlendNewDrug"]); 		 //����ҩƷ�б� 
   	if(SuspectNewDrugList!=""){
   		htmlStr=htmlStr+initTableTd("ҩƷ","��׼�ĺ�","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("��Ʒ����","ͨ������","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("��������","��������","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("�÷�����","��ʼʱ��","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("����ʱ��","��ҩԭ��","0","0","background-color:#808080;width:10%;","background-color:#808080","</tr>");

	   	$(SuspectNewDrugList).each(function(index,obj){
		htmlStr=htmlStr+initTableTd("����ҩƷ",$g(obj["SuspectNewDrug-96649"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96650"]),$g(obj["SuspectNewDrug-96651"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96652"]),$g(obj["SuspectNewDrug-96653"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96654"]),$g(obj["SuspectNewDrug-96655"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96656"]),$g(obj["SuspectNewDrug-96657"]),"0","0","width:10%;","","</tr>");

	//var SuspectDrugList=""+"^"+$g(obj["SuspectNewDrug-96649"])+"^"+$g(obj["SuspectNewDrug-96650"])+"^"+$g(obj["SuspectNewDrug-96651"])+"^"+$g(obj["SuspectNewDrug-96652"])+"^"+$g(obj["SuspectNewDrug-96653"])+"^"+$g(obj["SuspectNewDrug-96654"])+"^"+$g(obj["SuspectNewDrug-96655"])+"^"+$g(obj["SuspectNewDrug-96656"])+"^"+$g(obj["SuspectNewDrug-96657"])
	//htmlStr=htmlStr+initTableTdmor(SuspectDrugList,"")
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�л���ҩƷ","10","");
	   	
	   	}
   	if(BlendNewDrugList!=""){
	   	htmlStr=htmlStr+initTableTd("ҩƷ","��׼�ĺ�","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("��Ʒ����","ͨ������","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("��������","��������","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("�÷�����","��ʼʱ��","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("����ʱ��","��ҩԭ��","0","0","background-color:#808080;width:10%;","background-color:#808080","</tr>");

	   	$(BlendNewDrugList).each(function(index,obj){

		htmlStr=htmlStr+initTableTd("����ҩƷ",$g(obj["BlendNewDrug-96674"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96675"]),$g(obj["BlendNewDrug-96676"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96677"]),$g(obj["BlendNewDrug-96678"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96679"]),$g(obj["BlendNewDrug-96681"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96683"]),$g(obj["BlendNewDrug-96685"]),"0","0","width:10%;","","</tr>");

	//var SuspectDrugList=""+"^"+$g(obj["SuspectNewDrug-96649"])+"^"+$g(obj["SuspectNewDrug-96650"])+"^"+$g(obj["SuspectNewDrug-96651"])+"^"+$g(obj["SuspectNewDrug-96652"])+"^"+$g(obj["SuspectNewDrug-96653"])+"^"+$g(obj["SuspectNewDrug-96654"])+"^"+$g(obj["SuspectNewDrug-96655"])+"^"+$g(obj["SuspectNewDrug-96656"])+"^"+$g(obj["SuspectNewDrug-96657"])
	//htmlStr=htmlStr+initTableTdmor(SuspectDrugList,"")
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�в���ҩƷ","10","");
	   	}
	htmlStr=htmlStr+initTableTr("������Ӧ/�¼����ƣ�"+$g(data["AdvEventNewName"]),10,""); //������Ӧ�¼�����
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),6,"","","<tr>"); //��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"]),4,"","","</tr>"); //��������
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),6,"","","<tr>"); //�ϱ���������
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),4,"","","</tr>"); //�ϱ���ְ��

	htmlStr=htmlStr+initTableTr("������Ӧ/�¼���������������֢״���������ٴ�����ȣ������������2000�����ڣ���","10","border-bottom:0px"); //��������
	htmlStr=htmlStr+initTableTr($g(data["incidentNew-label-center"]),"10","border-top:0px"); //��������
	var EventNewResult=getRadioValueById("EventNewResult-label",data);
	if(EventNewResult=="�к���֢"){
		EventNewResult=EventNewResult+"�����֣�"+$g(data["EventNewResult-label-97002-97013"])+"��";
	}else if(EventNewResult=="����"){
		EventNewResult=EventNewResult+"��ֱ������"+$g(data["EventNewResult-label-97014-97015"])+"��"+"������ʱ�䣨"+$g(data["EventNewResult-label-97014-97016"])+"��";
	}
	
	htmlStr=htmlStr+initTableTr("������Ӧ/�¼��Ľ����"+EventNewResult,10,""); 						//������Ӧ/�¼��Ľ��
	htmlStr=htmlStr+initTableTr("ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ����᣺"+getRadioValueById("EventStopNewResultt",data),10,""); 	//ͣҩ������󣬷�Ӧ/�¼��Ƿ���ʧ�����
	htmlStr=htmlStr+initTableTr("�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼���"+getRadioValueById("EventTakingNewAgain",data),10,"");//�ٴ�ʹ�ÿ���ҩƷ���Ƿ��ٴγ���ͬ����Ӧ/�¼�
	htmlStr=htmlStr+initTableTr("��ԭ��������Ӱ�죺"+getRadioValueById("EventEffectNewOfTreatment-label",data),10,""); 				//��ԭ��������Ӱ��
	htmlStr=htmlStr+initTableTr("�����¼��ȼ���"+getRadioValueById("EventRepLevel",data),"10",""); 	//�����¼��ȼ�
	
	
	htmlStr=htmlStr+initTableTr("����������","10",""); 	//����������
	htmlStr=htmlStr+initTableTdOne("���������ۣ�"+getRadioValueById("EventCommentNewUser",data),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("������ǩ����"+$g(data["EventReportUser"]),4,"","","</tr>"); 	
	htmlStr=htmlStr+initTableTdOne("���浥λ���ۣ�"+getRadioValueById("EventCommentNewDept",data),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("���浥λǩ����"+$g(data["EventDeptNewReport"]),4,"","","</tr>"); 

	htmlStr=htmlStr+initTableTr("��������Ϣ","10",""); 	//��������Ϣ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["ReportNewUserMess-97050"]),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("ְҵ��"+getRadioValueById("ReportNewUserMess-97140",data),4,"","","</tr>"); 	
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["ReportNewUserMess-97145"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("ǩ����"+$g(data["ReportNewUserMess-97146"]),4,"","","</tr>"); 

	htmlStr=htmlStr+initTableTr("���浥λ��Ϣ","10",""); 	//���浥λ��Ϣ
	htmlStr=htmlStr+initTableTdOne("��ϵ�ˣ�"+$g(data["RepNewDeptMess-97151"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("��λ���ƣ�"+$g(data["RepNewDeptMess-97150"]),4,"","","</tr>"); 
	htmlStr=htmlStr+initTableTdOne("�绰��"+$g(data["RepNewDeptMess-97153"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["RepNewDeptMess-97155"]),4,"","","</tr>"); 


	htmlStr=htmlStr+initTableTr("������ҵ����д��Ϣ��Դ��"+getRadioValueById("MDRInfoSourse",data),"10","")		//������ҵ����д��Ϣ��Դ
	htmlStr=htmlStr+initTableTr("��ע��"+$g(data["RepNewRemark"]),"10","")		//��ע
	htmlStr=htmlStr+initTableTr("���Ҹ����ˣ�"+$g(data["LocLeading"]),"10","")		//���Ҹ�����
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
/// ҽ�Ʋ����¼���ӡ
function printAdvMedicalData (data){

	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҽ�Ʋ����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 // �¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),3,"","","<tr>");			 // �ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),7,"","","","</tr>");  // �ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			// ���߻�����Ϣ
	
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatNo"]),3,"","","<tr>");   	// �ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	// ������
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),4,"","","</tr>");  		// ����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","<tr>");		// ��������	
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),3,"","","");		// �Ա�
	htmlStr=htmlStr+initTableTdOne("סԺ������"+$g(data["HospTimes"]),4,"","","</tr>");			// סԺ����
	htmlStr=htmlStr+initTableTr("������Դ��"+getRadioValueById("PatOrigin",data),10,"");	// ������Դ
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["Disease"]),10,"");				// ���
	
	htmlStr=htmlStr+initTableTdOne("����ҽʦ��"+$g(data["Physician"]),3,"","","<tr>");				// ����ҽʦ
	htmlStr=htmlStr+initTableTdOne("��Ժ/������ң�"+$g(data["InOrOutHospLoc"]),7,"","","</tr>");	// ��Ժ/�������
	htmlStr=htmlStr+initTableTdOne("��λ�ţ�"+$g(data["AdmBedNum"]),3,"","","<tr>");			// ��λ��	
	htmlStr=htmlStr+initTableTdOne("��Ժ/�������ڣ�"+$g(data["InOrOutHospLoc"]),7,"","","</tr>");	// ��Ժ/�������� (��)
	
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["AgeType"]),3,"","","<tr>");				// ��������
	htmlStr=htmlStr+initTableTdOne("����ְ��"+$g(data["AdmOfficeRank"]),7,"","","</tr>");			// ����ְ��
	htmlStr=htmlStr+initTableTdOne("ҽ�����"+$g(data["MedicalCategory"]),3,"","","<tr>");		// ҽ�����	
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["LeavHospTime"]),7,"","","</tr>");		// ��Ժ����
	
	htmlStr=htmlStr+initTableTr("�¼���Ϣ","10","font-weight:bold;font-size:16px;");							// �¼���Ϣ

	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportTime"]),3,"","","<tr>");			// ��������
	htmlStr=htmlStr+initTableTdOne("����ʱ�䣺"+$g(data["OccurTime"]),3,"","","");				// ����ʱ��
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["DateType"]),4,"","","</tr>");				// ��������	
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),6,"","","<tr>");				// ��������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["HappenPlace-96400"]),4,"","","</tr>");	// ��������
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),6,"","","<tr>");		// �ϱ���������
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),4,"","","</tr>");	// �ϱ���ְ��
	htmlStr=htmlStr+initTableTr("�ṩ���ַ���ʱ������"+$g(data["RenderService"]),10,"");	// �ṩ���ַ���ʱ����

	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px"); //�¼�����
	htmlStr=htmlStr+initTableTr($g(data["EventProcessText"]),"10","border-top:0px"); //�¼�����

	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;"); 
	
	//htmlStr=htmlStr+initTableTr("�����¼����:"+getRadioById(15,"advMedicalReportType-label"),"10",""); 
	var radioStr=getRadioById(RepID,"advMedicalReportType-label");	
	if (radioStr != ""){
		var radioArray=radioStr.split("%");
		for(i=0;i<radioArray.length;i++) {
		  	var childRadioArr=radioArray[i].split("!");
		  	if(childRadioArr[0] == "����ȱ��"){		  	
				var tmpValue = childRadioArr[1].replace(/\*/g,";");
				htmlStr=htmlStr+initTableTr(childRadioArr[0]+"��"+tmpValue,"10",""); 
			}else{
				htmlStr=htmlStr+initTableTr(childRadioArr[0]+"��"+childRadioArr[1],"10",""); 
			}	
		  			  	
	 	}
	}

	htmlStr=htmlStr+initTableTr("�����¼��ĵȼ���"+getRadioValueById("EventRepLevel",data),"10","");	// �����¼��ĵȼ�
	htmlStr=htmlStr+initTableTr("ԭ�����","10","border-bottom:0px"); //ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); //ԭ�����
	htmlStr=htmlStr+initTableTr("���Ĵ�ʩ","10","border-bottom:0px"); //���Ĵ�ʩ
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); //���Ĵ�ʩ
	htmlStr=htmlStr+initTableTr("���Ҹ����ˣ�"+$g(data["LocLeading"]),"10","");		// ���Ҹ�����
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�

}

/// ҽ��Ͷ�ߡ����׵ǼǱ��£�
function printAdvMedDisputeData(data){

	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҽ��Ͷ�ߡ����׵ǼǱ�","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 // �¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),3,"","","<tr>");			 // �ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),7,"","","","</tr>");  // �ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			// ���߻�����Ϣ
	
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatNo"]),3,"","","<tr>");   	// �ǼǺ�
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["PatName"]),3,"","","");  		// ����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),4,"","","</tr>");		// ��������	
	htmlStr=htmlStr+initTableTdOne("�Ա�"+$g(data["PatSex"]),3,"","","<tr>");		// �Ա�
	htmlStr=htmlStr+initTableTdOne("����סַ��"+$g(data["PatAddr"]),3,"","","");			// סַ
	
	htmlStr=htmlStr+initTableTdOne("��ϵ��ʽ��"+$g(data["Contact"]),4,"","","</tr>");	// ��ϵ��ʽ
	htmlStr=htmlStr+initTableTdOne("���֤��������"+$g(data["PatIDCard"]),3,"","","<tr>");			// ���֤������
	htmlStr=htmlStr+initTableTdOne("�·����ң�"+$g(data["OccuLoc"]),3,"","","");		// �·�����
	htmlStr=htmlStr+initTableTdOne("�·�ʱ�䣺"+$g(data["IncidenTime"]),4,"","","</tr>");	// �·�ʱ��
	htmlStr=htmlStr+initTableTdOne("�����ˣ�"+$g(data["Party"]),3,"","","<tr>");		// ������
	
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["MedFamName"]),3,"","","");		// ��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["MedFamSex"]),4,"","","</tr>");			// �����Ա�
	htmlStr=htmlStr+initTableTdOne("���֤����������"+$g(data["FamIDCard"]),6,"","","<tr>");	// ���֤��������
	htmlStr=htmlStr+initTableTdOne("Ͷ����Դ��"+$g(data["ComplainSource"]),4,"","","</tr>");		// Ͷ����Դ	
	htmlStr=htmlStr+initTableTdOne("�뻼�߹�ϵ��"+$g(data["PatRelation"]),3,"","","<tr>");		// �뻼�߹�ϵ
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["MedPatOthMes"]),7,"","","</tr>");		// ����
	
	htmlStr=htmlStr+initTableTr("��Ҫ����","10","border-bottom:0px"); //��Ҫ����
	htmlStr=htmlStr+initTableTr($g(data["MainProblems"]),"10","border-top:0px"); //��Ҫ����
	htmlStr=htmlStr+initTableTr("�·�����","10","border-bottom:0px"); //�·�����
	htmlStr=htmlStr+initTableTr($g(data["IncidentPass"]),"10","border-top:0px"); //�·�����


	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");			// �¼�������Ϣ

	htmlStr=htmlStr+initTableTr("���Ҵ�����������Ĵ�ʩ","10","border-bottom:0px"); // ���Ҵ�����������Ĵ�ʩ
	htmlStr=htmlStr+initTableTr($g(data["LocDealView"]),"10","border-top:0px"); // ���Ҵ�����������Ĵ�ʩ
	
	htmlStr=htmlStr+initTableTdOne("���Ҹ����ˣ�"+$g(data["LocCharge"]),3,"","","<tr>");		// ���Ҹ�����
	htmlStr=htmlStr+initTableTdOne("ʱ�䣺"+$g(data["LocDateTime"]),7,"","","</tr>");			// ʱ��
	
	htmlStr=htmlStr+initTableTr("�ͽ�","10","border-bottom:0px"); // �ͽ�
	htmlStr=htmlStr+initTableTr($g(data["EventReconcile"]),"10","border-top:0px"); // �ͽ�

	htmlStr=htmlStr+initTableTr("����","10","border-bottom:0px"); // ����
	htmlStr=htmlStr+initTableTr($g(data["EventMediate"]),"10","border-top:0px"); // ����

	htmlStr=htmlStr+initTableTr("˾������","10","border-bottom:0px"); // ˾������
	htmlStr=htmlStr+initTableTr($g(data["ExpertTest"]),"10","border-top:0px"); // ˾������
	
	htmlStr=htmlStr+initTableTr("һ��","10","border-bottom:0px"); // һ��
	htmlStr=htmlStr+initTableTr($g(data["EventFirtInstance"]),"10","border-top:0px"); // һ��
	htmlStr=htmlStr+initTableTr("����","10","border-bottom:0px"); // ����
	htmlStr=htmlStr+initTableTr($g(data["EventSecInstance"]),"10","border-top:0px"); // ����
	htmlStr=htmlStr+initTableTr("����","10","border-bottom:0px"); // ����
	htmlStr=htmlStr+initTableTr($g(data["EventOthInstance"]),"10","border-top:0px"); // ����

	htmlStr=htmlStr+initTableTr("�¼�׷�ټ�ҽ�񲿴������","10","border-bottom:0px"); // �¼�׷�ټ�ҽ�񲿴������
	htmlStr=htmlStr+initTableTr($g(data["EventTrack"]),"10","border-top:0px"); // �¼�׷�ټ�ҽ�񲿴������
	htmlStr=htmlStr+initTableTdOne("ҽ�񲿸����ˣ�"+$g(data["MedServiceCharge"]),6,"","","<tr>");	// ҽ�񲿸�����
	htmlStr=htmlStr+initTableTdOne("ʱ�䣺"+$g(data["MedServiceTime"]),4,"","","</tr>");			// ʱ��
	htmlStr=htmlStr+initTableTr("����׷���봦����","10","border-bottom:0px"); // ����׷���봦����
	htmlStr=htmlStr+initTableTr($g(data["Accountable"]),"10","border-top:0px"); // ����׷���봦����
	htmlStr=htmlStr+initTableTdOne("Ժ�쵼ǩ�֣�"+$g(data["Leadership"]),6,"","","<tr>");			// Ժ�쵼ǩ��
	htmlStr=htmlStr+initTableTdOne("ʱ�䣺"+$g(data["LeaderTime"]),4,"","","</tr>");				// ʱ��	
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
	
}



//Ժ�в����¼�
function printadvHosInfectData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("Ժ�в����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���ţ�"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��ˣ�"+$g(data["ReportPer"]),3,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�䣺"+$g(data["ReportTime"]),7,"","","","</tr>");  //�ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ
	htmlStr=htmlStr+initTableTr("������Դ��"+getRadioValueById("PatOrigin",data),"10","");			//������Դ
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["PatNo"]),3,"","","<tr>");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("סԺ������"+$g(data["HospTimes"]),4,"","","</tr>");	//סԺ����
	
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");  					//����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["PatAge"]),3,"","","");	//��������
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//�Ա�
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["Disease"]),10,"");	//���

	htmlStr=htmlStr+initTableTdOne("��Ժ/������ң�"+$g(data["InOrOutHospLoc"]),6,"","","<tr>");				//��Ժ/�������
	htmlStr=htmlStr+initTableTdOne("����ҽʦ��"+$g(data["Physician"]),4,"","","</tr>");		//����ҽʦ
	htmlStr=htmlStr+initTableTdOne("��Ժ/�������ڣ�"+$g(data["InOrOutHospDate"]),6,"","","<tr>");	//��Ժ/��������
	htmlStr=htmlStr+initTableTdOne("��Ժ���ڣ�"+$g(data["LeavHospTime"]),4,"","","</tr>");	//��Ժ����
	
	htmlStr=htmlStr+initTableTdOne("��λ�ţ�"+$g(data["AdmBedNum"]),6,"","","<tr>");		//��λ��
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["AgeType"]),4,"","","</tr>");		//��������
	htmlStr=htmlStr+initTableTdOne("����ְ��"+$g(data["AdmOfficeRank"]),6,"","","<tr>");	//����ְ��
	htmlStr=htmlStr+initTableTdOne("ҽ�����"+$g(data["MedicalCategory"]),4,"","","</tr>");	//ҽ�����
	
	htmlStr=htmlStr+initTableTr("�¼���Ϣ","10","font-weight:bold;font-size:16px;");	//�¼���Ϣ
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),3,"","","<tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�������ͣ�"+$g(data["DateType"]),3,"","","");	//��������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("����������"+getRadioValueById("HappenPlace",data),3,"","","<tr>");   	//��������
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),3,"","","");	//�ϱ���ְ��
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),4,"","","</tr>");	//�ϱ���������
	htmlStr=htmlStr+initTableTr("�ṩ���ַ���ʱ������"+$g(data["RenderService"]),"10","");	//�¼���Ϣ
	htmlStr=htmlStr+initTableTr("�¼�����","10","border-bottom:0px"); // �¼�����
	htmlStr=htmlStr+initTableTr($g(data["EventProcessText"]),"10","border-top:0px"); // �¼�����
	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");	//�¼�������Ϣ
	htmlStr=htmlStr+initTableTr("�����¼����"+getRadioValueById("HosInfReportType-97149",data),10,"");   	//�����¼����
	htmlStr=htmlStr+initTableTr("�����¼��ĵȼ���"+getRadioValueById("EventRepLevel",data),10,"");   //�����¼��ĵȼ�
	htmlStr=htmlStr+initTableTr("ԭ�����","10","border-bottom:0px"); // ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); // ԭ�����
	htmlStr=htmlStr+initTableTr("���Ĵ�ʩ","10","border-bottom:0px"); // ���Ĵ�ʩ
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); // ���Ĵ�ʩ
	htmlStr=htmlStr+initTableTr("���Ҹ����ˣ�"+$g(data["LocLeading"]),10,"");   //���Ҹ�����
	 
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}

//ְҵ��¶�����¼����浥
function printadvOccExposeData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ְҵ��¶�����¼����浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���ţ�"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��ˣ�"+$g(data["ReportPer"]),3,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�䣺"+$g(data["ReportTime"]),7,"","","","</tr>");  //�ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("��¶�����","10","font-weight:bold;font-size:16px;");	//��¶�����
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("PatSexRadio",data),3,"","","");		//�Ա�
	htmlStr=htmlStr+initTableTdOne("��¶�����䣺"+$g(data["OccExpAge"]),4,"","","</tr>");	//��¶������
	htmlStr=htmlStr+initTableTdOne("�绰��"+$g(data["MedNewRepTel"]),3,"","","<tr>");	//�绰
	htmlStr=htmlStr+initTableTdOne("ְ�ƣ�"+$g(data["JobTitle"]),3,"","","");		//ְ��
	htmlStr=htmlStr+initTableTdOne("�μӹ���ʱ�䣺"+$g(data["StartWorkDate"]),4,"","","</tr>");		//�μӹ���ʱ��
	htmlStr=htmlStr+initTableTdOne("��������״����"+$g(data["HistoryHealth"]),3,"","","<tr>");	//��������״��
	htmlStr=htmlStr+initTableTdOne("��λ���"+getRadioValueById("PostCategory",data),3,"","","");	//��λ���
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),4,"","","</tr>");		//��������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),3,"","","<tr>");		//��������
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["ReportLitigand"]),3,"","","");	//�ϱ���ְ��
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),4,"","","</tr>");	//�ϱ���������

	htmlStr=htmlStr+initTableTdOne("��¶��λ��"+$g(data["ExposePart"]),3,"","","<tr>");     	 //��¶��λ
	var OccuExpVaccination=getRadioValueById("OccuExpVaccination",data);
	if (OccuExpVaccination=="��"){
		OccuExpVaccination=OccuExpVaccination+"���������ƣ�"+$g(data["OccuExpVaccineName"])+"��" ;
	}
	htmlStr=htmlStr+initTableTdOne("Ԥ�����֣�"+OccuExpVaccination,3,"","","");			 //Ԥ������
	htmlStr=htmlStr+initTableTdOne("��¶��������"+$g(data["ExposeTimes-96608"])+"�Σ����±�רҵ��",4,"","","","</tr>");  //��¶����

	htmlStr=htmlStr+initTableTdOne("��¶�ص㣺"+getRadioValueById("ExposePlace",data),3,"","","<tr>");     	 //��¶�ص�
	htmlStr=htmlStr+initTableTdOne("��¶��ʽ��"+getRadioValueById("ExposeMode",data),3,"","","");			 //��¶��ʽ
	htmlStr=htmlStr+initTableTdOne("�������ƣ�"+getRadioValueById("SharpWeapon",data),4,"","","","</tr>");  //��������
	htmlStr=htmlStr+initTableTdOne("���˳̶ȣ�"+getRadioValueById("DegreeOfInjury",data),6,"","","<tr>");     	 //���˳̶�
	htmlStr=htmlStr+initTableTdOne("���˻��ڣ�"+getRadioValueById("InjuryLink",data),4,"","","</tr>");			 //���˻���
	htmlStr=htmlStr+initTableTr("��¶��ֲ����������"+getRadioValueById("OccExpLocalTreatment",data),10,"");  //��¶��ֲ��������
	htmlStr=htmlStr+initTableTr("ְҵ��¶����","10","border-bottom:0px"); // ְҵ��¶����
	htmlStr=htmlStr+initTableTr($g(data["OccExposeCourse"]),"10","border-top:0px"); // ְҵ��¶����
	htmlStr=htmlStr+initTableTr("�����¼��ĵȼ���"+getRadioValueById("EventRepLevel",data) ,10,"");   //�����¼��ĵȼ�
	
	htmlStr=htmlStr+initTableTr("��¶Դ�������","10","font-weight:bold;font-size:16px;");	//��¶Դ�������
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["ExpSName"]),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");		//������
	htmlStr=htmlStr+initTableTdOne("�Ա�"+getRadioValueById("ExpSSexRadio",data),4,"","","</tr>");		//�Ա�
	htmlStr=htmlStr+initTableTdOne("���䣺"+$g(data["ExpSAge"]),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("�Ƿ�סԺ��"+getRadioValueById("ExpSInHospital",data),7,"","","</tr>");		//�Ƿ�סԺ
	htmlStr=htmlStr+initTableTr("��¶Դ��Ⱦ�����"+getRadioValueById("ExpSInfectInfo",data),"10","");	//��¶Դ��Ⱦ���
	htmlStr=htmlStr+initTableTr("��¶Դ��Ժ���","10","border-bottom:0px"); // ��¶Դ��Ժ���
	htmlStr=htmlStr+initTableTr($g(data["ExpSAdmDiagnosis"]),"10","border-top:0px"); // ��¶Դ��Ժ���
	
	htmlStr=htmlStr+initTableTr("��¶�����","10","font-weight:bold;font-size:16px;");	//��¶�����
	
	htmlStr=htmlStr+initTableTd("��Ҫ����ָ��","���濹ԭ","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd("���濹��","e��ԭ","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("e����","���Ŀ���","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("HCV","HIV","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("TP","����","0","0","background-color:#808080;width:10%;","background-color:#808080;","</tr>");

	htmlStr=htmlStr+initTableTd("����",$g(data["ExposerFlup-97053-97521-97531"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97523-97532"]),$g(data["ExposerFlup-97053-97524-97533"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97525-97534"]),$g(data["ExposerFlup-97053-97526-97535"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97527-97536"]),$g(data["ExposerFlup-97053-97528-97537"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97529-97540"]),$g(data["ExposerFlup-97053-97530-97542"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("1����",$g(data["ExposerFlup-97552-97559-97569"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97560-97570"]),$g(data["ExposerFlup-97552-97561-97571"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97562-97572"]),$g(data["ExposerFlup-97552-97563-97573"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97564-97574"]),$g(data["ExposerFlup-97552-97565-97575"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97566-97576"]),$g(data["ExposerFlup-97552-97684-97685"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("3����",$g(data["ExposerFlup-97553-97578-97607"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97579-97608"]),$g(data["ExposerFlup-97553-97580-97611"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97581-97612"]),$g(data["ExposerFlup-97553-97583-97613"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97584-97614"]),$g(data["ExposerFlup-97553-97585-97615"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97586-97616"]),$g(data["ExposerFlup-97553-97686-97687"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("6����",$g(data["ExposerFlup-97554-97588-97627"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97589-97631"]),$g(data["ExposerFlup-97554-97590-97632"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97591-97633"]),$g(data["ExposerFlup-97554-97592-97634"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97593-97636"]),$g(data["ExposerFlup-97554-97594-97637"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97595-97638"]),$g(data["ExposerFlup-97554-97688-97689"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("9����",$g(data["ExposerFlup-97555-97597-97642"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97598-97643"]),$g(data["ExposerFlup-97555-97599-97644"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97600-97645"]),$g(data["ExposerFlup-97555-97601-97646"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97603-97647"]),$g(data["ExposerFlup-97555-97604-97648"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97605-97649"]),$g(data["ExposerFlup-97555-97690-97691"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("1��",$g(data["ExposerFlup-97652-97656-97668"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97657-97672"]),$g(data["ExposerFlup-97652-97659-97673"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97660-97674"]),$g(data["ExposerFlup-97652-97661-97675"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97662-97676"]),$g(data["ExposerFlup-97652-97663-97677"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97664-97678"]),$g(data["ExposerFlup-97652-97665-97679"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTr("��¶����ҩ���","10","border-bottom:0px"); // ��¶����ҩ���
	htmlStr=htmlStr+initTableTr($g(data["OccExpDrugInfo"]),"10","border-top:0px"); // ��¶����ҩ���
	htmlStr=htmlStr+initTableTr("ԭ�����","10","border-bottom:0px"); // ԭ�����
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); // ԭ�����
	htmlStr=htmlStr+initTableTr("���Ĵ�ʩ","10","border-bottom:0px"); // ���Ĵ�ʩ
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); // ���Ĵ�ʩ
	
	htmlStr=htmlStr+initTableTr("���Ҹ����ˣ�"+$g(data["LocLeading"]) ,10,"");   //���Ҹ�����

	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}

//�Ǽƻ��ٴ��������浥
function printadvNonPlanRepaData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�Ǽƻ��ٴ��������浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��������","10","font-weight:bold;font-size:16px;");	//��������
	htmlStr=htmlStr+initTableTdOne("���ң�"+$g(data["NonPlanRepaLoc"]),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("���ţ�"+$g(data["NonPlanRepaBedCode"]),3,"","","");		//����
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["NonPlanRepaRepDate"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("������"+$g(data["NonPlanRepaPatName"]),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("�Ա�"+$g(data["NonPlanRepaPatSex"]),7,"","","</tr>");		//�Ա�
	htmlStr=htmlStr+initTableTdOne("���䣺"+$g(data["NonPlanRepaPatAge"]),3,"","","<tr>");	//����
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["NonPlanRepaPatID"]),7,"","","</tr>");	//�ǼǺ�
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["NonPlanRepaDiag"]) ,10,"");   //���
	
	htmlStr=htmlStr+initTableTr("�¼��������","10","font-weight:bold;font-size:16px;");							// �¼��������

	htmlStr=htmlStr+initTableTdOne("ԭ�������ƣ�"+$g(data["NonPlanRepTheOperName"]),3,"","","<tr>");			// ԭ��������
	htmlStr=htmlStr+initTableTdOne("ԭ�������ڣ�"+$g(data["NonPlanRepaTheOperDate"]),3,"","","");				// ԭ��������
	htmlStr=htmlStr+initTableTdOne("ԭ��������ҽʦ��"+$g(data["NonPlanRepaTheBthDoc"]),4,"","","</tr>");				// ԭ��������ҽʦ
	htmlStr=htmlStr+initTableTdOne("ְ�ƣ�"+$g(data["NonPlanRepaTheDocTitle"]),3,"","","<tr>");				// ְ��
	htmlStr=htmlStr+initTableTdOne("�Ƿ���������"+$g(data["NonPlanRepaIfEmOper"]),3,"","","");			// �Ƿ�������
	htmlStr=htmlStr+initTableTdOne("��������"+$g(data["NonPlanRepaOperLev"]),4,"","","</tr>");				// ��������
	htmlStr=htmlStr+initTableTdOne("������Ѫ����ml����"+$g(data["NonPlanRepaBldQty"]),3,"","","<tr>");				// ������Ѫ����ml��
	htmlStr=htmlStr+initTableTdOne("����ʱ����min����"+$g(data["NonPlanRepaOperDurTime"]),3,"","","");				// ����ʱ����min��
	htmlStr=htmlStr+initTableTdOne("�Ƿ�Σ�ػ��ߣ�"+$g(data["NonPlanRepaIfUrgPat"]),4,"","","</tr>");			// �Ƿ�Σ�ػ���
	htmlStr=htmlStr+initTableTdOne("�Ƿ�ϲ�����֢��"+$g(data["NonPlanRepaIfComDis"]),3,"","","<tr>");				// �Ƿ�ϲ�����֢
	htmlStr=htmlStr+initTableTdOne("�ٴ��������ƣ�"+$g(data["NonPlanRepAgainOperName"]),3,"","","");				// �ٴ���������
	htmlStr=htmlStr+initTableTdOne("���������ڣ�"+$g(data["NonPlanRepaAgainOperDate"]),4,"","","</tr>");				// ����������
	htmlStr=htmlStr+initTableTdOne("ְ�ƣ�"+$g(data["NonPlanRepaAgainDocTitle"]),3,"","","<tr>");				// ְ��
	htmlStr=htmlStr+initTableTdOne("�ٴ���������"+$g(data["NonPlanRepaAgainOperLev"]),3,"","","");				// �ٴ���������
	htmlStr=htmlStr+initTableTdOne("�ٴ���������ҽʦ��"+$g(data["NonPlanRepaAgainBthDoc"]),4,"","","</tr>");			// �ٴ���������ҽʦ 
	
	htmlStr=htmlStr+initTableTr("���ٴ�����ԭ��","10",""); 	//���ٴ�����ԭ��
	htmlStr=htmlStr+initTableTdOne("�����Ѫ��"+getRadioValueById("NonPlanRepaAgainOperRes-702",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("����ֲ��ܶ�����"+getRadioValueById("NonPlanRepaAgainOperRes-705",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("�����裺"+getRadioValueById("NonPlanRepaAgainOperRes-708",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("�����Ⱦ��"+getRadioValueById("NonPlanRepaAgainOperRes-711",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("������������"+getRadioValueById("NonPlanRepaAgainOperRes-714",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("�ǺϿ�����"+getRadioValueById("NonPlanRepaAgainOperRes-717",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("����֬��Һ����"+getRadioValueById("NonPlanRepaAgainOperRes-720",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("����Ѫ˨���ɣ�"+getRadioValueById("NonPlanRepaAgainOperRes-723",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("�����ѿ���"+getRadioValueById("NonPlanRepaAgainOperRes-726",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("����ҽ����"+getRadioValueById("NonPlanRepaAgainOperRes-729",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("�������ʣ�"+getRadioValueById("NonPlanRepaAgainOperRes-732",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("�ϴ�������ЧǷ�ѣ�"+getRadioValueById("NonPlanRepaAgainOperRes-735",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("������"+$g(data["NonPlanRepaAgainOperRes-738"]) ,10,"");   //�������ٴ�����ԭ��
	htmlStr=htmlStr+initTableTr("�ٴ�����Ŀ�ģ�"+$g(data["NonPlanRepaOperGoal"]) ,10,"");   //�ٴ�����Ŀ��
	
	htmlStr=htmlStr+initTableTr("�ٴ�����׼�����","10",""); 	//�ٴ�����׼�����
	htmlStr=htmlStr+initTableTdOne("�Ƿ񱨸��ϼ����鷿��"+getRadioValueById("NonPlanRepaOperReadiness-742",data),6,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("�Ƿ���֯�������ۣ�"+getRadioValueById("NonPlanRepaOperReadiness-745",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("�Ƿ��г�ֵ���ǰ׼����"+getRadioValueById("NonPlanRepaOperReadiness-748",data),6,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("�Ƿ��з��մ���Ԥ����"+getRadioValueById("NonPlanRepaOperReadiness-751",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("�Ƿ����û��߼���֪���֪��"+getRadioValueById("NonPlanRepaOperReadiness-754",data),10,"");  
	htmlStr=htmlStr+initTableTr("ҽ�ư�ȫ���������¼����"+getRadioValueById("MedAdvEventLev",data) ,10,"");   //ҽ�ư�ȫ���������¼����
	htmlStr=htmlStr+initTableTr("����������𺦵����س̶ȣ�"+getRadioValueById("MedAdvInjuryLevByType",data) ,10,"");   //����������𺦵����س̶�
	
	
	htmlStr=htmlStr+initTableTdOne("��������ˣ�"+$g(data["NonPlanRepaDirectorAudit"]),3,"","","<tr>");	// ���������
	htmlStr=htmlStr+initTableTdOne("Ԥ�󣨺�ת/δ��/��������"+$g(data["NonPlanRepaBetterProg"]),7,"","","</tr>");		// Ԥ�󣨺�ת/δ��/������
	htmlStr=htmlStr+initTableTdOne("����ҽ��ǩ����"+$g(data["NonPlanRepaRepDocSign"]),6,"","","<tr>");	// ����ҽ��ǩ��
	htmlStr=htmlStr+initTableTdOne("�ϱ���ְ�ƣ�"+$g(data["NonPlanRepaRepTitle"]),4,"","","</tr>");		// �ϱ���ְ��
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}

//��Һ��Ӧר��浥
function printadvTransRctData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("��Һ��Ӧר��浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("���ң�"+$g(data["TransRctLoc"]),6,"","","<tr>");     	 //����
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["TransRctRepDate"]),4,"","","","</tr>");  //��������
	
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["TransRctPatName"]),6,"","","<tr>");			 //��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["TransRctRegNo"]),4,"","","","</tr>");  //�ǼǺ�

	htmlStr=htmlStr+initTableTr("һ���������","10","font-weight:bold;font-size:16px;");	//��������
	htmlStr=htmlStr+initTableTr("1��Һ����עʱ�䣺"+$g(data["TransRctLiqInfuTime-94124"])+"ʱ"+$g(data["TransRctLiqInfuTime-94126"])+"��",10,"");		//Һ����עʱ��
	htmlStr=htmlStr+initTableTr("2�����ֲ���ʱ�䣺"+$g(data["TransRctDicTime-94177"])+"ʱ"+$g(data["TransRctDicTime-94179"])+"��",10,"");		//���ֲ���ʱ��
	var TransRctVitalSign="", SignT=$g(data["TransRctVitalSign-94131-94132"]),SignP=$g(data["TransRctVitalSign-94134-94135"]),SignR=$g(data["TransRctVitalSign-94137-94138"]),SignBp=$g(data["TransRctVitalSign-94140-94141"]),SignBpd=$g(data["TransRctVitalSign-94140-94142"]);
	if(SignT!=""){
		TransRctVitalSign=TransRctVitalSign+"T��"+SignT+"�棻";
	}
	if(SignP!=""){
		TransRctVitalSign=TransRctVitalSign+"P��"+SignP+"��/�֣�";
	}
	if(SignR!=""){
		TransRctVitalSign=TransRctVitalSign+"R��"+SignR+"��/�֣�";
	}
	if(SignBp!=""){
		TransRctVitalSign=TransRctVitalSign+"Bp��"+SignBp+"/"+SignBpd+"mmHg��";
	}
	
	htmlStr=htmlStr+initTableTdOne("3������������"+TransRctVitalSign,10,"");		//��������
	
	
	htmlStr=htmlStr+initTableTdOne("4�����ߵ��ٴ����֣�",3,"","","<tr>");		//���ߵ��ٴ�����
	htmlStr=htmlStr+initTableTdOne("Ƥ�"+getRadioValueById("TransRctCliniMan-94148",data)+getRadioValueById("TransRctCliniMan-94148-94150",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("��ս��"+getRadioValueById("TransRctCliniMan-94145",data),2,"","","");		
	htmlStr=htmlStr+initTableTdOne("�������ѣ�"+getRadioValueById("TransRctCliniMan-94154",data),2,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("5���������֣�"+$g(data["TransRctOtherPer"]) ,10,"");   //��������
	htmlStr=htmlStr+initTableTdOne("6������"+getRadioValueById("TransRctDispose",data),3,"","","<tr>");		//����
	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["TransRctDispose-94165-94167"])+"ʱ"+$g(data["TransRctDispose-94165-94168"])+"��֢״����",7,"","","</tr>");		

	htmlStr=htmlStr+initTableTr("����Һ�����ƹ���","10","font-weight:bold;font-size:16px;");							// ����Һ�����ƹ���
	var TransRctDrugInfo=$g(data["TransRctDrugInfo"]);  //ҩƷ��Ϣ�б�
	var TransRctSyRinge=$g(data["TransRctSyRinge"]); 		 //һ������Ʒ�б�
   	if(TransRctDrugInfo!=""){
   		htmlStr=htmlStr+initTableTdOne("ҩ��ͨ������(������)","2","","background-color:#808080;width:20%;","<tr>");
		htmlStr=htmlStr+initTableTdOne("�÷�����(������;�����մ���)","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("��������","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("��������","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("��Ч����","2","","background-color:#808080","</tr>");

	   	$(TransRctDrugInfo).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94182"]),"2","","width:20%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94183"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94184"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94185"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94186"]),"2","","","</tr>");
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û��ҩƷ��Ϣ","10","");
	   	
	}
	//һ������Ʒ�б�
	htmlStr=htmlStr+initTableTdOne("һ������Ʒ","2","","background-color:#808080;width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne("�ͺ�","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("��������","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("��������","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("��Ч����","2","","background-color:#808080","</tr>");

	htmlStr=htmlStr+initTableTdOne("��Һ��","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94197"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94198"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94199"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94200"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTdOne("������","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94203"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94204"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94205"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94206"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTdOne("ע����","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94209"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94210"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94211"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94212"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTr("����Һ����ע����","10","font-weight:bold;font-size:16px;");							// ����Һ����ע����
	htmlStr=htmlStr+initTableTr("1����Һ��ʽ��"+getRadioValueById("TransRctFluids",data),10,"");			// ��Һ��ʽ
	htmlStr=htmlStr+initTableTdOne("2���������ڣ�"+$g(data["TransRctPunDate"]),6,"","","<tr>");				// ��������
	htmlStr=htmlStr+initTableTdOne("���̲�λ��"+$g(data["TransRctPuncture"]),4,"","","</tr>");				// ���̲�λ
	htmlStr=htmlStr+initTableTdOne("3��Һ�����ã�"+$g(data["TransRctLiqConfig1"])+"���Ӻ�����",3,"","","<tr>");				// ԭ��������
	htmlStr=htmlStr+initTableTdOne("������Һ������Һ��(ml)��"+$g(data["TransRctLiqConfig2"]),3,"","","");				// ������Һ������Һ��
	htmlStr=htmlStr+initTableTdOne("��Һ�ٶ�(��/��)��"+$g(data["TransRctLiqConfig3"]),4,"","","</tr>");				// ��Һ�ٶ�

	htmlStr=htmlStr+initTableTr("�ġ���Ʒ����","10","font-weight:bold;font-size:16px;");							// �ġ���Ʒ����
	htmlStr=htmlStr+initTableTdOne("1����Ʒ��棺"+getRadioValueById("TransRctGoodStor",data),6,"","","<tr>");				// ��Ʒ���
	htmlStr=htmlStr+initTableTdOne("��ر��棺"+getRadioValueById("TransRctColdStor",data),4,"","","</tr>");				// ��ر���
	htmlStr=htmlStr+initTableTdOne("2��ҩҺ�����ͼ첿�ţ�"+getRadioValueById("TransRctLiqMedDep",data),6,"","","<tr>");				// ҩҺ�����ͼ첿��
	htmlStr=htmlStr+initTableTdOne("ʱ�䣺"+$g(data["TransRctMedDepDate"]),4,"","","</tr>");				// ʱ��
	htmlStr=htmlStr+initTableTdOne("2�����ܼ�������ͼ첿�ţ�"+getRadioValueById("TransRctCatheterDep",data),6,"","","<tr>");				// ���ܼ�������ͼ첿��
	htmlStr=htmlStr+initTableTdOne("ʱ�䣺"+$g(data["TransRctCatheterDate"]),4,"","","</tr>");				// ʱ��
	htmlStr=htmlStr+initTableTdOne("��ҩ��ʿ��"+$g(data["TransRctDispenNurse"]),3,"","","<tr>");				// ��ҩ��ʿ
	htmlStr=htmlStr+initTableTdOne("����/��Һ�廤ʿ��"+$g(data["TransRctNeedleNurse"]),7,"","","</tr>");				// ����/��Һ�廤ʿ

	htmlStr=htmlStr+initTableTr("�����¼�����������(��ʿ����д)��"+getRadioValueById("OccurAfterDealMethod",data) ,10,"");   // �����¼�����������(��ʿ����д)
	htmlStr=htmlStr+initTableTdOne("�����Ƿ��������Ƶ��¼���"+getRadioValueById("DeptIfOccSimEvent",data),6,"","","<tr>");				// �����Ƿ��������Ƶ��¼�
	htmlStr=htmlStr+initTableTdOne("����ȣ��Σ���"+$g(data["DeptIfOccSimEvent-94119-94120"]),4,"","","</tr>");				// ����ȣ��Σ�
	
	htmlStr=htmlStr+initTableTr("�������۷��������Ĵ�ʩ���������(��ʿ����д)",10,""); 	//�ٴ�����׼�����
	var ReasonStr=getRadioById(RepID,"NurReasonCase");
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var NurReasonCase="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("��")==-1){
				if(ReasonArr[1]!=""){
			 		NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0]+"��"+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("ԭ�������"+NurReasonCase,10,"");				// ԭ�����
	var NurCorrectAction=radioValue("NurCorrectAction-296,NurCorrectAction-297,NurCorrectAction-298,NurCorrectAction-299,NurCorrectAction-300,NurCorrectAction-302",data);
	if(radioValue("NurCorrectAction-301",data)!=""){
		NurCorrectAction=NurCorrectAction+"���޶��ƶ�/����/ְ��ȣ�"+radioValue("NurCorrectAction-301",data)
	}
	htmlStr=htmlStr+initTableTr("���Ĵ�ʩ��"+NurCorrectAction,10,"");   // ���Ĵ�ʩ
	var NurDisposition=radioValue("NurDisposition-306,NurDisposition-307,NurDisposition-309",data);
	if(radioValue("NurDisposition-308",data)!=""){
		NurDisposition=NurDisposition+"�������˼������ԱΥ���ƶ�/����/ְ����۷���"+radioValue("NurDisposition-308",data)
	}
	htmlStr=htmlStr+initTableTr("���������"+NurDisposition,10,"");   // �������
	htmlStr=htmlStr+initTableTdOne("��ʿ��ǩ����"+$g(data["NurHeadNurse"]),6,"","","<tr>");				// ��ʿ��ǩ��
	htmlStr=htmlStr+initTableTdOne("ǩ�����ڣ�"+$g(data["NurSignDate"]),4,"","","</tr>");				// ǩ������
	
	htmlStr=htmlStr+initTableTr("���߰�ȫ����С����н����ָ�����",10,""); 	//���߰�ȫ����С����н����ָ�����
	htmlStr=htmlStr+initTableTr("1.���������"+getRadioValueById("PatSafeGroupResult-label-603",data),10,"");				// 1.�������
	htmlStr=htmlStr+initTableTr("2.���Ҵ��������"+getRadioValueById("PatSafeGroupResult-label-606",data) ,10,"");   // 2.���Ҵ������
	htmlStr=htmlStr+initTableTr("3.������"+$g(data["PatSafeGroupResult-label-609"]) ,10,"");   // 3.����
	htmlStr=htmlStr+initTableTdOne("����ȫС������ˣ�"+$g(data["NurTeamReferPerson"]),6,"","","<tr>");				// ����ȫС�������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReferDate"]),4,"","","</tr>");				// ��������
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}

//ҩ������ר��浥
function printadvDrugExosData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҩ������ר��浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTdOne("����ʱ�䣺"+$g(data["DrugExosOccurDate"])+" "+$g(data["OccurTime"]),3,"","","<tr>");     	 // ����ʱ��
	htmlStr=htmlStr+initTableTdOne("�����������"+$g(data["DrugExosRepAuditName"]),7,"","","","</tr>");  // ���������
	htmlStr=htmlStr+initTableTdOne("����������"+$g(data["DrugExosPatName"]),3,"","","<tr>");			 // ��������
	htmlStr=htmlStr+initTableTdOne("�ǼǺţ�"+$g(data["DrugExosPatID"]),7,"","","","</tr>");  // �ǼǺ�
	htmlStr=htmlStr+initTableTr("һ��������Ŀ","10","font-weight:bold;font-size:16px;");	// һ��������Ŀ
	htmlStr=htmlStr+initTableTr("����������ҩ�"+getRadioValueById("DrugExosCauseByDrug",data),10,"");		// ����������ҩ��
	var DrugExosStimInt="",fpxint=$g(data["DrugExosStimInt-846-851"]),cjxint=$g(data["DrugExosStimInt-847-854"]),ffpxint=$g(data["DrugExosStimInt-848-857"]),othint=$g(data["DrugExosStimInt-849-860"]);
	if(fpxint!=""){
		DrugExosStimInt=DrugExosStimInt+"������(ҩ������ "+fpxint+");"
	}
	if(cjxint!=""){
		DrugExosStimInt=DrugExosStimInt+"�̼���(ҩ������ "+cjxint+");"
	}
	if(ffpxint!=""){
		DrugExosStimInt=DrugExosStimInt+"�Ƿ�����(ҩ������ "+ffpxint+");"
	}
	if(othint!=""){
		DrugExosStimInt=DrugExosStimInt+"����(ҩ������ "+othint+");"
	}
	
	htmlStr=htmlStr+initTableTr("�̼�ǿ�ȣ�"+DrugExosStimInt,10,"");		// �̼�ǿ��
	htmlStr=htmlStr+initTableTdOne("��ҩ;��",1,3,"","<tr>"); 	// ��ҩ;��
	htmlStr=htmlStr+initTableTdOne("���̲�λ��"+getRadioValueById("DrugExosDeliWay-863",data),9,"","","</tr>");				// ���̲�λ
	htmlStr=htmlStr+initTableTdOne("�����ܾ�����"+getRadioValueById("DrugExosDeliWay-870",data),9,"","","</tr>");				// �����ܾ���
	htmlStr=htmlStr+initTableTdOne("�����ľ���ͨ·��"+getRadioValueById("DrugExosDeliWay-873",data),9,"","","</tr>");				// �����ľ���ͨ·

	htmlStr=htmlStr+initTableTdOne("���̲�λҩ���������",1,3,"","<tr>"); 	// ���̲�λҩ���������
	var hzPuncExos="",ttPuncExos="",kyPuncExos="";
	if(getRadioValueById("DrugExosPuncExos-882",data)=="��"){
		hzPuncExos="����Χ"+$g(data["DrugExosPuncExos-882-884-886"])+"��"+$g(data["DrugExosPuncExos-882-884-900"])+"cm2";
	}
	if(getRadioValueById("DrugExosPuncExos-882",data)=="��"){
		ttPuncExos="������-������������"+$g(data["DrugExosPuncExos-905-907-909"])+"��";
	}
	if(getRadioValueById("DrugExosPuncExos-882",data)=="��"){
		kyPuncExos="����Χ"+$g(data["DrugExosPuncExos-917-919-921"])+"��"+$g(data["DrugExosPuncExos-917-919-923"])+"cm2";
	}
	
	htmlStr=htmlStr+initTableTdOne("���ף�"+getRadioValueById("DrugExosPuncExos-882",data)+hzPuncExos,2,"","","");				// ����
	htmlStr=htmlStr+initTableTdOne("Ӳ�᣺"+getRadioValueById("DrugExosPuncExos-902",data),3,"","","");				// Ӳ��
	htmlStr=htmlStr+initTableTdOne("��ʹ��"+getRadioValueById("DrugExosPuncExos-905",data)+ttPuncExos,4,"","","</tr>");				// ��ʹ
	htmlStr=htmlStr+initTableTdOne("���ȸУ�"+getRadioValueById("DrugExosPuncExos-911",data),2,"","","<tr>");				// ���ȸ�
	htmlStr=htmlStr+initTableTdOne("ˮ�ݣ�"+getRadioValueById("DrugExosPuncExos-914",data),3,"","","");				// ˮ��
	htmlStr=htmlStr+initTableTdOne("����"+getRadioValueById("DrugExosPuncExos-917",data)+kyPuncExos,4,"","","</tr>");				// ����
	htmlStr=htmlStr+initTableTdOne("�ؽڻ��"+getRadioValueById("DrugExosPuncExos-925",data),5,"","","<tr>");				// �ؽڻ
	htmlStr=htmlStr+initTableTdOne("��֫Զ��Ѫ�ˣ�"+getRadioValueById("DrugExosPuncExos-928",data),4,"","","</tr>");				// ��֫Զ��Ѫ��
	htmlStr=htmlStr+initTableTr("�����׷ּ���"+getRadioValueById("DrugExosPhleClass",data),10,"");		// �����׷ּ�
	htmlStr=htmlStr+initTableTr("�����ּ���"+getRadioValueById("DrugExosSeepClass",data),10,"");		// �����ּ�
	var DrugExosTreatMeas=radioValue("DrugExosTreatMeas-933,DrugExosTreatMeas-934,DrugExosTreatMeas-935,DrugExosTreatMeas-936",data);
	if(radioValue("DrugExosTreatMeas-937",data)!=""){
		DrugExosTreatMeas=DrugExosTreatMeas+"��ҩ��ֲ���գ�������ҩ����"+radioValue("DrugExosTreatMeas-937",data)
	}
	
	var TreatMeasDrugStr=getRadioById(RepID,"DrugExosTreatMeas-938");
	var TreatMeasDrug=TreatMeasDrugStr.split("%");
	var len=TreatMeasDrug.length;
	var TreatMeasDrugList="";
	if(TreatMeasDrug!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var TreatMeasDrugArr=TreatMeasDrug[i].split("!");
			if(TreatMeasDrugArr[1]==""){
				TreatMeasDrugList=TreatMeasDrugList+"  "+j+"��"+TreatMeasDrugArr[0];
			}
			if(TreatMeasDrugArr[0].indexOf("��")==-1){
				if(TreatMeasDrugArr[1]!=""){
			 		TreatMeasDrugList=TreatMeasDrugList+"  "+j+"��"+TreatMeasDrugArr[0]+"��"+TreatMeasDrugArr[1];
			 	}
			}else{
			 if(TreatMeasDrugArr[1]!=""){
		     	TreatMeasDrugList=TreatMeasDrugList+"  "+j+"��"+TreatMeasDrugArr[0]+TreatMeasDrugArr[1];
			 }
		   }   
		}
	}
	if(TreatMeasDrugList!=""){
		TreatMeasDrugList="������ҩ�����ʸ���("+TreatMeasDrugList+")";
	}
	
	var TreatMeasHz=getRadioValueById("DrugExosTreatMeas-947",data);
	if(TreatMeasHz!=""){
		TreatMeasHz="�������("+TreatMeasHz+")";
	}
	
	
	htmlStr=htmlStr+initTableTr("�����ʩ��"+DrugExosTreatMeas+TreatMeasDrugList+TreatMeasHz,10,"");		// �����ʩ
	htmlStr=htmlStr+initTableTr("�������˵����"+$g(data["DrugExosAssother"]),10,"");		// �������˵��

	htmlStr=htmlStr+initTableTr("�����¼���������ԭ�� ","10","font-weight:bold;font-size:16px;");							// �����¼���������ԭ�� 
	var DrugExosByPatPhyFact=radioValue("DrugExosByPatPhyFact-799,DrugExosByPatPhyFact-800,DrugExosByPatPhyFact-803,DrugExosByPatPhyFact-804",data);
	if(radioValue("DrugExosByPatPhyFact-801",data)!=""){
		DrugExosByPatPhyFact=DrugExosByPatPhyFact+"����ͷ��λ��"+getRadioValueById("DrugExosByPatPhyFact-801",data)+"��";
	}	
	htmlStr=htmlStr+initTableTr("1���벡��������Ϊ������أ�"+DrugExosByPatPhyFact,10,"");			// �벡��������Ϊ�������
	htmlStr=htmlStr+initTableTr("2���빤��״̬/�������������أ�"+getRadioValueById("DrugExosByWorkStat",data),10,"");			// �빤��״̬/��������������
	htmlStr=htmlStr+initTableTr("3������Ա����������أ�"+getRadioValueById("DrugExosByPerFact",data),10,"");			// ����Ա�����������
	htmlStr=htmlStr+initTableTr("4�����е��������أ�"+getRadioValueById("DrugExosByMechFact",data),10,"");			// ���е���������
	htmlStr=htmlStr+initTableTr("5����ҩ��������أ�"+getRadioValueById("DrugExosByPhmcFact",data),10,"");			// ��ҩ���������
	htmlStr=htmlStr+initTableTr("6��������������أ�"+getRadioValueById("DrugExosByBlockFact",data),10,"");			// �������������



	htmlStr=htmlStr+initTableTr("����������ҩ�淶","10","font-weight:bold;font-size:16px;");							// ����������ҩ�淶
	htmlStr=htmlStr+initTableTr("������ҩ�淶��"+getRadioValueById("DrugExosByLocDrug",data)+"��"+getRadioValueById("DrugExosByLocDrug-838",data),10,"");				// ������ҩ�淶

	htmlStr=htmlStr+initTableTdOne("���浥λ��"+$g(data["RepHospType"]),3,"","","<tr>");	//���浥λ
	htmlStr=htmlStr+initTableTdOne("��ϵ�绰��"+$g(data["HospPhone"]),3,"","","");	//��ϵ�绰
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReportDate"]),4,"","","</tr>");	//��������

	htmlStr=htmlStr+initTableTdOne("���������"+$g(data["RepUserName"]),3,"","","<tr>");	//�������
	htmlStr=htmlStr+initTableTdOne("���ְ�ƣ�"+$g(data["RepUserTitle"]),3,"","","");   	//���ְ��	
	htmlStr=htmlStr+initTableTdOne("��˹������ޣ�"+$g(data["RepUserWorkYears"]),4,"","","</tr>");   	//��˹�������	

	htmlStr=htmlStr+initTableTr("�����¼�����������(��ʿ����д)��"+getRadioValueById("OccurAfterDealMethod",data),10,"");			// �����¼�����������(��ʿ����д)
	var DeptIfOccSimEvent=getRadioValueById("DeptIfOccSimEvent",data);
	if(DeptIfOccSimEvent=="��"){
		DeptIfOccSimEvent=DeptIfOccSimEvent+"  ����ȣ��Σ���"+$g(data["DeptIfOccSimEvent-94119-94120"]);
	}	
	htmlStr=htmlStr+initTableTr("�����Ƿ��������Ƶ��¼���"+DeptIfOccSimEvent,10,"");				// �����Ƿ��������Ƶ��¼�
	htmlStr=htmlStr+initTableTr("�������۷��������Ĵ�ʩ���������(��ʿ����д)",10,""); 	//�ٴ�����׼�����
	var ReasonStr=getRadioById(RepID,"NurReasonCase");
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var NurReasonCase="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("��")==-1){
				if(ReasonArr[1]!=""){
			 		NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0]+"��"+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	NurReasonCase=NurReasonCase+"  "+j+"��"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("ԭ�������"+NurReasonCase,10,"");				// ԭ�����
	var NurCorrectAction=radioValue("NurCorrectAction-296,NurCorrectAction-297,NurCorrectAction-298,NurCorrectAction-299,NurCorrectAction-300,NurCorrectAction-302",data);
	if(radioValue("NurCorrectAction-301",data)!=""){
		NurCorrectAction=NurCorrectAction+"���޶��ƶ�/����/ְ��ȣ�"+radioValue("NurCorrectAction-301",data)
	}
	htmlStr=htmlStr+initTableTr("���Ĵ�ʩ��"+NurCorrectAction,10,"");   // ���Ĵ�ʩ
	var NurDisposition=radioValue("NurDisposition-306,NurDisposition-307,NurDisposition-309",data);
	if(radioValue("NurDisposition-308",data)!=""){
		NurDisposition=NurDisposition+"�������˼������ԱΥ���ƶ�/����/ְ����۷���"+radioValue("NurDisposition-308",data)
	}
	htmlStr=htmlStr+initTableTr("���������"+NurDisposition,10,"");   // �������
	htmlStr=htmlStr+initTableTdOne("��ʿ��ǩ����"+$g(data["NurHeadNurse"]),6,"","","<tr>");				// ��ʿ��ǩ��
	htmlStr=htmlStr+initTableTdOne("ǩ�����ڣ�"+$g(data["NurSignDate"]),3,"","","</tr>");				// ǩ������
	
	htmlStr=htmlStr+initTableTr("���߰�ȫ����С����н����ָ�����",10,""); 	//���߰�ȫ����С����н����ָ�����
	htmlStr=htmlStr+initTableTr("1.���������"+getRadioValueById("PatSafeGroupResult-label-603",data),10,"");				// 1.�������
	htmlStr=htmlStr+initTableTr("2.���Ҵ��������"+getRadioValueById("PatSafeGroupResult-label-606",data) ,10,"");   // 2.���Ҵ������
	htmlStr=htmlStr+initTableTr("3.������"+$g(data["PatSafeGroupResult-label-609"]) ,10,"");   // 3.����
	htmlStr=htmlStr+initTableTdOne("����ȫС������ˣ�"+$g(data["NurTeamReferPerson"]),6,"","","<tr>");				// ����ȫС�������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["ReferDate"]),4,"","","</tr>");				// ��������
	
	htmlStr=htmlStr+"</table>";
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if(($(this).html()!="")){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if(($("#printTable").height()>pageHeight*cuPage)) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show();
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}
//ҩƷ�������浥��ӡ
function printAdvdrugqualityData(data){
	
   var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//����һ������
	htmlStr=htmlStr+initTableTr("ҩƷ�������浥","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//����һ������
	htmlStr=htmlStr+initTableTr("�¼���� :"+$g(data["EventNum"]),10,"");     	 //�¼����
	htmlStr=htmlStr+initTableTdOne("�ϱ��� :"+$g(data["ReportPer"]),3,"","","<tr>");			 //�ϱ���
	htmlStr=htmlStr+initTableTdOne("�ϱ�ʱ�� :"+$g(data["ReportTime"]),7,"","","","</tr>");  //�ϱ�ʱ��
	
	htmlStr=htmlStr+initTableTr("���߻�����Ϣ","10","font-weight:bold;font-size:16px;");			//���߻�����Ϣ
	htmlStr=htmlStr+initTableTdOne("�ǼǺ� :"+$g(data["PatNo"]),3,"","","<tr>");   	//�ǼǺ�
	htmlStr=htmlStr+initTableTdOne("�����ţ�"+$g(data["PatMedicalNo"]),3,"","","");	//������
	htmlStr=htmlStr+initTableTdOne("���壺"+$g(data["PatNational"]),4,"","","</tr>");	//����

	htmlStr=htmlStr+initTableTdOne("������"+$g(data["AdmName"]),3,"","","<tr>");  					//����
	htmlStr=htmlStr+initTableTdOne("�������䣺"+$g(data["MedNewRepPatAge"]),3,"","","");	//��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["PatDOB"]),4,"","","</tr>");				//��������
	htmlStr=htmlStr+initTableTdOne("�����Ա�"+$g(data["PatSexinput"]),3,"","","<tr>");	//�Ա�	
	htmlStr=htmlStr+initTableTdOne("�������أ�"+$g(data["PatWeight"]),3,"","","");				//��������
	htmlStr=htmlStr+initTableTdOne("�绰��"+$g(data["MedNewRepTel"]),4,"","","</tr>");				//�绰
	htmlStr=htmlStr+initTableTr("��ϣ�"+$g(data["Disease"]),"10","");	//���
	htmlStr=htmlStr+initTableTr("������ң�"+$g(data["admLoc"]),"10","");	//�������

	htmlStr=htmlStr+initTableTr("�¼�������Ϣ","10","font-weight:bold;font-size:16px;");		//�¼�������Ϣ

	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["admLoc"]),6,"","","<tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("�������ڣ�"+$g(data["admLoc"]),4,"","","</tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("�������ң�"+$g(data["OccurLoc"]),6,"","","<tr>");	//��������
	htmlStr=htmlStr+initTableTdOne("�ϱ��������ң�"+$g(data["ReportSubLoc"]),4,"","","</tr>");	//�ϱ���������
	htmlStr=htmlStr+initTableTr("�¼��ּ���"+getRadioValueById("drugreportlevel",data),"10","");		//�¼��ּ�
	htmlStr=htmlStr+initTableTr("�¼������ص㣺"+getRadioValueById("quaHapenplace",data),"10","");		//�¼������ص�

	var quadruglist=$g(data["quadruglist"]);  //����ҩƷ�б�
   	if(quadruglist!=""){
   		htmlStr=htmlStr+initTableTd("��Ʒ����","ͨ����","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("��Ӧ��","������ҵ","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("����","����","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("����","���","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTdOne("��װ����",2,"","background-color:#808080","</tr>");
	   	$(quadruglist).each(function(index,obj){
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94629"]),$g(obj["quadruglist-94630"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94631"]),$g(obj["quadruglist-94632"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94633"]),$g(obj["quadruglist-94634"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94635"]),$g(obj["quadruglist-94636"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTdOne($g(obj["quadruglist-94637"]),2,"","","</tr>");	
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�л���ҩƷ","10","");
	}
	htmlStr=htmlStr+initTableTr("�Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ�������ϣ�"+getRadioValueById("cancopyinfoma",data),10,""); //�Ƿ��ܹ��ṩҩƷ��ǩ��������ӡ��������

	htmlStr=htmlStr+initTableTr("�¼�����������"+$g(data["reportpass"]),10,""); 						//�¼���������
	
	var admheartlevellist="";
	var admheartlevel=radioValue("admheartlevel-94648,admheartlevel-94651",data);
	var admheartlevelsw=radioValue("admheartlevel-94645",data);
	var admheartlevelcw=radioValue("admheartlevel-94647",data);
	var admheartlevelzs=radioValue("admheartlevel-94649",data);
	var admheartlevelyj=radioValue("admheartlevel-94650",data);
	var admheartlevelhf=radioValue("admheartlevel-94652-94653,admheartlevel-94652-94654,admheartlevel-94652-94655",data);
	if(admheartlevel!=""){
		admheartlevellist=admheartlevel;
	}
	if(admheartlevelsw!=""){
		admheartlevellist="����(ֱ������)��"+admheartlevelsw+"   ����ʱ�䣺"+$g(data["admheartlevel-94646"]);
	}
	if(admheartlevelcw!=""){
		admheartlevellist="������Σ��������(����)��"+admheartlevelcw;
	}
	if(admheartlevelzs!=""){
		admheartlevellist="��ʱ�˺�(��λ���̶�)��"+admheartlevelzs;
	}
	if(admheartlevelyj!=""){
		admheartlevellist="�������˺�(��λ���̶�)��"+admheartlevelyj;
	}
	htmlStr=htmlStr+initTableTr("�����˺������"+admheartlevellist,10,""); 	//�����˺����
	htmlStr=htmlStr+initTableTr("�ָ����̣�"+admheartlevelhf,10,""); 	//�ָ�����
	htmlStr=htmlStr+initTableTr("�����¼����أ�"+getRadioValueById("drugquafactor",data),10,""); //�����¼�����
	htmlStr=htmlStr+initTableTr("�¼����������"+$g(data["drugcondition"]),10,""); 						//�¼��������
	htmlStr=htmlStr+initTableTr("�Ľ���ʩ��"+$g(data["correcactions"]),10,""); 						//�Ľ���ʩ
	htmlStr=htmlStr+initTableTr("���Ҹ����ˣ�"+$g(data["LocLeading"]),"10","")		//���Ҹ�����
	htmlStr=htmlStr+"</table>";
	$("#testTable").append(htmlStr);
	$("body").append("<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>")
	$("#tableData").append(htmlStr);
	$("#tableData").find("tr").each(function(){
		if($(this).html()!=""){
		var htmlStr = "<tr>"+$(this).html()+"</tr>";
		$("#printTable").append(htmlStr);
		if($("#printTable").height()>pageHeight*cuPage) {
			isNextPage($("#printTable"),$(htmlStr).find("td").html(),$(htmlStr).find("td").html(),$(htmlStr));
		}}
	})
	$("#footer").show(); 
	//printOrExportHtml()  // ���ô�ӡ�򵼳�
}

// ��td������(ֵ,�ϲ���Ԫ����,css,tr��ǩ)
// return : <tr><td>ֵ</td> 
// return : <td>ֵ</td>
// return : <td>ֵ</td></tr>
function initTableTdOne(value,colspan,rowspan,valueCss,tr){
	var htmlStr="";
	htmlStr=htmlStr+"<td style="+'"'+valueCss+'"'+ " colspan="+colspan+" rowspan="+rowspan+">"+value+"</td>";
	if(tr=="<tr>"){
		htmlStr=tr+htmlStr
	}else if(tr=="</tr>"){
		htmlStr=htmlStr+tr
		}
	return htmlStr;
	}

// ˫td������(��ͷ,ֵ,��ͷ�ϲ���Ԫ����,ֵ�ϲ���Ԫ����,��ͷcss,ֵcss,tr��ǩ)
// return : <tr><td>��ͷ</td><td>ֵ</td></tr>
// return : <td>��ͷ</td><td>ֵ</td>
// return : <td>��ͷ</td><td>ֵ</td></tr>

function initTableTd(title,value,titleCol,valueCol,titleCss,valueCss,tr){
	var htmlStr="<td style="+'"'+titleCss+'"'+ " colspan="+titleCol+">"+title+"</td>"
	htmlStr=htmlStr+"<td style="+'"'+valueCss+'"'+ " colspan="+valueCol+">"+value+"</td>"
	if(tr=="<tr>"){
		htmlStr=tr+htmlStr
	}else if(tr=="</tr>"){
		htmlStr=htmlStr+tr
		}
	return htmlStr;
	}

// tr ������(��ͷ���ϲ���Ԫ������css)
// return : <tr><td>...</td></tr>
function initTableTr(title,clospan,css){
	var htmlStr=""
	var htmlStr="<tr><td style="+'"'+css+'"'+ " colspan="+clospan+">"+title+"</td></tr>"
	return htmlStr;
	}

// ���td  ����(ֵ^ֵ^ֵ^ֵ^ֵ^ֵ^ֵ^ֵ^....)
// return : <tr><td>...</td><td>...</td><td>...</td>...</tr>
function initTableTdmor(tdStr,css){
	var length=tdStr.split("^").length;
	var htmlStr="<tr>"
	for(var i=0;i<length;i++){
		htmlStr=htmlStr+"<td style="+'"'+css+'"'+ ">"+tdStr.split("^")[i]+"</td>"
		}
	htmlStr=htmlStr+"</tr>"
	return htmlStr;
	}
	
	
//ȡֵ��,����δ����ı���
function $g(param){
	return param==undefined?"":	param;
}
//ȡֵ��,ͨ������idȡֵ
function getRadioValueById(param,data){
	if(param==="") return "";
	var rtn=serverCall("web.DHCADVCOMMONPRINT","getRadioChildList",{"field":param});
	var ret=[]
	
	paramArray = rtn.split("^");
	
	for(var i =0;i<paramArray.length;i++){
		if($g(data[paramArray[i]])!=""){
			ret.push($g(data[paramArray[i]]));
		}
	}
	return ret.join("�� ");
}

// �������ߴ�ӡ
function printOrExportHtml(){
	UlcerPrint()
	/*if(prtOrExp=="htmlPrint"){
		UlcerPrint()
	}else if(prtOrExp=="htmlExport"){
		
		exportPdf()

		}
	*/
	}
//��ӡ
function UlcerPrint(){
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //�ж��Ƿ���IE�����
		document.getElementById('WebBrowser').ExecWB(6,2)
		setTimeout(function (){							//�رյ�ǰҳ��
			// window.close();			 
			 },200)	
		
	}else{
		 window.print();
		 setTimeout(function (){
			 window.close();			 
			 },200)	
	}
	
 }
// ҳ�浼��pdf
function exportPdf(){

		
        var pdf = new jsPDF('p', 'mm', 'b3'); 
        var print_content = $('#PrintContent'); 
		$('#PrintContent').css("background","#ffffff" )
        var filename = 'hello.pdf'; 
        
        pdf.addHTML($('#PrintContent'), function(){
            pdf.output("save", filename)
        })
}

//IE ���ش�ӡʱ�ļ�·��������
function HiddenPathDate(){     		   
	var hkey_root,hkey_path,hkey_key;
	hkey_root="HKEY_CURRENT_USER"
	hkey_path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
	try{
 	 	var RegWsh = new ActiveXObject("WScript.Shell");
 		hkey_key="header";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"");
		hkey_key="footer";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"&b��&pҳ/��&Pҳ"); //&w&bҳ��,&p/&P

		}catch(e){}

}

function printbypage(pdf, k){
  if(k >= $('#PrintContent').length)
  {  var filename = 'hello.pdf'; 
		
      pdf.output("save", filename)
  }
  pdf.addHTML($('#PrintContent')[k], function(){
    if(k < $('#PrintContent').length - 1)
    {
      pdf.addPage();
    }
    printbypage(pdf, $('#PrintContent').length -k);
  });
};

function printmyshow() {
  var pdf = new jsPDF('p', 'mm', 'd1');
	$('#PrintContent').css("background","#ffffff" )
  printbypage(pdf, 100);
};

function getRadioById(advMaster,field){
	var rtn=serverCall("web.DHCADVCOMMONPRINT","getRadioList",{"AdvMasterDr":advMaster,"field":field});
	var length=rtn.split("$").length-1
	var rtnStr=""
	for(var i=1;i<length+1;i++){
		var str1=rtn.split("$")[i].split("!")[0];
		var str2=rtn.split("$")[i].split("!")[1];
		var length2=str2.split("^").length;
		var childList="";
		for(var j=1;j<length2;j++){
			var str3=str2.split("^")[j];
			if(str3!=""){
				if(childList==""){
					childList=str3;
					}else{
						childList=childList+","+str3;
					}
				}
			}
		if(rtnStr==""){
			rtnStr=str1+"!"+childList;

			}else{
		rtnStr=rtnStr+"%"+str1+"!"+childList;
			}
	}
	return rtnStr;

}
//radio��checkbox���ݻ�ȡ
function radioValue(param,data){
	//alert(param);
	var ret=[]
	
	if(param==="") return "";
	paramArray = param.split(",");
	
	for(var i =0;i<paramArray.length;i++){
		if($g(data[paramArray[i]])!=""){
			ret.push($g(data[paramArray[i]]));
		}
	}
	
	return ret.join("�� ");
}
//radio��checkbox���ݻ�ȡ  ������Ԫ��ƴ��
function checksubValue(data,param,subdata){
	//alert(param);
	var ret=[]
	if(param==="") return "";
	paramArray = param.split(",");
	for(var i =0;i<paramArray.length;i++){
		if($g(subdata[paramArray[i]])!=""){
			ret.push($g(subdata[paramArray[i]]));
		}
	}
	if (ret.join("�� ")!=""){
		data=data+"��"+ret.join("�� ")+"��";
	}
	return data;
}

// ��ʿ����������
function HeadNurPrintInfo(HeadNurEvaList,RepFlag){
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("��ʿ��������ԭ�����","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("һ�����ᱨ��","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("���ᱨ�����ڣ�"+ $g(HeadNurEvaList["MornRepMeetDate"])+" "+$g(HeadNurEvaList["MornRepMeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("����ص㣺"+ $g(HeadNurEvaList["MornRepMeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("������Ա��"+ $g(HeadNurEvaList["MornRepMeetpants"]),"10","");
	htmlStr=htmlStr+initTableTr("�������ݣ�"+ $g(HeadNurEvaList["MornRepMeetContent"]),"10","");
	
	htmlStr=htmlStr+initTableTr("�������һ������¼�����","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("�������ڣ�"+ $g(HeadNurEvaList["MeetDate"])+" "+$g(HeadNurEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("����ص㣺"+ $g(HeadNurEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("�λ���Ա��"+ $g(HeadNurEvaList["Participants"]),"10","");
	if((RepFlag!="")&&(RepFlag!=undefined)){
		htmlStr=htmlStr+initTableTr("ԭ�����","10","font-weight:bold;font-size:16px;"); //ԭ�����
		htmlStr=htmlStr+initTableTr($g(HeadNurEvaList["CauseAnalysis-text"]),"10","");
	}
	htmlStr=htmlStr+initTableTr("�����Ľ�����ӦҪ�ؼ���ԭ��","10","font-weight:bold;font-size:16px;");
	var CaseImprovement=$g(HeadNurEvaList["CaseImprovement"])
	CaseImprovement=CaseImprovement.replace(/\n/g,'<br/>');
	CaseImprovement=CaseImprovement.replace(/\t\t\t/g,'<br/>');
	htmlStr=htmlStr+initTableTr(CaseImprovement,"10","");
	var ManaImprovementList="";
	var ManaImprovement=$g(HeadNurEvaList["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",HeadNurEvaList); 
	if (ManaImprovement!=""){
		ManaImprovementList="����Ľ���  �ƶȡ����̼��淶�ƶ����޶���"+ManaImprovementzdoth+"���ƣ�"+ManaImprovement+"����";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",HeadNurEvaList); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		ManaImprovementList="����Ľ���"+ManaImprovementoth
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		ManaImprovementList=ManaImprovementoth;
	}
	htmlStr=htmlStr+initTableTr("����Ľ�","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //����Ľ�
	if(ManaImprovementList!="")	{
		htmlStr=htmlStr+initTableTr(ManaImprovementList,"10","border-top:0px"); //����Ľ�
	}
	htmlStr=htmlStr+initTableTr("��ʿ��׷�ټ�����","10","font-weight:bold;font-size:16px;");
	var HeadNurEvaluateList=$g(HeadNurEvaList["HeadNurEvaluate"]);//��ʿ������
   	if(HeadNurEvaluateList!=""){
   		htmlStr=htmlStr+initTableTdOne("����ʱ��","","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("�������","","","background-color:#808080;width:15%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("��������","","","background-color:#808080;width:25%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("������","","","background-color:#808080;width:30%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("������","","","background-color:#808080;text-align:center;","</tr>");

	   	$(HeadNurEvaluateList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94393-94398"]),"","","width:15%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94394-94399"]),"","","width:15%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94395-94400"]),"","","width:25%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94396-94401"]),"","","width:30%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94397-94403"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�л�ʿ��������Ϣ","10","");
	}
	
	htmlStr=htmlStr+initTableTr("����Ч������","10","font-weight:bold;font-size:16px;");
	var AftImpMeasuresList="";
	if ((RepFlag!="")&&(RepFlag!=undefined)&&(RepFlag.indexOf("Ժ�����")>=0)){
		var UlcNurImpMeasures=radioValue("UlcNurImpMeasures-label-94930,UlcNurImpMeasures-label-94931",HeadNurEvaList); 
		if(UlcNurImpMeasures!=""){
			AftImpMeasuresList=AftImpMeasuresList+"\nԺ��ѹ���������ʩ��ʵЧ����"+UlcNurImpMeasures+"��";
		}
		var UlcNurImpMeasuresoth=$g(HeadNurEvaList["UlcNurImpMeasures-label-94932-94933"]);  //δ��ʵ δ��ʵԭ�� 
		if ((UlcNurImpMeasuresoth!="")){
			AftImpMeasuresList=AftImpMeasuresList+"\nԺ��ѹ���������ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+UlcNurImpMeasuresoth+"��";
		}
	}else{
		var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",HeadNurEvaList); 
		if(AftImpMeasures!=""){
			AftImpMeasuresList=AftImpMeasuresList+"�¼����������Ĵ�ʩ��ʵЧ����"+AftImpMeasures+"��";
		}
		var AftImpMeasuresoth=$g(HeadNurEvaList["AftImpMeasures-94925-94927"]);  //δ��ʵ δ��ʵԭ�� 
		if ((AftImpMeasuresoth!="")){
			AftImpMeasuresList=AftImpMeasuresList+"�¼����������Ĵ�ʩ��ʵЧ����δ��ʵ δ��ʵԭ��"+AftImpMeasuresoth+"��";
		}
	}
	htmlStr=htmlStr+initTableTr(AftImpMeasuresList,"10","");
	htmlStr=htmlStr+initTableTr("�����¼��д��"+ radioValue("ManaIfStandard-94455,ManaIfStandard-94456",HeadNurEvaList),"10","");
	
	return htmlStr;
}
///�ƻ�ʿ����������	
function SetLocHeaNurPrintInfo(LocHeadNurEvaList){	
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("�ƻ�ʿ��������ԭ�����","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("һ����ƻ������¼�������Ч������","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("�������ڣ�"+ $g(LocHeadNurEvaList["MeetDate"])+" "+$g(LocHeadNurEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("����ص㣺"+ $g(LocHeadNurEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("�λ���Ա��"+ $g(LocHeadNurEvaList["Participants"]),"10","");
	htmlStr=htmlStr+initTableTr("���Ұ���������ʱ�ԣ�"+ getRadioValueById("LocCaseTimeliness",LocHeadNurEvaList),"10","border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("ԭ������ҵ�����"+ getRadioValueById("FindReason",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",LocHeadNurEvaList); 
	var BefPreventMeasuresipt=$g(LocHeadNurEvaList["BefPreventMeasures-94439"]);  //�������
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		BefPreventMeasuresipt=" ������֣�"+BefPreventMeasuresipt+"��";
	}
	htmlStr=htmlStr+initTableTr("����ǰ������ʩ��ʵ�����"+ BefPreventMeasures+BefPreventMeasuresipt,"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("����ǰ������ʩδ��ʵ��ԭ�򣺾�����֣�"+ getRadioValueById("BefPreMeaReason",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�¼����������Ĵ�ʩ������ԣ�"+ getRadioValueById("AftImpPertinence",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�¼����������Ĵ�ʩ��ʵ�ļ�ʱ�ԣ�"+ getRadioValueById("AftImpTimeliness",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("��ʿ��������ʵ�ĺۼ���"+ getRadioValueById("HeadNurReformMark",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�����¼��д��"+ getRadioValueById("ManaIfStandard",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("��������"+ $g(LocHeadNurEvaList["LocHeadView"]),"10","border-top:0px;");
	
	htmlStr=htmlStr+initTableTr("�����ƻ�ʿ��׷�ټ�¼","10","font-weight:bold;font-size:16px;");
	var LocHeadNurEvaluateList=$g(LocHeadNurEvaList["LocHeadNurEvaluate"]);//�ƻ�ʿ������
   	if(LocHeadNurEvaluateList!=""){
   		htmlStr=htmlStr+initTableTdOne("����ʱ��","","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("�������","","","background-color:#808080;width:15%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("��������","","","background-color:#808080;width:25%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("������","","","background-color:#808080;width:30%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("������","","","background-color:#808080;text-align:center;","</tr>");

	   	$(LocHeadNurEvaluateList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94422-94427"]),"","","width:15%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94423-94428"]),"","","width:15%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94424-94429"]),"","","width:25%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94425-94430"]),"","","width:30%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94426-94431"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�пƻ�ʿ��������Ϣ","10","");
	}
	return htmlStr;
}
///������������	
function SetNurDepPrintInfo(NurDepEvaList){
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("����������ԭ�����","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("һ�������������¼�������Ч������","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("�������ڣ�"+ $g(NurDepEvaList["MeetDate"])+" "+$g(NurDepEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("����ص㣺"+ $g(NurDepEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("�λ���Ա��"+ $g(NurDepEvaList["Participants"]),"10","");
	htmlStr=htmlStr+initTableTr("�������¼�����"+ getRadioValueById("RepLevel",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("���Ұ���������ʱ�ԣ�"+ getRadioValueById("MLocCaseTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("����Ұ���������"+ getRadioValueById("HadeLocCaseTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("ԭ������ҵ�����"+ getRadioValueById("FindReason",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",NurDepEvaList); 
	var BefPreventMeasuresipt=$g(NurDepEvaList["BefPreventMeasures-94439"]);  //�������
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		BefPreventMeasuresipt=" ������֣�"+BefPreventMeasuresipt+"��";
	}
	htmlStr=htmlStr+initTableTr("����ǰ������ʩ��ʵ�����"+ BefPreventMeasures+BefPreventMeasuresipt,"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("����ǰ������ʩδ��ʵ��ԭ�򣺾�����֣�"+ getRadioValueById("BefPreMeaReason",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�¼����������Ĵ�ʩ������ԣ�"+ getRadioValueById("AftImpPertinence",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�¼����������Ĵ�ʩ��ʵ�ļ�ʱ�ԣ�"+ getRadioValueById("AftImpTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("��ʿ��������ʵ�ĺۼ���"+ getRadioValueById("HeadNurReformMark",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�ƻ�ʿ��������ʵ�ĺۼ���"+ getRadioValueById("LocHeadNurReformMark",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("�����¼��д��"+ getRadioValueById("ManaIfStandard",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	if(getRadioValueById("InSkiUlcQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("Ժ��ѹ���¼����ԣ�"+ getRadioValueById("InSkiUlcQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}
	if(getRadioValueById("DrugErrQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("��ҩȱ���¼����ԣ�"+ getRadioValueById("DrugErrQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}
	if(getRadioValueById("OthQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("�����¼����ԣ�"+ getRadioValueById("OthQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}

	htmlStr=htmlStr+initTableTr("�������ۣ�"+ getRadioValueById("OverEvaluation",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("��һ��Ҫ��"+ getRadioValueById("NextStep",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("���������"+ $g(NurDepEvaList["NurDepAdvice"]),"10","border-top:0px;");

	htmlStr=htmlStr+initTableTr("��������׷�ټ�¼","10","font-weight:bold;font-size:16px;");
	var NurDepRecordList=$g(NurDepEvaList["NurDepRecord"]);//����׷�ټ�¼
   	if(NurDepRecordList!=""){
   		htmlStr=htmlStr+initTableTdOne("����","1","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("��ʽ","1","","background-color:#808080;width:20%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("����","2","","background-color:#808080;width:50%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("��¼��","","","background-color:#808080;text-align:center;","</tr>");

	   	$(NurDepRecordList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94476-94480"]),"1","","width:15%;","<tr>");
			var NDRmode=radioValue("NurDepRecord-94470-94477-94481,NurDepRecord-94470-94477-94482,NurDepRecord-94470-94477-94483,NurDepRecord-94470-94477-94484",obj); //��ʽ
			htmlStr=htmlStr+initTableTdOne(NDRmode,"1","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94478-94485"]),"2","","width:50%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94479-94486"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("�ñ���û�л���׷����Ϣ","10","");
	}
	return htmlStr;
}
//html��ӡǿ�Ʒ�ҳ
function isNextPage($tab,allText,text,$tr){
	var tabId = $($tab).attr("id");
	if(($tr!=undefined)&&($tr.find("td").length>1)){
		var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
		$(lastTr).remove();//2018-11-28 ȥ����һ��ҳ������һ��
		$($tab).parent().append("<div class='pageNext'></div>");
		$($tab).removeAttr("id");
		$($tab).parent().append("<table id="+tabId+"></table>")
		$tab = $("#"+tabId);
		$($tab).append($(lastTr)); //2018-11-28 �µı�������ҳ���һ������
		return;
	}
	if(!($tab.height()>pageHeight*cuPage)&&(text.length!=0)){ //��ҳǰ���һ�����ݳ���һҳ������ж�
		//cuPage=cuPage+1;
		var nextText = allText.substring(text.length,allText.length);
		$($tab).parent().append("<div class='pageNext'></div>");
		$($tab).removeAttr("id");
		$($tab).parent().append("<table id="+tabId+"></table>")
		$tab = $("#"+tabId);
		$($tab).append("<tr><td colspan='10'>"+nextText+"</td></tr>");
		if(($tab.height()>pageHeight*cuPage)){
			isNextPage($tab,nextText,nextText);
		}
		return;
	}
	
	 if(text.length==0){ //��ҳǰ���һ�����ݲ�����һҳ������ж�
		//cuPage=cuPage+1;
		var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
		//$(lastTr).find("td").html(""); //2018-11-28 
		$(lastTr).remove();//2018-11-28 ȥ����һ��ҳ������һ��
		$($tab).parent().append("<div class='pageNext'></div>");
		$($tab).removeAttr("id");
		$($tab).parent().append("<table id="+tabId+"></table>")
		$tab = $("#"+tabId);
		$(lastTr).find("td").html(allText); //2018-11-28 ��ֵ
		$($tab).append($(lastTr)); //2018-11-28 �µı�������ҳ���һ������
		return;
	} 
		
	
	var newText = getTextTakeOurOneWord(text);
	var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
	$(lastTr).find("td").html(newText);
	isNextPage($tab,allText,newText);
	return;
}
//html��ӡǿ�Ʒ�ҳ ��ȡ�µ��ַ���
function getTextTakeOurOneWord(text){
	var textlist=text.replace(/<br>/g,"$");
	var textlist=text.replace(/<br\s*\/?>/g,"$");
	var val=text.substring(0,text.length - 1);
	val=val.replace(/\$/g,"<br />");
	return val;
}
