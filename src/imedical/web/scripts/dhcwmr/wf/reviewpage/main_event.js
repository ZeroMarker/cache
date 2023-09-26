function InitReviewPageEvents(obj){
	obj.LoadEvents = function(){
		obj.btnReviewPass.on('click',obj.btnReviewPass_onclick,obj);
		obj.btnReviewNotPass.on('click',obj.btnReviewNotPass_onclick,obj);
		obj.btnFinaAuditPass.on('click',obj.btnFinaAuditPass_onclick,obj);
		obj.btnFinaAuditNotPass.on('click',obj.btnFinaAuditNotPass_onclick,obj);
		obj.btnClose.on('click',obj.btnClose_onclick,obj);
	}
	
	obj.btnReviewPass_onclick = function(){
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviewSrv","ReviewPass",VolumeID,session['LOGON.USERID']);
		var arrRet=ret.split("^"); //add by niepeng 20150209
		if (arrRet[0] == '1'){
			//ExtTool.alert("提示","病历复核通过!");
			alert("病历复核通过!");		//add by niepeng 20150210 复核通过确定后关闭复核界面
			window.close();
		} else {
			ExtTool.alert("提示","病历复核通过保存错误!");
			return;
		}
	}
	
	obj.btnReviewNotPass_onclick = function(){
		var framePanel=document.getElementsByName("rightPanel").item(0);
		framePanel.style.display='none';
		var win = new RVNP_InitReviewNotPass(VolumeID);
		win.RVNP_WinReviewNotPass.show();
		win.RVNP_DisplayViewport();
	}
	
	obj.btnFinaAuditPass_onclick = function(){
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviewSrv","FinaAuditPass",EpisodeID,session['LOGON.USERID']);
		if (parseInt(ret)>0){
			ExtTool.alert("提示","财务审核成功!");
		} else {
			ExtTool.alert("提示","财务审核失败!");
			return;
		}
	}
	
	obj.btnFinaAuditNotPass_onclick = function(){
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviewSrv","FinaAuditNotPass",EpisodeID,session['LOGON.USERID']);
		if (parseInt(ret)>0){
			ExtTool.alert("提示","撤销财务审核成功!");
		} else {
			ExtTool.alert("提示","撤销财务审核失败!");
			return;
		}
	}
	
	obj.btnClose_onclick = function(){
		window.close();
	}
}
