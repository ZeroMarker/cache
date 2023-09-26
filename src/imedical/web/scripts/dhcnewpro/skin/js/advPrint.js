/// ���浥��ӡ
function printRepForm(ID,RepTypeCode)
{
	if(ID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}	
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintData",
	{AdvMasterDr:ID},
	function(ret){
		//ѹ�����浥
		if(RepTypeCode=="advSkinUlcer"){  
			printSkinUlcerData(ret);
		}
		//ҽ�ƻ�����շ���(��©/����)�¼����浥
		if(RepTypeCode=="advWallLeakage"){  
			printWallLData(ret);
		}
		//��·���䱨�浥
		if(RepTypeCode=="advPipeOff"){  
			printPipeOffData(ret);
		}
		//�����¼����浥
		if(RepTypeCode=="advAccidentFill"){  
			printAccidentData(ret); //
		}
		//��ҩ���󱨸浥
		if(RepTypeCode=="advDrugUseErr"){ 
			printDrugErrData(ret);
		}
		//����(׹��)�¼����浥	
		if(RepTypeCode=="advFallDownFill"){  
			printFallDownData(ret);
		}
		//һ����ҽ����Ʒ�����¼����浥
		if(RepTypeCode=="advDisMedThing"){  
			printDisMedData(ret);
		}
		
	});
	return ;
	
}
function printDrugErrData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_DrugUseErr.xls";
	//var Template = "D:/DHCADV_DrugUseErr.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //��������
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //������
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //��������
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //�Ա�
	objSheet.Cells(4,5).value="�ǼǺţ�"; //�ǼǺ�
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //�ǼǺ�
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //����
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //��һ���
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //������Դ
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //��Ժ����
	objSheet.Cells(9,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //������
	objSheet.Cells(10,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //�Ļ��̶�
	
	objSheet.Cells(12,1).value="��ҩ�������ڣ�"+$g(data["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]); //��ҩ��������
	objSheet.Cells(13,2).value=radioValue("DrugUseHappenPlace-label-94587,DrugUseHappenPlace-label-94588,DrugUseHappenPlace-label-94589,DrugUseHappenPlace-label-94590,DrugUseHappenPlace-label-94591",data); //�����ص�
	objSheet.Cells(14,2).value=radioValue("DrugUsePartyTitle-94597,DrugUsePartyTitle-94599,DrugUsePartyTitle-94611,DrugUsePartyTitle-94612",data); //������ְ��
	objSheet.Cells(15,1).value="�����˹������ޣ�"+$g(data["DrugUsePartyWorkYears"]); //�����˹�������
	
	objSheet.Cells(16,2).value=$g(data["PartyName"]); //����������
	objSheet.Cells(16,4).value=$g(data["DrugUseErrLevel"]); //�ܼ�
	objSheet.Cells(16,6).value=$g(data["Shift"]);  //���
	
	objSheet.Cells(17,2).value=radioValue("DrugUseErrRank-95145,DrugUseErrRank-95146,DrugUseErrRank-95147,DrugUseErrRank-95148,DrugUseErrRank-95149,DrugUseErrRank-95150",data); //���������
	objSheet.Cells(18,2).value=$g(data["WallDiscover"]); //����������
	objSheet.Cells(18,4).value="";///$g(data["DisMedThingPatName"]); //ְ��  
	objSheet.Cells(18,6).value=$g(data["WLManWorkLife"]); //��������
	
	var list="";
	var dosetargeterr=$g(data["DrugUseErrType-94616"]); //��ҩ�������
	if (dosetargeterr!=""){
		list=list+dosetargeterr+"��";
	}

	var dosetimeerr=$g(data["DrugUseErrType-94617"]); //��ҩʱ�����
	var dosetime=$g(data["DrugUseErrType-94617-94204"]);//ҽ����ҩʱ��
	var errdosetime=$g(data["DrugUseErrType-94617-94205"]);//�����ҩʱ��
	if(dosetime!=""){
		dosetimeerr=dosetimeerr+"��"+"ҽ����ҩʱ��Ϊ"+dosetime+"��"+"�����ҩʱ��Ϊ"+errdosetime
	}
	if (dosetimeerr!=""){
		list=list+dosetimeerr+"��";
	}
	
	var dosewayerr=$g(data["DrugUseErrType-94618"]); //��ҩ;������
	var doseway=$g(data["DrugUseErrType-94618-94208"]);//ҽ����ҩ;��
	var errdoseway=$g(data["DrugUseErrType-94618-94209"]);//�����ҩ;��
	if(doseway!=""){
		dosewayerr=dosewayerr+"��"+"ҽ����ҩ;��Ϊ"+doseway+"��"+"�����ҩ;��Ϊ"+errdoseway
	}
	if (dosewayerr!=""){
		list=list+dosewayerr+"��";
	}
	
	var missdose=$g(data["DrugUseErrType-94619"]); //��©��ҩ
	var missnum=$g(data["DrugUseErrType-94619-94212"]);//��©����
	var missdosetime=$g(data["DrugUseErrType-94619-94213"]);//ҽ����ҩʱ��
	if(missnum!=""){
		missdose=missdose+"��"+"��©����Ϊ"+missnum+"��"+"ҽ����ҩʱ��Ϊ"+missdosetime
	}
	if (missdose!=""){
		list=list+missdose+"��";
	}
	
	var infusionspeed=$g(data["DrugUseErrType-94620"]); //��Һ�ٶȴ���
	var infudrugname=$g(data["DrugUseErrType-94620-94215"]);//ҩ������
	var errdoseinfusion=$g(data["DrugUseErrType-94620-94216"]);//�����ҩ�ٶ�
	if(infudrugname!=""){
		infusionspeed=infusionspeed+"��"+"ҩ������Ϊ"+infudrugname+"��"+"�����ҩ�ٶ�Ϊ"+errdoseinfusion
	}
	if (infusionspeed!=""){
		list=list+infusionspeed+"��";
	}
	
	var dosageerr=$g(data["DrugUseErrType-94621"]); //��������
	var dosedosage=$g(data["DrugUseErrType-94621-94219"]);//ҽ����ҩ����
	var errdosage=$g(data["DrugUseErrType-94621-94220"]);//�����ҩ���� 
	if(dosedosage!=""){
		dosageerr=dosageerr+"��"+"ҽ����ҩ����Ϊ"+dosedosage+"��"+"�����ҩ����Ϊ"+errdosage
	}
	if (dosageerr!=""){
		list=list+dosageerr+"��";
	}
	
	var dosageformerr=$g(data["DrugUseErrType-94622"]); //���ʹ���
	var dosedosageform=$g(data["DrugUseErrType-94622-94223"]);//ҽ����ҩ����
	var errdosageform=$g(data["DrugUseErrType-94622-94224"]);//�����ҩ���� 
	if(dosedosageform!=""){
		dosageformerr=dosageformerr+"��"+"ҽ����ҩ����Ϊ"+dosedosageform+"��"+"�����ҩ����Ϊ"+errdosageform
	}
	if (dosageformerr!=""){
		list=list+dosageformerr+"��";
	}
	
	var drugerr=$g(data["DrugUseErrType-94623"]); //ҩ�����
	var dosedrugname=$g(data["DrugUseErrType-94622-94223"]);//ҽ����ҩ����
	var errdrugname=$g(data["DrugUseErrType-94622-94224"]);//�����ҩ���� 
	if(dosedrugname!=""){
		drugerr=drugerr+"��"+"ҽ����ҩ����Ϊ"+dosedrugname+"��"+"�����ҩ����Ϊ"+errdrugname
	}
	if (drugerr!=""){
		list=list+drugerr+"��";
	}

	var drugvalidityerr=$g(data["DrugUseErrType-94624"]); //ҩ��Ч�ڴ���
	if (drugvalidityerr!=""){
		list=list+drugvalidityerr+"��";
	}

	var drugoth=$g(data["DrugUseErrType-94625"]); //����
	if (drugoth!=""){
		list=list+drugoth+"��";
	}
	
	var Drugrow=parseInt(list.length/45);
	var Drugheightlen=(Drugrow+1)*14;
	objSheet.Rows(20+":"+20).RowHeight = Drugheightlen; 
	objSheet.Cells(20,1).value=list;  //��������
	objSheet.Cells(22,1).value=radioValue("DrugUseDefectResult-label-94633,DrugUseDefectResult-label-94634,DrugUseDefectResult-label-94635,DrugUseDefectResult-label-94636,DrugUseDefectResult-label-94637,DrugUseDefectResult-label-94638",data); //ȱ������ĺ��
	objSheet.Cells(23,2).value=$g(data["RepHospType"]); //���浥λ
	objSheet.Cells(23,6).value=$g(data["HospPhone"]); //��ϵ�绰
	objSheet.Cells(24,2).value=$g(data["ReportDate"]); //��������
	
	objSheet.Cells(25,2).value=$g(data["RepUserName"]); //�������
	objSheet.Cells(25,4).value=$g(data["RepUserTitle"]); //ְ��
	objSheet.Cells(25,6).value=$g(data["RepUserWorkYears"]); //��������
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(27+":"+27).RowHeight = WLEheightlen; 
	objSheet.Cells(27,1).value=$g(data["WLEventProcess"]); //�¼�����
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(29+":"+29).RowHeight = dealWayheightlen;
	objSheet.Cells(29,1).value=$g(data["dealWay"]); //�����ʩ
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

/// �����¼����浥��ӡ
function printAccidentData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_AccidentFill.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //��������
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //������
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //��������
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //�Ա�
	objSheet.Cells(4,5).value="�ǼǺţ�"; //�ǼǺ�
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //�ǼǺ�
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //����
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //��һ���
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //������Դ
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //��Ժ����  
	objSheet.Cells(9,1).value="��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]); //��ԺʱADL�÷�
	objSheet.Cells(9,5).value="���������չ�������"+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //���������չ�����
	objSheet.Cells(10,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //�㻤��Ա
	
	
	objSheet.Cells(11,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //������
	objSheet.Cells(12,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //�Ļ��̶�
	
	objSheet.Cells(14,3).value=radioValue("AFType-94495,AFType-94498,AFType-94499,AFType-94500,AFType-94927,AFType-94978,AFType-94979,AFType-94980,AFType-94981,AFType-94165",data); //�����¼���������
	objSheet.Cells(15,2).value=$g(data["HappenTime"])+" "+$g(data["OccurTime"]); //��ҩ��������
	objSheet.Cells(16,2).value=radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data); //�����ص�
	objSheet.Cells(17,2).value=radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data); //������
	objSheet.Cells(18,3).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data); //�¼��������໤ʿְ��
	objSheet.Cells(19,2).value=$g(data["WLManWorkLife"]); //��������
	
	var eventresult=radioValue("AFResult-94565,AFResult-94567",data); //�¼���ɵĺ��
	var patHOD=radioValue("AFResult-94566-94923,AFResult-94566-94924,AFResult-94566-94925,AFResult-94566-94926",data); //����סԺ����
	if (patHOD!=""){
		eventresult=eventresult+"�� "+$g(data["AFResult-94566"])+"��"+patHOD+"��";
	}	
	
	objSheet.Cells(21,1).value=eventresult; //�¼���ɵĺ��  
	
	objSheet.Cells(22,2).value=$g(data["RepHospType"]); //���浥λ
	objSheet.Cells(22,6).value=$g(data["HospPhone"]); //��ϵ�绰
	objSheet.Cells(23,2).value=$g(data["ReportDate"]); //��������
	
	var row=parseInt($g(data["WLEventProcess"]).length/45);
	var heightlen=row*14;
	objSheet.Rows(25+":"+25).RowHeight = heightlen; 
	objSheet.Cells(25,1).value=$g(data["WLEventProcess"]); //�¼�����
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //����֪ͨ
	var deal=radioValue("PatEventProcess-95032",data); //���������¼�������
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"��"+notice+"���� "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"��ҽ�ƻ����ʩ��"+$g(data["PatEventProcess-95033"])+"��"
	}
	if($g(data["PatEventProcess-95034"])!=""){
		deal=deal+$g(data["PatEventProcess-95034"])
	}

	
	objSheet.Cells(27,1).value=deal; //���������¼�������
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

/// ҽ�ƻ�����շ�������©/�������¼����浥
function printWallLData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_WallLeakage.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["AFLoc"]); //��������
	objSheet.Cells(3,4).value=$g(data["EveType"]); //�¼����
	objSheet.Cells(3,6).value=$g(data["FindDate"]); //��������
	
	var Prow=parseInt($g(data["WLEventProcess"]).length/45);
	var Pheightlen=(Prow+1)*14;
	objSheet.Rows(5+":"+5).RowHeight = Pheightlen; 
	objSheet.Cells(5,1).value=$g(data["WLEventProcess"]); //�¼�����
	
	var CArow=parseInt($g(data["WLCauseAnalysis"]).length/45);
	var CAheightlen=(CArow+1)*14;
	objSheet.Rows(7+":"+7).RowHeight = CAheightlen; 
	objSheet.Cells(7,1).value=$g(data["WLCauseAnalysis"]); //ԭ�����
	
	var IMrow=parseInt($g(data["WLImprovedMethod"]).length/45);
	var IMheightlen=(IMrow+1)*14;
	objSheet.Rows(9+":"+9).RowHeight = IMheightlen; 
	objSheet.Cells(9,1).value=$g(data["WLImprovedMethod"]); //�Ľ��취
	
	objSheet.Cells(11,2).value=$g(data["WallDiscover"]); //������
	objSheet.Cells(11,4).value=$g(data["JobTitle"]); //ְ��
	objSheet.Cells(11,6).value=$g(data["Duty"]); //ְ��
	objSheet.Cells(12,2).value=$g(data["WallWorkYears"]); //��������
	objSheet.Cells(14,1).value=radioValue("RelatedAreas-93867,RelatedAreas-93868,RelatedAreas-93869,RelatedAreas-93870,RelatedAreas-93871",data);; //�������
	objSheet.Cells(15,3).value=radioValue("IfWLBehavior-93873,IfWLBehavior-93874",data); //���¼��Ƿ�Ϊ��©��Ϊ
	
	objSheet.Cells(16,2).value=$g(data["WLMan"]); //��©��
	objSheet.Cells(16,4).value=$g(data["WLManWorkLife"]); //��������
	objSheet.Cells(16,6).value=$g(data["WallLoc"]); //��©�˿���
	
	var Brow=parseInt($g(data["WLBehavior"]).length/45);
	var Bheightlen=(Brow+1)*14;
	objSheet.Rows(17+":"+18).RowHeight = Bheightlen; 
	objSheet.Cells(17,1).value="��©��Ϊ��"+$g(data["WLBehavior"]); //��©��Ϊ
	
	var QCrow=parseInt($g(data["QualityCommitteeOpinion"]).length/45);
	var QCheightlen=(QCrow+1)*14;
	objSheet.Rows(20+":"+20).RowHeight = QCheightlen; 
	objSheet.Cells(20,1).value=$g(data["QualityCommitteeOpinion"]); //����ίԱ�����
	objSheet.Cells(21,1).value="����¹����ʽ��ۣ�"+radioValue("EventConclusion-93884,EventConclusion-93885,EventConclusion-93886",data); //��©��Ϊ
	objSheet.Cells(21,4).value="��Ч������"+radioValue("PerformanceRewards-93888,PerformanceRewards-93889",data); //��©��Ϊ
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//һ����ҽ����Ʒ�����¼����浥
function printDisMedData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_DisMedThing.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;

	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //��������
	objSheet.Cells(3,3).value="�����ţ�"+$g(data["PatMedicalNo"])+" "+"�Ա�"+$g(data["PatSexinput"])+" "+"���䣺"+$g(data["PatAge"])+" "+"�ǼǺţ�"+$g(data["PatID"]);  //������
	//objSheet.Cells(3,5).value="�Ա�"+$g(data["PatSexinput"]); //�Ա�
	//objSheet.Cells(3,6).value="���䣺"+$g(data["PatAge"]); //����
	
	objSheet.Cells(5,1).value="�¼��������ڣ�"+$g(data["DisMedThingHappenDate"]); //�¼���������
	objSheet.Cells(5,5).value="�������ң�"+$g(data["OccuLoc"]); //��������
	var SArow=parseInt($g(data["DisMedThingSpecArea"]).length/45);
	var SAheightlen=(SArow+1)*14;
	objSheet.Rows(7+":"+7).RowHeight = SAheightlen; 
	objSheet.Cells(7,1).value="    "+$g(data["WLEventProcess"]); //�¼�����
	objSheet.Cells(9,1).value="ҽ����е�������ƣ�"+$g(data["DisMedThingMdType"]); //ҽ����е��������
	
	objSheet.Cells(10,2).value=$g(data["DisMedThingGoodName"]); //��Ʒ����
	objSheet.Cells(10,6).value=$g(data["DisMedThingRegNumber"]); //ע��֤��
	objSheet.Cells(11,1).value="������ҵ���ƣ�"+$g(data["DisMedThingREnterpriseName"]); //������ҵ����
	objSheet.Cells(11,6).value=$g(data["HospPhone"]); //��ϵ�绰
	objSheet.Cells(12,1).value="������ҵ��ַ��"+$g(data["DisMedThingAddress"]); //������ҵ��ַ
	objSheet.Cells(13,2).value=$g(data["DisMedThingModelSpecification"]); //�ͺŹ��
	objSheet.Cells(13,4).value=$g(data["DisMedThingCode"]); //��Ʒ���
	objSheet.Cells(13,6).value=$g(data["DisMedThingProductNummber"]); //��Ʒ����
	
	objSheet.Cells(14,2).value=$g(data["DisMedThingPeriodValidity"]); //��Ч����
	objSheet.Cells(15,2).value=$g(data["DisMedThingDeactivateDate"]); //ͣ������
	objSheet.Cells(16,1).value="ֲ�����ڣ���ֲ�룩��"+$g(data["DisMedThingImlantDate"]); //ֲ�����ڣ���ֲ�룩
	objSheet.Cells(17,1).value="�¼�����ԭ�������"+$g(data["DisMedThingEventCauseAnaly"]); //�¼�����ԭ�����
	objSheet.Cells(18,1).value="�¼����������"+$g(data["WLEventProcess"]); //�¼��������
	objSheet.Cells(19,1).value="�¼�����״̬��"+radioValue("DisMedThingEventReportStatue-95116,DisMedThingEventReportStatue-95117,DisMedThingEventReportStatue-95118",data); //�¼�����״̬
		
	var Carow=parseInt($g(data["DisMedThingCaution"]).length/45);
	var Caheightlen=(Carow+1)*14;
	objSheet.Rows(21+":"+21).RowHeight = Caheightlen; 
	objSheet.Cells(21,1).value=$g(data["DisMedThingCaution"]); //��ʾ
	
	
	objSheet.Cells(22,1).value="��������ίԱ�᣺"+$g(data["DisMedThingQMC"]); //��������ίԱ��
	objSheet.Cells(23,1).value="�ϱ��ˣ�ǩ������"+$g(data["DisMedThingEventUserOfReport"]); //�ϱ��ˣ�ǩ����
	objSheet.Cells(23,3).value="�������ڣ�"+$g(data["ReportDate"]); //��������
	
	objSheet.Cells(23,5).value="������ң�"+$g(data["DisMedThingDept"]); //�������
	
	var RRrow=parseInt($g(data["DisMedThingRepRemark"]).length/45);
	var RRheightlen=(RRrow+1)*14;
	objSheet.Rows(25+":"+25).RowHeight = RRheightlen; 
	objSheet.Cells(25,1).value=$g(data["DisMedThingRepRemark"]); //��ע
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//��·���䱨�浥
function printPipeOffData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_PipeOff.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //��������
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //������
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //��������
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //�Ա�
	objSheet.Cells(4,5).value="�ǼǺţ�"; //�ǼǺ�
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //�ǼǺ�
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //����
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //��һ���
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //������Դ
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //��Ժ����
	objSheet.Cells(9,1).value="��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]); //��ԺʱADL�÷�
	objSheet.Cells(9,5).value="���������չ�������"+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //���������չ�����
	objSheet.Cells(10,1).value="����ǰADL�÷֣�"+$g(data["OccurADLScore"]); //����ǰADL�÷�
	objSheet.Cells(10,5).value="���������չ�������"+radioValue("OccurPatSelfCareAbility-94239,OccurPatSelfCareAbility-94240,OccurPatSelfCareAbility-94241",data); //���������չ�����
	objSheet.Cells(11,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //�㻤��Ա
	objSheet.Cells(12,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //������
	objSheet.Cells(13,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //�Ļ��̶�
	
	
	objSheet.Cells(15,1).value="�ѹܷ���ʱ�䣺"+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]); //�ѹܷ���ʱ��
	objSheet.Cells(16,2).value=$g(data["TubeDate"]); //�ù�����  
	objSheet.Cells(17,2).value=radioValue("PipeDiscoverers-94464,PipeDiscoverers-94465,PipeDiscoverers-94466,PipeDiscoverers-94467",data); //������
	objSheet.Cells(18,3).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data);//�¼��������໤ʿְ��
	objSheet.Cells(19,2).value=$g(data["WallWorkYears"]); //��������
	
	objSheet.Cells(21,1).value=radioValue("PipeType-94449,PipeType-94450,PipeType-94451,PipeType-94452,PipeType-94453,PipeType-94454,PipeType-94455,PipeType-94456,PipeType-94457,PipeType-94458,PipeType-94459,PipeType-94460,PipeType-94461,PipeType-94462,PipeType-94463",data);  //��������
	objSheet.Cells(23,2).value=radioValue("PipePS-94473-94476,PipePS-94473-94477,PipePS-94473-94478,PipePS-94473-94479,PipePS-94473-94480",data); //��ʶ״̬
	objSheet.Cells(24,2).value=radioValue("PipePS-94474-94481,PipePS-94474-94482,PipePS-94474-94483,PipePS-94474-94484,PipePS-94474-94485",data);//����״̬
	objSheet.Cells(25,2).value=radioValue("PipePS-94475-94486,PipePS-94475-94487,PipePS-94475-94488,PipePS-94475-94489,PipePS-94475-94490",data);//�����
	objSheet.Cells(27,1).value=radioValue("PipeReason-94493,PipeReason-94494,PipeReason-94496,PipeReason-94497",data); //����ԭ��
	
	objSheet.Cells(29,1).value=radioValue("PipeFixedMethod-94503,PipeFixedMethod-94506,PipeFixedMethod-94507,PipeFixedMethod-94508,PipeFixedMethod-94509",data); //�̶�����
	objSheet.Cells(31,2).value=radioValue("PipeOther-94512-94518,PipeOther-94512-94519",data); //��������
	objSheet.Cells(32,2).value=radioValue("PipeOther-94513-94520,PipeOther-94513-94521",data); //Լ����ʹ��
	objSheet.Cells(33,4).value=radioValue("PipeOther-94515-94522,PipeOther-94515-94523",data); //�¼�����ǰ�����Ƿ�ʹ����ҩ��
	objSheet.Cells(34,3).value=radioValue("PipeOther-94516-94524,PipeOther-94516-94525",data); //��·����ʱ������Ա
	var othnum=radioValue("PipeOther-94517-94527",data);
	objSheet.Cells(35,4).value=radioValue("PipeOther-94517-94526,PipeOther-94517-94527",data); //���߼����Ƿ�������·�����¼�
	if (othnum!=""){
		objSheet.Cells(35,4).value="����:"+othnum;
	}
	var pipetakesteps=radioValue("PipeTakeSteps-94533,PipeTakeSteps-94534,PipeTakeSteps-94537",data) //��ȡ��ʩ���ɶ�ѡ��
	var pipetakename=$g(data["PipeTakeSteps-94536-94258"]); //����Լ�� ��������
	if (pipetakename!=""){
		pipetakename="����Լ�飨�������ƣ�"+pipetakename+"��";
	}
	if ((pipetakesteps!="")&&(pipetakename!="")){
		pipetakesteps=pipetakesteps+"��"+pipetakename;
	}
	objSheet.Cells(37,1).value=pipetakesteps; //��ȡ��ʩ���ɶ�ѡ��
	
	var PipeComplication=radioValue("PipeComplication-94539,PipeComplication-94540",data); //����֢ �� ��
	var ifblood=$g(data["PipeComplication-94540-94541"]); //����֢��Ѫ
	if (ifblood!=""){
		ifblood="��Ѫ"+ifblood+"(ml)";
	}
	var otherlComp=radioValue("PipeComplication-94540-94542,PipeComplication-94540-94543,PipeComplication-94540-94544,PipeComplication-94540-94545,PipeComplication-94540-94546,PipeComplication-94540-94547,PipeComplication-94540-94548",data)
	if (PipeComplication=="��"){
		PipeComplication=ifblood+"�� "+otherlComp;
	}
	
	objSheet.Cells(39,1).value=PipeComplication; //����֢
	
	objSheet.Cells(40,2).value=$g(data["RepHospType"]); //���浥λ
	objSheet.Cells(40,6).value=$g(data["HospPhone"]); //��ϵ�绰
	objSheet.Cells(41,2).value=$g(data["ReportDate"]); //��������
	
	objSheet.Cells(42,2).value=$g(data["RepUserName"]); //�������
	objSheet.Cells(42,4).value=$g(data["RepUserTitle"]); //ְ��
	objSheet.Cells(42,6).value=$g(data["RepUserWorkYears"]); //��������
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(44+":"+44).RowHeight = WLEheightlen; 
	objSheet.Cells(44,1).value=$g(data["WLEventProcess"]); //�¼�����
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(46+":"+46).RowHeight = dealWayheightlen; 
	objSheet.Cells(46,1).value=$g(data["dealWay"]); //�����ʩ
	
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//ѹ�����浥
function printSkinUlcerData(data){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_SkinUlcer.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //��������
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //������
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //��������
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //�Ա�
	objSheet.Cells(4,5).value="�ǼǺţ�"; //�ǼǺ�
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //�ǼǺ�
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //����
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //��һ���
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //������Դ
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //��Ժ����
	objSheet.Cells(9,1).value="��ԺʱADL�÷֣�"+$g(data["PatAdmADLScore"]); //��ԺʱADL�÷�
	objSheet.Cells(9,5).value="���������չ�������"+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //���������չ�����
	objSheet.Cells(10,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //�㻤��Ա
	
	objSheet.Cells(11,1).value="ʹ��ѹ���������ֱ�"+radioValue("UseUlcerRiskpointtab-94929,UseUlcerRiskpointtab-94930,UseUlcerRiskpointtab-94931,UseUlcerRiskpointtab-94932",data); //ʹ��ѹ���������ֱ�
	
	objSheet.Cells(12,1).value="��Ժѹ���������֣�"+$g(data["HospUlcerRiskScore"]); //��Ժѹ����������
	objSheet.Cells(12,5).value="ѹ�����յȼ���"+radioValue("HospUlcerRiskLev-94936,HospUlcerRiskLev-94937,HospUlcerRiskLev-94938,HospUlcerRiskLev-94939",data); //ѹ�����յȼ�
	objSheet.Cells(13,1).value="����ѹ��ʱ�������֣�"+$g(data["OccurUlcerRiskScore"]); //����ѹ��ʱ��������
	objSheet.Cells(13,5).value="ѹ�����յȼ���"+radioValue("OccurUlcerRiskLev-94943,OccurUlcerRiskLev-94944,OccurUlcerRiskLev-94945,OccurUlcerRiskLev-94946",data); //ѹ�����յȼ�

	objSheet.Cells(14,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //������
	objSheet.Cells(15,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //�Ļ��̶�
	objSheet.Cells(16,2).value=$g(data["OpeDuration"]); //������Сʱ��
	
	
	var UlcerPartlist=$g(data["UlcerPart"]);//ѹ����λ
	var Ulcerlen=UlcerPartlist.length; //ѹ����λ����
	
	for(var k=0;k<Ulcerlen;k++){
		//var MULIDoArr=DocList[k].split("^");
		objSheet.Cells(17+5*k,1).Font.Size = 12; //����Ϊ12����
		objSheet.Cells(17+5*k,1).Font.Bold = true; //����Ϊ����
		xlApp.Range(xlApp.Cells(17+5*k,1),xlApp.Cells(17+5*k,1)).Borders(1).LineStyle=1;  //�����ϱ߿�
		objSheet.Cells(17+5*k,1).value="��λ"+(k+1);
		xlApp.Range(xlApp.Cells(17+5*k,2),xlApp.Cells(17+5*k,6)).MergeCells = true;  //�ϲ���Ԫ��
		xlApp.Range(xlApp.Cells(17+5*k,2),xlApp.Cells(17+5*k,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
		objSheet.Cells(17+5*k,2).value="�������ڣ�"+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //��������
		
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).MergeCells = true;  //�ϲ���Ԫ��
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
		var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //��Դ
		var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",UlcerPartlist[k]); //Ժ�����
		if (orignout!=""){orign=orign+"��"+orignout+"��";}
		objSheet.Cells(18+5*k,1).value="��Դ��"+orign; //��Դ
		
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).MergeCells = true;  //�ϲ���Ԫ��
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
		var part=""
		var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",UlcerPartlist[k]); //��λ
		if (qtpart!=""){part=qtpart+"�� "+part; }
		var ekpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",UlcerPartlist[k]); //����
		if (ekpart!=""){part=ekpart+"�� "+part; }
		var jjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",UlcerPartlist[k]); //���β�
		if (jjpart!=""){part=jjpart+"�� "+part; }
		var zbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //�ⲿ
		if (zbpart!=""){part=zbpart+"�� "+part; }
		var qqsjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //��ǰ�ϼ�
		if (qqsjpart!=""){part=qqsjpart+"�� "+part; }
		var kbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",UlcerPartlist[k]); //�Ų�
		if (kbpart!=""){part=kbpart+"�� "+part; }
		var xbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",UlcerPartlist[k]); //ϥ��
		if (xbpart!=""){part=xbpart+"�� "+part; }
		var hbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",UlcerPartlist[k]); //�ײ�
		if (hbpart!=""){part=hbpart+"�� "+part; }
		var zgbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",UlcerPartlist[k]); //�����
		if (zgbpart!=""){part=zgbpart+"�� "+part; }
		objSheet.Cells(19+5*k,1).value="��λ��"+part; //��λ
		
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).MergeCells = true;  //�ϲ���Ԫ��
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
		objSheet.Cells(20+5*k,1).value="���ڣ�"+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k]); //����
		
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).MergeCells = true;  //�ϲ���Ԫ��
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
		var cmlist=""
		if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])!="")){
			cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"]);
			if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])!="")){
				cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);
				if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])!="")){
					cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"��"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"]);
				}
			}
		}
		
		objSheet.Cells(21+5*k,1).value="���(������ cm��cm��cm)��"+cmlist; //���
	}
			
	/* objSheet.Cells(17+length,3).value="�������ڣ�"+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]); //��������
	objSheet.Cells(18+length,2).value="��Դ��"+$g(data["PatAdmDate"]); //��Դ
	objSheet.Cells(19+length,2).value="��λ��"+$g(data["PatAdmDate"]); //��λ
	objSheet.Cells(20+length,2).value="���ڣ�"+$g(data["PatAdmDate"]); //����
	objSheet.Cells(21+length,1).value="�����"+$g(data["PatAdmDate"]); //���
	 */
	var length=5*(Ulcerlen-1) ;
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(22+length,1).Font.Size = 12; //����Ϊ12����
	objSheet.Cells(22+length,1).Font.Bold = true; //����Ϊ����
	objSheet.Cells(22+length,1).value="ѹ������ԭ�򣨿ɶ�ѡ��";

	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(23+length,1).value="�������أ�"+myRadioValue("UlcerOccurReason-94948-94952,UlcerOccurReason-94948-94953,UlcerOccurReason-94948-94954,UlcerOccurReason-94948-94955,UlcerOccurReason-94948-94956,UlcerOccurReason-94948-94957,UlcerOccurReason-94948-94958,UlcerOccurReason-94948-94959",data);  //ѹ������ԭ�� ��������
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(24+length,1).value="�������أ�"+myRadioValue("UlcerOccurReason-94949-94960,UlcerOccurReason-94949-94961,UlcerOccurReason-94949-94962,UlcerOccurReason-94949-94963,UlcerOccurReason-94949-94964",data);  //ѹ������ԭ�� ��������
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).WrapText = true; //�Զ�����
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).VerticalAlignment = 1; //��ֱ����
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(25+length,1).value="������Ա���أ�"+myRadioValue("UlcerOccurReason-94950-94966,UlcerOccurReason-94950-94967,UlcerOccurReason-94950-94968,UlcerOccurReason-94950-94969,UlcerOccurReason-94950-94970,UlcerOccurReason-94950-94971,UlcerOccurReason-94950-94972,UlcerOccurReason-94950-94973,UlcerOccurReason-94950-94974",data);  //ѹ������ԭ�� ������Ա����
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(27+length,1).value="�������أ�"+myRadioValue("UlcerOccurReason-94951-94975,UlcerOccurReason-94951-94976",data);  //ѹ������ԭ�� ��������
	
	
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(28+length,1).Font.Size = 12; //����Ϊ12����
	objSheet.Cells(28+length,1).Font.Bold = true; //����Ϊ����
	objSheet.Cells(28+length,1).value="�Ѳ�ȡ�����ʩ";
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).WrapText=true; //�Զ�����
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).VerticalAlignment = 1; //��ֱ����
	objSheet.Cells(29+length,1).value=radioValue("AdoptNursMeasure-95006,AdoptNursMeasure-95007,AdoptNursMeasure-95008,AdoptNursMeasure-95009,AdoptNursMeasure-95010,AdoptNursMeasure-95011,AdoptNursMeasure-95012,AdoptNursMeasure-95013,AdoptNursMeasure-95014",data); //�Ѳ�ȡ�����ʩ	
	
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).Borders(1).LineStyle=1;  //������߿�
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(31+length,1).value="���浥λ��"+$g(data["RepHospType"]); //���浥λ
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).Borders(2).LineStyle=1;  //�����ұ߿�
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(31+length,5).value="��ϵ�绰��"+$g(data["HospPhone"]); //��ϵ�绰
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(32+length,1).value="�������ڣ�"+$g(data["ReportDate"]); //��������
	
	xlApp.Range(xlApp.Cells(33+length,1),xlApp.Cells(33+length,2)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(33+length,1),xlApp.Cells(33+length,2)).Borders(1).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(33+length,1).value="���������"+$g(data["RepUserName"]); //�������
	xlApp.Range(xlApp.Cells(33+length,3),xlApp.Cells(33+length,4)).MergeCells = true; //�ϲ���Ԫ��
	objSheet.Cells(33+length,3).value="ְ�ƣ�"+$g(data["RepUserTitle"]); //ְ��
	xlApp.Range(xlApp.Cells(33+length,5),xlApp.Cells(33+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(33+length,5),xlApp.Cells(33+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(33+length,5).value="�������ޣ�"+$g(data["RepUserWorkYears"]); //��������
	
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(34+length,1).Font.Size = 12; //����Ϊ12����
	objSheet.Cells(34+length,1).Font.Bold = true; //����Ϊ����
	objSheet.Cells(34+length,1).value="�¼�����";
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).WrapText=true; //�Զ�����
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(4).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).VerticalAlignment = 1; //��ֱ����
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(35+":"+37).RowHeight = WLEheightlen; 
	objSheet.Cells(35+length,1).value=$g(data["WLEventProcess"]); //�¼�����
	
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(3).LineStyle=1;  //�����ϱ߿�
	objSheet.Cells(38+length,1).Font.Size = 12; //����Ϊ12����
	objSheet.Cells(38+length,1).Font.Bold = true; //����Ϊ����
	objSheet.Cells(38+length,1).value="�����ʩ";
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).WrapText=true; //�Զ�����
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(1).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(2).LineStyle=1;  //�����ϱ߿�
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(4).LineStyle=1;  //�����±߿�
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).VerticalAlignment = 1; //��ֱ����
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(39+":"+41).RowHeight = dealWayheightlen; 
	objSheet.Cells(39+length,1).value=$g(data["dealWay"]); //�����ʩ
	
	//xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(44+length,6)).Borders(1).LineStyle=1;; //���ñ߿�
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}
//����(׹��)�¼����浥	
function printFallDownData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_FallDownFill.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(4,3).value=$g(data["DisMedThingPatName"]); //����
	objSheet.Cells(4,6).value=$g(data["PatMedicalNo"]); //������
	objSheet.Cells(4,8).value=$g(data["OccuLoc"]); 		//��������
	objSheet.Cells(5,3).value=$g(data["PatSexinput"]);  //�����Ա� 
	objSheet.Cells(5,6).value="�ǼǺţ�"; //�ǼǺ�
	objSheet.Cells(5,7).value="'"+$g(data["PatID"]); //�ǼǺ�
	objSheet.Cells(6,3).value=$g(data["PatAge"]); 		//����
	objSheet.Cells(7,3).value=$g(data["PatDiag"]); 		//��һ���
	objSheet.Cells(8,3).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //������Դ
	objSheet.Cells(9,3).value=$g(data["PatAdmDate"]); //��Ժ����
	objSheet.Cells(10,4).value=$g(data["PatAdmADLScore"]); //ADL�÷�
	objSheet.Cells(10,8).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //���������չ�����
	objSheet.Cells(11,3).value=radioValue("PatEscort-94349,PatEscort-94350",data); //������Ա
	objSheet.Cells(12,3).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //������
	objSheet.Cells(14,4).value=$g(data["HappenTime"])+" "+$g(data["OccurTime"]); //����ʱ��
	objSheet.Cells(14,8).value=radioValue("FallDownType-94261,FallDownType-94262",data); //��������
	
	objSheet.Cells(15,3).value=radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94578,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data);  //�����ص� 
	objSheet.Cells(16,6).value=radioValue("FDPatState-95051,FDPatState-95052,FDPatState-95053,FDPatState-95054,FDPatState-95055,FDPatState-95056,FDPatState-95057,FDPatState-95058,FDPatState-95059,FDPatState-95060,FDPatState-95061,FDPatState-95062",data); //����/׹��ʱ���ߵ�״̬
	objSheet.Cells(17,3).value=$g(data["JuredPart"]); //���˲�λ
	objSheet.Cells(18,3).value=$g(data["PatMedicalNo"]); //����ԭ��(�ɶ�ѡ) ����
	objSheet.Cells(19,3).value=radioValue("OccurReason-95068-95072,OccurReason-95068-95073,OccurReason-95068-95074,OccurReason-95068-95085,OccurReason-95068-95088,OccurReason-95068-95089",data); //��������  OccurReason-95068-95072
	objSheet.Cells(20,3).value=radioValue("OccurReason-95069-95094,OccurReason-95069-95095,OccurReason-95069-95098,OccurReason-95069-95099,OccurReason-95069-95102,OccurReason-95069-95103,OccurReason-95069-95104,OccurReason-95069-95105",data); //ҩ������
	objSheet.Cells(21,3).value=radioValue("OccurReason-95070-95106,OccurReason-95070-95112,OccurReason-95070-95113,OccurReason-95070-95114,OccurReason-95070-95121,OccurReason-95070-95122",data); //��������
	objSheet.Cells(22,3).value=$g(data["OccurReason-95071"]); //��������
	objSheet.Cells(23,3).value=radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data); //
	objSheet.Cells(24,5).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data); //�¼��������໤ʿְ��
	objSheet.Cells(25,4).value=$g(data["WLManWorkLife"]); //��������(��)
	//objSheet.Cells(27,4).value=myRadioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); // ����ɵ���/׹���¼���ɵĽ��
	//objSheet.Cells(28,4).value=$g(data["FDResult-95134"])==""?"��":"��";
	
	var eventresult=radioValue("FDResult-95131,FDResult-95134,FDResult-94245",data); //�¼���ɵĺ��
	var patHOD=radioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); //����סԺ����
	if (patHOD!=""){
		eventresult=$g(data["FDResult-95132"])+"��"+patHOD+"��"+"�� "+eventresult;
	}	
	objSheet.Cells(27,2).value=eventresult; //�¼���ɵĺ��  
	objSheet.Cells(29,2).value=myRadioValue("FDResult-95133-95139,FDResult-95133-95140,FDResult-95133-95141,FDResult-95133-95142,FDResult-95133-95143",data); 
	objSheet.Cells(30,3).value=$g(data["RepHospType"]); //���λ
	objSheet.Cells(30,8).value=$g(data["HospPhone"]); //��ϵ�绰
	objSheet.Cells(31,3).value=$g(data["ReportDate"]); //��������
	
	objSheet.Cells(32,3).value=$g(data["RepUserName"]); //���
	objSheet.Cells(32,6).value=$g(data["RepUserTitle"]); //ְ��
	objSheet.Cells(32,8).value=$g(data["RepUserWorkYears"]); //��������
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/40);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(34+":"+34).RowHeight = WLEheightlen; 
	objSheet.Cells(34,2).value=$g(data["WLEventProcess"]); //�¼�����
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //����֪ͨ
	var deal=radioValue("PatEventProcess-95032,PatEventProcess-95034",data); //���������¼�������
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"��"+notice+"���� "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"��ҽ�ƻ����ʩ��"+$g(data["PatEventProcess-95033"])+"��"
	}
	objSheet.Cells(36,2).value=deal; //���������¼�������
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}


//����δ����ı���
function $g(param){
	return param==undefined?"":	param;
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
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="��";
	}
	return ret;
}
