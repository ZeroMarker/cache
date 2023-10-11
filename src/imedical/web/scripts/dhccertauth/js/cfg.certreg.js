$(function(){
	//查看证书时页面设置只读，隐藏相应按钮
	if (caInfo.UsrSignInfoID != "") {
		$(".textbox").attr("disabled","true");
		$(".hisui-textbox").attr("disabled","true");
		
		$("#btnViewCert").hide();
		$("#btnUsrCertReg").hide();
		InitCertInfo(caInfo.UsrSignInfoID);
		return;
	}

	$('#SignTypeCode').val(caInfo.SignTypeCode);
	$('#VenderCode').val(caInfo.VenderCode);
	$('#tbxUserCode').val(caInfo.UserCode);
	
	if (caInfo.SignTypeCode == "UKEY") {
		InitUKey();
	} else if ((caInfo.SignTypeCode == "PHONE")||(caInfo.SignTypeCode == "FACE")) {
        ///人脸证书关联与手机证书关联用同一逻辑
		InitPhone();
	}
	
    $('#btnUsrCertReg').bind('click',function(){
        var userCode = $("#tbxUserCode").val();
        if(userCode===null||userCode===''){
            $.messager.alert("提示","请先输入要绑定的HIS用户工号");
            return;
        }
        
        var ctnrName = "";
        if (caInfo.SignTypeCode == "UKEY") {
	        ctnrName = $HUI.combobox('#cbxCertLst').getValue();
	        if(ctnrName===null||ctnrName===''){
            	$.messager.alert("提示","请先选择需要绑定的证书");
            	return;
        	}
        	var cert = getUsrSignatureInfo(ctnrName);
        } else if ((caInfo.SignTypeCode == "PHONE")||(caInfo.SignTypeCode == "FACE")) {
	        ctnrName = $("#tbxCAID").val();
	        if(ctnrName===null||ctnrName===''){
            	$.messager.alert("提示","请先录入要绑定的CA-ID标识");
            	return;
        	}
        	var cert = getCertInfoByUserCode(ctnrName);
        }
        
        if (cert === "") {
	        $.messager.alert("提示","证书信息不能为空");
        	return;
        }
        
        if ((cert.UsrCertCode||"") == "") {
        	$.messager.alert("提示","CA用户唯一标识不能为空");
        	return;
        }
        if ((cert.certificateNo||"") == "") {
        	$.messager.alert("提示","CA证书唯一标识不能为空");
        	return;
        }
        if ((cert.certificate||"") == "") {
        	$.messager.alert("提示","CA证书不能为空");
        	return;
        }
        
		var certObj = {
			SignTypeCode:caInfo.SignTypeCode,
			VenderCode:caInfo.VenderCode,
			UserCertCode:cert.UsrCertCode,
			CertNo:cert.certificateNo,
			CertSN:cert.CertificateSN,
			CertName:cert.CertName,
			IdentityID:cert.identityID,
			SignCert:cert.certificate,
            UKeyNo:cert.uKeyNo
		};
		var json = JSON.stringify(certObj);
		//var imgBase64 = cert.signImage;
		var imgBase64 = $("#SignImgBase64").val();
		if ((sysInfo.IsLimitImageNull == "1")&&(imgBase64.length < 50)) {
			$.messager.alert("提示","签名图片不能为空");
        	return;			
		}

        if ((sysInfo.IsLimitImageSize == "1")&&(imgBase64.length > (15 * 1024))) {
			$.messager.alert("提示","签名图片超长");
        	return;			
		}
        
		var data = ajaxDATA('String', 'CA.BL.Config', 'BindCert', userCode,json,imgBase64);
	    ajaxPOSTSyncCfg(data, function (ret) {
	        var d = $.parseJSON(ret);
	        $.messager.alert("提示",d.retMsg);
	    }, function (ret) {
	       $.messager.alert("提示","BindCert error:" + ret);
	    });
        
    });
    
    
});


function InitUKey() {
	$('#cbxCertLst').combobox({
		onSelect : function(rec){
			var ctnrName = rec.id;
			var cert = getUsrSignatureInfo(ctnrName);
		
			var newImageBase64 = getConvertedImage(cert.signImage);
			
			$("#UserCertCode").val(cert.UsrCertCode).validatebox("validate");
			$("#CertNo").val(cert.certificateNo).validatebox("validate");
			$("#CertSN").val(cert.CertificateSN).validatebox("validate");
			$("#CertCN").val(cert.CertName).validatebox("validate");
			$("#CtnrNo").val(cert.uKeyNo);
			$("#CtnrSN").val(cert.certificateNo);
			$("#IdentityID").val(cert.identityID);
			$("#SignCert").val(cert.certificate);
			$("#SignImgBase64").val(newImageBase64);
			
			var objImg = document.getElementById("SignImg");
			if (objImg != "") {
				var imgdata = "data:image/jpeg;base64," + newImageBase64;
		  		objImg.src = imgdata;
			}
		}
	});
	
	LoadUKeyCertList();
}

function LoadUKeyCertList() {
	var list = GetUserList();
	list = list || "";
	if (list == "") {
		$('#cbxCertLst').combobox("loadData",[]);
		return "";
	}
	
	var arr = new Array();
	var arrUsers = list.split('&&&');
    for (var i = 0; i < arrUsers.length; i++) {
        var user = arrUsers[i];
        if (user != "") {
            var keyName = user.split('||')[0];
            var uniqueID = user.split('||')[1];
            arr.push({id:uniqueID,text:keyName});
        }
    }
    $('#cbxCertLst').combobox("loadData",arr);
	return "";
}

function InitPhone() {
	$('#tbxCAID').val(caInfo.UserCode);
	$('#btnViewCert').bind('click',function(){
		var ctnrName = $("#tbxCAID").val();
        if(ctnrName===null||ctnrName===''){
            $.messager.alert("提示","请先录入要查看的CA-ID标识");
            return;
        }

		var cert = getCertInfoByUserCode(ctnrName);
		
		if ((typeof(cert) === "undefined")||("" === cert)) return;
			
		var newImageBase64 = getConvertedImage(cert.signImage);
		
		$("#UserCertCode").val(cert.UsrCertCode).validatebox("validate");
		$("#CertNo").val(cert.certificateNo).validatebox("validate");
		$("#CertSN").val(cert.CertificateSN).validatebox("validate");
		$("#CertCN").val(cert.CertName).validatebox("validate");
		$("#CtnrNo").val(cert.uKeyNo);
		$("#CtnrSN").val(cert.certificateNo);
		$("#IdentityID").val(cert.identityID);
		$("#SignCert").val(cert.certificate);
		$("#SignImgBase64").val(newImageBase64);
		
		var objImg = document.getElementById("SignImg");
		if (objImg != "") {
			var imgdata = "data:image/jpeg;base64," + newImageBase64;
	  		objImg.src = imgdata;
		}

	});
}

function getConvertedImage(base64) {
	try {
		if (sysInfo.EnableConvertImage != "1") return base64;
		
		if (base64 == "") return base64;
		
		var flag = sysInfo.ConvertImageFlag || "";
		if (flag === "") return base64;
		var height = sysInfo.ConvertImageHeight || "";
		
		var newBase64 = ca_imageutil.ConvertImage(base64, flag, height);
		return newBase64;
	} catch (ex) {
		$.messager.alert("提示","转换签名图格式错误,请查看IE信任站点ActiveX相关设置");
		return "";
	}
}


function InitCertInfo(UsrSignInfoID) {
	var data = ajaxDATA('String', 'CA.UsrSignatureInfo', 'GetCertInfoByID', UsrSignInfoID);
    ajaxPOST(data, function (ret) {
        if (ret != "")
        {
            var arr = $.parseJSON(ret);
            ShowCertInfo(arr);
        }else
        {
            $.messager.alert("提示","获取证书数据错误!");
        }
    }, function (ret) {
        $.messager.alert("提示","CA.UsrSignatureInfo.GetCertInfoByID Error:" + ret);
    });
}	
	
function ShowCertInfo(data){
	$('#tbxUserCode').val(data["UsrCode"]);
	$('#SignTypeCode').val(data["CASingTypeCode"]);
	$('#VenderCode').val(data["CAVenderCode"]);
	$("#UserCertCode").val(data["UsrCertCode"]);
	$("#CertNo").val(data["CertificateNo"]);
	$("#CertSN").val(data["CertificateSN"]);
	$("#CertCN").val(data["CertName"]);
	$("#CtnrNo").val(data["UKeyNo"]);
	$("#CtnrSN").val(data["CertificateNo"]);
	$("#IdentityID").val(data["IdentityID"]);
	$("#SignCert").val(data["Certificate"]);
	$("#SignImgBase64").val(data["SignImage"]);
	$("#CreateDate").val(data["CreateDate"]);
	$("#CreateTime").val(data["CreateTime"]);
	
	var objImg = document.getElementById("SignImg");
	if (objImg != "") {
		var imgdata = "data:image/jpeg;base64," + data["SignImage"];
  		objImg.src = imgdata;
	}
}

