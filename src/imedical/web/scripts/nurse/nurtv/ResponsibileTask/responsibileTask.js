(function ($) {
	var taskTimer;
	var taskReqCount = 0;
	var hospID = localStorage['hospId'];
	var wardID = localStorage['wardId'];
	var locId = localStorage['locId'];
	var nurXhr,lifeXhr,patXhr;
	baseSetup();
	function baseSetup(){
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		mui('.mui-scroll-wrapper').scroll({
			bounce: true,
			indicators: true, //是否显示滚动条
		});
		var lifeScale = document.getElementById('lifeScale');
		lifeScale.addEventListener(tapType,function(){
			scaleBtnTapped('life',this);
		});
		var nurScaleImg = document.getElementById('nurScale');
		nurScaleImg.addEventListener(tapType,function(){
			scaleBtnTapped('nur',this);
		});
		//患者模式 任务模式
		mui('#res-pat').on(tapType,'.res-pat-btn',changeMode);
		//时间条
		setupTimeFilter();
		$.DHCRequestXMl(function(result) {
			getServerTime(function(hourStr){
				updateTimeFilter(hourStr)
				getWardGroup(true);
			});
		},function(err){
		})
		
	}
	
	function getServerTime(block){
		$.DHCWebService('GetServerTime', {}, function(result) {
			var serverHour = result['data'].substring(11,13);
			localStorage['hourStr'] = serverHour
			block(serverHour);
		}, function(errorStr) {
			var dateObj = new Date()
			var hour = dateObj.getHours()
			if (hour < 10) {
				hour = '0'+hour
			}
			block(''+hour);
		});
	}
	
	function getWardGroup(isFirst){ //isFirst:为true表示第一次请求,需要获取所有数据,切换界面时不至于数据空白
		if (lifeXhr) {
			lifeXhr.abort()
		}
		if (nurXhr) {
			nurXhr.abort()
		}
		if (patXhr) {
			patXhr.abort()
		}
		var toast = document.querySelector('.loadingTask');
		if (!toast) {
			iziToast.show({
				class: 'loadingTask',
				title: '正在刷新',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});	
		}
		var xmlStr = {'WardID':wardID};
		$.DHCWebService('GetWardGroup',xmlStr,function(result){
			if (typeof result == 'object') {
				updateFilterUI(result);
			}else{
				updateFilterUI([]);
			}
			if (getCurrMode() == 'patMode') {
				getPatSourceData();
				if (isFirst) {
					getLifeSourceData();
					getNurSourceData();
				}
			}else{
				getLifeSourceData();
				getNurSourceData();
				if (isFirst) {
					getPatSourceData();
				}
			}
		},function(errorStr){
			updateFilterUI([]);
			if (getCurrMode() == 'patMode') {
				getPatSourceData();
				if (isFirst) {
					getLifeSourceData();
					getNurSourceData();
				}
			}else{
				getLifeSourceData();
				getNurSourceData();
				if (isFirst) {
					getPatSourceData();
				}
			}
		});
	}
	
	function getLifeSourceData(){
		var activeDom = document.querySelector('#res-filter .dhc-active');
		var idStr = activeDom.getAttribute('data-id');
		var xmlStr = {'HospID':hospID,'WardID':wardID,'GroupID':idStr,"LocID":locId};
		if (idStr == '') {
			xmlStr = {'HospID':hospID,'WardID':wardID,"LocID":locId};
		}
		var toast = document.querySelector('.loadingTask');
		if (!toast) {
			iziToast.show({
				class: 'loadingTask',
				title: '正在刷新',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});	
		}
		lifeXhr = $.DHCWebService('GetOBTask',xmlStr,function(result){
			lifeXhr = undefined
			taskReqCount += 1;
			if (taskReqCount >= 2) {
				taskReqCount = 0
				hideToast()
			}
			updateTaskContentUI('lifeTbody',result,'lifeNull');
		},function(errorStr){
			if (errorStr=="" || errorStr.indexOf('中断') != -1) {
				return
			}
			lifeXhr = undefined
			taskReqCount += 1;
			if (taskReqCount >= 2) {
				taskReqCount = 0
				hideToast()
			}
			document.getElementById('lifeTbody').innerHTML = '';
			showNULLByElementId('lifeNull','生命体征' + errorStr,'error');
		});
	}
	function getNurSourceData(){
		var activeDom = document.querySelector('#res-filter .dhc-active');
		var idStr = activeDom.getAttribute('data-id');
		var xmlStr = {'HospID':hospID,'WardID':wardID,'GroupID':idStr,"LocID":locId};
		if (idStr == '') {
			xmlStr = {'HospID':hospID,'WardID':wardID,"LocID":locId};
		}
		var toast = document.querySelector('.loadingTask');
		if (!toast) {
			iziToast.show({
				class: 'loadingTask',
				title: '正在刷新',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});	
		}
		nurXhr = $.DHCWebService('GetPGTask',xmlStr,function(result){
			nurXhr = undefined
			updateTaskContentUI('nurTbody',result,'nurNull');
			taskReqCount += 1;
			if (taskReqCount >= 2) {
				taskReqCount = 0
				hideToast()
			}
		},function(errorStr){
			if (errorStr=="" || errorStr.indexOf('中断') != -1) {
				return
			}
			nurXhr = undefined
			taskReqCount += 1;
			if (taskReqCount >= 2) {
				taskReqCount = 0
				hideToast()
			}
			document.getElementById('nurTbody').innerHTML = '';
			showNULLByElementId('nurNull','护理评估' + errorStr,'error');
		});
	}
	function getPatSourceData(){
		var resStr = document.querySelector('#res-filter .dhc-active').getAttribute('data-id');
		var timeStr = document.querySelector('#time-filter .dhc-active').getAttribute('data-id');;
		var xmlStr = {'HospID':hospID,'WardID':wardID,"LocID":locId,'GroupID':resStr,'Time':timeStr};
		if (resStr != '') {
			xmlStr['GroupID'] = resStr;
		}
		if (timeStr != '') {
			xmlStr['Time'] = timeStr;
		}
		var toast = document.querySelector('.loadingTask');
		if (!toast) {
			iziToast.show({
				class: 'loadingTask',
				title: '正在刷新',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});	
		}
		patXhr = $.DHCWebService('GetPatTask',xmlStr,function(result){
			patXhr = undefined
			if (typeof result == 'string') {
				hideToast()
				if (getCurrMode() == 'patMode') {
					showNULLByElementId('patNull','患者模式'+result);
				}
				var patTbody = document.getElementById('patTbody');
				patTbody.innerHTML = '';
				return
			}
			updatePatUI(result);
			hideToast()
		},function(errorStr){
			if (errorStr == '' || errorStr.indexOf('中断') != -1) {
				return
			}
			patXhr = undefined
			hideToast()
			document.getElementById('patTbody').innerHTML = '';
			if (getCurrMode() == 'patMode') {
				showNULLByElementId('patNull','患者模式'+errorStr);
			}
		});
	}
	
	function updateTaskContentUI(domId,dataArr,nullId){
		var dom = document.getElementById(domId);
		var html = '';
		if (typeof dataArr == 'string') {
			if (getCurrMode() != 'patMode') {
				showNULLByElementId(nullId,dataArr);
			}
			dom.innerHTML = html;
			return
		}
		for (var i= 0; i < dataArr.length;i++) {
			var dict = dataArr[i];
			
			var nameStr = dict['name'];
			var index = nameStr.indexOf('（');
			var index2 = nameStr.indexOf('(');
			if (index != -1 || index2 != -1) {
				if (index == -1) {
					index = index2;
				}
				nameStr = '<div>'+nameStr.substring(0,index) + '</div><div>'+nameStr.substring(index,nameStr.length)+'</div>';
			}
			var dataDict = dict['data'];
			var count = 0;
			var tempStr = '';
			for (var keyStr in dataDict) {
				if (count > 0) {
					tempStr += '<tr>';
				}
				tempStr += '<td class="title2">'+keyStr+'</td>'+
						'<td class="content">'+dataDict[keyStr].join(', ')+'</td></tr>';//、
				count++;
			}
			if (count == 0) {
				html += '<tr><td colspan="2"class="title12">'+nameStr+'</td>'+
					'<td class="content"></td></tr>'
			}else{
				html += '<tr><td rowspan="'+count+'"class="title1">'+nameStr+'</td>'+tempStr;
			}
		}
		dom.innerHTML = html;
		$('#life-area').scroll().scrollTo(0,0,100);
		$('#nur-area').scroll().scrollTo(0,0,100);
		if (dataArr.length == 0) {
			if (domId == 'nurTbody') {
				showNULLByElementId(nullId,'护理评估无数据');
			}else{
				showNULLByElementId(nullId,'生命体征无数据');
			}
			
		}else{
			hiddenNULLByElementId(nullId);
		}
		html = ''
	}
	
	function updatePatUI(dataArr){
		if (dataArr && dataArr.length > 0) {
			hiddenNULLByElementId('patNull');
		}else if (getCurrMode() == 'patMode') {
			showNULLByElementId('patNull','患者模式无数据')
		}
		var html = '';
		for (var i= 0; i < dataArr.length;i++) {
			var oneDict = dataArr[i];
			var vitalSign=oneDict['vitalSign']?oneDict['vitalSign']:"";
			var assessTask=oneDict['assessTask']?oneDict['assessTask']:""
			html += '<tr><td class="bedCode">'+oneDict['bedno']+'</td>'+
				'<td class="patName" data-patName="'+oneDict['name']+'">'+dealNamePrivate(oneDict['name'])+'</td>'+
				'<td class="taskContent">'+vitalSign+'</td>'+
				'<td class="taskContent">'+assessTask+'</td></tr>';			
		}
		var patTbody = document.getElementById('patTbody');
		patTbody.innerHTML = html;
		$('#pat-area').scroll().scrollTo(0,0,100);
		html = ''
	}
	
	//{"id":1,"name":"专业组B"}
	function updateFilterUI(dataArr){
		var resFilterDom = document.getElementById('res-filter');
		var active = resFilterDom.querySelector('.res-btn.dhc-active');
		var activeId = '';
		if (active) {
			activeId = active.getAttribute('data-id');
		}
		var html = '';
		for (var i = 0; i < dataArr.length;i++) {
			var idStr = dataArr[i]['id'];
			var nameStr = dataArr[i]['name'];
			html += '<div class="res-btn'
			if (activeId == idStr) {
				html += ' dhc-active';
			}
			html += '" data-id="'+idStr+'">'+nameStr+'</div>'
		}
		if (html.indexOf('dhc-active') != -1) {
			html = '<div class="res-btn" data-id="">全部</div>'+html
		}else{
			html = '<div class="res-btn dhc-active" data-id="">全部</div>'+html
		}
		mui('#res-filter').off(tapType,'.res-btn',filterBtnTapped) 
		resFilterDom.innerHTML = html;
		mui('#res-filter').on(tapType,'.res-btn',filterBtnTapped) 
	}
	
	function filterBtnTapped(){
		var classStr = this.getAttribute('class');
		if (classStr.indexOf('dhc-active') != -1) {
			return;
		}
		if (lifeXhr) {
			lifeXhr.abort()
		}
		if (nurXhr) {
			nurXhr.abort()
		}
		if (patXhr) {
			patXhr.abort()
		}
		mui('#life-area').scroll().scrollTo(0,0,100);
		mui('#nur-area').scroll().scrollTo(0,0,100);
		var activeDom = document.querySelector('#res-filter .dhc-active');
		activeDom.classList.remove('dhc-active');
		this.classList.add('dhc-active');
		
		if (getCurrMode() == 'patMode') {
			getPatSourceData();
		}else{
			getLifeSourceData();
			getNurSourceData();
		}
	}
	/**放大/缩小按钮点击事件**/
	function scaleBtnTapped(type,btn){
		if(btn.classList.contains('iconzoom1')){
			btn.classList.remove('iconzoom1');
			btn.classList.add('iconzoom0');
		}else{
			btn.classList.remove('iconzoom0');
			btn.classList.add('iconzoom1');
		}
		var typeWrapper = document.querySelector('.'+type+'-area');
		var oldY = mui('#'+type+'-area').scroll().y;
		var oldMax = typeWrapper.clientHeight - typeWrapper.querySelector('.mui-scroll').clientHeight;
		
		var content = document.getElementById('content');
		var contentClass = content.getAttribute('class');
		if (contentClass.indexOf(type) != -1) {
			
			content.classList.remove(type);
			var titleDom = document.querySelector('.'+type+'-title');
			titleDom.style.zIndex = '10';
			var wrapper = document.querySelector('.'+type+'-area');
			wrapper.style.zIndex = '10';
			var nullData = document.getElementById(type+'Null');
			nullData.style.zIndex = '10';
			setTimeout(function(){
				var titleDom = document.querySelector('.'+type+'-title');
				titleDom.style.cssText = '';
				var wrapper = document.querySelector('.'+type+'-area');
				wrapper.style.cssText = '0';
				var nullData = document.getElementById(type+'Null');
				if (nullData.style.display == 'block') {
					nullData.style.cssText = 'display: block;';
				}else{
					nullData.style.cssText = 'display: none;';
				}
			},800);
			setTimeout(function(){
				var maxScrollY = typeWrapper.clientHeight - typeWrapper.querySelector('.mui-scroll').clientHeight;
				var percent = 1.0
				if (maxScrollY != 0 && oldMax != 0) {
					percent = maxScrollY / oldMax
				}
				if (maxScrollY >= 0 || oldY > -20) {
					$('#'+type+'-area').scroll().scrollTo(0,0,100);
					$('#'+type+'-area').scroll().reLayout();
				}else{
					$('#'+type+'-area').scroll().scrollTo(0,oldY*percent,100);
					$('#'+type+'-area').scroll().reLayout();
				}
			},410);
		}else{
			content.setAttribute('class','mui-content '+type);
			var str = 'life';
			if (type == 'life') {
				str = 'nur';
			}
			var titleDom = document.querySelector('.'+str+'-title');
			titleDom.style.cssText = '';
			var wrapper = document.querySelector('.'+str+'-area');
			wrapper.style.cssText = '0';
			var nullData = document.getElementById(type+'Null');
			// nullData.style.cssText = '0';
			setTimeout(function(){
				var maxScrollY = typeWrapper.clientHeight - typeWrapper.querySelector('.mui-scroll').clientHeight;
				var percent = 1.0
				if (maxScrollY != 0 && oldMax != 0) {
					percent = oldMax / maxScrollY
				}
				if (maxScrollY >= 0 || oldY > -20) {
					$('#'+type+'-area').scroll().scrollTo(0,0,100);
					$('#'+type+'-area').scroll().reLayout();
				}else{
					$('#'+type+'-area').scroll().scrollTo(0,oldY/percent,100);
					$('#'+type+'-area').scroll().reLayout();
				}
			},410);
			
		}
	}
	
	function changeMode(){
		var type = this.id;
		var parentNode = this.parentNode
		var oldActive = parentNode.querySelector('.dhc-active')
		if (oldActive == this) {
			return;
		}
		oldActive.classList.remove('dhc-active')
		this.classList.add('dhc-active')
		var resFilterDom = document.getElementById('res-filter')
		var timeFilterDom = document.getElementById('time-filter');
		var patHead = document.getElementById('pat-head');
		var patArea = document.getElementById('pat-area');
		if (type == 'patMode') {
			resFilterDom.classList.add('patMode')
			parentNode.classList.add('patMode')
			timeFilterDom.classList.add('patMode')
			patHead.classList.add('patMode')
			patArea.classList.add('patMode')
		}else{
			timeFilterDom.classList.remove('patMode')
			resFilterDom.classList.remove('patMode')
			parentNode.classList.remove('patMode')
			patHead.classList.remove('patMode')
			patArea.classList.remove('patMode')
			hiddenNULLByElementId('patNull');
		}
		getWardGroup();
	}
	function getCurrMode(){
		var active = document.querySelector('#res-pat .dhc-active')
		return active.id;
	}
	
	function setupTimeFilter(){
		var timeHtml = '<div class="time-btn dhc-active" data-id="">全部</div>'
		for (var i = 0; i < 24;i++) {
			if (i < 10) {
				timeHtml += '<div class="time-btn" data-id="0'+i+':00">0'+i+':00</div>'
			}else{
				timeHtml += '<div class="time-btn" data-id="'+i+':00">'+i+':00</div>'
			}
		}
		mui('#time-filter')[0].innerHTML = timeHtml;
		mui('#time-filter').on(tapType,'.time-btn',function(){
			if (patXhr) {
				patXhr.abort()
			}
			var activeDom = document.querySelector('#time-filter .dhc-active');
			activeDom.classList.remove('dhc-active');
			this.classList.add('dhc-active');
			getPatSourceData();
		})
	}
	
	function updateTimeFilter(hourStr){
		if (hourStr == undefined) {
			hourStr = localStorage['hourStr']
		}
		var timeFilter = document.getElementById('time-filter');
		var activeDom = document.querySelector('#time-filter .dhc-active');
		if (activeDom.innerText == hourStr + ':00') {
			return
		}
		var newDom = document.querySelector('#time-filter .time-btn[data-id="'+hourStr+':00"]');
		activeDom.classList.remove('dhc-active');
		newDom.classList.add('dhc-active');
	}
	
	window.addEventListener('message',function(e){
		if (e.data.wardId != wardID && e.data.refreshType == 'ward') {//切换病区
			wardID = e.data.wardId;
			locId = e.data.locId;
			getWardGroup();
			if (taskTimer) {
				clearInterval(taskTimer);
				taskTimer = undefined;
			}
			timeIntervalSetup();
			return
		}
		wardID = e.data.wardId;
		changeDayNightMode(e.data.nightMode);
		if (e.data.refresh) {
			resetRefresh();
		} else if (e.data.namePrivate) {
			mui('#patTbody .patName').each(function (index,element) {
				element.innerHTML = dealNamePrivate(element.getAttribute('data-patName'))
			})
		}else if (e.data.isActive != undefined && e.data.isActive == false) {
			if (taskTimer) {
				clearInterval(taskTimer);
				taskTimer = undefined;
			}
		}else if(e.data.isActive){
			if(!taskTimer){
				timeIntervalSetup();
			}
			getWardGroup();
		}
	},false);
	
	function resetRefresh() {
		var toast = document.querySelector('.loadingTask');
		if (toast) {
			return;
		}
		getWardGroup();
	}
	function changeDayNightMode(mode){
		var classStr = document.body.getAttribute('class');
		if (!classStr || classStr.indexOf('nightMode') == -1) {
			if(mode){
				document.body.classList.add('nightMode');
			}
		}else{
			if(!mode){
				document.body.classList.remove('nightMode');
			}
		}
	}
	function hideToast(str){
		if (!str) {
			str = '.loadingTask';
		}
		var toast = document.querySelector(str);
		if (toast) {
		    iziToast.hide({
			       transitionOut: 'fadeOutUp'
		    }, toast);
		}
	}
	function timeIntervalSetup(){
		if (taskTimer) {
			return
		}
		var len = 10 * 60 * 1000;//10分钟
		taskTimer = setInterval(function(){
			updateTimeFilter()
			resetRefresh();//有刷新提示
		},len);
	}
	windowAddMouseWheel();
	function windowAddMouseWheel() {
	    var scrollFunc = function (e) {
			var domId = '';
			e = e || window.event;
			
			var target = e.target;
			var tagName = target.tagName;
			while(tagName != "BODY" && tagName != "HTML"){
				var id = target.id;
				switch (id){
					case 'nur-area':
					case 'life-area':
					case 'pat-area':
						domId = id;
						break;
					default:
						break;
				}
				if (domId != '') {
					break;
				}
				target = target.parentNode;
				tagName = target.tagName;
			}
			
			if (domId == '') {
				return;
			}
			mouseWheelScroll(domId,e)
	    };
		//滚动滑轮触发scrollFunc方法
	    window.onmousewheel = scrollFunc;
	}
	function changeTimeFilterWidth(){
		var mode = getCurrMode();
		var width = document.getElementById('content').clientWidth - 10*SCALE;
		if (width > 1500) {
			width = 1500;
		}
		if (window.screen.width >= 3840) {
			width = 2500;
		}
		var timeFilter = document.getElementById('time-filter')
		timeFilter.style.width = width +'px';
	}
	window.onresize = changeTimeFilterWidth;
})(mui);
