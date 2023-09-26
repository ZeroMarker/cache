

function InitwinSendMessageEvent(obj) {
	obj.LoadEvent = function(args)
	  {
		obj.CurrentEpisodeID = args[0];
		obj.CurrentSubjectID = args[1];
		obj.Callback = args[2];
	  };
  
	obj.Save = function()
	{
		var strArg = "";
		strArg += "^";
		strArg += obj.CurrentEpisodeID + "^";
		strArg += obj.CurrentSubjectID + "^";
		strArg += obj.txtMsg.getValue() + "^";
		strArg += session['LOGON.USERID'] + "^";
		strArg += "^";
		strArg += "^";
		strArg += obj.txtTitle.getValue() + "^";
		var ret = ExtTool.RunServerMethod("DHCMed.CC.CtlMessage", "Update", strArg, "^");
		return ret;
	}
  
  
	obj.btnOK_click = function()
	{
		if(obj.txtMsg.getValue() == "")
		{
			ExtTool.alert("提示", "请输入要发送的信息！" , Ext.MessageBox.INFO);
			return;			
		}
		var ret = obj.Save();
		if(ret > 0 )
		{
			ExtTool.alert("提示", "信息发送成功！" , Ext.MessageBox.INFO);
			if(obj.Callback)
			{
				var param = new Object();
				param.ClassName = 'DHCMed.CC.CtlMessage';
				param.QueryName = 'QryByEpisodeSubject';
				param.Arg1 = obj.CurrentEpisodeID;
				param.Arg2 = obj.CurrentSubjectID;		
				param.ArgCnt = 2;
				ChartTool.RunQuery(param, 
				function(arryResult){
					obj.Callback(arryResult);
				}, obj);					
			
			}
			obj.winSendMsg.close();
		}
		else
		{
			ExtTool.alert("错误", "保存失败！返回值：" + ret , Ext.MessageBox.INFO);
		}
	};
	obj.btnCancel_click = function()
	{
		obj.winSendMsg.close();
	};
/*winSendMessage新增代码占位符*/}

