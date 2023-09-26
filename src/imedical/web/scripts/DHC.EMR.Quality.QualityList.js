$(function(){
	InitQualityList();
});
//Desc:病人列表信息
function InitQualityList()
{
	//alert(CTLocatID+userID);
	var inPatTabTitle = "环节质控缺陷";
	var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.profilerlist.csp?Title='+ inPatTabTitle +'&EpisodeID='+EpisodeID+'&CTLocatID='+CTLocatID+'&userID='+userID+'"></iframe>';
    addTab("inPatTab",inPatTabTitle,inPat,false,true);
	
	var outPatTabTitle = "时效性缺陷";
	var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.qualityresult.csp?Title='+ outPatTabTitle +'&EpisodeID='+EpisodeID+'&CTLocatID='+CTLocatID+'&userID='+userID+'"></iframe>';
    addTab("outPatTab",outPatTabTitle,outPat,false,false);

}

function addTab(tabId,tabTitle,content,closable,selected)
{
	$('#patientTabs').tabs('add',{
	    id:       tabId,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected
   });	
}




