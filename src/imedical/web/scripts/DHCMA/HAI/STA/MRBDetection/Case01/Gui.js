//ҳ��Gui
function InitCtlResultWin(){
	var obj = new Object();
	obj.QryOpption="label01"
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID)
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//��ҽԺ����Select�¼������¿����б�
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
	//���ͷ�����ʾ
	var htmlStr='<div><b>������ҩ���������</b></div><ul>';
	$.each(MRBRuleJson, function(index, value) {
		htmlStr += '<li>'+ index +'</li>';
		htmlStr += '<ul>';
		htmlStr += '<li>���ͣ�'+ value.MRB +'</li>';
		htmlStr += '<li>��ԭ�壺'+ value.Bacteria +'</li>';
		htmlStr += '</ul>';
	});
	htmlStr += '</ul>';
	$("#QueryDesc").html(htmlStr);

	debugger
	InitCtlResultWinEvent(obj);
	return obj;
}
$(InitCtlResultWin);