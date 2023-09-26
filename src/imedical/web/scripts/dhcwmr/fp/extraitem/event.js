
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args){
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridExtraItem.on("rowclick",obj.gridExtraItem_rowclick,obj);
		obj.gridExtraItemStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function(){
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("cboType","","");
		Common_SetValue("cboDicCode","","");
		Common_SetValue("txtResume","");
		Common_SetDisabled("txtCode",false);
	}
	
	obj.btnUpdate_click = function(){
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var TypeID = Common_GetValue("cboType");
		var TypeDesc = Common_GetText("cboType");
		var DicID = Common_GetValue("cboDicCode");
		var Resume = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (!TypeID) {
			errinfo = errinfo + "数据类型为空!<br>";
		} else {
			if ((TypeDesc == '字典')&&(!DicID)){
				errinfo = errinfo + "字典为空!<br>";
			}
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + TypeID;
		inputStr = inputStr + CHR_1 + DicID;
		inputStr = inputStr + CHR_1 + Resume;
		var flg = ExtTool.RunServerMethod("DHCWMR.FP.ExtraItem","Update",inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!");
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridExtraItem");
	}
	
	obj.btnDelete_click = function(){
		var ID = obj.RecRowID;   //fix Bug 6548 by pylian 2015-01-20 取消选中的记录，记录仍能被删除
		if (ID==""){
			ExtTool.alert("提示","请选中数据记录,再点击删除!");
			return;
		}
		var objGrid = Ext.getCmp("gridExtraItem");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var EItemID = objRec.get("ItemID");
							var flg = ExtTool.RunServerMethod("DHCWMR.FP.ExtraItem","DeleteById",EItemID);
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
	
	obj.gridExtraItem_rowclick = function(){
		var index=arguments[1];
		var objRec = obj.gridExtraItem.getStore().getAt(index);
		if (objRec.get("ItemID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ItemID");
			Common_SetValue("txtCode",objRec.get("ItemCode"));
			Common_SetValue("txtDesc",objRec.get("ItemDesc"));
			Common_SetValue("cboDicCode",objRec.get("DicID"),objRec.get("DicDesc"));
			Common_SetValue("cboType",(objRec.get("TypeID")),objRec.get("TypeDesc"));
			Common_SetValue("txtResume",objRec.get("Resume")); //update by pylian 修改编目附加项选中一条记录“备注”不显示问题
			Common_SetDisabled("txtCode",true);
		}
	};
}