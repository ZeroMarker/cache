(function($) {
	var wardID = localStorage['wardId'];
	var datePicker;
	var startDate = '',endDate = '';
	$.init({});
	$('.mui-scroll-wrapper').scroll({
		bounce: true,
		indicators: true, //是否显示滚动条
	});
	baseSetup();
	function getServerTime(block){
		mui.DHCWebService('GetServerTime', {}, function(result) {
			var serverDay = result['data'].substring(0,10);
			localStorage['todayStr'] = serverDay;
			block();
		}, function(errorStr) {
			localStorage.removeItem('todayStr')
			block();
		});
	}
	
	function getNurWeekSchedual(start,end){
		var xmlStr = {
		 	'WardID':wardID,
		 	'StartDate':start,
			'EndDate':end
		 };
		$.DHCWebService('GetManageShift',xmlStr,function(result){
			hideToast('.refresh');
			if(result.length == 0){
				showNULLByElementId('schNull','当前无排班');
			}else{
				hiddenNULLByElementId('schNull');
			}
			var weekDaysArr = getFullWeek(start);
			updateUI(result,weekDaysArr);
		},function(errorStr){
			hideToast()
			var tbody = document.getElementById('tbody');
			tbody.innerHTML = '';
			showNULLByElementId('schNull','查询排班' + errorStr, 'error');
		});
	}
	function updateUI(schData,weekDaysArr) {
		var html = '';
		var tbody = document.getElementById('tbody');
		if(schData.length == 0){
			tbody.innerHTML = html;
			return;
		}
		for(var i = 0; i < schData.length; i++) {
			var dict = schData[i];
			var name = dict['PerName'];
			var level = dict['LevelDesc'];
			var weekMark = dict['ArgWorkRemark']==undefined?'':dict['ArgWorkRemark']
			var oneSchDom = '';
			html += '<tr><td class="order">' + (i + 1) + '</td><td>' + name + '</td><td>' + level + '</td>'
			for(var j = 0; j < weekDaysArr.length; j++) {
				var schStr = dict['Date' + weekDaysArr[j]['day']];
				if (!schStr) {
					schStr = ""
				}
				var schArr= new Array();
				var schArr = schStr.split("「");// 在每个逗号(「)处进行分解。
				var schSpan = '';
				for (k=0;k<schArr.length;k++){
					// console.log(schArr[k]); //分割后的单个排班字符输出
					var oneSch = schArr[k].split("」");
					schStr = oneSch[0];
					textColor = oneSch[1];
					bgColor = oneSch[2];
					if(textColor){
						textStr = 'color:' + textColor + ';';
					}else{
						textStr = '';
					}
					if(bgColor){
						bgStr = 'background:' + bgColor + ';';
					}else{
						bgStr = '';
					}
					schSpan += '<span class="schUnit" style="' + textStr + bgStr +'">' + schStr + '</span>';
				}
				var colorStr = '';
				html += '<td class="' + colorStr;
				if(j > 4) {
					html += 'weekend'
				}
				html += '">' + schSpan + '</td>';
			}
			html += '<td class="weekMark">'+weekMark+'</td></tr>';
		}
		tbody.innerHTML = html;
		html = ''
	}
	function baseSetup(){
		if (mui.os.plus) {
			var muiContent = document.querySelector('.mui-content');
			muiContent.classList.add('osPlus')
		}
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		mui.DHCRequestXMl(function(result) {
			getServerTime(function(){
				datePicker = new dhcTVDatePicker({
					'tapBtnId':'yearMonth',
					'startDate':startDate,
					'endDate':endDate
				},function(startStr,endStr,chinaYM){
					startDate = startStr;
					endDate = endStr;
					updateHeadDateUI(chinaYM);
				});
			});
		},function(err){
		})
		
		var yearMonth = document.getElementById('yearMonth');
		yearMonth.addEventListener(tapType,function(){
			datePicker.updatePickerPos('yearMonth');
			if (!datePicker.isShow) {
				datePicker.pickerShow(startDate,endDate);
			}else{
				datePicker.pickerHide();
			}
		});
		var lastWeek = document.getElementById('lastWeek');
		lastWeek.addEventListener(tapType,lastWeekBtnTapped,false);
		var NextWeek = document.getElementById('NextWeek');
		NextWeek.addEventListener(tapType,nextWeekBtnTapped,false);
	}
	function lastWeekBtnTapped(){
		var oneDay = startDate;
		for (var i = 0; i < 7;i++) {
			oneDay = getLastDay(oneDay);
			if (i == 0) {//结束日期
				endDate = oneDay;
			}else if (i == 6) {//开始日期
				startDate = oneDay
			}
		}
		updateHeadDateUI();
	}
	function nextWeekBtnTapped(){
		var oneDay = endDate;
		for (var i = 0; i < 7;i++) {
			oneDay = getNextDay(oneDay);
			if (i == 0) {//结束日期
				startDate = oneDay;
			}else if (i == 6) {//开始日期
				endDate = oneDay
			}
		}
		updateHeadDateUI();
	}
	function updateHeadDateUI(chinaYM){
		if (!chinaYM) {
			var ym = endDate.substr(0,7);
			chinaYM = ym.replace('-','年')+'月';
		}
		var yearMonth = document.getElementById('yearMonth');
		yearMonth.innerHTML = chinaYM;
		var startMD = document.getElementById('startMD');
		var str = startDate.substring(5,startDate.length);
		startMD.innerText = str.replace('-','月')+'日';
		var endMD = document.getElementById('endMD');
		str = endDate.substring(5,endDate.length);
		endMD.innerText = str.replace('-','月')+'日';
		var arr = getFullWeek(startDate);
		var headTr = document.getElementById('head');
		var trHtml = '<th class="order">序号</th><th>护士</th><th>层级</th>'; 
		for (var i = 0; i < arr.length;i++) {
			var day = arr[i]['day'];
			trHtml += '<th>'+day.substring(5,day.length)+' '+arr[i]['week']+'</th>'
		}
		trHtml += '<th class="weekMark">备注说明</th>'
		headTr.innerHTML = trHtml;
		getNurWeekSchedual(startDate,endDate);
	}
	window.addEventListener('message',function(e){
		if (e.data.wardId != wardID && e.data.refreshType == 'ward') {//切换病区
			wardID = e.data.wardId;
			var toast = document.querySelector('.refresh');
			if (!toast) {
				iziToast.show({
					class: 'refresh',
					color: 'dark',
					title: '正在刷新排班',
					image: '../common/images/load.gif',
					position: 'center',
					timeout: null,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
			}
			getNurWeekSchedual(startDate,endDate);
			mui('#tableWrapper').scroll().scrollTo(0,0,100);
			return
		}
		wardID = e.data.wardId;
		var dayStr = e.data.dayStr;
		if (dayStr != undefined && dayStr != '') {
			var arr = getWeekStartEndDate(dayStr)
			startDate = arr[0];
			endDate = arr[1];
			updateHeadDateUI()
		}
		changeDayNightMode(e.data.nightMode);
		if (e.data.refresh) {
			resetRefresh();
		}else if(e.data.isActive){
			resetRefresh('notoast');
		}
	},false);
	function resetRefresh(auto) {
		var toast = document.querySelector('.refresh');
		if (toast) {
		    return;
		}
		if(!auto){
			iziToast.show({
				class: 'refresh',
				color: 'dark',
				title: '正在刷新排班',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});	
		}
		if(startDate&&endDate){
			getNurWeekSchedual(startDate,endDate);
		}else{
			setTimeout(function() {
			    getNurWeekSchedual(startDate,endDate);
			}, 500);	
		}
	}
	function changeDayNightMode(mode){
		if(mode){
			document.body.classList.add('nightMode');
		}else{
			document.body.classList.remove('nightMode');
		}
	}
	function hideToast(str){
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
	    var scrollFunc = function (e) {
			var domId = '';
			e = e || window.event;
			
			var target = e.target;
			var tagName = target.tagName;
			while(tagName != "BODY" && tagName != "HTML"){
				if (target.id == 'tableWrapper') {
					domId = 'tableWrapper'
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
})(mui);
