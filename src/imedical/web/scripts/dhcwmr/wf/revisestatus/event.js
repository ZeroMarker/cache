function InitReviseStatusEvents(obj){
	obj.LoadEvents = function(){
		obj.btnRevise.on('click',obj.btnRevise_onclick,obj);
		obj.btnClose.on('click',obj.btnClose_onclick,obj);
		
		Common_LoadCurrPage('VolStatusGrid',1);
	}
	
	obj.ReviseUpdateStatus = function(StatusID,ReviseCode){
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviseSrv","ReviseUpdate",StatusID,ReviseCode,session['LOGON.USERID']);
		if (parseInt(ret) != 1){
			ExtTool.alert("提示","卷修正状态标记错误!");
			return;
		}
		Common_LoadCurrPage('VolStatusGrid');
	}
	
	obj.btnRevise_onclick = function(){
		var WorkItemID = '';
		var record = obj.VolStatusGrid.getSelectionModel().getSelected();
		if (record){
			WorkItemID = record.get("ItemID");
		}
		if (WorkItemID == '') {
			ExtTool.alert("提示","请选择对应卷状态,再修正!");
			return;
		}
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SSService.ReviseSrv","ReviseInsert",VolumeID,WorkItemID,session['LOGON.USERID']);
		if (parseInt(ret) != 1){
			if (ret.split("^")[0]==-3){
				ExtTool.alert("提示",ret.split("^")[1]+"!");
				return;
			}else{
				ExtTool.alert("提示","卷修正状态错误!");
				return;
			}
		}
		Common_LoadCurrPage('VolStatusGrid');
	}
	
	obj.btnClose_onclick = function(){
		window.close();
	}
}
