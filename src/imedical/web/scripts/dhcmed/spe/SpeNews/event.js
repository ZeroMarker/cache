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
			ExtTool.alert("����", "��������Ϣ!");
			return;
		}
		
		var InputStr=obj.SPN_Input.SpeID;
		InputStr += '^' + Opinion;
		InputStr += '^' + obj.SPN_Input.OperTpCode;
		InputStr += '^' + session['LOGON.USERID'];
		
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","SendNews",InputStr);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("����", "������Ϣʧ��!");
		} else {
			//ExtTool.alert("����", "������Ϣ�ɹ�!");
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
			ExtTool.alert("����", "�Ķ���Ϣʧ��!");
		} else {
			//ExtTool.alert("����", "�Ķ���Ϣ�ɹ�!");
			obj.SPN_gridSpeNewsListStore.load({});
		}
	}
	
	//ɾ����Ϣ�¼�
	obj.btnDeleteNews_Click = function(SpeLogID){
		if (!SpeLogID) return;
		Ext.MessageBox.confirm("ϵͳ��ʾ", "�Ƿ�ɾ����Ϣ��", function(but) {
			if (but=="yes"){
				var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","DeleteNews",SpeLogID,session['LOGON.USERID']);
				var arr = ret.split('^');
				if ((arr[0]*1)<1){
					if (arr[0] == '-100') {
						ExtTool.alert("����", "����Ϣ��Ч!");
					} else if (arr[0] == '-200') {
						ExtTool.alert("����", "������ɾ���Ǳ��˷��͵���Ϣ!");
					} else {
						ExtTool.alert("����", "ɾ����Ϣʧ��!");
					}
				} else {
					//ExtTool.alert("����", "ɾ����Ϣ�ɹ�!");
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
		//ˢ�¹�������ҳ��
		if (objScreen.WindowRefresh_Handler){
			objScreen.WindowRefresh_Handler();
		}
		//ˢ������б���
		if (objScreen.SpeGridRowRefresh_Handler){
			obj.gridSpeCheckListStore.reload({});
		}
		
	};
}
