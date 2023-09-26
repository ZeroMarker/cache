///Creator :QQA 
///CreateDate: 2017-03-09

$(function (){
	
	validAdm();
	
	showCheckLev();
	
	///初始化easyui控件
	initWidget();
	
	///初始化按钮方法
	initMethod();

})

function validAdm(){
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
}

//显示分级的信息
function showCheckLev(){
	//获取病人信息
	runClassMethod("web.DHCEMECheck","GetEmPatCheckLevGrade",{
		EpisodeID:EpisodeID
		},function (data){
			var nursCheckLev = data.split("^")[0];
			var docCheckLev = data.split("^")[1]?data.split("^")[1]:"无";
			var styleCss = StyleCheckLevColor(nursCheckLev); 
			$("#nursCheck").val(setCellLabel(nursCheckLev)); //hxy 2020-02-20
			$("#nursCheck").css(styleCss);
			var styleCss = StyleCheckLevColor(docCheckLev); 
			$("#docCheck").val(setCellLabel(docCheckLev)); //hxy 2020-02-20
			$("#docCheck").css(styleCss);
		},"text"
	)
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
		data:[{ "id": "1", "text": "Ⅰ级"},{ "id": "2", "text": "Ⅱ级"},{ "id": "3", "text": "Ⅲ级"},{ "id": "4", "text": "Ⅳa级"},{ "id": "5", "text": "Ⅳb级"}] //hxy 2020-02-20
		//data:[{ "id": "1", "text": "1级"},{ "id": "2", "text": "2级"},{ "id": "3", "text": "3级"},{ "id": "4", "text": "4级"}]
	});

	
}

function initMethod(){
	$('a:contains("保存")').bind("click",UptPatCheckLev);
	$('a:contains("取消")').bind("click",CloseWindow);	
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
}

//hxy 2020-02-20
function setCellLabel(value){
	if(value.indexOf("1级")>-1){value="Ⅰ级";}
	if(value.indexOf("2级")>-1){value="Ⅱ级";}
	if(value.indexOf("3级")>-1){value="Ⅲ级";}
	if(value.indexOf("4级")>-1){value="Ⅳa级";}
	if(value.indexOf("5级")>-1){value="Ⅳb级";}
	return value;
}
