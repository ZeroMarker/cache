(function ($) {
	var hospID = localStorage['hospId'];
	var wardID = localStorage['wardId'];
	var workTimer;
	var itemWard = 0;//用户等责组和交班项目请求结束后再请求交班详细数据
	$.init({});
	$('.mui-scroll-wrapper').scroll({
		bounce: true,
		indicators: false, //是否显示滚动条
	});
	
	baseSetup();
	function baseSetup() {
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		$.DHCRequestXMl(function(result) {
			requestShiftUpperData(); //获取top表
		},function(err){
		})
		//责组按钮
		var zezuSelect = document.getElementById("zezuSelect");
		zezuSelect.addEventListener(tapType, function() {
			var leftTop = getAbsPosition(this);
			var zezuPopover = document.getElementById("zezuPopover");
			zezuPopover.style.top = (leftTop['top']+this.clientHeight) + 'px';
			mui('#zezuPopover').popover('show');
			var zezuScroll = zezuPopover.querySelector('.mui-scroll');
			if (zezuPopover.clientHeight > zezuScroll.clientHeight + 10) {
				zezuPopover.style.height = zezuScroll.clientHeight + 'px'
			}
		})
		// 昨天 今天
		mui('#daySeg .mui-control-item').each(function() {
			this.addEventListener(tapType, function() {
				var old = mui('#daySeg .mui-control-item.mui-active')[0]
				if (old != this) {
					old.classList.remove('mui-active')
					this.classList.add('mui-active')
				}
				requestShiftUpperData(this.getAttribute('flag'));
			}, false);
		});
		//排序
		mui('#orderSeg .mui-control-item').each(function() {
			this.addEventListener(tapType, function() {
				getShiftTable(this.getAttribute('order'));
			}, false);
		});
	}
	function topCellTapped(){
		var toast = document.querySelector('.loading');
		if (toast) {
			return;
		}
		cateDomTapped(this);
	}
	
	function zezuCellTapped(){
		var oldActive = document.querySelector('#zezuUL .dhc-active')
		if (oldActive) {
			oldActive.classList.remove('dhc-active');
		}
		this.classList.add('dhc-active');
		var currZeDom = mui('#zezuSelect')[0]
		currZeDom.innerHTML = this.innerHTML
		currZeDom.setAttribute('group',this.getAttribute('group'))
		getShiftTable();
		mui('#zezuPopover').popover('hide');
	}
	function shiftItemsTapped(){
		var oldActive = document.querySelector('#itemWrapper .shiftItem.dhc-active');
		if (oldActive) {
			oldActive.classList.remove('dhc-active');
		}
		this.classList.add('dhc-active');
		getShiftTable();
	}
	//顶部表
	function requestShiftUpperData(flag) {
		var cdate = getRequestDate(flag);
		var xmlStr = {
			'WardID': wardID,
			'shiftDate': cdate
		};
		$.DHCWebService('GetShiftUpper', xmlStr, function(result) {
			hideToast();
			mui('#cate-area').off(tapType,'.category',topCellTapped);
			var cateArea = document.getElementById('cate-area')
			if (result.length > 0) {
				cateArea.style.display = 'block';
				if (result[0]["shiftHV"] == "H") {
					updateTopTableVersionH(result);//旧版的三个Table
				}else{
					updateTopTableVersionV(result);//新版横着的一个Table
				}
				mui('#cate-area').on(tapType,'.category',topCellTapped);
				requestAllItems(); //获取项目
				// getWardGroup(); //获取责组
			} else {
				cateArea.style.display = 'none';
				mui('#workBody')[0].innerHTML = ''
				showNULLByElementId('workNull', '未获取到交班时间');
			}
		}, function(errorStr) {
			hideToast();
			mui('#cate-area').off(tapType,'.category',topCellTapped);
			var cateArea = document.getElementById('cate-area')
			cateArea.style.display = 'none';
			mui('#workBody')[0].innerHTML = ''
			showNULLByElementId('workNull', '交班时间' + errorStr, 'error');
		});
	}

	function updateTopTableVersionH(result){
		var html = '';
		var activeCateId=getCurrShiftTimeID();
		var widthHtml = '';
		var cateAreaDom = document.getElementById('cate-area');
		cateAreaDom.style.display="flex"
		if ((100 / result.length) > 0) {
			widthHtml = 'style="width:' + (100 / result.length) + '%"';
		} else {
			widthHtml = '';
		}
		for (var i = 0; i < result.length; i++) {
			var active = '';
			var dict = result[i];
			if(dict['type'] == activeCateId || (activeCateId == "" && i == 0)){
				active = 'dhc-active';
			}
			var titleStr = '';
			if(dict['name'].indexOf("夜") != -1 ){
				titleStr = '<div class="cate-title nightSch">' + dict['name'] + '（' + dict['timeRange'] + '）'+ '</div>'
			}else{
				titleStr = '<div class="cate-title">' + dict['name'] + '（' + dict['timeRange'] + '）'+ '</div>'
			}
			html += '<div class="category horizonClass ' + active + '" data-id="' + dict['type'] + '" ' + widthHtml + '>' +
				titleStr + '<div class="cate-content">' + getContentInnerHtml(dict['data']) +'</div></div>';
		}
		cateAreaDom.innerHTML = html;
		if (!cateAreaDom.querySelector('.dhc-active')) {
			var first = cateAreaDom.querySelector('.category');
			if (first) {
				first.classList.add('dhc-active')
			}
		}
	}
	function getContentInnerHtml(one) {
		var html = '';
		var cateAreaDom = document.getElementById('cate-area');
		var wrapper = document.getElementById('wrapper');
		var sortedJson = one.sort(function(row, col) { //先排序a 字段   然后排序b 字段
			const first = row.row - col.row;
			if (first !== 0) {
				return first;
			}
			return row.col - col.col;
		});
		
		var colunm=0;
		for(var i = 0; i < sortedJson.length; i++){
			var ai = sortedJson[i];
			if (ai.col > colunm) {
				colunm = ai.col
			}
		}
		var widthStr = ' style="width:'+(100 / colunm)+'%;;"'
		var emptyHtml = '<div '+widthStr+' class="itemArea"><div class="itemFlex"></div></div>'
		var divCount = 0;
		for (var i = 0; i < sortedJson.length; i++) {
			var oneDict = sortedJson[i]
			var colInt = oneDict['col'];
			var rowInt = oneDict['row']
			var index = (rowInt-1) * colunm + colInt
			var currHtml = '<div '+widthStr+'class="itemArea"><div class="itemFlex">'+'<div class="itemName">'+oneDict['itemName']+':</div>'+
				'<div class="count">' + oneDict['count'] + '</div></div></div>';
			var jCount=0;
			for (var j = divCount ;j < index-1;j++) {
				html += emptyHtml;
				jCount += 1;
			}
			divCount += jCount+1
			html += currHtml
		}
		return html;
	}
	
	function updateTopTableVersionV(result){
		var headHtml = '';
		var bodyHtml = '';
		var oldActive = document.querySelector('#cate-area .dhc-active')
		var oldId = '';
		if (oldActive) {
			oldId = oldActive.getAttribute('data-id')
		}
		
		var upHead = document.getElementById('upHead')
		if (!upHead) {
			var cateArea = document.getElementById('cate-area')
			cateArea.innerHTML = '<table id="upperTable" style="width: 100%;" border="1">'+
					'<thead id="upHead"></thead><tbody id="upBody"></tbody></table>'
		}
		for (var i = 0; i < result.length; i++) {
			var dic = result[i];
			var itemArr = dic['data']
			if (!itemArr) {
				continue
			}
			var oneBody = ''
			for (var j = 0; j < itemArr.length; j++) {
				oneBody += '<td>' + itemArr[j]['count'] + '</td>';
				if (i == 0) {
					headHtml += '<td>' + itemArr[j]['itemName'] + '</td>';
				}
			}
			var activeStr = ''
			if (dic['type'] == oldId) {
				activeStr = 'dhc-active'
			}
			bodyHtml +='<tr class="category '+activeStr+'" data-id="'+dic['type']+'"><td class="cateName">'+
				'<div class="cateDesc">' + dic['name'] + '</div>'+
				'<span class="timeRange">' + dic['timeRange'] + '</span></td>'+ oneBody + '</tr>'
		}
		mui('#upHead')[0].innerHTML = '<tr><td class="rf">班次/项目</td>' + headHtml + '</tr>';
		mui('#upBody')[0].innerHTML = bodyHtml;
		if (!document.querySelector('#upBody .dhc-active')) {
			var first = document.querySelector('#upBody .category');
			if (first) {
				first.classList.add('dhc-active')
			}
		}
	}
	function cateDomTapped(cateDom) {
		var oldActive = document.querySelector('#cate-area .dhc-active');
		if(oldActive){
			oldActive.classList.remove('dhc-active');
		}
		cateDom.classList.add('dhc-active');
		//发起请求
		getShiftTable();
	}
	
	function getShiftTable(orderStr) {
		$('#wrapper').scroll().scrollTo(0,0,100);
		//零点过渡问题
		var argDate = getRequestDate();
		var type = getCurrShiftTimeID()
		var item=getCurrShiftItemID();
		var zezu = getCurrWardGroupID();
		var order= getCurrOrderID()
		if (orderStr != undefined) {
			order = orderStr
		}
		var xmlStr = {
			'WardID': wardID,
			'QDate': argDate,
			'ShiftType': type,
			'ItemDR': item,
			'GroupDR': zezu,
			'SortType': order
		};
		// console.log(argDate,type,item,zezu,order);
		hideToast('.loading');
		$.DHCWebService('GetShiftTable', xmlStr, function(result) {
			hideToast('.loading');
			if (result && result['head'].length > 0) {
				updateCompleteTable(result)
			} else {}
		}, function(errorStr) {});
	}
	
	function updateCompleteTable(arr) {
		if (arr == undefined || arr['key'] == undefined || arr['width'] == undefined || arr['head'] == undefined) {
			mui('#workHead')[0].innerHTML = ''
			mui('#workBody')[0].innerHTML = ''
			return
		}
		//更新表头
		var keyArr = arr['key'];
		var widthArr = arr['width'];
		var cols = '';
		for (var i = 0; i < widthArr.length; i++) {
			cols += '<col width="' + widthArr[i] + '">';
		}
		mui('#upCols')[0].innerHTML = cols; //用colgroup对齐上下表格
	
		var headData = arr['head'];
		var heightSty = "";
		if (headData.length == 1) {
			heightSty = 'height="40px;"'
		}
		var headHtml = ''
		for (var i = 0; i < headData.length; i++) {
			var rows = '';
			for (var j = 0; j < headData[i].length; j++) {
				var rowspan = headData[i][j].rowspan;
				var colspan = headData[i][j].colspan;
				var header = headData[i][j].header;
				rows += '<th colspan="' + colspan + '" rowspan="' + rowspan + '" ' + heightSty + '>' + header + '</th>';
			}
			headHtml += '<tr>' + rows + '</tr>';
		}
		mui('#workHead')[0].innerHTML = headHtml;
	
		//更新表
		var detailArr = []
		if (arr['detail']) {
			detailArr = arr['detail'];
		}
		var centerArr = []
		if (arr['center']) {
			centerArr = arr['center'];
		}
		var html = '';
		for (var i = 0; i < detailArr.length; i++) {
			var row = '';
			var rowDict = detailArr[i]
			for (var j = 0; j < keyArr.length; j++) {
				var charname = keyArr[j];
				var textStr = rowDict[charname]
				if (charname == 'name') {
					textStr = dealNamePrivate(textStr)
				}
				var centerStr = ''
				if (centerArr[j] != undefined) {
					centerStr = centerArr[j]
				}
				if (charname != 'name') {
					row += '<td class="' + keyArr[j] + ' '+ centerStr +'">' + textStr + '</td>';
				}else{
					row += '<td class="patName ' + keyArr[j] + ' '+ centerStr +'" data-patName="'+rowDict[charname]+'" >' + textStr + '</td>';
				}
			}
			html += '<tr>' + row + '</tr>';
		}
		
		mui('#botCols')[0].innerHTML = cols;//用colgroup对齐上下表格
		mui('#workBody')[0].innerHTML = html;
		if (detailArr.length == 0) {
			showNULLByElementId('workNull');
		}else{
			hiddenNULLByElementId('workNull');
		}
		setWrapperTop()
		var wrapper = document.getElementById("wrapper");
		wrapper.style.opacity = '1'
		var itemWrapper = document.getElementById("itemWrapper");
		itemWrapper.style.opacity = '1'
	}
	function requestAllItems() {
		var xmlStr = {
			'WardID': wardID
		};
		$.DHCWebService('GetShiftItems', xmlStr, function(result) {
			updateItemsWrapper(result);
			getShiftTable();
			// itemWard += 1;
			// if (itemWard >= 2) {
			// 	itemWard = 0
			// 	getShiftTable();
			// }
		}, function(errorStr) {
			updateItemsWrapper([]);
		});
	}
	function updateItemsWrapper(itemArr) {
		var itemScroll = document.getElementById('itemScroll')
		var oldItemId = getCurrShiftItemID()
		var html =''
		for (var i = 0; i < itemArr.length; i++) {
			var str = ''
			if (itemArr[i]['value'] == oldItemId) {
				str = ' dhc-active'
			}
			html += '<div class="shiftItem' + str + '" itemID="' + itemArr[i]['value'] + '">' + itemArr[i]['text'] + '</div>';
		}
		if (html.indexOf('dhc-active') == -1) {
			html = '<div class="shiftItem dhc-active" itemID="">全部</div>' + html;
		}else{
			html = '<div class="shiftItem" itemID="">全部</div>'+html;
		}
		//交班项目
		mui('#itemWrapper').off(tapType,'.shiftItem',shiftItemsTapped);
		itemScroll.innerHTML = html;
		mui('#itemWrapper').on(tapType,'.shiftItem',shiftItemsTapped);
	}
	
	function getWardGroup() {
		var xmlStr = {
			'WardID': wardID
		};
		$.DHCWebService('GetWardGroup', xmlStr, function(result) {
			updateZezuPopover(result);
			itemWard += 1;
			if (itemWard >= 2) {
				itemWard = 0
				getShiftTable();
			}
		}, function(errorStr) {
			updateZezuPopover([]);
		});
	}
	// 更新责组
	function updateZezuPopover(groupArr) {
		var zezuPopover = document.getElementById("zezuPopover");
		zezuPopover.style.height = 12.5 * 16 * SCALE + 'px'
		var oldGroupId = getCurrWardGroupID()
		var html = ''	
		for (var i = 0; i < groupArr.length; i++) {
			var str = ''
			if (groupArr[i]['id'] == oldGroupId) {
				str = ' dhc-active'
			}
			html += '<li class="mui-table-view-cell'+str+'" group="' + groupArr[i]['id'] + '">' + groupArr[i]['name'] + '</li>';
		}
		if (html.indexOf('dhc-active') == -1) {
			html = '<li class="mui-table-view-cell dhc-active" group="">全部</li>' + html;
		}else{
			html = '<li class="mui-table-view-cell" group="">全部</li>'+html;
		}
		//责组组别筛选
		mui('#zezuUL').off(tapType,'.mui-table-view-cell',zezuCellTapped);
		mui('#zezuUL')[0].innerHTML = html
		//责组组别筛选
		mui('#zezuUL').on(tapType,'.mui-table-view-cell',zezuCellTapped);
	}
	
	function getCurrWardGroupID(){
		var zezu = mui('#zezuSelect')[0].getAttribute('group');
		if (!zezu) {
			return ''
		}
		return zezu
	}
	function getCurrShiftItemID(){
		var activeDom = document.querySelector('#itemWrapper .dhc-active');
		if (!activeDom) {
			return "";
		}
		return activeDom.getAttribute('itemID');
	}
	function getCurrOrderID(){
		var order= document.querySelector('#orderSeg .mui-active').getAttribute('order')
		return order
	}
	function getCurrShiftTimeID(){
		var activeTR = document.querySelector('#cate-area .dhc-active');
		if (!activeTR) {
			return "";
		}
		return activeTR.getAttribute('data-id');
	}
	
	function getRequestDate(type){
		var currDate = getCurrentDayStr();
		if(localStorage['todayStr']){
			currDate = localStorage['todayStr'];
		}
		if (type == 'today') {//点击今日交班
			return currDate;
		}
		var activeFlag = document.querySelector('#daySeg .mui-active').getAttribute('flag');
		if (!type && activeFlag == 'today') {//非点击
			return currDate;
		}
		//点击昨日交班或直接获取昨日日期
		currDate = getLastDay(currDate)
		return currDate;
	}
	
	window.addEventListener('message', function(e) {
		if (e.data.wardId != wardID && e.data.refreshType == 'ward') {//切换病区
			wardID = e.data.wardId;
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
			requestShiftUpperData()
			mui('#wrapper').scroll().scrollTo(0,0,100);
			if (workTimer) {
				clearInterval(workTimer);
				workTimer = undefined;
			}
			timeIntervalSetup()
			return
		}
		wardID = e.data.wardId;
		changeDayNightMode(e.data.nightMode);
		if (e.data.refresh) {
			resetRefresh();
		} else if (e.data.namePrivate) {
			mui('#workBody .patName').each(function (index,element) {
				element.innerHTML = dealNamePrivate(element.getAttribute('data-patName'))
			});
		} else if (e.data.isActive != undefined && e.data.isActive == false) {
			if (workTimer) {
				clearInterval(workTimer);
				workTimer = undefined;
			}
		} else if (e.data.isActive) {
			requestShiftUpperData();
			if (!workTimer) {
				timeIntervalSetup();
			}
		}
	}, false);
	
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
		requestShiftUpperData();
	}
	function changeDayNightMode(mode) {
		if (mode) {
			document.body.classList.add('nightMode');
		} else {
			document.body.classList.remove('nightMode');
		}
	}
	
	function timeIntervalSetup() {
		if (workTimer) {
			return
		}
		var len = 10 * 60 * 1000; //10分钟
		workTimer = setInterval(function() {
			requestShiftUpperData();
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
					case 'wrapper':
					case 'itemWrapper':
					case 'zezuWrapper':
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
	function setWrapperTop(){
		var workHead = document.getElementById("workHead");
		var pos = getAbsPosition(workHead)
		var top = pos.top;
		
		var itemWrapper = document.getElementById("itemWrapper");
		var wrapper = document.getElementById("wrapper");
		wrapper.style.top = top + workHead.clientHeight + 'px';
		itemWrapper.style.top = top + 'px';
	}
	window.onresize = setWrapperTop
})(mui)
/*
去掉责组和排序修改的代码
html
1.orderArea隐藏display:none
2.fixedTable增加margin-top

js
requestShiftUpperData方法中不请求责组接口getWardGroup
getShiftTable中不做itemWard判断,直接请求getShiftTable接口
*/