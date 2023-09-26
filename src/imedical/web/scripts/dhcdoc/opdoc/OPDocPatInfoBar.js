var oprecadm=opdoc.lib.ns("opdoc.patinfobar");
oprecadm.view=(function(){
	function InitPatInfo(EpisodeID){
		$.m({
			ClassName:"web.DHCDoc.OP.AjaxInterface",
			MethodName:"GetOPInfoBar",
			EpisodeID:EpisodeID,
			CONTEXT:session['CONTEXT']
		},function(html){
			$(".PatInfoItem").html(reservedToHtml(html)).css('width',$(window).width()-250);
			//div内容溢出
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
			content:"<div class='patinfo-hover-content'>"+$(".PatInfoItem")[0].innerHTML+"</div>"
		});
	}
	return {
		"InitPatInfo":InitPatInfo
	}
})();