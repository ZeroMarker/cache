var oprecadm=opdoc.lib.ns("opdoc.patinfobar");
oprecadm.view=(function(){
	function InitPatInfo(EpisodeID,ItemWid){
		if((ItemWid=="")||(typeof ItemWid=='undefined')){
			//ItemWid=$(window).width()-250;	
			ItemWid=$(".PatInfoItem").parent().width()-50;	
		}
		$.m({
			ClassName:"web.DHCDoc.OP.AjaxInterface",
			MethodName:"GetOPInfoBar",
			EpisodeID:EpisodeID,
			CONTEXT:session['CONTEXT']
		},function(html){
			$(".PatInfoItem").html(reservedToHtml(html)).css('width',ItemWid);
			//divÄÚÈÝÒç³ö
			if ($(".PatInfoItem")[0].offsetWidth<$(".PatInfoItem")[0].scrollWidth) {
				InitPatInfoHover();
			}
		});
	}
	function reservedToHtml(str){
		var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
		"&#39;":"'", "&amp;":"&", "&#38;":"&"};
		return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
			return replacements[v];		
		});
	}
	function InitPatInfoHover(){
		$(".PatInfoItem").popover({
			width:$(".PatInfoItem").width(),
			trigger:'hover',
			arrow:false,
			style:'patinfo',
			isTopZindex:true,
			content:"<div class='patinfo-hover-content'>"+$(".PatInfoItem")[0].innerHTML+"</div>"
		});
		//$(".PatInfoItem").css({"margin-right":"20px"}).append('<div style="position:absolute;top:0px;right:0px;">...</div>')
	}
	return {
		"InitPatInfo":InitPatInfo
	}
})();