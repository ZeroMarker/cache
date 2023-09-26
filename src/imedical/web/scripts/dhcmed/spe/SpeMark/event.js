function SPM_InitSpeMarkWinEvent(obj) {
	obj.SPM_LoadEvent = function(){
		obj.SPM_btnMark.on("click", obj.SPM_btnMark_click, obj);
		obj.SPM_btnUpdoMark.on("click", obj.SPM_btnUpdoMark_click, obj);
		obj.SPM_btnCheck.on("click", obj.SPM_btnCheck_click, obj);
		obj.SPM_btnUpdoCheck.on("click", obj.SPM_btnUpdoCheck_click, obj);
		obj.SPM_btnClose.on("click", obj.SPM_btnClose_click, obj);
		obj.SPM_btnUpdoClose.on("click", obj.SPM_btnUpdoClose_click, obj);
	  	obj.SPM_btnCancel.on("click", obj.SPM_btnCancel_click, obj);
		
		obj.SPM_cboPatTypeSub.getStore().load({});
		obj.SPM_cboPrognosis.getStore().load({});
		
		obj.SPM_InitSpeData();
		obj.SPM_DisplaySpeInfo();
		obj.SPM_DisplayButtons();
	};
	
	obj.SPM_DisplayButtons = function(){
		Common_SetVisible('SPM_btnMark',false);
		Common_SetVisible('SPM_btnUpdoMark',false);
		Common_SetVisible('SPM_btnCheck',false);
		Common_SetVisible('SPM_btnUpdoCheck',false);
		Common_SetVisible('SPM_btnClose',false);
		Common_SetVisible('SPM_btnUpdoClose',false);
		
		if (obj.SPM_Input.OperTpCode == '1'){  //��ǲ���
			if (obj.SPM_Input.SpeID == ''){
				Common_SetVisible('SPM_btnMark',true);
			} else {
				if (obj.SPM_SpeObj.StatusCode == '1'){
					Common_SetVisible('SPM_btnUpdoMark',true);
					Common_SetVisible('SPM_btnClose',(obj.SPM_SpeObj.IsFinal == '0'));
				} else if (obj.SPM_SpeObj.StatusCode == '2'){
					Common_SetVisible('SPM_btnClose',(obj.SPM_SpeObj.IsFinal == '0'));
				} else if (obj.SPM_SpeObj.StatusCode == '3'){
					Common_SetVisible('SPM_btnUpdoClose',(obj.SPM_SpeObj.IsFinal == '2'));
				}
			}
		} else if (obj.SPM_Input.OperTpCode == '2'){  //��˲���
			if (obj.SPM_Input.SpeID == ''){ //���⻼��ɸ����� ��ǲ���
				Common_SetVisible('SPM_btnMark',true);
			} else {
				if (obj.SPM_SpeObj.StatusCode == '1'){
					Common_SetVisible('SPM_btnUpdoMark',true);
					Common_SetVisible('SPM_btnCheck',true);
					Common_SetVisible('SPM_btnClose',(obj.SPM_SpeObj.IsFinal == '0'));
				} else if (obj.SPM_SpeObj.StatusCode == '2'){
					Common_SetVisible('SPM_btnUpdoCheck',true);
					Common_SetVisible('SPM_btnClose',(obj.SPM_SpeObj.IsFinal == '0'));
				} else if (obj.SPM_SpeObj.StatusCode == '3'){
					Common_SetVisible('SPM_btnUpdoClose',(obj.SPM_SpeObj.IsFinal == '2'));
				}
			}
		}
	}
	
	obj.SPM_InitSpeData = function(){
		if (obj.SPM_Input.SpeID != ''){
			var strSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetSepInfoByID",obj.SPM_Input.SpeID);
			if (strSpeInfo == '') return;
			var arrSepInfo = strSpeInfo.split('^');
			obj.SPM_Input.EpisodeID = arrSepInfo[1];
			obj.SPM_SpeObj = new Object();
			var tmp = arrSepInfo[2];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PatTypeID    = arr[0];
			obj.SPM_SpeObj.PatTypeDesc  = arr[1];
			var tmp = arrSepInfo[3];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PatTypeSubID    = arr[0];
			obj.SPM_SpeObj.PatTypeSubDesc  = arr[1];
			var tmp = arrSepInfo[4];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.StatusID   = arr[0];
			obj.SPM_SpeObj.StatusCode = arr[1];
			obj.SPM_SpeObj.StatusDesc = arr[2];
			var tmp = arrSepInfo[5];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.DutyDeptID   = arr[0];
			obj.SPM_SpeObj.DutyDeptDesc = arr[1];
			var tmp = arrSepInfo[6];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.DutyUserID   = arr[0];
			obj.SPM_SpeObj.DutyUserDesc = arr[1];
			var tmp = arrSepInfo[7];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.MarkDate     = arr[0];
			obj.SPM_SpeObj.MarkTime     = arr[1];
			obj.SPM_SpeObj.Note         = arrSepInfo[8];
			obj.SPM_SpeObj.Opinion      = arrSepInfo[9];
			var tmp = arrSepInfo[10];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.CheckDate    = arr[0];
			obj.SPM_SpeObj.CheckTime    = arr[1];
			obj.SPM_SpeObj.CheckOpinion = arrSepInfo[11];
			var tmp = arrSepInfo[12];
			var arr = tmp.split(' ');
			obj.SPM_SpeObj.FinalDate    = arr[0];
			obj.SPM_SpeObj.FinalTime    = arr[1];
			var tmp = arrSepInfo[13];
			var arr = tmp.split(CHR_1);
			obj.SPM_SpeObj.PrognosisID   = arr[0];
			obj.SPM_SpeObj.PrognosisDesc = arr[1];
			obj.SPM_SpeObj.IsCheck = arrSepInfo[14];
			obj.SPM_SpeObj.IsFinal = arrSepInfo[15];
		}
		
		var strAdmInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetPatInfoByAdm",obj.SPM_Input.EpisodeID);
		if (strAdmInfo == '') return;
		var arrAdmInfo = strAdmInfo.split('^');
		obj.SPM_PatObj = new Object();
		obj.SPM_PatObj.RegNo     = arrAdmInfo[4];
		obj.SPM_PatObj.PatName   = arrAdmInfo[5];
		obj.SPM_PatObj.Sex       = arrAdmInfo[6];
		obj.SPM_PatObj.Age       = arrAdmInfo[7];
		var tmp = arrAdmInfo[2];
		var arr = tmp.split(CHR_1);
		obj.SPM_PatObj.LocID     = arr[0];
		obj.SPM_PatObj.LocDesc   = arr[1];
		var tmp = arrAdmInfo[2];
		var arr = tmp.split(CHR_1);
		obj.SPM_PatObj.DocID     = arr[0];
		obj.SPM_PatObj.DocDesc   = arr[1];
	}
	
	obj.SPM_DisplaySpeInfo = function(){
		//��ʾ������Ϣ
		var strInfo = "�ǼǺţ�" + obj.SPM_PatObj.RegNo + "\n";
		strInfo += "����������" + obj.SPM_PatObj.PatName + "\n";
		strInfo += "�Ա�" + obj.SPM_PatObj.Sex;
		strInfo += "  ���䣺" + obj.SPM_PatObj.Age;
		Common_SetValue('SPM_txtPatBaseInfo',strInfo);
		//��ʾ���⻼����Ϣ
		if (obj.SPM_Input.SpeID != ''){
			Common_SetValue('SPM_cboPatTypeSub',obj.SPM_SpeObj.PatTypeSubDesc);  //���ߵ�����Ӧ����ʾΪ����
			Common_SetValue('SPM_txtNote',obj.SPM_SpeObj.Note);
			Common_SetValue('SPM_txtMarkDate',obj.SPM_SpeObj.MarkDate + ' ' + obj.SPM_SpeObj.MarkTime);
			Common_SetValue('SPM_txtCurrStatus',obj.SPM_SpeObj.StatusDesc);
			Common_SetValue('SPM_txtCheckOpinion',obj.SPM_SpeObj.CheckOpinion);
			Common_SetValue('SPM_txtCheckDate',obj.SPM_SpeObj.CheckDate + ' ' + obj.SPM_SpeObj.CheckTime);
			Common_SetValue('SPM_cboPrognosis',obj.SPM_SpeObj.PrognosisDesc);  //ת��Ӧ����ʾΪ����
			Common_SetValue('SPM_txtFinalDate',obj.SPM_SpeObj.FinalDate + ' ' + obj.SPM_SpeObj.FinalTime);
			
			if (obj.SPM_Input.OperTpCode == '1'){  //��ǲ���
				if (obj.SPM_SpeObj.StatusCode == '1'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',(obj.SPM_SpeObj.IsFinal != '0'));
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else if(obj.SPM_SpeObj.StatusCode == '2'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',(obj.SPM_SpeObj.IsFinal != '0'));
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else if(obj.SPM_SpeObj.StatusCode == '3'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',true);
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else {
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',true);
					Common_SetDisabled('SPM_txtFinalDate',true);
				}
			} else if (obj.SPM_Input.OperTpCode == '2'){  //��˲���
				if (obj.SPM_SpeObj.StatusCode == '1'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',false);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',(obj.SPM_SpeObj.IsFinal != '0'));
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else if(obj.SPM_SpeObj.StatusCode == '2'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',(obj.SPM_SpeObj.IsFinal != '0'));
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else if(obj.SPM_SpeObj.StatusCode == '3'){
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',true);
					Common_SetDisabled('SPM_txtFinalDate',true);
				} else {
					Common_SetDisabled('SPM_cboPatTypeSub',true);
					Common_SetDisabled('SPM_txtNote',true);
					Common_SetDisabled('SPM_txtMarkDate',true);
					Common_SetDisabled('SPM_txtCurrStatus',true);
					Common_SetDisabled('SPM_txtCheckOpinion',true);
					Common_SetDisabled('SPM_txtCheckDate',true);
					Common_SetDisabled('SPM_cboPrognosis',true);
					Common_SetDisabled('SPM_txtFinalDate',true);
				}
			}
		} else {
			Common_SetDisabled('SPM_cboPatTypeSub',false);
			Common_SetDisabled('SPM_txtNote',false);
			Common_SetDisabled('SPM_txtMarkDate',true);
			Common_SetDisabled('SPM_txtCurrStatus',true);
			Common_SetDisabled('SPM_txtCheckOpinion',true);
			Common_SetDisabled('SPM_txtCheckDate',true);
			Common_SetDisabled('SPM_cboPrognosis',true);
			Common_SetDisabled('SPM_txtFinalDate',true);
		}
	}
	
	obj.SPM_SaveSpeInfo = function(StatusCode){
		var PatTypeSubID = Common_GetValue('SPM_cboPatTypeSub');
		var Note = Common_GetValue('SPM_txtNote');
		var CheckOpinion = Common_GetValue('SPM_txtCheckOpinion');
		var PrognosisID = Common_GetValue('SPM_cboPrognosis');
		
		if (StatusCode == '1'){
			if (PatTypeSubID == ''){
				ExtTool.alert("����", "���⻼������Ϊ��!");
				return;
			}
		}
		
		if (obj.SPM_Input.SpeID != ''){
			var InputStr = obj.SPM_Input.SpeID;
			InputStr += '^' + obj.SPM_Input.EpisodeID;
			InputStr += '^' + obj.SPM_SpeObj.PatTypeSubID;
			InputStr += '^' + obj.SPM_SpeObj.DutyDeptID;
			InputStr += '^' + obj.SPM_SpeObj.DutyUserID;
			InputStr += '^' + obj.SPM_SpeObj.Note;
			InputStr += '^' + obj.SPM_SpeObj.Opinion;
			InputStr += '^' + obj.SPM_SpeObj.MarkDate;
			InputStr += '^' + obj.SPM_SpeObj.MarkTime;
			InputStr += '^' + StatusCode;
			InputStr += '^' + CheckOpinion;
			InputStr += '^' + obj.SPM_SpeObj.CheckDate;
			InputStr += '^' + obj.SPM_SpeObj.CheckTime;
			InputStr += '^' + PrognosisID;
			InputStr += '^' + obj.SPM_SpeObj.FinalDate;
			InputStr += '^' + obj.SPM_SpeObj.FinalTime;
			InputStr += '^' + session['LOGON.USERID'];
		} else {
			var InputStr = '';
			InputStr += '^' + obj.SPM_Input.EpisodeID;
			InputStr += '^' + PatTypeSubID;
			InputStr += '^' + session['LOGON.CTLOCID'];
			InputStr += '^' + session['LOGON.USERID'];
			InputStr += '^' + Note;
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '1';  //���״̬
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + '';
			InputStr += '^' + session['LOGON.USERID'];
		}
		InputStr += '^' + obj.SPM_Input.OperTpCode; // add maxp 2017-06-13 ����Ȩ������ 1:�ٴ����� 2:�����
		
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","SaveSpeOper",InputStr);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			if(arr[0]=='-3'){
				ExtTool.alert("����", "�Ѵ�����ͬ���⻼�߱�ǣ��������ظ����!");
			}
			else{
				ExtTool.alert("����", "�������⻼�߱��ʧ��!");
			}
		} else {
			obj.SPM_WinSpeMark.close();   //�رմ���
			obj.SPM_Input.SpeID = ret;
			//obj.SPM_WinSpeMark_close(); //���֮�����ˢ��
			//ˢ�¼���б���
			if (objScreen.CtrlGridRowRefresh_Handler){	
				objScreen.CtrlGridRowRefresh_Handler(obj.SPM_Input.SpeID);
			}
		}
	}
	
	obj.SPM_UpdoSpeInfo = function(UpdoStatusCode,Opinion){
		var InputStr = obj.SPM_Input.SpeID;
		InputStr += '^' + UpdoStatusCode;
		InputStr += '^' + Opinion;
		InputStr += '^' + session['LOGON.USERID'];
		var ret = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","UpdoSpeOper",InputStr);
		var arr = ret.split('^');
		if ((arr[0]*1)<1){
			ExtTool.alert("����", "�������⻼�߲���ʧ��!");
		} else {
			obj.SPM_WinSpeMark.close();   //�رմ���
		}
	}
	
	obj.SPM_btnMark_click = function(){
		obj.SPM_SaveSpeInfo('1');
	}
	
	obj.SPM_btnUpdoMark_click = function(){
		Ext.MessageBox.confirm("ϵͳ��ʾ", "�Ƿ��������⻼�߱�ǣ�", function(but) {
			if (but=="yes"){
				obj.SPM_UpdoSpeInfo('1','�������⻼�߱��');
			}
        });
	}
	
	obj.SPM_btnCheck_click = function(){
		obj.SPM_SaveSpeInfo('2');
	}
	
	obj.SPM_btnUpdoCheck_click = function(){
		Ext.MessageBox.confirm("ϵͳ��ʾ", "�Ƿ�ȡ��������⻼�߱�ǣ�", function(but) {
			if (but=="yes"){
				obj.SPM_UpdoSpeInfo('2','ȡ��������⻼�߱��');
			}
        });
	}
	
	obj.SPM_btnClose_click = function(){
		obj.SPM_SaveSpeInfo('3');
	}
	
	obj.SPM_btnUpdoClose_click = function(){
		Ext.MessageBox.confirm("ϵͳ��ʾ", "�Ƿ����ر����⻼�߱�ǣ�", function(but) {
			if (but=="yes"){
				obj.SPM_UpdoSpeInfo('3','�����ر����⻼�߱��');
			}
        });
	}
	
	obj.SPM_btnCancel_click = function(){
		obj.SPM_WinSpeMark.close();
	};
	
	obj.SPM_WinSpeMark_close = function(){
		//ˢ�¼���б���
		if (objScreen.CtrlGridRowRefresh_Handler){
			objScreen.CtrlGridRowRefresh_Handler(obj.SPM_Input.SpeID);
		}
		
		//ˢ������б���
		if (objScreen.SpeGridRowRefresh_Handler){
			objScreen.SpeGridRowRefresh_Handler(obj.SPM_Input.SpeID);
		}
		
		//ˢ�¹�������ҳ��
		if (objScreen.WindowRefresh_Handler){
			objScreen.WindowRefresh_Handler();
		}
	}
}
