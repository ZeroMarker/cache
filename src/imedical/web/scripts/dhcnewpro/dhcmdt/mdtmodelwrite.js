//===========================================================================================
// 作者：      lvpeng
// 编写日期:   2021-04-08
// 描述:	   会诊模板打印 
//===========================================================================================
/// 页面初始化函数
function initPageDefault(){
	
	/// 初始化加载病人就诊ID
	InitPatEpisodeID();
	InitButton();
	GetPatBaseInfo();
	if(tempID > 0){
		initRecord(); //加载填写内容
	}else{
		GetPatLisInfo();	
	}
}

function InitButton(){
	$('#print').on('click',exportword);	
	$('#save').on('click',save);
	$(window).resize(function(){
		InitAutoLine();
	});
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// 就诊ID
	DisGrpID = getParam("DisGrpID");     /// 病种ID
	mdtID = getParam("ID");  //会诊id
	PatientID = getParam("PatientID");
}

/// 加载填写内容
function initRecord(){
	runClassMethod("web.DHCMDTemp","findByEmrId",{"mdtID":mdtID },
		function(data){
			if(data !=""){
				fillBlock(data)	
			}
		}
	)
}

function InitAutoLine(){
	var winWindth=$(window).width();
	if(parseInt(winWindth)<990){
		$(".autoNewLine").show();
		$("#nativePlaceSpan").addClass("dymSpan");
		$("#PatBDay,#chiefcomplaint").addClass("dymInput");
	}else{
		$(".autoNewLine").hide();
		$("#nativePlaceSpan").removeClass("dymSpan");
		$("#PatBDay,#chiefcomplaint").removeClass("dymInput");
	}	
}

function fillBlock(data){
	$("#physical").val(data.physical);	
	$("#treatment").val(data.treatment);
	$("#labexamination").val(data.labexamination);
	$("#imageexam").val(data.imageexam);
	$("#clinicaldiag").val(formatHtmlToValue(data.clinicaldiag));
	$("#cstpurpose").val(data.cstpurpose);
	data.chiefcomplaint?$("#chiefcomplaint").val(data.chiefcomplaint):"";
}


function GetPatLisInfo(){
	runClassMethod("web.DHCMDTCom","GetHistoryDataByEPRService",{"adm":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 var arr=jsonObject.split("^");
			 var chiefcomplaint=arr[0];
			 var currentmedhistory=arr[1];
			 var pastmedhistory=arr[2];
			 var specialexam=arr[3];
			 var auxiliaryexam=arr[4];
			 $('#chiefcomplaint').val(chiefcomplaint);
			 $('#physical').val(specialexam);
			 $('#treatment').val(currentmedhistory);
		}
	},'text',false)
	runClassMethod("web.DHCMDTConsultQuery","GetMdtConsPrintModel",{"CstID":mdtID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 var arr=jsonObject.split("^");
			 var CstPurpose=arr[0];
			 $('#cstpurpose').val(CstPurpose); //会诊目的
		}
	},'text',false)
	
}

/// 病人就诊信息
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 $("#PatName").val(jsonObject.PatName); /// 姓名
			 $("#PatSex").val(jsonObject.PatSex);   /// 性别
			 $("#PatAge").val(jsonObject.PatAge);   /// 年龄
			 $("#PatBDay").val(jsonObject.RegisterPlace);   /// 籍贯
			 if(jsonObject.RegisterPlace == ""){
				$("#PatBDay").val(jsonObject.RAddress);   /// 籍贯	 
			 }
			 $("#clinicaldiag").val(formatHtmlToValue(jsonObject.PatDiagDesc)); /// 诊断
		}
	},'json',false)	
}

function save(){
	var chiefcomplaint=$("#chiefcomplaint").val();
	
	if(chiefcomplaint.length>200){
		$.messager.alert("提示:","主诉最大字符数200!");
		return;
	}
	
	$.cm({ 
		ClassName:"web.DHCMDTemp",
		MethodName:"savemeettemp",
		'formId':mdtID,
		'par':loopStr("#from"),
		dataType:"text"
	},function(val){
		if(val == 0){
			$.messager.alert("提示:","保存成功!");
			return;
		}else{
			if(val.length>100) val=val.substring(0,100)+"......"
			$.messager.alert("提示:","保存失败!信息为:"+val);
			return;	
		}
	})
}

/// 引用
function OpenEmr(flag){

	var Link = "dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&Flag="+flag+"&MWToken="+websys_getMWToken();;
//	if (!isIE()){
	websys_showModal({
		url:Link,
		title:'引用',
		width: 1280,
		height: 600,
		InsQuote:function(resQuote,flag){
			InsQuote(resQuote,flag);
		},
		onClose: function() {
			
		}
	});
}

/// 插入引用内容
function InsQuote(resQuote, flag){
	if(flag == 1){
		if ($("#labexamination").val() == ""){
			$("#labexamination").val(resQuote);   /// 简要病历
		}else{
			$("#labexamination").val($("#labexamination").val()  +"\r\n"+ resQuote);   /// 简要病历
		}
	}		
	if(flag == 2){
		if ($("#imageexam").val() == ""){
			$("#imageexam").val(resQuote);   /// 简要病历
		}else{
			$("#imageexam").val($("#imageexam").val()  +"\r\n"+ resQuote);   /// 简要病历
		}
	}
}

///导出打印模板
function exportword()
{
	var prehtml="";
	prehtml=prehtml+"<body>"
	prehtml=prehtml+"<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>"
	prehtml=prehtml+"</body>"
	
	//查体
	var physical=$('#physical').val();
	physical.replace(/\r/g,"<br/>");
	physical.replace(/\n/g,"<br/>");
	//诊疗经过
	var treatment=$('#treatment').val();
	//实验室检查
	var labexamination=$('#labexamination').val();
	labexamination.replace(/\r/g,"<br/>");
	labexamination.replace(/\n/g,"<br/>");
	//影像学
	var imageexam=$('#imageexam').val();
	imageexam.replace(/\r/g,"<br/>");
	imageexam.replace(/\n/g,"<br/>");
	console.log(imageexam)
	//临床诊断
	var clinicaldiag=$('#clinicaldiag').val();
	clinicaldiag.replace(/\r/g,"<br/>");
	clinicaldiag.replace(/\n/g,"<br/>");
	//会诊目的
	var cstpurpose=$('#cstpurpose').val();
	cstpurpose.replace(/\r/g,"<br/>");
	cstpurpose.replace(/\n/g,"<br/>");
	
	var html="";
	html = html+ '<div id="word" >'
	html = html+ '<table style="border-collapse:collapse;border:none;width:300mm;">'
	//html = html+ 	'<tr><td style="font-size:22pt;font-weight:bold;background-color:#3276B1;color:#FFFFFF">基本资料</td></tr>';
	html = html+ 	'<tr style="height:225mm;">';
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">基本资料</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">姓名：'+$('#PatName').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">性别：'+$('#PatSex').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">年龄：'+$('#PatAge').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">籍贯：'+$('#PatBDay').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">主诉：'+$('#chiefcomplaint').val()+'</p>'
	html = html+ 		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">查体</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+physical+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">诊疗经过</p>'
	html = html+ 			'<pre style="font-size:30pt;font-weight:bold;">'+treatment+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;" >'
	html = html+ 		'<td valign="top" style="font-size:18pt;font-weight:bold;">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">实验室检查</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+labexamination+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr >';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">影像学</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+imageexam+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top" style="font-size:18pt;font-weight:bold;">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">临床诊断</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+clinicaldiag+'</pre>'
	html = html+			'<p style="font-size:40pt;">&nbsp;</p>'
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">会诊目的</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+cstpurpose+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'</table>';
	html = html+ '</div>';
	
	$("body").append(prehtml)
	$("#tableData").empty()     //先清空内容
	$("#tableData").append(html);
	
    $("#tableData").wordExport("会议模板")
}

/// 关闭
function closewin(){	
	commonParentCloseWin();
}
/// JQuery 初始化页面
$(function(){ initPageDefault(); })