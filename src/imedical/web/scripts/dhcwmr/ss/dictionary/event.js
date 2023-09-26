function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCWMR.SS.Dictionary");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.btnDicTpAdd.on("click",obj.btnDicTpAdd_click,obj);
		obj.btnDicTpEdit.on("click",obj.btnDicTpEdit_click,obj);
		obj.gridDicType.on("rowclick",obj.gridDicType_rowclick,obj);
		obj.gridDicItem.on("rowclick",obj.gridDicItem_rowclick,obj);
		obj.gridDicTypeStore.load({});
		
		obj.btnUpdate.setDisabled(true);
		obj.btnDelete.setDisabled(true);
		obj.btnDicTpEdit.setDisabled(true);
  	};
  	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("Code","");
		Common_SetValue("Desc","");
		Common_SetValue("cboHospId","");
		Common_SetValue("DicIsActive",false);
		Common_SetValue("DicResume","");
	}
	
	obj.btnDicTpAdd_click = function(){
		 var objWinEdit = new InitWinEdit();
		 objWinEdit.WinEdit.show();
	}
	
	obj.btnDicTpEdit_click = function(){
		var selectObj = obj.gridDicType.getSelectionModel().getSelected();
		if (selectObj){
			var objWinEdit = new InitWinEdit(selectObj);
			objWinEdit.WinEdit.show();
		}else{
			ExtTool.alert("提示","请先选中一行!");
		}
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("Code");
		var Desc = Common_GetValue("Desc");
		var HospId = Common_GetValue("cboHospId");
		var IsActive = Common_GetValue("DicIsActive");
		var Resume = Common_GetValue("DicResume");
		
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
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + obj.DicType;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + HospId;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');	
		inputStr = inputStr + CHR_1 + Resume;
		
		var selectObj = obj.gridDicItem.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("DicsCode") : "");
		var strCode = Code;
		if ((strCode != strCodeLast) && (obj.gridDicItemStore.findExact("DicsCode", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}
		var flg = obj.ClsSSDictionary.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		obj.ClearFormItem();
		Common_LoadCurrPage("gridDicItem");
	}
	//数据项类型删除
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridDicItem");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //fix Bug 6548 by pylian 2015-01-20 取消选中的记录，记录仍能被删除
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							
							var flg = obj.ClsSSDictionary.DeleteById(objRec.get("RowID"));
							if (parseInt(flg) < 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								//objGrid.getStore().remove(objRec);
								Common_LoadCurrPage("gridDicItem");       //为了刷新页码
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridDicType_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridDicType.getStore().getAt(index);
		obj.DicType = objRec.get("DicCode"); 
		obj.ClearFormItem();
		//Common_LoadCurrPage("gridDicItem");
		obj.gridDicItemStore.load({params:{start:0,limit:30}}); //update by pylian 20150616 108584 基础字典-第一页显示所有数据（多余30条数据），翻页后第一页只显示30条数据
		//obj.gridDicItemStore.load({});    // fix Bug 6568 by pylian 2015-01-21 一个页签翻页后，打开另一个页签显示的不是首页而是前一个页签翻到的页码
		obj.btnUpdate.setDisabled(false);
		obj.btnDelete.setDisabled(false);
		obj.btnDicTpEdit.setDisabled(false);
	}
	obj.gridDicItem_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridDicItem.getStore().getAt(index);
		if (objRec.get("RowID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("RowID");
			Common_SetValue("Code",objRec.get("DicsCode"));
			Common_SetValue("Desc",objRec.get("DicsDesc"));
			Common_SetValue("cboHospId",objRec.get("HospsDr"),objRec.get("HospsDesc")); //fix Bug 6520 by pylian 2015-01-20 选择维护了医院的记录，点击【保存】，保存后医院为空
			Common_SetValue("DicIsActive",objRec.get("aIsActive")=='是');
			Common_SetValue("DicResume",objRec.get("DicResume"));
		}
	}
}
function InitWinEditEvent(obj) {
	
	var objDictionary = ExtTool.StaticServerObject("DHCWMR.SS.Dictionary");
  	var parent=objControlArry['Viewport1'];	
	obj.LoadEvent = function()
	{
		if (obj.objDic){
			obj.DicID = obj.objDic.get("DicRowID");
			obj.DicCode.setValue(obj.objDic.get("DicCode"));
			if (obj.DicCode.setValue(obj.objDic.get("DicCode")))
			{
				obj.DicCode.setDisabled(true);
			}
			obj.DicDesc.setValue(obj.objDic.get("DicDesc"));
			obj.IsActive.setValue(obj.objDic.get("IsActive")=='是');
			obj.Resume.setValue(obj.objDic.get("Resume"));
			obj.DicCode.setDisabled(true);
		}
		//事件处理代码
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnCancel.on("click", obj.btnCancel_click, obj);
	};
	
	obj.btnSave_click = function()
	{
		var CHR_1=String.fromCharCode(1);
	    var IsActive = Common_GetValue("IsActive");
	    var Resume = Common_GetValue("Resume");
	    
		if(obj.DicCode.getValue()=="")
		{
			ExtTool.alert("提示","代码不能为空!");
			return;			
		}
		if(obj.DicDesc.getValue()=="")
		{
			ExtTool.alert("提示","描述不能为空!");
			return;
		}
        var CHR_1=String.fromCharCode(1);

		var inputStr = obj.DicID;
		
		inputStr = inputStr + CHR_1 + "SYS";
		inputStr = inputStr + CHR_1 + obj.DicCode.getValue();
		inputStr = inputStr + CHR_1 + obj.DicDesc.getValue();
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume
		
		var flg = objDictionary.Update(inputStr,CHR_1);
	
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据代码重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		obj.WinEdit.close();
		Common_LoadCurrPage("gridDicType");
		Common_LoadCurrPage("gridDicItem");
	};
	obj.btnCancel_click = function()
	{
		obj.WinEdit.close();
		parent.gridDicTypeStore.load({});  // modify by pylian  2015-01-21 修改F12报错
	};
}
