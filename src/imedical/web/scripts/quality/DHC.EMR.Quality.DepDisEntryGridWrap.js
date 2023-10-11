$(function(){
	InitQualityList();
});

function InitQualityList()
{
	var inPatTabTitle = "内涵质控";
	var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.qualityairesult.csp?Title='+ inPatTabTitle +'&EpisodeID='+EpisodeID+'&Action='+action+'"</iframe>';
    addTab("inPatTab",inPatTabTitle,inPat,false,true);
	
	var outPatTabTitle = "手工质控";
	if (action=="MD")
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.depdisentrygrid.csp?Title='+ outPatTabTitle +'&EpisodeID='+EpisodeID+'&action='+action+'&Ip='+Ip+'"</iframe>';
    }else{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhc.emr.quality.paperlessentrygrid.csp?Title='+ outPatTabTitle +'&EpisodeID='+EpisodeID+'&action='+action+'&Ip='+Ip+'"</iframe>';
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




