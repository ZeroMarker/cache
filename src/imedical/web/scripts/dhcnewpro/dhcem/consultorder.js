$(function(){
	InitEvent();
})
function InitEvent(){
	$.extend($("#tabsReg").tabs("options"),{
		onSelect:function(title,index){ 
			hrefRefresh(true);
			if((title=="ͣҽ��")||(index=="2")){ //hxy 2022-07-27
				tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
			}
		}
	});
}
function hrefRefresh(forceRefresh){
	// �������� 
	//tkMakeServerCall("web.DHCDocMainOrderInterface","ChartItemChange");
	var curTab = $('#tabsReg').tabs('getSelected');
	var curIframe = curTab.find("iframe").get(0);
	// isXhrRefresh=��,false����ȫ��ˢ��,���һ��ˢ��
	var isXhrRefresh=false;
	if (((curIframe.src=="about:blank")||!isXhrRefresh)&&(curIframe.name=="CMdataframe")){
		var lnk="opdoc.oeorder.cmlistcustom.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&EmConsultItm="+EmConsultItm;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
 		curIframe.src = lnk;
	}
	
	if (((curIframe.src=="about:blank")||!isXhrRefresh)&&(curIframe.name=="dataframe185")){
 		var lnk="doc.emstopord.hui.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&EntryFrom=";
 		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		curIframe.src = lnk;
	}
	
	if (((curIframe.src=="about:blank")||!isXhrRefresh)&&(curIframe.name=="CMdataframe1")){
 		var lnk="doc.virlongorder.hui.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&EntryFrom=";
 		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		curIframe.src = lnk;
	}
	
	if (((curIframe.src=="about:blank")||!isXhrRefresh)&&(curIframe.name=="CMdataframe2")){
 		var lnk="ipdoc.patorderview.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&EntryFrom=&PageShowFromWay=ShowFromOrdEntry"+"&EmConsultItm="+EmConsultItm;
		if ('undefined'!==typeof websys_getMWToken){
			lnk += "&MWToken="+websys_getMWToken();
		}
		curIframe.src = lnk;
	}
}