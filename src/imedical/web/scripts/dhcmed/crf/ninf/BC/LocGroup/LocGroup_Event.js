
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsBCLocGroup = ExtTool.StaticServerObject("DHCMed.NINF.BC.LocGroup");
	
	obj.LoadEvent = function(args)
    {
		obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.GridLocGroup.on("rowclick",obj.GridLocGroup_rowclick,obj);
		obj.chkDisplayAll.on("check",obj.chkDisplayAll_check,obj);
		
		obj.GridLocGroupStore.load({params : {start : 0,limit : 100}});
  	};
	
	obj.btnFind_click = function()
	{
		obj.GridLocGroupStore.removeAll();
		obj.GridLocGroupStore.load({params : {start : 0,limit : 100}});
		obj.ClearFormItem();
	}
	
	obj.chkDisplayAll_check = function()
	{
		obj.GridLocGroupStore.removeAll();
		obj.GridLocGroupStore.load({params : {start : 0,limit : 25}});   //update by likai for bug:1551 显示全部记录只显示1-25
		obj.ClearFormItem();
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtDeptDesc","");
		Common_SetValue("txtLocGrpDesc","");
		Common_SetValue("chkICUFlag",false);
		Common_SetValue("chkOperFlag",false);
		
		obj.btnUpdate.setDisabled(true);
		obj.btnDelete.setDisabled(true);
	}
	
	obj.btnUpdate_click = function()
	{
		var arrRec = obj.GridLocGroup.getSelectionModel().getSelections();
		if (arrRec.length<1) return;
		var objRec = arrRec[0];
		
		var errinfo = "";
		var LocGroup = Common_GetValue("txtLocGrpDesc");
		var ICUFlag = Common_GetValue("chkICUFlag");
		var OperFlag = Common_GetValue("chkOperFlag");
		if (!LocGroup) {
			errinfo = errinfo + "科室组为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = objRec.get('LocGrpID');
		inputStr = inputStr + CHR_1 + objRec.get('DeptCode');
		inputStr = inputStr + CHR_1 + objRec.get('DeptDesc');
		inputStr = inputStr + CHR_1 + objRec.get('HospCode');
		inputStr = inputStr + CHR_1 + objRec.get('HospDesc');
		inputStr = inputStr + CHR_1 + objRec.get('LocType');
		inputStr = inputStr + CHR_1 + LocGroup;
		inputStr = inputStr + CHR_1 + (ICUFlag ? '1' : '0');
		inputStr = inputStr + CHR_1 + (OperFlag ? '1' : '0');
		
		var flg = obj.ClsBCLocGroup.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("GridLocGroup");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("GridLocGroup");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('提示', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var LocGrpID = objRec.get("LocGrpID");
							if (LocGrpID == '') {
								ExtTool.alert("提示","无科室组记录!");
								continue;
							}
							
							var flg = obj.ClsBCLocGroup.DeleteById(LocGrpID);
							obj.btnFind_click(); //Modified By LiYang 2014-07-05
							/*
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
							*/
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.GridLocGroup_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.GridLocGroup.getStore().getAt(index);
		if (objRec.get("DeptCode") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("DeptCode");
			Common_SetValue("txtDeptDesc",objRec.get("DeptDesc"));
			Common_SetValue("txtLocGrpDesc",objRec.get("LocGroup"));
			Common_SetValue("chkICUFlag",(objRec.get("ICUFlag")=='1'));
			Common_SetValue("chkOperFlag",(objRec.get("OperFlag")=='1'));
			
			obj.btnUpdate.setDisabled(false);
			obj.btnDelete.setDisabled(false);
		}
	}
}

