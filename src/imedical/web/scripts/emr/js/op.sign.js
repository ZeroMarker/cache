$(function(){
    
    init();
    
    //�����û�
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

    //���������
    $('#txtPwd').blur(function() {
        getIdentityVerifcation();
    });
    
    $('#txtPwd').keyup(function(event){
      if(event.keyCode ==13){
        $('#checkSure').focus();
      }
    });
    
    //��ʼǩ��
    $("#checkSure").click(function(){
        checkSure();
    });
    
    //ȡ����ر�ǩ��
    $("#checkCancel").click(function(){
        closeWindow();
        window.returnValue = "";
    });
});

function init()
{
    $("#signCell")[0].innerText = opts.cellName;
    $("#divUserName")[0].innerText = userName;
    $("#txtUser").val(userCode)
    $("#divPwd").css('display','none');
    txtUserChange();
    getIdentityVerifcation(); 
    $('#checkSure').focus();
}

function checkSure()
{
    var userInfo = $("#hiddenUserInfo").val();
    if (userInfo == "")
    { 
        alert('�û������������');
        return;
    }
    window.returnValue = userInfo;
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
            "p3":userLocId
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
             }
        },
        error: function(d) {alert("error");}
    });	
}
 
 //ǩ�������֤(��̨������֤)
function getIdentityVerifcation()
{
    //document.getElementById("checkSure").focus();
    $('#checkSure').focus();
    var tmpUserCode = $("#txtUser").val();
    var tmpPassword = $("#txtPwd").val();
    if (tmpUserCode != userCode)
    {
        if (tmpPassword == "") 
        {
            alert('����������'); 
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
            "p3":userLocId
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