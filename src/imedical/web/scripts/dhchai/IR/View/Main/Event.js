///页面Event
function InitPatViewWinEvent(obj){
	obj.LoadEvent = function(arguments){
		if (IndexTab == 'ASPOrdItem') {
			obj.tab_show(IndexTab);
		} else {
			obj.tab_show(0);
		}
		
		obj.tab_click();
		//$(".title img").on("click",obj.closeWin);
		$(".close").on("click",obj.closeWin);
	};
	obj.closeWin = function()
	{
		if(parent.layer) { 
			var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引
			parent.layer.close(index); //再执行关闭 
		}else{
			websys_showModal('close');
		}
	}
	// tab点击事件
	obj.tab_click = function (){
		$('#PatViewTab li').each(function(i){
		    $(this).click(function(){
		    	obj.tab_show(i);
		   })
		})
	};

	// 显示tab页签内容
	obj.tab_show = function(i)
	{
		var itmp = parseInt(i);
		if (isNaN(itmp)){ //不是纯数字下标
			var indexId = i;
			i = "";
			for (var j=0; j<obj.tabJosn.data.length; j++){
				if (indexId == obj.tabJosn.data[j].id){
					i=j;
					break;
				}
			}
			if (i==""){ return;}
		}
		var id = obj.tabJosn.data[i].id;
    	var url = obj.tabJosn.data[i].url;
   		url = url + '?PaadmID=' + PaadmID + '&1=1';
    	if ($("#content_" + id).length<1) {
	  		var htm = '';
			htm += '<div id="content_' + id + '" class="tab-pane">';
			htm += '<iframe id="iframe_' + id + '" src="' + url + '"  width="99.5%" onLoad="iFrameHeight (\'iframe_' + id + '\')" frameborder="0" >';
			//htm += '<iframe id="iframe_' + id + '" src="' + url + '" height="80%" width="100%" frameborder="0" >';
			htm += '</iframe>';
			htm += '</div>';
			$("#PatViewContent").append(htm);
		}
		$("#PatViewTab").find("li").removeClass("active");
		$("#PatViewContent").find(".tab-pane").removeClass("active");
		$("#li_"+id).addClass("active");
		$("#content_"+id).addClass("active");
		//IE8下iframe的onload事件需先注册
		var ifm = document.getElementById('iframe_' + id);
		if(ifm.attachEvent){
	    	ifm.attachEvent("onload", function(){
				if (ifm != null) {
					try {
						var bHeight = ifm.contentWindow.document.body.scrollHeight;
						var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
						var innerHeight = Math.min(bHeight, dHeight);
						if (PageType == 'WinOpen') {
							var outerHeight = $(window).height()-100 ;
						}else {
							var outerHeight = $(window).height()-80 ;
						}
						ifm.height = outerHeight;
					} catch (e) {
						console.error(e);
						ifm.height = 560;
					}
				}
			});
		}else{
			ifm.onload = function(){
				if (ifm != null) {
					try {
						var bHeight = ifm.contentWindow.document.body.scrollHeight;
						var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
						var innerHeight = Math.min(bHeight, dHeight);
						if (PageType == 'WinOpen') {
							var outerHeight = $(window).height()-100 ;
						}else {
							var outerHeight = $(window).height()-80 ;
						}
						ifm.height = outerHeight;
					} catch (e) {
						console.error(e);
						ifm.height = 560;
					}
				}
			};
		}
	}
}
///iframe自适应屏幕高度
function iFrameHeight(id){
	var ifm = document.getElementById(id);
	if (ifm != null) {
		try {
			var bHeight = ifm.contentWindow.document.body.scrollHeight;
			var dHeight = ifm.contentWindow.document.documentElement.scrollHeight;
			var innerHeight = Math.min(bHeight, dHeight);
			if (PageType == 'WinOpen') {
				var outerHeight = $(window).height()-100 ;
			}else {
				var outerHeight = $(window).height()-80 ;
			}
			ifm.height = outerHeight;
		} catch (e) {
			console.error(e);
			ifm.height = 560;
		}
	}
}