$(function(){
	
	$('#keys').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		panelHeight: 'auto',
		onSelect:function() {
            //if (opts.topwin.strKey == "") return;
			var key = $('#keys').combobox('getValue');
			if (typeof opts.topwin.SOF_IsLogin != "undefined"  )
			{
				var isLogin  = opts.topwin.SOF_IsLogin(key);
				if (isLogin)
				{
					$("#trPassword").css('display','none');
				}
				else
				{
					$("#trPassword").css('display','block');
				}
			}
			if (isEnableSelectUserLevel == "Y")
			{
				//ͨ��CA�ӿڻ�ȡ��ǰkey��Ψһ����
				var certB64 = opts.topwin.GetSignCert(key);
				var UsrCertCode = opts.topwin.GetUniqueID(certB64);
				//ͨ��key��Ψһ�����ȡ����UserID
				var UsrIdByKey = GetUsrIdByKey(UsrCertCode);
				var userlevel = getUserLevel(UsrIdByKey);
				if (userlevel == "")
				{
					alert("Ϊ��ȡ����ǰ֤���û�����,�޷���ʼ������������!");
					return;
				}
				initUserLevel(userlevel);
			}
		},
        onLoadSuccess:function() {
            //if (opts.topwin.strKey == "") return;
			var key = $('#keys').combobox('getValue');
			if (typeof opts.topwin.SOF_IsLogin != "undefined"  )
			{
				var isLogin  = opts.topwin.SOF_IsLogin(key);
				if (isLogin)
				{
					$("#trPassword").css('display','none');
				}
				else
				{
					$("#trPassword").css('display','block');
				}
			}
			if (isEnableSelectUserLevel == "Y")
			{
				//ͨ��CA�ӿڻ�ȡ��ǰkey��Ψһ����
				var certB64 = opts.topwin.GetSignCert(key);
				var UsrCertCode = opts.topwin.GetUniqueID(certB64);
				//ͨ��key��Ψһ�����ȡ����UserID
				var UsrIdByKey = GetUsrIdByKey(UsrCertCode);
				var userlevel = getUserLevel(UsrIdByKey);
				if (userlevel == "")
				{
					alert("Ϊ��ȡ����ǰ֤���û�����,�޷���ʼ������������!");
					return;
				}
				initUserLevel(userlevel);
			}
		}
	});
	
	if (isEnableSelectUserLevel == "Y") {
		$('#trLevel').show();
		$("#txtLevel").combobox({
			valueField: 'LevelCode',
			textField: 'LevelDesc',
			editable: false,
			panelHeight: 'auto'
		});
	}
	init();
	
	/*if (openFlag == "0"){
	    checkSure();
	    return;
	}*/
	
	document.getElementById("password").focus();
	
	document.onkeydown = function() {
		var pwd = document.getElementById("password");
		var pwdNull = "Y"
		if ((pwd.value!="")&&(typeof(pwd.value)!="undefined")) {
			pwdNull = "N"
		}
		if ((pwdNull=="N")&&(13==event.keyCode)) {
			document.getElementById("checkSure").focus();
		}
	}
	///��ʼǩ��
	$("#checkSure").click(function()
	{ 
		checkSure();
	})
	
	///ȡ��ǩ��
	$("#checkCancel").click(function()
	{
		closeWindow(); 
	});
	
		//����ǩ��
	$("#revokeCheck").click(function(){
		var userInfo = login();
		if (userInfo == "")
		{ 
			alert('�û������������');
			return;
		}
		userInfo = getuserInfo(userInfo);
		window.returnValue = '{"action":"revoke","userInfo":'+userInfo+'}';
		closeWindow();
	});	
});
  
///��ʼ��ǩ����Ϣ   
function init() 
{
	$('#password').val('');
	if (opts.canRevokCheck == 1) 
	{
		$("#revokeCheck").css('display','block');
	}
	else
	{
		$("#revokeCheck").css('display','none');
	}
	$("#signCell")[0].innerText = opts.cellName;
	
    if (!CASessionDataInit()) 
    {
        return false;
    }
  	if (!GetList_pnp()) 
  	{
		alert('δ��⵽֤�飡');
        return false;
    } 
}

//ȷ���û�ǩ����Ϣ
function checkSure()
{
    var userInfo = login(); 
	if ((userInfo != "")&&(userInfo != '""'))
	{
		userInfo = getuserInfo(userInfo);
		window.returnValue = '{"action":"sign","userInfo":'+userInfo+'}';
		closeWindow(); 
	}
	else
	{
		alert("��½ʧ��");
	}	
}

///��½��֤
function login()
{
   var loginInfo = "";
   var key = $('#keys').combobox('getValue');
   var pwd = $('#password').val();
   if ('' == key) return loginInfo;
   var objForm = document.getElementById('loginForm');
   if ('' == key || !opts.topwin.Login(objForm, key, pwd)) return loginInfo;
   loginInfo = ajaxLogin(key); 
   var tmpInfo = eval("("+loginInfo+")")
   if (loginInfo != '' && tmpInfo.UserID == userId) 
   {
	   SetKeyInSession(key);
   }
   opts.topwin.strKey = key;
   return loginInfo;
}  

//��ʼ��CA�����Ϣ���ڵ�¼�򵯳�ǰ�����󷵻�false����ȷ����true
function CASessionDataInit() {
    var result = false;
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
        		"OutputType":"String",
				"Class":"EMRservice.BL.BLEMRSign",
				"Method":"CASessionDataInit"
        },
        success: function(ret) {
            if (ret && ret.Err) 
            {
                alert('����ǩ����ʼ������'+ ret.Err);
            } 
            else 
            {
                opts.topwin.strServerRan = ret.ServerRan;
                opts.topwin.strServerSignedData = ret.ServerSignedData;
                opts.topwin.strServerCert = ret.ServerCert;
                opts.topwin.strKey = ret.Key;
                result = true;
            }
        },
        error: function(ret) { alert('CA������ʼ���쳣��'+ ret); }
    });
    return result;
} 

// ��ȡ�����֤���б�
function GetList_pnp()
{
    var lst = opts.topwin.GetUserList();
    var arrUsers = lst.split('&&&');
    if ('' == lst || 0 == arrUsers.length) return false;
    var data = new Array();
    for (var i = 0; i < arrUsers.length; i++) 
    {
        var user = arrUsers[i];
        if (user != "") {
            var keyName = user.split('||')[0];
            var uniqueID = user.split('||')[1];
            //ͨ��CA�ӿڻ�ȡ��ǰkey��Ψһ����
            var certB64 = opts.topwin.GetSignCert(uniqueID);
            var UsrCertCode = opts.topwin.GetUniqueID(certB64);
            //ͨ��key��Ψһ�����ȡ����UserID
            var UsrIdByKey = GetUsrIdByKey(UsrCertCode);            

            if (data == '') 
            {
                data.push({"id":uniqueID,"text":keyName,"selected":true});
            }
            else if (userId == UsrIdByKey)
            {
	            data.push({"id":uniqueID,"text":keyName,"selected":true});
	        }            
            else 
            {
                data.push({"id":uniqueID,"text":keyName});
            }
        }
    }
    $('#keys').combobox('loadData', data);
    return true;
} 

//��¼�������û�������ǩ��ͼƬ
function ajaxLogin(key) {
    var loginInfo = '';
    var cert = '';
    var UserSignedData = '';  
    try {
        if (opts.topwin.strUserCert == "") 
        {
	        cert = opts.topwin.GetSignCert(key);
            UserSignedData  = opts.topwin.SignedData(opts.topwin.strServerRan, key);
        }
        else
        {
	        UserSignedData = opts.topwin.strUserSignedData;
	        cert = opts.topwin.strUserCert;
	    } 
    } catch (err) {}

    var UsrCertCode = opts.topwin.GetUniqueID(cert);
    var certificateNo = opts.topwin.GetCertNo(key);
	
	if (CAVersion == "2")
	{
		var signType = opts.topwin.ca_key.SignType;
		var venderCode  = opts.topwin.ca_key.VenderCode;
	}
	else
	{
		var signType = "";
		var venderCode  = "";
	}

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
				"pa":opts.topwin.strServerRan,
				"pb":UsrCertCode,
            	"pc":UserSignedData,
            	"pd":certificateNo,
            	"pe":cert,
            	"pf":userLocId,
            	"pg":"inpatient",
            	"ph":episodeId,
            	"pi":signType,
            	"pj":venderCode
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
    return JSON.stringify(loginInfo);
}

//����key����Ϣ���´ο��Բ��������룬�޷���ֵ
function SetKeyInSession(key) {
    $.ajax({
        type: 'POST',
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        cache: false,
        data: {
    		"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRSign",
			"Method":"SetKeyInSession",
			"p1":key
        }
    });
}

//��ȡ��ǰUsrCertCode������UserID
function GetUsrIdByKey(UsrCertCode) {
	var result = "";
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        cache: false,
        data: {
    		"OutputType":"String",
			"Class":"CA.UsrSignatureInfo",
			"Method":"GetUsrIdByKey",
			"p1":UsrCertCode
        },
        success: function(ret) 
        {
  			result = ret;
        },
        error: function(ret) {}
    });
    return result;
}

///����UserID��ȡ�û�����
function getUserLevel(usrIdByKey)
{
	var userlevel = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSignRole",
			"Method":"GetUserLevel",
			"p1":usrIdByKey,
			"p2":episodeId
		},
		success: function(d) {
			if(d != "") userlevel = d.split("^")[0];
		},
		error : function(d) { 
			alert("getUserLevel error");
		}
	});
	return userlevel;
}
///��ʼ������������
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
			if(d != "") {
				$('#txtLevel').combobox('loadData', eval("["+d+"]"));
				$('#txtLevel').combobox('select',userlevel);
			}
		},
		error : function(d) { 
			alert("initUserLevel error");
		}
	});
}

function getuserInfo(userInfo)
{
	if (isEnableSelectUserLevel == "Y")
	{
		 var result = eval("("+userInfo+")");
		 result.UserLevel = $('#txtLevel').combobox('getValue');
		 result.LevelDesc = $("#txtLevel").combobox('getText');
		 userInfo = JSON.stringify(result);
	}
	return userInfo;
}

//�رմ���
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}