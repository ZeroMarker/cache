//===========================================================================================
// ���ߣ�      lvpeng
// ��д����:   2021-04-08
// ����:	   ����ģ���ӡ 
//===========================================================================================
/// ҳ���ʼ������
function initPageDefault(){
	
	/// ��ʼ�����ز��˾���ID
	InitPatEpisodeID();
	InitButton();
	GetPatBaseInfo();
	if(tempID > 0){
		initRecord(); //������д����
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

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	EpisodeID = getParam("EpisodeID");   /// ����ID
	DisGrpID = getParam("DisGrpID");     /// ����ID
	mdtID = getParam("ID");  //����id
	PatientID = getParam("PatientID");
}

/// ������д����
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
			 $('#cstpurpose').val(CstPurpose); //����Ŀ��
		}
	},'text',false)
	
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	
	runClassMethod("web.DHCMDTConsultQuery","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		var jsonObject = jsonString;
		if (jsonObject != ""){
			 $("#PatName").val(jsonObject.PatName); /// ����
			 $("#PatSex").val(jsonObject.PatSex);   /// �Ա�
			 $("#PatAge").val(jsonObject.PatAge);   /// ����
			 $("#PatBDay").val(jsonObject.RegisterPlace);   /// ����
			 if(jsonObject.RegisterPlace == ""){
				$("#PatBDay").val(jsonObject.RAddress);   /// ����	 
			 }
			 $("#clinicaldiag").val(formatHtmlToValue(jsonObject.PatDiagDesc)); /// ���
		}
	},'json',false)	
}

function save(){
	var chiefcomplaint=$("#chiefcomplaint").val();
	
	if(chiefcomplaint.length>200){
		$.messager.alert("��ʾ:","��������ַ���200!");
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
			$.messager.alert("��ʾ:","����ɹ�!");
			return;
		}else{
			if(val.length>100) val=val.substring(0,100)+"......"
			$.messager.alert("��ʾ:","����ʧ��!��ϢΪ:"+val);
			return;	
		}
	})
}

/// ����
function OpenEmr(flag){

	var Link = "dhcem.patemrque.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&Flag="+flag+"&MWToken="+websys_getMWToken();;
//	if (!isIE()){
	websys_showModal({
		url:Link,
		title:'����',
		width: 1280,
		height: 600,
		InsQuote:function(resQuote,flag){
			InsQuote(resQuote,flag);
		},
		onClose: function() {
			
		}
	});
}

/// ������������
function InsQuote(resQuote, flag){
	if(flag == 1){
		if ($("#labexamination").val() == ""){
			$("#labexamination").val(resQuote);   /// ��Ҫ����
		}else{
			$("#labexamination").val($("#labexamination").val()  +"\r\n"+ resQuote);   /// ��Ҫ����
		}
	}		
	if(flag == 2){
		if ($("#imageexam").val() == ""){
			$("#imageexam").val(resQuote);   /// ��Ҫ����
		}else{
			$("#imageexam").val($("#imageexam").val()  +"\r\n"+ resQuote);   /// ��Ҫ����
		}
	}
}

///������ӡģ��
function exportword()
{
	var prehtml="";
	prehtml=prehtml+"<body>"
	prehtml=prehtml+"<div class='no-print'><table id='tableData' style='display:none;height:0px;'></table></div>"
	prehtml=prehtml+"</body>"
	
	//����
	var physical=$('#physical').val();
	physical.replace(/\r/g,"<br/>");
	physical.replace(/\n/g,"<br/>");
	//���ƾ���
	var treatment=$('#treatment').val();
	//ʵ���Ҽ��
	var labexamination=$('#labexamination').val();
	labexamination.replace(/\r/g,"<br/>");
	labexamination.replace(/\n/g,"<br/>");
	//Ӱ��ѧ
	var imageexam=$('#imageexam').val();
	imageexam.replace(/\r/g,"<br/>");
	imageexam.replace(/\n/g,"<br/>");
	console.log(imageexam)
	//�ٴ����
	var clinicaldiag=$('#clinicaldiag').val();
	clinicaldiag.replace(/\r/g,"<br/>");
	clinicaldiag.replace(/\n/g,"<br/>");
	//����Ŀ��
	var cstpurpose=$('#cstpurpose').val();
	cstpurpose.replace(/\r/g,"<br/>");
	cstpurpose.replace(/\n/g,"<br/>");
	
	var html="";
	html = html+ '<div id="word" >'
	html = html+ '<table style="border-collapse:collapse;border:none;width:300mm;">'
	//html = html+ 	'<tr><td style="font-size:22pt;font-weight:bold;background-color:#3276B1;color:#FFFFFF">��������</td></tr>';
	html = html+ 	'<tr style="height:225mm;">';
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">��������</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">������'+$('#PatName').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">�Ա�'+$('#PatSex').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">���䣺'+$('#PatAge').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">���᣺'+$('#PatBDay').val()+'</p>'
	html = html+			'<p style="font-size:30pt;font-weight:bold;">���ߣ�'+$('#chiefcomplaint').val()+'</p>'
	html = html+ 		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">����</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+physical+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">���ƾ���</p>'
	html = html+ 			'<pre style="font-size:30pt;font-weight:bold;">'+treatment+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;" >'
	html = html+ 		'<td valign="top" style="font-size:18pt;font-weight:bold;">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">ʵ���Ҽ��</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+labexamination+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr >';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">Ӱ��ѧ</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+imageexam+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'<tr style="height:225mm;">'
	html = html+ 		'<td valign="top" style="font-size:18pt;font-weight:bold;">';
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">�ٴ����</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+clinicaldiag+'</pre>'
	html = html+			'<p style="font-size:40pt;">&nbsp;</p>'
	html = html+			'<p style="font-size:40pt;font-weight:bold;background-color:#a4c2f4;color:#FFFFFF;">����Ŀ��</p>'
	html = html+			'<pre style="font-size:30pt;font-weight:bold;">'+cstpurpose+'</pre>'
	html = html+		'</td>';
	html = html+ 	'</tr>';
	html = html+ 	'</table>';
	html = html+ '</div>';
	
	$("body").append(prehtml)
	$("#tableData").empty()     //���������
	$("#tableData").append(html);
	
    $("#tableData").wordExport("����ģ��")
}

/// �ر�
function closewin(){	
	commonParentCloseWin();
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })