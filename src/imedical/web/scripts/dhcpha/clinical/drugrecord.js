var flag="";var updateLead="";var tabNums=2;var ListOrPicFlag="";
$(function(){
	getSelectTabNum()
	btnCanNot("disable")
	initPatientList(); //�����б�
	getPatinentInfo();	//���ػ�����Ϣ
    GetDisease();
	initResource(); //��ʼ��������Դ������
	getEvent();
	window.setInterval("getEvent()",600000);
	setDataToEventLog(); //�Զ���¼��¼����ҩ��ϵͳ����־
	if (pageAttribute.DefaultForm == "Edit")
	{
		loadRecordEidtPage();	
	}
	$('a').attr('href','#');
	
	loadContent(); //����ͷ�˵�tabs
	$("#ChangeShowMethod").combobox({
		valueField:'value',                        
		textField:'name',
		width:80,
		height:24,
		panelHeight:42,
		data:[{"value":"Picshow","name":"��Ƭ��ͼ","selected":true},
			  {"value":"listshow","name":"�����ͼ"}],
		onSelect:function(record)
		{
			if($.IEVersion()==-1){

				     if(!window.frames["framCategory"].contentWindow.frames["framTemplateRecord"]) return;
			         window.frames["framCategory"].contentWindow.frames["framTemplateRecord"].contentWindow.loadRecord($("#sortName").attr("categoryId"));  
			    }
			    else{
				    if(!window.frames["framCategory"].frames["framTemplateRecord"]) return;
			        window.frames["framCategory"].frames["framTemplateRecord"].loadRecord($("#sortName").attr("categoryId"));  
			    }
			
		}
	}); 
	ListOrPicFlag=$("#ChangeShowMethod").combobox('getValue'); //dws 2017-03-14 ��Ƭ��ͼ��ʾ
});
//�����б�
function initPatientList()
{
    var patientList= '<iframe id="framePatientList" src="dhcpha.clinical.patientlist.csp" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle"></iframe>'	
    $('#patientList').append(patientList);                
}

//��ȡͷ�˵���Ϣ
function getMenuForm() {
    var win = top.frames['eprmenu'];
    if (win) {
        var frm = win.document.forms['fEPRMENU'];
        return frm;
    }

    var frm = parent.frames[0].document.forms["fEPRMENU"];
    if (frm) return frm;
    frm = top.document.forms["fEPRMENU"];
    return frm
}

//�л�����
function doSwitch(PatientID,EpisodeID,mradm) {
	var frm = getMenuForm();
	if (frm)
	{
		var frmEpisodeID = frm.EpisodeID;
		var frmPatientID = frm.PatientID;
		var frmmradm = frm.mradm;
		frmPatientID.value = PatientID;
		frmEpisodeID.value = EpisodeID;
		frmmradm.value = mradm;
	}
	patientID=PatientID;
	episodeID=EpisodeID;
	$('#patientInfo').html("");
	getPatinentInfo(); //���ؼ��ػ�����Ϣ
	if(tabNums==2){
		if(flag==0){
			updateLead='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		}
	
		if(flag==1)
		{
			updateLead='<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'&UserLocID='+userLocID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		}
		updateLeadMethod(updateLead); //ˢ��ҩѧ���񵼺�ҳ��
	}
	if(tabNums==3){
		$('#library').tabs("close","ҩѧ������д"); //�ر�ҩѧ������дҳ��
		updateLead='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		updateLeadMethods(updateLead);
		//window.location.reload();//ˢ�µ�ǰҳ��.
	}
	btnCanNot("disable");
	$('.easyui-layout').layout('collapse','west');
}

//����ҩѧ������дҳǩ
function loadRecordEidtPage()
{
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="dhcpha.clinical.record.edit.csp" style="width:100%;height:100%;"></iframe>';	    
	addTabs("tabRecord","ҩѧ������д",content,true,true);
	tabNums=3;
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

//���ػ�����Ϣ
function getPatinentInfo()
{
	$.ajax({ 
        type: "POST", 
        url: "../web.DHCCM.EMRservice.Ajax.PatientInfo.cls", 
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
//���û�����Ϣ  s age = ##class(web.DHCSTKUTIL).GetAge($p(^PAADM(EpisodeID),"^",1))  ;����
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
			+ '<span class="spancolorleft">�ǼǺ�:</span> <span class="spancolor">'
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

//����ģ������ĵ�
function operateRecord(tabParam)
{
	recordParam = tabParam;
	var tabs = $('#library').tabs('tabs');
	var result = IsTabExitById(tabs,"tabRecord");
	if (!result[0])
	{
		loadRecordEidtPage();//����ҩѧ������д��ǩ
		
		if(recordParam.status=="�ݸ�")
		{
			btnCanNot("enable");
			btnPrintCanNot();
		}
		else{
			if(recordParam.status!="NORMAL"){
				btnCanNot("disable");
				btnSaveCanNot();
				//window.frames['framRecord'].setReadOnly(true,""); //����ҩ��
			}
			else{
				btnCanNot("enable");
				btnPrintCanNot();
			}
		}
		
	}
	else
	{
		$('#library').tabs('select', result[1]);
		if($.IEVersion()==-1){

		window.frames["framRecord"].contentWindow.InitDocument(tabParam);
	}
	else{
	        window.frames["framRecord"].InitDocument(tabParam); 	 
	   }
		
	}
}

///�򿪽ӿ�ҩ��
function openInterfaceRecord(Id,Name,src)
{
	var tabs = $('#library').tabs('tabs');
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
		addTab("library",tabId,Name,content,true);
	}
	else
	{
		$('#library').tabs('select', result[1]);
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
	$('#library').tabs({
		onBeforeClose:function(title,index){
			//�ر�ҩѧ������д,��ť������
			if(index==2){
				btnCanNot("disable");
				var updateLead2='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
				updateLeadMethods(updateLead2); //�ر�ҩѧ������дҳ���ˢ��ҩѧ����ҳ��
				tabNums=2;
			}
			$('#favoritesPlus').linkbutton('disable');
			var tab = $('#library').tabs('getTab',index);
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
		    var tab = $('#library').tabs('getTab',index);
		    var id = tab[0].id.substring(3);
		    if ((recordParam.IsActive == "N")&&(!isNaN(id))){
			    recordParam.IsActive = "";
			    window.frames["iframe"+id].Reload();
		    }
        }
	});	
});


//��ʼ����Դ��
function initResource()
{
	var kbTree = "<iframe id='framKBTree' frameborder='0' src='dhcpha.clinical.kbtree.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
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
		//eventSetToolbar(param);
	}
	else if (param["action"] == "sendCopyCutData")
	{
		sendCopyCutData(param);
	}
	else if (param["action"] == "INSERT_STYLE_TEXT_BLOCK")
	{
		if (!window.frames["framRecord"]) return;
		
		if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.cmdDoExecute(param);  
	    }
	    else{
		       window.frames["framRecord"].cmdDoExecute(param);       
	    }     
			
	}
	
}
//ˢ��֪ʶ��
function eventReflashKBNode(commandParam)
{
	if ((!window.frames["framKBTree"].GetKBNodeByTreeID)||(!commandParam)) return;
	if($.IEVersion()==-1){

		       window.frames["framKBTree"].contentWindow.GetKBNodeByTreeID(commandParam);  
	    }
	else{
		       window.frames["framKBTree"].GetKBNodeByTreeID(commandParam);       
	    }   
	
}

///׷�Ӹ���Ԫ��
function eventAppendComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.appendComposite(commandParam["NodeID"]); 
	    }
	else{
		       window.frames["framRecord"].appendComposite(commandParam["NodeID"]);   
	    }  
	
}

///�滻֪ʶ��ڵ�
function eventReplaceComposite(commandParam)
{
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       window.frames["framRecord"].contentWindow.replaceComposite(commandParam["NodeID"]);
	    }
	else{
		       window.frames["framRecord"].replaceComposite(commandParam["NodeID"]);  
	    } 
	
}

///�жϵ�ǰ������ĵ��е�λ��
function getElementContext(position)
{
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       	var result = window.frames["framRecord"].contentWindow.getElementContext(position);
	    }
	else{
		       	var result = window.frames["framRecord"].getElementContext(position);  
	    } 

	return result;
}

///��λ�ĵ�
function eventFocusDocument(commandParam)
{	
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       	window.frames["framRecord"].contentWindow.focusDocument(commandParam["InstanceID"],commandParam["path"],commandParam["actionType"]); 	
	    }
	else{
		       	window.frames["framRecord"].focusDocument(commandParam["InstanceID"],commandParam["path"],commandParam["actionType"]); 	 
	    } 
	
}

///���¼����ĵ�
function eventInsertText(commandParam)
{
	if (!window.frames["framRecord"]) return;
	if($.IEVersion()==-1){

		       	window.frames["framRecord"].contentWindow.insertText(commandParam["text"]);
	    }
	else{
		       	window.frames["framRecord"].insertText(commandParam["text"]);
	    } 
	 
}


function sendCopyCutData(param)
{
	if (!window.frames["framclipboard"]) return;
	if($.IEVersion()==-1){

		       window.frames["framclipboard"].contentWindow.setContent(param.content);
	    }
	else{
		       window.frames["framclipboard"].setContent(param.content);
	    } 
	
}


window.onbeforeunload = function(){    
	//�жϿͻ��������IE��汾
	if ($.browser.version == '11.0')
	{
		if (window.frames["framRecord"] && window.frames["framRecord"].length >0)
		{
			var result = window.frames["framRecord"].contentWindow.savePrompt();
			if (result == "cancel") return false;
			window.frames["framRecord"].contentWindow.unLockDocumnet();
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

//�Զ���¼��¼����ҩ��ϵͳ����־
function setDataToEventLog()
{
	if (IsSetToLog == "Y")
	{
		var ModelName = "EMR.Login";
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
}

function loadContent()
{
    var templateRecord = '<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
    addTabs("tabCategory","ҩѧ��Ŀ����",templateRecord,false,true);
	var welCome = '<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID="'+patientID+'&EpisodeID='+episodeID+'" '+'style="width:100%; height:100%;scrolling:no;"></iframe>';
	addTabs("tabSummary","ҩѧ����ʱ����",welCome,false,false);	
}

//����Tab
function addTabs(id,title,content,closable,isSelect)
{
	$('#library').tabs('add',{
		id: id,
		title: title,
		content: content,
		closable: closable,
		selected: isSelect
	});		
}

//�л����ߺ�ˢ��ҩѧ���񵼺�ҳ��
function updateLeadMethod(content)
{
	var tab = $('#library').tabs('getSelected');  
	$('#library').tabs('update', {
		tab: tab,
		options: {
			content: content
		}
	});
}

//�ر�ҩѧ������дҳ���ˢ��ҩѧ����ҳ��
function updateLeadMethods(content)
{
	var tab = $('#library').tabs('getTab',0);  
	$('#library').tabs('update', {
		tab: tab,
		options: {
			content: content
		}
	});
}

//�л�����֮ǰȷ��ѡ�е����ĸ�tab
function getSelectTabNum(){
	$('#library').tabs({
		onSelect: function(title,index){
			if(index==0){flag=0};
		}
	});
}

$(function(){
	$('#library').tabs({
 		onSelect: function(title,index){
			var tab = $('#library').tabs('getTab',index);
			if (tab[0].id == "tabSummary")
			{
				$('#framSummary').attr("src","dhcpha.clinical.record.library.summary.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&UserLocID="+userLocID);
				flag=1;
			}
			if (tab[0].id == "tabCategory")
			{
				$('#tab-tools').css("display","inline");
				flag=0;
			}
			else
			{
				$('#tab-tools').css("display","none");
			}
        }
	});
	
	
});

//����ؼ��¼�
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//�뿪�ؼ��¼�
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
// �س��¼�
function my_keyDown()
{
	if(event.keyCode==13)
    {
		serachRecord();                             
    }

}

$("#searchRecord").click(function(){
	serachRecord();
});

//��������
function serachRecord()
{
	if (!window.frames["framCategory"]) return;
	var selectValue = $("#searchInput").val();
	if (selectValue == $("#searchInput")[0].defaultValue)
	{
		selectValue = "";
	}
	if($.IEVersion()==-1){

	    window.frames["framCategory"].contentWindow.selectRecord(selectValue);	
	}
	else{
		  window.frames["framCategory"].selectRecord(selectValue); 
	   }
	
}

///�ر�ҩѧ������д��ť������/����
function btnCanNot(flag){
	$('#favoritesPlus').linkbutton(flag);
	$('#font').combobox(flag);
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
	$('#recordtransfer').linkbutton(flag);
	$('#PDF').linkbutton(flag);
	$('#unLock').linkbutton(flag);
	$('#print').linkbutton(flag);
	$('#reference').linkbutton(flag);
	$('#export').linkbutton(flag);
	$('#delete').linkbutton(flag);
}

///���水ť������ʱ��ť��״̬
function btnSaveCanNot(){
	if(($("#save").linkbutton('options').disabled)==true){
		$('#print').linkbutton("enable");
		$('#PDF').linkbutton("enable");
		$('#delete').linkbutton("enable");
		$('#export').linkbutton("enable");
		$('#favoritesPlus').linkbutton("enable");
		$('#favorites').linkbutton("enable");
	}
}

//��ӡ��PDF��ť������
function btnPrintCanNot(){
	$('#print').linkbutton("disable");
	$('#PDF').linkbutton("disable");
}
