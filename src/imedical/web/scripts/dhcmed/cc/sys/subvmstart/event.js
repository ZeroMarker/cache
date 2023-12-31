function InitStartConfigEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.CurrRowid=""
		obj.CurrentSubjectID = args[0];
		obj.IDList.on("rowclick", obj.IDList_rowclick, obj);
		obj.btnFind.on("click", obj.btnFind_click, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
  	};
	obj.IDList_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.IDListStore.getAt(rowIndex);
		if(objRec.get("rowid")==obj.CurrRowid)
		{	
			obj.CurrRowid=""
			obj.IDCode.setValue("");
			obj.Description.setValue("");
			obj.VarName.setValue("");
			obj.cboRunType.setValue("");
			//obj.cboTitle.setValue("");
			obj.IsActive.setValue("true");
			obj.pnExpression.setValue("");
			obj.cboStartIndex.setValue("");
			obj.pnResumeText.setValue("");
			obj.CurrRowid=""
		}else{
			obj.CurrRowid=objRec.get("rowid");
			obj.IDCode.setValue(objRec.get("Code"));
			obj.Description.setValue(objRec.get("Description"));
			obj.VarName.setValue(objRec.get("VarName"));
			obj.cboRunType.setValue(objRec.get("RunType"));
			//obj.cboTitle.setValue(objRec.get("SubjectID"));
			obj.IsActive.setValue(objRec.get("IsActive")=="1");
			obj.pnExpression.setValue(objRec.get("Expression"));
			obj.cboStartIndex.setValue(objRec.get("StartIndex"));
			obj.pnResumeText.setValue(objRec.get("ResumeText"));
			obj.CurrRowid=objRec.get("rowid")
			//alert(obj.CurrRowid)
			
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.IDCode.getValue()=="")||(obj.Description.getValue()=="")||(obj.pnExpression.getValue()=="")){
			ExtTool.alert("提示","代码、描述、表达式不能为空,请认真填写!");
			return;
		}
		
		if(obj.VarName.getValue()=="") {
			ExtTool.alert("提示","变量名不能为空,请认真填写!");
			return;
		}
		if(obj.cboStartIndex.getValue()=="") {
			ExtTool.alert("提示","启动顺序不能为空,请认真填写!");
			return;
		}
		 
		var tmp = obj.CurrRowid;
		tmp += "^" +obj.CurrentSubjectID;
		tmp += "^" + obj.IDCode.getValue();
		tmp += "^" + obj.Description.getValue();
		tmp += "^" +(obj.IsActive.getValue()? "Y" : "N");
		tmp += "^" + obj.cboStartIndex.getValue();
		tmp += "^" + obj.pnExpression.getValue();
		tmp += "^" + obj.pnResumeText.getValue();
		tmp += "^" + obj.cboRunType.getValue();
		tmp += "^" + obj.VarName.getValue();
		var objSubVM = ExtTool.StaticServerObject("DHCMed.CC.SubjectVMStartConfig");
		var ret = objSubVM.Update(tmp);
	  //alert(ret);
		if (ret>0){
			obj.CurrISCRowid="";
			obj.IDCode.setValue("");
			obj.Description.setValue("");
			obj.IsActive.setValue("true");
			obj.cboRunType.setValue("");
			obj.cboStartIndex.setValue("");
			//obj.cboTitle.setValue("");
			obj.pnExpression.setValue("");
			obj.pnResumeText.setValue("");
			obj.VarName.setValue("");
			obj.IDListStore.load({});
		}else{
			ExtTool.alert("提示", "保存失败!");
		}
	};
	obj.btnFind_click = function()
	{
		obj.IDListStore.removeAll();
		obj.IDListStore.load({ params : { start:0 , limit:20 }});
	};
	obj.btnDelete_click = function(){
		if(obj.CurrRowid==""){
	 		ExtTool.alert("提示","请先选中一行,再删除!");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            var objISC = ExtTool.StaticServerObject("DHCMed.CC.SubjectVMStartConfig");
			var ret = objISC.DeleteById(obj.CurrRowid);
			if(ret>-1){
				obj.CurrISCRowid="";
				obj.IDCode.setValue("");
				obj.Description.setValue("");
				obj.VarName.setValue("");
				obj.cboRunType.getValue("");
				obj.cboStartIndex.getValue("");
				//obj.cboTitle.getValue("");
				obj.IsActive.getValue("true");
				document.getElementById("pnExpression").Text="";
				obj.pnResumeText.getValue();
				obj.IDListStore.load({});
			}else{
				ExtTool.alert("提示","删除失败!");
			}
		});
	};
}
