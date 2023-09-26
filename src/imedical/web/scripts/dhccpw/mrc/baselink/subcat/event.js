function InitViewportEvent(obj) {
	obj.LoadEvent = function()
	{
		obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
  	};
	obj.vGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.vGridPanelStore.getAt(rowIndex);
		if(objRec.get("Rowid")==obj.CurrISCRowid)
		{
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
		}else{
			obj.CurrISCRowid=objRec.get("Rowid");
			obj.ISCCode.setValue(objRec.get("Code"));
			obj.ISCDesc.setValue(objRec.get("Desc"));
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ISCCode.getValue()=="")||(obj.ISCDesc.getValue()=="")){
			ExtTool.alert("提示","代码、描述不能为空,请认真填写!");
			return;	
		}
		//*******	Modified by zhaoyu 2012-11-30 临床路径维护-关联项目-增加代码重复的关联项目子类，提示"更新失败"，建议给出明确提示 191
		var BLISCCode = obj.ISCCode.getValue();
		var BLISCRID = ""
		if (obj.CurrISCRowid){
			BLISCRID = obj.CurrISCRowid;
		}
		var objBLISC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
		var CheckVal = objBLISC.CheckBLISCCode(BLISCCode,BLISCRID)
		if(CheckVal==1){
			ExtTool.alert("提示","代码重复，请重新输入！");
			return
		}
		//*******
		var tmp = obj.CurrISCRowid;
		tmp += "^" + obj.ISCCode.getValue();
		tmp += "^" + obj.ISCDesc.getValue();
		tmp += "^" + obj.CategID;
		var objItemSubCat = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
		var ret = objItemSubCat.Update(tmp);
		if (ret>0){
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.vGridPanelStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("提示", "更新失败!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrISCRowid==""){
	 		ExtTool.alert("提示","请先选中一行,再删除!");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            var objISC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
			var ret = objISC.DeleteById(obj.CurrISCRowid);
			if(parseInt(ret)>-1){
				obj.CurrISCRowid="";
				obj.ISCCode.setValue("");
				obj.ISCDesc.setValue("");
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("提示","删除失败!");
			}
		});
	};
}
