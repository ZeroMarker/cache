function InitViewportEvent(obj) {
	obj.LoadEvent = function()
	{
		obj.CurrISCRowid=""
		obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
  	};
	obj.vGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.vGridPanelStore.getAt(rowIndex);
		
		//Modified By LiYang 2014-07-24 FixBug:1606 医政管理-监控中心-监控主题-维护项目子类时，点击选中某个项目子类，再次点击该记录，无法取消选中
		//if(objRec.get("rowid")==obj.CurrISCRowid)
		if(objRec.get("Rowid")==obj.CurrISCRowid)
		{
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.cboISCKeyWord.setValue("");
			obj.CurrISCRowid=""
		}else{
			obj.CurrISCRowid=objRec.get("Rowid");
			obj.ISCCode.setValue(objRec.get("Code"));
			obj.ISCDesc.setValue(objRec.get("Desc"));
			obj.cboISCKeyWord.setValue(objRec.get("KeywordID"));
			obj.Currrowid=objRec.get("rowid")
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ISCCode.getValue()=="")||(obj.ISCDesc.getValue()=="")){
			ExtTool.alert("提示","代码、描述不能为空,请认真填写!");
			return;
		}
		var objItemSubCat = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
		var tmp = obj.CurrISCRowid;
		tmp += "^" + obj.ISCCode.getValue();
		tmp += "^" + obj.ISCDesc.getValue();
		tmp += "^" + obj.CategID;
		tmp += "^" + obj.cboISCKeyWord.getValue();
		//alert(tmp)
		var ret = objItemSubCat.Update(tmp);
		//alert(ret)
		if (ret>0){
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.cboISCKeyWord.setValue("");
			obj.vGridPanelStore.load({});
			window.parent.RefreshLeftTree();
		}else if(ret==-1){
			ExtTool.alert("提示", "代码重复，请重新填写!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrISCRowid==""){
	 		ExtTool.alert("提示","请先选中一行,再删除!");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            var objISC = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
			var ret = objISC.DeleteById(obj.CurrISCRowid);
			if(ret>-1){
				obj.CurrISCRowid="";
				obj.ISCCode.setValue("");
				obj.ISCDesc.setValue("");
				obj.cboISCKeyWord.setValue("");
				obj.vGridPanelStore.load({});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("提示","删除失败!");
			}
		});
	};
}
