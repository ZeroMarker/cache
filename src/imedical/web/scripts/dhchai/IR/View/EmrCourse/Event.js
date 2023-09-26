//页面Event
function InitEmrCourseWinEvent(obj){
	obj.LoadEvents = function(arguments){
		$(".prev").on('click',obj.prev_click);
		$(".next").on('click',obj.next_click);
		$(".timeline_ul>div").on('click',obj.timeline_ul_div_click);
		if (obj.DateLine.total!=0){
			obj.LoadRecod(obj.DateLine.record[(obj.DateLine.total-1)].DocDate);
		}
	}
	obj.next_click = function(){
		var lilength = $(".timeline_ul>div").width();
		if (obj.DateLine.total<parseInt($(".timeline_div").width()/lilength)){
			return;			//日期数量小于可视数量
		}
		//隐藏向前移动的一个div
		var flg=0;
		var moveflg =1;
		$('.timeline_ul>div').each(function (i){
			if (flg==1) return;
			var visibility = $(this).css("visibility");
			if (visibility=="visible"){
				if ((i+1)>obj.DateLine.total-parseInt($(".timeline_div").width()/lilength)) //后面的数据不足填充可视区域
				{
					moveflg=0;
					return;	
				} 
				$(this).css("visibility","hidden");
				flg = 1;
			}
		});
		var marginleft = $(".timeline_ul").css("margin-left");
		if (moveflg==1) {
			$(".timeline_ul").css("margin-left",(parseInt((marginleft).split("px")[0])-parseInt(lilength))+"px");
		}
	}
	obj.prev_click = function(){
		//显示可视区域前的一个div
		var ind = 0;
		$('.timeline_ul>div').each(function (i){
			var visibility = $(this).css("visibility");
			if (visibility=="hidden"){
				ind = i;
			}
		});
		$('.timeline_ul>div').each(function (i){
			if (i==ind){
				$(this).css("visibility","visible");
			}
		});
		var marginleft = $(".timeline_ul").css("margin-left");
		var lilength = $(".timeline_ul>div").width();
		if ((parseInt((marginleft).split("px")[0])+parseInt(lilength))>0) return;   //最左边div最多只能到可视区域左部
		$(".timeline_ul").css("margin-left",(parseInt((marginleft).split("px")[0])+parseInt(lilength))+"px");
	}
	obj.timeline_ul_div_click =function(e){
		var CDate = $(this).find("span").html();
		$(".timeline_ul>div>li>div").attr("class","grayspot");
		$(".timeline_ul>div>li>span").css("color","black")
		$(this).find("div").attr("class","greenspot");
		$(this).find("span").css("color","#02C486")
		obj.LoadRecod(CDate);
	}
	obj.LoadRecod = function(CDate){
		obj.EmrRecord = $.Tool.RunQuery("DHCHAI.IRS.CCRMEWordSrv","QryEmrRecord",PaadmID,"",CDate,CDate);
		$(".content>li").remove();
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
	}
}