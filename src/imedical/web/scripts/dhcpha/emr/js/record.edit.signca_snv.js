$(function(){
	
	$('#keys').combobox({
		valueField: 'id',
		textField: 'text',
		editable: false,
		panelHeight: 'auto'
	});
	init();
	
	if (openFlag == "0"){
	    checkSure();
	    return;
	}
	
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
    var key = $('#keys').combobox('getValue');
    if (opts.wid.parent.strKey && opts.wid.parent.strKey != "" && opts.wid.parent.strKey == key) 
    {
        var userInfo = ajaxLogin(opts.wid.parent.strKey);
        if (userInfo != "")
        {
	        window.returnValue = '{"action":"sign","userInfo":'+userInfo+'}';
	       	closeWindow(); 
	    }
    }
}

//ȷ���û�ǩ����Ϣ
function checkSure()
{
   var userInfo = login(); 
	if (userInfo != "")
	{
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
   if ('' == key || "" == pwd) return loginInfo;
   var objForm = document.getElementById('loginForm');
   if ('' == key || '' == pwd || !opts.wid.parent.Login(objForm, key, pwd)) return loginInfo;
   loginInfo = ajaxLogin(key); 
   if (loginInfo != '' && json.parse(loginInfo).UserID == userId) 
   {
	   SetKeyInSession(key);
	   opts.wid.parent.strKey = key;
   }
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
                opts.wid.parent.strServerRan = ret.ServerRan;
                opts.wid.parent.strServerSignedData = ret.ServerSignedData;
                opts.wid.parent.strServerCert = ret.ServerCert;
                opts.wid.parent.strKey = ret.Key;
                result = true;
            }
        },
        error: function(ret) {}
    });
    return result;
} 

// ��ȡ�����֤���б�
function GetList_pnp()
{
    var lst = opts.wid.parent.GetUserList();
    var arrUsers = lst.split('&&&');
    if ('' == lst || 0 == arrUsers.length) return false;
    var data = new Array();
    for (var i = 0; i < arrUsers.length; i++) 
    {
        var user = arrUsers[i];
        if (user != "") {
            var keyName = user.split('||')[0];
            var uniqueID = user.split('||')[1];
            if (data == '') 
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
        if (opts.wid.parent.strUserCert == "") 
        {
	        cert = opts.wid.parent.GetSignCert(key);
            UserSignedData  = opts.wid.parent.SignedData(opts.wid.parent.strServerRan, key);
        }
        else
        {
	        UserSignedData = opts.wid.parent.strUserSignedData;
	        cert = opts.wid.parent.strUserCert;
	    } 
    } catch (err) {}

    var UsrCertCode = opts.wid.parent.GetUniqueID(cert);
    var certificateNo = opts.wid.parent.GetCertNo(key);

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
				"p1":opts.wid.parent.strServerRan,
				"p2":UsrCertCode,
            	"p3":UserSignedData,
            	"p4":certificateNo,
            	"p5":cert,
            	"p6":userLocId,
            	"p7":"inpatient"
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

//�رմ���
function closeWindow()
{
	window.opener=null;
	window.open('','_self');
	window.close();	
}