//页面Event
function InitCCFeedbackWinEvent(obj){
	
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click',function(){
			//obj.reloadgridAdm();
			obj.refreshFeedList();
		});
	}
	//查询反馈信息
	obj.refreshFeedList = function(){
		//清空主区域内容
		$("#divMain").empty();
		var HospIDs  = $("#cboHospital").combobox('getValue');
		var LocID 	 = $("#cboLocation").combobox('getValue');
		var DateFrom = $("#dtDateFrom").datebox('getValue');
		var DateTo	 = $("#dtDateTo").datebox('getValue');
		var DateFlag=Common_CompareDate(DateFrom,DateTo);
		var ErrorStr="";
		if(DateFrom==""){
			$.messager.alert("提示","开始日期不能为空！", 'info');
			return;
		}
		if(DateTo==""){
			$.messager.alert("提示","结束日期不能为空！", 'info');
			return;
		}
		if (DateFlag==1){
			$.messager.alert("提示","开始日期不能大于结束日期！", 'info');
			return;
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			var runQuery=$cm ({
				ClassName:"DHCHAI.IRS.CCFeedbackSrv",
				QueryName:"QryFeedbackSrv",
				ResultSetType:"array",
				aEpisodeID:"",
				aTypeCode:"",
				aDateFrom:DateFrom,
				aDateTo:DateTo,
				aHospIDs:HospIDs,
				aLocID:LocID	
			},false);
			
			if (!runQuery) {
				//反馈问题列表查询失败
				htmlStr='<div id ="PaAdm1" style="position: relative;height:600px;">'
						+	'<img src="../scripts/dhchai/img/noresult.png"  style="position: absolute; top:30%;left:40%;"></img>'
						+ 	'<p style="position: absolute; top:42%;left:45%;font-size: large; color: red;">病例跟踪信息列表查询失败！</p>'
						+'</div>';
				$("#divMain").append(htmlStr);
			} else {
				obj.FeedArrData = runQuery;
				if (obj.FeedArrData.length<1) {
					//无符合条件的记录
					htmlStr='<div id ="Feedback1" style="position: relative;height:600px;">'
							+	'<img src="../scripts/dhchai/img/noresult.png"  style="position: absolute; top:30%;left:40%;"></img>'
					        + 	'<p style="position: absolute; top:42%;left:42%;font-size: large; color: red;">病例跟踪信息列表结果为空！</p>'
					        +'</div>';
					$("#divMain").append(htmlStr);
				} else {
					//显示反馈问题列表
					for(var indFeed = obj.FeedArrData.length-1; indFeed >= 0; indFeed--){
					(function(indFeed){
						var objFeedback = obj.FeedArrData[indFeed];					
						htmlStr ='<div id="accPanel'+objFeedback.ID+'" class="hisui-panel" title="'+objFeedback.PatName+ ' | '+ objFeedback.Sex+' | '+objFeedback.Age+' | '+objFeedback.VisitStatus+' | '+objFeedback.AdmDate+'入院('+objFeedback.AdmWard+')' +'&nbsp;&nbsp;'+objFeedback.TypeCode+'" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-paper\'," style="fit:true;height:150px;padding:20px;position:relative;">'
								+ 	'<div id="Question'+objFeedback.ID+'" style="float:left;word-break: break-all;">'+objFeedback.QuestNote+'</div>'
								+ 	'<div style="float:right;" id="RegTime'+objFeedback.ID+'" >'+objFeedback.RegUser+'('+objFeedback.RegUserLoc+')&nbsp;&nbsp;&nbsp;'+objFeedback.RegDate+'&nbsp;&nbsp;'+objFeedback.RegTime+'</div>'
								+ 	'<div id="Opinion'+objFeedback.ID+'" data-id="'+objFeedback.ID+'"></div>'
								+ '</div>'
								+ '<div style="padding-bottom:10px;"></div>'
						$("#divMain").append(htmlStr);
					
						if (objFeedback.IsOpinion == 1) { //已处置
							$("#Opinion"+objFeedback.ID).html('<div style="overflow: hidden;float: left;color: #666666;position:absolute;bottom:40px;left:20px;">---'+objFeedback.Opinion+'</div>'+'<div style="float:right;position:absolute;bottom:40px;right:20px;">'+objFeedback.ActUser+'('+objFeedback.ActUserLoc+')&nbsp;&nbsp;&nbsp;'+objFeedback.ActDate+'&nbsp'+objFeedback.ActTime+'</div>');
						} else {
							$("#Opinion"+objFeedback.ID).html('<button id="OpinionBtn'+objFeedback.ID+'"  class="hisui-linkbutton" style="width:80px;height:30px;position:absolute;bottom:20px;right:10px;color:#FFFFFF;border:none;cursor:pointer;">处置</button>');
							$("#OpinionBtn"+objFeedback.ID).on('click',function(){
								obj.InitDialog(objFeedback);
							});
						}
					})(indFeed)}
				}
				$.parser.parse('#divMain'); 
			}				
		}
	}	
	//保存
	obj.btnSave_click=function(objFeedback){
		var flg=obj.Save(objFeedback);
		if(flg == '-100'){
			return;
		}
		if (parseInt(flg)> 0) {
			obj.refreshFeedList();
			$HUI.dialog('#Edit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else{
			$.messager.alert("错误提示", "保存失败!", 'info');
		}
	}
	//核心方法-更新
	obj.Save = function(objFeedback){
		var errinfo = "";
		var Opinion = $('#txtOpinion').val();
		if (!Opinion) {
			errinfo = errinfo + "处置意见不能为空!<br>";
		}

		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return "-100";
		}
		var flg = $m({
			ClassName:"DHCHAI.IRS.CCFeedbackSrv",
			MethodName:"UpdateOpinion",
			aFeedbackID:objFeedback.ID,
			aOpinion:Opinion,
			aUserDr:$.LOGON.USERID
		},false);
		return flg
	}
	//窗体
	obj.SetDiaglog=function(objFeedback){
		$('#Edit').dialog({
			iconCls:'icon-w-paper',
			title:objFeedback.PatName+' | '+objFeedback.Sex+' | '+objFeedback.Age+' | '+objFeedback.VisitStatus+' | '+objFeedback.AdmDate+'入院('+objFeedback.AdmWard+')' ,
			modal: true,
			isTopZindex:false,//true,
			buttons:[{
				text:'保存',
				handler:function(){
					obj.btnSave_click(objFeedback);
				}
			},{
				text:'关闭',
				handler:function(){
					$HUI.dialog('#Edit').close();
				}
			}]
		});
	}
    //窗体-初始化
	obj.InitDialog= function(objFeedback){
		$('#txtCode').text(objFeedback.QuestNote);
		$('#txtTypeDesc').text(objFeedback.TypeCode);
		$('#txtRegTime').text(objFeedback.RegUser+'('+objFeedback.RegUserLoc+')'+' '+' '+objFeedback.RegDate+' '+' '+objFeedback.RegTime);
		$('#Edit').show();
		obj.SetDiaglog(objFeedback);
	}
	
	obj.refreshFeedList();
	
}

	