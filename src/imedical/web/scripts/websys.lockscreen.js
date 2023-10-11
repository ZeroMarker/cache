//jquery.cookie.js
;(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // CommonJS
        factory(require('jquery'));
    } else {
        // Browser globals
        factory(jQuery);
    }
}(function ($) {
    var pluses = /\+/g;
    function encode(s) {
        return config.raw ? s : encodeURIComponent(s);
    }
    function decode(s) {
        return config.raw ? s : decodeURIComponent(s);
    }
    function stringifyCookieValue(value) {
        return encode(config.json ? JSON.stringify(value) : String(value));
    }
    function parseCookieValue(s) {
        if (s.indexOf('"') === 0) {
            // This is a quoted cookie as according to RFC2068, unescape...
            s = s.slice(1, -1).replace(/\\"/g, '"').replace(/\\\\/g, '\\');
        }
        try {
            // Replace server-side written pluses with spaces.
            // If we can't decode the cookie, ignore it, it's unusable.
            // If we can't parse the cookie, ignore it, it's unusable.
            s = decodeURIComponent(s.replace(pluses, ' '));
            return config.json ? JSON.parse(s) : s;
        } catch(e) {}
    }
    function read(s, converter) {
        var value = config.raw ? s : parseCookieValue(s);
        return $.isFunction(converter) ? converter(value) : value;
    }
    var config = $.cookie = function (key, value, options) {
        // Write
        if (value !== undefined && !$.isFunction(value)) {
            options = $.extend({}, config.defaults, options);
            if (typeof options.expires === 'number') {
                var days = options.expires, t = options.expires = new Date();
                t.setTime(+t + days * 864e+5);
            }
            return (document.cookie = [
                encode(key), '=', stringifyCookieValue(value),
                options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
                options.path    ? '; path=' + options.path : '',
                options.domain  ? '; domain=' + options.domain : '',
                options.secure  ? '; secure' : ''
            ].join(''));
        }
        // Read
        var result = key ? undefined : {};
        // To prevent the for loop in the first place assign an empty array
        // in case there are no cookies at all. Also prevents odd result when
        // calling $.cookie().
        var cookies = document.cookie ? document.cookie.split('; ') : [];
        for (var i = 0, l = cookies.length; i < l; i++) {
            var parts = cookies[i].split('=');
            var name = decode(parts.shift());
            var cookie = parts.join('=');

            if (key && key === name) {
                // If second argument (value) is a function it's a converter...
                result = read(cookie, value);
                break;
            }
            // Prevent storing a cookie that we couldn't decode.
            if (!key && (cookie = read(cookie)) !== undefined) {
                result[name] = cookie;
            }
        }
        return result;
    };
    config.defaults = {};
    $.removeCookie = function (key, options) {
        if ($.cookie(key) === undefined) {
            return false;
        }
        // Must not alter options, thus extending a fresh object...
        $.cookie(key, '', $.extend({}, options, { expires: -1 }));
        return !$.cookie(key);
    };
}));
//websys.lockscreen.js
;(function($,w){
	var xy1="",xy2="",xy3="";
	var html = '<div class="alert alert-block popup-alert-warning alert-error lockScreen lock_screen_area" style="display:none">'
		+'<iframe frameborder="0" tabindex="-1" src="javascript:false;" style="display:block;position:absolute;z-index:-1;filter:Alpha(Opacity=0);opacity:0;top:0px;left:0px;width:100%;height:100%;"/></iframe>'
			+'<div class="login_carousel" style="height: 100%;">'
			+'<div id="carousel-example-generic" class="carousel_200 carousel slide login_carousel_picture" data-ride="carousel" style="height: 100%;">'
			+'<ol class="carousel-indicators login_indicators">'
			+'<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>'
						+'<li data-target="#carousel-example-generic" data-slide-to="1"></li>'
						+'<li data-target="#carousel-example-generic" data-slide-to="2"></li>'
					+'</ol>'
					+'<div class="carousel-inner" role="listbox">'
						+'<div class="item active"> <div class="in_img img1"></div> </div>'
						+'<div class="item"> <div class="in_img img2"></div> </div>'
						+'<div class="item"> <div class="in_img img3"></div> </div>'
					+'</div>'
					+'<a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">'
						+'<i class="fa fa-chevron-left" aria-hidden="true"></i>'
						+'<span class="sr-only">Previous</span>'
					+'</a>'
					+'<a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">'
						+'<i class="fa fa-chevron-right" aria-hidden="true"></i>'
						+'<span class="sr-only">Next</span>'
					+'</a>'
				+'</div>'
			+'</div>'
		+'<div>'
			+'<div>'
				+'<div class="iconLock">'+w.username+'</div>'
				+'<form class="form-horizontal row">'
				   	+'<div class="form-group col-sm-12">'
						+'<input type="text" name="notautosubmit" style="display:none"/>'
					  	+'<input class="form-control password_value_zl" type="password" placeholder="请输入密码解锁" />'
					  	+'<div class="verifyPassword_zl"><a class="iconLockOpen"></a></div>'
					+'</div>'
					+'<div class="time">'
						+'<div class="z-time"></div>'
						+'<div class="z-dateweek">'
							+'<div class="date"></div>'
							+'<div class="week"></div>'
						+'</div>'
					+'</div>'
				+'</form>'
			+'</div>'
		+'</div>'
    +'</div>';
	var timer_zl;
	var delay_zl=(w.timeout/3)*1000; //3*60*1000; //每5分钟拿一次xy
	var MWToken = "";
	if ("function"==typeof websys_getMWToken) MWToken=websys_getMWToken();
	var cobj;
	function showLockScrn(show) {
		cobj = $(".lock_screen_area");
		if (cobj.length==0){
			cobj = $(html).appendTo('body');
		}
		if(show){
			clearInterval(timer_zl);
			$(".lock_screen_area .in_img").backgroundcover({});
			startSetTime();
			$(".password_value_zl").val(""); //清空密码
			windowNPAPITotal=200;
			findEditorFrame(window,true);
			cobj.show();
			document.oncontextmenu = function(){
				event.returnValue = false;
				return false;
			}
		}else{
			startInterval();
			windowNPAPITotal=200;
			findEditorFrame(window,false);
			cobj.hide();
			document.oncontextmenu = null;
			if (window.ShowDHCMessageCount) ShowDHCMessageCount();
		}
	}
	function lockScrn() {
		if($.cookie('lockscreen-'+MWToken)==1){
		}else{
			$.cookie('lockscreen-'+MWToken,1);
			showLockScrn(true);
		}
	}
	function handlerMouse(){
		var xy = "";
		if (typeof cefbound != "undefined") {
			xy = cefbound.getMousePoint();
		}else{
			
		}
		if(xy1==""){ //browsertools.library.js
			xy1 = xy;
		}else if(xy2==""){
			xy2 = xy;
		}else if(xy3==""){
			xy3 = xy;
		}
		if(xy1!="" & xy2!="" && xy3!=""){	
			if (xy1==xy2 && xy2==xy3){
				//console.log("没动鼠标");
				lockScrn();
			}else{
				xy1 = xy2;
				xy2 = xy3;
				xy3 = xy;
			}
		}
	}
	function startInterval() {
		xy1="",xy2="",xy3="";
	    if (delay_zl>0) timer_zl = setInterval(handlerMouse, delay_zl);
	}
	if($.cookie('lockscreen-'+MWToken)==1){
		showLockScrn(true);
	}else{
		startInterval();
	}
	function isValid(){
		var rtnObj = {success:false,msg:"密码错误"};
		var psw = $(".password_value_zl").val();
		var encpsw = "";
		if ('string'==typeof isValidUserEncypt){
			var FIXKEY="ABCDEF0123456789";
			var sid = ""+Math.ceil(Math.random()*100000);
			var k = FIXKEY+(sid-1),l=sid.length;
			var encpsw = e7(psw,k.slice(l));
		}
		if (MWToken==""){
			if (true){ // old password, old project
				var enpsw = hex_md5(dhc_cacheEncrypt(psw));
				enpsw=enpsw+w.encodeKey;
				enpsw = hex_md5(enpsw);
				if(enpsw==w.popsw){
					rtnObj.success = true;
					return rtnObj;
				}
			}
			/*new password version*/
			if ('string'==typeof isValidUserEncypt){
				var rtn = $m({EncryItemName:isValidUserEncypt,username:session['LOGON.USERCODE'], password:encpsw, overrideauthentication:0, RSID:sid},false);
				if (parseInt(rtn)>0){rtnObj.success = true;return rtnObj;};				
			}
		}else{
			if ('string'==typeof isValidUserEncypt){
				var dtosess = {};
				for(var p in session){
					if (session.hasOwnProperty(p)){
						dtosess["dto."+p.replace('.','').replace('_','')] = session[p];
					}
				}
				var data={ClassName:"BSP.SYS.SRV.Token",MethodName:"ReLogon","dto.password":encpsw,"dto.RSID":sid,dataType:'json',"dto.UUID":MWToken};
				data = $.extend(dtosess,data)
				var rtn = $cm(data,false);
				if (rtn && rtn.success > 0) {
					rtnObj.success = true; rtnObj.msg = rtn.msg; return rtnObj;
				} else {
					rtnObj.msg = rtn.msg;
				}
			}
		}
		return rtnObj;
	}
	function lockOpenBtnClick(){
		var obj = isValid();
		if (obj.success) {
			//password validate success
			//$.cookie('lockscreen'+MWToken,0);
			$.removeCookie('lockscreen-'+MWToken);
			showLockScrn(false);
		}else{
			alert(obj.msg);
		}
	}
	$(document).on("keydown",".password_value_zl",function(e){
		if(e.keyCode==13){  //MediWay.exe->e.key=undefined
			lockOpenBtnClick();
		}
	}).on("click",'.iconLockOpen',function(e){
		lockOpenBtnClick();
	});
	function startSetTime(){
		function p(s) {
			return s < 10 ? '0' + s: s;
		}
		function setTime(){
			var myDate = new Date();
			//获取当前年
			var year=myDate.getFullYear();
			//获取当前月
			var month=myDate.getMonth()+1;
			//获取当前日
			var date1=myDate.getDate(); 
			var h=myDate.getHours();       //获取当前小时数(0-23)
			var m=myDate.getMinutes();     //获取当前分钟数(0-59)
			var s=myDate.getSeconds();  
			var now=year+'-'+p(month)+"-"+p(date1)+" "+p(h)+':'+p(m)+":"+p(s);
			var date = p(month)+"/"+p(date1) + '/' + year ; 
			var day = new Date(Date.parse(date));   //需要正则转换的则 此处为 ： var day = new Date(Date.parse(date.replace(/-/g, '/')));  
			var today = new Array('星期日','星期一','星期二','星期三','星期四','星期五','星期六');  
			var week = today[day.getDay()];  
			cobj.find(".z-time").text(p(h)+':'+p(m));
			cobj.find(".z-dateweek .date").text(p(month)+"月"+p(date1) + "日");
			cobj.find(".z-dateweek .week").text(week);
			
		}
		setTime();
		setInterval(setTime,60000);
	}
	w.userOperation = function(){
		xy1="",xy2="",xy3=""; //clearInterval(timer_zl);
		//timer_zl = setInterval(handlerMouse, delay_zl);
		return true;
	};
	w.lockScrn = lockScrn;
})(jQuery,lockScreenOpt);