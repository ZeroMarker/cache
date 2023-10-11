//页面Gui
var objScreen = new Object();
function InitEmrRepAdmWin(){
	var obj = objScreen;
	$.parser.parse(); // 解析整个页面 
	var flag = 0;
	
	//控制产品显示
	obj.RepTypeList = new Array();  //产品列表
	var arrRepType = RepTypeList.split(',');
	for (var indRepType = 0; indRepType < arrRepType.length; indRepType++) {
		var tmpReport = arrRepType[indRepType];
		if (!tmpReport) continue;
		var arrTmp = tmpReport.split('-');
		if (arrTmp.length < 3) continue;
		obj.RepTypeList[indRepType] = {
			TypeCate : arrTmp[0],
			TypeCode : arrTmp[1],
			TypeDesc : arrTmp[2],
			ReportList : new Array(),
			ReportCount : 0
		}
	}
	
	//控制卡片显示	
	//传染病
	obj.LoadEPDData = function() {
		var strEPDList =$m({
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QryByPapmi",
			ResultSetType:'array',
			PatientID: PatientID
		}, false);
		var objEPD = JSON.parse(strEPDList);
		var EPDlen = objEPD.length;
		if (EPDlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<EPDlen;ind++) {
			var EPDID         = objEPD[ind].RowID;
			var DiseaseName   = objEPD[ind].DiseaseName;
			var DiagDate      = objEPD[ind].DiagDate;
			var Status        = objEPD[ind].Status;
			var ReportDep     = objEPD[ind].ReportDep;
			var RepDateTime   = objEPD[ind].RepDate+' '+objEPD[ind].RepTime;
			var RepUserName   = objEPD[ind].RepUserName;
			var CheckDateTime = objEPD[ind].CheckDate+' '+objEPD[ind].CheckTime;
			var CheckUserName = objEPD[ind].CheckUserName;		
			var DelReason     = objEPD[ind].DelReason;
			var OldRepFlag     = objEPD[ind].OldRepFlag;
			var background=""
			if (Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			var type="epd";
			htmlStr =  '<div class="card-div" id=CardEpd'+EPDID+'>'	
			if (OldRepFlag==1) {
				htmlStr += '<div class="card-title" style="background:#BA55D3;"><span>传染病报告(历史数据导入)</span></div>'			
			}else {
				htmlStr += 	'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + EPDID + '\')">传染病报告</a></span></div>'			
			}
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			if (OldRepFlag==1) {
				htmlStr +=             '<tr><td class="card-td"><span>诊断：</span></td><td>'+DiseaseName+'</td></tr>'			
			}else {
				htmlStr += 			   '<tr><td class="card-td"><span>诊断：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + EPDID + '\')">'+DiseaseName+'</a></td></tr>'
			}
			htmlStr += 					'<tr><td class="card-td"><span>诊断日期：</span></td><td>'+DiagDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportDep+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+CheckDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+CheckUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>退废原因：</span></td><td>'+DelReason+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	
	//新冠肺炎
	obj.LoadNCPData = function() {
		var strNCPList =$m({
			ClassName:"DHCMed.EPDService.NCPInvestigationSrv",
			QueryName:"QryReportByPat",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objNCP = JSON.parse(strNCPList);
		var NCPlen = objNCP.length;
		if (NCPlen<1) return;
	  
		var htmlStr ='';
		for (var ind=0; ind<NCPlen;ind++) {
			var NCPID         = objNCP[ind].RepoetID;
			var CardNo        = objNCP[ind].CardNo;
			var SymPtom       = objNCP[ind].SymPtomList;
			var Status        = objNCP[ind].StatusDesc;
			var Severity      = objNCP[ind].SeverityDesc
			var DiagDegree    = objNCP[ind].DiagDegreeDesc
			var SickDate      = objNCP[ind].SickDate
			var Complication  = objNCP[ind].ComplicationList;
			var PreAnamnesis  = objNCP[ind].PreAnamnesisList;
			var RepDateTime   = objNCP[ind].ReportDate+' '+objNCP[ind].ReportTime;
		
			var background=""
			if(Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			
			htmlStr =  '<div class="card-div" id=CardNCP'+NCPID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenNCPReport(\'' +NCPID + '\')">新冠肺炎个案调查</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>问卷编号：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenNCPReport(\'' + NCPID + '\')">'+CardNo+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>发病日期：</span></td><td>'+SickDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>症状体征：</span></td><td>'+SymPtom+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>并发症：</span></td><td>'+Complication+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>既往病史：</span></td><td>'+PreAnamnesis+'</td></tr>'		
			htmlStr += 					'<tr><td class="card-td"><span>严重程度：</span></td><td>'+Severity+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>病例分类：</span></td><td>'+DiagDegree+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>调查时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	
	//HIV个案随访表
	obj.LoadHIVData = function() {
		var objHIV=$cm({
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QryHIVRepByEpisodeID",
			ResultSetType:'array',
			aEpisodeID: EpisodeID,
			aPatientID:PatientID
		}, false);
		var HIVlen = objHIV.length;
		if (HIVlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<HIVlen;ind++) {
			var HIVID               = objHIV[ind].ReportID ;   			        //reportid
			var ReportName    	 	= "HIV个案随访表";
			var txtPatName   		= objHIV[ind].PatName;		 	   			//患者姓名
			var txtFollowStatus		= objHIV[ind].FollowStatus;      			//随访状态
			var txtHIVDate			= objHIV[ind].HIVDate;              		//确诊日期
			var txtSurveyOrgan		= objHIV[ind].SurveyOrgan;					//随访单位
			var txtSurveyName		= objHIV[ind].SurveyName;					//随访人
			var txtSurveyDate		= objHIV[ind].SurveyDate;					//随访日期 
			var type="hiv";
			htmlStr =  '<div class="card-div" id=CardEpd'+HIVID+'>'	
			htmlStr += 		'<div class="card-title"><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + HIVID + '\')">HIV个案随访表</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>患者姓名：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + HIVID + '\')">'+txtPatName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>随访状态：</span></td><td>'+txtFollowStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>确诊日期：</span></td><td>'+txtHIVDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>随访单位：</span></td><td>'+txtSurveyOrgan+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>随访人：</span></td><td>'+txtSurveyName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>随访日期：</span></td><td>'+txtSurveyDate+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);					
		}
		
	}
	//肺结核转诊单
	obj.LoadRefData = function() {
		var objRef=$cm({
			ClassName:"DHCMed.EPDService.ReferralRepSrv",
			QueryName:"QryRefRepByEpisode",
			ResultSetType:'array',
			aEpisodeID: EpisodeID
		}, false);
		//var objEPD = JSON.parse(objILI);
		var Reflen = objRef.length;
		if (Reflen<1) return;
		
		var htmlStr ='';
		for (var ind=0; ind<Reflen;ind++) {
			var RefID        = objRef[ind].ReportID;    			                //reportid
			var ReportName   = "肺结核转诊单";
			var ReferralDate = objRef[ind].ReferralDate;	 	 	                 //转诊日期
			var Status       = objRef[ind].RepStatusDesc;                            //报告状态
			var ReferralHosp = objRef[ind].ReferralHosp;                             //转诊单位
			var RepDateTime	 = objRef[ind].ReportDate+" "+objRef[ind].ReportTime;	 //报告时间
			var RepUserName  = objRef[ind].ReportUser;				                 //报告人
			var type="referral";
			var background=""
			if(Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardEpd'+RefID+'>'	
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + RefID + '\')">'+ReportName+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>报告类型：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + RefID + '\')">'+ReportName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>转诊日期：</span></td><td>'+ReferralDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>转诊单位：</span></td><td>'+ReferralHosp +'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'					
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	
	}
	//流感样病例
	obj.LoadILIData = function() {
		var objILI=$cm({
			ClassName:"DHCMed.EPDService.QryReportILI",
			QueryName:"QryILIRepByEpisodeID",
			ResultSetType:'array',
			aEpisodeID: EpisodeID
		}, false);
		//var objEPD = JSON.parse(objILI);
		var ILIlen = objILI.length;
		if (ILIlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<ILIlen;ind++) {
			var ILIID         = objILI[ind].ReportID;    			 //reportid
			var ReportName    = "流感样病例登记";
			var DiagDate      = objILI[ind].ERAdmitDate;		 	 //诊断日期
			var Status        =	objILI[ind].RepStatusDesc;           //报告状态
			var ReportDep     = objILI[ind].ERAdmLoc;                 //报告科室
			var RepDateTime	  =	objILI[ind].ReportDate+" "+objILI[ind].ReportTime;	    //报告时间
			var RepUserName   =	objILI[ind].DoctorName;				  //报告人
			var CheckDateTime =	objILI[ind].CheckDate+" "+objILI[ind].CheckTime;		//审核时间
			var CheckUserName =	objILI[ind].CheckUser;		          //审核人
			var type="ili";
			var background=""
			if(Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardEpd'+ILIID+'>'	
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + ILIID + '\')">传染病报告</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>报告类型：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + ILIID + '\')">'+ReportName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>诊断日期：</span></td><td>'+DiagDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportDep+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+CheckDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+CheckUserName+'</td></tr>'
			//htmlStr += 					'<tr><td class="card-td"><span>退回原因：</span></td><td>'+DelReason+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
				
	}
	//死亡证
	obj.LoadDTHData = function() {
		var strDTHList =$m({
			ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryReportByPatientID",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objDTH = JSON.parse(strDTHList);
		var DTHlen = objDTH.length;
		if (DTHlen<1) return;
		
		var htmlStr ='';
		for (var ind=0; ind<DTHlen;ind++) {
			var DTHID       = objDTH[ind].RowID;
			var DeathNo     = objDTH[ind].DeathNo;
			var BaseReason  = objDTH[ind].BaseReason;
			var DthDateTime = objDTH[ind].DeathDateTime;
			var RepStatus   = objDTH[ind].RepStatusDesc;
			var RepDateTime = objDTH[ind].RepDateTime;
			var RepLoc      = objDTH[ind].RepLoc;
			var RepUser     = objDTH[ind].RepUser;		
			var CheckDate   = objDTH[ind].CheckTwoDate;
			var ReturnReason = objDTH[ind].ReturnReason;
			var background=""
			if(RepStatus=="作废"){
				var background='style="background:#C0C0C0;"'
			}		
			htmlStr =  '<div class="card-div" id=CardDth'+DTHID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">居民死亡医学证明（推断）书</a></span></div>'
			htmlStr += 		'<div class="card-dth">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>编号：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">'+DeathNo+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>死亡原因：</span></td><td><a class="hisui-tooltip" title='+BaseReason+'>'+BaseReason+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>死亡时间：</span></td><td>'+DthDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">'+RepStatus+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+RepLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+CheckDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>退回原因：</span></td><td>'+ReturnReason+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	//院感
	obj.LoadHAIData = function() {
		var strHAIList =$m({
			ClassName:"DHCHAI.CUS.ToClinReport",
			QueryName:"QryReportByAdm",
			ResultSetType:'array',
			aEpisodeDr: HAIEpisodeDr
		}, false);
		var objHAI = JSON.parse(strHAIList);
		var HAIlen = objHAI.length;
	    if (HAIlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<HAIlen;ind++) {
			var HAIID        = objHAI[ind].ReportID;
			var RepType      = objHAI[ind].ReportTypeCode;
			var RepTypeDesc  = objHAI[ind].ReportTypeDesc;
			var InfDate      = objHAI[ind].InfDate;
			var InfDiag      = objHAI[ind].InfDiag;
			var InfPos       = objHAI[ind].InfPos;
			var ReportStatus = objHAI[ind].ReportStatusDesc;
			var RepDateTime  = objHAI[ind].ReportDate+' '+objHAI[ind].ReportTime;
			var Specimen     = objHAI[ind].Specimen;
			var TestResults  = objHAI[ind].TestResults;		
			var BackOpinion  = objHAI[ind].BackOpinion;
			var background=""
			if(ReportStatus=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			
			htmlStr =  '<div class="card-div" id=CardHAI'+HAIID+'>'
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenHAIReport(\'' + HAIID + '\')">医院感染报告</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>报告类型：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenHAIReport(\'' + HAIID + '\')">'+RepTypeDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>感染日期：</span></td><td>'+InfDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>感染诊断：</span></td><td><a class="hisui-tooltip" title='+InfPos+'>'+InfPos+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>感染分类：</span></td><td><a class="hisui-tooltip" title='+InfDiag+'>'+InfDiag+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>检验标本：</span></td><td>'+Specimen+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>病原体：</span></td><td><a class="hisui-tooltip" title='+TestResults+'>'+TestResults+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>退回原因：</span></td><td>'+BackOpinion+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}	
			
	}
	
	//多重耐药菌报告
	obj.LoadMBRData = function() {
		var strMBRList =$m({
			ClassName:"DHCHAI.IRS.INFMBRSrv",
			QueryName:"QryMBRRepSrv",
			ResultSetType:'array',
			aEpisodeID: HAIEpisodeDr
		}, false);
		var objMBR = JSON.parse(strMBRList);
		var MBRlen = objMBR.length;
	    if (MBRlen<1) return;
	   
		var htmlStr ='';
		for (var ind=0; ind<MBRlen;ind++) {
			var MBRRepID     = objMBR[ind].MBRRepID;
			var LabRepID     = objMBR[ind].LabRepID;		
			var SpecDesc     = objMBR[ind].SpecDesc;
			var LocDesc      = objMBR[ind].LocDesc
			var SubmissDate  = objMBR[ind].SubmissDate;
			var MRBDesc      = objMBR[ind].MRBDesc;
			var InfTypeDesc  = objMBR[ind].InfTypeDesc;
			var HandDesc     = objMBR[ind].HandDesc;
			var ReportStatus = objMBR[ind].StatusDesc;
			var RepDateTime  = objMBR[ind].RepDate+' '+objMBR[ind].RepTime;
			var InsulatDesc  = objMBR[ind].InsulatDesc;
			var ContactListDesc  = objMBR[ind].ContactListDesc;		
			var background=""
			if(ReportStatus=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			
			htmlStr =  '<div class="card-div" id=CardMBR'+MBRRepID+'>'
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenMBRReport(\'' + MBRRepID + '\',\'' + LabRepID + '\')">多耐细菌报告</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>细菌名称：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenMBRReport(\'' + MBRRepID + '\',\'' + LabRepID + '\')">'+MRBDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>送检日期：</span></td><td>'+SubmissDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>送检标本：</span></td><td>'+SpecDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>送检科室：</span></td><td>'+LocDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>感染类型：</span></td><td>'+InfTypeDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>隔离方式：</span></td><td>'+InsulatDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>接触隔离：</span></td><td><a class="hisui-tooltip" title='+ContactListDesc+'>'+ContactListDesc+'</a></td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}	
			
	}
	
		
	//手术切口调查报告
	obj.LoadOPSData = function() {
		var strOpsList =$m({
			ClassName:"DHCHAI.IRS.INFOPSSrv",
			QueryName:"QryINFOPSByAdm",
			ResultSetType:'array',
			aEpisodeDr: HAIEpisodeDr
		}, false);
		var objOps = JSON.parse(strOpsList);
		var Opslen = objOps.length;
	    if (Opslen<1) return;
	    
		var htmlStr ='';
		for (var ind=0; ind<Opslen;ind++) {
			var ReportID     = objOps[ind].ReportID;
			var OPSID        = objOps[ind].OPSID;
			var OperAnaesID  = objOps[ind].OperAnaesID;		
			var OperName     = objOps[ind].OperName;
			var OperType      = objOps[ind].OperType
			var OperSttDateTime = objOps[ind].OperStartDateTime;
			var OperEndDateTime = objOps[ind].OperEndDateTime;
			var CuteHealing  = objOps[ind].CuteHealing;
			var CuteType     = objOps[ind].CuteType;
			var ReportStatus = objOps[ind].StatusDesc;
			var RepDateTime  = objOps[ind].RepDate+' '+objOps[ind].RepTime;
			var NNISLevel  = objOps[ind].NNISLevel;
			var ASADesc  = objOps[ind].ASADesc;		
			var background=""
			if(ReportStatus=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			
			htmlStr =  '<div class="card-div" id=CardOPS'+ReportID+'>'
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenOPSReport(\'' + ReportID + '\',\'' + OPSID + '\',\'' + OperAnaesID + '\')">手术切口调查</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>手术名称：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenOPSReport(\'' + ReportID + '\',\'' + OPSID + '\',\'' + OperAnaesID + '\')">'+OperName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>手术类型：</span></td><td>'+OperType+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>手术时间：</span></td><td>'+OperSttDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>结束时间：</span></td><td>'+OperEndDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>切口愈合：</span></td><td>'+CuteType+'/'+CuteHealing+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>风险分级：</span></td><td>'+NNISLevel+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>ASA评分：</span></td><td>'+ASADesc+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}	
			
	}

	//精神疾病
	obj.LoadSMDData = function() {
		var strSMDList =$m({
			ClassName:"DHCMed.SMDService.ReportSrv",
			QueryName:"QryReportByAdm",
			ResultSetType:'array',
			aEpisodeID: EpisodeID
		}, false);
		var objSMD = JSON.parse(strSMDList);
		var SMDlen = objSMD.length;
		if (SMDlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<SMDlen;ind++) {
			var SMDID        = objSMD[ind].RowID;
			var RepTypeDesc  = objSMD[ind].RepTypeDesc;
			var DiseaseDesc  = objSMD[ind].DiseaseDesc;
			var SickDate     = objSMD[ind].SickDate;
			var ReportLoc    = objSMD[ind].RepLocDesc;
			var StatusDesc   = objSMD[ind].StatusDesc;
			var RepDateTime  = objSMD[ind].RepDate+' '+objSMD[ind].RepTime;
			var RepUserName  = objSMD[ind].RepUserDesc;
			var ChkDateTime  = objSMD[ind].CheckDate+' '+objSMD[ind].CheckTime;
			var ChkUserName  = objSMD[ind].CheckUserDesc;		
			var background=""
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardSmd'+SMDID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenSMDReport(\'' + SMDID + '\')">精神疾病报告卡</a></span></div>'
			htmlStr += 			'<div class="card-smd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>报卡类型：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenSMDReport(\'' + SMDID + '\')">'+RepTypeDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>疾病名称：</span></td><td><a class="hisui-tooltip" title='+DiseaseDesc+'>'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>发病日期：</span></td><td>'+SickDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	//食源性疾病
	obj.LoadFBDData = function() {
		var strFBDList =$m({
			ClassName:"DHCMed.FBDService.ReportSrv",
			QueryName:"QryReportByPapmi",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objFBD = JSON.parse(strFBDList);
		var FBDlen = objFBD.length;
		if (FBDlen<1) return;
		
		var htmlStr ='';
		for (var ind=0; ind<FBDlen;ind++) {
			var FBDID        = objFBD[ind].RowID;
			var DiseaseCate  = objFBD[ind].CateDesc;
			var DiseaseDesc  = objFBD[ind].DiseaseDesc;
			var SickDateTime = objFBD[ind].SickDateTime;
			var ReportLoc    = objFBD[ind].ReportLocDesc;
			var StatusDesc   = objFBD[ind].StatusDesc;
			var RepDateTime  = objFBD[ind].RepDateTime;
			var RepUserName  = objFBD[ind].RepUserName;
			var ChkDateTime  = objFBD[ind].ChkDateTime;
			var ChkUserName  = objFBD[ind].ChkUserName;
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardFbd'+FBDID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenFBDReport(\'FBD\',\'' + FBDID + '\')">食源性疾病</a></span></div>'
			htmlStr += 		'<div class="card-fdb">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>疾病名称：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenFBDReport(\'FBD\',\'' + FBDID + '\')">'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>疾病分类：</span></td><td><a class="hisui-tooltip" title='+DiseaseCate+'>'+DiseaseCate+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>发病时间：</span></td><td>'+SickDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr +=       '<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	
	//疑似食源性疾病
	obj.LoadSusAbData = function() {
		var strSusAbList =$m({
			ClassName:"DHCMed.FBDService.SusAbRepSrv",
			QueryName:"QrySusAbRepByPapmi",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objSusAb = JSON.parse(strSusAbList);
		var SusAblen = objSusAb.length;
		if (SusAblen<1) return;
		
		var htmlStr ='';
		for (var ind=0; ind<SusAblen;ind++) {
			var SusAbID      = objSusAb[ind].RowID;
			var DiseaseCate  = objSusAb[ind].CateDesc;
			var DiseaseDesc  = objSusAb[ind].DiseaseDesc;
			var SickDateTime = objSusAb[ind].SickDateTime;
			var ReportLoc    = objSusAb[ind].ReportLocDesc;
			var StatusDesc   = objSusAb[ind].StatusDesc;
			var RepDateTime  = objSusAb[ind].RepDateTime;
			var RepUserName  = objSusAb[ind].RepUserName;
			var ChkDateTime  = objSusAb[ind].ChkDateTime;
			var ChkUserName  = objSusAb[ind].ChkUserName;
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardFbd'+SusAbID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span style="cursor:pointer;"><a ref="#" onclick="objScreen.OpenFBDReport(\'SUS\',\'' + SusAbID + '\')">疑似食源性疾病</a></span></div>'
			htmlStr += 		'<div class="card-fdb">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>主要诊断：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenFBDReport(\'SUS\',\'' + SusAbID + '\')">'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>诊断备注：</span></td><td><a class="hisui-tooltip" title='+DiseaseCate+'>'+DiseaseCate+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>发病时间：</span></td><td>'+SickDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr +=       '<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	
	
		
	//特殊患者
	obj.LoadSPEData = function() {
		var strSPEList =$m({
			ClassName:"DHCMed.SPEService.PatientsQry",
			QueryName:"QrySpeListByAdm",
			ResultSetType:'array',
			aEpisodeID: EpisodeID,
			aOperTpCode:1	
		}, false);
		var objSPE = JSON.parse(strSPEList);
		var SPElen = objSPE.length;
		if (SPElen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<SPElen;ind++) {
			var SPEID         = objSPE[ind].RowID;
			var PatTypeDesc   = objSPE[ind].PatTypeDesc;
			var StatusDesc    = objSPE[ind].StatusDesc;
			var ReadStatus    = objSPE[ind].ReadStatus;
			var Note          = objSPE[ind].Note;		
			var PrognosisDesc = objSPE[ind].PrognosisDesc;
			var MarkDateTime  = objSPE[ind].MarkDate+' '+objSPE[ind].MarkTime;
			var MarkUser      = objSPE[ind].MarkUser;
			var CheckDateTime = objSPE[ind].CheckDate+' '+objSPE[ind].CheckTime;
			var CheckOpinion  = objSPE[ind].CheckOpinion;
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardSpe'+SPEID+'>'				
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenEditSPE(\'' + SPEID + '\')">特殊患者</a></span></div>'
			htmlStr += 		'<div class="card-spe">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>患者类型：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEditSPE(\'' + SPEID + '\')">'+PatTypeDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>状态：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>消息：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenSpeNewsWin(\'' + SPEID + '\')">'+ReadStatus+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>情况说明：</span></td><td>'+Note+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>转归：</span></td><td>'+PrognosisDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>标记时间：</span></td><td>'+MarkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>标记人：</span></td><td>'+MarkUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+CheckDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核意见：</span></td><td>'+CheckOpinion+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
		
	// 慢病
	obj.LoadCDData = function() {
		var strCDList =$m({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryRepByEpisodeID",
			ResultSetType:'array',
			aEpisodeID: EpisodeID,
		}, false);
		var objCD = JSON.parse(strCDList);
		var CDlen = objCD.length;
		if (CDlen<1) return;
		
		var htmlStr ='';
		for (var ind=0; ind<CDlen;ind++) {
			var CDID         = objCD[ind].ReportID;
			var RepType      = objCD[ind].RepTypeCode
			var KPBH         = objCD[ind].KPBH;
			var RepTypeDesc  = objCD[ind].RepTypeDesc
			var ReportLoc    = objCD[ind].ReportLoc;
			var StatusDesc   = objCD[ind].RepStatusDesc;
			var RepDateTime  = objCD[ind].ReportDate+' '+ objCD[ind].ReportTime;
			var ReportUser   = objCD[ind].ReportUser;
			var ChkDateTime  = objCD[ind].CheckDate+' '+ objCD[ind].CheckTime;
			var ChkUserName  = objCD[ind].CheckUser;		
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardCD'+CDID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenCDReport(\'' + RepType + '\',\'' + CDID + '\')">慢病管理</a></span></div>'
			htmlStr += 		'<div class="card-cd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>卡片编号：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenCDReport(\'' + RepType + '\',\'' + CDID + '\')">'+KPBH+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告类型：</span></td><td>'+RepTypeDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+ReportUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核人：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			$("#cardlist").append(htmlStr);		
		}
			
	}
	//罕见病登记
	obj.LoadRDSData = function() {
		var strRDSList =$m({
			ClassName:"DHCMed.RDService.ReportSrv",
			QueryName:"QryReportByPapmi",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objRDS = JSON.parse(strRDSList);
		var RDSlen = objRDS.length;
		if (RDSlen<1) return;
	
		var htmlStr ='';
		for (var ind=0; ind<RDSlen;ind++) {
			var ReportID    = objRDS[ind].ReportID;
			var DiagnosDesc = objRDS[ind].DiagnosDesc;
			var DiagnosType = objRDS[ind].DiagnosType;
			var OnsetAge    = objRDS[ind].OnsetAge;
			var StatusDesc  = objRDS[ind].StatusDesc;
			var RepDateTime = objRDS[ind].RepDate +' '+ objRDS[ind].RepTime;
			var RepLoc      = objRDS[ind].RepLoc;
			var RepUser     = objRDS[ind].RepUser;		
			var CheckDate   = objRDS[ind].CheckDate;
			var background=""
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;'
			}
			htmlStr =  '<div class="card-div" id=CardRDS'+ReportID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenRDSReport(\'' + ReportID + '\')">罕见病登记</a></span></div>'
			htmlStr += 		'<div class="card-rds">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>诊断：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenRDSReport(\'' + ReportID + '\')">'+DiagnosDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>诊断类型：</span></td><td>'+DiagnosType+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>发病年龄：</span></td><td>'+OnsetAge+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告状态：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenRDSReport(\'' + ReportID + '\')">'+StatusDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告时间：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告科室：</span></td><td>'+RepLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>报告人：</span></td><td>'+RepUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>审核时间：</span></td><td>'+CheckDate+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}	
	}

	
	InitEmrRepAdmWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}