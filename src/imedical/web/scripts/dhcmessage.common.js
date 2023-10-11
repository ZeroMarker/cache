/*
*消息平台各界面能用到的公共方法
*/
// underscore 防抖
function debounce(func, wait, immediate) {
    var timeout, result;
    var debounced = function () {
        var context = this;
        var args = arguments;

        if (timeout) clearTimeout(timeout);
        if (immediate) {
            // 如果已经执行过，不再执行
            var callNow = !timeout;
            timeout = setTimeout(function(){
                timeout = null;
            }, wait)
            if (callNow) result = func.apply(context, args)
        }
        else {
            timeout = setTimeout(function(){
                func.apply(context, args)
            }, wait);
        }
        return result;
    };
    debounced.cancel = function() {
        clearTimeout(timeout);
        timeout = null;
    };
    return debounced;
}


var getTokenUrl=function(url){
	
	if(typeof url=='string' && url.indexOf('.csp')>-1) {
		var token='';
		if(typeof websys_getMWToken=='function' ){
			token= websys_getMWToken();
		}
		
		var arr=url.split('#');
		arr[0]=arr[0]+(arr[0].indexOf('?')>-1?'&':'?')+'MWToken='+token; 
		url=arr.join('#');
	}
	
	//alert('getTokenUrl:'+url)
	
	return url;
}



function easyModal(title,url,width,height,onClose){
	var maxWidth=$(window).width(),maxHeight=$(window).height();
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+height||'80%',height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var $easyModal=$('#dhcmessage-easyModal');
	if ($easyModal.length==0){
		$easyModal=$('<div id="dhcmessage-easyModal" style="overflow:hidden;" ><iframe name="dhcmessage-easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
	}
	
	url=getTokenUrl(url);
	
	$easyModal.find('iframe').attr('src',url);
	$easyModal.dialog({
		iconCls:'icon-w-paper',
		modal:true,
		title:title,
		width:width,
		height:height
		,onClose:function(){
			if (typeof onClose=='function'){
				onClose();
			}
			$easyModal.find('iframe').attr('src','about:blank');
		}
	}).dialog('open').dialog('center');
	
	return $easyModal;
	
}
/// 采用window.open打开窗口
function easyOriginWin(winname,url,width,height){
	winname=winname||'_blank';
	if (window.originWins && window.originWins[winname] && winname!='_blank' ) {
		try{
			window.originWins[winname].close();
		}catch(e){}	
	}
	if (!window.originWins) window.originWins={};
	
	var maxWidth=screen.availWidth-20;
	var maxHeight=screen.availHeight-40;
	
	width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
	height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
	var l=parseInt((maxWidth-width)/2),t=parseInt((maxHeight-height)/2);	
	
	if(typeof cefbound == 'object') { //医为浏览器
		l-=10;
		t-=31;
		width-=6;
		height-=113;
	}
			
	var features='top='+t+',left='+l+',width='+width+',height='+height+',toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,maximized=yes'
	
	url=getTokenUrl(url);
	
	window.originWins[winname]=window.open(url,winname,features);
	return window.originWins[winname];
}