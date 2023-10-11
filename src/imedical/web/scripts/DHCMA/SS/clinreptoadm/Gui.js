//页面Gui
var objScreen = new Object();
function InitClinRepToAdmWin(){
	var obj = objScreen;
	$.parser.parse(); // 解析整个页面 
	var flag = 0;
	//控制按钮显示
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
	var RepTypeLen = obj.RepTypeList.length;
	
	var arrCDType =CDTypeList.split(',');    // 慢病列表
	var CDTypeLen = arrCDType.length;
	
	var htmlStr = "";
	if (RepTypeLen < 1) {  //无可上报产品
		$("#divMain").empty();//清空主区域内容
		htmlStr='<div class="noresult">'
				+ 	'<div class="nodata"><p>无上线产品或无权上报!</p></div>'
				+'</div>';
		$("#divMain").append(htmlStr);
	}else {			
		for (var indRepType = 0; indRepType < RepTypeLen; indRepType++) {
			var objRepType = obj.RepTypeList[indRepType];
			var TypeCate = objRepType.TypeCate;
			$('#btnRep'+TypeCate).show();
			
			if (TypeCate=='CD') {
				var htmlMenu='';
				for (var ind = 0; ind < CDTypeLen; ind++) {
					var TypeList = arrCDType[ind];
					var TypeCode = TypeList.split('-')[0];
					var TypeDesc = TypeList.split('-')[1];
					htmlMenu += "<div id=btnRepCD_"+TypeCode+">"+TypeDesc+"</div>";
				}
				$('#mm-cds').append(htmlMenu);
				$('#btnRepCD').menubutton({      //menubutton再生成一下  
				 	menu: '#mm-cds'  
				});  
			}
		   
			if (TypeCate=='SMD') {
				if (AdmType == 'I') {
					$('#btnRepSMD').menubutton({     
				 		menu: '#mm-smds'  
					});  
				}else {
					$('#btnRepSMD_O').removeAttr("style"); //显示div
					$('#btnRepSMD').hide();
				}
			}
			
			if (TypeCate=='HAI') {
				var retval = $m({
					ClassName:"DHCHAI.IRS.CCScreenAttSrv",
					MethodName:"GetScreenAttInfo",
					aEpisodeDr:HAIEpisodeDr
				},false);
				var rstArr = retval.split("^");
				var IsSusInf= rstArr[1];
				
				var IsMRB = $m({
					ClassName:"DHCHAI.IRS.CtlMRBSrv",
					MethodName:"IsExistMRB",
					aEpisodeDr:HAIEpisodeDr
				},false);
				
				var OprDate = $m({
					ClassName:"DHCHAI.DPS.OROperAnaesSrv",
					MethodName:"GetOperDates",
					aEpisodeDr:HAIEpisodeDr
				},false);
				if (IsSusInf=='1') {				
					if (IsMRB!=1) {
						$('#btnMBRRep').hide();
					}
					if (OprDate=="") {
						$('#btnOPSRep').hide();
					}
					$('#btnRepHAIS').removeAttr("style"); //显示div
					$('#btnRepHAIS').menubutton({     
				 		menu: '#mm-hais'  
					}); 
					$('#btnRepHAI').hide(); 
				}else {
					$('#btnRepHAI').removeAttr("style"); //显示div
					$('#btnRepHAIS').hide();
				}
				if (OprDate!="") {				
					$('#btnRepHAI').hide(); 
					if (IsSusInf!='1') {
						$('#btnScreen').hide();
					}
					if (IsMRB!=1) {
						$('#btnMBRRep').hide();
					}
					$('#btnRepHAIS').removeAttr("style"); //显示div
					$('#btnRepHAIS').menubutton({     
				 		menu: '#mm-hais'  
					}); 
				}
			}
			
		}
	}
	//处理产品较多时出现滚动条问题 add 2020-03-03
	var Height = $('#divtoolbtn').height();
	if (Height>45) {
		$('#divNorth').css('height','77px');
		$('.layout-panel-center').css('top','77px');
	}
	//控制卡片显示	
	//传染病
	obj.LoadEPDData = function() {
		var strEPDList =$m({
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QryByPapmi",
			ResultSetType:'array',
			aEpisodeID: EpisodeID
		}, false);
		var objEPD = JSON.parse(strEPDList);
		var EPDlen = objEPD.length;
		if (EPDlen<1) return;
	
		//多语言处理增加翻译
		var repTitle	 = $g('传染病报告');
		var repTitleold  = $g('传染病报告(历史数据导入)');
		var repDiag 	 = $g('诊断');
		var repDiagDate  = $g('诊断日期');
		var repSt 		 = $g('报告状态');
		var repLoc 		 = $g('报告科室');
		var repsj 		 = $g('报告时间');
		var reppeop 	 = $g('报告人');
		var repshsj 	 = $g('审核时间');
		var repshr 	 	 = $g('审核人');
		var reptfyy 	 = $g('退废原因');
		
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
			var OldRepFlag    = objEPD[ind].OldRepFlag;
			var IsCASign	  = objEPD[ind].IsCASign;
			var background=""
			if (Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			var CASignHtml = ''
			if (IsCASign == 1) {
				CASignHtml = '<td style="width:20px;" title="该报告已经过CA数字签名"><img src="../skin/default/images/ca_icon_green.png"></td>'
			}
			
			var type="epd";
			htmlStr =  '<div class="card-div" id=CardEpd'+EPDID+'>'	
			if (OldRepFlag==1) {
				htmlStr += '<div class="card-title" style="background:#BA55D3;"><span>'+repTitleold+'</span></div>'			
			}else {
				htmlStr += 	'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + EPDID + '\')">'+repTitle+'</a></span></div>'			
			}
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			if (OldRepFlag==1) {
				htmlStr +=             '<tr><td class="card-td"><span>'+repDiag+'：</span></td><td>'+DiseaseName+'</td>'+ CASignHtml +'</tr>'			
			}else {
				htmlStr += 			   '<tr><td class="card-td"><span>'+repDiag+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + EPDID + '\')">'+DiseaseName+'</a></td>'+ CASignHtml +'</tr>'
			}
			htmlStr += 					'<tr><td class="card-td"><span>'+repDiagDate+'：</span></td><td>'+DiagDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repLoc+'：</span></td><td>'+ReportDep+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repsj+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+reppeop+'：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repshsj+'：</span></td><td>'+CheckDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repshr+'：</span></td><td>'+CheckUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+reptfyy+'：</span></td><td>'+DelReason+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			$("#cardlist").append(htmlStr);		
		}
	}
	// 丙肝转介单
	obj.LoadHCVRefData = function() {
		var strHRList =$m({
			ClassName:"DHCMed.EPDService.HCVReferralSrv",
			QueryName:"QueryHCVRefByPaadm",
			ResultSetType:'array',
			aEpisodeID: EpisodeID
		}, false);
		var objHR = JSON.parse(strHRList);
		var HRlen = objHR.length;
		if (HRlen<1) return;
		var htmlStr ='';
		
		var repTitle	= $g('丙肝转介单');
		var repstatus   = $g('报告状态');
		var repname     = $g('姓名');
		var repidnum    = $g('身份证号');
		var repdate     = $g('上报日期');
		var repreforg   = $g('转介单位');
		var reprefdoc   = $g('转介医生');
		
		for (var ind=0; ind<HRlen;ind++) {
			var HRID       	= objHR[ind].RepID;
			var HRStatus   	= objHR[ind].RepStatus;
			var PatName    	= objHR[ind].PatName;
			var PersonalID  = objHR[ind].PersonalID;
			var ReportDate  = objHR[ind].ReportDate;
			var RefOrgName  = objHR[ind].RefOrgName;
			var RefDoctor   = objHR[ind].RefDoctor;
			var type = "hcvreferral";
			var background=""
			if(HRStatus==$g("作废")){
				var background='style="background:#C0C0C0;'
			}
			htmlStr =  '<div class="card-div" id=CardEpd'+HRID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport( \'' + type + '\',\'' + HRID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repstatus+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport( \'' + type + '\',\'' + HRID + '\')">'+HRStatus+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repname+'：</span></td><td>'+PatName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repidnum+'：</span></td><td>'+PersonalID+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repdate+'：</span></td><td>'+ReportDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repreforg+'：</span></td><td>'+RefOrgName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+reprefdoc+'：</span></td><td>'+RefDoctor+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	//新诊断报告丙肝病例个案调查表
	obj.LoadHCVData = function() {
		var strHCVList =$m({
			ClassName:"DHCMed.EPDService.HCVReportSrv",
			QueryName:"QryReportByPat",
			ResultSetType:'array',
			aPatientID: PatientID
		}, false);
		var objHCV = JSON.parse(strHCVList);
		var HCVlen = objHCV.length;
		if (HCVlen<1) return;
	  
		//多语言处理增加翻译
		var repTitle	 = $g('新诊断报告丙肝病例个案调查');
		var replsh 	 	 = $g('流水号');
		var repSt 		 = $g('报告状态');
		var repjcrq 	 = $g('检测日期');
		var repjcff 	 = $g('检测方法');
		var repjcyy 	 = $g('检测原因');
		var repfjrq 	 = $g('复检日期');
		var repbgjg 	 = $g('丙肝结果');
		var repzjjg 	 = $g('转介结果');
		var reptbrq 	 = $g('填报日期');
		var repthly 	 = $g('退回理由');
		
		var htmlStr ='';
		for (var ind=0; ind<HCVlen;ind++) {
			var HCVID         = objHCV[ind].RepoetID;
			var SerialNum     = objHCV[ind].SerialNum;
			var Status        = objHCV[ind].StatusDesc;
			var TestPosDate   = objHCV[ind].TestPosDate;
			var TestMethod    = objHCV[ind].TestMethodDesc;
			var TestReason    = objHCV[ind].TestReasonDesc;
			var RecheckDate   = objHCV[ind].RecheckDate;
			var NucleinRet    = objHCV[ind].NucleinRetDesc;
			var ReferResult   = objHCV[ind].ReferResultDesc;
			var RepDate	      = objHCV[ind].RepDate;
			var Reason		  = objHCV[ind].Reason;
		
			var background=""
			if(Status=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			
			htmlStr =  '<div class="card-div" id=CardHCV'+HCVID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenHcvRep(\'' +HCVID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+replsh+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenHcvRep(\'' + HCVID + '\')">'+SerialNum+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repjcrq+'：</span></td><td>'+TestPosDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repjcff+'：</span></td><td>'+TestMethod+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repjcyy+'：</span></td><td>'+TestReason+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repfjrq+'：</span></td><td>'+RecheckDate+'</td></tr>'		
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgjg+'：</span></td><td>'+NucleinRet+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzjjg+'：</span></td><td>'+ReferResult+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+reptbrq+'：</span></td><td>'+RepDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repthly+'：</span></td><td>'+Reason+'</td></tr>'			
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
	  
		//多语言处理增加翻译
		var repTitle	 = $g('新冠病毒感染个案调查');
		var repwjbh 	 = $g('问卷编号');
		var repSt 		 = $g('报告状态');
		var repfbrq 	 = $g('发病日期');
		var repzztz	 	 = $g('症状体征');
		var repbfz 	 	 = $g('并发症');
		var repjwbs 	 = $g('既往病史');
		var repyzcd	 	 = $g('严重程度');
		var repblfl 	 = $g('病例分类');
		var repdcsj	 	 = $g('调查时间');
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
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenNCPReport(\'' +NCPID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repwjbh+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenNCPReport(\'' + NCPID + '\')">'+CardNo+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repfbrq+'：</span></td><td>'+SickDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzztz+'：</span></td><td>'+SymPtom+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbfz+'：</span></td><td>'+Complication+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repjwbs+'：</span></td><td>'+PreAnamnesis+'</td></tr>'		
			htmlStr += 					'<tr><td class="card-td"><span>'+repyzcd+'：</span></td><td>'+Severity+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repblfl+'：</span></td><td>'+DiagDegree+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repdcsj+'：</span></td><td>'+RepDateTime+'</td></tr>'
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
	
		//多语言处理增加翻译
		var repTitle	 = $g('HIV个案随访表');
		var rephzxm 	 = $g('患者姓名');
		var repsfzt 	 = $g('随访状态');
		var repqzrq 	 = $g('确诊日期');
		var repsfdw 	 = $g('随访单位');
		var repsfr 	 	 = $g('随访人');
		var repsfrq 	 = $g('随访日期');
		
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
			htmlStr += 		'<div class="card-title"><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + HIVID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rephzxm+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + HIVID + '\')">'+txtPatName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repsfzt+'：</span></td><td>'+txtFollowStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repqzrq+'：</span></td><td>'+txtHIVDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repsfdw+'：</span></td><td>'+txtSurveyOrgan+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repsfr+'：</span></td><td>'+txtSurveyName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repsfrq+'：</span></td><td>'+txtSurveyDate+'</td></tr>'
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
		
		//多语言处理增加翻译
		var repbglx	 	 = $g('报告类型');
		var repzzrq 	 = $g('转诊日期');
		var repbgzt 	 = $g('报告状态');
		var repzzdw 	 = $g('转诊单位');
		var repbgsj 	 = $g('报告时间');
		var repbgr 	 	 = $g('报告人');
		
		var htmlStr ='';
		for (var ind=0; ind<Reflen;ind++) {
			var RefID        = objRef[ind].ReportID;    			                //reportid
			var ReportName   = $g('肺结核转诊单');
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
			htmlStr += 					'<tr><td class="card-td"><span>'+repbglx+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + RefID + '\')">'+ReportName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzzrq+'：</span></td><td>'+ReferralDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgzt+'：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzzdw+'：</span></td><td>'+ReferralHosp +'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgsj+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgr+'：</span></td><td>'+RepUserName+'</td></tr>'					
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
	
		//多语言处理增加翻译
		var repbglx	 	 = $g('报告类型');
		var repzzrq 	 = $g('诊断日期');
		var repbgzt 	 = $g('报告状态');
		var repzzdw 	 = $g('报告科室');
		var repbgsj 	 = $g('报告时间');
		var repbgr 	 	 = $g('报告人');
		var repshsj 	 = $g('审核时间');
		var repshr 	 	 = $g('审核人');
		
		var htmlStr ='';
		for (var ind=0; ind<ILIlen;ind++) {
			var ILIID         = objILI[ind].ReportID;    			 //reportid
			var ReportName    = $g('流感样病例登记');
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
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + ILIID + '\')">'+ReportName+'</a></span></div>'
			htmlStr += 		'<div class="card-epd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbglx+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenEPDReport(\'' + type +'\',\'' + ILIID + '\')">'+ReportName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzzrq+'：</span></td><td>'+DiagDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgzt+'：</span></td><td>'+Status+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repzzdw+'：</span></td><td>'+ReportDep+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgsj+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repbgr+'：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repshsj+'：</span></td><td>'+CheckDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repshr+'：</span></td><td>'+CheckUserName+'</td></tr>'
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
		
		var repTitle = $g('居民死亡医学证明（推断）书');
		var repNum =$g('编号');
		var repDthResum =$g('死亡原因');
		var repDthDate=$g('死亡时间');
		var repSt =$g('报告状态');
		var repDate=$g('报告时间');
		var repLoc =$g('报告科室');
		var repName=$g('报告人');
		var repCheckDate=$g('审核时间');
		var repResum=$g('退回原因');
		
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
			var IsCASign	= objDTH[ind].IsCASign;
			var background=""
			if(RepStatus=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			var CASignHtml = ''
			if (IsCASign == 1) {
				CASignHtml = '<td style="width:20px;" title="该报告已经过CA数字签名"><img src="../skin/default/images/ca_icon_green.png"></td>'
			}
			
			htmlStr =  '<div class="card-div" id=CardDth'+DTHID+'>'	
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-dth">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repNum+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">'+DeathNo+'</a></td>'+ CASignHtml +'</tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDthResum+'：</span></td><td><a class="hisui-tooltip" title='+BaseReason+'>'+BaseReason+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDthDate+'：</span></td><td>'+DthDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenDTHReport(\'' + DTHID + '\')">'+RepStatus+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repLoc+'：</span></td><td>'+RepLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repName+'：</span></td><td>'+RepUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repCheckDate+'：</span></td><td>'+CheckDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repResum+'：</span></td><td>'+ReturnReason+'</td></tr>'
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
		//多语言处理增加翻译
		var repTitle = $g('医院感染报告');
		var repTyte =$g('报告类型');
		var repInfDate =$g('感染日期');
		var repInfZd =$g('感染诊断');
		var repInfType =$g('感染分类');
		var repSt =$g('报告状态');
		var repDate=$g('报告时间');
		var repInfBb=$g('检验标本');
		var repInfByt=$g('病原体');
		var repThyy=$g('退回原因');
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
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenHAIReport(\'' + HAIID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repTyte+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenHAIReport(\'' + HAIID + '\')">'+RepTypeDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfDate+'：</span></td><td>'+InfDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfZd+'：</span></td><td><a class="hisui-tooltip" title='+InfPos+'>'+InfPos+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfType+'：</span></td><td><a class="hisui-tooltip" title='+InfDiag+'>'+InfDiag+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfBb+'：</span></td><td>'+Specimen+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfByt+'：</span></td><td><a class="hisui-tooltip" title='+TestResults+'>'+TestResults+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repThyy+'：</span></td><td>'+BackOpinion+'</td></tr>'
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
		//多语言处理增加翻译
		var repTitle = $g('多耐细菌报告');
		var repSjks =$g('送检科室');
		var repSjDate =$g('送检日期');
		var repSjbb =$g('送检标本');
		var repSt =$g('报告状态');
		var repDate=$g('报告时间');
		var repInfLX=$g('感染类型');
		var repInfByt=$g('细菌名称');
		var repGlfs=$g('隔离方式');
		var repJCGL=$g('接触隔离');
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
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenMBRReport(\'' + MBRRepID + '\',\'' + LabRepID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfByt+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenMBRReport(\'' + MBRRepID + '\',\'' + LabRepID + '\')">'+MRBDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSjDate+'：</span></td><td>'+SubmissDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSjbb+'：</span></td><td>'+SpecDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSjks+'：</span></td><td>'+LocDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repInfLX+'：</span></td><td>'+InfTypeDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repGlfs+'：</span></td><td>'+InsulatDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repJCGL+'：</span></td><td><a class="hisui-tooltip" title='+ContactListDesc+'>'+ContactListDesc+'</a></td></tr>'
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
		//多语言处理增加翻译
		var repTitle = $g('手术切口调查');
		var repSsmc =$g('手术名称');
		var repSslx =$g('手术类型');
		var repSssj =$g('手术时间');
		var repSt =$g('报告状态');
		var repDate=$g('报告时间');
		var repSsjssj=$g('结束时间');
		var repQkyh=$g('切口愈合');
		var repFxfj=$g('风险分级');
		var repASAPF=$g('ASA评分');
		
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
			htmlStr += 		'<div class="card-title" '+background+'><span><a ref="#" onclick="objScreen.OpenOPSReport(\'' + ReportID + '\',\'' + OPSID + '\',\'' + OperAnaesID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-hai">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSsmc+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenOPSReport(\'' + ReportID + '\',\'' + OPSID + '\',\'' + OperAnaesID + '\')">'+OperName+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSslx+'：</span></td><td>'+OperType+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSssj+'：</span></td><td>'+OperSttDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSsjssj+'：</span></td><td>'+OperEndDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repQkyh+'：</span></td><td>'+CuteType+'/'+CuteHealing+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+ReportStatus+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repFxfj+'：</span></td><td>'+NNISLevel+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repASAPF+'：</span></td><td>'+ASADesc+'</td></tr>'
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
		
		var repTitle = $g('精神疾病报告卡');
		var repType =$g('报卡类型');
		var disDesc =$g('疾病名称');
		var sickDate =$g('发病日期');
		var repStatic =$g('报告状态');
		var repLoc =$g('报告科室');
		var repDate=$g('报告时间');
		var repUser=$g('报告人');
		var checkDate=$g('审核时间');
		var checkUser=$g('审核人');
	
		
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
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenSMDReport(\'' + SMDID + '\')">'+ repTitle +'</a></span></div>'
			htmlStr += 			'<div class="card-smd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repType+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenSMDReport(\'' + SMDID + '\')">'+RepTypeDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+disDesc+'：</span></td><td><a class="hisui-tooltip" title='+DiseaseDesc+'>'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+sickDate+'：</span></td><td>'+SickDate+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repLoc+'：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repStatic+'：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repUser+'：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+checkDate+'：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+checkUser+'：</span></td><td>'+ChkUserName+'</td></tr>'
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
		
		var repTitle = $g('食源性疾病');
		var DiseaseName =$g('疾病名称');
		var disDesc =$g('疾病分类');
		var sickDate =$g('发病时间');
		var repLoc =$g('报告科室');
		var repStatic =$g('报告状态');
		var repDate=$g('报告时间');
		var repUser=$g('报告人');
		var checkDate=$g('审核时间');
		var checkUser=$g('审核人');
		var BackReason=$g('退回原因');
		
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
			var Resume		 = objFBD[ind].Resume;
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardFbd'+FBDID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenFBDReport(\'FBD\',\'' + FBDID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-fdb">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+DiseaseName+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenFBDReport(\'FBD\',\'' + FBDID + '\')">'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+disDesc+'：</span></td><td><a class="hisui-tooltip" title='+DiseaseCate+'>'+DiseaseCate+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+sickDate+'：</span></td><td>'+SickDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repLoc+'：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repStatic+'：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repUser+'：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+checkDate+'：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+checkUser+'：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+BackReason+'：</span></td><td>'+Resume+'</td></tr>'
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
		
		var repTitle = $g('疑似食源性疾病');
		var rep1 = $g('主要诊断');
		var rep2 = $g('诊断备注');
		var rep3 = $g('发病时间');
		var rep4 = $g('报告科室');
		var rep5 = $g('报告状态');
		var rep6 = $g('报告时间');
		var rep7 = $g('报告人');
		var rep8 = $g('审核时间');
		var rep9 = $g('审核人');
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
			htmlStr += 		'<div class="card-title"'+background+'><span style="cursor:pointer;"><a ref="#" onclick="objScreen.OpenFBDReport(\'SUS\',\'' + SusAbID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-fdb">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep1+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenFBDReport(\'SUS\',\'' + SusAbID + '\')">'+DiseaseDesc+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep2+'：</span></td><td><a class="hisui-tooltip" title='+DiseaseCate+'>'+DiseaseCate+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep3+'：</span></td><td>'+SickDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep4+'：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep5+'：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep6+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep7+'：</span></td><td>'+RepUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep8+'：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+rep9+'：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr +=       '<div>'
			htmlStr += '<div>'
			
			$("#cardlist").append(htmlStr);		
		}
	}
	
	
		
	
		
	// 慢病
	obj.LoadCDData = function() {
		var strCDList =$m({
			ClassName:"DHCMed.CDService.QryService",
			QueryName:"QryRepByPatientID",
			ResultSetType:'array',
			aPatientID: PatientID,
		}, false);
		var objCD = JSON.parse(strCDList);
		var CDlen = objCD.length;
		if (CDlen<1) return;
		
		var htmlStr ='';
		
		var repTitle = $g('重大非传染性疾病管理');
		var repNum =$g('卡片编号');
		var repCardType =$g('报告类型');
		var repLoc =$g('报告科室');
		var repSt =$g('报告状态');
		var repDate=$g('报告时间');
		var repName=$g('报告人');
		var repCheckDate=$g('审核时间');
		var repCheckName=$g('审核人');
		var repResum=$g('退回原因');
		
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
			var DelReason  	 = objCD[ind].DelReason;	
			var background=""		
			if(StatusDesc=="作废"){
				var background='style="background:#C0C0C0;"'
			}
			htmlStr =  '<div class="card-div" id=CardCD'+CDID+'>'
			htmlStr += 		'<div class="card-title"'+background+'><span><a ref="#" onclick="objScreen.OpenCDReport(\'' + RepType + '\',\'' + CDID + '\')">'+repTitle+'</a></span></div>'
			htmlStr += 		'<div class="card-cd">'
			htmlStr += 			'<table class="card-table">'
			htmlStr += 				'<tbody>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repNum+'：</span></td><td><a ref="#" style="color:blue" onclick="objScreen.OpenCDReport(\'' + RepType + '\',\'' + CDID + '\')">'+KPBH+'</a></td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repCardType+'：</span></td><td>'+RepTypeDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repLoc+'：</span></td><td>'+ReportLoc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repSt+'：</span></td><td>'+StatusDesc+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repDate+'：</span></td><td>'+RepDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repName+'：</span></td><td>'+ReportUser+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repCheckDate+'：</span></td><td>'+ChkDateTime+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repCheckName+'：</span></td><td>'+ChkUserName+'</td></tr>'
			htmlStr += 					'<tr><td class="card-td"><span>'+repResum+'：</span></td><td>'+DelReason+'</td></tr>'
			htmlStr += 				'</tbody>'
			htmlStr += 			'</table>'
			htmlStr += 		'<div>'
			htmlStr += '<div>'
			$("#cardlist").append(htmlStr);		
		}
			
	}
	InitClinRepToAdmWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}