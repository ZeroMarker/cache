$(function(){
	refreshBar();
})
function reservedToHtml(str){	
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
var refreshBar = function (){
		jQuery.ajax({
		type : "GET", 
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls?OutputType=String&Class=web.DHCDoc.OP.AjaxInterface&Method=GetOPInfoBar&p1="+episodeID+"&p2=", 
		async : false,
		success : function(d) {
			if (d !== '')
	       $(".PatInfoItem").html(reservedToHtml(d));
		}
	});	
	var html = document.querySelector('.PatInfoItem').innerHTML;
	$(".PatInfoItem").popover({
		width:$(".PatInfoItem").width()-10,
		trigger:'hover',
		arrow:false,
		style:'patinfo',
		content:"<div class='patinfo-hover-content'>"+reservedToHtml(html)+"</div>"
	});	
	$(".PatInfoItem").append('<div style="position:absolute;top:0px;right:10px;">...</div>')
	$(".PatInfoItem").append('<div class="border-div"></div>');
	//  patientbar 极简版背景色 HISUIStyleCode!=='lite'
	if(HISUIStyleCode=='lite'){
		$(".hisui-layout div:not.border-div").css("background-color","#f5f5f5")	
	}
	
};    
