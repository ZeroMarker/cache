
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsFPICDVersion = ExtTool.StaticServerObject("DHCWMR.FP.ICDVersion");
	
	obj.LoadEvent = function(args)
    {
		//obj.btnFind.on("click",obj.btnFind_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.GridICDVersion.on("rowclick",obj.GridICDVersion_rowclick,obj);
		
		obj.GridICDVersionStore.load({params : {start : 0,limit : 100}});
  	};
	
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtResume","");
		Ext.getCmp("txtCode").setDisabled(false);
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Resume = Common_GetValue('txtResume');
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var separate = "^";
		var inputStr = obj.RecRowID;
		inputStr = inputStr + separate + Code;
		inputStr = inputStr + separate + Desc;
		inputStr = inputStr + separate + Resume;
		
		var flg = obj.ClsFPICDVersion.Update(inputStr,separate);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg)==-100)
			{
				ExtTool.alert("错误提示","代码重复!Error=" + flg);
				return;
			}else{
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
				return;
			}
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("GridICDVersion");
	}
	
	obj.btnDelete_click = function()
	{
		var ID = obj.RecRowID;   //修改Bug 6548
		if (ID==""){
			ExtTool.alert("提示","请选中数据记录,再点击删除!");
			return;
		}
		var objGrid = Ext.getCmp("GridICDVersion");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('提示', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var ICDLibID = objRec.get("ID");
							if (ICDLibID == '') {
								ExtTool.alert("提示","无诊断库记录!");
								continue;
							}
							
							var flg = obj.ClsFPICDVersion.DeleteById(ICDLibID);
							if (parseInt(flg) < 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								//objGrid.getStore().remove(objRec);
								obj.GridICDVersionStore.load({params : {start : 0,limit : 100}});
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.GridICDVersion_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.GridICDVersion.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("txtCode",objRec.get("ICDCode"));
			Common_SetValue("txtDesc",objRec.get("ICDDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
			Ext.getCmp("txtCode").setDisabled(true);
		}
	}
}

