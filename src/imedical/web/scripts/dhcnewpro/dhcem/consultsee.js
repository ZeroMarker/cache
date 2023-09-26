//consultsee.js
$(function(){  //hxy 2020-04-29 just for DHCWebBrowser49
	var EpisodeID=$("#EpisodeID").val();
	var PatientID=$("#PatientID").val();
	var mradm=$("#mradm").val();
	$HUI.tabs("#tabsReg",{
		onSelect:function(title){
			var lnk = "dhcapp.seepatlis.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
			if(title=="¼ìÑé²é¿´"){
				document.getElementById("dataframe185").src=lnk;
			}
		}
	});
});	