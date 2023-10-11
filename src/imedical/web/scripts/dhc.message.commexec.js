var init=function(){
	$.m({
		ClassName:'websys.DHCMessageContentExec',
		MethodName:'GetByDetailsId',
		DetailsId:GV.DetailsId
	},function(ret){
		var obj=$.parseJSON(ret)
	
		if (obj.msg && obj.msg!='') {
			$.messager.alert('成功',obj.msg,'error',function(ret){
				closeWin();
			})
		}else{
			if (obj.ExecUserCode && obj.ExecUserCode!='') {
				$('#execUserCode').val(obj.ExecUserCode);
				$('#execNote').val(obj.ExecNote);
			}else{
				$('#btn-ok').linkbutton('enable');
			}
			
		}
	})
	
	
	
	$('#btn-ok').click(function(){
		if ($(this).hasClass('l-btn-disabled')) return false;
		
		var execNote=$('#execNote').val();
		var execUserCode=$('#execUserCode').val();
		var execUserPwd='',execUserPwdMD5='';
		
		if ($('#execUserPwd').length>0) {
			execUserPwd=$('#execUserPwd').val();
			execUserPwdMD5=hex_md5(dhc_cacheEncrypt(execUserPwd));
		}
		
		$.m({
			ClassName:'websys.DHCMessageContentExec',
			MethodName:'Exec',
			DetailsId:GV.DetailsId,
			ExecNote:execNote,
			ExecAuditFlag:'Y',
			ExecUserCode:execUserCode,
			ExecUserPwd:execUserPwdMD5
		},function(ret){
			
			if (ret>0) {
				$.messager.alert('成功','保存成功','success',function(){
					closeWin();
				})	;
				
			}else{
				$.messager.alert('失败',ret.split('^')[1]||ret)	;
			}
		})
		
	})
	$('#btn-close').click(function(){
		if ($(this).hasClass('l-btn-disabled')) return false;
		closeWin();
	})
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
	}
}


$(init);