var FavEpisodeID=""; //收藏时的就诊号
var InstanceID="",categoryId="",templateId="";
$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	setFontData();
	if (disableFont != "")
	{
		//控制工具栏字体段落格式等按钮的显示和隐藏
		setToolBarFontView(disableFont);
	}
	setToolBarStatus("disable");
	setRecordtransfer();
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
	setChick(flag);
	setExportDocumnet(flag);
	setReference(flag);
	setViewRevision(flag);
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
	$('#viewRevision').linkbutton(flag);
	//$('#recordtransfer').linkbutton(flag);
	$('#PDF').linkbutton(flag);
	$('#unLock').linkbutton(flag);
}
///Desc:是否可打印
function setPrintStatus(flag)
{
	$('#print').linkbutton(flag);
}
///Desc:是否可删除
function setDeleteStatus(flag)
{
	$('#delete').linkbutton(flag);
}
///Desc:是否可签名
function setChick(flag)
{
	$('#chick').linkbutton(flag);
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

//文档对照
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

//折叠资源区
function collapseResourse()
{
	$('#recordlayout').layout('collapse','east');
}

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	var tempflag=document.getElementById('framRecord').contentWindow.tempFlag; //切换药历的标记
	if(tempflag=="未切换药历"){ //没有点击切换药历
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
	createDialog("dialogFavAdd","添加收藏","454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
	};
	//添加收藏回调记录日志
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //记录用户(收藏病历.取消)行为
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}
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
	var returnValues = window.open("dhcpha.clinical.favorite.csp","",'resizable=yes,directories=no,top=0,left=0,width='+xpwidth+',height='+xpheight);
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
				alert("解锁失败");
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
				alert("解锁失败");
			}	       	 
	    }  
		
	}
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
/*document.getElementById("spechars").onclick = function(){
	if (!window.frames["framRecord"]) return;
	var returnValues = window.showModalDialog("emr.spechars.csp","","dialogHeight:480px;dialogWidth:490px;resizable:no;status:no");	
	if (returnValues != "")	window.frames["framRecord"].insertText(returnValues); 
};*/
//特殊字符   lbb modify 2018/8/16  取值为字符串修改取值
document.getElementById("spechars").onclick = function(){
		if (!framRecord) return;
	var tempFrame = "<iframe id='iframeSpechars' scrolling='auto' frameborder='0' src='dhcpha.clinical.spechars.csp' style='width:510px; height:428px; display:block;'></iframe>";
	document.getElementById("framRecord").style.visibility="hidden";
	createDialog("dialogSpechars","特殊字符","514","480","iframeSpechars",tempFrame,speCallback,"");
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


//保存
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

//打印
document.getElementById("print").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.printDocument(); 
	}
	else{
		   window.frames["framRecord"].printDocument(); 	 
	   }	
};
//删除文档
document.getElementById("delete").onclick = function(){
	if (!window.frames["framRecord"]) return;	
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.deleteDocument(); 
	}
	else{
		   window.frames["framRecord"].deleteDocument(); 	 
	   }		
}
//签名
document.getElementById("chick").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.audit(); 
	}
	else{
		   window.frames["framRecord"].audit(); 	 
	   }	 
}
//刷新绑定数据
document.getElementById("binddatareload").onclick = function(){
	if (!window.frames["framRecord"]) return;
	//获取当前活动文档的instanceID
	if($.IEVersion()==-1){
        var instanceID = window.frames["framRecord"].contentWindow.getDocumentContext().InstanceID; 						
	    window.frames["framRecord"].contentWindow.refreshReferenceData(instanceID,"false"); 
	}
	else{
		  var instanceID = window.frames["framRecord"].getDocumentContext().InstanceID; 						
	      window.frames["framRecord"].refreshReferenceData(instanceID,"false"); 	 
	   }
}
//显示留痕
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

//判断留痕框是否勾选
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

//导出病历
document.getElementById("export").onclick = function(){
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.exportDocument();
	    }
	else{
		       window.frames["framRecord"].exportDocument();
	    } 						
	 
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
		//$("#recording").attr("title","开启语音录入");
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
		//$("#recording").attr("title","关闭语音录入");
		$("#recording").css("background","url('../scripts/dhcpha/emr/image/toolbar/endrecord.png') no-repeat center center");		
		if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.setASRVoiceStatus(true);
	    }
	else{
		      window.frames["framRecord"].setASRVoiceStatus(true);
	    } 
		
	}	
	 
}

//执行命令
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

///初始化工栏状态
function initToolbarStatus()
{
	//初始化语音录入
	$("#recording").attr("flag",true);
	$("#recording").attr("title","开启语音录入");
	$("#recording").css("background","url('../scripts/dhcpha/emr/image/toolbar/startrecord.png') no-repeat center center");	
    if($.IEVersion()==-1){

	    if (!window.frames["framRecord"].contentWindow.plugin()) return;
	    window.frames["framRecord"].contentWindow.setASRVoiceStatus(false);	
	}
	else{
		   if (!window.frames["framRecord"].plugin()) return;
	       window.frames["framRecord"].setASRVoiceStatus(false);	 
	   }	
	
	//初始化留痕查看
	$('#viewRevision input').attr("checked",false);
	
}

//判断当前用户是否是当前患者的主管医生，只有主管医生才有病历转移权限；
function setRecordtransfer()
{
	if (mainDoc != userCode)
	{
		//$('#recordtransfer').linkbutton("disable");	
	}
}
//打开病历转移窗口
/* document.getElementById("recordtransfer").onclick = function(){
	var returnValues = window.open("dhcpha.clinical.recordtransfer.csp?EpisodeID=" +  episodeID,"recordtransferWin","resizable:no;status:no,width=325,height=450");
} */

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView(disableFont)
{
	var strs = new Array(); //定义一数组
	strs = disableFont.split(","); //字符分割
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

//完成病历,生成PDF
function generatePDF(){
	var text = '生成PDF后将无法修改药历，是否确认提交！';
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
			$.messager.show({title:'操作提示',msg:'生成PDF成功!',showType:'slide',timeout:5000});
		}else{
			$.messager.show({title:'操作提示',msg:'提交失败,未生成PDF',showType:'slide',timeout:5000});
		}
	} 
}

//定位到上次书写位置
document.getElementById("silverLocation").onclick = function(){
	strJson = {"action":"GOTO_LAST_MODIFY_POSITION","args":""}; 
 	doExecute(strJson);	
}

//根据药历id获取就诊号
function getEpisodeID(InstanceID){
	runClassMethod("web.DHCCM.drugFav","getEpsoideID",{"InstanceID":InstanceID},function(jsonObj){
		FavEpisodeID=jsonObj;
	},'',false);
}