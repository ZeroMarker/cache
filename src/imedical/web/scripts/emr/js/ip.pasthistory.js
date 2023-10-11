var dateObj = "";
var hasIndex2 = "0";
$(function(){
	getDateList();
	var dateStr = base64encode(utf16to8(escape(JSON.stringify(dateObj))));
	
	getLastPastHistory();
	var src = "emr.ip.pasthistorybydate.csp?tempdate=" + dateStr;	
	var content = "<iframe id='framePHByDate' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
	$('#pasthistoryByDate').append(content);
	
	$('#typeTab').tabs({
		onSelect: function(title,index){
			if ((index == 2)&&(hasIndex2 == "0"))
			{
				var diagnoseData = getDiagnoseData();
				for (var i=0; i<diagnoseData.length; i++)
				{
					var diagnoseObj = diagnoseData[i];
					var diagDesc = diagnoseObj.Diagnos;
					var diagDateList = diagnoseObj.DateList;
					var DateListStr = base64encode(utf16to8(escape(JSON.stringify(diagDateList))));
					
					var li = $('<li id="diagPanel"' + i + '></li>');
					var category = '<label for="folder'+i+'" class="folderOne" id="folderLabel' + i + '" onclick=typeClick(this.id)>'+diagDesc+'</label><input type="checkbox" id="folder'+i+'"/>';
					$(li).append(category);
					
					var childul = $('<ol></ol>');
					
					var src = "emr.ip.pasthistorybydate.csp?tempdate=" + DateListStr;	
					var content = "<iframe id='framePHByDateTP" + i + "' src='" + src + "' scrolling='no' width='100%' height='100%' frameborder='0'></iframe>";
					$(childul).append($('<div style="height:370px;"></div>').append(content));
					$(li).append(childul);
					
					$('#ulcategory').append(li);
				}
				hasIndex2 = "1";
			}
		}
	});
	
	
});

function typeClick(id)
{
	var num = id.split("folderLabel")[1];
	var iframeid = "framePHByDateTP" + num;
	document.frames[iframeid].reload(iframeid);
}

function reloadIframe(iframeid,src)
{
	document.getElementById(iframeid).src=src;
}
//取患者以往就诊信息
function getDateList()
{
	var data = {
		"OutputType":"Stream",
		"Class":"EMRservice.BL.BLPastHistory",
		"Method":"getAdmList",
		"p1":patientID
	};
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			dateObj = eval("["+d+"]")[0].rows;
			/*
			var diagnoseData = [
					{"Diagnos":"高血压","DateList":[{"EpisodeID":"4","AdmDate":"2020-10-11"},{"EpisodeID":"4","AdmDate":"2020-10-11"}]},
					{"Diagnos":"糖尿病","DateList":[{"EpisodeID":"4","AdmDate":"2020-10-11"},{"EpisodeID":"4","AdmDate":"2020-10-11"}]}
				];
			dateObj = diagnoseData[1].DateList;
			*/
		},
		error : function(d) {
			$.messager.alert("提示信息", "getAdmList ERROR！", 'info');
		}
	});		
}

//按疾病类型取数据
function getDiagnoseData()
{
	var returnValue = "";
	var data = {
		"OutputType":"Stream",
		"Class":"EMRservice.BL.BLPastHistory",
		"Method":"getAdmListOrderByDiagnosis",
		"p1":patientID
	};
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: data,
		success: function(d) {
			returnValue = eval("["+d+"]");
			/*
			var diagnoseData = [
				{"Diagnos":"高血压","DateList":[{"EpisodeID":"4","AdmDate":"2020-10-11"},{"EpisodeID":"4","AdmDate":"2020-10-11"}]},
				{"Diagnos":"糖尿病","DateList":[{"EpisodeID":"4","AdmDate":"2020-10-11"},{"EpisodeID":"4","AdmDate":"2020-10-11"}]}
			];
			returnValue = diagnoseData;
			*/
		},
		error : function(d) {
			$.messager.alert("提示信息", "getAdmListOrderByDiagnosis ERROR！", 'info');
		}
	});
	return returnValue;
}

//取患者最近一次使用既往史编辑页面保存的数据，显示到页面中
function getLastPastHistory()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPastHistory",
			"Method":"getLastPastHistory",
			"p1":patientID
		},
		success: function(d) {
			if (d == "-1")
			{
				$.messager.alert("提示信息", "入参为空，请联系工程师处理！", 'info');
			}
			else if (d == "-2")
			{
				$.messager.alert("提示信息", "获取最近一次书写的既往史数据时时出错，请联系工程师处理！", 'info');
			}
			else
			{
				var AreaStr = d.split("^^^")[0];
				var AreaAllergyStr = d.split("^^^")[1];
				$('#textArea').val(AreaStr);
				$('#textAreaAllergy').val(AreaAllergyStr);
			}
		},
		error : function(d) {
			$.messager.alert("提示信息", "getLastPastHistory ERROR！", 'info');
		}
	});
	
}

function openAllergyWin()
{
	//alert("patientID:" + patientID);
	var tempFrame = "<iframe id='iframeAllergy' scrolling='auto' frameborder='0' src='emr.ip.pasthistoryallergy.csp?EpisodeID=" + episodeID + "&PatientID=" + patientID + "' style='width:1126px; height:468px; display:block;'></iframe>";
	parent.createModalDialog("AllergyDialog","过敏记录","1126","508","iframeAllergy",tempFrame,AllergyCallBack,"");
	
}

//过敏记录回调
function AllergyCallBack(returnValue,arr)
{
	//alert(returnValue);
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPastHistory",
			"Method":"getAllergyData",
			"p1":patientID
		},
		success: function(d) {
			setTextAreaAllergy(eval("["+d+"]"));
		},
		error : function(d) {
			$.messager.alert("提示信息", "getAllergyData ERROR！", 'info');
		}
	});
}

function setTextAreaAllergy(AllergyData)
{
	var tempText = "";
	for (var i=0; i<AllergyData.length; i++)
	{
		if (tempText == "")
		{
			tempText = AllergyData[i].text + "；";
		}
		else
		{
			tempText = tempText + AllergyData[i].text + "；" ;
		}
	}
	$('#textAreaAllergy').val(tempText);
}

function insertToEMR()
{
	var pasthistory = "";
	var textAreaStr = $('#textArea').val();
	var textAreaAllergyStr = $('#textAreaAllergy').val();
	
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLPastHistory",
			"Method":"savePastHistory",
			"p1":episodeID,
			"p2":patientID,
			"p3":userID,
			"p4":userLocID,
			"p5":textAreaStr,
			"p6":textAreaAllergyStr
		},
		success: function(d) {
			if (d == "-1")
			{
				$.messager.alert("提示信息", "某用户信息为空，请联系工程师处理！", 'info');
			}
			else if (d == "-2")
			{
				$.messager.alert("提示信息", "后台创建既往史对象时出错，请联系工程师处理！", 'info');
			}
			else if (d == "-3")
			{
				$.messager.alert("提示信息", "后台保存既往史对象时出错，请联系工程师处理！", 'info');
			}
			else
			{
				pasthistory = textAreaStr + textAreaAllergyStr;
				//通过回调函数，将内容插入指定单元内，原方案parent.insertText(pasthistory);会插入数据到单元外。
				returnValue = pasthistory;
				closeWindow();
			}
		},
		error : function(d) { $.messager.alert("提示信息", "savePastHistory ERROR！", 'info');}
	});
}

function closeWindow()
{
	if((parent)&&(parent.closeDialog)){
		parent.closeDialog("PasthistoryDialog");
	}
	if ((window.parent)&&(window.parent.closeDialog)){
        window.parent.closeDialog("PasthistoryDialog");
    }
}