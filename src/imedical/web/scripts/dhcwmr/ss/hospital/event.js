
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSHospital = ExtTool.StaticServerObject("DHCWMR.SS.Hospital");
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridHospital.on("rowclick",obj.gridHospital_rowclick,obj);
		obj.gridHospitalStore.load({});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("cboHospital","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Hospital = Common_GetValue("cboHospital");
		var Resume = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!Hospital) {
			errinfo = errinfo + "医院为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Hospital;
		inputStr = inputStr + CHR_1 + Resume;
		// 修复Bug 6510
		var selectObj = obj.gridHospital.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("SSHospCode") : "");
		var strCode = Code;
		if ((strCode != strCodeLast) && (obj.gridHospitalStore.findExact("SSHospCode", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}
		var flg = obj.ClsSSHospital.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!");
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridHospital");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridHospital");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //fix Bug 6548 by pylian 2015-01-20 取消选中的记录，记录仍能被删除
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsSSHospital.DeleteById(objRec.get("SSHospID"));
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
	
	obj.gridHospital_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridHospital.getStore().getAt(index);
		if (objRec.get("SSHospID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("SSHospID");
			Common_SetValue("txtCode",objRec.get("SSHospCode"));
			Common_SetValue("txtDesc",objRec.get("SSHospDesc"));
			Common_SetValue("cboHospital",objRec.get("CTHospID"),objRec.get("CTHospDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
		}
	};
}