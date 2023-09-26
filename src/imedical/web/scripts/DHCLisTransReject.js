;(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);
GV.util={
	debounce:function(func, wait, immediate) {
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
	},
	formatPAPMINO:function(no){
		no+='';
		if(no!=""){
			while(no.length<10){
				no=0+''+no;
			}	
		}
		return no;
	},
	easyModal:function(title,url,width,height){
		var $easyModal=$('#easyModal');
		if ($easyModal.length==0){
			$easyModal=$('<div id="easyModal" style="overflow:hidden;"><iframe name="easyModal" style="	width: 100%;height: 100%; margin:0; border: 0;" scroll="auto"></iframe></div>').appendTo('body');
		}
		var maxWidth=$(window).width(),maxHeight=$(window).height();
		width=''+(width||'80%'),width=Math.min(maxWidth-20,(width.indexOf('%')>-1?parseInt(maxWidth*parseFloat(width)*0.01):parseInt(width)));
		height=''+(height||'80%'),height=Math.min(maxHeight-20,(height.indexOf('%')>-1?parseInt(maxHeight*parseFloat(height)*0.01):parseInt(height)));
		$easyModal.find('iframe').attr('src',url);
		$easyModal.dialog({
			iconCls:'icon-w-paper',
			modal:true,
			title:title,
			width:width,
			height:height
		}).dialog('open').dialog('center');
		
	}
}
GV.BaseInfoCP={  
	0:'IDValField', //登记号
	1:'PatNameValField',
	2:'SexValField',
	3:'AgeValField',
	4:'MedCareValField',
	7:'AppDepValField',
	8:'AppDocValField',
	13:'TelValField',
	5:'ArcItemValField'
}
GV.setBaseInfo=function(baseInfo){
	var baseArr=baseInfo.split("\\");
	for (var i in GV.BaseInfoCP){
		$('#'+GV.BaseInfoCP[i]).text(baseArr[i]);
	}
	//$('#BBNoValField').text(GV.epis);
	$('#BBNoValField').text(GV.epis.replace(/--/ig,'||')); //把双-换成双|
	 
}

GV.initInfo=function(){


}
var init=function(){
	/*
	if (GV.SendTime>1){
		$.m({
			ClassName:'web.DHCAntCVSend',
			MethodName:'GetSendHistory',
			reportID:GV.RepType+'||'+GV.ReportId,
			SendTime:GV.SendTime
			},function(rtn){
				rtn=$.parseJSON(rtn);
				
				var items=[];
				$.each(rtn,function(i,c){
					var o={};
					o.text='第'+c.SendTime+'发送 '+c.CreateDate+' '+c.CreateTime
					o.type='section',
					o.items=[];
					$.each(c.rows,function(i,r){
						o.items.push({text:r.UserName,id:'Det-'+r.DetailsId});
					})
					items.push(o);
				})
				//console.log(items);
				$('#SendHistory').keywords({
					items:items
				}).off('click');
				
				$('#SendHistory').find('ul.kw-section-list').append('<div style="clear:both"></div>');
				var c=$('#SendHistory-P').closest('.container');
				c.height(c.height()+($('#SendHistory')._outerHeight()-$('#SendHistory-P').height()));
				$('#SendHistory-P').panel('resize');
				
			}
		)
	}
	*/
	if (GV.ShowTransAdvice=="1") {
		$('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
	}else{
		$('#TransAdvice-TR').hide();
	}
	

	function formatByJson(template,data){
		if ("string" == typeof data ){
			data = $.parseJSON(data);
		}
		// template + data生成数据html
		return template.replace(/\{(.+?)\}/ig,function(m,i,d){
				return data[i]||'';
		}) ;
	}
	

	if (GV.reportInfoObj.repStatus=='1'){
		$('#TransAdvice').val(GV.reportInfoObj.OperateNotes);
		$('#btnSave').linkbutton('disable');
	}


	
	
	
	function saveTrans(){
		
		var TransAdvice=$('#TransAdvice').val()||'';
		TransAdvice=TransAdvice.replace(/\\/g,'$c(92)').replace(/\^/g,'$c(94)');

		if(TransAdvice==""){
			$.messager.alert('提示',"处理说明不能为空！");
			return;
		}
		$.m({
			ClassName:'DHCLIS.DHCRejectSpecimen',MethodName:'SaveOperate',
			RejectDR:GV.VisitNumberRejectSpecDR,
			UserID:GV.UserId,
			OperateNotes:TransAdvice,
			HospID:GV.HospId,
			DetailsId:GV.DetailsId
			},function(rtn){
				if(rtn==1){
					$.messager.alert('成功',"保存成功",'success',function(){
						closeWin();
					});
				}else{
					$.messager.alert('失败',"保存失败"+(rtn.split('^')[1]||rtn));
				}
			}
		)
	}
	
	
	$('#btnSave').click(saveTrans);
	$('#btnClose').click(function(){
		closeWin();
	})
	$(window).resize(GV.util.debounce(function(){
		$('body').find('div.panel:visible').each(function(){
			$(this).triggerHandler('_resize');
			
		})
		if($('#TransAdvice').is(':visible')) $('#TransAdvice').width($('#TransAdvice').closest('td').width()-20);
	},200));
	if (GV.ShowProcess=='1'){
		var pModal=findThisModal()
		if (pModal && pModal.length) {
			if (pModal.width()<1050) {
				pModal.window('resize',{width:1150}).window('center');
				$(window).resize();
			}
		}
	}

}

function findThisModal(id){
	var modal=null;
	var key=(new Date()).getTime()+'r'+parseInt(Math.random()*1000000);
	if (!window.parent || window.parent===window) return modal;
	try {
		var P$=window.parent.$;
	}catch(e){
		return modal;
	}
	if (typeof id=="string" && P$('#'+id).length>0) return P$('#'+id);
	
	window._findThisModalKey=key;
	
	P$('iframe').each(function(){
		try {
			if (this.contentWindow._findThisModalKey==key){
				modal=P$(this).closest('.window-body');
				return false;
			}
		}catch(e){}
		
	})
	return modal;
}

function closeWin(){
	var modal=findThisModal();
	if (modal && modal.length>0){
		modal.window('close');
	}else{
		window.close()
		if (parent && parent.closeTransWin) {
			parent.closeTransWin();
		}else if(top && top.HideExecMsgWin) {
			top.HideExecMsgWin();
		}
	}
	

}
$(function(){
	$.m({
		ClassName:'DHCLIS.DHCRejectSpecimen',
		MethodName:'GetAllInfo',
		VisitNumberRejectSpecDR:GV.VisitNumberRejectSpecDR,
		EpisodeID:GV.EpisodeID
	},function(ret){
		try{
			var obj=$.parseJSON(ret);
		}catch(e){
			var obj={success:0,msg:'返回数据格式错误'}
		}
		if (obj && obj.success=='1'){
			$('.data-ele').each(function(){
				var t=$(this);
				var key=t.data('key'),mth=t.data('mth')||'text';
				t[mth]( obj[key]||'');
			})
			GV.reportInfoObj=obj;
			init();
		}else{
			$.messager.alert("错误",obj.msg,function(){
				closeWin()
			},'error');
		}
		
	})
});