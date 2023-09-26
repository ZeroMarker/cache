///Desc:病历编辑加锁
function lock(actionType,categoryId,docId,instanceId,templateId)
{
	var result = "";
	if (enableLock != "Y") return result;
	
	//隐藏锁信息
	$("#lock").hide();
	
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
				"Class": "EMRservice.BL.BLLock",
				"Method":"Lock",
				"OutputType":"String",
		       	"pa": userID,
		       	"pb": getComputerName(),
		       	"pc": userCode,
		      	"pd": getIpAddress(),
		      	"pe": actionType,
		       	"pf": episodeID,
		       	"pg": docId,
		       	"ph": instanceId,
		       	"pi": templateId,
		       	"pj": sessionID,
				"pk": userLocID
		},
		success: function(d) {
			var openMode = "";
			var lockId = "";
		    var lockinfo = d.split("^"); 
		    var message = "";
		    if ((lockinfo[0] == "locked")||(lockinfo[0] == "0"))
		    {
			    openMode = "ReadOnly";
			    if (lockinfo[0] == "0")
			    {
				    message = "添加病历锁失败";
				}
				else
				{
					message = lockinfo[1];
				}
			}
			else
			{
				lockId = lockinfo[1];
				
				//加锁审计
				setLockToLog(lockId,docId,"EMR.UnLock.Lock");
			}
			result = {"openMode":openMode,"LockID":lockId};
			
			//发送锁消息
			setlockdocument(message);
		},
		error : function(d) { alert(" error");}
	});	
	
	return result;
}

///Desc:病历编辑解锁
function unLock(lockId)
{
	var result = "0";
	if ((lockId == "")||(lockId == undefined)) return result;
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
				"Class": "EMRservice.BL.BLLock",
				"Method":"UnLock",
				"OutputType":"String",
		        "p1": lockId
		      },
		success: function(d) {
			result = d;
			//解锁审计
			setLockToLog(lockId,param.emrDocId,"EMR.UnLock.UnLock");
		},
		error : function(d) { alert(" error");}
	});
	return result;	
}

function unLockAllInstance(userID,episodeID,docId)
{
	if ((userID == "")||(episodeID == "")||(docId == "")) return result;
	var method = "UnLockAllInstance";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
				"Class": "EMRservice.BL.BLLock",
				"Method":method,
				"OutputType":"String",
		        "p1": userID,
		        "p2": episodeID,
		        "p3": docId,
		        "p4": getIpAddress()
		      },
		success: function(d) {
			var result = d;
			var strs = new Array(); //定义一数组
			strs = result.split("^"); //字符分割
			for (i=0;i<strs.length;i++ )
			{
				//解锁审计
				setLockToLog(strs[i],param.emrDocId,"EMR.UnLock.UnLock");
					
			} 
		},
		error : function(d) { alert(" error");}
	});
}