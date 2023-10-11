var clockObj = (function($) {
	var apiMoment_d;
	var tempMoment_d;
	var timeStr;
//	var timeIndex = -1;//时间校准测试
//	var timeArr = ['2020-11-20 23:59:50','2020-11-20 23:59:55','2020-11-21 00:00:10'];//时间校准测试
	mui.DHCRequestXMl(function(result) {
		getServerTime();
	},function(err){})
	
	
	// Cache some selectors

	var clock = $('#clock'),
		date = clock.find('.date');		
		week = clock.find('.week');	
	// This will hold the number of seconds left
	// until the alarm should go off

	// Map digits to their names (this will be an array)
	var digit_to_name = 'zero one two three four five six seven eight nine'.split(' ');
	var name_to_digit = {"zero":0,"one":1,"two":2,"three":3,"four":4,"five":5,"six":6,"seven":7,"eight":8,"nine":9};

	// This object will hold the digit elements
	var digits = {};

	// Positions for the hours, minutes, and seconds
	// var positions = [
	// 	'h1', 'h2', ':', 'm1', 'm2', ':', "s1", "s2"
	// 	]
	var positions = [
		'h1', 'h2', ':', 'm1', 'm2'
		]

	// Generate the digits with the needed markup,
	// and add them to the clock

	var digit_holder = clock.find('.digits');

	$.each(positions, function(){

		if(this == ':'){
			digit_holder.append('<div class="dots">');
		}
		else{

			var pos = $('<div>');

			for(var i=1; i<8; i++){
				pos.append('<span class="d' + i + '">');
			}

			// Set the digits as key:value pairs in the digits object
			digits[this] = pos;

			// Add the digit elements to the page
			digit_holder.append(pos);
		}

	});
	// request scervertime
	function getServerTime(localTime){
//			timeIndex += 1;//时间校准测试
			var xmlStr = {};
			mui.DHCWebService('GetServerTime', xmlStr, function(result) {
				if(result['data']){
					timeStr = result['data'];
					//timeStr = '2020-11-20 23:59:50';//假数据
//					timeStr = timeArr[timeIndex];//时间校准测试
					timeStr = timeStr.substring(0,19);
					var serverDay = timeStr.substring(0,10);
					var serverHour = timeStr.substring(11,13)
					localStorage['todayStr'] = serverDay;
					localStorage['hourStr'] = serverHour
					if (localTime == '00:00:00') { //夜间12点服务器校准
						var dayStr = document.querySelector('.date').innerText
						if (dayStr <= serverDay) {//白板计算时间比服务器慢或相等
							refreshActivePage();
						}
					}else if (localTime == '00:00') { //每小时校准
						var hourStr = ''+name_to_digit[digits.h1.attr('class')]+name_to_digit[digits.h2.attr('class')]
						if (hourStr <= serverHour) {
							refreshResponsTaskPage(serverHour)
						}
					}
					timeStr = timeStr.replace(/-/g,'/'); //必须把日期'-'转为'/'
					var timestamp = new Date(timeStr).getTime();
					apiMoment_d = new Date(timestamp);
					update_time();
				}else{
					iziToast.error({
						class: 'serverTime',
						title: '获取服务器时间失败',
						position: 'center',
						timeout: 2000,
						close: true
					});
					update_time();
					if (localTime == '00:00:00') {
						refreshActivePage();
					}else if (localTime == '00:00') {
						refreshResponsTaskPage()
					}
				}
			}, function(errorStr) {
				iziToast.error({
					class: 'serverTime',
					title: '获取服务器时间失败！',
					position: 'center',
					timeout: 2000,
					close: true
				});
				update_time();
				if (localTime != undefined) {
					refreshActivePage();
				}else if (localTime == '00:00') {
					refreshResponsTaskPage()
				}
			});
		}
	
	// Run a timer every second and update the clock

	function update_time(){

		// Use moment.js to output the current time as a string
		// hh is for the hours in 12-hour format,
		// mm - minutes, ss-seconds (all with leading zeroes),
		// d is for day of week and A is for AM/PM
		var newM = this.moment();
		var now;
		if(!tempMoment_d && apiMoment_d){
			newM._d = apiMoment_d;
			now = newM.add(1, 'second').format('YYYYMMDDHHmmss');
			tempMoment_d = now._d;
		}else if(apiMoment_d && tempMoment_d){
			newM._d = tempMoment_d;
			now = newM.add(1, 'second').format('YYYYMMDDHHmmss');
			tempMoment_d = now._d;
		}
		if(!tempMoment_d && !apiMoment_d){
			now = newM.format('YYYYMMDDHHmmss');
		}
		
		// console.log(nowTime);
		// var now = moment().format("HHmmss");
		
		digits.h1.attr('class', digit_to_name[now[8]]);
		digits.h2.attr('class', digit_to_name[now[9]]);
		digits.m1.attr('class', digit_to_name[now[10]]);
		digits.m2.attr('class', digit_to_name[now[11]]);
		// digits.s1.attr('class', digit_to_name[now[12]]);
		// digits.s2.attr('class', digit_to_name[now[13]]);
		// The library returns Sunday as the first day of the week.
		// Stupid, I know. Lets shift all the days one position down, 
		// and make Sunday last
		
		var dow = now[4];
		dow--;
		
		// Sunday!
		if(dow < 0){
			// Make it last
			dow = 4;
		}
		var monthDate = newM.format("YYYY-MM-DD");
		date.text(monthDate);
		var weekStr = newM.format('dddd');
		if(weekStr == 'Monday'){
			weekStr = '星期一';
		}else if(weekStr == 'Tuesday'){
			weekStr = '星期二';
		}else if(weekStr == 'Wednesday'){
			weekStr = '星期三';
		}else if(weekStr == 'Thursday'){
			weekStr = '星期四';
		}else if(weekStr == 'Friday'){
			weekStr = '星期五';
		}else if(weekStr == 'Saturday'){
			weekStr = '星期六';
		}else if(weekStr == 'Sunday'){
			weekStr = '星期日';
		}
		week.text(weekStr);
		// Mark the active day of the week

		var dyArr = (localStorage['dayNightChange']==undefined?"":localStorage['dayNightChange']).split('^');// = "07:00^19:00^0"
		var dayHM = dyArr[0]
		var nightHM = dyArr[1]==undefined?"":dyArr[1]
		var dyOPen = dyArr[2]==undefined?"0":dyArr[2]
		if (dayHM!="" && nightHM!=""&&dyOPen=='1'&&(''+now[12]+now[13]=="00")) {
			var hourMinute = ''+now[8]+now[9]+':'+now[10]+now[11]
			if(hourMinute == dayHM){ //转换为日间的时间点
				if ( localStorage['nightMode'] == "true") {
					changeDayNighMode('remove');
				}
			}else if(hourMinute == nightHM){ //转换为夜间的时间点
				if (localStorage['nightMode'] != "true") {
					changeDayNighMode('add');
				}
			}
		}


		// Schedule this function to be run again in 1 sec
		
		var nowStr = ''+now[8]+now[9]+':'+now[10]+now[11]+':'+now[12]+now[13]
		var minSec = ''+now[10]+now[11]+':'+now[12]+now[13]
		if (nowStr == '00:00:00') {
			getServerTime('00:00:00'); //夜间12点整体刷新
			return;
		}else if (minSec == '00:00') {  //每小时进行时间校准
			getServerTime('00:00');
			return;
		}
		setTimeout(update_time, 1000);
	};

	// Switch the theme

	$('#switch-theme').click(function(){
		clock.toggleClass('light dark');
	});
	function refreshActivePage(){
		// console.log('refreshActivePage')
		var dayStr = document.querySelector('.date').innerText
		pm12Refresh(dayStr)
	}
	function refreshResponsTaskPage(serverHour){
		// console.log('refreshResponsTaskPage')
		if (serverHour == undefined) {
			serverHour = ''+name_to_digit[digits.h1.attr('class')]+name_to_digit[digits.h2.attr('class')]
		}
		localStorage['hourStr'] = serverHour
		perHourRefresh(serverHour)
	}
	
	function getNowTimeStr(){
		var hmStr = ''+name_to_digit[digits.h1.attr('class')]+name_to_digit[digits.h2.attr('class')]+':'+
			name_to_digit[digits.m1.attr('class')]+name_to_digit[digits.m2.attr('class')]
		return hmStr
	}
	
	var exportObj = {}
	exportObj.getNowTimeStr = getNowTimeStr
	return exportObj
})(jQuery);

function getNowTimeStr(){
	return clockObj.getNowTimeStr()
}

