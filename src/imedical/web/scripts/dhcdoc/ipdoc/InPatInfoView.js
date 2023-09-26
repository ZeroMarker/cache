var opl=ipdoc.lib.ns("ipdoc.patinfo");
opl.view=(function(){
	$(document).ready(function() {
		$(".window-mask.alldom").hide();
		//病历质控表格信息加载
		ipdoc.patemrquality.view.Inittabemrquality();
		ipdoc.patord.view.InitInPatOrd();
		ipdoc.pattreatinfo.view.InitPatAdmInfoJson();
	});
})();

function xhrRefresh(refreshArgs){
    var adm=refreshArgs.adm;
	if (ServerObj.EpisodeID==adm){
		//切换页签时，界面布局有时会错乱
		$('#Ordlayout_main').layout('resize');
		$('#OrdReSubCatList').tabs('resize');
		$('#tabInPatOrd').datagrid("resize");
		//有可能是切换页签时调用的，需要刷新列表数据
		//return true;
	}
	$(".window-mask.alldom").show();
	if (typeof(history.pushState) === 'function') {
        var Url=window.location.href;
        Url=rewriteUrl(Url, {
	        EpisodeID:refreshArgs.adm,
        	PatientID:refreshArgs.papmi,
        	mradm:refreshArgs.mradm,
        	forceRefresh:refreshArgs.forceRefresh
        });
        history.pushState("", "", Url);
    }	
	ipdoc.patord.view.xhrRefresh(adm,function (){
		$(".window-mask.alldom").hide();
	});
	ipdoc.patemrquality.view.xhrRefresh();
	ipdoc.pattreatinfo.view.xhrRefresh();
}
﻿