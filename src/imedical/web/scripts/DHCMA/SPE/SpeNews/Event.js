function InitSpeNewsWinEvent(obj) {
	obj.LoadEvent = function(){
		
		$('#btnSend').on("click", function(){
			obj.SPN_btnSend_click();
		});
		$('#btnRead').on("click", function(){
			obj.SPN_btnRead_click();
		});
	  	$('#btnCancel').on("click", function(){
		  	obj.SPN_btnCancel_click();	  	
	  	});
	  	obj.gridSpeNewsList.load();
	}
	
	obj.SPN_btnSend_click = function(){
		var Opinion = $.trim($('#txtOpinion').val());
		if (Opinion == ''){
			$.messager.alert("错误","请输入消息!", 'info');
			return;
		}
		
		var InputStr=obj.SPN_Input.SpeID;
		InputStr += '^' + Opinion;
		InputStr += '^' + obj.SPN_Input.OperTpCode;
		InputStr += '^' + session['LOGON.USERID'];
		var ret = $m({
				ClassName:"DHCMed.SPEService.PatientsSrv",
				MethodName:"SendNews",
				aInputStr:InputStr		
			},false);
			
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			$.messager.alert("错误","发送消息失败!", 'info');
		} else {
			$.messager.popover({msg: '消息发送成功！',type:'success',timeout: 1000});
			obj.gridSpeNewsList.reload();
			$('#txtOpinion').val('');
			obj.SPN_WinSpeNews_Refresh();
		}
	}
	
	obj.SPN_btnRead_click = function(){
		var SpeID = obj.SPN_Input.SpeID;
		var OperTpCode = obj.SPN_Input.OperTpCode;
		var flg = $m({
			ClassName:"DHCMed.SPEService.PatientsSrv",
			MethodName:"CheckNews",
			aSpeID:obj.SPN_Input.SpeID,
			aOperTpCode:OperTpCode				
		},false);
		if (flg!=1) {
			$.messager.popover({msg: '消息已阅或无需阅读！',type:'info',timeout: 2000});
			return ;
		} else {
			var ret = $m({
				ClassName:"DHCMed.SPEService.PatientsSrv",
				MethodName:"ReadNews",
				aSpeID:obj.SPN_Input.SpeID,
				aUserID:session['LOGON.USERID'],
				aOperTpCode:OperTpCode				
			},false);
			var arr = ret.split('^');
			if ((arr[0]*1)<1){
				$.messager.alert("错误","阅读消息失败!", 'info');
			} else {
				$.messager.popover({msg: '阅读消息成功',type:'success',timeout: 1000});
				obj.gridSpeNewsList.reload();
				obj.SPN_WinSpeNews_Refresh();
			}
		}
	}
	
	//删除消息事件
	obj.btnDeleteNews_Click = function(SpeLogID){
		if (!SpeLogID) return;
		$.messager.confirm("系统提示", "是否删除消息？", function (r) {
			if (r){
				var ret = $m({
					ClassName:"DHCMed.SPEService.PatientsSrv",
					MethodName:"DeleteNews",
					aSpeLogID:SpeLogID,
					aUserID:session['LOGON.USERID']
				},false);
				var arr = ret.split('^');
				if ((arr[0]*1)<1){
					if (arr[0] == '-100') {						
						$.messager.alert("错误","此消息无效!", 'info');
					} else if (arr[0] == '-200') {
						$.messager.alert("错误","不允许删除非本人发送的消息!", 'info');
					} else {
						$.messager.alert("错误","删除消息失败!", 'info');
					}
				} else {
					$.messager.popover({msg: '删除消息成功',type:'success',timeout: 1000});
					var arr = SpeLogID.split('||');
					var SpeID = arr[0];
					obj.gridSpeNewsList.reload();
					obj.SPN_WinSpeNews_Refresh();
				}
			}
        });
	}
	
	obj.SPN_btnCancel_click = function(){
		//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
		websys_showModal('close');
	};
	
	//刷新
	obj.SPN_WinSpeNews_Refresh = function(){
		//刷新审核列表行
		var opt = websys_showModal("options");
		opt.originWindow.$('#SpeCheckList').datagrid('reload');
	    //刷新公共卫生页面	
	   			
	};
}
