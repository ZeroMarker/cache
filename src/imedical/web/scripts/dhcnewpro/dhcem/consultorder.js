$(function(){
	InitEvent();
})
function InitEvent(){
	$.extend($("#tabsReg").tabs("options"),{
		onSelect:function(title,index){ 
			hrefRefresh(true);
		}
	});
}
function hrefRefresh(forceRefresh){
	// �������� 
	//tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
	var curTab = $('#tabsReg').tabs('getSelected');
	var curIframe = curTab.find("iframe").get(0);
	// isXhrRefresh=��,false����ȫ��ˢ��,���һ��ˢ��
	if ((curIframe.src=="about:blank")||!isXhrRefresh){
		var lnk="opdoc.oeorder.cmlistcustom.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&EmConsultItm="+EmConsultItm;
 		curIframe.src = lnk;
	}
}