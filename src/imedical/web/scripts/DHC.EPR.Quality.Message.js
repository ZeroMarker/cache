function InitFrom()
{
	var obj=document.getElementById("btnSend");
	if (obj){obj.onclick=btnSend_onClick;}

	var obj=document.getElementById("btnSendToDoc");
	if (obj){obj.onclick=btnSendToDoc_onClick;}
	
	var obj=document.getElementById("btnCancel");
	if (obj){obj.onclick=btnCancel_onClick;}
	
	var obj=document.getElementById("btnOpenEntryMTree");
	if (obj){obj.onclick=btnOpenEntryMTree_onClick;}

}

function GetSelectedEpisodeIDs() 
{
    var EpisodeIDs = "", IsFirstNode = 1;
    var objTable = window.parent.RPtop.document.getElementById("tDHC_EPR_Quality_JITMonitor");
    for (var i = 1; i < objTable.rows.length; i++) {
        var TSelected = window.parent.RPtop.document.getElementById("TSelectedz" + i).checked;
        var EpisodeID = window.parent.RPtop.document.getElementById("TEpisodeIDz" + i).value;
        if (TSelected) {
            if (IsFirstNode == 1) {
                EpisodeIDs = EpisodeIDs + EpisodeID
                IsFirstNode = 0
            }
            else {
                EpisodeIDs = EpisodeIDs + "|" + EpisodeID
            }
        }
    }
    return EpisodeIDs;
}



function btnSendToDoc_onClick() 
{
    var MessageBody = getElementValue("AMsgBody", null);
    MessageBody = MessageBody.replace(/\r\n/gi, '<br/>')
    if (MessageBody == "") {
        alert(t["MsgBody"]);
        return;
    }

    var EpisodeID = getElementValue("EpisodeID", null);
    var MainDocID = getElementValue("txtMainDocID", null);
    var AttendDocID = getElementValue("txtAttendDocID", null);
	
	if ((EpisodeID == "") || (EpisodeID == null)){
		alert("请选择一个就诊患者");
	}
	else  {
		var CreateUserID = getElementValue("LOGON.USERID", null);
		var Params = escape(MessageBody) + "^" + EpisodeID + "^" + MainDocID + "^" + AttendDocID + "^" + CreateUserID

		var obj = document.getElementById("MethodSendMessageToDoc");
		if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
		var ret = cspRunServerMethod(strMethod, Params);
		if (ret > 0) {
			alert("发送成功!");
			//location.reload();
			window.parent.RPbottom.location.reload();
		} else {
			alert("发送失败!");
		}
	}
}

function btnSend_onClick() 
{
    var MessageBody = getElementValue("AMsgBody", null);
    MessageBody = MessageBody.replace(/\r\n/gi, '<br/>')
    if (MessageBody == "") {
        alert(t["MsgBody"]);
        return;
    }

    var EpisodeIDs = GetSelectedEpisodeIDs();
    if (EpisodeIDs == "") {
        alert("请至少勾选一个就诊患者!");
        return;
    }


    var CreateUserID = getElementValue("LOGON.USERID", null);
    var Params = escape(MessageBody) + "^" + EpisodeIDs + "^" + CreateUserID
    var obj = document.getElementById("MethodSendMessage");
    if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
    var ret = cspRunServerMethod(strMethod, Params);
    if (ret > 0) {
        alert("发送成功!");
        //location.reload();
	window.parent.RPbottom.location.reload();
    } else {
        alert("发送失败!");
    }
}

function btnOpenEntryMTree_onClick() {
    var RuleID = 1;
    var EntryTitle = "";
	var MessageBody="";
    var lnk = "dhc.epr.quality.entrytree.csp?RuleID=" + RuleID + "&EntryTitle=" + escape(EntryTitle);
    var ret = window.showModalDialog(lnk, '', "dialogHeight=600px;dialogWidth=600px;scroll=no;status=no;resizable=yes");
	if (!ret) return;
	if (ret.length>1)
	{
		for (var i = 0;i<ret.length ;i++ )
		{
			var result=ret[i].split("^");
			if (result.length >= 3) {
				var MessageBody=MessageBody+result[2];
				
			}
		}
	}
	
	else{
		var result = ret[0].split("^");
		if (result.length >= 3) {
			var MessageBody=MessageBody+result[2];
		}
	}
	setElementValue("AMsgBody", MessageBody);
}

function LookupMainDoc(str)
{
	var tmpList=str.split("^");
	setElementValue("txtMainDocID",tmpList[0]);
	setElementValue("txtMainDocName",tmpList[2]);
	setElementValue("txtAttendDocID",tmpList[5]);
	setElementValue("txtAttendDocName",tmpList[7]);
}

InitFrom();