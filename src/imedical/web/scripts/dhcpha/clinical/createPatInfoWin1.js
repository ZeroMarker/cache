
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   ??äººå°±è¯?ä¿¡Í??çª???

function createPatInfoWin(adm)
{
	
	if($('#win').is(":visible")){return;}  //çª?ä½?å¤?????å¼??¶æ??,????

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="tab"></div>');
	//iframe ?´æ??????tab??divä¸?
	//$('#tab').append('<div id="pal" title="è¿???è®°å?"><iframe scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe></div>');
	$('#tab').append('<div id="pal" title="è¿???è®°å?"></div>');
	$('#tab').append('<div id="ris" title="æ£???è®°å?"></div>');
	$('#tab').append('<div id="lab" title="æ£?éª?è®°å?"></div>');
	$('#tab').append('<div id="epl" title="????æµ?è§?"></div>');
	$('#tab').append('<div id="ord" title="??æ¬¡È?»å??></div>');
	$('#tab').append('<div id="ord1" title="????ä¿¡Í??"></div>');

	$('#win').window({
		title:'??äººæ???æ£?éª?ä¿¡Í??',
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:550,
		onClose:function(){
			$('#win').remove();  //çª????³é???¶ç?»é??in??DIV??ç­?
			}
	}); 
	$('#tab').tabs({    
	    border:false,
	    fit:"true", 
	    onSelect:function(title){
	        var tab = $('#tab').tabs('getSelected');  // ?·å?????????£Ø??
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
	            case "pal":
					maintab="dhcpha.comment.paallergy.csp";  //è¿???è®°å?
					break;
				case "ris":
					maintab="dhcpha.comment.risquery.csp";   //æ£???è®°å?
					break;
				case "lab":
					maintab="dhcpha.comment.labquery.csp";   //æ£?éª?è®°å?  ?°å??????????
					break;
				case "epl":
					maintab="epr.newfw.episodelistuvpanel.csp";  //????æµ?è§? ?°å??????????
					break;
				case "ord":
					maintab="dhcpha.comment.queryorditemds.csp";    //??æ¬¡È?»å??
			}
			//iframe å®?ä¹?
	        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'"?PatientID=1&EpisodeID=1" ></iframe>';
	        tab.html(iframe);
	    }    
	});
	$('#tab').tabs('select','è¿???è®°å?'); //é»?è®???ä¸?é¡?
	$('#win').window('open');
}
