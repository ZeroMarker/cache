(function($) {
	var configJson, logData;
	var hospID = localStorage['hospId'];
	var realWardArr =[];
	var realLocId=localStorage['locId'],realWardId=localStorage['wardId'];
	var colNum = 0,rowNum = 0;
	var logAreaId = 'halfLogScroll',originLogHtml = '';
	var bedTimer;
	var bedResult, logItemArr, logItemSearch;
	var chosenItemArr = [];
	var specicalFilter = undefined; //{'refuseShave':{'desc':'过敏','key':'allergys'}} 
	var BodyWidth = 0;
	var logXHR,configXHR,iconXHR,bedXHR,filterXHR;
	var emptyBedInfoHtml = ''
	var toop = document.querySelector('.toop')
	$.init({});
	$('.mui-scroll-wrapper').scroll({
		bounce: true,
		indicators: true, //是否显示滚动条
	});
	baseSetup();

	function baseSetup() {
		if (mui.os.plus) {
			var muiContent = document.querySelector('.mui-content');
			muiContent.classList.add('osPlus')
		}
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true);
		}
		//日志模板配置
		var itemClose = document.getElementById('itemClose');
		itemClose.addEventListener(tapType, closeItemPopover, false);

		//手工输入
		var commitBtn = document.getElementById('commitBtn');
		commitBtn.addEventListener(tapType, popoverSureBtnTapped, false);
		// 取消点击
		var cancelBtn = document.getElementById('cancelBtn');
		cancelBtn.addEventListener(tapType, function() {
			showOrHideDHCpopover('ManualPopover','hide')
		}, false);
		//关闭编辑信息
		var editClose = document.getElementById('editClose');
		editClose.addEventListener(tapType, function() {
			showOrHideDHCpopover('ManualPopover','hide')
		}, false);
		//日志项目搜索按钮
		var searchBtn = document.getElementById('searchBtn');
		searchBtn.addEventListener(tapType,function(){
			getLogItems();
			mui('#itemWrapper').scroll().scrollTo(0,0,100);
		});
		//日志项目搜索清空图标点击
		mui("body").on("tap", ".itemSearchArea .mui-icon-clear", function() {
			if (document.getElementById('searchInput').value != "") {
				document.getElementById('searchInput').value = ""
			}
			getLogItems();
			mui('#itemWrapper').scroll().scrollTo(0,0,100);
		});
		//关闭病人信息
		var closePat = document.getElementById('closePat');
		closePat.addEventListener(tapType, function() {
			showOrHideDHCpopover('PatInfoPopover','hide')
		}, false);
		//关闭病人信息
		var patClose = document.getElementById('patClose');
		patClose.addEventListener(tapType, function() {
			showOrHideDHCpopover('PatInfoPopover','hide')
		}, false);
		var dhcBackdrop = document.getElementById('dhcBackdrop');
		dhcBackdrop.addEventListener(tapType, function() {
			var popover = document.querySelector('.mui-popover.mui-active');
			if (popover) {
				if(popover.id == 'PatInfoPopover'){
					return;
				}
				showOrHideDHCpopover(popover.id,'hide');
			}else{
				this.classList.remove('dhc-active');
			}
		});
		//加载日志
		mui.DHCRequestXMl(function(result) {
			getWardLogData();
			getAllNurse();
			getAllDoc();
			getSpecicalFilter()
			// 定时刷新
			timeIntervalSetup();
		},function(err){
		})
		
		openPopoverDrag('ManualPopover');
		openPopoverDrag('itemPopover');
		//wrapper 滑动
		mui('.mui-scroll-wrapper').on('scroll', 'div', hideToop);
		var slider = document.getElementById('slider');
		slider.addEventListener('scroll', hideToop, false)
		//首页切换时，关闭其他pop
		slider.addEventListener('slide', function(event) {
			hideLogDataToop()
			//注意slideNumber是从0开始的；
			var index = event.detail.slideNumber;
			if (index != 2 && document.querySelector('.itemPopover.mui-active')) {
				closeItemPopover(false)
			}
			var oldActive = document.querySelector('#sliderIndicator .mui-indicator.mui-active');
			if (oldActive) {
				oldActive.classList.remove('mui-active')
			}
			document.querySelector('#sliderIndicator .mui-indicator[data-index="'+index+'"]').classList.add('mui-active');
		});
		//mui('#slider').slider().stopped = true; //禁止左右滑动
		var indicators = document.querySelectorAll('#sliderIndicator .mui-indicator');
		for (var i = 0; i < indicators.length;i++) {
			indicators[i].addEventListener(tapType,function(){
				hideLogDataToop()
				var oldActive = document.querySelector('#sliderIndicator .mui-indicator.mui-active');
				if (oldActive) {
					if (oldActive == this) {
						return
					}
					oldActive.classList.remove('mui-active')
				}
				hideToop();
				var newIndex = parseInt(this.getAttribute('data-index'))
				if (newIndex != 2 && document.querySelector('.itemPopover.mui-active')) {
					closeItemPopover(false)
				}
				this.classList.add('mui-active')
				mui('#slider').slider().gotoItem(newIndex,0)
			});
		}
		mui('#fullBedMap').on(tapType,'#up',function(){
			mui('#allBedWrapper').scroll().scrollTo(0,0,100);
		})
		var scroll = mui('.allBedWrapper').scroll();
		var allBedWrapper = document.getElementById('allBedWrapper');
		allBedWrapper.addEventListener('scroll',function(e){
			if(scroll.y < 0){
				$('#up')[0].style.display = "block";
			}else{
				$('#up')[0].style.display = "none";
			}
		})
	}
	
	//读取日志模板和数据
	function getWardLogData(isConfig) {
		var xmlStr = {
			'HospID': hospID,
			'WardID': realWardId
		};
		logXHR=$.DHCWebService('GetLayout', xmlStr, function(result) {
			logXHR=null
			logData = result;
			if (!isConfig) {//读取床位图配置和数据
				prepareRealWardArr(result['combLocs'])
				getBedCardConfig();
			}
			updateLogScrollUI(result, isConfig);
			if (logData['html'] ==undefined || logData['html'] == "") {
				closeItemPopover(false);
			}
		}, function(errorStr) {
			logXHR=null
			if (errorStr == "中断") {
				return
			}
			clearLayoutTap()
			logData = undefined
			if (!isConfig) {//读取床位图配置和数据
				realWardArr = [];
				getBedCardConfig();
			}
			
			var allLogScroll = document.getElementById('allLogScroll');
			var halfLogScroll = document.getElementById('halfLogScroll');
			allLogScroll.innerHTML = ''
			halfLogScroll.innerHTML = ''
			showNULLByElementId('halflogNull', errorStr, 'error');
			showNULLByElementId('alllogNull', errorStr, 'error');
		});
	}
	
	function prepareRealWardArr(dict){
		realWardArr = [];
		if (dict == undefined) {
			return;
		}
		var arr = []
		for (var key in dict) {
			var one = dict[key]
			arr.push(one);
		}
		realWardArr = arr.sort(function(a,b){
			var aOrder=a.bedNo;
			var bOrder=b.bedNo;
			return parseInt(aOrder) - parseInt(bOrder)
		})
	}

	function getLogItems(tobottom) {
		//获取模板项目
		var xmlStr = {
			'HospID': hospID
		};
		var searchInputText = document.getElementById('searchInput').value
		if (searchInputText != "") {
			xmlStr['Desc'] = searchInputText
		}
		$.DHCWebService('GetLogItems', xmlStr, function(result) {
			//logItemArr = result;
			var deleteItem = [{
				"code": "",
				"detail": "",
				"detailShow": "",
				"id": "",
				"name": "删除此项",
				"order": "",
				"show": "",
				"type": "",
				"way": ""
			}];
			var tempArr = result.sort(treeSort)
			tempArr = tempArr.concat(deleteItem)
			for(var i=0; i < tempArr.length;i++){
				if(tempArr[i]['order'] == undefined){
					tempArr[i]['order']=""
				}
				var children = tempArr[i]['children']
				if(children==undefined){
					continue
				}
				for(var j=0; j < children.length;j++){
					if(children[j]['order'] == undefined){
						tempArr[i]['children'][j]['order']=""
					}
				}
				tempArr[i]['children'] = children.sort(treeSort)
			}
			if (searchInputText == "") {
				logItemArr = tempArr
			}
			logItemSearch = tempArr;
			updateItemPopoverUL(logItemSearch);
			var itemPopover = document.getElementById('itemPopover');
			itemPopover.classList.add('mui-active');
			// mui('#').popover('show')
			if (tobottom) {
				wrapperScrollToBottom('itemWrapper');
			}
		}, function(errorStr) {
			clearLogItemsTap()
			if (xmlStr['Desc'] != undefined) {
				var itemUl = document.getElementById('itemUl');
				itemUl = ''
			}
		});
	}
	function treeSort(a,b){
		var aOrder=a.order;
		var bOrder=b.order;
		if((bOrder==undefined || bOrder=="") && (aOrder==undefined || aOrder=="")){
			return 1
		}
		if(bOrder==undefined || bOrder==""){
			return -1
		}
		if(aOrder==undefined || aOrder==""){
			return 1
		}
		return parseInt(aOrder) - parseInt(bOrder)
	}
	// luzhiqiang -- 
	//新增病区日志项目事件
	var createItem = document.getElementById("createItem");
	createItem.addEventListener(tapType, function(e) {
		var itemUl = document.getElementById('itemUl');
		var newItemInput = document.getElementById("newItemInput");
		if (newItemInput.value) {
			if (checkIsHasSpecialStr(newItemInput.value)) {
				iziToast.error({
				    title: '含有特殊非法字符！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
				newItemInput.value = '';
			}
			if (/^[0-9]+/.test(newItemInput.value.charAt(0))) {
				iziToast.error({
				    title: '不能以数字开头！',
					position: 'center',
				    timeout: 1000,
					transitionOut: 'flipOutX'
				});
				newItemInput.value = '';
				return
			}
			itemCode = getPinyin(logItemArr[logItemArr.length - 1]['id']);
			for (var i = 0; i < logItemArr.length; i++) {
				if (newItemInput.value == logItemArr[i]['name']) {
					alert('已有该项目');
					newItemInput.value = '';
					return
				}
			}
			var xmlStr = {
				'LIName	': newItemInput.value,
				'HospID': hospID,
				'LICode': itemCode
			};
			mui.DHCWebService('SaveLogItem', xmlStr, function(result) {
				if (result['flag']=='false' || !result['flag']) { //创建失败
					newItemInput.value = '';
					mui.toast(result['err']);
				}else{
					getLogItems('滚动到底部，显示新建的项目');
					newItemInput.value = '';
				}
			}, function(errorStr) {
				
				mui.toast('创建项目失败：' + errorStr);
			});
		} else {
			mui.toast('请输入要创建的项目')
		}
	});

	function getPinyin(itemID) {
		var value = document.getElementById('newItemInput').value;
		var result = '';
		if (value) {
			result = 'Cus' + pinyinUtil.getFirstLetter(value, false) + itemID;
		}
		return result;
	}
	// luzhiqiajng ---

	function updateItemPopoverUL(arr) {
		var itemUl = document.getElementById('itemUl');
		var html = '';
		for (var i = 0; i < arr.length; i++) {
			var dict = arr[i];
			var logItemName = dict['name'];
			var children = dict['children'];
			var porder = dict['order']?(dict['order']+"."):"";
			if (!children || dict['children'].length == 0) {
				if (chosenItemArr.indexOf(logItemName) > -1) { //高亮已选项目
					html += '<li id="item-' + i + '" class="mui-table-view-cell parent chosenItem"><div class="itemText">' +
						porder+logItemName + '</div></li>'
				} else {
					var deleteCls = '';
					if(logItemName == '删除此项'){
						deleteCls = 'deleteItem'
					}
					html += '<li id="item-' + i + '" class="mui-table-view-cell parent"><div class="itemText ' + deleteCls + '">' + 
						porder+logItemName +'</div></li>'
				}
				continue;
			}
			if (chosenItemArr.indexOf(logItemName) > -1) {
				html += '<li id="item-' + i + '" class="mui-table-view-cell parent chosenItem" data-child="' + children.length +
					'">' +
					'<div class="itemText">' + porder+ logItemName + '</div>' +
					'<div id="item-' + i + '-icon" class="arrow iconfont iconright"></div></li>'
			} else {
				html += '<li id="item-' + i + '" class="mui-table-view-cell parent" data-child="' + children.length + '">' +
					'<div class="itemText">' + porder+ logItemName + '</div>' +
					'<div id="item-' + i + '-icon" class="arrow iconfont iconright"></div></li>'
			}
			for (var j = 0; j < children.length; j++) {
				var childDict = children[j]
				var childName = childDict['name'];
				var order= childDict['order']?(childDict['order']+"."):"";
				var spStr = ''; //'|&nbsp;&nbsp;'
				html += '<li id="item-' + i + '-' + j +
					'" style="display:none" class="mui-table-view-cell child"><div class="itemText">'+ 
					order + spStr + childName + '</div></li>'
			}
		}
		clearLogItemsTap()
		itemUl.innerHTML = html;
		setupLogItemsTap()
	}

	function itemPopoverCellTap(event) {
		var targe = event.target
		if (targe.classList.contains('arrow')) {
			return;
		}
		var itemUl = document.getElementById('itemUl');
		//折叠其他地方展开的项目
		var targetPId = targe.parentNode.id;
		if (targetPId == 'itemUl') {
			targetPId = targe.id;
		}
		var liIcon = itemUl.querySelector('.icondown');
		if (liIcon && targetPId.indexOf(liIcon.parentNode.id + '-') == -1) {
			var parentDom = liIcon.parentNode;
			var count = parseInt(parentDom.getAttribute('data-child'));
			for (var j = 0; j < count; j++) {
				var child = document.getElementById(parentDom.id + '-' + j);
				child.style.display = 'none'
			}
			liIcon.classList.remove('icondown');
			liIcon.classList.add('iconright');
		}
	
		if (this.classList.contains('chosenItem')) {
			mui.toast('不允许重复配置！');
			return;
		}
		var index = parseInt(this.id.split('-')[1]);
		var dict = logItemSearch[index];
		if (this.classList.contains('child')) { //点击子项目
			var rowIndex = parseInt(this.id.split('-')[2]);
			dict = dict['children'][rowIndex];
		}
		//填充log的td
		var itemPopover = document.getElementById('itemPopover');
		var tdOrder = itemPopover.getAttribute('data-td');
		var logArea = document.getElementById(logAreaId)
		var tdDom = logArea.querySelector('td[data-order="' + tdOrder + '"]');
		var oldText = tdDom.innerText;
	
		//如果不是父级 为数据格填充code
		if (tdDom.getAttribute('data-role') != 'parent') {
			if(dict['name'] != '删除此项'){
				tdDom.innerText = dict['name'];
			}else{
				tdDom.innerText = '';
			}
			//查找数据格 并填充code
			var colSpan = 1;
			var rowSpan = 1;
			if (tdDom.colSpan && tdDom.colSpan != '') {
				colSpan = parseInt(tdDom.colSpan);
			}
			var dataOrder = tdDom.getAttribute('data-order').split('-')
			var rowIndex = parseInt(dataOrder[0]);
			var colIndex = parseInt(dataOrder[1]);
			for (var j = colIndex + colSpan; j < colNum; j++) {
				var codeDom = logArea.querySelector('td[data-order="' + rowIndex + '-' + j + '"]');
				var codeDisplay = codeDom.style.display
				if (codeDisplay == 'none' || codeDom.classList.contains('itemName')) {
					continue
				}
				codeDom.setAttribute('data-id', dict['code']);
				//codeDom.innerHTML = dict['code'];
				var tempLog = document.getElementById('tempLog');
				var tempTd = tempLog.querySelector('td[data-order="' + tdOrder + '"]');
				if(dict['name'] != '删除此项'){
					tempTd.innerText = dict['name'];
				}else{
					tempTd.innerText = '';
				}
				var tempCodeTd = tempLog.querySelector('td[data-order="' + rowIndex + '-' + j + '"]');
				tempCodeTd.setAttribute('data-id', dict['code']);
				tempCodeTd.innerHTML = dict['code'];
				//准备模板并保存模板 保存模板后 请求新的模板
				prepareAndSaveLogTemplate();
				break;
			}
		} else if (dict['children'] == undefined) { //不可以在父节点处添加子项目 
			if(dict['name'] != '删除此项'){
				mui.toast('请选择带子节点的项目'); //此处是分级的父节点
				return
			}else{
				var tempLog = document.getElementById('tempLog');
				var tempTd = tempLog.querySelector('td[data-order="' + tdOrder + '"]');
				tempTd.innerText = '';
				prepareAndSaveLogTemplate();
			}
		} else {
			var tempLog = document.getElementById('tempLog');
			var tempTd = tempLog.querySelector('td[data-order="' + tdOrder + '"]');
			if(dict['name'] != '删除此项'){
				tdDom.innerText = dict['name'];
				tempTd.innerText = dict['name'];
			}else{
				tempTd.innerText = '';
				tempTd.innerText = '';
			}
			//准备模板并保存模板 保存模板后 请求新的模板
			prepareAndSaveLogTemplate();
		}
		var oldIndex = chosenItemArr.indexOf(oldText);
		if (oldIndex != -1) {
			chosenItemArr.splice(oldIndex, 1);
			if (chosenItemArr.indexOf(oldText) == -1) {
				var destArr = logItemArr;
				if (document.getElementById('searchInput').value != "") {
					destArr = logItemSearch;
				}
				for (var j = 0; j < destArr.length; j++) {
					var oneDict = destArr[j];
					if (destArr[j]['name'] == oldText) {
						var oldItem = document.getElementById('item-' + j);
						if (oldItem) {
							oldItem.classList.remove('chosenItem')
						}
					}
				}
			}
		}
		if (!this.classList.contains('child')) { //子日志项目
			if(dict['name'] != '删除此项'){
				this.classList.add('chosenItem');
				chosenItemArr.push(dict['name'])
			}
		}
		//如果折叠了就打开
		var iconDom = this.querySelector('.arrow');
		if (!iconDom) {
			return;;
		}
		if (iconDom.classList.contains('iconright')) {
			iconDom.classList.remove('iconright');
			iconDom.classList.add('icondown');
		}
		var count = parseInt(this.getAttribute('data-child'));
		for (var j = 0; j < count; j++) { //没必要折叠--zys
			var child = document.getElementById(this.id + '-' + j);
			child.style.display = 'inline-flex';
		}
	}
	//箭头图标的点击事件
	function itemPopoverCellArrowTap(){
		var itemUl = document.getElementById("itemUl");
		var liIcon = itemUl.querySelector('.icondown');
		if (liIcon && liIcon.id != this.id) {
			var parentDom = liIcon.parentNode;
			var count = parseInt(parentDom.getAttribute('data-child'));
			for (var j = 0; j < count; j++) {
				var child = document.getElementById(parentDom.id + '-' + j);
				child.style.display = 'none'
			}
			liIcon.classList.remove('icondown');
			liIcon.classList.add('iconright');
		}
		if (this.classList.contains('iconright')) {
			this.classList.remove('iconright');
			this.classList.add('icondown');
		} else if (this.classList.contains('icondown')) {
			this.classList.remove('icondown');
			this.classList.add('iconright');
		}
		var parentId = this.id.substr(0, this.id.length - 5);
		var parentDom = document.getElementById(parentId);
		var count = parseInt(parentDom.getAttribute('data-child'));
		for (var j = 0; j < count; j++) {
			var child = document.getElementById(parentId + '-' + j);
			if (child.style.display == 'none') {
				child.style.display = 'inline-flex'
			} else {
				child.style.display = 'none'
			}
		}
	}

	function prepareAndSaveLogTemplate(dataOrder) {
		var tempLog = document.getElementById('tempLog');
		var htmls = tempLog.innerHTML;
		var codeArr = []
		for (var i = 0; i < logItemArr.length; i++) {
			var dict = logItemArr[i];
			var td = tempLog.querySelector('td[data-id="' + dict['code'] + '"]');
			if (td) {
				codeArr.push(dict['code']);
			}
			var children = dict['children']
			if(children == undefined){
				continue
			}
			for (var j = 0; j < children.length;j++) {
				var oneC = children[j];
				var td = tempLog.querySelector('td[data-id="' + oneC['code'] + '"]');
				if (td) {
					codeArr.push(oneC['code']);
				}
			}
		}
		var codes = codeArr.join();
		htmls = htmls.replace(/\\/g, '');
		htmls = htmls.replace(/</g, '@l@');
		htmls = htmls.replace(/>/g, '@r@');
		var xmlStr = {
			'WardID': realWardId,
			'HospDR': hospID,
			'TableHtml': htmls,
			'Codes': codes,
			'ColCount': colNum
		};
		$.DHCWebService('SaveLayout', xmlStr, function(result) {
			getWardLogData(true);
		}, function(errorStr) {
			mui.toast('保存病区日志失败:' + errorStr);
		});
	}

	function updateLogScrollUI(result, isConfig) {
		clearLayoutTap()
		var loghtml = result.html;
		var allLogScroll = document.getElementById('allLogScroll');
		var halfLogScroll = document.getElementById('halfLogScroll');
		if (!loghtml || result == '' || result.layoutErr) {
			
			allLogScroll.innerHTML = ""
			halfLogScroll.innerHTML = ""
			var str = '尚未配置病区日志'
			if (result == '') {
				str = '没有获取到病区日志'
			}
			if (result.layoutErr){
				str = result.layoutErr
			}
			showNULLByElementId('halflogNull', str);
			showNULLByElementId('alllogNull', str);
			return;
		} else {
			hiddenNULLByElementId('halflogNull');
			hiddenNULLByElementId('alllogNull');
		}
		loghtml = loghtml.replace(/@smh@/g, '-style:');
		loghtml = loghtml.replace(/@yangshi@/g, ' style=');
		loghtml = loghtml.replace(/\\/g, '');
		originLogHtml = loghtml;
		var colStr = result['col'];
		if (!colStr || colStr == '') {
			colNum == 0
		} else {
			colNum = parseInt(colStr);
			var width = 100.0 / colNum;
			var colgroup = '<colgroup>';
			for (var i = 0; i < colNum; i++) {
				colgroup += '<col width="' + width + '%"/>';
			}
			colgroup += '</colgroup>';
			var tbodyIndex = loghtml.indexOf('<tbody');
			if (tbodyIndex != -1) {
				loghtml = loghtml.slice(0, tbodyIndex) + colgroup + loghtml.slice(tbodyIndex);
			}
		}
		var lastChose = halfLogScroll.querySelector('.chosen');
		var lastId = undefined;
		var lastPinci = undefined
		if (lastChose) {
			lastId = lastChose.getAttribute('data-id');
			var pinciDom = lastChose.querySelector('.pinciChosen')
			if (pinciDom) {
				lastPinci = pinciDom.getAttribute('data-id');
			}
		}
		allLogScroll.innerHTML = loghtml;
		halfLogScroll.innerHTML = loghtml;
		var tempLog = document.getElementById('tempLog');
		tempLog.innerHTML = originLogHtml;
		var allTds = allLogScroll.querySelectorAll('td');
		var halfTds = halfLogScroll.querySelectorAll('td');
		//设置点击事件
		var trs = halfLogScroll.querySelectorAll('tr');
		if (logAreaId == 'allLogScroll') {
			trs = allLogScroll.querySelectorAll('tr');
		}
		rowNum = trs.length;
		chosenItemArr.splice(0, chosenItemArr.length);
		for (var i = 0; i < allTds.length; i++) {
			var alltd = allTds[i];
			var halftd = halfTds[i];
			var display = halftd.style.display;
			var dataID = halftd.getAttribute('data-id');
			var dataOrder = halftd.getAttribute('data-order')
			if (!dataOrder || dataOrder == '') {
				continue
			}
			if (allTds[i].classList.contains('itemName') && allTds[i].innerText) {
				chosenItemArr.push(allTds[i].innerText);
			}
			if (display == 'none' || dataID == undefined || dataID == '' || result[dataID] == undefined) {
				if (!halftd.classList.contains('itemName') && dataID && dataID != '' && result[dataID] == undefined) {
					halftd.innerText = ''; //his测试
					alltd.innerText = ''; //his测试
				}
				continue;
			}
			var dict = result[dataID];
			var selfDef = (dict['selfDef']==undefined?"":dict['selfDef'])+""; //B显示床号,N显示总数
			var show = dict['show']; //B显示床号,N显示总数
			var way = dict['way']; //R关联获取 M手工输入 A获取方法
			if (!halftd.classList.contains('itemName')) {
				dealBedsWidthRealWardArr(dict['beds'],show,way,halftd,alltd,selfDef,dict['score'])
			}
			halftd.classList.add('ellipsis');

			if (way == 'A' && selfDef!= undefined && selfDef!= "") { //留言板,日志等
				alltd.innerHTML = selfDef.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				halftd.innerHTML = selfDef;//.replace(/\n/g,'<br>').replace(/\r/g,'<br>');
				halftd.setAttribute('data-title', selfDef);
			}
			if (dataID == lastId) {
				halftd.classList.add('chosen');
				if (lastPinci) {
					var pinciDom = halftd.querySelector('tr[data-id="'+lastPinci+'"]')
					if (pinciDom) {
						pinciDom.classList.add('pinciChosen')
					}
				}
				if (dict['score']=='1') {
					showLogDataToop(halftd)
				}
			}
		}
	
		var allLogWrapper = document.getElementById('allLogWrapper');
		var allLogTable = allLogScroll.querySelector('table')
		if (allLogWrapper.clientHeight >= allLogTable.clientHeight) {
			allLogScroll.style.height = '100%';
		} else {
			allLogScroll.style.height = 'auto';
		}
		var halfLogWrapper = document.getElementById('halfLogWrapper');
		var halfLogTable = halfLogScroll.querySelector('table')
		if (halfLogWrapper.clientHeight >= halfLogTable.clientHeight) {
			halfLogScroll.style.height = '100%';
		} else {
			halfLogScroll.style.height = 'auto';
		}
		var itemPopover = document.getElementById('itemPopover');
		if (isConfig || itemPopover.classList.contains('mui-active')) {
			var logArea = document.getElementById(logAreaId);
			var tdOrder = itemPopover.getAttribute('data-td');
			var tdDom = logArea.querySelector('td[data-order="' + tdOrder + '"]');
			if (tdDom) {
				tdDom.classList.add('chosen')
			}
			if (isConfig) {
				gotoNextItem();
			}
		}
		setupLayoutTap()
	}
	 //日志单元格点击
	function logTdTapped(){
		hideLogDataToop()
		hideToop();
		var halftd = this
		var display = halftd.style.display
		if (display != 'none' && halftd.classList.contains('itemName')) {
			itemNameTdTapped(halftd, event)
			return
		}
		var dataID = halftd.getAttribute('data-id');
		if (display == 'none' || dataID == undefined || dataID == '' || logData[dataID] == undefined) {
			return
		}
		dataTdTapped(halftd, event)
	}
	
	function itemNameTdTapped(tdDom, event){
		if (event.target.className.indexOf('fixed') != -1) {
			mui.toast('该选中项目已锁定');
			return;
		}
		var itemPopover = document.getElementById('itemPopover');
		if (!itemPopover.classList.contains('mui-active')) {
			clearInterval(bedTimer);
			bedTimer = undefined;
			getLogItems();
		}
		filterHalfBedData(undefined, undefined, 'showAllBed');
		oneLogItemTapped(tdDom.getAttribute('data-order'));
	}
	
	function dataTdTapped(tdDom, event){
		var classStr = event.target.getAttribute('class')
		if (event && event.target.tagName != "TD" && classStr != "noBreak"&& classStr != "allergys" && classStr.indexOf('loc')==-1&&classStr!="totalSelfDef") {
			return;
		}
		
		if (tdDom.classList.contains('itemName')) {
			return
		}
		var itemPopover = document.getElementById('itemPopover');
		if (itemPopover.classList.contains('mui-active')) {
			closeItemPopover();
		}
		var parentNode = event.target.parentNode
		if (classStr.indexOf('pinci') != -1){ 
			//点击的是频次或者频次的床号
			validTdTapped(tdDom,parentNode);
		}else if (classStr == "noBreak" && parentNode&&parentNode.getAttribute('class').indexOf('pinci') != -1) {
			///点击的是频次中的noBreak
			classStr = parentNode.getAttribute('class')
			validTdTapped(tdDom,parentNode.parentNode);
		}else if (classStr.indexOf('loc') !=-1 && parentNode&&parentNode.getAttribute('class').indexOf('pinci') != -1) {
			///点击的是频次中的noBreak
			classStr = parentNode.getAttribute('class')
			validTdTapped(tdDom,parentNode.parentNode);
		}else{
			validTdTapped(tdDom);
		}
		if (!tdDom.classList.contains('chosen')) {
			return
		}
		if (tdDom.getAttribute('data-scoreType')=='1') { 
			showLogDataToop(tdDom)
		}
	}
	
	function logManualIconTapped(){
		hideToop();
		hideLogDataToop()
		var tdid = this.getAttribute('data-td');
		var bedsArr = logData[tdid]['beds']
		var ManualPopover = document.getElementById('ManualPopover');
		ManualPopover.setAttribute('data-td', tdid);
		updateManualPopoverSelectUI(this,logData[tdid]);
		var itemPopover = document.getElementById('itemPopover');
		if (itemPopover.classList.contains('mui-active')) {
			closeItemPopover(true)
		}
		//mui('#ManualPopover').popover('toggle')
		showOrHideDHCpopover('ManualPopover','show')
		if (bedTimer) {
			clearInterval(bedTimer);
			bedTimer = undefined;
		}
	}
	
	function dealBedsWidthRealWardArr(bedsArr,show,way,halfTd,allTd,selfDefT,isScoreType){
		if (bedsArr && bedsArr != ''&& !(bedsArr instanceof Array)) {  //血压/血糖类
			dealPinciBedsWidthRealWardArr(bedsArr,show,way,halfTd,allTd,isScoreType)
			return
		}
		var manulIcon=''
		if (way == 'M') {
			manulIcon = '<div class="iconfont iconyumao manualIcon" data-td="'+halfTd.getAttribute('data-id')+'"></div>'
		}
		if (!bedsArr || bedsArr == '' || bedsArr.length == 0) {
			//添加一下备注
			var str = ''
			if (selfDefT!= undefined) {
				str = selfDefT;
			}
			
			if (way == 'M' && str != '') {
				halfTd.innerHTML = '<div class="totalSelfDef">【'+str+'】</div>'+manulIcon;
				allTd.innerHTML = '<div class="totalSelfDef">【'+str+'】</div>'+manulIcon;
			}else{
				halfTd.innerHTML = str+manulIcon
				allTd.innerHTML = str+manulIcon
			}
			halfTd.setAttribute('data-title', "");
			return;
		}
		var bedStrArr = new Array(realWardArr.length);
		var scoreArr= new Array(realWardArr.length);
		for (var j = 0; j < bedsArr.length; j++) {
			var oneB = bedsArr[j];
			if (oneB['bed']==undefined || oneB['bed'] == "") {//只有就诊号,没有床号
				continue
			}
			var selfDef = ''
			if (way == 'M'){
				selfDef = oneB['selfDef']!= undefined?oneB['selfDef']:''
			}
			
			if (!oneB['currLocId']) {//空床
				if (bedStrArr[0] == undefined) {
					bedStrArr[0] = ""
				}
				bedStrArr[0] += '<div class="noBreak">'+oneB['bed']+',</div>';
				continue
			}
			var allergyStr = oneB['allergys']
			for(var k = 0; k < realWardArr.length;k++){
				if (bedStrArr[k] == undefined) {
					bedStrArr[k] = ""
				}
				if (scoreArr[k] == undefined) {
					scoreArr[k] = ""
				}
				if (realWardArr.length == 1 || oneB['currLocId'] == realWardArr[k]['currLocId']) {
					
					if (allergyStr != undefined && allergyStr.length != 0) {
						bedStrArr[k] += '<div class="noBreak">'+oneB['bed']+'</div><span class="allergys">'+allergyStr+'</span>,<br>';
					}else if(way != 'M'){
						bedStrArr[k] += '<div class="noBreak">'+oneB['bed']+',</div>';
					}else{
						bedStrArr[k] += '<div class="noBreak">'+oneB['bed']+'</div>'
						if (selfDef!= "") {
							bedStrArr[k] += '('+selfDef+')';
						}
						bedStrArr[k] += '，'
					}
					if (isScoreType == '1') {
						scoreArr[k] += '<div class="noBreak">'+oneB['bed']+'床：'+oneB['score']+'；</div>';
					}
				}
			}
		}
		var countArr = [];
		var fullCount = 0;
		var bedStr = "",countStr="",wardCountStr="",scoreStr="";
		for(var k = 0; k < bedStrArr.length;k++){
			var oneStr =  bedStrArr[k]==undefined?"": bedStrArr[k]
			var oneCount = 0
			if (oneStr != "") {
				oneCount = oneStr.split('</div>').length - 1
			}
			countArr[k] = oneCount;
			fullCount += oneCount;
			if (oneCount == 0) {
				continue;
			}
			if (bedStr != "") {
				// bedStr += ',';
				countStr += ',';
				wardCountStr += '<br/>'
			}
			var locClass = 'loc'+k
			var linkType = realWardArr[k]['linkType']
			if (linkType != '1') {
				locClass = 'locOther'
			}
			bedStr += '<span class="'+locClass+'">'+ oneStr + '</span>';
			countStr += '<span class="'+locClass+'">'+ oneCount + '人</span>';
			wardCountStr += '<span class="'+locClass+'">'+realWardArr[k]['locDesc']+ oneCount + '人</span>';
			if (isScoreType == '1') { //带分值的
				scoreStr += '<span class="'+locClass+'">'+ (scoreArr[k]==undefined?'':scoreArr[k]) + '</span>';
			}
		}
		if (realWardArr.length == 1) { //只有一个科室时
			bedStr = oneStr
			countStr = oneCount+'人'
			wardCountStr = realWardArr[0]['locDesc']+ oneCount + '人';
			if (isScoreType == '1') { //带分值的
				scoreStr = scoreArr[0]
			}
		}
		var douIndex = bedStr.lastIndexOf(',</div>') //此处去掉最后一个逗号
		if (douIndex != -1) {
			bedStr = bedStr.substring(0,douIndex) + '</div></span>'
		}else{
			douIndex = bedStr.lastIndexOf(',<br><span>') //过敏的
			if (douIndex != -1) {
				bedStr = bedStr.substring(0,douIndex) + '<br></span>'
			}else{
				douIndex = bedStr.lastIndexOf(',<br>') //只有第一个loc有过敏数据的
				if (douIndex != -1) {
					bedStr = bedStr.substring(0,douIndex)
				}
			}
		}
		if (way =='M'&&bedStr.lastIndexOf('，') != -1) {
			bedStr = bedStr.substring(0,bedStr.lastIndexOf('，'))
		}

		if (fullCount == 0) {
			halfTd.innerHTML = ""+manulIcon;
			halfTd.setAttribute('data-title', "");
			allTd.innerHTML = ""+manulIcon;
			return;
		}
		halfTd.setAttribute('data-title', wardCountStr);
		if (isScoreType == '1') {
			halfTd.setAttribute('data-title', scoreStr);
			halfTd.setAttribute('data-scoreType', isScoreType);
		}
		if (way == 'M' && selfDefT != "") {
			countStr = '<div class="totalSelfDef">【'+selfDefT+'】</div>'+countStr+manulIcon 
			bedStr = '<div class="totalSelfDef">【'+selfDefT+'】</div>'+bedStr+manulIcon
		}
		if (show == "N") {
			halfTd.innerHTML = countStr +'<span class="bedCount">'+fullCount+'</span>'+manulIcon;
			allTd.innerHTML = countStr +'<span class="bedCount">'+fullCount+'</span>'+manulIcon;
		}else{
			halfTd.innerHTML = bedStr +'<span class="bedCount">'+fullCount+'</span>'+manulIcon;
			allTd.innerHTML = bedStr +'<span class="bedCount">'+fullCount+'</span>'+manulIcon;
		}
	}
	
	function dealPinciBedsWidthRealWardArr(bedsDict,show,way,halfTd,allTd,isScoreType){
		if (getJsonLength(bedsDict) < 2 || bedsDict['type'] != 'json') { //只有通过方法获取的才处理
			halfTd.innerHTML = '';
			halfTd.setAttribute('data-title', "");
			allTd.innerHTML = '';
			return;
		}
		
		var fullCount = 0;
		var fullBedStr="";
		var titleArr = [];
		for (var pinci in bedsDict){
			if (pinci == 'type') {
				continue
			}
			var bedsArr = bedsDict[pinci]
			if (bedsArr == '' || bedsArr.length == 0) {
				continue
			}
			var pinciCount=0
			var bedStrArr = new Array(realWardArr.length);
			for (var j = 0; j < bedsArr.length; j++) {
				var oneB = bedsArr[j];
				if (oneB['bed']==undefined || oneB['bed'] == "") {//只有就诊号,没有床号
					continue
				}
				if (!oneB['currLocId']) {//空床
					continue
				}
				for(var k = 0; k < realWardArr.length;k++){
					if (bedStrArr[k] == undefined) {
						bedStrArr[k] = ""
					}
					if (realWardArr.length == 1 || oneB['currLocId'] == realWardArr[k]['currLocId']) {
						bedStrArr[k] += '<div class="noBreak">'+oneB['bed']+',</div>';
					}
				}
			}
			var bedStr = "",countStr="",wardCountStr="";
			for(var k = 0; k < bedStrArr.length;k++){
				var oneStr =  bedStrArr[k]==undefined?"": bedStrArr[k]
				var oneCount = 0
				if (oneStr != "") {
					oneCount = oneStr.split('</div>').length - 1
				}
				fullCount += oneCount;
				pinciCount += oneCount;
				if (oneCount == 0) {
					continue;
				}
				if (bedStr != "") {
					// bedStr += ',';
					countStr += ',';
					wardCountStr += '<br>'
				}
				var locClass='loc'+k
				var linkType = realWardArr[k]['linkType']
				if (linkType != '1') {
					locClass = 'locOther'
				}
				bedStr += '<span class="'+locClass+'">'+ oneStr + '</span>';
				countStr += '<span class="'+locClass+'">'+ oneCount + '人</span>';
				wardCountStr += '<span class="'+locClass+'">'+realWardArr[k]['locDesc']+ oneCount + '人</span>';
			}
			if (realWardArr.length == 1) { //只有一个科室时
				bedStr = oneStr
				countStr = oneCount+'人'
				wardCountStr = realWardArr[0]['locDesc']+ oneCount + '人';
			}
			titleArr.push(wardCountStr)
			var douIndex = bedStr.lastIndexOf(',</div>') //此处去掉最后一个逗号
			if (douIndex != -1) {
				bedStr = bedStr.substring(0,douIndex) + '</div></span>'
			}
			if (show == 'N') { //显示总数
				fullBedStr += '<tr data-id="'+pinci+'">'+
					'<td class="pinci">'+pinci+'</td>'+
					'<td class="pinciBed">'+countStr+'<span class="bedCount">'+pinciCount+'</span></td></tr>'  //表格形式
			}else{ //显示床号
				fullBedStr += '<tr data-id="'+pinci+'">'+
					'<td class="pinci">'+pinci+'</td>'+
					'<td class="pinciBed">'+bedStr+'<span class="bedCount">'+pinciCount+'</span></td></tr>'
			}
		}
	
		fullBedStr = '<div class="tdTable"><table border="0"><colgroup><col width="30%"><col width="70%"></colgroup><tbody>'+fullBedStr+
			'</tbody></table></div>'
		if (fullCount == 0) {
			halfTd.innerHTML = "";
			halfTd.setAttribute('data-title', "");
			allTd.innerHTML = "";
			return;
		}
		halfTd.innerHTML = fullBedStr
		allTd.innerHTML = fullBedStr
		halfTd.style.padding='0'
		allTd.style.padding='0'
		var titleDoms = halfTd.querySelectorAll('td.pinciBed')
		for (var i = 0; i < titleDoms.length;i++) {
			titleDoms[i].setAttribute('data-title',titleArr[i]);
		}
	}
	//父子项目单元格点击
	function oneLogItemTapped(dataOrder) {
		var itemPopover = document.getElementById('itemPopover');
		itemPopover.setAttribute('data-td', dataOrder);
		var logArea = document.getElementById(logAreaId);
		var chosen = logArea.querySelector('td.chosen');
		if (chosen) {
			chosen.classList.remove('chosen')
		}
		var pinciChosen = logArea.querySelector('.pinciChosen');
		if (pinciChosen) {
			pinciChosen.classList.remove('pinciChosen')
		}
		
		var thisDom = logArea.querySelector('td[data-order="' + dataOrder + '"]');
		thisDom.classList.add('chosen');

	}
	//跳转下一个父子项目单元格
	function gotoNextItem() {
		var logArea = document.getElementById(logAreaId);
		var itemPopover = document.getElementById('itemPopover');
		var tdOrder = itemPopover.getAttribute('data-td');
		var tdDom = logArea.querySelector('td[data-order="' + tdOrder + '"]');
		var idArr = tdOrder.split('-');
		var colIndex = parseInt(idArr[1])
		var rowIndex = parseInt(idArr[0])
		var rowSpan = 1;
		if (tdDom.rowSpan && tdDom.rowSpan != '') {
			rowSpan = parseInt(tdDom.rowSpan);
		}
		var colSpan = 1;
		if (tdDom.colSpan && tdDom.colSpan != '') {
			colSpan = parseInt(tdDom.colSpan);
		}
		var nextId = '';
		var parentOrder = tdDom.getAttribute('data-parent');
		var isLast = tdDom.getAttribute('data-last');
		if (parentOrder && parentOrder != '') { //子节点
			var parentDom = logArea.querySelector('td[data-order="' + parentOrder + '"]');
			var pRowSpan = 1;
			var pColSpan = 1;
			if (parentDom.rowSpan && parentDom.rowSpan != '') {
				pRowSpan = parseInt(parentDom.rowSpan);
			}
			if (parentDom.colSpan && parentDom.colSpan != '') {
				pColSpan = parseInt(parentDom.colSpan);
			}
			var pArr = parentOrder.split('-')
			var pRowIndex = parseInt(pArr[0])
			var pColIndex = parseInt(pArr[1])
			if (isLast == '1') { //子节点中的最后一个 找父节点的下方
				for (var row = pRowIndex + pRowSpan; row < rowNum; row++) {
					var next = logArea.querySelector('td[data-order="' + row + '-' + pColIndex + '"]');
					var nextDisplay = next.style.display
					if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
						continue
					}
					nextId = row + '-' + pColIndex;
					if (next.classList.contains('fixed')) { //固定项
						itemPopover.setAttribute('data-td', nextId);
						gotoNextItem();
						return;
					}
					break;
				}
				if (nextId == '') { //下一列
					for (var col = colIndex + colSpan; col < colNum; col++) {
						var next = logArea.querySelector('td[data-order="' + 0 + '-' + col + '"]');
						var nextDisplay = next.style.display
						if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
							continue
						}
						nextId = '0-' + col;
						break;
					}
					if (nextId != '') { //有下一列 判断是不是固定项
						var next = logArea.querySelector('td[data-order="' + nextId + '"]');
						if (next.classList.contains('fixed')) { //是固定项
							itemPopover.setAttribute('data-td', nextId);
							gotoNextItem();
							return;
						}
					}
				}
			} else { //不是最后一项
				for (var row = rowIndex + rowSpan; row < pRowIndex + pRowSpan; row++) {
					var next = logArea.querySelector('td[data-order="' + row + '-' + colIndex + '"]');
					var nextDisplay = next.style.display
					if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
						continue
					}
					nextId = row + '-' + colIndex;
					if (next.classList.contains('fixed')) { //固定项
						itemPopover.setAttribute('data-td', nextId);
						gotoNextItem();
						return;
					}
					break;
				}
			}
		} else if (rowSpan > 1) { //父节点或普通节点
			//查找右边 确定是父节点还是普通节点
			var next = logArea.querySelector('td[data-order="' + rowIndex + '-' + (colIndex + colSpan) + '"]');
			var nextDisplay = next.style.display
			if (!next.classList.contains('itemName')) { //普通节点 往下查找
				for (var row = rowIndex + rowSpan; row < rowNum; row++) {
					var next = logArea.querySelector('td[data-order="' + row + '-' + colIndex + '"]');
					var nextDisplay = next.style.display
					if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
						continue
					}
					nextId = row + '-' + colIndex;
					if (next.classList.contains('fixed')) { //固定项
						itemPopover.setAttribute('data-td', nextId);
						gotoNextItem();
						return;
					}
					break;
				}
				if (nextId == '') { //下一列
					for (var col = colIndex + colSpan; col < colNum; col++) {
						var next = logArea.querySelector('td[data-order="' + 0 + '-' + col + '"]');
						var nextDisplay = next.style.display
						if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
							continue
						}
						nextId = '0-' + col;
						break;
					}
					if (nextId != '') { //有下一列 判断是不是固定项
						var next = logArea.querySelector('td[data-order="' + nextId + '"]');
						if (next.classList.contains('fixed')) { //是固定项
							itemPopover.setAttribute('data-td', nextId);
							gotoNextItem();
							return;
						}
					}
				}
			} else { //父节点 往右
				nextId = rowIndex + '-' + (colIndex + colSpan);
				var next = logArea.querySelector('td[data-order="' + nextId + '"]');
				if (next.classList.contains('fixed')) { //固定项
					itemPopover.setAttribute('data-td', nextId);
					gotoNextItem();
					return;
				}
			}
		} else { //普通节点
			if (rowIndex == rowNum - 1) { //最后一行 在下一列查找
				for (var col = colIndex + colSpan; col < colNum; col++) {
					var next = logArea.querySelector('td[data-order="' + 0 + '-' + col + '"]');
					var nextDisplay = next.style.display
					if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
						continue
					}
					nextId = '0-' + col;
					if (next.classList.contains('fixed')) { //固定项
						itemPopover.setAttribute('data-td', nextId);
						gotoNextItem();
						return;
					}
					break;
				}
			} else {
				for (var row = rowIndex + rowSpan; row < rowNum; row++) {
					var next = logArea.querySelector('td[data-order="' + row + '-' + colIndex + '"]');
					var nextDisplay = next.style.display
					if (nextDisplay == 'none' || !next.classList.contains('itemName')) {
						continue
					}
					nextId = row + '-' + colIndex;
					if (next.classList.contains('fixed')) { //固定项

						itemPopover.setAttribute('data-td', nextId);
						gotoNextItem();
						return;
					}
					break;
				}
			}
		}
		//console.log(nextId)
		if (nextId.length == 0) {
			// console.log('已经是最后一个了')
			var chosen = logArea.querySelector('.chosen');
			itemPopover.setAttribute('data-td', chosen.getAttribute('data-order'));
		}
		if (nextId.length > 1) {
			oneLogItemTapped(nextId);
		}
	}

	function validTdTapped(tdDom,pinciTrDom) {
		var halfLogScroll = document.getElementById('halfLogScroll');
		var validTd = halfLogScroll.querySelector('.chosen');
		if (validTd && validTd != tdDom) {
			validTd.classList.remove('chosen');
			//清除频次选中
			var pinciChosen = validTd.querySelector('.pinciChosen')
			if (pinciChosen) {
				pinciChosen.classList.remove('pinciChosen');
			}
		}

		var tdid = tdDom.getAttribute('data-id');
		if (tdDom.classList.contains('chosen')) {
			//清除频次选中
			var pinciChosen = tdDom.querySelector('.pinciChosen')
			if (pinciChosen && pinciTrDom != pinciChosen) {
				pinciChosen.classList.remove('pinciChosen');
			}
			if (pinciTrDom && !pinciTrDom.classList.contains('pinciChosen')) {
				pinciTrDom.classList.add('pinciChosen');
				filterHalfBedData(tdDom, tdid,undefined,pinciTrDom.getAttribute('data-id'));
			}else{
				tdDom.classList.remove('chosen');
				var pinciChosen = validTd.querySelector('.pinciChosen')
				if (pinciChosen) {
					pinciChosen.classList.remove('pinciChosen');
				}
				filterHalfBedData(tdDom, tdid, 'showAllBed');	
			}
		} else {
			tdDom.classList.add('chosen');
			if (pinciTrDom) {
				pinciTrDom.classList.add('pinciChosen');
				filterHalfBedData(tdDom, tdid,undefined,pinciTrDom.getAttribute('data-id'));
			}else{
				filterHalfBedData(tdDom, tdid);
			}
		}
	}

	function filterHalfBedData(dom, tdid, showAllBed,pinci) {
		hideToop();
		var bedMap = document.getElementById('bedMap');
		if (showAllBed) {
			hideBedMapNullDom('bedMap','');
			//hiddenNULLByElementId('halfbedNull');
			bedMap.classList.remove('bedFilter');
			bedMap.classList.remove('specicalFilter');
			var hiddens = bedMap.querySelectorAll('.selected');
			for (var i = 0; i < hiddens.length; i++) {
				var oneHide = hiddens[i];
				oneHide.classList.remove('selected');
				var specials = oneHide.querySelectorAll('.special');
				for (var j = 0; j < specials.length; j++) {
					var baseInfo = oneHide.querySelector('.baseInfo')
					baseInfo.removeChild(specials[j]);
				}
			}
			if (bedMap.querySelectorAll('.halfBed').length == 0) {
				var bedMapNulls = document.querySelectorAll('#bedMap .nullData');
				for (var i = 0; i < bedMapNulls.length;i++) {
					showNULLByElementId(bedMapNulls[i].id, '没有床位');
				}
			}
			return;
		} else {
			var wrapper = bedMap.querySelectorAll('.halfBedWrapper')
			for (var i = 0; i < wrapper.length;i++) {
				$('#'+wrapper[i].id).scroll().scrollTo(0, 0, 100);
			}
			bedMap.classList.add('bedFilter');
		}
		var isSpecial = false;
		var specicalDict = undefined;
		if (specicalFilter && specicalFilter[tdid]) {
			isSpecial = true;
			specicalDict = specicalFilter[tdid]
			bedMap.classList.add('specicalFilter');
		} else {
			bedMap.classList.remove('specicalFilter');
		}

		var bedArr = dom.innerText.split(',');
		var dict = logData[tdid];
		//清除原来的
		var hiddens = bedMap.querySelectorAll('.selected');
		for (var i = 0; i < hiddens.length; i++) {
			var oneHide = hiddens[i];
			oneHide.classList.remove('selected');
			var specials = oneHide.querySelectorAll('.special');
			for (var j = 0; j < specials.length; j++) {
				var baseInfo = oneHide.querySelector('.baseInfo')
				baseInfo.removeChild(specials[j]);
			}
		}
		if (bedResult == undefined) {
			return;
		}
		//hiddenNULLByElementId('halfbedNull');
		var beds = dict['beds'];
		if (pinci) {
			beds = dict['beds'][pinci];
		}
		if (beds.length > 0) {
			for (var i = 0; i < beds.length; i++) {
				var bedDoms;
				var epid = beds[i]['episodeID'];
				var bedCode = beds[i]['bed'];
				if(epid){
					bedDoms = bedMap.querySelectorAll('.halfBed[data-epid="' + epid + '"]');
				}else{
					bedDoms = bedMap.querySelectorAll('.halfBed[data-code="' + bedCode + '"]');
				}
				for (var j = 0; j < bedDoms.length; j++) {
					var bedDom = bedDoms[j]
					if (!epid && bedDom.getAttribute('data-epid')!= undefined) {
						continue
					}
					bedDom.classList.add('selected');
					if (!isSpecial) {
						continue;
					}
					var index = parseInt(bedDom.getAttribute('data-index'));
					var baseInfo = bedDom.querySelector('.baseInfo')
					var domKey = document.createElement('div');
					var domValue = document.createElement('div');
					baseInfo.appendChild(domKey);
					baseInfo.appendChild(domValue);
					domKey.classList.add('im');
					domKey.classList.add('special');
					domKey.classList.add('key');
					
					domValue.classList.add('im');
					domValue.classList.add('special');
					domValue.classList.add('value');
					var oneDict = bedResult[index];
					var patient = oneDict['patient'];
					var desc = specicalDict['desc'];
					var key = specicalDict['key'];
					domValue.setAttribute('data-title', patient[key]);
					domValue.innerHTML = '';
					if(patient[key]){
						domValue.innerHTML = patient[key];
					}
					domKey.innerHTML = desc + '：';
					
				}
			}
			var bedMapContent = document.querySelectorAll('#bedMap .mui-control-content');
			for (var i = 0; i < bedMapContent.length;i++) {
				var selectDom = bedMapContent[i].querySelector('.halfBed.selected')
				if (!selectDom) {
					showNULLByElementId(bedMapContent[i].id+'-null', '没有相关床位');
				}else{
					hiddenNULLByElementId(bedMapContent[i].id+'-null');
				}
			}
		} else {
			//showNULLByElementId('halfbedNull', '没有相关床位');
			var bedMapNulls = document.querySelectorAll('#bedMap .nullData');
			for (var i = 0; i < bedMapNulls.length;i++) {
				showNULLByElementId(bedMapNulls[i].id, '没有相关床位');
			}
		}
	}

	//获取床位卡配置
	function getBedCardConfig() {
		var xmlStr = {
			'HospID': hospID,
			'WardID': realWardId
		};
		configXHR=$.DHCWebService('GetBedCardConfig', xmlStr, function(result) {
			configXHR=null
			if (result.length == 0) {
				hideToast();
				var str = '未配置床位卡';
				iziToast.error({
					class: 'noConfig',
					color: '#41bbff',
					title: str,
					position: 'center',
					timeout: 1500,
					transitionOut: 'flipOutX',
					close: true,
				});
			}
			configJson = jsonSort(result, 'order'); //按照后台order字段排序
			emptyBedInfoHtml = getBaseInfoHtml(undefined,true)
			getBedCard();
		}, function(errorStr) {
			configXHR=null
			if (errorStr == "中断") {
				hideToast();
				return
			}
			getBedCard();
		});
	}
	//获取床位图
	function getBedCard() {
		var xmlStr = {
			'HospitalID': hospID,
			'WardID': realWardId
		};
		bedXHR = $.DHCWebService('GetBedCard', xmlStr, function(result) {
			bedXHR=null
			hideToast();
			bedResult = result;
			clearBedTap()
			if (bedResult != 0 && bedResult.length > 0) {
				hideBedMapNullDom("","");
				updateHalfAndAllBedsUI()
				getAllBedIcons()
			}else{
				document.getElementById('bedMapLocs').innerHTML = "";
				document.getElementById('bedMapContainer').innerHTML = '<div id="TempBedMapNull" class="nullData">'+
					'<div class="nullImage"></div><div class="nullTip"></div></div>';
				document.getElementById('manualSegScroll').innerHTML = "";
				document.getElementById('manualBedMap').innerHTML = '<div id="TempManualNull" class="nullData">'+
					'<div class="nullImage"></div><div class="nullTip"></div></div>';
				document.getElementById('allBedScroll').innerHTML = "";
				showNULLByElementId("TempBedMapNull","没有床位");
				showNULLByElementId("TempManualNull","没有床位");
				showNULLByElementId("allbedNull","没有床位");
			}
		}, function(errorStr) {
			bedXHR=null
			hideToast();
			bedResult = undefined;
			if (errorStr == "中断") {
				return
			}
			clearBedTap()
			var bedMapScrolls = document.querySelectorAll('#bedMap .mui-scroll')
			var allBedScroll = document.getElementById('allBedScroll')
			var manualbedMapScrolls = document.querySelectorAll('#manualBedMap .mui-scroll')
			for (var i = 0; i < bedMapScrolls.length;i++) {
				bedMapScrolls[i].innerHTML = ''
				manualbedMapScrolls[i].innerHTML = ''
			}
			allBedScroll.innerHTML = '';
			showBedMapNullDom("","",errorStr);
		});
	}

	function updateHalfAndAllBedsUI() {
		if (bedResult == undefined) {
			return;
		}
		var activeId = ''
		var oldActive = document.querySelector('#bedMapContainer .mui-control-content.mui-active');
		if (oldActive) {
			var oldActiveIdArr = oldActive.id.split('-');
			oldActiveIdArr.splice(0, 1)
			activeId = oldActiveIdArr.join('-')
		}else if (realWardArr.length > 0) {
			activeId = realWardArr[0]['wardId']
		}else{
			activeId = realWardId
			realWardArr = [{'wardId':realWardId,'currLocId':'','locDesc':'','linkType':'1'}]
		}
		var bedMap = document.getElementById('bedMap')
		var ManualPopover = document.getElementById('ManualPopover');
		if (realWardArr.length > 1) {
			bedMap.classList.add('mulSeg')
			ManualPopover.classList.add('mulSeg')
		}else{
			bedMap.classList.remove('mulSeg')
			ManualPopover.classList.remove('mulSeg')
		}
		clearBedMapImg()
		var bedMapContainer =  $('#bedMapContainer')[0]
		var manualBedMap =  $('#manualBedMap')[0]
		var bedMapLocs = $('#bedMapLocs')[0]
		var manualSegScroll = $('#manualSegScroll')[0]
		bedMapLocs.innerHTML = "";
		bedMapContainer.innerHTML = "";
		manualSegScroll.innerHTML = "";
		manualBedMap.innerHTML = "";
		document.getElementById('allBedScroll').innerHTML = "";
		setupBedTap()
		var mauHtml = ''
		var mauSegHtml = ''
		var bedSegHtml = ''
		var bedHtml = ''
		var halfBedHtmlArr = [];
		var mauHtmlArr = []
		for (var i = 0; i < realWardArr.length;i++) {
			var oneReal=realWardArr[i]
			if (oneReal['out'] == "1") {
				continue
			}
			halfBedHtmlArr[i]=''
			mauHtmlArr[i] = ''
			var newItemIdId = oneReal['wardId'] + '-'+ oneReal['currLocId']
			if (i == 0) {
				newItemIdId = oneReal['wardId']
			}
			var active = ''
			if (newItemIdId == activeId) {
				active = ' mui-active'
			}
			mauHtml += '<div data-index="'+i+'" class="mui-control-content '+active+'" id="manualBedMap-'+newItemIdId+'">'+
				'<div id="manualBedMap-'+newItemIdId+'-wrapper" class="mui-scroll-wrapper manualWrapper">'+
					'<div id="manualBedMap-'+newItemIdId+'-scroll" class="mui-scroll mui-scroll-iPhone"></div></div></div>'
			bedHtml += '<div data-index="'+i+'" class="mui-control-content '+active+'" id="bedMapContainer-'+newItemIdId+'">'+
				'<div class="nullData" id="bedMapContainer-'+newItemIdId+'-null"><div class="nullImage"></div><div class="nullTip"></div></div>'+
				'<div id="bedMapContainer-'+newItemIdId+'-wrapper" class="mui-scroll-wrapper halfBedWrapper">'+
					'<div id="bedMapContainer-'+newItemIdId+'-scroll" class="mui-scroll mui-scroll-iPhone"></div></div></div>'
			var locClass = ''
			if (oneReal['linkType'] != '1') {
				locClass = 'locOther'
			}else{
				locClass = 'loc' + i
			}
			mauSegHtml += '<a class="mui-control-item '+active+' '+locClass+'" id="bedMapLocs-'+newItemIdId+'" href="#manualBedMap-'+newItemIdId+'">'+oneReal['locDesc']+'</a>'
			bedSegHtml += '<a class="mui-control-item '+active+' '+locClass+'" id="manualSegScroll-'+newItemIdId+'" href="#bedMapContainer-'+newItemIdId+'">'+oneReal['locDesc']+'</a>'
		}
		bedMapContainer.innerHTML = bedHtml
		manualBedMap.innerHTML = mauHtml;
		bedMapLocs.innerHTML = bedSegHtml
		manualSegScroll.innerHTML = mauSegHtml
		
		var bedMapLocsHeight = bedMapLocs.clientHeight
		bedMapContainer.removeAttribute('style')
		if (bedMapLocsHeight> 10) {
			bedMapContainer.style.top = bedMapLocsHeight + 'px'
			bedMapContainer.style.height = 'calc(100% - '+(bedMapLocsHeight - 10)+'px)'
		}
		if (!document.querySelector('#bedMapContainer .mui-control-content.mui-active')) {
			document.querySelector('#bedMapLocs .mui-control-item').classList.add('mui-active')
			document.querySelector('#manualBedMap .mui-control-content').classList.add('mui-active')
			document.querySelector('#manualSegScroll .mui-control-item').classList.add('mui-active')
			document.querySelector('#bedMapContainer .mui-control-content').classList.add('mui-active')
		}
		var allHtml = ''
		for (var i = 0; i < bedResult.length; i++) {
			var onePat = bedResult[i];
			var patient = onePat['patient'];
			var isEmptyBed = true
			var index = 0
			if (patient && getJsonLength(patient) > 0) {//有患者信息
				isEmptyBed = false;
				var currLocId = onePat['patient']['currLocID']+''
				var dom = document.getElementById('bedMapContainer-'+realWardId+'-'+currLocId)
				if (dom) {//接收的是别的科室的
					index = dom.getAttribute('data-index')
				}
			}
			if (onePat['unavailReason'] && onePat['unavailReason'].length > 0) {
				index = 0
			}
			var oneBedHtml = getOneBedHtml(onePat,'halfBed',i,isEmptyBed)
			halfBedHtmlArr[index] += oneBedHtml
			mauHtmlArr[index] += getOneManualBedHtml(onePat)
			allHtml += oneBedHtml.replace('halfBed','oneBed');
		}
		allBedScroll.innerHTML = allHtml
		//清除字符串变量
		allHtml = ''
		mui('#bedMapContainer .mui-scroll').each(function (index,element) {
			element.innerHTML = halfBedHtmlArr[index]
		})
		mui('#manualBedMap .mui-scroll').each(function (index,element) {
			element.innerHTML = mauHtmlArr[index]
		})
		halfBedHtmlArr.splice(0,halfBedHtmlArr.length)
		mauHtmlArr.splice(0,mauHtmlArr.length)
		//去掉多余的ControlContent
		$('.mui-scroll-wrapper').scroll({
			bounce: true,
			indicators: true, //是否显示滚动条
		});
		
		var halfLogScroll = document.getElementById('halfLogScroll');
		var chosenTD = halfLogScroll.querySelector('.chosen')
		if (chosenTD) {
			chosenId = chosenTD.getAttribute('data-id');
			if (chosenId && chosenId != '') {
				var pinciDom = chosenTD.querySelector('.pinciChosen')
				if (pinciDom) {
					filterHalfBedData(chosenTD, chosenId,undefined,pinciDom.getAttribute('data-id'));
				}else if (chosenTD.querySelector('.tdTable')) {
					chosenTD.classList.remove('chosen')
					filterHalfBedData(undefined, undefined, 'showAllBed');
				}else{
					filterHalfBedData(chosenTD, chosenId);
				}
			}else{
				filterHalfBedData(undefined, undefined, 'showAllBed');
			}
		} else {
			filterHalfBedData(undefined, undefined, 'showAllBed');
		}
		
		var ManualPopover = document.querySelector('#ManualPopover.mui-active')
		if (ManualPopover && logData) {
			var tdid = ManualPopover.getAttribute('data-td');
			updateManualPopoverSelectUI(document.getElementById(tdid),logData[tdid]);
		}
		//window.gc()
	}
	
	function hideBedMapNullDom(domId,locId){
		var bedMapNulls = document.querySelectorAll('#bedMap .nullData');
		if(domId != "" && locId){
			bedMapNulls = document.querySelectorAll('#'+domId+'-'+locId+'-null')
		}
		for (var i = 0; i < bedMapNulls.length;i++) {
			hiddenNULLByElementId(bedMapNulls[i].id);
		}
		if (domId == "" && document.getElementById('allbedNull')) {
			hiddenNULLByElementId('allbedNull');
		}
	}
	
	function showBedMapNullDom(domId,locId,errorStr){
		var bedMapNulls = document.querySelectorAll('#bedMap .nullData');
		if(domId != "" && locId != ""){
			bedMapNulls = document.querySelectorAll('#'+domId+'-'+locId+'-null')
		}
		for (var i = 0; i < bedMapNulls.length;i++) {
			showNULLByElementId(bedMapNulls[i].id, '床位图' + errorStr, 'error');
		}
		if (domId == "") {
			showNULLByElementId('allbedNull', '床位图' + errorStr, 'error');
		}
	}
	
	function bedDblclicked(){
		hideLogDataToop()
		var itemPopover = document.getElementById("itemPopover");
		if(itemPopover.classList.contains('mui-active')){
			return
		}
		getPatInfo(this);
	}
	function getPatInfo(card){
		var patResult = {};
		mui('#PatInfoPopover img').each(function (index,element) {
			element.src = ''
		})
		showOrHideDHCpopover('PatInfoPopover','show');
		var pop = document.getElementById("PatInfoPopover");
		//头部床位卡图标
		var sexImg = pop.querySelector('.sexImg img');
		sexImg.src = '../common/images/unknown.svg';
		var patImg = pop.querySelector('.patImg');
		patImg.innerHTML = '';
		var epID = card.getAttribute('data-epid');
		var sexStr = card.getAttribute('data-sexImg');
		if (sexStr) {
			sexImg.src = sexStr;
		}
		
		//头部信息文字
		var bedCode = pop.querySelector('.bedCode');
		var code = card.getAttribute('data-code');
		bedCode.innerText = code + '床';
		var infoName = pop.querySelector('.name');
		infoName.innerText = '该床暂无患者';
		var infoAge = pop.querySelector('.age');
		infoAge.innerText = '';
		var infoLoc = pop.querySelector('.ctLocDesc');
		infoLoc.innerText = '';
		var infoWard = pop.querySelector('.wardDesc');
		infoWard.innerText = '';
		var infoRoom = pop.querySelector('.roomDesc');
		infoRoom.innerText = card.getAttribute('which-room');
		updatePatPop(patResult);//恢复默认空数据
		if(!epID){
			return
		}
		var xmlStr = {
			EpisodeID: epID,
			HospitalID: hospID
		}
		$.DHCWebService('GetPatient', xmlStr, function(result) {
			if(result != patResult){
				var name = dealNamePrivate(result['name']);
				setPatInfo(infoName,name);
				infoName.setAttribute('data-patName',result['name'])
				setPatInfo(infoAge,result['age']);
				setPatInfo(infoLoc,result['ctLocDesc']);
				setPatInfo(infoWard,result['wardDesc']);
				setPatIcon(patImg,result['icons']);
				patResult = result;
				updatePatPop(patResult);
			}
		}, function(errorStr) {
			var str = "获取患者信息" + errorStr
			iziToast.error({
				class: 'loadError',
				color: '#41bbff',
				title: str,
				position: 'center',
				timeout: 800,
				transitionOut: 'flipOutX',
				close: true,
			});
		});
	}
	function updatePatPop(result) {
		setPatInput('medicareNo',result['medicareNo']);
		setPatInput('regNo',result['regNo']);
		setPatInput('insuranceCard',result['insuranceCard']);
		setPatInput('inHospDateTime',result['inHospDateTime']);
		setPatInput('inDeptDateTime',result['inDeptDateTime']);
		setPatInput('inDays',result['inDays']);
		setPatInput('mainDoctor',result['mainDoctor']);
		setPatInput('mainNurse',result['mainNurse']);
		setPatInput('wardDesc',result['wardDesc']);
		setPatInput('diagnosis',result['diagnosis']);
		setPatInput('allergys',result['allergys']);
		setPatInput('careLevel',result['careLevel']);
		setPatInput('illState',result['illState']);
		setPatInput('nation',result['nation']);
		setPatInput('personID',result['personID']);
		setPatInput('balance',result['balance']);
		setPatInput('totalCost',result['totalCost']);
		setPatInput('patLinkman',result['patLinkman']);
		setPatInput('telphone',result['telphone']);
		setPatInput('connectTel',result['connectTel']);
		setPatInput('RHBlood',result['RHBloodType']);
		setPatInput('bloodType',result['ABOBloodType']);
		setPatInput('homeAddres',result['homeAddres']);
	}
	function setPatInfo(ele, txt) {
		if(ele && txt!= ''){
			if(txt != undefined){
				ele.innerText = txt;
			}else{
				ele.innerText = '';
			}
		}
	}
	function setPatIcon(dom,iconArr) {
		if(iconArr && iconArr.length > 0){
			var imgBadgeInner = '';
			for(var j=0; j<iconArr.length; j++){
				var path = iconArr[j]['src'];
				var desc = iconArr[j]['title'];
				path = bedImageUrl + path;
				var imgDom = '<img data-title="' + desc + '" class="cardImg" src="' + path + '" >';
				imgBadgeInner += imgDom;
			}
			dom.innerHTML = imgBadgeInner;
		}
	}
	function setPatInput(id, txt) {
		var infoInput = document.getElementById(id);
		if(infoInput){
			if(txt != undefined){
				infoInput.value = txt;
			}else{
				infoInput.value = '';
			}
		}
	}
	
	function getOneManualBedHtml(one){
		var patInfo = one['patient'];
		var epid = patInfo['episodeID'] != undefined?patInfo['episodeID']:"";
		var name = dealNamePrivate(patInfo['name']);
		return '<div data-wardId="'+one['wardId']+'" data-epid="'+epid+'" class="bed"><div class="bedNo">' + one['code'] + '</div>'+
			'<div class="bedPat">' + name + '</div></div>';
	}
	
	function manualBedTapped(){
		var epid = this.getAttribute('data-epid');
		if (epid == '') {
			mui.toast('当前选择的是空床');
			return;
		}
		var classStr = this.getAttribute('class');
		var epid = this.getAttribute('data-epid');
		var selectedUl = document.getElementById('selectedUl');
		if (classStr.indexOf('selected') != -1) {
			this.classList.remove('selected');
			var str = '.selectedBed[data-epid="' + epid + '"]';
			var dom = selectedUl.querySelector(str);
			if (dom) {
				selectedUl.removeChild(dom.parentNode);
			}
		} else {
			this.classList.add('selected');
			refreshselectedUl();
		}
	}
	
	function getOneBedHtml(one, className, bedIndex,isEmptyBed) {
		var yzyStr = ''
		var unStr = ''
		var YuZhuYuanArr = one['BedAppInfo']; //获取预住院信息
		if (YuZhuYuanArr && YuZhuYuanArr.length > 0) {
			var yyzInfo = '';
			for (var i = 0; i < YuZhuYuanArr.length; i++) {
				yyzInfo += YuZhuYuanArr[i]['AppDate'] + '&nbsp;' + YuZhuYuanArr[i]['AppPat'];
				if (i != YuZhuYuanArr.length - 1) {
					yyzInfo += '<br>';
				}
			}
			yzyStr = '<div class="yuZhuYuan" data-name="yuzhuyuan"><img data-title="' + yyzInfo + '" class="yyzImage" src="../common/images/yu.svg" ></div>'
		}
		if (one['unavailReason']) {
			var unavailPatName = '';
			var unavailReason = '';
			var unavailDays = ''
			if(one['unavailReason']){
				unavailReason = one['unavailReason'] + '  ';
			}
			if(one['unavailPatName']){
				unavailPatName = one['unavailPatName'] + '  ';
			}
			if(one['unavailDays']){
				unavailDays = one['unavailDays'] + '天';
			}
			if (unavailReason || unavailPatName) {
				unStr = '<div class="unavailInfo">'+unavailPatName +  unavailReason + unavailDays+'</div>'
			}
		}
		var patInfo = one['patient'];
		var epid = patInfo['episodeID'];
		var epidStr = ''
		if (epid) {
			epidStr = 'data-epid="'+epid+'"'
		}
		html = ''
		if (isEmptyBed) {
			html = '<div class="'+className+'" data-code="'+one['code']+'" '+epidStr+' which-room="'+one['roomDesc']+'" data-index="'+bedIndex+'">'+
				yzyStr+
				'<div class="titleInfo"><span class="bedNum">' + one['code'] + '</span></div>'+
				'<div class="sexInfo"></div>'+
				'<div class="baseInfo">'+emptyBedInfoHtml+'</div>'+
				'<div class="imgBadge"><img style="opacity: 0; display: none;" class="cardImg"></div>'+unStr+
				'</div>'
			return html;
		}
		var titleHtml = '<div class="titleInfo"><span class="bedNum">' + one['code'] + '</span>'
		if (patInfo['careLevelColor']) {
			titleHtml = '<div class="titleInfo" style="background:'+patInfo['careLevelColor']+';color:#FFFFFF">'+
				'<span class="bedNum">' + one['code'] + '</span>'
		}
		var name = dealNamePrivate(patInfo['name']);
		titleHtml += '<span class="patName" data-title="'+name+'" data-patName="'+patInfo['name']+'">' + name + '</span>'+
			'<span class="inHospTime">'+patInfo['inDays']+'天</span></div>';
		var sexSrc = '../common/images/unknown.svg';
		if (patInfo['sex'] === '男') {
			sexSrc = '../common/images/male.svg';
		} else if (patInfo['sex'] === '女') {
			sexSrc = '../common/images/female.svg';
		}
		var sexClass = 'sex';
		if (ISMOBILE) {
			sexClass = 'sex mobile'
		}
		html = '<div class="'+className+'" data-code="'+one['code']+'" '+epidStr+' which-room="'+one['roomDesc']+'" data-sexImg="'+sexSrc+'" data-index="'+bedIndex+'">'+
			titleHtml +yzyStr+
			'<div class="sexInfo"><div class="' + sexClass + '"><img src="' + sexSrc+'"></div></div>'+
			'<div class="baseInfo" '+(unStr==""?'':'style="opacity:0"')+'>'+getBaseInfoHtml(patInfo,isEmptyBed)+'</div>'
		if (one['unavailReason']) {
			html += '<div class="imgBadge"><img style="opacity: 0; display: none;" class="cardImg"></div>'
		}else{
			html += '<div class="imgBadge"></div>'
		}
		html += unStr + '</div>';
		return html
	}
	
	function getBaseInfoHtml(patInfo,isEmptyBed){
		var html = ''
		for (var j = 0; j < configJson.length; j++) {
			var oneJS = configJson[j]
			if (oneJS.order <= 0) {
				continue
			}
			if (isEmptyBed){ //空床
				html += '<div class="im key"></div><div class="im value"></div>'
			}else{
				var value = patInfo[configJson[j].code]
				var dataStr = ''
				if (value == undefined || value == '') {
					value = '';
				} else {
					dataStr = 'data-title="'+value+'"'
				}
				html += '<div class="im key">'+oneJS.name+'：</div><div class="im value" '+dataStr+'>'+value+'</div>'
			}
		}
		return html
	}
	
	var modeSwitch = document.getElementById('modeSwitch');
	modeSwitch.addEventListener('toggle', function(event){
		//回到顶部
		var bedMap = document.getElementById('bedMap');
		var wrapper = bedMap.querySelectorAll('.halfBedWrapper')
		for (var i = 0; i < wrapper.length;i++) {
			$('#'+wrapper[i].id).scroll().scrollTo(0, 0, 100);
		}
		$('#allBedWrapper').scroll().scrollTo(0, 0, 100);
		if(event.detail.isActive) {
			$('#bedMap')[0].classList.add('simple')
			$('#fullBedMap')[0].classList.add('simple')
		} else {
			$('#bedMap')[0].classList.remove('simple')
			$('#fullBedMap')[0].classList.remove('simple')
		}
	});
	

	window.addEventListener('message', function(e) {
		var xhrArr = [logXHR,filterXHR,configXHR,,bedXHR,iconXHR]
		for (var i = xhrArr.length-1; i >= 0;i--) {
			if (xhrArr[i]) {
				xhrArr[i].abort()
			}
		}
		hideToop();
		//合并病区切换
		if(e.data.refreshType == 'ward'&& realWardId != e.data.wardId){
			realLocId = e.data.locId
			realWardId = e.data.wardId
			//关闭itemPopover/manualPopover/患者信息popover,去掉chosen
			closeItemPopover();
			showOrHideDHCpopover('ManualPopover','hide')
			showOrHideDHCpopover('PatInfoPopover','hide')

			var halfLogScroll = document.getElementById('halfLogScroll');
			var validTd = halfLogScroll.querySelector('.chosen');
			if (validTd && validTd != tdDom) {
				validTd.classList.remove('chosen');
			}
			var bedMap = document.getElementById('bedMap');
			bedMap.classList.remove('bedFilter');
			bedMap.classList.remove('specicalFilter');
			var toast = document.querySelector('.loadingBedData');
			if (!toast) {
				iziToast.show({
					class: 'loadingBedData',
					color: 'dark',
					title: '正在刷新床位',
					image: '../common/images/load.gif',
					position: 'center',
					timeout: null,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
			}
			getWardLogData();
			getAllNurse();
			getAllDoc();
			getSpecicalFilter();
			mui('#allLogWrapper').scroll().scrollTo(0,0,100);
			mui('#halfLogWrapper').scroll().scrollTo(0,0,100);
			mui('#nurseBedWrapper').scroll().scrollTo(0,0,100);
			mui('#docBedWrapper').scroll().scrollTo(0,0,100);
			mui('#allBedWrapper').scroll().scrollTo(0,0,100);
		}
		if (e.data.refreshType == 'ward') {
			return;
		}
		realLocId = e.data.locId
		realWardId = e.data.wardId
		changeDayNightMode(e.data.nightMode);
		if (e.data.refresh) {
			resetRefresh();
		} else if (e.data.namePrivate) {
			mui('#bedMapContainer .patName').each(function (index,element) {
				var newName = dealNamePrivate(element.getAttribute('data-patName'))
				element.innerHTML = newName
				element.setAttribute('data-title',name);
			})
			mui('#allBedScroll .patName').each(function (index,element) {
				var newName = dealNamePrivate(element.getAttribute('data-patName'))
				element.innerHTML = newName
				element.setAttribute('data-title',name);
			})
			var popName = $('#PatInfoPopover .name')[0]
			popName.innerHTML = dealNamePrivate(popName.getAttribute('data-patName'))
		} else if (e.data.isActive != undefined && e.data.isActive == false) {
			//mui('#ManualPopover').popover('hide');
			showOrHideDHCpopover('ManualPopover','hide')
			if (bedTimer) {
				clearInterval(bedTimer);
				bedTimer = undefined;
			}
		} else if (e.data.isActive) {
			resetRefresh();
			if (!bedTimer) {
				timeIntervalSetup();
			}
		}
	}, false);

	function timeIntervalSetup() {
		var len = 2 * 60 * 1000; //2分钟
		bedTimer = setInterval(function() {
			resetRefresh('auto'); //无刷新提示
		}, len);
	}
	
	function updateManualPopoverSelectUI(td,dataArr) {
		mui('#customWrapper').scroll().scrollTo(0,0,100)
		
		var beds = dataArr['beds'];
		//清空原来选中
		var manualBedMap = document.getElementById('manualBedMap');
		var selectdBeds = manualBedMap.querySelectorAll('.selected')
		for (var i = 0; i < selectdBeds.length; i++) {
			selectdBeds[i].classList.remove('selected');
		}
		
		var selectedUl = document.getElementById('selectedUl');
		selectedUl.innerHTML = '';
		var html = '';
		for (var i = 0; i < beds.length; i++) {
			var oneDict = beds[i];
			var bedStr = oneDict['bed'];
			if (bedStr == undefined || bedStr == "") {
				continue
			}
			
			var epidStr = oneDict['episodeID'];
			var selfStr = oneDict['selfDef']!=undefined?oneDict['selfDef']:"";
			html += '<div class="oneLine mui-input-row"><label class="selectedBed" data-epid="' + epidStr + '">'+bedStr+'</label>'+
				'<input type="text" class="mui-input-clear" data-epid="' + epidStr + '" value="'+selfStr+'"/></div>'
			var str = '.bed[data-epid="' + epidStr + '"]';
			var bedDom = manualBedMap.querySelector(str);
			if (bedDom) {
				bedDom.classList.add('selected');
			}
		}
		selectedUl.innerHTML = html;
		mui(".mui-input-row input").input()
		mui('#customValue')[0].value = dataArr['selfDef']
	}

	function refreshselectedUl() {
		var temp = getPopoverSelectdBedInfo();
		var codes = temp['codes'];
		var epids = temp['epids'];
		var selfs = temp['selfs']
		var html = ''
		for (var i = 0; i < codes.length; i++) {
			var bedStr = codes[i];
			var epidStr = epids[i];
			var selfStr = selfs[i];
			var inputDom = selectedUl.querySelector('input[data-epid="' + epidStr + '"]')
			if (inputDom) {
				selfStr = inputDom.value
			}
			html += '<div class="oneLine mui-input-row"><label class="selectedBed" data-epid="' + epidStr + '">'+bedStr+'</label>'+
			'<input type="text" class="mui-input-clear" data-epid="' + epidStr + '" value="'+selfStr+'"/></div>'
		}
		selectedUl.innerHTML = html;
	}

	function getPopoverSelectdBedInfo() {
		var manualBedMap = document.getElementById('manualBedMap');
		var doms = manualBedMap.querySelectorAll('.selected');
		if (doms.length == 0) {
			return {
				'codes': [],
				'epids': [],
				'selfs':[]
			}
		}
		var codes = [];
		var epids = [];
		var selfs = [];
		for (var i = 0; i < doms.length; i++) {
			var dom = doms[i];
			var bedDom = dom.querySelector('.bedNo');
			var code = bedDom.innerText;
			var epid = dom.getAttribute('data-epid');
			epids.push(epid);
			codes.push(code);
			var selfStr=""
			var selfDom = selectedUl.querySelector('input[data-epid="'+epid+'"]');
			if (selfDom) {
				selfStr = selfDom.value+"";
			}
			selfs.push(selfStr)
		}
		return {
			'codes': codes,
			'epids': epids,
			'selfs':selfs
		}
	}

	function popoverSureBtnTapped() {
		var ManualPopover = document.getElementById('ManualPopover');
		var tdId = ManualPopover.getAttribute('data-td');
		var allLogScroll = document.getElementById('allLogScroll');
		var halfLogScroll = document.getElementById('halfLogScroll');
		var alltds = allLogScroll.querySelectorAll('td[data-id=' + tdId + ']');
		var halftds = halfLogScroll.querySelectorAll('td[data-id=' + tdId + ']');
		var dict = getPopoverSelectdBedInfo();
		var epidStr = '',selfStr='';
		if (dict['codes'].length > 0) {
			epidStr = dict['epids'].join();
			selfStr = dict['selfs'].join('^');
		}
		var bedStr = '';
		for (var i = 0; i < dict['codes'].length;i++) {
			bedStr += dict['codes'][i];
			if (dict['selfs'][i] != "") {
				bedStr +="("+dict['selfs'][i]+")" ;
			}
			if (i !=dict['codes'].length -1) {
				bedStr += "，"
			}
		}
		var totalSelf = mui('#customValue')[0].value
		if (checkIsHasSpecialStr( dict['selfs'].join(''))||checkIsHasSpecialStr(totalSelf)) {
			iziToast.error({
			    title: '含有特殊非法字符！',
				position: 'center',
			    timeout: 1000,
				transitionOut: 'flipOutX'
			});
			return;
		}
		var xmlStr = {
			'SelfDef': selfStr,
			'HospID': hospID,
			'WardID': realWardId,
			'EpIDS': epidStr,
			'ItemCode': tdId,
			'Type':'self',
			'TotalSelf':totalSelf
		};
		$.DHCWebService('SaveInputLogItem', xmlStr, function(result) {
			if (result['success']) {
				showOrHideDHCpopover('ManualPopover','hide')
				//mui('#ManualPopover').popover('toggle')
				logData[tdId]['beds'] = result['beds'];
				logData[tdId]['selfDef'] = totalSelf;
				for (var i = 0; i < alltds.length; i++) {
					dealBedsWidthRealWardArr(result['beds'],logData[tdId]['way'],"M",halftds[i],alltds[i],totalSelf,logData[tdId]['score'])
				}
				var validTd = halfLogScroll.querySelector('.chosen');
				if (validTd) {
					var tdid = validTd.getAttribute('data-id');
					filterHalfBedData(validTd, tdid);
				}
			} else {
				var str = "保存失败"
				iziToast.error({
					class: 'loadError',
					color: '#41bbff',
					title: str,
					position: 'center',
					timeout: 800,
					transitionOut: 'flipOutX',
					close: true,
				});
			}

		}, function(errorStr) {
			var str = "调用失败:" + errorStr
			iziToast.error({
				class: 'loadError',
				color: '#41bbff',
				title: str,
				position: 'center',
				timeout: 800,
				transitionOut: 'flipOutX',
				close: true,
			});
		});
	}


	function resetRefresh(auto) {
		hideToast();
		//mui('#ManualPopover').popover('hide');
		//showOrHideDHCpopover('ManualPopover','hide');
		if (!auto) {
			var toast = document.querySelector('.loadingBedData');
			if (toast) {
				return;
			}
			iziToast.show({
				class: 'loadingBedData',
				color: 'dark',
				title: '正在刷新床位',
				image: '../common/images/load.gif',
				position: 'center',
				timeout: null,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});
		}
		getWardLogData();
		getAllNurse();
		getAllDoc();
		getSpecicalFilter()
	}
	/****夜间模式*****/
	function changeDayNightMode(mode) {
		if (mode) {
			document.body.classList.add('nightMode');
		} else {
			document.body.classList.remove('nightMode');
		}
	}

	function hideToast(str) {
		if (!str) {
			str = '.loadingBedData';
		}
		var toast = document.querySelector(str);
		if (toast) {
			iziToast.hide({
				transitionOut: 'fadeOutUp'
			}, toast);
		}
	}

	//手工输入popover 拖动功能
	function openPopoverDrag(popoverId) {
		var popoverBoard = document.getElementById(popoverId);
		var touchBoard = popoverBoard.querySelector('.headTip')
		//限制最大宽高，不让滑块出去
		var popoverW = 400;
		//手指触摸开始，记录div的初始位置
		var left = top.document.body.clientWidth*0.5;//(document.body.clientWidth - popoverW) * 0.5 ;//+ 300 * SCALE;
		popoverBoard.style.left = left + 'px';
		var halfBedWrapper = document.getElementById("halfBedWrapper");
		touchBoard.addEventListener('dragstart', function(e) {
			var classStr = document.body.getAttribute('class');
			if (classStr.indexOf('hasSwitch') == -1) { //折叠筐关闭
				BodyWidth = document.body.clientWidth - popoverW - 32;
			} else {
				BodyWidth = document.body.clientWidth*0.875 - popoverW - 32;
			}
		});
		touchBoard.addEventListener('drag', function(e) {
			var tempLeft = left + e.detail.deltaX;
			if (tempLeft < 1) {
				tempLeft = 1
			} else if (tempLeft > BodyWidth) {
				tempLeft = BodyWidth
			}
			popoverBoard.style.left = tempLeft + 'px';
		});
		//触摸结束时的处理
		touchBoard.addEventListener('dragend', function(e) {
			left = parseInt(popoverBoard.style.left)
		});
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
				if (id.indexOf('-wrapper') != -1) {
					domId = id;
				}else{
					switch (id) {
						case 'allLogWrapper':
						case 'halfLogWrapper':
						case 'allBedWrapper':
						case 'customWrapper':
						case 'nurseBedWrapper':
						case 'docBedWrapper':
						case 'itemWrapper':
							domId = id;
							break;
						default:
							break;
					}
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
			hideToop()
			mouseWheelScroll(domId, e)
		};
		//滚动滑轮触发scrollFunc方法
		window.onmousewheel = scrollFunc;
	}

	function closeItemPopover(isOtherCause) {
		if (isOtherCause != true) { //不是手工输入popover引起的itemPopover hidden
			//开启定时刷新
			if (!bedTimer) {
				timeIntervalSetup();
			}
		}
		var itemPopover = document.getElementById('itemPopover');
		itemPopover.classList.remove('mui-active');
		var logArea = document.getElementById(logAreaId);
		var chosen = logArea.querySelector('.chosen');
		if (chosen) {
			chosen.classList.remove('chosen')
		}
		document.getElementById('searchInput').value = "";
	}

	function getSpecicalFilter() {
		var xmlStr = {
			'HospID': hospID,
			'WardID': realWardId
		};
		filterXHR=$.DHCWebService('GetLogBedFilter', xmlStr, function(result) {
			filterXHR=null
			//console.log('GetLogBedFilter',result)
			if (result.flag == 'false' || result.flag == false) {
				specicalFilter = undefined;
				return;
			}
			specicalFilter = result;
			var halfLogScroll = document.getElementById('halfLogScroll');
			var chosenTD = halfLogScroll.querySelector('.chosen')
			if (chosenTD) {
				chosenId = chosenTD.getAttribute('data-id');
				if (chosenId && chosenId != '') {
					filterHalfBedData(chosenTD, chosenId);
				}
			}
		}, function(errorStr) {
			filterXHR=null
			specicalFilter = undefined;
		});
	}

	function hideToop() {
		toop.style.display = 'none'
	}
	
	function showOrHideDHCpopover(popoverId,type){
		if (!popoverId) {
			popoverId = "ManualPopover"
		}
		var popover = document.getElementById(popoverId);
		var dhcBackdrop = document.getElementById('dhcBackdrop');
		if (type == "show") {
			if (popover) {
				popover.classList.add('mui-active')
			}
			if (popoverId == "ManualPopover" && realWardArr.length > 1) {
				var manualSegScroll = document.getElementById('manualSegScroll')
				if (manualSegScroll.clientWidth < document.getElementById('manualSeg').clientWidth) {
					manualSegScroll.style.width = "100%"
				}
			}
			dhcBackdrop.classList.add('dhc-active')
		}else{
			if (popover) {
				popover.classList.remove('mui-active')
			}
			dhcBackdrop.classList.remove('dhc-active')
			mui('#selectedUl input').each(function (index,element) {
				element.blur()
			})
			var slider = document.getElementById('slider');
			if (slider.clientHeight == 0) {
				//当前界面不显示
				return;
			}
			// console.log('bedTimer')
			if (!bedTimer) {
				timeIntervalSetup();
			}
		}
	}
	window.onresize = function(){
		var allLogWrapper = document.getElementById('allLogWrapper');
		allLogScroll.style.height = 'auto';
		var halfLogWrapper = document.getElementById('halfLogWrapper');
		halfLogScroll.style.height = 'auto';
		if (allLogWrapper.clientHeight >= allLogScroll.clientHeight) {
			allLogScroll.style.height = '100%';
		}
		if (halfLogWrapper.clientHeight >= halfLogScroll.clientHeight) {
			halfLogScroll.style.height = '100%';
		}
	}
	jQuery(document).keydown(function(event) {
		if (event.keyCode == 13) {//回车
			if (document.activeElement.id == 'searchInput') {
				getLogItems();
				mui('#itemWrapper').scroll().scrollTo(0,0,100);
			}
		}
	});
	
	//获取床位图图标
	function getAllBedIcons() {
		var xmlStr = {
			'WardID': realWardId,
			'HospitalID':hospID
		};
		iconXHR=$.DHCWebService('GetAllIcons', xmlStr, function(result) {
			iconXHR=null
			updateBedCardIcon(result)
		}, function(errorStr) {
			iconXHR=null
		});
	}
	
	function updateBedCardIcon(dataArr){
		for(var i=0; i < dataArr.length; i++){
			var epid = dataArr[i]['EpisodeID'];
			var iconArr = dataArr[i]['icons'];
			var bedImgDom = document.querySelector('.halfBed[data-epid="'+epid+'"] .imgBadge')
			var halfBedImgDom = document.querySelector('.oneBed[data-epid="'+epid+'"] .imgBadge')
			if (!bedImgDom) {
				continue
			}
			var imgBadgeInner = '';
			for(var j=0; j<iconArr.length; j++){
				var path = bedImageUrl + iconArr[j]['src']; //直接使用his的图标
				var desc = iconArr[j]['title'];
				imgBadgeInner += '<img data-title="' + desc + '" class="cardImg" src="' + path + '" >';
			}
			bedImgDom.innerHTML = imgBadgeInner;
			halfBedImgDom.innerHTML = imgBadgeInner
		}
	}
	//获取所有护士
	function getAllNurse(){
		var xmlStr = {'WardID': realWardId};
		$.DHCWebService('GetMainNurses', xmlStr, function(result) {
			initManaBedBodyUI(result,'name','nurseBedBody');
			getNurseBed();
		}, function(errorStr) {
			getNurseBed(true);
		});
	}
	//获取有床位信息的护士及床位
	function getNurseBed(isAllFail){
		var xmlStr = {'WardID': realWardId};
		$.DHCWebService('GetNurForPat', xmlStr, function(result) {
			hiddenNULLByElementId('nurseBedNull')
			if (isAllFail) {
				initManaBedBodyUI(result,'mainNurse','nurseBedBody');
			}
			updateManaBedBodyUI(result,'nurseBedBody','nurseBedNull',isAllFail);
		}, function(errorStr) {
			var nurseBedBody = document.getElementById('nurseBedBody');
			nurseBedBody.innerHTML = ''
			showNULLByElementId('nurseBedNull', errorStr, 'error');
		});
	}
	
	//获取所有医生
	function getAllDoc(){
		var xmlStr = {'WardID': realWardId};
		$.DHCWebService('GetMainDoctors', xmlStr, function(result) {
			initManaBedBodyUI(result,'name','docBedBody');
			getDocBed();
		}, function(errorStr) {
			getDocBed(true);
		});
	}
	//获取有床位信息的护士及床位
	function getDocBed(isAllFail){
		var xmlStr = {'WardID': realWardId};
		$.DHCWebService('GetDocForPat', xmlStr, function(result) {
			hiddenNULLByElementId('docBedNull')
			if (isAllFail) {
				initManaBedBodyUI(result,'mainNurse','docBedBody');
			}
			updateManaBedBodyUI(result,'docBedBody','docBedNull',isAllFail);
		}, function(errorStr) {
			var docBedBody = document.getElementById('docBedBody');
			docBedBody.innerHTML = ''
			showNULLByElementId('docBedNull', errorStr, 'error');
		});
	}
	
	function initManaBedBodyUI(result,keyStr,bodyId){
		var bedBody = document.getElementById(bodyId);
		if (!result || result.length == 0) {
			bedBody.innerHTML = ''
			return
		}
		var html = ''
		for (var i = 0 ; i < result.length;i++) {
			var name = result[i][keyStr];
			html += '<tr><td class="nurse">'+name+'</td><td class="forBed" id="'+name+'"></td></tr>'
		}
		bedBody.innerHTML = html
	}
	
	function updateManaBedBodyUI(result,tbodyId,nullId,isAllFail){
		if (!result || result.length == 0) {
			if (isAllFail) {
				showNULLByElementId(nullId,"没有获取到管床信息")
			}
			return;
		}
		for (var i = 0 ; i < result.length;i++) {
			var name = result[i].mainNurse;
			var dom = document.getElementById(name);
			if (!dom) {
				continue
			}
			var beds = [];
			if (result[i].bedCode && result[i].bedCode != "") {
				beds = result[i].bedCode.split('^')
			}
			var epids = [];
			if (result[i].EpisodeIDs && result[i].EpisodeIDs != "") {
				epids = result[i].EpisodeIDs.split('^')
			}
			var bedHtml = '';
			for (var j = 0; j < beds.length;j++) {
				if (bedHtml != "") {
					bedHtml += '、'
				}
				if (beds[j] == "") {
					continue;
				}
				bedHtml += '<span class="nurBed">'+beds[j]+'</span>'
			}
			dom.innerHTML = bedHtml;
		}
	}
	function showLogDataToop(tdDom){
		hideToop()
		var pos = getAbsPosition(tdDom)
		pos.left = pos.left - document.body.clientWidth
		var logDataToop = $("#logDataToop")[0]
		logDataToop.innerHTML = tdDom.getAttribute('data-title');
		logDataToop.classList.add('show')
		logDataToop.setAttribute('data-id',tdDom.getAttribute('data-id'))
		var width = logDataToop.clientWidth
		var height = logDataToop.clientHeight + 5;
		var left = pos.left + width;
		var top = pos.top + 20
		var bottom = top + height;
		var bodyW = parseInt(localStorage.getItem('bodyW'))
		var bodyH = parseInt(localStorage.getItem('bodyH'))
		var offset = 106;
		if (bottom > bodyH - offset) {
			top = pos.top - 20 - height;
		}
		var contain = document.body.classList.contains('hasSwitch')
		if ((!contain && left >= bodyW - 45) || (contain && left >= bodyW * 0.875 - 45)) {
			left = pos.left - width
		} else {
			left = pos.left
		}
		logDataToop.style.top = top + 'px';
		logDataToop.style.left = left + 'px';
	}
	function hideLogDataToop(){
		$('#logDataToop')[0].setAttribute('data-id','')
		$("#logDataToop")[0].classList.remove('show')
	}
	
	function setupLayoutTap(){
		mui('#'+logAreaId).on('tap','td',logTdTapped) //日志单元格点击
		mui('#'+logAreaId).on('tap','td .manualIcon',logManualIconTapped) //半屏手工录入图标点击
		mui('#allLogScroll').on('tap','td .manualIcon',logManualIconTapped) //全屏手工录入图标点击
		jQuery("#halfLogScroll").on("mouseover",".ellipsis", mouseOverAction);
		jQuery("#halfLogScroll").on("mouseout",".ellipsis", mouseOutAction);
		jQuery("#halfLogScroll").on("mousemove",".ellipsis", mouseMoveAction);
	}
	
	function clearLayoutTap(){
		mui('#'+logAreaId).off('tap','td',logTdTapped) //日志单元格点击
		mui('#'+logAreaId).off('tap','td .manualIcon',logManualIconTapped) //半屏手工录入图标点击
		mui('#allLogScroll').off('tap','td .manualIcon',logManualIconTapped) //全屏手工录入图标点击
		jQuery("#halfLogScroll").off("mouseover",".ellipsis", mouseOverAction);
		jQuery("#halfLogScroll").off("mouseout",".ellipsis", mouseOutAction);
		jQuery("#halfLogScroll").off("mousemove",".ellipsis", mouseMoveAction);
	}
	
	function setupBedTap(){
		mui('#manualBedMap').on('tap','.bed',manualBedTapped);//手工录入 床号点击
		jQuery("#bedMapContainer").on("dblclick",".halfBed", bedDblclicked); //床位图双击
		jQuery("#allBedScroll").on("dblclick",".oneBed", bedDblclicked);
		//数据浮动
		jQuery("#bedMapContainer").on("mouseover",".halfBed .special.value", mouseOverAction);
		jQuery("#bedMapContainer").on("mouseover",".halfBed .patName", mouseOverAction);
		jQuery("#bedMapContainer").on("mouseover",".baseInfo .value", mouseOverAction);
		jQuery("#bedMapContainer").on("mouseover",".imgBadge img", mouseOverAction);
		jQuery("#bedMapContainer").on("mouseover",".halfBed .yuZhuYuan", mouseOverAction);
		
		jQuery("#bedMapContainer").on("mouseout",".halfBed .special.value", mouseOutAction);
		jQuery("#bedMapContainer").on("mouseout",".halfBed .patName", mouseOutAction);
		jQuery("#bedMapContainer").on("mouseout",".baseInfo .value", mouseOutAction);
		jQuery("#bedMapContainer").on("mouseout",".imgBadge img", mouseOutAction);
		jQuery("#bedMapContainer").on("mouseout",".halfBed .yuZhuYuan", mouseOutAction);
		
		jQuery("#bedMapContainer").on("mousemove",".halfBed .special.value", mouseMoveAction);
		jQuery("#bedMapContainer").on("mousemove",".halfBed .patName", mouseMoveAction);
		jQuery("#bedMapContainer").on("mousemove",".baseInfo .value", mouseMoveAction);
		jQuery("#bedMapContainer").on("mousemove",".imgBadge img", mouseMoveAction);
		jQuery("#bedMapContainer").on("mousemove",".halfBed .yuZhuYuan", mouseMoveAction);
	}
	function clearBedTap(){
		mui('#manualBedMap').off('tap','.bed',manualBedTapped);//手工录入 床号点击
		jQuery("#bedMapContainer").off("dblclick",".halfBed", bedDblclicked);//床位图双击
		jQuery("#allBedScroll").off("dblclick",".oneBed", bedDblclicked);
		//数据浮动
		jQuery("#bedMapContainer").off("mouseover",".halfBed .special.value", mouseOverAction);
		jQuery("#bedMapContainer").off("mouseover",".halfBed .patName", mouseOverAction);
		jQuery("#bedMapContainer").off("mouseover",".baseInfo .value", mouseOverAction);
		jQuery("#bedMapContainer").off("mouseover",".imgBadge img", mouseOverAction);
		jQuery("#bedMapContainer").off("mouseover",".halfBed .yuZhuYuan", mouseOverAction);
		
		jQuery("#bedMapContainer").off("mouseout",".halfBed .special.value", mouseOutAction);
		jQuery("#bedMapContainer").off("mouseout",".halfBed .patName", mouseOutAction);
		jQuery("#bedMapContainer").off("mouseout",".baseInfo .value", mouseOutAction);
		jQuery("#bedMapContainer").off("mouseout",".imgBadge img", mouseOutAction);
		jQuery("#bedMapContainer").off("mouseout",".halfBed .yuZhuYuan", mouseOutAction);
		
		jQuery("#bedMapContainer").off("mousemove",".halfBed .special.value", mouseMoveAction);
		jQuery("#bedMapContainer").off("mousemove",".halfBed .patName", mouseMoveAction);
		jQuery("#bedMapContainer").off("mousemove",".baseInfo .value", mouseMoveAction);
		jQuery("#bedMapContainer").off("mousemove",".imgBadge img", mouseMoveAction);
		jQuery("#bedMapContainer").off("mousemove",".halfBed .yuZhuYuan", mouseMoveAction);
	}
	function clearBedMapImg(){
		//回收图片
		mui('#bedMapContainer img').each(function (index,element) {
			element.src=""
		})
		mui('#allBedScroll img').each(function (index,element) {
			element.src=""
		})
	}
	
	function setupLogItemsTap(){
		mui('#itemUl').on('tap','li',itemPopoverCellTap) //日志项目点击
		mui('#itemUl').on('tap','li .arrow',itemPopoverCellArrowTap) //日志项目上箭头点击
	}
	function clearLogItemsTap(){
		mui('#itemUl').off('tap','li',itemPopoverCellTap) //日志项目点击
		mui('#itemUl').off('tap','li .arrow',itemPopoverCellArrowTap) //日志项目上箭头点击
	}
})(mui);

function mouseOverAction(e){
	if (e.target.classList.contains('bedCount')) {
		return
	}
	var cssText = e.target.getAttribute('style')
	if (cssText && cssText != "") {
		e.target.setAttribute('data-style',cssText)
	}
	if(e.target.classList.contains('value')){
		e.target.style.color = '#ff5550';
	}
	if (e.target.getAttribute('data-title')) {
		var logDataToopid= $('#logDataToop')[0].getAttribute('data-id')
		if (logDataToopid!=""&& logDataToopid== e.target.getAttribute('data-id')) { 
			return
		}
		toop.innerHTML = e.target.getAttribute('data-title');
		if (e.target.getAttribute('data-order')) {
			toop.classList.add('halfLogColor')
		}
		$(".toop")
			.css({
				"position": "absolute",
				"top": (e.pageY + 20) + "px",
				"left": "0px",
				'opacity': '0.9'
			}).show();
		var width = toop.clientWidth
		var height = toop.clientHeight + 5;
		var left = e.pageX + width;
		var top = e.pageY + 20
		var bottom = top + height;
		var bodyW = parseInt(localStorage.getItem('bodyW'))
		var bodyH = parseInt(localStorage.getItem('bodyH'))
		var offset = 106;
		
		if (bottom > bodyH - offset) {
			top = e.pageY - 20 - height;
		}
		var contain = document.body.classList.contains('hasSwitch')
		if ((!contain && left >= bodyW - 45) || (contain && left >= bodyW * 0.875 - 45)) {
			$(".toop")
				.css({
					"position": "absolute",
					"top": top + "px",
					"left": (e.pageX - width) + "px"
				}).show();;
		} else {
			toop.style.left = e.pageX + 'px';
		}
		toop.style.opacity = '0.9';
	}
}
function mouseOutAction(e){
	$(".toop").css({}).hide();
	mui('.toop')[0].classList.remove('halfLogColor')
	var style ='';
	if (e.target.getAttribute('data-style')) {
		style = e.target.getAttribute('data-style')
		e.target.removeAttribute('data-style')
	}
	e.target.setAttribute('style',style);
}

function mouseMoveAction(e){
	if ($('#logDataToop')[0].getAttribute('data-id') == e.target.getAttribute('data-id')) {
		return
	}
	var width = toop.clientWidth
	var height = toop.clientHeight + 5;
	var left = e.pageX + width;
	var top = e.pageY + 20
	var bottom = top + height
	var bodyW = parseInt(localStorage.getItem('bodyW'))
	var bodyH = parseInt(localStorage.getItem('bodyH'))
	var offset = 106;
	
	if (bottom > bodyH - offset) {
		top = e.pageY - 20 - height;
	}
	var contain = document.body.classList.contains('hasSwitch')
	if ((!contain && left >= bodyW - 45) || (contain && left >= bodyW * 0.875 - 45)) {
		$(".toop")
			.css({
				"position": "absolute",
				"top": top + "px",
				"left": (e.pageX - width) + "px"
			});
	} else {
		$(".toop")
			.css({
				"position": "absolute",
				"top": top + "px",
				"left": (e.pageX) + "px"
			});
	}
}

function jsonSort(array, field, reverse) {
	//数组长度小于2 或 没有指定排序字段 或 不是json格式数据
	if (array.length < 2 || !field || typeof array[0] !== "object") return array;
	//数字类型排序
	if (typeof array[0][field] === "number") {
		array.sort(function(x, y) {
			return x[field] - y[field]
		});
	}
	//字符串类型排序
	if (typeof array[0][field] === "string") {
		array.sort(function(x, y) {
			return x[field].localeCompare(y[field])
		});
	}
	//倒序
	if (reverse) {
		array.reverse();
	}
	return array;
}

function getJsonLength(json) {
	var jsonLength = 0;
	for (var i in json) {
		jsonLength++;
		break
	}
	return jsonLength;
}

function tojson(arr) {
	if (!arr.length) return null;
	var i = 0;
	len = arr.length,
		array = [];
	for (var i = 0; i < len; i++) {
		array.push({
			"AppDate": arr[i]['AppDate'],
			"AppPat": arr[i]['AppPat'],
			"AppflagID": arr[i]['AppflagID']
		});
	}
	return JSON.stringify(array);
}
/*
 * 接口
 * GetLayout 
 * {"html":"......","code1":{"beds":[],"show":"B","way":"R"}};
 * 	show: B显示床号,N显示总数
	way : R关联获取 M手工输入 A获取方法
	
 */
