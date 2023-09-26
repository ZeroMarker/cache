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
		       	"p1": userID,
		       	"p2": userCode,
		       	"p3": getIpAddress(),
		      	"p4": actionType,
		      	"p5": episodeID,
		       	"p6": docId,
		       	"p7": instanceId,
		       	"p8": templateId,
		       	"p9": "",
		       	"p10": getComputerName()
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
	var result = "0"
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
