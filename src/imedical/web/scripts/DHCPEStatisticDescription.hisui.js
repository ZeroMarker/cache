//名称	DHCPEStatisticDescription.hisui.js
//功能	体检统计说明
//创建	2022.09.30
//创建人  ln

function description_click()
{
	var strUrl=location.href;
	var MenuDesc=tkMakeServerCall("web.DHCPE.Statistic.HISUICommon","GetMenuDescByUrl",strUrl);
	if (MenuDesc=="") return false;
	var lnk="dhcpestatisticdescription.hisui.csp"+"?MenuDesc="+MenuDesc;
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=600,height=250,hisui=true,title='+$g("统计规则说明"))	
	
	return true;
}

// 解决iframe中 润乾csp 跳动问题
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId);
    if (iframeObj) {
		if (HISUIStyleCode == "lite") {  // 没找到极简的加载数据图片
			var tStyle = "background: url(../images/board_loading.png) center no-repeat;"
					   + "width: 100%;"
					   + "height: 100%;"
					   ;
		} else {
			var tStyle = "background: url(../images/board_loading.png) center no-repeat;"
					   + "width: 100%;"
					   + "height: 100%;"
					   ;
		}
		$(iframeObj).before("<div id='loadingRunQianCSP' style='" + tStyle + "'></div>");

	    iframeObj.src=url;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
				$("#loadingRunQianCSP").remove();
		        $(this).show();
				$(this).contents().find("body").height($(this).height()-10);
				$(this).contents().find("body").width($(this).width()-10);
				if (HISUIStyleCode == "lite") setScrollbar(iframeId, "RunQianReport");
		    });
	    } else {
		    iframeObj.onload = function(){
				$("#loadingRunQianCSP").remove();
		        $(this).show();
				$(this).contents().find("body").height($(this).height()-10);
				$(this).contents().find("body").width($(this).width()-10);
				if (HISUIStyleCode == "lite") setScrollbar(iframeId, "RunQianReport");
		    };
	    }
    }
}

/// 润乾中滚动条修改
/// 若润乾csp修改了，则不需调用这个方法
function setScrollbar(iframeId, docName) {
	var iframeName = $("#"+iframeId).contents().find("[name='"+docName+"']");
    if (iframeName) {
		var styleHTML = "<style type=\"text/css\">"
					  + "::-webkit-scrollbar {"
					  + "	width: 8px;"
					  + "	height: 8px;"
					  + "	box-sizing: border-box;"
					  + "}"
					  
					  + "::-webkit-scrollbar-button {"
					  + "	background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAAAUCAYAAADRA14pAAADr0lEQVRYR71Yy04iQRQtE10IRiSBOLbOUvZmfkIlLHXjI+jCDzAm8w8TJKxZyENdqEui8BPuDVtsHCNGQcFEWUzdSt/KtbqqqZ44U0kn1V2n69xz63W6x5h9iXFoNADe521dftnibJlt+7PCjdmycpzz9vbmmvCTk5PzvK0NuNvbWyNuYWEBcbbUX8obSvBgMDAKiUQiUrDLi0nNPC9eYqwFfyWvTvAPHsm1JhqHEl9dXbHV1VUJo4Lv7u6k4JOTE7a5uSlxc3Nz/0ww5VXjR15VMIjFoop2+v2+EAJisaDoaDQqR/j+/l7gjo+PJW5ra0vUZ2dnqWDko1zqM+fi4kL0RxOMMaytrUneXC4ncMhFYzg4OBA4KpiK1Yl2Xl9fXSqWip6ampLEDw8PbrVa9U2S7e1tlkwmdYIBC6J1CXfOz8/ljAHRNIbFxcXs0tJShb/rHB4eShxw0RgymczPVCr1CwWrRCOJeQesVqtJUevr61JwPp+XxHt7e6xYLErc/v6+OqVHJvrl5cWt1+u+BEIMNzc3UvDj46NbqYD2zwViaLfbWsGBU+vs7EwIASIow+GQYSA8e5K4UCgIHBBBeX9/Z+VyWdT5CAliJabApdTr9UR/VDTGQPeO5+dngUMuGgPiQu3S3W7XHR8fl2IxaHjWbDalYAhwYmJCNH98fEht8KzVaukEA8a4WQIvdgKiacJjsZicWZgYwJZKJZlwiGF6etq3hpWk+24dzKAOODMzI4lhrZs6I2t9FB+2+3ghcZjIIF4YCJiFUJA31AjbCrY8N/9aMH2RCrbhDSP4OydKBETZ4W09fn3jV8SAG/Dnv/kFFtS22PC2eGdWOJNg3fnos3iXl5ci6HQ6zTxryVRbeXp6KjAbGxvMYCt1XDQZgpdy0UbV0lI+ikNuk9NCLN21fU4LQXA2ersgbP+fXBZiwG05jqNzWUE7NLwueHVmBxrpLg3c4OwoJ9aR+6udFgvhsugA/DeHZ3JaWi+tOi1q9bxdkHU6nU8uCxwPlkQiEeSjTaKFw8M+1JGmDg+4EUddFsSA3KFGWGcAVlZWBId3zrGnpyff4Z/NZgUmHo+bBIc2Hgqv+Cy14Q61hlUDgNkEcs8AMPXwR8zOzo48/Olc5vWRaxh4qctCsdCPajzAcFBOrI8yHtpdWj2HG42G6G95eZl55yHDLyokOjo6EtXd3V1Gvqh061e3jAAnjAfloi/Tcxi4KR/FIXeYc9jmFwpw2PwGUgY58NaG1/rX0h9d1DUzJEP0JgAAAABJRU5ErkJggg==);"
					  + "	background-color: #F1F1F1;"
					  + "	background-repeat: no-repeat;"
					  + "}"
					
					  + "::-webkit-scrollbar-button:vertical:decrement {"
					  + "	width: 8px;"
					  + "	height: 10px;"
					  + "	background-position-x: -1px;"
					  + "	background-position-y: 0;"
					  + "	border-top-right-radius: 4px;"
					  + "	border-top-left-radius: 4px"
					  + "}"
					
					  + "::-webkit-scrollbar-button:vertical:increment {"
					  + "	width: 8px;"
					  + "	height: 10px;"
					  + "	background-position-x: -31px;"
					  + "	background-position-y: 0;"
					  + "	border-bottom-right-radius: 4px;"
					  + "	border-bottom-left-radius: 4px"
					  + "}"
					
					  + "::-webkit-scrollbar-button:horizontal:decrement {"
					  + "	width: 8px;"
					  + "	height: 8px;"
					  + "	background-position-x: 0;"
					  + "	background-position-y: -11px;"
					  + "	border-top-left-radius: 4px;"
					  + "	border-bottom-left-radius: 4px"
					  + "}"
					
					  + "::-webkit-scrollbar-button:horizontal:increment {"
					  + "	width: 8px;"
					  + "	height: 8px;"
					  + "	background-position-x: -30px;"
					  + "	background-position-y: -11px;"
					  + "	border-top-right-radius: 4px;"
					  + "	border-bottom-right-radius: 4px"
					  + "}"

					  + "::-webkit-scrollbar-corner {"
					  + "	background-color: #AFCEDE;"
					  + "	border-radius: 1px;"
					  + "}"
					  + "::-webkit-scrollbar-thumb {"
					  + "	background-color: #D4D4D4;"
					  + "	border-radius: 4px;"
					  + "	border-width: 0;"
					  + "}"
					  
					  + "::-webkit-scrollbar-thumb:hover {"
					  + "	background-color: #AFCEDE;"
					  + "	border-radius: 4px;"
					  + "	border-width: 0"
					  + "}"

					  + "::-webkit-scrollbar-track-piece {"
					  + "	background-color: #F1F1F1;"
					  + "	border-width: 0;"
					  + "}"
					  + "</style>";
					  debugger
		iframeName.contents().find("head").append(styleHTML);
    }
}