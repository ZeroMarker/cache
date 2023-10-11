/// 页面初始化函数
function initPageDefault(){
	InitParams();      /// 初始华参数
}

/// 初始化页面参数
function InitParams(){
	//EpisodeID = getParam("EpisodeID");   /// 就诊ID
}

/// 保存
function sure(){
	
	if(window.parent.frames["TRAK_main"]){
		if(window.parent.frames["dhcmessageexec"]){
			window.parent.frames["dhcmessageexec"].$("#reasonInput").val("");
		}else{
			if(window.parent.frames["TRAK_main"].frames["idhcem_consultquery"]){
				window.parent.frames["TRAK_main"].frames["idhcem_consultquery"].frames[0].$("#reasonInput").val("");
			}else{
				window.parent.frames["TRAK_main"].frames[0].$("#reasonInput").val("");
			}
		}
	}else{
		window.parent.frames[0].$("#reasonInput").val("");
	}
	
	var reason = $("#reason").val();       /// 原因
	if(reason==""){
		window.parent.$.messager.alert("提示:","原因不能为空！","warning");
		return;
	}
	if(window.parent.frames["TRAK_main"]){
		if(window.parent.frames["dhcmessageexec"]){
			window.parent.frames["dhcmessageexec"].$("#reasonInput").val(reason);
		}else{
			if(window.parent.frames["TRAK_main"].frames["idhcem_consultquery"]){
				window.parent.frames["TRAK_main"].frames["idhcem_consultquery"].frames[0].$("#reasonInput").val(reason);
			}else{
				window.parent.frames["TRAK_main"].frames[0].$("#reasonInput").val(reason);
			}
		}
	}else{
		window.parent.frames[0].$("#reasonInput").val(reason);
	}
	//window.parent.frames["dhcmessageexec"].$("#reasonInput").val(reason)
   	closewin();	/// 关闭
}

/// 关闭
function closewin(){
	websys_showModal('close');
}

/// JQuery 初始化页面
$(function(){ initPageDefault(); })
