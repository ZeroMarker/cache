//===========================================================================================
// 作者：      yuliping
// 编写日期:   2018-08-21
// 描述:	   新不良事件html打印
//===========================================================================================
var pageHeight=970;   //当前页面高度
var cuPage=1;           //当前第几页

$(document).ready(function(){	

	HiddenPathDate(); //IE 隐藏打印时文件路径和日期
	initTable();	// 初始化table内容，并调用打印
	$("#PrintBut").on("click",function(){
		printOrExportHtml();// 调用打印或导出
	}) 
	
  $('input,textarea').not("#print").attr("readonly","readonly");

})

//初始化表单内容，调用对应的打印方法
function initTable(){
	//alert(RepTypeCode)
	runClassMethod("web.DHCADVCOMMONPRINT","GetPrintData",{AdvMasterDr:RepID},function(ret){
		if(RepTypeCode=="advWallLeakage"){ 
			printWallLData(ret); //医疗护理风险防范(堵漏/隐患)事件报告单
		}else if(RepTypeCode=="advPipeOff"){
			printPipeOffData(ret);//管路脱落报告单  
		}else if(RepTypeCode=="advAccidentFill"){  
			printAccidentData(ret); //意外事件报告单
		}else if(RepTypeCode=="advDrugUseErr"){  
			printadvDrugUseErrData(ret); //用药错误事件报告单
		}else if(RepTypeCode=="advFallDownFill"){  
			printAdvFDFillData(ret); //跌倒(坠床)事件报告单	
		}else if(RepTypeCode=="advSkinUlcer"){  
			printAdvSkinUlcerData(ret); //压疮报告单
		}else if(RepTypeCode=="advDisMedThing"){  
			printAdvDisMedData(ret);  //一次性医疗用品不良事件报告单
		}else if(RepTypeCode=="advDevice"){
			printAdvDevicebyData(ret); // 器械
		}else if(RepTypeCode=="advBlood"){
			printAdvBloodbyData(ret); // 输血
		}else if(RepTypeCode=="advDrug"){
			printAdvdrugData(ret); //药品不良事件
		}else if(RepTypeCode=="advMedical"){		 
			printAdvMedicalData(ret); // 医疗不良事件			
		}else if(RepTypeCode=="advMedDispute"){
			printAdvMedDisputeData(ret); // 医疗投诉、纠纷登记表
		}else if(RepTypeCode=="advHosInfect"){  
			printadvHosInfectData(ret); //院感不良事件
		}else if(RepTypeCode=="advOccExpose"){  
			printadvOccExposeData(ret); //职业暴露不良事件报告单
		}else if(RepTypeCode=="advNonPlanRepa"){  
			printadvNonPlanRepaData(ret); //非计划再次手术报告单
		}else if(RepTypeCode=="advTransRct"){  
			printadvTransRctData(ret); //输液反应专项报告单
		}else if(RepTypeCode=="advDrugExos"){  
			printadvDrugExosData(ret); //药物外渗专项报告单
		}else if(RepTypeCode=="advDrugquality"){  
			printAdvdrugqualityData(ret); //药品质量报告单 
		}else {
			$.messager.alert("提示:","无打印相关程序！");
			return;
		}		
	})
}
/// 医疗护理风险防范（堵漏/隐患）事件报告单
function printWallLData(data){
    var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("医疗护理风险防范（堵漏/隐患）事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
    htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["AFLoc"]),3,"","","<tr>");   	//发生科室
	htmlStr=htmlStr+initTableTdOne("发现日期："+$g(data["FindDate"]),3,"","","");  					//发现日期
	htmlStr=htmlStr+initTableTdOne("事件类别："+$g(data["EveType"]),4,"","","</tr>");	//事件类别

    htmlStr=htmlStr+initTableTr("事件经过：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	
	htmlStr=htmlStr+initTableTr("原因分析：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //原因分析
	htmlStr=htmlStr+initTableTr($g(data["WLCauseAnalysis"]),"10","border-top:0px"); //原因分析
	
	htmlStr=htmlStr+initTableTr("改进办法：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //改进办法
	htmlStr=htmlStr+initTableTr($g(data["WLImprovedMethod"]),"10","border-top:0px"); //改进办法
	
	htmlStr=htmlStr+initTableTdOne("发现人："+$g(data["WallDiscover"]),3,"","","<tr>");	//发现人
	htmlStr=htmlStr+initTableTdOne("职称："+$g(data["JobTitle"]),7,"","","</tr>");	//职称
	htmlStr=htmlStr+initTableTdOne("职务："+$g(data["Duty"]),3,"","","<tr>");	//职务
	htmlStr=htmlStr+initTableTdOne("工作年限（年）："+$g(data["WallWorkYears"]),7,"","","</tr>");   	//上报人工作年限	

	htmlStr=htmlStr+initTableTr("相关领域："+getRadioValueById("RelatedAreas",data),"10","");   	//相关领域
	htmlStr=htmlStr+initTableTr("此事件是否为堵漏行为："+getRadioValueById("IfWLBehavior",data),"10","");	//此事件是否为堵漏行为
	htmlStr=htmlStr+initTableTdOne("堵漏人："+$g(data["WLMan"]),3,"","","<tr>");  					//堵漏人
	htmlStr=htmlStr+initTableTdOne("工作年限："+$g(data["WLManWorkLife"]),7,"","","</tr>");  					//工作年限
	htmlStr=htmlStr+initTableTr("堵漏人科室："+$g(data["WallLoc"]),"10","");  					//堵漏人科室
	
	htmlStr=htmlStr+initTableTr("堵漏行为：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //堵漏行为
	htmlStr=htmlStr+initTableTr($g(data["WLBehavior"]),"10","border-top:0px"); //堵漏行为
	htmlStr=htmlStr+initTableTdOne("差错事故性质结论："+getRadioValueById("EventConclusion",data),6,"","","<tr>");   	//差错事故性质结论
	htmlStr=htmlStr+initTableTdOne("绩效奖励："+getRadioValueById("PerformanceRewards",data),4,"","","</tr>");	//绩效奖励
	htmlStr=htmlStr+initTableTr("质量委员会意见：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //质量委员会意见
	htmlStr=htmlStr+initTableTr($g(data["QualityCommitteeOpinion"]),"10","border-top:0px"); //质量委员会意见
	
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
//管路滑脱不良事件打印
function printPipeOffData(data){
   var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("管路脱落报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料

	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者基本信息

	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>");   	//姓名
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	//病案号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");	//发生科室
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatID"]),3,"","","<tr>");  					//登记号
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");	//患者年龄

    htmlStr=htmlStr+initTableTdOne("性别："+$g(data["PatSexinput"]),4,"","","</tr>");   	//性别
	htmlStr=htmlStr+initTableTr("第一诊断："+$g(data["PatDiag"]),10,"");	//第一诊断
	htmlStr=htmlStr+initTableTdOne("患者来源："+getRadioValueById("PatOrigin",data),6,"","","<tr>");	//患者来源
	htmlStr=htmlStr+initTableTdOne("入院日期："+$g(data["PatAdmDate"]),4,"","","</tr>");  					//入院日期

	htmlStr=htmlStr+initTableTdOne("入院时ADL得分："+$g(data["PatAdmADLScore"]),3,"","","<tr>");   	//入院时ADL得分
	htmlStr=htmlStr+initTableTdOne("入院时患者自我照顾能力："+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//患者自我照顾能力
	htmlStr=htmlStr+initTableTdOne("发生前ADL得分："+$g(data["OccurADLScore"]),3,"","","<tr>");	//发生前ADL得分
	htmlStr=htmlStr+initTableTdOne("发生前患者自我照顾能力："+getRadioValueById("OccurPatSelfCareAbility",data),7,"","","</tr>");	//患者自我照顾能力
	htmlStr=htmlStr+initTableTdOne("陪护人员："+getRadioValueById("PatEscort",data),3,"","","<tr>");   	//陪护人员
	htmlStr=htmlStr+initTableTdOne("护理级别："+getRadioValueById("NursingLev",data),3,"","","");	//护理级别
	htmlStr=htmlStr+initTableTdOne("文化程度："+getRadioValueById("DegreeEducate",data),4,"","","</tr>");	//文化程度
	
	
	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");			//事件发生情况
	htmlStr=htmlStr+initTableTdOne("脱管发现日期："+$g(data["PipeFindDate"])+" "+$g(data["PipeFindTime"]),6,"","","<tr>");   	//脱管发生日期	
	htmlStr=htmlStr+initTableTdOne("置管日期："+$g(data["TubeDate"]),4,"","","</tr>");	//置管日期
	
	htmlStr=htmlStr+initTableTdOne("发现人："+getRadioValueById("PipeDiscoverers",data),3,"","","<tr>");	//发现人
	htmlStr=htmlStr+initTableTdOne("事件发生当班护士职称："+getRadioValueById("PipeDutyNurTitle",data),3,"","","");	//事件发生当班护士职称
	htmlStr=htmlStr+initTableTdOne("工作年限（年）："+$g(data["WallWorkYears"]),4,"","","</tr>");   	//上报人工作年限	

	htmlStr=htmlStr+initTableTr("导管类型："+getRadioValueById("PipeType",data),"10",""); 	//导管类型
	
	 
	htmlStr=htmlStr+initTableTr("患者身体状况","10","font-weight:bold;font-size:16px;"); //患者身体状况
	htmlStr=htmlStr+initTableTdOne("意识状态："+getRadioValueById("PipePS-94473",data),3,"","","<tr>");	//意识状态
	htmlStr=htmlStr+initTableTdOne("精神状态："+getRadioValueById("PipePS-94474",data),3,"","","");   	//精神状态	
	htmlStr=htmlStr+initTableTdOne("活动能力："+getRadioValueById("PipePS-94475",data),4,"","","</tr>");	//活动能力
	
	htmlStr=htmlStr+initTableTr("脱管原因："+getRadioValueById("PipeReason",data),"10","");   	//脱管原因
	htmlStr=htmlStr+initTableTr("固定方法："+getRadioValueById("PipeFixedMethod",data),"10","");   	//固定方法
	
	htmlStr=htmlStr+initTableTr("其他","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //其他
	htmlStr=htmlStr+initTableTr("健康教育："+getRadioValueById("PipeOther-94512",data),10,"border-top:0px;border-bottom:0px");	//健康教育
	htmlStr=htmlStr+initTableTr("约束带使用："+getRadioValueById("PipeOther-94513",data),10,"border-top:0px;border-bottom:0px");   	//约束带使用	
	htmlStr=htmlStr+initTableTr("事件发生前患者是否使用镇静药物："+getRadioValueById("PipeOther-94515",data),10,"border-top:0px;border-bottom:0px");	//事件发生前患者是否使用镇静药物
	htmlStr=htmlStr+initTableTr("管路滑脱时工作人员："+getRadioValueById("PipeOther-94516",data),10,"border-top:0px;border-bottom:0px");	//管路滑脱时工作人员
	htmlStr=htmlStr+initTableTr("患者既往是否发生过管路滑脱事件："+getRadioValueById("PipeOther-94517",data),10,"border-top:0px");	//患者既往是否发生过管路滑脱事件

	
	var pipetakesteps=radioValue("PipeTakeSteps-94533,PipeTakeSteps-94534,PipeTakeSteps-94537",data) //采取措施（可多选）
	var pipetakename=$g(data["PipeTakeSteps-94536-94258"]); //诊断性检查 具体名称
	if (pipetakename!=""){
		pipetakename="诊断性检查（具体名称："+pipetakename+"）";
	}
	if ((pipetakesteps!="")&&(pipetakename!="")){
		pipetakesteps=pipetakesteps+"；"+pipetakename;
	}
	
	htmlStr=htmlStr+initTableTr("采取措施","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //采取措施
	htmlStr=htmlStr+initTableTr(pipetakesteps,10,"border-top:0px;border-bottom:0px");	//采取措施
	var PipeComplication=radioValue("PipeComplication-94539,PipeComplication-94540",data); //并发症 有 无
	var ifblood=$g(data["PipeComplication-94540-94541"]); //并发症出血
	if (ifblood!=""){
		ifblood="出血"+ifblood+"(ml)";
	}
	var otherlComp=radioValue("PipeComplication-94540-94542,PipeComplication-94540-94543,PipeComplication-94540-94544,PipeComplication-94540-94545,PipeComplication-94540-94546,PipeComplication-94540-94547,PipeComplication-94540-94548",data)
	if (PipeComplication=="有"){
		PipeComplication=otherlComp+"； "+ifblood;
	}
	htmlStr=htmlStr+initTableTr("并发症","10","font-weight:bold;border-bottom:0px;font-size:16px;"); //并发症
	htmlStr=htmlStr+initTableTr(PipeComplication,10,"border-top:0px;border-bottom:0px");	//并发症
	htmlStr=htmlStr+initTableTr("报告单位："+$g(data["RepHospType"]),10,"");	//报告单位
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),3,"","","<tr>");	//报告日期
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),7,"","","</tr>");	//联系电话

	htmlStr=htmlStr+initTableTdOne("填报人姓名："+$g(data["RepUserName"]),3,"","","<tr>");	//填报人姓名
	htmlStr=htmlStr+initTableTdOne("填报人职称："+$g(data["RepUserTitle"]),3,"","","");   	//填报人职称	
	htmlStr=htmlStr+initTableTdOne("工作年限："+$g(data["RepUserWorkYears"]),4,"","","</tr>");   	//工作年限	
	
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	
	htmlStr=htmlStr+initTableTr("处理措施","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //处理措施
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //处理措施
	
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
	//printOrExportHtml()  // 调用打印或导出
}
/// 意外事件报告单打印
function printAccidentData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("意外事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者基本信息

	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>");   	//姓名
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	//病案号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");	//发生科室
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatID"]),3,"","","<tr>");  					//登记号
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");	//患者年龄

    htmlStr=htmlStr+initTableTdOne("性别："+$g(data["PatSexinput"]),4,"","","</tr>");   	//性别
	htmlStr=htmlStr+initTableTr("第一诊断："+$g(data["PatDiag"]),10,"");	//第一诊断
	htmlStr=htmlStr+initTableTdOne("患者来源："+getRadioValueById("PatOrigin",data),6,"","","<tr>");	//患者来源
	htmlStr=htmlStr+initTableTdOne("入院日期："+$g(data["PatAdmDate"]),4,"","","</tr>");  					//入院日期

    htmlStr=htmlStr+initTableTdOne("入院时ADL得分："+$g(data["PatAdmADLScore"]),3,"","","<tr>");   	//入院时ADL得分
	htmlStr=htmlStr+initTableTdOne("入院时患者自我照顾能力："+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//患者自我照顾能力
    htmlStr=htmlStr+initTableTdOne("陪护人员："+getRadioValueById("PatEscort",data),3,"","","<tr>");   	//陪护人员
	htmlStr=htmlStr+initTableTdOne("护理级别："+getRadioValueById("NursingLev",data),3,"","","");	//护理级别
	htmlStr=htmlStr+initTableTdOne("文化程度："+getRadioValueById("DegreeEducate",data),4,"","","</tr>");	//文化程度
	
	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");			//事件发生情况
	
	htmlStr=htmlStr+initTableTr("意外事件发生类型："+getRadioValueById("AFType",data),10,"");   	//意外事件发生类型
	htmlStr=htmlStr+initTableTdOne("发生地点："+getRadioValueById("HappenPlace-label",data),3,"","","<tr>");   	//发生地点
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),7,"","","</tr>");	//发生日期

	htmlStr=htmlStr+initTableTdOne("发现人："+getRadioValueById("DiscoverMan",data),3,"","","<tr>");   	//发现人
	 htmlStr=htmlStr+initTableTdOne("工作年限："+$g(data["WLManWorkLife"]),3,"","","");   	//工作年限
	htmlStr=htmlStr+initTableTdOne("事件发生当班护士职称："+getRadioValueById("PipeDutyNurTitle",data),4,"","","</tr>");	//事件发生当班护士职称
	var AFResult="";
	var eventresult=radioValue("AFResult-94565,AFResult-94567",data); //事件造成的后果
	var patHOD=getRadioValueById("AFResult-94566",data); //患者住院天数
	if (eventresult!=""){
		AFResult=AFResult+eventresult+"；";
	}	
	if (patHOD!=""){
		AFResult=AFResult+$g(data["AFResult-94566"])+"（"+patHOD+"）；";
	}	
	htmlStr=htmlStr+initTableTr("事件造成的后果：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //事件造成的后果
	htmlStr=htmlStr+initTableTr(AFResult,"10","border-top:0px"); //事件造成的后果
	htmlStr=htmlStr+initTableTr("报告单位："+$g(data["RepHospType"]),10,"");	//报告单位
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),3,"","","<tr>");   	//联系电话
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),7,"","","</tr>");   	//报告日期
	
	htmlStr=htmlStr+initTableTr("事件经过：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	var PatEventProcess="";
	var notice=getRadioValueById("PatEventProcess-95021",data);  //立即通知
	if(notice!=""){
		PatEventProcess=PatEventProcess+"立即通知（"+notice+"）；" ;
	}
	if(radioValue("PatEventProcess-95032",data)!=""){
		PatEventProcess=PatEventProcess+radioValue("PatEventProcess-95032",data)+"；" ;
	}
	if($g(data["PatEventProcess-95033"])!=""){
		PatEventProcess=PatEventProcess+"医疗或护理措施（"+$g(data["PatEventProcess-95033"])+"）；" ;
	}
	if($g(data["PatEventProcess-95034"])!=""){
		PatEventProcess=PatEventProcess+$g(data["PatEventProcess-95034"]);
	}
	
	htmlStr=htmlStr+initTableTr("患者意外事件处理经过：","10","border-bottom:0px;font-size:16px;font-weight:bold;"); //患者意外事件处理经过
	htmlStr=htmlStr+initTableTr(PatEventProcess,"10","border-top:0px"); //患者意外事件处理经过
	
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
	//printOrExportHtml()  // 调用打印或导出
	
}
//用药错误事件报告单
function printadvDrugUseErrData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("用药错误报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>") //患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatID"]),3,"","","");   	//登记号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");   	//发生科室
	htmlStr=htmlStr+initTableTdOne("患者性别："+$g(data["PatSexinput"]),3,"","","<tr>") //患者性别
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");   	//患者年龄
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//病案号
	htmlStr=htmlStr+initTableTr("第一诊断："+$g(data["PatDiag"]),"10","border-top:0px"); //第一诊断
	htmlStr=htmlStr+initTableTdOne("入院日期："+$g(data["PatAdmDate"]),3,"","","<tr>");				//入院日期
	htmlStr=htmlStr+initTableTdOne("患者来源："+getRadioValueById("PatOrigin",data),7,"","","</tr>");	//患者来源
	htmlStr=htmlStr+initTableTdOne("护理级别："+getRadioValueById("NursingLev",data),3,"","","<tr>");	//护理级别
	htmlStr=htmlStr+initTableTdOne("文化程度："+getRadioValueById("DegreeEducate",data),7,"","","</tr>");	//文化程度

	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");			//事件发生情况
	htmlStr=htmlStr+initTableTdOne("给药发生日期："+$g(data["GiveDrugHappenTime"])+" "+$g(data["OccurTime"]),6,"","","<tr>");				//发生日期
	htmlStr=htmlStr+initTableTdOne("发生地点："+getRadioValueById("DrugUseHappenPlace-label",data),4,"","","</tr>");	//发生地点
	htmlStr=htmlStr+initTableTdOne("当事人姓名 ："+$g(data["PartyName"]),3,"","","<tr>");	//当事人姓名 
	htmlStr=htmlStr+initTableTdOne("能级："+$g(data["DrugUseErrLevel"]),3,"","","");	//能级
	htmlStr=htmlStr+initTableTdOne("班次："+$g(data["Shift"]),4,"","","</tr>");	//班次
	htmlStr=htmlStr+initTableTdOne("当事人身份："+getRadioValueById("DrugUseErrRank",data),3,"","","<tr>");	//当事人身份
	htmlStr=htmlStr+initTableTdOne("当事人职称："+getRadioValueById("DrugUsePartyTitle",data),3,"","","");	//当事人职称
	htmlStr=htmlStr+initTableTdOne("当事人工作年限（年）："+$g(data["DrugUsePartyWorkYears"]),4,"","","</tr>");	//当事人工作年限（年）
	htmlStr=htmlStr+initTableTdOne("发现人姓名："+$g(data["WallDiscover"]),3,"","","<tr>");	//发现人姓名
	htmlStr=htmlStr+initTableTdOne("工作年限(年)："+$g(data["WLManWorkLife"]),7,"","","</tr>");	//工作年限(年)
	
	htmlStr=htmlStr+initTableTr("错误类型",10,"font-weight:bold;font-size:16px;"); 	//错误类型
	htmlStr=htmlStr+initTableTdOne("给药时间错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("医嘱给药时间 （"+$g(data["DrugUseErrType-94617-94204"])+"），错误给药时间 （"+$g(data["DrugUseErrType-94617-94205"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("给药途径错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("医嘱给药途径 （"+$g(data["DrugUseErrType-94618-94208"])+"），错误给药途径 （"+$g(data["DrugUseErrType-94618-94209"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("遗漏给药：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("遗漏次数 （"+$g(data["DrugUseErrType-94619-94212"])+"），医嘱给药时间 （"+$g(data["DrugUseErrType-94619-94213"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("输液速度错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("药物名称 （"+$g(data["DrugUseErrType-94620-94215"])+"），错误给药速度 （"+$g(data["DrugUseErrType-94620-94216"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("剂量错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("医嘱给药剂量 （"+$g(data["DrugUseErrType-94621-94219"])+"），错误给药剂量 （"+$g(data["DrugUseErrType-94621-94220"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("剂型错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("医嘱给药剂型 （"+$g(data["DrugUseErrType-94622-94223"])+"），错误给药剂型 （"+$g(data["DrugUseErrType-94622-94224"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("药物错误：",2,"","","<tr>");	
	htmlStr=htmlStr+initTableTdOne("医嘱给药名称 （"+$g(data["DrugUseErrType-94623-94227"])+"），错误给药名称 （"+$g(data["DrugUseErrType-94623-94228"])+"）",8,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("其他错误：",2,0,"","<tr>");	
	htmlStr=htmlStr+initTableTdOne(radioValue("DrugUseErrType-94616,DrugUseErrType-94624,DrugUseErrType-94625",data),8,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("缺陷引起的后果："+getRadioValueById("DrugUseDefectResult-label",data),10,"","");	//当事人职称

	htmlStr=htmlStr+initTableTr("报告单位："+$g(data["RepHospType"]),10,"");	//报告单位
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),3,"","","<tr>");	//联系电话
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),7,"","","</tr>");	//报告日期
	htmlStr=htmlStr+initTableTdOne("填报人姓名："+$g(data["RepUserName"]),3,"","","<tr>");	//填报人姓名
	htmlStr=htmlStr+initTableTdOne("填报人职称："+$g(data["RepUserTitle"]),3,"","","");   	//填报人职称	
	htmlStr=htmlStr+initTableTdOne("填报人工作年限："+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//填报人工作年限
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	htmlStr=htmlStr+initTableTr("处理措施","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //处理措施
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //处理措施

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
	//printOrExportHtml()  // 调用打印或导出
}
//跌倒(坠床)事件报告单html打印
function printAdvFDFillData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("跌倒(坠床)事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>") //患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatID"]),3,"","","");   	//登记号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");   	//发生科室
	htmlStr=htmlStr+initTableTdOne("患者性别："+$g(data["PatSexinput"]),3,"","","<tr>") //患者性别
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");   	//患者年龄
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//病案号
	htmlStr=htmlStr+initTableTr("第一诊断："+$g(data["PatDiag"]),"10","border-top:0px"); //第一诊断
	htmlStr=htmlStr+initTableTdOne("入院日期："+$g(data["PatAdmDate"]),3,"","","<tr>");				//入院日期
	htmlStr=htmlStr+initTableTdOne("患者来源："+getRadioValueById("PatOrigin",data),7,"","","</tr>");	//患者来源
	htmlStr=htmlStr+initTableTdOne("入院时ADL得分："+$g(data["PatAdmADLScore"]),3,"","","<tr>");				//入院时ADL得分
	htmlStr=htmlStr+initTableTdOne("自我照顾能力："+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//自我照顾能力
	htmlStr=htmlStr+initTableTdOne("陪护人员："+getRadioValueById("PatEscort",data),6,"","","<tr>");	//陪护人员
	htmlStr=htmlStr+initTableTdOne("护理级别："+getRadioValueById("NursingLev",data),4,"","","</tr>");	//护理级别
	
	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");			//事件发生情况
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),3,"","","<tr>");				//发生日期
	htmlStr=htmlStr+initTableTdOne("发生类型："+getRadioValueById("FallDownType",data),3,"","","");	//发生类型
	htmlStr=htmlStr+initTableTdOne("发生地点："+getRadioValueById("HappenPlace-label",data),4,"","","</tr>");	//发生地点
	htmlStr=htmlStr+initTableTr("跌倒/坠床（指患者身体的任何部位（不包括双脚）意外触及地面）时患者的状态："+getRadioValueById("FDPatState",data),10,"");				//发生日期
	htmlStr=htmlStr+initTableTr("受伤部位："+$g(data["JuredPart"]),10,"");	//受伤部位
	
	var ReasonStr=getRadioById(RepID,"OccurReason")
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var OccurReason="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				OccurReason=OccurReason+"  "+j+"、"+"其他因素："+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("：")==-1){
				if(ReasonArr[1]!=""){
			 		OccurReason=OccurReason+"  "+j+"、"+ReasonArr[0]+"："+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	OccurReason=OccurReason+"  "+j+"、"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("发生原因：","10","border-bottom:0px;font-weight:bold;font-size:16px;")		//发生原因
	htmlStr=htmlStr+initTableTr(OccurReason,"10","border-top:0px")		//发生原因

	htmlStr=htmlStr+initTableTdOne("发现人："+getRadioValueById("DiscoverMan",data),3,"","","<tr>");	//发现人
	htmlStr=htmlStr+initTableTdOne("事件发生当班护士职称："+getRadioValueById("PipeDutyNurTitle",data),3,"","","");	//事件发生当班护士职称
	htmlStr=htmlStr+initTableTdOne("工作年限(年)："+$g(data["WLManWorkLife"]),4,"","","</tr>");	//工作年限(年)
	var eventresult=radioValue("FDResult-95131,FDResult-95134,FDResult-94245",data); //事件造成的后果
	var patHOD=radioValue("FDResult-95132-95135,FDResult-95132-95136,FDResult-95132-95137,FDResult-95132-95138",data); //患者住院天数
	if (patHOD!=""){
		eventresult=$g(data["FDResult-95132"])+"（"+patHOD+"）"+"； "+eventresult;
	}	
	htmlStr=htmlStr+initTableTr("跌倒/坠床事件造成的结果："+eventresult,"10","");	//跌倒/坠床事件造成的结果
	htmlStr=htmlStr+initTableTr("伤害严重程度："+getRadioValueById("FDResult-label",data),"10","");	//伤害严重程度

	htmlStr=htmlStr+initTableTr("报告单位："+$g(data["RepHospType"]),10,"");	//报告单位
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),3,"","","<tr>");	//联系电话
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),7,"","","</tr>");	//报告日期
	htmlStr=htmlStr+initTableTdOne("填报人姓名："+$g(data["RepUserName"]),3,"","","<tr>");	//填报人姓名
	htmlStr=htmlStr+initTableTdOne("填报人职称："+$g(data["RepUserTitle"]),3,"","","");	//填报人职称
	htmlStr=htmlStr+initTableTdOne("填报人工作年限："+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//填报人工作年限
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	
	var notice=radioValue("PatEventProcess-95021-95024,PatEventProcess-95021-95025,PatEventProcess-95021-95026,PatEventProcess-95021-95028,PatEventProcess-95021-95029,PatEventProcess-95021-95030,PatEventProcess-95021-95031",data); //立即通知
	var deal=radioValue("PatEventProcess-95032,PatEventProcess-95034",data); //患者意外事件处理经过
	if(notice!=""){
		deal=$g(data["PatEventProcess-95021"])+"（"+notice+"）； "+deal
	}
	if($g(data["PatEventProcess-95033"])!=""){
		deal=deal+"；医疗或护理措施（"+$g(data["PatEventProcess-95033"])+"）"
	}
	htmlStr=htmlStr+initTableTr("患者意外事件处理经过：","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //患者意外事件处理经过
	htmlStr=htmlStr+initTableTr(deal,"10","border-top:0px"); //患者意外事件处理经过
	
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
	//printOrExportHtml()  // 调用打印或导出
}
//压疮报告单html打印
function printAdvSkinUlcerData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("压疮报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>") //患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatID"]),3,"","","");   	//登记号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");   	//发生科室
	htmlStr=htmlStr+initTableTdOne("患者性别："+$g(data["PatSexinput"]),3,"","","<tr>") //患者性别
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");   	//患者年龄
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//病案号
	htmlStr=htmlStr+initTableTr("第一诊断："+$g(data["PatDiag"]),"10",""); //第一诊断
	htmlStr=htmlStr+initTableTdOne("入院日期："+$g(data["PatAdmDate"]),6,"","","<tr>");				//入院日期
	htmlStr=htmlStr+initTableTdOne("患者来源："+getRadioValueById("PatOrigin",data),4,"","","</tr>");	//患者来源
	htmlStr=htmlStr+initTableTdOne("入院时ADL得分："+$g(data["PatAdmADLScore"]),3,"","","<tr>");				//入院时ADL得分
	htmlStr=htmlStr+initTableTdOne("自我照顾能力："+getRadioValueById("PatSelfCareAbility",data),7,"","","</tr>");	//自我照顾能力
	htmlStr=htmlStr+initTableTdOne("陪护人员："+getRadioValueById("PatEscort",data),6,"","","<tr>");	//陪护人员
	htmlStr=htmlStr+initTableTdOne("护理级别："+getRadioValueById("NursingLev",data),4,"","","</tr>");	//护理级别
	htmlStr=htmlStr+initTableTr("使用压疮风险评分表："+getRadioValueById("UseUlcerRiskpointtab",data),10,"");				//使用压疮风险评分表
	htmlStr=htmlStr+initTableTdOne("入院压疮风险评分："+$g(data["HospUlcerRiskScore"]),6,"","","<tr>");	//入院压疮风险评分
	htmlStr=htmlStr+initTableTdOne("压疮风险等级："+getRadioValueById("HospUlcerRiskLev",data),4,"","","</tr>");	//压疮风险等级
	htmlStr=htmlStr+initTableTdOne("发生压疮时风险评分："+$g(data["OccurUlcerRiskScore"]),6,"","","<tr>");	//发生压疮时风险评分
	htmlStr=htmlStr+initTableTdOne("压疮风险等级："+getRadioValueById("OccurUlcerRiskLev",data),4,"","","</tr>");	//压疮风险等级
	htmlStr=htmlStr+initTableTdOne("文化程度："+getRadioValueById("DegreeEducate",data),6,"","","<tr>");				//文化程度
	htmlStr=htmlStr+initTableTdOne("手术(小时)："+$g(data["OpeDuration"]),4,"","","</tr>");	//手术(小时)
	
	//htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;");			//事件发生情况
	htmlStr=htmlStr+initTableTr("压疮部位信息","10","font-weight:bold;font-size:16px;");
	var UlcerPartlist=$g(data["UlcerPart"]);//压疮部位
	
	//var SuspectNewDrugList=$g(data["SuspectNewDrug"]);  //怀疑药品列表
   	if(UlcerPartlist!=""){//value,colspan,rowspan,valueCss,tr
   		htmlStr=htmlStr+initTableTdOne("发现日期","2","","background-color:#808080;width:20%;","<tr>");
		htmlStr=htmlStr+initTableTdOne("来源","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("部位","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("分期","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("长cm*宽cm*深cm","2","","background-color:#808080","</tr>");

	   	$(UlcerPartlist).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["UlcerPart-95158-95162-95192"]),"2","","width:20%;","<tr>");
			var orign=radioValue("UlcerPart-95158-95163-95170,UlcerPart-95158-95163-95171",obj); //来源
			var orignout=radioValue("UlcerPart-95158-95163-95171-94233,UlcerPart-95158-95163-95171-94234,UlcerPart-95158-95163-95171-94235,UlcerPart-95158-95163-95171-94236",obj); //院外带入
			if (orignout!=""){orign=orign+"（"+orignout+"）";}
			htmlStr=htmlStr+initTableTdOne(orign+" "+orignout,"2","","width:20%;","");
			//var UlcerPart=getRadioValueById("UlcerPart-95158-95166",obj);
			var part=""
			var qtpart=radioValue("UlcerPart-95158-95166-95172,UlcerPart-95158-95166-95178,UlcerPart-95158-95166-95182",obj); //部位
			if (qtpart!=""){part=qtpart+"； "+part; }
			var ekpart=checksubValue($g(obj["UlcerPart-95158-95166-95173"]),"UlcerPart-95158-95166-95173-95196,UlcerPart-95158-95166-95173-95197",obj); //耳廓
			if (ekpart!=""){part=ekpart+"； "+part; }
			var jjpart=checksubValue($g(obj["UlcerPart-95158-95166-95174"]),"UlcerPart-95158-95166-95174-94173,UlcerPart-95158-95166-95174-94174",obj); //肩胛部
			if (jjpart!=""){part=jjpart+"； "+part; }
			var zbpart=checksubValue($g(obj["UlcerPart-95158-95166-95175"]),"UlcerPart-95158-95166-95175-94177,UlcerPart-95158-95166-95175-94178",obj); //肘部
			if (zbpart!=""){part=zbpart+"； "+part; }
			var qqsjpart=checksubValue($g(obj["UlcerPart-95158-95166-95176"]),"UlcerPart-95158-95166-95176-94181,UlcerPart-95158-95166-95176-94182",obj); //髂前上棘
			if (qqsjpart!=""){part=qqsjpart+"； "+part; }
			var kbpart=checksubValue($g(obj["UlcerPart-95158-95166-95177"]),"UlcerPart-95158-95166-95177-94185,UlcerPart-95158-95166-95177-94186",obj); //髋部
			if (kbpart!=""){part=kbpart+"； "+part; }
			var xbpart=checksubValue($g(obj["UlcerPart-95158-95166-95179"]),"UlcerPart-95158-95166-95179-94189,UlcerPart-95158-95166-95179-94190",obj); //膝部
			if (xbpart!=""){part=xbpart+"； "+part; }
			var hbpart=checksubValue($g(obj["UlcerPart-95158-95166-95180"]),"UlcerPart-95158-95166-95180-94193,UlcerPart-95158-95166-95180-94194",obj); //踝部
			if (hbpart!=""){part=hbpart+"； "+part; }
			var zgbpart=checksubValue($g(obj["UlcerPart-95158-95166-95181"]),"UlcerPart-95158-95166-95181-94197,UlcerPart-95158-95166-95181-94198",obj); //足跟部
			if (zgbpart!=""){part=zgbpart+"； "+part; }
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
			
			htmlStr=htmlStr+initTableTdOne(cmlistl+"×"+cmlistw+"×"+cmlists,"2","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有压疮部位信息","10","");
	}
	
	htmlStr=htmlStr+initTableTr("压疮发生原因","10","font-weight:bold;font-size:16px;border-bottom:0px");
	htmlStr=htmlStr+initTableTr("患者因素："+getRadioValueById("UlcerOccurReason-94948",data),"10","border-bottom:0px;border-top:0px");				//患者因素
	htmlStr=htmlStr+initTableTr("病情因素："+getRadioValueById("UlcerOccurReason-94949",data),"10","border-bottom:0px;border-top:0px");	//病情因素
	htmlStr=htmlStr+initTableTr("护理人员因素："+getRadioValueById("UlcerOccurReason-94950",data),"10","border-bottom:0px;border-top:0px");	//护理人员因素
	htmlStr=htmlStr+initTableTr("其他因素："+getRadioValueById("UlcerOccurReason-94951",data),"10","border-top:0px");	//其他因素
	
	htmlStr=htmlStr+initTableTr("事件情况","10","font-weight:bold;font-size:16px;");			//事件情况
	htmlStr=htmlStr+initTableTr("已采取护理措施："+getRadioValueById("AdoptNursMeasure",data),"10","");
	htmlStr=htmlStr+initTableTr("报告单位："+$g(data["RepHospType"]),10,"");	//报告单位
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),3,"","","<tr>");	//联系电话
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),7,"","","</tr>");	//报告日期
	htmlStr=htmlStr+initTableTdOne("填报人姓名："+$g(data["RepUserName"]),3,"","","<tr>");	//填报人姓名
	htmlStr=htmlStr+initTableTdOne("填报人职称："+$g(data["RepUserTitle"]),3,"","","");	//填报人职称
	htmlStr=htmlStr+initTableTdOne("填报人工作年限："+$g(data["RepUserWorkYears"]),4,"","","</tr>");	//填报人工作年限
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	htmlStr=htmlStr+initTableTr("处理措施（伤口换药）","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //处理措施
	htmlStr=htmlStr+initTableTr($g(data["dealWay"]),"10","border-top:0px"); //处理措施
	var HeadNurEvaList="",LocHeadNurEvaList="",NurDepEvaList="";
	var HeadNurEvaRecId="",LocHeadNurEvaRecId="",NurDepEvaRecId="",OutHeadNurEvaRecId="";
	//院内压疮护士长评价
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
	//院外压疮护士长评价
	runClassMethod("web.DHCADVCOMMONPART","GetRecordId",{'LinkRecordId':recordID,'FormCode':"UlcOutHeaNurEvaluate"},
	function(data){ 
			 OutHeadNurEvaRecId=data
	},"text",false)
	if((HeadNurEvaRecId!="")&&(orign=="院内发生")){
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
	//院外压疮
	if((OutHeadNurEvaRecId!="")&&(orign.indexOf("院外带入")>=0)){
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
	//printOrExportHtml()  // 调用打印或导出
}
//一次性医疗用品不良事件报告单
function printAdvDisMedData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("一次性医疗用品不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者一般资料","10","font-weight:bold;font-size:16px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["DisMedThingPatName"]),3,"","","<tr>") //患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatID"]),3,"","","");   	//登记号
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccuLoc"]),4,"","","</tr>");   	//发生科室
	htmlStr=htmlStr+initTableTdOne("患者性别："+$g(data["PatSexinput"]),3,"","","<tr>") //患者性别
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");   	//患者年龄
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),4,"","","</tr>");   	//病案号
	
	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");			//事件发生情况
	htmlStr=htmlStr+initTableTr("事件发生日期："+$g(data["DisMedThingHappenDate"]),"10","");			//事件发生日期
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["WLEventProcess"]),"10","border-top:0px"); //事件经过
	htmlStr=htmlStr+initTableTdOne("医疗器械分类名称："+$g(data["DisMedThingMdType"]),3,"","","<tr>");	//医疗器械分类名称
	htmlStr=htmlStr+initTableTdOne("商品名称："+$g(data["DisMedThingGoodName"]),3,"","","");	//商品名称
	htmlStr=htmlStr+initTableTdOne("注册证号："+$g(data["DisMedThingRegNumber"]),4,"","","</tr>");	//注册证号

	htmlStr=htmlStr+initTableTdOne("生产企业名称："+$g(data["DisMedThingREnterpriseName"]),3,"","","<tr>");	//生产企业名称
	htmlStr=htmlStr+initTableTdOne("地址："+$g(data["DisMedThingAddress"]),3,"","","");	//地址
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),4,"","","</tr>");	//联系电话

	htmlStr=htmlStr+initTableTdOne("型号规格："+$g(data["DisMedThingModelSpecification"]),3,"","","<tr>");	//型号规格
	htmlStr=htmlStr+initTableTdOne("产品编号："+$g(data["DisMedThingCode"]),3,"","","");	//产品编号
	htmlStr=htmlStr+initTableTdOne("产品批号："+$g(data["DisMedThingProductNummber"]),4,"","","</tr>");	//产品批号

	htmlStr=htmlStr+initTableTdOne("有效期至："+$g(data["DisMedThingPeriodValidity"]),3,"","","<tr>");	//有效期至
	htmlStr=htmlStr+initTableTdOne("停用日期："+$g(data["DisMedThingDeactivateDate"]),3,"","","");	//停用日期
	htmlStr=htmlStr+initTableTdOne("植入日期（若植入）："+$g(data["DisMedThingImlantDate"]),4,"","","</tr>");	//植入日期
	
	htmlStr=htmlStr+initTableTr("事件发生原因分析","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件发生原因分析
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingEventCauseAnaly"]),"10","border-top:0px"); //事件发生原因分析
	htmlStr=htmlStr+initTableTr("事件处理情况","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //事件处理情况
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingEventResult"]),"10","border-top:0px"); //事件处理情况
	
	htmlStr=htmlStr+initTableTr("事件报告状态："+getRadioValueById("DisMedThingEventReportStatue",data),"10","");	//事件报告状态
	htmlStr=htmlStr+initTableTr("警示","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //警示
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingCaution"]),"10","border-top:0px"); //警示

	htmlStr=htmlStr+initTableTr("质量管理委员会：","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //质量管理委员会
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingQMC"]),"10","border-top:0px"); //质量管理委员会
	htmlStr=htmlStr+initTableTdOne("报告人（签名）："+$g(data["DisMedThingEventUserOfReport"]),3,"","","<tr>");	//报告人（签名）
	htmlStr=htmlStr+initTableTdOne("报告科室："+$g(data["DisMedThingDept"]),3,"","","");	//报告科室
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),4,"","","</tr>");	//报告日期
	htmlStr=htmlStr+initTableTr("备注","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //备注
	htmlStr=htmlStr+initTableTr($g(data["DisMedThingRepRemark"]),"10","border-top:0px"); //备注


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
	//printOrExportHtml()  // 调用打印或导出
}
//器械不良事件
function printAdvDevicebyData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("器械不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),4,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),6,"","","","</tr>");  //上报时间

	htmlStr=htmlStr+initTableTr("报告来源 :"+getRadioValueById("MedRepSource",data),10,"");   //报告来源
	htmlStr=htmlStr+initTableTr("联系地址 :"+$g(data["PatContactAddr"]),10,"");			 //联系地址
	htmlStr=htmlStr+initTableTr("邮编 :"+$g(data["PatPostCode"]),10,""); 		 //邮编

	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");						//患者基本信息

	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");  					//姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");			//患者年龄
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//性别
	
	htmlStr=htmlStr+initTableTdOne("年龄类型："+$g(data["AgeType"]),3,"","","<tr>");				//年龄类型
	htmlStr=htmlStr+initTableTdOne("出生日期："+$g(data["PatDOB"]),3,"","","");						//出生日期
	htmlStr=htmlStr+initTableTdOne("电话："+$g(data["MedNewRepTel"]),4,"","","</tr>");				//电话
	htmlStr=htmlStr+initTableTr("预期治疗疾病或作用","10","border-bottom:0px"); //预期治疗疾病或作用
	htmlStr=htmlStr+initTableTr($g(data["MDProspectiveNewTreat"]),"10","border-top:0px"); //预期治疗疾病或作用

	htmlStr=htmlStr+initTableTr("事件基本信息","10","font-weight:bold;font-size:16px;");		//事件基本信息
	htmlStr=htmlStr+initTableTr("事件主要表现","10","");							//事件主要表现
	
	htmlStr=htmlStr+initTableTdOne("器械故障："+$g(data["EquipmentFailure"]),3,"","","<tr>");  		//器械故障
	htmlStr=htmlStr+initTableTdOne("主要伤害："+$g(data["MainDamage"]),3,"","","");  				//主要伤害
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),4,"","","</tr>");  			//发生科室
	
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),6,"","","<tr>");  		//上报所属科室
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),4,"","","</tr>");  			//上报人职称
	
	htmlStr=htmlStr+initTableTr("不良事件的等级："+getRadioValueById("EventRepLevel",data),"10","")	//不良事件的等级
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"]),6,"","","<tr>");  			//发生日期 
	htmlStr=htmlStr+initTableTdOne("发现日期："+$g(data["FindDate"]),4,"","","");  					//发现日期
	htmlStr=htmlStr+initTableTr("医疗器械实际使用场所："+getRadioValueById("MedDevicesPlace",data),"10","");  //医疗器械实际使用场所
	var MedNewEventResult=getRadioValueById("MedNewEventResult",data)
	var dietime=$g(data["MedNewEventResult-97739-97915"])
	if(dietime!=""){
		MedNewEventResult=MedNewEventResult+" 死亡时间："+dietime
		}
	htmlStr=htmlStr+initTableTr("事件后果："+MedNewEventResult,"10","")	//事件后果
	htmlStr=htmlStr+initTableTr("事件陈述","10","border-bottom:0px;"); //事件陈述
	htmlStr=htmlStr+initTableTr($g(data["MdEventStatement"]),"10","border-top:0px"); //事件陈述

	htmlStr=htmlStr+initTableTr("医疗器械情况","10","font-weight:bold;font-size:16px;");			//医疗器械情况
	htmlStr=htmlStr+initTableTr("医疗器械信息",10,"")				//医疗器械信息
	
	htmlStr=htmlStr+initTableTdOne("注册证号："+$g(data["MDRegistrationNo"]),6,"","","<tr>");  		//注册证号
	htmlStr=htmlStr+initTableTdOne("产品名称："+$g(data["MDProductNewName"]),4,"","","</tr>");  			//产品名称
	htmlStr=htmlStr+initTableTdOne("商品名称："+$g(data["MDCommodityNewName"]),6,"","","<tr>");  		//商品名称
	htmlStr=htmlStr+initTableTdOne("产品分类："+$g(data["MDRProductClassify"]),4,"","","</tr>");  	//产品分类
	
	htmlStr=htmlStr+initTableTr("产品信息",10,"");  		//产品信息
	htmlStr=htmlStr+initTableTdOne("企业名称："+$g(data["MDEnterpriseNameBy "]),6,"","","<tr>");  			//企业名称
	htmlStr=htmlStr+initTableTdOne("企业地址："+$g(data["MDREnterpriseAddressBy "]),4,"","","</tr>");  		//企业地址
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["MDEnterpriseRelateTelephone "]),6,"","","<tr>");  	//联系电话
	htmlStr=htmlStr+initTableTdOne("规格型号："+$g(data["MDlSpecificationMode"]),4,"","","</tr>");  		//规格型号
	htmlStr=htmlStr+initTableTdOne("产品编号："+$g(data["DisMedCode"]),6,"","","<tr>");  		//产品编号
	htmlStr=htmlStr+initTableTdOne("产品批号（耗材必备）："+$g(data["MDProductBatchNo"]),4,"","","</tr>");  	//产品批号（耗材必备）
	htmlStr=htmlStr+initTableTr("操作人："+getRadioValueById("MedOperator",data),"10","")	//事件后果
	
	htmlStr=htmlStr+initTableTr("日期",10,"");  		//产品信息
	htmlStr=htmlStr+initTableTdOne("有效期至："+$g(data["MedAllDate-97761"]),6,"","","<tr>");  				//有效期至 
	htmlStr=htmlStr+initTableTdOne("生产日期："+$g(data["MedAllDate-97762"]),4,"","","</tr>");  		//生产日期 
	htmlStr=htmlStr+initTableTdOne("停用日期："+$g(data["MedAllDate-97763"]),6,"","","<tr>");  			//停用日期
	htmlStr=htmlStr+initTableTdOne("植入日期："+$g(data["MedAllDate-97764"]),4,"","","</tr>");  		//植入日期
	htmlStr=htmlStr+initTableTr("事件发生初步原因分析","10","border-bottom:0px"); //事件发生初步原因分析
	htmlStr=htmlStr+initTableTr($g(data["MedEventInfomation-97800"]),"10","border-top:0px"); //事件发生初步原因分析
	htmlStr=htmlStr+initTableTr("事件初步处理情况","10","border-bottom:0px"); //事件初步处理情况
	htmlStr=htmlStr+initTableTr($g(data["MedEventInfomation-97802"]),"10","border-top:0px"); //事件初步处理情况
	htmlStr=htmlStr+initTableTr("事件报告状态："+getRadioValueById("MDNewEventReportStatue",data),"10","")	//事件报告状态
	htmlStr=htmlStr+initTableTr("不良事件评价","10","font-weight:bold;");			//不良事件评价
	htmlStr=htmlStr+initTableTr("省级监测技术机构评价意见","10","border-bottom:0px"); //省级监测技术机构评价意见
	htmlStr=htmlStr+initTableTr($g(data["MDProvincialEvaluationOpinion"]),"10","border-top:0px"); //省级监测技术机构评价意见
	htmlStr=htmlStr+initTableTr("国家监测技术机构评价意见","10","border-bottom:0px"); //国家监测技术机构评价意见
	htmlStr=htmlStr+initTableTr($g(data["MDCountryEvaluationOpinion"]),"10","border-top:0px"); //国家监测技术机构评价意见

	
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
	//printOrExportHtml()  // 调用打印或导出
	}
//输血不良事件打印
function printAdvBloodbyData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("输血不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),3,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),7,"","","","</tr>");  //上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			//患者基本信息
	
	htmlStr=htmlStr+initTableTr("患者来源："+getRadioValueById("PatOrigin",data),10,"");	//患者来源	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatNo"]),2,"","","<tr>");   	//登记号
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatNo"]),3,"","","<tr>");				//登记号
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");			//病案号
	htmlStr=htmlStr+initTableTdOne("住院次数："+$g(data["HospTimes"]),4,"","","</tr>");    //住院次数
	
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");  					//姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["MedNewRepPatAge"]),3,"","","");			//患者年龄
	htmlStr=htmlStr+initTableTdOne("民族："+$g(data["PatNational"]),4,"","","</tr>");					//民族
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),3,"","","<tr>");	//性别
	htmlStr=htmlStr+initTableTdOne("孕："+getRadioValueById("isPregnancy",data),3,"","","");//孕
	htmlStr=htmlStr+initTableTdOne("婚否："+getRadioValueById("isMarry",data),4,"","","</tr>");		//婚否
	htmlStr=htmlStr+initTableTdOne("产："+getRadioValueById("isGive",data),3,"","","<tr>");			//产
	htmlStr=htmlStr+initTableTdOne("主治医师："+$g(data["Physician"]),7,"","","</tr>");			//主治医师

	htmlStr=htmlStr+initTableTdOne("入院/门诊科室："+$g(data["InOrOutHospLoc"]),6,"","","<tr>");	//入院/门诊科室
	htmlStr=htmlStr+initTableTdOne("出院日期："+$g(data["LeavHospTime"]),4,"","","</tr>");				//出院日期
	htmlStr=htmlStr+initTableTdOne("入院/门诊日期："+$g(data["InOrOutHospDate"]),6,"","","<tr>");		//入院/门诊日期
	htmlStr=htmlStr+initTableTdOne("床位号："+$g(data["AdmBedNum"]),4,"","","</tr>");					//床位号
	
	htmlStr=htmlStr+initTableTdOne("年龄类型："+$g(data["AgeType"]),3,"","","<tr>");				//年龄类型
	htmlStr=htmlStr+initTableTdOne("病人职别："+$g(data["AdmOfficeRank"]),3,"","","");				//病人职别
	htmlStr=htmlStr+initTableTdOne("医疗类别："+$g(data["MedicalCategory"]),4,"","","</tr>");			//医疗类别
	htmlStr=htmlStr+initTableTdOne("血型(ABO)："+$g(data["BloodType"]),3,"","","<tr>");			//血型(ABO)
	
	htmlStr=htmlStr+initTableTdOne("Rh(D)："+$g(data["Rh(D)by"]),3,"","","");					//Rh(D)
	htmlStr=htmlStr+initTableTdOne("不规则抗体筛查："+$g(data["errAntibo"]),4,"","","</tr>");			//不规则抗体筛查
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["Disease"]),10,"");		//诊断
	
	htmlStr=htmlStr+initTableTr("输血列表","10","font-weight:bold;font-size:16px;");			//输血列表
	var SuspectNewDrugList=$g(data["BloodGiveList"]);  //输血列表
   	if(SuspectNewDrugList!=""){
   		htmlStr=htmlStr+initTableTd("献血编号或者条形码","血液成分(品名)","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("血型(ABO)","Rh(D)","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("血量(U/治疗量)","输血开始时间","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTdOne("输血结束时间",2,"","background-color:#808080","</tr>");	
	   	$(SuspectNewDrugList).each(function(index,obj){
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97703-97710"]),$g(obj["BloodGiveList-97701-97704-97711"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97705-97712"]),$g(obj["BloodGiveList-97701-97706-97713"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BloodGiveList-97701-97707-97714"]),$g(obj["BloodGiveList-97701-97708-97715"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTdOne($g(obj["BloodGiveList-97701-97709-97716"]),2,"","","</tr>");	

	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有输血列表","10","");
	   	
	   	}
	
  	htmlStr=htmlStr+initTableTr("事件基本信息","10","font-weight:bold;font-size:16px;");								//事件基本信息
	htmlStr=htmlStr+initTableTdOne("发生日期 ："+$g(data["HappenTime"]),3,"","","<tr>");				//发生日期 
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),7,"","","</tr>");				//上报所属科室
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),3,"","","<tr>");						//发生科室
	htmlStr=htmlStr+initTableTdOne("既往输血史："+getRadioValueById("BloodtransfusionHistory-label",data),7,"","","</tr>");				//既往输血史
	
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),3,"","","<tr>");							//上报人职称
	htmlStr=htmlStr+initTableTdOne("不良事件分级："+getRadioValueById("DruPOEventLevel",data),7,"","","</tr>");				//不良事件分级
	htmlStr=htmlStr+initTableTdOne("输血不良反应："+getRadioValueById("AdvBloodsereactions",data),3,"","","<tr>");			//输血不良反应
	htmlStr=htmlStr+initTableTdOne("输血不良反应时间："+$g(data["AdvBloodSereaOccTime"]),7,"","","</tr>");			  	//输血不良反应时间

	var BloodForTemperatureChange="输血前后体温变化情况：输血前：T(°C):"+$g(data["BloodForTemperatureChange-label-97460"])+",输血后：T(°C):"+$g(data["BloodForTemperatureChange-label-97461"]) 
	htmlStr=htmlStr+initTableTr(BloodForTemperatureChange,10,"");							//输血前后体温变化情况
	htmlStr=htmlStr+initTableTr("输血不良反应症状","10","border-bottom:0px"); //输血不良反应症状
	htmlStr=htmlStr+initTableTr(getRadioValueById("AdvBloodSymptom-label",data)+","+$g(data["AdvBloodSymptom"]),"10","border-top:0px"); //输血不良反应症状
	
	htmlStr=htmlStr+initTableTr("治疗措施及结果","10","border-bottom:0px"); //治疗措施及结果
	htmlStr=htmlStr+initTableTr($g(data["TreatmentPlan"]),"10","border-top:0px"); //治疗措施及结果

	htmlStr=htmlStr+initTableTr("其他","10","border-bottom:0px"); //其他
	htmlStr=htmlStr+initTableTr($g(data["Other"]),"10","border-top:0px"); //其他

	htmlStr=htmlStr+initTableTr("不良事件的等级："+getRadioValueById("EventRepLevel",data),10,"");   //不良事件的等级
	
	htmlStr=htmlStr+initTableTr("输血科（血库）处理反馈意见","10","font-weight:bold;font-size:16px;");  //输血科（血库）处理反馈意见
	htmlStr=htmlStr+initTableTr("复查供血者及患者ABO血型(正反定型)结果,供血者："+$g(data["BloodTypeResult-97617"])+",受血者"+$g(data["BloodTypeResult-97618"]),10,"");   //复查供血者及患者ABO血型(正反定型)结果
	htmlStr=htmlStr+initTableTr("复查供血者及患者RHD血型结果,供血者："+$g(data["BloodRHDTypeResult-97620"])+",受血者"+$g(data["BloodRHDTypeResult-97621"]),10,"");   //复查供血者及患者RHD血型结果
	htmlStr=htmlStr+initTableTr("不规则抗体筛查或直接抗人体血球试验结果,供血者："+$g(data["BloodIrregularResult-97623"])+",受血者"+$g(data["BloodIrregularResult-97624"]),10,"");   //不规则抗体筛查或直接抗人体血球试验结果
	htmlStr=htmlStr+initTableTr("重复交叉配血实验,方法："+$g(data["BloodRepeatRepeat-97628"])+",结果"+$g(data["BloodRepeatRepeat-97630"]),10,"");   //重复交叉配血实验	
	htmlStr=htmlStr+initTableTr("肉眼观察血液外观有无凝块，溶血现象等结果","10","border-bottom:0px"); //肉眼观察血液外观有无凝块，溶血现象等结果
	htmlStr=htmlStr+initTableTr($g(data["BloodAdviceResurt"]),"10","border-top:0px"); //肉眼观察血液外观有无凝块，溶血现象等结果
	htmlStr=htmlStr+initTableTr("其他","10","border-bottom:0px"); //其他
	htmlStr=htmlStr+initTableTr($g(data["BloodAdviceOther"]),"10","border-top:0px"); //其他
	
	htmlStr=htmlStr+initTableTr("血站处理反馈意见","10","font-weight:bold;font-size:16px;"); 				//血站处理反馈意见
	htmlStr=htmlStr+initTableTr("处理意见","10","border-bottom:0px"); //处理意见
	htmlStr=htmlStr+initTableTr($g(data["BloodWorkDealadviceDeil"]),"10","border-top:0px"); //处理意见
	htmlStr=htmlStr+initTableTdOne("填表时间："+$g(data["BloodCreateDate"]),6,"","","<tr>");				//填表时间
	htmlStr=htmlStr+initTableTdOne("填表人："+$g(data["BloodCreateCreator"]),4,"","","</tr>");				//填表人
	
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
	//printOrExportHtml()  // 调用打印或导出
	}

//药品不良事件打印
function printAdvdrugData(data){
	
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("药品不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),3,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),7,"","","","</tr>");  //上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			//患者基本信息
	htmlStr=htmlStr+initTableTr("患者来源："+getRadioValueById("PatOrigin",data),"10","");			//患者来源
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatNo"]),3,"","","<tr>");   	//登记号
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	//病案号

	htmlStr=htmlStr+initTableTdOne("民族："+$g(data["PatNational"]),4,"","","</tr>");	//民族

	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");  					//姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["MedNewRepPatAge"]),3,"","","");	//患者年龄
	
	htmlStr=htmlStr+initTableTdOne("出生日期："+$g(data["PatDOB"]),4,"","","</tr>");				//出生日期

	htmlStr=htmlStr+initTableTdOne("患者体重："+$g(data["PatWeight"]),3,"","","<tr>");				//患者体重
	htmlStr=htmlStr+initTableTdOne("电话："+$g(data["MedNewRepTel"]),3,"","","");				//电话
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//性别
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["Disease"]),"10","");	//诊断

	htmlStr=htmlStr+initTableTr("既往药品不良反应/事件："+getRadioValueById("EventNewHistory-label",data),"10","");	//既往药品不良反应/事件
	htmlStr=htmlStr+initTableTr("家族药品不良反应/事件："+getRadioValueById("EventNewFamily",data),"10","");				//家族药品不良反应/事件
	htmlStr=htmlStr+initTableTr("相关重要信息："+getRadioValueById("ImpInfoNewData",data),"10","");				//家族药品不良反应/事件

	//htmlStr=htmlStr+initTableTr("相关重要信息："+getRadioValueById("ImpInfoNewData",data),"10","");		//事件基本信息

	htmlStr=htmlStr+initTableTr("事件基本信息","10","font-weight:bold;font-size:16px;");		//事件基本信息

	htmlStr=htmlStr+initTableTdOne("首次/跟踪报告："+getRadioValueById("FirstOrAfterRep",data),3,"","","<tr>");	//首次/跟踪报告
	htmlStr=htmlStr+initTableTdOne("报告类型："+getRadioValueById("RepNewType",data),3,"","","");				//报告类型
	htmlStr=htmlStr+initTableTdOne("报告单位类别："+getRadioValueById("RepUnitType",data),4,"","","</tr>");	//报告单位类别


	var SuspectNewDrugList=$g(data["SuspectNewDrug"]);  //怀疑药品列表
	var BlendNewDrugList=$g(data["BlendNewDrug"]); 		 //并用药品列表 
   	if(SuspectNewDrugList!=""){
   		htmlStr=htmlStr+initTableTd("药品","批准文号","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("商品名称","通用名称","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("生产厂家","生产批号","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("用法用量","开始时间","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("结束时间","用药原因","0","0","background-color:#808080;width:10%;","background-color:#808080","</tr>");

	   	$(SuspectNewDrugList).each(function(index,obj){
		htmlStr=htmlStr+initTableTd("怀疑药品",$g(obj["SuspectNewDrug-96649"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96650"]),$g(obj["SuspectNewDrug-96651"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96652"]),$g(obj["SuspectNewDrug-96653"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96654"]),$g(obj["SuspectNewDrug-96655"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["SuspectNewDrug-96656"]),$g(obj["SuspectNewDrug-96657"]),"0","0","width:10%;","","</tr>");

	//var SuspectDrugList=""+"^"+$g(obj["SuspectNewDrug-96649"])+"^"+$g(obj["SuspectNewDrug-96650"])+"^"+$g(obj["SuspectNewDrug-96651"])+"^"+$g(obj["SuspectNewDrug-96652"])+"^"+$g(obj["SuspectNewDrug-96653"])+"^"+$g(obj["SuspectNewDrug-96654"])+"^"+$g(obj["SuspectNewDrug-96655"])+"^"+$g(obj["SuspectNewDrug-96656"])+"^"+$g(obj["SuspectNewDrug-96657"])
	//htmlStr=htmlStr+initTableTdmor(SuspectDrugList,"")
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有怀疑药品","10","");
	   	
	   	}
   	if(BlendNewDrugList!=""){
	   	htmlStr=htmlStr+initTableTd("药品","批准文号","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("商品名称","通用名称","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("生产厂家","生产批号","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("用法用量","开始时间","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("结束时间","用药原因","0","0","background-color:#808080;width:10%;","background-color:#808080","</tr>");

	   	$(BlendNewDrugList).each(function(index,obj){

		htmlStr=htmlStr+initTableTd("并用药品",$g(obj["BlendNewDrug-96674"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96675"]),$g(obj["BlendNewDrug-96676"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96677"]),$g(obj["BlendNewDrug-96678"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96679"]),$g(obj["BlendNewDrug-96681"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["BlendNewDrug-96683"]),$g(obj["BlendNewDrug-96685"]),"0","0","width:10%;","","</tr>");

	//var SuspectDrugList=""+"^"+$g(obj["SuspectNewDrug-96649"])+"^"+$g(obj["SuspectNewDrug-96650"])+"^"+$g(obj["SuspectNewDrug-96651"])+"^"+$g(obj["SuspectNewDrug-96652"])+"^"+$g(obj["SuspectNewDrug-96653"])+"^"+$g(obj["SuspectNewDrug-96654"])+"^"+$g(obj["SuspectNewDrug-96655"])+"^"+$g(obj["SuspectNewDrug-96656"])+"^"+$g(obj["SuspectNewDrug-96657"])
	//htmlStr=htmlStr+initTableTdmor(SuspectDrugList,"")
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有并用药品","10","");
	   	}
	htmlStr=htmlStr+initTableTr("不良反应/事件名称："+$g(data["AdvEventNewName"]),10,""); //不良反应事件名称
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),6,"","","<tr>"); //发生科室
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"]),4,"","","</tr>"); //发生日期
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),6,"","","<tr>"); //上报所属科室
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),4,"","","</tr>"); //上报人职称

	htmlStr=htmlStr+initTableTr("不良反应/事件过程描述（包括症状、体征、临床检验等）及处理情况（2000字以内）：","10","border-bottom:0px"); //过程描述
	htmlStr=htmlStr+initTableTr($g(data["incidentNew-label-center"]),"10","border-top:0px"); //过程描述
	var EventNewResult=getRadioValueById("EventNewResult-label",data);
	if(EventNewResult=="有后遗症"){
		EventNewResult=EventNewResult+"，表现（"+$g(data["EventNewResult-label-97002-97013"])+"）";
	}else if(EventNewResult=="死亡"){
		EventNewResult=EventNewResult+"，直接死因（"+$g(data["EventNewResult-label-97014-97015"])+"）"+"，死亡时间（"+$g(data["EventNewResult-label-97014-97016"])+"）";
	}
	
	htmlStr=htmlStr+initTableTr("不良反应/事件的结果："+EventNewResult,10,""); 						//不良反应/事件的结果
	htmlStr=htmlStr+initTableTr("停药或减量后，反应/事件是否消失或减轻："+getRadioValueById("EventStopNewResultt",data),10,""); 	//停药或减量后，反应/事件是否消失或减轻
	htmlStr=htmlStr+initTableTr("再次使用可疑药品后是否再次出现同样反应/事件："+getRadioValueById("EventTakingNewAgain",data),10,"");//再次使用可疑药品后是否再次出现同样反应/事件
	htmlStr=htmlStr+initTableTr("对原患疾病的影响："+getRadioValueById("EventEffectNewOfTreatment-label",data),10,""); 				//对原患疾病的影响
	htmlStr=htmlStr+initTableTr("不良事件等级："+getRadioValueById("EventRepLevel",data),"10",""); 	//不良事件等级
	
	
	htmlStr=htmlStr+initTableTr("关联性评价","10",""); 	//关联性评价
	htmlStr=htmlStr+initTableTdOne("报告人评价："+getRadioValueById("EventCommentNewUser",data),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("报告人签名："+$g(data["EventReportUser"]),4,"","","</tr>"); 	
	htmlStr=htmlStr+initTableTdOne("报告单位评价："+getRadioValueById("EventCommentNewDept",data),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("报告单位签名："+$g(data["EventDeptNewReport"]),4,"","","</tr>"); 

	htmlStr=htmlStr+initTableTr("报告人信息","10",""); 	//报告人信息
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["ReportNewUserMess-97050"]),6,"","","<tr>"); 	
	htmlStr=htmlStr+initTableTdOne("职业："+getRadioValueById("ReportNewUserMess-97140",data),4,"","","</tr>"); 	
	htmlStr=htmlStr+initTableTdOne("电子邮箱："+$g(data["ReportNewUserMess-97145"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("签名："+$g(data["ReportNewUserMess-97146"]),4,"","","</tr>"); 

	htmlStr=htmlStr+initTableTr("报告单位信息","10",""); 	//报告单位信息
	htmlStr=htmlStr+initTableTdOne("联系人："+$g(data["RepNewDeptMess-97151"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("单位名称："+$g(data["RepNewDeptMess-97150"]),4,"","","</tr>"); 
	htmlStr=htmlStr+initTableTdOne("电话："+$g(data["RepNewDeptMess-97153"]),6,"","","<tr>"); 
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["RepNewDeptMess-97155"]),4,"","","</tr>"); 


	htmlStr=htmlStr+initTableTr("生产企业请填写信息来源："+getRadioValueById("MDRInfoSourse",data),"10","")		//生产企业请填写信息来源
	htmlStr=htmlStr+initTableTr("备注："+$g(data["RepNewRemark"]),"10","")		//备注
	htmlStr=htmlStr+initTableTr("科室负责人："+$g(data["LocLeading"]),"10","")		//科室负责人
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
	//printOrExportHtml()  // 调用打印或导出
}
/// 医疗不良事件打印
function printAdvMedicalData (data){

	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("医疗不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 // 事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),3,"","","<tr>");			 // 上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),7,"","","","</tr>");  // 上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			// 患者基本信息
	
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatNo"]),3,"","","<tr>");   	// 登记号
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	// 病案号
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),4,"","","</tr>");  		// 姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","<tr>");		// 患者年龄	
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),3,"","","");		// 性别
	htmlStr=htmlStr+initTableTdOne("住院次数："+$g(data["HospTimes"]),4,"","","</tr>");			// 住院次数
	htmlStr=htmlStr+initTableTr("患者来源："+getRadioValueById("PatOrigin",data),10,"");	// 患者来源
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["Disease"]),10,"");				// 诊断
	
	htmlStr=htmlStr+initTableTdOne("主治医师："+$g(data["Physician"]),3,"","","<tr>");				// 主治医师
	htmlStr=htmlStr+initTableTdOne("入院/门诊科室："+$g(data["InOrOutHospLoc"]),7,"","","</tr>");	// 入院/门诊科室
	htmlStr=htmlStr+initTableTdOne("床位号："+$g(data["AdmBedNum"]),3,"","","<tr>");			// 床位号	
	htmlStr=htmlStr+initTableTdOne("入院/门诊日期："+$g(data["InOrOutHospLoc"]),7,"","","</tr>");	// 入院/门诊日期 (无)
	
	htmlStr=htmlStr+initTableTdOne("年龄类型："+$g(data["AgeType"]),3,"","","<tr>");				// 年龄类型
	htmlStr=htmlStr+initTableTdOne("病人职别："+$g(data["AdmOfficeRank"]),7,"","","</tr>");			// 病人职别
	htmlStr=htmlStr+initTableTdOne("医疗类别："+$g(data["MedicalCategory"]),3,"","","<tr>");		// 医疗类别	
	htmlStr=htmlStr+initTableTdOne("出院日期："+$g(data["LeavHospTime"]),7,"","","</tr>");		// 出院日期
	
	htmlStr=htmlStr+initTableTr("事件信息","10","font-weight:bold;font-size:16px;");							// 事件信息

	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["ReportTime"]),3,"","","<tr>");			// 发生日期
	htmlStr=htmlStr+initTableTdOne("发生时间："+$g(data["OccurTime"]),3,"","","");				// 发生时间
	htmlStr=htmlStr+initTableTdOne("日期类型："+$g(data["DateType"]),4,"","","</tr>");				// 日期类型	
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),6,"","","<tr>");				// 发生科室
	htmlStr=htmlStr+initTableTdOne("发生场所："+$g(data["HappenPlace-96400"]),4,"","","</tr>");	// 发生场所
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),6,"","","<tr>");		// 上报所属科室
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),4,"","","</tr>");	// 上报人职称
	htmlStr=htmlStr+initTableTr("提供何种服务时发生："+$g(data["RenderService"]),10,"");	// 提供何种服务时发生

	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px"); //事件经过
	htmlStr=htmlStr+initTableTr($g(data["EventProcessText"]),"10","border-top:0px"); //事件经过

	htmlStr=htmlStr+initTableTr("事件详情信息","10","font-weight:bold;font-size:16px;"); 
	
	//htmlStr=htmlStr+initTableTr("不良事件类别:"+getRadioById(15,"advMedicalReportType-label"),"10",""); 
	var radioStr=getRadioById(RepID,"advMedicalReportType-label");	
	if (radioStr != ""){
		var radioArray=radioStr.split("%");
		for(i=0;i<radioArray.length;i++) {
		  	var childRadioArr=radioArray[i].split("!");
		  	if(childRadioArr[0] == "治疗缺陷"){		  	
				var tmpValue = childRadioArr[1].replace(/\*/g,";");
				htmlStr=htmlStr+initTableTr(childRadioArr[0]+"："+tmpValue,"10",""); 
			}else{
				htmlStr=htmlStr+initTableTr(childRadioArr[0]+"："+childRadioArr[1],"10",""); 
			}	
		  			  	
	 	}
	}

	htmlStr=htmlStr+initTableTr("不良事件的等级："+getRadioValueById("EventRepLevel",data),"10","");	// 不良事件的等级
	htmlStr=htmlStr+initTableTr("原因分析","10","border-bottom:0px"); //原因分析
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); //原因分析
	htmlStr=htmlStr+initTableTr("整改措施","10","border-bottom:0px"); //整改措施
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); //整改措施
	htmlStr=htmlStr+initTableTr("科室负责人："+$g(data["LocLeading"]),"10","");		// 科室负责人
	
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
	//printOrExportHtml()  // 调用打印或导出

}

/// 医疗投诉、纠纷登记表（新）
function printAdvMedDisputeData(data){

	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("医疗投诉、纠纷登记表","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 // 事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),3,"","","<tr>");			 // 上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),7,"","","","</tr>");  // 上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			// 患者基本信息
	
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatNo"]),3,"","","<tr>");   	// 登记号
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["PatName"]),3,"","","");  		// 姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),4,"","","</tr>");		// 患者年龄	
	htmlStr=htmlStr+initTableTdOne("性别："+$g(data["PatSex"]),3,"","","<tr>");		// 性别
	htmlStr=htmlStr+initTableTdOne("患者住址："+$g(data["PatAddr"]),3,"","","");			// 住址
	
	htmlStr=htmlStr+initTableTdOne("联系方式："+$g(data["Contact"]),4,"","","</tr>");	// 联系方式
	htmlStr=htmlStr+initTableTdOne("身份证（患）："+$g(data["PatIDCard"]),3,"","","<tr>");			// 身份证（患）
	htmlStr=htmlStr+initTableTdOne("事发科室："+$g(data["OccuLoc"]),3,"","","");		// 事发科室
	htmlStr=htmlStr+initTableTdOne("事发时间："+$g(data["IncidenTime"]),4,"","","</tr>");	// 事发时间
	htmlStr=htmlStr+initTableTdOne("当事人："+$g(data["Party"]),3,"","","<tr>");		// 当事人
	
	htmlStr=htmlStr+initTableTdOne("家属姓名："+$g(data["MedFamName"]),3,"","","");		// 家属姓名
	htmlStr=htmlStr+initTableTdOne("家属性别："+$g(data["MedFamSex"]),4,"","","</tr>");			// 家属性别
	htmlStr=htmlStr+initTableTdOne("身份证（家属）："+$g(data["FamIDCard"]),6,"","","<tr>");	// 身份证（家属）
	htmlStr=htmlStr+initTableTdOne("投诉来源："+$g(data["ComplainSource"]),4,"","","</tr>");		// 投诉来源	
	htmlStr=htmlStr+initTableTdOne("与患者关系："+$g(data["PatRelation"]),3,"","","<tr>");		// 与患者关系
	htmlStr=htmlStr+initTableTdOne("其他："+$g(data["MedPatOthMes"]),7,"","","</tr>");		// 其他
	
	htmlStr=htmlStr+initTableTr("主要问题","10","border-bottom:0px"); //主要问题
	htmlStr=htmlStr+initTableTr($g(data["MainProblems"]),"10","border-top:0px"); //主要问题
	htmlStr=htmlStr+initTableTr("事发经过","10","border-bottom:0px"); //事发经过
	htmlStr=htmlStr+initTableTr($g(data["IncidentPass"]),"10","border-top:0px"); //事发经过


	htmlStr=htmlStr+initTableTr("事件详情信息","10","font-weight:bold;font-size:16px;");			// 事件详情信息

	htmlStr=htmlStr+initTableTr("科室处理意见及整改措施","10","border-bottom:0px"); // 科室处理意见及整改措施
	htmlStr=htmlStr+initTableTr($g(data["LocDealView"]),"10","border-top:0px"); // 科室处理意见及整改措施
	
	htmlStr=htmlStr+initTableTdOne("科室负责人："+$g(data["LocCharge"]),3,"","","<tr>");		// 科室负责人
	htmlStr=htmlStr+initTableTdOne("时间："+$g(data["LocDateTime"]),7,"","","</tr>");			// 时间
	
	htmlStr=htmlStr+initTableTr("和解","10","border-bottom:0px"); // 和解
	htmlStr=htmlStr+initTableTr($g(data["EventReconcile"]),"10","border-top:0px"); // 和解

	htmlStr=htmlStr+initTableTr("调解","10","border-bottom:0px"); // 调解
	htmlStr=htmlStr+initTableTr($g(data["EventMediate"]),"10","border-top:0px"); // 调解

	htmlStr=htmlStr+initTableTr("司法鉴定","10","border-bottom:0px"); // 司法鉴定
	htmlStr=htmlStr+initTableTr($g(data["ExpertTest"]),"10","border-top:0px"); // 司法鉴定
	
	htmlStr=htmlStr+initTableTr("一审","10","border-bottom:0px"); // 一审
	htmlStr=htmlStr+initTableTr($g(data["EventFirtInstance"]),"10","border-top:0px"); // 一审
	htmlStr=htmlStr+initTableTr("二审","10","border-bottom:0px"); // 二审
	htmlStr=htmlStr+initTableTr($g(data["EventSecInstance"]),"10","border-top:0px"); // 二审
	htmlStr=htmlStr+initTableTr("其他","10","border-bottom:0px"); // 其他
	htmlStr=htmlStr+initTableTr($g(data["EventOthInstance"]),"10","border-top:0px"); // 其他

	htmlStr=htmlStr+initTableTr("事件追踪及医务部处理意见","10","border-bottom:0px"); // 事件追踪及医务部处理意见
	htmlStr=htmlStr+initTableTr($g(data["EventTrack"]),"10","border-top:0px"); // 事件追踪及医务部处理意见
	htmlStr=htmlStr+initTableTdOne("医务部负责人："+$g(data["MedServiceCharge"]),6,"","","<tr>");	// 医务部负责人
	htmlStr=htmlStr+initTableTdOne("时间："+$g(data["MedServiceTime"]),4,"","","</tr>");			// 时间
	htmlStr=htmlStr+initTableTr("责任追究与处理结果","10","border-bottom:0px"); // 责任追究与处理结果
	htmlStr=htmlStr+initTableTr($g(data["Accountable"]),"10","border-top:0px"); // 责任追究与处理结果
	htmlStr=htmlStr+initTableTdOne("院领导签字："+$g(data["Leadership"]),6,"","","<tr>");			// 院领导签字
	htmlStr=htmlStr+initTableTdOne("时间："+$g(data["LeaderTime"]),4,"","","</tr>");				// 时间	
	
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
	//printOrExportHtml()  // 调用打印或导出
	
}



//院感不良事件
function printadvHosInfectData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("院感不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号："+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人："+$g(data["ReportPer"]),3,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间："+$g(data["ReportTime"]),7,"","","","</tr>");  //上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			//患者基本信息
	htmlStr=htmlStr+initTableTr("患者来源："+getRadioValueById("PatOrigin",data),"10","");			//患者来源
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["PatNo"]),3,"","","<tr>");   	//登记号
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	//病案号
	htmlStr=htmlStr+initTableTdOne("住院次数："+$g(data["HospTimes"]),4,"","","</tr>");	//住院次数
	
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");  					//姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["PatAge"]),3,"","","");	//患者年龄
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),4,"","","</tr>");	//性别
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["Disease"]),10,"");	//诊断

	htmlStr=htmlStr+initTableTdOne("入院/门诊科室："+$g(data["InOrOutHospLoc"]),6,"","","<tr>");				//入院/门诊科室
	htmlStr=htmlStr+initTableTdOne("主治医师："+$g(data["Physician"]),4,"","","</tr>");		//主治医师
	htmlStr=htmlStr+initTableTdOne("入院/门诊日期："+$g(data["InOrOutHospDate"]),6,"","","<tr>");	//入院/门诊日期
	htmlStr=htmlStr+initTableTdOne("出院日期："+$g(data["LeavHospTime"]),4,"","","</tr>");	//出院日期
	
	htmlStr=htmlStr+initTableTdOne("床位号："+$g(data["AdmBedNum"]),6,"","","<tr>");		//床位号
	htmlStr=htmlStr+initTableTdOne("年龄类型："+$g(data["AgeType"]),4,"","","</tr>");		//年龄类型
	htmlStr=htmlStr+initTableTdOne("病人职别："+$g(data["AdmOfficeRank"]),6,"","","<tr>");	//病人职别
	htmlStr=htmlStr+initTableTdOne("医疗类别："+$g(data["MedicalCategory"]),4,"","","</tr>");	//医疗类别
	
	htmlStr=htmlStr+initTableTr("事件信息","10","font-weight:bold;font-size:16px;");	//事件信息
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),3,"","","<tr>");   	//发生日期
	htmlStr=htmlStr+initTableTdOne("日期类型："+$g(data["DateType"]),3,"","","");	//日期类型
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),4,"","","</tr>");	//发生科室
	htmlStr=htmlStr+initTableTdOne("发生场所："+getRadioValueById("HappenPlace",data),3,"","","<tr>");   	//发生场所
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),3,"","","");	//上报人职称
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),4,"","","</tr>");	//上报所属科室
	htmlStr=htmlStr+initTableTr("提供何种服务时发生："+$g(data["RenderService"]),"10","");	//事件信息
	htmlStr=htmlStr+initTableTr("事件经过","10","border-bottom:0px"); // 事件经过
	htmlStr=htmlStr+initTableTr($g(data["EventProcessText"]),"10","border-top:0px"); // 事件经过
	htmlStr=htmlStr+initTableTr("事件详情信息","10","font-weight:bold;font-size:16px;");	//事件详情信息
	htmlStr=htmlStr+initTableTr("不良事件类别："+getRadioValueById("HosInfReportType-97149",data),10,"");   	//不良事件类别
	htmlStr=htmlStr+initTableTr("不良事件的等级："+getRadioValueById("EventRepLevel",data),10,"");   //不良事件的等级
	htmlStr=htmlStr+initTableTr("原因分析","10","border-bottom:0px"); // 原因分析
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); // 原因分析
	htmlStr=htmlStr+initTableTr("整改措施","10","border-bottom:0px"); // 整改措施
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); // 整改措施
	htmlStr=htmlStr+initTableTr("科室负责人："+$g(data["LocLeading"]),10,"");   //科室负责人
	 
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
	//printOrExportHtml()  // 调用打印或导出
}

//职业暴露不良事件报告单
function printadvOccExposeData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("职业暴露不良事件报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号："+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人："+$g(data["ReportPer"]),3,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间："+$g(data["ReportTime"]),7,"","","","</tr>");  //上报时间
	
	htmlStr=htmlStr+initTableTr("暴露者情况","10","font-weight:bold;font-size:16px;");	//暴露者情况
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");		//姓名
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("PatSexRadio",data),3,"","","");		//性别
	htmlStr=htmlStr+initTableTdOne("暴露者年龄："+$g(data["OccExpAge"]),4,"","","</tr>");	//暴露者年龄
	htmlStr=htmlStr+initTableTdOne("电话："+$g(data["MedNewRepTel"]),3,"","","<tr>");	//电话
	htmlStr=htmlStr+initTableTdOne("职称："+$g(data["JobTitle"]),3,"","","");		//职称
	htmlStr=htmlStr+initTableTdOne("参加工作时间："+$g(data["StartWorkDate"]),4,"","","</tr>");		//参加工作时间
	htmlStr=htmlStr+initTableTdOne("既往健康状况："+$g(data["HistoryHealth"]),3,"","","<tr>");	//既往健康状况
	htmlStr=htmlStr+initTableTdOne("岗位类别："+getRadioValueById("PostCategory",data),3,"","","");	//岗位类别
	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["HappenTime"])+" "+$g(data["OccurTime"]),4,"","","</tr>");		//发生日期
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),3,"","","<tr>");		//发生科室
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["ReportLitigand"]),3,"","","");	//上报人职称
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),4,"","","</tr>");	//上报所属科室

	htmlStr=htmlStr+initTableTdOne("暴露部位："+$g(data["ExposePart"]),3,"","","<tr>");     	 //暴露部位
	var OccuExpVaccination=getRadioValueById("OccuExpVaccination",data);
	if (OccuExpVaccination=="是"){
		OccuExpVaccination=OccuExpVaccination+"，疫苗名称（"+$g(data["OccuExpVaccineName"])+"）" ;
	}
	htmlStr=htmlStr+initTableTdOne("预防接种："+OccuExpVaccination,3,"","","");			 //预防接种
	htmlStr=htmlStr+initTableTdOne("暴露次数：第"+$g(data["ExposeTimes-96608"])+"次（从事本专业后）",4,"","","","</tr>");  //暴露次数

	htmlStr=htmlStr+initTableTdOne("暴露地点："+getRadioValueById("ExposePlace",data),3,"","","<tr>");     	 //暴露地点
	htmlStr=htmlStr+initTableTdOne("暴露方式："+getRadioValueById("ExposeMode",data),3,"","","");			 //暴露方式
	htmlStr=htmlStr+initTableTdOne("锐器名称："+getRadioValueById("SharpWeapon",data),4,"","","","</tr>");  //锐器名称
	htmlStr=htmlStr+initTableTdOne("损伤程度："+getRadioValueById("DegreeOfInjury",data),6,"","","<tr>");     	 //损伤程度
	htmlStr=htmlStr+initTableTdOne("损伤环节："+getRadioValueById("InjuryLink",data),4,"","","</tr>");			 //损伤环节
	htmlStr=htmlStr+initTableTr("暴露后局部处理情况："+getRadioValueById("OccExpLocalTreatment",data),10,"");  //暴露后局部处理情况
	htmlStr=htmlStr+initTableTr("职业暴露经过","10","border-bottom:0px"); // 职业暴露经过
	htmlStr=htmlStr+initTableTr($g(data["OccExposeCourse"]),"10","border-top:0px"); // 职业暴露经过
	htmlStr=htmlStr+initTableTr("不良事件的等级："+getRadioValueById("EventRepLevel",data) ,10,"");   //不良事件的等级
	
	htmlStr=htmlStr+initTableTr("暴露源基本情况","10","font-weight:bold;font-size:16px;");	//暴露源基本情况
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["ExpSName"]),3,"","","<tr>");		//姓名
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");		//病案号
	htmlStr=htmlStr+initTableTdOne("性别："+getRadioValueById("ExpSSexRadio",data),4,"","","</tr>");		//性别
	htmlStr=htmlStr+initTableTdOne("年龄："+$g(data["ExpSAge"]),3,"","","<tr>");		//年龄
	htmlStr=htmlStr+initTableTdOne("是否住院："+getRadioValueById("ExpSInHospital",data),7,"","","</tr>");		//是否住院
	htmlStr=htmlStr+initTableTr("暴露源感染情况："+getRadioValueById("ExpSInfectInfo",data),"10","");	//暴露源感染情况
	htmlStr=htmlStr+initTableTr("暴露源入院诊断","10","border-bottom:0px"); // 暴露源入院诊断
	htmlStr=htmlStr+initTableTr($g(data["ExpSAdmDiagnosis"]),"10","border-top:0px"); // 暴露源入院诊断
	
	htmlStr=htmlStr+initTableTr("暴露者随访","10","font-weight:bold;font-size:16px;");	//暴露者随访
	
	htmlStr=htmlStr+initTableTd("主要化验指标","表面抗原","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd("表面抗体","e抗原","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("e抗体","核心抗体","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("HCV","HIV","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
	htmlStr=htmlStr+initTableTd("TP","其他","0","0","background-color:#808080;width:10%;","background-color:#808080;","</tr>");

	htmlStr=htmlStr+initTableTd("基线",$g(data["ExposerFlup-97053-97521-97531"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97523-97532"]),$g(data["ExposerFlup-97053-97524-97533"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97525-97534"]),$g(data["ExposerFlup-97053-97526-97535"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97527-97536"]),$g(data["ExposerFlup-97053-97528-97537"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97053-97529-97540"]),$g(data["ExposerFlup-97053-97530-97542"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("1个月",$g(data["ExposerFlup-97552-97559-97569"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97560-97570"]),$g(data["ExposerFlup-97552-97561-97571"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97562-97572"]),$g(data["ExposerFlup-97552-97563-97573"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97564-97574"]),$g(data["ExposerFlup-97552-97565-97575"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97552-97566-97576"]),$g(data["ExposerFlup-97552-97684-97685"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("3个月",$g(data["ExposerFlup-97553-97578-97607"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97579-97608"]),$g(data["ExposerFlup-97553-97580-97611"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97581-97612"]),$g(data["ExposerFlup-97553-97583-97613"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97584-97614"]),$g(data["ExposerFlup-97553-97585-97615"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97553-97586-97616"]),$g(data["ExposerFlup-97553-97686-97687"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("6个月",$g(data["ExposerFlup-97554-97588-97627"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97589-97631"]),$g(data["ExposerFlup-97554-97590-97632"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97591-97633"]),$g(data["ExposerFlup-97554-97592-97634"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97593-97636"]),$g(data["ExposerFlup-97554-97594-97637"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97554-97595-97638"]),$g(data["ExposerFlup-97554-97688-97689"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("9个月",$g(data["ExposerFlup-97555-97597-97642"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97598-97643"]),$g(data["ExposerFlup-97555-97599-97644"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97600-97645"]),$g(data["ExposerFlup-97555-97601-97646"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97603-97647"]),$g(data["ExposerFlup-97555-97604-97648"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97555-97605-97649"]),$g(data["ExposerFlup-97555-97690-97691"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTd("1年",$g(data["ExposerFlup-97652-97656-97668"]),"0","0","width:10%;","width:10%;","<tr>");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97657-97672"]),$g(data["ExposerFlup-97652-97659-97673"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97660-97674"]),$g(data["ExposerFlup-97652-97661-97675"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97662-97676"]),$g(data["ExposerFlup-97652-97663-97677"]),"0","0","width:10%;","width:10%;","");
	htmlStr=htmlStr+initTableTd($g(data["ExposerFlup-97652-97664-97678"]),$g(data["ExposerFlup-97652-97665-97679"]),"0","0","width:10%;","","</tr>");

	htmlStr=htmlStr+initTableTr("暴露后用药情况","10","border-bottom:0px"); // 暴露后用药情况
	htmlStr=htmlStr+initTableTr($g(data["OccExpDrugInfo"]),"10","border-top:0px"); // 暴露后用药情况
	htmlStr=htmlStr+initTableTr("原因分析","10","border-bottom:0px"); // 原因分析
	htmlStr=htmlStr+initTableTr($g(data["ReportReason"]),"10","border-top:0px"); // 原因分析
	htmlStr=htmlStr+initTableTr("整改措施","10","border-bottom:0px"); // 整改措施
	htmlStr=htmlStr+initTableTr($g(data["Measure"]),"10","border-top:0px"); // 整改措施
	
	htmlStr=htmlStr+initTableTr("科室负责人："+$g(data["LocLeading"]) ,10,"");   //科室负责人

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
	//printOrExportHtml()  // 调用打印或导出
}

//非计划再次手术报告单
function printadvNonPlanRepaData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("非计划再次手术报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("患者资料","10","font-weight:bold;font-size:16px;");	//患者资料
	htmlStr=htmlStr+initTableTdOne("科室："+$g(data["NonPlanRepaLoc"]),3,"","","<tr>");		//科室
	htmlStr=htmlStr+initTableTdOne("床号："+$g(data["NonPlanRepaBedCode"]),3,"","","");		//床号
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["NonPlanRepaRepDate"]),4,"","","</tr>");	//报告日期
	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["NonPlanRepaPatName"]),3,"","","<tr>");		//姓名
	htmlStr=htmlStr+initTableTdOne("性别："+$g(data["NonPlanRepaPatSex"]),7,"","","</tr>");		//性别
	htmlStr=htmlStr+initTableTdOne("年龄："+$g(data["NonPlanRepaPatAge"]),3,"","","<tr>");	//年龄
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["NonPlanRepaPatID"]),7,"","","</tr>");	//登记号
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["NonPlanRepaDiag"]) ,10,"");   //诊断
	
	htmlStr=htmlStr+initTableTr("事件发生情况","10","font-weight:bold;font-size:16px;");							// 事件发生情况

	htmlStr=htmlStr+initTableTdOne("原手术名称："+$g(data["NonPlanRepTheOperName"]),3,"","","<tr>");			// 原手术名称
	htmlStr=htmlStr+initTableTdOne("原手术日期："+$g(data["NonPlanRepaTheOperDate"]),3,"","","");				// 原手术日期
	htmlStr=htmlStr+initTableTdOne("原手术主刀医师："+$g(data["NonPlanRepaTheBthDoc"]),4,"","","</tr>");				// 原手术主刀医师
	htmlStr=htmlStr+initTableTdOne("职称："+$g(data["NonPlanRepaTheDocTitle"]),3,"","","<tr>");				// 职称
	htmlStr=htmlStr+initTableTdOne("是否急诊手术："+$g(data["NonPlanRepaIfEmOper"]),3,"","","");			// 是否急诊手术
	htmlStr=htmlStr+initTableTdOne("手术级别："+$g(data["NonPlanRepaOperLev"]),4,"","","</tr>");				// 手术级别
	htmlStr=htmlStr+initTableTdOne("手术出血量（ml）："+$g(data["NonPlanRepaBldQty"]),3,"","","<tr>");				// 手术出血量（ml）
	htmlStr=htmlStr+initTableTdOne("手术时长（min）："+$g(data["NonPlanRepaOperDurTime"]),3,"","","");				// 手术时长（min）
	htmlStr=htmlStr+initTableTdOne("是否危重患者："+$g(data["NonPlanRepaIfUrgPat"]),4,"","","</tr>");			// 是否危重患者
	htmlStr=htmlStr+initTableTdOne("是否合并并发症："+$g(data["NonPlanRepaIfComDis"]),3,"","","<tr>");				// 是否合并并发症
	htmlStr=htmlStr+initTableTdOne("再次手术名称："+$g(data["NonPlanRepAgainOperName"]),3,"","","");				// 再次手术名称
	htmlStr=htmlStr+initTableTdOne("拟手术日期："+$g(data["NonPlanRepaAgainOperDate"]),4,"","","</tr>");				// 拟手术日期
	htmlStr=htmlStr+initTableTdOne("职称："+$g(data["NonPlanRepaAgainDocTitle"]),3,"","","<tr>");				// 职称
	htmlStr=htmlStr+initTableTdOne("再次手术级别："+$g(data["NonPlanRepaAgainOperLev"]),3,"","","");				// 再次手术级别
	htmlStr=htmlStr+initTableTdOne("再次手术主刀医师："+$g(data["NonPlanRepaAgainBthDoc"]),4,"","","</tr>");			// 再次手术主刀医师 
	
	htmlStr=htmlStr+initTableTr("需再次手术原因","10",""); 	//需再次手术原因
	htmlStr=htmlStr+initTableTdOne("术后出血："+getRadioValueById("NonPlanRepaAgainOperRes-702",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("术后植入管堵塞："+getRadioValueById("NonPlanRepaAgainOperRes-705",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("术后梗阻："+getRadioValueById("NonPlanRepaAgainOperRes-708",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("术后感染："+getRadioValueById("NonPlanRepaAgainOperRes-711",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("术后病理升级："+getRadioValueById("NonPlanRepaAgainOperRes-714",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("吻合口瘘："+getRadioValueById("NonPlanRepaAgainOperRes-717",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("术口脂肪液化："+getRadioValueById("NonPlanRepaAgainOperRes-720",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("术后血栓生成："+getRadioValueById("NonPlanRepaAgainOperRes-723",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("术后裂开："+getRadioValueById("NonPlanRepaAgainOperRes-726",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("不遵医嘱："+getRadioValueById("NonPlanRepaAgainOperRes-729",data),3,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("特殊体质："+getRadioValueById("NonPlanRepaAgainOperRes-732",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("上次手术疗效欠佳："+getRadioValueById("NonPlanRepaAgainOperRes-735",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("其他："+$g(data["NonPlanRepaAgainOperRes-738"]) ,10,"");   //其他需再次手术原因
	htmlStr=htmlStr+initTableTr("再次手术目的："+$g(data["NonPlanRepaOperGoal"]) ,10,"");   //再次手术目的
	
	htmlStr=htmlStr+initTableTr("再次手术准备情况","10",""); 	//再次手术准备情况
	htmlStr=htmlStr+initTableTdOne("是否报告上级并查房："+getRadioValueById("NonPlanRepaOperReadiness-742",data),6,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("是否组织科内讨论："+getRadioValueById("NonPlanRepaOperReadiness-745",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTdOne("是否有充分的术前准备："+getRadioValueById("NonPlanRepaOperReadiness-748",data),6,"","","<tr>");  
	htmlStr=htmlStr+initTableTdOne("是否有风险处置预案："+getRadioValueById("NonPlanRepaOperReadiness-751",data),4,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("是否做好患者家属知情告知："+getRadioValueById("NonPlanRepaOperReadiness-754",data),10,"");  
	htmlStr=htmlStr+initTableTr("医疗安全（不良）事件类别："+getRadioValueById("MedAdvEventLev",data) ,10,"");   //医疗安全（不良）事件类别
	htmlStr=htmlStr+initTableTr("给患者造成损害的轻重程度："+getRadioValueById("MedAdvInjuryLevByType",data) ,10,"");   //给患者造成损害的轻重程度
	
	
	htmlStr=htmlStr+initTableTdOne("科主任审核："+$g(data["NonPlanRepaDirectorAudit"]),3,"","","<tr>");	// 科主任审核
	htmlStr=htmlStr+initTableTdOne("预后（好转/未愈/死亡）："+$g(data["NonPlanRepaBetterProg"]),7,"","","</tr>");		// 预后（好转/未愈/死亡）
	htmlStr=htmlStr+initTableTdOne("报告医生签名："+$g(data["NonPlanRepaRepDocSign"]),6,"","","<tr>");	// 报告医生签名
	htmlStr=htmlStr+initTableTdOne("上报人职称："+$g(data["NonPlanRepaRepTitle"]),4,"","","</tr>");		// 上报人职称
	
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
	//printOrExportHtml()  // 调用打印或导出
}

//输液反应专项报告单
function printadvTransRctData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("输液反应专项报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("科室："+$g(data["TransRctLoc"]),6,"","","<tr>");     	 //科室
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["TransRctRepDate"]),4,"","","","</tr>");  //报告日期
	
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["TransRctPatName"]),6,"","","<tr>");			 //患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["TransRctRegNo"]),4,"","","","</tr>");  //登记号

	htmlStr=htmlStr+initTableTr("一、基本情况","10","font-weight:bold;font-size:16px;");	//患者资料
	htmlStr=htmlStr+initTableTr("1、液体输注时间："+$g(data["TransRctLiqInfuTime-94124"])+"时"+$g(data["TransRctLiqInfuTime-94126"])+"分",10,"");		//液体输注时间
	htmlStr=htmlStr+initTableTr("2、出现不适时间："+$g(data["TransRctDicTime-94177"])+"时"+$g(data["TransRctDicTime-94179"])+"分",10,"");		//出现不适时间
	var TransRctVitalSign="", SignT=$g(data["TransRctVitalSign-94131-94132"]),SignP=$g(data["TransRctVitalSign-94134-94135"]),SignR=$g(data["TransRctVitalSign-94137-94138"]),SignBp=$g(data["TransRctVitalSign-94140-94141"]),SignBpd=$g(data["TransRctVitalSign-94140-94142"]);
	if(SignT!=""){
		TransRctVitalSign=TransRctVitalSign+"T："+SignT+"℃；";
	}
	if(SignP!=""){
		TransRctVitalSign=TransRctVitalSign+"P："+SignP+"次/分；";
	}
	if(SignR!=""){
		TransRctVitalSign=TransRctVitalSign+"R："+SignR+"次/分；";
	}
	if(SignBp!=""){
		TransRctVitalSign=TransRctVitalSign+"Bp："+SignBp+"/"+SignBpd+"mmHg；";
	}
	
	htmlStr=htmlStr+initTableTdOne("3、生命体征："+TransRctVitalSign,10,"");		//生命体征
	
	
	htmlStr=htmlStr+initTableTdOne("4、患者的临床表现：",3,"","","<tr>");		//患者的临床表现
	htmlStr=htmlStr+initTableTdOne("皮疹："+getRadioValueById("TransRctCliniMan-94148",data)+getRadioValueById("TransRctCliniMan-94148-94150",data),3,"","","");  
	htmlStr=htmlStr+initTableTdOne("寒战："+getRadioValueById("TransRctCliniMan-94145",data),2,"","","");		
	htmlStr=htmlStr+initTableTdOne("呼吸困难："+getRadioValueById("TransRctCliniMan-94154",data),2,"","","</tr>");  
	htmlStr=htmlStr+initTableTr("5、其他表现："+$g(data["TransRctOtherPer"]) ,10,"");   //其他表现
	htmlStr=htmlStr+initTableTdOne("6、处理："+getRadioValueById("TransRctDispose",data),3,"","","<tr>");		//处理
	htmlStr=htmlStr+initTableTdOne("处理后患者于"+$g(data["TransRctDispose-94165-94167"])+"时"+$g(data["TransRctDispose-94165-94168"])+"分症状缓解",7,"","","</tr>");		

	htmlStr=htmlStr+initTableTr("二、液体配制过程","10","font-weight:bold;font-size:16px;");							// 二、液体配制过程
	var TransRctDrugInfo=$g(data["TransRctDrugInfo"]);  //药品信息列表
	var TransRctSyRinge=$g(data["TransRctSyRinge"]); 		 //一次性用品列表
   	if(TransRctDrugInfo!=""){
   		htmlStr=htmlStr+initTableTdOne("药物通用名称(含剂型)","2","","background-color:#808080;width:20%;","<tr>");
		htmlStr=htmlStr+initTableTdOne("用法用量(剂量、途径、日次数)","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("生产厂家","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("生产批号","2","","background-color:#808080;width:20%;","");
		htmlStr=htmlStr+initTableTdOne("有效期至","2","","background-color:#808080","</tr>");

	   	$(TransRctDrugInfo).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94182"]),"2","","width:20%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94183"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94184"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94185"]),"2","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["TransRctDrugInfo-94186"]),"2","","","</tr>");
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有药品信息","10","");
	   	
	}
	//一次性用品列表
	htmlStr=htmlStr+initTableTdOne("一次性用品","2","","background-color:#808080;width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne("型号","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("生产厂家","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("生产批号","2","","background-color:#808080;width:20%;","");
	htmlStr=htmlStr+initTableTdOne("有效期至","2","","background-color:#808080","</tr>");

	htmlStr=htmlStr+initTableTdOne("输液器","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94197"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94198"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94199"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94194-94200"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTdOne("穿刺针","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94203"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94204"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94205"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94201-94206"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTdOne("注射器","2","","width:20%;","<tr>");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94209"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94210"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94211"]),"2","","width:20%;","");
	htmlStr=htmlStr+initTableTdOne($g(data["TransRctSyRinge-94207-94212"]),"2","","","</tr>");

	htmlStr=htmlStr+initTableTr("三、液体输注过程","10","font-weight:bold;font-size:16px;");							// 三、液体输注过程
	htmlStr=htmlStr+initTableTr("1、输液方式："+getRadioValueById("TransRctFluids",data),10,"");			// 输液方式
	htmlStr=htmlStr+initTableTdOne("2、穿刺日期："+$g(data["TransRctPunDate"]),6,"","","<tr>");				// 穿刺日期
	htmlStr=htmlStr+initTableTdOne("穿刺部位："+$g(data["TransRctPuncture"]),4,"","","</tr>");				// 穿刺部位
	htmlStr=htmlStr+initTableTdOne("3、液体配置："+$g(data["TransRctLiqConfig1"])+"分钟后输入",3,"","","<tr>");				// 原手术日期
	htmlStr=htmlStr+initTableTdOne("此组输液已输入液体(ml)："+$g(data["TransRctLiqConfig2"]),3,"","","");				// 此组输液已输入液体
	htmlStr=htmlStr+initTableTdOne("输液速度(滴/分)："+$g(data["TransRctLiqConfig3"]),4,"","","</tr>");				// 输液速度

	htmlStr=htmlStr+initTableTr("四、物品处置","10","font-weight:bold;font-size:16px;");							// 四、物品处置
	htmlStr=htmlStr+initTableTdOne("1、物品封存："+getRadioValueById("TransRctGoodStor",data),6,"","","<tr>");				// 物品封存
	htmlStr=htmlStr+initTableTdOne("冷藏保存："+getRadioValueById("TransRctColdStor",data),4,"","","</tr>");				// 冷藏保存
	htmlStr=htmlStr+initTableTdOne("2、药液培养送检部门："+getRadioValueById("TransRctLiqMedDep",data),6,"","","<tr>");				// 药液培养送检部门
	htmlStr=htmlStr+initTableTdOne("时间："+$g(data["TransRctMedDepDate"]),4,"","","</tr>");				// 时间
	htmlStr=htmlStr+initTableTdOne("2、导管尖端培养送检部门："+getRadioValueById("TransRctCatheterDep",data),6,"","","<tr>");				// 导管尖端培养送检部门
	htmlStr=htmlStr+initTableTdOne("时间："+$g(data["TransRctCatheterDate"]),4,"","","</tr>");				// 时间
	htmlStr=htmlStr+initTableTdOne("配药护士："+$g(data["TransRctDispenNurse"]),3,"","","<tr>");				// 配药护士
	htmlStr=htmlStr+initTableTdOne("穿刺/接液体护士："+$g(data["TransRctNeedleNurse"]),7,"","","</tr>");				// 穿刺/接液体护士

	htmlStr=htmlStr+initTableTr("不良事件发生后处理方法(护士长填写)："+getRadioValueById("OccurAfterDealMethod",data) ,10,"");   // 不良事件发生后处理方法(护士长填写)
	htmlStr=htmlStr+initTableTdOne("科室是否发生过类似的事件："+getRadioValueById("DeptIfOccSimEvent",data),6,"","","<tr>");				// 科室是否发生过类似的事件
	htmlStr=htmlStr+initTableTdOne("本年度（次）："+$g(data["DeptIfOccSimEvent-94119-94120"]),4,"","","</tr>");				// 本年度（次）
	
	htmlStr=htmlStr+initTableTr("科室讨论分析、整改措施及处理意见(护士长填写)",10,""); 	//再次手术准备情况
	var ReasonStr=getRadioById(RepID,"NurReasonCase");
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var NurReasonCase="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("：")==-1){
				if(ReasonArr[1]!=""){
			 		NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0]+"："+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("原因分析："+NurReasonCase,10,"");				// 原因分析
	var NurCorrectAction=radioValue("NurCorrectAction-296,NurCorrectAction-297,NurCorrectAction-298,NurCorrectAction-299,NurCorrectAction-300,NurCorrectAction-302",data);
	if(radioValue("NurCorrectAction-301",data)!=""){
		NurCorrectAction=NurCorrectAction+"；修订制度/流程/职责等："+radioValue("NurCorrectAction-301",data)
	}
	htmlStr=htmlStr+initTableTr("整改措施："+NurCorrectAction,10,"");   // 整改措施
	var NurDisposition=radioValue("NurDisposition-306,NurDisposition-307,NurDisposition-309",data);
	if(radioValue("NurDisposition-308",data)!=""){
		NurDisposition=NurDisposition+"；当事人及相关人员违反制度/流程/职责，予扣罚："+radioValue("NurDisposition-308",data)
	}
	htmlStr=htmlStr+initTableTr("处理意见："+NurDisposition,10,"");   // 处理意见
	htmlStr=htmlStr+initTableTdOne("护士长签名："+$g(data["NurHeadNurse"]),6,"","","<tr>");				// 护士长签名
	htmlStr=htmlStr+initTableTdOne("签名日期："+$g(data["NurSignDate"]),4,"","","</tr>");				// 签名日期
	
	htmlStr=htmlStr+initTableTr("患者安全管理小组调研结果及指导意见",10,""); 	//患者安全管理小组调研结果及指导意见
	htmlStr=htmlStr+initTableTr("1.调研情况："+getRadioValueById("PatSafeGroupResult-label-603",data),10,"");				// 1.调研情况
	htmlStr=htmlStr+initTableTr("2.科室处理意见："+getRadioValueById("PatSafeGroupResult-label-606",data) ,10,"");   // 2.科室处理意见
	htmlStr=htmlStr+initTableTr("3.其他："+$g(data["PatSafeGroupResult-label-609"]) ,10,"");   // 3.其他
	htmlStr=htmlStr+initTableTdOne("护理安全小组查阅人："+$g(data["NurTeamReferPerson"]),6,"","","<tr>");				// 护理安全小组查阅人
	htmlStr=htmlStr+initTableTdOne("查阅日期："+$g(data["ReferDate"]),4,"","","</tr>");				// 查阅日期
	
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
	//printOrExportHtml()  // 调用打印或导出
}

//药物外渗专项报告单
function printadvDrugExosData(data){
	var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("药物外渗专项报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTdOne("发生时间："+$g(data["DrugExosOccurDate"])+" "+$g(data["OccurTime"]),3,"","","<tr>");     	 // 发生时间
	htmlStr=htmlStr+initTableTdOne("审核者姓名："+$g(data["DrugExosRepAuditName"]),7,"","","","</tr>");  // 审核者姓名
	htmlStr=htmlStr+initTableTdOne("患者姓名："+$g(data["DrugExosPatName"]),3,"","","<tr>");			 // 患者姓名
	htmlStr=htmlStr+initTableTdOne("登记号："+$g(data["DrugExosPatID"]),7,"","","","</tr>");  // 登记号
	htmlStr=htmlStr+initTableTr("一、评估项目","10","font-weight:bold;font-size:16px;");	// 一、评估项目
	htmlStr=htmlStr+initTableTr("引起外渗的药物："+getRadioValueById("DrugExosCauseByDrug",data),10,"");		// 引起外渗的药物
	var DrugExosStimInt="",fpxint=$g(data["DrugExosStimInt-846-851"]),cjxint=$g(data["DrugExosStimInt-847-854"]),ffpxint=$g(data["DrugExosStimInt-848-857"]),othint=$g(data["DrugExosStimInt-849-860"]);
	if(fpxint!=""){
		DrugExosStimInt=DrugExosStimInt+"发泡性(药物名称 "+fpxint+");"
	}
	if(cjxint!=""){
		DrugExosStimInt=DrugExosStimInt+"刺激性(药物名称 "+cjxint+");"
	}
	if(ffpxint!=""){
		DrugExosStimInt=DrugExosStimInt+"非发泡性(药物名称 "+ffpxint+");"
	}
	if(othint!=""){
		DrugExosStimInt=DrugExosStimInt+"其它(药物名称 "+othint+");"
	}
	
	htmlStr=htmlStr+initTableTr("刺激强度："+DrugExosStimInt,10,"");		// 刺激强度
	htmlStr=htmlStr+initTableTdOne("给药途径",1,3,"","<tr>"); 	// 给药途径
	htmlStr=htmlStr+initTableTdOne("穿刺部位："+getRadioValueById("DrugExosDeliWay-863",data),9,"","","</tr>");				// 穿刺部位
	htmlStr=htmlStr+initTableTdOne("经外周静脉："+getRadioValueById("DrugExosDeliWay-870",data),9,"","","</tr>");				// 经外周静脉
	htmlStr=htmlStr+initTableTdOne("经中心静脉通路："+getRadioValueById("DrugExosDeliWay-873",data),9,"","","</tr>");				// 经中心静脉通路

	htmlStr=htmlStr+initTableTdOne("穿刺部位药物外渗情况",1,3,"","<tr>"); 	// 穿刺部位药物外渗情况
	var hzPuncExos="",ttPuncExos="",kyPuncExos="";
	if(getRadioValueById("DrugExosPuncExos-882",data)=="有"){
		hzPuncExos="，范围"+$g(data["DrugExosPuncExos-882-884-886"])+"×"+$g(data["DrugExosPuncExos-882-884-900"])+"cm2";
	}
	if(getRadioValueById("DrugExosPuncExos-882",data)=="有"){
		ttPuncExos="，评分-数字评定量表"+$g(data["DrugExosPuncExos-905-907-909"])+"分";
	}
	if(getRadioValueById("DrugExosPuncExos-882",data)=="有"){
		kyPuncExos="，范围"+$g(data["DrugExosPuncExos-917-919-921"])+"×"+$g(data["DrugExosPuncExos-917-919-923"])+"cm2";
	}
	
	htmlStr=htmlStr+initTableTdOne("红肿："+getRadioValueById("DrugExosPuncExos-882",data)+hzPuncExos,2,"","","");				// 红肿
	htmlStr=htmlStr+initTableTdOne("硬结："+getRadioValueById("DrugExosPuncExos-902",data),3,"","","");				// 硬结
	htmlStr=htmlStr+initTableTdOne("疼痛："+getRadioValueById("DrugExosPuncExos-905",data)+ttPuncExos,4,"","","</tr>");				// 疼痛
	htmlStr=htmlStr+initTableTdOne("灼热感："+getRadioValueById("DrugExosPuncExos-911",data),2,"","","<tr>");				// 灼热感
	htmlStr=htmlStr+initTableTdOne("水泡："+getRadioValueById("DrugExosPuncExos-914",data),3,"","","");				// 水泡
	htmlStr=htmlStr+initTableTdOne("溃疡："+getRadioValueById("DrugExosPuncExos-917",data)+kyPuncExos,4,"","","</tr>");				// 溃疡
	htmlStr=htmlStr+initTableTdOne("关节活动："+getRadioValueById("DrugExosPuncExos-925",data),5,"","","<tr>");				// 关节活动
	htmlStr=htmlStr+initTableTdOne("患肢远端血运："+getRadioValueById("DrugExosPuncExos-928",data),4,"","","</tr>");				// 患肢远端血运
	htmlStr=htmlStr+initTableTr("静脉炎分级："+getRadioValueById("DrugExosPhleClass",data),10,"");		// 静脉炎分级
	htmlStr=htmlStr+initTableTr("渗出分级："+getRadioValueById("DrugExosSeepClass",data),10,"");		// 渗出分级
	var DrugExosTreatMeas=radioValue("DrugExosTreatMeas-933,DrugExosTreatMeas-934,DrugExosTreatMeas-935,DrugExosTreatMeas-936",data);
	if(radioValue("DrugExosTreatMeas-937",data)!=""){
		DrugExosTreatMeas=DrugExosTreatMeas+"；药物局部封闭（具体用药）："+radioValue("DrugExosTreatMeas-937",data)
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
				TreatMeasDrugList=TreatMeasDrugList+"  "+j+"、"+TreatMeasDrugArr[0];
			}
			if(TreatMeasDrugArr[0].indexOf("：")==-1){
				if(TreatMeasDrugArr[1]!=""){
			 		TreatMeasDrugList=TreatMeasDrugList+"  "+j+"、"+TreatMeasDrugArr[0]+"："+TreatMeasDrugArr[1];
			 	}
			}else{
			 if(TreatMeasDrugArr[1]!=""){
		     	TreatMeasDrugList=TreatMeasDrugList+"  "+j+"、"+TreatMeasDrugArr[0]+TreatMeasDrugArr[1];
			 }
		   }   
		}
	}
	if(TreatMeasDrugList!=""){
		TreatMeasDrugList="；根据药物性质给予("+TreatMeasDrugList+")";
	}
	
	var TreatMeasHz=getRadioValueById("DrugExosTreatMeas-947",data);
	if(TreatMeasHz!=""){
		TreatMeasHz="；请会诊("+TreatMeasHz+")";
	}
	
	
	htmlStr=htmlStr+initTableTr("处理措施："+DrugExosTreatMeas+TreatMeasDrugList+TreatMeasHz,10,"");		// 处理措施
	htmlStr=htmlStr+initTableTr("其他情况说明："+$g(data["DrugExosAssother"]),10,"");		// 其他情况说明

	htmlStr=htmlStr+initTableTr("二、事件发生可能原因 ","10","font-weight:bold;font-size:16px;");							// 二、事件发生可能原因 
	var DrugExosByPatPhyFact=radioValue("DrugExosByPatPhyFact-799,DrugExosByPatPhyFact-800,DrugExosByPatPhyFact-803,DrugExosByPatPhyFact-804",data);
	if(radioValue("DrugExosByPatPhyFact-801",data)!=""){
		DrugExosByPatPhyFact=DrugExosByPatPhyFact+"；针头移位（"+getRadioValueById("DrugExosByPatPhyFact-801",data)+"）";
	}	
	htmlStr=htmlStr+initTableTr("1、与病人生理及行为因素相关："+DrugExosByPatPhyFact,10,"");			// 与病人生理及行为因素相关
	htmlStr=htmlStr+initTableTr("2、与工作状态/流程设计因素相关："+getRadioValueById("DrugExosByWorkStat",data),10,"");			// 与工作状态/流程设计因素相关
	htmlStr=htmlStr+initTableTr("3、与人员个人因素相关："+getRadioValueById("DrugExosByPerFact",data),10,"");			// 与人员个人因素相关
	htmlStr=htmlStr+initTableTr("4、与机械性因素相关："+getRadioValueById("DrugExosByMechFact",data),10,"");			// 与机械性因素相关
	htmlStr=htmlStr+initTableTr("5、与药理因素相关："+getRadioValueById("DrugExosByPhmcFact",data),10,"");			// 与药理因素相关
	htmlStr=htmlStr+initTableTr("6、与阻塞因素相关："+getRadioValueById("DrugExosByBlockFact",data),10,"");			// 与阻塞因素相关



	htmlStr=htmlStr+initTableTr("三、科室用药规范","10","font-weight:bold;font-size:16px;");							// 三、科室用药规范
	htmlStr=htmlStr+initTableTr("科室用药规范："+getRadioValueById("DrugExosByLocDrug",data)+"；"+getRadioValueById("DrugExosByLocDrug-838",data),10,"");				// 科室用药规范

	htmlStr=htmlStr+initTableTdOne("报告单位："+$g(data["RepHospType"]),3,"","","<tr>");	//报告单位
	htmlStr=htmlStr+initTableTdOne("联系电话："+$g(data["HospPhone"]),3,"","","");	//联系电话
	htmlStr=htmlStr+initTableTdOne("报告日期："+$g(data["ReportDate"]),4,"","","</tr>");	//报告日期

	htmlStr=htmlStr+initTableTdOne("填报人姓名："+$g(data["RepUserName"]),3,"","","<tr>");	//填报人姓名
	htmlStr=htmlStr+initTableTdOne("填报人职称："+$g(data["RepUserTitle"]),3,"","","");   	//填报人职称	
	htmlStr=htmlStr+initTableTdOne("填报人工作年限："+$g(data["RepUserWorkYears"]),4,"","","</tr>");   	//填报人工作年限	

	htmlStr=htmlStr+initTableTr("不良事件发生后处理方法(护士长填写)："+getRadioValueById("OccurAfterDealMethod",data),10,"");			// 不良事件发生后处理方法(护士长填写)
	var DeptIfOccSimEvent=getRadioValueById("DeptIfOccSimEvent",data);
	if(DeptIfOccSimEvent=="是"){
		DeptIfOccSimEvent=DeptIfOccSimEvent+"  本年度（次）："+$g(data["DeptIfOccSimEvent-94119-94120"]);
	}	
	htmlStr=htmlStr+initTableTr("科室是否发生过类似的事件："+DeptIfOccSimEvent,10,"");				// 科室是否发生过类似的事件
	htmlStr=htmlStr+initTableTr("科室讨论分析、整改措施及处理意见(护士长填写)",10,""); 	//再次手术准备情况
	var ReasonStr=getRadioById(RepID,"NurReasonCase");
	var Reason=ReasonStr.split("%");
	var len=Reason.length;
	var NurReasonCase="";
	if(Reason!=""){
		for(i=0;i<len;i++){
			var j=i+1
			var ReasonArr=Reason[i].split("!");
			if(ReasonArr[1]==""){
				NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0];
			}
			if(ReasonArr[0].indexOf("：")==-1){
				if(ReasonArr[1]!=""){
			 		NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0]+"："+ReasonArr[1];
			 	}
			}else{
			 if(ReasonArr[1]!=""){
		     	NurReasonCase=NurReasonCase+"  "+j+"、"+ReasonArr[0]+ReasonArr[1];
			 }
		   }   
		}
	}
	htmlStr=htmlStr+initTableTr("原因分析："+NurReasonCase,10,"");				// 原因分析
	var NurCorrectAction=radioValue("NurCorrectAction-296,NurCorrectAction-297,NurCorrectAction-298,NurCorrectAction-299,NurCorrectAction-300,NurCorrectAction-302",data);
	if(radioValue("NurCorrectAction-301",data)!=""){
		NurCorrectAction=NurCorrectAction+"；修订制度/流程/职责等："+radioValue("NurCorrectAction-301",data)
	}
	htmlStr=htmlStr+initTableTr("整改措施："+NurCorrectAction,10,"");   // 整改措施
	var NurDisposition=radioValue("NurDisposition-306,NurDisposition-307,NurDisposition-309",data);
	if(radioValue("NurDisposition-308",data)!=""){
		NurDisposition=NurDisposition+"；当事人及相关人员违反制度/流程/职责，予扣罚："+radioValue("NurDisposition-308",data)
	}
	htmlStr=htmlStr+initTableTr("处理意见："+NurDisposition,10,"");   // 处理意见
	htmlStr=htmlStr+initTableTdOne("护士长签名："+$g(data["NurHeadNurse"]),6,"","","<tr>");				// 护士长签名
	htmlStr=htmlStr+initTableTdOne("签名日期："+$g(data["NurSignDate"]),3,"","","</tr>");				// 签名日期
	
	htmlStr=htmlStr+initTableTr("患者安全管理小组调研结果及指导意见",10,""); 	//患者安全管理小组调研结果及指导意见
	htmlStr=htmlStr+initTableTr("1.调研情况："+getRadioValueById("PatSafeGroupResult-label-603",data),10,"");				// 1.调研情况
	htmlStr=htmlStr+initTableTr("2.科室处理意见："+getRadioValueById("PatSafeGroupResult-label-606",data) ,10,"");   // 2.科室处理意见
	htmlStr=htmlStr+initTableTr("3.其他："+$g(data["PatSafeGroupResult-label-609"]) ,10,"");   // 3.其他
	htmlStr=htmlStr+initTableTdOne("护理安全小组查阅人："+$g(data["NurTeamReferPerson"]),6,"","","<tr>");				// 护理安全小组查阅人
	htmlStr=htmlStr+initTableTdOne("查阅日期："+$g(data["ReferDate"]),4,"","","</tr>");				// 查阅日期
	
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
	//printOrExportHtml()  // 调用打印或导出
}
//药品质量报告单打印
function printAdvdrugqualityData(data){
	
   var htmlStr="<table  border='0' cellspacing='0' style='width:100%'>" ;
	htmlStr=htmlStr+initTableTr(LgHospDesc,"10","border:1px solid #ffffff;font-size:16px;font-weight:bold;text-align:center;margin-top:20px;height:20px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("药品质量报告单","10","border-left-color:#ffffff;border-right-color:#ffffff;font-size:30px;font-weight:bold;text-align:center;margin-top:20px;height:40px;");			//患者一般资料
	htmlStr=htmlStr+initTableTr("事件编号 :"+$g(data["EventNum"]),10,"");     	 //事件编号
	htmlStr=htmlStr+initTableTdOne("上报人 :"+$g(data["ReportPer"]),3,"","","<tr>");			 //上报人
	htmlStr=htmlStr+initTableTdOne("上报时间 :"+$g(data["ReportTime"]),7,"","","","</tr>");  //上报时间
	
	htmlStr=htmlStr+initTableTr("患者基本信息","10","font-weight:bold;font-size:16px;");			//患者基本信息
	htmlStr=htmlStr+initTableTdOne("登记号 :"+$g(data["PatNo"]),3,"","","<tr>");   	//登记号
	htmlStr=htmlStr+initTableTdOne("病案号："+$g(data["PatMedicalNo"]),3,"","","");	//病案号
	htmlStr=htmlStr+initTableTdOne("民族："+$g(data["PatNational"]),4,"","","</tr>");	//民族

	htmlStr=htmlStr+initTableTdOne("姓名："+$g(data["AdmName"]),3,"","","<tr>");  					//姓名
	htmlStr=htmlStr+initTableTdOne("患者年龄："+$g(data["MedNewRepPatAge"]),3,"","","");	//患者年龄
	htmlStr=htmlStr+initTableTdOne("出生日期："+$g(data["PatDOB"]),4,"","","</tr>");				//出生日期
	htmlStr=htmlStr+initTableTdOne("患者性别："+$g(data["PatSexinput"]),3,"","","<tr>");	//性别	
	htmlStr=htmlStr+initTableTdOne("患者体重："+$g(data["PatWeight"]),3,"","","");				//患者体重
	htmlStr=htmlStr+initTableTdOne("电话："+$g(data["MedNewRepTel"]),4,"","","</tr>");				//电话
	htmlStr=htmlStr+initTableTr("诊断："+$g(data["Disease"]),"10","");	//诊断
	htmlStr=htmlStr+initTableTr("就诊科室："+$g(data["admLoc"]),"10","");	//就诊科室

	htmlStr=htmlStr+initTableTr("事件基本信息","10","font-weight:bold;font-size:16px;");		//事件基本信息

	htmlStr=htmlStr+initTableTdOne("发生日期："+$g(data["admLoc"]),6,"","","<tr>");	//发生日期
	htmlStr=htmlStr+initTableTdOne("发现日期："+$g(data["admLoc"]),4,"","","</tr>");	//发现日期
	htmlStr=htmlStr+initTableTdOne("发生科室："+$g(data["OccurLoc"]),6,"","","<tr>");	//发生科室
	htmlStr=htmlStr+initTableTdOne("上报所属科室："+$g(data["ReportSubLoc"]),4,"","","</tr>");	//上报所属科室
	htmlStr=htmlStr+initTableTr("事件分级："+getRadioValueById("drugreportlevel",data),"10","");		//事件分级
	htmlStr=htmlStr+initTableTr("事件发生地点："+getRadioValueById("quaHapenplace",data),"10","");		//事件发生地点

	var quadruglist=$g(data["quadruglist"]);  //怀疑药品列表
   	if(quadruglist!=""){
   		htmlStr=htmlStr+initTableTd("商品名称","通用名","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd("供应商","生产企业","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("批号","数量","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTd("剂型","规格","0","0","background-color:#808080;width:10%;","background-color:#808080;width:10%;","");
		htmlStr=htmlStr+initTableTdOne("包装类型",2,"","background-color:#808080","</tr>");
	   	$(quadruglist).each(function(index,obj){
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94629"]),$g(obj["quadruglist-94630"]),"0","0","width:10%;","width:10%;","<tr>");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94631"]),$g(obj["quadruglist-94632"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94633"]),$g(obj["quadruglist-94634"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTd($g(obj["quadruglist-94635"]),$g(obj["quadruglist-94636"]),"0","0","width:10%;","width:10%;","");
		htmlStr=htmlStr+initTableTdOne($g(obj["quadruglist-94637"]),2,"","","</tr>");	
	       })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有怀疑药品","10","");
	}
	htmlStr=htmlStr+initTableTr("是否能够提供药品标签、处方复印件等资料："+getRadioValueById("cancopyinfoma",data),10,""); //是否能够提供药品标签、处方复印件等资料

	htmlStr=htmlStr+initTableTr("事件发生经过："+$g(data["reportpass"]),10,""); 						//事件发生经过
	
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
		admheartlevellist="死亡(直接死因)："+admheartlevelsw+"   死亡时间："+$g(data["admheartlevel-94646"]);
	}
	if(admheartlevelcw!=""){
		admheartlevellist="生命垂危，需抢救(报告)："+admheartlevelcw;
	}
	if(admheartlevelzs!=""){
		admheartlevellist="暂时伤害(部位、程度)："+admheartlevelzs;
	}
	if(admheartlevelyj!=""){
		admheartlevellist="永久性伤害(部位、程度)："+admheartlevelyj;
	}
	htmlStr=htmlStr+initTableTr("患者伤害情况："+admheartlevellist,10,""); 	//患者伤害情况
	htmlStr=htmlStr+initTableTr("恢复过程："+admheartlevelhf,10,""); 	//恢复过程
	htmlStr=htmlStr+initTableTr("引发事件因素："+getRadioValueById("drugquafactor",data),10,""); //引发事件因素
	htmlStr=htmlStr+initTableTr("事件处理情况："+$g(data["drugcondition"]),10,""); 						//事件处理情况
	htmlStr=htmlStr+initTableTr("改进措施："+$g(data["correcactions"]),10,""); 						//改进措施
	htmlStr=htmlStr+initTableTr("科室负责人："+$g(data["LocLeading"]),"10","")		//科室负责人
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
	//printOrExportHtml()  // 调用打印或导出
}

// 单td，传参(值,合并单元格数,css,tr标签)
// return : <tr><td>值</td> 
// return : <td>值</td>
// return : <td>值</td></tr>
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

// 双td，传参(表头,值,表头合并单元格数,值合并单元格数,表头css,值css,tr标签)
// return : <tr><td>表头</td><td>值</td></tr>
// return : <td>表头</td><td>值</td>
// return : <td>表头</td><td>值</td></tr>

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

// tr ，传参(表头，合并单元格数，css)
// return : <tr><td>...</td></tr>
function initTableTr(title,clospan,css){
	var htmlStr=""
	var htmlStr="<tr><td style="+'"'+css+'"'+ " colspan="+clospan+">"+title+"</td></tr>"
	return htmlStr;
	}

// 多个td  传参(值^值^值^值^值^值^值^值^....)
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
	
	
//取值用,处理未定义的变量
function $g(param){
	return param==undefined?"":	param;
}
//取值用,通过父类id取值
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
	return ret.join("； ");
}

// 导出或者打印
function printOrExportHtml(){
	UlcerPrint()
	/*if(prtOrExp=="htmlPrint"){
		UlcerPrint()
	}else if(prtOrExp=="htmlExport"){
		
		exportPdf()

		}
	*/
	}
//打印
function UlcerPrint(){
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //判断是否是IE浏览器
		document.getElementById('WebBrowser').ExecWB(6,2)
		setTimeout(function (){							//关闭当前页面
			// window.close();			 
			 },200)	
		
	}else{
		 window.print();
		 setTimeout(function (){
			 window.close();			 
			 },200)	
	}
	
 }
// 页面导出pdf
function exportPdf(){

		
        var pdf = new jsPDF('p', 'mm', 'b3'); 
        var print_content = $('#PrintContent'); 
		$('#PrintContent').css("background","#ffffff" )
        var filename = 'hello.pdf'; 
        
        pdf.addHTML($('#PrintContent'), function(){
            pdf.output("save", filename)
        })
}

//IE 隐藏打印时文件路径和日期
function HiddenPathDate(){     		   
	var hkey_root,hkey_path,hkey_key;
	hkey_root="HKEY_CURRENT_USER"
	hkey_path="\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
	try{
 	 	var RegWsh = new ActiveXObject("WScript.Shell");
 		hkey_key="header";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"");
		hkey_key="footer";
		RegWsh.RegWrite(hkey_root+hkey_path+hkey_key,"&b第&p页/共&P页"); //&w&b页码,&p/&P

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

// 护士长评价内容
function HeadNurPrintInfo(HeadNurEvaList,RepFlag){
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("护士长评价与原因分析","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("一、晨会报告","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("晨会报告日期："+ $g(HeadNurEvaList["MornRepMeetDate"])+" "+$g(HeadNurEvaList["MornRepMeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("晨会地点："+ $g(HeadNurEvaList["MornRepMeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("晨会人员："+ $g(HeadNurEvaList["MornRepMeetpants"]),"10","");
	htmlStr=htmlStr+initTableTr("晨会内容："+ $g(HeadNurEvaList["MornRepMeetContent"]),"10","");
	
	htmlStr=htmlStr+initTableTr("二、科室护理不良事件分析","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("会议日期："+ $g(HeadNurEvaList["MeetDate"])+" "+$g(HeadNurEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("会议地点："+ $g(HeadNurEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("参会人员："+ $g(HeadNurEvaList["Participants"]),"10","");
	if((RepFlag!="")&&(RepFlag!=undefined)){
		htmlStr=htmlStr+initTableTr("原因分析","10","font-weight:bold;font-size:16px;"); //原因分析
		htmlStr=htmlStr+initTableTr($g(HeadNurEvaList["CauseAnalysis-text"]),"10","");
	}
	htmlStr=htmlStr+initTableTr("个案改进（对应要素集中原因）","10","font-weight:bold;font-size:16px;");
	var CaseImprovement=$g(HeadNurEvaList["CaseImprovement"])
	CaseImprovement=CaseImprovement.replace(/\n/g,'<br/>');
	CaseImprovement=CaseImprovement.replace(/\t\t\t/g,'<br/>');
	htmlStr=htmlStr+initTableTr(CaseImprovement,"10","");
	var ManaImprovementList="";
	var ManaImprovement=$g(HeadNurEvaList["ManaImprovement-94378-94951"]); 
	var ManaImprovementzdoth=radioValue("ManaImprovement-94378-94949,ManaImprovement-94378-94950",HeadNurEvaList); 
	if (ManaImprovement!=""){
		ManaImprovementList="管理改进：  制度、流程及规范制定或修订（"+ManaImprovementzdoth+"名称："+ManaImprovement+"）；";
	}
	var ManaImprovementoth=radioValue("ManaImprovement-94381,ManaImprovement-94382,ManaImprovement-94493",HeadNurEvaList); 
	if((ManaImprovementoth!="")&&(ManaImprovement=="")){
		ManaImprovementList="管理改进："+ManaImprovementoth
	}
	if ((ManaImprovement!="")&&(ManaImprovementoth!="")){
		ManaImprovementList=ManaImprovementoth;
	}
	htmlStr=htmlStr+initTableTr("管理改进","10","border-bottom:0px;font-weight:bold;font-size:16px;"); //管理改进
	if(ManaImprovementList!="")	{
		htmlStr=htmlStr+initTableTr(ManaImprovementList,"10","border-top:0px"); //管理改进
	}
	htmlStr=htmlStr+initTableTr("护士长追踪及评价","10","font-weight:bold;font-size:16px;");
	var HeadNurEvaluateList=$g(HeadNurEvaList["HeadNurEvaluate"]);//护士长评价
   	if(HeadNurEvaluateList!=""){
   		htmlStr=htmlStr+initTableTdOne("督查时间","","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("督查对象","","","background-color:#808080;width:15%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查内容","","","background-color:#808080;width:25%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查结果","","","background-color:#808080;width:30%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查人","","","background-color:#808080;text-align:center;","</tr>");

	   	$(HeadNurEvaluateList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94393-94398"]),"","","width:15%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94394-94399"]),"","","width:15%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94395-94400"]),"","","width:25%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94396-94401"]),"","","width:30%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["HeadNurEvaluate-94387-94397-94403"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有护士长评价信息","10","");
	}
	
	htmlStr=htmlStr+initTableTr("管理效果评价","10","font-weight:bold;font-size:16px;");
	var AftImpMeasuresList="";
	if ((RepFlag!="")&&(RepFlag!=undefined)&&(RepFlag.indexOf("院外带入")>=0)){
		var UlcNurImpMeasures=radioValue("UlcNurImpMeasures-label-94930,UlcNurImpMeasures-label-94931",HeadNurEvaList); 
		if(UlcNurImpMeasures!=""){
			AftImpMeasuresList=AftImpMeasuresList+"\n院外压疮：护理措施落实效果："+UlcNurImpMeasures+"。";
		}
		var UlcNurImpMeasuresoth=$g(HeadNurEvaList["UlcNurImpMeasures-label-94932-94933"]);  //未落实 未落实原因： 
		if ((UlcNurImpMeasuresoth!="")){
			AftImpMeasuresList=AftImpMeasuresList+"\n院外压疮：护理措施落实效果：未落实 未落实原因："+UlcNurImpMeasuresoth+"。";
		}
	}else{
		var AftImpMeasures=radioValue("AftImpMeasures-94923,AftImpMeasures-94924",HeadNurEvaList); 
		if(AftImpMeasures!=""){
			AftImpMeasuresList=AftImpMeasuresList+"事件发生后整改措施落实效果："+AftImpMeasures+"。";
		}
		var AftImpMeasuresoth=$g(HeadNurEvaList["AftImpMeasures-94925-94927"]);  //未落实 未落实原因： 
		if ((AftImpMeasuresoth!="")){
			AftImpMeasuresList=AftImpMeasuresList+"事件发生后整改措施落实效果：未落实 未落实原因："+AftImpMeasuresoth+"。";
		}
	}
	htmlStr=htmlStr+initTableTr(AftImpMeasuresList,"10","");
	htmlStr=htmlStr+initTableTr("护理记录书写："+ radioValue("ManaIfStandard-94455,ManaIfStandard-94456",HeadNurEvaList),"10","");
	
	return htmlStr;
}
///科护士长评价内容	
function SetLocHeaNurPrintInfo(LocHeadNurEvaList){	
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("科护士长评价与原因分析","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("一、大科护理不良事件分析及效果评价","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("会议日期："+ $g(LocHeadNurEvaList["MeetDate"])+" "+$g(LocHeadNurEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("会议地点："+ $g(LocHeadNurEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("参会人员："+ $g(LocHeadNurEvaList["Participants"]),"10","");
	htmlStr=htmlStr+initTableTr("科室案例分析及时性："+ getRadioValueById("LocCaseTimeliness",LocHeadNurEvaList),"10","border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("原因分析找到真因："+ getRadioValueById("FindReason",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",LocHeadNurEvaList); 
	var BefPreventMeasuresipt=$g(LocHeadNurEvaList["BefPreventMeasures-94439"]);  //具体表现
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		BefPreventMeasuresipt=" 具体表现："+BefPreventMeasuresipt+"。";
	}
	htmlStr=htmlStr+initTableTr("发生前防范措施落实情况："+ BefPreventMeasures+BefPreventMeasuresipt,"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("发生前防范措施未落实的原因：具体表现："+ getRadioValueById("BefPreMeaReason",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("事件发生后整改措施的针对性："+ getRadioValueById("AftImpPertinence",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("事件发生后整改措施落实的及时性："+ getRadioValueById("AftImpTimeliness",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("护士长整改落实的痕迹："+ getRadioValueById("HeadNurReformMark",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("护理记录书写："+ getRadioValueById("ManaIfStandard",LocHeadNurEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("大科意见："+ $g(LocHeadNurEvaList["LocHeadView"]),"10","border-top:0px;");
	
	htmlStr=htmlStr+initTableTr("二、科护士长追踪记录","10","font-weight:bold;font-size:16px;");
	var LocHeadNurEvaluateList=$g(LocHeadNurEvaList["LocHeadNurEvaluate"]);//科护士长评价
   	if(LocHeadNurEvaluateList!=""){
   		htmlStr=htmlStr+initTableTdOne("督查时间","","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("督查对象","","","background-color:#808080;width:15%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查内容","","","background-color:#808080;width:25%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查结果","","","background-color:#808080;width:30%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("督查人","","","background-color:#808080;text-align:center;","</tr>");

	   	$(LocHeadNurEvaluateList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94422-94427"]),"","","width:15%;","<tr>");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94423-94428"]),"","","width:15%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94424-94429"]),"","","width:25%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94425-94430"]),"","","width:30%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["LocHeadNurEvaluate-94416-94426-94431"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有科护士长评价信息","10","");
	}
	return htmlStr;
}
///护理部评价内容	
function SetNurDepPrintInfo(NurDepEvaList){
	var htmlStr="";
	htmlStr=htmlStr+initTableTr("护理部评价与原因分析","10","font-weight:bold;font-size:16px;text-align:center;");
	htmlStr=htmlStr+initTableTr("一、护理部护理不良事件分析及效果评价","10","font-weight:bold;font-size:16px;");
	htmlStr=htmlStr+initTableTr("会议日期："+ $g(NurDepEvaList["MeetDate"])+" "+$g(NurDepEvaList["MeetTime"]),"10","");
	htmlStr=htmlStr+initTableTr("会议地点："+ $g(NurDepEvaList["MeetPlace"]),"10","");
	htmlStr=htmlStr+initTableTr("参会人员："+ $g(NurDepEvaList["Participants"]),"10","");
	htmlStr=htmlStr+initTableTr("护理不良事件级别："+ getRadioValueById("RepLevel",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("科室案例分析及时性："+ getRadioValueById("MLocCaseTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("大科室案例分析："+ getRadioValueById("HadeLocCaseTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("原因分析找到真因："+ getRadioValueById("FindReason",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	var BefPreventMeasures=radioValue("BefPreventMeasures-94436,BefPreventMeasures-94437",NurDepEvaList); 
	var BefPreventMeasuresipt=$g(NurDepEvaList["BefPreventMeasures-94439"]);  //具体表现
	if ((BefPreventMeasuresipt!="")&&(BefPreventMeasures!="")){
		BefPreventMeasuresipt=" 具体表现："+BefPreventMeasuresipt+"。";
	}
	htmlStr=htmlStr+initTableTr("发生前防范措施落实情况："+ BefPreventMeasures+BefPreventMeasuresipt,"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("发生前防范措施未落实的原因：具体表现："+ getRadioValueById("BefPreMeaReason",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("事件发生后整改措施的针对性："+ getRadioValueById("AftImpPertinence",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("事件发生后整改措施落实的及时性："+ getRadioValueById("AftImpTimeliness",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("护士长整改落实的痕迹："+ getRadioValueById("HeadNurReformMark",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("科护士长整改落实的痕迹："+ getRadioValueById("LocHeadNurReformMark",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("护理记录书写："+ getRadioValueById("ManaIfStandard",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	if(getRadioValueById("InSkiUlcQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("院内压疮事件定性："+ getRadioValueById("InSkiUlcQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}
	if(getRadioValueById("DrugErrQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("给药缺陷事件定性："+ getRadioValueById("DrugErrQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}
	if(getRadioValueById("OthQualita",NurDepEvaList)!=""){
		htmlStr=htmlStr+initTableTr("其它事件定性："+ getRadioValueById("OthQualita",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	}

	htmlStr=htmlStr+initTableTr("总体评价："+ getRadioValueById("OverEvaluation",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("下一步要求："+ getRadioValueById("NextStep",NurDepEvaList),"10","border-top:0px;border-bottom:0px;");
	htmlStr=htmlStr+initTableTr("护理部意见："+ $g(NurDepEvaList["NurDepAdvice"]),"10","border-top:0px;");

	htmlStr=htmlStr+initTableTr("二、护理部追踪记录","10","font-weight:bold;font-size:16px;");
	var NurDepRecordList=$g(NurDepEvaList["NurDepRecord"]);//护理部追踪记录
   	if(NurDepRecordList!=""){
   		htmlStr=htmlStr+initTableTdOne("日期","1","","background-color:#808080;width:15%;text-align:center;","<tr>");
		htmlStr=htmlStr+initTableTdOne("方式","1","","background-color:#808080;width:20%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("内容","2","","background-color:#808080;width:50%;text-align:center;","");
		htmlStr=htmlStr+initTableTdOne("记录者","","","background-color:#808080;text-align:center;","</tr>");

	   	$(NurDepRecordList).each(function(index,obj){
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94476-94480"]),"1","","width:15%;","<tr>");
			var NDRmode=radioValue("NurDepRecord-94470-94477-94481,NurDepRecord-94470-94477-94482,NurDepRecord-94470-94477-94483,NurDepRecord-94470-94477-94484",obj); //方式
			htmlStr=htmlStr+initTableTdOne(NDRmode,"1","","width:20%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94478-94485"]),"2","","width:50%;","");
			htmlStr=htmlStr+initTableTdOne($g(obj["NurDepRecord-94470-94479-94486"]),"","","","</tr>");
	   })
   	}else{
	   	htmlStr=htmlStr+initTableTr("该报告没有护理部追踪信息","10","");
	}
	return htmlStr;
}
//html打印强制分页
function isNextPage($tab,allText,text,$tr){
	var tabId = $($tab).attr("id");
	if(($tr!=undefined)&&($tr.find("td").length>1)){
		var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
		$(lastTr).remove();//2018-11-28 去除上一个页面的最后一行
		$($tab).parent().append("<div class='pageNext'></div>");
		$($tab).removeAttr("id");
		$($tab).parent().append("<table id="+tabId+"></table>")
		$tab = $("#"+tabId);
		$($tab).append($(lastTr)); //2018-11-28 新的表格添加上页最后一行数据
		return;
	}
	if(!($tab.height()>pageHeight*cuPage)&&(text.length!=0)){ //换页前最后一行数据超过一页进入此判断
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
	
	 if(text.length==0){ //换页前最后一行数据不超过一页进入此判断
		//cuPage=cuPage+1;
		var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
		//$(lastTr).find("td").html(""); //2018-11-28 
		$(lastTr).remove();//2018-11-28 去除上一个页面的最后一行
		$($tab).parent().append("<div class='pageNext'></div>");
		$($tab).removeAttr("id");
		$($tab).parent().append("<table id="+tabId+"></table>")
		$tab = $("#"+tabId);
		$(lastTr).find("td").html(allText); //2018-11-28 赋值
		$($tab).append($(lastTr)); //2018-11-28 新的表格添加上页最后一行数据
		return;
	} 
		
	
	var newText = getTextTakeOurOneWord(text);
	var lastTr = $tab.find("tr")[$tab.find("tr").length-1];
	$(lastTr).find("td").html(newText);
	isNextPage($tab,allText,newText);
	return;
}
//html打印强制分页 获取新的字符串
function getTextTakeOurOneWord(text){
	var textlist=text.replace(/<br>/g,"$");
	var textlist=text.replace(/<br\s*\/?>/g,"$");
	var val=text.substring(0,text.length - 1);
	val=val.replace(/\$/g,"<br />");
	return val;
}
