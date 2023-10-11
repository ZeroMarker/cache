function initPageDefault(){
	PageDefault();
	
	}

function PageDefault(){
	$('#tt3').tabs({ 
		border:false, 
		onSelect:function(title){ 	
			var iframe = null;// 得到iframe
			if("知识来源配置"==title){
				iframe = $('#first')[0];// 得到iframe
			}
			if("目录优先级配置"==title){
				iframe = $('#second')[0];// 得到iframe
			}   
			if(iframe){
			iframe = (iframe.contentWindow || iframe.contentDocument);// 得到iframe窗口内容
			//console.log(iframe);
			iframe.location.reload(true); // 刷新整个页面列表
			
			}
		} 
	}); 
	}


/// JQuery 初始化页面
$(function(){ initPageDefault(); })
