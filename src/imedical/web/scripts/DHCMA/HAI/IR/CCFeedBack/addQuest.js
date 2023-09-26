$(function () {
	addQuest();
	QuestMsg();
});

function addQuest(){
	if ((EpisodeID=="")||(TypeCode=="")) return;
	var PatInfo ="";
	var FeedStr = "";
	$("#divNorth").empty();
	$("#divCenter").empty();	
	
	var FeedInfo = $cm({
		ClassName:"DHCHAI.IRS.CCFeedbackSrv",
		QueryName:"QryFeedbackSrv",		
		aEpisodeID: EpisodeID,
		aTypeCode:TypeCode,
		aDateFrom:Common_GetDate(new Date()), 
		aDateTo:Common_GetDate(new Date())
	},false);
	
	if (FeedInfo.total>0) {		
		for(var indFeed = 0; indFeed < FeedInfo.total; indFeed++){
			var objFeedback = FeedInfo.rows[indFeed];
			if (!objFeedback) continue;
			
			var IsOpinion = (objFeedback["IsOpinion"] == 1) ? "已处置" : "未处置";
			var QuestClass = (objFeedback["IsOpinion"] == 0) ? "red" : "";
			FeedStr += '<div style="background-color:#F2F2F2; padding:10px;margin-bottom:5px;">'
					+	'<div style="color:#808080;">'
					+		'<span style="margin-right:10px;">'+objFeedback.RegUserLoc+'</span><span style="margin-right:10px;">'+objFeedback.RegUser+'</span><span style="margin-right:10px;">'+objFeedback.RegDate+'&nbsp'+objFeedback.RegTime+'</span>'
					+	'</div>'
					+	'<div style="line-height:35px;color:'+QuestClass+'">'+objFeedback.QuestNote+'</div>'
					+	'<div><span style="color:#808080;" style="margin-right:15px;">'+IsOpinion+'</span><span style="color:#808080;">'+objFeedback.TypeCode+'</span></div>'
					+ '</div>';
		}
		PatInfo = '<ul class="list-inline"><li>'+FeedInfo.rows[0].PatName+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].Sex+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].Age+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].VisitStatus+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].AdmDate+'入院('+FeedInfo.rows[0].AdmWard+')</li></ul>';
    }else {
		FeedStr = '<div style="background-color:#F2F2F2;color:#808080;padding:10px;">该病人今日无反馈问题</div>';
		var AdmInfo = $cm({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			QueryName:"QryAdmInfo",		
			aEpisodeID: EpisodeID
		},false);
		if (AdmInfo.total>0) {
			var admInfo = AdmInfo.rows[0];
			switch(admInfo.VisitStatus){
				case "P":
					admInfo.VisitStatus = "预住院";break;
				case "A":
					admInfo.VisitStatus = "在院";break;
				case "D":
					admInfo.VisitStatus = "出院";break;
				case "C":
					admInfo.VisitStatus = "退院";break;
				default:
					admInfo.VisitStatus = "作废";break;
			}
			PatInfo = '<ul class="list-inline"><li>'+admInfo.PatName+'</li><li class="middle-line">|</li><li>'+admInfo.Sex+'</li><li class="middle-line">|</li><li>'+admInfo.Age+'</li><li class="middle-line">|</li><li>'+admInfo.VisitStatus+'</li><li class="middle-line">|</li><li>'+admInfo.AdmDate+'入院('+admInfo.AdmWardDesc+')</li></ul>';
		}
	}
	$("#divNorth").append(PatInfo);
	$("#divCenter").append(FeedStr);

}

function QuestMsg(){
	
	var TypeDesc = $m({
		ClassName:"DHCHAI.IRS.CCFeedbackSrv",
		MethodName:"GetDescByCode",		
		aCode: TypeCode
	},false);
	if (TypeDesc == "0") {
		$.messager.alert("提示","请先维护问题类型下代码为'+TypeCode+'的字典！'", "info");	
		return;
	}
	
	var htmlStr = '<div id="divSendMess" style="display: block; border-top: 1px solid #ccc;padding:10px;">'		
				+ '		<textarea class="textbox"  id="txtQuestion" style="width:99%;height:80px;outline:none;background-color:#fff;" placeholder="新增问题..."></textarea> '			
				+ '		<div style="padding-top:5px;">'
				+ '			<span style="color:#808080;">问题类型：'+TypeDesc+'</span>'
				+ '			<div style="padding-top:5px;text-align:center">'
				+ '				<a id="btnSave">保存</a>'
				+ '				<a id="btnClose">关闭</a>'	
				+ '			</div>'				
				+ '		</div>'
				+ '</div>'
	$("#divSouth").append(htmlStr);
	$('#btnSave').linkbutton();
	$('#btnClose').linkbutton();
	//保存按钮
	$('#btnSave').on('click', function(){
		btnSave_click();
	});
	//关闭按钮
	$('#btnClose').on('click', function(){
		websys_showModal('close');
	});
}
btnSave_click =function(){	
	var txtQuestion = $.trim($("#txtQuestion").val());
	if (txtQuestion == ""){
		$.messager.alert("提示","问题内容不为空！", "info");
		return;
	}
	var InputStr = "^"+EpisodeID+"^"+TypeCode+"^"+txtQuestion+"^^^"+$.LOGON.USERID+"^^^^";
	var retval = $m({
		ClassName:"DHCHAI.IR.CCFeedback",
		MethodName:"Update",
		aInputStr:InputStr,
		aSeparete:'^'
	},false);

	if (parseInt(retval)>0){
		addQuest(); //刷新
		$('#txtQuestion').val('');
		$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
	} else {
		$.messager.alert("提示", "保存失败！", "info");
	}
}



 