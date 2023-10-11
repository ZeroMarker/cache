//页面Gui
function InitSummaryWin(){
	var obj = new Object();
	obj.ViewIcon    = [];	//图例
	obj.CurrNo = 1;	//图例默认页
	obj.column      = 60;   //默认列数
	obj.ViewBackColor=[];	//背景色	
	obj.ViewBackColor = [
		["KSS1","#FFE1E1","非限制级"],
		["KSS2","#F9E79F","限制级"],
		["KSS3","#A9DFBF","特殊级"]
	];		
	//初始化高度
	var wh = $(window).height();
	$("body").height(wh-10);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("body").height(wh-10);
		window.location.reload();
	});
	
	// 渲染图例
	var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewIcon");
	if (!runQuery) {
		$.Tool.alert('图例信息为空 ！');
		return;
	}
	else{
		obj.ViewIcon = runQuery.record;
		for(var i = 0 ;i<obj.ViewIcon.length;i++){
			var desc = obj.ViewIcon[i].desc;
			var src = obj.ViewIcon[i].src;
			var html = '<div><img src = "' + src + '"/>'+desc+'</div>' ;
			$('#img_span').append(html);
		}
		//背景色类型特殊处理
		for(var i = 0 ;i<obj.ViewBackColor.length;i++){
			var desc = obj.ViewBackColor[i][2];
			var src = obj.ViewBackColor[i][1];
			var html = '<div><div class="pull-left" style = "background-color:' + src + ';width:14px;height:14px;margin-top:4px;"></div>&nbsp;'+desc+'</div>' ;
			$('#img_span').append(html);
		}
		//刷新处理
		var desc = "上页";
		var src = "";
		var html = '<div><a id="previous" style="cursor: pointer;">'+desc+'</a></div>' ;
		$('#img_span').append(html);
		var desc = "下页";
		var src = "";
		var html = '<div><a id="next" style="cursor: pointer;">'+desc+'</a></div>' ;
		$('#img_span').append(html);
	}
	InitSummaryWinEvent(obj);
	return obj;
}
