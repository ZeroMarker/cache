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
		easyModal:function(title,url,width,height,target,autoZoom){
			if (target){
				var maxWidth=$(target).width(),maxHeight=$(target).height();
			}else{
				var maxWidth=$(window).width(),maxHeight=$(window).height();
			}
			width=''+(width||'80%'),width=width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width);
			height=''+(height||'80%'),height=height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height);

			if ((width>maxWidth-20 || height>maxHeight-20) && !autoZoom && top.websys_showModal) { //�������С���� �Ҳ������Լ����� ��top����websys_showModal ����top.websys_showModal
				return top.websys_showModal({url:url,title:title,width:width,height:height});
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
	function loadJs(url,charset,callback){
		var script = document.createElement('script'),
		head = document.getElementsByTagName('head')[0];
		script.type = 'text/javascript';
		script.charset = charset||'gb18030';
		script.src = url;
		if (script.addEventListener) {
			script.addEventListener('load', function () {
				callback(true);
			}, false);
			script.addEventListener('error', function () {
				callback(false);
			}, false);
		} else if (script.attachEvent) {
			script.attachEvent('onreadystatechange', function () {
				var target = window.event.srcElement;
				if (target.readyState == 'loaded'||target.readyState == 'complete') {
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
			var content=opts.contentType=='html'?'<div class="orderview"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
			$renderTo.empty().html(content);
		}
		render(ele);
		function createWin(){
			var content=opts.contentType=='html'?'<div class="orderview"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
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
		///���Ƕ�ҽ��render
		if (typeof ord=="string"){
			orders=ord.split('^');
		}else{
			orders=ord||[];
		}
		opts.orders=orders;
		
		if (opts.contentType=="html"){
			var ajaxBrokerUrl= opts.baseUrl+'/csp/websys.Broker.cls';//"/dthealth/web/csp/websys.Broker.cls";
			if (!opts.data || !opts.cache || opts.lastOrd!=orders.join('^')){
				opts.ord=ord,opts.lastOrd=orders.join('^');
				if (orders.length==1){ //��ҽ��
					var reqData={ClassName:'icare.web.TimeLineData',MethodName:'GetActData',OrdItemId:ord
						,OrdViewType:opts.ordViewType||''
						,OrdViewBizId:opts.ordViewBizId||''
					};
					var mockReqData={ClassName:'a.util.Mock',MethodName:'FromFile',filename:'dhc.orderview.mock.json'};
					//reqData=mockReqData;
					var xhr=$.ajax({
						url:ajaxBrokerUrl,
						data:reqData, 
						dataType:'json',
						type:'POST',
						success:function(res){
							
							formatterPorcessData(res,opts);
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
			var iframeSrc=$frame.attr('src');
			//console.log(iframeSrc);
			if (thisSrc!=iframeSrc || !opts.cache){
				//console.log(iframeSrc);
				state.win.find('iframe').attr('src',thisSrc);
			}
		}
		
	}

	/**
	 * ��̨���ص�data.ActCfg data.ActData ת��data.PorcessData
	 * @param {*} data ��ȡ��������
	 * @param {*} dateFormat ���ڸ�ʽ 3/4
	 * @param {*} followNegativeStateCate ��������һ�Զ����������Щ
	 * @param {*} followNegativeActCode  ��������һ�Զ� �����̴���
	 */
	function formatterPorcessData(data,opts){
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
			if(typeof this.ExamNo=="string" && this.ExamNo!="" && this.Sort>0){ //����  ȡ������м��� ȴ��ӦԤԼû�м���
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
					if(parseFloat(this.Sort)>branchStartSort) BranchChildProcessCount=Math.max(BranchChildProcessCount,childProcessCount);
				}
				branches.push(branchItem);
			}

			var sort=parseFloat(this.Sort);
			if (sort>0) {
				if(sort>=branchStartSort){
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
		
		
		$.each(data.ActData,function(){
			this.OprUser=this.OprUser||'  '; //�п��ܻ��в�����Ϊ��
			var absSort=Math.abs( parseFloat(this.Sort) );
			var absParentSort=Math.abs( parseFloat(this.ParentSort) );
			if(!this.ParentCode && !temp[absSort] ) return true;  //���ݵ�λ����������û�� //���������� �ж�����˳����ڷ�
			if ( this.ParentCode && !temp[absParentSort] ) return true; //�������� �жϸ�����˳����ڷ�
			
			
			var newItem=$.extend({},this,{OprDate:formatDateString(this.OprDate||'',dateFormat)});
			
			if(absSort>=branchStartSort){ //����֧
				var branchIndex=ExamArr.indexOf(this.ExamNo);
				if (branchIndex==-1) branchIndex=0; //ǰ�����˼���  ������Ī��û���� ������һ����֧
				if (this.ParentCode ) { //��������
					var branchItem=temp[absParentSort].branches[branchIndex];
					if (branchItem.tempChildren && branchItem.tempChildren[absSort]) {
						if (this.Sort<0) branchItem.tempChildren[absSort].state=2 //�����̽ڵ�������
						branchItem.tempChildren[absSort].data.push(newItem);
					}
				}else{
					if (!this.ExamNo&& this.ActDesc=='ȡѪ����'){ //ȡѪ�������⴦��
						for (var mytempi=0;mytempi<ExamArr.length;mytempi++){
							if(temp[absSort-1]&&temp[absSort-1].branches&&temp[absSort-1].branches[mytempi].data.length >0 ){ //ǰ��ڵ�������
								if (this.Sort<0) temp[absSort].branches[mytempi].state=2; //�й�������
								temp[absSort].branches[mytempi].data.push( $.extend({},newItem,{isFixData:true,ExamNo:temp[absSort-1].branches[mytempi].data[0].ExamNo}) );
							}
						}
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
		//�����������Ϊһ�Զ� ��ѭ������
		if (isFollowNegativeState){
			$.each(temp,function(idx,item){
				item.data.sort(compareActData);
				var len=item.data.length;
				
				$.each(item.data,function(dataIdx){
					if(this.Sort<0 && !this.appendFlag && followNegativeActCode.indexOf(this.ActCode)>-1) insertNegative(temp,this,idx,-1,dataIdx)
				})
				
				if(item.branches){
					$.each(item.branches,function(branchIdx,branch){
						branch.data.sort(compareActData);

						$.each(branch.data,function(dataIdx){
							if(this.Sort<0 && !this.appendFlag && followNegativeActCode.indexOf(this.ActCode)>-1) insertNegative(temp,this,idx,branchIdx,dataIdx)
						})
						
					})
				}
			})
		}
		function insertNegative(tempData,negativeData,sortKey,branchIdx,dataIdx){
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

		data.ProcessData=[];
		data.ProcessGroup=[];
		var currGroup=null,groupColorMap={},colorInd=0;
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
				if (this.Sort>0) item.showData=this;
			})

			if (item.tempChildren){
				item.children=[];
				$.each(item.tempChildren,function(cIdx,cItem){
					cItem.data.sort(compareActData);
					var len=cItem.data.length;
					if (len>0){
						if (cItem.data[len-1].Sort>0){
							if (cItem.state==0) cItem.state=1
							if (cItem.state==2) cItem.state=3  //�й������� ����������˻���
						}
						
					}
					$.each(cItem.data,function(){  //��������������Ϊ��ʾ
						if (this.Sort>0) cItem.showData=this;
					})
					item.children.push(cItem);
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
						if (this.Sort>0) branch.showData=this;
					})

					if (branch.tempChildren){
						branch.children=[];
						$.each(branch.tempChildren,function(cIdx,cItem){
							cItem.data.sort(compareActData);
							var len=cItem.data.length;
							if (len>0){
								if (cItem.data[len-1].Sort>0){
									if (cItem.state==0) cItem.state=1
									if (cItem.state==2) cItem.state=3  //�й������� ����������˻���
								}
								
							}
							$.each(cItem.data,function(){  //��������������Ϊ��ʾ
								if (this.Sort>0) cItem.showData=this;
							})
							branch.children.push(cItem);
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
		})
		if (data.ProcessGroup.length==1 && data.ProcessGroup[0].name=='') data.ProcessGroup.pop(); //���ֻ��һ�� ���ǿ� ����Ϊû�з���

		if (data.PatOrdType=="0621" ||data.PatOrdType=="0721" ||data.PatOrdType=="0711"){
			if(!data.ChartList || data.ChartList.length==0) data.ChartList=[{Code:'ZXJL',Description:'ִ�м�¼',Url:'',JsFun:'renderOrderExecDetails'}];
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
					//����С�ڸ��� ����ԽСԽС ����ԽСԽ��
					var aSortV=aSort>=0?aSort:1000+Math.abs(aSort);
					var bSortV=bSort>=0?bSort:1000+Math.abs(bSort);
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
		if((data.ButtonList && data.ButtonList.length)||(data.ChartList && data.ChartList.length)){
			var cateCode=data.PatOrdType.substr(0,data.PatOrdType.length-2);
			$.orderview.loadJs(opts.assetsBaseUrl+'/TimeLine/dhc.orderview.'+cateCode+'.js','gb18030',function(success){
				//��������Զ���labels ���Ҷ�̬���ص�js������labels
				if (!opts.isCustomLabels && $.fn.orderview.defaults['labels'+cateCode]) opts.labels=$.fn.orderview.defaults['labels'+cateCode];
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
		var $labels_icon=$('<div class="orderview-labels-icon "></div>').appendTo($labels);
		if (data.PatSex && data.PatSex=='��') $labels_icon.addClass('orderview-labels-icon-man');
		if (data.PatSex && data.PatSex=='Ů') $labels_icon.addClass('orderview-labels-icon-woman');

		$.each(opts.labels,function(){
			var $labels_row=$('<div class="orderview-labels-row"></div>');
			$.each(this,function(ind,item){
				var label=item.label,key=item.key;
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
			if ($labels_row.find('.orderview-labels-cell-value').length>0) $labels_row.appendTo($labels);
		})
		$labels.appendTo($labels_wrap);
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
			if (buttonData.Url) {
				var url=buttonData.Url;
				url+=(url.indexOf('?')>-1?'&':'?')+'ordItemId='+opts.orders[0];
				if (buttonData.ValExpr) url+=url.indexOf('?')>-1?'':'?a=a'+buttonData.ValExpr;
				var features=$.orderview.formatFeatures(buttonData.NewWindow||'hisui=true');
				if (typeof features=='string'){
					$.orderview.easyOriginWin(url,'orderview-btn-'+buttonData.Code,features);
				}else{ //
					$.orderview.easyModal(buttonData.Description,url,features.width,features.height,$con,false);
				}
			}else if(buttonData.JsFun){
				if (typeof window[buttonData.JsFun]=='function'){
					var features=$.orderview.formatFeatures(buttonData.NewWindow||'hisui=true');
					var easyModal=$.orderview.easyModal(buttonData.Description,'',features.width,features.height,$con,false);
					window[buttonData.JsFun](ele,data,buttonData,easyModal.find('>.panel>.dialog-content'));
				}else{
					$.messager.popover({msg:buttonData.JsFun+'δ���壬����ϵ��Ϣ����',type:'alert'})
				}
			}else{
				$.messager.popover({msg:buttonData.Description+'���ò���ȷ,����ϵ��Ϣ����',type:'alert'})
			}
		}
		
		
	}
    //��Ⱦ�仯����
    function renderProcess(ele,data){
		console.log(data)
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
			childHeightFix:childHeightFix
	    },data.ProcessGroup)
    }
    
    
    //��process_wrap��Ԫ�� ��renderProcess�����ó��� Ϊ�˾�����ϸʱ����Ҳ����ʹ��
    //otherParams:{branchHeight:'��֧�߸�Number',num:'��֧��Number',maxStepWidth:'��󲽳�Number',lineFollowState0:'��ɫ�ڵ�ǰ����Ϊ��ɫ',branchStyle:'1б��2����',processDetailPopover:'�ڵ���ϸ�Ƿ�Ҫ��ʾ',branchStartSort:'��֧��ʼ�ڵ�Sord'}
	function renderProcessDom(processWrap,processData,otherParams,processGroup){
		if (!$proxyContainer) $proxyContainer=$('<div class="orderview-proxy-container"></div>').appendTo('body');
		processGroup=processGroup||[];
		//console.log(processData);
		//console.log(otherParams);
        var branchHeight=otherParams.branchHeight||95,
            num=otherParams.num||1,
            opts=$.extend({},otherParams),
            $process_wrap=processWrap;
        var $process=$('<div class="orderview-process"></div>');

		var totalWidth=$process_wrap.width();
		
		var len=processData.length,firstLabelWidth=Math.max(processData[0].ActDesc.length*14,80),lastLabelWidth=Math.max(processData[len-1].ActDesc.length*14,80);
		totalWidth=totalWidth-firstLabelWidth/2-lastLabelWidth/2;   //������ϸ���� ���ܹ�80��
		var startP=firstLabelWidth/2; //������ϸ���� ���ܹ�80��
		
		if (processGroup.length>0) { //����
			totalWidth=totalWidth-20; //�ܵ����� -20
			startP=startP+10; //��ʼ����10
		}
		var step=opts.maxStepWidth;
		if (len>1) step=parseFloat(totalWidth/(len-1)).toFixed(2);

		step=Math.min(opts.maxStepWidth,step);

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
		var processConHeight= branchesHeight+(processGroup.length>0?(24+5+10+10):0); // //��֧���ݸ�+header+padding


		
		$process.height(processConHeight);

		

		
		var groupStart=0;labelInd=0
		$.each(processGroup,function(idx,group){
			var groupLeft=parseInt(0+startP+labelInd*step-step/2+5);
			if (idx==0) groupLeft=0
			labelInd=labelInd+group.len;
			var groupRight=parseInt(0+startP+labelInd*step-step/2-5);
			if (idx==processGroup.length-1) groupRight=totalWidth+firstLabelWidth/2+lastLabelWidth/2+20;
			var groupWidth=groupRight-groupLeft;
			
			var groupTop=0,
				groupHeight=branchHeight*num+24+5+20,
				groupStyle='left:'+groupLeft+'px;top:'+groupTop+'px;width:'+groupWidth+'px;height:'+groupHeight+'px;background-color:'+group.bodyBg+';';
			
			
			$('<div class="orderview-process-group" style="'+groupStyle+'">'
				+'<div class="orderview-process-group-header orderview-process-group-header-state'+group.state+'" style="background-color:'+group.headerBg+';">'+group.name+'</div>'
				+'</div>').appendTo($process);
		})
		
		var pointRadius=12;
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
		$.each(processData,function(idx,one){
			var isLastNode=(idx==len-1);
			var baseLeft=0+startP+idx*step;
			var lineLeft=baseLeft-step;

			var pointLeft=baseLeft-pointRadius;
			//var labelLeft=baseLeft-one.ActDesc.length*7;
			//var detailLeft=baseLeft-40;   //������ϸ���� ���ܹ�80��
			if (one.Sort<otherParams.branchStartSort){
				var lineTop=20+13+masterBaseTop;
				var pointTop=20+(13+3)-pointRadius+masterBaseTop;
				var lineStyle='position:absolute;top:'+lineTop+'px;left:'+lineLeft+'px;width:'+step+'px;';
				var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
				if(idx>0){
					var lineState=one.state;
					if (opts.lineFollowState0 && LastPointState['master']==0) lineState=0;
					$process.append('<div class="orderview-process-line orderview-process-state'+lineState+'" style="'+lineStyle+'"></div>');
				}
				$process.append('<div class="orderview-process-point orderview-process-state'+one.state+'" style="'+pointStyle+'">'+(idx+1)+'</div>');
				LastPointState['master']=one.state;


				appendNodeLabel($process,one,masterBaseTop,baseLeft,pointRadius,totalWidth,idx,'',otherParams.branchStartSort,isLastNode);

				appendNodeDetails($process,one,masterBaseTop,baseLeft,pointRadius,totalWidth,idx,'',isLastNode);

				if(one.children){
					appendNodeChildren($process,one,masterBaseTop,pointLeft,pointRadius,totalWidth,pointBaseStyle,branchHeight,childHeight,childHeightFix,idx,'','top',isLastNode);
				}
				
			}else{ //��֧
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
						if (one.Sort==otherParams.branchStartSort){
							if (opts.lineFollowState0 && LastPointState['master']==0) lineState=0; //��֧��ʼ�� ȡ���߽ڵ�state
							if(opts.branchStyle==2){
								if (one.branches.length>1) lineState=branch.state;  //
								var brokenLineHtml=getBrokenLineHtml(lineLeft,20+13+masterBaseTop,lineTop,step,LastPointState['master'],lineState,branchIdx,one.branches.length);
								$process.append(brokenLineHtml);
							}else{
								lineStyle=getRotateLineStyle(lineLeft,20+13+masterBaseTop,lineTop,step);
								$process.append('<div class="orderview-process-line orderview-process-state'+lineState+'" style="'+lineStyle+'"></div>');
							}
							
						}else{
							$process.append('<div class="orderview-process-line orderview-process-state'+lineState+'" style="'+lineStyle+'"></div>');
						}
					}
					$process.append('<div class="orderview-process-point orderview-process-state'+branch.state+'" style="'+pointStyle+'">'+(idx+1)+'</div>');
					LastPointState[branchIdx]=branch.state;
					
					appendNodeLabel($process,one,branchBaseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,otherParams.branchStartSort,isLastNode);
					
					appendNodeDetails($process,one,branchBaseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,isLastNode);
					if (branch.children){
						appendNodeChildren($process,one,branchBaseTop,pointLeft,pointRadius,totalWidth,pointBaseStyle,branchHeight,childHeight,childHeightFix,idx,branchIdx,(branchIdx<num/2)?'top':'bottom',isLastNode);
					}

				})
			}
		})
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
				$process.append('<div class="orderview-process-line-v orderview-process-state'+lineState+'" style="'+lineStyle+'"></div>');
				var pointStyle=pointBaseStyle+'position:absolute;top:'+pointTop+'px;left:'+pointLeft+'px;';
				$process.append('<div class="orderview-process-point orderview-process-state'+cItem.state+'" style="'+pointStyle+'">'+(cIdx+1)+'</div>');

				LastPointState['C-'+idx+'-'+branchIdx]=cItem.state;

				var labelStyle='position:absolute;top:'+labelTop+'px;left:'+labelLeft+'px;';
				$process.append('<span class="orderview-process-point-label orderview-process-state'+cItem.state+'" style="'+labelStyle+'">'+cItem.ActDesc+'</sapn>');
				

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
					var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-process-detail orderview-process-detail-child" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'
									+'<div><span style="color:#333;">'+cItem.showData.OprUser+'</span> <span style="color:#666">'+(oprTimeArr[0]+':'+oprTimeArr[1])+'</span> </div>'
									+'<div><span style="color:#666">'+cItem.showData.OprDate+'</span></div>'
									+'</div>';
					$process.append(detailHtml);
				}else if(cItem.data.length>0){
					var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-process-detail orderview-process-detail-child" style="'+detailStyle+'width:70px;height:30px;" data-options="'+detailPopoverOptions+'">'+'</div>';
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
			if(one.Sort==branchStartSort && nodeData.showData) labelText=labelText+'('+(typeof nodeData.showData.PartDesc=='string'?nodeData.showData.PartDesc+' ':'')+nodeData.showData.ExamNo+')';
			
			var $proxy=$('<span class="orderview-process-point-label" >'+labelText+'</span>').appendTo($proxyContainer);
			var labelWidth=$proxy.width();
			if (idx==0 && labelWidth>firstLabelWidth) {
				labelLeft=baseLeft-firstLabelWidth/2;
			}else if(isLastNode && labelWidth>lastLabelWidth ){
				labelLeft=baseLeft-(labelWidth-lastLabelWidth/2);
			}else{
				labelLeft=baseLeft-labelWidth/2;
			}
			$proxy.remove();


			var labelStyle='position:absolute;top:'+labelTop+'px;left:'+labelLeft+'px;';
			$process.append('<span class="orderview-process-point-label orderview-process-state'+nodeData.state+'" style="'+labelStyle+'">'+labelText+'</sapn>');
		}
		function appendNodeDetails($process,one,baseTop,baseLeft,pointRadius,totalWidth,idx,branchIdx,isLastNode){
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
			if(nodeData.showData){
				var showData=nodeData.showData;
				
				var oprTimeArr=showData.OprTime.split(':');	
				var detailContent='<div><span style="color:#333;">'+showData.OprUser+'</span></div>'
					+'<div><span style="color:#666">'+showData.OprDate+'</span></div>'
					+'<div><span style="color:#666">'+(oprTimeArr[0]+':'+oprTimeArr[1])+'</span></div>'
					+(showData.Note?('<div style="color:#f00;">'+showData.Note+'</div>'):'');
				
				var $proxy=$('<div class="orderview-process-detail" >'+detailContent+'</div>').appendTo($proxyContainer);
				var detailWidth=$proxy.width();
				if (idx==0 && detailWidth>=80) detailLeft=baseLeft-40;
				else  detailLeft=baseLeft-detailWidth/2;
				$proxy.remove();
				detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+detailLeft+'px;';
				

				var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-process-detail" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'
								+detailContent
								+'</div>';
				
				$process.append(detailHtml);
			}else if(nodeData.data.length>0){
				detailStyle='padding-top:'+detailPaddingTop+'px;position:absolute;top:'+detailTop+'px;left:'+(baseLeft-40)+'px;width:80px;height:50px;';
				var detailHtml='<div data-index="'+nodeIndex+'" class="orderview-process-detail" style="'+detailStyle+'" data-options="'+detailPopoverOptions+'">'+'</div>';
				$process.append(detailHtml);
			}
		}
		///left1���left
		///top1 ���top
		///top2 �յ�top
		///width ��㵽�յ�ˮƽ����
		///state1 ���״̬
		///state2 �յ�״̬
		///index ��֧index
		///len ��֧��
		function getBrokenLineHtml(left1,top1,top2,width,state1,state2,index,len){
			var htmlArr=[];
			if(index==0){//��������һ�κ��� ������ɫ����ǰ������֧��ɫ
				var horizontalStyle='position:absolute;top:'+top1+'px;left:'+left1+'px;width:'+Math.floor(width*0.3)+'px;';
				var horizontalHtml='<div class="orderview-process-line orderview-process-state'+state1+'" style="'+horizontalStyle+'"></div>';
				htmlArr.push(horizontalHtml);
			}
			//����
			var h=(len-1)/2-index,height=Math.floor( Math.abs(h)*branchHeight +3),zIndex=11+Math.ceil(Math.abs(h));
			height=Math.abs(top1-top2)+3;
			var vTop=h>0?top2:(top2-height+3)+2;
			if (height>0){
				var verticalStyle='position:absolute;top:'+vTop+'px;left:'+(left1+Math.floor(width*0.3))+'px;height:'+height+'px;z-index:'+zIndex+';';
				var verticalHtml='<div class="orderview-process-line-v orderview-process-state'+state2+'" style="'+verticalStyle+'"></div>';
				htmlArr.push(verticalHtml);
			}
			//���������֧�㻭����
			var lineStyle='position:absolute;top:'+top2+'px;left:'+(left1+Math.floor(width*0.3))+'px;width:'+Math.floor(width*0.7)+'px;';
			var lineHtml='<div class="orderview-process-line orderview-process-state'+state2+'" style="'+lineStyle+'"></div>';
			htmlArr.push(lineHtml);
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
		

		$process_wrap.empty().append($process);
        if (typeof opts.processDetailPopover!="boolean" || opts.processDetailPopover!==false){  //�����ж�
            $process.find('.orderview-process-detail').each(function(){
				var index=$(this).data('index')+'';
				var indexArr=index.split('-');
				if (indexArr.length==1){
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
                        //$li.append('<div class="orderview-before"></div>')
                        $li.append('<div><span>'+this.ActDesc+(typeof this.PartDesc=='string'?'('+this.PartDesc+')':'')+'</span><span style="padding-left:10px;color:#333;">'+this.OprUser+'</span></div>');
						$li.append('<div><span style="color:#666">'+this.OprDate+' '+this.OprTime+'</span></div>');
						if (this.Note) $li.append('<div style="color:#f00">'+this.Note+'</div>');
                        if(this.Sort<0) $li.addClass('orderview-process-state2');
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
				url+=(url.indexOf('?')>-1?'&':'?')+'ordItemId='+opts.orders[0];
				if (chartData.ValExpr) url+=url.indexOf('?')>-1?'':'?a=a'+chartData.ValExpr;
				var $iframe=$('<iframe name="orderview-chart-'+chartData.Code+'" style="width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe>').appendTo(chartPanel);
				$iframe.attr('src',url);
			}else if(chartData.JsFun){
				if (typeof window[chartData.JsFun]=='function'){
					window[chartData.JsFun](ele,data,chartData,chartPanel);
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
			var content=opts.contentType=='html'?'<div class="orderview"></div>':'<iframe class="iframe" scrolling="auto"  src=""></iframe>';
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
                $.extend(state.options, opts);
            } else {
				var parsedOpts=$.fn.orderview.parseOptions(this);
				if (parsedOpts.labels || opts.labels ) opts.isCustomLabels=true; //�Ƿ����Զ���labels
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
    };
})(jQuery);


















