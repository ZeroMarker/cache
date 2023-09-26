//页面Event
function InitCCScreeningWinEvent(obj){	
	// 初始化权限
	
	var htmlStr="";	
	
	function refreshLocList()
	{
		//日志
		obj.DateLine = $.Tool.RunQuery('DHCHAI.DPS.EmrRecordSrv','QryDocDate',PaadmID,"");
		if (obj.DateLine.total==0){		//没有数据显示提示
			//清空主区域内容
				$("#divMain").empty();
				//无符合条件的记录
				htmlStr='<div id ="PaAdm1" class="noresult">'
						+	'<img src="../scripts/dhchai/img/noresult.png"/>'
						+ 	'<p>无符合条件的记录</p>'
						+'</div>';		
				$("#divMain").append(htmlStr);
			return obj;
		}else{
			$("#ulLoc").empty();
			
			
			//一级
			var str="";
			str += "<li class='active treeview'>";
			str +="<a id='LocQY' href='#'>";
			str +="<span>{0}</span>";
			str +="</a>";
			var cntIn =0,cntLog=0,cntIng=0,cntCfm=0;
			
			str +="<ul id='ulLocMX' class='treeview-menu'>"
			var tmpStr ="";
			for(var i=(obj.DateLine.total-1);i>=0;i--){
				var tmp = obj.DateLine.record[i].DocDate;			
				
				tmpStr += ("<li text='"+tmp+"'><a id='Loc"+tmp+"' href='#'>{0}</a>");
				tmpStr = tmpStr.format(tmp);				
				//三级暂不考虑
				
				tmpStr+="</li>";
			}
			str = str.format("病程记录");
			str += tmpStr;
			str += "</ul></li>";
			$("#ulLoc").append(str);
			
		}		
		//科室选中逻辑 
		$('#ulLocMX > li').click(function (e) {
			e.preventDefault();
			$('#ulLocMX > li').removeClass('active');
			$(this).addClass("active");			
			
			var txt = $(this,"a").attr("text");  //text
			$('#ulLoc').val(txt);
			refreshPatList();
			//setTimeout(refreshPatList,0.2*1000);  //错开达到异步
		});		
		//默认选择第一条科室
		$('#ulLocMX li:first-child').click();
	}
	refreshLocList();
	//刷新病人列表
	function refreshPatList()
	{
		//清空主区域内容
		$(".content>li").remove();
		var CDate = $("#ulLoc").val();  //科室ID
		obj.EmrRecord = $.Tool.RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryEmrRecord",PaadmID,"",CDate,CDate);
		for (var i=0;i<obj.EmrRecord.total;i++)
		{
			var RecordID = obj.EmrRecord.record[i].RecordID;
			var DocType = obj.EmrRecord.record[i].DocType;
			var DocTitle = obj.EmrRecord.record[i].DocTitle;
			var DocDate = obj.EmrRecord.record[i].DocDate;
			var DocContent = obj.EmrRecord.record[i].DocContent;
			var ActDate = obj.EmrRecord.record[i].ActDate;
			var ActTime = obj.EmrRecord.record[i].ActTime;
			var ActUser = obj.EmrRecord.record[i].ActUser;
			var htm="";
			htm+='<li><h4>'+ActDate+' '+ActTime+ ' '+DocTitle+'<h4>';
			htm+='<p class="course">'+DocContent+'</p>';
			htm+='<p class="sign">医生：'+ActUser+'</p>'; 
			htm+='</li>';
			$(".content").append(htm);
		}		
		//移动滚动条
		//$("#MainTable").mCustomScrollbar("scrollTo",[0,0]);
		//$("#MainTable").mCustomScrollbar("scrollTo","top");
		$("#MainTable").mCustomScrollbar({
			theme: "dark-thick",
			axis: "y",
			scrollInertia: 100,
			mouseWheelPixels: 80
		});		
		//setTimeout('$("#MainTable").mCustomScrollbar("scrollTo","top");',2*1000)		
	}
	
	function myLoading() {
		if ($(".Loading_animate_content").length != 0) {
			if ($(".Loading_animate_bg").length == 0) {
				var html = '<div class="Loading_animate_bg">'
				    +'<div class="loading">'
					+	'<img src="../scripts/dhchai/img/loading.gif"/>'
				    +'</div>'
				    +'</div>'
					+ '<div class="Loading_animate_font">加载中...</div>';
					$(".Loading_animate_content").append(html);
			}
		}
	}
	function myLoadingBug() {		
		$('.Loading_animate_bg').css({ height: $(document).height() });
		$('.Loading_animate_font').css({ left: ($(document).width() - 36) / 2 });
	}
	function myLoadHiden()
	{
		if ($(".Loading_animate_content").length != 0) {
			$(".Loading_animate_content").css("display", "none");
			$(".Loading_animate_font").text("加载中...");
		}
	}
	
}
