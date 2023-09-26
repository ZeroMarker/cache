//页面Event
function InitCCFeedbackWinEvent(obj){
	CheckSpecificKey();
	obj.refreshFeedList = function(){
		//清空主区域内容
		$("#divMain").empty();
		
		var runQuery = $.Tool.RunQuery('DHCHAI.IRS.CCFeedbackSrv','QryFeedbackSrv',"","",$("#DateFrom").val(),$("#DateTo").val(),$.form.GetValue("cboHospital"),$.form.GetValue("cboLocation"));
		if (!runQuery) {
			//反馈问题列表查询失败
			htmlStr='<div id ="PaAdm1" class="noresult">'
					+	'<img src="../scripts/dhchai/img/noresult.png"></img>'
				    + 	'<p>反馈信息列表查询失败</p>'
				    +'</div>';
			$("#divMain").append(htmlStr);
		} else {
			obj.FeedArrData = runQuery.record;
			if (obj.FeedArrData.length<1) {
				//无符合条件的记录
				htmlStr='<div id ="Feedback1" class="noresult">'
						+	'<img src="../scripts/dhchai/img/noresult.png"></img>'
				        + 	'<p>无符合条件的记录!<br>选择其他条件试试!</p>'
				        +'</div>';
				$("#divMain").append(htmlStr);
			} else {
				//显示反馈问题列表
				for(var indFeed = 0; indFeed < obj.FeedArrData.length; indFeed++){
					var objFeedback = obj.FeedArrData[indFeed];
					if (!objFeedback) continue;
					
					htmlStr ='<div id ="Feedback'+objFeedback.ID+'" class="panel panel-default panel-primary" style="border-radius: 0px;">'
							+	'<div class="panel-heading" style="padding-top:5px;padding-bottom:0px;">'
							+		'<ul id="PatInfo'+objFeedback.ID+'" class="list-inline">'
							+			'<li>'+objFeedback.PatName+'</li>'
							+			'<li class="color-gray-light">|</li>'
							+			'<li>'+objFeedback.Sex+'</li>'
							+			'<li class="color-gray-light">|</li>'
							+			'<li>'+objFeedback.Age+'</li>'
							+			'<li class="color-gray-light">|</li>'
							+			'<li>'+objFeedback.VisitStatus+'</li>'
							+			'<li class="color-gray-light">|</li>'
							+			'<li>'+objFeedback.AdmDate+'入院('+objFeedback.AdmWard+')</li>'
							+			'<li id="TypeDesc'+objFeedback.ID+'" class="pull-right text-muted" style="color: #ffffff;">'+objFeedback.TypeCode+'</li>'
							+		'</ul>'
							+	'</div>'
							
							+	'<div class="panel-body" style="border:aliceblue;">'
							+		'<div class="col-md-12"><div id="Question'+objFeedback.ID+'" style="overflow: hidden;float:left;word-break: break-all;">'+objFeedback.QuestNote+'</div>'
							+		'<div style="float:right;" id="RegTime'+objFeedback.ID+'" class="text-muted pull-right">'+objFeedback.RegUser+'('+objFeedback.RegUserLoc+')&nbsp;&nbsp;&nbsp;'+objFeedback.RegDate+'&nbsp'+objFeedback.RegTime+'</div></div>'
							+		'<div class="col-md-12" id="Opinion'+objFeedback.ID+'" data-id="'+objFeedback.ID+'"></div>'
							+	'</div>'
							+'</div>';
					$("#divMain").append(htmlStr);
					if (objFeedback.IsOpinion == 1) { //已处置
						$("#Opinion"+objFeedback.ID).html('<div style="overflow: hidden;float: left;color: #666666;">---'+objFeedback.Opinion+'</div>'+'<div class="text-muted pull-right" style="float:right;">'+objFeedback.ActUser+'('+objFeedback.ActUserLoc+')&nbsp;&nbsp;&nbsp;'+objFeedback.ActDate+'&nbsp'+objFeedback.ActTime+'</div>');
					} else {
						$("#Question"+objFeedback.ID).addClass("text-danger");
						$("#Opinion"+objFeedback.ID).html('<button id="OpinionBtn'+objFeedback.ID+'" class="btn btn-primary btn-sm pull-right" style="border-radius: 0px;">处置</button>');
						$("#OpinionBtn"+objFeedback.ID).click(function(){
							editOpinion(this,$(this).parents().attr('data-id'));
						});
					}
				}
			}
		}
	}
	
	$("#btnQuery").click(function(){
		obj.reloadgridAdm();
		obj.refreshFeedList();
	});
	obj.reloadgridAdm = function(){
		var DateFrom 	= $("#DateFrom").val();
		var DateTo 		= $("#DateTo").val();
		if ((DateFrom!="")||(DateTo!=""))
		{   
			if (DateFrom=="") {
				layer.msg('请选择开始日期!',{icon: 0});
			}
			if (DateTo == "") {
				layer.msg('请选择结束日期!',{icon: 0});
			}
			if (DateFrom > DateTo) {
				layer.msg('开始日期不能大于结束日期!',{icon: 0});
			}
		}else{
				layer.msg('请选择查询条件！',{icon: 0});
				return;
		}
	};
	
	function editOpinion(el, aFeedbackID){
		if (!aFeedbackID) return;
		var TypeDesc = $("#TypeDesc"+aFeedbackID).text();
		var PatInfo = $("#PatInfo"+aFeedbackID).text().replace(TypeDesc,"").replace(new RegExp("\\|","g"),"&nbsp;|&nbsp;");
		var Question = $("#Question"+aFeedbackID).text();
		var RegTime = $("#RegTime"+aFeedbackID).text();
		var contentStr = '<div class="layer" id="layer"><div style="background:#4C9CE4;color:#fff;border:0px;padding-left:20px;padding-bottom:10px;padding-top:5px;">'+PatInfo+'</div><div class="modal-body"><form class="form-horizontal" role="form"><div style="margin-bottom:10px;word-break: break-all;">'+Question+'</div><textarea id="txtOpinion" name="txtOpinion" class="form-control" rows="3" placeholder="处置意见…"></textarea><div style="margin-top:10px;"><span class="text-muted">问题类型：'+TypeDesc+'</span><span class="text-muted pull-right">'+RegTime+'</span></div></form></div></div>';
		
		obj.layerOpinion = layer.open({
			type: 1,  //0(信息框,默认) 1(页面层)  2(iframe层) 3(加载层) 4(tips层)
			zIndex: 100,
			maxmin: false,
			title: ["处置信息填写"], 
			area: ['620px'],
			content: contentStr,
			btn: ['保存','关闭'],
			btnAlign: 'c',
			yes: function(index, layero){
				var txtOpinion = $.form.return2Br($.trim($.form.GetValue("txtOpinion")));
				if (txtOpinion == ""){
					layer.msg("处置意见不为空",{icon: 2});
					return;
				}
				var retval = $.Tool.RunServerMethod('DHCHAI.IRS.CCFeedbackSrv','UpdateOpinion',aFeedbackID, txtOpinion, $.LOGON.USERID);
				if (parseInt(retval)>0){
					obj.refreshFeedList();
					layer.msg('保存成功!',{icon: 1});
				} else {
					layer.msg('保存失败!',{icon: 2});
				}
				layer.close(index);
			}
		});
	}
	
	$("#test").click(function(){
		addQuest(1010,2);
	});
	obj.refreshFeedList();
}