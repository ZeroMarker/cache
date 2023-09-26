$(function(){	
	init();		
});

function init()
{
	getPatinentInfo();	
	setViewForm();
}


//设置浏览界面
function setViewForm()
{
	var content ="<iframe id='frameBrowseInEpisode' src='emr.record.browse.episode.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&AdmType="+admType+"&Action="+action+"' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>"
	addTab("tabBrowse","BrowseInEpisode","病历浏览",content,false,true);

	loadHisDoc();	
	/*  //病历操作日志查询页面，作为菜单配置在“电子病历”菜单组中，不再显示在病历浏览模块中  modify by niucaicai 2016-4-11
	if (IsSetToLog == "Y")
	{
		//增加病历操作日志查询页面
		var ActionLogscountent = '<iframe id="ActionLogs" src="emr.actionlogs.csp?EpisodeID='+ episodeID +'" style=" width:100%; height:100%;scrolling:no;"></iframe>';
		addTab("tabBrowse","ActionLogs","病历操作日志",ActionLogscountent,false,false);
	}
	*/
}
//加载His数据
function loadHisDoc()
{
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.browse.cls",
		async: true,
		data: {"Action":"GetHisData"},
		success: function(d){
			if (d != "")
			{
				var data = eval(d);
				for (var i=0;i<data.length;i++){
					var url = formatUrl(data[i].url);
					var countent = '<iframe frameborder="0" src="'+url+'" style=" width:100%; height:100%;scrolling:no;"></iframe>';
					addTab("tabBrowse","his"+i,data[i].title,countent,false,false);
				}
			}
		},
		error: function(d){alert("error");}
	});
}
//格式化his url
function formatUrl(url)
{
	url = url.replace(/\[patientID\]/g, patientID);
	url = url.replace(/\[episodeID\]/g, episodeID);
	url = url.replace(/\[mradm\]/g, mradm);
	url = url.replace(/\[regNo\]/g, regNo);
	url = url.replace(/\[medicare\]/g, medicare);
	url = url.replace(/\[userID\]/g, userID);
	url = url.replace(/\[userCode\]/g, userCode);
	url = url.replace(/\[ctLocID\]/g, userLocID);
	url = url.replace(/\[ctLocCode\]/g, userLocCode);
	url = url.replace(/\[ssGroupID\]/g, ssgroupID);
	return url	
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

$(function(){
	$('#tabBrowse').tabs({
 		onSelect: function(title,index){
			var tab = $('#tabBrowse').tabs('getTab',index);
			if (tab[0].id == "BrowseInEpisode")
			{
				$('#tab-tools').css("display","inline");
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
		obj.style.color='#999';
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
	if (!window.frames["frameBrowseInEpisode"]) return;
	var selectValue = $("#searchInput").val();
	if (selectValue == $("#searchInput")[0].defaultValue)
	{
		selectValue = "";
	}
	window.frames["frameBrowseInEpisode"].selectRecord(selectValue);	
}

//患者信息///////////////////////////////////////////////////////////////////////////////////////
//加载患者信息
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
            setPatientInfo(eval(data));
        } 
    });
}
//设置患者信息
function setPatientInfo(patientInfo) {
	var splitor = '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spancolorleft">登记号:</span> <span class="spancolor">'
			+ patientInfo[0].papmiNo + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">病案号:</span><span class="spancolor">'
			+ patientInfo[0].ipRecordNo + '</span>';
	
	if (HasPatEncryptLevel == "Y")
	{
		htmlStr += splitor
			+ '<span class="spancolorleft">病人密级:</span><span class="spancolor">'
			+ patientInfo[0].SecAlias + '</span>';

		htmlStr += splitor
			+ '<span class="spancolorleft">病人级别:</span><span class="spancolor">'
			+ patientInfo[0].EmployeeFunction + '</span>';
	}

	htmlStr += splitor
			+ '<span class="spancolorleft">床号:</span><span class="spancolor">'
			+ patientInfo[0].disBed + '</span>';
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
			+ '<span class="spancolorleft">付费方式:</span><span class="spancolor">'
			+ patientInfo[0].payType + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">入院日期:</span> <span class="spancolor">'
			+ patientInfo[0].admDate + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">诊断:</span> <span class="spancolor">'
			+ patientInfo[0].mainDiagnos + '</span>';
	htmlStr += splitor
			+ '<span class="spancolorleft">经治医生:</span><span class="spancolor">'
			+ patientInfo[0].doctor + '</span>';
	$('#patientInfo').append(htmlStr);
	jQuery(".patientInfo").css("display", "inline-block");
}
