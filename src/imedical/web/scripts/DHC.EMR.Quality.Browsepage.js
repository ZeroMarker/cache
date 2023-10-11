$(function(){
	InitQualityList();
});

function InitQualityList()
{
	var TabTitle1 = "病历浏览";
	if (QuaSetPage=="2"&&action!="O")
	{
		if('undefined' != typeof websys_getMWToken)
		{
			var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.browse.quality.csp?PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&EpisodeLocID='+episodeLocID+'&action=quality'+'&MWToken='+websys_getMWToken()+'"></iframe>';
		}
		else
		{
			var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.browse.quality.csp?PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&EpisodeLocID='+episodeLocID+'&action=quality'+'"></iframe>';
		}
		
	}
	else
	{
		if('undefined' != typeof websys_getMWToken)
		{
			var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.record.quality.csp?PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&EpisodeLocID='+episodeLocID+'&action='+action+'&MWToken='+websys_getMWToken()+'"></iframe>';
		}
		else
		{
			var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.record.quality.csp?PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&EpisodeLocID='+episodeLocID+'&action='+action+'"></iframe>';
		}
    }
	addTab("inPatTab",TabTitle1,inPat,false,true);
    //需要医生站配置才能显示医嘱
	var TabTitle2 = "医嘱浏览";
	if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="doc.admordlist.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="doc.admordlist.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
	}
    addTab("outPatTab",TabTitle2,outPat,false,false);
    var TabTitle3 = "检查报告";
    if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;" src="dhcapp.inspectrs.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;" src="dhcapp.inspectrs.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
	}
    addTab("outPatTab",TabTitle3,outPat,false,false);
    var TabTitle4 = "检验结果";
	if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcapp.seepatlis.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcapp.seepatlis.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
		
	}
    addTab("outPatTab",TabTitle4,outPat,false,false);
    var TabTitle5 = "诊断浏览";
    if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcdoc.diaglistforemr.hui.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
    
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcdoc.diaglistforemr.hui.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
	}
	addTab("outPatTab",TabTitle5,outPat,false,false);
    var TabTitle5 = "过敏记录浏览";
    if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcem.allergyenter.csp?IsOnlyShowPAList=Y&EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcem.allergyenter.csp?IsOnlyShowPAList=Y&EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
	}
    addTab("outPatTab",TabTitle5,outPat,false,false);
    //var TabTitle6 = "麻醉记录单";
	//var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcanoperpdfbrowser.view.csp?PatientID='+PatientID+'&EpisodeID='+EpisodeID+'"></iframe>';
    //addTab("outPatTab",TabTitle6,outPat,false,false);
    var TabTitle7 = "会诊查询";
    if('undefined' != typeof websys_getMWToken)
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcem.consultpathis.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	}
	else
	{
		var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="dhcem.consultpathis.csp?EpisodeID='+ EpisodeID +'&PatientID='+PatientID+'"></iframe>';
	}
    addTab("outPatTab",TabTitle7,outPat,false,false);
	var PDFView=isPDFView.split('^');
	if (PDFView.indexOf(action, 1)>0) 
	{
		var TabTitle8 = "PDF浏览";
		if('undefined' != typeof websys_getMWToken)
	   {
			var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src=""dhc.epr.fs.bscheckrecord.csp?EpisodeID='+EpisodeID+'&MWToken='+websys_getMWToken()+'"></iframe>';
	   }
	   else
	   {
		   var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src=""dhc.epr.fs.bscheckrecord.csp?EpisodeID='+EpisodeID+'"></iframe>';
	   }
	    addTab("outPatTab",TabTitle8,outPat,false,false);	
	}
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




