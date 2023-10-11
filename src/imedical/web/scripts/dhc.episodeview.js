/**
 * 给出一个方法 可以直接弹出界面
 * 把此段代码提前 后面其它地方将可复用方法 通过$.episodeview.fn 放出去
*/
(function($){
	
	var episodeview={
		easyModal:function(title,url,width,height,target,autoZoom){
			if (target){
				var maxWidth=$(target).width(),maxHeight=$(target).height();
			}else{
				var maxWidth=$(window).width(),maxHeight=$(window).height();
			}
			width=''+(width||'80%'),width=width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width);
			height=''+(height||'80%'),height=height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height);

			if ((width>maxWidth-20 || height>maxHeight-20) && !autoZoom && top.websys_showModal) { //如果最大大小超出 且不允许自己缩放 且top层有websys_showModal 调用top.websys_showModal
				return top.websys_showModal({url:url,title:title,width:width,height:height});
			} else{ //当前
				var $easyModal=$('#episodeview-easyModal');
				if (target) {
					var $easyModal=$(target).find('>.panel>.episodeview-easyModal');
				}else {
					var $easyModal=$('#global-episodeview-easyModal');
				}
				if ($easyModal.length==0){
					if (url!='') {
						$easyModal=$('<div '+(target?'':'id="global-episodeview-easyModal"')+' class="episodeview-easyModal" style="overflow:hidden;"><iframe name="episodeview-easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scrolling="auto"></iframe></div>').appendTo(target||'body');
					}else{
						$easyModal=$('<div '+(target?'':'id="global-episodeview-easyModal"')+' class="episodeview-easyModal" style="overflow:hidden;"><div class="episodeview-easyModal-content" style="width:100%;height:100%;"></div></div>').appendTo(target||'body');
					}
					
				}
				width=Math.min(maxWidth-20,width);
				height=Math.min(maxHeight-20,height);
				$easyModal.find('iframe').attr('src',url);
				$easyModal.dialog({
					iconCls:'icon-w-paper',
					modal:true,
					title:title,
					width:width,
					height:height,
					inline:!!target
					,onClose:function(){
						$(target||'body').removeClass('episodeview-noscroll');
					},onOpen:function(){
						$(target||'body').addClass('episodeview-noscroll');
					}
				}).dialog('open').dialog('center');
				return $easyModal;
			}
		}
		,easyOriginWin:function(url,name,features){
			window.open(url,name,features);
		},
		formatFeatures:function(features){
			features=(features||'').toLowerCase();
			var obj={};
			arr=features.split(',');
			for (var i=0,len=arr.length;i<len;i++){
				var item = arr[i];
				if (item!=""){
					var itemArr = item.split("=");
					if (itemArr.length==1){ //status,resizable,scrollbars,
						obj[itemArr[0]] = "yes";
					}else{
						if (itemArr[1]=="true" || itemArr[1]=="false"){
							obj[itemArr[0]] = itemArr[1]=="true"?true:false;
						}else{
							obj[itemArr[0]] = itemArr[1]||"";
						}	
					}
				}
			}
			if (obj['hisui']){
				obj.iconCls = obj["iconcls"]||'icon-w-paper'; 
				return obj;
			} else {
				var commonFea='titlebar=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes'
				var arr=commonFea.split(',')
				for (var i=0,len=arr.length;i<len;i++){
					var itemArr=arr[i].split('=');
					if (!obj[itemArr[0]]) obj[itemArr[0]]=itemArr[1];
				}


				var maxWidth=window.screen.availWidth,maxHeight=window.screen.availHeight;
				var width=''+(obj.width||'80%'),height=''+(obj.height||'80%'),top=''+(obj.top||''),left=''+(obj.left||'');
				width=width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width);
				height=height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height);
				top=top.indexOf('%')>-1?parseInt(maxHeight*parseFloat(top)*0.01):parseInt(top);
				left=left.indexOf('%')>-1?parseInt(maxWidth*parseFloat(left)*0.01):parseInt(left);
				if (isNaN(top)) top=parseInt((maxHeight-height)/2);
				if (isNaN(left)) left=parseInt((maxWidth-width)/2);
				obj.width=width,obj.height=height,obj.top=top,obj.left=left;
				features=''
				for (var i in obj){
					features+=(features==''?'':',')+i+'='+obj[i]
				}
				return features;
			}
		}
		,findThisModal:function(id){
			var modal=null;
			var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
			if (!window.parent || window.parent===window) return modal;
			try {
				var P$=window.parent.$;
			}catch(e){
				return modal;
			}
			if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
			
			window._findThisModalKey=key;
			
			P$('iframe').each(function(){
				try {
					if (this.contentWindow._findThisModalKey==key){
						modal=P$(this).closest('.window-body');
						return false;
					}
				}catch(e){}
				
			})
			return modal;
		},
		closeWin:function(){
			var modal=$.episodeview.findThisModal();
			if (modal && modal.length>0){
				modal.window('close');
			}else{
				window.close()
			}
			

		}
	}
	$.episodeview=episodeview;
})(jQuery);

(function($){
	
	function loadCss(url){
		var link = document.createElement('link');
	    link.type = 'text/css';
	    link.rel = 'stylesheet';
	    link.href = url;
	    var head = document.getElementsByTagName('head')[0];
	    head.appendChild(link);
	}
	var loadJsHistory={};
	function loadJs(url,charset,callback,otherParams){
		otherParams=otherParams||{};
		if (!otherParams.forceLoad && typeof loadJsHistory[url]=='object') {  //不是强制加载 且已经加载过
			callback( loadJsHistory[url].success );
			return;
		}

		var script = document.createElement('script'),
		head = document.getElementsByTagName('head')[0];
		script.type = 'text/javascript';
		script.charset = charset||'gb18030';
		script.src = url;
		if (script.addEventListener) {
			script.addEventListener('load', function () {
				loadJsHistory[url]={success:true};
				callback(true);


			}, false);
			script.addEventListener('error', function () {
				loadJsHistory[url]={success:false};
				callback(false);
			}, false);
		} else if (script.attachEvent) {
			script.attachEvent('onreadystatechange', function () {
				var target = window.event.srcElement;
				if (target.readyState == 'loaded'||target.readyState == 'complete') {
					loadJsHistory[url]={success:true};
					callback(true); //ie8好像会是这里 即使加载失败 本界面好像不兼容IE8也无所谓
				}
			});
		}
		head.appendChild(script);
	}
	$.episodeview.loadCss=loadCss;
	$.episodeview.loadJs=loadJs;
})(jQuery);

(function ($) {
	
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
	            if (callNow) result = func.apply(context, args);
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
	};
	///将字符串中日期格式转换 3 yyyy-MM-dd 4 dd/MM/yyyy  暂不考虑其他格式
	function formatDateString(str,format){
		if (format==3){ //转换里面 dd/MM/yyyy格式的
			str=str.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m,i,d){
				return m.split('/').reverse().join('-');
			})
		}
		if (format==4){  //转换里面 yyyy-MM-dd 的
			str=str.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m){
				return m.split('-').reverse().join('/');
			})
		}
		return str;
	};
	var window_resize=debounce(function(){
		//console.count('window_resize');
		$('.episodeview').triggerHandler('__resize.episodeview');	
	},200);
	$(window).off('resize.episodeview').on('resize.episodeview',window_resize);



	/**
	 * 
	 * @param {*} a 数据a
	 * @param {*} b 数据b
	 */
	function compareActData(a,b,dateField,timeField,extField1){
		var aOprDate=a[dateField],bOprDate=b[dateField];
		if(aOprDate.indexOf('/')>-1) aOprDate=aOprDate.split('/').reverse().join('-');
		if(bOprDate.indexOf('/')>-1) bOprDate=bOprDate.split('/').reverse().join('-');
		if(aOprDate==bOprDate){
			if(a[timeField]==b[timeField]){
				if(extField1) {
					if (a[extField1]==b[extField1]) {
						return 0;
					}else if (a[extField1]<b[extField1]) {
						return -1;
					}else{
						return 1	
					}
				}else{
					return 0;
				}
				
			} else if(a[timeField]<b[timeField]){
				 return -1;
			}else{
				return 1;
			}
		}else if(aOprDate<bOprDate) {
			return -1;
		}else{
			return 1;
		}
		
	}
	
	//渲染
	function render(ele){
 		var state = $.data(ele, "episodeview");
		var opts=state.options;
		var dataArg=$.extend({ClassName:'icare.web.TimeLineData',MethodName:'GetEpisodeViewData'},opts.queryParams)
		$cm(dataArg,function(ret){
			if(ret.success=='1'){
				renderAll(ele,ret);
			}else{
				$.messager.alert('错误',ret.msg,'error',function(){
					$.episodeview.closeWin();
				})	
			}
		})

	}

	function renderAll(ele,data){
		var $ele=$(ele);
		var state = $.data(ele, "episodeview");
		var opts=state.options;
		
		var $con=$(ele).children('.episodeview');
		$con.empty();
		$.data($con[0],'target',$ele);
		formatterData(data,-1);
		renderLabels(ele,data);
		
		renderProcess(ele,data);

		$con.off('__resize.episodeview').on('__resize.episodeview',function(){

		})

	}
	function formatterData(data,order){
		$.each(data.AdmList,function(indAdm,itemAdm){
			$.each(itemAdm.TransLocs,function(indLoc,itemLoc){
				
				$.each(itemLoc.Events,function(indEvt,itemEvt){
					itemEvt.Details.sort(function(a,b){
						return compareActData(a,b,'DetDate','DetTime')*1;   //*order  明细正序即可
					})
				})
				itemLoc.Events.sort(function(a,b){
					return compareActData(a,b,'EventDate','EventTime','EventId')*order;
				})
			})
			itemAdm.TransLocs.sort(function(a,b){
				return compareActData(a,b,'LocDate','LocTime')*order; 
			})
		})
		data.AdmList.sort(function(a,b){
			return (a.AdmId-b.AdmId)*order;
		})		
	}
	function renderLabels(ele,data){
		var $ele=$(ele);
		var state = $.data(ele, "episodeview");
		var opts=state.options;
		var $con=$ele.children('.episodeview');
		
		var $labels_wrap=$con.find('.episodeview-labels-wrap');
		if ($labels_wrap.length==0){
			$labels_wrap=$('<div class="episodeview-labels-wrap"></div>').appendTo($con);
		}
		var $labels=$('<div class="episodeview-labels"></div>');

		if (opts.hideLabel){ //隐藏label
			$labels.appendTo($labels_wrap);
			return;
		}

		if (!opts.hideLabelIcon) { //不隐藏患者图标
			var $labels_icon=$('<div class="episodeview-labels-icon "></div>').appendTo($labels);
			var PatSex=''+data.PatSexZH+data.PatSex;
			if (PatSex.indexOf('男')>-1) $labels_icon.addClass('episodeview-labels-icon-man');
			if (PatSex.indexOf('女')>-1) $labels_icon.addClass('episodeview-labels-icon-woman');
		}else{ //隐藏图标
			$labels.addClass('episodeview-labels-no-icon')
		}
		
		$.each(opts.labels,function(){
			var $labels_row=$('<div class="episodeview-labels-row"></div>');
			$.each(this,function(ind,item){
				var label=item.label,key=item.key;
				if (typeof data[key]!="undefined" && data[key]!=''){
					var value=data[key];
					if (item.type && item.type=="date") value=formatDateString(value,opts.dateFormat);
					if ($labels_row.find('.episodeview-labels-cell-value').length>0 ) {
						if (item.hideSep) $labels_row.append('&nbsp;&nbsp;');
						else $labels_row.append('<span class="episodeview-labels-cell-sep">/</span>');
						
					}
					if (!item.hideLabel) $labels_row.append('<span class="episodeview-labels-cell-label">'+$g(label)+'：</span>');
					var $value=$('<span class="episodeview-labels-cell-value">'+value+'</span>');
					if (item.css) $value.css(item.css)
					$labels_row.append($value);
				}
			})
			
			if ($labels_row.find('.episodeview-labels-cell-value').length>0) $labels_row.appendTo($labels);
			
		});
		$labels.appendTo($labels_wrap);
		
		if (typeof data.ButtonList=='object' && data.ButtonList.length>0){
			var $labels_buttons=$('<div class="episodeview-labels-buttons"></div>').appendTo($labels);
			$.each(data.ButtonList,function(ind,item){
				var $btn=$('<a class="episodeview-labels-buttons-cell">'+item.Description+'</a>').appendTo($labels_buttons);
				$btn.linkbutton({
					onClick:function(){
						buttonOnClick(item,$(this));
					}
				})
			})
		}
		function buttonOnClick(buttonData,button){
			//$.messager.popover({msg:buttonData.Description,type:'info'})
			//console.log('buttonOnClick',buttonData,button);
			//Code:%String:菜单代码,Description:%String:菜单描述,Url:%String:链接,ValExpr:%String:表达式,JsFun:%String:Js函数,JsFile:%String:Js文件名"，NewWindow:"top=10,width=100"
			if (buttonData.Url) {
				var url=buttonData.Url;
				url+=(url.indexOf('?')>-1?'&':'?')+'ordItemId='+opts.orders[0];
				if (buttonData.ValExpr) url+=url.indexOf('?')>-1?'':'?a=a'+buttonData.ValExpr;
				var features=$.episodeview.formatFeatures(buttonData.NewWindow||'hisui=true');
				if (typeof features=='string'){
					$.episodeview.easyOriginWin(url,'episodeview-btn-'+buttonData.Code,features);
				}else{ //
					$.episodeview.easyModal(buttonData.Description,url,features.width,features.height,$con,false);
				}
			}else if(buttonData.JsFun){
				var tempJsFun=getMenuJsFun(buttonData.JsFun,opts.cateCode,opts.dataTypeCode); //cryze 2021-10-21
				if (tempJsFun){
					var features=$.episodeview.formatFeatures(buttonData.NewWindow||'hisui=true');
					var easyModal=$.episodeview.easyModal(buttonData.Description,'',features.width,features.height,$con,false);
					tempJsFun(ele,data,buttonData,easyModal.find('>.panel>.dialog-content'));
				}else{
					$.messager.popover({msg:buttonData.JsFun+'未定义，请联系信息中心',type:'alert'})
				}
			}else{
				$.messager.popover({msg:buttonData.Description+'配置不正确,请联系信息中心',type:'alert'})
			}
		}
		
		
	}
	
	///获取 按钮、图表定义的JS方法 以前是直接定义在window下的，但是随着闭环越来越多 可能会冲突 //cryze 2021-10-21
	function getMenuJsFun(funName){
		var tempJsFun=null
		if( typeof window[funName]=='function' ){ //最后取window下的
			tempJsFun=window[funName];
		}
		return tempJsFun;
		
	}
	
    //渲染变化过程
    function renderProcess(ele,data){
		console.log(data)
		
		var $ele=$(ele);
		var state = $.data(ele, "episodeview");
		var opts=state.options;
		var $con=$ele.children('.episodeview');
		
		var $process_wrap=$con.find('.episodeview-process-wrap');
		if ($process_wrap.length==0){
			$process_wrap=$('<div class="episodeview-process-wrap"></div>').appendTo($con);
		}
		
		var $process_nav_wrap=$con.find('.episodeview-process-nav-wrap');
		if ($process_nav_wrap.length==0){
			$process_nav_wrap=$('<div class="episodeview-process-nav-wrap"></div>').appendTo($con);
		}
		
		
		var totalHeight=0;
		if ($ele.prop('tagName')=="BODY"){
			totalHeight=$(window).height();
		}else{
			totalHeight=$ele.height();
		}
		var labelsHeight=$con.children('.episodeview-labels-wrap').outerHeight();
		$process_wrap.outerHeight(totalHeight- labelsHeight );
		
		$process_nav_wrap.css({maxHeight:(totalHeight- labelsHeight-30)+'px',top:(labelsHeight+15)+'px'})
		
		
		var $process=$('<div class="episodeview-process"></div>');
		var $processul=$('<ul class="episodeview-process-ul"></ul>').appendTo($process);
		var $process_nav=$('<div class="episodeview-process-nav"></div>');
		var $process_navul=$('<ul class="episodeview-process-nav-ul"></ul>').appendTo($process_nav);
		
		
		$.each(data.AdmList,function(indAdm,itemAdm){
			var admTypeMap={I:'住',E:'急',O:'门',H:'健'}
			if (data.AdmList.length>1) {
				var $nav_par=$('<li data-ap="a'+indAdm+'-l0"><div class="episodeview-process-nav-item">'+itemAdm.AdmDate+' ['+admTypeMap[itemAdm.AdmType]+']</div><ul></ul></li>').appendTo($process_navul).find('ul');
			}else{
				var $nav_par=$process_navul;
			}
			
			$.each(itemAdm.TransLocs,function(indLoc,itemLoc){
				$('<li data-ap="a'+indAdm+'-l'+indLoc+'"><div class="episodeview-process-nav-item">'+itemLoc.LocDesc+'</div></li>').appendTo($nav_par);
				var $ap=$('<li class="episodeview-process-ap" data-ap="a'+indAdm+'-l'+indLoc+'"><div></div></li>');
				if(indLoc>0) {
					$ap.addClass('episodeview-process-loc-sep');
				}else if(indAdm>0 && indLoc==0){
					$ap.addClass('episodeview-process-adm-sep');
				}
				$ap.appendTo($processul);
				
				$.each(itemLoc.Events,function(indEvt,itemEvt){
					var evtHtml='<li>'+'<div class="episodeview-process-event '+ ((itemEvt.Details&&itemEvt.Details.length>0)?'has-detail':'') +'"><div class="circle"></div><span class="ev-ev-dt">'+itemEvt.EventDate+' '+itemEvt.EventTime+'</span><span class="ev-ev-desc">'+itemEvt.EventDesc+'</span><span class="ev-ev-note">'+(itemEvt.EventNote||'')+'</span></div>';
					evtHtml+='<div class="episodeview-process-event-details" style="display:none">';
					$.each(itemEvt.Details,function(indDet,itemDet){
						evtHtml+='<div class="episodeview-process-event-det"><span class="ev-evt-dt">'+itemDet.DetDate+' '+itemDet.DetTime+'</span> <span class="ev-evt-desc">'+itemDet.DetDesc+'</span> <span class="ev-evt-note">'+(itemDet.DetNote||'')+'</span></div>';
					})
					evtHtml+='</div>';
					evtHtml+='</li>';
					$processul.append(evtHtml);
				})
			})
			
			
		})
		$process.appendTo($process_wrap);
		$process_nav.appendTo($process_nav_wrap);
		
		$ele.on('click','.episodeview-process-event.has-detail', debounce(function(){
			
			if ($(this).children('.circle').hasClass('playcircle')){
				$(this).children('.circle').removeClass('playcircle');
				$(this).parent().find('.episodeview-process-event-details').slideUp();
			}else{
				$(this).children('.circle').addClass('playcircle');
				$(this).parent().find('.episodeview-process-event-details').slideDown();
			}
		},200,true))
		
		$ele.on('click','.episodeview-process-nav-item',function(){
			$(this).closest('.episodeview-process-nav').find('li.active').removeClass('active');
			var $li=$(this).closest('li');
			$li.addClass('active');
			$li.parent().closest('li').addClass('active');
			
			var ap=$li.data('ap');
			
			var $ap=$ele.find('.episodeview-process-ap[data-ap="'+ap+'"]') ;
			var $ap0=$ele.find('.episodeview-process-ap[data-ap="a0-l0"]'); 
			var scrollHeight=Math.min($ap.offset().top-$ap0.offset().top, $process.height()-$process_wrap.height())
			if (scrollHeight>=0) {
				$process_wrap.scrollTop(scrollHeight);
			}
			
			
			//alert(ap)	
		})
		
		$process_wrap.on('scroll',debounce(function(){
			var scrollTop=$process_wrap.scrollTop();
			var offsetTop0=$ele.find('.episodeview-process-ap[data-ap="a0-l0"]').offset().top;
			$ele.find('.episodeview-process-ap').each(function(){
				if($(this).offset().top-offsetTop0>=scrollTop) {
					var ap=$(this).data('ap');
					$ele.find('.episodeview-process-nav-ul li.active').removeClass('active');
					var $li=$ele.find('.episodeview-process-nav-ul li[data-ap="'+ap+'"]');
					$li.addClass('active');
					$li.parent().closest('li').addClass('active');
					return false;
				}	
			})
			
		},200))

    }
    
		
    function init(ele) {
	    
	    var state = $.data(ele, "episodeview");
		var opts=state.options;
		
		var verCls=opts.uiVer?' episodeview-ver-'+opts.uiVer:'';  //根据ui版本不同 在组件最外层增加ui版本样式类 2022-12-14
		
	    var content='<div class="episodeview'+verCls+'"></div>';
		opts.renderTo=ele;
		$(ele).empty().html(content);
		render(ele);
    };


    $.fn.episodeview = function (opts, param) {
        if (typeof opts == "string") {
            var mth = $.fn.episodeview.methods[opts];
            return mth(this, param);
        }
        opts = opts || {};
        return this.each(function () {
            var state = $.data(this, "episodeview");
            if (state) {
                $.extend(state.options, opts);
            } else {
				var parsedOpts=$.fn.episodeview.parseOptions(this);
                $.data(this, "episodeview", {
                    options: $.extend({}, $.fn.episodeview.defaults, parsedOpts, opts)
                });
            }
            init(this);
        });
    };
    $.fn.episodeview.methods = {
        options: function (jq) {
            return $.data(jq[0], "episodeview").options;
        }
    };
    $.fn.episodeview.parseOptions = function (ele) {
	    var def={}
        if (typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite') {
	    	def.uiVer='lite';   
	    }
    	return def;
    };
    $.fn.episodeview.defaults ={
	    queryParams:{},
	    labels:[[
				{label:'姓名',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'性别',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'年龄',key:'PatAge',hideLabel:true},
				{label:'就诊号',key:'EpisodeID'},
				{label:'登记号',key:'PapmiNo'},
				{label:'病案号',key:'MrNo'},
				{label:'费别',key:'AdmReason'}
		    ],[
				{label:'就诊日期',key:'AdmDate',type:'date'},
				{label:'住院天数',key:'InPatDays'},
				{label:'就诊天数',key:'OEHAdmDays'},
				{label:'科室',key:'PatDept'},
				{label:'当前状态',key:'CurrStatus'}
		    ]
	    ]
	    ,uiVer:'blue'  //ui版本 同hisui版本
    };
})(jQuery);






