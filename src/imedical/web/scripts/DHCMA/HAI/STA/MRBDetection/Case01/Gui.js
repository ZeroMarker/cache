//页面Gui
function InitCtlResultWin(){
	var obj = new Object();
	obj.QryOpption="label01"
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID)
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			Common_ComboToLoc("cboLocation",HospIDs,'','I|E','E');
		 }
	 })
	 var MRBRule=$m({
		 	ClassName : 'DHCHAI.STAS.MRBDetectionSrv',
			MethodName : 'GetMRBRule',
		},false)
	var MRBRuleJson = $.parseJSON(MRBRule);
	var Html='<select class="hisui-combobox" id="cboMRBRule" style="width:200px" disabled>'
	$.each(MRBRuleJson, function(index, value) {
		Html+="<option value='"+index+"'>"+index+"</option>";
	});
	Html+='</select>'
	$("#MRBRule").append(Html);
	$.parser.parse('#MRBRule');
	$("#cboMRBRule").combobox("setValue",""); 
	//多耐分类提示
	var htmlStr='<div><b>多重耐药菌归类规则</b></div><ul>';
	$.each(MRBRuleJson, function(index, value) {
		htmlStr += '<li>'+ index +'</li>';
		htmlStr += '<ul>';
		htmlStr += '<li>多耐：'+ value.MRB +'</li>';
		htmlStr += '<li>病原体：'+ value.Bacteria +'</li>';
		htmlStr += '</ul>';
	});
	htmlStr += '</ul>';
	$("#QueryDesc").html(htmlStr);

	debugger
	InitCtlResultWinEvent(obj);
	return obj;
}
$(InitCtlResultWin);