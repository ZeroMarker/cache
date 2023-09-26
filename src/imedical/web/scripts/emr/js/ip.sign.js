
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
	$('#txtUser').keyup(function(event){
	  if (event.keyCode ==13){
		 var display = $('#divPwd').css('display');
		 if (display == 'none')
		 {
			 checkSure();
	     }
	     else
	     {
			$('#txtPwd').focus();
	     }
	  }
	}); 	
 	/*//���������
 	$('#txtPwd').blur(function() {
	 	getIdentityVerifcation();
 	});*/
 	$('#txtPwd').keyup(function(event){
	  if(event.keyCode ==13){
		checkSure();
	  }
	});	
 	
 	//��ʼǩ��
	$("#checkSure").click(function(){
		checkSure();
	});
	
	//ȡ����ر�ǩ��
	$("#checkCancel").click(function(){		
		window.returnValue = "";
		closeWindow();
	});
	
	//����ǩ��
	$("#revokeCheck").click(function(){
		var userInfo = $("#hiddenUserInfo").val();
		if (userInfo == "")
		{ 
			$.messager.alert("��ʾ","�û������������");
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
		$("#revokeCheck").show();
	}
	else
	{
		$("#revokeCheck").hide();
	}
	//���ӵ�ǰǩ����Ԫ��ʾ�ж� ��Ϊ���֤�����ҳ��Ҳʹ�������ҳ�棬�����Ǹ�ҳ��û��ǩ����Ԫ��
	//��opts.cellNameΪundefined ������ʾ
	(typeof opts.cellName == "undefined")?$("#divSignCell").css("visibility","hidden"):$("#signCell")[0].innerText = opts.cellName;
 	$("#divUserName")[0].innerText = userName;
 	$("#txtUser").val(userCode)
 	$("#divPwd").css('display','none');
	txtUserChange();
	getIdentityVerifcation(); 
	$('#checkSure').focus();
}

function checkSure()
{
	if("false"==getIdentityVerifcation()) return
	var userInfo = $("#hiddenUserInfo").val();
	if (userInfo == "")
	{ 
		$.messager.alert("��ʾ","�û������������");
		return;
	}
	if (isEnableSelectUserLevel == "Y")
	{
		 var result = eval("("+$("#hiddenUserInfo").val()+")");
		 result.UserLevel = $('#txtLevel').combobox('getValue');
		 result.LevelDesc = $("#txtLevel").combobox('getText');
		 userInfo = JSON.stringify(result);
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
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":txtUserCode,
			"p2":'',
			"p3":userLocId,
			"p4":"",
			"p5":"inpatient",
			"p6":episodeId,
			"p7":hospitalID
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
 
 //ǩ�������֤(��̨������֤)
function getIdentityVerifcation()
{
	var result="true";
	document.getElementById("checkSure").focus();
	var tmpUserCode = $("#txtUser").val();
	var tmpPassword = $("#txtPwd").val();
	if (tmpUserCode != userCode)
	{
		if (tmpPassword == "") 
		{
			result="false";
			$.messager.alert("��ʾ","����������"); 
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
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"GetUserInfo",
			"p1":tmpUserCode,
			"p2":tmpPassword,
			"p3":userLocId,
			"p4":"",
			"p5":"inpatient",
			"p6":episodeId,
			"p7":hospitalID
		},
		success: function(d) {
			 if (d == "")
			 {
				 result="false";
				 $.messager.alert("��ʾ","�û����������"); 
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
	return result
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
		width:275,
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
	    	$('#txtLevel').combobox('enable');
		}
	});
}

//���ǩ�������ı���
function clearCheckWindow()
{
	$("#txtPwd").val("");
	$("#txtLevel").val("");
	$("#hiddenUserInfo").val("");
}
//�رմ���
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