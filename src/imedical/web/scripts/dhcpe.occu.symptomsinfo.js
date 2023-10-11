/// dhcpe.occu.symptomsinfo.js
/// dhcpe.occu.symptomsinfo.csp

$(function() {
	setLayoutSize(0);
	$("input[name='SymptomChk']").click(function(){
		var SyspCode = this.id;
		if (this.checked) {
			$("#Remark" + SyspCode).removeAttr("disabled");
		} else {
			$("#Remark" + SyspCode).attr("disabled","true");
			$("#Remark" + SyspCode).val("");
		}
	});
	
	$("#SaveSymptom").click(function(){
		SaveSymptom_Click();
	});
});

/**
 * ����Body�Ŀ��
 * @param    {[int]}    flag [0 չ��  1 �۵�]
 * @Author   wangguoying
 * @DateTime 2019-09-04
 */
function setLayoutSize(flag) {
	debugger;
    //var dWidth = $(window).width();
    var dWidth = $("#DocPanel", window.parent.document).width()-36;
    var parentLeft = $("#PersonTab", window.parent.document);
    if (parentLeft.css("display") == "none") flag = 1;   //��ֹ����������۵�ʱ��ˢ��iframe�����Ҳ�հ�
    var leftWidth = 0;
    if (flag == 1) {
        leftWidth = 0;
    } else {
        leftWidth = parentLeft.width() - 20;
    }

    $("#SysptomsBody").height($("#DocCenter", window.parent.document).height()-86);
    $("#SysptomsBody").width(dWidth - leftWidth);
    $("#SysptomsBody").layout("resize");
}

function SaveSymptom_Click() {
    setLayoutSize(0);
	var arr = [];
	$("input[name='SymptomChk']:checked").each(function(i,item){
		var SyspCode = this.id;
		var SyspRemark = $("#Remark" + SyspCode).val();
		var obj = {};
		obj.code = SyspCode;
		obj.text = SyspRemark;
		arr.push(obj);
	});
	var Result = JSON.stringify(arr);
	
	$.cm({
		ClassName:"web.DHCPE.Occu.Common",
        MethodName:"SaveSymptom",
        PreIADM:PreIADM,
        Result:Result,
        UserID:session["LOGON.USERID"]
	}, function(data) {
		if (data.code > 0) {
			$.messager.alert("��ʾ", "����ɹ���", "info");
			$("#SymptomUser").val(session["LOGON.USERNAME"]);
			$("#SymptomDate").val(data.msg);
		} else {
			$.messager.alert("��ʾ", "����ʧ�ܣ�", "info");
		}
	});
}