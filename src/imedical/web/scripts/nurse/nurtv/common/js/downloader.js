var downloader = (function ($) {
	var dtask=undefined;
	var container,progressTimer;
	function initDownLoader(){
		var mainDom = document.getElementById('downloader');
		if (mainDom) {
			showDownLoader();
			return
		}
		mainDom = document.createElement('div');
		document.body.appendChild(mainDom);
		mainDom.setAttribute('class','mui-popover downloadPopo')
		mainDom.id = 'downloader';
		
		mainDom.innerHTML = '<div class="headTip">检查更新'+
			'<div id="downloadCloseBtn" class="iconfont iconerror1"></div></div>'+
			'<div id="stepArea" class="stepArea"><div id="stepTip" class="stepTip"></div>'+
			'<p id="progressP" class="progressP" style="width: 15rem;"></p></div>';
		var downloadCloseBtn = document.getElementById('downloadCloseBtn');
		downloadCloseBtn.addEventListener('tap',HideDownLoader,false);
		mui('body').on('hidden', '.mui-popover', function(e) {
			if (this.id == 'downloader') {
				HideDownLoader();
			}
		});
		container = mui("#stepArea p");
		mui(container).progressbar({
			progress: 0
		}).show();
		showDownLoader();
	}
	
	function showDownLoader(){
		var mainDom = document.getElementById('downloader');
		mainDom.classList.add('mui-active');
		var stepTip = document.getElementById('stepTip');
		stepTip.innerHTML = '正在检验安装包'
		setTimeout(function() {
			container.progressbar().setProgress(0);
		}, 0);
	}
	
	function HideDownLoader(){
		var mainDom = document.getElementById('downloader');
		 mainDom.classList.remove('mui-active');
		 if (dtask) {
		 	dtask.clear();
		 	dtask = undefined
		 }
	}
	
	function createDownloadTask(url,newVersion){
		if (!dtask) {
			var requestName = 'nurtv'+newVersion+url.substring(url.length - 4);
			var options = {method:"GET",filename:"_downloads/"+requestName,retryInterval:10};
			dtask = plus.downloader.createDownload(url, options,function(d, status){
				if(status != 200){ // 下载失败
					var stepTip = document.getElementById('stepTip');
					stepTip.innerHTML = '下载失败！'
					setTimeout(function() {
						container.progressbar().setProgress(progress);
					}, 0);
					if (dtask) {
						dtask.clear();
						dtask = undefined
					}
				}
			});
			dtask.addEventListener( "statechanged", function(task,status){
				if(!dtask){return;}
				var stepTip = document.getElementById('stepTip');
				switch(task.state) {
					case 3:	// 已接收到数据
						stepTip.innerHTML = '正在下载！'
						setTimeout(function() {
							var progress = (task.downloadedSize / task.totalSize) * 100;
							container.progressbar().setProgress(progress);
						}, 0);
					break;
					case 4:	// 下载完成
						dtask = undefined
						stepTip.innerHTML = '正在安装！'
						setTimeout(function() {
							container.progressbar().setProgress(0);
						}, 0);
						//找到文件,打开文件
						var filePath = getfilepath(requestName)
						setupInstallTimer(filePath);
					break;
				}
			});
		}
		dtask.start();
		stepTip.innerHTML = '准备下载！'
	}

	function downLoadAPK(url,newVersion){
		initDownLoader();
		if (!checkPackageUrl(url)) { //判断路径是否完整
			return
		}
		var index = 0;
		deleteAllFiles(function(count){ //清除所有安装包
			index += 1;
			if (index == count || count ==0) {
				createDownloadTask(url,newVersion); //下载新的安装包
			}
		});
	}
	
	function setupInstallTimer(filePath){
		var progress = 0
		progressTimer = setInterval(function(){
			progress += 5
			setTimeout(function(){
				container.progressbar().setProgress(progress);
			},0)
			if(progress >= 80 && progressTimer){
				clearInterval(progressTimer);
				progressTimer = undefined
			}
		},100);
		setTimeout(function(){
			installApk(filePath);
		},200);
	}
	
	function installApk(filePath){
		var stepTip = document.getElementById('stepTip');
		plus.runtime.install(filePath, {force:true}, function(WidgetInfo ){
			stepTip.innerHTML = '安装成功';
			setTimeout(function() {
				container.progressbar().setProgress(100);
			}, 0);
			clearInterval(progressTimer);
			if (filePath.indexOf('.apk') != -1) {//apk包会跳转安装界面这里直接关闭即可
				HideDownLoader()
				return;
			}
			stepTip.innerHTML = '删除安装包';
			setTimeout(function() {
				var index = 0;
				deleteAllFiles(function(count){
					index += 1;
					var percent = 0;
					if (count == 0) {
						percent = 100;
					}else{
						percent = (index/count)*100;
					}
					setTimeout(function() {
						container.progressbar().setProgress(percent);
					}, 0);
					if (index == count || count == 0) {
						stepTip.innerHTML = '白板重启';
						setTimeout(function() {
							plus.runtime.restart();
						}, 500);
					}
				});
			}, 500);
		}, function(errorInfo){
			var version = document.getElementById('version');
			var appid = version.getAttribute('data-appid')
			stepTip.innerHTML = '<span>'+errorInfo.message+' APPID:'+appid+'</span>';
			clearInterval(progressTimer);
			setTimeout(function() {
				container.progressbar().setProgress(0);
			}, 0);
			deleteAllFiles(function(count){})
		});
	}
	
	function checkPackageUrl(url){
		var stepTip = document.getElementById('stepTip');
		if (url.length < 11) {
			stepTip.innerHTML = '安装包路径不正确';
			return false
		}
		var preStr = url.substring(0,8)
		var endStr = url.substring(url.length - 4)
		var isHttp = preStr.indexOf('http://')
		var isHttps = preStr.indexOf('https://')
		var isApk = endStr.indexOf('.apk')
		var isWgt = endStr.indexOf('.wgt')
		if ((isHttp != 0 && isHttps != 0) || (isApk == -1 && isWgt == -1)) {
			stepTip.innerHTML = '安装包路径不正确';
			return false
		}
		return true
	}
	
	var downloaderObj = {}
	downloaderObj.initDownLoader = initDownLoader;
	downloaderObj.downLoadAPK = downLoadAPK;
	return downloaderObj
})(mui);


function downLoadAPK(url,newVersion){
	//downloader.initDownLoader();
	downloader.downLoadAPK(url,newVersion);
}

