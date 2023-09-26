
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSWorkItem = ExtTool.StaticServerObject("DHCWMR.SS.WorkItem");
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridWorkItem.on("rowclick",obj.gridWorkItem_rowclick,obj);
		obj.gridWorkItemStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.txtCode.setDisabled(false);
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Resume = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = obj.ClsSSWorkItem.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)==-100)
			{
				ExtTool.alert("错误提示","代码重复!");
				return;
			}else{
				ExtTool.alert("错误提示","更新数据错误!");
				return;
			}
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridWorkItem");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridWorkItem");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //fix Bug 6548 by pylian 2015-01-20 取消选中的记录，仍能被删除
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsSSWorkItem.DeleteById(objRec.get("ID"));
							if (parseInt(flg) < 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridWorkItem_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridWorkItem.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			obj.txtCode.setDisabled(true);
			Common_SetValue("txtCode",objRec.get("WCode"));
			Common_SetValue("txtDesc",objRec.get("WDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
		}
	};
}