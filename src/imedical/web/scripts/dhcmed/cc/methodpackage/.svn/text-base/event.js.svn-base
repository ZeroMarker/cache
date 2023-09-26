
function InitViewportEvent(obj) {
	var objMethod = ExtTool.StaticServerObject("DHCMed.CC.MethodPackage");
	obj.LoadEvent = function(args)
  {};
	obj.btnFind_click = function()
	{
		obj.MethodPackageStore.load({params : {start:0,limit:20}});
	};
	obj.btnInfo_click = function()
	{
		var rc = obj.MethodPackage.getSelectionModel().getSelected();
		if(!rc)
		{
			ExtTool.alert("提示","请先选则一个函数包!");
			return;	
		}
		obj.rowid.setValue(rc.get("rowid"));
		if(obj.rowid.getValue()!=null)
		{
			var objMInfo = new InitMethodInfo();
			objMInfo.winPackageID.setValue(rc.get("rowid"));
			objMInfo.MethodInfoListStore.load({params : {start:0,limit:20}});
			objMInfo.MethodInfo.show();
		}
	};
	obj.butUpdate_click = function()
	{
		var Code =obj.Code.getValue();
		var Name =obj.Name.getValue();
	 	if(Code=="")
	 	{
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(Name=="")
	 	{
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.rowid.getValue();
		tmp += "^"+obj.Code.getValue();
		tmp += "^"+obj.Name.getValue();
		tmp += "^"+(obj.IsActive.getValue()? "Y":"N");
		tmp += "^"+obj.ResumeText.getValue();
		var ret=objMethod.Update(tmp);
		if(ret>0) 
		{
			ClearData(obj);
			obj.MethodPackageStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.MethodPackage_rowclick = function()
	{
		var rc = obj.MethodPackage.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.rowid.getValue()!=MessagePID)
		{
			obj.rowid.setValue(rc.get("rowid"));
			obj.Code.setValue(rc.get("Code"));
			obj.Name.setValue(rc.get("Name"));
			obj.IsActive.setValue(rc.get("IsActive"));
			obj.ResumeText.setValue(rc.get("ResumeText"));	
		}
		else
		{
			ClearData(obj);	
		}
	};
}
function ClearData(obj)
{
	obj.Code.setValue();
	obj.Name.setValue();
	obj.rowid.setValue();
	obj.ResumeText.setValue();
}
function ClearInfoData(obj)
{
	obj.winID.setValue();
	obj.winName.setValue();
	obj.winClassMethod.setValue();
	obj.winResumeText.setValue();
	obj.winDReturnValue.setValue();
}
function InitMethodInfoEvent(obj)
{	
	var objInfo = ExtTool.StaticServerObject("DHCMed.CC.MethodInfo");
	var parent=objControlArry['Viewport'];
	obj.LoadEvent = function(args)
	{
	}
	obj.winBtnFind_click = function()
	{
		obj.MethodInfoListStore.load({params : {start:0,limit:20}});
	};
	obj.winBtnUpdate_click = function()
	{
		var ClassMethod =obj.winClassMethod.getValue();
		var Name =obj.winName.getValue();
	 	if(ClassMethod=="")
	 	{
	 		ExtTool.alert("提示","书写格式不能为空!");
	 		return;
	 	}
	 	if(Name=="")
	 	{
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.winID.getValue();
		tmp += "^"+obj.winPackageID.getValue();
		tmp += "^"+obj.winName.getValue();
		tmp += "^"+obj.winClassMethod.getValue();
		tmp += "^"+(obj.winIsActive.getValue()? "Y":"N");
		tmp += "^"+obj.winResumeText.getValue();
		tmp += "^"+obj.winDReturnValue.getValue();
		var ret=objInfo.Update(tmp);
		if(ret>0) 
		{
			ClearInfoData(obj);
			obj.MethodInfoListStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.winBtnExit_click = function()
	{
		ClearData(parent);
		obj.MethodInfo.close();
	};
	obj.MethodInfoList_rowclick = function()
	{
		var rc = obj.MethodInfoList.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.winID.getValue()!=MessagePID)
		{
			obj.winID.setValue(rc.get("rowid"));
			obj.winName.setValue(rc.get("Name"));
			obj.winClassMethod.setValue(rc.get("ClassMetohd"));
			obj.winIsActive.setValue(rc.get("IsActive"));
			obj.winResumeText.setValue(rc.get("ResumeText"));
			obj.winDReturnValue.setValue(rc.get("DefaultReturnValue"));	
		}
		else
		{
			ClearInfoData(obj);	
		}
	};
}
