/*
*Desc:异步加载图片
*Creater:Chenwenjun
*CreatDate:090507
*/

function makeAsyncRequest(url, divName, isCallBack, callback)
{
        var httpRequest;

        if (window.XMLHttpRequest) { // Mozilla, Safari, ...

                httpRequest = new XMLHttpRequest();
                if (httpRequest.overrideMimeType) {
                        httpRequest.overrideMimeType('text/xml');
                }
        } else if (window.ActiveXObject) { // IE

                try {
                        httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                        try {
                                httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (e) {
                        }
                }
        }

        httpRequest.onreadystatechange = function () {
                if (httpRequest.readyState == 4
                                && httpRequest.status == 200)
                        callback(url, divName, isCallBack);
        };

        httpRequest.open('GET', url, true);
        httpRequest.send('');
}

/*url:图片地址 divName:承载图片的DIV isShowLoading:是否提示正在下载的信息  isCallBack:是否回调*/
function displayImage(url, divName, isShowLoading, isCallBack)
{
	if (isShowLoading)
	{
		var div = document.getElementById(divName);
		var imgHtml = "<img src='../scripts/epr/Pics/loading.gif' width=16 height=16>图片加载中...</img>";
		div.innerHTML = imgHtml;
	}

        makeAsyncRequest(url, divName, isCallBack, function (url, divName, isCallBack) {
		if (isCallBack)
		{
			afterImgLoaded(url, divName);
		}
		else
		{
			var div = document.getElementById(divName);
                
			var imgHtml = "<img style='margin:auto;' src='" + url + "'>";                	div.innerHTML = imgHtml;
		}

        });
}