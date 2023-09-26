var FavEpisodeID=""; //�ղ�ʱ�ľ����
var InstanceID="",categoryId="",templateId="";
$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	setFontData();
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
	setChick(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setViewRevision(flag);
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
	$('#viewRevision').linkbutton(flag);
	//$('#recordtransfer').linkbutton(flag);
	$('#PDF').linkbutton(flag);
	$('#unLock').linkbutton(flag);
}
///Desc:�Ƿ�ɴ�ӡ
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
}
///Desc:�Ƿ��ɾ��
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///Desc:�Ƿ��ǩ��
function setChick(flag)
{
	$('#chick').linkbutton(flag);
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

//�ĵ�����
document.getElementById("reference").onclick = function(){
	
	if ($("#reference").attr("flag") && ($("#reference").attr("flag")=="false"))
	{
		if($.IEVersion()==-1){

		      window.frames["framRecord"].contentWindow.reference("remove");
	    }
	    else{
		      window.frames["framRecord"].reference("remove");
	    } 
		$("#reference").attr("flag",true);	
	}else
	{
		if($.IEVersion()==-1){

		      window.frames["framRecord"].contentWindow.reference("add");
	    }
	    else{
		      window.frames["framRecord"].reference("add");
	    } 
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
	var tempflag=document.getElementById('framRecord').contentWindow.tempFlag; //�л�ҩ���ı��
	if(tempflag=="δ�л�ҩ��"){ //û�е���л�ҩ��
		InstanceID = recordParam.id;
		categoryId = recordParam.categoryId;
		templateId = recordParam.templateId;
		//alert(InstanceID+","+categoryId+","+templateId)
	}
	else{
		var tempParams = document.getElementById('framRecord').contentWindow.tempParams;
		InstanceID = tempParams.InstanceID;
		categoryId = tempParams.categoryId;
		templateId = tempParams.templateId;
	}
	getEpisodeID(InstanceID);
	if (!window.frames["framRecord"]) return;							
		if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.saveDocument(); 
	}
	else{
		  window.frames["framRecord"].saveDocument();      //lbb  2019/05/21  	 
	   }     
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
    var arr = {"userId":userID,"userLocId":userLocID};
	var tempFrame = "<iframe id='iframeFavAdd' scrolling='auto' frameborder='0' src='dhcpha.clinical.favorite.add.csp?EpisodeID="+episodeID+"&InstanceID="+ InstanceID+"&categoryId="+categoryId+"&templateId="+templateId+ "' style='width:450px; height:450px; display:block;'></iframe>";
	document.getElementById("framRecord").style.visibility="hidden";
	createDialog("dialogFavAdd","����ղ�","454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
	};
	//����ղػص���¼��־
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //��¼�û�(�ղز���.ȡ��)��Ϊ
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}
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
	var returnValues = window.open("dhcpha.clinical.favorite.csp","",'resizable=yes,directories=no,top=0,left=0,width='+xpwidth+',height='+xpheight);
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
		if (!window.frames["framRecord"]) return;							
		if($.IEVersion()==-1){
		    if (window.frames["framRecord"].contentWindow.unLock(lockId)=="1")
			{
				window.frames["framRecord"].contentWindow.setReadOnly(false,"");
				window.frames["framRecord"].contentWindow.lockDocument("");
				$("#lock").empty(); 
			}
			else
			{
				alert("����ʧ��");
			}	
	    }
	    else{
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
/*document.getElementById("spechars").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	window.frames["framRecord"].insertText(returnValues); 
};*/
//�����ַ�   lbb modify 2018/8/16  ȡֵΪ�ַ����޸�ȡֵ
document.getElementById("spechars").onclick = function(){
		if (!framRecord) return;
	var tempFrame = "<iframe id='iframeSpechars' scrolling='auto' frameborder='0' src='dhcpha.clinical.spechars.csp' style='width:510px; height:428px; display:block;'></iframe>";
	document.getElementById("framRecord").style.visibility="hidden";
	createDialog("dialogSpechars","�����ַ�","514","480","iframeSpechars",tempFrame,speCallback,"");
}
function createDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback,arr){
    if ($("#modalIframe").length<1)
	{
        $("body").append('<iframe id="modalIframe" style="position: absolute; z-index: 1999; width: 100%; height: 100%; top: 0;left:0;scrolling:no;" frameborder="0"></iframe>');
    }
	else
	{
        $("#modalIframe").css("display","block");
    }
    $("body").append("<div id='"+dialogId+"'</div>");
	if (isNaN(width)) width = 800;
	if (isNaN(height)) height = 500; 
    
    var returnValue = "";
	$('#'+dialogId).dialog({ 
        title: dialogTitle,
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $('#'+iframeId)[0].contentWindow;
			if (tempFrame.dialogBeforeClose)
			{
				tempFrame.dialogBeforeClose();
			}
            if (tempFrame && tempFrame.returnValue)
			{
				returnValue = tempFrame.returnValue;
			    if ((returnValue !== "") &&(typeof(callback) === "function"))
				{
                    callback(returnValue,arr);
                }
			}
        },
        onClose:function(){
            $("#modalIframe").hide();
            document.getElementById("framRecord").style.visibility="visible";
			$("#"+dialogId).dialog('destroy');
        }
    });
}
function speCallback(returnValue)
{
	if (returnValue != "")	
	{   	
			var str=""
			var returnValues=eval('(' + returnValue + ')')
	    	var values=returnValues.items;
			for(var i=0;i<values.length;i++)
			{		
        		 var rtn=values[i].TEXT
         		if(str=="")   str=rtn 
         		else   str=str+","+rtn
			}							
		if($.IEVersion()==-1){

		     window.frames["framRecord"].contentWindow.insertText(str); 
	    }
	    else{
		     window.frames["framRecord"].insertText(str);       	 
	    }    	    
	} 
};


//����
document.getElementById("save").onclick = function(){
	if (!window.frames["framRecord"]) return;	
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.saveDocument(); 
	}
	else{
		   window.frames["framRecord"].saveDocument(); 	 
	   }	
	
};

//��ӡ
document.getElementById("print").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.printDocument(); 
	}
	else{
		   window.frames["framRecord"].printDocument(); 	 
	   }	
};
//ɾ���ĵ�
document.getElementById("delete").onclick = function(){
	if (!window.frames["framRecord"]) return;	
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.deleteDocument(); 
	}
	else{
		   window.frames["framRecord"].deleteDocument(); 	 
	   }		
}
//ǩ��
document.getElementById("chick").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.audit(); 
	}
	else{
		   window.frames["framRecord"].audit(); 	 
	   }	 
}
//ˢ�°�����
document.getElementById("binddatareload").onclick = function(){
	if (!window.frames["framRecord"]) return;
	//��ȡ��ǰ��ĵ���instanceID
	if($.IEVersion()==-1){
        var instanceID = window.frames["framRecord"].contentWindow.getDocumentContext().InstanceID; 						
	    window.frames["framRecord"].contentWindow.refreshReferenceData(instanceID,"false"); 
	}
	else{
		  var instanceID = window.frames["framRecord"].getDocumentContext().InstanceID; 						
	      window.frames["framRecord"].refreshReferenceData(instanceID,"false"); 	 
	   }
}
//��ʾ����
$("#viewRevision").on("click",function(){
	if (!window.frames["framRecord"]) return;						
	if ($("input[type='checkbox']").is(":checked")==true)
	{
		window.frames["framRecord"].viewRevision(true); 
		$("input[type='checkbox']").attr("checked",false);
	}else
	{
		window.frames["framRecord"].viewRevision(false); 
		$("input[type='checkbox']").attr("checked",true);
	}
})

//�ж����ۿ��Ƿ�ѡ
function isViewRevisionCheck()
{
	return "false";  //qunianpeng 2018/3/29 
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
	if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.exportDocument();
	    }
	else{
		       window.frames["framRecord"].exportDocument();
	    } 						
	 
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
		//$("#recording").attr("title","��������¼��");
		$("#recording").css("background","url('../scripts/dhcpha/emr/image/toolbar/startrecord.png') no-repeat center center");			
		if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.setASRVoiceStatus(false);
	    }
	else{
		       window.frames["framRecord"].setASRVoiceStatus(false);
	    } 
		
	}
	else
	{
		$("#recording").attr("flag",false);
		//$("#recording").attr("title","�ر�����¼��");
		$("#recording").css("background","url('../scripts/dhcpha/emr/image/toolbar/endrecord.png') no-repeat center center");		
		if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.setASRVoiceStatus(true);
	    }
	else{
		      window.frames["framRecord"].setASRVoiceStatus(true);
	    } 
		
	}	
	 
}

//ִ������
function doExecute(strJson)
{
	if (!window.frames["framRecord"] || window.frames["framRecord"].length<=0) return;
	if($.IEVersion()==-1){
		window.frames["framRecord"].contentWindow.cmdDoExecute(strJson);  
	}
	else{
		  window.frames["framRecord"].cmdDoExecute(strJson);  	 
	   }						
		
}

///��ʼ������״̬
function initToolbarStatus()
{
	//��ʼ������¼��
	$("#recording").attr("flag",true);
	$("#recording").attr("title","��������¼��");
	$("#recording").css("background","url('../scripts/dhcpha/emr/image/toolbar/startrecord.png') no-repeat center center");	
    if($.IEVersion()==-1){

	    if (!window.frames["framRecord"].contentWindow.plugin()) return;
	    window.frames["framRecord"].contentWindow.setASRVoiceStatus(false);	
	}
	else{
		   if (!window.frames["framRecord"].plugin()) return;
	       window.frames["framRecord"].setASRVoiceStatus(false);	 
	   }	
	
	//��ʼ�����۲鿴
	$('#viewRevision input').attr("checked",false);
	
}

//�жϵ�ǰ�û��Ƿ��ǵ�ǰ���ߵ�����ҽ����ֻ������ҽ�����в���ת��Ȩ�ޣ�
function setRecordtransfer()
{
	if (mainDoc != userCode)
	{
		//$('#recordtransfer').linkbutton("disable");	
	}
}
//�򿪲���ת�ƴ���
/* document.getElementById("recordtransfer").onclick = function(){
	var returnValues = window.open("dhcpha.clinical.recordtransfer.csp?EpisodeID=" +  episodeID,"recordtransferWin","resizable:no;status:no,width=325,height=450");
} */

//���ƹ�������������ʽ�Ȱ�ť����ʾ������
function setToolBarFontView(disableFont)
{
	var strs = new Array(); //����һ����
	strs = disableFont.split(","); //�ַ��ָ�
	for (i=0;i<strs.length;i++ )
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

//��ɲ���,����PDF
function generatePDF(){
	var text = '����PDF���޷��޸�ҩ�����Ƿ�ȷ���ύ��';
	var returnValues = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
	if (returnValues == "cancel"){
		return;
	}else if (returnValues == "confirm"){
		var result = false;
		$.ajax({
			type: "GET",
			url: "../DHCEPRFS.web.eprajax.AdmMRStatusMgr.cls?EpisodeID="+episodeID+"&UserID="+userID+"&ActionType=doctor", 
			async : false,
			success: function (data){
				if (data == "1") result = true;
			}
		});
		if (result){
			$.messager.show({title:'������ʾ',msg:'����PDF�ɹ�!',showType:'slide',timeout:5000});
		}else{
			$.messager.show({title:'������ʾ',msg:'�ύʧ��,δ����PDF',showType:'slide',timeout:5000});
		}
	} 
}

//��λ���ϴ���дλ��
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}

//����ҩ��id��ȡ�����
function getEpisodeID(InstanceID){
	runClassMethod("web.DHCCM.drugFav","getEpsoideID",{"InstanceID":InstanceID},function(jsonObj){
		FavEpisodeID=jsonObj;
	},'',false);
}