
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
	$('#txtUser').keyup(function(event){
	  if(event.keyCode ==13){
		$('#txtPwd').focus();
	  }
	}); 	

 	//输入密码后
 	$('#txtPwd').blur(function() {
	 	getIdentityVerifcation();
 	});
 	
 	$('#txtPwd').keyup(function(event){
	  if(event.keyCode ==13){
		$('#checkSure').focus();
	  }
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
 	$("#txtUser").val(userCode)
 	$("#divPwd").css('display','none');
 	if (isEnableSelectUserLevel == "Y") {
		$("#txtLevel").combobox({
			valueField: 'LevelCode',
			textField: 'LevelDesc',
			width:204,
			panelHeight:120
		});
	}
	txtUserChange();
	getIdentityVerifcation(); 
	$('#checkSure').focus();
}

function checkSure()
{
	var userInfo = $("#hiddenUserInfo").val();
	if (userInfo == "")
	{ 
		alert('用户名或密码错误');
		return;
	}
	if (isEnableSelectUserLevel == "Y")
	{
		 var result = eval("("+$("#hiddenUserInfo").val()+")");
		 if (result.UserLevel != "")
		 {
		 	result.UserLevel = $('#txtLevel').combobox('getValue');
		 	result.LevelDesc = $("#txtLevel").combobox('getText');
		 	userInfo = JSON.stringify(result);
		 }
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
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":txtUserCode,
			"p2":'',
			"p3":userLocId,
			"p4":"",
			"p5":"inpatient",
			"p6":episodeId
		},
		success: function(d) {
			 if (d == "")
			 {
				 $("#divUserName")[0].innerText = "";
			 }
			 else 
			 {
				 $("#txtLevel").val("");
				 result = eval("("+d+")");
				 $("#divUserName")[0].innerText = result.UserName;
				 $("#txtLevel").val(result.LevelDesc);
				 if (isEnableSelectUserLevel == "Y")
				 {
				 	if (result.UserLevel != "")
				 	{
				 		initUserLevel(result.UserLevel);
				 	}
				 	else
				 	{
					 	$('#txtLevel').combobox('loadData', {});
					 	$('#txtLevel').combobox('setValue', "");
				 	}
				 }
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
    tmpPassword = base64encode(tmpPassword);
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
			"p3":userLocId,
			"p4":"",
			"p5":"inpatient",
			"p6":episodeId
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

function initUserLevel(userlevel)
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserLevel",
			"Method":"GetUserLevelRangeJson",
			"p1":userlevel
		},
		success: function(d) {
			if(d != "") setLevelRange(eval("["+d+"]"),userlevel);
			else isEnableSelectUserLevel="N";
		},
		error : function(d) { 
			alert("initUserLevel error");
		}
	});
}

function setLevelRange(data,userlevel)
{
	$("#txtLevel").combobox({
		valueField:'LevelCode',                        
		textField:'LevelDesc',
		width:204,
		height:22,
		panelHeight:120,
		data:data,
		onSelect:function(record)
		{
			if ($("#hiddenUserInfo").val() != "")
			{
				 var result = eval("("+$("#hiddenUserInfo").val()+")");
				 result.UserLevel = $('#txtLevel').combobox('getValue');
				 result.LevelDesc = $("#txtLevel").combobox('getText');
				 $("#hiddenUserInfo").val(JSON.stringify(result));
			}
		},
	    onLoadSuccess:function(d){
	    	$('#txtLevel').combobox('select',userlevel);
		}
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
	window.opener=null;
	window.open('','_self');
	window.close();	
}