$(function(){
	InitQualityList();
});

function InitQualityList()
{
	var inPatTabTitle = "内涵质控";
	if('undefined' != typeof websys_getMWToken)
	{
		var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.qualityairesult.csp?Title='+ inPatTabTitle +'&EpisodeID='+EpisodeID+'&Action='+action+'&MWToken='+websys_getMWToken()+'"</iframe>';
	}
	else
	{
		var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.qualityairesult.csp?Title='+ inPatTabTitle +'&EpisodeID='+EpisodeID+'&Action='+action+'"</iframe>';
	}
    addTab("inPatTab",inPatTabTitle,inPat,false,true);
	
	var outPatTabTitle = "手工质控";
	if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.disentrygrid.csp?Title='+ outPatTabTitle +'&EpisodeID='+EpisodeID+'&action='+action+'&MWToken='+websys_getMWToken()+'"</iframe>';
	}
	else
	{	
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.disentrygrid.csp?Title='+ outPatTabTitle +'&EpisodeID='+EpisodeID+'&action='+action+'"</iframe>';
	}
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




