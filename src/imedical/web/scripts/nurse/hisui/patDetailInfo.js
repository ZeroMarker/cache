$(window).load(function() {
	$("#Loading").hide();
})
$(function(){
	Init();
	InitEvent();
});
function Init(){
	setPatientBarInfo();
	setPatientInfo();
}
function InitEvent(){
	$("#btnSave").click(btnSaveClick);
	$("#btnCancel").click(btnCancelClick);
}
function setPatientInfo(){
	for (index1 in ServerObj.detailInfoObj){
		for (index2 in ServerObj.detailInfoObj[index1]){
			var itemObj=ServerObj.detailInfoObj[index1][index2];
			var id=itemObj["itemId"];
			var value=itemObj["itemValue"];
			if (ServerObj.saveOperation!="N"){
				if (id=="mainDoctor"){
					initMainDoc(value);
				}else if(id=="mainNurse"){
					initMainNurse(value);
				}else{
					$("#"+id).val(value);
				}
			}else{
				if ((id=="mainDoctor")||(id=="mainNurse")){
					$("#"+id).val(value.split(" ").join(","));
				}else{
					$("#"+id).val(value);
				}
			}
		}
	}
	
}
var patientListPage="";
// 加载患者信息条数据
function setPatientBarInfo() {
	InitPatInfoBanner(ServerObj.EpisodeID);
	/*var html=$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: ServerObj.EpisodeID
	},false);
	if (html != "") {
		$(".patientbar").data("patinfo",html);
		if ("function"==typeof InitPatInfoHover) {InitPatInfoHover();}
		else{$(".PatInfoItem").html(reservedToHtml(html))}
		$(".PatInfoItem").find("img").eq(0).css("top",0);
	} else {
		$(".PatInfoItem").html("获取病人信息失败。请检查【患者信息展示】配置。");
	}*/
}
function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
		return replacements[v];
	});
}
function initMainDoc(defValue){
	var patCurrLocID=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetCurrLocID",
		EpisodeID:ServerObj.EpisodeID
	},false)
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainDoctors",
		locID:patCurrLocID
	},function(docData){
		$('#mainDoctor').combobox({
			width:$("#mainDoctor").parent().width(),
			multiple:ServerObj.MainDocMulti=="Y"?true:false,
			rowStyle:"checkbox",
			disabled:false,
			blurValidValue:true,
			selectOnNavigation:true,
			valueField:'ID',
			textField:'name',
			data:docData,
			filter: function(q, row){
				var pyjp = getPinyin(row["name"]).toLowerCase();
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				$.cm({
					ClassName:"Nur.NIS.Service.Base.Patient",
					MethodName:"GetMainDoctorID",
					EpisodeID:ServerObj.EpisodeID
				},function(mainDocIdArr){
					if (ServerObj.MainDocMulti=="Y"){
						if (mainDocIdArr.length==0){
							$('#mainDoctor').combobox("setValues","");
						}else{
							$('#mainDoctor').combobox("setValues",mainDocIdArr);
						}
					}else{
						$('#mainDoctor').combobox("setValue",mainDocIdArr[0]);
					}
				})
			},
			onSelect:function(rec){
				if (ServerObj.MainDocMulti=="Y"){
					var selValArr=$('#mainDoctor').combobox("getValues");
					if (selValArr.length>=3){
						$('#mainDoctor').combobox("setValues",selValArr.slice(1,3))
					}
				}
			}
	    });
	})
}
function initMainNurse(defValue){
	var patCurrWardID=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"GetCurrWardID",
		EpisodeID:ServerObj.EpisodeID
	},false)
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		MethodName:"GetMainNursesByWardID",
		wardID:patCurrWardID
	},function(docData){
		$('#mainNurse').combobox({
			width:$("#mainNurse").parent().width(),
			multiple:ServerObj.MainNurseMulti=="Y"?true:false,
			rowStyle:"checkbox",
			disabled:false,
			blurValidValue:true,
			selectOnNavigation:true,
			valueField:'ID',
			textField:'name',
			data:docData,
			filter: function(q, row){
				var pyjp = getPinyin(row["name"]).toLowerCase();
				return (row["name"].toUpperCase().indexOf(q.toUpperCase()) >= 0) ||(pyjp.toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess:function(){
				$.cm({
					ClassName:"Nur.NIS.Service.Base.Patient",
					MethodName:"GetMainNurseID",
					EpisodeID:ServerObj.EpisodeID
				},function(mainNurseIdArr){
					if (ServerObj.MainNurseMulti=="Y"){
						if (mainNurseIdArr.length==0){
							$('#mainNurse').combobox("setValues","");
						}else{
							$('#mainNurse').combobox("setValues",mainNurseIdArr);
						}
					}else{
						$('#mainNurse').combobox("setValue",mainNurseIdArr);
					}
					
				})
			},
			onSelect:function(rec){
				if (ServerObj.MainNurseMulti=="Y"){
					var selValArr=$('#mainNurse').combobox("getValues");
					if (selValArr.length>=3){
						$('#mainNurse').combobox("setValues",selValArr.slice(1,3))
					}
				}
			}
	    });
	})
}
function btnSaveClick(){
	var mainDocIDArr=$('#mainDoctor').combobox("getValues").join(",");
	if ((ServerObj.MainDocRequired=="Y")&&(mainDocIDArr=="")){
		$.messager.popover({msg:'请在下拉框中选择主管医生',type:'error'});
		$('#mainDoctor').next('span').find('input').focus();
		return false;
	}
	var mainNurIDArr=$('#mainNurse').combobox("getValues").join(",");
	if ((ServerObj.MainNurseRequired=="Y")&&(mainNurIDArr=="")){
		$.messager.popover({msg:'请在下拉框中选择主管护士',type:'error'});
		$('#mainNurse').next('span').find('input').focus();
		return false;
	}
	var data=$.cm({
		ClassName:"Nur.NIS.Service.Base.Patient",
		MethodName:"UpdateMainDocNur",
		episodeID:ServerObj.EpisodeID,
		mainDocIDArray:mainDocIDArr,
		mainNurIDArray:mainNurIDArr,
		userID:session['LOGON.USERID'],
		data:"text"
	},false)
	if (data.status == 0) {
      	$.messager.popover({msg:'保存成功!',type:'success'});
      	if (websys_showModal('options').CallBackFunc) {
			websys_showModal('options').CallBackFunc(0);
		}else{
			window.close();
		}
    } else {
       $.messager.popover({msg:'保存失败!'+data.status,type:'error'});
    }
}
function btnCancelClick(){
	if (websys_showModal('options').CallBackFunc) {
		websys_showModal('options').CallBackFunc();
	}else{
		window.close();
	}
}