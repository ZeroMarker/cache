var lgHospID=session['LOGON.HOSPID'];
var lgCtLocID=session['LOGON.CTLOCID'];
var lgGroupID=session['LOGON.GROUPID'];
var lgUserID=session['LOGON.USERID'];
var lgUserCode=session['LOGON.USERCODE'];
var lgParams=lgHospID+"^"+lgCtLocID+"^"+lgGroupID+"^"+lgUserID;

$(function(){
	
	initParams();
	
	///������ϢΪ�Ķ�״̬
	setMsgStatus();
	
	initPage();
	
	initCombobox();
	
	initBtn();	
})

function initParams(){
	USERTYPE = getParam("userType");
	AUDITID = getParam("auditId");   /// ��˽����ID
	STACODE = getParam("stacode");   /// �����޸�-˫ǩͨ��
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
				console.log("�����Ķ��ɹ�!");
			}else{
				console.log("�����Ķ�ʧ��!");
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
				"<span class='spanTitle'>��ҩ;��:</span><span class='itmValueItm'>"+itmData.DrugPreMet+"</span>"+
				"<span class='spanTitle'>����:</span><span class='itmValueItm'>"+itmData.DrugSpeed+itmData.DrugSpeedUnit+"</span>"+
			"</div>"+
			"<div class='itmDiv'>"+
				"<span class='spanTitle'>��ҩƵ��:</span><span class='itmValueItm'>"+itmData.DrugFreq+"</span>"+
				"<span class='spanTitle'>�Ƴ�:</span><span class='itmValueItm'>"+itmData.Treatment+"</span>"+
			"</div>"+
			"<div class='itmDiv'>"+
				"<span class='spanTitle' >���μ���:</span><span class='itmValueItm'>"+itmData.OnceDose+itmData.Unit+"</span>"+
				"<span class='spanTitle' >�״���ҩ:</span><span class='itmValueItm'>"+itmData.FirstUseFlag+"</span>"+
			"</div>"+
			"<div class='itmDiv'><span class='spanTitle'>��ʼ����:</span><span class='itmValueItm'>"+itmData.StDate+"</span></div>"+
			"<div class='itmDiv'><span class='spanTitle'>������ҩ:</span><span class='' style=' font-size:16px; color:red;'>"+QustionStr+"</span></div>"
			
			$("#auditList").append(itmHtml);
		}	
	});
	
	if(STACODE==="STA01"){
		$("#AuditRes").text("�����޸�");
	}
	if(STACODE==="STA03"){
		$("#AuditRes").text("˫ǩͨ��");
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
		$.messager.alert('��ʾ','�������ɲ���Ϊ�գ���ѡ��');
		return false;
	}
	var replyMessage=$("#replyMessage").val();
	if($.trim(replyMessage) == ""){
		$.messager.alert('��ʾ','��ע����Ϊ�գ���ѡ��');
		return false;
	}
	var password=$("#passWord").val();
	
	if(isNeedPassWord){
		if(password==""){
			$.messager.alert("��ʾ","���벻��Ϊ��");
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
			$.messager.alert("��ʾ",validPas);
			return;
		}	
	}
	
	/*if(replyMessage==""){
		$.messager.alert("��ʾ","�ظ���ע����Ϊ��!");
		return;	
	}*/
	
	var isUpdStat="N";	///�Ƿ���Ҫ��״̬�޸�Ϊͨ��
	if(isNeedPassWord) isUpdStat="Y";  ///˫ǩ�ģ���֤������Ϊͨ��״̬
	
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
			$.messager.alert("��ʾ","����ɹ�!","",function(){
				cancel();
			});		
		}else{
			$.messager.alert("��ʾ","����ʧ��!��Ϣ:"+ret);	
		}
	});
}


function cancel(){
	websys_showModal("close");	
	window.parent?window.parent.$("#newsWinAction").window("close"):"";
}
///��ʼ��������
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