$(function() {

});

function saveActionLog(UsrID, UsrLoc, Action, EMRTemplate) {
    $.ajax({
        type: 'POST',
        url: '../EMRservice.Ajax.ActionLog.cls',
        async: true,
        cache: false,
        data: {
            func: 'saveActionLog',
            UsrID: UsrID,
            UsrLoc: UsrLoc,
            Action: Action,
            EMRTemplate: EMRTemplate
        }
    });
}

function AddActionLog(UserID,UserLocID,Action,Content)
{
	var ip = getIpAddress();
    $.ajax({
        type: 'POST',
        url: '../EMRservice.Ajax.ActionLog.cls',
        async: true,
        cache: false,
        data: {
            func: 'AddActionLog',
            UserID: UserID,
            UserLocID: UserLocID,
            Action: Action,
            Content: Content,
            IP:ip
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) { 
            alert(textStatus); 
        }, 
        success: function (data) { 
        	if (data != "1")
        	{
	        	alert("日志添加失败");
	        }
        }   
    });	
}

//获取客户端IP地址
function getIpAddress()
{
	try
	{
		var locator = new ActiveXObject ("WbemScripting.SWbemLocator");
		var service = locator.ConnectServer(".");
		var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
		var e = new Enumerator (properties);
		{
		    var p = e.item();
		    var ip = p.IPAddress(0);
		    return ip
		}
	}
	catch(err)
	{
		return "";
	}
}