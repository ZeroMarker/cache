$(function(){
	//$("html").append("11111");
	$("span[class='combo']").each(function(){
		var combo_height = $(this).height();
		var combo_width = $(this).width();
		var comboText_width  = combo_width-combo_height;
		//$(this).children("input[class*='combo-text']").css({"height":combo_height,"line-height":combo_height,"width":comboText_width});
		$(this).children("input[class*='combo-text']").css({"height":combo_height,"width":comboText_width});
	})
	///$("span[class='combo']").css("height","25px");
	
	$("span[class='combo-arrow']").each(function(){
		if($(this).parent().parent().attr("class")=="combo"){
			var combo_height= $(this).parent().parent().height();
			$(this).css({"height":combo_height,"width":combo_height,"opacity":"1"});
		}
	})
})