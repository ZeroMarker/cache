$(document).ready(function(){
	debugger
	var Src=ServerObj.frameurl+"&MWToken="+websys_getMWToken()
	var frame='<iframe id="iOrderOther" name="iOrdOther" src='+Src+' width="98%" min-height="500px" height="98%" frameborder="0"></iframe>'
	//var frame='<iframe id="iOrderOther" name="iOrdOther" src="http://114.251.235.22/irisview/towatch/report?&patid=0000000022&stAccNum=CJCH725" width="98%" min-height="500px" height="98%" frameborder="0"></iframe>'
	
	$("#CenterPanel").panel('open').panel("setTitle",ServerObj.title);
	$('#CenterPanel').empty().append(frame);
	//$("#CenterInfo").attr("src",Src)
	$("#CenterPanel").panel({maximizable:true,closable:true})			
	$("#mainPanel").layout('resize'); 

	//window.open(Src,'_parent');
	//window.parent.location.href=Src
	//top.location.href=Src
})