var lgHospID=session['LOGON.HOSPID'];
var lgCtLocID=session['LOGON.CTLOCID'];
var lgGroupID=session['LOGON.GROUPID'];
var lgUserID=session['LOGON.USERID'];
var lgUserCode=session['LOGON.USERCODE'];
var lgParams=lgHospID+"^"+lgCtLocID+"^"+lgGroupID+"^"+lgUserID;

$(function(){
	
	initParams();
	
	///设置消息为阅读状态
	setMsgStatus();
	
	initPage();
	
	initCombobox();
	
	initBtn();	
})

function initParams(){
	USERTYPE = getParam("userType");
	AUDITID = getParam("auditId");   /// 审核结果表ID
	STACODE = getParam("stacode");   /// 必须修改-双签通过
}

function setMsgStatus(){
	if(USERTYPE=="Doctor"){
		$cm({
			ClassName:"web.DHCPRESCReviewReply",
			MethodName:"SetMsgStatus",
			"AuditID":AUDITID,
			"UserType":USERTYPE,
			"LgParams":lgParams,
			dataType:"text"
		},function(ret){
			if(ret==0){
				console.log("设置阅读成功!");
			}else{
				console.log("设置阅读失败!");
			}
		});	
	}
}

function initPage(){
	
	$cm({
		ClassName:"web.DHCPRESCReviewReply",
		MethodName:"JsonReviewReplyData",
		"AuditID":AUDITID
	},function(jsonRet){
		$("#patName").html(jsonRet.PatName);
		$("#patSex").html(jsonRet.PatSex);
		$("#patAge").html(jsonRet.PatAge);
		$("#patNo").html(jsonRet.PatNo);
		$("#patLoc").html(jsonRet.PatLoc);
		var PatDiagDesc = jsonRet.PatDiagDesc;
		var diagLen = PatDiagDesc.length;
		if(diagLen>200){
			PatDiagDesc = PatDiagDesc.substring(0, 60)+"..."
		}
		$("#patDiag").html(PatDiagDesc);
		$("#remark").html(jsonRet.Reason +"<br>"+ jsonRet.Remark);
		$("#prescNo").html(jsonRet.PrescNo);
		$("#date").html(jsonRet.Date+" "+jsonRet.Time);
		$("#ysname").html(jsonRet.User)
		if(true){
			$("#passwordArea").show();
		}
	});
	
	$cm({
		ClassName:"web.DHCPRESCReviewReply",
		MethodName:"JsonReviewReplyListData",
		"AuditID":AUDITID
	},function(jsonRet){
		var QustionStr=""
	
		
		
		for(i in jsonRet){
			var itmData=jsonRet[i];
			if(itmData.Question.split("$$").length>0)
			{
				for(var j=1;j<itmData.Question.split("$$").length;j++)
				{
					QustionStr=QustionStr+"</br>"+itmData.Question.split("$$")[j];
				}
			}
			
			var itmHtml=""+
			(i==0?"":"<div class='tool-bar-line' style='margin-top:10px;border-bottom-color:#cccccc;border-bottom-width:1px; border-bottom-style:dashed;'></div>")+
			"<div class='itmDiv itm_title'><span class='spanTitle'></span><span class='itmDrug'>"+itmData.DrugCode+" "+itmData.DrugDesc+"</span></div>"+
			"<div class='itmDiv'>"+
				"<span class='spanTitle'>用药途径:</span><span class='itmValueItm'>"+itmData.DrugPreMet+"</span>"+
				"<span class='spanTitle'>滴速:</span><span class='itmValueItm'>"+itmData.DrugSpeed+itmData.DrugSpeedUnit+"</span>"+
			"</div>"+
			"<div class='itmDiv'>"+
				"<span class='spanTitle'>用药频率:</span><span class='itmValueItm'>"+itmData.DrugFreq+"</span>"+
				"<span class='spanTitle'>疗程:</span><span class='itmValueItm'>"+itmData.Treatment+"</span>"+
			"</div>"+
			"<div class='itmDiv'>"+
				"<span class='spanTitle' >单次剂量:</span><span class='itmValueItm'>"+itmData.OnceDose+itmData.Unit+"</span>"+
				"<span class='spanTitle' >首次用药:</span><span class='itmValueItm'>"+itmData.FirstUseFlag+"</span>"+
			"</div>"+
			"<div class='itmDiv'><span class='spanTitle'>开始日期:</span><span class='itmValueItm'>"+itmData.StDate+"</span></div>"+
			"<div class='itmDiv'><span class='spanTitle'>合理用药:</span><span class='' style=' font-size:16px; color:red;'>"+QustionStr+"</span></div>"
			
			$("#auditList").append(itmHtml);
		}	
	});
	
	if(STACODE==="STA01"){
		$("#AuditRes").text("必须修改");
	}
	if(STACODE==="STA03"){
		$("#AuditRes").text("双签通过");
	}
}

function initBtn(){

if(STACODE=="STA01")
{
	$("#STA3").hide();
	$(".DocWr").hide();
	$("#passWord").hide();	
}else{
	$("#STA1").hide();
}
	
		
}

function sure(){
	var isNeedPassWord=$("#passwordArea").is("hide")?false:true;
	var docreason = $("#docreason").combobox('getValue');
	if(docreason == ""){
		$.messager.alert('提示','申诉理由不能为空，请选择！');
		return false;
	}
	var replyMessage=$("#replyMessage").val();
	if($.trim(replyMessage) == ""){
		$.messager.alert('提示','备注不能为空，请选择！');
		return false;
	}
	var password=$("#passWord").val();
	
	if(isNeedPassWord){
		if(password==""){
			$.messager.alert("提示","密码不能为空");
			return;
		}
		
		var validPas=$cm({
			ClassName:"web.DHCEMSkinTest",
			MethodName:"ConfirmPassWord",
			'userCode':lgUserCode,
			'passWord':password,
			"dataType":"text"
		},false)
		
		if (validPas.split("^")[0] != 0) {
			$.messager.alert("提示",validPas);
			return;
		}	
	}
	
	/*if(replyMessage==""){
		$.messager.alert("提示","回复备注不能为空!");
		return;	
	}*/
	
	var isUpdStat="N";	///是否需要将状态修改为通过
	if(isNeedPassWord) isUpdStat="Y";  ///双签的，验证密码后改为通过状态
	
	var params= replyMessage+"^"+isUpdStat  +"^"+ docreason;
	$cm({
		ClassName:"web.DHCPRESCReviewReply",
		MethodName:"InsetPrescAuditResult",
		"AuditID":AUDITID,
		"Params":params,
		"LgParams":lgParams,
		"dataType":"text"
	},function(ret){
		if(ret==0){
			$.messager.alert("提示","处理成功!","",function(){
				cancel();
			});		
		}else{
			$.messager.alert("提示","处理失败!信息:"+ret);	
		}
	});
}


function cancel(){
	websys_showModal("close");	
	window.parent?window.parent.$("#newsWinAction").window("close"):"";
}
///初始化下拉框
function initCombobox()
{
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	/*$HUI.combotree("#inselitm",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode:'remote',
		onSelect:function(ret){
			
		 }
	})	*/
	$('#docreason').combobox({
    	url:uniturl+'QueryDicItemCombox&code=APPEAL&hospId='+lgHospID,
    	lines:true,
		animate:true,
		onSelect: function(rec){
			
	    },
	    onLoadSuccess:function(data){
		   
		}
	});
	
}