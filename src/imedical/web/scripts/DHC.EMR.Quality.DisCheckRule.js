var qualityStatus = {};
qualityStatus.ViewRevisionFlag=true;

$(function(){
	
	initQualityBrowse();
	initQualityEntryGrid();
	
})

function initQualityBrowse()
{
	var qualityBrowseUrl = "emr.record.quality.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+CTLocatID+"&action="+action
	$("#recordQuality").attr("data",qualityBrowseUrl);

}
function initQualityEntryGrid()
{
	
	var qualityEntryUrl = "dhc.emr.quality.disentrygrid.csp?EpisodeID="+episodeID+"&action="+action
	$("#qualityEntrygrid").attr("data",qualityEntryUrl);
	
		
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
	$('#browselogiframe').attr('src',browseLogUrl);
	$HUI.dialog('#browselogdialog').open();
}