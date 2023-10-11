$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	setFontData();
	//setFontSizeData();
	if (disableFont != "")
	{
		//���ƹ�������������ʽ�Ȱ�ť����ʾ������
		setToolBarFontView(disableFont);
	}
	setToolBarStatus("disable");
	setRecordtransfer();
});

//������������Դ
function setFontData()
{
	var json=[{"value":"����","name":"����"},
	          {"value":"����","name":"����"},
	          {"value":"����","name":"����"},
	          {"value":"����","name":"����"}
	         ]
	$('#font').combobox({
		data : json ,                       
		valueField:'value',                        
		textField:'name'
	});	
	$('#font').combobox('setValue',json[0].value)     
}
//���������С����Դ
function setFontSizeData()
{
	var json=[{"value":"42pt","name":"����"},
			  {"value":"36pt","name":"С����"},
	          {"value":"31.5pt","name":"��һ��"},
	          {"value":"28pt","name":"һ��"},
	          {"value":"21pt","name":"����"},
	          {"value":"18pt","name":"С����"},
	          {"value":"16pt","name":"����"},
	          {"value":"14pt","name":"�ĺ�"},
	          {"value":"12pt","name":"С�ĺ�"},
	          {"value":"10.5pt","name":"���"},
	          {"value":"9pt","name":"С���"},
	          {"value":"8pt","name":"����"},
	          {"value":"6.875pt","name":"С����"},
	          {"value":"5.25pt","name":"�ߺ�"},
	          {"value":"4.5pt","name":"�˺�"},
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

//���ù�����״̬
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



///Desc:�Ƿ�ɱ༭
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
}
///Desc:�Ƿ�ɴ�ӡ
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
	$('#printView').linkbutton(flag);
}
///Desc:�Ƿ��ɾ��
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///��д�Ա�
function setReference(flag)
{
	$('#reference').linkbutton(flag);
}
///�Ƿ�ɵ���
function setExportDocumnet(flag)
{
	$('#export').linkbutton(flag);	
}
///�Ƿ���ʾ���ۿ���
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

///Desc:�Ƿ���Ͳ�����
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}


//�ĵ�����
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

//�۵���Դ��
function collapseResourse()
{
	$('#recordlayout').layout('collapse','east');
}

//����ղ�
document.getElementById("favoritesPlus").onclick = function(){
	//����������¼��Ҫ���� start
	var categoryId = "";
	var templateId = "";
	if (recordParam != "")
	{
		categoryId = recordParam.categoryId;
		templateId = recordParam.templateId;
	}
	//����������¼��Ҫ���� end
	//��¼�û�(�ղز���)��Ϊ
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
	var returnValues = window.showModalDialog("emr.favorite.add.csp?EpisodeID="+episodeID+"&InstanceID="+recordParam.id+"&categoryId="+categoryId+"&templateId="+templateId,"","dialogHeight:450px;dialogWidth:450px;resizable:no;status:no");
};
//�����ղؼ�
document.getElementById("favorites").onclick = function(){
	
	//��¼�û�(�����ղ�)��Ϊ
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

//�ֹ�����
document.getElementById("unLock").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var lockcode = $("#lock span").attr("userCode");
	var lockname = $("#lock span").attr("userName");
	var lockId = $("#lock span").attr("lockId");
	if (lockcode != undefined )
	{
		if (!confirm("ȷ��������?")) return;
		if (lockcode != userCode)
		{
			var result = window.showModalDialog("emr.userverification.csp?UserID="+lockcode+"&UserName="+lockname,"","dialogHeight:160px;dialogWidth:100px;resizable:no;status:no");
			if (result == "") 
			{
				return;
			}
			else if(result == "0")
			{
				alert("������֤ʧ��");
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
			alert("����ʧ��");
		}	
	}
};

//����
$('#font').combobox({
	onSelect: function (record) {
		strJson = {action:"FONT_FAMILY",args:record.value};
		doExecute(strJson);		
	}
});

//�ֺ�
$('#fontSize').combobox({
	onSelect: function(record){
		strJson = {action:"FONT_SIZE",args:record.value};
		doExecute(strJson);		
	}
});

//����������ɫ   start
$("#fontcolor").colorpicker({
});
//��/�ر���ɫѡ����
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
//��������ɫ�����༭��
function setFontColor(color){
	//alert("get+"+color);
	strJson = {action:"FONT_COLOR",args:color}; 
 	doExecute(strJson);	
};
//����������ɫ   end

//���ô���
document.getElementById("bold").onclick = function(){
 	strJson = {action:"BOLD",args:{path:""}}; 
 	doExecute(strJson);	
};

//����б��
document.getElementById("italic").onclick = function(){
 	strJson = {action:"ITALIC",args:""}; 
 	doExecute(strJson);	
};

//�����»���
document.getElementById("underline").onclick = function(){
 	strJson = {action:"UNDER_LINE",args:""};
 	doExecute(strJson);	
};

//ɾ����
document.getElementById("strike").onclick = function(){
 	strJson = {action:"STRIKE",args:""};
 	doExecute(strJson);	
};

//�����ϱ�
document.getElementById("super").onclick = function(){
 	strJson = {action:"SUPER",args:""};
 	doExecute(strJson);	
};

//�����±�
document.getElementById("sub").onclick = function(){
 	strJson = {action:"SUB",args:""};
 	doExecute(strJson);	
};

//�������˶���
document.getElementById("alignjustify").onclick = function(){
 	strJson = {action:"ALIGN_JUSTIFY",args:""}; 
 	doExecute(strJson);	
};

//���������
document.getElementById("alignleft").onclick = function(){
 	strJson = {action:"ALIGN_LEFT",args:""}; 
 	doExecute(strJson);	
};

//���þ��ж���
document.getElementById("aligncenter").onclick = function(){
 	strJson = {action:"ALIGN_CENTER",args:""}; 
 	doExecute(strJson);	
};

//�����Ҷ���
document.getElementById("alignright").onclick = function(){
 	strJson = {action:"ALIGN_RIGHT",args:""}; 
 	doExecute(strJson);	
};

//��������
document.getElementById("indent").onclick = function(){
 	strJson = {action:"INDENT",args:""};
 	doExecute(strJson);	
};

//���÷�����
document.getElementById("unindent").onclick = function(){
 	strJson = {action:"UNINDENT",args:""};  
 	doExecute(strJson);	
};

//����
document.getElementById("cut").onclick = function(){
 	strJson = {action:"CUT",args:""};  
 	doExecute(strJson);	
};

//����
document.getElementById("copy").onclick = function(){
 	strJson = {action:"COPY",args:""};  
 	doExecute(strJson);	
};

//ճ��
document.getElementById("paste").onclick = function(){
 	strJson = {action:"PASTE",args:""};  
 	doExecute(strJson);	
};

//����
document.getElementById("undo").onclick = function(){
 	strJson = {action:"UNDO",args:""}; 
 	doExecute(strJson);	
};

//����
document.getElementById("redo").onclick = function(){
 	strJson = {action:"REDO",args:""}; 
 	doExecute(strJson);	
};

//�����ַ�
document.getElementById("spechars").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	window.frames["framRecord"].insertStyleText(returnValues); 
};

//����
document.getElementById("save").onclick = function(){
	if (!window.frames["framRecord"]) return;	
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].saveDocument(); 
};

//��ӡ
document.getElementById("print").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].printDocument();	
};
//ɾ���ĵ�
document.getElementById("delete").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].deleteDocument();
}

//ˢ�°�����
document.getElementById("binddatareload").onclick = function(){
	if (!window.frames["framRecord"]) return;
	//��ȡ��ǰ��ĵ���instanceID
	var instanceID = window.frames["framRecord"].getDocumentContext().InstanceID; 						
	window.frames["framRecord"].refreshReferenceData(instanceID,"false"); 
}
//��ʾ����
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

//�ж����ۿ��Ƿ�ѡ
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


//��������
document.getElementById("export").onclick = function(){
	if (!window.frames["framRecord"]) return;						
	window.frames["framRecord"].exportDocument(); 
}

//������
document.getElementById("clipboard").onclick = function(){
	 $("#recordlayout").layout("expand","east"); 
	var clipboard = "<iframe id='framclipboard' frameborder='0' src='emr.clipboard.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addResourceTab("clipboard","������",clipboard,false); 

};

//����¼�벡��
document.getElementById("recording").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if ($("#recording").attr("flag") && $("#recording").attr("flag")=="false")	
	{
		$("#recording").attr("flag",true);
		$("#recording").attr("title","��������¼��");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/startrecord.png') no-repeat center center");			
		window.frames["framRecord"].setASRVoiceStatus(false);
	}
	else
	{
		$("#recording").attr("flag",false);
		$("#recording").attr("title","�ر�����¼��");
		$("#recording").css("background","url('../scripts/emr/image/toolbar/endrecord.png') no-repeat center center");		
		window.frames["framRecord"].setASRVoiceStatus(true);
	}	
	 
}

//ִ������
function doExecute(strJson)
{
	if (!window.frames["framRecord"] || window.frames["framRecord"].length<=0) return;						
	window.frames["framRecord"].cmdDoExecute(strJson); 	
}

///��ʼ������״̬
function initToolbarStatus()
{
	//��ʼ������¼��
	$("#recording").attr("flag",true);
	$("#recording").attr("title","��������¼��");
	$("#recording").css("background","url('../scripts/emr/image/toolbar/startrecord.png') no-repeat center center");			
	
	//��ʼ����ӡԤ��
	$("#printView").attr("flag",true);
	$("#printView").attr("title","������ӡԤ��");
	$("#printViewText").html("����Ԥ��");
	
	if (!window.frames["framRecord"].plugin()) return;
	window.frames["framRecord"].setASRVoiceStatus(false);
	window.frames["framRecord"].setPreviewDocumentState(false);
	
	//��ʼ�����۲鿴
	$('#viewRevision input').attr("checked",false);
	
}

//�жϵ�ǰ�û��Ƿ��ǵ�ǰ���ߵ�����ҽ����ֻ������ҽ�����в���ת��Ȩ�ޣ�
function setRecordtransfer()
{
	if (mainDoc != userCode)
	{
		$('#recordtransfer').linkbutton("disable");	
	}
}
//�򿪲���ת�ƴ���
document.getElementById("recordtransfer").onclick = function(){
	var returnValues = window.open("emr.record.recordtransfer.csp?EpisodeID=" +  episodeID,"recordtransferWin","resizable:no;status:no,width=325,height=450");
}

//���ƹ�������������ʽ�Ȱ�ť����ʾ������
function setToolBarFontView(disableFont)
{
	var strs = new Array(); //����һ����
	strs = disableFont.split(","); //�ַ��ָ�
	for (i=0;i<strs.length;i++ )
	{
		if (document.getElementById(strs[i]) != null)
		{
			if (strs[i] == "font")
			{
				document.getElementById("fontSpan").style.display="none";
			}
			else if(document.getElementById(strs[i]))
			{
				document.getElementById(strs[i]).style.display="none";
			}
		}	
	} 
}

//ȷ�ϲ���ȫ�����
function confirmRecordFinished()
{
	//���޸ı��뱣��󣬲ſ�ȷ�ϲ���ȫ�����
	if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	{
		var result = window.frames["framRecord"].savePrompt();
		if ((result != "")&&(result != "save")) return;
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "ȷ�ϲ���ȫ����ɺ��޷��޸Ĳ������Ƿ�ȷ���ύ?";
	if (window.confirm(tipMsg)){

		//��ȡȷ�ϲ���ȫ������Ƿ�ɹ�
		var completeResult = getCompleteResult();
		if (completeResult == true)
		{
			alert("ȷ�ϲ���ȫ����ɳɹ�");
			setToolbarPrivilege();
		}
		else 
		{
			alert("ȷ�ϲ���ȫ�����ʧ��");
		}
		
		if (getProductStatus("DHCEPRFS") == true)
		{
			//��ȡ�����鵵�ύ�Ƿ�ɹ�
			var fileSubmitResult = getFileSubmitResult();
			if (fileSubmitResult == true)
			{
				alert("�����鵵�ύ�ɹ�");
			}
			else if(fileSubmitResult == false)
			{
				alert("�����鵵�ύʧ��");
			}
		}
	} 
}

//��ȡ�����鵵�ύ�Ƿ�ɹ�
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

//ȷ�ϲ���ȫ�����
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

//�жϸ���Ŀ�Ƿ����˸ò�Ʒ
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

//��λ���ϴ���дλ��
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}
/*
//�޸��ϼ�ҽʦ
document.getElementById("modifysuper").onclick = function(){
	window.open('emr.setsuperior.csp?UserID='+userID+'&UserName='+userName+'&UserLoc='+userLocID+'&SSGroupID='+ssgroupID,'','width=500px,height=300px'); 
}
//��������ҽʦ
document.getElementById("setpatientdoctor").onclick = function(){
	window.open('emr.setpatientdoctor.csp?UserID='+userID+'&UserName='+userName+'&UserLoc='+userLocID+'&SSGroupID='+ssgroupID+'&EpisodeID='+episodeID,'','width=500px,height=300px'); 
}*/
//��ӡԤ��
document.getElementById("printView").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if (window.frames["framRecord"].getModifyStatus().Modified == "True")
	{
		var text = '�ĵ����ڱ༭���뱣�����Ԥ�����Ƿ񱣴棿';
		//�жϿͻ��������IE����汾
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
		$("#printView").attr("title","������ӡԤ��");
		$("#printViewText").html("����Ԥ��");
		window.frames["framRecord"].setPreviewDocumentState(false);	
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printView.png') no-repeat center center");
		$('#printViewMessage').css('display','none');
	}
	else
	{
		$("#printView").attr("flag",false);
		$("#printView").attr("title","�رմ�ӡԤ��");
		$("#printViewText").html("�ر�Ԥ��");
		window.frames["framRecord"].setPreviewDocumentState(true);	
		//$("#printView").css("background","url('../scripts/emr/image/toolbar/printViewClose.jpg') no-repeat center center");	
		$('#printViewMessage').css('display','block');		
	}	
	 
}

///���ù�����Ȩ��
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
	//�����ʿ�
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
				var content = "ȷ�ϲ���ȫ�����ʧ�ܣ�" + "\n";
			}
			var strs = new Array(); //����һ����
			strs = strQualityData.split("#"); //�ַ��ָ�
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

//�ʿ�
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
//��ͼ�ⴰ��
document.getElementById("image").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var xpwidth=window.screen.width-10;
	var xpheight=window.screen.height-35;
	var returnValues = window.showModalDialog("emr.image.csp","","dialogHeight:"+xpwidth+";dialogWidth:"+xpheight+";resizable:yes;status:no");
	if (returnValues)	
	{
		window.frames["framRecord"].insertIMG(returnValues);
		window.frames["framRecord"].changeIMGfreq(returnValues);
	}
}

///�Ƿ�������Զ�����
function setApplyeditDocumnet(flag)
{
	$('#applyedit').linkbutton(flag);	
}

//�����Զ�����
document.getElementById("applyedit").onclick = function(){
	if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	{
		window.frames["framRecord"].applyedit();
	}
}

///Desc:�Ƿ���ֹ�����
function setUnLockStatus(flag)
{
	$('#unLock').linkbutton(flag);
}


//������
document.getElementById("insertTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};

//ɾ�����
document.getElementById("deleteTable").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_TABLE",args:{path:""}}; 
 	doExecute(strJson);	
};


//������
document.getElementById("insertRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//ɾ����
document.getElementById("deleteRow").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_ROW",args:{path:""}}; 
 	doExecute(strJson);	
};

//������
document.getElementById("insertCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_INSERT_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//ɾ����
document.getElementById("deleteCol").onclick = function(){
 	strJson = {action:"TOOL_BAR_DELETE_COL",args:{path:""}}; 
 	doExecute(strJson);	
};

//��ֵ�Ԫ��
document.getElementById("splitCells").onclick = function(){
 	strJson = {action:"TOOL_BAR_SPLIT_CELLS",args:{path:""}}; 
 	doExecute(strJson);	
};

