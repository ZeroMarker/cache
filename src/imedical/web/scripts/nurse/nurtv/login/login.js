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

(function() {
	mui.plusReady(function() {
		//系统信息
		var AppID = ''
		plus.runtime.getProperty( plus.runtime.appid, function(wigInfo){
			AppID = wigInfo.appid
			var vd = document.getElementById("vendor");
			vd.innerText += plus.device.vendor + " " +  plus.device.model+'('+plus.os.name + " " +  plus.os.version+')';
			var uuid = document.getElementById("uuid");
			uuid.innerText += plus.device.uuid + '-' + AppID;
			var hxw = document.getElementById("HxW");
			hxw.innerText = plus.screen.resolutionWidth + "x" + plus.screen.resolutionHeight + "@" + plus.screen.scale;
			//隐藏系统信息
			var inf = document.getElementById("infomation")
			inf.addEventListener('tap', function(){
				this.style.opacity = 1;
			}, false);
		});
	});
	var locData = {};
	var accStr, pwdStr,tokenStr;
	mui.DHCRequestXMl(function(result) {
		baseSetup();
	},function(err){
		var str = err;
		iziToast.error({
			class: 'logonError',
			title: str,
			position: 'center',
			timeout: 1000,
			color: '#FF0000',
			transitionOut: 'flipOutX',
			close: true
		});
	});
	
	function baseSetup() {
		var btn = document.getElementById('loginBtn');
		btn.addEventListener(tapType, function(){
			if (isShowVersion && !ISMOBILE) { //Windows演示版
				checkToken(function(msg){
					if (msg != 'err') {
						loginAction()
					}
				})
			}else{
				loginAction()
			}
		}, false);
		if (!isShowVersion&&ISMOBILE) {
			$('#configBtn')[0].style.display = 'block'
			mui('body').on(tapType,'#configBtn',function(){
				mui.showIpConfig()
			})
		}
	}

	function loginAction() {
		var accountInput = document.getElementById('account')
		var pswInput = document.getElementById('password');
		var accountStr = document.getElementById('account').value;
		var pswStr = document.getElementById('password').value;
		var tokenDom = document.getElementById('token');
		var tokenValue = tokenDom.value;
		
		if (locData && accStr != '' && pwdStr != '' && accStr == accountStr && pswStr == pwdStr) {
			if (isShowVersion && ISMOBILE && tokenValue != tokenStr) { //打包演示版token不一致
				locData = undefined
				loginAction();
				return
			}

			// console.log(locData.length)
			var index = $("#section ").get(0).selectedIndex; //索引
			if (index < 0) {
				iziToast.error({
					class: 'logonError',
					title: '请选择登录病区',
					position: 'center',
					timeout: 1000,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
				return;
			}
			//保存院区和科室
			var dict = locData[index];
			localStorage['hospId'] = dict['hospitalRowId'];
			var hospName = dict['hospitalName']
			hospName=hospName==undefined?"":hospName
			localStorage['hospName'] = hospName;
			localStorage['locId'] = dict['locId'];
			localStorage['wardId'] = dict['wardId'];
			localStorage['groupId'] = dict['groupId'];
			localStorage['locDesc'] = dict['locDesc'];
			getMergeWrad(dict['wardId'],dict['hospitalRowId'])
			return;
		} else if (accountStr == '' || pswStr == '') {
			if (pswStr == '' && accountStr != '') {
				iziToast.error({
					class: 'logonError',
					title: '请输入密码',
					position: 'center',
					timeout: 1000,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
			} else {
				iziToast.error({
					class: 'logonError',
					title: '请输入完整的用户名和密码',
					position: 'center',
					timeout: 1000,
					color: '#F4C059',
					transitionOut: 'flipOutX',
					close: true
				});
			}
			return;
		}else if (isShowVersion && ISMOBILE && tokenValue =="") {
			iziToast.error({
				class: 'logonError',
				title: '请输入授权码',
				position: 'center',
				timeout: 1000,
				color: '#F4C059',
				transitionOut: 'flipOutX',
				close: true
			});
			return
		}
		locData = undefined;
		var xmlStr = {
			'userCode': accountStr,
			'password': pswStr
		}
		accStr = accountStr;
		pwdStr = pswStr;
		$('#section').val('-1');
		if (isShowVersion && ISMOBILE) {
			tokenStr = tokenValue
			localStorage['token']=tokenStr
			checkToken(function(msg){
				if (msg != 'err') {
					GetLoginInfo(xmlStr)
				}
			})
		}else{
			GetLoginInfo(xmlStr)
		}
		
	}
	
	function GetLoginInfo(xmlStr){
		mui.DHCRequestXMl(function(result) {
			mui.DHCWebService('Logon', xmlStr, function(result) {
				if (result.status != 0) {
					iziToast.error({
						class: 'logonError',
						title: '用户名或密码错误！',
						position: 'center',
						timeout: 1000,
						color: '#F4C059',
						transitionOut: 'flipOutX',
						close: true
					});
					return;
				}
				updateLocsUI(result);
			}, function(errorStr) {
				var str = '登录:' + errorStr;
				iziToast.error({
					class: 'logonError',
					title: str,
					position: 'center',
					timeout: 1000,
					color: '#FF0000',
					transitionOut: 'flipOutX',
					close: true
				});
			});
		},function(err){
			var str = err;
			iziToast.error({
				class: 'logonError',
				title: str,
				position: 'center',
				timeout: 1000,
				color: '#FF0000',
				transitionOut: 'flipOutX',
				close: true
			});
		});
	}
	
	function getMergeWrad(wardId,hospId){
		iziToast.show({
			class: 'mergeData',
			color: 'dark',
			title: '获取合并病区',
			image: '../common/images/load.gif',
			position: 'center',
			timeout: null,
			color: '#F4C059',
			transitionOut: 'flipOutX',
			close: true
		});
		var xmlStr = {
			'WardID': wardId,
			'HospID': hospId
		}
		mui.DHCWebService('GetMergeWards', xmlStr, function(result) {
			hideToast();
			localStorage['originWard'] = JSON.stringify(result);
			window.location.href = '../index.html';
		}, function(errorStr) {
			hideToast()
			var str = '获取合并病区:' + errorStr;
			iziToast.error({
				class: 'mergeError',
				title: str,
				position: 'center',
				timeout: 1000,
				color: '#FF0000',
				transitionOut: 'flipOutX',
				close: true
			});
		});
	}

	function updateLocsUI(result) {
		localStorage['userCode'] = result['userCode'];
		localStorage['userId'] = result['userId'];
		localStorage['userName'] = result['userName'];
		locData = filterWardsData(result['locs']);
		var html = ''; //
		for (var i = 0; i < locData.length; i++) {
			var locDict = locData[i];
			html += '<option value="' + i + '">' + locDict['locDesc'] + '</option>'
		}
		var section = document.getElementById('section');
		section.innerHTML = html;
		$('#section').val('0');
	}

	function filterWardsData(result) {
		var arr = [];
		for (var i = 0; i < result.length; i++) {
			var dict = result[i];
			//本地化
			var hospid = dict['hospitalRowId'];
			var hospName = dict['hospitalName'];
			hospName=hospName==undefined?"":hospName
			var wardId = dict['wardId'];
			var locId = dict['locId'];
			var groupId = dict['groupId'];
			var tempArr = dict['locDesc'].split(' ');
			var locDesc = tempArr[0];
			var newDict = {
				'hospitalName': hospName,
				'hospitalRowId': hospid,
				'locDesc': locDesc,
				'wardId': wardId,
				'locId': locId,
				'groupId': groupId
			};
			if (i == 0) {
				arr[0] = newDict;
				continue;
			}
			var isContain = false;
			for (var j = 0; j < arr.length; j++) {
				var hos2 = arr[j]['hospitalRowId']
				var ward2 = arr[j]['wardId']
				var desc2 = arr[j]['locDesc']
				if (hos2 == hospid && ward2 == wardId && desc2 == locDesc) {
					isContain = true;
					break;
				}
			}
			if (!isContain) {
				arr.push(newDict)
			}
		}
		return arr;
	}
	// 绑定回车事件
	$(document).keydown(function(event) {
		if (event.keyCode == 13) {
			loginAction()
		}
	});
	
	function hideToast(str) {
		if (!str) {
			str = '.mergeData';
		}
		var toast = document.querySelector(str);
		if (toast) {
			iziToast.hide({
				transitionOut: 'fadeOutUp'
			}, toast);
		}
	}
})();
