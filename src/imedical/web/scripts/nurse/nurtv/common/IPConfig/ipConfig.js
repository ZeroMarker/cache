(function ($) {
	var ipPartStart = false; //用于切换IPPart后的信息录入
	$.showIpConfig = function(type){
		var configPopo = $('#configPopo')[0]
		if (configPopo) {
			var configDict = localStorage['ipConfigDict'];
			if (configDict) {
				configDict = JSON.parse(localStorage['ipConfigDict']);
				updateUIWithDefault(configDict)
			}else{
				updateUIWithDefault()
			}
			configPopo.classList.add('mui-active')
			return
		}
		configPopo = document.createElement('div')
		document.body.appendChild(configPopo);
		configPopo.id = 'configPopo'
		configPopo.setAttribute('class','configPopo')
		configPopo.innerHTML=getPopoContentHtml();
		
		setupConfigTapped();
		var configDict = localStorage['ipConfigDict'];
		if (configDict) {
			configDict = JSON.parse(localStorage['ipConfigDict']);
			updateUIWithDefault(configDict)
		}else{
			updateUIWithDefault()
		}
		configPopo.classList.add('mui-active')
	}
	function updateUIWithDefault(dict){
		var tempIp = ipUrl
		var tempPro = protocol
		var temp85 = parseInt(his85)
		var tempWeb= webUrl
		if (dict) {
			tempPro = dict['protocol']
			temp85 = parseInt(dict['his85'])
			tempWeb = dict['webUrl']
			tempIp = dict['ipUrl']
		}
		var hisStr = '.conRight.hisCell .option[data-index="1"]'
		if (temp85 === 1) {
			hisStr = '.conRight.hisCell .option[data-index="0"]'
		}
		mui.trigger(mui(hisStr)[0],tapType)
		
		//协议
		var cateStr = '.conRight.cateCell .option[data-index="0"]'
		if (tempPro == "https"+':') {
			cateStr = '.conRight.cateCell .option[data-index="1"]'
		}
		mui.trigger(mui(cateStr)[0],tapType)
		
		var webStr = '.conRight.webCell .option[data-index="1"]'
		if (tempWeb == "/imedical/webservice") {
			webStr = '.conRight.webCell .option[data-index="2"]'
		}else if (tempWeb == "/dthealth/web") {
			webStr = '.conRight.webCell .option[data-index="0"]'
		}
		mui.trigger(mui(webStr)[0],tapType)
		
		//ip
		var ipCellArr = tempIp.split(":")
		var ipArr = ipCellArr[0].split('.')
		for (var i=0;i < 4;i++) {
			var onePart = ipArr[i]
			if (onePart == undefined) {
				onePart = ''
			}
			mui('.conRight.ipCell .ipPart[data-index="'+i+'"]')[0].innerText = onePart
		}
		var port = ipCellArr[1]
		if (port == undefined) {
			port = ''
		}
		mui('.conRight.ipCell .ipPart[data-index="4"]')[0].innerText = port
	}
	function saveConfigToLocal(){
		var ipParts = document.querySelectorAll('.ipCell .ipPart')
		var tempIp = ''
		for (var i = 0; i < ipParts.length;i++) {
			var currPart=parseInt(ipParts[i].innerText)
			if (i == 4) {
				if (ipParts[i].innerText != '') {
					tempIp += ':'+currPart
				}
				continue
			}
			if (isNaN(currPart) || currPart > 255) {
				mui.toast('ip地址不正确')
				return
			}
			if (i > 0) {
				tempIp += '.'
			}
			tempIp +=currPart 
		}
		var cateValue = mui('.conRight.cateCell .option.mui-active')[0].innerText+':'
		var webValue = mui('.conRight.webCell .option.mui-active')[0].innerText
		var hisDom = mui('.conRight.hisCell .option.mui-active')[0]
		var hisValue = 1
		if (hisDom == undefined || hisDom.getAttribute('data-index') == '1') {
			hisValue = 0
		}
		var configDict = {'protocol':cateValue,'his85':hisValue,'webUrl':'/'+webValue,'ipUrl':tempIp};
		localStorage['ipConfigDict'] = JSON.stringify(configDict);
		closeConfigPopo()
	}
	function setupConfigTapped(){
		mui('.popoContent').on(tapType,'#configClose',closeConfigPopo)
		mui('.numberBox').on(tapType,'#numClose',closeNumberBox) 
		mui('li').on(tapType,'.option',function(){
			closeNumberBox()
			var conRight = this.parentNode
			var oldActive = conRight.querySelector('.mui-active')
			if (oldActive && oldActive!= this) {
				oldActive.classList.remove('mui-active')
			}
			this.classList.add('mui-active')
			if (conRight.getAttribute('class').indexOf('hisCell') == -1) { //hisCell
				return
			}
			var index = this.getAttribute('data-index')
			if (index == 0) {
				mui.trigger(mui('.conRight.cateCell .option[data-index="1"]')[0],tapType)
				mui.trigger(mui('.conRight.webCell .option[data-index="2"]')[0],tapType)
			}else{
				mui.trigger(mui('.conRight.cateCell .option[data-index="0"]')[0],tapType)
				if (mui('.conRight.webCell .option[data-index="2"].mui-active')[0]) {
					mui.trigger(mui('.conRight.webCell .option[data-index="1"]')[0],tapType)
				}
			}
		});
		mui('li').on(tapType,'.ipPart',function(){ //ip部分
			ipPartStart = true
			var conRight = this.parentNode
			var oldActive = conRight.querySelector('.mui-active')
			if (oldActive && oldActive!= this) {
				oldActive.classList.remove('mui-active')
			}
			this.classList.add('mui-active')
			$('#numberBox')[0].classList.add('mui-active')
			mui('#numberBox .notValid').each(function (index,element) {
				element.classList.remove('notValid')
			});
			if (this.getAttribute('data-index') == '0') {
				mui('#numberBox .iconleft')[0].classList.add('notValid')
			}else if (this.getAttribute('data-index') == '4') {
				mui('#numberBox .iconright')[0].classList.add('notValid')
			}
		});
		mui('.popoContent').on(tapType,'.resetBtn',function(){ //恢复默认
			closeNumberBox()
			updateUIWithDefault();
		})
		mui('.popoContent').on(tapType,'.confirmBtn',saveConfigToLocal) //确认地址
		
		mui('#numberBox').on(tapType,'.oneNum',numberBoxTapped) 
	}
	
	//ip专用键盘
	function numberBoxTapped(){
		var active = $('.ipCell .mui-active')[0]
		if (!active) {
			return
		}
		if (this.id == 'clearPart') {
			active.innerHTML = ''
			return
		}
		if (this.id == 'backNum') {
			clearOneChart(active);
			return
		}
		var thisClass = this.getAttribute('class')
		if (thisClass.indexOf('notValid') != -1) {
			return
		}
		var activeIndex = parseInt(active.getAttribute('data-index'));
		if (thisClass.indexOf('iconfont') != -1) {
			var idStr = '.ipCell .ipPart[data-index="'+(activeIndex+1)+'"]'
			if (thisClass.indexOf('iconleft') != -1) {
				idStr = '.ipCell .ipPart[data-index="'+(activeIndex-1)+'"]'
			}
			mui.trigger($(idStr)[0],tapType)
			return
		}
		var partValue = parseInt(active.innerHTML+this.innerHTML)
		
		if (activeIndex == 4 && partValue > 65535) {
			mui.toast('超出最大限制')
			return
		}
		if (ipPartStart) {
			active.innerHTML = this.innerHTML
			ipPartStart = false
			return
		}else if (activeIndex < 4 && partValue > 255) {
			mui.trigger($('.ipCell .ipPart[data-index="'+(activeIndex+1)+'"]')[0],tapType)
			ipPartStart = false
			$('.ipCell .mui-active')[0].innerHTML = this.innerHTML
		}else{
			active.innerHTML = partValue
		}
	}
	
	function clearOneChart(active){
		var str = active.innerHTML
		if (str.length < 1) {
			return
		}
		active.innerHTML = str.substring(0,str.length - 1 )
	}
	
	function closeConfigPopo(){
		$('#configPopo')[0].classList.remove('mui-active')
		closeNumberBox()
		
	}
	function closeNumberBox(){
		$('#numberBox')[0].classList.remove('mui-active')
		var active = $('.ipCell .mui-active')[0]
		if (!active) {
			return
		}
		active.classList.remove('mui-active')
	}
	
	function getPopoContentHtml(type){
		var header = '<div class="headTip iconfont iconsetting">服务器地址及端口号配置<div id="configClose" class="iconfont iconerror1"></div></div>'
		var cateCell = '<li class="mui-table-view-cell cellFlex">'+
			'<div class="tip">类型：</div>'+
			'<div class="conRight cateCell">'+
				'<div class="option iconfont icondone" data-index="0">http</div>'+
				'<div class="option iconfont icondone" data-index="1">https</div>'+
			'</div></li>'
		var ipCell = '<li class="mui-table-view-cell cellFlex">'+
			'<div class="tip">IP：</div>'+
			'<div class="conRight cellFlex ipCell">'+
				'<div class="ipPart" data-index="0"></div><div class="drop">.</div><div class="ipPart" data-index="1"></div><div class="drop">.</div>'+
				'<div class="ipPart" data-index="2"></div><div class="drop">.</div><div class="ipPart" data-index="3"></div><div class="drop">:</div>'+
				'<div class="ipPart" data-index="4"></div>'+
			'</div></li>'
		var webCell = '<li class="mui-table-view-cell cellFlex">'+
			'<div class="tip">Web：</div>'+
			'<div id="webOptions" class="conRight webCell">'+
				'<div class="option iconfont icondone" data-index="0">dthealth/web</div>'+
				'<div class="option iconfont icondone" data-index="1">imedical/web</div>'+
				'<div class="option iconfont icondone" data-index="2">imedical/webservice</div>'+
			'</div></li>'
		var his = '<li class="mui-table-view-cell cellFlex">'+
			'<div class="tip">HIS：</div>'+
			'<div class="conRight hisCell">'+
				'<div class="option iconfont icondone" data-index="0">8.5及以后版本</div>'+
				'<div class="option iconfont icondone" data-index="1">8.4及以前版本</div>'+
			'</div></li>'
		var html='<div class="popoContent">'+header+
				'<ul class="mui-table-view">'+cateCell+ipCell+webCell+his+'</ul>'+
				'<div class="bottomBtns">'+
					'<button class="resetBtn">恢复默认</button>'+
					'<button class="confirmBtn">确认地址</button>'+
				'</div>'+
			'</div>'
		var numberBox = '<div id="numberBox" class="numberBox">'+
				'<div class="headTip">IP专用键盘<div id="numClose" class="iconfont iconerror1"></div></div>'+
				'<div class="cellFlex"><div id="clearPart" class="oneNum iconfont iconqingchu"></div>'+
					'<div id="backNum" class="oneNum iconfont iconbackspace"></div></div>'+
				'<div class="cellFlex"><div class="oneNum">1</div><div class="oneNum">2</div><div class="oneNum">3</div></div>'+
				'<div class="cellFlex"><div class="oneNum">4</div><div class="oneNum">5</div><div class="oneNum">6</div></div>'+
				'<div class="cellFlex"><div class="oneNum">7</div><div class="oneNum">8</div><div class="oneNum">9</div></div>'+
				'<div class="cellFlex"><div class="oneNum iconfont iconleft"></div><div class="oneNum">0</div><div class="oneNum iconfont iconright">.</div></div>'+
			'</div>'
		return html+numberBox
	}

})(mui)


