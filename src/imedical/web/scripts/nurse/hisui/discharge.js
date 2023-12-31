/*
 * author pengjunfu 2018-8-25
 * 新出院
 */

$(function() {
	$("#needCareOrderDlg").dialog('close');
	var BaseInfoLayOutInit = function() {
	};
var BaseInfoInitValue = function() {

	var baseInfoStr = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeInfo", EpisodeID);
	var baseInfoArray = baseInfoStr.split("^");
	$("#EstimDischargeDate").val(baseInfoArray[0]);
	$("#EstimDischargeTime").val(baseInfoArray[1]);
	$("#DischgDate").val(baseInfoArray[2]);
	$("#DischgTime").val(baseInfoArray[3]);
	$("#EstimDischargeDoctor").val(baseInfoArray[4]);
	$("#DischNurse").val(baseInfoArray[5]);
	$("#DeceasedDate").val(baseInfoArray[6]);
	$("#DeceasedTime").val(baseInfoArray[7]);
	$("#DischCond").val(baseInfoArray[8]);
	var DischgDays=baseInfoArray[9];
	
	$("#UserCode").val(session['LOGON.USERCODE']);

	var info = tkMakeServerCall("web.DHCNurIpComm", "NurPatInfo", EpisodeID);
	$("#PatInfo").val(info.split("^")[0]);
	$("#PatRegNo").val(info.split("^")[4]);
	$("#PatAdminDateTime").val(info.split("^")[5]);
	//UserPassword
	var UpdateBtn = $("#Update");


	while (true) {
		//护士召回
		if (type == "R") {
			if ((recallLimitDays!="")&&(parseInt(DischgDays)>parseInt(recallLimitDays))) {
				$.messager.alert("提示", "仅允许召回"+recallLimitDays+"天内出院的患者！", 'error');
				$("#Update").hide();
				return false;
			}
			otherAlertAbnormalOrder("DischRecall",$g("召回"));
			getPatLockFlag();
			GetInsuUpFlagByAdm();
			UpdateBtn.find(".l-btn-text").html($g("召回"));
			UpdateBtn.bind("click", function() {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					RecallPatient(userId)
				} else {
					$.messager.alert("提示", ret, 'info');
				};
			})
			break;
		};
		//护士办理出院
		if (type == "F") {
			$("#DischgDate").prop("disabled",false);
			$("#DischgTime").prop("disabled",false);
			AlertAbnormalOrder();
			checkBabyByMother();
			UpdateBtn.find(".l-btn-text").html($g("出院"));
			UpdateBtn.bind("click", function() {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					NurseDischarge(userId)
				} else {
					$.messager.alert("提示", ret, 'info');
				};
				
			})
			break;
		};
		//护士终止费用调整
		if (type == "T") {
			otherAlertAbnormalOrder("EndCostAdjust",$g("结束费用调整"));
			UpdateBtn.find(".l-btn-text").html($g("结束费用调整"));
			UpdateBtn.css("width","150px")
			UpdateBtn.bind("click", function() {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					TerminalRecallPatientForBill(userId)
				} else {
					$.messager.alert("提示", ret, 'info');
				};
			})
			break;
		};
		//护士费用调整
		if (type == "B") {
			otherAlertAbnormalOrder("CostAdjust",$g("费用调整"));
			getPatLockFlag();
			GetInsuUpFlagByAdm();
			UpdateBtn.find(".l-btn-text").html($g("费用调整"));
			UpdateBtn.css("width","130px")
			UpdateBtn.bind("click", function() {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					RecallPatientForBill(userId)
				} else {
					$.messager.alert("提示", ret, 'info');
				};
			})
			break;
		};
		$("#Update").css("display","none");
		break;
	}

};
var otherAlertAbnormalOrder = function(abnormalType,title) {
	if (abnormalType=="EndCostAdjust"){
		var RoleLevel=tkMakeServerCall("web.DHCIPBillCheckAdmCost","GetLevelCfg",session['LOGON.HOSPID']);
		var retStr = tkMakeServerCall("web.DHCDischargeHistory", "nurSettlementCheck", EpisodeID)
		if (retStr != 0) {
			$.messager.confirm("费用核查提示", "患者住院费用核查未通过,原因:"+retStr+((RoleLevel==2&&(session['LOGON.GROUPDESC'].indexOf("护士长")<0))?"如您已审核，请转告护士长审核":""), function (success) {
				if (success) {
					var obj=getWidthHeightObj();
					billWin=websys_createWindow("dhcbill.ipbill.checkadmfee.csp?RoleLevel="+(session['LOGON.GROUPDESC'].indexOf("护士长")>=0?RoleLevel:1)+"&EpisodeID="+EpisodeID,"","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"");
					var timerBill=setInterval(function(){
						// 需关注界面关闭后，出院界面也关闭
						if(billWin != null && billWin.closed){
							clearInterval(timerBill);
							billWin = null;
							close();	
						}	
					},500)
				}
			});
			$("#Update").css("display","none");
			return;
		}
	}
	//var retStr = tkMakeServerCall("Nur.HISUI.NeedCareOrder", "getAbnormalOrder", EpisodeID,"NURSE","D")
	var retArr=$cm({
		ClassName: "Nur.NIS.Service.Base.Transfer",
		MethodName: 'getAbnormalOrder',
		episodeID:EpisodeID,
		abnormalType: abnormalType //"Disch"
	},false)
	if (retArr.length>0){
		var ifCanOper=retArr[0].ifCanOper;
		var ifOtherCanOper=retArr[0].ifOtherCanOper;
		var abnormalMsgArr=retArr[0].abnormalMsgs;
		var otherAbnormalMsgs=retArr[0].otherAbnormalMsgs;
		$("#needCareOrderDlg").dialog('open');
		$('#confirmBtn').unbind('click');
		$('#confirmBtn').bind('click', function(){
			var obj=getWidthHeightObj();
			abnormWin=websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+EpisodeID+"&defaultTypeCode=D","","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
			var timerAbnorm=setInterval(function(){
				// 需关注界面关闭后，出院界面也关闭
				if(abnormWin != null && abnormWin.closed){
					clearInterval(timerAbnorm);
					abnormWin = null;
					close();	
				}	
			},500)
		});
		$('#cancelBtn').bind('click', function(){
			$("#needCareOrderDlg").dialog('close');
		});
		var alertMsgArr=[];
		for (var i=0;i<abnormalMsgArr.length;i++){
			var style=abnormalMsgArr[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
			alertMsgArr.push("<span style='"+style+"'>"+abnormalMsgArr[i].abnormalMsg+"</span>");	
		}
		var otherAlertMsgArr=[];
		for (var i=0;i<otherAbnormalMsgs.length;i++){
			var linkUrl=otherAbnormalMsgs[i].linkUrl;
			var style=otherAbnormalMsgs[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
			if (linkUrl){
				style+="text-decoration:underline;";
				otherAlertMsgArr.push("<a href='#' style='"+style+"' onclick=openOtherAbnormalMsgLink('"+EpisodeID+"','"+linkUrl+"','"+otherAbnormalMsgs[i].abnormalMsg+"')>"+otherAbnormalMsgs[i].abnormalMsg+"</a>");
			}else{
				otherAlertMsgArr.push("<span style='"+style+"'>"+otherAbnormalMsgs[i].abnormalMsg+"</span>");
			}
		}
		var otherAlertMsg=otherAlertMsgArr.join(" ");
		var alertMsg=alertMsgArr.join(" ");
		if (alertMsg!=""){
			if(ifCanOper=="0"){
				$("#needCareOrderDlg .dialog-content").html("存在 "+alertMsg + " " +otherAlertMsg + "是否立即处理?");
				if(ifOtherCanOper=="1"){
					$("#Update").hide();
				}
			}else{
				$("#needCareOrderDlg .dialog-content").html("存在 "+alertMsg + " " +otherAlertMsg +" 不能"+ title+ ",请先处理!")
				$("#Update").css("display","none");
				$("#cancelBtn").css("display","none");
			}
		}else if(otherAlertMsg!=""){
			if(ifOtherCanOper=="0"){
				$("#needCareOrderDlg .dialog-content").html("存在 "+otherAlertMsg);
			}else{
				$("#needCareOrderDlg .dialog-content").html("存在 "+otherAlertMsg +" 不能"+title+",请先处理!")
				$("#Update").hide();
				$("#confirmBtn").hide();
			}
			$("#cancelBtn").show();
		}
		return;
	}
}
var Refresh=function(){
	if(window.opener){
			//window.opener.location.reload();
			if(window.opener.parent.window.frames['TRAK_main']){
				window.opener.parent.window.frames['TRAK_main'].location.reload();
			}else{
				window.opener.location.reload();
			}
			window.close();
		}else{
			var lnk = "epr.default.csp";
			window.location = lnk;
		}
}
var RecallPatient = function(userId) {
	var coderet = tkMakeServerCall("web.DHCBillInterface","IGetCodingFlag",EpisodeID);
	if(coderet!="N"){
		$.messager.alert("提示", "财务已经审核，请撤销后召回!");
		return ;
	}

	var ret = tkMakeServerCall("web.DHCDischargeHistory", "RecallPatient", EpisodeID, userId);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
	}
};
var NurseDischarge = function(userId) {	
	var date = $("#DischgDate").val();
	var time = $("#DischgTime").val();	
	var ret = tkMakeServerCall("web.DHCDischargeHistory", "NurseDischarge", EpisodeID, userId, date, time);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
		
		
	}
};
var RecallPatientForBill = function(userId) {
	var ret = tkMakeServerCall("web.DHCDischargeHistory", "RecallPatientForBill", EpisodeID, userId);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
	}
};

var TerminalRecallPatientForBill = function(userId) {

	var ret = tkMakeServerCall("web.DHCDischargeHistory", "TerminalRecallPatientForBill", EpisodeID, userId);
	if (ret != "0") {
		$.messager.alert("提示", ret, 'info');
	} else {
		$.messager.alert("提示", "操作成功!", 'info');
		Refresh()
	}
};

var ConfirmPassWord = function() {
	var UserCode = $("#UserCode").val();
	var UserPassword = $("#UserPassword").val();
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "ConfirmUserPIN", UserCode, UserPassword);
	return ret;
};

var GetInsuUpFlagByAdm = function() {
	var retStr = tkMakeServerCall("web.DHCINSUPort", "GetInsuUpFlagByAdm", EpisodeID, "")
	if (retStr > 0) {
		$.messager.alert("提示", "医保已经结算或上传,不能办理该操作", 'info');
		$("#Update").hide();
	};
}

var getPatLockFlag = function() {
	var flag = tkMakeServerCall("Nur.DHCADTDischarge","getPatLockFlag",EpisodeID);
	if (flag!="") {
		$.messager.alert("提示", "该患者被以下锁定 "+ flag, 'info');
		$("#Update").hide();
		return;
	}else{
		var ret=tkMakeServerCall("Nur.DHCADTDischarge","setPatLockDischarge",EpisodeID,session['LOGON.USERID'],session['LOGON.CTLOCID']);
	}
}

var checkBabyByMother=function(){
	var ifBabyBillAM = tkMakeServerCall("Nur.DHCADTDischarge", "getBabyBillConf");
	if(ifBabyBillAM=="Y"){
		var ret = tkMakeServerCall("Nur.DHCADTDischarge", "checkBabyByMother", EpisodeID);
		if(ret!=0){
			$.messager.alert("提示", "其婴儿："+ret, 'info');
			$("#Update").hide();
			return;
		}
	}
}
var AlertAbnormalOrder = function() {
	var retStr = tkMakeServerCall("web.DHCDischargeHistory", "ifDoctorDischarge", EpisodeID);
	if (retStr != "1") {
		$.messager.alert("提示", "医生未做医疗结算,不能办理出院!", 'info');
		$("#Update").css("display","none");
		return;
	}
	var retStr = tkMakeServerCall("web.DHCDischargeHistory", "nurSettlementCheck", EpisodeID)
	if (retStr != 0) {
		var RoleLevel=tkMakeServerCall("web.DHCIPBillCheckAdmCost","GetLevelCfg",session['LOGON.HOSPID']);
		$.messager.confirm("费用核查提示", "患者住院费用核查未通过,原因:"+retStr+((RoleLevel==2&&(session['LOGON.GROUPDESC'].indexOf("护士长")<0))?"如您已审核，请转告护士长审核":""), function (success) {
			if (success) {
				var obj=getWidthHeightObj();
				billWin=websys_createWindow("dhcbill.ipbill.checkadmfee.csp?RoleLevel="+(session['LOGON.GROUPDESC'].indexOf("护士长")>=0?RoleLevel:1)+"&EpisodeID="+EpisodeID,"","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"");
				var timerBill=setInterval(function(){
					// 需关注界面关闭后，出院界面也关闭
					if(billWin != null && billWin.closed){
						clearInterval(timerBill);
						billWin = null;
						close();	
					}	
				},500)
			}
		});
		$("#Update").css("display","none");
		return;
	}
	retStr = tkMakeServerCall("web.DHCCAbFeeCheck", "GetCheckFeeFinal", EpisodeID, "")
	if (retStr != "") {	
		$.messager.alert("提示", retStr, 'info');
		$("#Update").css("display","none");
		return;

	}
	var ifCanOper=0,ifOtherCanOper=0,MsgArr=[];
	var retArr=$cm({
        ClassName: "Nur.NIS.Service.Base.Transfer",
        MethodName: 'getAbnormalOrder',
        episodeID:EpisodeID,
        abnormalType: "Disch"
    },false)
    if (retArr.length>0){
	    var ifCanOper=retArr[0].ifCanOper;
	    var ifOtherCanOper=retArr[0].ifOtherCanOper;
	    var abnormalMsgArr=retArr[0].abnormalMsgs;
	    var otherAbnormalMsgs=retArr[0].otherAbnormalMsgs;
	    $("#needCareOrderDlg").dialog('open');
		$('#confirmBtn').unbind('click');
		$('#confirmBtn').bind('click', function(){
			var obj=getWidthHeightObj();
			var abnormWin2=websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+EpisodeID+"&defaultTypeCode=D","","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
			var timerAbnorm2=setInterval(function(){
				// 需关注界面关闭后，出院界面也关闭
				if(abnormWin2 != null && abnormWin2.closed){
					clearInterval(timerAbnorm2);
					abnormWin2 = null;
					close();	
				}	
			},500)
		});
		$('#cancelBtn').bind('click', function(){
			$("#needCareOrderDlg").dialog('close');
		});
		var alertMsgArr=[];
		for (var i=0;i<abnormalMsgArr.length;i++){
			var style=abnormalMsgArr[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
			alertMsgArr.push("<span style='"+style+"'>"+abnormalMsgArr[i].abnormalMsg+"</span>");
		}
		var otherAlertMsgArr=[];
		for (var i=0;i<otherAbnormalMsgs.length;i++){
			var linkUrl=otherAbnormalMsgs[i].linkUrl;
			var style=otherAbnormalMsgs[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
			if (linkUrl){
				style+="text-decoration:underline;";
				otherAlertMsgArr.push("<a href='#' style='"+style+"' onclick=openOtherAbnormalMsgLink('"+EpisodeID+"','"+linkUrl+"','"+otherAbnormalMsgs[i].abnormalMsg+"')>"+otherAbnormalMsgs[i].abnormalMsg+"</a>");
			}else{
				otherAlertMsgArr.push("<span style='"+style+"'>"+otherAbnormalMsgs[i].abnormalMsg+"</span>");
			}
		}
		var otherAlertMsg=otherAlertMsgArr.join(" ");
		var alertMsg=alertMsgArr.join(" ");
		/*if (alertMsg!=""){
			if(ifCanOper=="0"){
				$("#needCareOrderDlg .dialog-content").html("存在 "+alertMsg + " " +otherAlertMsg + "是否立即处理?");
				if(ifOtherCanOper=="1"){
					$("#Update").hide();
				}
			}else{
				$("#needCareOrderDlg .dialog-content").html("存在 "+alertMsg + " " +otherAlertMsg + "不能出院,请先处理!")
				$("#Update").css("display","none");
				$("#cancelBtn").css("display","none");
			}
		}else if(otherAlertMsg!=""){
			if(ifOtherCanOper=="0"){
				$("#needCareOrderDlg .dialog-content").html("存在 "+otherAlertMsg);
			}else{
				$("#needCareOrderDlg .dialog-content").html("存在 "+otherAlertMsg +"不能出院,请先处理!")
				$("#Update").hide();
				$("#confirmBtn").hide();
			}
			$("#cancelBtn").show();
		}*/
		if (alertMsg==""){
			$("#confirmBtn").hide();
		}
		if (alertMsg!=""){
			if(ifCanOper=="0"){
				MsgArr.push("患者存在"+alertMsg + " " +otherAlertMsg+"是否立即处理?");
			}else{
				MsgArr.push("患者存在"+alertMsg + " " +otherAlertMsg+"不能出院,请先处理!");
				$("#Update").hide();
			}
			if(ifOtherCanOper=="1"){
				$("#Update").hide();
			}
		}else if(otherAlertMsg!=""){
			if(ifOtherCanOper=="0"){
				MsgArr.push("患者存在"+otherAlertMsg);
			}else{
				MsgArr.push("患者存在"+otherAlertMsg+"不能出院,请先处理!");
				$("#Update").hide();
			}
		}
		//return;
	}
	var babyIfCanOper=0,babyIfOtherCanOper=0,babyAlertMsgArr=[];
	var ifBabyBillAM = tkMakeServerCall("Nur.DHCADTDischarge", "getBabyBillConf");
	if(ifBabyBillAM=="Y"){
		var retArr=$cm({
	        ClassName: "Nur.HISUI.NeedCareOrder",
	        MethodName: 'getBabyAbnormalOrderByMother',
	        motherEpisodeID:EpisodeID,
	        CtcpType: "NURSE",
	        AbnormalType:"D"
	    },false)
		if (retArr.length>0){
			 if (!MsgArr.length){
				 $("#needCareOrderDlg").dialog('open');
				 $('#confirmBtn').hide();
				 $('#confirmBtn').unbind('click');
				 $('#cancelBtn').bind('click', function(){
					$("#needCareOrderDlg").dialog('close');
				});
		     }
			babyAlertMsgArr.push("患者婴儿");
			for (var babyIndex=0;babyIndex<retArr.length;babyIndex++){
				var oneBabyIfCanOper=retArr[babyIndex].ifCanOper;
			    var oneBabyIfOtherCanOper=retArr[babyIndex].ifOtherCanOper;
			    var oneBabyAbnormalMsgArr=retArr[babyIndex].abnormalMsgs;
			    var oneBabyOtherAbnormalMsgs=retArr[babyIndex].otherAbnormalMsgs;
			    var babyName=retArr[babyIndex].babyName;
			    var babyAdmId=retArr[babyIndex].babyAdmId;
			    if (oneBabyIfCanOper==1) babyIfCanOper=oneBabyIfCanOper;
			    if (oneBabyIfOtherCanOper==1) babyIfOtherCanOper=oneBabyIfOtherCanOper;
				var oneBabyAlertMsgArr=[];
				for (var i=0;i<oneBabyAbnormalMsgArr.length;i++){
					var style=oneBabyAbnormalMsgArr[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
					oneBabyAlertMsgArr.push("<span style='"+style+"'>"+oneBabyAbnormalMsgArr[i].abnormalMsg+"</span>");
				}
				var oneBabyOtherAlertMsgArr=[];
				for (var i=0;i<oneBabyOtherAbnormalMsgs.length;i++){
					var style=oneBabyOtherAbnormalMsgs[i].ifCanOper ==1?"color:red;":"color:#589DDA;";
					if (linkUrl){
						style+="text-decoration:underline;";
						oneBabyOtherAlertMsgArr.push("<a href='#' style='"+style+"' onclick=openOtherAbnormalMsgLink('"+babyAdmId+"','"+linkUrl+"','"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"')>"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"</a>");
					}else{
						oneBabyOtherAlertMsgArr.push("<span style='"+style+"'>"+oneBabyOtherAbnormalMsgs[i].abnormalMsg+"</span>");
					}
				}
				var oneBabyOtherAlertMsg=oneBabyOtherAlertMsgArr.join(" ");
				var oneBabyAlertMsg=oneBabyAlertMsgArr.join(" ");
				if (oneBabyAlertMsg!=""){
					babyAlertMsgArr.push("<a href='#' class='babyNameLink' onclick='openBabyOrderNeedCare("+babyAdmId+")'>"+babyName+"</a>"+" 存在 "+oneBabyAlertMsg + " " +oneBabyOtherAlertMsg+";");
				}else{
					babyAlertMsgArr.push(+babyName+" 存在 "+oneBabyAlertMsg + " " +oneBabyOtherAlertMsg+";");
				}
			}
			if ((babyIfCanOper==1)||(babyIfOtherCanOper==1)) babyAlertMsgArr.push("不能出院,请点击婴儿名称处理!");
		}
	}
	if (babyAlertMsgArr.length) MsgArr.push(babyAlertMsgArr.join("<br/>"));
	if (MsgArr.length) $("#needCareOrderDlg .dialog-content").html(MsgArr.join("<br/>"))
	return;
}
	BaseInfoLayOutInit();
	BaseInfoInitValue()
	
});
function getWidthHeightObj(){
	var iHeight=window.screen.height-150;
	var iWidth=window.screen.width-50;
	var iTop=(window.screen.height-30-iHeight)/2;
	var iLeft=(window.screen.width-30-iWidth)/2;
	return {
		iHeight:iHeight,
		iWidth:iWidth,
		iTop:iTop,
		iLeft:iLeft
	};
}
var openBabyOrderNeedCare=function(babyAdmId) {
	var obj=getWidthHeightObj();
	var abnormWin2=websys_createWindow("../csp/nur.hisui.orderNeedCare.csp?EpisodeID="+babyAdmId+"&defaultTypeCode=D","","top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
}
var openOtherAbnormalMsgLink=function(episodeID,linkUrl,title){
	var obj=getWidthHeightObj();
	var abnormWin2=websys_createWindow(linkUrl+"?EpisodeID="+episodeID,title,"top="+obj.iTop+",left="+obj.iLeft+",width="+obj.iWidth+",height="+obj.iHeight+"")
}