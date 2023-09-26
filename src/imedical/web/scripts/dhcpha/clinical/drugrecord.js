var flag="";var updateLead="";var tabNums=2;var ListOrPicFlag="";
$(function(){
	getSelectTabNum()
	btnCanNot("disable")
	initPatientList(); //患者列表
	getPatinentInfo();	//加载患者信息
    GetDisease();
	initResource(); //初始化其它资源区内容
	getEvent();
	window.setInterval("getEvent()",600000);
	setDataToEventLog(); //自动记录登录电子药历系统的日志
	if (pageAttribute.DefaultForm == "Edit")
	{
		loadRecordEidtPage();	
	}
	$('a').attr('href','#');
	
	loadContent(); //加载头菜单tabs
	$("#ChangeShowMethod").combobox({
		valueField:'value',                        
		textField:'name',
		width:80,
		height:24,
		panelHeight:42,
		data:[{"value":"Picshow","name":"卡片视图","selected":true},
			  {"value":"listshow","name":"表格视图"}],
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
	ListOrPicFlag=$("#ChangeShowMethod").combobox('getValue'); //dws 2017-03-14 卡片试图显示
});
//患者列表
function initPatientList()
{
    var patientList= '<iframe id="framePatientList" src="dhcpha.clinical.patientlist.csp" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle"></iframe>'	
    $('#patientList').append(patientList);                
}

//获取头菜单信息
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

//切换患者
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
	getPatinentInfo(); //加载加载患者信息
	if(tabNums==2){
		if(flag==0){
			updateLead='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		}
	
		if(flag==1)
		{
			updateLead='<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'&UserLocID='+userLocID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		}
		updateLeadMethod(updateLead); //刷新药学服务导航页面
	}
	if(tabNums==3){
		$('#library').tabs("close","药学服务填写"); //关闭药学服务填写页面
		updateLead='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
		updateLeadMethods(updateLead);
		//window.location.reload();//刷新当前页面.
	}
	btnCanNot("disable");
	$('.easyui-layout').layout('collapse','west');
}

//加载药学服务填写页签
function loadRecordEidtPage()
{
	var content = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="dhcpha.clinical.record.edit.csp" style="width:100%;height:100%;"></iframe>';	    
	addTabs("tabRecord","药学服务填写",content,true,true);
	tabNums=3;
 }

//增加tab标签
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

//加载患者信息
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
//设置患者信息  s age = ##class(web.DHCSTKUTIL).GetAge($p(^PAADM(EpisodeID),"^",1))  ;年龄
function SetPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp';
	htmlStr += '<span class="spancolorleft">床号:</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';

	if (HasPatEncryptLevel == "Y")
	{
		SecCode = PatientInfo[0].SecCode;

		htmlStr += splitor
			+ '<span class="spancolorleft">病人密级:</span> <span class="spancolor">'
			+ patientInfo[0].SecAlias + '</span>';

		htmlStr += splitor
			+ '<span class="spancolorleft">病人级别:</span> <span class="spancolor">'
			+ patientInfo[0].EmployeeFunction + '</span>';
	}
		
	htmlStr += splitor
			+ '<span class="spancolorleft">姓名:</span> <span class="spancolor">'
			+ patientInfo[0].name + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">性别:</span> <span class="spancolor">'
			+ patientInfo[0].gender + '</span>';			

	htmlStr += splitor
			+ '<span class="spancolorleft">年龄:</span> <span class="spancolor">'
			+ patientInfo[0].age + '</span>';
	
	htmlStr += splitor							
			+ '<span class="spancolorleft">登记号:</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">病案号:</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';

	htmlStr += splitor
			+ '<span class="spancolorleft">付费方式:</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">入院日期:</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
			
	htmlStr += splitor
			+ '<span class="spancolorleft">诊断:</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
	$('#patientInfo').append(htmlStr);
	jQuery("#patientInfo").css("display", "inline-block");
	jQuery("#tool-disease").css("display", "block");
}

//进入模板操作文档
function operateRecord(tabParam)
{
	recordParam = tabParam;
	var tabs = $('#library').tabs('tabs');
	var result = IsTabExitById(tabs,"tabRecord");
	if (!result[0])
	{
		loadRecordEidtPage();//加载药学服务填写标签
		
		if(recordParam.status=="草稿")
		{
			btnCanNot("enable");
			btnPrintCanNot();
		}
		else{
			if(recordParam.status!="NORMAL"){
				btnCanNot("disable");
				btnSaveCanNot();
				//window.frames['framRecord'].setReadOnly(true,""); //加锁药历
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

///打开接口药历
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

//判断tab是否存在
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
			//关闭药学服务填写,按钮不可用
			if(index==2){
				btnCanNot("disable");
				var updateLead2='<iframe id = "framCategory" frameborder="0" src="dhcpha.clinical.record.library.category.csp?PatientID='+patientID+'&EpisodeID='+episodeID+'" style="width:100%; height:100%;scrolling:no;"></iframe>';
				updateLeadMethods(updateLead2); //关闭药学服务填写页面后刷新药学导航页面
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
			    	///重新加载当前目录导航数据
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


//初始化资源区
function initResource()
{
	var kbTree = "<iframe id='framKBTree' frameborder='0' src='dhcpha.clinical.kbtree.csp' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"				
	addTab("resources","tabKBTree","知识库",kbTree,false,true);
	resourceScheme = getResourceScheme();
	for(i=0;i<resourceScheme.length;i++ ){
		var content = "<iframe id='fram" + resourceScheme[i].id + "' frameborder='0' src='' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>"	
		addTab("resources","tab"+resourceScheme[i].id,resourceScheme[i].title,content,false,false);
	}	
}
//资源区scheme
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

//添加资源区
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

//点击tab改变资源区大小
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


//主窗体事件派发
function eventDispatch(param)
{
	if (param["action"] == "reflashKBNode")          
	{
		//根据绑定值刷新知识库
		eventReflashKBNode(param);
	}
	else if (param["action"] == "appendComposite")  
	{
		//追加复合元素(知识库)
		eventAppendComposite(param);
	}
	else if (param["action"] == "replaceComposite")  
	{
		//替换知识库节点
		eventReplaceComposite(param);
	}
	else if (param["action"] == "focusDocument")    
	{
		//定位文档
		eventFocusDocument(param);
	}
	else if(param["action"] == "insertText")   
	{
		//插入文本
		eventInsertText(param);
	}
	else if (param["action"] == "setToolbar")
	{
		//设置工具条件
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
//刷新知识库
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

///追加复合元素
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

///替换知识库节点
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

///判断当前光标在文档中的位置
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

///定位文档
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

///重新加载文档
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
	//判断客户端浏览器IE其版本
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

//自动记录登录电子药历系统的日志
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
    addTabs("tabCategory","药学项目导航",templateRecord,false,true);
	var welCome = '<iframe id = "framSummary" frameborder="0" src="dhcpha.clinical.record.library.summary.csp?PatientID="'+patientID+'&EpisodeID='+episodeID+'" '+'style="width:100%; height:100%;scrolling:no;"></iframe>';
	addTabs("tabSummary","药学服务时间轴",welCome,false,false);	
}

//增加Tab
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

//切换患者后刷新药学服务导航页面
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

//关闭药学服务填写页面后刷新药学导航页面
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

//切换患者之前确认选中的是哪个tab
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

//点击控件事件
function my_click(obj, myid)
{
	if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
	{
		document.getElementById(myid).value = '';
		obj.style.color='#000';
	}
}
//离开控件事件
function my_blur(obj, myid)
{
	if (document.getElementById(myid).value == '')
	{
		document.getElementById(myid).value = document.getElementById(myid).defaultValue;
		obj.style.color='#999'
	}
}
// 回车事件
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

//病历检索
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

///关闭药学服务填写按钮不可用/可用
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

///保存按钮不可用时按钮的状态
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

//打印和PDF按钮不可用
function btnPrintCanNot(){
	$('#print').linkbutton("disable");
	$('#PDF').linkbutton("disable");
}
