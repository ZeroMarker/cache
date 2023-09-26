$(function(){
    
    init();
    
	//�����û�
	$('#txtUser').bind("input propertychange",function(){
		clearCheckWindow();
		txtUserChange();
 	});	

 	//���������
 	$('#txtPwd').blur(function() {
	 	getIdentityVerifcation();
 	});
 	
 	//��ʼǩ��
	$("#checkSure").click(function(){
		var userInfo = $("#hiddenUserInfo").val();
		if (userInfo == "")
		{ 
			alert('�û������������');
			return;
		}
		window.returnValue = '{"action":"sign","userInfo":'+userInfo+'}';
		closeWindow();
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
	$("#signCell")[0].innerText = opts.cellName;
 	$("#divUserName")[0].innerText = userName;
 	$("#txtUser").val(userCode)
	txtUserChange();
}
 
 // �û����ı�ʱ����ǩ���������������޸ģ�����ʾ��Ӧ�û�������
function txtUserChange(){
	var txtUserCode = $('#txtUser').val();
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":txtUserCode,
			"p2":'',
			"p3":'INSU'
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
	if (tmpPassword == "") 
	{
		alert('����������'); 
		return;	
	}
	jQuery.ajax({
		type: "POST",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":tmpUserCode,
			"p2":tmpPassword,
			"p3":"INSU"
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
	window.opener=null;
	window.open('','_self');
	window.close();	
}