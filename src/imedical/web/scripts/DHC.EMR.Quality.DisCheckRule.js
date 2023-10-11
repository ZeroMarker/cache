var qualityStatus = {};
qualityStatus.ViewRevisionFlag=true;

$(function(){
	InitPatInfoBanner(episodeID);
	
	initQualityBrowse();
	initQualityEntryGrid();
	
})

function initQualityBrowse()
{
	var qualityBrowseUrl = "emr.record.fullquality.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+CTLocatID+"&action="+action
	if('undefined' != typeof websys_getMWToken)
	{
		qualityBrowseUrl += "&MWToken="+websys_getMWToken()
	}
	$("#recordQuality").attr("src",qualityBrowseUrl);

}
function initQualityEntryGrid()
{
	if (pilotView>=0)
	{
		var qualityEntryUrl = "dhc.emr.quality.disentrygridwrap.csp?EpisodeID="+episodeID+"&action="+action
	}else{
		var qualityEntryUrl = "dhc.emr.quality.disentrygrid.csp?EpisodeID="+episodeID+"&action="+action+"&patientName="+patientName+"&MedicareNo="+MedicareNo+"&BedNo="+BedNo
	}
	if('undefined' != typeof websys_getMWToken)
	{
		qualityEntryUrl += "&MWToken="+websys_getMWToken()
	}
	$("#qualityEntrygrid").attr("src",qualityEntryUrl);
	
		
}

function setViewRevisionFlag(status)
{
	qualityStatus.ViewRevisionFlag = qualityStatus.ViewRevisionFlag?false:true;

}

function getViewRevisionFlag()
{
	return qualityStatus.ViewRevisionFlag;
}

function openBrowseRecordLog(browseEpisodeID,browseDocID,browseNum)
{
	var browseLogUrl = "emr.instancelog.csp?EpisodeID="+browseEpisodeID+"&EMRDocId="+browseDocID+"&EMRNum="+browseNum;
	if('undefined' != typeof websys_getMWToken)
	{
		browseLogUrl += "&MWToken="+websys_getMWToken()
	}
	$('#browselogiframe').attr('src',browseLogUrl);
	$HUI.dialog('#browselogdialog').open();
}

