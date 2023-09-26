
function InitViewportEvent(obj) {
	var objSub = ExtTool.StaticServerObject("DHCMed.CC.SubjectCat");
	obj.LoadEvent = function(args)
  {};
	obj.btnFind_click = function()
	{
		obj.SubjectCatStore.load({params : {start:0,limit:20}});
	};
	obj.btnUpdate_click = function()
	{
		var Code =obj.Code.getValue();
		var Title =obj.Title.getValue();
	 	if(Code=="")
	 	{
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(Title=="")
	 	{
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.ID.getValue();
		tmp += "^"+obj.Code.getValue();
		tmp += "^"+obj.Title.getValue();
		tmp += "^"+obj.Desc.getValue();
		tmp += "^"+(obj.IsActive.getValue()? "1":"0");
		tmp += "^"+obj.ResumeText.getValue();
		var ret=objSub.Update(tmp);
		if(ret>0) 
		{
			ClearData(obj);
			obj.SubjectCatStore.load({params : {start:0,limit:20}});
		}
		else ExtTool.alert("提示","保存失败!");
	};
	obj.SubjectCat_rowclick = function()
	{
		var rc = obj.SubjectCat.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.ID.getValue()!=MessagePID)
		{
			obj.ID.setValue(rc.get("rowid"));
			obj.Code.setValue(rc.get("Code"));
			obj.Title.setValue(rc.get("Title"));
			obj.Desc.setValue(rc.get("Desc"));
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
	obj.Title.setValue();
	obj.Desc.setValue();
	obj.ID.setValue();
	obj.ResumeText.setValue();	
	
}

