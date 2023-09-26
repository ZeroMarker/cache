
function InitfrmPathWayVerEditEvent(obj) {
	obj.LoadEvent = function(args)
	{
	  	obj.CurrID = args[0];
	  	obj.CurrDicID = args[1];
		var DHCMRCClinPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
		obj.CurrDicString =  DHCMRCClinPathWaysDic.GetStringById(obj.CurrDicID);
		obj.CurrDicArry = obj.CurrDicString.split("^"); 
		
		if(obj.CurrID != "")
		{
			var DHCMRCClinicalPathWays = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
			var strInfo = DHCMRCClinicalPathWays.GetById(obj.CurrID);
			var arryFields = strInfo.split("^");
			
			obj.txtCode.setValue(arryFields[1]);
			obj.txtDesc.setValue(arryFields[2]);
			obj.txtPathType.setValue(arryFields[17]);
			obj.txtIsActive.setValue(arryFields[16]);
			obj.txtStartDate.setValue(arryFields[4]);
			obj.txtToDate.setValue(arryFields[5]);
			
			obj.CurrDicID = arryFields[15];
			obj.txtCost.setValue(arryFields[7]);
			obj.txtDays.setValue(arryFields[8]);
			obj.txtICD.setValue(arryFields[6]);
			obj.txtLabel.setValue(arryFields[9]);
			obj.txtVarReason.setValue(arryFields[10]);
			
			if (arryFields.length>17){
				if (arryFields[18]=="Yes") obj.chkIsOffShoot.setValue(1);    //add by wuqk 2010-07-21
				if (arryFields[19]=="SYNDROME") obj.chkIsOffShoot.setDisabled(true);    //add by wuqk 2010-07-21
			}
			if (arryFields.length>=24){
				obj.txtKeys.setValue(arryFields[22]);
				obj.txtOperICD.setValue(arryFields[23]);
				obj.txtOperKeys.setValue(arryFields[24]);
			}
		}else if(obj.CurrDicID != ""){
			var DHCMRCClinicalPathWaysDic = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysDicSrv");
			var strInfo = DHCMRCClinicalPathWaysDic.GetStringById(obj.CurrDicID,"^");
			var arryFields = strInfo.split("^");
			
			obj.txtCode.setValue(arryFields[1]);
			obj.txtDesc.setValue(arryFields[2]);
			obj.txtPathType.setValue(arryFields[8]);
			obj.txtIsActive.setValue(arryFields[4]);
			obj.txtStartDate.setValue(arryFields[5]);
			obj.txtToDate.setValue(arryFields[6]);
		}
		
		obj.btnSave.on("click", obj.btnSave_click, obj);
	};
	
	
	obj.SaveToString = function()
	{
		var strTmp = "";
		strTmp += obj.CurrID + "^";
		strTmp += obj.CurrDicID + "^";
		strTmp += obj.txtCost.getValue() + "^";
		strTmp += obj.txtDays.getValue() + "^";
		strTmp += obj.txtICD.getValue() + "^";	
		strTmp += obj.txtLabel.getValue() + "^";
		strTmp += obj.txtVarReason.getValue() + "^";
		strTmp += obj.chkIsOffShoot.getValue() + "^";            //add by wuqk 2011-07-21
		strTmp += obj.txtKeys.getValue() + "^";
		strTmp += obj.txtOperICD.getValue() + "^";
		strTmp += obj.txtOperKeys.getValue() + "^";

		return strTmp;
	}
	
	obj.btnSave_click = function()
	{
		var strArg = obj.SaveToString();
		var DHCMRCClinPathWays = ExtTool.StaticServerObject("web.DHCCPW.MRC.CliPathWay");
		try {
			var ret = DHCMRCClinPathWays.Update(strArg);
			if(ret > 0){
				ExtTool.alert("提示", "保存成功！");
			}
		} catch(e) {
			ExtTool.alert("错误", e.description, Ext.MessageBox.OK, Ext.MessageBox.ERROR);
		}
	}
}

