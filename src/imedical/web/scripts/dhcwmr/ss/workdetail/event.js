
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSWorkDetail = ExtTool.StaticServerObject("DHCWMR.SS.WorkDetail");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridWorkDetail.on("rowclick",obj.gridWorkDetail_rowclick,obj);
		obj.gridWorkDetailStore.load({params : {start : 0,limit : 50}});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("cboType","");
		Common_SetValue("cboDicCode","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var Type = Common_GetValue("cboType");
		var DicCode = Common_GetValue("cboDicCode");
		var Resume = Common_GetValue("txtResume");
		
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!Type) {
			errinfo = errinfo + "类型为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Type;
		inputStr = inputStr + CHR_1 + DicCode;
		inputStr = inputStr + CHR_1 + Resume;
		
		var flg = obj.ClsSSWorkDetail.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!");
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridWorkDetail");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridWorkDetail");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if((arrRec.length>0) && (obj.RecRowID!= "")){  //修改Bug 6548
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsSSWorkDetail.DeleteById(objRec.get("ID"));
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
	
	obj.gridWorkDetail_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridWorkDetail.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ID");
			Common_SetValue("txtCode",objRec.get("WDetailCode"));
			Common_SetValue("txtDesc",objRec.get("WDetailDesc"));
			Common_SetValue("cboDicCode",objRec.get("DicID"),objRec.get("DicDesc"));
			Common_SetValue("cboType",objRec.get("TypeID"),objRec.get("TypeDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
		}
	};
}