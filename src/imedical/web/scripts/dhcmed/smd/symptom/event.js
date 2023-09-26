
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridMentalSym.on("rowclick",obj.gridMentalSym_rowclick,obj);
		obj.gridMentalSymStore.load({params:{start:0,limit:50}}); //update by pylian 20150616 110380 修改精神症状字典-第一页显示所有数据，翻页后每页显示50条数据
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("cboMsCate","");
		Common_SetValue("IsActive",false);
		Common_SetValue("txtResume","");
	}
	obj.btnQuery_click  = function()
	{
		//Common_LoadCurrPage("gridMentalSym");
		obj.gridMentalSymStore.load({params:{start:0,limit:50}}); //update by pylian 20150616 110379 修改精神症状字典-翻页后，查询不自动显示第一页数据 
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code 	  = Common_GetValue("txtCode");
		var Desc 	  = Common_GetValue("txtDesc");
		var cboMsCate = Common_GetValue("cboMsCate");
		var IsActive  = Common_GetValue("IsActive");
		var Resume    = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!cboMsCate) {
			errinfo = errinfo + "症状类型为空!<br>";
		}
		
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + cboMsCate;
		inputStr = inputStr + CHR_1 + (IsActive ? "1" : "0");
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = ExtTool.RunServerMethod("DHCMed.SMD.Symptom","Update",inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			//update by pylian 20150616 110374 修改精神症状字典-代码重复报错“SyntaxError: 无效字符”  
			if (parseInt(flg) ==-2)
			{
				ExtTool.alert("错误提示","代码重复!");
				return;
			}else{
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
				return;
			}
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridMentalSym");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridMentalSym");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = ExtTool.RunServerMethod("DHCMed.SMD.Symptom","DeleteById",objRec.get("RowID"));
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
	
	obj.gridMentalSym_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridMentalSym.getStore().getAt(index);
		if (objRec.get("RowID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("RowID");
			Common_SetValue("txtCode",objRec.get("Code"));
			Common_SetValue("txtDesc",objRec.get("Desc"));
			Common_SetValue("cboMsCate",objRec.get("CateID"),objRec.get("CateDesc"));
			Common_SetValue("IsActive",objRec.get("IsActive")=='是');
			Common_SetValue("txtResume",objRec.get("Resume"));
		}
	};
}