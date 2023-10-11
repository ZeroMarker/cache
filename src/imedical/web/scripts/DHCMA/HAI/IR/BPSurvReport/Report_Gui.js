﻿var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var obj = new Object();
function InitReportWin(ActFlag)
{
	// 初始化模块
	obj.RepStatusCode = "";
	obj.PAEpisodeID = "" ;
	obj.AdminPower = AdminPower;
	obj.RepInfo = "";
	InitBPRepWinEvent(obj);
	InitBase();
	if (ActFlag==1){
		obj.LoadEvent();
	}
	// 初始化功能按钮
	obj.InitButtons();
	
	<!-- 初始化公共模板的JS -->
	InitComTemplateWin(obj);
	obj.RegExt_Refresh();
	return obj;
}
// 初始化病人基本信息
function InitBase(){
	// 初始化就诊信息
    obj.AdmInfo = $cm({
		ClassName:"DHCHAI.IRS.BPSurverySrv",
		QueryName:"QryAdmInfo",		
		aBPRegID: BPRegID,		
		aSurvNumber: SurvNumber
	},false);
	if (obj.AdmInfo.total>0) {
		var AdmInfo = obj.AdmInfo.rows[0];
		$('#Sex').val(AdmInfo.PAPatSex);
		$('#txtPatName').val(AdmInfo.PAPatName);
		$('#Age').val(AdmInfo.PAPatAge);	
		$('#txtBPRegID').val(AdmInfo.BPRegID);
		$('#txtMrNo').val(AdmInfo.PAMrNo);
		$('#txtPARegDate').val(AdmInfo.PARegDate);
		$('#txtPADiagnosis').val(AdmInfo.PADiagnosis);
		$('#txtPAAdmDoc').val(AdmInfo.PAAdmDoc);
		if (AdmInfo.RepStatus=="未调查"){
			$('#txtBPRegDate').val("");
			$('#txtBPRegUserDesc').val("");
			$('#txtBPRegLocDesc').val("");
			$('#txtRepStatus').val(AdmInfo.RepStatus);
		}else{
			$('#txtBPRegDate').val(AdmInfo.BPRegDate);
			$('#txtBPRegUserDesc').val(AdmInfo.BPRegUserDesc);
			$('#txtBPRegLocDesc').val(AdmInfo.BPRegLocDesc);
			$('#txtRepStatus').val(AdmInfo.RepStatus);
		}
		obj.RepStatusCode = AdmInfo.RepStatusCode;
		obj.PAEpisodeID = AdmInfo.PAEpisodeID;
	}
}
function InitPatChangeWin(aBPRegID,aReportID){
	BPRegID  = aBPRegID;
	ReportID = aReportID;
	InitReportWin("");
}

function InitPatWin(aFlag){
	var objS = new Object();
	//患者列表
	objS.PAAdmListLoad=function(inputParams,aChangeFlag){
		$('#ulPAAdmList').html("");
		var runQuery =$cm({
			ClassName:"DHCHAI.IRS.BPSurverySrv",
			QueryName:"QryBPPatList",
			aIntputs:inputParams,
			aSearch:aFlag,
			page:1,
			rows:9999
		},false);
		
		if(runQuery){
			var arrMap = runQuery.rows;
			tabsLength=arrMap.length;
			var strHtml=" <ul>";
			
			for (var indMap = 0; indMap < arrMap.length; indMap++){
				var rd = arrMap[indMap];
				if (!rd) continue;
				if (indMap=="0"){
					if ((aChangeFlag!=1)&&(aFlag==1)){
						InitPatChangeWin(BPRegID,ReportID);
					}else{
						InitPatChangeWin(rd["BPRegID"],rd["BPSurvID"]);
					}
					
					strHtml+="<li class='active' id=\""+rd["BPRegID"]+"\"><a href='javascript:void(0);' onclick='InitPatChangeWin(\""+rd["BPRegID"]+"\",\""+rd["BPSurvID"]+"\");' class='api-navi-tab'>"+rd["PAMrNo"]+" "+rd["PAPatName"]+"</a></li>";
					continue;
				}
				strHtml+="<li id=\""+rd["BPRegID"]+"\"><a href='javascript:void(0);' onclick='InitPatChangeWin(\""+rd["BPRegID"]+"\",\""+rd["BPSurvID"]+"\");' class='api-navi-tab'>"+rd["PAMrNo"]+" "+rd["PAPatName"]+"</a></li>";
			}
			strHtml+=" <li style='height:44px;border:none;'></li></ul>"
			$('#ulPAAdmList').html(strHtml); 
			$.parser.parse('#ulPAAdmList');
			if (arrMap.length=="0"){
				$('#Sex').val("");
				$('#txtPatName').val("");
				$('#Age').val("");	
				$('#txtBPRegID').val("");
				$('#txtMrNo').val("");
				$('#txtPARegDate').val("");
				$('#txtPADiagnosis').val("");
				$('#txtPAAdmDoc').val("");
				$('#txtBPRegDate').val("");
				$('#txtBPRegLocDesc').val("");
				$('#txtBPRegUserDesc').val("");
				$('#txtRepStatus').val("");
				InitPatChangeWin("","");
			}
		}
		if (aFlag==1){
			$(".hisui-accordion ul>li.active").removeClass('active');
			$("#"+BPRegID).addClass('active');	
		}
		$('.api-navi-tab').on('click',function(){
	        $(".hisui-accordion ul>li.active").removeClass('active'); 
	        $(this).closest("li").addClass('active');
	 	});
	 	
	}
	$HUI.radio("input[name='chkStatunit']",{
		onChecked:function(e,value){
			var Status=Common_CheckboxValue('chkStatunit');
			objS.PAAdmListLoad(inputParams+Status,"1");
		}
	});
	tmpRepStatus=Common_CheckboxValue('chkStatunit');
	if (tmpRepStatus!=""){
		RepStatus=tmpRepStatus;
	}
	if (RepStatus=="1"){
		$('#chkStatunit-UnSub').checkbox('setValue', true);
		$('#chkStatunit-UnCheck').checkbox('setValue', false);
		$('#chkStatunit-Check').checkbox('setValue', false);
	}else if(RepStatus=="2"){
		$('#chkStatunit-UnSub').checkbox('setValue', false);
		$('#chkStatunit-UnCheck').checkbox('setValue', true);
		$('#chkStatunit-Check').checkbox('setValue', false);
	}else if(RepStatus=="3"){
		$('#chkStatunit-UnSub').checkbox('setValue', false);
		$('#chkStatunit-UnCheck').checkbox('setValue', false);
		$('#chkStatunit-Check').checkbox('setValue', true);
	}else {
		$('#chkStatunit-UnSub').checkbox('setValue', true);
	}
	
	objS.PAAdmListLoad(inputParams+RepStatus,"");
	return objS;
}