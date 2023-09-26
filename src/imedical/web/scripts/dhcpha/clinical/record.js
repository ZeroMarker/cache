$(function(){
	getPatinentInfo();	
	loadNavPage();
    GetDisease();
	initResource(); //��ʼ��������Դ������
	getEvent();
	window.setInterval("getEvent()",600000);
	setDataToEventLog(); //�Զ���¼��¼���Ӳ���ϵͳ����־
	if (pageAttribute.DefaultForm == "Edit")
	{
		loadRecordEidtPage();	
	}
	$('a').attr('href','#');
});

//���ص���ҳǩ
function loadNavPage()
{
   	var libRecord = '<iframe id = "framnav" frameborder="0" src="dhcpha.clinical.record.library.csp" style=" width:100%; height:100%;scrolling:no;"></iframe>';
    //var libRecord = '<iframe id = "framnav" frameborder="0" src="emr.record.library.csp" style=" width:100%; height:100%;scrolling:no;"></iframe>';
    addTab("content","tabnav","ҩѧ���񵼺�",libRecord,false,false);	
}

//���ز����༭ҳǩ
function loadRecordEidtPage()
{
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="dhcpha.clinical.record.edit.csp" style="width:100%;height:100%;"></iframe>';	    
	//var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="emr.record.edit.csp" style="width:100%;height:100%;"></iframe>';	
	addTab("content","tabRecord","ҩѧ������д",content,true,true);	
}


//����tab��ǩ
function addTab(ctrlId,tabId,tabTitle,content,closable,selected)
{
	$('#'+ctrlId).tabs('add',{
	    id:       tabId ,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected	
   });	
}

//������Ϣ///////////////////////////////////////////////////////////////////////////////////////
//���ػ�����Ϣ
function getPatinentInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../EMRservice.Ajax.patientInfo.cls", 
        data: "action=GetPatientInfo"+ "&patientID=" +patientID+ "&EpisodeID=" +episodeID, 
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	PatientInfo = eval(data);
            SetPatientInfo(PatientInfo);
        } 
    });
}
//���û�����Ϣ
function SetPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp';
	htmlStr += '<span class="spancolorleft">����:</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';

	if (HasPatEncryptLevel == "Y")
	{
		SecCode = PatientInfo[0].SecCode;

		htmlStr += splitor
			+ '<span class="spancolorleft">�����ܼ�:</span> <span class="spancolor">'
			+ patientInfo[0].SecAlias + '</span>';

		htmlStr += splitor
			+ '<span class="spancolorleft">���˼���:</span> <span class="spancolor">'
			+ patientInfo[0].EmployeeFunction + '</span>';
	}
		
	htmlStr += splitor
			+ '<span class="spancolorleft">����:</span> <span class="spancolor">'
			+ patientInfo[0].name + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">�Ա�:</span> <span class="spancolor">'
			+ patientInfo[0].gender + '</span>';			

	htmlStr += splitor
			+ '<span class="spancolorleft">����:</span> <span class="spancolor">'
			+ patientInfo[0].age + '</span>';
	
	htmlStr += splitor							
			+ '<span class="spancolorleft">����ID:</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">������:</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';

	htmlStr += splitor
			+ '<span class="spancolorleft">���ѷ�ʽ:</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">��Ժ����:</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">���:</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
	$('#patientInfo').append(htmlStr);
	jQuery("#patientInfo").css("display", "inline-block");
	jQuery("#tool-disease").css("display", "block");
}

//�����༭/////////////////////////////////////////////////////////////////////////////////////////
//�����ĵ�
function operateRecord(tabParam)
{
	recordParam = tabParam;
	var tabs = $('#content').tabs('tabs');
	var result = IsTabExitById(tabs,"tabRecord");
	if (!result[0])
	{
		loadRecordEidtPage();
	}
	else
	{
		$('#content').tabs('select', result[1]);
		window.frames["framRecord"].InitDocument(tabParam);
	}
}

///�򿪽ӿڲ���
function openInterfaceRecord(Id,Name,src)
{
	var tabs = $('#content').tabs('tabs');
	var tabId = "tab"+Id
	var result = IsTabExitById(tabs,tabId);
	if (!result[0])
	{	
	   	src = src.replace(/\[patientID\]/g, patientID);
		src = src.replace(/\[episodeID\]/g, episodeID);
		src = src.replace(/\[mradm\]/g, mradm);
		src = src.replace(/\[regNo\]/g, regNo);
		src = src.replace(/\[medicare\]/g, medicare);
		src = src.replace(/\[userID\]/g, userID);
		src = src.replace(/\[userCode\]/g, userCode);
		src = src.replace(/\[ctLocID\]/g, userLocID);
		src = src.replace(/\[ctLocCode\]/g, userLocCode);
		src = src.replace(/\[ssGroupID\]/g, ssgroupID);
		var content = '<iframe id ="iframe'+Id+'" frameborder="0" src="'+src+'" style="width:100%;height:100%;"></iframe>'
		addTab("content",tabId,Name,content,true);
	}
	else
	{
		$('#content').tabs('select', result[1]);
	}
}

//�ж�tab�Ƿ����
function IsTabExitById(tabs,id)
{
	var result = [false,0]
	for(var i=0; i<tabs.length; i++){
		if (tabs[i].panel('options').id == id)
		{
			result = [true,i];
		} 
	}
	return result;
}

$(function(){
	$('#content').tabs({
		onBeforeClose:function(title,index){
			var tab = $('#content').tabs('getTab',index);
			if (tab.id == "tabRecord") recordParam = "";
		     if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
	     	 {
		     	 var result = window.frames["framRecord"].savePrompt();
		     	 if (result == "cancel") return false;
		     	 window.frames["framRecord"].unLockDocumnet();
				 initToolbarStatus();
				 setToolBarStatus("disable");
				 $("#reference").removeAttr("flag");
		     }   
        },
        onSelect:function(title,index){
	    	var param = {"action":"reflashKBNode","bindKBBaseID":"","titleCode":""}; 
	    	eventDispatch(param)
	    	if ((index == 0)&&(recordParam))
	    	{
		    	var categoryId = recordParam["categoryId"]
		    	if (categoryId != "")
		    	{
			    	///���¼��ص�ǰĿ¼��������
			    	window.frames["framnav"].frames["framCategory"].reLoadNav(categoryId);
			    }
		    }
		    var tab = $('#content').tabs('getTab',index);
		    var id = tab[0].id.substring(3);
		    if ((recordParam.IsActive == "N")&&(!isNaN(id))){
			    recordParam.IsActive = "";
			    window.frames["iframe"+id].Reload();
		    }
        }
	});	
});

//��Դ��/////////////////////////////////////////////////////////////////////////

//��ʼ����Դ��
function initResource()
{
	var kbTree = "<iframe id='framKBTree' frameborder='0' src='emr.resource.kbtree.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addTab("resources","tabKBTree","֪ʶ��",kbTree,false,true);
	resourceScheme = getResourceScheme();
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("resources","tab"+resourceScheme[i].id,resourceScheme[i].title,content,false,false);
	}	
}
//��Դ��scheme
function getResourceScheme()
{
	strXml = convertToXml(resourceScheme);
    var objResourceScheme = new Array();
    $(strXml).find("resource>item").each(function(){
	    var id = $(this).find("id").text();
	    var title = $(this).find("title").text();
	    var source = $(this).find("source").text();
	    var width = $(this).find("width").text();
	    objResourceScheme.push({id:id,title:title,source:source,width:width})
    });
    return objResourceScheme;
}

//�����Դ��
function addResourceTab(id,title,content,closable)
{
   if($('#resources').tabs('exists',title)){
   	   $('#resources').tabs('select',title);
   }else{	
	   $('#resources').tabs('add',{
		    id: id,
			title: title,
			content: content,
			closable: closable
	   });
   }	
}

//���tab�ı���Դ����С
$(function(){
	$("#resources").tabs({
		onSelect: function(title,index){
			var tab = $('#resources').tabs('getTab',index);
			var width = 300;
			if(tab[0].id != "tabKBTree")
			{
				if (resourceScheme[index-1])
				{
					width = parseInt(resourceScheme[index-1].width);
					var tbIframe = $("#"+tab[0].id+" iframe:first-child");
					if (tbIframe.attr("src") == "")
					{
						tbIframe.attr("src",resourceScheme[index-1].source);
					}
				}
			}
			$('.easyui-layout').layout('panel', 'east').panel('resize',{width:width});
			$('.easyui-layout').layout('resize');
		}
	});
});

//�¼�����///////////////////////////////////////////////////////////////////////////////////////

//�������¼��ɷ�
function eventDispatch(param)
{
	if (param["action"] == "reflashKBNode")          
	{
		//���ݰ�ֵˢ��֪ʶ��
		eventReflashKBNode(param);
	}
	else if (param["action"] == "appendComposite")  
	{
		//׷�Ӹ���Ԫ��(֪ʶ��)
		eventAppendComposite(param);
	}
	else if (param["action"] == "replaceComposite")  
	{
		//�滻֪ʶ��ڵ�
		eventReplaceComposite(param);
	}
	else if (param["action"] == "focusDocument")    
	{
		//��λ�ĵ�
		eventFocusDocument(param);
	}
	else if(param["action"] == "insertText")   
	{
		//�����ı�
		eventInsertText(param);
	}
	else if (param["action"] == "setToolbar")
	{
		//���ù�������
		eventSetToolbar(param);
	}
	else if (param["action"] == "sendCopyCutData")
	{
		sendCopyCutData(param);
	}
	else if (param["action"] == "INSERT_STYLE_TEXT_BLOCK")
	{
		if (!window.frames["framRecord"]) return;
		window.frames["framRecord"].cmdDoExecute(param);	
	}
	
}
//ˢ��֪ʶ��
function eventReflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);
}

///׷�Ӹ���Ԫ��
function eventAppendComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].appendComposite(commandParam["NodeID"]);
}

///�滻֪ʶ��ڵ�
function eventReplaceComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].replaceComposite(commandParam["NodeID"]);
}

///�жϵ�ǰ������ĵ��е�λ��
function getElementContext(position)
{
	if (!window.frames["framRecord"]) return;
	var result = window.frames["framRecord"].getElementContext(position);
	return result;
}

///��λ�ĵ�
function eventFocusDocument(commandParam)
{	
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].focusDocument(commandParam["InstanceID"],commandParam["path"],commandParam["actionType"]); 	
}

///���¼����ĵ�
function eventInsertText(commandParam)
{
	if (!window.frames["framRecord"]) return;
	window.frames["framRecord"].insertText(commandParam["text"]); 
}

///���ù�������״̬
function eventSetToolbar(commandParam)
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
	if((commandParam.status["canResidentCheck"] == 1)||(commandParam.status["canChiefCheck"] == 1)||(commandParam.status["canAttendingCheck"] ==1))
	{
		setChick('enable');
	}
	else
	{
		setChick('disable');
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
	if(commandParam.status["canViewRevise"] == 1)
	{
		setViewRevision('enable');
	}
	else
	{
		setViewRevision('disable');
	}	
}

function sendCopyCutData(param)
{
	if (!window.frames["framclipboard"]) return;
	window.frames["framclipboard"].setContent(param.content);
}


window.onbeforeunload = function(){    
	//�жϿͻ��������IE��汾
	if ($.browser.version == '11.0')
	{
		if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
		{
			var result = window.frames["framRecord"].savePrompt();
			if (result == "cancel") return false;
			window.frames["framRecord"].unLockDocumnet();
		}
	}else{
		var b = window.event.clientX > document.documentElement.scrollWidth - 40; 
		if ((b && window.event.clientY < 0) || (window.event.screenY > document.body.clientHeight) || window.event.altKey)
		{    
			if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
			{
				var result = window.frames["framRecord"].savePrompt();
				if (result == "cancel") return false;
				window.frames["framRecord"].unLockDocumnet();
			}
		}
	}
	window.close();
}

////event
///�¼�������Ϣ
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
					text = text + '<span id='+d[i].EventType+'><img src="../scripts/dhcpha/emr/image/icon/'+d[i].EventType+'.png"/>';	
					text = text + '<div class="helper">'+d[i].PromptMessage+'</div></span>';
				}
				text = text + '</marquee>';
				$("#event").html(text);	
			}
		},
		error : function(d) { alert(" error");}
	});
}

$("#event marquee span").live("click",function(){
	var eventType = $(this)[0].id;
	var returnValues = "";
	returnValues = window.showModalDialog("emr.event.csp?EpisodeID="+episodeID+"&EventType="+eventType,window,"dialogHeight:500px;dialogWidth:700px;resizable:no;status:no");
	if ((returnValues == "")||(returnValues == undefined)) return;
	operateRecord(returnValues);
});

//�Զ���¼��¼���Ӳ���ϵͳ����־
function setDataToEventLog()
{
	if (IsSetToLog == "Y")
	{
		var ModelName = "EMR.Login";
		var Condition = "";
		//alert("ok");
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
}