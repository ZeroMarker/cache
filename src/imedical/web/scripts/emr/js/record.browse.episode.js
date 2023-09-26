$(function(){	
	initFrameURL();		
});

function initFrameURL()
{
	var status = GetBrowseStatus(episodeID);
	if (status.IsEMR == 1)
	{
		if(status.IsPDF == 0)
		{
			var viewType = "Editor";
			var url = "emr.record.browse.category.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+episodeLocID+"&Action="+action;
			$('#frameBrowseEPRorEMR').attr("src",url);
		}
	}
	else
	{
		var url = "epr.newfw.episodelistuvpanel.csp?patientID=" + patientID + "&episodeID=" + episodeID + "&admType=" + admType;
		$('#frameBrowseEPRorEMR').attr("src",url);
	}
}

function GetBrowseStatus(episodeID)
{
	var result = "";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.browse.cls",
		async: false,
		data: {"Action":"GetBrowseStatus","EpisodeID":episodeID},
		success: function(d) { result = eval("("+d+")");},
		error : function(d) { alert(action+" error");}
	});
	return result;
}

//检索当前病历
function selectRecord(value)
{
	window.frames["frameBrowseEPRorEMR"].selectRecord(value);
}