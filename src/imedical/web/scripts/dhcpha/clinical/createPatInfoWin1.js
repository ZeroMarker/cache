
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   ??人就�?信�??�???

function createPatInfoWin(adm)
{
	
	if($('#win').is(":visible")){return;}  //�?�?�?????�??��??,????

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="tab"></div>');
	//iframe ?��??????tab??div�?
	//$('#tab').append('<div id="pal" title="�???记�?"><iframe scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe></div>');
	$('#tab').append('<div id="pal" title="�???记�?"></div>');
	$('#tab').append('<div id="ris" title="�???记�?"></div>');
	$('#tab').append('<div id="lab" title="�?�?记�?"></div>');
	$('#tab').append('<div id="epl" title="????�?�?"></div>');
	$('#tab').append('<div id="ord" title="??次�?��??></div>');
	$('#tab').append('<div id="ord1" title="????信�??"></div>');

	$('#win').window({
		title:'??人�???�?�?信�??',
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:550,
		onClose:function(){
			$('#win').remove();  //�????��???��?��??in??DIV??�?
			}
	}); 
	$('#tab').tabs({    
	    border:false,
	    fit:"true", 
	    onSelect:function(title){
	        var tab = $('#tab').tabs('getSelected');  // ?��?????????��??
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
	            case "pal":
					maintab="dhcpha.comment.paallergy.csp";  //�???记�?
					break;
				case "ris":
					maintab="dhcpha.comment.risquery.csp";   //�???记�?
					break;
				case "lab":
					maintab="dhcpha.comment.labquery.csp";   //�?�?记�?  ?��??????????
					break;
				case "epl":
					maintab="epr.newfw.episodelistuvpanel.csp";  //????�?�? ?��??????????
					break;
				case "ord":
					maintab="dhcpha.comment.queryorditemds.csp";    //??次�?��??
			}
			//iframe �?�?
	        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'"?PatientID=1&EpisodeID=1" ></iframe>';
	        tab.html(iframe);
	    }    
	});
	$('#tab').tabs('select','�???记�?'); //�?�???�?�?
	$('#win').window('open');
}
