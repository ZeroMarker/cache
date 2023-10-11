$(function(){
	if (isEnableRevokeComplete == "N")
	{
		document.getElementById("revoke").style.display="none";
	}
	initList();
});


function initList()
{
	jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: true,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLAdmRecordStatusLog",
            "Method":"GetLogData",
            "p1":episodeID
        },
        success: function(d) 
        {
            if (d != "")
            {
	            setList(eval("["+d+"]")[0]);
            }
            else
            {
	            setDefaultData();
            }
        },
        error : function(d) { 
            alert("GetLogData error");
        }
    });		
}

//加载目录
function setList(data)
{
    $('#logTree').empty();
    $('#logTree').addClass('log-item');
    
    if (data.length > 0)
    {
	    var statusDesc = statusFormat(data[data.length-1]["Status"]);
    }
    else
    {
	    var statusDesc = "未提交";
    }
    var currentstatus = '<div class="currentstatus">当前状态：'+statusDesc+'</div>';
    $('#logTree').append(currentstatus);
    
    $('#logTree').append('<div class="head"></div>');
    for (var i=0;i<data.length;i++)
    {
        $('#logTree').append(setlistdata(data[i]));
    }
	$('#logTree').on('mouseenter', 'li', function() {
        $(this).find('#dot').addClass("hoverdot");
    });
    $('#logTree').on('mouseleave', 'li', function() {
       $(this).find('#dot').removeClass("hoverdot");
    });    
}

///加载列表样式
function setlistdata(data)
{
    var li = $('<li></li>');
    $(li).attr({"id":data.id,"text":data.Action});
    $(li).append('<div id="dot" class="left"></div>')
    var right = $('<a href="#" class="right"></a>');
    var first = $('<div class="first"></div>');
    var text = data.Action;
    if (data.Remark != "")
    {
	    text = text + "（" + data.Remark + "）";
    }
    
    $(first).append('<div class="title">'+text+'</div>');
    var fleft = $('<div class="fleft"></div>');

    $(first).append(fleft);
    $(right).append(first);
    var second = '<div class="second"><span class="data">'+data.OperateDate+'</span><span class="data">'+data.OperateTime+'</span><span class="green">'+data.UserName+'</span><span>'+data.IPAddress+'</span><span>'+data.ProductSource+'</span></div>';
    $(right).append(second);
    $(li).append(right);
    return li;
}
 
function statusFormat(val){
    var retStr = "";
    if (val == '1') {
        retStr = emrTrans('已提交');
    }else if (val == '-1') {
        retStr = emrTrans('已退回');
    }else if (val == '0') {
        retStr = emrTrans('已撤销');
    }else if (val == '-2') {
        retStr = emrTrans('已召回');
    }
    return retStr;
}
 
function confirm()
{
 	var status = getAdmRecordStatus();
 	if (status == "1")
 	{
	 	$.messager.alert("提示", "患者病历已提交，无需重复提交！",'info');
		return;
 	}
 	window.returnValue = "confirm";
 	closeWindow();
}
 
function revoke()
{
	var status = getAdmRecordStatus();
 	if (status != "1")
 	{
	 	$.messager.alert("提示", "患者病历还未提交，无需撤销提交！",'info');
		return;
 	}
	
	var tipMsg = "是否确认撤销提交病历?";
	$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		window.returnValue = "revoke";
		closeWindow();
	});
	
}

function getAdmRecordStatus()
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function(d) {
				if (d != "") result = d;
			},
			error : function(d) { alert("getAdmRecordStatus error");}
		});	
	return result;	
}

function setDefaultData()
{
	var currentstatus = '<img  src="../scripts/emr/image/icon/nocommit.png" style="height:250px;position:absolute;left:35%;"  alt="此患者没有提交病历" />';
    $('#logTree').append(currentstatus);
}

//关闭窗口
function closeWindow()
{
	parent.closeDialog("ConfirmDialog");
}