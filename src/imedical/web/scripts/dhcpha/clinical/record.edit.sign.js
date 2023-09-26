
$(function(){
    
    init();
    if (openFlag == "0"){
	    checkSure();
	    return;
	}
    
    
	//更改用户
	$('#txtUser').bind("input propertychange",function(){
		$("#divPwd").css("display","block");
		clearCheckWindow();
		txtUserChange();
 	});	

 	//输入密码后
 	$('#txtPwd').blur(function() {
	 	getIdentityVerifcation();
 	});
 	
 	//开始签名
	$("#checkSure").click(function(){
		checkSure();
	});
	
	//取消或关闭签名
	$("#checkCancel").click(function(){
		closeWindow();
		window.returnValue = "";
	});
	
	//撤销签名
	$("#revokeCheck").click(function(){
		var userInfo = $("#hiddenUserInfo").val();
		if (userInfo == "")
		{ 
			alert('用户名或密码错误');
			return;
		}
		window.returnValue = '{"action":"revoke","userInfo":'+userInfo+'}';
		closeWindow();
	});	
	
});

function init()
{   
    //兼容showModalDialog和hisui的dialog写法
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
		alert('用户名或密码错误');
		return;
	}
	window.returnValue = '{"action":"sign","userInfo":'+userInfo+'}';
	closeWindow();		
}
 
 // 用户名改变时，对签名窗口做出布局修改，并显示对应用户姓名；
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
 
 //签名身份验证(后台数据验证)
function getIdentityVerifcation()
{
	document.getElementById("checkSure").focus();
	var tmpUserCode = $("#txtUser").val();
	var tmpPassword = $("#txtPwd").val();
	if (tmpUserCode != userCode)
	{
		if (tmpPassword == "") 
		{
			alert('请输入密码'); 
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
				 alert('用户名密码错误'); 
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

//清楚签名窗口文本框
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
		//兼容showModalDialog写法
		window.opener=null;
		window.open('','_self');
		window.close();	
	}
}