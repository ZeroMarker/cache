function LI_InitLendInfoEvent(obj) {
	obj.LI_LoadEvent = function(){
		obj.LI_btnCancel.on("click",obj.LI_btnCancel_click,obj);
		obj.LI_btnSave.on("click",obj.LI_btnSave_click,obj);
		obj.LI_cboLendLoc.on("select",obj.LI_cboLendLoc_select,obj);
	};
	
	obj.LI_cboLendLoc_select = function(combo,record,index){
		Common_SetValue("LI_cboLendDoc","","");
		obj.LI_cboLendDoc.getStore().removeAll();
		obj.LI_cboLendDoc.getStore().load({});
	}
	
	obj.LI_btnSave_click = function(){
		var Error='';
		var MrTypeID = Common_GetValue("cboMrType");
		if (!MrTypeID){
			ExtTool.alert("��ʾ",'��������Ϊ��!');
			return;
		}
		
		var LLocID = Common_GetValue("LI_cboLendLoc");
		var LLocDesc = Common_GetText("LI_cboLendLoc");
		var LLocTel = Common_GetValue("LI_txtLLocTel");
		var LCareProvID = Common_GetValue("LI_cboLendDoc");   
		var LCareProvName = Common_GetText("LI_cboLendDoc");
		var LUserTel = Common_GetValue("LI_txtLUserTel");
		var LPurpose = Common_GetValue("LI_cbgLPurpose");
		var LExpBackDate = Common_GetValue("LI_txtLExpBackDate");
		var LNote = Common_GetValue("LI_txtLNote");
		if (LPurpose != "") LPurpose = LPurpose.replace(/,/g,'#');
		if (!LCareProvName) Error = Error+'����ҽ����';
		if (!LLocDesc) Error = Error+'���Ŀ��ҡ�';
		if (Error)
		{
			ExtTool.alert("��ʾ",Error+'Ϊ�գ�');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LL");
		if (!objWFItem){
			ExtTool.alert("��ʾ",'�޳��������Ŀ!');
			return;
		}
		
		var Deatil = LLocID                     //���Ŀ���
			+ "^" + LLocDesc                    //���Ŀ�������
			+ "^" + LLocTel                     //���Ŀ��ҵ绰
			+ "^" + LCareProvID                 //�����ˣ�ҽ����Ա��
			+ "^" + LCareProvName               //������������ҽ����Ա��
			+ "^" + LUserTel                    //�����˵绰
			+ "^" + LPurpose                    //����Ŀ��
			+ "^" + LExpBackDate                //Ԥ�ƹ黹����
			+ "^" + LNote                       //��ע

		var objInput = new Object();
		objInput.OperType = 'L';
		objInput.ToUserID = '';
		objInput.MRecord = obj.MRecords;
		objInput.LRecord = '';
		objInput.Detail = Deatil;
		objInput.LendFlag = '';
		objInput.WFIBatchOper = objWFItem.WFIBatchOper;
		
		obj.LI_WinLendInfo.close();
		
		//�Ƿ��û�У��
		if (objWFItem.WFICheckUser == 1){
			var win = new CU_InitCheckUser(objInput);
			win.WinCheckUser.show();
		} else {
			objScreen.SaveData(objInput);
		}
	}
	
	obj.LI_btnCancel_click = function(){
		obj.LI_WinLendInfo.close();
	}
}