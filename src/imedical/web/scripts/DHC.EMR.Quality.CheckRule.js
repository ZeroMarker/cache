var qualityStatus = {};
qualityStatus.ViewRevisionFlag=true;
$(function(){
	InitPatInfoBanner(episodeID);
	initQualityBrowse();
	initQualityEntryGrid();
	
})

function initQualityBrowse()
{

	var qualityBrowseUrl = "emr.record.fullquality.csp?PatientID="+patientID+"&EpisodeID="+episodeID+"&EpisodeLocID="+CTLocatID+"&action="+action+"&QuaSetPage="+QuaSetPage	
	if('undefined' != typeof websys_getMWToken)
	{
		qualityBrowseUrl += "&MWToken="+websys_getMWToken()
	}
	$("#recordQuality").attr("src",qualityBrowseUrl);

}
function initQualityEntryGrid()
{
  if (QuaSetPage=="2"&&action!="O")
  {
  	var qualityEntryUrl = "dhc.emr.quality.entrygridwide.csp?EpisodeID="+episodeID+"&action="+action
  	if('undefined' != typeof websys_getMWToken)
	{
		qualityEntryUrl += "&MWToken="+websys_getMWToken()
	}
  }
  else
  {
	if (pilotView>=0&&(action=="A"||action=="D"||action=="O"))
	{
		var qualityEntryUrl = "dhc.emr.quality.entrygridwrap.csp?EpisodeID="+episodeID+"&action="+action
	}else{
		var qualityEntryUrl = "dhc.emr.quality.entrygrid.csp?EpisodeID="+episodeID+"&action="+action
	}
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

function commitZeroError()
{
	$.messager.alert("提示","确认成功！");	
}

