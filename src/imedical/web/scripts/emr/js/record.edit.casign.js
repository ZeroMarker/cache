function publicInit()
{
	//record.edit.casign.js
	var loginInfo = '';
	var topWin = window.parent;
	//var loginResult = topWin.dhcsys_getcacert();
	var loginResult = window.parent.parent.parent.dhcsys_getcacert();
	if (!loginResult.IsSucc)
	{
		alert("登录失败");
		return loginInfo;
	}
	
	var key = loginResult.ContainerName;
    var cert = '';
    var UserSignedData = '';  
    try {
		 cert = topWin.GetSignCert(key);
         UserSignedData  =topWin.SignedData(window.Parent.strServerRan, key);
    } catch (err) {}

    var UsrCertCode = topWin.GetUniqueID(cert);
    var certificateNo = topWin.GetCertNo(key);

    $.ajax({
        type: 'post',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
        		"OutputType":"String",
				"Class":"EMRservice.BL.BLEMRSign",
				"Method":"CALogin",
				"p1":window.Parent.strServerRan,
				"p2":UsrCertCode,
            	"p3":UserSignedData,
            	"p4":userId,
            	"p5":certificateNo,
            	"p6":cert,
            	"p7":userLocId,
            	"p8":"inpatient"
        },
        success: function(ret) 
        {
            if (ret && ret.Err) 
            {
                alert(ret.Err);
            } 
            else
            {
	            loginInfo = ret;
	        }
        },
        error: function(ret) {}
    });
    
    var userInfo = JSON.stringify(loginInfo);
    
    return '{"action":"sign","userInfo":'+userInfo+'}';
}