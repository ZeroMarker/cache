

//跑马灯显示消息 依赖jQuery

/*实现一个跑马灯jquery-easyui插件
* 数据取远程数据 用easyui datagrid 格式数据 {rows:[],total:0}
* itemFormatter:function(row,ind){return xxx};
* onClickItem:function(row,ind){} 
*/
;(function ($) {
	function loadStyleText(cssText){
		var style = document.createElement('style');
		style.type = 'text/css';
		style.innerHTML=cssText
		document.getElementsByTagName('head').item(0).appendChild(style);
	}
	var cssLoaded=false
	
	//Functions
	function init(target){
		if (!cssLoaded){
			loadStyleText('\
			.marquee {\
				line-height: 28px;\
				height:28px;\
				padding:0;\
				border: 1px solid transparent;\
				border-radius: 4px;\
				color: #3c763d;\
				background-color: #dff0d8;\
				border-color: #d6e9c6;\
				position:absolute;\
				z-index:5000;\
			}\
			.marquee.marquee-vertical{\
				height:auto;\
			}\
			.marquee-mask {\
				position:absolute;\
				z-index:4999;\
			}\
			.marquee .marquee-button{\
				position:absolute;\
				bottom:0;\
				width:28px;\
				text-align:center;\
				font-weight:700;\
				color: #3c763d;\
				background-color: #dff0d8;\
				vertical-align: middle;\
				font-size:0;\
				cursor:pointer;\
			}\
			.marquee .marquee-button .marquee-count{\
				display: inline-block;\
				line-height: 0.9;\
				padding: 3px;\
				color: #ffffff;\
				background-color: red;\
				font-size: 12px;\
				font-weight: 700;\
				text-align: center;\
				white-space: nowrap;\
				vertical-align: middle;\
				border-radius: 10px;\
			}\
			.marquee.marquee-vertical .marquee-button{\
				bottom:0;\
			}\
			.marquee.marquee-left .marquee-button{\
				left:0;\
			}\
			.marquee.marquee-right .marquee-button{\
				right:0;\
			}\
			.marquee.marquee-vertical .marquee-header {\
				height:29px;\
				line-height:29px;\
				font-weight:bold;\
				padding-left:10px;\
				border-bottom:1px solid #ddd;\
				position:relative;\
			}\
			.marquee-toolbar{\
				position:absolute;\
				top:0;\
				right:0;\
				width:auto;\
				padding-right:10px;\
			}\
			.marquee-toolbar a{\
				display:inline-block;\
				width:18px;\
				height:18px;\
				text-align:center;\
				line-height:18px;\
				font-weight:900;\
				border-radius:3px;\
				font-size:18px;\
			}\
			.marquee-toolbar-min{\
				color:red;\
			}\
			.marquee-toolbar-min:hover{\
				color:white;\
				background-color:red;\
			}\
			.marquee-toolbar a:hover{\
				color:white;\
				background-color:red;\
			}\
			.marquee .marquee-content{\
				margin:0 5px ;\
				height:28px;\
				line-height:28px;\
				overflow:hidden;\
				background-color: #dff0d8;\
			}\
			.marquee.marquee-vertical .marquee-content{\
				overflow-y:auto;\
			}\
			.marquee.marquee-left .marquee-content{\
				padding:0 10px 0 38px;\
			}\
			.marquee.marquee-right .marquee-content{\
				padding:0 38px 0 10px;\
			}\
			.marquee.marquee-vertical.marquee-left .marquee-content{\
				padding:0 0px 0 0px;\
			}\
			.marquee.marquee-vertical.marquee-right .marquee-content{\
				padding:0 0px 0 0px;\
			}\
			.marquee .marquee-content .marquee-content-inner{\
				width:100000px;\
				white-space: nowrap;\
				word-break: keep-all;\
			}\
			.marquee .marquee-content .marquee-content-item{\
				width:auto;\
				display:inline;\
				padding:0 10px;\
				height:28px;\
				line-height:28px;\
				cursor:pointer;\
				vertical-align: middle;\
			}\
			.marquee.marquee-vertical .marquee-content .marquee-content-inner{\
				width:100%;\
				white-space: nowrap;\
				word-break: keep-all;\
			}\
			.marquee.marquee-vertical .marquee-content .marquee-content-item{\
				display:block;\
				padding:0 10px;\
				height:28px;\
				line-height:28px;\
				cursor:pointer;\
				vertical-align: middle;\
			}\
			.marquee .marquee-content .marquee-content-item>span{\
				line-height:28px;\
				vertical-align: middle;\
			}\
			');
			cssLoaded=true;
		}
		var state=$.data(target,'marquee');
		var opts=state.options;
		var t=$(target);
		t.empty().appendTo('body');
		t.removeClass('marquee marquee-horizontal marquee-vertical marquee-left marquee-right');
		t.addClass('marquee marquee-'+(opts.dir=='vertical'?'vertical':'horizontal'));
		
		t.append('<div class="marquee-content"><div class="marquee-content-inner"></div></div><div class="marquee-button">18</div>');
		if(!!window.ActiveXObject || "ActiveXObject" in window){
			t.append('<div class="marquee-bg" style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:-1;"><iframe frameborder="0" tabindex="-1" src="javascript:false;" style="width:100%;height:100%;filter:Alpha(Opacity=0);opacity:0;"></iframe></div>')
		}
		if (opts.title && opts.dir=='vertical') {
			var header=$('<div class="marquee-header"><div class="marquee-title"></div><div class="marquee-toolbar"></div></div>').prependTo(t);
			header.find('.marquee-title').html(opts.title);
			
			if (opts.minimizable) {
				header.find('.marquee-toolbar').append('<a href="javascript:void(0);" class="marquee-toolbar-min">&times;</a>');
			}
		
		}
		

		
		$('<div class="marquee-mask"></div>').insertAfter(t);
		move(target);
		resize(target);
		loadData(target);
		initEvent(target);
	}


	function initEvent(target){
		var state=$.data(target,'marquee');
		var opts=state.options;
		var t=$(target);
		t.off('.marquee');
		t.find('.marquee-button').off('.marquee').on('click.marquee',function(){
			if(opts.closed){
				setClosed(target,false);
			}else{
				setClosed(target,true);
			}
		})
		t.find('.marquee-content').off('.marquee').on('mouseover.marquee',function(){
			setPause(target,true);
		}).on('mouseout.marquee',function(){
			setPause(target,false);
		}).on('click.marquee','.marquee-content-item',function(){
			var ind=$(this).data('ind');
			var row=opts.data.rows[ind];
			if(typeof opts.onClickItem=='function') opts.onClickItem.call(target,row,ind);
		})
		
		t.find('.marquee-toolbar .marquee-toolbar-min').off('click').on('click',function(){
			t.marquee('close');
			return false;
		})
	}
	function setPause(target,pause){
		pause=(pause===false?false:true);
		var state=$.data(target,'marquee');
		var opts=state.options;
		opts.pause=pause;
	}
	function loadData(target,data){
		var state=$.data(target,'marquee');
		var opts=state.options;
		data=data||opts.data||[];
		var t=$(target);
		if (data instanceof Array){
			data={total:data.length,rows:data}
		}
		opts.data=data;
		var content=t.find('.marquee-content');
		var inner=t.find('.marquee-content-inner').empty();
		var btn=t.find('.marquee-button');
		if (typeof opts.labelFormatter=='function'){
			var btnHtml=opts.labelFormatter.call(target,data.total);
		}else{
			var btnHtml='<span class="marquee-count">'+data.total+'</span>'
		}
		btn.html( btnHtml);

		content.off('scroll.marquee')
		if (state.control) {
			clearInterval(state.control);
		}
		if (opts.dir=='vertical'){ //纵向滚动
			/*content.scrollTop(0);
			inner.height(data.rows.length*28);
			var totalPage=Math.ceil(data.rows.length/10);
			var virtualTop=$('<div class="marquee-content-page-virtual-top" style="height:0;"></div>').appendTo(inner);
			var virtualBot=$('<div class="marquee-content-page-virtual-bot" style="height:0;"></div>').appendTo(inner);
			virtualBot.height(inner.height());
			showPage(1,'bot');
			showPage(2,'bot');
			var beforeScrollTop=0;
			content.on('scroll.marquee',function(){
				var scrollTop=content.scrollTop();
				var nav=scrollTop>beforeScrollTop?'bot':'top';
				beforeScrollTop=scrollTop;
				if (nav=='top'){ //向上
					if (scrollTop-inner.find('.marquee-content-page-virtual-top').height()<28*10) {
						var currPage =Math.ceil(scrollTop/28/10);
						console.log(currPage);
						showPage(currPage-1,nav);
					}
				}else{
					if (inner.height()- scrollTop-content.height()-inner.find('.marquee-content-page-virtual-bot').height()<28*10) {
						var currPage =Math.ceil((scrollTop+content.height())/28/10);
						console.log(currPage);
						showPage(currPage+1,nav);
					}
				}
			})

			state.control=setInterval(function(){
				if (!opts.closed && !opts.pause && t.is(':visible') && content.find('.marquee-content-item').length>0){ // 没折叠 没暂停 可见
					var scrollTop=content.scrollTop();
					scrollTop+=opts.pixels;
					if (scrollTop> inner.height()-content.height()) {
						inner.find('.marquee-content-page').remove();
						virtualTop.height(0);
						virtualBot.height(inner.height());
						showPage(1,'bot');
						showPage(2,'bot');
						scrollTop=0;
						beforeScrollTop=0;
					}
					content.scrollTop(scrollTop);
				}

			},opts.speed);*/
			content.scrollTop(0);
			inner.height(data.rows.length*28+50);
			var maxScrollTop=inner.height()-(opts.height-2-(opts.title?30:0));
			$.each(data.rows,function(ind,row){
				insertItem(ind);
			})
			$('<div class="marquee-content-item-end" style="height:50px;"></div>').appendTo(inner);
			state.control=setInterval(function(){
				if (!opts.closed && !opts.pause && t.is(':visible') && content.find('.marquee-content-item').length>0){ // 没折叠 没暂停 可见
					var scrollTop=content.scrollTop();
					scrollTop+=opts.pixels;
					if (scrollTop> maxScrollTop) {
						scrollTop=0;
					}
					content.scrollTop(scrollTop);
				}

			},opts.speed);
		}else{ //横向滚动
			$.each(data.rows,function(ind,row){
				if (ind>=5) return false;
				insertItem(ind);
			})
			opts.item0Width=0;
			content.scrollLeft(0);
			state.control=setInterval(function(){
				if (!opts.closed && !opts.pause && t.is(':visible') && content.find('.marquee-content-item').length>0){ // 没折叠 没暂停 可见
					var scrollLeft=content.scrollLeft();
					scrollLeft+=opts.pixels;
					if (opts.item0Width==0) opts.item0Width=content.find('.marquee-content-item').eq(0)._outerWidth();
					if (scrollLeft>0 && opts.item0Width>0 && scrollLeft>opts.item0Width) {
						scrollLeft=scrollLeft-opts.item0Width;
						content.find('.marquee-content-item').eq(0).remove();
						opts.item0Width=t.find('.marquee-content-item')._outerWidth();
						insertItem(opts.nextDataIndex);
					}
					content.scrollLeft(scrollLeft);
				}
			},opts.speed);
		}


		function insertItem(ind){
			var row=data.rows[ind];
			var item=$('<div class="marquee-content-item" data-ind="'+ind+'"></div>').appendTo(inner);
			item.html(opts.itemFormatter.call(target,row,ind));
			opts.nextDataIndex=(ind==data.rows.length-1?0:(ind+1));
		}
		function showPage(page,nav){
			if (page<=0 || page>totalPage) return;
			if (inner.find('.marquee-content-page[data-page="'+page+'"]').length>0) return;
			var $page=$('<div class="marquee-content-page" data-page="'+page+'"></div>');
			var pageHeight=0;
			for (var i=(page-1)*10,len=data.rows.length;i<page*10 && i<len;i++){
				var row=data.rows[i];
				var item=$('<div class="marquee-content-item" data-ind="'+i+'"></div>').appendTo($page);
				item.html(opts.itemFormatter.call(target,row,i));
				pageHeight+=28;
			}
			if (nav=='top') {//向上滑动
				var delHeight=0;
				if (page+3<=totalPage) {
					delHeight=inner.find('.marquee-content-page[data-page="'+(page+3)+'"]').height();
					inner.find('.marquee-content-page[data-page="'+(page+3)+'"]').remove();
					inner.find('.marquee-content-page-virtual-bot').height(inner.find('.marquee-content-page-virtual-bot').height()+delHeight);
				}
				$page.insertAfter(inner.find('.marquee-content-page-virtual-top'));
				inner.find('.marquee-content-page-virtual-top').height(inner.find('.marquee-content-page-virtual-top').height()-pageHeight);
				
			}else if(nav=='bot'){
				var delHeight=0;
				if (page-3>=1) {
					delHeight=inner.find('.marquee-content-page[data-page="'+(page-3)+'"]').height();
					inner.find('.marquee-content-page[data-page="'+(page-3)+'"]').remove();
					inner.find('.marquee-content-page-virtual-top').height(inner.find('.marquee-content-page-virtual-top').height()+delHeight);
				}
				$page.insertBefore(inner.find('.marquee-content-page-virtual-bot'));
				inner.find('.marquee-content-page-virtual-bot').height(inner.find('.marquee-content-page-virtual-bot').height()-pageHeight);
			}
		}

	}
	function resize(target,size){
		size=size||{};
		var state=$.data(target,'marquee');
		var opts=state.options;
		var t=$(target);
		$.extend(opts,size);
		var content=t.find('.marquee-content');
		var header=t.find('.marquee-header');
		
		if (opts.closed){
			if(opts.dir=='vertical') {
				t._outerHeight(30)._outerWidth(30);
				content._outerWidth(opts.width-2*5);
				t.next('.marquee-mask')._outerWidth(30)._outerHeight(30);
			}else{
				var height=t._outerHeight();
				t._outerWidth(height);
				content._outerWidth(opts.width-height-2*5);
				t.next('.marquee-mask')._outerWidth(height)._outerHeight(height);
			}
			content.hide();
			header.hide();
			
		}else{
			if(opts.dir=='vertical') {
				t._outerWidth(opts.width)._outerHeight(opts.height);
				content._outerWidth(opts.width-height-2*5);
				if (opts.title) {
					content._outerHeight(t.height()-header._outerHeight() );
				}else{
					content._outerHeight(t.height());
				}
				t.next('.marquee-mask')._outerWidth(opts.width+20)._outerHeight(opts.height);
			}else{
				var height=t._outerHeight();
				t._outerWidth(opts.width);
				content._outerWidth(opts.width-height-2*5);
				t.next('.marquee-mask')._outerWidth(opts.width+20)._outerHeight(height);;
			}
			content.show();
			header.show();
		}
	}
	function move(target,pos){
		pos=pos||{};
		var state=$.data(target,'marquee');
		var opts=state.options;
		var t=$(target);
		$.extend(opts,pos);

		var labelAlign=opts.labelAlign||'';
		var topBottom=labelAlign.indexOf('top')>-1?'top':'bottom',
			leftRight=labelAlign.indexOf('left')>-1?'left':'right';
		opts.labelAlign=topBottom+'-'+leftRight;
		opts[topBottom]=opts[topBottom]||0;
		opts[leftRight]=opts[leftRight]||0;
		var tPar=t.parent();
		var scrollLeft=tPar.scrollLeft(),scrollTop=tPar.scrollTop();
		if (!t.hasClass('marquee-'+leftRight)) t.removeClass('marquee-left marquee-right').addClass('marquee-'+leftRight);
		var posCss={};
		posCss[topBottom]=(opts[topBottom]+(scrollTop*(topBottom=='top'?1:-1)))+'px';
		posCss[leftRight]=(opts[leftRight]+(scrollLeft*(leftRight=='left'?1:-1)))+'px';
		t.css(posCss);
		t.next('.marquee-mask').css(posCss);
	}
	function setClosed(target,closed){
		closed=(closed===false?false:true);
		var state=$.data(target,'marquee');
		var opts=state.options;
		opts.closed=closed;
		resize(target);
	}
    //入口
    $.fn.marquee = function (opts, param) {
        if (typeof opts == "string") {
            var fn = $.fn.marquee.methods[opts];
            return fn(this, param);
        }
        opts = opts || {};
        return this.each(function () {
            var state = $.data(this, "marquee");
            if (state) {
                $.extend(state.options, opts);
            } else {
                $.data(this, "marquee", { options: $.extend({}, $.fn.marquee.defaults, $.fn.marquee.parseOptions(this), opts) });
            }
			//然后去做初始化等
			init(this);
        });
    };
    //方法
    $.fn.marquee.methods = {
        options: function (jq) {
            //...
		} ,
		resize:function(jq,param){
	    	return jq.each(function(){
		    	resize(this,param);
		    })
		},
		move:function(jq,param){
	    	return jq.each(function(){
		    	move(this,param);
		    })
		},
		open:function(jq){
	    	return jq.each(function(){
		    	setClosed(this,false);
		    })
		},
		close:function(jq){
	    	return jq.each(function(){
		    	setClosed(this,true);
		    })
		},
		pause:function(jq){
			return jq.each(function(){
		    	setPause(this,true);
		    })
		},
		play:function(jq){
			return jq.each(function(){
		    	setPause(this,false);
		    })
		},
		loadData:function(jq,param){
	    	return jq.each(function(){
		    	loadData(this,param);
		    })
		}
    };
    //解析配置项
    $.fn.marquee.parseOptions = function (target) {
	    var t=$(target);
        return $.extend({}, $.parser.parseOptions(target));
    };
    //默认配置项
    $.fn.marquee.defaults = $.extend({
		height:30,
		width:500,
		pixels:2, //每次移动像素
		speed:50, //没多少ms移动一次
		pause:false,
		closed:false,
		minimizable:true,
		resizable:false,
		dir:'horizontal',
		labelAlign:'bottom-right',left:0,top:0,right:0,bottom:0
	});
})(jQuery);


;(function($){
	var initDHCMessageMarquee=function(params){
		var dir=params.dir||"vertical";
		var t=$('<div id="DHCMessageMarqueue"></div>').appendTo('body');
		t.marquee({
			width:600,title:'消息提醒',
			labelAlign:'bottom-right',bottom:10,right:10,
			closed:true,
			itemFormatter:function(row,ind){
				if (dir=='vertical') {
					return '<div style="width:auto;" title="'+row.Content.replace(/(<[^>]+>)|(&nbsp;)/ig,"")+'">'
						+'<span style="font-weight:bold;padding-right:5px;">'+(ind+1)+'、'+row.ActionDesc+'</span>'
						+'<span style="padding-right:2px;">'+(row.BedNo||'')+(row.PatName||'')+'</span>' //床号 姓名
						+'<span style="padding-right:2px;">'+row.SendDate+' '+row.SendTime+'</span>'
						+'<span style="padding-right:2px;">'+(row.AdmLoc||'')+'</span>' //科室
						+'</div>';
				}else{
					return '<span style="font-weight:bold;padding-right:5px;">'+(ind+1)+'、'+row.ActionDesc+'</span>'
						+'<span style="padding-right:2px;">'+(row.BedNo||'')+(row.PatName||'')+'</span>' //床号 姓名
						+'<span style="padding-right:2px;">'+row.SendDate+' '+row.SendTime+'</span>'
						+'<span style="padding-right:2px;">'+(row.AdmLoc||'')+'</span>'; //科室
				}
				//+'<span>'+row.Content.replace(/(<[^>]+>)|(&nbsp;)/ig,"")+'</span>'
			},
			data:[],
			dir:dir,height:38 + 28*7,
			bottom:2,right:2,
			onClickItem:function(row,ind){
				console.log(row,ind);
				var $msgListWin=$('#MessageWin-Marquee');
				if ($msgListWin.length==0) {
					var $msgListWin=$('<div id="MessageWin-Marquee" style="padding:0px;overflow:hidden;"></div>').appendTo('body');
					$msgListWin.window({
						title:'跑马灯消息列表',iconCls:"icon-w-msg",
						isTopZindex:true,modal:true,closed:true,collapsible:false,minimizable:false,maximizable:false,width:1230,height:600,closable:true,
						content:'<iframe src="" scrolling=no frameborder=0 style=\"width:100%;height:100%;\"></iframe>',
						onClose:function(){
							getDHCMessageMarqueeData(params.sessionUserId,params.searchInterval,1);
						}

					});
					
				}
				$msgListWin.window("open");
				$msgListWin.find('iframe')[0].src='dhc.message.csp?OnlyMarquee=1&DetailsId='+row.DetailsId+'&DataInd='+ind;
				t.marquee('pause');
				
			}
		})
		getDHCMessageMarqueeData(params.sessionUserId,params.searchInterval,params.mqCount);
	};
	var getDHCMessageMarqueeData_timmer;
	function getDHCMessageMarqueeData(sessionUserId,searchInterval,mqCount){
		searchInterval=searchInterval||0;
		if (getDHCMessageMarqueeData_timmer) clearTimeout(getDHCMessageMarqueeData_timmer);
		if (mqCount==0){
			onData({total:0,rows:[]});
		}else{
			$.q({
				ClassName:"websys.DHCMessageDetailsMgr",
				QueryName:"FindInfo",
				UserId:sessionUserId,
				ReadFlag:"N",
				SendDateStart:"",
				SendDateEnd:"",
				ActionTypeArg:"",
				LevelType:"",
				MarqueeShow:'Y',
				page:1,rows:9999
			},onData);
		}
		function onData(data){
			$('#DHCMessageMarqueue').marquee('loadData',data);
			if (data.total>0) {
				$('#DHCMessageMarqueue').marquee('open');
			}else{
				$('#DHCMessageMarqueue').marquee('close');
			}
			if (searchInterval>0) {
				getDHCMessageMarqueeData_timmer=setTimeout(function(){
					getDHCMessageMarqueeData(sessionUserId,searchInterval);
				},searchInterval*60*1000);
			}

		}

	}
	var reloadDHCMessageMarquee=function(params){
		getDHCMessageMarqueeData(params.sessionUserId,params.searchInterval,params.mqCount);
	}
	window.initDHCMessageMarquee=initDHCMessageMarquee;
	window.reloadDHCMessageMarquee=reloadDHCMessageMarquee;
})(jQuery);
