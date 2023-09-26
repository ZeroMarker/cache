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
			ExtTool.alert("提示",'病案类型为空!');
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
		if (!LCareProvName) Error = Error+'借阅医生、';
		if (!LLocDesc) Error = Error+'借阅科室、';
		if (Error)
		{
			ExtTool.alert("提示",Error+'为空！');
			return;
		}
		var objWFItem = ExtTool.RunServerMethod('DHCWMR.SS.WorkFItem','GetWFItemBySysOpera',MrTypeID,"LL");
		if (!objWFItem){
			ExtTool.alert("提示",'无出库操作项目!');
			return;
		}
		
		var Deatil = LLocID                     //借阅科室
			+ "^" + LLocDesc                    //借阅科室名称
			+ "^" + LLocTel                     //借阅科室电话
			+ "^" + LCareProvID                 //借阅人（医护人员）
			+ "^" + LCareProvName               //借阅人姓名（医护人员）
			+ "^" + LUserTel                    //借阅人电话
			+ "^" + LPurpose                    //借阅目的
			+ "^" + LExpBackDate                //预计归还日期
			+ "^" + LNote                       //备注

		var objInput = new Object();
		objInput.OperType = 'L';
		objInput.ToUserID = '';
		objInput.MRecord = obj.MRecords;
		objInput.LRecord = '';
		objInput.Detail = Deatil;
		objInput.LendFlag = '';
		objInput.WFIBatchOper = objWFItem.WFIBatchOper;
		
		obj.LI_WinLendInfo.close();
		
		//是否用户校验
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