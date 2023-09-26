
$(function(){
    
    init();
    if (openFlag == "0"){
	    checkSure();
	    return;
	}
    
    
	//�����û�
	$('#txtUser').bind("input propertychange",function(){
		$("#divPwd").css("display","block");
		clearCheckWindow();
		txtUserChange();
 	});	

 	//���������
 	$('#txtPwd').blur(function() {
	 	getIdentityVerifcation();
 	});
 	
 	//��ʼǩ��
	$("#checkSure").click(function(){
		checkSure();
	});
	
	//ȡ����ر�ǩ��
	$("#checkCancel").click(function(){
		closeWindow();
		window.returnValue = "";
	});
	
	//����ǩ��
	$("#revokeCheck").click(function(){
		var userInfo = $("#hiddenUserInfo").val();
		if (userInfo == "")
		{ 
			alert('�û������������');
			return;
		}
		window.returnValue = '{"action":"revoke","userInfo":'+userInfo+'}';
		closeWindow();
	});	
	
});

function init()
{   
    //����showModalDialog��hisui��dialogд��
	if ((typeof(opts)=="undefined")&&(signParamStr != ""))
    {
	    opts = JSON.parse(unescape(utf8to16(base64decode(signParamStr)))); 
	}
	if (opts.canRevokCheck == 1) 
	{
		$("#revokeCheck").css('display','block');
	}
	else
	{
		$("#revokeCheck").css('display','none');
	}
	$("#signCell")[0].innerText = opts.cellName;
 	$("#divUserName")[0].innerText = userName;
 	$("#txtUser").val(userCode);
 	$("#divPwd").css('display','none');
	txtUserChange();
	getIdentityVerifcation(); 
}

function checkSure()
{
	var userInfo = $("#hiddenUserInfo").val();
	if (userInfo == "")
	{ 
		alert('�û������������');
		return;
	}
	window.returnValue = '{"action":"sign","userInfo":'+userInfo+'}';
	closeWindow();		
}
 
 // �û����ı�ʱ����ǩ���������������޸ģ�����ʾ��Ӧ�û�������
function txtUserChange(){
	var txtUserCode = $('#txtUser').val();
	if (txtUserCode == userCode)
	{
		$("#divPwd").css('display','none');
		getIdentityVerifcation();
	}
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"web.DHCCM.EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":txtUserCode,
			"p2":''
		},
		success: function(d) {
			 if (d == "")
			 {
				 $("#divUserName")[0].innerText = "";
			 }
			 else 
			 {
				 result = eval("("+d+")");
				 $("#divUserName")[0].innerText = result.UserName;
				 $("#txtLevel").val(result.LevelDesc);
			 }
		},
		error: function(d) {alert("error");}
	});	
}
 
 //ǩ�������֤(��̨������֤)
function getIdentityVerifcation()
{
	document.getElementById("checkSure").focus();
	var tmpUserCode = $("#txtUser").val();
	var tmpPassword = $("#txtPwd").val();
	if (tmpUserCode != userCode)
	{
		if (tmpPassword == "") 
		{
			alert('����������'); 
			return;	
		}
	}
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"web.DHCCM.EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":tmpUserCode,
			"p2":tmpPassword
		},
		success: function(d) {
			 if (d == "")
			 {
				 alert('�û����������'); 
			 }
			 else 
			 {
				 result = eval("("+d+")");
				 $("#txtLevel").val(result.LevelDesc);
				 $("#hiddenUserInfo").val(d);
			 }
		},
		error: function(d) {alert("error");}
	});	
}

//���ǩ�������ı���
function clearCheckWindow()
{
	$("#txtPwd").val("");
	$("#txtLevel").val("");
	$("#hiddenUserInfo").val("");
}

function closeWindow()
{
	if ((signParamStr != "")&&(openWay == "sign"))
	{
		parent.closeDialog("SignDialog");	
	}
	else
	{
		//����showModalDialogд��
		window.opener=null;
		window.open('','_self');
		window.close();	
	}
}