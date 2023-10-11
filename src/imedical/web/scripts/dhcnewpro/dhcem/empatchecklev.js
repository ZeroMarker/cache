///Creator :QQA 
///CreateDate: 2017-03-09
var windowId = '';
$(function (){
	
	validAdm();
	
	showCheckLev();
	
	///初始化easyui控件
	initWidget();
	
	///初始化按钮方法
	initMethod();

})

function validAdm(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2011-10-24 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	if(hosNoPatOpenUrl!=""){
		$("#cancLev").hide();
	}
	
	//获取病人信息
	runClassMethod("web.DHCEMECheck","GetAdmStatus",{
		EpisodeID:EpisodeID
		},function (ret){
			if(ret!="A"){
				$.messager.alert("提示:","当前就诊状态非正常就诊状态，不允许更改分级！","info",function(){
					window.close()
				});	
			}
		},"text"
	)
	
	window.onload = function(){
		windowId = GetQueryString("windowId");
	}
}

//显示分级的信息
function showCheckLev(){
	if(EpisodeID=="")return;
	//获取病人信息
	runClassMethod("web.DHCEMECheck","GetEmPatCheckLevGrade",{
		EpisodeID:EpisodeID
		},function (data){
			var nursCheckLev = data.split("^")[0];
			var docCheckLev = data.split("^")[1]?data.split("^")[1]:$g("无");
			var styleCss = StyleCheckLevColor(nursCheckLev); 
			$("#nursCheck").val(setCellLabel(nursCheckLev)); //hxy 2020-02-20
			$("#nursCheck").css(styleCss);
			var styleCss = StyleCheckLevColor(docCheckLev); 
			$("#docCheck").val(setCellLabel(docCheckLev)); //hxy 2020-02-20
			$("#docCheck").css(styleCss);
		},"text"
	)
	
	InitPatInfoBanner(EpisodeID); 
}

function initWidget(){
	$("#CheckLevCause").combobox({
		multiple:false,
		blurValidValue:true,
		url:LINK_CSP+'?ClassName=web.DHCEMDocUpReason&MethodName=JsonComboDocUpdReason&hopDr='+LgHospID+"&Type=Doc"
	});
	
	$("#NurCheckAssess").combobox({
		blurValidValue:true,
		url:LINK_CSP+'?ClassName=web.DHCEMDocAssessType&MethodName=JsonComboDocAssessType&hopDr='+LgHospID
	});
	
	$("#DocLevel").combobox({
		blurValidValue:true,
		valueField:'id',
		textField:'text',
		data:[{ "id": "1", "text": $g("Ⅰ级")},{ "id": "2", "text": $g("Ⅱ级")},{ "id": "3", "text": $g("Ⅲ级")},{ "id": "4", "text": $g("Ⅳa级")},{ "id": "5", "text": $g("Ⅳb级")}] //hxy 2020-02-20
		//data:[{ "id": "1", "text": "1级"},{ "id": "2", "text": "2级"},{ "id": "3", "text": "3级"},{ "id": "4", "text": "4级"}]
	});

	
}

function initMethod(){
	$('#saveLev').bind("click",UptPatCheckLev); //a:contains("保存")
	$('#cancLev').bind("click",CloseWindow);	//a:contains("取消")
}

///修改病人分级
function UptPatCheckLev(){
	var Params  = getParams();
	
	if(Params==""){
		return;	
	}
	
	runClassMethod("web.DHCEMECheck","InsDHCEmDocUpdPatLev",
    {Adm:EpisodeID,
   	 Params:Params
    },
	   function (data){
			if(data==0){
				$.messager.alert("提示:","保存成功！","info",function(){
					if(window.opener!=null){			///界面刷新
						if(window.opener.parentFlash){
							window.opener.parentFlash();
						}
					}
					window.close()
				});	
			}else{
				$.messager.alert("提示:","保存失败！");		
			}
		},
		"text",false
	);
}

function getParams(){
	var Params = ""
	//级别^分诊原因id^医生id^护士分级评估^评估说明^日期(数字)^时间(数字)
	var DocCheckLev = $('#DocLevel').combobox("getValue");
	
	if(DocCheckLev===""){
		$.messager.alert("提示:","请选择分级！");	
		return "";
	}
	
	var DocCheck=$("#docCheck").val(); //hxy 2020-03-10 st
	var DocCheckLevText = $('#DocLevel').combobox("getText");
	if(DocCheckLevText==DocCheck){
		$.messager.alert("提示:","修改分级与当前分级相同，无需修改！");	
		return "";
	}//ed

	var CheckLevCause=""
	CheckLevCause = $('#CheckLevCause').combobox("getValue");
	
	if(CheckLevCause===""){
		$.messager.alert("提示:","请选择更改原因！");	
		return "";
	}
	
	var NurCheckAssess = ""
	NurCheckAssess = $('#NurCheckAssess').combobox("getValue");
	
	var NurCheckComments=""
	NurCheckComments = $('#NurCheckComments').val();
	
	Params=DocCheckLev+"^"+CheckLevCause+"^"+LgUserID+"^"+NurCheckAssess+"^"+NurCheckComments

	return Params;	
}

function StyleCheckLevColor(param){
	var css={};
	if(param.indexOf("1级")>-1){ //hxy 2020-02-20 原： =="1级"
		css = {"color":"red","font-weight":"bold"};
	}
	if(param.indexOf("2级")>-1){ //=="2级"
		css = {"color":"orange","font-weight":"bold"}; //hxy 2020-02-20 原： red
	}
	if(param.indexOf("3级")>-1){ //=="3级"
		css = {"color":"#f9bf3b","font-weight":"bold"};	
	}
	if((param.indexOf("4级")>-1)||(param.indexOf("5级")>-1)){ //hxy 2020-02-20 add ||(param=="5级")
		css = {"color":"green","font-weight":"bold"};	
	}
	return css;
}

///关闭界面
function CloseWindow(){
	window.close();
	myClick('windowClose');
}

//hxy 2020-02-20
function setCellLabel(value){
	if(value.indexOf("1级")>-1){value=$g("Ⅰ级");}
	if(value.indexOf("2级")>-1){value=$g("Ⅱ级");}
	if(value.indexOf("3级")>-1){value=$g("Ⅲ级");}
	if(value.indexOf("4级")>-1){value=$g("Ⅳa级");}
	if(value.indexOf("5级")>-1){value=$g("Ⅳb级");}
	return value;
}

function GetQueryString(name){
	var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if(r!=null)return  unescape(r[2]); return null;
}

function myClick (command){
	window.parent.postMessage(
	{ operatePortalWindow: 
	{
		windowId: windowId,
		operate: command
	} 
	},"*");
}