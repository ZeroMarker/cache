function ClearInfoData(obj)
{
	obj.winCurrRowid="";
	obj.winName.setValue();
	obj.winClassMethod.setValue();
	obj.winResumeText.setValue();
	obj.winDReturnValue.setValue();
	obj.winIsActive.setValue(1);
}
function InitViewportEvent(obj)
{
	var objInfo = ExtTool.StaticServerObject("DHCMed.CC.MethodInfo");
	obj.LoadEvent = function(args)
	{
		obj.MethodInfoList.on("rowclick", obj.MethodInfoList_rowclick, obj);
		obj.winBtnUpdate.on("click", obj.winBtnUpdate_click, obj);
	}
	obj.winBtnUpdate_click = function()
	{
		var ClassMethod =obj.winClassMethod.getValue();
		var Name =obj.winName.getValue();
	 	if(ClassMethod=="")
	 	{
	 		ExtTool.alert("提示","类方法不能为空!");
	 		return;
	 	}
	 	if(Name=="")
	 	{
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.winCurrRowid;
		tmp += "^"+obj.winPackageID;
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
			window.parent.RefreshLeftTree();
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.MethodInfoList_rowclick = function()
	{
		var rc = obj.MethodInfoList.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.winCurrRowid!=MessagePID)
		{
			obj.winCurrRowid=rc.get("rowid");
			obj.winName.setValue(rc.get("Name"));
			obj.winClassMethod.setValue(rc.get("ClassMetohd"));
			obj.winIsActive.setValue(rc.get("IsActive"));
			obj.winResumeText.setValue(rc.get("ResumeText"));
			obj.winDReturnValue.setValue(rc.get("DefaultReturnValue"));	
		}else{
			ClearInfoData(obj);	
		}
	};
}
