(function ($) {
	var cardCol = 3;
	var wardID = localStorage['wardId'];
	var locID = localStorage['locId'];
	var opPhrase = {},insPhrase = {};
	var opResult,insResult;
	window.onload = baseSetup();
	var opTimer;
	function baseSetup(){
		if (mui.os.plus) {
			document.body.classList.add('osPlus')
		}
		if (localStorage['nightMode'] == 'true') {
			changeDayNightMode(true)
		}
		var contentDom = document.getElementById('content');
		if (localStorage['opFirst'] == 'true') {
			contentDom.classList.remove('inspect');
			contentDom.classList.add('op');
		}else{
			contentDom.classList.remove('op');
			contentDom.classList.add('inspect');
		}
		mui('.mui-scroll-wrapper').scroll();
		clearPhraseUI('op')
		clearAllContentUI('op');
		clearPhraseUI('ins')
		clearAllContentUI('ins');
		var changeScale = document.getElementById('changeScale');
		changeScale.addEventListener(tapType,function(){
			var contentDom = document.getElementById('content');
			var classStr = contentDom.getAttribute('class');
			if (classStr.indexOf('op') != -1) {
				contentDom.classList.remove('op');
				contentDom.classList.add('inspect');
				getRadiaPhrase();
			}else{
				contentDom.classList.remove('inspect');
				contentDom.classList.add('op');
				getOperationPhrase();
			}
			if(opTimer){
				clearInterval(opTimer);
				opTimer = undefined;
			}
			timeIntervalSetup();
		});
		$.DHCRequestXMl(function(result) {
			getOperationPhrase();
			getRadiaPhrase();
		},function(err){
		})
	}
	function stateTextTapped(){
		var parentNode = this.parentNode;
		var oldActive = parentNode.querySelector('.dhc-active');
		if (oldActive == this) {
			this.classList.remove('dhc-active');
		}else{
			if(oldActive){
				oldActive.classList.remove('dhc-active');
			}
			this.classList.add('dhc-active');
		}
		if (parentNode.id == 'op-state-area') {
			if (opResult != undefined) {
				filterOperationData()
			}else{
				getOperationData();
			}
		}else{
			if (insResult != undefined) {
				filterInspectData()
			}else{
				getInspectData();
			}
		}
	}
	//获取手术流程
	function getOperationPhrase(){
		var xmlStr = {};
		$.DHCWebService('GetOperationPhrase',xmlStr,function(result){
			updatePhraseUI(result,'op');
			getOperationData();
		},function(errorStr){
			var result = [{"color":"#227FDE","desc":"预约","icon":"iconclock","id":"Application,Arrange,Audit"},
				{"color":"#E17C2A","desc":"正在手术","icon":"iconwaiting","id":"RoomIn"},
				{"color":"#E17C2A","desc":"手术结束","icon":"iconwaiting","id":"RoomOut"},
				{"color":"#27AB57 ","desc":"手术完成","icon":"icondone","id":"Finish"},
				{"color":"#27AB57 ","desc":"手术取消","icon":"iconerror","id":"Cancel"}];
			updatePhraseUI(result,'op');
			getOperationData();
		});
	}
	//获取检查流程
	function getRadiaPhrase(){
		var xmlStr = {};
		$.DHCWebService('GetRadiaPhrase',xmlStr,function(result){
			updatePhraseUI(result,'ins');
			getInspectData();
		},function(errorStr){
			var result = [{"color":"#7C7C81","desc":"已开单","icon":"iconbill","id":"已开单"},
				{"color":"#227FDE","desc":"已预约","icon":"iconclock","id":"预约"},
				{"color":"#E17C2A","desc":"正在检查","icon":"iconwaiting","id":"检查中"},
				{"color":"#27AB57","desc":"检查完成","icon":"icondone","id":"已完成"},
				{"color":"#27AB57","desc":"检查取消","icon":"iconerror","id":"已取消"}];
			updatePhraseUI(result,'ins');
			getInspectData();
		});
	}
	//获取手术数据
	function getOperationData(){
		var xmlStr = {'LocID':locID,"OpType":"",'WardID':wardID};
		$.DHCWebService('GetOperationInfo',xmlStr,function(result){
			opResult = result;
			updateOperationUI();
			hideToast();
		},function(errorStr){
			opResult = undefined;
			clearAllContentUI('op');
			showNULLByElementId('op-order-null','预约信息'+errorStr,'error');
			showNULLByElementId('op-today-null','今日手术'+errorStr,'error');
			hideToast();
		});
	}
	//获取检查数据
	function getInspectData(){
		var xmlStr = {'WardID':wardID,"InsType":""};
		$.DHCWebService('GetRadiaInfo',xmlStr,function(result){
			insResult = result;
			updateInspectUI();
			hideToast();
		},function(errorStr){
			hideToast();
			insResult = undefined
			clearAllContentUI('ins');
			showNULLByElementId('inspect-bill-null','开单信息'+errorStr,'error');
			showNULLByElementId('inspect-order-null','预约信息'+errorStr,'error');
			showNULLByElementId('inspect-today-null','今日检查'+errorStr,'error');
		});
	}
	
	//更新手术流程/检查流程 UI {"color":"#227FDE","desc":"预约","icon":"iconclock"}
	function updatePhraseUI(dataArr,type){
		var domId = 'ins-state-area';
		if (type == 'op') {
			domId = 'op-state-area';
			opPhrase = {}
		}else{
			insPhrase={}
		}
		var stateDom = document.getElementById(domId);
		var html = '', idStr = '';
		var oldActive = stateDom.querySelector('.dhc-active');
		if (oldActive) {
			idStr = oldActive.getAttribute('data-type');
		}
		for (var i = 0; i < dataArr.length;i++) {
			var dict = dataArr[i];
			var desc = dict['desc']
			var activeStr = '';
			if(idStr == dict['id']){
				activeStr = ' dhc-active';
			}
			html += '<div class="state-text'+activeStr+'" data-type="'+dict['id']+'" style="color:'+dict['color']+'">'+desc+'</div>';
			if (i != dataArr.length - 1) {
				html += '<div class="state-line"></div>'
			}
			if (type == 'op') {
				opPhrase[desc] = dict;
			}else{
				insPhrase[desc] = dict;
			}
		}
		mui('#'+domId).off(tapType,'.state-text',stateTextTapped)
		stateDom.innerHTML = html;
		mui('#'+domId).on(tapType,'.state-text',stateTextTapped)
		if (type == 'op') {
			$('#op-order-wrapper').scroll().scrollTo(0,0,100);
			$('#op-today-wrapper').scroll().scrollTo(0,0,100);
		}else{
			$('#inspect-bill-wrapper').scroll().scrollTo(0,0,100);
			$('#inspect-order-wrapper').scroll().scrollTo(0,0,100);
			$('#inspect-today-wrapper').scroll().scrollTo(0,0,100);
		}
	}
	function updateOperationUI(){
		if (opResult == undefined) {
			return;
		}
		if (opResult['PH1']) {
			updateOperationOneUI('op-order',opResult['PH1'])
		}else{
			document.getElementById('op-order').innerHTML = '';
			showNULLByElementId("op-order-null",'无预约');
		}
		if (opResult['PH2']) {
			updateOperationOneUI('op-today',opResult['PH2'])
		}else {
			document.getElementById('op-today').innerHTML = '';
			showNULLByElementId('op-today-null','今日无手术');
		}
		filterOperationData();
	}
	//更新手术内容UI
	function updateOperationOneUI(domId,dict){
		var colorStr = dict['color'];
		var op_title = document.getElementById(domId+'-title');
		op_title.style.background = colorStr;
		var titleDom = op_title.querySelector('div');
		titleDom.innerText = dict['name'];
		op_title.innerHTML = '<div>'+dict['name']+'</div>';
		var contentArea = op_title.parentNode;
		contentArea.style.borderColor = colorStr;
		var prepareDom = document.getElementById(domId);
		var dataArr = dict['data'];
		var html = '';
		if (dataArr) {
			for (var i = 0; i < dataArr.length;i++) {
				var oneDict = dataArr[i];
				var oneHtml = getOneBedBox(oneDict,colorStr,'op',domId);
				html += oneHtml
			}
		}
		prepareDom.innerHTML = html;
		hiddenNULLByElementId(domId+'-null')
		if (!dataArr || dataArr.length == 0) {
			if (domId == 'op-order') {//与测试组沟通,无数据时不应有图片和文字提示
				showNULLByElementId(domId+'-null','无预约');
			}else if (domId == 'op-today') {
				showNULLByElementId(domId+'-null','今日无手术');
			}
		}else{
			hiddenNULLByElementId(domId+'-null')
		}
	}
	function updateInspectUI(){
		if (insResult == undefined) {
			return;
		}
		if (insResult['PH1']) {
			updateInspectOneUI('inspect-bill',insResult['PH1'])
		}else{
			document.getElementById('inspect-bill').innerHTML = '';
			showNULLByElementId('inspect-bill-null','无开单');
		}
		if (insResult['PH2']) {
			updateInspectOneUI('inspect-order',insResult['PH2'])
		}else {
			document.getElementById('inspect-order').innerHTML = '';
			showNULLByElementId('inspect-order-null','无预约');
		}
		if (insResult['PH3']) {
			updateInspectOneUI('inspect-today',insResult['PH3'])
		}else{
			document.getElementById('inspect-today').innerHTML = '';
			showNULLByElementId('inspect-today-null','今日无检查');
		}
		filterInspectData();
	}
	//更新检查内容UI
	function updateInspectOneUI(domId,dict){
		var colorStr = dict['color'];
		var ins_title = document.getElementById(domId+'-title');
		ins_title.style.background = colorStr;
		var titleDom = ins_title.querySelector('div');
		titleDom.innerText = dict['name'];
		//ins_title.innerHTML = '<div>'+dict['name']+'</div>';
		var contentArea = ins_title.parentNode;
		contentArea.style.borderColor = colorStr;
		// ins_title.style.height = contentArea.clientHeight + 'px'
		var prepareDom = document.getElementById(domId);
		var dataArr = dict['data'];
		var html = '';
		for (var i = 0; i < dataArr.length;i++) {
			var oneDict = dataArr[i];
			var oneHtml = getOneBedBox(oneDict,colorStr,'ins',domId);
			html += oneHtml
		}
		prepareDom.innerHTML = html;
		html = ''
		//hiddenNULLByElementId(domId+'-null')
		if (dataArr.length == 0) {//与测试组沟通,无数据时不应有图片和文字提示
			if (domId == 'inspect-bill') {
				showNULLByElementId(domId+'-null','无开单');
			}else if (domId == 'inspect-order') {
				showNULLByElementId(domId+'-null','无预约');
			}else{
				showNULLByElementId(domId+'-null','今日无检查');
			}
		}else{
			hiddenNULLByElementId(domId+'-null')
		}
	}
	
	function filterOperationData(){
		var filterType = getOpType();
		var filterDom = document.getElementById('opFilter')
		mui('#opFilterWrapper').scroll().scrollTo(0,0,100);
		if (filterType == "") {//显示全部
			filterDom.classList.remove('dhc-active')
			return;
		}
		hiddenNULLByElementId('opFilterNull')
		filterType = ','+filterType+','
		var index = 1;
		var html = ''
		for (var ph in opResult){
			var arr = opResult[ph]['data']
			for (var i = 0; i < arr.length;i++) {
				var dict = arr[i]
				var statusFlag = dict['statusFlag']
				if (filterType.indexOf(statusFlag) == -1) {
					continue
				}
				var stateText = dict['status']!=undefined?dict['status']:'';
				var bedNo = dict['bed']!=undefined?dict['bed']:'';
				var patName = dealNamePrivate(dict['patname']);
				var datetime = dict['datetime']!=undefined?dict['datetime']:'';
				var opname = dict['opname']!=undefined?dict['opname']:'';
				var surgeon = dict['surgeon']!=undefined?dict['surgeon']:'';
				var optLevel = dict['optLevel']!=undefined?dict['optLevel']:'';
				var anaMethod = dict['anaMethod']!=undefined?dict['anaMethod']:'';
				var optdept = dict['optdept']!=undefined?dict['optdept']:'';
				var optroom = dict['optroom']!=undefined?dict['optroom']:'';
				var optseq = dict['optseq']!=undefined?dict['optseq']:'';
				//序号 床号 姓名 手术名称 级别 麻醉 医生 手术室 手术间 台次 时间 状态
				html += '<tr><td>'+index+'</td><td>'+bedNo+'</td><td>'+patName+'</td><td>'+opname+'</td><td>'+optLevel+'</td>'+
					'<td>'+anaMethod+'</td><td>'+surgeon+'</td><td>'+optdept+'</td><td>'+optroom+' / '+optseq+'</td>'+
					'<td>'+datetime+'</td><td>'+stateText+'</td></tr>'
				index += 1
			}
		}
		var opTbody = document.getElementById('opTbody')
		opTbody.innerHTML = html;
		if (html == '') {
			showNULLByElementId('opFilterNull','该状态无数据');
		}
		filterDom.classList.add('dhc-active')
		html = ''
	}
	
	function filterInspectData(){
		var filterType = getInsType();
		var filterDom = document.getElementById('insFilter')
		mui('#insFilterWrapper').scroll().scrollTo(0,0,100);
		if (filterType == "") {//显示全部
			filterDom.classList.remove('dhc-active')
			return;
		}
		hiddenNULLByElementId('insFilterNull')
		var insDateTitle = document.getElementById('insDate')
		if (filterType.indexOf('开单') != -1) {
			insDateTitle.innerText = '开单时间'
		}else if(filterType.indexOf('预约') != -1){
			insDateTitle.innerText = '预约时间'	
		}else if(filterType.indexOf('完成') != -1){
			insDateTitle.innerText = '完成时间'
		}else if(filterType.indexOf('取消') != -1){
			insDateTitle.innerText = '取消时间'
		}else{
			insDateTitle.innerText = '检查时间'
		}
		filterType = ','+filterType+','
		var index = 1;
		var html = ''
		for (var ph in insResult){
			var arr = insResult[ph]['data']
			for (var i = 0; i < arr.length;i++) {
				var dict = arr[i]
				var stateText = dict['status']!=undefined?dict['status']:'';
				if (filterType.indexOf(stateText) == -1) {
					continue
				}
				var bedNo = dict['bed']!=undefined?dict['bed']:'';;
				var patName = dealNamePrivate(dict['patname']);
				var recloc = dict['recloc']!=undefined?dict['recloc']:'';;
				var examname = dict['examname']!=undefined?dict['examname']:'';;
				var apptime = dict['apptime']!=undefined?dict['apptime']:'';;
				html += '<tr><td>'+index+'</td><td>'+bedNo+'</td><td class="pat-name" data-patName="'+dict['patname']+'">'+patName+'</td><td>'+examname+'</td><td>'+recloc+'</td>'+
					'<td>'+apptime+'</td><td>'+stateText+'</td></tr>'
				index += 1
			}
		}
		var insTbody = document.getElementById('insTbody')
		insTbody.innerHTML = html;
		if (html == '') {
			showNULLByElementId('insFilterNull','该状态无数据');
		}
		filterDom.classList.add('dhc-active')
		html = ''
	}
	
	function getInsType(){
		var insType = '';
		var active = document.querySelector('#ins-state-area .dhc-active');
		if (active) {
			insType = active.getAttribute('data-type')
		}
		return insType;
	}
	
	function getOpType(){
		var opType = '';
		var active = document.querySelector('#op-state-area .dhc-active');
		if (active) {
			opType = active.getAttribute('data-type')
		}
		return opType
	}
	
	//小卡片
	function getOneBedBox(dict,colorStr,type,domId){
		var bedNo = dict['bed'];
		var patName = dealNamePrivate(dict['patname']);
		var opName = dict['opname'];
		var opDoc = dict['surgeon'];
		var stateText = dict['status']
		var statusFlag = dict['statusFlag']!=undefined ? dict['statusFlag'] : "";
		if (type == 'ins') {
			statusFlag = stateText
		}
		var textStr = stateText;
		if (stateText.indexOf('取消') != -1) { 
			textStr = '取消';
		}
		var colorDict = opPhrase[textStr];
		if (type == 'ins') {
			opName = dict['recloc'];
			opDoc = dict['examname'];
			colorDict = insPhrase[textStr]; 
		}
		if (colorDict == undefined) {//流程为空或者失败
			if (domId == 'inspect-bill') {
				iconStr = 'iconbill';
				colorStr = 'gray';
			}else if (domId == 'op-order' || domId == 'inspect-order') {
				iconStr = 'iconclock';
				colorStr = '#227FDE';
			}else if (domId == 'op-today' || domId == 'inspect-today') {
				iconStr = 'iconwaiting';
				colorStr = '#E17C2A';
				if (textStr.indexOf('预约') != -1) {
					iconStr = 'iconclock';
					colorStr = '#227FDE';
				}
			}
		}else{
			colorStr = colorDict['color'];
			iconStr = colorDict['icon'];
		}
		if (textStr.indexOf('取消') != -1) {//取消
			colorStr = '#FF6261';
			iconStr = 'iconerror'
		}
		if (textStr.indexOf('完成') != -1) {
			iconStr = 'icondone';
			colorStr = '#27AB57';
		}
		var opNameicon = 'iconshoushudao';
		var opDocicon = 'icondoc';
		var timeIcon = 'icontime'
		if (type == 'ins') {
			opNameicon = 'iconward';
			opDocicon = 'iconopCheck';
		}else if (domId == 'op-today') {
			opDocicon = 'iconward';
		}
		var timeStr = ''
		if(dict['apptime']){
			timeStr = dict['apptime']
		}
		if (domId == 'op-order') {
			timeStr = dict['datetime']
		}else if (domId == 'op-today') {
			timeIcon = 'iconlocate';
			//手术室 optdept 手术间optroom 台次optseq
			opDoc = dict['optdept']
			var optseq = dict['optseq']+""
			if(optseq!= "" && optseq.indexOf('台')==-1){
				optseq += '台'
			}
			var midline = '';
			if(dict['optroom'] && optseq){ 
				midline = '/';
			}
			timeStr = dict['optroom'] + midline + optseq;
		}
		var mazui = '';
		if(domId == 'op-today' || domId == 'op-order'){
			var anaMethodStr = dict['anaMethod'];
			if (!anaMethodStr) {
				anaMethodStr = '';
			}
			var optLevelStr = dict['optLevel'];
			if (!optLevelStr) {
				optLevelStr = '';
			}
			mazui = '<div class="line">'+
				'<div class="iconfont icontizi"></div>'+
				'<div title="'+ optLevelStr + '" class="op-anaMethod">'+optLevelStr+'</div>'+
			'</div>'+
			'<div class="line">'+
				'<div class="iconfont iconneedle"></div>'+
				'<div title="'+ anaMethodStr + '" class="op-anaMethod">'+anaMethodStr+'</div>'+
			'</div>'
		}
		var html = '<div class="bed-box-p" data-status="'+statusFlag+'"><div class="bed-box">'+
			'<div class="line">'+
				'<div class="pat-name" data-patName="'+dict['patname']+'">'+bedNo+"&nbsp;&nbsp;"+patName+'</div>'+
				'<div class="iconfont '+iconStr+' state-icon" style="color:'+colorStr+'"></div>'+
				'<div class="state">'+stateText+'</div>'+
			'</div>'+
			'<div class="line">'+
				'<div class="iconfont '+opNameicon+'"></div>'+
				'<div title="'+ opName + '" class="op-name">'+opName+'</div>'+
			'</div>'
			+ mazui + //手术分级和麻醉方式
			'<div class="line">'+
				'<div class="iconfont '+opDocicon+'"></div>'+
				'<div title="'+ opDoc + '" class="op-doc">'+opDoc+'</div>'+
			'</div>'+
			'<div class="line">'+
				'<div class="iconfont '+timeIcon+'"></div>'+
				'<div title="'+ timeStr + '"  class="op-doc">'+timeStr+'</div>'+
			'</div></div></div>'
		return html;
	}
	window.addEventListener('message',function(e){
		if (e.data.wardId != wardID && e.data.refreshType == 'ward') {//切换病区
			wardID = e.data.wardId;
			locID = e.data.locId;
			var toast = document.querySelector('.loadingPlan');
			if (!toast) {
				iziToast.show({
					class: 'loadingPlan',
					color: 'dark',
					title: '正在刷新',
					image: '../common/images/load.gif',
					position: 'center',
					timeout: null,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});	
			}
			var contentDom = document.getElementById('content');
			var classStr = contentDom.getAttribute('class');
			if (classStr.indexOf('op') != -1) {
				getOperationPhrase();
			}else{
				getRadiaPhrase();
			}
			if(opTimer){
				clearInterval(opTimer);
				opTimer = undefined;
			}
			timeIntervalSetup();
			return
		}
		wardID = e.data.wardId;
		locID = e.data.locId;
		changeDayNightMode(e.data.nightMode);
		if(e.data.refresh){
			resetRefresh();
			if(opTimer){
				clearInterval(opTimer);
				opTimer = undefined;
			}
			timeIntervalSetup();
		}else if (e.data.isActive != undefined && e.data.isActive == false) {
			if (opTimer) {
				clearInterval(opTimer);
				opTimer = undefined;
			}
		}else if(e.data.isActive){
			var contentDom = document.getElementById('content');
			var classStr = contentDom.getAttribute('class');
			if (classStr.indexOf('op') != -1) {
				getOperationPhrase();
			}else{
				getRadiaPhrase();
			}
			if(opTimer){
				clearInterval(opTimer);
				opTimer = undefined;
			}
			timeIntervalSetup();
		}else{
			if(e.data.namePrivate){
				mui('.pat-name').each(function (index,element) {
					element.innerHTML = dealNamePrivate(element.getAttribute('data-patName'))
				})
			}
			var contentClass = document.getElementById('content').getAttribute('class');
			if (e.data.opFirst && contentClass.indexOf('op') == -1) {
				var changeScale = document.getElementById('changeScale');
				mui.trigger(changeScale, tapType);
			}
		}
	},false);
	
	function resetRefresh() {
		var toast = document.querySelector('.loadingPlan');
		if (toast) {
			return;
		}
		iziToast.show({
			class: 'loadingPlan',
			color: 'dark',
			title: '正在刷新',
			image: '../common/images/load.gif',
			position: 'center',
			timeout: null,
			color: '#F4C059',
			transitionOut: 'flipOutX',
			close: true
		});	
		//获取手术流程成功或失败都会继续获取检查流程及数据
		var contentDom = document.getElementById('content');
		var classStr = contentDom.getAttribute('class');
		if (classStr.indexOf('op') != -1) {
			getOperationPhrase();
		}else{
			getRadiaPhrase();
		}
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
	
	function setupNullSize(domId,height,areaWidth){
		var width = height * 10 / 7.0;
		var nullDom = document.getElementById(domId);
		nullDom.style.height = height + 'px';
		nullDom.style.width = width + 'px';
		var left = areaWidth*0.5 - 50 - width*0.5;
		if (left < 0) {
			left = 0
		}
		nullDom.style.left = left + 'px';
		var top = height*0.5 - width*0.5;
		if (top < 0) {
			top = 0
		}
		nullDom.style.top = top + 'px';
		var nullText = nullDom.querySelector('.nullTip');
		nullText.style.width = width + 'px';
	}
	
	function hideToast(str){
		if (!str) {
			str = '.loadingPlan';
		}
		var toast = document.querySelector(str);
		if (toast) {
		    iziToast.hide({
				transitionOut: 'fadeOutUp'
		    }, toast);
		}
	}
	function clearAllContentUI(type){
		if(type == 'op'){
			document.getElementById('op-order').innerHTML = '';
			document.getElementById('op-today').innerHTML = '';
		}else{
			document.getElementById('inspect-bill').innerHTML = '';
			document.getElementById('inspect-order').innerHTML = '';
			document.getElementById('inspect-today').innerHTML = '';
		}
	}
	
	
	function clearPhraseUI(type){
		if(type == 'op'){
			document.getElementById('op-state-area').innerHTML = '';
		}else{
			document.getElementById('ins-state-area').innerHTML = '';
		}
	}
	
	function timeIntervalSetup(){
		if (opTimer) {
			return
		}
		var len = 10 * 60 * 1000;//10分钟
		opTimer = setInterval(function(){
			var contentDom = document.getElementById('content');
			var classStr = contentDom.getAttribute('class');
			if (classStr.indexOf('op') != -1) {
				getOperationPhrase();
			}else{
				getRadiaPhrase();
			}
		},len);
	}
	windowAddMouseWheel();
	function windowAddMouseWheel() {
	    var scrollFunc = function(e) {
			var domId = '';
	    	e = e || window.event;
			
			var target = e.target;
			var tagName = target.tagName;
			while(tagName != "BODY" && tagName != "HTML"){
				var id = target.id;
				switch (id){
					case 'op-today-wrapper':
					case 'op-order-wrapper':
					case 'inspect-today-wrapper':
					case 'inspect-bill-wrapper':
					case 'inspect-order-wrapper':
					case 'insFilterWrapper':
					case 'opFilterWrapper':
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
	
})(mui);


// $(function() {
// 	setHover($(".op-name"));
// 	setHover($(".op-doc"));
// });

function setHover(dom) {
	dom.mouseover(function(e) {
		this.Mytitle = this.title; //获取title属性
		this.title = ""; //
		$("body").append("<div class='toop'>" + this.Mytitle + "</div>"); //新建div到body
		$(".toop")
			.css({
				// "top": (e.pageY + 10) + "px",
				// "position": "absolute", 
				// "left": (e.pageX + 20) + "px",
			}).show();
	}).mouseout(function() { //鼠标离开
		this.title = this.Mytitle;
		$(".toop").remove(); //移除对象
	}).mousemove(function(e) { //鼠标移动
		$(".toop")
			.css({
				// "top": (e.pageY + 10) + "px",
				// "position": "absolute", 
				// "left": (e.pageX + 20) + "px",
			});
	});
}

