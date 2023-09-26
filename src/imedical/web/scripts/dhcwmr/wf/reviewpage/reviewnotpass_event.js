function RVNP_InitReviewNotPassEvent(obj){
	obj.RVNP_LoadEvent = function(){
		obj.RVNP_btnCancel.on("click",obj.RVNP_btnCancel_click,obj);
		obj.RVNP_btnSave.on("click",obj.RVNP_btnSave_click,obj);
	};
	
	obj.RVNP_DisplayViewport = function(){
		Ext.ComponentMgr.all.each(function(cmp){
			var objTD = document.getElementById('cmp_' + cmp.id);
			if (objTD) {
				cmp.setWidth(objTD.offsetWidth);
				cmp.render('cmp_' + cmp.id);
			}
		});
	}
	
	obj.RVNP_btnSave_click = function(){
		var chkDocSmt = Common_GetValue('RVNP_chkDocSmt');
		var chkNurSmt = Common_GetValue('RVNP_chkNurSmt');
		var txtResume = Common_GetValue('RVNP_txtResume');
		if ((!chkDocSmt)&&(!chkNurSmt)){
			ExtTool.alert('提示', '请选择撤销医生/护士提交!');
			return;
		}
		if (txtResume == ''){
			ExtTool.alert('提示', '复核不通过，请填写原因!');
			Ext.getCmp("RVNP_txtResume").focus(false, 100);
			return;
		}
		
		var FinalAccountFlag = (chkNurSmt == true ? 1 : 0);
		var MRCompletionFlag = (chkDocSmt == true ? 1 : 0);
		var Remark = txtResume;
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviewSrv","ReviewNotPass",obj.RVNP_VolumeID,session['LOGON.USERID'],FinalAccountFlag,MRCompletionFlag,Remark);
		var arrRet=ret.split("^"); //add by niepeng 20150209
		if (arrRet[0] == '1'){
			ExtTool.alert("提示","病历复核未通过!");
		} else {
			ExtTool.alert("提示","病历复核未通过保存错误!");
			return;
		}
		//关闭窗体
		//obj.RVNP_WinReviewNotPass.close();
		obj.RVNP_btnCancel_click();
	}
	
	obj.RVNP_btnCancel_click = function(){
		obj.RVNP_WinReviewNotPass.close();
		var framePanel=document.getElementsByName("rightPanel").item(0);
		framePanel.style.display='';
	}
}