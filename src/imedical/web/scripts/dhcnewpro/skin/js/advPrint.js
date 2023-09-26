/// 报告单打印
function printRepForm(ID,RepTypeCode)
{
	if(ID==""){
		$.messager.alert("提示:","报表ID为空！");
		return;
	}	
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintData",
	{AdvMasterDr:ID},
	function(ret){
		//压疮报告单
		if(RepTypeCode=="advSkinUlcer"){  
			printSkinUlcerData(ret);
		}
		//医疗护理风险防范(堵漏/隐患)事件报告单
		if(RepTypeCode=="advWallLeakage"){  
			printWallLData(ret);
		}
		//管路脱落报告单
		if(RepTypeCode=="advPipeOff"){  
			printPipeOffData(ret);
		}
		//意外事件报告单
		if(RepTypeCode=="advAccidentFill"){  
			printAccidentData(ret); //
		}
		//用药错误报告单
		if(RepTypeCode=="advDrugUseErr"){ 
			printDrugErrData(ret);
		}
		//跌倒(坠床)事件报告单	
		if(RepTypeCode=="advFallDownFill"){  
			printFallDownData(ret);
		}
		//一次性医疗用品不良事件报告单
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
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //患者姓名
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //病案号
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //发生科室
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //性别
	objSheet.Cells(4,5).value="登记号："; //登记号
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //登记号
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //年龄
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //第一诊断
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //患者来源
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //入院日期
	objSheet.Cells(9,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //护理级别
	objSheet.Cells(10,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //文化程度
	
	objSheet.Cells(12,1).value="给药发生日期："+$g(data["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]); //给药发生日期
	objSheet.Cells(13,2).value=radioValue("DrugUseHappenPlace-label-94587,DrugUseHappenPlace-label-94588,DrugUseHappenPlace-label-94589,DrugUseHappenPlace-label-94590,DrugUseHappenPlace-label-94591",data); //发生地点
	objSheet.Cells(14,2).value=radioValue("DrugUsePartyTitle-94597,DrugUsePartyTitle-94599,DrugUsePartyTitle-94611,DrugUsePartyTitle-94612",data); //当事人职称
	objSheet.Cells(15,1).value="当事人工作年限："+$g(data["DrugUsePartyWorkYears"]); //当事人工作年限
	
	objSheet.Cells(16,2).value=$g(data["PartyName"]); //当事人姓名
	objSheet.Cells(16,4).value=$g(data["DrugUseErrLevel"]); //能级
	objSheet.Cells(16,6).value=$g(data["Shift"]);  //班次
	
	objSheet.Cells(17,2).value=radioValue("DrugUseErrRank-95145,DrugUseErrRank-95146,DrugUseErrRank-95147,DrugUseErrRank-95148,DrugUseErrRank-95149,DrugUseErrRank-95150",data); //当事人身份
	objSheet.Cells(18,2).value=$g(data["WallDiscover"]); //发现人姓名
	objSheet.Cells(18,4).value="";///$g(data["DisMedThingPatName"]); //职称  
	objSheet.Cells(18,6).value=$g(data["WLManWorkLife"]); //工作年限
	
	var list="";
	var dosetargeterr=$g(data["DrugUseErrType-94616"]); //给药对象错误
	if (dosetargeterr!=""){
		list=list+dosetargeterr+"；";
	}

	var dosetimeerr=$g(data["DrugUseErrType-94617"]); //给药时间错误
	var dosetime=$g(data["DrugUseErrType-94617-94204"]);//医嘱给药时间
	var errdosetime=$g(data["DrugUseErrType-94617-94205"]);//错误给药时间
	if(dosetime!=""){
		dosetimeerr=dosetimeerr+"："+"医嘱给药时间为"+dosetime+"，"+"错误给药时间为"+errdosetime
	}
	if (dosetimeerr!=""){
		list=list+dosetimeerr+"；";
	}
	
	var dosewayerr=$g(data["DrugUseErrType-94618"]); //给药途径错误
	var doseway=$g(data["DrugUseErrType-94618-94208"]);//医嘱给药途径
	var errdoseway=$g(data["DrugUseErrType-94618-94209"]);//错误给药途径
	if(doseway!=""){
		dosewayerr=dosewayerr+"："+"医嘱给药途径为"+doseway+"，"+"错误给药途径为"+errdoseway
	}
	if (dosewayerr!=""){
		list=list+dosewayerr+"；";
	}
	
	var missdose=$g(data["DrugUseErrType-94619"]); //遗漏给药
	var missnum=$g(data["DrugUseErrType-94619-94212"]);//遗漏次数
	var missdosetime=$g(data["DrugUseErrType-94619-94213"]);//医嘱给药时间
	if(missnum!=""){
		missdose=missdose+"："+"遗漏次数为"+missnum+"，"+"医嘱给药时间为"+missdosetime
	}
	if (missdose!=""){
		list=list+missdose+"；";
	}
	
	var infusionspeed=$g(data["DrugUseErrType-94620"]); //输液速度错误
	var infudrugname=$g(data["DrugUseErrType-94620-94215"]);//药物名称
	var errdoseinfusion=$g(data["DrugUseErrType-94620-94216"]);//错误给药速度
	if(infudrugname!=""){
		infusionspeed=infusionspeed+"："+"药物名称为"+infudrugname+"，"+"错误给药速度为"+errdoseinfusion
	}
	if (infusionspeed!=""){
		list=list+infusionspeed+"；";
	}
	
	var dosageerr=$g(data["DrugUseErrType-94621"]); //剂量错误
	var dosedosage=$g(data["DrugUseErrType-94621-94219"]);//医嘱给药剂量
	var errdosage=$g(data["DrugUseErrType-94621-94220"]);//错误给药剂量 
	if(dosedosage!=""){
		dosageerr=dosageerr+"："+"医嘱给药剂量为"+dosedosage+"，"+"错误给药剂量为"+errdosage
	}
	if (dosageerr!=""){
		list=list+dosageerr+"；";
	}
	
	var dosageformerr=$g(data["DrugUseErrType-94622"]); //剂型错误
	var dosedosageform=$g(data["DrugUseErrType-94622-94223"]);//医嘱给药剂型
	var errdosageform=$g(data["DrugUseErrType-94622-94224"]);//错误给药剂型 
	if(dosedosageform!=""){
		dosageformerr=dosageformerr+"："+"医嘱给药剂型为"+dosedosageform+"，"+"错误给药剂型为"+errdosageform
	}
	if (dosageformerr!=""){
		list=list+dosageformerr+"；";
	}
	
	var drugerr=$g(data["DrugUseErrType-94623"]); //药物错误
	var dosedrugname=$g(data["DrugUseErrType-94622-94223"]);//医嘱给药名称
	var errdrugname=$g(data["DrugUseErrType-94622-94224"]);//错误给药名称 
	if(dosedrugname!=""){
		drugerr=drugerr+"："+"医嘱给药名称为"+dosedrugname+"，"+"错误给药名称为"+errdrugname
	}
	if (drugerr!=""){
		list=list+drugerr+"；";
	}

	var drugvalidityerr=$g(data["DrugUseErrType-94624"]); //药物效期错误
	if (drugvalidityerr!=""){
		list=list+drugvalidityerr+"；";
	}

	var drugoth=$g(data["DrugUseErrType-94625"]); //其他
	if (drugoth!=""){
		list=list+drugoth+"；";
	}
	
	var Drugrow=parseInt(list.length/45);
	var Drugheightlen=(Drugrow+1)*14;
	objSheet.Rows(20+":"+20).RowHeight = Drugheightlen; 
	objSheet.Cells(20,1).value=list;  //错误类型
	objSheet.Cells(22,1).value=radioValue("DrugUseDefectResult-label-94633,DrugUseDefectResult-label-94634,DrugUseDefectResult-label-94635,DrugUseDefectResult-label-94636,DrugUseDefectResult-label-94637,DrugUseDefectResult-label-94638",data); //缺陷引起的后果
	objSheet.Cells(23,2).value=$g(data["RepHospType"]); //报告单位
	objSheet.Cells(23,6).value=$g(data["HospPhone"]); //联系电话
	objSheet.Cells(24,2).value=$g(data["ReportDate"]); //报告日期
	
	objSheet.Cells(25,2).value=$g(data["RepUserName"]); //填报人姓名
	objSheet.Cells(25,4).value=$g(data["RepUserTitle"]); //职称
	objSheet.Cells(25,6).value=$g(data["RepUserWorkYears"]); //工作年限
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(27+":"+27).RowHeight = WLEheightlen; 
	objSheet.Cells(27,1).value=$g(data["WLEventProcess"]); //事件经过
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(29+":"+29).RowHeight = dealWayheightlen;
	objSheet.Cells(29,1).value=$g(data["dealWay"]); //处理措施
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

/// 意外事件报告单打印
function printAccidentData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_AccidentFill.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //患者姓名
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //病案号
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //发生科室
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //性别
	objSheet.Cells(4,5).value="登记号："; //登记号
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //登记号
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //年龄
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //第一诊断
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //患者来源
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //入院日期  
	objSheet.Cells(9,1).value="入院时ADL得分："+$g(data["PatAdmADLScore"]); //入院时ADL得分
	objSheet.Cells(9,5).value="患者自我照顾能力："+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //患者自我照顾能力
	objSheet.Cells(10,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //陪护人员
	
	
	objSheet.Cells(11,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //护理级别
	objSheet.Cells(12,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //文化程度
	
	objSheet.Cells(14,3).value=radioValue("AFType-94495,AFType-94498,AFType-94499,AFType-94500,AFType-94927,AFType-94978,AFType-94979,AFType-94980,AFType-94981,AFType-94165",data); //意外事件发生类型
	objSheet.Cells(15,2).value=$g(data["HappenTime"])+" "+$g(data["OccurTime"]); //给药发生日期
	objSheet.Cells(16,2).value=radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data); //发生地点
	objSheet.Cells(17,2).value=radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data); //发现人
	objSheet.Cells(18,3).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data); //事件发生当班护士职称
	objSheet.Cells(19,2).value=$g(data["WLManWorkLife"]); //工作年限
	
	var eventresult=radioValue("AFResult-94565,AFResult-94567",data); //事件造成的后果
	var patHOD=radioValue("AFResult-94566-94923,AFResult-94566-94924,AFResult-94566-94925,AFResult-94566-94926",data); //患者住院天数
	if (patHOD!=""){
		eventresult=eventresult+"； "+$g(data["AFResult-94566"])+"（"+patHOD+"）";
	}	
	
	objSheet.Cells(21,1).value=eventresult; //事件造成的后果  
	
	objSheet.Cells(22,2).value=$g(data["RepHospType"]); //报告单位
	objSheet.Cells(22,6).value=$g(data["HospPhone"]); //联系电话
	objSheet.Cells(23,2).value=$g(data["ReportDate"]); //报告日期
	
	var row=parseInt($g(data["WLEventProcess"]).length/45);
	var heightlen=row*14;
	objSheet.Rows(25+":"+25).RowHeight = heightlen; 
	objSheet.Cells(25,1).value=$g(data["WLEventProcess"]); //事件经过
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //立即通知
	var deal=radioValue("PatEventProcess-95032",data); //患者意外事件处理经过
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"（"+notice+"）； "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"；医疗或护理措施（"+$g(data["PatEventProcess-95033"])+"）"
	}
	if($g(data["PatEventProcess-95034"])!=""){
		deal=deal+$g(data["PatEventProcess-95034"])
	}

	
	objSheet.Cells(27,1).value=deal; //患者意外事件处理经过
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

/// 医疗护理风险防范（堵漏/隐患）事件报告单
function printWallLData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_WallLeakage.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["AFLoc"]); //发生科室
	objSheet.Cells(3,4).value=$g(data["EveType"]); //事件类别
	objSheet.Cells(3,6).value=$g(data["FindDate"]); //发现日期
	
	var Prow=parseInt($g(data["WLEventProcess"]).length/45);
	var Pheightlen=(Prow+1)*14;
	objSheet.Rows(5+":"+5).RowHeight = Pheightlen; 
	objSheet.Cells(5,1).value=$g(data["WLEventProcess"]); //事件经过
	
	var CArow=parseInt($g(data["WLCauseAnalysis"]).length/45);
	var CAheightlen=(CArow+1)*14;
	objSheet.Rows(7+":"+7).RowHeight = CAheightlen; 
	objSheet.Cells(7,1).value=$g(data["WLCauseAnalysis"]); //原因分析
	
	var IMrow=parseInt($g(data["WLImprovedMethod"]).length/45);
	var IMheightlen=(IMrow+1)*14;
	objSheet.Rows(9+":"+9).RowHeight = IMheightlen; 
	objSheet.Cells(9,1).value=$g(data["WLImprovedMethod"]); //改进办法
	
	objSheet.Cells(11,2).value=$g(data["WallDiscover"]); //发现人
	objSheet.Cells(11,4).value=$g(data["JobTitle"]); //职称
	objSheet.Cells(11,6).value=$g(data["Duty"]); //职务
	objSheet.Cells(12,2).value=$g(data["WallWorkYears"]); //工作年限
	objSheet.Cells(14,1).value=radioValue("RelatedAreas-93867,RelatedAreas-93868,RelatedAreas-93869,RelatedAreas-93870,RelatedAreas-93871",data);; //相关领域
	objSheet.Cells(15,3).value=radioValue("IfWLBehavior-93873,IfWLBehavior-93874",data); //此事件是否为堵漏行为
	
	objSheet.Cells(16,2).value=$g(data["WLMan"]); //堵漏人
	objSheet.Cells(16,4).value=$g(data["WLManWorkLife"]); //工作年限
	objSheet.Cells(16,6).value=$g(data["WallLoc"]); //堵漏人科室
	
	var Brow=parseInt($g(data["WLBehavior"]).length/45);
	var Bheightlen=(Brow+1)*14;
	objSheet.Rows(17+":"+18).RowHeight = Bheightlen; 
	objSheet.Cells(17,1).value="堵漏行为："+$g(data["WLBehavior"]); //堵漏行为
	
	var QCrow=parseInt($g(data["QualityCommitteeOpinion"]).length/45);
	var QCheightlen=(QCrow+1)*14;
	objSheet.Rows(20+":"+20).RowHeight = QCheightlen; 
	objSheet.Cells(20,1).value=$g(data["QualityCommitteeOpinion"]); //质量委员会意见
	objSheet.Cells(21,1).value="差错事故性质结论："+radioValue("EventConclusion-93884,EventConclusion-93885,EventConclusion-93886",data); //堵漏行为
	objSheet.Cells(21,4).value="绩效奖励："+radioValue("PerformanceRewards-93888,PerformanceRewards-93889",data); //堵漏行为
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//一次性医疗用品不良事件报告单
function printDisMedData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_DisMedThing.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;

	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //患者姓名
	objSheet.Cells(3,3).value="病案号："+$g(data["PatMedicalNo"])+" "+"性别："+$g(data["PatSexinput"])+" "+"年龄："+$g(data["PatAge"])+" "+"登记号："+$g(data["PatID"]);  //病案号
	//objSheet.Cells(3,5).value="性别："+$g(data["PatSexinput"]); //性别
	//objSheet.Cells(3,6).value="年龄："+$g(data["PatAge"]); //年龄
	
	objSheet.Cells(5,1).value="事件发生日期："+$g(data["DisMedThingHappenDate"]); //事件发生日期
	objSheet.Cells(5,5).value="发生科室："+$g(data["OccuLoc"]); //发生科室
	var SArow=parseInt($g(data["DisMedThingSpecArea"]).length/45);
	var SAheightlen=(SArow+1)*14;
	objSheet.Rows(7+":"+7).RowHeight = SAheightlen; 
	objSheet.Cells(7,1).value="    "+$g(data["WLEventProcess"]); //事件陈述
	objSheet.Cells(9,1).value="医疗器械分类名称："+$g(data["DisMedThingMdType"]); //医疗器械分类名称
	
	objSheet.Cells(10,2).value=$g(data["DisMedThingGoodName"]); //商品名称
	objSheet.Cells(10,6).value=$g(data["DisMedThingRegNumber"]); //注册证号
	objSheet.Cells(11,1).value="生产企业名称："+$g(data["DisMedThingREnterpriseName"]); //生产企业名称
	objSheet.Cells(11,6).value=$g(data["HospPhone"]); //联系电话
	objSheet.Cells(12,1).value="生产企业地址："+$g(data["DisMedThingAddress"]); //生产企业地址
	objSheet.Cells(13,2).value=$g(data["DisMedThingModelSpecification"]); //型号规格
	objSheet.Cells(13,4).value=$g(data["DisMedThingCode"]); //产品编号
	objSheet.Cells(13,6).value=$g(data["DisMedThingProductNummber"]); //产品批号
	
	objSheet.Cells(14,2).value=$g(data["DisMedThingPeriodValidity"]); //有效期至
	objSheet.Cells(15,2).value=$g(data["DisMedThingDeactivateDate"]); //停用日期
	objSheet.Cells(16,1).value="植入日期（若植入）："+$g(data["DisMedThingImlantDate"]); //植入日期（若植入）
	objSheet.Cells(17,1).value="事件发生原因分析："+$g(data["DisMedThingEventCauseAnaly"]); //事件发生原因分析
	objSheet.Cells(18,1).value="事件处理情况："+$g(data["WLEventProcess"]); //事件处理情况
	objSheet.Cells(19,1).value="事件报告状态："+radioValue("DisMedThingEventReportStatue-95116,DisMedThingEventReportStatue-95117,DisMedThingEventReportStatue-95118",data); //事件报告状态
		
	var Carow=parseInt($g(data["DisMedThingCaution"]).length/45);
	var Caheightlen=(Carow+1)*14;
	objSheet.Rows(21+":"+21).RowHeight = Caheightlen; 
	objSheet.Cells(21,1).value=$g(data["DisMedThingCaution"]); //警示
	
	
	objSheet.Cells(22,1).value="质量管理委员会："+$g(data["DisMedThingQMC"]); //质量管理委员会
	objSheet.Cells(23,1).value="上报人（签名）："+$g(data["DisMedThingEventUserOfReport"]); //上报人（签名）
	objSheet.Cells(23,3).value="报告日期："+$g(data["ReportDate"]); //报告日期
	
	objSheet.Cells(23,5).value="报告科室："+$g(data["DisMedThingDept"]); //报告科室
	
	var RRrow=parseInt($g(data["DisMedThingRepRemark"]).length/45);
	var RRheightlen=(RRrow+1)*14;
	objSheet.Rows(25+":"+25).RowHeight = RRheightlen; 
	objSheet.Cells(25,1).value=$g(data["DisMedThingRepRemark"]); //备注
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//管路脱落报告单
function printPipeOffData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_PipeOff.xls";

	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //患者姓名
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //病案号
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //发生科室
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //性别
	objSheet.Cells(4,5).value="登记号："; //登记号
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //登记号
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //年龄
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //第一诊断
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //患者来源
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //入院日期
	objSheet.Cells(9,1).value="入院时ADL得分："+$g(data["PatAdmADLScore"]); //入院时ADL得分
	objSheet.Cells(9,5).value="患者自我照顾能力："+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //患者自我照顾能力
	objSheet.Cells(10,1).value="发生前ADL得分："+$g(data["OccurADLScore"]); //发生前ADL得分
	objSheet.Cells(10,5).value="患者自我照顾能力："+radioValue("OccurPatSelfCareAbility-94239,OccurPatSelfCareAbility-94240,OccurPatSelfCareAbility-94241",data); //患者自我照顾能力
	objSheet.Cells(11,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //陪护人员
	objSheet.Cells(12,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //护理级别
	objSheet.Cells(13,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //文化程度
	
	
	objSheet.Cells(15,1).value="脱管发现时间："+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]); //脱管发现时间
	objSheet.Cells(16,2).value=$g(data["TubeDate"]); //置管日期  
	objSheet.Cells(17,2).value=radioValue("PipeDiscoverers-94464,PipeDiscoverers-94465,PipeDiscoverers-94466,PipeDiscoverers-94467",data); //发现人
	objSheet.Cells(18,3).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data);//事件发生当班护士职称
	objSheet.Cells(19,2).value=$g(data["WallWorkYears"]); //工作年限
	
	objSheet.Cells(21,1).value=radioValue("PipeType-94449,PipeType-94450,PipeType-94451,PipeType-94452,PipeType-94453,PipeType-94454,PipeType-94455,PipeType-94456,PipeType-94457,PipeType-94458,PipeType-94459,PipeType-94460,PipeType-94461,PipeType-94462,PipeType-94463",data);  //导管类型
	objSheet.Cells(23,2).value=radioValue("PipePS-94473-94476,PipePS-94473-94477,PipePS-94473-94478,PipePS-94473-94479,PipePS-94473-94480",data); //意识状态
	objSheet.Cells(24,2).value=radioValue("PipePS-94474-94481,PipePS-94474-94482,PipePS-94474-94483,PipePS-94474-94484,PipePS-94474-94485",data);//精神状态
	objSheet.Cells(25,2).value=radioValue("PipePS-94475-94486,PipePS-94475-94487,PipePS-94475-94488,PipePS-94475-94489,PipePS-94475-94490",data);//活动能力
	objSheet.Cells(27,1).value=radioValue("PipeReason-94493,PipeReason-94494,PipeReason-94496,PipeReason-94497",data); //导管原因
	
	objSheet.Cells(29,1).value=radioValue("PipeFixedMethod-94503,PipeFixedMethod-94506,PipeFixedMethod-94507,PipeFixedMethod-94508,PipeFixedMethod-94509",data); //固定方法
	objSheet.Cells(31,2).value=radioValue("PipeOther-94512-94518,PipeOther-94512-94519",data); //健康教育
	objSheet.Cells(32,2).value=radioValue("PipeOther-94513-94520,PipeOther-94513-94521",data); //约束带使用
	objSheet.Cells(33,4).value=radioValue("PipeOther-94515-94522,PipeOther-94515-94523",data); //事件发生前患者是否使用镇静药物
	objSheet.Cells(34,3).value=radioValue("PipeOther-94516-94524,PipeOther-94516-94525",data); //管路滑落时工作人员
	var othnum=radioValue("PipeOther-94517-94527",data);
	objSheet.Cells(35,4).value=radioValue("PipeOther-94517-94526,PipeOther-94517-94527",data); //患者既往是否发生过管路滑脱事件
	if (othnum!=""){
		objSheet.Cells(35,4).value="次数:"+othnum;
	}
	var pipetakesteps=radioValue("PipeTakeSteps-94533,PipeTakeSteps-94534,PipeTakeSteps-94537",data) //采取措施（可多选）
	var pipetakename=$g(data["PipeTakeSteps-94536-94258"]); //诊断性检查 具体名称
	if (pipetakename!=""){
		pipetakename="诊断性检查（具体名称："+pipetakename+"）";
	}
	if ((pipetakesteps!="")&&(pipetakename!="")){
		pipetakesteps=pipetakesteps+"；"+pipetakename;
	}
	objSheet.Cells(37,1).value=pipetakesteps; //采取措施（可多选）
	
	var PipeComplication=radioValue("PipeComplication-94539,PipeComplication-94540",data); //并发症 有 无
	var ifblood=$g(data["PipeComplication-94540-94541"]); //并发症出血
	if (ifblood!=""){
		ifblood="出血"+ifblood+"(ml)";
	}
	var otherlComp=radioValue("PipeComplication-94540-94542,PipeComplication-94540-94543,PipeComplication-94540-94544,PipeComplication-94540-94545,PipeComplication-94540-94546,PipeComplication-94540-94547,PipeComplication-94540-94548",data)
	if (PipeComplication=="有"){
		PipeComplication=ifblood+"； "+otherlComp;
	}
	
	objSheet.Cells(39,1).value=PipeComplication; //并发症
	
	objSheet.Cells(40,2).value=$g(data["RepHospType"]); //报告单位
	objSheet.Cells(40,6).value=$g(data["HospPhone"]); //联系电话
	objSheet.Cells(41,2).value=$g(data["ReportDate"]); //报告日期
	
	objSheet.Cells(42,2).value=$g(data["RepUserName"]); //填报人姓名
	objSheet.Cells(42,4).value=$g(data["RepUserTitle"]); //职称
	objSheet.Cells(42,6).value=$g(data["RepUserWorkYears"]); //工作年限
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(44+":"+44).RowHeight = WLEheightlen; 
	objSheet.Cells(44,1).value=$g(data["WLEventProcess"]); //事件经过
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(46+":"+46).RowHeight = dealWayheightlen; 
	objSheet.Cells(46,1).value=$g(data["dealWay"]); //处理措施
	
	
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}

//压疮报告单
function printSkinUlcerData(data){
	
	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_SkinUlcer.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	
	objSheet.Cells(3,2).value=$g(data["DisMedThingPatName"]); //患者姓名
	objSheet.Cells(3,4).value=$g(data["PatMedicalNo"]); //病案号
	objSheet.Cells(3,6).value=$g(data["OccuLoc"]); //发生科室
	
	objSheet.Cells(4,2).value=$g(data["PatSexinput"]); //性别
	objSheet.Cells(4,5).value="登记号："; //登记号
	objSheet.Cells(4,6).value="'"+$g(data["PatID"]); //登记号
	objSheet.Cells(5,2).value=$g(data["PatAge"]); //年龄
	objSheet.Cells(6,2).value=$g(data["PatDiag"]); //第一诊断
	//var PatOrign=$g(data["PatOrigin-label-94335"])
	objSheet.Cells(7,2).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //患者来源
	
	objSheet.Cells(8,2).value=$g(data["PatAdmDate"]); //入院日期
	objSheet.Cells(9,1).value="入院时ADL得分："+$g(data["PatAdmADLScore"]); //入院时ADL得分
	objSheet.Cells(9,5).value="患者自我照顾能力："+radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //患者自我照顾能力
	objSheet.Cells(10,2).value=radioValue("PatEscort-94349,PatEscort-94350",data); //陪护人员
	
	objSheet.Cells(11,1).value="使用压疮风险评分表："+radioValue("UseUlcerRiskpointtab-94929,UseUlcerRiskpointtab-94930,UseUlcerRiskpointtab-94931,UseUlcerRiskpointtab-94932",data); //使用压疮风险评分表
	
	objSheet.Cells(12,1).value="入院压疮风险评分："+$g(data["HospUlcerRiskScore"]); //入院压疮风险评分
	objSheet.Cells(12,5).value="压疮风险等级："+radioValue("HospUlcerRiskLev-94936,HospUlcerRiskLev-94937,HospUlcerRiskLev-94938,HospUlcerRiskLev-94939",data); //压疮风险等级
	objSheet.Cells(13,1).value="发生压疮时风险评分："+$g(data["OccurUlcerRiskScore"]); //发生压疮时风险评分
	objSheet.Cells(13,5).value="压疮风险等级："+radioValue("OccurUlcerRiskLev-94943,OccurUlcerRiskLev-94944,OccurUlcerRiskLev-94945,OccurUlcerRiskLev-94946",data); //压疮风险等级

	objSheet.Cells(14,2).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //护理级别
	objSheet.Cells(15,2).value=radioValue("DegreeEducate-94370,DegreeEducate-94371,DegreeEducate-94372,DegreeEducate-94373,DegreeEducate-94374,DegreeEducate-94375",data); //文化程度
	objSheet.Cells(16,2).value=$g(data["OpeDuration"]); //手术（小时）
	
	
	var UlcerPartlist=$g(data["UlcerPart"]);//压疮部位
	var Ulcerlen=UlcerPartlist.length; //压疮部位个数
	
	for(var k=0;k<Ulcerlen;k++){
		//var MULIDoArr=DocList[k].split("^");
		objSheet.Cells(17+5*k,1).Font.Size = 12; //设置为12号字
		objSheet.Cells(17+5*k,1).Font.Bold = true; //设置为粗体
		xlApp.Range(xlApp.Cells(17+5*k,1),xlApp.Cells(17+5*k,1)).Borders(1).LineStyle=1;  //设置上边框
		objSheet.Cells(17+5*k,1).value="部位"+(k+1);
		xlApp.Range(xlApp.Cells(17+5*k,2),xlApp.Cells(17+5*k,6)).MergeCells = true;  //合并单元格
		xlApp.Range(xlApp.Cells(17+5*k,2),xlApp.Cells(17+5*k,6)).Borders(2).LineStyle=1;  //设置上边框
		objSheet.Cells(17+5*k,2).value="发现日期："+$g(UlcerPartlist[k]["UlcerPart-95158-95162-95192"]); //发现日期
		
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).MergeCells = true;  //合并单元格
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).Borders(1).LineStyle=1;  //设置上边框
		xlApp.Range(xlApp.Cells(18+5*k,1),xlApp.Cells(18+5*k,6)).Borders(2).LineStyle=1;  //设置上边框
		var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",UlcerPartlist[k]); //来源
		var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",UlcerPartlist[k]); //院外带入
		if (orignout!=""){orign=orign+"（"+orignout+"）";}
		objSheet.Cells(18+5*k,1).value="来源："+orign; //来源
		
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).MergeCells = true;  //合并单元格
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).Borders(1).LineStyle=1;  //设置上边框
		xlApp.Range(xlApp.Cells(19+5*k,1),xlApp.Cells(19+5*k,6)).Borders(2).LineStyle=1;  //设置上边框
		var part=""
		var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",UlcerPartlist[k]); //部位
		if (qtpart!=""){part=qtpart+"； "+part; }
		var ekpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",UlcerPartlist[k]); //耳廓
		if (ekpart!=""){part=ekpart+"； "+part; }
		var jjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",UlcerPartlist[k]); //肩胛部
		if (jjpart!=""){part=jjpart+"； "+part; }
		var zbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //肘部
		if (zbpart!=""){part=zbpart+"； "+part; }
		var qqsjpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",UlcerPartlist[k]); //髂前上棘
		if (qqsjpart!=""){part=qqsjpart+"； "+part; }
		var kbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",UlcerPartlist[k]); //髋部
		if (kbpart!=""){part=kbpart+"； "+part; }
		var xbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",UlcerPartlist[k]); //膝部
		if (xbpart!=""){part=xbpart+"； "+part; }
		var hbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",UlcerPartlist[k]); //踝部
		if (hbpart!=""){part=hbpart+"； "+part; }
		var zgbpart=checksubValue($g(UlcerPartlist[k]["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",UlcerPartlist[k]); //足跟部
		if (zgbpart!=""){part=zgbpart+"； "+part; }
		objSheet.Cells(19+5*k,1).value="部位："+part; //部位
		
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).MergeCells = true;  //合并单元格
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).Borders(1).LineStyle=1;  //设置上边框
		xlApp.Range(xlApp.Cells(20+5*k,1),xlApp.Cells(20+5*k,6)).Borders(2).LineStyle=1;  //设置上边框
		objSheet.Cells(20+5*k,1).value="分期："+radioValue("UlcerPart-95158-95169-95183,UlcerPart-95158-95169-95184,UlcerPart-95158-95169-95185,UlcerPart-95158-95169-95186,UlcerPart-95158-95169-95187,UlcerPart-95158-95169-95188",UlcerPartlist[k]); //分期
		
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).MergeCells = true;  //合并单元格
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).Borders(1).LineStyle=1;  //设置上边框
		xlApp.Range(xlApp.Cells(21+5*k,1),xlApp.Cells(21+5*k,6)).Borders(2).LineStyle=1;  //设置上边框
		var cmlist=""
		if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])!="")){
			cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"]);
			if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])!="")){
				cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"]);
				if(($g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"])!="")){
					cmlist=$g(UlcerPartlist[k]["UlcerPart-95158-95189-94247"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94249"])+"×"+$g(UlcerPartlist[k]["UlcerPart-95158-95189-94251"]);
				}
			}
		}
		
		objSheet.Cells(21+5*k,1).value="面积(长宽深 cm×cm×cm)："+cmlist; //面积
	}
			
	/* objSheet.Cells(17+length,3).value="发现日期："+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]); //发现日期
	objSheet.Cells(18+length,2).value="来源："+$g(data["PatAdmDate"]); //来源
	objSheet.Cells(19+length,2).value="部位："+$g(data["PatAdmDate"]); //部位
	objSheet.Cells(20+length,2).value="分期："+$g(data["PatAdmDate"]); //分期
	objSheet.Cells(21+length,1).value="面积："+$g(data["PatAdmDate"]); //面积
	 */
	var length=5*(Ulcerlen-1) ;
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(22+length,1),xlApp.Cells(22+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(22+length,1).Font.Size = 12; //设置为12号字
	objSheet.Cells(22+length,1).Font.Bold = true; //设置为粗体
	objSheet.Cells(22+length,1).value="压疮发生原因（可多选）";

	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(23+length,1),xlApp.Cells(23+length,6)).Borders(2).LineStyle=1;  //设置上边框
	objSheet.Cells(23+length,1).value="患者因素："+myRadioValue("UlcerOccurReason-94948-94952,UlcerOccurReason-94948-94953,UlcerOccurReason-94948-94954,UlcerOccurReason-94948-94955,UlcerOccurReason-94948-94956,UlcerOccurReason-94948-94957,UlcerOccurReason-94948-94958,UlcerOccurReason-94948-94959",data);  //压疮发生原因 患者因素
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(24+length,1),xlApp.Cells(24+length,6)).Borders(2).LineStyle=1;  //设置上边框
	objSheet.Cells(24+length,1).value="病情因素："+myRadioValue("UlcerOccurReason-94949-94960,UlcerOccurReason-94949-94961,UlcerOccurReason-94949-94962,UlcerOccurReason-94949-94963,UlcerOccurReason-94949-94964",data);  //压疮发生原因 病情因素
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).WrapText = true; //自动换行
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).VerticalAlignment = 1; //垂直靠上
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(25+length,1),xlApp.Cells(26+length,6)).Borders(2).LineStyle=1;  //设置上边框
	objSheet.Cells(25+length,1).value="护理人员因素："+myRadioValue("UlcerOccurReason-94950-94966,UlcerOccurReason-94950-94967,UlcerOccurReason-94950-94968,UlcerOccurReason-94950-94969,UlcerOccurReason-94950-94970,UlcerOccurReason-94950-94971,UlcerOccurReason-94950-94972,UlcerOccurReason-94950-94973,UlcerOccurReason-94950-94974",data);  //压疮发生原因 护理人员因素
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(27+length,1),xlApp.Cells(27+length,6)).Borders(2).LineStyle=1;  //设置上边框
	objSheet.Cells(27+length,1).value="其他因素："+myRadioValue("UlcerOccurReason-94951-94975,UlcerOccurReason-94951-94976",data);  //压疮发生原因 其他因素
	
	
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(28+length,1),xlApp.Cells(28+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(28+length,1).Font.Size = 12; //设置为12号字
	objSheet.Cells(28+length,1).Font.Bold = true; //设置为粗体
	objSheet.Cells(28+length,1).value="已采取护理措施";
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).WrapText=true; //自动换行
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(29+length,1),xlApp.Cells(30+length,6)).VerticalAlignment = 1; //垂直靠上
	objSheet.Cells(29+length,1).value=radioValue("AdoptNursMeasure-95006,AdoptNursMeasure-95007,AdoptNursMeasure-95008,AdoptNursMeasure-95009,AdoptNursMeasure-95010,AdoptNursMeasure-95011,AdoptNursMeasure-95012,AdoptNursMeasure-95013,AdoptNursMeasure-95014",data); //已采取护理措施	
	
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).Borders(1).LineStyle=1;  //设置左边框
	xlApp.Range(xlApp.Cells(31+length,1),xlApp.Cells(31+length,4)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(31+length,1).value="报告单位："+$g(data["RepHospType"]); //报告单位
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).Borders(2).LineStyle=1;  //设置右边框
	xlApp.Range(xlApp.Cells(31+length,5),xlApp.Cells(31+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(31+length,5).value="联系电话："+$g(data["HospPhone"]); //联系电话
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(32+length,1),xlApp.Cells(32+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(32+length,1).value="报告日期："+$g(data["ReportDate"]); //报告日期
	
	xlApp.Range(xlApp.Cells(33+length,1),xlApp.Cells(33+length,2)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(33+length,1),xlApp.Cells(33+length,2)).Borders(1).LineStyle=1;  //设置上边框
	objSheet.Cells(33+length,1).value="填报人姓名："+$g(data["RepUserName"]); //填报人姓名
	xlApp.Range(xlApp.Cells(33+length,3),xlApp.Cells(33+length,4)).MergeCells = true; //合并单元格
	objSheet.Cells(33+length,3).value="职称："+$g(data["RepUserTitle"]); //职称
	xlApp.Range(xlApp.Cells(33+length,5),xlApp.Cells(33+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(33+length,5),xlApp.Cells(33+length,6)).Borders(2).LineStyle=1;  //设置上边框
	objSheet.Cells(33+length,5).value="工作年限："+$g(data["RepUserWorkYears"]); //工作年限
	
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(34+length,1),xlApp.Cells(34+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(34+length,1).Font.Size = 12; //设置为12号字
	objSheet.Cells(34+length,1).Font.Bold = true; //设置为粗体
	objSheet.Cells(34+length,1).value="事件经过";
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).WrapText=true; //自动换行
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).Borders(4).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(35+length,1),xlApp.Cells(37+length,6)).VerticalAlignment = 1; //垂直靠上
	var WLErow=parseInt($g(data["WLEventProcess"]).length/45);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(35+":"+37).RowHeight = WLEheightlen; 
	objSheet.Cells(35+length,1).value=$g(data["WLEventProcess"]); //事件经过
	
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(38+length,1),xlApp.Cells(38+length,6)).Borders(3).LineStyle=1;  //设置上边框
	objSheet.Cells(38+length,1).Font.Size = 12; //设置为12号字
	objSheet.Cells(38+length,1).Font.Bold = true; //设置为粗体
	objSheet.Cells(38+length,1).value="处理措施";
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).MergeCells = true; //合并单元格
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).WrapText=true; //自动换行
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(1).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(2).LineStyle=1;  //设置上边框
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).Borders(4).LineStyle=1;  //设置下边框
	xlApp.Range(xlApp.Cells(39+length,1),xlApp.Cells(41+length,6)).VerticalAlignment = 1; //垂直靠上
	var dealWayrow=parseInt($g(data["dealWay"]).length/45);
	var dealWayheightlen=(dealWayrow+1)*14;
	objSheet.Rows(39+":"+41).RowHeight = dealWayheightlen; 
	objSheet.Cells(39+length,1).value=$g(data["dealWay"]); //处理措施
	
	//xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(44+length,6)).Borders(1).LineStyle=1;; //设置边框
	//xlBook.Close(savechanges=false);
	//objSheet=null;
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}
//跌倒(坠床)事件报告单	
function printFallDownData(data){

	var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
	var Template = path+"DHCADV_FallDownFill.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var objSheet = xlBook.ActiveSheet;
	objSheet.Cells(4,3).value=$g(data["DisMedThingPatName"]); //姓名
	objSheet.Cells(4,6).value=$g(data["PatMedicalNo"]); //病案号
	objSheet.Cells(4,8).value=$g(data["OccuLoc"]); 		//发生科室
	objSheet.Cells(5,3).value=$g(data["PatSexinput"]);  //患者性别 
	objSheet.Cells(5,6).value="登记号："; //登记号
	objSheet.Cells(5,7).value="'"+$g(data["PatID"]); //登记号
	objSheet.Cells(6,3).value=$g(data["PatAge"]); 		//年龄
	objSheet.Cells(7,3).value=$g(data["PatDiag"]); 		//第一诊断
	objSheet.Cells(8,3).value=radioValue("PatOrigin-label-94335,PatOrigin-label-94336,PatOrigin-label-94337,PatOrigin-label-94338,PatOrigin-label-94339",data); //患者来源
	objSheet.Cells(9,3).value=$g(data["PatAdmDate"]); //入院日期
	objSheet.Cells(10,4).value=$g(data["PatAdmADLScore"]); //ADL得分
	objSheet.Cells(10,8).value=radioValue("PatSelfCareAbility-94345,PatSelfCareAbility-94346,PatSelfCareAbility-94347",data); //患者自我照顾能力
	objSheet.Cells(11,3).value=radioValue("PatEscort-94349,PatEscort-94350",data); //陪送人员
	objSheet.Cells(12,3).value=radioValue("NursingLev-94352,NursingLev-94353,NursingLev-94354,NursingLev-94355,NursingLev-94367",data); //护理级别
	objSheet.Cells(14,4).value=$g(data["HappenTime"])+" "+$g(data["OccurTime"]); //发生时间
	objSheet.Cells(14,8).value=radioValue("FallDownType-94261,FallDownType-94262",data); //发生类型
	
	objSheet.Cells(15,3).value=radioValue("HappenPlace-label-94575,HappenPlace-label-94576,HappenPlace-label-94577,HappenPlace-label-94578,HappenPlace-label-94579,HappenPlace-label-94580,HappenPlace-label-94581,HappenPlace-label-94582,HappenPlace-label-94583,HappenPlace-label-94584,HappenPlace-label-94585",data);  //发生地点 
	objSheet.Cells(16,6).value=radioValue("FDPatState-95051,FDPatState-95052,FDPatState-95053,FDPatState-95054,FDPatState-95055,FDPatState-95056,FDPatState-95057,FDPatState-95058,FDPatState-95059,FDPatState-95060,FDPatState-95061,FDPatState-95062",data); //跌倒/坠床时患者的状态
	objSheet.Cells(17,3).value=$g(data["JuredPart"]); //受伤部位
	objSheet.Cells(18,3).value=$g(data["PatMedicalNo"]); //发生原因(可多选) 待做
	objSheet.Cells(19,3).value=radioValue("OccurReason-95068-95072,OccurReason-95068-95073,OccurReason-95068-95074,OccurReason-95068-95085,OccurReason-95068-95088,OccurReason-95068-95089",data); //患者因素  OccurReason-95068-95072
	objSheet.Cells(20,3).value=radioValue("OccurReason-95069-95094,OccurReason-95069-95095,OccurReason-95069-95098,OccurReason-95069-95099,OccurReason-95069-95102,OccurReason-95069-95103,OccurReason-95069-95104,OccurReason-95069-95105",data); //药物因素
	objSheet.Cells(21,3).value=radioValue("OccurReason-95070-95106,OccurReason-95070-95112,OccurReason-95070-95113,OccurReason-95070-95114,OccurReason-95070-95121,OccurReason-95070-95122",data); //管理因素
	objSheet.Cells(22,3).value=$g(data["OccurReason-95071"]); //其他因素
	objSheet.Cells(23,3).value=radioValue("DiscoverMan-94528,DiscoverMan-94530,DiscoverMan-94531,DiscoverMan-94532",data); //
	objSheet.Cells(24,5).value=radioValue("PipeDutyNurTitle-94468,PipeDutyNurTitle-94469,PipeDutyNurTitle-94470,PipeDutyNurTitle-94471",data); //事件发生当班护士职称
	objSheet.Cells(25,4).value=$g(data["WLManWorkLife"]); //工作年限(年)
	//objSheet.Cells(27,4).value=myRadioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); // 待完成跌倒/坠床事件造成的结果
	//objSheet.Cells(28,4).value=$g(data["FDResult-95134"])==""?"无":"有";
	
	var eventresult=radioValue("FDResult-95131,FDResult-95134,FDResult-94245",data); //事件造成的后果
	var patHOD=radioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); //患者住院天数
	if (patHOD!=""){
		eventresult=$g(data["FDResult-95132"])+"（"+patHOD+"）"+"； "+eventresult;
	}	
	objSheet.Cells(27,2).value=eventresult; //事件造成的后果  
	objSheet.Cells(29,2).value=myRadioValue("FDResult-95133-95139,FDResult-95133-95140,FDResult-95133-95141,FDResult-95133-95142,FDResult-95133-95143",data); 
	objSheet.Cells(30,3).value=$g(data["RepHospType"]); //填报单位
	objSheet.Cells(30,8).value=$g(data["HospPhone"]); //联系电话
	objSheet.Cells(31,3).value=$g(data["ReportDate"]); //报告日期
	
	objSheet.Cells(32,3).value=$g(data["RepUserName"]); //填报人
	objSheet.Cells(32,6).value=$g(data["RepUserTitle"]); //职称
	objSheet.Cells(32,8).value=$g(data["RepUserWorkYears"]); //工作年限
	
	var WLErow=parseInt($g(data["WLEventProcess"]).length/40);
	var WLEheightlen=(WLErow+1)*14;
	objSheet.Rows(34+":"+34).RowHeight = WLEheightlen; 
	objSheet.Cells(34,2).value=$g(data["WLEventProcess"]); //事件经过
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //立即通知
	var deal=radioValue("PatEventProcess-95032,PatEventProcess-95034",data); //患者意外事件处理经过
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"（"+notice+"）； "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"；医疗或护理措施（"+$g(data["PatEventProcess-95033"])+"）"
	}
	objSheet.Cells(36,2).value=deal; //患者意外事件处理经过
	objSheet.printout();
	xlApp=null;
	xlBook.Close(savechanges=false);
	objSheet=null;
}


//处理未定义的变量
function $g(param){
	return param==undefined?"":	param;
}
//radio和checkbox数据获取
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
	
	return ret.join("； ");
}

//radio和checkbox数据获取  带有子元素拼串
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
	if (ret.join("； ")!=""){
		data=data+"（"+ret.join("； ")+"）";
	}
	return data;
}
function myRadioValue(param,data){
	var ret = radioValue(param,data);
	if(ret===""){
		ret="无";
	}
	return ret;
}
