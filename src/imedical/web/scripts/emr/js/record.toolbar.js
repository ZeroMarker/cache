﻿$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	setFontData();
	setFontSizeData();
	if (disableFont != "")
	{
		//控制工具栏字体段落格式等按钮的显示和隐藏
		setToolBarFontView(disableFont);
	}
	setToolBarStatus("disable");
	//setRecordtransfer();
	initConfirmRecord();
    if ((loadDocMode.TitleCode != "")||(loadDocMode.RecordConfig != "")){
        $('#loadRecord').css('display','block');
    }
});

//设置字体数据源
function setFontData()
{
	var json=[{"value":"宋体","name":"宋体"},
	          {"value":"仿宋","name":"仿宋"},
	          {"value":"楷体","name":"楷体"},
	          {"value":"黑体","name":"黑体"}
	         ]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#font').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
	}
	//设置默认显示项
	if ($.browser.version == '6.0')
	{
		setTimeout(function() { 
			$('#font').find('option[value="'+defaultFontStyle.fontFamily+'"]').attr("selected",true);
		}, 1);
	}
	else
	{
		$('#font').find('option[value="'+defaultFontStyle.fontFamily+'"]').attr("selected",true); 
	}        
}
//设置字体大小数据源
function setFontSizeData()
{
	var json=[{"value":"42pt","name":"初号"},
			  {"value":"36pt","name":"小初号"},
	          {"value":"31.5pt","name":"大一号"},
	          {"value":"28pt","name":"一号"},
	          {"value":"21pt","name":"二号"},
	          {"value":"18pt","name":"小二号"},
	          {"value":"16pt","name":"三号"},
	          {"value":"14pt","name":"四号"},
	          {"value":"12pt","name":"小四号"},
	          {"value":"10.5pt","name":"五号"},
	          {"value":"9pt","name":"小五号"},
	          {"value":"8pt","name":"六号"},
	          {"value":"6.875pt","name":"小六号"},
	          {"value":"5.25pt","name":"七号"},
	          {"value":"4.5pt","name":"八号"},
	          {"value":"5pt","name":"5"},
	          {"value":"5.5pt","name":"5.5"},
	          {"value":"6.5pt","name":"6.5"},
	          {"value":"7.5pt","name":"7.5"},
	          {"value":"8.5pt","name":"8.5"},
	          {"value":"9.5pt","name":"9.5"},
	          {"value":"10pt","name":"10"},
	          {"value":"11pt","name":"11"}
	         ]
	for (var i=0;i<json.length;i++)  
	{       
    	$('#fontSize').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
	}
	//设置默认显示项
	if ($.browser.version == '6.0')
	{
		setTimeout(function() { 
			$('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);	
		}, 1);
	}
	else
	{
		$('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);
	}	
	document.getElementById('fontSizeText').value = defaultFontStyle.fontSize.replace('pt','');	         		
}

//字号改变
function changeFontSize()
{
	document.getElementById('fontSizeText').value = document.getElementById('fontSize').options[document.getElementById('fontSize').selectedIndex].text;
}

//输入字号
function changeFontSizeText()
{
	if(event.keyCode == 13)
	{
		var strJson = {action:"FONT_SIZE",args:document.getElementById('fontSizeText').value};
		doExecute(strJson);
		document.getElementById('fontSize').value = ""; 
	} 
	
}

//设置工具条状态
function setToolBarStatus(flag)
{
	setSaveStatus(flag);
	setPrintStatus(flag);
	setDeleteStatus(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setViewRevision(flag);
	setApplyeditDocumnet(flag);
}



///Desc:是否可编辑
function setSaveStatus(flag)
{
	$('#bold').linkbutton(flag);
	$('#italic').linkbutton(flag);
	$('#underline').linkbutton(flag);
	$('#strike').linkbutton(flag);
	$('#super').linkbutton(flag);
	$('#sub').linkbutton(flag);
	$('#alignjustify').linkbutton(flag);
	$('#alignleft').linkbutton(flag);
	$('#aligncenter').linkbutton(flag);
	$('#alignright').linkbutton(flag);
	$('#indent').linkbutton(flag);
	$('#unindent').linkbutton(flag);
	$('#cut').linkbutton(flag);
	$('#paste').linkbutton(flag);
	$('#undo').linkbutton(flag);
	$('#redo').linkbutton(flag);	
	$('#save').linkbutton(flag);
	$('#binddatareload').linkbutton(flag);
	$('#spechars').linkbutton(flag);
	$('#clipboard').linkbutton(flag);
	$('#fontcolor').linkbutton(flag);
	$('#recording').linkbutton(flag);
	$('#silverLocation').linkbutton(flag);
	$('#image').linkbutton(flag);	
	$('#plampoint').linkbutton(flag);
	$('#insertTable').linkbutton(flag);
	$('#deleteTable').linkbutton(flag);
	$('#insertRow').linkbutton(flag);
	$('#insertCol').linkbutton(flag);
	$('#deleteRow').linkbutton(flag);
	$('#deleteCol').linkbutton(flag);
	$('#splitCells').linkbutton(flag);
	$('#loadRecord').linkbutton(flag);
}
///Desc:是否可打印
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
	$('#printView').linkbutton(flag);
}
///Desc:是否可删除
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///书写对比
function setReference(flag)
{
	$('#reference').linkbutton(flag);
}
///是否可导出
function setExportDocumnet(flag)
{
	$('#export').linkbutton(flag);	
}
///是否显示留痕可用
function setViewRevision(flag)
{
	//$('#viewRevision').linkbutton(flag);	
	if (flag == "enable")
	{
		$('#viewRevision input').attr("disabled",false);
		$('#viewRevision').attr("disabled",false);
	}
	else
	{
		$('#viewRevision input').attr("disabled",true);	
		$('#viewRevision').attr("disabled",true);	
	}
}

///Desc:是否可提交病历
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}

///病历转移功能
function setTransferStatus(flag)
{
	$('#recordtransfer').linkbutton(flag);
}


//文档对照
document.getElementById("reference").onclick = function(){
	
	if ($("#reference").attr("flag") && ($("#reference").attr("flag")=="false"))
	{
		window.frames["framRecord"].reference("remove");
		$("#reference").attr("flag",true);	
	}else
	{
		window.frames["framRecord"].reference("add");
		$("#reference").attr("flag",false);
		$('#reference').attr("disabled",true);	
	}	
	
};

//折叠资源区
function collapseResourse()
{
	$('#recordlayout').layout('collapse','east');
}

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	//病历操作记录需要数据 start
	var categoryId = "";
	var templateId = "";
	if (recordParam != "")
	{
		categoryId = recordParam.categoryId;
		templateId = recordParam.templateId;
	}
	//病历操作记录需要数据 end
	//记录用户(收藏病历)行为
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
	var returnValues = window.showModalDialog("emr.favorite.add.csp?EpisodeID="+episodeID+"&InstanceID="+recordParam.id+"&categoryId="+categoryId+"&templateId="+templateId,"","dialogHeight:450px;dialogWidth:450px;resizable:no;status:no");
};
//病历收藏夹
document.getElementById("favorites").onclick = function(){
	
	//记录用户(整理收藏)行为
    AddActionLog(userID,userLocID,"FavoritesView",""); 
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var ModelName = "EMR.Favorites.Login";
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
		var ConditionAndContent = Condition;
		//alert(ConditionAndContent);
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
	var xpwidth=window.screen.width-10;
	var xpheight=window.screen.height-35;
	var returnValues = window.open("emr.favorite.csp","",'resizable=yes,directories=no,top=0,left=0,width='+xpwidth+',height='+xpheight);
};

//手工解锁
document.getElementById("unLock").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var lockcode = $("#lock span").attr("userCode");
	var lockname = $("#lock span").attr("userName");
	var lockId = $("#lock span").attr("lockId");
	if (lockcode != undefined )
	{
		if (!confirm("确定解锁吗?")) return;
		if (lockcode != userCode)
		{
			var result = window.showModalDialog("emr.userverification.csp?UserID="+lockcode+"&UserName="+lockname,"","dialogHeight:160px;dialogWidth:100px;resizable:no;status:no");
			if (result == "") 
			{
				return;
			}
			else if(result == "0")
			{
				alert("密码验证失败");
				return;
			}
		}
		if (window.frames["framRecord"].unLock(lockId)=="1")
		{
			window.frames["framRecord"].setReadOnly(false,"");
			window.frames["framRecord"].lockDocument("");
			$("#lock").empty();
		}
		else
		{
			alert("解锁失败");
		}	
	}
};

//字体
$("#font").change(function(){
    var strJson = {action:"FONT_FAMILY",args:$("#font").find("option:selected").text()};
	doExecute(strJson);	
}); 

//字号
$("#fontSize").change(function(){
    var strJson = {action:"FONT_SIZE",args:$("#fontSize").find("option:selected").val()};
	doExecute(strJson);	
});


//设置字体颜色   start
$("#fontcolor").colorpicker({
});
//打开/关闭颜色选择器
document.getElementById("fontcolor").onclick = function(){
	//alert(colorpanelshow);
	if (colorpanelshow == "1")
	{
		$("#colorpanel").hide();
		colorpanelshow = "0";
	}
	else if (colorpanelshow == "0")
	{
		$("#colorpanel").show();
		colorpanelshow = "1";
	}
};
//将字体颜色传给编辑器
function setFontColor(color){
	//alert("get+"+color);
	strJson = {action:"FONT_COLOR",args:color}; 
 	doExecute(strJson);	
};
//设置字体颜色   end

//设置粗体
document.getElementById("bold").onclick = function(){
 	strJson = {action:"BOLD",args:{path:""}}; 
 	doExecute(strJson);	
};

//设置斜体
document.getElementById("italic").onclick = function(){
 	strJson = {action:"ITALIC",args:""}; 
 	doExecute(strJson);	
};

//设置下划线
document.getElementById("underline").onclick = function(){
 	strJson = {action:"UNDER_LINE",args:""};
 	doExecute(strJson);	
};

//删除线
document.getElementById("strike").onclick = function(){
 	strJson = {action:"STRIKE",args:""};
 	doExecute(strJson);	
};

//设置上标
document.getElementById("super").onclick = function(){
 	strJson = {action:"SUPER",args:""};
 	doExecute(strJson);	
};

//设置下标
document.getElementById("sub").onclick = function(){
 	strJson = {action:"SUB",args:""};
 	doExecute(strJson);	
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
 	strJson = {action:"ALIGN_JUSTIFY",args:""}; 
 	doExecute(strJson);	
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
 	strJson = {action:"ALIGN_LEFT",args:""}; 
 	doExecute(strJson);	
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
 	strJson = {action:"ALIGN_CENTER",args:""}; 
 	doExecute(strJson);	
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
 	strJson = {action:"ALIGN_RIGHT",args:""}; 
 	doExecute(strJson);	
};

//设置缩进
document.getElementById("indent").onclick = function(){
 	strJson = {action:"INDENT",args:""};
 	doExecute(strJson);	
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
 	strJson = {action:"UNINDENT",args:""};  
 	doExecute(strJson);	
};

//剪切
document.getElementById("cut").onclick = function(){
 	strJson = {action:"CUT",args:""};  
 	doExecute(strJson);	
};

//复制
document.getElementById("copy").onclick = function(){
 	strJson = {action:"COPY",args:""};  
 	doExecute(strJson);	
};

//粘贴
document.getElementById("paste").onclick = function(){
 	strJson = {action:"PASTE",args:""};  
 	doExecute(strJson);	
};

//撤销
document.getElementById("undo").onclick = function(){
 	strJson = {action:"UNDO",args:""}; 
 	doExecute(strJson);	
};

//重做
document.getElementById("redo").onclick = function(){
 	strJson = {action:"REDO",args:""}; 
 	doExecute(strJson);	
};

//特殊字符
document.getElementById("spechars").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	window.frames["framRecord"].insertStyleText(returnValues); 
};

//牙位图
document.getElementById("tooth").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var returnValue = window.showModalDialog("emr.record.tooth.csp","","dialogWidth=940px;dialogheight=420px;status:no;center:yes;minimize:yes;");	
	if (returnValue !== "")	window.frames["framRecord"].insertTooth("new",returnValue); 
	//window.frames["framRecord"].openTooth("123"); 
};

//保存
document.getElementById("save").onclick = function(){
	if (!window.frames["framRecord"]) return;	
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].saveDocument(); 
};

//打印
document.getElementById("print").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].printDocument();	
};
//删除文档
document.getElementById("delete").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].deleteDocument();
}

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
	if (!window.frames["framRecord"]) return;
	//获取当前活动文档的instanceID
	var instanceID = window.frames["framRecord"].getDocumentContext().InstanceID; 						
	window.frames["framRecord"].refreshReferenceData(instanceID,"false"); 
}
//显示留痕
$("#viewRevision input:checkbox").live("click",function(){
	if (!window.frames["framRecord"]) return;						
	
	if ($("#viewRevision input").attr("checked") == "checked")
	{
		window.frames["framRecord"].viewRevision(true); 
	}else
	{
		window.frames["framRecord"].viewRevision(false); 
	}
})

//判断留痕框是否勾选
function isViewRevisionCheck()
{
	var result = "";
	if ($("#viewRevision input")[0].checked == true)
	{
		var result = "true"; 
	}else
	{
		var result = "false";
	}
	return result
}


//导出病历
document.getElementById("export").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].exportDocument(); 
}

//剪贴板
document.getElementById("clipboard").onclick = function(){
	 $("#recordlayout").layout("expand","east"); 
	var clipboard = "<iframe id='framclipboard' frameborder='0' src='emr.clipboard.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addResourceTab("clipboard","剪贴板",clipboard,false); 

};

//语音录入病历
document.getElementById("recording").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if ($("#recording").attr("flag") && $("#recording").attr("flag")=="false")	
	{
		$("#recording").attr("flag",true);
		$("#recording").attr("title","开启语音录入");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/startrecord.png') no-repeat top center");			
		window.frames["framRecord"].setASRVoiceStatus(false,productName);
	}
	else
	{
		$("#recording").attr("flag",false);
		$("#recording").attr("title","关闭语音录入");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/endrecord.png') no-repeat top center");		
		window.frames["framRecord"].setASRVoiceStatus(true,productName);
	}	
	 
}

//执行命令
function doExecute(strJson)
{
	if (!window.frames["framRecord"] || window.frames["framRecord"].length<=0) return;						
	window.frames["framRecord"].cmdDoExecute(strJson); 	
}

///初始化工栏状态
function initToolbarStatus()
{
	//初始化语音录入
	$("#recording").attr("flag",true);
	$("#recording").attr("title","开启语音录入");
	$("#recording").css("background","url('../scripts/emr/image/toolbar/startrecord.png') no-repeat top center");			
	
	//初始化打印预览
	$("#printView").attr("flag",true);
	$("#printView").attr("title","开启打印预览");
	$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat top center");
	$('#printViewMessage').css('display','none');
	
    //初始化留痕查看
    if (isDefaultviewRevision == "Y") {
        $('#viewRevision input').attr("checked",true);
	} else {
        $('#viewRevision input').attr("checked",false);
	}
    
	if (!window.frames["framRecord"].plugin()) return;
	window.frames["framRecord"].setASRVoiceStatus(false,productName);
	window.frames["framRecord"].setPreviewDocumentState(false);
}

//判断当前用户是否是当前患者的主管医生，只有主管医生才有病历转移权限；
function setRecordtransfer()
{
    /*
	if (mainDoc != userCode)
	{
		setTransferStatus("disable");
	}
    */
    //走工具栏权限脚本，判断病历转移按钮可不可用
}
//打开病历转移窗口
document.getElementById("recordtransfer").onclick = function(){
	var returnValues = window.open("emr.record.recordtransfer.csp?EpisodeID=" +  episodeID,"recordtransferWin","resizable:no;status:no,width=650,height=450");
}

//打开申请权限窗口
document.getElementById("authRequest").onclick = function(){
	var returnValues = window.open("emr.authappoint.request.csp?EpisodeID=" +  episodeID + "&PatientID=" + patientID,"authRequestWin","resizable:no;status:no,width=850,height=550");
}

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView(disableFont)
{
	var strs = new Array(); //定义一数组
	strs = disableFont.split(","); //字符分割
	for (i=0;i<strs.length;i++ )
	{
		if (document.getElementById(strs[i]) != null)
		{
			if (strs[i] == "font")
			{
				document.getElementById("fontSpan").style.display="none";
			}
			else
			{
				document.getElementById(strs[i]).style.display="none";
			}
		}	
	} 
}

//初始化提交病历状态
function initConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1")
				{ 
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmRecordCompleted").attr("title","已提交病历");
						$("#confirmRecordCompleted").text("已提交病历");
						$("#confirmRecordCompleted").css("width","65px");
					}
					else
					{
						$("#confirmRecordCompleted").attr("title","撤销提交病历");
						$("#confirmRecordCompleted").text("撤销提交病历");
						$("#confirmRecordCompleted").css("width","75px");
					}
					$("#confirmRecordCompleted").css("padding-top","22px");
					$("#confirmRecordCompleted").css("text-align","center");
				}
			}
		});	
}

//提交病历点击事件
function changeRecordFinishedStatus()
{
	var returnValue = window.showModalDialog("emr.confirmadmrecord.csp?EpisodeID="+episodeID,"","dialogHeight:340px;dialogWidth:1000px;resizable:no;status:no");
	if (returnValue == "confirm")
	{
		confirmRecordFinished();
	}
	else if(returnValue == "revoke")
	{
		revokeConfirmRecord();
	}
}

//确认病历全部完成
function confirmRecordFinished()
{
	//有修改必须保存后，才可确认病历全部完成
	if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	{
		var result = window.frames["framRecord"].savePrompt("");
		if ((result != "")&&(result != "save")) return;
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "提交病历后将无法修改病历，是否确认提交?";
	if (window.confirm(tipMsg)){

		if (checkOutCorrelation() == true)
		{
			var xpwidth=window.screen.width-10;
			var xpheight=window.screen.height-35;
			window.open('dhc.epr.fs.correlationepisode.csp?EpisodeID='+episodeID+'&UserID='+userID,'','resizable=yes,directories=no,top=0,left=0,width='+xpwidth+',height='+xpheight);
		}
		else
		{
			submitRemarks();
			//获取提交病历是否成功
			var completeResult = getCompleteResult();
			if (completeResult == true)
			{
				alert("提交病历成功");
				window.location.reload();
			}
			else 
			{
				alert("提交病历失败");
			}
		}
	} 
}

//提交病历
function getCompleteResult()
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"ConfirmRecordFinished",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":""
				},
			success: function (data){
				if (data == "1") 
				{
					result = true;
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmRecordCompleted").attr("title","已提交病历");
						$("#confirmRecordCompleted").text("已提交病历");
						$("#confirmRecordCompleted").css("width","65px");
					}
					else
					{
						$("#confirmRecordCompleted").attr("title","撤销提交病历");
						$("#confirmRecordCompleted").text("撤销提交病历");
						$("#confirmRecordCompleted").css("width","75px");
					}
					$("#confirmRecordCompleted").css("padding-top","22px");
					$("#confirmRecordCompleted").css("text-align","center");
				}
			}
		});	
	return result;
}

//撤销提交病历
function revokeConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"RevokeConfirmRecord",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":"",
					"p6":"Revoke"
				},
			success: function (data){
				if (data == "1") 
				{
					$("#confirmRecordCompleted").attr("title","提交病历");
					$("#confirmRecordCompleted").text("提交病历");
					$("#confirmRecordCompleted").css("width","60px");
					$("#confirmRecordCompleted").css("padding-top","22px");
					$("#confirmRecordCompleted").css("text-align","center");
					alert("撤销提交病历成功");
					window.location.reload();
				}
			}
		});	
}

//判断该科室是否有关联门诊功能
function checkOutCorrelation()
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.AdmRecordStatus",
					"Method":"CheckOutCorrelation",
					"p1":userLocID			
				},
			success: function (data){
				if (data == 1) result = true;
			}
		});	
	return result;
}

//定位到上次书写位置
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}

//修改上级医师
document.getElementById("modifysuper").onclick = function(){
	//window.open('emr.setsuperior.csp?UserID='+userID+'&UserName='+userName+'&UserLoc='+userLocID+'&SSGroupID='+ssgroupID,'','width=500px,height=300px');
	window.open('emr.setpatientdoctor.csp?UserID='+userID+'&UserName='+userName+'&UserLoc='+userLocID+'&SSGroupID='+ssgroupID+'&EpisodeID='+episodeID,'','width=500px,height=300px'); 	
}

//打印预览
document.getElementById("printView").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if (window.frames["framRecord"].getModifyStatus("").Modified == "True")
	{
		var text = '文档正在编辑，请保存后开启预览，是否保存？';
		//判断客户端浏览器IE及其版本
		if ($.browser.msie && $.browser.version == '6.0')
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}else
		{
			returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
		}
		if (returnValues == "save")
		{
			window.frames["framRecord"].saveDocument();
			return;
		}
		else
		{
			return;
		}
	} 
	if ($("#printView").attr("flag") && $("#printView").attr("flag")=="false")	
	{
		$("#printView").attr("flag",true);
		$("#printView").attr("title","开启打印预览");
		window.frames["framRecord"].setPreviewDocumentState(false);	
		$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat top center");
		$('#printViewMessage').css('display','none');
	}
	else
	{
		$("#printView").attr("flag",false);
		$("#printView").attr("title","关闭打印预览");
		window.frames["framRecord"].setPreviewDocumentState(true);
		$("#printView").css("background","url('../scripts/emr/image/toolbar/printViewClose.jpg') no-repeat top center");	
		$('#printViewMessage').css('display','block');
	}	
	 
}

///设置工具栏权限
function setToolbarPrivilege()
{
	var toolbarPrivilege = getPrivilege("ToolbarPrivilege","","","")
	var privelegeJson = {"action":"setToolbar","status":toolbarPrivilege};
	eventDispatch(privelegeJson);
	if (window.frames["framRecord"])
	{
		window.frames["framRecord"].checkToolbarPrivilege();
	}
}

function qualityConfirmDocument()
{
	var result =  false;
	//病历质控
	var eventType = "ConfirmRecord^" + ssgroupID + "^" + userLocID;
	var qualityData = qualityCheck(episodeID,"","",eventType)
	if (qualityData != "")
	{
		var pos = qualityData.indexOf("^");
		var controlType = qualityData.substring(0,pos);
        var strQualityData = qualityData.substring(pos+1);
        if (strQualityData != "")
        {
			var content = ""
			if (controlType == "0") 
			{
				var content = "确认病历全部完成失败！" + "\n";
			}
			var strs = new Array(); //定义一数组
			strs = strQualityData.split("#"); //字符分割
			for (i=0;i<strs.length;i++ )
			{
				if (strs[i]!="")
				{
					content = content + "\n" +strs[i];
				}
			} 
			alert(content);
			
			if (controlType == "0") 
			{
				result = true;
				return result;
			}
        }
	}
	return result;
}

//质控
function qualityCheck(episodeId,instanceId,templateId,eventType)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId,
					"p5":"EASYUI"
				},
			success: function(d) {
					result = d;
			},
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}

//打开图库窗口
document.getElementById("image").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var xpwidth=window.screen.width-10;
	var xpheight=window.screen.height-35;
	var returnValues = window.showModalDialog("emr.image.csp","","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
	if (returnValues)	
	{
		window.frames["framRecord"].insertIMG(returnValues);
	}
}

//打开新生儿掌纹窗口
document.getElementById("plampoint").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var xpwidth=window.screen.width-100;
	var xpheight=window.screen.height-350;
	var returnValues = window.showModalDialog("emr.extern.image.palm.csp","","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
	if (returnValues)
	{
		var insertValues = {"ImageType":".jpg","ImageData":returnValues};
		window.frames["framRecord"].insertIMGData(insertValues);
	}
}

///是否可申请自动审批
function setApplyeditDocumnet(flag)
{
	$('#applyedit').linkbutton(flag);	
}

//申请自动审批
document.getElementById("applyedit").onclick = function(){
	if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	{
		window.frames["framRecord"].applyedit();
	}
}

///Desc:是否可手工解锁
function setUnLockStatus(flag)
{
	$('#unLock').linkbutton(flag);
}

//插入表格
document.getElementById("insertTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除表格
document.getElementById("deleteTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};


//插入行
document.getElementById("insertRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除行
document.getElementById("deleteRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//插入列
document.getElementById("insertCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//删除列
document.getElementById("deleteCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//拆分单元格
document.getElementById("splitCells").onclick = function(){
 	strJson = {action:"TOOL_BAR_SPLIT_CELLS",args:{path:""}}; 
 	doExecute(strJson);	
};
var messageObj="";
var titleText ="";
function topCenter(obj){
	if ((typeof($('#'+ obj.id).attr('reason')) == "undefined")||($('#'+ obj.id).attr('reason')== "")) return;
	if (typeof(obj) == "undefined") return;
	if (messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
	var pos = obj.getBoundingClientRect();
	var right = pos.right+2;
	var top = pos.top;
	titleText = $('#'+ obj.id).attr('title');
	$('#'+ obj.id).attr('title',"");
	var message = $('#'+ obj.id).attr('reason');
	messageObj=document.createElement("DIV")
	messageObj.innerText=message;
	messageObj.id="messageText";
	messageObj.style.top=top+"px";
	messageObj.style.left=right+"px";
	window.document.body.appendChild(messageObj);
}
function topDel(obj){
	if (typeof(obj) == "undefined") return;
	if(titleText!=""){
		$('#'+ obj.id).attr('title',titleText);
		titleText="";
	}
	if(messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
}

//调用归档统计扫描项目数目页面
function submitRemarks()
{
	if (isSubmitRemarks != "Y") return;
	var iWidth = 440;
	var iHeight = 520;
	var iTop = (window.screen.availHeight - iHeight) / 2;
	var iLeft = (window.screen.availWidth - iWidth) / 2;
	var url = '../csp/dhc.epr.fs.submitremarks.csp?EpisodeID=' + episodeID;
	var returnValue = window.showModalDialog(url,self,'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=no;help=no;resizable=no;scroll=no;status=no;edge=sunken');

}

//加载全部病程
function loadAllRecord()
{
    if ((window.frames["framRecord"].param != "")&&(window.frames["framRecord"].checkLoadDocMode()))
    {
        var returnValues = window.frames["framRecord"].savePrompt(window.frames["framRecord"].param.id,"sync");
        if ((returnValues == "unsave")||(!returnValues))
        {
            window.frames["framRecord"].reloadAllRecord();
        }
    }
}
