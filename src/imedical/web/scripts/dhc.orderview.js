var STATIC_ORDERVIEW_CONFIG={
	showByTime:{ //�Ƿ�ʱ����ʾ 
		'134':{  //�����ջ� 
			showByTimeStyle:1
		}
//		  ,'05':{  //����
//		  	showByTimeStyle:1
//		  }
	}
	///��ǰ����orderview.defaults
	,followNegativeStateCate:['04','05','20','21']  //һ�������̲����൱��֮�������̵�������  ��ʱ���������� ����Ҫ�ж�ʱ�����Ϣ Ϊ�������̲�������������
	,followNegativeActCode:['CA','OCA','CRP',"CIM"]  //��һ�Զ������ ����  ����CIM20220728

};



/**
 * ����һ������ ����ֱ�ӵ�������
 * �Ѵ˶δ�����ǰ ���������ط����ɸ��÷��� ͨ��$.orderview.fn �ų�ȥ
*/
(function($){
	
	var orderview={
		show:function(ord,opts){
			opts=opts||{};
			if(typeof ord=="object" && ord instanceof Array) ord=ord.join('^');
			var triggerId='dhc-orderview-trigger-'+ord.replace(/\|\|/g,'-').replace(/\^/g,'_');
			var trigger=$('#'+triggerId);
			if (trigger.length==0){
				trigger=$('<a style="display:none;" id="'+triggerId+'"></a>').appendTo('body');
				trigger.orderview($.extend(opts,{ord:ord,ordGetter:null,type:'trigger',trigger:'click'}));
			}
			trigger.trigger('click');
		},
		getTokenUrl:function(url){
			if(typeof url=='string' && url.indexOf('.csp')>-1) {
				var token='';
				if(typeof websys_getMWToken=='function' ){
					token= websys_getMWToken();
				}
				
				var arr=url.split('#');
				arr[0]=arr[0]+(arr[0].indexOf('?')>-1?'&':'?')+'MWToken='+token; 
				url=arr.join('#');
			}
			
			//alert('getTokenUrl:'+url)
			
			return url;
		},
		easyModal:function(title,url,width,height,target,autoZoom){
			
			url=$.orderview.getTokenUrl(url);
			
			if (target){
				var maxWidth=$(target).width(),maxHeight=$(target).height();
			}else{
				var maxWidth=$(window).width(),maxHeight=$(window).height();
			}
			width=''+(width||'80%'),width=width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width);
			height=''+(height||'80%'),height=height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height);
			
			
			var topWin=window;
			try{
				if(top.websys_showModal) topWin=top;
			}catch(e){}
			
			if ((width>maxWidth-20 || height>maxHeight-20) && !autoZoom && topWin.websys_showModal) { //�������С���� �Ҳ������Լ����� ��top����websys_showModal ����top.websys_showModal
				return topWin.websys_showModal({url:url,title:title,width:width,height:height,iconCls:'icon-w-paper'});
			} else{ //��ǰ
				var $easyModal=$('#orderview-easyModal');
				if (target) {
					var $easyModal=$(target).find('>.panel>.orderview-easyModal');
				}else {
					var $easyModal=$('#global-orderview-easyModal');
				}
				if ($easyModal.length==0){
					if (url!='') {
						$easyModal=$('<div '+(target?'':'id="global-orderview-easyModal"')+' class="orderview-easyModal" style="overflow:hidden;"><iframe name="orderview-easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scrolling="auto"></iframe></div>').appendTo(target||'body');
					}else{
						$easyModal=$('<div '+(target?'':'id="global-orderview-easyModal"')+' class="orderview-easyModal" style="overflow:hidden;"><div class="orderview-easyModal-content" style="width:100%;height:100%;"></div></div>').appendTo(target||'body');
					}
					
				}else{
					var modalContent=$easyModal.find('>.panel>.dialog-content').eq(0);
					if (modalContent.length>0) {
						modalContent.find('iframe').attr('src','about:blank');
						modalContent.empty();
						if (url!='') {
							modalContent.append('<iframe name="orderview-easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scrolling="auto"></iframe>');
							
						}else{
							modalContent.append('<div class="orderview-easyModal-content" style="width:100%;height:100%;"></div>');
						}
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
						$(target||'body').removeClass('orderview-noscroll');
					},onOpen:function(){
						$(target||'body').addClass('orderview-noscroll');
					}
				}).dialog('open').dialog('center');
				return $easyModal;
			}
		}
		,easyOriginWin:function(url,name,features){
			url=$.orderview.getTokenUrl(url);
			window.open(url,name,features);
		},formatByJson :function(template,data){
			if ("string" == typeof data ){
				data = $.parseJSON(data);
			}
			// template + data��������html
			return template.replace(/\{(.+?)\}/ig,function(m,i,d){
					return data[i]||'';
			}) ;
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
		,replaceHtml:function(str){
			 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
		},calSeconds:function(dateA,timeA,dateB,timeB){ //ֻ�򵥿��� 3 yyyy-MM-dd 4 dd/MM/yyyy������
			if (dateA.indexOf('/')) dateA=dateA.split('/').reverse().join('-');
			if (dateB.indexOf('/')) dateB=dateB.split('/').reverse().join('-');
			
			var dA=new Date(dateA+' '+timeA),
				dB=new Date(dateB+' '+timeB)  ;
			
			return (dB-dA)/1000;
			
		},
		parseTmpl:function(template,data){
			if (typeof data=='object') {
				data=data||{};
			}else{
				data={};	
			}
			return template.replace(/\$\{(.+?)\}/ig,function(m,i,d){
				return data[i]||'';
			}) ;

		}
	}
	$.orderview=orderview;
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
		if (!otherParams.forceLoad && typeof loadJsHistory[url]=='object') {  //����ǿ�Ƽ��� ���Ѿ����ع�
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
					callback(true); //ie8����������� ��ʹ����ʧ�� ��������񲻼���IE8Ҳ����ν
				}
			});
		}
		head.appendChild(script);
	}
	$.orderview.loadCss=loadCss;
	$.orderview.loadJs=loadJs;
})(jQuery);

(function ($) {
	var BASE_URL=location.pathname.split('/web/')[0]+'/web',
		ASSETS_BASE_URL='/imedical/web/scripts'; //��̬�ļ�base·�� �Դﵽ����ʹ���ݺ�ҽ���ջ�ǰ̨����ֿ�
	$('script').each(function(){
		var src=this.src;
		if (src.indexOf('dhc.orderview.js')>-1){
			ASSETS_BASE_URL=src.split('dhc.orderview.js')[0];
			var csssrc=src.replace('dhc.orderview.js','dhc.orderview.css');
			$.orderview.loadCss(csssrc);
			return false;
		}
	})
	var $proxyContainer;

    var GLOBAL_ONE_WIN = null;
    var GLOBAL_ONEFRAME_WIN = null;
    var renderId=0;
	// underscore ����
	function debounce(func, wait, immediate) {

	    var timeout, result;

	    var debounced = function () {
	        var context = this;
	        var args = arguments;

	        if (timeout) clearTimeout(timeout);
	        if (immediate) {
	            // ����Ѿ�ִ�й�������ִ��
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
	///���ַ��������ڸ�ʽת�� 3 yyyy-MM-dd 4 dd/MM/yyyy  �ݲ�����������ʽ
	function formatDateString(str,format){
		if (format==3){ //ת������ dd/MM/yyyy��ʽ��
			str=str.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m,i,d){
				return m.split('/').reverse().join('-');
			})
		}
		if (format==4){  //ת������ yyyy-MM-dd ��
			str=str.replace(/(^\d)*(\d+)-(\d+)-(\d+)(^\d)*/ig,function(m){
				return m.split('-').reverse().join('/');
			})
		}
		return str;
	};
	var window_resize=debounce(function(){
		//console.count('window_resize');
		$('.orderview').triggerHandler('__resize.orderview');	
	},200);
	$(window).off('resize.orderview').on('resize.orderview',window_resize);
	function onTrigger(){
		var ele=this;
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var $renderTo=$(opts.renderTo);
		if ($renderTo.length==0){
			if(!state.win){
				if (opts.renderToOne){
					if(opts.contentType=='html'){
						if(!GLOBAL_ONE_WIN) GLOBAL_ONE_WIN=createWin();
						state.win=GLOBAL_ONE_WIN;
					}else{
						if(!GLOBAL_ONEFRAME_WIN) GLOBAL_ONEFRAME_WIN=createWin();
						state.win=GLOBAL_ONEFRAME_WIN;
					}
				}else{
					state.win=createWin();
				}
			}
			var size=calWinSize(opts);
			if(opts.renderToOne) state.win.children('.orderview').empty();
			state.win.window('open').window('move',{left:0,top:0}).window('resize',size).window('center');
		}else{
			var verCls=opts.uiVer?' orderview-ver-'+opts.uiVer:'';  //����ui�汾��ͬ ��������������ui�汾��ʽ�� 2022-12-14
			var content=opts.contentType=='html'?'<div class="orderview orderview-noscrollX'+verCls+'"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
			$renderTo.empty().html(content);
		}
		render(ele);
		function createWin(){
			var verCls=opts.uiVer?' orderview-ver-'+opts.uiVer:'';  //����ui�汾��ͬ ��������������ui�汾��ʽ�� 2022-12-14
			var content=opts.contentType=='html'?'<div class="orderview orderview-noscrollX'+verCls+'"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
		    var size=calWinSize(opts);
		    return $('<div class="orderview-win">'+content+'</div>').appendTo('body').window({
				width:size.width,
				height:size.height,
				iconCls:'icon-w-epr',
				title:'ҽ���鿴',
				closed:true,modal:true,
				collapsible:false,minimizable:false,maximizable:false,draggable:false,resizable:false
			});
		}
		function calWinSize(opts){
			if(opts.autoFitWin){
				return {
					height:Math.min(opts.winHeight,$(window).height()-20),
					width:Math.min(opts.winWidth,$(window).width()-20),
				};
			}else{
				return {height:opts.winHeight,width:opts.winWidth};
			}
		}
	}

	//��Ⱦ
	function render(ele){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		var $renderTo=$(opts.renderTo);
		var ord=opts.ord;
		if (typeof opts.ordGetter=="function"){
			ord=opts.ordGetter.apply(ele);
		}
		var orders=[];
		///���Ƕ�ҽ��render
		if (typeof ord=="string"){
			var temporders=ord.split('^');
			$.each(temporders,function(ind,itemord){
				if(parseInt(itemord.split('||')[0]) >0 && parseInt(itemord.split('||')[1]) >0 ) {  //��������Ϊ����ȷ��ҽ��ID
					orders.push(itemord);
				}
			})
			ord=orders.join('^');
			opts.ord=ord;
		}else{
			orders=ord||[];
		}
		opts.orders=orders;
		
		if (opts.contentType=="html"){
			var ajaxBrokerUrl= opts.baseUrl+'/csp/websys.Broker.cls';//"/dthealth/web/csp/websys.Broker.cls";
			if (!opts.data || !opts.cache || opts.lastOrd!=orders.join('^')){
				opts.ord=ord,opts.lastOrd=orders.join('^');
				
				///����������json�ַ�����ʽ������̨ 20230111
				var otherParamsJsonStr=JSON.stringify({
					hideSensitiveInfo:opts.hideSensitiveInfo	
				})
				if (orders.length==1 ||(orders.length==0&&opts.ordViewBizId!=''&&opts.ordViewType!='')){ //��ҽ��  �����п��ܲ���ҽ��
					var reqData={ClassName:'icare.web.TimeLineData',MethodName:'GetActData',OrdItemId:ord
						,OrdViewType:opts.ordViewType||''
						,OrdViewBizId:opts.ordViewBizId||''
						,OtherParams:otherParamsJsonStr
					};
					var mockReqData={ClassName:'a.util.Mock',MethodName:'FromFile',filename:'dhc.orderview.mock.json'};
					//reqData=mockReqData;
					var xhr=$.ajax({
						url:ajaxBrokerUrl,
						data:reqData, 
						dataType:'json',
						type:'POST',
						success:function(res){
							if(res && res.errMsg) { //������Ϣ
								$.messager.popover({msg:res.errMsg,type:'error'})
								return;
								
							}
							
							if (opts.orders.length==0 && res.OrdItemId) {
								opts.ord=res.OrdItemId;
								opts.orders=opts.ord.split('^');
							}
							if (!opts.ordViewBizId && res.OrdViewBizId) {
								opts.ordViewBizId=res.OrdViewBizId;
							}



							formatterProcessData(res,opts);
							opts.data=res;
							renderBefore(ele,res,function(){
								renderAll(ele,res);
							})
							
						}
					})
				}else if (orders.length>1){ //��ҽ��
					$.ajax({
						url:ajaxBrokerUrl,
						data:{ClassName:'icare.web.TimeLineData',MethodName:'GetOrdItems',OrdItemIds:orders.join('^')},
						dataType:'json',
						type:'POST',
						success:function(res){
							//console.log(res);
							opts.orderArray=res;
							renderOrders(ele,res);
						}
					})
				}
			}else{
				renderBefore(ele,opts.data,function(){
					renderAll(ele,opts.data);
				})
				
			}
		}else{
			if (state.win) var $frame=state.win.find('iframe');
			else  var $frame=$renderTo.find('iframe');
			//var thisSrc='/dthealth/web/csp/dhc.orderview.csp?ord='+orders.join('^');
			var thisSrc=opts.baseUrl+'/csp/dhc.orderview.csp?ord='+orders.join('^');
			thisSrc=$.orderview.getTokenUrl(thisSrc);  //����Token
			var iframeSrc=$frame.attr('src');
			//console.log(iframeSrc);
			if (thisSrc!=iframeSrc || !opts.cache){
				//console.log(iframeSrc);
				state.win.find('iframe').attr('src',thisSrc);
			}
		}
		
	}

	/**
	 * ��̨���ص�data.ActCfg data.ActData ת��data.ProcessData
	 * @param {*} data ��ȡ��������
	 * @param {*} dateFormat ���ڸ�ʽ 3/4
	 * @param {*} followNegativeStateCate ��������һ�Զ����������Щ
	 * @param {*} followNegativeActCode  ��������һ�Զ� �����̴���
	 */
	function formatterProcessData(data,opts){
		var dateFormat=opts.dateFormat,
			followNegativeStateCate=opts.followNegativeStateCate||[],
			followNegativeActCode=opts.followNegativeActCode||[];
		if (!data.ActCfg) data.ActCfg=[];
		if (!data.ActData) data.ActData=[];

		followNegativeStateCate=followNegativeStateCate||[];
		followNegativeActCode=followNegativeActCode||[];
		var isFollowNegativeState=false;
		var DataType=data.PatOrdType||'';
		var DataCate=DataType.substr(0,DataType.length-2);
		if (followNegativeStateCate.indexOf(DataCate)>-1) isFollowNegativeState=true;  //isFollowNegativeStateΪtrue ÿ���������̶���Ҫ�����Ƿ���������ڵ�
		
		
		// if (data.PatOrdType && data.PatOrdType.substr(0,data.PatOrdType.length-2)=='134' && typeof opts.showByTime=='undefined') {
		// 	opts.showByTime=true;
		// }
		
		///��̨���������ProcessShowStyle
		if(data.ProcessShowStyle && typeof opts.showByTime=='undefined' ){
			if (data.ProcessShowStyle.indexOf('time-')>-1){
				opts.showByTime=true;
				opts.showByTimeStyle=data.ProcessShowStyle.split('time-')[1]
			}else{
				opts.showByTime=false;
				opts.showByTimeStyle='';
			}
			
		}
		
		var cateCode=data.PatOrdType?data.PatOrdType.substr(0,data.PatOrdType.length-2):'';
		if (typeof STATIC_ORDERVIEW_CONFIG=='object') {
			if (STATIC_ORDERVIEW_CONFIG.showByTime && STATIC_ORDERVIEW_CONFIG.showByTime[cateCode] && typeof opts.showByTime=='undefined' ) {
				opts.showByTime=true;
				opts.showByTimeStyle=STATIC_ORDERVIEW_CONFIG.showByTime[cateCode].showByTimeStyle;
			}
			if (STATIC_ORDERVIEW_CONFIG && STATIC_ORDERVIEW_CONFIG.followNegativeStateCate) { //ȡ STATIC_ORDERVIEW_CONFIG��
				followNegativeStateCate=STATIC_ORDERVIEW_CONFIG.followNegativeStateCate||[];
				if (followNegativeStateCate.indexOf(DataCate)>-1) isFollowNegativeState=true;
			}
			if (STATIC_ORDERVIEW_CONFIG && STATIC_ORDERVIEW_CONFIG.followNegativeActCode) { //ȡ STATIC_ORDERVIEW_CONFIG��
				followNegativeActCode=STATIC_ORDERVIEW_CONFIG.followNegativeActCode||[];
			}

		}


		data.ActData.sort(compareActData); //���е�ActData ��ʱ������

		var ActCfgIndex={};
		//�ڵ����������ô���
		$.each(data.ActCfg,function(){
			ActCfgIndex[this.ActCode]=this;
		})
		$.each(data.ActCfg,function(){
			if(this.ParentCode && ActCfgIndex[this.ParentCode]) {
				this.ParentSort=ActCfgIndex[this.ParentCode].Sort;
				if (!ActCfgIndex[this.ParentCode].Children) ActCfgIndex[this.ParentCode].Children=[];
				ActCfgIndex[this.ParentCode].Children.push(this);
			}
		})




		///��ѭ��һ������ȷ����֧ ExamNo��Ϊ�������� ʵ�ʾ��ǵǼ�
		var ExamArr=[],branchStartSort=1000;
		$.each(data.ActData,function(){
			if (ActCfgIndex[this.ActCode] && ActCfgIndex[this.ActCode].ParentCode ){
				this.ParentCode=ActCfgIndex[this.ActCode].ParentCode;
				this.ParentSort=ActCfgIndex[this.ActCode].ParentSort;
				return true;
			}
			if(typeof this.ExamNo=="string" && this.ExamNo!="" && this.Sort>0 && ActCfgIndex[this.ActCode] && ActCfgIndex[this.ActCode].ForceMaster!='Y' ){ //����  ȡ������м��� ȴ��ӦԤԼû�м���  //20220919 ����ǿ������֧ ��ǿ������֧�ڵ��ExamNo�������֧
				var ExamNo=this.ExamNo,Sort=this.Sort;
				if (ExamArr.indexOf(ExamNo)==-1) ExamArr.push(ExamNo);
				branchStartSort=Math.min(branchStartSort,Math.abs( parseFloat(this.Sort) ));
			}
		})
		data.ExamArr=ExamArr,data.branchStartSort=branchStartSort;
		var temp={};
		var BranchCount=0, //��֧��
			MasterChildProcessCount=0, //����֧ �������̵Ľڵ��������������Ǹ���
			BranchChildProcessCount=0;  //��֧ �������̵Ľڵ��������������Ǹ���
		$.each(data.ActCfg,function(){
			if (this.ParentCode) return true;
			var branches=[];
			for (var i=0;i<ExamArr.length;i++){
				var branchItem={state:0,data:[]};
				if(this.Children){
					var childProcessCount=0;
					branchItem.tempChildren={};
					$.each(this.Children,function(ind,item){
						var childSort=parseFloat(item.Sort);
						if (childSort>0) {
							branchItem.tempChildren[childSort]=$.extend({state:0,data:[]},item);
							childProcessCount++;
						}
					})
					if(parseFloat(this.Sort)>branchStartSort && this.ForceMaster!='Y') {  //add 20220919 ����ǿ������֧
						BranchChildProcessCount=Math.max(BranchChildProcessCount,childProcessCount);
					}
				}
				branches.push(branchItem);
			}

			var sort=parseFloat(this.Sort);
			if (sort>0) {
				if(sort>=branchStartSort && this.ForceMaster!='Y'){ //add 20220919 ����ǿ������֧ ǿ������֧û��branches
					temp[sort]=$.extend({state:0,data:[],branches:branches},this);
				}else{
					temp[sort]=$.extend({state:0,data:[]},this);
					if(this.Children){
						var childProcessCount=0;
						temp[sort].tempChildren={};
						$.each(this.Children,function(ind,item){
							var childSort=parseFloat(item.Sort);
							if (childSort>0) {
								temp[sort].tempChildren[childSort]=$.extend({state:0,data:[]},item);
								childProcessCount++;
							}
							MasterChildProcessCount=Math.max(MasterChildProcessCount,childProcessCount);
						})
					}
				}
			}
		})

		data.BranchCount=ExamArr.length;
		data.MasterChildProcessCount=MasterChildProcessCount;
		data.BranchChildProcessCount=BranchChildProcessCount;
		
		var hasNote=false,hasOprLoc=false;  //���������� �Ƿ��б�ע��Ϣ  �Ƿ��в���������Ϣ  �û��������ʱ����߶ȵ��ж�

		var bldClloectionAPIndArr=[]; //ȡѪ�������⴦��
		$.each(data.ActData,function(itemInd){
			this.OprUser=this.OprUser||'  '; //�п��ܻ��в�����Ϊ��
			var absSort=Math.abs( parseFloat(this.Sort) );
			var absParentSort=Math.abs( parseFloat(this.ParentSort) );
			if(!this.ParentCode && !temp[absSort] ) return true;  //���ݵ�λ����������û�� //���������� �ж�����˳����ڷ�
			if ( this.ParentCode && !temp[absParentSort] ) return true; //�������� �жϸ�����˳����ڷ�
			
			if(!this.ParentCode && this.Sort>0) {
				if(this.Note) hasNote=true;
				if(this.OprLoc) hasOprLoc=true;
			}
			
			var newItem=$.extend({},this,{OprDate:formatDateString(this.OprDate||'',dateFormat)});
			
			var isForceMaster=false;  //add 20220909 ǿ������֧
			if(!this.ParentCode && temp[absSort]&& temp[absSort].ForceMaster=='Y') isForceMaster=true; //���������� �ж�����˳����ǲ���ǿ������֧
			if(this.ParentCode && temp[absParentSort]&& temp[absParentSort].ForceMaster=='Y') isForceMaster=true;  //�������жϸ��ڵ��ǲ���ǿ������֧
			
			if(absSort>=branchStartSort && !isForceMaster){ //����֧  //add20220919 ����ǿ������֧ �Ž���֧
				var branchIndex=ExamArr.indexOf(this.ExamNo);
				if (branchIndex==-1) branchIndex=0; //ǰ�����˼���  ������Ī��û���� ������һ����֧
				if (this.ParentCode ) { //��������
					var branchItem=temp[absParentSort].branches[branchIndex];
					if (branchItem.tempChildren && branchItem.tempChildren[absSort]) {
						if (this.Sort<0) branchItem.tempChildren[absSort].state=2 //�����̽ڵ�������
						branchItem.tempChildren[absSort].data.push(newItem);
					}
				}else{
					if (!this.ExamNo&& (this.ActDesc=='ȡѪ����'||this.HISCode=='BLDCOLLECTIONAP')){ //ȡѪ�������⴦��
						bldClloectionAPIndArr.push(itemInd);
//						for (var mytempi=0;mytempi<ExamArr.length;mytempi++){
//							if(temp[absSort-1]&&temp[absSort-1].branches&&temp[absSort-1].branches[mytempi].data.length >0 ){ //ǰ��ڵ�������
//								if (this.Sort<0) temp[absSort].branches[mytempi].state=2; //�й�������
//								temp[absSort].branches[mytempi].data.push( $.extend({},newItem,{isFixData:true,ExamNo:temp[absSort-1].branches[mytempi].data[0].ExamNo}) );
//							}
//						}
					}else{
						if (this.Sort<0) temp[absSort].branches[branchIndex].state=2; //�й�������
						temp[absSort].branches[branchIndex].data.push( newItem );
					}

				}


				
			}else{
				if (this.ParentCode ) { //��������
					if (temp[absParentSort].tempChildren && temp[absParentSort].tempChildren[absSort]){
						if (this.Sort<0) temp[absParentSort].tempChildren[absSort].state=2; //�й�������
						temp[absParentSort].tempChildren[absSort].data.push( newItem );
					}

				}else{
					if (this.Sort<0) temp[absSort].state=2; //�й�������
					temp[absSort].data.push( newItem );
				}

			}
			

		})
		///ȡѪ���� ��Ϊ�жϺ���ڵ��Ƿ����
		$.each(bldClloectionAPIndArr,function(ind,itemInd){
			var actData=data.ActData[itemInd];
			var absSort=Math.abs( parseFloat(actData.Sort) );
			var nextSort=absSort+1;
			var newItem=$.extend({},actData,{OprDate:formatDateString(actData.OprDate||'',dateFormat)});
			
			for (var mytempi=0;mytempi<ExamArr.length;mytempi++){
				if(temp[nextSort]&&temp[nextSort].branches&&temp[nextSort].branches[mytempi].data.length >0 ){ //����ڵ�������
					if (actData.Sort<0) temp[absSort].branches[mytempi].state=2; //�й�������
					temp[absSort].branches[mytempi].data.push( $.extend({},newItem,{isFixData:true,ExamNo:temp[nextSort].branches[mytempi].data[0].ExamNo}) );
				}
			}
		})

		data.hasNote=hasNote;
		data.hasOprLoc=hasOprLoc;

		
		

		var canShowByTime=false;
		//������ʱ����ʾ �����ջ����ᰴ����ʱ���� �Ҹ��ݽڵ�˳����л���   û�з�֧ û�������� û�з��������ô��ʾ   2022-01-17����Ŀ��԰�ʱ����ʾ
		if (opts.showByTime && MasterChildProcessCount==0 && BranchChildProcessCount==0  && data.BranchCount<=1){  //�ж���ǰ
			canShowByTime=true;
		}

		//�����������Ϊһ�Զ� ��ѭ������
		if (isFollowNegativeState && !canShowByTime){   //2022-01-17 ��ʱ����ʾ�Ĳ����Զ�����
			$.each(temp,function(idx,item){
				item.data.sort(compareActData);
				var len=item.data.length;
				
				$.each(item.data,function(dataIdx){
					if(this.Sort<0 && !this.appendFlag && followNegativeActCode.indexOf(this.HISCode||this.ActCode)>-1) insertNegative(temp,this,idx,-1,dataIdx)
				})
				
				if(item.branches){
					$.each(item.branches,function(branchIdx,branch){
						branch.data.sort(compareActData);

						$.each(branch.data,function(dataIdx){
							if(this.Sort<0 && !this.appendFlag && followNegativeActCode.indexOf(this.HISCode||this.ActCode)>-1) insertNegative(temp,this,idx,branchIdx,dataIdx)
						})
						
					})
				}
			})
		}
		function insertNegative(tempData,negativeData,sortKey,branchIdx,dataIdx){
			sortKey=parseFloat(sortKey);
			
			var negativeExamNo=negativeData.ExamNo||'';
			var negativeBranchIdx=-1;
			if (branchIdx==-1 && negativeExamNo!=''){  //ȡ����� ��Ӧ�ڵ���ԤԼ������֧ ��ʱ��  ����ʵ���ǶԷ�֧���еĲ��� ���Ժ����Ĳ������������������� ��֧���Ƕ�Ӧ��֧ �������з�֧
				negativeBranchIdx= ExamArr.indexOf(negativeExamNo);
			}

			$.each(tempData,function(idx,item){
				if (idx>sortKey){
					if(branchIdx>-1){ //��֧�������� ֻȥ�ı�η�֧����
						if (insertToArray(item.branches[branchIdx].data)) item.branches[branchIdx].state=2;  //������� ����ֵΪtrue �൱�ڲ����������� ״̬Ҫ��Ϊ2
					}else if(negativeBranchIdx>-1){
						if ( insertToArray(item.data) ) item.state=2;
						if (item.branches){
							if (insertToArray(item.branches[negativeBranchIdx].data)) item.branches[negativeBranchIdx].state=2;  //������� ����ֵΪtrue �൱�ڲ����������� ״̬Ҫ��Ϊ2
						}
					}else{ //���������� Ҫ�ı�������������з�֧
						if ( insertToArray(item.data) ) item.state=2;
						if (item.branches){
							$.each(item.branches,function(){
								if(insertToArray(this.data)) this.state=2;
							})
						}
					}
				}
			})
			function insertToArray(dataArr){
				var beforeItem,insertFlag=false;
				$.each(dataArr,function(idx,item){
					if (compareActData(item,negativeData)<0){
						beforeItem=item;
					} else {
						return false;
					}
				})
				if (beforeItem && beforeItem.Sort>0){
					dataArr.push( $.extend({},negativeData,{Sort:-beforeItem.Sort,appendFlag:true}) );
					insertFlag=true;
				}
				dataArr.sort(compareActData);
				return insertFlag;
			}
		}
		
		function isOverTime(prevItem,showData,timeLimit,type,branchIdx){
			timeLimit=parseInt(timeLimit);
			if (!(timeLimit>0)) return false;
			if (!prevItem) return false;
			if (!showData || !(showData.Sort>0)) return false;
			
			var dateB=showData.OprDate,timeB=showData.OprTime
			var dateA='',timeA='';
			if(type=='master') { //����ʱ��   
				if (prevItem.branches) {  //add 20220919 ǿ������֧  ����ǰһ�ڵ�����Ƿ�֧
					//���ñ��ڵ�showData��ʱ�� �� ǰһ˳��ڵ����з�֧����ʾ�ڵ�������µ�ʱ����бȽ�
					for (var braLen=prevItem.branches.length,braInd=0;braInd<braLen;braInd++ ){
						if (prevItem.branches[braInd].showData && prevItem.branches[braInd].showData.Sort>0 ) {
							if (dateA=='') {
								dateA=prevItem.branches[braInd].showData.OprDate;
								timeA=prevItem.branches[braInd].showData.OprTime;
							}else if (  compareActData( {OprDate:dateA,OprTime:timeA},prevItem.branches[braInd].showData )<0  ){
								//�˽ڵ����ڸ���
								dateA=prevItem.branches[braInd].showData.OprDate;
								timeA=prevItem.branches[braInd].showData.OprTime;
							}
							
						}
						
					}
					
				}else {
					if (prevItem.showData && prevItem.showData.Sort>0) {
						dateA=prevItem.showData.OprDate;
						timeA=prevItem.showData.OprTime;
					}
					
				}
				
			}else if (type=='branch') { //��֧
				if (prevItem.branches) {  //ǰһ�ڵ��з�֧
					if (prevItem.branches[branchIdx] && prevItem.branches[branchIdx].showData && prevItem.branches[branchIdx].showData.Sort>0 ) {
						dateA=prevItem.branches[branchIdx].showData.OprDate;
						timeA=prevItem.branches[branchIdx].showData.OprTime;
					}
					
				}else{ //ǰһ�ڵ�Ϊ����
					if (prevItem.showData && prevItem.showData.Sort>0) {
						dateA=prevItem.showData.OprDate;
						timeA=prevItem.showData.OprTime;
					}
				}
				
			}
			
			if (!dateA || !timeA) return false;
			
			var flag=false;
			try {
				flag=($.orderview.calSeconds(dateA,timeA,dateB,timeB)>timeLimit)
			}catch(e){
				console.log(e);	
			}
			return flag;
			
		}
		
		data.ProcessData=[];
		data.ProcessGroup=[];
		var currGroup=null,groupColorMap={},colorInd=0,prevTempItem=null;  //prevTempItem �ϸ��ڵ�����
		$.each(temp,function(idx,item){
			var nodeHasPositiveState=0;
			item.data.sort(compareActData);
			var len=item.data.length;
			if (len>0){
				if (item.data[len-1].Sort>0){
					if (item.state==0) item.state=1
					if (item.state==2) item.state=3  //�й������� ����������˻���
				}
				if (item.state==1 || item.state==3) nodeHasPositiveState=1; //��˳��ڵ��Ƿ�������Ϊ����״̬
			}
			$.each(item.data,function(){  //��������������Ϊ��ʾ
				if (this.Sort>0){
					 item.showData=this;
					 item.isOverTime=isOverTime(prevTempItem,item.showData,item.TimeLimit,"master");
				}
			})

			if (item.tempChildren){
				item.children=[];
				var prevTempChildItem=null; //�ӽڵ����һ���ڵ�
				
				var itemChildrenSortKeys=Object.keys(item.tempChildren).sort();
				$.each(itemChildrenSortKeys,function(arrInd,cSortKey){  //$.each(item.tempChildren,function(cIdx,cItem){   ֱ��each ���򲻶�  2021-07-30
					var cItem=item.tempChildren[cSortKey];
					cItem.data.sort(compareActData);
					var len=cItem.data.length;
					if (len>0){
						if (cItem.data[len-1].Sort>0){
							if (cItem.state==0) cItem.state=1
							if (cItem.state==2) cItem.state=3  //�й������� ����������˻���
						}
						
					}
					$.each(cItem.data,function(){  //��������������Ϊ��ʾ
						if (this.Sort>0) {
							cItem.showData=this;
							cItem.isOverTime=isOverTime(prevTempChildItem,cItem.showData,cItem.TimeLimit,"master");  //child �൱��master
						}
					})
					item.children.push(cItem);
					prevTempChildItem=cItem;
				})
				
			}
			
			
			if(item.branches){
				$.each(item.branches,function(bIdx,branch){
					branch.data.sort(compareActData);
					var len=branch.data.length;
					if (len>0){
						if (branch.data[len-1].Sort>0){
							if (branch.state==0) branch.state=1
							if (branch.state==2) branch.state=3  //�й������� ����������˻���
						}
						if (branch.state==1 || branch.state==3) nodeHasPositiveState=1; //��˳��ڵ��Ƿ�������Ϊ����״̬
					}
					$.each(branch.data,function(){  //��������������Ϊ��ʾ
						if (this.Sort>0) {
							branch.showData=this;
							branch.isOverTime=isOverTime(prevTempItem,branch.showData,item.TimeLimit,"branch",bIdx);  //branch
						}
					})

					if (branch.tempChildren){
						branch.children=[];
						var prevTempChildItem=null; //�ӽڵ����һ���ڵ�
						var branchChildrenSortKeys=Object.keys(branch.tempChildren).sort();
						$.each(branchChildrenSortKeys,function(arrInd,cSortKey){    //$.each(branch.tempChildren,function(cIdx,cItem){   ֱ��each ���򲻶� 2021-07-30
							var cItem=branch.tempChildren[cSortKey];
							cItem.data.sort(compareActData);
							var len=cItem.data.length;
							if (len>0){
								if (cItem.data[len-1].Sort>0){
									if (cItem.state==0) cItem.state=1
									if (cItem.state==2) cItem.state=3  //�й������� ����������˻���
								}
								
							}
							$.each(cItem.data,function(){  //��������������Ϊ��ʾ
								if (this.Sort>0) {
									cItem.showData=this;
									cItem.isOverTime=isOverTime(prevTempChildItem,cItem.showData,cItem.TimeLimit,"master");  //child �൱��master
								}
							})
							branch.children.push(cItem);
							prevTempChildItem=cItem;
						})
						
					}

				})
			}
			var groupName=item.GroupName||'';
			
			if (!groupColorMap[groupName]) groupColorMap[groupName]=opts.processGroupColors[colorInd++]; //colorInd ͬʱ��1
			if (colorInd==opts.processGroupColors.length) colorInd=0;

			if (!currGroup ||currGroup.name!=groupName){
				currGroup={
					name:groupName,len:1,
					state:nodeHasPositiveState,
					headerBg:groupColorMap[groupName]['state'+nodeHasPositiveState].headerBg,
					bodyBg:groupColorMap[groupName]['state'+nodeHasPositiveState].bodyBg
				}
				data.ProcessGroup.push(currGroup);
			}else{
				currGroup.len++;
				if (nodeHasPositiveState==1) { //����ɫ���Ը���
					currGroup.state=nodeHasPositiveState,
					currGroup.headerBg=groupColorMap[groupName]['state'+nodeHasPositiveState].headerBg;
					currGroup.bodyBg=groupColorMap[groupName]['state'+nodeHasPositiveState].bodyBg;
				}
			}
			data.ProcessData.push(item);
			prevTempItem=item;
		})
		if (data.ProcessGroup.length==1 && data.ProcessGroup[0].name=='') data.ProcessGroup.pop(); //���ֻ��һ�� ���ǿ� ����Ϊû�з���

		if (data.PatOrdType=="0621" ||data.PatOrdType=="0721" ||data.PatOrdType=="0711"){
			if(!data.ChartList || data.ChartList.length==0) data.ChartList=[{Code:'ZXJL',Description:'ִ�м�¼',Url:'',JsFun:'renderOrderExecDetails'}];
		}

		//������ʱ����ʾ �����ջ����ᰴ����ʱ���� �Ҹ��ݽڵ�˳����л���   û�з�֧ û�������� û�з��������ô��ʾ   2022-01-17����Ŀ��԰�ʱ����ʾ
		if (canShowByTime){   //if (opts.showByTime && MasterChildProcessCount==0 && BranchChildProcessCount==0  && data.BranchCount<=1){  //�ж���ǰ
			var TimeProcessData=[];
			var lineTemp={},lastAbsSort=0;
			$.each(data.ActData,function(dataInd){
				this.OprUser=this.OprUser||'  '; //�п��ܻ��в�����Ϊ��
				var absSort=Math.abs( parseFloat(this.Sort) );
				if ( this.ParentCode) return true; //�������ټ�
				if (!temp[absSort]) return true; //
				
				if (absSort<lastAbsSort ) {  //��Ҫ������
					TimeProcessData.push(  sortData2Array(lineTemp) );
					lineTemp={};
				}
				lastAbsSort=absSort;
				var newItem=$.extend({},this,{OprDate:formatDateString(this.OprDate||'',dateFormat)});
				if (!lineTemp[absSort]) {
					var tempItem=temp[absSort];
					lineTemp[absSort]={
						ActCode:tempItem.ActCode,
						ActDesc:tempItem.ActDesc,
						Sort:tempItem.Sort,
						state:0,
						data:[],
						TimeLimit:tempItem.TimeLimit
					}
				}
				if (this.Sort<0) lineTemp[absSort].state=2; //�й�������
				lineTemp[absSort].data.push( newItem );
			})
			TimeProcessData.push(  sortData2Array(lineTemp) );
			
			data.TimeProcessData=TimeProcessData;

			
		}

		function sortData2Array(sortData){
			var arr=[];
			var prevTempItem=null;
			$.each(sortData,function(idx,item){
				var nodeHasPositiveState=0;
				item.data.sort(compareActData);
				var len=item.data.length;
				if (len>0){
					if (item.data[len-1].Sort>0){
						if (item.state==0) item.state=1
						if (item.state==2) item.state=3  //�й������� ����������˻���
					}
					if (item.state==1 || item.state==3) nodeHasPositiveState=1; //��˳��ڵ��Ƿ�������Ϊ����״̬
				}
				
				/*
				$.each(item.data,function(){  //��������������Ϊ��ʾ
					if (this.Sort>0) item.showData=this;
				})
				*/
				item.showData=item.data[len-1];  //�������� ���������ڵ���Ϊ��ʾ
				
				item.isOverTime=isOverTime(prevTempItem,item.showData,item.TimeLimit,"master");  
				
				arr.push(item);
				
				prevTempItem=item;
				
			})
			return arr;
		}


		/**
		 * 
		 * @param {*} a ����a
		 * @param {*} b ����b
		 */
		function compareActData(a,b){
			var aOprDate=a.OprDate,bOprDate=b.OprDate;
			if(aOprDate.indexOf('/')>-1) aOprDate=aOprDate.split('/').reverse().join('-');
			if(bOprDate.indexOf('/')>-1) bOprDate=bOprDate.split('/').reverse().join('-');
			if(aOprDate==bOprDate){
				if(a.OprTime==b.OprTime){
					//���� ʱ����ͬ �ٰ�Sort��  0,1,2,3,...,n,-n,...,-3,-2,-1
					var aSort=parseFloat(a.Sort||0)||0;
					var bSort=parseFloat(b.Sort||0)||0;
					//����С�ڸ��� ����ԽСԽС ����ԽСԽ��  //2021-06-18 ʵ�ʿ��� ����Ҳ��ԽСԽС ��-8Ӧ����-7
					var aSortV=aSort>=0?aSort:1000-Math.abs(aSort);
					var bSortV=bSort>=0?bSort:1000-Math.abs(bSort);
					if(aSortV==bSortV) return 0;
					if(aSortV<bSortV) return -1;
					return 1;
				} 
				if(a.OprTime<b.OprTime) return -1;
				return 1;
			}
			if(aOprDate<bOprDate) return -1;
			return 1;
		}
	}
	function renderOrders(ele,orderArray){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		$con.empty();
		$.data($con[0],'target',$ele);
		
		var $tabs_wrap=$('<div class="orderview-tabs-wrap"></div>').appendTo($con);
		var $tabs=$('<div class="orderview-tabs"></div>').appendTo($tabs_wrap);
		var $keywords=$('<ul class="orderview-tabs-kw kw-section-list keywords"></ul>').appendTo($tabs);
		$.each(orderArray,function(){
			$keywords.append('<li data-ord="'+this.ordId+'"><a>'+this.ordDesc+'</a></li>');
		})
		
		var $orderRenderTo=$('<div class="orderview-render-container"></div>').appendTo($con);
		var outerHeight=$con.height()-$con.find('.orderview-tabs-wrap').outerHeight();
		$orderRenderTo.outerHeight(outerHeight);
		
		$keywords.find('li').off('click').on('click',function(){
			$keywords.find('li.selected').removeClass('selected');
			$(this).addClass('selected');
		}).orderview({
			renderTo:$orderRenderTo,
			ordGetter:function(){
				return $(this).data('ord');
			}
		})
		$keywords.find('li').eq(0).trigger('click');
		
		
		
		$con.off('__resize.orderview').on('__resize.orderview',function(){
			
		})
		$con.triggerHandler('__resize.orderview');
	}
	function renderBefore(ele,data,after){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if((data.ButtonList && data.ButtonList.length)||(data.ChartList && data.ChartList.length) || (data.LoadCustomJS=='1')){  //��̨��LoadCustomJS��־ 2021-06-18
			var dataTypeCode=data.PatOrdType;
			var cateCode=dataTypeCode.substr(0,data.PatOrdType.length-2);
			opts.dataTypeCode=dataTypeCode;  //��¼���� ������
			opts.cateCode=cateCode;
			
			$.orderview.loadJs(opts.assetsBaseUrl+'/TimeLine/dhc.orderview.'+cateCode+'.js','gb18030',function(success){
				//��������Զ���labels ���Ҷ�̬���ص�js������labels
				if (!opts.isCustomLabels){
					if( $.fn.orderview.defaults['labels'+dataTypeCode]) {  //������ʾ�����ı�ǩ����
						opts.labels=$.fn.orderview.defaults['labels'+dataTypeCode];
					}else if ($.fn.orderview.defaults['labels'+cateCode]) { //��ʾ���ı�ǩ����
						opts.labels=$.fn.orderview.defaults['labels'+cateCode];
					}
				}
				//�Զ��������� ����label
				if (!opts.isCustomHideLabel){
					if( typeof $.fn.orderview.defaults['hideLabel'+dataTypeCode]!='undefined') {  //������ʾ�����Ķ���
						opts.hideLabel=$.fn.orderview.defaults['hideLabel'+dataTypeCode];
					}else if ( typeof $.fn.orderview.defaults['hideLabel'+cateCode] !='undefined') { //��ʾ���Ķ���
						opts.hideLabel=$.fn.orderview.defaults['hideLabel'+cateCode];
					}
				}

				//�Զ��������� ����label
				if (!opts.isCustomHideLabelIcon){
					if( typeof $.fn.orderview.defaults['hideLabelIcon'+dataTypeCode]!='undefined') {  //������ʾ�����Ķ���
						opts.hideLabelIcon=$.fn.orderview.defaults['hideLabelIcon'+dataTypeCode];
					}else if ( typeof $.fn.orderview.defaults['hideLabelIcon'+cateCode] !='undefined') { //��ʾ���Ķ���
						opts.hideLabelIcon=$.fn.orderview.defaults['hideLabelIcon'+cateCode];
					}
				}


				after();
			})
		}else{
			after();
		}
	}
	function renderAll(ele,data){
		//console.error('���ڵ��Լ��ಿλ,���ֿ�����ʾ����ȷ')
		//console.log(data);
		renderId=0
		//console.log(data);
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		$con.empty();
		$.data($con[0],'target',$ele);
		renderLabels(ele,data);
		if (data.ProcessData.length>0) renderProcess(ele,data);
		var hasTable=false;
		if(data.ChartList && data.ChartList.length>0){
			renderCharts(ele,data);
			hasTable=true;
		}
		$con.off('__resize.orderview').on('__resize.orderview',function(){
			//console.count('$con._resize.orderview')
			var $con=$(this);
			var ele=$.data($con[0],'target')[0];
			var state = $.data(ele, "orderview");
			var opts=state.options;
			var outerHeight=$con.height()-$con.children('.orderview-labels-wrap').outerHeight()-$con.children('.orderview-process-wrap').outerHeight();
			var outerWidth=$con.width();
			if (opts.chartsMinHeight && outerHeight<opts.chartsMinHeight) {
				outerHeight=opts.chartsMinHeight;
				outerWidth=outerWidth-20;
			}
			$con.children('.orderview-details-wrap').outerWidth(outerWidth).outerHeight(outerHeight);
			$con.children('.orderview-details-wrap').children('.panel.datagrid').triggerHandler('_resize');

			$con.children('.orderview-charts-wrap').outerWidth(outerWidth).outerHeight(outerHeight);
			$con.children('.orderview-charts-wrap').children('.panel.datagrid').triggerHandler('_resize');

			if (opts.data && opts.data.ProcessData && opts.data.ProcessData.length>0) renderProcess(ele,opts.data);

			$con.addClass('orderview-noscroll');   //�����Ӹ���ֹ�������� �Ժ��Ƴ�  ���Ա��ⲻ�ó��ֵĹ�����
			setTimeout(function(){
				$con.removeClass('orderview-noscroll');
			},200);
		})
		
		
		//render ���
		if ((opts.autoHeight||opts.autoMoreHeight) && !hasTable && opts.type=="trigger" && state.win){
			var headerHeight=$con.closest('.panel').children('.panel-header').outerHeight();
			var conInnerHeight=$con.find('.orderview-labels-wrap').outerHeight()+$con.find('.orderview-process-wrap').outerHeight();
			var totalHeight=headerHeight+conInnerHeight;
			if ( opts.autoHeight ||(opts.autoMoreHeight && totalHeight>opts.winHeight)){ //�Զ��߶� ���� �Զ�����߶��Ҹ߶ȳ�����ǰ
				//debugger;
				state.win.window('move',{left:0,top:0})
						 .window('resize',{height:Math.min($(window).height()-20,totalHeight)})
						 .window('center');
			}

		}
		
		$con.triggerHandler('__resize.orderview');
		
		
		$con.find('.orderview-a-link').off('click.orderview').on('click.orderview',function(){
			var link=$(this).data('link');
			var features=$(this).data('features');	
			if (link) {
				var features=$.orderview.formatFeatures(features||'hisui=true');
				if (typeof features=='string'){
					$.orderview.easyOriginWin(link,'orderview-a-link-win',features);
				}else{ //
					$.orderview.easyModal(features.title,link,features.width,features.height,'',false);
				}
				
			}
			
			
		})
		
	}
	function renderLabels(ele,data){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		
		var $labels_wrap=$con.find('.orderview-labels-wrap');
		if ($labels_wrap.length==0){
			$labels_wrap=$('<div class="orderview-labels-wrap"></div>').appendTo($con);
		}
		var $labels=$('<div class="orderview-labels"></div>');

		if (opts.hideLabel){ //����label
			$labels.addClass('orderview-labels-empty');
			$labels.appendTo($labels_wrap);
			return;
		}

		if (!opts.hideLabelIcon) { //�����ػ���ͼ��
			var $labels_icon=$('<div class="orderview-labels-icon "></div>').appendTo($labels);
			var PatSex=''+data.PatSexZH+data.PatSex;
			if (PatSex.indexOf('��')>-1) $labels_icon.addClass('orderview-labels-icon-man');
			if (PatSex.indexOf('Ů')>-1) $labels_icon.addClass('orderview-labels-icon-woman');
		}else{ //����ͼ��
			$labels.addClass('orderview-labels-no-icon')
		}
		var $labels_biz = $('<div class="orderview-labels-biz"></div>');
		$.each(opts.labels,function(){
			var $labels_row=$('<div class="orderview-labels-row"></div>');
			$.each(this,function(ind,item){
				var label=$g(item.label||"empty"),key=item.key;
				if (typeof data[key]!="undefined" && data[key]!=''){
					var value=data[key];
					if (item.type && item.type=="date") value=formatDateString(value,opts.dateFormat);
					if ($labels_row.find('.orderview-labels-cell-value').length>0 ) {
						if (item.hideSep) $labels_row.append('&nbsp;&nbsp;');
						else $labels_row.append('<span class="orderview-labels-cell-sep">/</span>');
						
					}
					if (!item.hideLabel) $labels_row.append('<span class="orderview-labels-cell-label">'+label+'��</span>');
					var $value=$('<span class="orderview-labels-cell-value">'+value+'</span>');
					if (item.css) $value.css(item.css)
					$labels_row.append($value);
				}
			})
			//debugger;
			if (1){ /*wanghc 2021-10-18*/
				if ($labels.find('.orderview-labels-row').length>=1){
					if ($labels_row.find('.orderview-labels-cell-value').length>0) $labels_row.appendTo($labels_biz);
				}else{
					if ($labels_row.find('.orderview-labels-cell-value').length>0) $labels_row.appendTo($labels);
				}
			}else{
				if ($labels_row.find('.orderview-labels-cell-value').length>0) $labels_row.appendTo($labels);
			}
		});
		if($labels.find('.orderview-labels-row').length==0){
			$labels.addClass('orderview-labels-empty');
		}
		if($labels_biz.find('.orderview-labels-row').length==0){
			$labels_biz.addClass('orderview-labels-empty');
		}
		$labels.appendTo($labels_wrap);
		$labels_biz.appendTo($labels_wrap);
		if (typeof data.ButtonList=='object' && data.ButtonList.length>0){
			var $labels_buttons=$('<div class="orderview-labels-buttons"></div>').appendTo($labels);
			$.each(data.ButtonList,function(ind,item){
				var $btn=$('<a class="orderview-labels-buttons-cell">'+item.Description+'</a>').appendTo($labels_buttons);
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
			//Code:%String:�˵�����,Description:%String:�˵�����,Url:%String:����,ValExpr:%String:���ʽ,JsFun:%String:Js����,JsFile:%String:Js�ļ���"��NewWindow:"top=10,width=100"
			if (buttonData.Type=="1321" || buttonData.Type=="1331"){
				if (buttonData.Url.indexOf("&InstanceID=&")>-1){
					$.messager.alert('��ʾ','�˻���δ��ɲ������顣');
					return ;
				}
				
			}
			if (buttonData.Url) {
				var url=buttonData.Url;
				url+=(url.indexOf('?')>-1?'&':'?')+'ordItemId='+(opts.orders[0]||'');
				if (buttonData.ValExpr) url+=url.indexOf('?')>-1?'':'?a=a'+buttonData.ValExpr;
				url=$.orderview.parseTmpl(url,opts.ARGDATA)
				
				var features=$.orderview.formatFeatures(buttonData.NewWindow||'hisui=true');
				if (typeof features=='string'){
					$.orderview.easyOriginWin(url,'orderview-btn-'+buttonData.Code,features);
				}else{ //
					$.orderview.easyModal(buttonData.Description,url,features.width,features.height,$con,false);
				}
			}else if(buttonData.JsFun){
				var tempJsFun=getMenuJsFun(buttonData.JsFun,opts.cateCode,opts.dataTypeCode); //cryze 2021-10-21
				if (tempJsFun){
					var features=$.orderview.formatFeatures(buttonData.NewWindow||'hisui=true');
					var easyModal=$.orderview.easyModal(buttonData.Description,'',features.width,features.height,$con,false);
					tempJsFun(ele,data,buttonData,easyModal.find('>.panel>.dialog-content'));
				}else{
					$.messager.popover({msg:buttonData.JsFun+'δ���壬����ϵ��Ϣ����',type:'alert'})
				}
			}else{
				$.messager.popover({msg:buttonData.Description+'���ò���ȷ,����ϵ��Ϣ����',type:'alert'})
			}
		}
		
		
	}
	
	///��ȡ ��ť��ͼ�����JS���� ��ǰ��ֱ�Ӷ�����window�µģ��������űջ�Խ��Խ�� ���ܻ��ͻ //cryze 2021-10-21
	function getMenuJsFun(funName,cateCode,dataTypeCode){
		var tempJsFun=null,o=window.ORDERVIEW_FUNC;
		if (o && dataTypeCode && o['f'+dataTypeCode]&& typeof o['f'+dataTypeCode][funName]=='function' ){ //����ȡ��ʾ�����¶����
			tempJsFun=o['f'+dataTypeCode][funName];
		}else if (o && cateCode && o['f'+cateCode]&& typeof o['f'+cateCode][funName]=='function' ){ //���ȡ��ʾ���¶����
			tempJsFun=o['f'+cateCode][funName];
		}else if( typeof window[funName]=='function' ){ //���ȡwindow�µ�
			tempJsFun=window[funName];
		}
		return tempJsFun;
		
	}
	
    //��Ⱦ�仯����
    function renderProcess(ele,data){
		//console.log(data)
		//$.messager.popover({msg:'���ڵ��ԣ����ܻ��б���',type:'error'});
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');
		var processData=data.ProcessData;

		
		var $process_wrap=$con.find('.orderview-process-wrap');
		if ($process_wrap.length==0){
			$process_wrap=$('<div class="orderview-process-wrap"></div>').appendTo($con);
		}
		
		var num=Math.max(1,data.ExamArr.length);
		var branchHeight=135;

		if(!data.hasNote) branchHeight=branchHeight-19;
		if(data.hasOprLoc && opts.showOprLoc) branchHeight=branchHeight+19;
		if(!opts.showOprUser) branchHeight=branchHeight-19; //���ز����û�
		
		var totalHeight=0;
		if (opts.type=="container"){
			if ($ele.prop('tagName')=="BODY"){
				totalHeight=$(window).height();
			}else{
				totalHeight=$ele.height();
			}
		}else{
			if (state.win){
				if(opts.autoFitWin || opts.autoHeight || opts.autoMoreHeight) {
					totalHeight=$(window).height()-20;
				}else{
					totalHeight=opts.winHeight;
				}
			}else{
				totalHeight=$(opts.renderTo).height();
			}
		}
		var childHeight=60,childHeightFix=0;
		var oneBranchTotalHeight=branchHeight+(data.BranchChildProcessCount>0?(childHeight*data.BranchChildProcessCount+childHeightFix):0);
		var masterTotalHeight=branchHeight+(data.MasterChildProcessCount>0?(childHeight*data.MasterChildProcessCount+childHeightFix):0);
		var branchesHeight=oneBranchTotalHeight*num;
		if (num>1 && data.BranchChildProcessCount>0) branchesHeight=branchesHeight+ Math.floor(num/2)*childHeight ;//���·���������� Ҫ��һ���߶Ȳ���
		var topFix=0; //�����ߵ������̽ϸ�ʱ ����߶�ƫ�Ʋ���
		if(num%2==0){ //ż��
			topFix=masterTotalHeight-(branchHeight/2)-oneBranchTotalHeight*Math.ceil(num/2);
		}else{
			topFix=masterTotalHeight-oneBranchTotalHeight*Math.ceil(num/2);
		}
		if (topFix>0) branchesHeight=branchesHeight+topFix;
		var lineSpacing=30;
		if (data.TimeProcessData && data.TimeProcessData.length>0 ) {  //��ʱ�仭�� 
			branchesHeight=data.TimeProcessData.length*branchHeight + (data.TimeProcessData.length-1)*lineSpacing;
		}
		var processConHeight= branchesHeight+((data.ProcessGroup && data.ProcessGroup.length>0)?(24+5+10+10):0);



		
		if (totalHeight>0 && $con.find('.orderview-labels-wrap').outerHeight()+processConHeight>$con.height()){
			$process_wrap.outerWidth($con.width()-18 );
        }
        renderProcessDom($process_wrap,processData,{
			branchHeight:branchHeight,
	        num:num,
	        processDetailPopover:true,
	        branchStartSort:data.branchStartSort,
	        maxStepWidth:opts.maxStepWidth,
	        lineFollowState0:opts.lineFollowState0,
			branchStyle:opts.branchStyle,
			masterChildProcessCount:data.MasterChildProcessCount,
			branchChildProcessCount:data.BranchChildProcessCount,
			childHeight:childHeight,
			childHeightFix:childHeightFix,
			lineSpacing:lineSpacing,
			showByTimeStyle:opts.showByTimeStyle
			,showOprLoc:opts.showOprLoc
			,showOprUser:opts.showOprUser
			,uiVer:opts.uiVer
			,nodeStyle:opts.nodeStyle
			,hasOprLoc:data.hasOprLoc
			,hasNote:data.hasNote
	    },data.ProcessGroup,data.TimeProcessData)
    }
    
    
    //��process_wrap��Ԫ�� ��renderProcess�����ó��� Ϊ�˾�����ϸʱ����Ҳ����ʹ��
    /*otherParams:{
		branchHeight:'��֧�߸�Number',
		num:'��֧��Number',
		maxStepWidth:'��󲽳�Number',
		lineFollowState0:'��ɫ�ڵ�ǰ����Ϊ��ɫ',
		branchStyle:'1б��2����',
		processDetailPopover:'�ڵ���ϸ�Ƿ�Ҫ��ʾ',
		branchStartSort:'��֧��ʼ�ڵ�Sord'
		masterChildProcessCount:'����֧�����̽ڵ���'
		branchChildProcessCount:'��֧�������̽ڵ���'
		childHeight:'�����̸߶�'
		childHeightFix:'�����̸߶�ƫ��'
		lineSpacing:'��ʱ�仭��ʱ��ÿ���߼���'
		showByTimeStyle:'��ʱ�仭��ʱ������ʽ 1����ҳ�,���ع��һ���� ��2�Ͻ��³����������ع��һ����'
		showOprLoc:'��ʾ��������'
		showOprUser:'��ʾ�����û�'
		uiVer:ui�汾
		nodeStyle:�ڵ���ʽ
		hasOprLoc:'�Ƿ��в�������'
		hasNote:'�Ƿ��б�ע'
	}*/
	function renderProcessDom(processWrap,processData,otherParams,processGroup,timeProcessData){
		//console.log(processData)
		if (!$proxyContainer) $proxyContainer=$('<div class="orderview-proxy-container"></div>').appendTo('body');
		processGroup=processGroup||[];
		//console.log(processData);
		//console.log(otherParams);
        var branchHeight=otherParams.branchHeight||95,
            num=otherParams.num||1,
            opts=$.extend({},otherParams),
            $process_wrap=processWrap,
			lineSpacing=otherParams.lineSpacing||30,
			showByTimeStyle=otherParams.showByTimeStyle||1
			;
        var $process=$('<div class="orderview-process"></div>');

		var totalWidth=$process_wrap.width();

		///����ÿ��˳��ڵ�ĵĿ�� ��ϸ
		var detMaxWidthArr=[],allDetMaxWidth=0;
		$.each(processData,function(){
			var detMaxWidth=getOneMaxDetailWidth(this);
			detMaxWidthArr.push(detMaxWidth);
			if (detMaxWidth>allDetMaxWidth) allDetMaxWidth=detMaxWidth;
			
		})

		
		if (opts.nodeStyle==2) {
			var len=processData.length,firstLabelWidth=getLabelWidth(processData[0]),lastLabelWidth=getLabelWidth(processData[len-1]);
			var lastDetMaxWidth=detMaxWidthArr[len-1];
			var firstLabelFix=firstLabelWidth/2,  //�׸��ڵ�Ԥ��
				lastLabelFix=Math.max((lastDetMaxWidth-lastLabelWidth/2),lastLabelWidth/2);  //���ڵ�Ԥ�����
			
			totalWidth=totalWidth-firstLabelFix-lastLabelFix;   
			var startP=firstLabelFix; 
		}else{
			var len=processData.length;
			var lastDetMaxWidth=detMaxWidthArr[len-1];
			var firstDetMaxWidth=detMaxWidthArr[0];
			var firstLabelWidth=Math.max(getLabelWidth(processData[0]),firstDetMaxWidth),lastLabelWidth=Math.max(getLabelWidth(processData[len-1]),lastDetMaxWidth);
			var firstLabelFix=firstLabelWidth/2,  //�׸��ڵ�Ԥ��
				lastLabelFix=lastLabelWidth/2;   //���ڵ�Ԥ�����
				totalWidth=totalWidth-firstLabelFix-lastLabelFix;   
			var startP=firstLabelWidth/2; 
		}

		
		var pointRadius=12; 
		var lastNodeChildFix=0;  //���ڵ������������ Ҫ�и���Ȳ���
		if (processData[len-1]  && processData[len-1].Children && processData[len-1].Children.length>0 ){  //���ڵ���������
			lastNodeChildFix=(pointRadius+5+80)-lastLabelWidth/2;
		}
		totalWidth=totalWidth-lastNodeChildFix;  //lastNodeChildFix Ԥ�����ڵ������̶�����Ŀ��
		
		if (processGroup.length>0) { //����
			totalWidth=totalWidth-20; //�ܵ����� -20
			startP=startP+10; //��ʼ����10
		}
		var step=opts.maxStepWidth;
		if (len>1) step=parseFloat(totalWidth/(len-1)).toFixed(2);

		step=Math.min(opts.maxStepWidth,step);
		
		var processSrollWidth=0,minStepWidth=allDetMaxWidth+10;
		if (step<minStepWidth) {  //��ϸ��Ȼ���ಽ��  
			totalWidth=totalWidth+(minStepWidth-step)*(len-1);
			step=minStepWidth;
			
			processSrollWidth=opts.uiVer=='lite'?8:18;  //������

			
		}

		if (step<80) { //���̽ڵ���࣬�������С������ϸ�����С
			$process.addClass('orderview-process-mini-det');
			$proxyContainer.addClass('orderview-process-mini-det');
		}
		
		$process.data('step',step); //����
		$process.data('lineCount', num>1?num:( (timeProcessData&&timeProcessData.length>1)?timeProcessData.length:1) );  //����

		var branchChildProcessCount=opts.branchChildProcessCount||0,
			masterChildProcessCount=opts.masterChildProcessCount||0,
			childHeight=opts.childHeight||0,
			childHeightFix=opts.childHeightFix||0;
		
		var hasChildProcess=(branchChildProcessCount>0)||(masterChildProcessCount>0);
		var oneBranchTotalHeight=branchHeight+(branchChildProcessCount>0?(childHeight*branchChildProcessCount+childHeightFix):0);
		var masterTotalHeight=branchHeight+(masterChildProcessCount>0?(childHeight*masterChildProcessCount+childHeightFix):0);
		var branchesHeight=oneBranchTotalHeight*num;
		if (num>1 && branchChildProcessCount>0) branchesHeight=branchesHeight+ Math.floor(num/2)*childHeight ;//���·���������� Ҫ��һ���߶Ȳ���
		var topFix=0; //�����ߵ������̽ϸ�ʱ ����߶�ƫ�Ʋ���
		if(num%2==0){ //ż��
			topFix=masterTotalHeight-(branchHeight/2)-oneBranchTotalHeight*Math.ceil(num/2)
		}else{
			topFix=masterTotalHeight-oneBranchTotalHeight*Math.ceil(num/2)
		}

		if (topFix>0) branchesHeight=branchesHeight+topFix;

		if (timeProcessData && timeProcessData.length>0 ) {  //��ʱ�仭�� 
			branchesHeight=timeProcessData.length*branchHeight + (timeProcessData.length-1)*lineSpacing;
		}

		var processConHeight= branchesHeight+(processGroup.length>0?(24+5+10+10):0)+processSrollWidth; // //��֧���ݸ�+header+padding

		processConHeight=processConHeight-6;

		
		$process.height(processConHeight);

		

		
		var groupStart=0;labelInd=0
		$.each(processGroup,function(idx,group){
			var groupLeft=parseInt(0+startP+labelInd*step-step/2+5);
			if (idx==0) groupLeft=0
			labelInd=labelInd+group.len;
			var groupRight=parseInt(0+startP+labelInd*step-step/2-5);
			if (idx==processGroup.length-1) {
				
				groupRight=totalWidth+firstLabelFix+lastLabelFix+20+lastNodeChildFix;  //lastNodeChildFix���ڵ��������Ҳಹ��
				
			}
			var groupWidth=groupRight-groupLeft;
			
			var groupTop=0,
				groupHeight=branchHeight*num+24+5+20,
				groupStyle='left:'+groupLeft+'px;top:'+groupTop+'px;width:'+groupWidth+'px;height:'+groupHeight+'px;background-color:'+group.bodyBg+';';
			
			
			$('<div class="orderview-process-group" style="'+groupStyle+'">'
				+'<div class="orderview-process-group-header orderview-process-group-header-state'+group.state+'" style="background-color:'+group.headerBg+';">'+group.name+'</div>'
				+'</div>').appendTo($process);
		})
		
		//var pointRadius=12;  //�ŵ�ǰ�� 
		var pointBaseStyle='width:'+2*pointRadius+'px;height:'+2*pointRadius+'px;border-radius:'+pointRadius+'px;line-height:'+2*pointRadius+'px;';
		var LastPointState={}; //��һ���ڵ�״̬
		var processGroupFixTop=processGroup.length>0?(24+5+10):0 ; //�����з��� topҪ���ӳ������header padding
		var masterBaseTop=processGroupFixTop+(num-1)*branchHeight/2;
		if (hasChildProcess){
			if(num%2==0){ //ż��
				masterBaseTop=processGroupFixTop+(topFix>0?topFix:0)+ oneBranchTotalHeight*Math.ceil(num/2) - branchHeight/2;
			}else{
				masterBaseTop=processGroupFixTop+(topFix>0?topFix:0)+ oneBranchTotalHeight*Math.ceil(num/2) - branchHeight;
			}
		}

		var sort2NodeInd={}
		$.each(processData,function(idx){
			sort2NodeInd[this.Sort]=idx;
		})

		if (timeProcessData && timeProcessData.length>0 ) {
			//��ѭ��һ�鲹��ɫ�ĵ� 
			// 1.ÿһ�нڵ㲻����Ծ�������Ծ �����ɫ�ڵ�
			// 2.���һ�б�֤����ڵ����������û�У������ɫ�ڵ�����
			$.each(timeProcessData,function(lineIdx,lineOne){
				var tempOneLine=[],lastNodeInd=-1;
				$.each(lineOne,function(idx,one){
					var nodeInd=sort2NodeInd[one.Sort];
					if (nodeInd-lastNodeInd>1 && (idx>0 || lineIdx==0)) {  //��ڵ��� ���ǵ�һ�ڵ�����ǵ�һ�нڵ�
						for (var tempInd=lastNodeInd+1;tempInd<nodeInd;tempInd++) {
							tempOneLine.push(
								{
									ActCode:processData[tempInd].ActCode,
									ActDesc:processData[tempInd].ActDesc,
									Sort:processData[tempInd].Sort,
									data:[],state:0
								}
							)
						}
					}
					tempOneLine.push(one);
					lastNodeInd=nodeInd;
				})
				if (lineIdx==timeProcessData.length-1 && lastNodeInd<processData.length-1) {  //���һ������ Ҫ�ع��յ�  û���ݾͲ����ɫ
					for (var tempInd=lastNodeInd+1;tempInd<=processData.length-1;tempInd++) {
						tempOneLine.push(
							{
								ActCode:processData[tempInd].ActCode,
								ActDesc:processData[tempInd].ActDesc,
								Sort:processData[tempInd].Sort,
								data:[],state:0
							}
						)
					}
				}


				timeProcessData[lineIdx]=tempOneLine;
			})


			var firstLineCurrNodeInd=-1;
			$.each(timeProcessData,function(lineIdx,lineOne){    //
				var timeLineBaseTop=processGroupFixTop+lineIdx*branchHeight+lineIdx*lineSpacing;

				
				var lastLineTop=-1;
				$.each(lineOne,function(idx,one){
					var nodeInd=sort2NodeInd[one.Sort];
					var isLastNode=(nodeInd==len-1);

					var thisTimeLineBaseTop=timeLineBaseTop;

					if (nodeInd>firstLineCurrNodeInd && lineIdx>0 ) {  //��ǰ�ڵ��ڵ�һ��û�� �ع鵽��һ��ȥ  
						if (showByTimeStyle=='1') { //add 2022-01-14 showByTimeStyle=1 �Żع�
							thisTimeLineBaseTop=processGroupFixTop;
						}
						
					}
					

					var baseLeft=0+startP+nodeInd*step;
					var lineLeft=baseLeft-step;
					var pointLeft=baseLeft-pointRadius;
					var lineTop=20+13+thisTimeLineBaseTop;
					var pointTop=20+(13+3)-pointRadius+thisTimeLineBaseTop;
					var lineStyle='position:absolute;top:'+lineTop+'px;left:'+lineLeft+'px;width:'+step+'px;';
					var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
					if(idx>0){
						var lineState=one.state;
						if (lastLineTop>0 && lastLineTop!=lineTop ) { // �߶Բ��� ˵���Ǵ�ĳһ�е�һ�λع鵽��һ�� ��Ҫ������
							var regrHtml=getRegressionLineHtml(lineLeft,lastLineTop,lineLeft+step,lineTop,step-60,lineState,one.isOverTime);
							$process.append(regrHtml);

						}else{  //�ع鵽��һ��
							$process.append('<div class="orderview-process-line orderview-process-state'+lineState+(one.isOverTime?' orderview-process-state9':'')+'" style="'+lineStyle+'"></div>');
						}
						
					}
					lastLineTop=lineTop;

					if (idx==lineOne.length-1 && lineIdx<timeProcessData.length-1) {  //���һ�ڵ� �Ҳ������һ��   ���һ��Ҫ���ӵ���һ�е�һ����
						var nextOne=timeProcessData[lineIdx+1][0] ;
						//�� �� �� ��
						var nextNodeInd=sort2NodeInd[nextOne.Sort];
						var nextBaseLeft=0+startP+nextNodeInd*step;
						var nextLineLeft=nextBaseLeft-step;
						var nextTimeLineBaseTop=timeLineBaseTop+branchHeight+lineSpacing;
						var nextLineTop=20+13+nextTimeLineBaseTop;
						
						if(showByTimeStyle=='2'){  //�³� ���� ���£��ӵ��Ϸ����룩
							var fixTop1=0;
							if(opts.hasNote &&!(one.showData&&one.showData.Note)) fixTop1+=19 //�����б�ע �˽ڵ���û��ʾ��ע 
							if(opts.hasOprLoc && opts.showOprLoc &&!(one.showData&&one.showData.OprLoc)) fixTop1+=19 //�����п�������ʾ �˽ڵ���û��ʾ���� 
							
							var left1=lineLeft+step,
								top1=nextTimeLineBaseTop-lineSpacing- fixTop1  , //����Ϊ��һ�л����߶�-��� ���û�б�ע�ټ�ȥ��ע�߶�  //��Ҫ�������Ƿ��б�ע�Ϳ���
								left2=nextLineLeft+step,
								top2=nextTimeLineBaseTop,
								height2=top2-top1-20;
							var connHtml=getNextLineConnLineHtml(left1,top1,left2,top2,0, height2,nextOne.state ,nextOne.isOverTime)
						}else if(showByTimeStyle=='3'){  //�ӵ�ǰ�ߺ���һ�������ڵ�һ�µ�˳��ڵ� ���»�������

							//var nextNodeInThisLine=lineOne[nextNodeInd]; 
							// nextNodeInd��ȡ���������˳��������������˳�� ������������ڱ����ߵ�����˳�� Ҫ��ȡ�������ϵ�˳����ͬ�Ľڵ� 2023-01-12
							var nextNodeInThisLine=$.hisui.getArrayItem(lineOne,'Sort',nextOne.Sort);
							
							var fixTop1=0;
							if(opts.hasNote &&!(nextNodeInThisLine&&nextNodeInThisLine.showData&&nextNodeInThisLine.showData.Note)) fixTop1+=19 //�����б�ע �˽ڵ���û��ʾ��ע 
							if(opts.hasOprLoc && opts.showOprLoc &&!(nextNodeInThisLine&&nextNodeInThisLine.showData&&nextNodeInThisLine.showData.OprLoc)) fixTop1+=19 //�����п�������ʾ �˽ڵ���û��ʾ���� 
							
							
							var left1=nextLineLeft+step,
								top1=nextTimeLineBaseTop-lineSpacing-  fixTop1, //����Ϊ��һ�л����߶�-��� ���û�б�ע�ټ�ȥ��ע�߶� //��Ҫ�������Ƿ��б�ע�Ϳ���
								left2=nextLineLeft+step,
								top2=nextTimeLineBaseTop,
								height2=top2-top1;
							var connHtml=getNextLineConnLineHtml(left1,top1,left2,top2,0, height2,nextOne.state ,nextOne.isOverTime)



						}else{ //1 �ҳ� ���� ���� ���£��ӵ��Ϸ����룩
							var left1=lineLeft+step,top1=lineTop,left2=nextLineLeft+step,top2=nextTimeLineBaseTop,height2=top2-top1-20;
							var connHtml=getNextLineConnLineHtml(left1,top1,left2,top2,60, height2,nextOne.state,nextOne.isOverTime )
						}

						$process.append(connHtml);


					}


					$process.append('<div class="orderview-process-point orderview-process-state'+one.state+(one.isOverTime?' orderview-process-state9':'')+'" style="'+pointStyle+'">'+(nodeInd+1)+'</div>');
					
	
	
					var labelPos=appendNodeLabel($process,one,thisTimeLineBaseTop,baseLeft,pointRadius,totalWidth,nodeInd,'',otherParams.branchStartSort,isLastNode);
	
					appendNodeDetails($process,one,thisTimeLineBaseTop,baseLeft,pointRadius,totalWidth,nodeInd,'',isLastNode,lineIdx+'-'+idx,labelPos);
		
					if(nodeInd>firstLineCurrNodeInd) firstLineCurrNodeInd=nodeInd;


				})
			})


		}else{
			var prevSortNode={isMaster:true};
			$.each(processData,function(idx,one){
				var isLastNode=(idx==len-1);
				var baseLeft=0+startP+idx*step;
				var lineLeft=baseLeft-step;
	
				var pointLeft=baseLeft-pointRadius;
				//var labelLeft=baseLeft-one.ActDesc.length*7;
				//var detailLeft=baseLeft-40;   //������ϸ���� ���ܹ�80��
				if (one.Sort<otherParams.branchStartSort || one.ForceMaster=='Y'){  //add 20220919 ǿ������֧
					var lineTop=20+13+masterBaseTop;  
					var pointTop=20+(13+3)-pointRadius+masterBaseTop;
					var lineStyle='position:absolute;top:'+lineTop+'px;left:'+lineLeft+'px;width:'+step+'px;';
					var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
					if(idx>0){
						var lineState=one.state;
						if (prevSortNode.isMaster) { //add 20220919 ǰһ�ڵ�������֧
							if (opts.lineFollowState0 && LastPointState['master']==0) lineState=0;
							$process.append('<div class="orderview-process-line orderview-process-state'+lineState+(one.isOverTime?' orderview-process-state9':'')+'" style="'+lineStyle+'"></div>');
						}else{
							//add 20220919 ��֧��һ��
							if(opts.branchStyle==2){
								
								$.each(prevSortNode.branches,function(prevSortNodeBInd,prevSortNodeBItem){
									
									var brokenLineHtml=getBrokenLineHtml2(lineLeft,prevSortNodeBItem.top,lineTop,step,prevSortNodeBItem.state,lineState,prevSortNodeBInd,prevSortNode.branches.length,one.isOverTime,0.5);
									$process.append(brokenLineHtml);
									
								})
								
							}else{
								$.each(prevSortNode.branches,function(prevSortNodeBInd,prevSortNodeBItem){
									
									lineStyle=getRotateLineStyle(lineLeft,prevSortNodeBItem.top,lineTop,step);
									$process.append('<div class="orderview-process-line orderview-process-state'+lineState+(one.isOverTime?' orderview-process-state9':'')+'" style="'+lineStyle+'"></div>');
									
								})
								
							}
						}
					}
					$process.append('<div class="orderview-process-point orderview-process-state'+one.state+(one.isOverTime?' orderview-process-state9':'')+'" style="'+pointStyle+'">'+(idx+1)+'</div>');
					LastPointState['master']=one.state;
	
	
					var labelPos=appendNodeLabel($process,one,masterBaseTop,baseLeft,pointRadius,totalWidth,idx,'',otherParams.branchStartSort,isLastNode);
	
					appendNodeDetails($process,one,masterBaseTop,baseLeft,pointRadius,totalWidth,idx,'',isLastNode,null,labelPos);
	
					if(one.children){
						appendNodeChildren($process,one,masterBaseTop,pointLeft,pointRadius,totalWidth,pointBaseStyle,branchHeight,childHeight,childHeightFix,idx,'','top',isLastNode);
					}
					prevSortNode={
						isMaster:true	
					}
					
				}else{ //��֧
					prevSortNodeBranches=[]; //add 20220919 ��һ�ڵ��֧��¼
					
					$.each(one.branches,function(branchIdx,branch){
						var branchBaseTop=processGroupFixTop+branchIdx*branchHeight;
						if(hasChildProcess){
							if(num%2==0){ //ż��
								if(branchIdx<num/2) branchBaseTop=processGroupFixTop+(topFix>0?topFix:0)+(branchIdx+1)*oneBranchTotalHeight-branchHeight;
								else  branchBaseTop=processGroupFixTop+(topFix>0?topFix:0)+(branchIdx)*oneBranchTotalHeight
							}else{
								if(branchIdx<num/2) branchBaseTop=processGroupFixTop+(topFix>0?topFix:0)+(branchIdx+1)*oneBranchTotalHeight-branchHeight;
								else  branchBaseTop=processGroupFixTop+(topFix>0?topFix:0)+(branchIdx)*oneBranchTotalHeight
							}
							 
						}
						var lineTop=branchBaseTop+20+13;
						var pointTop=branchBaseTop+20+(13+3)-pointRadius;
						var lineStyle='position:absolute;top:'+lineTop+'px;left:'+lineLeft+'px;width:'+step+'px;';
	
						var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
						if(idx>0){
							var lineState=branch.state;
							if (opts.lineFollowState0 && LastPointState[branchIdx]==0) lineState=0; //ȡǰһ�ڵ�state
							//if (one.Sort==otherParams.branchStartSort){
							if (prevSortNode.isMaster) { //add 20220919 ǰһ�ڵ�������֧
								var isFirstBranchNode=(one.Sort==otherParams.branchStartSort) //�Ƿ��ǵ�һ����֧��ʼ��
								
								if (opts.lineFollowState0 && LastPointState['master']==0) lineState=0; //��֧��ʼ�� ȡ���߽ڵ�state
								if(opts.branchStyle==2){
									if (one.branches.length>1) lineState=branch.state;  //
									var brokenLineHtml=getBrokenLineHtml(lineLeft,20+13+masterBaseTop,lineTop,step,LastPointState['master'],lineState,branchIdx,one.branches.length,branch.isOverTime,isFirstBranchNode?0.3:0.5);
									$process.append(brokenLineHtml);
								}else{
									lineStyle=getRotateLineStyle(lineLeft,20+13+masterBaseTop,lineTop,step);
									$process.append('<div class="orderview-process-line orderview-process-state'+lineState+(branch.isOverTime?' orderview-process-state9':'')+'" style="'+lineStyle+'"></div>');
								}
								
							}else{
								$process.append('<div class="orderview-process-line orderview-process-state'+lineState+(branch.isOverTime?' orderview-process-state9':'')+'" style="'+lineStyle+'"></div>');
							}
						}
						prevSortNodeBranches.push({top:lineTop,state:branch.state}); //���ӷ�֧�߶ȼ�¼ס ���ڷ�֧��һ�㻭��
						
						$process.append('<div class="orderview-process-point orderview-process-state'+branch.state+(branch.isOverTime?' orderview-process-state9':'')+'" style="'+pointStyle+'">'+(idx+1)+'</div>');
						LastPointState[branchIdx]=branch.state;
						
						var labelPos=appendNodeLabel($process,one,branchBaseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,otherParams.branchStartSort,isLastNode);
						
						appendNodeDetails($process,one,branchBaseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,isLastNode,null,labelPos);
						if (branch.children){
							appendNodeChildren($process,one,branchBaseTop,pointLeft,pointRadius,totalWidth,pointBaseStyle,branchHeight,childHeight,childHeightFix,idx,branchIdx,(branchIdx<num/2)?'top':'bottom',isLastNode);
						}
	
					})
					
					prevSortNode={
						isMaster:false,branches:prevSortNodeBranches
					}
				}
			})

		}



		
		//��ֱ���� ���µ�����
		function appendNodeChildren($process,one,baseTop,pointLeft,pointRadius,totalWidth,pointBaseStyle,branchHeight,childHeight,childHeightFix,idx,branchIdx,dir,isLastNode){
			var nodeData=one;
			if(parseInt(branchIdx)>=0) nodeData=one.branches[branchIdx];
			if (dir=='bottom' && !nodeData.showData) {
				baseTop=baseTop-(branchHeight-20-2*pointRadius - 20);
			}
			$.each(nodeData.children,function(cIdx,cItem){
				if(dir=='bottom'){
					var lineTop=baseTop+branchHeight+childHeightFix+childHeight*cIdx;
					var pointTop=lineTop+childHeight-2*pointRadius;
					var labelTop=lineTop+childHeight-2*pointRadius;
				}else{
					var lineTop=baseTop-childHeightFix-childHeight*(cIdx+1);
					var pointTop=lineTop;
					var labelTop=lineTop;
				}

				var labelLeft=pointLeft+2*pointRadius+5;

				var lineLeft=pointLeft+pointRadius-3;
				var lineStyle='position:absolute;top:'+lineTop+'px;left:'+lineLeft+'px;height:'+childHeight+'px;';
				var lineState=cItem.state;
				if (opts.lineFollowState0 && LastPointState['C-'+idx+'-'+branchIdx]==0) lineState=0;
				$process.append('<div class="orderview-child-process orderview-process-line-v orderview-process-state'+lineState+'" style="'+lineStyle+'"></div>');
				var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
				$process.append('<div class="orderview-child-process orderview-process-point orderview-process-state'+cItem.state+'" style="'+pointStyle+'">'+(cIdx+1)+'</div>');

				LastPointState['C-'+idx+'-'+branchIdx]=cItem.state;

				var labelStyle='position:absolute;top:'+labelTop+'px;left:'+labelLeft+'px;';
				$process.append('<span class="orderview-child-process orderview-process-point-label orderview-process-state'+cItem.state+'" style="'+labelStyle+'">'+cItem.ActDesc+'</sapn>');
				

				var detailTop=labelTop;
				var detailPaddingTop=20,detailLeft=labelLeft;
				var detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+detailLeft+'px;';
				var detailPopoverOptions='placement:\'auto-right\'';
				
				if (totalWidth-detailLeft<450){ //̫����popover��ʾ�����
					detailPopoverOptions='placement:\'auto-left\'';
				}

				if(cItem.showData){
					var nodeIndex=''+idx+'-'+branchIdx+'-'+cIdx;
					var oprTimeArr=cItem.showData.OprTime.split(':');				
					var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-child-process orderview-process-detail orderview-process-detail-child" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'
									+'<div><span style="color:#333;">'+cItem.showData.OprUser+'</span> <span style="color:#666">'+(oprTimeArr[0]+':'+oprTimeArr[1])+'</span> </div>'
									+'<div><span style="color:#666">'+cItem.showData.OprDate+'</span></div>'
									+'</div>';
					$process.append(detailHtml);
				}else if(cItem.data.length>0){
					var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-child-process orderview-process-detail orderview-process-detail-child" style="'+detailStyle+'width:70px;height:30px;" data-options="'+detailPopoverOptions+'">'+'</div>';
					$process.append(detailHtml);
				}
	
			})
		}
		function appendNodeLabel($process,one,baseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,branchStartSort,isLastNode){
			var nodeData=one;
			if(parseInt(branchIdx)>=0) nodeData=one.branches[branchIdx];
			var labelTop=0+baseTop;
			var labelLeft=baseLeft-one.ActDesc.length*7;
			var labelText=one.ActDesc;
			if(one.Sort==branchStartSort && nodeData.showData && idx!=0) labelText=labelText+'('+(typeof nodeData.showData.PartDesc=='string'?nodeData.showData.PartDesc+' ':'')+nodeData.showData.ExamNo+')';
			
			var labelWidth=getLabelWidth(one);
			
			if (idx==0 && labelWidth>firstLabelWidth) {
				labelLeft=baseLeft-firstLabelWidth/2;
			}else if(isLastNode && labelWidth>lastLabelWidth ){
				labelLeft=baseLeft-(labelWidth-lastLabelWidth/2);
			}else{
				labelLeft=baseLeft-labelWidth/2;
			}
			


			var labelStyle='position:absolute;top:'+labelTop+'px;left:'+labelLeft+'px;';
			$process.append('<span class="orderview-process-point-label orderview-process-state'+nodeData.state+ (nodeData.isOverTime?' orderview-process-state9':'') +'" style="'+labelStyle+'">'+labelText+'</sapn>');
			
			return {top:labelTop,left:labelLeft,width:labelWidth};

		}
		
		function getLabelWidth(nodeData){
			if(!nodeData || !nodeData.ActDesc) return 0;
			var labelText=nodeData.ActDesc;
			var $proxy=$('<span class="orderview-process-point-label" >'+labelText+'</span>').appendTo($proxyContainer);
			var labelWidth=$proxy.width();
			$proxy.remove();
			return labelWidth;
			
		}


		///2021-06-20 lineIdx �ߵ�˳��
		function appendNodeDetails($process,one,baseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,isLastNode,lineIndex,labelPos){
			var step=$process.data('step');
			var lineCount=$process.data('lineCount');
			
			var nodeData=one;
			if(parseInt(branchIdx)>=0) nodeData=one.branches[branchIdx];
			var detailTop=baseTop+0;
			var detailPaddingTop=20+(13+3)+pointRadius+5;  
			var detailLeft=baseLeft-40;
			var detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+detailLeft+'px;';
			var detailPopoverOptions='placement:\'auto-right\'';
			
			if (totalWidth-detailLeft<450){ //̫����popover��ʾ�����
				detailPopoverOptions='placement:\'auto-left\'';
			}
			/*if (totalWidth-detailLeft<150){ //̫���� ���ҿ�
				detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;right:'+0+'px;';
			}*/
			var nodeIndex=''+idx+(parseInt(branchIdx)>=0?('-'+branchIdx):'');

			lineIndex=lineIndex||'';
			
			var processDetCls='orderview-process-detail';
			
			if(nodeData.showData){
				var showData=nodeData.showData;
				
				var detObj=getNodeDetail(nodeData,isLastNode,step,lineCount);
				var detailWidth=detObj.width;
				var detailContent=detObj.content;


				//if (idx==0 && detailWidth>=80) detailLeft=baseLeft-40;
				//else  detailLeft=baseLeft-detailWidth/2;
				detailLeft=baseLeft-detailWidth/2;  //��ϸ����
				
				
				if (opts.nodeStyle==2 && labelPos) {  //�ڵ���ʽ2 detail��label�����
					detailLeft=labelPos.left;
					processDetCls+=' orderview-process-detail-style2'
				}

				detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+detailLeft+'px;';
				

				var detailHtml='<div data-index="'+nodeIndex+'" data-line-index="'+lineIndex+'" class="'+processDetCls+'" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'
								+detailContent
								+'</div>';
				
				$process.append(detailHtml);
			}else if(nodeData.data.length>0){
				detailLeft=baseLeft-40;
				if (opts.nodeStyle==2 && labelPos) {  //�ڵ���ʽ2 detail��label�����
					detailLeft=labelPos.left;
				}

				detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+detailLeft+'px;width:80px;height:50px;';
				var detailHtml='<div data-index="'+nodeIndex+'" data-line-index="'+lineIndex+'" class="'+processDetCls+'" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'+'</div>';
				$process.append(detailHtml);
			}

			return {top:detailTop,left:detailLeft,width:detailWidth};

		}
		///����nodeData��֯��ϸ����  ���Ҵ�������Ԫ�� ������
		function getNodeDetail(nodeData,isLastNode,step,lineCount){
			var showData=nodeData.showData;
			if(!showData){
				return{
					width:80,
					content:''
				}
			}
			var showDataNote=showData.Note||'';  //��ʾ�ڵ㱸ע��Ϣ
			if (showDataNote.indexOf("http")>-1 &&  nodeData.state=='2') {  //��ע������ �� ��ǰ�������������� ����ʾ�鿴
				showDataNote='';
			}
			
			var detailsNoteStyle='';
			if (showDataNote&&showDataNote.indexOf("http")==-1 && step>0) {
//				detailsNoteStyle=detailsNoteStyle+'max-width:'+(isLastNode?'120':(step-14))+'px;' //�����
//				if (lineCount==1) { //ֻ��һ�е������ ��ϸ������
//					detailsNoteStyle+='word-break: break-all;white-space: normal;max-height:2.8rem;';
//					
//				}
			}
			
			
			var oprTimeArr=showData.OprTime.split(':');	
			var noteLink=getNoteLink(showDataNote);
			var detailContent=(opts.showOprUser?'<div><span style="color:#333;">'+showData.OprUser+'</span></div>':'') //add showOprUser config 2022-12-07
				+'<div><span style="color:#666">'+showData.OprDate+'</span></div>'
				+'<div><span style="color:#666">'+(oprTimeArr[0]+':'+oprTimeArr[1])+'</span></div>'
				+((showData.OprLoc&&opts.showOprLoc)?('<div><span style="color:#666">'+showData.OprLoc+'</span></div>'):'')  //���� λ�� add 2022-12-07
				+(showDataNote?(noteLink?'<div>'+noteLink+'</div>':'<div style="color:#f00;'+( detailsNoteStyle )+'">'+showDataNote+'</div>'):'');
			

			var processDetCls='orderview-process-detail';
			if (opts.nodeStyle==2) processDetCls+=' orderview-process-detail-style2';

			var $proxy=$('<div class="'+processDetCls+'" >'+detailContent+'</div>').appendTo($proxyContainer);
			var detailWidth=$proxy.width();
			$proxy.remove();

			return {
				width:detailWidth,
				content:detailContent
			}
		}

		///��ȡһ���ڵ����з�֧�� ������ϸ ����һ��
		function getOneMaxDetailWidth(one){
			var ret=0;
			var arr=[]
			if (one.branches && one.branches.length>0 ) {
				arr=one.branches;
			}else{
				arr.push(one);
			}
			$.each(arr,function(ind,nodeData){
				var detObj=getNodeDetail(nodeData);
				if (detObj.width>ret) ret=detObj.width;
				
			})
			return ret||80;
		}
		///��ȡ��ע����
		function getNoteLink(note) {
			if(!note) return '';
			if (note.indexOf("http")==0 || note.indexOf('ftp')==0 ) {
				return '<a target="_blank" href="'+note+'">'+$g('�鿴')+'</a>'	
			}else if(note.indexOf('</a>')>-1) {
				return note;
			}
			return '';
			
		}


		///left1���left
		///top1 ���top
		///top2 �յ�top
		///width ��㵽�յ�ˮƽ����
		///state1 ���״̬
		///state2 �յ�״̬
		///index ��֧index
		///len ��֧��
		///isOverTime�Ƿ�ʱ
		/// ratio ���߶α��� 
		function getBrokenLineHtml(left1,top1,top2,width,state1,state2,index,len,isOverTime,ratio){
			var ratio=ratio||0.3;
			
			var htmlArr=[];
			if(index==0){//��������һ�κ��� ������ɫ����ǰ������֧��ɫ
				var horizontalStyle='position:absolute;top:'+top1+'px;left:'+left1+'px;width:'+Math.floor(width*ratio)+'px;';
				var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state1+'" style="'+horizontalStyle+'"></div>';
				htmlArr.push(horizontalHtml);
			}
			//����
			var h=(len-1)/2-index,height=Math.floor( Math.abs(h)*branchHeight +3),zIndex=11+Math.ceil(Math.abs(h));
			height=Math.abs(top1-top2)+3;
			var vTop=h>0?top2:(top2-height+3)+2;
			if (height>0){
				var verticalStyle='position:absolute;top:'+vTop+'px;left:'+(left1+Math.floor(width*ratio))+'px;height:'+height+'px;z-index:'+zIndex+';';
				var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state2+(isOverTime?' orderview-process-state9':'') +'" style="'+verticalStyle+'"></div>';
				htmlArr.push(verticalHtml);
			}
			//���������֧�㻭����
			var lineStyle='position:absolute;top:'+top2+'px;left:'+(left1+Math.floor(width*ratio))+'px;width:'+Math.floor(width*(1-ratio))+'px;';
			var lineHtml='<div class="orderview-process-line orderview-process-state'+state2+(isOverTime?' orderview-process-state9':'') +'" style="'+lineStyle+'"></div>';
			htmlArr.push(lineHtml);
			return htmlArr.join('');
								
		}
		
		///��֧��һ�㻭��
		///left1���left
		///top1 ���top
		///top2 �յ�top
		///width ��㵽�յ�ˮƽ����
		///state1 ���״̬
		///state2 �յ�״̬
		///index ��֧index
		///len ��֧��
		///isOverTime�Ƿ�ʱ
		/// ratio ���߶α��� 
		function getBrokenLineHtml2(left1,top1,top2,width,state1,state2,index,len,isOverTime,ratio){
			var ratio=ratio||0.3;
			
			var htmlArr=[];
			
			var horizontalStyle='position:absolute;top:'+top1+'px;left:'+left1+'px;width:'+Math.floor(width*ratio)+'px;';
			var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state1+'" style="'+horizontalStyle+'"></div>';
			htmlArr.push(horizontalHtml);
			
			//����
			var h=(len-1)/2-index,height=Math.floor( Math.abs(h)*branchHeight +3),zIndex=11+Math.ceil(Math.abs(h));
			height=Math.abs(top1-top2)+3;
			var vTop=h>0?top1:(top1-height+3)+2;
			if (height>0){
				var verticalStyle='position:absolute;top:'+vTop+'px;left:'+(left1+Math.floor(width*ratio))+'px;height:'+height+'px;z-index:'+zIndex+';';
				var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state1+(isOverTime?' orderview-process-state9':'') +'" style="'+verticalStyle+'"></div>';
				htmlArr.push(verticalHtml);
			}
			//���������֧�㻭����
				if(index==0){//��������һ�κ��� ������ɫ����ǰ������֧��ɫ
				var lineStyle='position:absolute;top:'+top2+'px;left:'+(left1+Math.floor(width*ratio))+'px;width:'+Math.floor(width*(1-ratio))+'px;';
				var lineHtml='<div class="orderview-process-line orderview-process-state'+state2+(isOverTime?' orderview-process-state9':'') +'" style="'+lineStyle+'"></div>';
				htmlArr.push(lineHtml);
			}
			return htmlArr.join('');
								
		}
		
		function getRotateLineStyle(left1,top1,top2,width){
			var x=width;
			var y=top2-top1;
			var deg=360*Math.atan(y/x)/(2*Math.PI);
			
			var f_width=Math.sqrt(x*x+y*y);
			var f_top=top1+y/2;
			var f_left=left1-(f_width-width)/2;
			
//			transform:rotate(7deg);
//			-ms-transform:rotate(7deg); 	/* IE 9 */
//			-moz-transform:rotate(7deg); 	/* Firefox */
//			-webkit-transform:rotate(7deg); /* Safari �� Chrome */
//			-o-transform:rotate(7deg); 
			var degStyle='transform:rotate('+deg+'deg);-ms-transform:rotate('+deg+'deg);-moz-transform:rotate('+deg+'deg);-webkit-transform:rotate('+deg+'deg);-o-transform:rotate('+deg+'deg);'
			var lineStyle='position:absolute;top:'+f_top+'px;left:'+f_left+'px;width:'+f_width+'px;'+degStyle;
			return lineStyle;
		}

		/// ��ȡ ����һ�����ӵ�
		function getNextLineConnLineHtml(left1,top1,left2,top2,widthA,heightB,state,isOverTime){
			var htmlArr=[];
			var zIndex=11;

			if(left1==left2) {  //������xλ����ͬ ֱ�ӻ�����
				var top=top1,left=left1,height=top2-top1;
				var verticalStyle='position:absolute;top:'+top+'px;left:'+left+'px;height:'+height+'px;z-index:'+zIndex+';';
				var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+verticalStyle+'"></div>';
				return verticalHtml;
			}



			if (widthA>0) { //widthA>0 �Ż���
				/// �߶�A ����
				var horizontalStyle='position:absolute;top:'+top1+'px;left:'+left1+'px;width:'+widthA+'px;';
				var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+horizontalStyle+'"></div>';
				htmlArr.push(horizontalHtml);
			}

			
			///�߶�B ����
			var topB=top1,leftB=left1+widthA;
			var verticalStyle='position:absolute;top:'+topB+'px;left:'+leftB+'px;height:'+heightB+'px;z-index:'+zIndex+';';
			var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+verticalStyle+'"></div>';
			htmlArr.push(verticalHtml);

			/// �߶�C ����
			var leftC=left2-3,topC=topB+heightB,widthC=leftB-leftC+5;
			var horizontalStyle='position:absolute;top:'+topC+'px;left:'+leftC+'px;width:'+widthC+'px;';
			var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+horizontalStyle+'"></div>';
			htmlArr.push(horizontalHtml);

			///�߶�D ����
			///�߶�B ����
			var topD=topC,leftD=leftC,heightD=top2-topD;
			var verticalStyle='position:absolute;top:'+topD+'px;left:'+leftD+'px;height:'+heightD+'px;z-index:'+zIndex+';';
			var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+verticalStyle+'"></div>';
			htmlArr.push(verticalHtml);
			return htmlArr.join('');
								
		}
		/// �ع鵽��һ�� ����
		function getRegressionLineHtml(left1,top1,left2,top2,widthA,state,isOverTime){
			//����
			var htmlArr=[];
			var zIndex=11;
			/// �߶�A ����
			var horizontalStyle='position:absolute;top:'+top1+'px;left:'+left1+'px;width:'+widthA+'px;';
			var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+horizontalStyle+'"></div>';
			htmlArr.push(horizontalHtml);

			///�߶�B ��
			var topB=top2,leftB=left1+widthA,heightB=top1-top2+5;
			var verticalStyle='position:absolute;top:'+topB+'px;left:'+leftB+'px;height:'+heightB+'px;z-index:'+zIndex+';';
			var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+verticalStyle+'"></div>';
			htmlArr.push(verticalHtml);

			/// �߶�C ����
			var leftC=leftB,topC=topB,widthC=left2-left1-widthA;
			var horizontalStyle='position:absolute;top:'+topC+'px;left:'+leftC+'px;width:'+widthC+'px;';
			var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state+(isOverTime?' orderview-process-state9':'')+'" style="'+horizontalStyle+'"></div>';
			htmlArr.push(horizontalHtml);
			return htmlArr.join('');
		}
		

		$process_wrap.empty().append($process);
        if (typeof opts.processDetailPopover!="boolean" || opts.processDetailPopover!==false){  //�����ж�
            $process.find('.orderview-process-detail').each(function(){
				var index=$(this).data('index')+'';
				var indexArr=index.split('-');
				var lineIndex=$(this).data('lineIndex');
				if (lineIndex) {
					var idx1=lineIndex.split('-')[1],idx2=lineIndex.split('-')[0];
					var processDetailData=timeProcessData[idx2][idx1].data;

				}else if (indexArr.length==1){
					var processDetailData=processData[index].data;
				}else if(indexArr.length==2){
					var idx1=index.split('-')[0],idx2=index.split('-')[1];
					var processDetailData=processData[idx1].branches[idx2].data;
				}else if(indexArr.length==3){
					var idx1=index.split('-')[0],idx2=index.split('-')[1],idx3=index.split('-')[2];
					if (parseInt(idx2)>=0){
						var processDetailData=processData[idx1].branches[idx2].children[idx3].data;
					}else{
						var processDetailData=processData[idx1].children[idx3].data;
					}
                    
				}else{
					return;
				}
                
                if(processDetailData.length>0){
                    var $ul=$('<ul class="orderview-process-detail-timeline"></ul>');
                    
                    $.each(processDetailData,function(){
                        var $li=$('<li></li>').appendTo($ul);
                        var noteLink=getNoteLink(this.Note);
                        var oprUserHtml=opts.showOprUser?'<span style="padding-left:10px;color:#333;">'+this.OprUser+'</span>':''; //add showOprUser config 2022-12-07
                        $li.append('<div><span>'+this.ActDesc+(typeof this.PartDesc=='string'?'('+this.PartDesc+')':'')+'</span>'+oprUserHtml+'</div>');
						$li.append('<div><span style="color:#666">'+this.OprDate+' '+this.OprTime+'</span></div>');
						if (this.OprLoc&&opts.showOprLoc) $li.append('<div><span style="color:#666">'+this.OprLoc+'</span></div>'); //����λ�� 2022-12-07
						if (this.Note) $li.append(noteLink?'<div class="note-link-wrap">'+noteLink+'</div>':'<div style="color:#f00">'+this.Note+'</div>');
                        if(this.Sort<0) {
	                        $li.addClass('orderview-process-state2');
	                        $ul.find('li').not(this).find('div.note-link-wrap').remove();
                        }
                    })
                    //var popoverHtml=
                    $(this).popover({
                        content:$ul.prop('outerHTML'),
                        trigger:'hover',
                        placement:function(tarEle,srcEle){
                            //placement �����������auto�Ľ�����Ӧ��ת�� ����auto-left���ܻ�����left-top, ���ǻ�����ϲ��ռ䲻�� ��ʾ��ȫ
                            //�������Ԫ�����Ǹ����ʽ̫����
                            var ret='auto-right';
                            var tarHeight=$(tarEle).outerHeight();
                            var srcHeight=$(srcEle).outerHeight();
                            //��������еĿռ�
                            var topLeft=$(srcEle).offset().top-$('body').scrollTop()+srcHeight;
                            //console.log(topLeft);
                            if ($(srcEle).data('options').indexOf('auto-left')>-1){
                                ret='auto-left';
                                if (topLeft<tarHeight) ret='left-bottom';
                            }else{
                                
                            }
                            return ret;
                             
                        }
                    })
                }
            })
        }

		$process.find('.orderview-process-point.orderview-process-state1,.orderview-process-point.orderview-process-state3').last().addClass('orderview-process-active');
		
	};

	$.orderview.renderProcessDom=renderProcessDom; //���˷���ӳ���ȥ �������ط�ʹ��


	//��Ⱦͼ�� ��ԭ��ҩƷִ�м�¼��ͼ��ҲǨ�Ƶ��˴�
	function renderCharts(ele,data){
		var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (state.win) var $con=state.win.children('.orderview');
		else  var $con=$(opts.renderTo).children('.orderview');

		var $charts_wrap=$('<div class="orderview-charts-wrap"></div>').appendTo($con);
		var outerHeight=$con.height()-$con.children('.orderview-labels-wrap').outerHeight()-$con.children('.orderview-process-wrap').outerHeight();
		var outerWidth=$con.width();
		if (opts.chartsMinHeight && outerHeight<opts.chartsMinHeight) {
			outerHeight=opts.chartsMinHeight;
			outerWidth=outerWidth-20;
		}
		$charts_wrap.outerWidth(outerWidth).outerHeight(outerHeight);
		
		if (data.ChartList.length==1){
			var $chart=$('<div class="orderview-charts-cell"></div>').appendTo($charts_wrap).panel({
				fit:true,
				border:false
			})
			chartOnSelect(data.ChartList[0],$chart);
		}else{
			var $charts=$('<div class="orderview-charts tabs-gray"></div>');
			if (data.ChartBrand) $charts.append('<div title="'+data.ChartBrand+'" data-options="iconCls:\'icon-paper\'" ></div>');
			$.each(data.ChartList,function(idx,item){
				$charts.append('<div class="orderview-charts-cell" title="'+item.Description+'"></div>');
			})
			$charts.appendTo($charts_wrap).tabs({
				isBrandTabs:!!data.ChartBrand,
				fit:true,
				onSelect:function(title,index){
					var dataIndex=index;
					if (data.ChartBrand) dataIndex=index-1;
					var chartData=data.ChartList[dataIndex];
					chartOnSelect(chartData,$charts.tabs('getTab',index));

				}
			});
		}
		function chartOnSelect(chartData,chartPanel){
			//$.messager.popover({msg:chartData.Description,type:'info'})
			console.log('chartOnSelect',chartData,chartPanel);
			if (chartData.onceSelected) return;
			//Code:%String:�˵�����,Description:%String:�˵�����,Url:%String:����,ValExpr:%String:���ʽ,JsFun:%String:Js����,JsFile:%String:Js�ļ���"��NewWindow:"top=10,width=100"
			if (chartData.Url) {
				var url=chartData.Url;
				url+=(url.indexOf('?')>-1?'&':'?')+'ordItemId='+(opts.orders[0]||'');
				if (chartData.ValExpr) url+=url.indexOf('?')>-1?'':'?a=a'+chartData.ValExpr;
				url=$.orderview.parseTmpl(url,opts.ARGDATA)
				url=$.orderview.getTokenUrl(url);
				var $iframe=$('<iframe name="orderview-chart-'+chartData.Code+'" style="width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe>').appendTo(chartPanel);
				$iframe.attr('src',url);
			}else if(chartData.JsFun){ 
				var tempJsFun=getMenuJsFun(chartData.JsFun,opts.cateCode,opts.dataTypeCode);  //cryze 2021-10-21
				if (tempJsFun){
					tempJsFun(ele,data,chartData,chartPanel);
				}else{
					$.messager.popover({msg:chartData.JsFun+'δ���壬����ϵ��Ϣ����',type:'alert'})
				}
			}else{
				$.messager.popover({msg:chartData.Description+'�����ݲ�֧�֣�����ϵ��Ϣ����',type:'alert'});
			}
			chartData.onceSelected=true;


			
		}

	}
		
    function init(ele) {
	    var $ele=$(ele);
		var state = $.data(ele, "orderview");
		var opts=state.options;
		if (opts.type=="trigger"){
			var trigger=opts.trigger;
			$ele.off('.orderview').on(trigger+'.orderview',function(e){
				var context = this;
	        	var args = arguments;
				if (e.type=='contextmenu'){
					e.preventDefault();
				}
				return onTrigger.apply(context,args);
			});
		}else if(opts.type=="container"){
			var verCls=opts.uiVer?' orderview-ver-'+opts.uiVer:'';  //����ui�汾��ͬ ��������������ui�汾��ʽ�� 2022-12-14
			var content=opts.contentType=='html'?'<div class="orderview orderview-noscrollX'+verCls+'"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
			opts.renderTo=ele;
			$(ele).empty().html(content);
			render(ele);
		}
    };


    $.fn.orderview = function (opts, param) {
        if (typeof opts == "string") {
            var mth = $.fn.orderview.methods[opts];
            return mth(this, param);
        }
        opts = opts || {};
        return this.each(function () {
            var state = $.data(this, "orderview");
            if (state) {
				if (opts.labels) opts.isCustomLabels=true; 
				if (typeof opts.hideLabel!='undefined') opts.isCustomHideLabel=true; 
				if (typeof opts.hideLabelIcon!='undefined') opts.isCustomHideLabelIcon=true; 
                $.extend(state.options, opts);
            } else {
				var parsedOpts=$.fn.orderview.parseOptions(this);
				if (parsedOpts.labels || opts.labels ) opts.isCustomLabels=true; //�Ƿ����Զ���labels
				if (typeof opts.hideLabel!='undefined') opts.isCustomHideLabel=true; 
				if (typeof opts.hideLabelIcon!='undefined') opts.isCustomHideLabelIcon=true; 
                $.data(this, "orderview", {
                    options: $.extend({}, $.fn.orderview.defaults, parsedOpts, opts)
                });
            }
            init(this);
        });
    };
    $.fn.orderview.methods = {
        options: function (jq) {
            return $.data(jq[0], "orderview").options;
        }
    };
    $.fn.orderview.parseOptions = function (ele) {
        var t = $(ele);
        //��Ҫ�����Ĭ��ֵ
        var def={
			baseUrl:BASE_URL, //ҳ��location�������
			assetsBaseUrl:ASSETS_BASE_URL //ҳ������dhc.orderview.js��·������
		};
        if ($.fn.datebox){ 
        	var nowDate=$.fn.datebox.defaults.formatter(new Date());
        	def.dateFormat=nowDate.indexOf("/")>-1?4:3;
        }
        
        if (typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite') {
	    	def.uiVer='lite';
	    	def.nodeStyle=2;    
	    }
        return $.extend({},def, $.parser.parseOptions(ele, ["renderTo"]), {});
    };
    $.fn.orderview.defaults ={
	    ord:'',
	    ordGetter:null,
	    type:'trigger',
	    trigger:'click',
	    renderTo:null,
	    renderToOne:true, //��Ⱦ��ͬһ��window��
	    contentType:'html' ,  //��ʲô��ʽ��Ⱦ html��iframe
	    cache:false,  //loadһ�����ݺ���load  //2019-01-29 Ĭ��ֵ��Ϊfalse
	    winWidth:1340,
	    winHeight:500,
	    autoFitWin:true,  //win��С�Զ��ʵ�ǰҳ�洰�ڴ�С
	    autoHeight:false,  //û�б��� html���͵� �Ƿ�������ݼ���߶�
	    autoMoreHeight:true, //�Ƿ��Զ�����߶� �ಿλ
	    labels:[[
				{label:'����',key:'PatName',css:{fontSize:'16px'},hideLabel:true,hideSep:true},
				{label:'�Ա�',key:'PatSex',hideLabel:true,hideSep:true},
				{label:'����',key:'PatAge',hideLabel:true},
				{label:'�������',key:'AppDeptDesc'},
				{label:'��������',key:'OperDeptDesc'},
				{label:'��������',key:'SourceTypeDesc'},
		    	{label:'����ʽ',key:'AnaMethodDesc'},
		    	{label:'����ҽ��',key:'AnesthesiologistDesc'},
		    	{label:'Ѳ�ػ�ʿ',key:'CircualNurseDesc'},
				{label:'��е��ʿ',key:'ScrubNurseDesc'},
				{label:'��ǰסԺ��',key:'PreopAdmDays'},
				{label:'����ʱ��',key:'ROperDuration'},
				{label:'ҽ����ʼʱ��',key:'OrdStartDate',type:'date'},
		    	{label:'ҽ������',key:'OrdPriority'},
		    	{label:'Ƥ��',key:'OrdSkin'},
				{label:'������',key:'PresNo'},
				{label:'��������',key:'OrdLocDesc'}
	    	],[
	    		{label:'ҽ������',key:'OrdDesc'}
	    	]
	    ],
	    hideLabel:false,
	    hideLableIcon:false,
		baseUrl:'/dthealth/web',
		assetsBaseUrl:'/dthealth/web/scripts',
	    dateFormat:3  //���ڸ�ʽ 
	    ,branchStyle:2  //��֧��ʽ 1.ֱ�ӵ����б������ 2.����һ�������ӣ����������֧�����������
	    ,lineFollowState0:true  //����ڵ�״̬Ϊ0,������״̬�Ƿ�Ҫ����
	    ,maxStepWidth:500  //���ƽڵ������
		,followNegativeStateCate:['04','05','20','21']  //һ�������̲����൱��֮�������̵�������  ��ʱ���������� ����Ҫ�ж�ʱ�����Ϣ Ϊ�������̲�������������
		,followNegativeActCode:['CA','OCA']  //��һ�Զ������ ���� 
		,processGroupColors:[{
								state0:{headerBg:'#DDDDDD',bodyBg:'#F3F3F3'},
								state1:{headerBg:'#18AF66',bodyBg:'#ECFBF4'}
							},{
								state0:{headerBg:'#BEBEBE',bodyBg:'#E8E8E8'},
								state1:{headerBg:'#39C6C8',bodyBg:'#E9FFFF'}
							},{
								state0:{headerBg:'#DDDDDD',bodyBg:'#F3F3F3'},
								state1:{headerBg:'#21BE97',bodyBg:'#E7FDF8'}
							}]
		,chartsMinHeight:200
		,showOprLoc:true  //��ʾ��������
		,showOprUser:true  //��ʾ�����û�
		,uiVer:'blue'  //ui�汾 ͬhisui�汾
		,nodeStyle:1  //1����  2label���У�detail��label�����
		,hideSensitiveInfo:'0'
		,ARGDATA:{}
    };
})(jQuery);
