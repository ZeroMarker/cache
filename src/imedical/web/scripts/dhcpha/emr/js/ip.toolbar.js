var framRecord = parent.window.frames["framRecord"];
var framResource = parent.frames["framResource"];
var frameNav = parent.frames["framnav"];
$(function(){
	$(".tool_tabs").children('li').eq(0).find(".title").addClass("select");	
	$(".tool_tabs").children('li').eq(0).find(".panel").show();	
	$(".tool_tabs li").click(function(){
		if ($(this).find(".select").length<=0)
		{
			parent.foldtoolbar(100);
			$(".tool_tabs li .panel").hide()
			$(".tool_tabs li .title").removeClass("select");
			$(this).find(".title").addClass("select");
			$(this).find(".panel").show();
			$(".fold").css("display","block");
		}
		else
		{
			barhide();
		}
		

	});
	$(".fold").click(function(){
		barhide();
	});	
	
	function barhide()
	{
		$(".tool_tabs li .panel").hide();
		$(".tool_tabs li").find(".title").removeClass("select");
		parent.foldtoolbar(33);
	}
	
	//setFontData();
	
	//控制工具栏字体段落格式等按钮的显示和隐藏
	setToolBarFontView();

	setToolBarStatus("disable");
	getEvent();
	window.setInterval("getEvent()",600000);
});

//设置字体数据源
function setFontData()
{
	var json=[{"value":"宋体","name":"宋体"},
	          {"value":"仿宋","name":"仿宋"},
	          {"value":"楷体","name":"楷体"},
	          {"value":"黑体","name":"黑体"}
	         ]
	$('#font').combobox({
		data : json ,                       
		valueField:'value',                        
		textField:'name'
	});	
	$('#font').combobox('setValue',json[0].value)     
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
	$('#fontSize').combobox({
		data : json ,                       
		valueField:'value',                        
		textField:'name'
	});	
	$('#fontSize').combobox('setValue',json[2].value) 	         		
}

//设置工具条状态
function setToolBarStatus(flag)
{
	setSaveStatus(flag);
	setPrintStatus(flag);
	setDeleteStatus(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setRecordtransfer(flag);
	setApplyeditDocumnet(flag);
	setUnLockStatus(flag);
}

///Desc:是否可编辑
function setSaveStatus(flag)
{
	$('#font').combobox(flag);
	//$('#fontSize').combobox(flag);
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
	
	$('#insertTable').linkbutton(flag);
	$('#deleteTable').linkbutton(flag);
	$('#insertRow').linkbutton(flag);
	$('#insertCol').linkbutton(flag);
	$('#deleteRow').linkbutton(flag);
	$('#deleteCol').linkbutton(flag);
	$('#splitCells').linkbutton(flag);
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

///Desc:是否可送病案室
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}


//文档对照
document.getElementById("reference").onclick = function(){
	
	if ($("#reference").attr("flag") && ($("#reference").attr("flag")=="false"))
	{
		framRecord.reference("remove");
		$("#reference").attr("flag",true);	
	}else
	{
		framRecord.reference("add");
		$("#reference").attr("flag",false);
		//$('#reference').attr("disabled",true);	
	}	
};

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	//病历操作记录需要数据 start
	var categoryId = "";
	var templateId = "";
	if (framRecord.param != "")
	{
		categoryId = framRecord.param.categoryId;
		templateId = framRecord.param.templateId;
	}
	//病历操作记录需要数据 end
	//记录用户(收藏病历)行为
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
	var returnValues = window.showModalDialog("emr.favorite.add.csp?EpisodeID="+episodeID+"&InstanceID="+ framRecord.param.id+"&categoryId="+categoryId+"&templateId="+templateId,"","dialogHeight:450px;dialogWidth:450px;resizable:no;status:no");
};
//病历收藏夹
document.getElementById("favorites").onclick = function(){
	
	//记录用户(整理收藏)行为
    AddActionLog(userID,userLocID,"FavoritesView",""); 
	setFavoritesLog();
	var xpwidth=window.screen.width-10;
	var xpheight=window.screen.height-35;
	var returnValues = window.open("emr.favorite.csp","",'resizable=yes,directories=no,top=0,left=0,width='+xpwidth+',height='+xpheight);
};

//手工解锁
document.getElementById("unLock").onclick = function(){
	if (!framRecord) return;
	framRecord.btnUnLock();
};

//字体
$('#font').combobox({
	onSelect: function (record) {
		strJson = {action:"FONT_FAMILY",args:record.value};
		doExecute(strJson);		
	}
});

//字号
$('#fontSize').combobox({
	onSelect: function(record){
		strJson = {action:"FONT_SIZE",args:record.value};
		doExecute(strJson);		
	}
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
	if (!framRecord) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	framRecord.insertStyleText(returnValues); 
};

//保存
document.getElementById("save").onclick = function(){
	if (!framRecord) return;	
	if (!framRecord) return;						
	framRecord.saveDocument(); 
};

//打印
document.getElementById("print").onclick = function(){
	if (!framRecord) return;						
	framRecord.printDocument();	
};
//删除文档
document.getElementById("delete").onclick = function(){
	if (!framRecord) return;						
	framRecord.deleteDocument();
}

//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
	if (!framRecord) return;
	//获取当前活动文档的instanceID
	var instanceID = framRecord.getDocumentContext().InstanceID; 						
	framRecord.refreshReferenceData(instanceID,"false"); 
}

//导出病历
document.getElementById("export").onclick = function(){
	if (!framRecord) return;						
	framRecord.exportDocument(); 
}

//剪贴板
document.getElementById("clipboard").onclick = function(){
	 parent.$(".easyui-layout").layout("expand","east"); 
	var clipboard = "<iframe id='framclipboard' src='emr.clipboard.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	framResource.addClipboardTab("clipboard","剪贴板",clipboard,true); 

};

//语音录入病历
document.getElementById("recording").onclick = function(){
	if (!framRecord) return;
	if ($("#recording").attr("flag") && $("#recording").attr("flag")=="false")	
	{
		$("#recording").attr("flag",true);
		$("#recording").attr("title","开启语音录入");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/startrecord.png') no-repeat top center");			
		framRecord.setASRVoiceStatus(false,productName);
	}
	else
	{
		$("#recording").attr("flag",false);
		$("#recording").attr("title","关闭语音录入");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/endrecord.png') no-repeat top center");		
		framRecord.setASRVoiceStatus(true,productName);
	}	
	 
}

//执行命令
function doExecute(strJson)
{
	if (!framRecord) return;						
	framRecord.cmdDoExecute(strJson); 	
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
	
	$("#showtype span span").text("编辑模式");
	$("#showtype").css("background","url('../scripts/emr/image/tool/editMode.png') no-repeat top center");
	
	if (!framRecord.plugin()) return;
	framRecord.setPreviewDocumentState(false);
	framRecord.setASRVoiceStatus(false,productName);
}

//判断当前用户是否是当前患者的主管医生，只有主管医生才有病历转移权限；
function setRecordtransfer(flag)
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.HISInterface.PatientInfoAssist",
					"Method":"MainDoc",			
					"p1":episodeID
				},
			success: function (data){
				//alert("data:"+data);
				if (data !== "")
				{
					var mainDoctorID = data.split("^")[0];
					//alert("mainDoctorID:"+mainDoctorID);
					//alert("currDoctorID:"+currDoctorID);
					if (mainDoctorID != currDoctorID)
					{
						$('#recordtransfer').linkbutton("disable");
					}
				}
			}
		});
}
//打开病历转移窗口
function doRecordTransfer(){
	//alert("病历转移");
	var returnValues = window.open("emr.record.recordtransfer.csp?EpisodeID=" +  episodeID,"recordtransferWin","resizable:no;status:no,width=325,height=450");
}

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName2",
			"p1":"DisableFont",
			"p2":""
		},
		success: function(d){
			if (d == "") return;
			strs = d.split(","); //字符分割
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
		},
		error: function(d){alert("error");}
	});
}

//确认病历全部完成
function confirmRecordFinished()
{
	//有修改必须保存后，才可确认病历全部完成
	if (framRecord && framRecord.length >0)
	{
		var result = framRecord.savePrompt();
		if ((result != "")&&(result != "save")) return;
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "确认病历全部完成后将无法修改病历，是否确认提交?";
	if (window.confirm(tipMsg)){

		//获取确认病历全部完成是否成功
		var completeResult = getCompleteResult();
		if (completeResult == true)
		{
			alert("确认病历全部完成成功");
			setToolbarPrivilege();
		}
		else 
		{
			alert("确认病历全部完成失败");
		}
		
		if (getProductStatus("DHCEPRFS") == true)
		{
			//获取病历归档提交是否成功
			var fileSubmitResult = getFileSubmitResult();
			if (fileSubmitResult == true)
			{
				alert("病案归档提交成功");
			}
			else if(fileSubmitResult == false)
			{
				alert("病案归档提交失败");
			}
		}
	} 
}

//获取病历归档提交是否成功
function getFileSubmitResult()
{
	var result = false;
	$.ajax({
		type: "GET",
		url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?EpisodeID="+episodeID+"&UserID="+userID+"&ActionType=doctor", 
		async : false,
		success: function (data){
			if (data == "1") result = true;
		}
	});
	return result;
}

//确认病历全部完成
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
					"Method":"AddAdmRecordStatusData",			
					"p1":episodeID,
					"p2":userID
				},
			success: function (data){
				if (data == "1") result = true;
			}
		});	
	return result;
}

//判断该项目是否上了该产品
function getProductStatus(productCode)
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.EMRProduct",
					"Method":"GetProductStatus",
					"p1":productCode			
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


//打印预览
document.getElementById("printView").onclick = function(){
	if (!framRecord) return;
	if (framRecord.getModifyStatus().Modified == "True")
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
			framRecord.saveDocument();
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
		$("#printView span span").text("预览");
		framRecord.setPreviewDocumentState(false);	
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat center center");
	}
	else
	{
		$("#printView").attr("flag",false);
		$("#printView").attr("title","关闭打印预览");
		$("#printView span span").text("关闭预览");
		framRecord.setPreviewDocumentState(true);
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printViewClose.jpg') no-repeat center center");	
	}	
	 
}

///设置工具栏权限
function setToolbarPrivilege()
{
	var toolbarPrivilege = getPrivilege("ToolbarPrivilege","","","")
	var privelegeJson = {"action":"setToolbar","status":toolbarPrivilege};
	//eventDispatch(privelegeJson);
	if (framRecord)
	{
		framRecord.checkToolbarPrivilege();
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
					"p4":instanceId
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
	if (!framRecord) return;
	var xpwidth=window.screen.width-10;
	var xpheight=window.screen.height-35;
	var returnValues = window.showModalDialog("emr.image.csp","","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
	if (returnValues)	
	{
		framRecord.insertIMG(returnValues);
		framRecord.changeIMGfreq(returnValues);
	}
}

///事件助手消息
function getEvent()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.eventData.cls",
		async: true,
		data: {
			"EpisodeID": episodeID,
			"Action": "GetMessage"
		},
		success: function(d) {
			if (d != "")
			{
				var d = eval(d);
				var text = '<marquee onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2">';
				for (var i=0;i<d.length;i++)
				{
					text = text + '<span id='+d[i].EventType+'><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
					text = text + '<div class="helper">'+d[i].PromptMessage+'</div></span>';
				}
				text = text + '</marquee>';
				$("#event").html(text);	
			}
		},
		error : function(d) { alert(" error");}
	});
}
function sendCopyCutData(content)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(content);
}

$("#event").on('click',"marquee span",function(){
	var eventType = $(this)[0].id;

	var returnValues = "";
	returnValues = window.showModalDialog("emr.event.csp?EpisodeID="+episodeID+"&EventType="+eventType,window,"dialogHeight:500px;dialogWidth:700px;resizable:no;status:no");

	if (typeof(returnValues) != "undefined" && returnValues != "")
	{
		var values = eval("("+returnValues+")");
		if (values.length <=0) return;
		parent.operateRecord(values);
	}
});

///设置工具条件状态
function setToolbarStatus(commandParam)
{
	if(!commandParam.status) return;
	if(commandParam.status["canSave"] == 1)
	{
		setSaveStatus('enable');
	}
	else
	{
		setSaveStatus('disable');
	}
	if(commandParam.status["canPrint"] == 1)
	{
		setPrintStatus('enable');
	}
	else
	{
		setPrintStatus('disable');
	}
	if(commandParam.status["canDelete"] == 1)
	{
		setDeleteStatus('enable');
	}
	else
	{
		setDeleteStatus('disable');
	}
	
	if(commandParam.status["canReference"] == 1)
	{
		setReference('enable');
	}
	else
	{
		setReference('disable');
	}
	if(commandParam.status["canExport"] == 1)
	{
		setExportDocumnet('enable');
	}
	else
	{
		setExportDocumnet('disable');
	}	
	if(commandParam.status["canCommit"] == 1)
	{
		setCommitStatus('enable');
	}
	else
	{
		setCommitStatus('disable');
	}
	if(commandParam.status["canApplyEdit"] == 1)
	{
		setApplyeditDocumnet('enable');
	}
	else
	{
		setApplyeditDocumnet('disable');
	}
	if(commandParam.status["canUnLock"] == 1)
	{
		setUnLockStatus('enable');
	}
	else
	{
		setUnLockStatus('disable');
	}
}

///是否可申请自动审批
function setApplyeditDocumnet(flag)
{
	$('#applyedit').linkbutton(flag);	
}

//申请自动审批
function applyeditOnclick()
{
	if (!framRecord) return;
	framRecord.applyedit();
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

//切换书写模式和浏览模式
function changeShowType()
{	
 	if (!framRecord) return;
 	if ($("#showtype").text() == "浏览模式")
 	{
	 	//setNoteState("Edit");
	 	framRecord.setPreviewDocumentState(false);
		$("#showtype span span").text("编辑模式");
		$("#showtype").css("background","url('../scripts/emr/image/tool/editMode.png') no-repeat top center");
		
		var documentContext = framRecord.getDocumentContext("");
		//设置当前文档操作权限
		framRecord.setPrivelege(documentContext);
 	}
 	else
 	{
		if (framRecord.getModifyStatus().Modified == "True")
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
				framRecord.saveDocument();
			}
			else
			{
				return;
			}
		} 
		
		//setNoteState("Browse");
		framRecord.setPreviewDocumentState(true);
		$("#showtype span span").text("浏览模式");
		$("#showtype").css("background","url('../scripts/emr/image/tool/browseMode.png') no-repeat top center");
 	}		
};

//设置书写状态
function setNoteState(status)
{
	strJson = {action:"SET_NOTE_STATE",args:status};
	doExecute(strJson);	
}

//初始化书写模式
function initShowType()
{
	$("#showtype span span").text("编辑模式");
	$("#showtype").css("background","url('../scripts/emr/image/tool/editMode.png') no-repeat top center");
}

function getNav()
{
	parent.$("#nav").css("display","block");
	parent.$("#editor").css("display","none");
	frameNav.init();
}