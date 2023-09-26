function SPN_InitSpeNewsWinEvent(obj) {
	obj.SPN_LoadEvent = function(){
		obj.SPN_btnSend.on("click", obj.SPN_btnSend_click, obj);
		obj.SPN_btnRead.on("click", obj.SPN_btnRead_click, obj);
	  	obj.SPN_btnCancel.on("click", obj.SPN_btnCancel_click, obj);
		obj.SPN_gridSpeNewsListStore.load({});
	};
	
	obj.SPN_btnSend_click = function(){
		var Opinion = Common_GetValue("SPN_txtOpinion");
		if (Opinion == ''){
			ExtTool.alert("错误", "请输入消息!");
			return;
		}
		
		var InputStr=obj.SPN_Input.SpeID;
		InputStr += '^' + Opinion;
		InputStr += '^' + obj.SPN_Input.OperTpCode;
		InputStr += '^' + session['LOGON.USERID'];
		
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","SendNews",InputStr);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("错误", "发送消息失败!");
		} else {
			//ExtTool.alert("错误", "发送消息成功!");
			obj.SPN_gridSpeNewsListStore.load({});
			Common_SetValue("SPN_txtOpinion","");
		}
	}
	
	obj.SPN_btnRead_click = function(){
		var SpeID = obj.SPN_Input.SpeID;
		var OperTpCode = obj.SPN_Input.OperTpCode;
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","ReadNews",obj.SPN_Input.SpeID,session['LOGON.USERID'],OperTpCode);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("错误", "阅读消息失败!");
		} else {
			//ExtTool.alert("错误", "阅读消息成功!");
			obj.SPN_gridSpeNewsListStore.load({});
		}
	}
	
	//删除消息事件
	obj.btnDeleteNews_Click = function(SpeLogID){
		if (!SpeLogID) return;
		Ext.MessageBox.confirm("系统提示", "是否删除消息？", function(but) {
			if (but=="yes"){
				var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","DeleteNews",SpeLogID,session['LOGON.USERID']);
				var arr = ret.split('^');
				if ((arr[0]*1)<1){
					if (arr[0] == '-100') {
						ExtTool.alert("错误", "此消息无效!");
					} else if (arr[0] == '-200') {
						ExtTool.alert("错误", "不允许删除非本人发送的消息!");
					} else {
						ExtTool.alert("错误", "删除消息失败!");
					}
				} else {
					//ExtTool.alert("错误", "删除消息成功!");
					var arr = SpeLogID.split('||');
					var SpeID = arr[0];
					obj.SPN_gridSpeNewsListStore.load({});
				}
			}
        });
	}
	
	obj.SPN_btnCancel_click = function(){
		obj.SPN_WinSpeNews.close();
	};
	
	obj.SPN_WinSpeNews_close = function(){
		//刷新公共卫生页面
		if (objScreen.WindowRefresh_Handler){
			objScreen.WindowRefresh_Handler();
		}
		//刷新审核列表行
		if (objScreen.SpeGridRowRefresh_Handler){
			obj.gridSpeCheckListStore.reload({});
		}
		
	};
}
