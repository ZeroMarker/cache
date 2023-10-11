// mui.plusReady(function() {
// 	if (plus.os.name == "Android") {
// 		if(plus.device.model.substr(0,3) == 'DMB' || plus.device.model.substr(0,3) == 'dmb' || plus.device.model.substr(0,3) == 'Dmb'){
			
// 		}else if(plus.device.vendor.substr(0,3) == 'DMB' || plus.device.vendor.substr(0,3) == 'dmb' || plus.device.vendor.substr(0,3) == 'Dmb'){
			
// 		}else{
// 			document.body.style.display = 'none';
// 			plus.runtime.quit();
// 		}
// 	}
// });
mui.plusReady(function() {
	plus.runtime.getProperty( plus.runtime.appid, function(wigInfo){
		var version = document.getElementById('version')
		version.innerText = wigInfo.version;
		version.setAttribute('data-appid',wigInfo.appid)
	});
});
var indexObj = (function($) {
	if (localStorage['token'] == undefined && isShowVersion) {
		window.location.href = 'login/login.html';
		return;
	}
	var audio = document.getElementById('audio');
	var voice = false;
	var currTabId = '#tab1';
	var hospID = localStorage['hospId'];
	var locID = localStorage['locId'];
	var groupID = localStorage['groupId'];
	var wardID = localStorage['wardId'];
	var hospName = localStorage['hospName'];
	var locDesc = localStorage['locDesc'];
	var newOrderTimer = undefined;
	var newsPage = 1,newsPull,isPulling = false,Limit = 20;
	$.init();
	$('.mui-scroll-wrapper').scroll({
		indicators: true //是否显示滚动条
	});
	var indexOption = {
		msgWindow: true,
		newOrder: true,
		namePrivate: true,
		nightMode: false,
		refresh: false,
		hasSwitch: false,
		opFirst:true,
		wardId:wardID,
		locId:locID
	}
	updateMergeWardUI();
	jQuery(document).ready(function () {
		baseSetup();
	});
	rightNofSwitchSetup();
	
	windowAddMouseWheel();
	//侧边栏点击
	function nofSwitchTapped() {
		var body = document.body;
		var nofSwitch = document.getElementById("switch");
		var bedMapBody;
		if ($('#BedMap')[0]) {
			var BedMapiFr = document.getElementById('BedMap').contentWindow;
			bedMapBody = BedMapiFr.document.body
		}
		
		if (nofSwitch.classList.contains('iconshow')) {
			nofSwitch.classList.remove('iconshow');
			nofSwitch.classList.add('iconhide');
			
			if (bedMapBody) {
				bedMapBody.classList.add('hasSwitch');
			}
			body.classList.add('open');
			indexOption.hasSwitch = true;
		} else if (nofSwitch.classList.contains('iconhide')) {
			nofSwitch.classList.remove('iconhide');
			nofSwitch.classList.add('iconshow');
			
			if (bedMapBody) {
				bedMapBody.classList.remove('hasSwitch');
			}
			body.classList.remove('open');
			indexOption.hasSwitch = false;
		}
	}
	function setFullScreen(btn){
		var flag = btn.getAttribute('data-flag');
		if(flag == 'full'){
			exitFullscreen();
			btn.setAttribute('data-flag','nofull');
		}else{
			requestFullScreen();
			btn.setAttribute('data-flag','full');
		}
	}

	//刷新按钮点击事件
	function refreshBtnTapped(dayStr) {
		checkToken()
		indexOption.refresh = true;
		if (typeof dayStr == 'string') {
			indexOption.dayStr = dayStr;
		}
		var toast = document.querySelector('.newOrder'); //关闭旧的新医嘱消息
		if (toast) {
		    iziToast.hide({
		        transitionOut: 'fadeOutUp'
		    }, toast);
		}
		//重置定时器
		if (newOrderTimer) {
			clearInterval(newOrderTimer);
			newOrderTimer = undefined;
		}
		if(indexOption.newOrder == true){
			setNewOrderTimer();
		}
		
		//刷新index
		var topSlider = document.getElementById("topSegControl");
		var activeSeg = topSlider.querySelector('.mui-active');
		if(activeSeg.getAttribute('href')==='#item1mobile'){
			resetGetNewsRefresh()
		}else{
			getWeekPlan()
		}
		var bottomSlider = document.getElementById("botSegControl");
		var activeSeg = bottomSlider.querySelector('.mui-active');
		if(activeSeg.getAttribute('href')==='#item1'){
			getlyb()
		}else{
			getDoc()
		}
		getscrollInput();
		//刷新iframe
		var iframeContainer = document.getElementById("container");
		var activeTabbar = iframeContainer.querySelector('.mui-active');
		switch (activeTabbar.id) {
			case 'tab1':
				setupIframePostMessage('BedMap', indexOption); //床位图
				break;
			case 'tab2':
				setupIframePostMessage('ResponsibileTask', indexOption); //责组任务
				break;
			case 'tab3':
				setupIframePostMessage('ShiftWork', indexOption); //护理交班
				break;
			case 'tab4':
				setupIframePostMessage('OperationPlan', indexOption); //术检排程
				break;
			case 'tab6':
				setupIframePostMessage('NurSchedule', indexOption); //护理排班
				break;
			case 'tab7':
				setupIframePostMessage('CriticalValue', indexOption); //危急值
				break;
		}
		indexOption.refresh = false;
		if (typeof dayStr == 'string') {
			indexOption.dayStr = '';
		}
	}
	
	//退出按钮点击事件
	function exitBtnTapped() {
		var toast = document.querySelector('.exitWindow');
		if (toast) {
			iziToast.hide({
				transitionOut: 'fadeOutUp'
			}, toast);
		}
		// var notificationCenter = document.querySelector('.notificationCenter');
		// if (notificationCenter) {
		// 	iziToast.setOption({
		// 		title: '新的留言',
		// 		message: '用来修改已经弹出的iziToast',
		// 	}, notificationCenter);
		// }
		iziToast.info({
			class: 'exitWindow',
			title: '注销登录？',
			position: 'topRight',
			timeout: null,
			color: 'green',
			close: false,
			buttons: [
				['<button>注销</button>', function(btn, instance, toast) {
					var storage = window.localStorage;
					var nightMode = localStorage['nightMode']
					storage.clear();
					localStorage['nightMode'] = nightMode
					window.location.href = 'login/login.html';
				}],
				['<button>取消</button>', function(btn, instance, toast) {
					var toast = document.querySelector('.exitWindow');
					if (toast) {
						iziToast.hide({
							transitionOut: 'fadeOutUp'
						}, toast);
					}
				}],
				['<button>检查更新</button>', function(btn, instance, toast) {
					var toast = document.querySelector('.exitWindow');
					if (toast) {
						iziToast.hide({
							transitionOut: 'fadeOutUp'
						}, toast);
					}
					updateVersion()
				}]
			],
			onOpen: function() {
				mui.toast('onOpen');
			},
			onClose: function() {
				mui.toast('onOpen');
			}
		});
	}
	//提交设置
	function commitSettings() {
		changeDayNightMode(getSwitchStateById('nightMode'));
		indexOption.msgWindow = getSwitchStateById('msgWindow');
		indexOption.newOrder = getSwitchStateById('newOrder');
		indexOption.namePrivate = getSwitchStateById('namePrivate');
		indexOption.nightMode = getSwitchStateById('nightMode');
		indexOption.opFirst = getSwitchStateById('opFirst');
		var dict = copyIndexOptions();
		if (localStorage['namePrivate'] == 'true' && !indexOption.namePrivate) {
			dict['namePrivate'] = true;
			localStorage['namePrivate'] = indexOption['namePrivate'];
			updateNewsUIPrivate();
		} else if (localStorage['namePrivate'] == 'false' && indexOption.namePrivate) {
			dict['namePrivate'] = true;
			localStorage['namePrivate'] = indexOption['namePrivate'];
			updateNewsUIPrivate();
		}
		if (localStorage['opFirst'] == 'false' && indexOption.opFirst) {
			dict['opFirst'] = true;
		}else{
			dict['opFirst'] = false;
		}
		var oldNewOrder = localStorage['newOrder']
		localStorage['newOrder'] = indexOption['newOrder'];
		localStorage['msgWindow'] = indexOption['msgWindow'];
		localStorage['namePrivate'] = indexOption['namePrivate'];
		localStorage['nightMode'] = indexOption['nightMode'];
		localStorage['opFirst'] = indexOption['opFirst'];
		
		if(!indexOption.newOrder){
			// 清除定时器
			if (newOrderTimer) {
				clearInterval(newOrderTimer);
				newOrderTimer = undefined;
			}
			var toast = document.querySelector('.newOrder');
			if (toast) {
			    iziToast.hide({
			        transitionOut: 'fadeOutUp'
			    }, toast);
			}
		}else if (oldNewOrder == 'false' && localStorage['newOrder'] == 'true') {
			// 清除定时器并重新开始请求新医嘱
			if (newOrderTimer) {
				clearInterval(newOrderTimer);
				newOrderTimer = undefined;
			}
			resetGetNewsRefresh()
		}
		if(!indexOption.msgWindow){
			var toast = document.querySelector('.newOrder');
			if (toast) {
			    iziToast.hide({
			        transitionOut: 'fadeOutUp'
			    }, toast);
			}
		}
		setupIframePostMessage('BedMap', dict);
		setupIframePostMessage('ResponsibileTask', dict);
		setupIframePostMessage('ShiftWork', dict);
		setupIframePostMessage('OperationPlan', dict);
		setupIframePostMessage('NurSchedule', dict);
		setupIframePostMessage('CriticalValue', dict);
	}

	function changeDayNightMode(mode) {
		var indexBody = document.body;
		if (mode) {//
			indexBody.classList.add('nightMode');
		} else {
			indexBody.classList.remove('nightMode');
		}
	}

	function getSwitchStateById(eleId) {
		var isActive = document.getElementById(eleId).classList.contains("mui-active");
		if (isActive) {
			return true;
		} else {
			return false;
		}
	}

	function setSwitchState(eleId) {
		var state = indexOption[eleId];
		var ele = document.getElementById(eleId);
		if (state == true) {
			ele.classList.add('mui-active');
		} else {
			ele.classList.remove('mui-active');
		}
		ele.querySelector('.mui-switch-handle').setAttribute('style', '');
	}

	function setupIframePostMessage(iframeId, customOption) {
		var iframeDom = document.getElementById(iframeId);
		if (!iframeDom) {
			return
		}
		var contentWindow = iframeDom.contentWindow;
		contentWindow.postMessage(customOption, '*');
	}

	function getLocalIndexInfo(str) {
		var flag = localStorage[str];
		if (flag == 'false') {
			indexOption[str] = false;
		} else if (flag == 'true') {
			indexOption[str] = true;
		} else { //初次
			localStorage.setItem(str, indexOption[str])
		}
	}

	function saveContainerSize() {
		var bodyDom = document.body;
		var bodyClass = bodyDom.getAttribute('class');
		var isOpen = false;
		if (bodyClass && bodyClass.indexOf('open') != -1) {
			isOpen = true;
		}
		var container = document.getElementById('container');
		var active = container.querySelector('.mui-control-content.iframeBox.mui-active');
		var width = active.clientWidth;
		var height = active.clientHeight;
		if (active.id == 'tab1') {
			width = width * 0.875
		} else {
			if (!isOpen) {
				width = (width + 30) * 0.875;
			}
		}
		localStorage.setItem('bodyW', container.clientWidth)
		localStorage.setItem('bodyH', container.clientHeight)
	}

	function getLYBandWeekPlan(e) {
		if(e.target.id == 'topSlider'){
			if (e.detail.slideNumber === 0) {
				//重置定时器
				if (newOrderTimer) {
					clearInterval(newOrderTimer);
					newOrderTimer = undefined;
				}
				resetGetNewsRefresh()
			}
			if (e.detail.slideNumber === 1) {
				getWeekPlan();
			}
			var withoutClock = document.getElementById('withoutClock');
			var scaleBtn = document.getElementById('scaleBtn');
			scaleBtn.classList.remove('iconzoom0');
			scaleBtn.classList.add('iconzoom1');
			withoutClock.classList.remove('lybMax')
		}
		
		if(e.target.id == 'botSlider'){
			if (e.detail.slideNumber === 0) {
				getlyb();
			}
			if (e.detail.slideNumber === 1) {
				getDoc()
			}
		}
		
	}

	function getWeekPlan() {
		var planData;
		var item3 = document.getElementById('item3mobile');
		$('#scroll3').scroll().scrollTo(0,0,100);
		item3.querySelector('.weekPlan').innerHTML = '';
		if (item3.querySelector('.mui-loading')) {
			var clock = document.querySelector('.date')
			var currDate = clock.innerText;
			var xmlStr = {
				'ctlocId': indexOption.locId,
				'date': currDate
			};
			$.DHCWebService('GetNurheadWeekPlan', xmlStr, function(result) {
				planData = result['data'] + '';
				item3.querySelector('.weekPlan').innerHTML = planData;
				if(planData == ''){
					item3.querySelector('.weekPlan').innerHTML = '暂无周计划';
				}
			}, function(errorStr) {
				item3.querySelector('.weekPlan').innerHTML = '周计划查询失败！';
			});
		}
	}
	
	function getlyb() {
		var lybData = '';
		var liuyanInput = document.getElementById("liuyanInput");
		var lyb = document.getElementById('item1');
		var lybTextDom = lyb.querySelector('.liuyanban')
		$('#wrapper1').scroll().scrollTo(0,0,100);
		lybTextDom.innerHTML = '';
		lybTextDom.setAttribute('data-origin',"");
		if (lyb.querySelector('.mui-loading')) {
			var xmlStr = {
				'HospID':hospID,
				'WardID': indexOption.wardId
			};
			$.DHCWebService('GetLYB', xmlStr, function(result) {
				lybData = result['data'] + '';
				liuyanInput.value = lybData.replace(/\n/g,'\r');
				lybData = lybData.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				lybTextDom.innerHTML = lybData;
				lybTextDom.setAttribute('data-origin',lybData);
				if(lybData == ''){
					lybTextDom.innerHTML = '暂无留言';
					lybTextDom.setAttribute('data-origin',"");
				}
			}, function(errorStr) {
				lybTextDom.innerHTML = '留言板获取失败！';
				lybTextDom.setAttribute('data-origin',"");
			});
		}
	}

	function getDoc() {
		var docData;
		var docInput = document.getElementById("docInput");
		docInput.innerHTML = '';
		var doc = document.getElementById('item2');
		var docTextDom = doc.querySelector('.docInfo')
		$('#wrapper2').scroll().scrollTo(0,0,100);
		docTextDom.innerHTML = '';
		docTextDom.setAttribute('data-origin',"");
		if (doc.querySelector('.mui-loading')) {
			var xmlStr = {
				'HospID':hospID,
				'WardID': indexOption.wardId
			};
			$.DHCWebService('GetDocPhone', xmlStr, function(result) {
				docData = result['data'] + '';
				docInput.value = docData.replace(/\n/g,'\r');;
				docData = docData.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				docTextDom.innerHTML = docData;
				docTextDom.setAttribute('data-origin',docData);
				if(docData == ''){
					docTextDom.innerHTML = '未录入值班医生';
					docTextDom.setAttribute('data-origin',"");
				}
			}, function(errorStr) {
				docTextDom.innerHTML = '值班医生接口错误！';
				docTextDom.setAttribute('data-origin',"");
			});
		}
	}
	//获取滚动字幕
	function getscrollInput() {
		var scrTxtData = '';
		var scrollInput = document.getElementById("scrollInput");
		var scrollArea = document.getElementById("scrollArea");
		var marquee = scrollArea.querySelector('marquee')
		marquee.innerText = scrTxtData;
		marquee.setAttribute('data-origin',scrTxtData);
			var xmlStr = {
				'HospID':hospID,
				'WardID': indexOption.wardId
			};
			$.DHCWebService('GetScrollText', xmlStr, function(result) {
				var data = result['data'] + '';
				var jieqi = result['jieqi'] == undefined?'':result['jieqi']
				scrTxtData = data.replace(/\n/g,'').replace(/\r/g,'');//滚动字幕不考虑换行
				marquee.innerHTML = scrTxtData+jieqi;
				marquee.setAttribute('data-origin',scrTxtData);
				marquee.setAttribute('data-jieqi',jieqi);
				scrollInput.value = scrTxtData;
				if(scrTxtData == ''&&jieqi==""){
					marquee.innerText = '暂无滚动文字！';
					marquee.setAttribute('data-origin',"");
					marquee.setAttribute('data-jieqi','');
				}
			}, function(errorStr) {
				marquee.innerText = '滚动字幕获取失败！';
				marquee.setAttribute('data-origin',"");
				marquee.setAttribute('data-jieqi','');
			});
	}
	
	function copyIndexOptions() {
		var dict = {
			'msgWindow': indexOption.msgWindow,
			'newOrder': indexOption.newOrder,
			'namePrivate': false,
			'nightMode': indexOption.nightMode,
			'hasSwitch': indexOption.hasSwitch,
			'opFirst':indexOption.opFirst,
			'wardId':indexOption.wardId,
			'locId':indexOption.locId
		};
		return dict;
	}

	//侧边栏配置
	function rightNofSwitchSetup() {
		var nofSwitch = document.getElementById("switch");
		nofSwitch.addEventListener(tapType, nofSwitchTapped, false);
		var msgBtn = document.getElementById("msgBtn");
		msgBtn.addEventListener(tapType,function(){
			 nofSwitchTapped(this);
		}, false);

		var topSlider = document.getElementById('topSlider');
		topSlider.addEventListener('slide', getLYBandWeekPlan, false);
		var botSlider =  document.getElementById('botSlider');
		botSlider.addEventListener('slide', getLYBandWeekPlan, false);
		
		
		mui('#withoutClock .mui-control-item').each(function (index,element) {
			element.addEventListener(tapType,function(){
				var thisDom = this;
				var href = thisDom.getAttribute('href')
				var content = $(href)[0]
				if (content.getAttribute('class').indexOf('mui-active') != -1) {
					return;
				}
				var sliderId="botSlider"
				var newIndex = 0
				switch (href){
					case '#item1mobile':
						sliderId="topSlider"
						break;
					case '#item3mobile':
						sliderId="topSlider"
						newIndex = 1
						break;
					case '#item1':
						break;
					case '#item2':
						newIndex = 1
						break;
					default:
						break;
				}
				mui('#'+sliderId).slider().gotoItem(newIndex,0)
			})
		})
		
		var sliderSegmentedControl = document.getElementById('sliderSegmentedControl');
		$('.mui-input-group').on('change', 'input', function() {
			if (this.checked) {
				var str = 'mui-slider-indicator mui-segmented-control mui-segmented-control-inverted mui-segmented-control-' +
					this.value;
				sliderSegmentedControl.className = str;
				sliderProgressBar.setAttribute('style', sliderProgressBar.getAttribute('style'));
			}
		});

		document.getElementById("editCommit").addEventListener(tapType, function() {
			var lybArea = document.getElementById("liuyanInput");
			var docInput = document.getElementById("docInput");
			var scorllText = document.getElementById("scrollInput");
			var lybisSpecial = checkIsHasSpecialStr(lybArea.value,true);
			var docisSpecial = checkIsHasSpecialStr(docInput.value,true);
			var textisSpecial = checkIsHasSpecialStr(scorllText.value,true);
			if (lybisSpecial || docisSpecial || textisSpecial) {
				iziToast.error({
				    title: '含有非法特殊字符！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
				return;
			}
			var lybChange = isSelfDefineTextChange(lybArea.value,'#item1 .liuyanban');
			var docChange = isSelfDefineTextChange(docInput.value,'#item2 .docInfo');
			var scrollChange = isSelfDefineTextChange(scorllText.value,'#scrollArea marquee');
			if(lybChange){
				writeLYB();
			}
			if(scrollChange){
				setScrollInput();
			}
			if(docChange){
				writeDocPhone();
			}
			
			showOrHideDHCpopover('msgPopover','hide');
		})
		document.getElementById("editCancle").addEventListener(tapType, function() {
			showOrHideDHCpopover('msgPopover','hide');
		})
		document.getElementById("editClose").addEventListener(tapType, function() {
			showOrHideDHCpopover('msgPopover','hide');
		})
		// document.getElementById("editClose2").addEventListener('tap', function() {
		// 	showOrHideDHCpopover('docPopover','hide');
		// })
		var dhcBackdrop = document.getElementById('dhcBackdrop');
		dhcBackdrop.addEventListener(tapType, function() {
			var popover = document.querySelector('.mui-popover.mui-active');
			if (popover) {
				showOrHideDHCpopover(popover.id,'hide');
			}else{
				this.classList.remove('dhc-active');
			}
		});
	}

	function baseSetup() {
		saveContainerSize();
		mui('#tabbar').on(tapType,'.mui-tab-item',tabbarTapped)
		setupTabbars(); //tabbar走json文件配置
		mui('.setPopover').on('toggle','.mui-switch',setPopoverSwicthToggle) 
		var loc = localStorage['locDesc'];
		if (!loc) {
			window.location.href = 'login/login.html';
			return;
		}
		document.body.style.opacity = '1';
		//document.querySelector('.ward').innerText = loc;
		if(hospName && hospName != undefined){
			document.querySelector('.hospName').innerText = hospName;
		}
		setTimeout(function() {
			iziToast.success({
				title: '欢迎使用东华医为电子白板!',
				message: '',
				timeout: 4000,
				color: 'green',
				transitionIn: 'bounceInLeft',
				position: 'topRight',
			});
		}, 300);
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		getLocalIndexInfo('msgWindow');
		getLocalIndexInfo('newOrder');
		getLocalIndexInfo('namePrivate');
		getLocalIndexInfo('nightMode');
		getLocalIndexInfo('opFirst');
		// getServerTime();
		$.DHCRequestXMl(function(result) {
			getNewMsg();
			getlyb();
			getscrollInput();
			Get24JieQi()
		},function(err){
			var toast = document.querySelector('.xmlError');
			if (!toast) {
				iziToast.error({
					class: 'xmlError',
					title: err,
					position: 'center',
					timeout: 1000,
					color: '#FF0000',
					transitionOut: 'flipOutX',
					close: true
				});
			}
		})
		
		//全屏显示
		// var fullScreenBtn = document.getElementById("fullScreenBtn");
		// fullScreenBtn.addEventListener('tap', function() {
		// 	setFullScreen(fullScreenBtn);
		// });
		//刷新当前正在显示的界面
		mui('.switch').on(tapType,'#refreshBtn',refreshBtnTapped) 
		//设置按钮
		var mask = mui.createMask(function() { //遮罩层callback事件
			return false; //返回true关闭mask
		});
		mui('.switch').on(tapType,'#settingBtn', function() {
			setSwitchState('msgWindow');
			setSwitchState('newOrder');
			setSwitchState('namePrivate');
			setSwitchState('nightMode');
			setSwitchState('opFirst');
			mui('#setPopover').popover('show');
		});
		mui('.switch').on(tapType,'#voiceBtn', function(){
			if(this.classList.contains('iconmute')){
				this.classList.toggle("iconmute", false);
				this.classList.toggle("iconaudio", true);
				voice = true;
				mui.toast('已开启声音')
			}else{
				this.classList.toggle("iconaudio", false);
				this.classList.toggle("iconmute", true);
				voice = false;
				mui.toast('已关闭声音')
			}
		});
		mui('.switch').on(tapType,'#editBtn',  function(){
			showOrHideDHCpopover('msgPopover','show');
			getlyb();
			getDoc();
			getscrollInput();
		});
		//编辑留言板、值班医生、滚动字幕
		mui('#withoutClock').on('tap','#item1',  function(){
			showOrHideDHCpopover('msgPopover','show');
			getlyb();
			getDoc();
			getscrollInput();
		}, false);
		//编辑留言板、值班医生、滚动字幕
		mui('#withoutClock').on('tap','#item2',  function(){
			showOrHideDHCpopover('msgPopover','show');
			getlyb();
			getDoc();
			getscrollInput();
		}, false);
		
		//隐藏tabbar
		document.getElementById("hideBar").addEventListener(tapType, function() {
			var body = document.body;
			if(this.classList.contains('iconzoom1')){
				this.classList.remove('iconzoom1');
				this.classList.add('iconzoom0');
				body.classList.add('hideBar')
			}else{
				this.classList.remove('iconzoom0');
				this.classList.add('iconzoom1');
				body.classList.remove('hideBar')
			}
		});
		//设置保存事件
		document.getElementById("commitBtn").addEventListener(tapType, function(){
			mui('#setPopover').popover('hide')
			mui('#timePopover')[0].classList.remove('dhc-active')
			commitSettings()
		}, false);
		//设置关闭事件
		document.getElementById("closeBtn").addEventListener(tapType, function() {
			mui('#setPopover').popover('hide');
			mui('#timePopover')[0].classList.remove('dhc-active')
		});
		// 取消设置事件
		document.getElementById("cancelBtn").addEventListener(tapType, function() {
			mui('#setPopover').popover('hide');
			mui('#timePopover')[0].classList.remove('dhc-active')
		});
		//退出登录按钮点击
		var exitBtn = document.getElementById("exitBtn");
		exitBtn.addEventListener(tapType, exitBtnTapped, false);
		//获取新医嘱
		
		//开启监听遥控器
	//	initWindow(window);
		
		//开启新医嘱上拉加载
		var newsScroll = document.getElementById('newsScroll');
		newsPull = $(newsScroll).pullToRefresh({
			up: {
				callback: function() {
					//重置定时器
					if (newOrderTimer) {
						clearInterval(newOrderTimer);
						newOrderTimer = undefined;
					}
					getNewMsg()
				}
			}
		});
		//scaleBtn
		var scaleBtn = document.getElementById('scaleBtn');
		scaleBtn.addEventListener(tapType,lybScaleBtnTapped,false);
		
		//日夜间模式自动切换
		var dyArr = (localStorage['dayNightChange']==undefined?"":localStorage['dayNightChange']).split('^');// = "07:00^19:00^0"
		var dayHM = dyArr[0]==""?"08:00":dyArr[0]
		var nightHM = dyArr[1]==undefined?"20:00":dyArr[1]
		var dyOPen = dyArr[2]==undefined?"0":dyArr[2]
		$("#dayTime")[0].innerText = dayHM;
		$("#nightTime")[0].innerText = nightHM;
		if (dyOPen == '1') {
			$('#timeTurn')[0].classList.add('mui-active')
		}
		$('#selfBtn')[0].addEventListener(tapType,function(){
			var timePopo = $('#timePopover')[0]
			if(timePopo.getAttribute('class').indexOf('dhc-active') != -1){
				timePopo.classList.remove('dhc-active')
			}else{
				timePopo.classList.add('dhc-active')
			}
		});
		
		$("#dayTime")[0].addEventListener(tapType, selectNightModeTime);
		$("#nightTime")[0].addEventListener(tapType,selectNightModeTime);
		$('body').on(tapType,".mui-dtpicker-header > button",function(){
			var picker = $("#dayTime")[0].picker;
			if(picker){
				picker.dispose();
				$("#dayTime")[0].picker = null;
			}
			picker = $("#nightTime")[0].picker;
			if(picker){
				picker.dispose();
				$("#nightTime")[0].picker = null;
			}
		})
		$('#timeTurn')[0].addEventListener('toggle', timeInfoChanged);
	}
	
	function timeInfoChanged(){
		var dayHM = $('#dayTime')[0].innerText;
		var nightHM = $('#nightTime')[0].innerText;
		var dyOPen = '0'
		if ($('#timeTurn')[0].getAttribute('class').indexOf('mui-active') != -1) {
			dyOPen ='1'
		}
		var str = dayHM +'^'+nightHM+'^'+dyOPen;
		if (str == localStorage['dayNightChange']) {
			return;
		}
		localStorage['dayNightChange'] = str;
		if (dyOPen != '1') {
			return
		}
		var hourMinute = getNowTimeStr()
		var nightModeDom = $('#nightMode')[0];
		if(hourMinute == dayHM){ //转换为日间的时间点
			if ( localStorage['nightMode'] == "true") {
				nightModeDom.classList.remove('mui-active');
				commitSettings()
			}
		}else if(hourMinute == nightHM){ //转换为夜间的时间点
			if (localStorage['nightMode'] != "true") {
				nightModeDom.classList.add('mui-active');
				commitSettings()
			}
		}
	}
	
	function selectNightModeTime(){
		var _self = this;
		if(_self.picker) {
			var classStr = _self.picker.ui.picker.getAttribute('class');
			if(classStr.indexOf('mui-active') != -1) {
				_self.picker.dispose();
				_self.picker = null;
				return;
			}
		}
		var otherBtnId = 'dayTime';
		if(_self.id == 'dayTime') {
			otherBtnId = 'nightTime';
		}
		var otherBtn = document.getElementById(otherBtnId);
		if(otherBtn.picker) {
			var classStr = otherBtn.picker.ui.picker.getAttribute('class');
			if(classStr.indexOf('mui-active') != -1) {
				otherBtn.picker.ui.picker.style=""
				otherBtn.picker.dispose();
				otherBtn.picker = null
			}
		}
		if(_self.picker) {
			_self.picker.show(function(rs) {
				var dateStr = rs.text;
				_self.innerText = dateStr;
				_self.picker.dispose();
				_self.picker = null;
		
			});
		} else {
			var timeStr = '2021-01-01 ' + _self.innerText
			var optionsJson = '{"type":"time","value":"'+timeStr+'"}';
			var options = JSON.parse(optionsJson);
			_self.picker = new mui.DtPicker(options);
			var pos = getAbsPosition(_self); //[left,top]
			// _self.picker.ui.picker.style.left = pos.left + 'px';
			_self.picker.ui.picker.style.width = _self.clientWidth + 'px';
			_self.picker.ui.picker.style.top =(pos.top + _self.clientHeight) + 'px';
			_self.picker.show(function(rs) {
				var dateStr = rs.text;
				_self.innerText = dateStr;
				timeInfoChanged();
				_self.picker.dispose();
				_self.picker = null;
			});
		}
	}
	
	function lybScaleBtnTapped(){
		var scaleBtn = document.getElementById('scaleBtn');
		var withoutClock = document.getElementById('withoutClock');
		if(scaleBtn.classList.contains('iconzoom1')){
			scaleBtn.classList.remove('iconzoom1');
			scaleBtn.classList.add('iconzoom0');
			withoutClock.classList.add('lybMax')
			$('#wrapper1').scroll().scrollTo(0,0,100);
		}else{
			scaleBtn.classList.remove('iconzoom0');
			scaleBtn.classList.add('iconzoom1');
			withoutClock.classList.remove('lybMax')
		}
	}
	
	function setNewOrderTimer(){
		if (newOrderTimer) {
			return
		}
		var len = 2 * 60 * 1000;//计时器时长
		newOrderTimer = setInterval(function(){
			resetGetNewsRefresh()
			checkToken()
		},len);
	}
	function tabbarTapped() {
		var old = mui('.mui-tab-item.mui-active')[0]
		if (old != this) {
			old.classList.remove('mui-active')
			this.classList.add('mui-active')
		}
		
		var href = this.getAttribute('href');
		if (href == currTabId) {
			return;
		}
		var dict = copyIndexOptions();
		dict['isActive'] = false;
		var currIframeId = getIframeId(currTabId);
		$(currTabId)[0].classList.remove('mui-active');
		//原来的iframe隐藏了,告诉iframe停止定时刷新
		setupIframePostMessage(currIframeId, dict);
		
		$(href)[0].classList.add('mui-active');
		var hrefIframeId = getIframeId(href);
		currTabId = href;
		dict['isActive'] = true;
		//当前iframe显示了,告诉iframe刷新页面,开启定时刷新
		setupIframePostMessage(hrefIframeId, dict);
	}
	
	function getIframeId(itemId) {
		var str = '';
		switch (itemId) {
			case '#tab1':
				str = 'BedMap'; //床位图
				break;
			case '#tab2':
				str = 'ResponsibileTask'; //责组任务
				break;
			case '#tab3':
				str = 'ShiftWork'; //护理交班
				break;
			case '#tab4':
				str = 'OperationPlan'; //术检排程
				break;
			case '#tab6':
				str = 'NurSchedule'; //护理排班
				break;
			case '#tab7':
				str = 'CriticalValue'; //危急值	
				break;
		}
		return str;
	}
	//获取医嘱
	function getNewMsg() {
		if (isPulling) {
			newsPull.endPullUpToRefresh()
			return;
		}
		isPulling = true
		setTimeout(function() {
			isPulling = false
		}, 1000);
		if(indexOption.newOrder && newOrderTimer == undefined){
			setNewOrderTimer();
		}
		var msg = document.getElementById("msgBtn");
		var msgNum = msg.querySelector('.msgNum');
		var item1 = document.getElementById("item1mobile");
		var xmlStr = {
			'WardID': indexOption.wardId,
			'GroupID': groupID,
			'LocID': indexOption.locId,
			'Page':newsPage,
			'Limit':Limit
		};
		if (newsPage == 1) {
			var item1 = document.getElementById("item1mobile");
			item1.querySelector('.mui-table-view').innerHTML = '';
		}
		$.DHCWebService('GetNews', xmlStr, function(resultDict) {
			var jsonStr = JSON.stringify(resultDict)
			if (jsonStr != "") {
				jsonStr = jsonStr.substring(0,1)
			}
			
			var result = []
			if (resultDict['msg'] == undefined) {//成功
				result = resultDict['news']?resultDict['news']:[]
				msgNum.innerText = resultDict['rows']!=undefined?resultDict['rows']:'0';
				Limit = resultDict['Limit']!=undefined?parseInt(resultDict['Limit']):20
				if (jsonStr == '[') {//适配原来的getnews
					result = resultDict
					msgNum.innerText = result.length;
				}
			}else{
				newsPull.endPullUpToRefresh();
				return
			}
			
			// 新医嘱弹框
			if(indexOption.msgWindow){
				var toast = document.querySelector('.newOrder');
				if (toast) {
				    iziToast.hide({
				        transitionOut: 'fadeOutUp'
				    }, toast);
				}
				if(result.length > 0 && newsPage == 1){//首次请求或重置上拉刷新
					iziToast.info({
						class: 'newOrder',
						title: '新医嘱',
						message: resultDict['rows'] + '条',
						position: 'bottomRight',
						timeout: 15000,
						color: '#aad08f',
						close: true,
						buttons: [
							['<button>展开/折叠</button>', function(btn, instance, toast) {
								nofSwitchTapped();
								var toast = document.querySelector('.newOrder');
								if (toast) {
								    iziToast.hide({
								        transitionOut: 'fadeOutUp'
								    }, toast);
								}
							}]
						]
					});
					if(voice&&audio){
						audio.setAttribute('muted',false);
						audio.play();
					}
				}
			}
			updateNewsUI(result);
			if (jsonStr== '[') {//适配原来的getnews
				newsPull.endPullUpToRefresh(true);
			}else{
				newsPull.endPullUpToRefresh(result.length < Limit);
			}
			newsPage += 1;
		}, function(errorStr) {
			if (newsPage == 1) {
				item1.querySelector('.mui-table-view').innerHTML = '<div class="newsFail">新医嘱获取失败！<div>';
			}
			if(newsPull){
				newsPull.endPullUpToRefresh();
			}
		});
	}
	
	function resetGetNewsRefresh(){
		newsPage = 1;
		if (newsPull) {
			newsPull.refresh(true)
		}
		getNewMsg();
		$('#scroll1').scroll().scrollTo(0,0,100);
	}
	
	function updateNewsUI(result){
		var UL = $("#item1mobile .mui-table-view")[0];
		var lis = UL.querySelectorAll('li')
		var length = lis.length
		if (length == 0) {
			UL.innerHTML = '';
		}else{
			//lis.splice(0,length)
		}
		for(var i=0; i<result.length; i++){
			var oneDict = result[i]
			var myCanvas = '<div class="myCanvas" cuntNo="' + (i+length) + '"></div>';
			var childOrder = '';
			var children = oneDict['children']
			if(children && children.length > 0){
				for(var j=0; j<children.length; j++){
					var oneChild = children[j]
					var orderOtherHtml = '</div><div class="orderOther">' + oneChild['doseQtyUnit'] + '&nbsp;&nbsp;' +oneDict['phcinDesc'] + '</div>';
					var oneChildOrder = '<div class="orderName">' + oneChild['arcimDesc'] + orderOtherHtml;
				childOrder += oneChildOrder;
				}
				childOrder += myCanvas;
			}
			var patName = dealNamePrivate(oneDict['patName']);
			var orderOtherHtml = '</div><div class="orderOther">' + oneDict['doseQtyUnit'] + '&nbsp;&nbsp;' + oneDict['phcfrCode'] + '&nbsp;&nbsp;' + oneDict['phcinDesc'];
			var createTime = oneDict['createDateTime'].substring(5, 16);
			var oneMsgOrder = '<div class="createTime">' + createTime +
								'</div><div class="patInfo" data-bedcode="'+oneDict['bedCode']+'" data-name="'+oneDict['patName']+'">' + oneDict['bedCode'] + '-' + patName+
								'</div><div class="orderName">' + oneDict['arcimDesc'] +
								orderOtherHtml + '</div>' + childOrder;
			var newLi = document.createElement('li')
			UL.appendChild(newLi)
			newLi.setAttribute('class','mui-table-view-cell oneOrder')
			newLi.setAttribute('cuntNo',i+length)
			newLi.innerHTML = oneMsgOrder
			oneMsgOrder = ''
			//drawCanvas(newLi.querySelector('.myCanvas'))
		}
	}
	function drawCanvas(dom){
		if (!dom) {
			return
		}
		var ctx=dom.getContext("2d");
		var cHeight = dom.height;
		ctx.strokeStyle = 'gray';
		if(ISMOBILE){
			ctx.moveTo(10,35);
			ctx.lineTo(5,35);
			ctx.lineTo(5,cHeight - 20);
			ctx.lineTo(40,cHeight - 20);
			ctx.stroke();
		}else{
			ctx.moveTo(35,35);
			ctx.lineTo(5,35);
			ctx.lineTo(5,cHeight - 20);
			ctx.lineTo(35,cHeight - 20);
			ctx.stroke();
		}
	}
	function updateNewsUIPrivate(){
		mui('#item1mobile .patInfo').each(function (index,element) {
			element.innerHTML = element.getAttribute('data-bedcode') + '-' +dealNamePrivate(element.getAttribute('data-name'));
		})
	}
	//写留言
	function writeLYB() {
		var lybArea = document.getElementById("liuyanInput")
		var item2 = document.getElementById("item1")
		var xmlStr = {
			'HospID':hospID,
			'WardID': indexOption.wardId,
			'Content': lybArea.value
		};
		$.DHCWebService('WriteLYB', xmlStr, function(result) {
			//读取床位图配置和数据
			if(result['flag'] == "true" || result['flag'] == true){//部分项目flag返回的是"true",不是布尔值
				//mui('#msgPopover').popover('hide');
				showOrHideDHCpopover('msgPopover','hide');
				item2.querySelector('.liuyanban').innerHTML = lybArea.value.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				iziToast.success({
				    title: '留言板保存成功！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
				var iframeContainer = document.getElementById("container");
				var activeTabbar = iframeContainer.querySelector('.mui-active');
				if (activeTabbar.id == "tab1") {//用于刷新日志中的留言板
					indexOption.refresh = true;
					setupIframePostMessage('BedMap', indexOption);
					indexOption.refresh = false;
				}
			}else{
				iziToast.error({
				    title: '留言板保存失败！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
			}
		}, function(errorStr) {
			iziToast.error({
			    title: errorStr,
				position: 'center',
			    timeout: 800,
				transitionOut: 'flipOutX'
			});
			//读取床位图配置和数据
		});
	}
	function writeDocPhone(){
		var docInput = document.getElementById("docInput")
		var item2 = document.getElementById("item2")
		var xmlStr = {
			'HospID':hospID,
			'WardID': indexOption.wardId,
			'Content': docInput.value
		};
		$.DHCWebService('WriteDocPhone', xmlStr, function(result) {
			//读取床位图配置和数据
			if(result['flag'] == "true" || result['flag'] == true){
				item2.querySelector('.docInfo').innerHTML = docInput.value.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				iziToast.success({
				    title: '值班医生保存成功！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
			}else{
				iziToast.error({
				    title: '值班医生保存失败！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
			}
		}, function(errorStr) {
			iziToast.error({
			    title: errorStr,
				position: 'center',
			    timeout: 800,
				transitionOut: 'flipOutX'
			});
			//读取床位图配置和数据
		});
	}
	
	function setScrollInput(){
		var scrollInput = document.getElementById("scrollInput");
		var scrollArea = document.getElementById("scrollArea");
		var xmlStr = {
			'HospID':hospID,
			'WardID': indexOption.wardId,
			'Content': scrollInput.value
		};
		$.DHCWebService('WriteSCroll', xmlStr, function(result) {
			//读取床位图配置和数据
			if(result['flag'] == "true" || result['flag'] == true){
				//滚动字幕不换行
				var marquee = scrollArea.querySelector('marquee')
				var jieqi = marquee.getAttribute('data-jieqi');
				marquee.innerHTML = scrollInput.value.replace(/\n/g,'').replace(/\r/g,'')+jieqi;
				if(marquee.innerText == '' && jieqi ==""){
					marquee.innerText = '暂无滚动文字！';
				}
				iziToast.success({
				    title: '字幕保存成功！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
			}else{
				iziToast.error({
				    title: '字幕保存失败！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
			}
		}, function(errorStr) {
			iziToast.error({
			    title: errorStr,
				position: 'center',
			    timeout: 800,
				transitionOut: 'flipOutX'
			});
			//读取床位图配置和数据
		});
	}
	
	//关闭新医嘱查询时 关闭弹框switch
	function setPopoverSwicthToggle(){
		if(this.id === 'newOrder' && event.detail.isActive == false){
			var msgWindow = document.getElementById("msgWindow");
			if(msgWindow.classList.contains('mui-active')){
				$("#msgWindow").switch().toggle();
			}
		}
		if(this.id === 'msgWindow' && event.detail.isActive == true){
			var newOrder = document.getElementById("newOrder");
			if(!newOrder.classList.contains('mui-active')){
				$("#newOrder").switch().toggle();
			}
		}
	}
	//全屏
	function requestFullScreen() {
	    var de = document.documentElement;
	    if (de.requestFullscreen) {
	        de.requestFullscreen();
	    } else if (de.mozRequestFullScreen) {
	        de.mozRequestFullScreen();
	    } else if (de.webkitRequestFullScreen) {
	        de.webkitRequestFullScreen();
	    }
	}
	//退出全屏
	function exitFullscreen() {
	    var de = document;
	    if (de.exitFullscreen) {
	        de.exitFullscreen();
	    } else if (de.mozCancelFullScreen) {
	        de.mozCancelFullScreen();
	    } else if (de.webkitCancelFullScreen) {
	        de.webkitCancelFullScreen();
	    }
	}
	
	function showOrHideDHCpopover(popoverId,type){
		var popover = document.getElementById(popoverId);
		var dhcBackdrop = document.getElementById('dhcBackdrop');
		if (type == "show") {
			if (popover) {
				popover.classList.add('mui-active')
			}
			dhcBackdrop.classList.add('dhc-active')
		}else{
			if (popover) {
				popover.classList.remove('mui-active')
			}
			dhcBackdrop.classList.remove('dhc-active')
			var liuyanInput = document.getElementById('liuyanInput')
			liuyanInput.blur();
			var docInput = document.getElementById('docInput')
			docInput.blur();
		}
	}
	window.addEventListener('message', function(event) {
		var msgDcit = event.data
		var content = msgDcit['content']
		if (!content) {
			return
		}
		var toast = document.querySelector('.newValue');
		if (toast) {
		    iziToast.hide({
		        transitionOut: 'fadeOutUp'
		    }, toast);
		}
		iziToast.warning({
			class: 'newValue',
		    title: '危急值',
			message: msgDcit['content'] + '条',
			position: 'bottomRight',
		    timeout: 10000,
			transitionOut: 'flipOutX'
		});
		if(voice&&audio){
			audio.setAttribute('muted',false);
			audio.play();
		}
	}, false);
	function updateVersion(isPm12) {
		if(!ISMOBILE){
			iziToast.info({
			    title: '已经是最新版本',
				position: 'center',
			    timeout: 1000,
				transitionOut: 'flipOutX'
			});
			return
		}
		var xmlStr = {};
		$.DHCWebService('GetPadVersion', xmlStr, function(result) {
			if(result){
				if(compare(result.AppVersion+"",document.getElementById('version').innerText)){
					if(isPm12){ //夜间检测到新版本
						if (result.AppForce != undefined && result.AppForce+'' == '1') {
							downLoadAPK(result.AppUrl,result.AppVersion);
							return;
						}
						return 
					}
					var btnArray = ['不了', '立即更新'];
					var title = result.AppTitle
					if(!title || title == ''){
						title = '检测到新版本'
					}
					mui.confirm(result.AppNote, title, btnArray, function(e) {
						if (e.index == 1) {
							//var url = "https://114.242.246.235:1443/imedical/web/scripts/nurse/NurWB/nurtv.apk";
							downLoadAPK(result.AppUrl,result.AppVersion);
						}
					})
				}else if(!isPm12){
					mui.toast('已经是最新版本');
				}
			}
		}, function(errorStr) {
			
		});
	}
	
	function compare(curV,reqV){
	   if(curV && reqV){
	      //将两个版本号拆成数字
	      var arr1 = curV.split('.'),
	          arr2 = reqV.split('.');
	      var minLength=Math.min(arr1.length,arr2.length),
	          position=0,
	          diff=0;
	      //依次比较版本号每一位大小，当对比得出结果后跳出循环（后文有简单介绍）
	      while(position<minLength && ((diff=parseInt(arr1[position])-parseInt(arr2[position]))==0)){
	          position++;
	      }
	      diff=(diff!=0)?diff:(arr1.length-arr2.length);
	      //若curV大于reqV，则返回true
	      return diff>0;
	   }else{
	      //输入为空
	      //console.log("版本号不能为空");
	      return false;
	   }
	}
	
	function updateMergeWardUI(wardArr){
		var wardScroll = document.getElementById('wardScroll')
		wardScroll.style.width = 'auto'
		var wardJson = localStorage['originWard']
		if (!wardJson || wardJson == "" || JSON.parse(wardJson).length == 0) {
			wardArr = [{'wardId':wardID,'locId':locID,'wardDesc':locDesc}]
		}else{
			wardArr = JSON.parse(wardJson)
		}
		var html = ''
		for (var i = 0; i < wardArr.length;i++) {
			var oneWard = wardArr[i];
			var wardDesc = oneWard['wardDesc']?oneWard['wardDesc']:'未登录'
			html += '<div data-locId="'+oneWard['locId']+'" data-wardId="'+oneWard['wardId']+'" class="mui-control-item">'+wardDesc+'</div>'
			if (i != wardArr.length - 1) {
				html += '<div class="controlItemSp"></div>'
			}
		}
		document.getElementById('wardScroll').innerHTML = html;
		var item = document.querySelector('.ward .mui-control-item')
		if (item) {
			item.classList.add('mui-active');
			indexOption.wardId = wardArr[0]['wardId'];
			indexOption.locId = wardArr[0]['locId'];
		}
		var items = document.querySelectorAll('.ward .mui-control-item')
		for (var i = 0; i < items.length;i++) {
			items[i].addEventListener(tapType,wardItemTapped,false)
		}
		if (wardScroll.clientWidth < document.getElementById('wardSeg').clientWidth) {
			wardScroll.style.width = '100%'
		}
	}
	
	function wardItemTapped(){
		locId = this.getAttribute('data-locId');
		wardId = this.getAttribute('data-wardId');
		if (indexOption.wardId == wardId) {
			return;
		}
		indexOption.wardId = wardId;
		indexOption.locId = locId;
		//留言板,值班医生,周计划,新医嘱刷新-----滚动字幕共用
		var topSlider = document.getElementById("topSegControl");
		var activeSeg = topSlider.querySelector('.mui-active');
		if(activeSeg.getAttribute('href')==='#item1mobile'){
			resetGetNewsRefresh()
		}else{
			getWeekPlan()
		}
		var bottomSlider = document.getElementById("botSegControl");
		var activeSeg = bottomSlider.querySelector('.mui-active');
		if(activeSeg.getAttribute('href')==='#item1'){
			getlyb()
		}else{
			getDoc()
		}
		
		var iframeContainer = document.getElementById("container");
		var activeTabbar = iframeContainer.querySelector('.mui-active');
		var newDict = copyIndexOptions()
		newDict.refresh = true;
		newDict.refreshType = 'ward';
		switch (activeTabbar.id) {
			case 'tab1':
				setupIframePostMessage('BedMap', newDict); //床位图
				break;
			case 'tab2':
				setupIframePostMessage('ResponsibileTask', newDict); //责组任务
				break;
			case 'tab3':
				setupIframePostMessage('ShiftWork', newDict); //护理交班
				break;
			case 'tab4':
				setupIframePostMessage('OperationPlan', newDict); //术检排程
				break;
			case 'tab6':
				setupIframePostMessage('NurSchedule', newDict); //护理排班
				break;
			case 'tab7':
				setupIframePostMessage('CriticalValue', newDict); //危急值
				break;
		}
	}
	
	function windowAddMouseWheel() {
		var slider = document.getElementById('sliderGroup');
		var scrollFunc = function(e) {
			var domId = '';
			e = e || window.event;
			
			var target = e.target;
			var tagName = target.tagName;
			while(tagName != "BODY" && tagName != "HTML"){
				var id = target.id;
				switch (id){
					case 'scroll1':
					case 'scroll2':
					case 'scroll3':
					case 'wrapper1':
					case 'wrapper2':
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
			mouseWheelScroll(domId, e)
		};
		//滚动滑轮触发scrollFunc方法
		window.onmousewheel = scrollFunc;
	}
	function isSelfDefineTextChange(inputValue,divSelector){
		var divDom = document.querySelector(divSelector);
		var divText = divDom.getAttribute('data-origin');
		var inputText = inputValue;
		if (divSelector.indexOf('marquee') != -1) {//滚动字幕 不换行
			divText = divText.replace(/\n/g,'').replace(/\r/g,'');
			inputText = inputValue.replace(/\n/g,'').replace(/\r/g,'');
		}else{
			divText = divText.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
			inputText = inputValue.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
		}
		return divText != inputText
	}
	
	function setupTabbars(){
		$.DHCRequestJson('tabbar.json',function(result){
			if (result == "" || result.indexOf('[{') == -1) {
				return;
			}
			try{
				var arr = eval('('+result+')');
				if (arr.length == 0) {
					return;
				}
				var html = ''
				for (var i = 0; i < arr.length; i++) {
					var oneDict = arr[i]
					var show = oneDict['show']
					if (show == '0') {
						var dom = $(oneDict['href'])[0]
						if (dom) {
							$('#container')[0].removeChild(dom)
						}
						continue;
					}
					html +='<div id="'+oneDict['id']+'" class="mui-tab-item" href="'+oneDict['href']+'" '+
						+'data-l="'+oneDict['left']+'" data-r="'+oneDict['right']+'">'+
						'<div class="tabContent"><span class="mui-icon iconfont '+oneDict['icon']+'"></span>'+
						'<span class="mui-tab-label">'+oneDict['name']+'</span></div></div>'
				}
				mui('#tabbar').off(tapType,'.mui-tab-item',tabbarTapped)
				$('#tabbar')[0].innerHTML = html
				var firstDom = $('#tabbar')[0].querySelector('.mui-tab-item')
				firstDom.classList.add('mui-active')
				var href = firstDom.getAttribute('href')
				var oldActive = $('#container iframeBox.mui-active')[0]
				if (oldActive && ('#'+oldActive.id) != href) {
					oldActive.classList.remove('mui-active')
				}
				$(href)[0].classList.add('mui-active');
				currTabId = href;
				mui('#tabbar').on(tapType,'.mui-tab-item',tabbarTapped)
			}catch(e){
			}
		},function(errorStr){
			
		});
	}
	
	function Get24JieQi(){
		var jieqi =  $('#jieqi')[0]
		if (!jieqi) {
			return
		}
		var xmlStr = {};
		//(12rem + 135px) + scrollWidth+jieqiWidth + WardWidth + 50px
		
		$.DHCWebService('Get24JieQi', xmlStr, function(result) {
			var wardDom = $('#wardSeg')[0]
			var scrollDom = $('#scrollArea')[0]
			var str = (result['data']==undefined?'':result['data'])
			jieqi.innerHTML = str
			if (str == "" || result['textWidth']=="" || !result['textWidth']){
				wardDom.removeAttribute('style')
				scrollDom.removeAttribute('style')
				jieqi.removeAttribute('style')
			}else{
				// wardDom.style.width = 'calc('+result.wardWidth+'% - 4rem - 62px)'
				// scrollDom.style.width = 'calc('+result.textWidth+'% - 4rem - 62px)'
				// jieqi.style.width = 'calc('+result.jqWdith+'% - 4rem - 62px)'
				// jieqi.style.left = 'calc('+result.textWidth+'% + 8rem - 73px)'
				wardDom.style.width = result.wardWidth+'%'
				scrollDom.style.width = result.textWidth+'%'
				jieqi.style.width = result.jqWdith+'%'
			}
		}, function(errorStr) {
			jieqi.innerHTML=""
		})
	}
	
	var exportObj = {}
	exportObj.pm12Refresh = function(){
		Get24JieQi()
		refreshBtnTapped();
		if(ISMOBILE){
			updateVersion(true);
		}
	};
	exportObj.perHourRefresh = function(){ //每小时更新,不包含夜间12点刷新
		//目前只更新护理任务
		var iframeContainer = document.getElementById("container");
		var activeTabbar = iframeContainer.querySelector('.mui-active');
		if (activeTabbar.id == 'tab2') { //只有当前是护理任务,才发刷新的消息
			indexOption.refresh = true;
			setupIframePostMessage('ResponsibileTask', indexOption); //责组任务
			indexOption.refresh = false;
		}
	};
	exportObj.commitSettings = commitSettings
	return exportObj
})(mui);

function pm12Refresh(dayStr){
	indexObj.pm12Refresh(dayStr);
}
function perHourRefresh(dayStr){
	indexObj.perHourRefresh(dayStr);
}
function changeDayNighMode(type){
	var nightModeDom = document.getElementById('nightMode');
	if (type == "add") {
		nightModeDom.classList.add('mui-active');
	}else{
		nightModeDom.classList.remove('mui-active');
	}
	indexObj.commitSettings();
}

function eventHandler(eventResult) {
	var activePopover = document.querySelector('.mui-popover.mui-active');
	if (activePopover) {
		return;
	}
	var activeDom = document.querySelector('.mui-tab-item.mui-active')
	if (!activeDom) {
		activeDom = document.getElementById("tabbar1");
	}
	var leftId = activeDom.getAttribute('data-l')?activeDom.getAttribute('data-l'):""
	var rightId = activeDom.getAttribute('data-r')?activeDom.getAttribute('data-r'):""
	var upId =  activeDom.getAttribute('data-u')?activeDom.getAttribute('data-u'):""
	var downId = activeDom.getAttribute('data-d')?activeDom.getAttribute('data-d'):""
	var newDomId=""
	switch(eventResult.code) {
		//确定键拦截,case要与keyevent.util.js里面的case code一样
		case "KEY_SELECT":
			newDomId = activeDom.id
			break;
		case "KEY_RIGHT": //右
			newDomId = rightId
			break;
		case "KEY_LEFT": //左
			newDomId = leftId
			break;
		case "KEY_DOWN": //下
			newDomId = downId
			break;
		case "KEY_UP": //上
			newDomId = upId
			break;
		case "KET_PRE": //上一页 
			newDomId = ""
			break;
		case "KET_NEXT": //下一页  
			newDomId = ""
			break;
		case "KET_BACK": //返回键 
			newDomId = ""
			break;
		case "KEY_QUIT": //退出
			newDomId = ""
			break;
	}
	if (newDomId == "" || !document.getElementById(newDomId)) {
		return
	}
	var newDom = document.getElementById(newDomId)
	if (newDomId == "switch") {
		mui.trigger(newDom,tapType);
		return
	}else if (activeDom.id == "switch" && eventResult.code == "KEY_LEFT") {
		mui.trigger(activeDom,tapType);
		return
	}
	var oldFrame = activeDom.getAttribute('href')
	document.querySelector(oldFrame).classList.remove('mui-active');
	activeDom.classList.remove('mui-active');
	
	var newFrame = newDom.getAttribute('href')
	newDom.classList.add('mui-active');
	document.querySelector(newFrame).classList.add('mui-active');

	mui.trigger(newDom,tapType);
}

/*
 * 新医嘱分页查询, 定时刷新,刷新按钮,侧边栏页签切换
 * 1.开启定时刷新: 2分钟刷新一次
 * 2.触发上拉加载:关闭定时刷新,上拉结束,重新开启定时刷新
 * 3.刷新按钮/切换标签:重置上拉,滚动到页面,定时器重置
 * 4.修改设置,从关闭到开启,
 * 
 * 重置上拉加载更多
 * 1.切换页签;2.保存设置;3.刷新按钮;4.定时刷新;5.本身
 * 
 * 重置定时器
 * 1.刷新按钮点击且新医嘱查询开关打开
 * 2.页签切换
 * 3.保存设置
 * 4.上拉加载更多
 * 
 * 设置
 * 新医嘱查询与浮窗提示的关系
 * 1.关闭新医嘱查询:关闭定时器,关闭浮窗
 * 2.新医嘱查询打开状态,浮窗提示可以关闭
*/