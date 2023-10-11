(function($) {
	var cTimer;
	var locId = localStorage['locId'];
	var wardId = localStorage['wardId'];
	var userId = localStorage['userId'];
	var groupId = localStorage['groupId'];
	$.init({});
	$('.mui-scroll-wrapper').scroll({
		bounce: true,
		indicators: true, //是否显示滚动条
	});
	baseSetup();
	function getCriticalValueData(){
		var xmlStr = {'LocId':locId,'WardID':wardId,'UserId':userId,'GroupId':groupId,'ReadFlag':"N","ActionType":"1000"};//,"StartDate":"","EndDate":""
		$.DHCWebService('GetCriticalValue',xmlStr,function(result){
			hideToast('.refresh');
			if (cTimer) {
				clearInterval(cTimer);
				cTimer = undefined;
			}
			timeIntervalSetup();
			updateUI(result);
		},function(errorStr){
			hideToast('.refresh');
			var tbody = document.getElementById('tbody');
			tbody.innerHTML = '';
			showNULLByElementId('criticalNull','查询危急值' + errorStr, 'error');
		});
	}
	function updateUI(dataArr) {
		var tbody = document.getElementById('tbody');
		if (dataArr && dataArr.length > 0) {
			hiddenNULLByElementId('criticalNull');
		}else{
			showNULLByElementId('criticalNull','当前无危急值');
			tbody.innerHTML = '';
			return
		}
		var html = '';
		for (var i= 0; i < dataArr.length;i++) {
			var oneDict = dataArr[i];
			var SendDate = oneDict['SendDate']+""
			var last4 = SendDate.substring(SendDate.length-4,SendDate.length);
			if (SendDate.indexOf("-") == -1 && last4.indexOf("/") == -1) {//日期格式day/month/year
				SendDate = SendDate.replace(/\//g, '').replace(/^(\d{2})(\d{2})(\d{4})$/,"$3-$2-$1")
			}
			var sendTime = SendDate +' '+oneDict['SendTime']
			var bed = oneDict['BedNo']!=undefined?oneDict['BedNo']:'';
			var patName = oneDict['PatName']!=undefined?oneDict['PatName']:'';
			
			html += '<tr><td class="order">'+(i+1)+'</td><td class="bedCode">'+bed+'</td>'+
				'<td class="patName" data-patName="'+patName+'">'+dealNamePrivate(patName)+'</td>'+
				'<td class="diag">'+oneDict['diagnose']+'</td>'+'<td class="content">'+oneDict['Content']+'</td>'+
				'<td class="sender">'+oneDict['SendUserDesc']+'</td>'+'<td class="sendTime">'+sendTime+'</td></tr>';			
		}
		tbody.innerHTML = html;
		$('#tableWrapper').scroll().scrollTo(0,0,100);
		resetTdWidth();
		top.postMessage({"origin":'criticalValue',content:dataArr.length}, '*');
	}
	function baseSetup(){
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		mui.DHCRequestXMl(function(result) {
			timeIntervalSetup();
			getCriticalValueData();
		},function(err){
		})
		
		return;
		mui('#status-area .status-btn').each(function() {
			this.addEventListener('tap', function() {
				var oldActive = document.querySelector('#status-area .dhc-active')
				if (oldActive) {
					oldActive.classList.remove('dhc-active');
				}
				this.classList.add('dhc-active');
				getCriticalValueData();
			}, false);
		});
	}
	
	function getStatusId(){
		var activeDom = document.querySelector('#status-area .dhc-active');
		if (activeDom && activeDom.getAttribute('data-id')) {
			return activeDom.getAttribute('data-id');
		}
		return ''
	}
	
	window.addEventListener('message',function(e){
		/*if (e.data.wardId != wardId && e.data.refreshType == 'ward') {//切换病区
			wardId = e.data.wardId
			locId = e.data.locId
			var toast = document.querySelector('.refresh');
			if (!toast) {
				iziToast.show({
					class: 'refresh',
					title: '正在刷新',
					image: '../common/images/load.gif',
					position: 'center',
					timeout: null,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
			}
			getCriticalValueData();
			mui('#tableWrapper').scroll().scrollTo(0,0,100);
			return
		}
		wardId = e.data.wardId
		locId = e.data.locId*/
		changeDayNightMode(e.data.nightMode);
		if (e.data.refresh) {
			resetRefresh();
		} else if (e.data.namePrivate) {
			mui('#tbody .patName').each(function (index,element) {
				element.innerHTML = dealNamePrivate(element.getAttribute('data-patName'))
			})
		} else if (e.data.isActive != undefined && e.data.isActive == false) {
			// if (cTimer) {
			// 	clearInterval(cTimer);
			// 	cTimer = undefined;
			// }
		} else if (e.data.isActive) {
			getCriticalValueData();
			if (!cTimer) {
				timeIntervalSetup();
			}
		}
	},false);
	function resetRefresh(auto) {
		var toast = document.querySelector('.refresh');
		if (toast) {
			return;
		}
		iziToast.show({
			class: 'refresh',
			title: '正在刷新',
			image: '../common/images/load.gif',
			position: 'center',
			timeout: null,
			color: '#F4C059',
			transitionOut: 'flipOutX',
			close: true
		});
		getCriticalValueData();
	}
	function changeDayNightMode(mode) {
		if (mode) {
			document.body.classList.add('nightMode');
		} else {
			document.body.classList.remove('nightMode');
		}
	}
	
	function timeIntervalSetup() {
		var len = 2 * 60 * 1000; //2分钟
		cTimer = setInterval(function() {
			getCriticalValueData();
		}, len);
	}
	
	function hideToast(str) {
		if (!str) {
			str = '.refresh';
		}
		var toast = document.querySelector(str);
		if (toast) {
			iziToast.hide({
				transitionOut: 'fadeOutUp'
			}, toast);
		}
	}
	windowAddMouseWheel();
	
	function windowAddMouseWheel() {
		var scrollFunc = function(e) {
			var domId = '';
			e = e || window.event;
			var target = e.target;
			var tagName = target.tagName;
			while (tagName != "BODY" && tagName != "HTML") {
				var id = target.id;
				switch (id) {
					case 'tableWrapper':
						domId = id;
						break;
					default:
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
	window.onresize = resetTdWidth;
	
	function resetTdWidth(){
		return
		var tbody = document.getElementById('tbody');
		var tr = tbody.querySelector('tr');
		if (!tr) {
			return;
		}
		var tds = tr.querySelectorAll('td');
		var headTds = document.querySelectorAll('#headTable th');
		for (var i = 0; i < tds.length;i++) {
			// headTds[i].style.width = (tds[i].clientWidth + 0) + 'px';
		}
	}
})(mui);
