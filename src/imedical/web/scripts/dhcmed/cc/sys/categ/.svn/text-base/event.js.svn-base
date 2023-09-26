function InitViewportEvent(obj) {
	obj.LoadEvent = function()
	{
		obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
         obj.cboDep.on("expand", 
            function(){obj.cboDep.clearValue();}
          );
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
              obj.cboDep.setValue("");
		}else{
			obj.CurrICRowid=objRec.get("Rowid");
			obj.ICCode.setValue(objRec.get("Code"));
			obj.ICDesc.setValue(objRec.get("Desc"));
              obj.cboDep.setRawValue(objRec.get("Dep"));
              obj.cboDepStore.load({
                    callback : function()
                    {
                        obj.cboDep.setValue(objRec.get("DepID"));
                    }
              });
              
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ICCode.getValue()=="")||(obj.ICDesc.getValue()=="")){
			ExtTool.alert("提示","代码、描述不能为空,请认真填写!");
			return;	
		}
		var tmp = obj.CurrICRowid;
		tmp += "^" + obj.ICCode.getValue();
		tmp += "^" + obj.ICDesc.getValue();
		tmp += "^" + obj.SubjectID;
         tmp += "^" + obj.cboDep.getValue();
         tmp += "^" + "";
		var objItemCat = ExtTool.StaticServerObject("DHCMed.CC.ItemCat");
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
            var objIC = ExtTool.StaticServerObject("DHCMed.CCService.Sys.ItemCatSrv");
			var ret = objIC.DeleteItemCat(obj.CurrICRowid);
			if(ret>0){
				obj.CurrICRowid="";
				obj.ICCode.setValue("");
				obj.ICDesc.setValue("");
                  obj.cboDep.setValue("");
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("提示","删除失败!");
			}
		});
	};
}
