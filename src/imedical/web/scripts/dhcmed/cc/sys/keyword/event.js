function InitviewScreenEvent(obj)
{
	
	obj.LoadEvent = function(args)
	{
		obj.Currrowid="";
		/*obj.gridResult.on("rowclick", obj.gridResult_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.gridResult.on("rowdblclick", obj.gridResult_rowdblclick, obj);*/
	};

obj.gridResult_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridResultStore.getAt(rowIndex);
		//alert(obj.Currrowid);
		//alert(objRec.get("rowid"));
		if(objRec.get("rowid")==obj.Currrowid)
		{
			obj.txtCode.setValue("");
			obj.txtTimeLineCode.setValue("");
			obj.txtDesc.setValue("");
			obj.cboIsActive.setValue("ture");
			obj.ResumeText.setValue("");
			obj.Currrowid="";
		}else{
			obj.txtCode.setValue(objRec.get("Code"));
			obj.txtTimeLineCode.setValue(objRec.get("TimeLineCode"));
			obj.txtDesc.setValue(objRec.get("Description"));
			obj.cboIsActive.setValue((objRec.get("IsActive") == "1"));
			obj.ResumeText.setValue(objRec.get("Resume"));
			obj.Currrowid=objRec.get("rowid")
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.txtCode.getValue()=="")||(obj.txtDesc.getValue()=="")){
			ExtTool.alert("提示","代码、名称不能为空,请认真填写!");
			return;	
		}
		var objKeywordInfo = ExtTool.StaticServerObject("DHCMed.CC.KeyWord");
		var tmp = obj.Currrowid;
		tmp += "^" + obj.txtCode.getValue();
		tmp += "^" + obj.txtDesc.getValue();
		tmp += "^" + (obj.cboIsActive.getValue()? "1" : "0");
		tmp += "^" + obj.ResumeText.getValue();
		tmp += "^" + obj.txtTimeLineCode.getValue();
		var ret = objKeywordInfo.Update(tmp);
		if (ret>0){
			obj.Currrowid="";
			obj.txtCode.setValue("");
			obj.txtTimeLineCode.setValue("");
			obj.txtDesc.setValue("");
			obj.cboIsActive.setValue("");
			obj.ResumeText.setValue("");
			obj.gridResultStore.load({});
		}else{
			ExtTool.alert("提示", "保存失败!");
		}
	};
}