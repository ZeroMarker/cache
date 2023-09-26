$(function(){
	// 展开../images/websys/accordion_arrows.png
	// 收起../images/websys/layout_arrows.png
	$(".collapsetitle").each(function(index,t){
		if(index==0){
			$(this).prepend("<a style='float:right;display:inline-block;padding: 0 2 0 0;width:16px;height:16px;opacity:0.6;filter: alpha(opacity=60);margin: 0 0 0 2px;background: url(../images/websys/accordion_arrows.png) no-repeat 0 0;' href='javascript:void(0)'></a>");
		}else{
			$(this).parent().siblings("tr").hide();
			$(this).prepend("<a style='float:right;display:inline-block;padding: 0 2 0 0;width:16px;height:16px;opacity:0.6;filter: alpha(opacity=60);margin: 0 0 0 2px;background: url(../images/websys/layout_arrows.png) no-repeat 0 0;' href='javascript:void(0)'></a>");
		}
	});
	$("body").delegate(".collapsetitle","click",function(e){
		var that = $(this);
		if(that){
			var aJObj = that.find("a");
			if(aJObj.css("backgroundImage").indexOf("layout_arrows.png")>-1){
				aJObj.css("backgroundImage","url(../images/websys/accordion_arrows.png)");
				that.parent().siblings("tr").show();
			}else{
				aJObj.css("backgroundImage","url(../images/websys/layout_arrows.png)");
				that.parent().siblings("tr").hide();
			}
		}
		
	});
});