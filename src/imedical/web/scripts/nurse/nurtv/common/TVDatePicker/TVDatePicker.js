var pickerSelf = ''
function dhcTVDatePicker(options, block) {
	var self = this;
	pickerSelf = self
	var dateDom = document.querySelector('.tv-date-area')
	if(dateDom) {
		return;
	}
	var btnId = options.tapBtnId;
	var startDate = options.startDate;
	var endDate = options.endDate;
	var dateDom = document.createElement('div');
	document.body.appendChild(dateDom);
	dateDom.setAttribute('class', 'tv-date-area');
	self.isShow = false;
	var absPos = self.getAbsPosition(btnId);
	var popoverWith = 150 * SCALE
	var left = (absPos.centerx - popoverWith) + 'px';
	var top = absPos.top + 'px';
	dateDom.style.left = left;
	dateDom.style.top = top;
	dateDom.innerHTML =
		'<div class="tv-date-header">' +
			'<div id="dhcDate-ly" class="iconfont iconleft-double tv-date-ln"></div>' +
			'<div id="dhcDate-lm" class="iconfont iconleft tv-date-ln"></div>' +
			'<div id="dhcDate-ym" class="tv-date-ym"></div>' +
			'<div id="dhcDate-nm" class="iconfont iconright tv-date-ln"></div>' +
			'<div id="dhcDate-ny" class="iconfont iconright-double tv-date-ln"></div>' +
		'</div>' +
		'<table class="tv-day-table"><thead><tr>' +
			'<td>周日</td><td>周一</td><td>周二</td><td>周三</td>' +
			'<td>周四</td><td>周五</td><td>周六</td></tr></thead>' +
			'<tbody><tr></tr><tr></tr><tr></tr><tr></tr></tbody>' +
		'</table>' +
		'<div class="tv-date-footer">' +
			'<button id="dhcDate-tweek" class="tv-date-thisweek">本周</button>' +
			'<button id="dhcDate-cancel" class="tv-date-cancel">取消</button>' +
			'<button id="dhcDate-sure" class="tv-date-sure">确定</button>' +
		'</div>';
	

	self.areaDom = dateDom;
	if(startDate == '' || endDate == '') {
		self.initDays();
		self.fillDateUI(self.startDate,self.endDate);
		block(self.startDate,self.endDate,self.chinaYM);
	} else {
		self.startDate = startDate;
		self.endDate = endDate;
		self.currentYM = self.endDate.substr(0, 7);
		self.chinaYM = self.currentYM.replace('-', '年') + '月';
		self.fillDateUI(self.startDate,self.endDate);
		var ymDom = document.getElementById('dhcDate-ym'); //当前年月
		ymDom.innerText = self.chinaYM;
	}
	//各个固定按钮点击方法
	self.setupBtnTapped(function(){
		block(self.startDate,self.endDate,self.chinaYM);
	});
}

function dayTdTapped(){
	pickerSelf.TdDomTapped(this)
}

dhcTVDatePicker.prototype.pickerShow = function(startDate, endDate) {
	var self = this;
	self.isShow = true;
	self.areaDom.style.display = 'block';
	if(self.startDate == startDate) {
		return;
	}
	var startDateDom = document.getElementById('tv-date-td-' + startDate);
	if(!startDateDom) {
		mui('.tv-day-table tbody').off(tapType,'td',dayTdTapped) 
		var tbody = self.areaDom.querySelector('tbody');
		tbody.innerHTML = '';
		self.fillDateUI(startDate, endDate, null);
		return;
	}
	var trIndex = parseInt(startDateDom.getAttribute('data-tr'));
	var tdIndex = parseInt(startDateDom.getAttribute('data-td'));
	if(self.rowNum == trIndex + 1 || (tdIndex == 0 && trIndex == 0)) { //需翻月份
		//设置月份后
		self.startDate = startDate;
		self.endDate = endDate;
		if (tdIndex == 0 && trIndex == 0) {
			self.currentYM = startDate.substr(0,7);
			self.pickerChangeYM('lm');
		}else{
			self.currentYM = endDate.substr(0,7);
			self.pickerChangeYM('nm');
		}
		self.chinaYM = self.currentYM.replace('-','年') + '月'		
	}else { //在本月中选择
		 //清除原来选中 
		self.clearSelectedTds();
		//选中当前
		var currTr = document.getElementById('tv-data-tr-' + trIndex);
		var ctds = currTr.querySelectorAll('td');
		for(var i = 1; i < ctds.length; i++) {
			var oneTd = ctds[i];
			oneTd.classList.add('select');
			if(i == 1) {
				oneTd.classList.add('start');
			}
		}
		var nextTr = document.getElementById('tv-data-tr-' + (trIndex + 1));
		var nextTd = nextTr.querySelector('td');
		nextTd.classList.add('select');
		nextTd.classList.add('end');
	}
}

dhcTVDatePicker.prototype.pickerHide = function() {
	var self = this;
	self.isShow = false;
	self.areaDom.style.display = 'none';
}

dhcTVDatePicker.prototype.pickerChangeYM = function(type) {
	var self = this
	var arr = self.currentYM.split('-');
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	if(type == 'ly') { //上年
		year -= 1;
	} else if(type == 'lm') { //上月
		if(month == 1) {
			month = 12;
			year -= 1;
		} else {
			month -= 1;
		}
	} else if(type == 'ny') { //下年
		year += 1;
	} else if(type == 'nm') { //下月
		if(month == 12) {
			month = 1;
			year += 1;
		} else {
			month += 1;
		}
	}
	var dayStr = self.outYMDStr(year,month,1);
	self.getFullWeek(dayStr);
	self.fillDateUI(self.startDate,self.endDate);
}

dhcTVDatePicker.prototype.fillDateUI = function(startDate, endDate) {
	mui('.tv-day-table tbody').off(tapType,'td',dayTdTapped) 
	var self = this;
	var arr = endDate.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	var maxDay = self.getMonthMaxDay(year, month);
	var lastMaxDay = self.getLastMonthMaxDay(year, month);
	var startIndex = self.getWeekIndex(endDate.substring(0,7) + '-01');
	var endIndex = self.getWeekIndex(endDate.substring(0,7) + '-' + maxDay);
	var count = startIndex + maxDay + (6 - endIndex);
	if (startIndex == 0) {
		count += 7;
		startIndex = 7;
	}
	var html = '';
	var rowNum = 0,startTrIndex = 0;
	for(var i = 0; i < count; i++) {
		var trIndex = parseInt(i / 7);
		var tdIndex = i % 7;
		if(i % 7 == 0) {
			html += '<tr id="tv-data-tr-' + trIndex + '">';
			rowNum += 1;
		}
		if(i < startIndex) {
			var dayStr = lastMaxDay - startIndex + 1 + i;
			var lmonth = month - 1;
			var lyear = year;
			if(lmonth == 0) {
				lmonth = 12;
				lyear -= 1;
			}
			var idStr = 'tv-date-td-' + lyear + '-' + lmonth + '-' + dayStr;
			if(lmonth < 10) {
				idStr = 'tv-date-td-' + lyear + '-0' + lmonth + '-' + dayStr;
			}
			html += '<td class="abnormal" id="' + idStr + '" data-tr="' + trIndex +
				'" data-td="' + tdIndex + '"><div>' + dayStr + '</div></td>';
			if (idStr == 'tv-data-td-' + startDate) {
				startTrIndex = trIndex;
			}
		} else if(i >= startIndex + maxDay) {
			var nmonth = month + 1;
			var nyear = year;
			if(nmonth == 13) {
				nmonth = 1;
				nyear += 1;
			}
			var dayStr = (i - maxDay - startIndex + 1);
			var idStr = 'tv-data-td-' + nyear + '-' + nmonth + '-0' + dayStr;
			if(nmonth < 10) {
				idStr = 'tv-data-td-' + nyear + '-0' + nmonth + '-0' + dayStr;
			}
			html += '<td class="abnormal" id="' + idStr + '" data-tr="' + trIndex +
				'" data-td="' + tdIndex + '"><div>0' + dayStr + '</div></td>';
			if (idStr == 'tv-data-td-' + startDate) {
				startTrIndex = trIndex;
			}
		} else {
			var monthStr = month + '';
			if (month < 10) {
				monthStr = '0'+month;
			}
			var dayStr = (i - startIndex + 1);
			if((i - startIndex + 1) < 10) {
				dayStr = '0' + dayStr
			}
			var idStr = 'tv-data-td-' + year +'-'+monthStr + '-' + dayStr;
			html += '<td id="' + idStr + '" data-tr="' + trIndex +
				'" data-td="' + tdIndex + '"><div>' + dayStr + '</div></td>';
			if (idStr == 'tv-data-td-' + startDate) {
				startTrIndex = trIndex;
			}
		}
		if(i % 7 == 6) {
			html += '</tr>';
		}
	}
	self.rowNum = rowNum;
	var areaDom = self.areaDom;
	var tbody = areaDom.querySelector('tbody');
	tbody.innerHTML = html;
	mui('.tv-day-table tbody').on(tapType,'td',dayTdTapped) 
	self.startDate = startDate;
	self.endDate = endDate;
	self.currentYM = endDate.substr(0,7);
	self.chinaYM = self.currentYM.replace('-','年')+'月';
	var ymDom = document.getElementById('dhcDate-ym'); //当前年月
	ymDom.innerText = self.chinaYM;
	//设置选中周
	var currTr = document.getElementById('tv-data-tr-' + startTrIndex);
	var ctds = currTr.querySelectorAll('td');
	for(var i = 1; i < ctds.length; i++) {
		var oneTd = ctds[i];
		oneTd.classList.add('select');
		if(i == 1) {
			oneTd.classList.add('start');
		}
	}
	var nextTr = document.getElementById('tv-data-tr-' + (startTrIndex + 1));
	var nextTd = nextTr.querySelector('td');
	nextTd.classList.add('select');
	nextTd.classList.add('end');
}

dhcTVDatePicker.prototype.TdDomTapped = function(tdDom) {
	var self = this;
	var classStr = tdDom.getAttribute('class');
	if(classStr && classStr.indexOf('select') != -1) { //当前周
		return;
	}
	//清除原来的
	self.clearSelectedTds();
			
	var trIndex = parseInt(tdDom.getAttribute('data-tr'));
	var tdIndex = parseInt(tdDom.getAttribute('data-td'));
	if((tdIndex == 0 && trIndex == 0) || self.rowNum == trIndex + 1) { 
		//需要换月份
		var idStr = tdDom.id;
		var dateStr = idStr.substring('tv-date-td-'.length,idStr.length);
		self.getFullWeek(dateStr);
		self.fillDateUI(self.startDate,self.endDate);
	} else{
		var startIndex = trIndex;
		var endIndex = trIndex+1;
		if (tdIndex == 0 && trIndex > 0) {
			startIndex = trIndex - 1;
			endIndex = trIndex;
		}
		var startTr = document.getElementById('tv-data-tr-' + startIndex);
		var endTr = document.getElementById('tv-data-tr-' + endIndex);
		var startTds = startTr.querySelectorAll('td');
		for(var i = 1; i < startTds.length; i++) {
			var oneTd = startTds[i];
			oneTd.classList.add('select');
			if(i == 1) {
				oneTd.classList.add('start');
				var idStr = oneTd.id;
				self.startDate = idStr.substring('tv-data-td-'.length,idStr.length)
			}
		}
		var endTd = endTr.querySelector('td');
		endTd.classList.add('select');
		endTd.classList.add('end');
		var idStr = endTd.id;
		self.endDate = idStr.substring('tv-data-td-'.length,idStr.length);
	}
}

dhcTVDatePicker.prototype.clearSelectedTds = function() {
	var self = this;
	var selectTds = self.areaDom.querySelectorAll('.select');
	for(var i = 0; i < selectTds.length; i++) {
		var selectTd = selectTds[i];
		selectTd.classList.remove('select');
		selectTd.classList.remove('start');
		selectTd.classList.remove('end');
	}
}
dhcTVDatePicker.prototype.setupBtnTapped = function(block) {
	self = this;
	var lyBtn = document.getElementById('dhcDate-ly'); //上一年
	var lmBtn = document.getElementById('dhcDate-lm'); //上一月
	var nmBtn = document.getElementById('dhcDate-nm'); //下一月
	var nyBtn = document.getElementById('dhcDate-ny'); //下一年
	var weekBtn = document.getElementById('dhcDate-tweek'); //本周
	var cancelBtn = document.getElementById('dhcDate-cancel'); //取消按钮
	var sureBtn = document.getElementById('dhcDate-sure'); //确定按钮
	lyBtn.addEventListener(tapType, function() {//上年
		self.pickerChangeYM('ly');
	}, false)
	lmBtn.addEventListener(tapType, function() {//上月
		self.pickerChangeYM('lm');
	}, false)
	nmBtn.addEventListener(tapType, function() {//下月
		self.pickerChangeYM('nm');
	}, false)
	nyBtn.addEventListener(tapType, function() {//下年
		self.pickerChangeYM('ny');
	}, false)
	weekBtn.addEventListener(tapType, function() {//本周
		self.initDays();
		self.fillDateUI(self.startDate,self.endDate);
	}, false)
	cancelBtn.addEventListener(tapType, function() {//取消
		self.pickerHide()
	}, false)
	sureBtn.addEventListener(tapType, function() {//确定
		self.pickerHide();
		block();
	}, false)
}

dhcTVDatePicker.prototype.initDays = function(){
	var self = this;
	if (localStorage['todayStr']) {
		self.getFullWeek(localStorage['todayStr']);
		return
	}
	var newDate = new Date();
	var year = newDate.getFullYear();
	var month = newDate.getMonth() + 1;
	var day = newDate.getDate();
	var str = self.outYMDStr(year,month,day);
	self.getFullWeek(str);
}
dhcTVDatePicker.prototype.getFullWeek = function(dayStr) {
	var self = this;
	var dict = self.getYMDWithStr(dayStr)
	var cyear = dict['year'];
	var cmonth = dict['month'];
	var cday = dict['day'];
	var weekDay = self.getWeekIndex(dayStr);
	var maxDay = self.getMonthMaxDay(cyear,cmonth);
	
	if (weekDay == 0) {
		self.endDate = dayStr;
		self.currentYM = dayStr.substr(0,7);
		self.chinaYM = self.currentYM.replace('-','年')+'月';
		var sday = cday - 6
		if (sday < 1) {
			cmonth -= 1;
			if (cmonth < 0) {
				cmonth = 12;
				cyear -= 1;
			}
			maxDay = self.getMonthMaxDay(cyear,cmonth);
			sday += maxDay;
		}
		self.startDate = self.outYMDStr(cyear,cmonth,sday);
		var ymDom = document.getElementById('dhcDate-ym'); //当前年月
		ymDom.innerText = self.chinaYM;
		return;
	}
	var syear = cyear;
	var smonth = cmonth;
	var sday = cday;
	var sday = cday - weekDay + 1;
	cday = cday + 7 - weekDay;
	if(cday > maxDay) {
		cmonth += 1;
		cday = cday - maxDay;
		if(cmonth == 13) {
			cyear += 1;
			cmonth = 1;
		}
	}
	if(sday < 1) {
		maxDay = self.getLastMonthMaxDay(cyear,cmonth)
		sday = maxDay + sday;
		smonth -= 1;
		if(smonth == 0) {
			syear -= 1;
			smonth = 12;
		}
	}

	self.startDate = self.outYMDStr(syear, smonth, sday);
	self.endDate = self.outYMDStr(cyear, cmonth, cday);
	self.currentYM = self.outYMStr(cyear, cmonth)
	self.chinaYM = self.outChinaYMStr(cyear, cmonth);	
	var ymDom = document.getElementById('dhcDate-ym'); //当前年月
	ymDom.innerText = self.chinaYM;
}


dhcTVDatePicker.prototype.getWeekIndex = function(dayStr) {
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]) - 1;
	var day = parseInt(arr[2]);
	var originDate = new Date(year, month, day);
	return originDate.getDay()
}
dhcTVDatePicker.prototype.getYMWithStr = function(dayStr){
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	return {'year':year,'month':month};
}
dhcTVDatePicker.prototype.getYMDWithStr = function(dayStr){
	var arr = dayStr.split("-");
	var year = parseInt(arr[0]);
	var month = parseInt(arr[1]);
	var day = parseInt(arr[2]);
	return {'year':year,'month':month,'day':day};
}

dhcTVDatePicker.prototype.getLastYMDict = function(year, month){
	if(month == 1) {
		month = 12;
		year -= 1;
	} else {
		month -= 1;
	}
	return {'year':year,'month':month};
}
dhcTVDatePicker.prototype.getNextYMDict = function(year, month){
	if(month == 12) {
		month = 1;
		year += 1;
	} else {
		month += 1;
	}
	return {'year':year,'month':month};
}

dhcTVDatePicker.prototype.getLastMonthMaxDay = function(year, month) {
	var self = this;
	if(month == 1) {
		month = 12;
		year -= 1;
	} else {
		month -= 1;
	}
	var maxDay = self.getMonthMaxDay(year, month);
	return maxDay;
}

dhcTVDatePicker.prototype.getMonthMaxDay = function(year, month) {
	var maxDay = 31;
	if(month == 2) {
		maxDay = 28;
		if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0)) {
			maxDay = 29;
		}
	} else if(month == 4 || month == 6 || month == 9 || month == 11) {
		maxDay = 30;
	}
	return maxDay;
}

dhcTVDatePicker.prototype.outYMStr = function(year, month) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	return year + '-'+monthStr;	
}
dhcTVDatePicker.prototype.outChinaYMStr = function(year, month) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	return year + '年'+monthStr+'月';
}
dhcTVDatePicker.prototype.outYMDStr = function(year, month,day) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	var dayStr = day + '';
	if (day < 10) {
		dayStr = '0'+day;
	}
	return year + '-'+monthStr+'-'+dayStr;
}
dhcTVDatePicker.prototype.outChinaMDStr = function(month,day) {
	var monthStr = month + '';
	if (month < 10) {
		monthStr = '0'+month;
	}
	var dayStr = day + '';
	if (day < 10) {
		dayStr = '0'+day;
	}
	return monthStr+'月'+dayStr+'日';
}
dhcTVDatePicker.prototype.updatePickerPos = function(btnId) {
	var self  = this;
	var absPos = self.getAbsPosition(btnId);
	var popoverWith = 150 * SCALE
	var left = (absPos.centerx - popoverWith) + 'px';
	var top = absPos.top + 'px';
	self.areaDom.style.left = left;
	self.areaDom.style.top = top;
}

dhcTVDatePicker.prototype.getAbsPosition = function(itemId) {
	var bodyW = parseInt(localStorage.getItem('bodyW'))
	var bodyH = parseInt(localStorage.getItem('bodyH'))
	if(itemId == null || itemId == undefined) {
		itemId = '';
	}
	var item = document.getElementById(itemId);
	if(!item) {
		return {
			'centerx': bodyW * 0.5,
			'top': bodyH * 0.4
		};
	}
	var actualLeft = item.offsetLeft + item.clientWidth * 0.5;
	var actualTop = item.offsetTop + item.clientHeight;
	var current = item.offsetParent;
	while(current !== null) {
		actualLeft += (current.offsetLeft + current.clientLeft);
		actualTop += (current.offsetTop + current.clientTop);
		current = current.offsetParent;
	}
	return {
		'centerx': actualLeft,
		'top': actualTop
	};
}