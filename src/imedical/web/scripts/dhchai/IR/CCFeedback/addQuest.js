/* 添加反馈问题公共调用方法,参数:就诊号,问题类型Code */
function addQuest(EpisodeID, TypeCode){
	if ((EpisodeID=="")||(TypeCode=="")) return;
	
	var TypeDesc = $.Tool.RunServerMethod('DHCHAI.IRS.CCFeedbackSrv','GetDescByCode', TypeCode);
	if (TypeDesc == "0") {
		layer.msg('请先维护问题类型下代码为'+TypeCode+'的字典！',{icon: 2});
		return;
	}
	
	var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCFeedbackSrv','QryFeedbackSrv', EpisodeID, "", $.form.GetCurrDate('-'), $.form.GetCurrDate('-'));
	var ScrollbarCss = ""; //窗体问题列表样式
	if (!runQuery) {
		//反馈问题列表查询失败
		layer.msg('参数错误!',{icon: 2});
		return;
	} else {
		FeedArrData = runQuery.record;
		if (FeedArrData.length<1) {
			var FeedStr = '<div class="text-muted">该病人今日无反馈问题</div>';
			var admQuery = $.Tool.RunQuery('DHCHAI.DPS.PAAdmSrv','QryAdmInfo', EpisodeID);
			if (!admQuery) return;
			var admInfo = admQuery.record[0];
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
			var PatInfo = '<ul class="list-inline"><li>'+admInfo.PatName+'</li><li class="color-gray-light">|</li><li>'+admInfo.Sex+'</li><li class="color-gray-light">|</li><li>'+admInfo.Age+'</li><li class="color-gray-light">|</li><li>'+admInfo.VisitStatus+'</li><li class="color-gray-light">|</li><li>'+admInfo.AdmDate+'入院('+admInfo.AdmWardDesc+')</li></ul>';
		} else {
			var FeedStr = "";
			for(var indFeed = 0; indFeed < FeedArrData.length; indFeed++){
				var objFeedback = FeedArrData[indFeed];
				if (!objFeedback) continue;
				
				var IsOpinion = (objFeedback.IsOpinion == 1) ? "已处置" : "未处置";
				var QuestClass = (objFeedback.IsOpinion == 0) ? "text-danger" : "";
				FeedStr += '<div style="background-color:#F2F2F2; padding:10px;margin-bottom:5px;">'
						+	'<div class="text-muted">'
						+		'<span style="margin-right:10px;">'+objFeedback.RegUserLoc+'</span><span style="margin-right:10px;">'+objFeedback.RegUser+'</span><span style="margin-right:10px;">'+objFeedback.RegDate+'&nbsp'+objFeedback.RegTime+'</span>'
						+	'</div>'
						+	'<div class="'+QuestClass+'">'+objFeedback.QuestNote+'</div>'
						+	'<div><span class="text-muted" style="margin-right:15px;">'+IsOpinion+'</span><span class="text-muted">'+objFeedback.TypeCode+'</span></div>'
						+ '</div>';
			}
			var PatInfo = '<ul class="list-inline"><li>'+FeedArrData[0].PatName+'</li><li class="color-gray-light">|</li><li>'+FeedArrData[0].Sex+'</li><li class="color-gray-light">|</li><li>'+FeedArrData[0].Age+'</li><li class="color-gray-light">|</li><li>'+FeedArrData[0].VisitStatus+'</li><li class="color-gray-light">|</li><li>'+FeedArrData[0].AdmDate+'入院('+FeedArrData[0].AdmWard+')</li></ul>';
			if ($(".mCustomScrollbar").height() > 190) ScrollbarCss = "height:190px;overflow:auto";
		}
		
		var htmlStr = '<div class="layer">'
					+	'<div style="background:#4C9CE4;color:#fff;border:0px;padding-left:20px;padding-bottom:1px;padding-top:5px;">'+PatInfo+'</div>'
					+	'<div class="modal-body">'
					+		'<form class="form-horizontal" role="form">'
					+			'<div class="mCustomScrollbar" style="margin-bottom:10px;'+ScrollbarCss+'">'+FeedStr+'</div>'
					+			'<textarea id="txtQuestion" name="txtQuestion" class="form-control" rows="3" placeholder="新增问题…"></textarea>'
					+			'<span class="text-muted" style="margin-top:10px;">问题类型：'+TypeDesc+'</span>'
					+		'</form>'
					+ 	'</div>'
					+ '</div>';
		
		layerFeedback = layer.open({
			type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			zIndex: 100,
			maxmin: false,
			title: ["问题反馈"], 
			area: ['620px'],
			content: htmlStr,
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
				//处理换行符
				var txtQuestion = $.form.return2Br($.trim($.form.GetValue("txtQuestion")));
				if (txtQuestion == ""){
					layer.msg("问题内容不为空！",{icon: 2});
					return;
				}
				var InputStr = "^"+EpisodeID+"^"+TypeCode+"^"+txtQuestion+"^^^"+$.LOGON.USERID+"^^^^";
				var retval = $.Tool.RunServerMethod('DHCHAI.IR.CCFeedback','Update', InputStr, "^");
				if (parseInt(retval)>0){
					layer.msg('保存成功!',{icon: 1});
					layer.close(index);
					return true;
				} else {
					layer.msg('保存失败!',{icon: 2});
					return false;
				}
			}
		});
	}
	//问题列表滚动条
	if (ScrollbarCss != ""){
		$(".mCustomScrollbar").mCustomScrollbar({
			theme: "dark-thick",
			scrollInertia : 100,
			mouseWheelPixels: 50 //滚动速度
		});
	}
}/* 公共调用方法结束 */
