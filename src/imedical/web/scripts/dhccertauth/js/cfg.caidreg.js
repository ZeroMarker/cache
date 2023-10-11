$(function(){
	
	$('#SignTypeCode').val(caInfo.SignTypeCode);
	$('#VenderCode').val(caInfo.VenderCode);
	
	$('#UserID').val(toAddUserInfo.UserID);
	$('#UserCode').val(toAddUserInfo.UserCode);
	$('#UserName').val(toAddUserInfo.UserName);
	//$('#UserCertCode').val(toAddUserInfo.UserCode);
	
	
    $('#btnCAIDReg').bind('click',function(){
        var userID = $("#UserID").val();
		var userCode = $("#UserCode").val();
        if((userCode||"") == ""){
            $.messager.alert("提示","HIS用户工号不能为空");
            return;
        }
        
        var userCertCode = $("#UserCertCode").val();
		if ((userCertCode||"") == "") {
        	$.messager.alert("提示","CA用户唯一标识不能为空");
        	return;
        }
		
		var signTypeCode = $("#SignTypeCode").val();
		if ((signTypeCode||"") == "") {
        	$.messager.alert("提示","签名类型不能为空");
        	return;
        }
		
		var venderCode = $("#VenderCode").val();
		if ((venderCode||"") == "") {
        	$.messager.alert("提示","CA厂商标识不能为空");
        	return;
        }
        
		var certName = $("#CertName").val();
		var caNote = $("#CANote").val();
		
		var data = ajaxDATA('String', 'CA.BL.Config', 'AddCAID', userCode, userCertCode, signTypeCode, venderCode, certName, caNote);
	    ajaxPOSTSyncCfg(data, function (ret) {
	        var d = $.parseJSON(ret);
	        $.messager.alert("提示",d.retMsg);
	    }, function (ret) {
	        $.messager.alert("提示","AddCAID error:" + ret);
	    });
        
    });
    
	
	$('#btnCAIDQuery').bind('click',function(){
		var userCode = $("#UserCode").val();
        var rtn = iGetData("QueryUserInfo","","","",userCode);
		if (rtn.retCode == "0") {
			if (rtn.userCertCode == "")
			{
				$.messager.alert("提示","获取CA用户标识为空");
				return;	
			}
			if (rtn.userName == "")
			{
				$.messager.alert("提示","获取CA用户姓名为空");
				return;	
			}
			$('#UserCertCode').val(rtn.userCertCode);
			$('#CertName').val(rtn.userName);
		} else {
			$.messager.alert("提示",rtn.retMsg);
			return;
		}
	});
});


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