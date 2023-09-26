$(function(){
	setBloodType();
	setRHBloodType();
	setHbsAg();
	setHCVAb();
	setHivAb();
	setTPAb();
});

//手术室//////////////////////////////////////////////
$("#btOperLoc").click(function(){
	getOperLoc();
});
$('#OperLoc').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperLoc();
	}
});
function getOperLoc()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetOperationRoom&p1=OP^OUTOP^EMOP&p2=";
	obj.url = url;
	obj.condition = $("#OperLoc").val();
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if ((returnValues != undefined) && (returnValues != ""))
		{
			$("#OperLoc").val(returnValues.Desc);
			$("#OperLoc").attr("key",returnValues.ID);
		}
	}	
}

///申请科室////////////////////////////////////////////
$("#btOperAppLoc").click(function(){
	getOperAppLoc();
});

$('#OperAppLoc').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperAppLoc();
	}
});

function getOperAppLoc()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetDicList&p1=";
	obj.url = url;
	obj.condition = $("#OperAppLoc").val()
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperAppLoc").val(returnValues.Desc);
			$("#OperAppLoc").attr("key",returnValues.ID);
		}
	}	
}

///诊断////////////////////////////////////////////
$("#btOperPreopDiag").click(function(){
	getOperPreopDiag();
});

$('#OperPreopDiag').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperPreopDiag();
	}
})

function getOperPreopDiag()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=getMRCICD&p1=";
	obj.url = url;
	obj.condition = $("#OperPreopDiag").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperPreopDiag").val(returnValues.Desc);
			$("#OperPreopDiag").attr("key",returnValues.ID);
		}
	}	
}

///手术医师////////////////////////////////////////////
$("#btOperDoc").click(function(){
	getOperDoc();
});

$('#OperDoc').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperDoc();
	}
})

function getOperDoc()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#OperDoc").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperDoc").val(returnValues.Desc);
			$("#OperDoc").attr("key",returnValues.ID);
		}
	}	
}

///一助////////////////////////////////////////////
$("#btOperAssistFirst").click(function(){
	getOperAssistFirst();
});

$('#OperAssistFirst').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperAssistFirst();
	}
})

function getOperAssistFirst()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#OperAssistFirst").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperAssistFirst").val(returnValues.Desc);
			$("#OperAssistFirst").attr("key",returnValues.ID);
		}
	}	
}

///二助////////////////////////////////////////////
$("#btOperAssistSecond").click(function(){
	getOperAssistSecond();
});

$('#OperAssistSecond').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperAssistSecond();
	}
})

function getOperAssistSecond()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#OperAssistSecond").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperAssistSecond").val(returnValues.Desc);
			$("#OperAssistSecond").attr("key",returnValues.ID);
		}
	}	
}

///手术名称////////////////////////////////////////////
$("#btOper").click(function(){
	getOper();
});

$('#Oper').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOper();
	}
})

function getOper()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetORCOperation&p1=";
	obj.url = url;
	obj.condition = $("#Oper").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#Oper").val(returnValues.Desc);
			$("#Oper").attr("key",returnValues.ID);
		}
	}	
}
///手术级别////////////////////////////////////////////
$("#btOperLevel").click(function(){
	getOperLevel();
});

$('#OperLevel').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperLevel();
	}
})

function getOperLevel()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetORCOperationCategory&p1=";
	obj.url = url;
	obj.condition = $("#OperLevel").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperLevel").val(returnValues.Desc);
			$("#OperLevel").attr("key",returnValues.ID);
		}
	}	
}

///切口////////////////////////////////////////////
$("#btOperBladeType").click(function(){
	getOperBladeType();
});

$('#OperBladeType').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperBladeType();
	}
})

function getOperBladeType()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetBladeType&p1=";
	obj.url = url;
	obj.condition = $("#OperBladeType").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperBladeType").val(returnValues.Desc);
			$("#OperBladeType").attr("key",returnValues.ID);
		}
	}	
}

///手术部位////////////////////////////////////////////
$("#btBodsDesc").click(function(){
	getBodsDesc();
});

$('#BodsDesc').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getBodsDesc();
	}
})

function getBodsDesc()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetOperationBody&p1=";
	obj.url = url;
	obj.condition = $("#BodsDesc").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#BodsDesc").val(returnValues.Desc);
			$("#BodsDesc").attr("key",returnValues.ID);
		}
	}	
}

///手术体位////////////////////////////////////////////
$("#btOperPosition").click(function(){
	getOperPosition();
});

$('#OperPosition').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperPosition();
	}
})

function getOperPosition()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetOperPosition&p1=";
	obj.url = url;
	obj.condition = $("#OperPosition").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperPosition").val(returnValues.Desc);
			$("#OperPosition").attr("key",returnValues.ID);
		}
	}	
}
///血型
function setBloodType()
{
	jQuery.ajax({
        dataType: 'json',
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.Event.BLOperation",
			"Method":"GetPACBloodType"
		},
		success: function(d){
			$.each(d,function(index,value){
				$("#OperBloodType").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
			});
		},
		error: function(d){alert("error");}
	});		 	
}
///RH血型
function setRHBloodType()
{
	var data = [{"ID":"1","Desc":"不详"},{"ID":"2","Desc":"阴性(-)"},{"ID":"3","Desc":"阳性(+)"}]; 
	$.each(data,function(index,value){
		$("#OperRhBloodType").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
	});	
}

///HbsAg数据
function getCheckquData()
{
	var data =[{"ID":"1","Desc":"不详"},{"ID":"2","Desc":"阴性(-)"},{"ID":"3","Desc":"阳性(+)"},{"ID":"4","Desc":"化验中"}];
	return data;
}

///HbsAg
function setHbsAg()
{
	$.each(getCheckquData(),function(index,value){
		$("#OperHBsAg").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
	});	
}

/// HCVAb
function setHCVAb()
{
	$.each(getCheckquData(),function(index,value){
		$("#OperHCVAb").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
	});			
}

/// HivAb
function setHivAb()
{
	$.each(getCheckquData(),function(index,value){
		$("#OperHivAb").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
	});		
}

/// TPAb
function setTPAb()
{
	$.each(getCheckquData(),function(index,value){
		$("#OperTPAb").append("<option value='"+value.ID+"'>"+value.Desc+"</option>"); 
	});		
}

///麻醉医师////////////////////////////////////////////
$("#btAnaDoctor").click(function(){
	getAnaDoctor();
});

$('#AnaDoctor').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getAnaDoctor();
	}
})

function getAnaDoctor()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#AnaDoctor").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#AnaDoctor").val(returnValues.Desc);
			$("#AnaDoctor").attr("key",returnValues.ID);
		}
	}	
}
///麻醉方法////////////////////////////////////////////
$("#btAnaMethod").click(function(){
	getAnaMethod();
});

$('#AnaMethod').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getAnaMethod();
	}
})

function getAnaMethod()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetAnaMethod&p1=";
	obj.url = url;
	obj.condition = $("#AnaMethod").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#AnaMethod").val(returnValues.Desc);
			$("#AnaMethod").attr("key",returnValues.ID);
		}
	}	
}

///手术间////////////////////////////////////////////
$("#btOperRoom").click(function(){
	getOperRoom();
});

$('#OperRoom').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getOperRoom();
	}
})

function getOperRoom()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=String&Class=EMRservice.BL.Event.BLOperation&Method=GetOproomdr&p1=";
	obj.url = url;
	obj.condition = $("#OperRoom").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#OperRoom").val(returnValues.Desc);
			$("#OperRoom").attr("key",returnValues.ID);
		}
	}	
}
///器械护士一////////////////////////////////////////////
$("#btScrubNurFirst").click(function(){
	getScrubNurFirst();
});

$('#ScrubNurFirst').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getScrubNurFirst();
	}
})

function getScrubNurFirst()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#ScrubNurFirst").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#ScrubNurFirst").val(returnValues.Desc);
			$("#ScrubNurFirst").attr("key",returnValues.ID);
		}
	}	
}

///器械护士二////////////////////////////////////////////
$("#btScrubNurSecond").click(function(){
	getScrubNurSecond();
});

$('#ScrubNurSecond').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getScrubNurSecond();
	}
})

function getScrubNurSecond()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#ScrubNurSecond").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#ScrubNurSecond").val(returnValues.Desc);
			$("#ScrubNurSecond").attr("key",returnValues.ID);
		}
	}	
}
///器械护士三////////////////////////////////////////////
$("#btScrubNurThird").click(function(){
	getScrubNurThird();
});

$('#ScrubNurThird').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getScrubNurThird();
	}
})

function getScrubNurThird()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#ScrubNurThird").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#ScrubNurThird").val(returnValues.Desc);
			$("#ScrubNurThird").attr("key",returnValues.ID);
		}
	}	
}

///巡回护士一////////////////////////////////////////////
$("#btCirculNurFirst").click(function(){
	getCirculNurFirst();
});

$('#CirculNurFirst').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getCirculNurFirst();
	}
})

function getCirculNurFirst()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#CirculNurFirst").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#CirculNurFirst").val(returnValues.Desc);
			$("#CirculNurFirst").attr("key",returnValues.ID);
		}
	}	
}

///巡回护士二////////////////////////////////////////////
$("#btCirculNurSecond").click(function(){
	getCirculNurSecond();
});

$('#CirculNurSecond').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getCirculNurSecond();
	}
})

function getCirculNurSecond()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#CirculNurSecond").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#CirculNurSecond").val(returnValues.Desc);
			$("#CirculNurSecond").attr("key",returnValues.ID);
		}
	}	
}

///巡回护士三////////////////////////////////////////////
$("#btCirculNurThird").click(function(){
	getCirculNurThird();
});

$('#CirculNurThird').bind('keypress',function(event){
	if(event.keyCode == "13")
	{
		getCirculNurThird();
	}
})

function getCirculNurThird()
{
	var obj = new  Object();
	var url = "EMRservice.Ajax.common.cls?OutputType=Stream&Class=EMRservice.BL.Event.BLOperation&Method=GetCTCareProv&p1=";
	obj.url = url;
	obj.condition = $("#CirculNurThird").val()	
	var Values = window.showModalDialog("emr.record.library.navoperation.dictionarygird.csp",obj,"dialogHeight:400px;dialogWidth:500px;resizable:yes;status:no");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if (returnValues != undefined && returnValues != "")
		{
			$("#CirculNurThird").val(returnValues.Desc);
			$("#CirculNurThird").attr("key",returnValues.ID);
		}
	}	
}

/////////////////////////////////////////////////////////////////////////

///添加手术
$("#btOperationAdd").click(function(){
	var data = getSelectOperInfo();
	if (data == "") return;
	var row = "";
	row = row + "<td field='OperID'>"+data.OperID+"</td>";
	row = row + "<td field='Oper'>"+data.Oper+"</td>";
	row = row + "<td field='OperLevelID'>"+data.OperLevelID+"</td>";
	row = row + "<td field='OperLevel'>"+data.OperLevel+"</td>";
	row = row + "<td field='OperBladeTypeID'>"+data.OperBladeTypeID+"</td>";
	row = row + "<td field='OperBladeType'>"+data.OperBladeType+"</td>";
	row = row + "<td field='OperMemo'>"+data.OperMemo+"</td>";
	row = row + "<td><a href='#' onclick='DelectTr(this)'>删除<a></td>";
	$('#operations').append($("<tr></tr>").append(row));	
});

///删除行
function DelectTr(obj){
	$(obj).parent().parent().remove(); 
};

///选择手术数据
function getSelectOperInfo()
{
	var result = {};
	var flag = false;
	$(".opergroup .linegroup .item").each(function(i) {
		var required = $(this).find(".required").text();
		var name =  $(this).find(".name").text();
		var valueElement = $(this).find(".value");
		var valueName =  $(valueElement).attr("id");
		var valueId = "";
		var valueDesc = "";
		var elementType = $(valueElement).attr("type");
		if (elementType == "text")
		{
			valueDesc = $(valueElement).val();
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}	
			result[valueName]= valueDesc;		
		}
		else if (elementType == "keyvalue")
		{
			valueId =  $(valueElement).attr("key");
			valueDesc =  $(valueElement).val();
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}
			var valueNameId = valueName +"ID";
			result[valueNameId] = valueId;		
			result[valueName]= valueDesc;
		}
	});	
	if (flag) result = "";
	return result;
}

$("#btSave").click(function(){

	var data = getAllOperInfo();
	if ((typeof(data.operSubs) == "undefined")||(data.operSubs.length == 0)) return;
    jQuery.ajax({
		type: "post",
        dataType: "json",
		url: "../EMRservice.Ajax.operation.cls",
		async: true,
		data: {
			ID:$("#ID").val(),
			PatientID:patientID,
			EpisodeID:episodeID,
			Data:JSON.stringify(data)
		},
		success: function(d){
 			if (d != "0") 
 			{
	 			$("#ID").val(d);
 				var OperDatetime = data.OperStartDate+" "+data.OperStartTime;
 				if (data.OperStartDate == "") 
 				{
	 				OperDatetime = data.OperDate;
	 			}
 				var returnvalues = 
 				{
	 				"OperDateTime":OperDatetime,
	 				"OperDesc":data.operSubs[0].Oper,
	 				"OperDoc":data.OperDoc,
	 				"OperLevel":data.OperLevel,
	 				"OperAssistFirst":data.OperAssistFirst,
	 				"OperAssistSecond":data.OperAssistSecond,
	 				"ID":d
 				};
 				window.returnValue  = JSON.stringify(returnvalues);
 				alert("保存成功");
 				windowClose();
 			}
 			else
 			{
 				alert("保存失败");
 			}
		},
		error: function(d){alert("error");}
	});
});

$("#btClose").click(function(){
	
 	windowClose();
});

///必填项检查
function checkRequired(value,desc)
{
	var result = true
	if ((value == "")||(value == "0"))
	{
		alert(desc + " 必填,请填写");
		result = false;
	}
	return result;
}

///所填数据信息
function getAllOperInfo()
{
	var result = {};
	var flag = false;
	$(".linegroup .operItem").each(function(i) {
		var required = $(this).find(".required").text();
		var name =  $(this).find(".name").text();
		var valueElement = $(this).find(".value");
		var valueName =  $(valueElement).attr("id");
		var valueId = "";
		var valueDesc = "";
		var elementType = $(valueElement).attr("type");
		if (elementType == "datetime")
		{
			valueDesc = $(valueElement).val();
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}
			result[valueName+"Date"]= valueDesc.split(" ")[0];
			result[valueName+"Time"]= valueDesc.split(" ")[1];
			if (result[valueName+"Date"] == undefined) result[valueName+"Date"] ="";
			if (result[valueName+"Time"] == undefined) result[valueName+"Time"] ="";
		}
		else if (elementType == "text")
		{
			valueDesc = $(valueElement).val();
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}	
			result[valueName]= valueDesc;		
		}
		else if (elementType == "keyvalue")
		{
			valueId =  $(valueElement).attr("key");	
			if (valueId == undefined) valueId ="";
			valueDesc = $(valueElement).val();
			
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}
			var valueNameId = valueName +"ID";
			result[valueNameId] = valueId;		
			result[valueName]= valueDesc;		
		}
		else if (elementType == "select")
		{	
			valueDesc = $(valueElement).find("option:selected").text();
			if (required != "")
			{
				if (!checkRequired(valueDesc,name))
				{
					flag = true;
					return false;
				}
			}	
			result[valueName]= valueDesc;	
		}
		else if (elementType == "checkbox")
		{
			if ($(valueElement).attr("checked"))
			{
				result[valueName]= "Y";
			}
			else
			{
				result[valueName]= "N";
			}
		}
	});
	
	var subarry = new Array();
			
	$("#operations").find("tr").each(function(){
		var sub = new Object();
		$(this).find("td").each(function(){
			if ($(this).text()== "删除") return true;
			sub[$(this).attr("field")]= $(this).text();
		});
		if (!$.isEmptyObject(sub)) subarry.push(sub);
	});
	
	if (subarry.length <=0) 
	{
		flag = true;
		alert("拟施手术必填,请填写！");
	}
	else
	{
		result["operSubs"] = subarry;
	}
	if (flag) result = {};
	return result;	
}

function windowClose()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}


