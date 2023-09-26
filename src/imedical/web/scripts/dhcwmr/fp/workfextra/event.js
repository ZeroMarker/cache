
function InitFPItemExtraWinEvent(obj) {
	obj.LoadEvent = function(args){
		obj.Ex_btnUpdate.on("click",obj.Ex_btnUpdate_click,obj);
		obj.Ex_btnDelete.on("click",obj.Ex_btnDelete_click,obj);
		obj.Ex_chkIsViewAll.on("check",obj.Ex_chkIsViewAll_check,obj);
		obj.Ex_gridWFEItemList.on("rowclick",obj.Ex_gridWFEItemList_rowclick,obj);
		obj.Ex_gridWFEItemListStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.Ex_chkIsViewAll_check = function() {
		obj.Ex_gridWFEItemListStore.removeAll();
		obj.Ex_gridWFEItemListStore.load({params : {start : 0,limit : 50}});
	}
	
	obj.ClearFormItem = function(){
		obj.EItemID = "";
		obj.FPIExtraID = "";
		Common_SetValue("Ex_txtEItemDesc","");
		Common_SetValue("Ex_cboDataItem","");
		Common_SetValue("Ex_txtIndex","");
		Common_SetValue("Ex_txtInitValue","");
		Common_SetValue("Ex_chkIsNeed",false);
		Common_SetValue("Ex_chkIsActive",false);
		Common_SetValue("Ex_txtResume","");
	}
	
	obj.Ex_btnUpdate_click = function(){
		var errinfo = "";
		var WFEItemID = obj.FPIExtraID;
		if (WFEItemID != ''){
			var arrItemID = WFEItemID.split("||");
			var FPItemID = arrItemID[0];
			var WFESubID = arrItemID[1];
		} else {
			var FPItemID = obj.FPItemID;
			var WFESubID = "";
		}
		var EIIndex   = Common_GetValue("Ex_txtIndex")
		
		var DataItem  = Common_GetValue("Ex_cboDataItem")
		/*********fix by liyi 2015-01-22删除已维附加项的数据项后跟新不会改变原数据项************/
		var DataItemRawValue=obj.Ex_cboDataItem.getRawValue();
		if (DataItemRawValue=="") DataItem="";
		/*********************/
		var InitValue = Common_GetValue("Ex_txtInitValue");
		var IsNeed    = Common_GetValue("Ex_chkIsNeed");
		var IsActive  = Common_GetValue("Ex_chkIsActive");
		var Resume    = Common_GetValue("Ex_txtResume");
		
		if (obj.EItemID == '') {
			errinfo = errinfo + "请选择对应附加项!<br>";
		}
		if (!EIIndex) {
			errinfo = errinfo + "显示顺序为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var inputStr = obj.FPItemID;
		inputStr = inputStr + CHR_1 + WFESubID;
		inputStr = inputStr + CHR_1 + obj.EItemID;
		inputStr = inputStr + CHR_1 + EIIndex;
		inputStr = inputStr + CHR_1 + DataItem;
		inputStr = inputStr + CHR_1 + InitValue;
		inputStr = inputStr + CHR_1 + (IsNeed ? '1' : '0');
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = ExtTool.RunServerMethod("DHCWMR.FP.WorkFExtra","Update",inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!");
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("Ex_gridWFEItemList");
	}
	
	obj.Ex_btnDelete_click = function(){
		var ID = obj.EItemID;   //修改Bug 6548
		if (ID==""){
			ExtTool.alert("提示","请选中数据记录,再点击删除!");
			return;
		}
		var objGrid = Ext.getCmp("Ex_gridWFEItemList");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var WFEItemID = objRec.get("WFEItemID");
							if (WFEItemID == '') continue;
							var flg = ExtTool.RunServerMethod("DHCWMR.FP.WorkFExtra","DeleteById",WFEItemID);
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
	
	obj.Ex_gridWFEItemList_rowclick = function(){
		var index=arguments[1];
		var objRec = obj.Ex_gridWFEItemList.getStore().getAt(index);
		if (objRec.get("EItemID") == obj.EItemID) {
			obj.ClearFormItem();
		} else {
			obj.EItemID = objRec.get("EItemID");
			obj.FPIExtraID = objRec.get("WFEItemID");
			Common_SetValue("Ex_txtEItemDesc",objRec.get("EItemDesc"));
			Common_SetValue("Ex_txtIndex",objRec.get("WFEIIndex"));
			Common_SetValue("Ex_txtInitValue",objRec.get("WFEIInitVal"));
			Common_SetValue("Ex_cboDataItem",objRec.get("WFEIDataID"),objRec.get("WFEIDataDesc"));
			Common_SetValue("Ex_chkIsActive",(objRec.get("WFEIIsActive")=='是'));
			Common_SetValue("Ex_chkIsNeed",(objRec.get("WFEIIsNeed")=='是'));
			Common_SetValue("Ex_txtResume",objRec.get("WFEIResume"));
		}
	};
}