$(function(){

});

function GetProblemList()
{
	var Action = action
	
	if (Action=="A")
	{
		parent.createModalDialog("QualityResultDialogA","�ʿ�ȱ�ݲ鿴","1000","500","iframeQualityResultA","<iframe id='iframeQualityResultA' scrolling='auto' frameborder='0' src='dhc.emr.quality.qualityresultwide.csp?EpisodeID=" + EpisodeID + "&ARuleID=1" +"' style='width:100%; height:100%; display:block;'></iframe>","","")	
	}
	else if (Action=="D")
	{
		window.open("dhc.emr.quality.qualitylist.csp?EpisodeID=" + EpisodeID+ "&RuleID=" + 2); 	
	}
		
}

//ȷ���ʿ���ȱ��
//hky 20180817
function SureZeroError()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../web.eprajax.EPRSetManualFlag.cls",
		async: true,
		data: {
			"EpisodeID":EpisodeID,
			"SignUserID":SignUserID,
			"Action":"Set",
			"Status":action,
			"SSGroupID":SSGroupID,
			"IsMessage":"1"
		},
		success: function(d) {
			
			if (d ==1 )
			{
				parent.commitZeroError()
			}
		}
	});
	
}

function CommitEntryItems()
{
	parent.createModalDialog("CommitEntryItems","�ʿ�ȱ������","760","650","iframeCommitEntry","<iframe id='iframeCommitEntry' scrolling='auto' frameborder='0' src='dhc.emr.quality.entrygrid.csp?EpisodeID=" + EpisodeID + "&action="+action +"' style='width:100%; height:100%; display:block;'></iframe>","","")
	
}

function changeRevisionStatus()
{
 	if (document.getElementById("revision").innerText == "��ʾ����")
 	{
	 	document.getElementById("revision").innerText = "�ر�����";
	 	setRevision("true");
	}
	else
	{
		document.getElementById("revision").innerText = "��ʾ����";
		setRevision("false");
	}
	document.getElementById("revision").style.height="30px"
	document.getElementById("revision").font="30px"
	document.getElementById("revision").style.lineHeight="30px"
}
function setRevision(status)
{
	parent.setViewRevisionFlag(status)
}
