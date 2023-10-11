// underscore 防抖
function debounce(func, wait, immediate) {
    var timeout, result;
    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };
    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };
    return debounced;
}

if (typeof $g=='undefined') var $g=function(item){
	return item;
}

/**
* @param {String} url 链接路径 如: https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=1&UserId=1
* @param {Object} obj 直接对象 如: {"EpisodeId":2,OrderId:"2||1"}
* @return {String} 组合后的url串 如:https://127.0.0.1/dthealth/web/csp/test.csp?EpisodeId=2&UserId=1&OrderId=2||1
*/
function rewriteUrl(url, obj){
	url = url||"";
	var reg,flag, indexFlag = false;
	var indexFlag = (url.indexOf("?")==-1);
	if(indexFlag){
		url += "?";	
	}
	for (var i in obj){	
		if(obj.hasOwnProperty(i)){
			flag = false; 	
			if(!indexFlag){
				reg =  new RegExp(i+"=(.*?)(?=$|&)","g");
				url = url.replace(reg, function(m1){
					flag = true;
					return i+"="+obj[i];
				});
			}
			if(!flag){
				url  +=   "&" + i + "=" + obj[i];
			}
		}
	}
	return url;	
}

(function($){
	$.isIE=false,$.isLowIE=false;
	var ua=navigator.userAgent;
	if(ua.indexOf('Trident')>-1 || ua.indexOf("MSIE")>-1) $.isIE=true;
	if(ua.indexOf('MSIE 6')>-1 || ua.indexOf("MSIE 7")>-1 ||ua.indexOf("MSIE 8")>-1) $.isLowIE=true;
})(jQuery);


///=============================日期时相关  ===============================
Date.prototype.format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1, //月           
        "d+": this.getDate(), //日           
        "h+": this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, //时           
        "H+": this.getHours(), //小时           
        "m+": this.getMinutes(), //分           
        "s+": this.getSeconds(), //秒           
        "q+": Math.floor((this.getMonth() + 3) / 3), //季
        "S": this.getMilliseconds() //毫秒           
    };
    var week = {
        "0": "\u65e5",
        "1": "\u4e00",
        "2": "\u4e8c",
        "3": "\u4e09",
        "4": "\u56db",
        "5": "\u4e94",
        "6": "\u516d"
    };
    if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    if (/(E+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f" : "\u5468") : "") + week[this.getDay() + ""]);
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        }
    }
    return fmt;
}
if(typeof websys_dateformat=="undefined") var websys_dateformat=3;
//his 配置日期格式
function websys_formatDate(datestr){
	/*if((websys_dateformat==4)&&(datestr.indexOf("-")>-1)){
		var arr=datestr.split("&nbsp");
		arr[0]=arr[0].split("-").reverse().join("/");
		datestr=arr.join("&nbsp");
    }
    return datestr;*/
    
	if (websys_dateformat==3){ //转换里面 dd/MM/yyyy格式的
		datestr=datestr.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m,i,d){
			return m.split('/').reverse().join('-');
		})
	}
	if (websys_dateformat==4){  //转换里面 yyyy-MM-dd 的
		datestr=datestr.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m){
			return m.split('-').reverse().join('/');
		})
	}
	return datestr;
}

function calDays(xDate,yDate){
    var xD=new Date(xDate.replace(/-/g,"/")),
        yD=new Date(yDate.replace(/-/g,"/"))
    return parseInt((yD.getTime() - xD.getTime()) / (24 * 60 * 60 * 1000));
}
///计算相差多少秒 Date YYYY-MM-DD  Time HH:MM  HH:MM:SS
function calSeconds(xDate,xTime,yDate,yTime){
    var xD=new Date(xDate.replace(/-/g,"/") +" "+ xTime),
        yD=new Date(yDate.replace(/-/g,"/") +" "+ yTime)
    return parseInt((yD.getTime() - xD.getTime()) / 1000);
}
function $zth(time){
	var arr=time.split(":");
	var h=parseInt(arr[0]),m=parseInt(arr[1]),s=parseInt(arr[2]);
	return (h||0)*60*60+(m||0)*60+(s||0);
}
///获取某天是星期几  
function getWeekDay(date){
	if (typeof date=="string"){
		var D=new Date(date.replace(/-/g,"/"));
	}else {
		var D=date;
	}
	return "日一二三四五六".charAt(D.getDay());
}
function moveDay(date,days){
	var D=new Date(date.replace(/-/g,"/"));
	D.setDate(D.getDate()+days);
	return D.format("yyyy-MM-dd");
}
///获取从某天起多天 日期框文本
function getDateTextArray(date,limit){
	limit=limit||7;
	var arr=[];
	var D=new Date(date.replace(/-/g,"/"));
	for (var i=0;i<limit;i++){
		arr.push(websys_formatDate(D.format("yyyy-MM-dd"))+$g("（"+getWeekDay(D)+"）")) ; //add trans
		D.setDate(D.getDate()+1);
	}
	return arr;
}


//门诊 日期格子显示内容
function GetDateAndWeekDayHour(episodeValue) {
    var lstEpisode = ClinicalData.EpisodeList;
    var nowEpisode = null;
    for (var index = 0; index < lstEpisode.length; index++) {
        if(lstEpisode[index].EpisodeID == episodeValue) {
            nowEpisode = lstEpisode[index];
            break;
        }
    }
    if (nowEpisode == null) {
        return "";
    }
    var dateTxt = nowEpisode.ActDate;
    var dtArr = dateTxt.split("-");
    var dt = new Date(dtArr[0], parseInt(dtArr[1], 10) - 1, dtArr[2]);
    var weekDay = dt.getDay();
    var weekDayTxt = "";
    switch (weekDay) {
        case 0: weekDayTxt = $g("(日)"); break;
        case 1: weekDayTxt = $g("(一)"); break;
        case 2: weekDayTxt = $g("(二)"); break;
        case 3: weekDayTxt = $g("(三)"); break;
        case 4: weekDayTxt = $g("(四)"); break;
        case 5: weekDayTxt = $g("(五)"); break;
        case 6: weekDayTxt = $g("(六)"); break;
    }
    var hourTxt = nowEpisode.ActTime;
    var hour = parseInt(hourTxt.split(":")[0],10);
    var timeTxt = "";
    if (hour <= 5) {
        timeTxt = $g("凌");
    }
    else if (hour <= 12) {
        timeTxt = $g("上");
    }
    else if (hour <= 18) {
        timeTxt = $g("下");
    }
    else {
        timeTxt = $g("晚");
    }
    return websys_formatDate(dateTxt) + " " + weekDayTxt + " " + timeTxt+(nowEpisode.PAADMType=="E"?" [急]":"");
}
///=============================日期时相关  END===============================

///=============================折线图相关===============================
function drawPoint(ctx ,x,y,color,text) {
    ctx.fillStyle=color;
    ctx.fillRect(x-2,y-2,4,4);
    ctx.font = "12px 宋体";
    ctx.fillText(text,x,y);
}
function drawDashedLine(ctx,sx,sy,tx,ty,color,lineWidth,dashLen){
    var len = cacuDis(sx,sy,tx,ty),
        lineWidth = lineWidth || 1,
        dashLen = dashLen || 5,
        num = ~~(len / dashLen);
    ctx.beginPath();
    for(var i=0;i<num;i++){
        var x = sx + (tx - sx) / num * i,
            y = sy + (ty - sy) / num * i;
        ctx[i & 1 ? "lineTo" : "moveTo"](x,y);
    }
    //ctx.closePath();
    ctx.lineWidth = lineWidth;
    ctx.strokeStyle = color;
    ctx.stroke();
    function cacuDis(sx,sy,tx,ty){
        return Math.sqrt(Math.pow(tx-sx,2)+Math.pow(ty-sy,2));
    }
}
function fillCurveHeader(dom,config){
    var totalHeight=(config.stepCount+1)*config.stepHeight;
    $(dom).height(totalHeight)
    var html='<table class="CurveHeaderTable" border="0" cellpadding="0" cellspacing="0" ><tr>';
    $.each(config.lines,function(){
        html+='<td style="color:'+this.color+';line-height:'+config.stepHeight+'px">'+this.text+'</td>';
    })
    html+='</tr>';
    for(var i=0;i<config.stepCount;i++){
        html+='<tr>';
        $.each(config.lines,function(){
            var text=this.start+this.step*(config.stepCount-i-1);
            html+='<td style="color:'+this.color+';line-height:'+config.stepHeight+'px">'+text+'</td>';
        })
        html+='</tr>';
    }
    html+='</table>';
    //$(dom).html(html);
    $(dom).find('table.CurveHeaderTable').remove();
    $(dom).append(html);
}
function fillCurveBody(dom,config,data){
    var totalHeight=(config.stepCount+1)*config.stepHeight;
    $(dom).height(totalHeight);
    var totalWidth=$(dom).width();
    if (!$(dom).is(':visible')){
	    totalWidth=GV.dayWidth*7;
	}
	//console.log('totalWidth',totalWidth);

    var canvas=document.createElement('canvas');
    $(dom).empty().append(canvas);
    var ctx = canvas.getContext("2d");
    canvas.width=totalWidth;
    canvas.height=totalHeight;

    //先画网格线
    for(var i=0;i<=config.stepCount;i++){
        var y=config.stepHeight/2+i*(config.stepHeight);
        drawDashedLine(ctx,0,y,totalWidth,y,'#ddd',1,3);
    }
    for(var i=1;i<6*7;i++){
        var x=i/6/7*totalWidth;
        if (i%6==0){
            x=x-0.5;
            ctx.beginPath();
            ctx.moveTo(x,0);
            ctx.lineTo(x,totalHeight);
            //ctx.closePath();
            ctx.lineWidth = 1;
            ctx.strokeStyle = '#ddd';
            ctx.stroke();
        }else{
            drawDashedLine(ctx,x,0,x,totalHeight,'#ddd',1,3);
        }
    }
    //画数据

    var searchDate=data.searchDate;
    for(var i=0;i<config.lines.length;i++){
        var line=config.lines[i];
        var item={color:line.color,points:[]};
        var DataTypeCode=line.DataTypeCode;
        for (var j=0;j<data.DataArray.length;j++){
            if (data.DataArray[j].DataTypeCode==DataTypeCode) {
                for (var k=0;k<data.DataArray[j].records.length;k++){
                    var r=data.DataArray[j].records[k];
                    var x=calSeconds(searchDate,"00:00",r.ActDate,r.ActTime)/(7*24*60*60)*totalWidth;
                    var y=config.stepHeight/2+config.stepCount*config.stepHeight - (r.DataValue-line.start)/line.step*config.stepHeight;
                    item.points.push({x:x,y:y,text:r.DataValue})
                }
            }
        }
        item.points.sort(function(o1,o2){
            return o1.x<o2.x?"-1":1;
        })
        //console.log(item)
        if (item.points.length>0){
            ctx.beginPath();
            for (var k=0;k<item.points.length;k++){
                if (k==0) {
                    ctx.moveTo(item.points[k].x,item.points[k].y);
                }else{
                    ctx.lineTo(item.points[k].x,item.points[k].y);
                }
                
            }
            //ctx.closePath();
            ctx.lineWidth = 1;
            ctx.strokeStyle = item.color;
            ctx.stroke();
        }
        //画点
        for (var k=0;k<item.points.length;k++){
            drawPoint(ctx,item.points[k].x,item.points[k].y,item.color,item.points[k].text);
        }
    }

}
///=============================折线图相关  END===============================




var getTokenUrl=function(url){
	
	if(typeof url=='string' && url.indexOf('.csp')>-1) {
		var token='';
		if(typeof websys_getMWToken=='function' ){
			token= websys_getMWToken();
		}
		
		if (token) {
			var arr=url.split('#');
			ind=arr[0].indexOf('MWToken=')
			if (ind>-1) {
				var ind2=arr[0].indexOf('&',ind) //MWToken=后第一个&符
				if(ind2>-1){
					arr[0]=arr[0].slice(0,ind)+'MWToken='+token+arr[0].slice(ind2);
				}else{
					arr[0]=arr[0].slice(0,ind)+'MWToken='+token;
				}
				
			}else{
				arr[0]=arr[0]+(arr[0].indexOf('?')>-1?'&':'?')+'MWToken='+token; 
			}
			
			url=arr.join('#');
			
		}
		

	}
	
	//alert('getTokenUrl:'+url)
	
	return url;
}


//打开窗口 本窗口可能是已经是一个window了，打开的要比现在的小一点 (套娃窗口)
// opts.left  opts.top  偏移量
function openRussianDollWin(url,opts){
	//IE11 window.screenX
	var x=(typeof window.screenX=="number")?window.screenX:window.screenLeft; 
	var y=(typeof window.screenY=="number")?window.screenY:window.screenTop; 
	var winWidth=$(window).width();
	var winHeight=$(window).height();
	if (window.name=="TRAK_main"){ 
		var pWin=parent.window
		x=(typeof pWin.screenX=="number")?pWin.screenX:pWin.screenLeft; 
		y=(typeof pWin.screenY=="number")?pWin.screenY:pWin.screenTop; 
		winWidth=pWin.$(pWin).width();
		winHeight=pWin.$(pWin).height();
	}else if(window.parent && window.parent!=window) {
		var x=0,
		left=0,
		winWidth=screen.availWidth-20;
		winHeight=screen.availHeight-40;
	}
	
	var maxLeft=Math.max(parseInt((winWidth-500)/2),0);
	var maxTop=Math.max(parseInt((winHeight-300)/2),0);
	if (typeof opts.left=="undefined") opts.left="2%";
	if (typeof opts.top=="undefined") opts.top="4%";
	if (opts.left.indexOf('%')){
		opts.left=parseInt(winWidth*parseFloat(opts.left)*0.01);
	}
	opts.left=Math.min(maxLeft,opts.left);
	if (opts.top.indexOf('%')){
		opts.top=parseInt(winWidth*parseFloat(opts.top)*0.01);
	}
	opts.top=Math.min(maxTop,opts.top);
	opts.width=winWidth-2*opts.left;
	opts.height=winHeight-2*opts.top;
	opts.top+=y;
	opts.left+=x;
	
	if(typeof cefbound == 'object') { //医为浏览器
		opts.left-=10;
		opts.top-=31;
		opts.width-=6;
		opts.height-=113;
		
	}
	
	url=getTokenUrl(url);
	
	return window.open(url, opts.name||'', 'height='+opts.height+',width='+opts.width+',top='+opts.top+',left='+opts.left+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes');
	
}


//weekselector
(function($){
	function initWeekselector(target){
		var state=$.data(target,'weekselector');
		var opts=state.options;
		var bb={};
		$(target).addClass('weekselector').html("<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr></tr></table>");
		var tr=$(target).find('tr');
		bb.prev_more=appendBtn('prev_more');
		bb.prev_one=appendBtn('prev_one');
		if (opts.beforeText!=""){
			$('<td class="weekselector-bt-td"><span >'+opts.beforeText+'</span></td>').appendTo(tr);
		}
        var wl = $("<select ></select>");
        wl.bind("change", function () {
	        var days=((parseInt($(this).val())||1)-1)*7;
	        var tDate=moveDay(opts.basicDate,days);
	        if (calDays(opts.startDate,tDate)<0) tDate=opts.startDate;
	        $(target).weekselector('select',tDate);
        });
	    
	    if(opts.weekMode==2){  //周日为一周开始
			var weekday=getWeekDay(opts.startDate);
			var index="日一二三四五六".indexOf(weekday);
			opts.basicDate=moveDay(opts.startDate,-index);
			
		}else if(opts.weekMode==3){  //周一为一周开始
			var weekday=getWeekDay(opts.startDate);
			var index="一二三四五六日".indexOf(weekday);
			opts.basicDate=moveDay(opts.startDate,-index);
		}else{
			opts.basicDate=opts.startDate;
		}
		
		var days=calDays(opts.basicDate,opts.endDate);
		var weeks=Math.floor(days/7)+1;
		
        for (var i = 1; i <= weeks; i++) {
            $("<option></option>").text(i).appendTo(wl);
        }
        
        $("<td></td>").append(wl).appendTo(tr);
        wl.wrap("<div class=\"weekselector-week-list\"></div>");
		
		if (opts.afterText!=""){
			$('<td class="weekselector-at-td"><span>'+opts.afterText+'</span></td>').appendTo(tr);
		}
		bb.weeklist=wl;
		bb.next_one=appendBtn('next_one');
		bb.next_more=appendBtn('next_more');
		state.bb=bb;
		if (!opts.currentDate){
			opts.currentDate=moveDay(opts.endDate,-6);
		}
		selectDate(target,opts.currentDate);
		function appendBtn(k){
			var btn = opts.nav[k];
			var a=$('<a class="weekselector-btn" href="javascript:void(0)"></a>').appendTo(tr);
			a.wrap('<td class="weekselector-btn-td"></td>');
	        a.addClass(btn.iconCls).unbind(".weekselector").bind("click.weekselector", function () {
		        if($(this).hasClass('disabled')) return false;
	            btn.handler.call(target);
	        });
	        return a ;
		}

	}
	function selectDate(target,date){
		var state=$.data(target,'weekselector');
		var opts=state.options;
		var bb=state.bb;
		if (calDays(opts.startDate,opts.endDate)>6){
			if (calDays(opts.startDate,date)>0){  //没超过最小的那个日期
				bb.prev_more.removeClass('disabled');
				bb.prev_one.removeClass('disabled');
			}else{
				bb.prev_more.addClass('disabled');
				bb.prev_one.addClass('disabled');
				date=opts.startDate;
			}
			if (calDays(opts.endDate,date)<0){  //没超过最小的那个日期
				bb.next_more.removeClass('disabled');
				bb.next_one.removeClass('disabled');
			}else{
				bb.next_more.addClass('disabled');
				bb.next_one.addClass('disabled');
				date=opts.endDate;
			}
		}else{
			bb.prev_more.addClass('disabled');
			bb.prev_one.addClass('disabled');
			bb.next_more.addClass('disabled');
			bb.next_one.addClass('disabled');
			date=opts.startDate;
		}

		
		//计算显示为第几周
		var days=calDays(opts.basicDate,date);
		var week=Math.floor(days/7)+1;
		bb.weeklist.find("option").eq(week-1).prop("selected",true);
			
		if (date!=opts.currentDate){
			var oldDate=opts.currentDate;
			opts.currentDate=date;
			opts.onChange.call(target,date,oldDate);
		}

	}
    $.fn.weekselector = function (options, param) {
        if (typeof options == "string") {
            var fn = $.fn.weekselector.methods[options];
            return fn(this, param);
            
        }
        options = options || {};
        return this.each(function () {
            var state = $.data(this, "weekselector");
            if (state) {
                $.extend(state.options, options);
            } else {
                $.data(this, "weekselector", {
                    options: $.extend({}, $.fn.weekselector.defaults, $.fn.weekselector.parseOptions(this), options)
                });
            }
            initWeekselector(this);
        });
    };
    $.fn.weekselector.methods = {
        options: function (jq) {
            return $.data(jq[0], "weekselector").options;
        },select:function(jq,date){
	        jq.each(function(){
		    	selectDate(this,date);
		    })
	    },getValue:function(jq){  //value是date
		    return $.data(jq[0], "weekselector").options.currentDate;
		}
    };
    $.fn.weekselector.parseOptions = function (target) {
        var t = $(target);
        return $.extend({}, $.parser.parseOptions(target, ["width","height"]));
    };
    $.fn.weekselector.defaults = {
	    beforeText:'第',
	    afterText:'周',
	    weekMode:'',  //第几周判断逻辑 1.startDate,startDate+6 为第一周   2. 周六为一周结束 startDate - 第一个周六 为第一周  3. 周日为一周结束 startDate - 第一个周日 为第一周,
	    nav:{
		    prev_more:{
				iconCls:'weekselector-prev-more'  ,
				handler:function(){
					var opts=$(this).weekselector('options');
					var tDate=moveDay(opts.currentDate,-7);
					$(this).weekselector('select',tDate);
				} 
			},
			prev_one:{
				iconCls:'weekselector-prev-one'  ,
				handler:function(){
					var opts=$(this).weekselector('options');
					var tDate=moveDay(opts.currentDate,-1);
					$(this).weekselector('select',tDate);
				} 
			},
			next_one:{
				iconCls:'weekselector-next-one'  ,
				handler:function(){
					var opts=$(this).weekselector('options');
					var tDate=moveDay(opts.currentDate,1);
					$(this).weekselector('select',tDate);
				} 
			},
			next_more:{
				iconCls:'weekselector-next-more'  ,
				handler:function(){
					var opts=$(this).weekselector('options');
					var tDate=moveDay(opts.currentDate,7);
					$(this).weekselector('select',tDate);
				} 
			}
		},
        onChange:function(){}
    };
})(jQuery);

//arrayselector  数组选择  理论上和weekselector 差不多概念
(function($){
	function initArrayselector(target){
		var state=$.data(target,'arrayselector');
		var opts=state.options;
		var bb={};
		$(target).addClass('arrayselector').html("<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\"><tr></tr></table>");
		var tr=$(target).find('tr');
		bb.prev_more=appendBtn('prev_more');
		bb.prev_one=appendBtn('prev_one');
		if (opts.tipText!=""){
			$("<td style=\"text-align:center;line-height:25px;\"><span >"+opts.tipText+"</span></td>").appendTo(tr);
		}
		bb.next_one=appendBtn('next_one');
		bb.next_more=appendBtn('next_more');
		state.bb=bb;
		if (!(opts.currentIndex>=0)){
			opts.currentIndex=Math.max(opts.data.length-7,0);
		}
		
		select(target,opts.currentIndex);
		function appendBtn(k){
			var btn = opts.nav[k];
			var a=$('<a class="arrayselector-btn" href=\"javascript:void(0)\"></a>').appendTo(tr);
			a.wrap('<td class="arrayselector-btn-td"></td>');
	        a.addClass(btn.iconCls).unbind(".arrayselector").bind("click.arrayselector", function () {
	            if($(this).hasClass('disabled')) return false;
	            btn.handler.call(target);
	        });
	        return a ;
		}
	}
	function select(target,index){
		var state=$.data(target,'arrayselector');
		var opts=state.options;
		var bb=state.bb;
		
		if (opts.data.length>7){
			if (index>0){  //没超过最小的那个日期
				bb.prev_more.removeClass('disabled');
				bb.prev_one.removeClass('disabled');
			}else{
				bb.prev_more.addClass('disabled');
				bb.prev_one.addClass('disabled');
				index=0;
			}
			if (index<opts.data.length-7){  
				bb.next_more.removeClass('disabled');
				bb.next_one.removeClass('disabled');
			}else{
				bb.next_more.addClass('disabled');
				bb.next_one.addClass('disabled');
				index=opts.data.length-7;
			}
		}else{
			bb.prev_more.addClass('disabled');
			bb.prev_one.addClass('disabled');
			bb.next_more.addClass('disabled');
			bb.next_one.addClass('disabled');
			index=0;
		}
		if (index!=opts.currentIndex){
			var oldIndex=opts.currentIndex;
			opts.currentIndex=index;
			opts.onChange.call(target,index,oldIndex);
		}

	}
    $.fn.arrayselector = function (options, param) {
        if (typeof options == "string") {
            var fn = $.fn.arrayselector.methods[options];
            return fn(this, param);
            
        }
        options = options || {};
        return this.each(function () {
            var state = $.data(this, "arrayselector");
            if (state) {
                $.extend(state.options, options);
            } else {
                $.data(this, "arrayselector", {
                    options: $.extend({}, $.fn.arrayselector.defaults, $.fn.arrayselector.parseOptions(this), options)
                });
            }
            initArrayselector(this);
        });
    };
    $.fn.arrayselector.methods = {
        options: function (jq) {
            return $.data(jq[0], "arrayselector").options;
        },select:function(jq,index){
	        jq.each(function(){
		    	select(this,index);
		    })
	    },getValue:function(jq){  //value是数组index
		    return $.data(jq[0], "arrayselector").options.currentIndex;
		}
    };
    $.fn.arrayselector.parseOptions = function (target) {
        var t = $(target);
        return $.extend({}, $.parser.parseOptions(target, ["width","height"]));
    };
    $.fn.arrayselector.defaults = {
	    tipText:'就诊',
	    nav:{
		    prev_more:{
				iconCls:'arrayselector-prev-more'  ,
				handler:function(){
					var opts=$(this).arrayselector('options');
					$(this).arrayselector('select',opts.currentIndex-7);
				} 
			},
			prev_one:{
				iconCls:'arrayselector-prev-one'  ,
				handler:function(){
					var opts=$(this).arrayselector('options');
					$(this).arrayselector('select',opts.currentIndex-1);
				} 
			},
			next_one:{
				iconCls:'arrayselector-next-one'  ,
				handler:function(){
					var opts=$(this).arrayselector('options');
					$(this).arrayselector('select',opts.currentIndex+1);
				} 
			},
			next_more:{
				iconCls:'arrayselector-next-more'  ,
				handler:function(){
					var opts=$(this).arrayselector('options');
					$(this).arrayselector('select',opts.currentIndex+7);
				} 
			}
		},
        onChange:function(){}
    };
})(jQuery);

//select2 基于浏览器原生select 实现简易select2
(function($){
	function initSelect2(target){
		var state=$.data(target,'select2');
		var opts=state.options;
		var data=opts.data;

		$(target).addClass("select2-f").hide();
		var select2=$('<div class="select2"></div>').insertAfter($(target));
        var select = $("<select ></select>");
        select.bind("change", function () {
	        var val=$(this).val();
	        $(target).select2('select',val);
        });

        for (var i = 0; i < data.length; i++) {
	        var item=data[i];
	        var option=$("<option></option>");
	        if (typeof item=="object"){
		        option.text(item[opts.textField||'text']||'')
		    }else{
			    option.text(item);
			}
	        option.val(i).appendTo(select);
        }
        select.appendTo(select2);   
        opts.proxy=select2;
        
        var val=$(target).val()||$(target).text();
        if (val!=""){
	        $(target).select2('setText',val);
	    }
	    //
	    var tWidth=select.width();
	    select.width(tWidth+20);
	    if($.isIE){
		    select2.width(tWidth);
	    }else{
		    select2.width(tWidth+20);
		}
        
	}
	function select(target,index){
		//console.log('select');
		var state=$.data(target,'select2');
		var opts=state.options;
		var data=opts.data; 
		var oldValue=state.currentValue;
		var newValue=opts.data[index];
		opts.currentValue=newValue;
		opts.onChange.call(target,newValue,oldValue);
		opts.proxy.find('select>option').eq(index).prop('selected',true);
	}
	function setText(target,text){
		var state=$.data(target,'select2');
		var opts=state.options;
		var data=opts.data;
		var tIndex;
		$.each(data,function(idx){
			var item=this;
			if ((typeof item=="object" && text==item[opts.textField])||(typeof item=="string"&&text==item)){
				opts.currentValue=item;
				opts.proxy.find('select>option').eq(idx).prop('selected',true);
				return false;
			}
		})
		
		
	}
    $.fn.select2 = function (options, param) {
        if (typeof options == "string") {
            var fn = $.fn.select2.methods[options];
            return fn(this, param);
            
        }
        options = options || {};
        return this.each(function () {
            var state = $.data(this, "select2");
            if (state) {
                $.extend(state.options, options);
            } else {
                $.data(this, "select2", {
                    options: $.extend({}, $.fn.select2.defaults, $.fn.select2.parseOptions(this), options)
                });
            }
            initSelect2(this);
        });
    };
    $.fn.select2.methods = {
        options: function (jq) {
            return $.data(jq[0], "select2").options;
        },select:function(jq,index){
	        jq.each(function(){
		    	select(this,index);
		    })
	    },getValue:function(jq){
		    return $.data(jq[0], "select2").options.currentValue;
		},setText:function(jq,text){
			jq.each(function(){
		    	setText(this,text);
		    })
		}
    };
    $.fn.select2.parseOptions = function (target) {
        var t = $(target);
        return $.extend({}, $.parser.parseOptions(target, ["width","height"]));
    };
    $.fn.select2.defaults = {
        onChange:function(){},
        data:[],
        textField:'text'
    };
})(jQuery);


function easyModal(title,url,width,height,onClose){
	var maxWidth=$(window).width(),maxHeight=$(window).height();
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+height||'80%',height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var $easyModal=$('#dhcmessage-easyModal');
	if ($easyModal.length==0){
		$easyModal=$('<div id="dhcmessage-easyModal" style="overflow:hidden;" ><iframe name="dhcmessage-easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
	}
	
	url=getTokenUrl(url);
	
	$easyModal.find('iframe').attr('src',url);
	$easyModal.dialog({
		iconCls:'icon-w-paper',
		modal:true,
		title:title,
		width:width,
		height:height
		,onClose:function(){
			if (typeof onClose=='function'){
				onClose();
			}
			$easyModal.find('iframe').attr('src','about:blank');
		}
	}).dialog('open').dialog('center');
	
}




/// 采用window.open打开窗口
function easyOriginWin(winname,url,width,height){
	winname=winname||'_blank';
	if (window.originWins && window.originWins[winname] && winname!='_blank' ) {
		try{
			window.originWins[winname].close();
		}catch(e){}	
	}
	if (!window.originWins) window.originWins={};
	
	var maxWidth=screen.availWidth-20;
	var maxHeight=screen.availHeight-40;
	
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var l=parseInt((maxWidth-width)/2),t=parseInt((maxHeight-height)/2);	
	
	if(typeof cefbound == 'object') { //医为浏览器
		l-=10;
		t-=31;
		width-=6;
		height-=113;
	}
			
	var features='top='+t+',left='+l+',width='+width+',height='+height+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
	
	url=getTokenUrl(url);
	
	window.originWins[winname]=window.open(url,winname,features);
	return window.originWins[winname];
}


