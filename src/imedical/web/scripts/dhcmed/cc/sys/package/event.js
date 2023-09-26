
function InitViewportEvent(obj) {
	var objMethod = ExtTool.StaticServerObject("DHCMed.CC.MethodPackage");
	obj.LoadEvent = function(args)
	{
		obj.MethodPackage.on("rowclick", obj.MethodPackage_rowclick, obj);
		obj.butUpdate.on("click", obj.butUpdate_click, obj);
	};
	obj.butUpdate_click = function()
	{
		var Code =obj.Code.getValue();
		var Name =obj.Name.getValue();
	 	if(Code==""){
	 		ExtTool.alert("提示","代码不能为空!");
	 		return;
	 	}
	 	if(Name==""){
	 		ExtTool.alert("提示","名称不能为空!");
	 		return;
	 	}
	 	var tmp = obj.CurrRowid;
	 	if(tmp==""){
	 		var IsCheck=objMethod.CheckByCode(Code);
	 		if(IsCheck==1){
	 			ExtTool.alert("提示","代码重复，请重新填写!");
	 			return;
	 		}
	 	}
		tmp += "^"+obj.Code.getValue();
		tmp += "^"+obj.Name.getValue();
		tmp += "^"+(obj.IsActive.getValue()? "Y":"N");
		tmp += "^"+obj.ResumeText.getValue();
		var ret=objMethod.Update(tmp);
		if(ret>0) 
		{
			ClearData(obj);
			obj.MethodPackageStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("提示","保存失败!");
		}
	};
	obj.MethodPackage_rowclick = function()
	{
		var rc = obj.MethodPackage.getSelectionModel().getSelected();
		var MessagePID=rc.get("rowid");
		if(obj.CurrRowid!==MessagePID)
		{
			obj.CurrRowid=rc.get("rowid");
			obj.Code.setValue(rc.get("Code"));
			obj.Name.setValue(rc.get("Name"));
			obj.IsActive.setValue(rc.get("IsActive"));
			obj.ResumeText.setValue(rc.get("ResumeText"));	
		}else{
			ClearData(obj);	
		}
	};
}
function ClearData(obj)
{
	obj.CurrRowid="";
	obj.Code.setValue("");
	obj.Name.setValue("");
	obj.ResumeText.setValue("");
	obj.IsActive.setValue(1);
}