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
		if(objRec.get("Rowid")==obj.CurrICRowid)
		{
			obj.CurrICRowid="";
			obj.ICCode.setValue("");
			obj.ICDesc.setValue("");
		}else{
			obj.CurrICRowid=objRec.get("Rowid");
			obj.ICCode.setValue(objRec.get("Code"));
			obj.ICDesc.setValue(objRec.get("Desc"));
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ICCode.getValue()=="")||(obj.ICDesc.getValue()=="")){
			ExtTool.alert("提示","代码、描述不能为空,请认真填写!");
			return;	
		}
		//*******	Modified by zhaoyu 2012-11-30 临床路径维护-关联项目-增加关联项目大类，代码可以重复 192
		var BLICCode = obj.ICCode.getValue();
		var BLICRID = ""
		if (obj.CurrICRowid){
			BLICRID = obj.CurrICRowid;
		}
		var objBLIC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
		var CheckVal = objBLIC.CheckBLICCode(BLICCode,BLICRID)
		if(CheckVal==1){
			ExtTool.alert("提示","代码重复，请重新输入！");
			return
		}
		//*******
		var tmp = obj.CurrICRowid;
		tmp += "^" + obj.ICCode.getValue();
		tmp += "^" + obj.ICDesc.getValue();
		var objItemCat = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
		var ret = objItemCat.Update(tmp);
		if (ret>0){
			obj.CurrICRowid="";
			obj.ICCode.setValue("");
			obj.ICDesc.setValue("");
			obj.vGridPanelStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("提示", "更新失败!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrICRowid==""){
	 		ExtTool.alert("提示","请先选中一行,再删除!");
	 		return;
	 	}
		ExtTool.confirm('选择框','确定删除?',function(btn){
            if(btn=="no") return;
            var objIC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
			var ret = objIC.DeleteById(obj.CurrICRowid);
			if(parseInt(ret)>-1){
				obj.CurrICRowid="";
				obj.ICCode.setValue("");
				obj.ICDesc.setValue("");
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("提示","删除失败!");
			}
		});
	};
}
