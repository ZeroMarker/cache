///Desc:病历编辑加锁
function lock(instanceId)
{
    var result = true;
    if (sysOption.isLock != "Y") return result;
    
    //隐藏锁信息
    $("#lock").hide();
    
    jQuery.ajax({
        type: "Post",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "Class": "EMRservice.BL.BLLockOp",
            "Method":"Lock",
            "OutputType":"String",
            "p1": patInfo.UserID,
            "p2": getComputerName(),
            "p3": getIpAddress(),
            "p4": patInfo.EpisodeID,
            "p5": instanceId,
            "p6": patInfo.SessionID,
            "p7": patInfo.UserLocID
        },
        success: function(d) {
            var lockinfo = d.split("^"); 
            var message = "";
            if ((lockinfo[0] == "locked")||(lockinfo[0] == "0")) {
                //已经有锁
                if (lockinfo[0] == "0") {
                    $.messager.alert("简单提示", "加锁失败！", "error");
                } else {
                    message = lockinfo[1];
                    envVar.lockedID = lockinfo[2];
                    iEmrPlugin.SET_READONLY({
                        ReadOnly: true
                    });
                    result = false;
                    //加锁后清除标记，不需要提示是否保存
                    setSysMenuDoingSth("");
                    setDoingSthSureCallback(false);
                }
            } else {
                envVar.lockedIns = instanceId;
                envVar.lockedID = lockinfo[1];
                //加锁审计
                hisLog.lock(envVar.lockedID,envVar.lockedIns);
            }
            //发送锁消息
            setLockMessage(message);
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
                "Class": "EMRservice.BL.BLLockOp",
                "Method":"UnLock",
                "OutputType":"String",
                "p1": lockId
              },
        success: function(d) {
            result = d;
            if (d != "1") {
                $.messager.alert("简单提示", "解锁失败！", "error");
            } else {
                unlockSetReadonly();
                envVar.lockedID = "";
                envVar.lockedIns = "";
                
                //解锁后文档进入编辑状态，给平台发消息
		    	setSysMenuDoingSth(emrTrans('病历正在编辑，是否保存？'));
            	//设置保存的回调函数供平台调用
		    	setDoingSthSureCallback(true);
            }
            //解锁审计
            hisLog.unlock(lockId);
        },
        error : function(d) { alert(" error");}
    });
    
    return result;
}