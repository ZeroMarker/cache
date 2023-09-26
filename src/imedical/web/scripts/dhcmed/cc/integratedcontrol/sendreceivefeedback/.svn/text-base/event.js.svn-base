

function InitwinSendReceiveFeedbackEvent(obj) {
	obj.LoadEvent = function(args)
	  {
		obj.CurrentFeedBackID = args[0];
		obj.Callback = args[1];
		obj.CallbackScope = args[2];
	  };
  
	obj.Save = function()
	{
		var ret = "";
		var arrRec = obj.CurrentFeedBackID.split(",");
		for (var indRec = 0; indRec < arrRec.length; indRec++) {
			var FeedBackID = arrRec[indRec];
			if (!FeedBackID) continue;
			
			var strArg = "";
			strArg += FeedBackID + "^";
			strArg += obj.txtMsg.getValue() + "^";
			strArg += session['LOGON.USERID'] + "^";
			strArg += "^";
			strArg += "^";
			strArg += "2^";
			ret = ExtTool.RunServerMethod("DHCMed.CC.CtlFeedback", "UpdateAllReceiveFeedBack", strArg, "^");
		}
		return ret;
	}
	
	obj.btnOK_click = function()
	{
		if(obj.txtMsg.getValue() == "")
		{
			ExtTool.alert("提示", "请输入拒绝的理由！" , Ext.MessageBox.INFO);
			return;
		}
		var ret = obj.Save();
		if(ret > 0 )
		{
			ExtTool.alert("提示", "保存成功！" , Ext.MessageBox.INFO);
			if(obj.Callback)
			{
				obj.Callback.call(obj.CallbackScope);			
			}
			obj.winReject.close();
		}
		else
		{
			ExtTool.alert("错误", "保存失败！返回值：" + ret , Ext.MessageBox.INFO);
		}
	};
	obj.btnCancel_click = function()
	{
		obj.winReject.close();
	};
/*winSendMessage新增代码占位符*/}

