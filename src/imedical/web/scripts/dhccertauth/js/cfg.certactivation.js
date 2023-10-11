$(function(){
	if (isUse != "Y") {
		$("#main").hide();
		$("#caTip").show();
		document.getElementById("caTip").innerText = "因激活证书(扫码下载CA证书)非HISUI业务，此页面已停用，请联系CA厂商，提供相应下载证书的途径(短信验证等)";			
		return;
	}

	$('#tbxUserCode').val(logonInfo.UserCode);
	$('#tbxUserName').val(logonInfo.UserName);
	
    $('#btnVerify').bind('click',function(){
        var identityID = $("#IdentityID").val();
        if(identityID===null||identityID===''){
            $.messager.alert("提示","请先输入当前登录用户身份证号");
            return;
        }
        
        var rtn = iGetData("QueryUserInfo","","SF",identityID,logonInfo.UserCode);
		if (rtn.retCode == "0") {
			if ((rtn.userName != logonInfo.UserName)||(rtn.userCode != logonInfo.UserCode))
			{
				$.messager.alert("提示","通过身份证号获取到用户信息与当前登录用户信息不一致:当前登录用户"+logonInfo.UserName+"^"+logonInfo.UserCode+"获取用户信息:"+rtn.userName+"^"+rtn.userCode);
				return;	
			}
		} else {
			$.messager.alert("提示",rtn.retMsg);
			return;
		}
        
		var rtn = iGetData("GetActivationCode",rtn.userCertCode,"SF",identityID,logonInfo.UserName);
		if (rtn.retCode == "0") {
			qrCode = rtn.qrCode;
			isImage = rtn.isImage;
			imageCode = rtn.imageCode || "";
			
			$("#mgrimage").show();   //显示
			showQRCode();
			$("#divqrcodegen").hide();
			$("#divqrcodeimg").show();
		} else {
			$("#mgrimage").hide();  //隐藏
			$.messager.alert("提示",rtn.retMsg);
			return;
		}
        
    });
});

function showQRCode() {
	if (isImage == "1") {
		var qrcodeimg = document.getElementById("qrcodeimg");
		if (imageCode == "") {
			var imgdata = "data:image/jpeg;base64," + qrCode;
			qrcodeimg.src = imgdata;
		} else {
			qrcodeimg.src = imageCode;
			//$("#qrcodeimg").attr("src",imageCode);
		}
	} else {
		if (qrcodeMaker == "") {
			//qrcodeMaker = new QRCode(document.getElementById("qrcodeimg"),{width:150,height:150,colorDark:"#000000",colorLight : "#ffffff"});
			qrcodeMaker = new QRCode(document.getElementById("qrcodeimg"),{width:200,height:200,correctLevel:QRCode.CorrectLevel.L});
		} 
		qrcodeMaker.clear()
		qrcodeMaker.makeCode(qrCode);	
	}
}
	
function iGetData(Func,P1,P2,P3,P4,P5,P6,P7,P8,P9) {
	
	var result = "";
	
	var para = {
  		CAFunc: Func,
	  	CAVenderCode:caInfo.VenderCode,
	  	CASignType:caInfo.SignTypeCode,
  		P1:P1||"",
  		P2:P2||"",
  		P3:P3||"",
  		P4:P4||"",
  		P5:P5||"",
  		P6:P6||"",
  		P7:P7||"",
  		P8:P8||"",
  		P9:P9||""
	};
	
	$.ajax({
		url: "../CA.Ajax.DS.cls",
		type: "POST",
		dataType: "JSON",
		async: false,
		data: para,
		success: function(ret) {
        	if (ret && ret.retCode == "0") {
            	result = ret;
        	} else {
            	$.messager.alert("提示",ret.retMsg);
        	}
        },
    	error: function(err) {
        	$.messager.alert("提示",err.retMsg || err);
    	}
	});
	return result;
}